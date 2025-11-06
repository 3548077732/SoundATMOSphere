import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { actionLog } from '../shared/utils.js';
import { equalizerPresets } from '../config/configmodel.js';
import { updateOutput } from '../view/renderer.js';


export const updateEqualizerSliders = (preset) => {
    const lang = state.domCache.languageSelect?.value || 'en';
    const sliders = ['heq47', 'heq141', 'heq234', 'heq328', 'heq469', 'heq656', 'heq844', 'heq1031',
                     'heq1313', 'heq1688', 'heq2250', 'heq3000', 'heq3750', 'heq4688', 'heq5813',
                     'heq7125', 'heq9000', 'heq11250', 'heq13875', 'heq19688'];
    
    let values;
    if (preset === 'custom') { 
        const customValueString = state.heqCustomValues || sliders.map(() => '0').join(',');
        values = customValueString.split(',');
        actionLog(state.translations[lang]['custom_eq_loaded']);
    } else {
        // configmodel.js loading config logic
        const presetValuesString = equalizerPresets[preset];
        if (presetValuesString) {
            values = presetValuesString.split(',');
            state.heqCustomValues = presetValuesString; 
        } else {
            console.error(`Preset ${preset} not found in equalizerPresets`);
            values = sliders.map(() => '0'); 
        }
    }
    sliders.forEach((id, index) => {
        const slider = getDomElement(id);
        const value = values[index] || '0'; 
        if (slider) {
            slider.value = value;
            const valueDisplay = getDomElement(`${id}-value`);
            if (valueDisplay) {
                valueDisplay.textContent = convertToLanguageNumerals(value, lang) + ' dB';
            }
        }
    });
};

export const initEqualizer = () => {
    const lang = state.domCache.languageSelect?.value || 'en';
    const sliders = ['heq47', 'heq141', 'heq234', 'heq328', 'heq469', 'heq656', 'heq844', 'heq1031',
                     'heq1313', 'heq1688', 'heq2250', 'heq3000', 'heq3750', 'heq4688', 'heq5813',
                     'heq7125', 'heq9000', 'heq11250', 'heq13875', 'heq19688'];
  const presetSelect = getDomElement('heqpreset');
    if (presetSelect) {
        
        presetSelect.addEventListener('change', () => {
            const selectedPreset = presetSelect.value;
            
            const customContainer = getDomElement('customEqContainer');
            if (customContainer) {
                customContainer.classList.toggle('visible', selectedPreset === 'custom');
            }
            
            updateEqualizerSliders(selectedPreset);
            updateOutput();
        });
        
        const customContainer = getDomElement('customEqContainer');
        if (customContainer) {
            customContainer.classList.toggle('visible', presetSelect.value === 'custom');
        }
    }
    
	const resetBtn = getDomElement('resetCustomEq');
	if (resetBtn) {
	    resetBtn.addEventListener('click', () => {
	        const presetSelect = getDomElement('heqpreset');
	        actionLog(state.translations[lang]['resetting_custom_eq']);
	        
	        if (presetSelect) {
	            presetSelect.value = 'custom';
	        }
	        
	        const customContainer = getDomElement('customEqContainer');
	        if (customContainer) {
	            customContainer.classList.add('visible');
	        }
	        
	        const zeroValuesString = sliders.map(() => '0').join(',');
	        state.heqCustomValues = zeroValuesString;
	        updateEqualizerSliders('custom');
	        updateOutput();
	    });
	}
    
    sliders.forEach(id => {
        const slider = getDomElement(id);
        if (slider) {
            slider.step = '0.5';
			slider.addEventListener('input', () => {
			    const valueDisplay = getDomElement(`${id}-value`);
			    if (valueDisplay) {
			        valueDisplay.textContent = convertToLanguageNumerals(slider.value, lang) + ' dB';
			    }
			    if (presetSelect && presetSelect.value !== 'custom') {
			        presetSelect.value = 'custom';
			        const customContainer = getDomElement('customEqContainer');
			        if (customContainer) {
			            customContainer.classList.add('visible');
			        }
			    }
			    const currentValues = sliders.map(sliderId => {
			        const currentSlider = getDomElement(sliderId);
			        return currentSlider ? currentSlider.value : '0';
			    });
			    state.heqCustomValues = currentValues.join(',');
			    updateOutput();
			});
        } 
    });
    
    const resizeEqualizerSliders = (delta, currentLang) => {
        sliders.forEach(id => {
            const slider = getDomElement(id);
            if (slider) {
                const styleHeight = slider.style.height;
                const currentRem = styleHeight && styleHeight.endsWith('rem') 
                                 ? parseFloat(styleHeight) 
                                 : 1;
                                 
                const newHeight = Math.max(1, Math.min(20, currentRem + (delta))); 
                slider.style.height = `${newHeight}rem`;
            }
        });
    };
    
    const shrinkBtn = getDomElement('slidershrink');
    if (shrinkBtn) {
        shrinkBtn.addEventListener('click', () => resizeEqualizerSliders(-5, lang)); 
    }
    const expandBtn = getDomElement('sliderexpand');
    if (expandBtn) {
        expandBtn.addEventListener('click', () => resizeEqualizerSliders(5, lang)); 
    }
    
    updateEqualizerSliders(presetSelect?.value || 'flat');
};
