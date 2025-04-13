console.log("scripts.js loaded");
logAction("scripts.js loaded");

const CONFIG_PATH = "/storage/emulated/0/tuningDIY.txt";
const ACTION_PATH = "/data/adb/modules/sv_sndasphere/action.sh";
const LOG_PATH = "/data/adb/modules/sv_sndasphere/actiondebug.txt";

let customValues = '200,32568,15164,8090,1,2,3,1';
let scustomValues = '103,32568,11164,5090,0,3,3,3';
let actionRunning = false;
let translations = { en: { yes: "YES", no: "NO", on: "ON", off: "OFF", numerals: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] } };

const defaultValues = {
    headphonetuning: 'YES',
    hieq: 'B',
    hieqstr: '6',
    hrenderbass: 'VB',
    hbassboost: '6',
    hbasscutoff: '90',
    hbasswidth: '32',
    hbassharmtype: '2',
    hbassharmboost: '6',
    hbasslingain: '7',
    hvolboost: '0',
    hde: '0',
    hdea: '6',
    hded: '0',
    hvirtdist: '40',
    hsurboost: '3',
    hadvirtangle: '90',
    hvirtmod: '2',
    hadvirtrend: '200,32568,15164,8090,1,2,3,1',
    hleveler: 'OFF',
    hlevstr: '3',
    hlevamount: '0',
    hlevtargetin: '6',
    hlevtargetout: '6',
    hregoverdrive: '8',
    htimbre: '2',
    speakertuning: 'YES',
    sieq: 'B',
    sieqstr: '6',
    srenderbass: 'VB',
    sbassboost: '6',
    sbassharmtype: '3',
    sbassharmboost: '3',
    sbasslingain: '5',
    svolboost: '0',
    sde: '0',
    sdea: '6',
    sded: '0',
    ssurboost: '3',
    svirtmod: '2',
    sadvirtrend: '103,32568,11164,5090,0,3,3,3',
    sleveler: 'OFF',
    slevstr: '3',
    slevamount: '0',
    slevtargetin: '6',
    slevtargetout: '6',
    stimbre: '2'
};

function logAction(message) {
    const actionLog = document.getElementById('actionLog');
    if (!actionLog) return;
    const timestamp = new Date().toLocaleTimeString();
    actionLog.textContent += `[${timestamp}] ${message}\n`;
    actionLog.scrollTop = actionLog.scrollHeight;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function execCommand(command) {
    const callbackName = `exec_callback_${Date.now()}`;
    return new Promise((resolve, reject) => {
        window[callbackName] = (errno, stdout, stderr) => {
            delete window[callbackName];
            if (errno === 0) resolve(stdout);
            else reject(stderr);
        };
        try {
            ksu.exec(command, "{}", callbackName);
        } catch (error) {
            reject(`KernelSU exec error: ${error}`);
        }
    });
}

async function loadTranslations() {
    try {
        const response = await fetch('translations.json');
        if (!response.ok) throw new Error('Failed to load translations');
        translations = await response.json();
        const lang = document.getElementById('languageSelect')?.value || 'en';
        logAction(translations[lang]['translations_loaded']);
        return translations;
    } catch (error) {
        logAction(`Error loading translations: ${error.message}`);
        console.error(error);
        translations = {
            en: {
                language_name: "English",
                yes: "YES",
                no: "NO",
                on: "ON",
                off: "OFF",
                numerals: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            }
        };
        return translations;
    }
}

function convertToLanguageNumerals(number, lang) {
    const numeralMap = translations[lang]?.numerals || ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];
    return String(number).split('').map(digit => numeralMap[parseInt(digit, 10)] || digit).join('');
}

function setupTuningToggle() {
    const headphoneToggle = document.getElementById('headphone-toggle');
    const speakerToggle = document.getElementById('speaker-toggle');
    const headphoneGroup = document.getElementById('headphone-group');
    const speakerGroup = document.getElementById('speaker-group');

    function showHeadphoneGroup() {
        headphoneToggle.classList.add('active');
        speakerToggle.classList.remove('active');
        headphoneGroup.classList.add('active');
        speakerGroup.classList.remove('active');
        headphoneGroup.querySelectorAll('.section').forEach(section => section.classList.add('visible'));
        speakerGroup.querySelectorAll('.section').forEach(section => section.classList.remove('visible'));
        const lang = document.getElementById('languageSelect').value;
        logAction(`${translations[lang]['switched_to']} ${translations[lang]['headphone_tuning']}`);
    }

    function showSpeakerGroup() {
        headphoneToggle.classList.remove('active');
        speakerToggle.classList.add('active');
        headphoneGroup.classList.remove('active');
        speakerGroup.classList.add('active');
        headphoneGroup.querySelectorAll('.section').forEach(section => section.classList.remove('visible'));
        speakerGroup.querySelectorAll('.section').forEach(section => section.classList.add('visible'));
        const lang = document.getElementById('languageSelect').value;
        logAction(`${translations[lang]['switched_to']} ${translations[lang]['speaker_tuning']}`);
    }

    headphoneToggle.addEventListener('click', showHeadphoneGroup);
    speakerToggle.addEventListener('click', showSpeakerGroup);
}

