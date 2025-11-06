import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals, convertFromLanguageNumerals } from '../shared/language.js';
import { actionLog } from '../shared/utils.js';
import { defaultValues } from '../config/configmodel.js';
import { updateOutput } from '../view/renderer.js';

export const initIeq = () => {
    const lang = state.domCache.languageSelect?.value || 'en';
	
	const checkIeqCustomVisibility = (selectElement) => {
	    const customContainer = getDomElement('hieqCustomInput'); 
	    const standardContainer = getDomElement('hieqPresetsContainer');
	
	    if (selectElement) {
	        const isCustom = selectElement.value === 'C';
	        if (customContainer) {
	            customContainer.classList.toggle('visible', isCustom);
	            customContainer.style.display = isCustom ? 'block' : 'none'; 
	        }
	        if (standardContainer) {
	            standardContainer.classList.toggle('visible', !isCustom);
	            standardContainer.style.display = isCustom ? 'none' : 'block';
	        }
	    }
	};

    const hietInputs = ['hiet47', 'hiet141', 'hiet234', 'hiet328', 'hiet469', 'hiet656', 'hiet844', 'hiet1031',
                        'hiet1313', 'hiet1688', 'hiet2250', 'hiet3000', 'hiet3750', 'hiet4688', 'hiet5813',
                        'hiet7125', 'hiet9000', 'hiet11250', 'hiet13875', 'hiet19688'];
    const hIeq = getDomElement('hieq');
    if (hIeq) {
        hIeq.addEventListener('change', () => {
            updateHieqInputs(hIeq.value);
            checkIeqCustomVisibility(hIeq);
            updateOutput();
        });
    }

    const sIeq = getDomElement('sieq');
    if (sIeq) {
        sIeq.addEventListener('change', () => {
            updateOutput();
        });
    }

    // Strength slider
    const hIeqStr = getDomElement('hieqstr');
    if (hIeqStr) {
        hIeqStr.addEventListener('input',() => {
            const valueDisplay = getDomElement('hieqstr-value');
            if (valueDisplay) {
                valueDisplay.textContent = convertToLanguageNumerals(hIeqStr.value, lang);
            }
            updateOutput();
        });
    }

    const sIeqStr = getDomElement('sieqstr');
    if (sIeqStr) {
        sIeqStr.addEventListener('input',() => {
            const valueDisplay = getDomElement('sieqstr-value');
            if (valueDisplay) {
                valueDisplay.textContent = convertToLanguageNumerals(sIeqStr.value, lang);
            }
            updateOutput();
        });
    }

    // Custom IEQ inputs
    hietInputs.forEach((id, index) => {
        const input = getDomElement(id);
        if (input) {
            input.addEventListener('input',() => {
                const value = convertFromLanguageNumerals(input.value, lang);
                if (isNaN(value)) {
                    actionLog(`Invalid input for ${id}`);
                    return;
                }
                const customValuesFallback = '150,142,188,216,189,195,202,199,210,225,230,236,235,235,214,165,112,49,-24,-217';
                const safeHieqValues = state.hieqCustomValues || customValuesFallback;
                
                const values = safeHieqValues.split(',');
                values[index] = value;
                state.hieqCustomValues = values.join(',');
                updateOutput();
            });
        }
    });
	const updateHieqInputs = (preset, lang) => {
	    if (preset === 'N') {
	        return; 
	    }
	
	    const hietInputs = ['hiet47', 'hiet141', 'hiet234', 'hiet328', 'hiet469', 'hiet656', 'hiet844', 'hiet1031', 'hiet1313', 'hiet1688', 'hiet2250', 'hiet3000', 'hiet3750', 'hiet4688', 'hiet5813', 'hiet7125', 'hiet9000', 'hiet11250', 'hiet13875', 'hiet19688'];
	    const customValuesFallback = '150,142,188,216,189,195,202,199,210,225,230,236,235,235,214,165,112,49,-24,-217';
	    let values;
	
	    if (preset === 'C') {
	        const customValuesString = state.hieqCustomValues || customValuesFallback;
	        values = customValuesString.split(',');
	    } else if (defaultValues.hieqPresets && defaultValues.hieqPresets[preset]) {
	        values = defaultValues.hieqPresets[preset].split(',');
	    } else {
	        console.warn(`IEQ preset "${preset}" not found in defaultValues.hieqPresets. No values will be loaded.`);
	        return;
	    }
	
	    hietInputs.forEach((id, index) => {
	        const input = getDomElement(id);
	        if (input && values[index] !== undefined) {
	            input.value = convertToLanguageNumerals(values[index], lang);
	        }
	    });
	};
	}