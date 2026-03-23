import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals, convertFromLanguageNumerals } from '../shared/language.js';
import { debounce } from '../shared/utils.js';
import { translationMaps } from '../config/configmodel.js';
import { toggleVisibility, updateOutput } from '../view/renderer.js';

// Set your default custom values here
const DEFAULT_H_CUSTOM = '103,32568,11164,5090,0,3,3,3';
const DEFAULT_S_CUSTOM = '103,32568,11164,5090,0,3,3,3';

const debouncedUpdateOutput = debounce(updateOutput, 10);

export const virtListeners = () => {
	const headphoneSelect = getDomElement('hadvirtrend');
	const speakerSelect = getDomElement('sadvirtrend');
	const customInputs = document.querySelectorAll('#customInput input, #scustomInput input');

	if (headphoneSelect) {
		headphoneSelect.addEventListener('change', updateOutput);
		updateOutput();
	}
	
	if (speakerSelect) {
		speakerSelect.addEventListener('change', updateOutput);
		updateOutput();
	}
	
	customInputs.forEach(input => {
		input.addEventListener('input', updateOutput);
	});
	updateOutput();
	console.log("Event listeners for virtualizer settings initialized.");
};

const loadAdvRendState = (selectId, stateKey, customValuesKey, customInputsId) => {
	const selectElement = getDomElement(selectId);
	const configValue = state[stateKey];
	const customContainer = getDomElement(customInputsId);
	const lang = state.domCache.languageSelect?.value || 'en';

	if (!selectElement || !configValue) {
		return;
	}

	const presetValues = Array.from(selectElement.options)
		.map(opt => opt.value)
		.filter(val => val !== 'custom');
		
	let isPreset = presetValues.includes(configValue);

	if (isPreset) {
		selectElement.value = configValue;
	} else {
		selectElement.value = 'custom';
		state[customValuesKey] = configValue;
		const values = configValue.split(',').map(v => v.trim());
		const inputs = customContainer?.querySelectorAll('input') || [];
		
		inputs.forEach((input, index) => {
			if (values[index] !== undefined) {
				input.value = convertToLanguageNumerals(values[index], lang);
				input.dispatchEvent(new Event('input', { bubbles: true }));
			}
		});
	}

	selectElement.dispatchEvent(new Event('change'));
};

export const loadVirtualizerState = () => {
	loadAdvRendState('hadvirtrend', 'hadvirtrend', 'customValues', 'customInput');
	loadAdvRendState('sadvirtrend', 'sadvirtrend', 'scustomValues', 'scustomInput');
};

export const initVirtualizer = () => {
	const lang = state.domCache.languageSelect?.value || 'en';

	const checkCustom = (element, containerId) => {
		const container = getDomElement(containerId);
		if (element && container) {
			container.classList.toggle('visible', element.value === 'custom');
		}
	};

	const handleAdvRendChange = (selectElement, containerId, stateKey, storageKey, defaultValues) => {
		Array.from(selectElement.options).forEach(opt => {
			const key = translationMaps.advVirtRend[opt.value] || 'custom';
			opt.textContent = state.translations[lang][key] || opt.value;
		});
		
		if (selectElement.value === 'custom') {
			const savedCustom = localStorage.getItem(storageKey) || defaultValues;
			state[stateKey] = savedCustom;
			
			const inputs = getDomElement(containerId).querySelectorAll('input');
			const values = savedCustom.split(',');
			
			inputs.forEach((input, index) => {
				if (values[index] !== undefined) {
					input.value = convertToLanguageNumerals(values[index].trim(), lang);
				}
			});
		} else if (selectElement.value === '' && state[stateKey] && state[stateKey].includes(',')) {
			selectElement.value = 'custom';
		}
		
		checkCustom(selectElement, containerId);
		updateOutput();
	};

	const hVirtualizer = getDomElement('hvirtualizer');
	if (hVirtualizer) {
		hVirtualizer.addEventListener('change', () => updateOutput());
	}

	const sVirtualizer = getDomElement('svirtualizer');
	if (sVirtualizer) {
		sVirtualizer.addEventListener('change', () => updateOutput());
	}

	const sliders = ['hvirtdist', 'hsurboost', 'hadvirtangle', 'ssurboost'];
	sliders.forEach(id => {
		const slider = getDomElement(id);
		if (slider) {
			slider.addEventListener('input', () => {
				const valueDisplay = getDomElement(`${id}-value`);
				if (valueDisplay) {
					valueDisplay.textContent = convertToLanguageNumerals(slider.value, lang);
				}
				debouncedUpdateOutput();
			});
		}
	});

	const hVirtMod = getDomElement('hvirtmod');
	if (hVirtMod) {
		hVirtMod.addEventListener('change', () => updateOutput());
	}

	const sVirtMod = getDomElement('svirtmod');
	if (sVirtMod) {
		sVirtMod.addEventListener('change', () => updateOutput());
	}

	const hHeightFilter = getDomElement('hheightfilter');
	if (hHeightFilter) {
		hHeightFilter.addEventListener('change', () => updateOutput());
	}

	const hAdvRend = getDomElement('hadvirtrend'); 
	if (hAdvRend) {
		hAdvRend.addEventListener('change', () => {
			handleAdvRendChange(hAdvRend, 'customInput', 'hadvirtrend', 'hadvirtrend_custom_saved', DEFAULT_H_CUSTOM);
		});
	}

	const sAdvRend = getDomElement('sadvirtrend');
	if (sAdvRend) {
		sAdvRend.addEventListener('change', () => {
			handleAdvRendChange(sAdvRend, 'scustomInput', 'sadvirtrend', 'sadvirtrend_custom_saved', DEFAULT_S_CUSTOM);
		});
	}

	const setupCustomInputs = (containerId, stateKey, storageKey, defaultValues) => {
		const container = getDomElement(containerId);
		if (!container) return;

		const inputs = container.querySelectorAll('input');
		inputs.forEach((input, index) => {
			input.addEventListener('input', () => {
				let currentVal = state[stateKey];
				if (!currentVal || !currentVal.includes(',')) {
					currentVal = localStorage.getItem(storageKey) || defaultValues;
				}
				
				const values = currentVal.split(',');
				values[index] = convertFromLanguageNumerals(input.value, lang);
				const newValue = values.join(',');
				
				state[stateKey] = newValue;
				localStorage.setItem(storageKey, newValue);
				updateOutput();
			});
		});
	};

	setupCustomInputs('customInput', 'hadvirtrend', 'hadvirtrend_custom_saved', DEFAULT_H_CUSTOM);
	setupCustomInputs('scustomInput', 'sadvirtrend', 'sadvirtrend_custom_saved', DEFAULT_S_CUSTOM);
	
	toggleVisibility('headphone', 'hvirtualizerContainer');
	toggleVisibility('speaker', 'svirtualizerContainer');
	
	checkCustom(getDomElement('hadvirtrend'), 'customInput');
	checkCustom(getDomElement('sadvirtrend'), 'scustomInput');
};