function switchLanguage(lang) {
    const elements = document.querySelectorAll('[data-lang-key]');
    elements.forEach(element => {
        const key = element.getAttribute('data-lang-key');
        if (translations[lang] && translations[lang][key]) {
            if (element.classList.contains('toggle-btn') && element.id !== 'hrenderbassToggle' && element.id !== 'srenderbassToggle') {
                const state = element.getAttribute('data-state') === 'true';
                element.textContent = state ? translations[lang][element.id === 'speakertuning' || element.id === 'headphonetuning' ? 'yes' : 'on'] : translations[lang][element.id === 'speakertuning' || element.id === 'headphonetuning' ? 'no' : 'off'];
            } else {
                element.textContent = translations[lang][key];
            }
        }
    });

    const options = document.querySelectorAll('select option[data-lang-key]');
    options.forEach(option => {
        const key = option.getAttribute('data-lang-key');
        if (translations[lang] && translations[lang][key]) {
            option.textContent = translations[lang][key];
        }
    });

    const sliders = document.querySelectorAll('input[type="range"]');
    sliders.forEach(slider => {
        const displayValue = convertToLanguageNumerals(slider.value, lang);
        document.getElementById(`${slider.id}-value`).textContent = displayValue;
    });
    document.title = translations[lang]['title'] || 'Dolby Tuning DIY';
    
    updateDefaultValuesDisplay();
    logAction(`${translations[lang]['language_switched_to']} ${translations[lang].language_name}`);
}

function setupLanguageSelector() {
    const langSelect = document.getElementById('languageSelect');
    if (!langSelect) return;

    langSelect.innerHTML = '';

    const availableLanguages = Object.keys(translations).map(code => ({
        code,
        key: code
    }));

    availableLanguages.forEach(lang => {
        const option = document.createElement('option');
        option.value = lang.code;
        option.textContent = translations[lang.code].language_name || lang.code;
        langSelect.appendChild(option);
    });

    langSelect.value = 'en';
    langSelect.addEventListener('change', (e) => switchLanguage(e.target.value));
}

