import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { debounce, actionLog } from '../shared/utils.js';
import { visibilityMap } from '../config/configmodel.js';
import { updateOutput } from '../view/renderer.js';

export const bassVisibility = (section, toggleId, featureKey = null) => {
    const toggle = state.domCache[toggleId];
    if (!toggle) {
        console.log(`toggleVisibility: Toggle ${toggleId} not found in domCache`);
        if (featureKey) {
        }
        return; 
    }
    const lang = state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en';
    const isSimpleMode = document.body.classList.contains('simple-mode');
    const isVB = isSimpleMode ? false : toggle.getAttribute('data-state') === 'false';
      for (const [key, { id, showWhen }] of Object.entries(visibilityMap[section])) {
        const container = state.domCache[id];
        if (container) {
            const isExpertOnly = container.classList.contains('expert-only');
            const shouldShow = showWhen.length === 1 ? showWhen(isSimpleMode) : showWhen(isVB, state.supportedFeatures);
            const displayValue = shouldShow && (!isSimpleMode || !isExpertOnly) ? 'block' : 'none';
            container.style.display = displayValue;
            container.style.removeProperty('display');
            container.style.display = displayValue;
            if (displayValue === 'block') {
                container.classList.add('visible');
                container.querySelectorAll('.slider-container').forEach(slider => {
                    slider.style.removeProperty('display');
                    slider.style.display = 'block';
                    const input = slider.querySelector('input[type="range"]');
                    if (input) {
                        input.style.removeProperty('display');
                        input.style.display = 'inline-block';
                    }
                });
            } else {
                container.classList.remove('visible');
                container.querySelectorAll('.slider-container').forEach(slider => {
                    slider.style.removeProperty('display');
                    slider.style.display = 'none';
                    const input = slider.querySelector('input[type="range"]');
                    if (input) {
                        input.style.removeProperty('display');
                        input.style.display = 'none';
                    }
                });
            }
            console.log(`Set ${id}.style.display to ${displayValue}, computed: ${window.getComputedStyle(container).display}, isExpertOnly=${isExpertOnly}, shouldShow=${shouldShow}, classList=${container.classList}`);
        }
    }
    const warning = state.domCache[section === 'headphone' ? 'vb-warning-headphone' : 'vb-warning-speaker'];
    if (warning) {
        if (!state.supportedFeatures.harm && !isSimpleMode) {
            warning.textContent = state.translations[lang]['vb_unsupported'] || 'Virtual Bass is unsupported, use Bass Enhancer';
            warning.style.display = 'inline';
            toggle.setAttribute('data-state', 'true');
            toggle.textContent = state.translations[lang]['bass_enhancer'];
            toggle.disabled = true;
            console.log(`Forced ${toggleId} to Bass Enhancer due to unsupported harm, data-state=${toggle.getAttribute('data-state')}`);
            ['bassboostContainer', 'basscutoffContainer', 'basswidthContainer'].forEach(key => {
                const container = state.domCache[section === 'headphone' ? `h${key}` : `s${key}`];
                if (container) {
                    container.style.removeProperty('display');
                    container.style.display = 'block';
                    container.classList.add('visible');
                    container.querySelectorAll('.slider-container').forEach(slider => {


                        slider.style.removeProperty('display');
                        slider.style.display = 'block';
                        const input = slider.querySelector('input[type="range"]');
                        if (input) {
                            input.style.removeProperty('display');
                            input.style.display = 'inline-block';
                            console.log(`Set ${input.id || 'slider-input'} to display: inline-block in ${container.id}`);
                        }
                    });
                }
            });
            ['bassharmtypeContainer', 'bassharmmixfreqminContainer', 'bassharmmixfreqmaxContainer', 'bassharmsrcfreqminContainer', 'bassharmsrcfreqmaxContainer', 'bassharmboostContainer', 'basslingainContainer'].forEach(key => {
                const container = state.domCache[section === 'headphone' ? `h${key}` : `s${key}`];
                if (container) {
                    container.style.removeProperty('display');
                    container.style.display = 'none';
                    container.classList.remove('visible');
                    container.querySelectorAll('.slider-container').forEach(slider => {
                        slider.style.removeProperty('display');
                        slider.style.display = 'none';
                        const input = slider.querySelector('input[type="range"]');
                        if (input) {
                            input.style.removeProperty('display');
                            input.style.display = 'none';
                            console.log(`Set ${input.id || 'slider-input'} to display: none in ${container.id}`);
                        }
                    });
                }
            });
        } else {
            warning.style.display = 'none';
            toggle.disabled = isSimpleMode;
            toggle.textContent = isVB ? state.translations[lang]['virtual_bass'] : state.translations[lang]['bass_enhancer'];
        }
    }
    const sectionElement = state.domCache[section === 'headphone' ? 'bass-boost-section' : 'sbass-boost-section'];
    if (sectionElement) {
        console.log(`Parent section ${sectionElement.id} visible: ${sectionElement.classList.contains('visible')}, display: ${window.getComputedStyle(sectionElement).display}`);
    }
    updateOutput();
};

