import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { actionLog } from '../shared/utils.js';
import { equalizerPresets } from '../config/configmodel.js';
import { updateOutput } from '../view/renderer.js';

export const FREQUENCIES = [
	'47', '141', '234', '328', '469', '656', '844', '1031',
	'1313', '1688', '2250', '3000', '3750', '4688', '5813',
	'7125', '9000', '11250', '13875', '19688'
];

const getSliderIds = (prefix) => FREQUENCIES.map(freq => `${prefix}${freq}`);

export const updateEqualizerSliders = (preset, prefix = 'heq') => {
	const lang = state.domCache.languageSelect?.value || 'en';
	const sliders = getSliderIds(prefix);
	const stateKey = `${prefix}CustomValues`;

	let values;
	if (preset === 'custom') { 
		const customValueString = state[stateKey] || sliders.map(() => '0').join(',');
		values = customValueString.split(',');
		actionLog(state.translations[lang]['custom_eq_loaded']);
	} else {
		const presetValuesString = equalizerPresets[preset];
		if (presetValuesString) {
			values = presetValuesString.split(',');
			state[stateKey] = presetValuesString; 
		} else {
			console.error(`Preset ${preset} not found in equalizerPresets`);
			values = sliders.map(() => '0'); 
		}
	}

	sliders.forEach((id, index) => {
		// Use native document.getElementById to ensure dynamically loaded sliders are found
		const slider = document.getElementById(id);
		const value = values[index] || '0'; 
		
		if (slider) {
			slider.value = value;
			
			// Update the text display for the slider value
			const valueDisplay = document.getElementById(`${id}-value`);
			if (valueDisplay) {
				valueDisplay.textContent = convertToLanguageNumerals(value, lang) + ' dB';
			}
		}
	});
};

const initEqualizerInstance = (prefix) => {
	const lang = state.domCache.languageSelect?.value || 'en';
	const sliders = getSliderIds(prefix);
	const stateKey = `${prefix}CustomValues`;
	
	const presetSelect = document.getElementById(`${prefix}preset`);
	const customContainerId = `${prefix}CustomEqContainer`;
	const customContainer = document.getElementById(customContainerId);

	if (presetSelect) {
		presetSelect.addEventListener('change', () => {
			const selectedPreset = presetSelect.value;
			
			if (customContainer) {
				customContainer.classList.toggle('visible', selectedPreset === 'custom');
			}
			
			updateEqualizerSliders(selectedPreset, prefix);
			updateOutput();
		});
		
		if (customContainer) {
			customContainer.classList.toggle('visible', presetSelect.value === 'custom');
		}
	}

	// Attach input event listeners for real-time slider value updates
	sliders.forEach(id => {
		const slider = document.getElementById(id);
		if (slider) {
			slider.step = '0.5';
			slider.addEventListener('input', () => {
				const valueDisplay = document.getElementById(`${id}-value`);
				if (valueDisplay) {
					valueDisplay.textContent = convertToLanguageNumerals(slider.value, lang) + ' dB';
				}
				
				if (presetSelect && presetSelect.value !== 'custom') {
					presetSelect.value = 'custom';
					if (customContainer) {
						customContainer.classList.add('visible');
					}
				}
				
				const currentValues = sliders.map(sliderId => {
					const currentSlider = document.getElementById(sliderId);
					return currentSlider ? currentSlider.value : '0';
				});
				
				state[stateKey] = currentValues.join(',');
				updateOutput();
			});
		} 
	});

	const resizeEqualizerSliders = (delta) => {
		sliders.forEach(id => {
			const slider = document.getElementById(id);
			if (slider) {
				const styleHeight = slider.style.height;
				const currentRem = styleHeight && styleHeight.endsWith('rem') 
								 ? parseFloat(styleHeight) 
								 : 15; 
								 
				const newHeight = Math.max(1, Math.min(20, currentRem + delta)); 
				slider.style.height = `${newHeight}rem`;
			}
		});
	};

	// Event delegation to handle dynamically rendered buttons
	document.addEventListener('click', (event) => {
		const targetId = event.target.id;
		
		if (targetId === `slidershrink${prefix}`) {
			resizeEqualizerSliders(-5);
		} else if (targetId === `sliderexpand${prefix}`) {
			resizeEqualizerSliders(5);
		} else if (targetId === `resetCustomEq${prefix}`) {
			actionLog(state.translations[lang]['resetting_custom_eq']);
			
			if (presetSelect) {
				presetSelect.value = 'custom';
			}
			
			if (customContainer) {
				customContainer.classList.add('visible');
			}
			
			const zeroValuesString = sliders.map(() => '0').join(',');
			state[stateKey] = zeroValuesString;
			
			// Update the UI
			updateEqualizerSliders('custom', prefix);
			updateOutput();
		}
	});
	
	updateEqualizerSliders(presetSelect?.value || 'flat', prefix);
};

export const initEqualizer = () => {
	initEqualizerInstance('heq');
	initEqualizerInstance('seq');
};