function updateDefaultValuesDisplay() {
    const lang = document.getElementById('languageSelect').value;
    const bassHarmTypeMap = {
        '1': 'first_harmonic',
        '2': 'more_harmonics',
        '3': 'boosted_harmonics'
    };
    const virtModMap = {
        '1': 'center_oriented',
        '2': 'expanded'
    };
    const dialogEnhancerMap = {
        '0': 'off',
        '1': 'movie_profile_only',
        '2': 'all_profiles'
    };
    const ieqMap = {
        'B': 'balanced',
        'D': 'detailed',
        'W': 'warm',
        'N': 'no_ieq'
    };
    const advVirtRendMap = {
        '103,32568,11164,5090,0,3,3,3': 'stock',
        '160,32767,14379,7090,2,2,3,1': 'option_1',
        '200,32767,16379,7090,3,3,3,1': 'option_2',
        '160,32767,16379,2065,0,3,3,0': 'motorola_spatializer',
        '103,32568,11164,5090,0,1,2,2': 'xiaomi_15_spatializer',
        '200,32568,15164,8090,1,2,2,1': 'favorite_1',
        '200,32568,15164,8090,1,3,3,1': 'favorite_2',
        '200,32568,15164,8090,1,2,3,1': 'favorite_3'
    };
    const timbreMap = {
        '1': 'level_1',
        '2': 'level_2',
        '3': 'level_3',
        '4': 'level_4'
    };
    
    for (const [key, value] of Object.entries(defaultValues)) {
        const defaultElement = document.getElementById(`${key.toLowerCase()}-default`);
        if (defaultElement) {
            if (key === 'hrenderbass' || key === 'srenderbass') {
                defaultElement.textContent = `(Default: ${value})`;
            } else if (key === 'hadvirtrend' || key === 'sadvirtrend') {
                const translatedKey = advVirtRendMap[value] || 'custom';
                const translatedValue = translations[lang][translatedKey] || value.split(',').map(val => convertToLanguageNumerals(val, lang)).join(',');
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else if (['headphonetuning', 'hleveler', 'speakertuning', 'sleveler'].includes(key)) {
                const translatedValue = translations[lang][value.toLowerCase()] || value;
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else if (key === 'hbassharmtype' || key === 'sbassharmtype') {
                const translatedValue = translations[lang][bassHarmTypeMap[value]] || value;
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else if (key === 'hvirtmod' || key === 'svirtmod') {
                const translatedValue = translations[lang][virtModMap[value]] || value;
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else if (key === 'hde' || key === 'sde') {
                const translatedValue = translations[lang][dialogEnhancerMap[value]] || value;
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else if (key === 'hieq' || key === 'sieq') {
                const translatedValue = translations[lang][ieqMap[value]] || value;
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else if (key === 'htimbre' || key === 'stimbre') {
                const translatedValue = translations[lang][timbreMap[value]] || value;
                defaultElement.textContent = `(Default: ${translatedValue})`;
            } else {
                const translatedValue = convertToLanguageNumerals(value, lang);
                defaultElement.textContent = `(Default: ${translatedValue})`;
            }
        }
    }
}

function setupSliders() {
    const sliders = document.querySelectorAll('input[type="range"]');
    sliders.forEach(slider => {
        slider.addEventListener('input', function() {
            const lang = document.getElementById('languageSelect').value;
            const displayValue = convertToLanguageNumerals(this.value, lang);
            document.getElementById(`${this.id}-value`).textContent = displayValue;
            updateOutput();
        });
    });
}

function toggleHarmonicsVisibility() {
    const bassToggle = document.getElementById('hrenderbassToggle');
    const hbassboostContainer = document.getElementById('hbassboostContainer');
    const hbasscutoffContainer = document.getElementById('hbasscutoffContainer');
    const hbasswidthContainer = document.getElementById('hbasswidthContainer');
    const hbassharmtypeContainer = document.getElementById('hbassharmtypeContainer');
    const hbassharmboostContainer = document.getElementById('hbassharmboostContainer');
    const hbasslingainContainer = document.getElementById('hbasslingainContainer');

    if (!bassToggle || !hbassboostContainer || !hbasscutoffContainer || !hbasswidthContainer || !hbassharmtypeContainer || !hbassharmboostContainer || !hbasslingainContainer) return;

    console.log("HRENDERBASS data-state:", bassToggle.getAttribute('data-state')); // Debug
    const isVB = bassToggle.getAttribute('data-state') === 'false';
    hbassboostContainer.style.display = isVB ? 'none' : 'block';
    hbasscutoffContainer.style.display = isVB ? 'none' : 'block';
    hbasswidthContainer.style.display = isVB ? 'none' : 'block';
    hbassharmtypeContainer.style.display = isVB ? 'block' : 'none';
    hbassharmboostContainer.style.display = isVB ? 'block' : 'none';
    hbasslingainContainer.style.display = isVB ? 'block' : 'none';
    const lang = document.getElementById('languageSelect').value;
}

function toggleSpeakerHarmonicsVisibility() {
    const bassToggle = document.getElementById('srenderbassToggle');
    const sbassboostContainer = document.getElementById('sbassboostContainer');
    const sbassharmtypeContainer = document.getElementById('sbassharmtypeContainer');
    const sbassharmboostContainer = document.getElementById('sbassharmboostContainer');
    const sbasslingainContainer = document.getElementById('sbasslingainContainer');

    if (!bassToggle || !sbassboostContainer || !sbassharmtypeContainer || !sbassharmboostContainer || !sbasslingainContainer) return;

    const isVB = bassToggle.getAttribute('data-state') === 'false'; // VB when false, BE when true
    console.log(`toggleSpeakerHarmonicsVisibility: data-state=${bassToggle.getAttribute('data-state')}, isVB=${isVB}`);
    sbassboostContainer.style.display = isVB ? 'none' : 'block';
    sbassharmtypeContainer.style.display = isVB ? 'block' : 'none';
    sbassharmboostContainer.style.display = isVB ? 'block' : 'none';
    sbasslingainContainer.style.display = isVB ? 'block' : 'none';

    const lang = document.getElementById('languageSelect').value;
}

function setupToggles() {
    const toggles = document.querySelectorAll('.toggle-btn');
    toggles.forEach(toggle => {
        toggle.addEventListener('click', function() {
            const currentState = this.getAttribute('data-state') === 'true';
            this.setAttribute('data-state', !currentState);
            const lang = document.getElementById('languageSelect')?.value || 'en';

            if (this.id === 'hrenderbassToggle') {
                this.textContent = !currentState ? 'BE' : 'VB';
                toggleHarmonicsVisibility();
            } else if (this.id === 'srenderbassToggle') {
                this.textContent = !currentState ? 'BE' : 'VB';
                toggleSpeakerHarmonicsVisibility();
            } else {
                const yesText = translations[lang]?.[this.id === 'speakertuning' || this.id === 'headphonetuning' ? 'yes' : 'on'] || (this.id === 'speakertuning' || this.id === 'headphonetuning' ? 'YES' : 'ON');
                const noText = translations[lang]?.[this.id === 'speakertuning' || this.id === 'headphonetuning' ? 'no' : 'off'] || (this.id === 'speakertuning' || this.id === 'headphonetuning' ? 'NO' : 'OFF');
                this.textContent = !currentState ? yesText : noText;
                this.classList.toggle('active');
            }
            updateOutput();
            updateDefaultValuesDisplay();
        });
    });
}

function setupSelects() {
    const selects = document.querySelectorAll('select');
    selects.forEach(select => {
        select.addEventListener('change', () => {
            if (select.id === 'hadvirtrend') {
                checkCustom(select, 'customInput');
            } else if (select.id === 'sadvirtrend') {
                checkCustom(select, 'scustomInput');
            } else {
                updateOutput();
            }
            updateDefaultValuesDisplay();
        });
    });
}

function updateRendererValues() {
    const select = document.getElementById('hadvirtrend');
    const display = document.getElementById('hadvirtrend-values');
    if (!select || !display) return;
    let values = select.value;
    const lang = document.getElementById('languageSelect').value;

    if (select.value === 'custom') {
        values = customValues;
        display.style.display = 'none';
    } else {
        display.style.display = 'block';
    }
    display.textContent = `Values: ${values.split(',').map(val => convertToLanguageNumerals(val, lang)).join(',')}`;
}

function updateSpeakerRendererValues() {
    const select = document.getElementById('sadvirtrend');
    const display = document.getElementById('sadvirtrend-values');
    if (!select || !display) return;
    let values = select.value;
    const lang = document.getElementById('languageSelect').value;

    if (select.value === 'custom') {
        values = scustomValues;
        display.style.display = 'none';
    } else {
        display.style.display = 'block';
    }
    display.textContent = `Values: ${values.split(',').map(val => convertToLanguageNumerals(val, lang)).join(',')}`;
}

const idMapping = {
    'HRENDERBASS': 'hrenderbassToggle',
    'SRENDERBASS': 'srenderbassToggle',
    'HBASSBOOST': 'hbassboost',
    // Add other mappings as needed
};

function parseConfig(content) {
    const lines = content.split('\n');
    const lang = document.getElementById('languageSelect').value;

    // Predefiniowane opcje dla HADVIRTREND i SADVIRTREND
    const advVirtRendOptions = [
        '103,32568,11164,5090,0,3,3,3',
        '160,32767,14379,7090,2,2,3,1',
        '200,32767,16379,7090,3,3,3,1',
        '160,32767,16379,2065,0,3,3,0',
        '103,32568,11164,5090,0,1,2,2',
        '200,32568,15164,8090,1,2,2,1',
        '200,32568,15164,8090,1,3,3,1',
        '200,32568,15164,8090,1,2,3,1'
    ];

    lines.forEach(line => {
        if (!line.trim() || line.startsWith('#') || line.startsWith('---') || line.startsWith('V=')) {
            return; // Skip this line
        }

        const match = line.match(/^([A-Z]+)=(.+)$/);
        if (match) {
            const [_, key, value] = match;
            let elementId = key.toLowerCase();
            if (key === 'HRENDERBASS' || key === 'SRENDERBASS') {
                elementId += 'Toggle';
            }
            const element = document.getElementById(elementId);

            if (element) {
                if (key === 'HRENDERBASS' || key === 'SRENDERBASS') {
                    const isBE = value.trim() === 'BE';
                    element.setAttribute('data-state', isBE ? 'true' : 'false');
                    element.textContent = isBE ? 'BE' : 'VB';
                } else if (element.type === 'range') {
                    element.value = value;
                    document.getElementById(`${key.toLowerCase()}-value`).textContent = convertToLanguageNumerals(value, lang);
                } else if (element.tagName === 'SELECT') {
                    if (key === 'HADVIRTREND' || key === 'SADVIRTREND') {
                        if (advVirtRendOptions.includes(value)) {
                            element.value = value;
                        } else {
                            element.value = 'custom';
                            if (key === 'HADVIRTREND') {
                                customValues = value;
                                const customInput = document.getElementById('customInput');
                                customInput.classList.add('visible');
                                const customValuesArray = value.split(',');
                                for (let i = 1; i <= 8; i++) {
                                    const input = document.getElementById(`val${i}`);
                                    if (input) {
                                        input.value = convertToLanguageNumerals(customValuesArray[i - 1] || '', lang);
                                        input.dataset.userEdited = 'true'; // Oznacz jako edytowane, aby zachować przy przełączaniu
                                    }
                                }
                            } else if (key === 'SADVIRTREND') {
                                scustomValues = value;
                                const scustomInput = document.getElementById('scustomInput');
                                scustomInput.classList.add('visible');
                                const scustomValuesArray = value.split(',');
                                for (let i = 1; i <= 8; i++) {
                                    const input = document.getElementById(`sval${i}`);
                                    if (input) {
                                        input.value = convertToLanguageNumerals(scustomValuesArray[i - 1] || '', lang);
                                        input.dataset.userEdited = 'true'; // Oznacz jako edytowane
                                    }
                                }
                            }
                        }
                    } else {
                        element.value = value;
                    }
                } else if (element.classList.contains('toggle-btn')) {
                    const isOn = value === 'ON' || value === 'YES';
                    element.setAttribute('data-state', isOn);
                    const yesText = translations[lang]?.[key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'yes' : 'on'] || (key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'YES' : 'ON');
                    const noText = translations[lang]?.[key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'no' : 'off'] || (key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'NO' : 'OFF');
                    element.textContent = isOn ? yesText : noText;
                    element.classList.toggle('active', isOn);
                }
            } else {
                logAction(`Element not found for key: ${key} (ID: ${elementId})`);
            }
        }
    });

    toggleHarmonicsVisibility();
    toggleSpeakerHarmonicsVisibility();
    updateRendererValues();
    updateSpeakerRendererValues();
    checkCustom(document.getElementById('hadvirtrend'), 'customInput');
    checkCustom(document.getElementById('sadvirtrend'), 'scustomInput');
    updateDefaultValuesDisplay();
    updateOutput();
}

function checkCustom(selectElement, inputId) {
    if (!selectElement) return;
    const customInput = document.getElementById(inputId);
    const isCustom = selectElement.value === 'custom';
    const lang = document.getElementById('languageSelect').value;
    const advVirtRendOptions = [
        '103,32568,11164,5090,0,3,3,3',
        '160,32767,14379,7090,2,2,3,1',
        '200,32767,16379,7090,3,3,3,1',
        '160,32767,16379,2065,0,3,3,0',
        '103,32568,11164,5090,0,1,2,2',
        '200,32568,15164,8090,1,2,2,1',
        '200,32568,15164,8090,1,3,3,1',
        '200,32568,15164,8090,1,2,3,1'
    ];

    if (isCustom) {
        customInput.classList.add('visible');
        customInput.style.visibility = 'visible';
        customInput.style.display = 'block';

        const inputs = document.querySelectorAll(`#${inputId} input`);
        const previousValue = selectElement.dataset.previousValue || '';
    } else {
        const currentValues = Array.from(document.querySelectorAll(`#${inputId} input`))
            .map(input => input.value === '' ? '' : input.value.split('').map(d => {
                const bengaliIndex = translations['bn']?.numerals?.indexOf(d) || -1;
                return bengaliIndex !== -1 ? bengaliIndex : (parseInt(d, 10) || '');
            }).join(''))
            .join(',');
        customInput.dataset.lastValues = currentValues;
        customInput.classList.remove('visible');
        customInput.style.visibility = 'hidden';
        customInput.style.display = 'none';
    }

    selectElement.dataset.previousValue = selectElement.value; // Zapisz poprzednią wartość

    if (inputId === 'customInput') {
        updateRendererValues();
    } else if (inputId === 'scustomInput') {
        updateSpeakerRendererValues();
    }
    updateOutput();
}

function validateInput(input, range, errorId) {
    const errorMessage = document.getElementById(errorId);
    let hasError = false;
    const rawValue = input.value.trim();
    let value = rawValue === '' ? '' : parseInt(rawValue, 10);

    if (rawValue !== '') {
        if (isNaN(value) || value < range.min || value > range.max) {
            value = Math.max(range.min, Math.min(range.max, isNaN(value) ? range.default : value));
            input.value = value;
            hasError = true;
        }
    }

    if (hasError) {
        errorMessage.textContent = `Value for ${input.id} corrected to fit range [${range.min}-${range.max}].`;
        errorMessage.style.display = 'block';
        setTimeout(() => { errorMessage.style.display = 'none'; }, 3000);
    } else {
        errorMessage.style.display = 'none';
    }

    return value === '' ? range.default : value;
}

function updateCustomValue(event, inputId, valuesVar) {
    if (event) event.stopPropagation();

    const ranges = [
        { id: inputId === 'customInput' ? 'val1' : 'sval1', min: 0, max: 255, default: 200 },
        { id: inputId === 'customInput' ? 'val2' : 'sval2', min: 16384, max: 32767, default: 32568 },
        { id: inputId === 'customInput' ? 'val3' : 'sval3', min: 8192, max: 16383, default: 15164 },
        { id: inputId === 'customInput' ? 'val4' : 'sval4', min: 0, max: 8191, default: 8090 },
        { id: inputId === 'customInput' ? 'val5' : 'sval5', min: 0, max: 3, default: 1 },
        { id: inputId === 'customInput' ? 'val6' : 'sval6', min: 0, max: 3, default: 2 },
        { id: inputId === 'customInput' ? 'val7' : 'sval7', min: 0, max: 3, default: 3 },
        { id: inputId === 'customInput' ? 'val8' : 'sval8', min: 0, max: 3, default: 1 }
    ];

    const lang = document.getElementById('languageSelect').value;
    const inputs = Array.from(document.querySelectorAll(`#${inputId} input`));
    const currentValues = (inputId === 'customInput' ? customValues : scustomValues).split(',');

    const updatedValues = ranges.map((range, index) => {
        const input = document.getElementById(range.id);
        if (!input) return currentValues[index] || range.default;

        const rawValue = input.value.replace(/[^0-9০-৯零一二三四五六七八九]/g, '');
        if (rawValue === '') {
            input.dataset.userEdited = 'false';
            return currentValues[index] || range.default;
        }

        if (event && event.type === 'input') {
            input.dataset.userEdited = 'true';
            return currentValues[index] || range.default;
        }

        if (event && event.type === 'change') {
            const arabicValue = rawValue.split('').map(d => {
                const bengaliIndex = translations['bn']?.numerals?.indexOf(d) || -1;
                const chineseIndex = translations['zh']?.numerals?.indexOf(d) || -1;
                if (bengaliIndex !== -1) return bengaliIndex;
                if (chineseIndex !== -1) return chineseIndex;
                return parseInt(d, 10);
            }).join('');
            const validatedValue = validateInput({ value: arabicValue, id: range.id }, range, inputId === 'customInput' ? 'errorMessage' : 'serrorMessage');
            input.value = convertToLanguageNumerals(validatedValue, lang);
            input.dataset.userEdited = 'true';
            return validatedValue;
        }

        return currentValues[index] || range.default;
    });

    if (event && event.type === 'change') {
        if (inputId === 'customInput') {
            customValues = updatedValues.join(',');
            logAction(`${translations[lang]['updated_headphone_custom_values_to']} ${customValues}`);
            const select = document.getElementById('hadvirtrend');
            if (select && select.value !== 'custom') {
                select.value = 'custom';
                select.dispatchEvent(new Event('change'));
            }
            updateRendererValues();
        } else if (inputId === 'scustomInput') {
            scustomValues = updatedValues.join(',');
            logAction(`${translations[lang]['updated_speaker_custom_values_to']} ${scustomValues}`);
            const select = document.getElementById('sadvirtrend');
            if (select && select.value !== 'custom') {
                select.value = 'custom';
                select.dispatchEvent(new Event('change'));
            }
            updateSpeakerRendererValues();
        }

        updateOutput();
        updateDefaultValuesDisplay();
    }
}

function updateOutput() {
    const hselect = document.getElementById('hadvirtrend');
    const hadvirtrendValue = hselect && hselect.value === 'custom' ? customValues : (hselect ? hselect.value : '200,32568,15164,8090,1,2,3,1');

    const sselect = document.getElementById('sadvirtrend');
    const sadvirtrendValue = sselect && sselect.value === 'custom' ? scustomValues : (sselect ? sselect.value : '103,32568,11164,5090,0,3,3,3');

    const hrenderbassToggle = document.getElementById('hrenderbassToggle');
    const hrenderbassValue = hrenderbassToggle && hrenderbassToggle.getAttribute('data-state') === 'true' ? 'BE' : 'VB';

    const srenderbassToggle = document.getElementById('srenderbassToggle');
    const srenderbassValue = srenderbassToggle && srenderbassToggle.getAttribute('data-state') === 'true' ? 'BE' : 'VB';

    const headphonetuningToggle = document.getElementById('headphonetuning');
    const headphonetuningValue = headphonetuningToggle && headphonetuningToggle.getAttribute('data-state') === 'true' ? 'YES' : 'NO';

    const speakertuningToggle = document.getElementById('speakertuning');
    const speakertuningValue = speakertuningToggle && speakertuningToggle.getAttribute('data-state') === 'true' ? 'YES' : 'NO';

    const hlevelerToggle = document.getElementById('hleveler');
    const hlevelerValue = hlevelerToggle && hlevelerToggle.getAttribute('data-state') === 'true' ? 'ON' : 'OFF';

    const slevelerToggle = document.getElementById('sleveler');
    const slevelerValue = slevelerToggle && slevelerToggle.getAttribute('data-state') === 'true' ? 'ON' : 'OFF';

    const config = `V=43
### Dolby tuning DIY
#Blank or wrong filled variable will cause setting default value

-----------------------------------
#########################
### HEADPHONE SECTION ###
#########################
-----------------------------------

# Do you want to modify your headphones experience?
# Values [YES or NO] (default YES)

HEADPHONETUNING=${headphonetuningValue}

-----------------------------------

# Which Intelligent EQ preset you want? 
# (values B - balanced, D - detailed, W - Warm, N - no IEQ)
# (default and stock: B)

HIEQ=${document.getElementById('hieq')?.value || 'B'}

-----------------------------------

# How strong Intelligent EQ should be? 
# Generally values:
# 1-3 is weak
# 4-6 is medium
# 7-10 is strong
# 10-15 is very strong
# 16-20 is extreme
# ** stock values differ, mostly 3-8 **
# values [1-20] (default: 6)

HIEQSTR=${document.getElementById('hieqstr')?.value || '6'}

-----------------------------------

# Bass enhancer (BE) or Virtual Bass (VB)?
# values [BE or VB] (default: Virtual Bass)
# If you will set Virtual Bass and your dolby will not support it
# Bass Enhancer will be used instead
# ** stock settings use Bass Enhancer **

HRENDERBASS=${hrenderbassValue}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# How strong Bass Enhancer boost you want?
# ** stock settings uses wide range, from 2 to 6 **
# values [0-25] (default: 6)

HBASSBOOST=${document.getElementById('hbassboost')?.value || '6'}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# Where bass enhancer should cut its boost?
# ** stock settings uses wide range **
# values [10-200] (default: 90)

HBASSCUTOFF=${document.getElementById('hbasscutoff')?.value || '90'}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# How broad Bass Enhancer boost you want around cutoff?
# ** stock settings mostly use ranges from 16 to 32 **
# values [1-128] (default: 32)

HBASSWIDTH=${document.getElementById('hbasswidth')?.value || '32'}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Value 1 will render bass like in 1.16 (only first harmonic)
#
# Value 2 will boost bass with more harmonics
#
# Value 3 will also boost bass with even more harmonics
#
# ** stock settings don't use Virtual bass **
# 
# Values [1-3] (default: 2)

HBASSHARMTYPE=${document.getElementById('hbassharmtype')?.value || '2'}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# How strong Bass Harmonics boost you want?
# ** stock settings don't use Virtual bass **
# values [0-15] (default: 6)

HBASSHARMBOOST=${document.getElementById('hbassharmboost')?.value || '6'}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Here you can set linear bass gain
# More = stronger bass and its harmonics
#
# ** stock settings don't use Virtual bass **
#
# Values [0-20] (default: 7)

HBASSLINGAIN=${document.getElementById('hbasslingain')?.value || '7'}

-----------------------------------
# Headphone Digital Volume booster
# How much in dB volume should be boosted?
# values [-15 to 15] (default and stock:0)

HVOLBOOST=${document.getElementById('hvolboost')?.value || '0'}

-----------------------------------

# Dialog Enhancer. Should be turned on? or off?
# Value of 0 will turn off Dialog Enhancer
# Value of 1 will turn on Dialog Enhancer only for Movie profile
# Value of 2 will turn on Dialog Enhancer for every profile
# ** stock values differ and depend on OEM, but mostly it's 1 **
# values [0-2] (default: 0)

HDE=${document.getElementById('hde')?.value || '0'}

-----------------------------------

# This setting is working only with enabled Dialog Enhancer
# How strong Dialog Enhancer should be?
# values [1-10] (default: 6)

HDEA=${document.getElementById('hdea')?.value || '6'}

-----------------------------------

# This setting is working only with enabled Dialog Enhancer
# How strong Dialog Enhancer ducking should be?
# (ducking will attenuate audio when dialogue appear)
# values [0-10] (default: 0)

HDED=${document.getElementById('hded')?.value || '0'}

-----------------------------------

# Virtualizer will be enabled in Movie preset 
# and disabled in Music preset
# This will set Virtualizer source distance 
# FOR SUPPORTED DOLBY
# ** stock value is mostly 4 but sometimes 12, 24 or 40 **
# values [4-100] (default: 40)

HVIRTDIST=${document.getElementById('hvirtdist')?.value || '40'}

-----------------------------------

# Surround boost
# 
# values [0-15] (default: 3)

HSURBOOST=${document.getElementById('hsurboost')?.value || '3'}

-----------------------------------

# Headphone Advanced left-right Angle
# How wide (left-right angle) Virtualizer effect you want? 
# FOR SUPPORTED DOLBY
# ** stock value is 45 **
# values [45-90] (default: 90)

HADVIRTANGLE=${document.getElementById('hadvirtangle')?.value || '90'}

-----------------------------------

# Which mode of Virtualizer effect you want?
# FOR SUPPORTED DOLBY
# Mode 1 means, Virtualizer is center oriented, soundscene is narrow.
# Mode 2 means, Virtualizer is much more expanded to sides.
# values [1 or 2] (default and stock: 2)

HVIRTMOD=${document.getElementById('hvirtmod')?.value || '2'}

-----------------------------------

# Hadphone Advanced Virtualizer Renderer
# FOR ADVANCED USERS ONLY!
# THIS SETTING HAVE HUGE IMPACT ON VIRTUALIZER SOUNDSTAGE RENDERING
# FOR SUPPORTED DOLBY
#
# STOCK values are: 103,32568,11164,5090,0,3,3,3
# Some good and possible options:
# 160,32767,14379,7090,2,2,3,1
# 160,32767,16379,2065,0,3,3,0 - motorola spatializer 
# 103,32568,11164,5090,0,1,2,2 - xiaomi 15 spatializer
# 200,32767,16379,7090,3,3,3,1
# 200,32568,15164,8090,1,2,2,1 (one of my favorite)
# 200,32568,15164,8090,1,3,3,1 (also one of my favorite)
# 200,32568,15164,8090,1,2,3,1 (one of my favorite and currently used)
# I encourage to experiment but be careful with modifying it ^^

HADVIRTREND=${hadvirtrendValue}

-----------------------------------

# Should Volume Leveler be turned on or off? 
# values [ON or OFF] (default and stock: OFF)

HLEVELER=${hlevelerValue}

-----------------------------------

# How strong volume boost with volume leveler should be? 
# HLEVELER must be turned ON if you want this feature
# IF HLEVELER is off, then no matter what value is here
# values [0-10] (default: 3)

HLEVSTR=${document.getElementById('hlevstr')?.value || '3'}

-----------------------------------

# This setting is working when Volume Leveler is enabled
# How fast should HLEVELER react?
# Value of 0 means no reaction speed adjustment
# values [0-10] (default: 0)

HLEVAMOUNT=${document.getElementById('hlevamount')?.value || '0'}

-----------------------------------

# Peak attenuation for Volume Leveler
# Higher values mean more attenuation of peaks
# values [1-10] (default: 6)

HLEVTARGETIN=${document.getElementById('hlevtargetin')?.value || '6'}

-----------------------------------

# Signal modification for Volume Leveler
# Adjusts the output signal strength
# values [1-10] (default: 6)

HLEVTARGETOUT=${document.getElementById('hlevtargetout')?.value || '6'}

-----------------------------------

# Timbre preservation level for headphone regulator
# Higher values preserve more of the original timbre
# values [1-4] (default: 2)

HTIMBRE=${document.getElementById('htimbre')?.value || '2'}

-----------------------------------

# Regulator overdrive for headphones
# Controls the intensity of the regulator effect
# values [0-10] (default: 8)

HREGOVERDRIVE=${document.getElementById('hregoverdrive')?.value || '8'}

-----------------------------------
#########################
### SPEAKER SECTION ###
#########################
-----------------------------------

# Do you want to modify your speakers experience?
# Values [YES or NO] (default YES)

SPEAKERTUNING=${speakertuningValue}

-----------------------------------

# Which Intelligent EQ preset you want for speakers? 
# (values B - balanced, D - detailed, W - Warm, N - no IEQ)
# (default and stock: B)

SIEQ=${document.getElementById('sieq')?.value || 'B'}

-----------------------------------

# How strong Intelligent EQ should be for speakers? 
# values [1-20] (default: 6)

SIEQSTR=${document.getElementById('sieqstr')?.value || '6'}

-----------------------------------

# Bass enhancer (BE) or Virtual Bass (VB) for speakers?
# values [BE or VB] (default: Virtual Bass)

SRENDERBASS=${srenderbassValue}

-----------------------------------

# This parameter works ONLY with Bass Enhancer for speakers
# How strong Bass Enhancer boost you want?
# values [0-15] (default: 6)

SBASSBOOST=${document.getElementById('sbassboost')?.value || '6'}

-----------------------------------

# This parameter works ONLY with Virtual Bass for speakers
# Harmonics type for speaker bass
# values [1-3] (default: 1)

SBASSHARMTYPE=${document.getElementById('sbassharmtype')?.value || '1'}

-----------------------------------

# This parameter works ONLY with Virtual Bass for speakers
# How strong Bass Harmonics boost you want?
# values [0-15] (default: 2)

SBASSHARMBOOST=${document.getElementById('sbassharmboost')?.value || '2'}

-----------------------------------

# This parameter works ONLY with Virtual Bass for speakers
# Linear bass gain for speakers
# values [0-20] (default: 12)

SBASSLINGAIN=${document.getElementById('sbasslingain')?.value || '12'}

-----------------------------------

# Speaker Digital Volume booster
# How much in dB volume should be boosted for speakers?
# values [-15 to 15] (default: 0)

SVOLBOOST=${document.getElementById('svolboost')?.value || '0'}

-----------------------------------

# Dialog Enhancer for speakers. Should be turned on or off?
# values [0-2] (default: 0)

SDE=${document.getElementById('sde')?.value || '0'}

-----------------------------------

# This setting works only with enabled Dialog Enhancer for speakers
# How strong Dialog Enhancer should be?
# values [1-10] (default: 6)

SDEA=${document.getElementById('sdea')?.value || '6'}

-----------------------------------

# This setting works only with enabled Dialog Enhancer for speakers
# How strong Dialog Enhancer ducking should be?
# values [0-10] (default: 0)

SDED=${document.getElementById('sded')?.value || '0'}

-----------------------------------

# Surround boost for speakers
# values [0-15] (default: 3)

SSURBOOST=${document.getElementById('ssurboost')?.value || '3'}

-----------------------------------

# Which mode of Virtualizer effect you want for speakers?
# values [1 or 2] (default: 2)

SVIRTMOD=${document.getElementById('svirtmod')?.value || '2'}

-----------------------------------

# Speaker Advanced Virtualizer Renderer
# FOR ADVANCED USERS ONLY!
# values as per headphone section

SADVIRTREND=${sadvirtrendValue}

-----------------------------------

# Should Volume Leveler be turned on or off for speakers? 
# values [ON or OFF] (default: OFF)

SLEVELER=${slevelerValue}

-----------------------------------

# How strong volume boost with volume leveler should be for speakers? 
# values [0-10] (default: 3)

SLEVSTR=${document.getElementById('slevstr')?.value || '3'}

-----------------------------------

# Reaction speed for speaker Volume Leveler
# values [0-10] (default: 0)

SLEVAMOUNT=${document.getElementById('slevamount')?.value || '0'}

-----------------------------------

# Peak attenuation for speaker Volume Leveler
# values [1-10] (default: 6)

SLEVTARGETIN=${document.getElementById('slevtargetin')?.value || '6'}

-----------------------------------

# Signal modification for speaker Volume Leveler
# values [1-10] (default: 6)

SLEVTARGETOUT=${document.getElementById('slevtargetout')?.value || '6'}

-----------------------------------

# Timbre preservation level for speaker regulator
# values [1-4] (default: 2)

STIMBRE=${document.getElementById('stimbre')?.value || '2'}
`;

    const output = document.getElementById('output');
    if (output) output.textContent = config;
}

async function loadConfig() {
    try {
        const content = await execCommand(`cat ${CONFIG_PATH}`);
        if (content) {
            parseConfig(content);
            updateOutput();

            // Show UI sections
            const actionLogSection = document.getElementById('action-log-section');
            const outputSection = document.getElementById('output-section');
            const tuningToggle = document.getElementById('tuning-toggle');
            const actionButtons = document.getElementById('actionButtons');
            const headphoneGroup = document.getElementById('headphone-group');

            if (actionLogSection) actionLogSection.classList.add('visible');
            if (outputSection) outputSection.classList.add('visible');
            if (tuningToggle) tuningToggle.classList.add('visible');
            if (actionButtons) actionButtons.classList.add('visible');
            if (headphoneGroup) {
                headphoneGroup.classList.add('active');
                headphoneGroup.querySelectorAll('.section').forEach(section => section.classList.add('visible'));
            }

            const lang = document.getElementById('languageSelect').value;
            logAction(translations[lang]['config_loaded']);
        }
    } catch (error) {
        const lang = document.getElementById('languageSelect').value;
        logAction(`${translations[lang]['error_loading_config']}: ${error}`);
    }
}

async function saveConfig() {
    try {
        const output = document.getElementById('output').textContent;
        await execCommand(`echo "${output}" > ${CONFIG_PATH}`);
        const lang = document.getElementById('languageSelect').value;
        logAction(translations[lang]['config_saved']);
    } catch (error) {
        const lang = document.getElementById('languageSelect').value;
        logAction(`${translations[lang]['error_saving_config']}: ${error}`);
    }
}

async function applyTuning() {
    if (actionRunning) {
        const lang = document.getElementById('languageSelect').value;
        logAction(translations[lang]['action_already_running'] || 'Action already running');
        return;
    }

    actionRunning = true;
    const lang = document.getElementById('languageSelect').value;
    try {
        // Save the config first
        await saveConfig();
        logAction(translations[lang]['applying_tuning']);
        logAction(translations[lang]['applying_tuning_time_warning']);

        // Wait briefly to ensure the config is written
        await sleep(100);

        // Execute the action.sh script and capture its output directly
        const scriptOutput = await execCommand(`su -c "sh ${ACTION_PATH}"`);
        await sleep(100); // Small delay to ensure execution completes

        // Process the script output
        if (scriptOutput && typeof scriptOutput === 'string') {
            const outputLines = scriptOutput.split('\n');
            outputLines.forEach(line => logAction(line));
        } else {
            console.log('Script output issue:', scriptOutput);
            logAction(translations[lang]['no_output'] || 'No output from script');
        }
    } catch (error) {
        console.error('Error in applyTuning:', error);
        logAction(`${translations[lang]['error_applying_tuning'] || 'Error applying tuning'}: ${error}`);
    } finally {
        actionRunning = false;
    }
}

function resetToDefault() {
    const lang = document.getElementById('languageSelect').value;

    for (const [key, value] of Object.entries(defaultValues)) {
        const element = document.getElementById(key.toLowerCase());
        if (element) {
            if (element.type === 'range') {
                element.value = value;
                document.getElementById(`${key.toLowerCase()}-value`).textContent = convertToLanguageNumerals(value, lang);
            } else if (element.tagName === 'SELECT') {
                element.value = value;
                if (key === 'HADVIRTREND') checkCustom(element, 'customInput');
                if (key === 'SADVIRTREND') checkCustom(element, 'scustomInput');
            } else if (element.classList.contains('toggle-btn')) {
                const isOn = value === 'ON' || value === 'YES';
                const isBE = value === 'BE';
                element.setAttribute('data-state', isOn || isBE);
                if (key === 'HRENDERBASS' || key === 'SRENDERBASS') {
                    element.textContent = isBE ? 'BE' : 'VB';
                } else {
                    element.textContent = isOn ? translations[lang][key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'yes' : 'on'] : translations[lang][key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'no' : 'off'];
                    element.classList.toggle('active', isOn);
                }
            }
        }
    }

    toggleHarmonicsVisibility();
    toggleSpeakerHarmonicsVisibility();
    updateRendererValues();
    updateSpeakerRendererValues();
    updateOutput();
    updateDefaultValuesDisplay();
    logAction(translations[lang]['reset_to_default']);
}

document.addEventListener('DOMContentLoaded', async () => {
    console.log("DOM fully loaded");
    logAction("DOM fully loaded");

    await loadTranslations();
    setupLanguageSelector();
    switchLanguage('en');

    setupTuningToggle();
    setupSliders();
    setupToggles();
    setupSelects();
    
    document.getElementById('loadConfig')?.addEventListener('click', loadConfig);
    document.getElementById('saveConfig')?.addEventListener('click', saveConfig);
    document.getElementById('applyTuning')?.addEventListener('click', applyTuning);
    document.getElementById('resetToDefault')?.addEventListener('click', resetToDefault);
    document.getElementById('hrenderbassToggle').setAttribute('data-state', defaultValues.hrenderbass === 'BE' ? 'true' : 'false');
    document.getElementById('hrenderbassToggle').textContent = defaultValues.hrenderbass;
    toggleHarmonicsVisibility();
    
    const customInputs = document.querySelectorAll('#customInput input, #scustomInput input');
    customInputs.forEach(input => {
        input.addEventListener('input', (e) => updateCustomValue(e, input.parentElement.id));
        input.addEventListener('change', (e) => updateCustomValue(e, input.parentElement.id));
    });
});