export const initBass = () => {
	const debouncedUpdateOutput = debounce(updateOutput, 100);
    const lang = state.domCache.languageSelect?.value || 'en';
    console.log('initBass: Current language:', lang);
    console.log('initBass: Translations available:', state.translations?.[lang]);

    if (!state.translations || !state.translations[lang]) {
        console.error(`Translations for language "${lang}" not found`);
        return;
    }

    const getTranslation = (key, fallback) => {
        console.log(`getTranslation: key=${key}, lang=${lang}`);
        return state.translations[lang][key] || fallback;
    };

    const hToggle = getDomElement('hrenderbass');
    if (hToggle) {
        hToggle.addEventListener('click', () => {
            const isOn = hToggle.getAttribute('data-state') === 'true';
            hToggle.setAttribute('data-state', !isOn);
            hToggle.textContent = !isOn 
                ? getTranslation('bass_enhancer', 'Bass Enhancer') 
                : getTranslation('virtual_bass', 'Virtual Bass');
            hToggle.classList.toggle('active', !isOn);
            actionLog(`${getTranslation('headphone_bass_render_method_set_to', 'Headphone bass render method set to')} ${hToggle.textContent}`);
            bassVisibility('headphone', 'hrenderbass', lang);
            updateOutput();
        });
        if (!state.supportedFeatures?.harm) {
            hToggle.setAttribute('data-state', 'true');
            hToggle.textContent = getTranslation('bass_enhancer', 'Bass Enhancer');
            hToggle.disabled = true;
        }
    }

    const sToggle = getDomElement('srenderbass');
    if (sToggle) {
        sToggle.addEventListener('click', () => {
            const isOn = sToggle.getAttribute('data-state') === 'true';
            sToggle.setAttribute('data-state', !isOn);
            sToggle.textContent = !isOn 
                ? getTranslation('bass_enhancer', 'Bass Enhancer') 
                : getTranslation('virtual_bass', 'Virtual Bass');
            sToggle.classList.toggle('active', !isOn);
            actionLog(`${getTranslation('speaker_bass_render_method_set_to', 'Speaker bass render method set to')} ${sToggle.textContent}`);
            bassVisibility('speaker', 'srenderbass', lang);
            updateOutput();
        });
        if (!state.supportedFeatures?.harm) {
            sToggle.setAttribute('data-state', 'true');
            sToggle.textContent = getTranslation('bass_enhancer', 'Bass Enhancer');
            sToggle.disabled = true;
        }
    }
	
    const sliders = ['hbassboost', 'hbasscutoff', 'hbasswidth', 'hbassharmmixfreqmin', 'hbassharmmixfreqmax', 
                    'hbassharmsrcfreqmin', 'hbassharmsrcfreqmax', 'hbassharmboost', 'hbasslingain', 
                    'sbassboost', 'sbassharmboost', 'sbasslingain'];
    sliders.forEach(id => {
        const slider = getDomElement(id);
        if (slider) {
            slider.addEventListener('input',() => {
                const valueDisplay = getDomElement(`${id}-value`);
                if (valueDisplay) {
                    valueDisplay.textContent = convertToLanguageNumerals(slider.value, lang);
                }
                debouncedUpdateOutput();
            });
        }
    });

    const hHarmType = getDomElement('hbassharmtype');
    if (hHarmType) {
        hHarmType.addEventListener('change', () => {
            updateOutput();
        });
    }
    const sHarmType = getDomElement('sbassharmtype');
    if (sHarmType) {
        sHarmType.addEventListener('change', () => {
            updateOutput();
        });
    }

    bassVisibility('headphone', 'hrenderbass', lang);
    bassVisibility('speaker', 'srenderbass', lang);
};