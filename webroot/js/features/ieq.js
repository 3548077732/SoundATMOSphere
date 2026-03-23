import { state } from '../shared/state.js';
import { updateOutput } from '../view/renderer.js';

export const initIeq = () => {
	const hietInputs = [
		'hiet47', 'hiet141', 'hiet234', 'hiet328', 'hiet469', 
		'hiet656', 'hiet844', 'hiet1031', 'hiet1313', 'hiet1688', 
		'hiet2250', 'hiet3000', 'hiet3750', 'hiet4688', 'hiet5813', 
		'hiet7125', 'hiet9000', 'hiet11250', 'hiet13875', 'hiet19688'
	];

	const templateValues = {
		'B': [157, 167, 218, 218, 203, 188, 192, 192, 205, 213, 218, 209, 193, 159, 134, 97, 71, 22, -90, -283],
		'D': [150, 142, 188, 216, 189, 195, 202, 199, 210, 225, 230, 236, 235, 235, 214, 165, 112, 49, -24, -217],
		'W': [114, 146, 183, 169, 170, 128, 103, 90, 98, 126, 127, 140, 96, 85, 80, 66, 38, -32, -132, -275]
	};

	const presetMap = { 
		'balanced': 'B', 'detailed': 'D', 'warm': 'W',
		'b': 'B', 'd': 'D', 'w': 'W'
	};
	
	const STORAGE_KEY = 'ieq_custom_state';

	const getEl = (id) => document.getElementById(id);

	// Get select elements for both headphones and speakers
	const hIeqSelect = getEl('hieq');
	const sIeqSelect = getEl('sieq');
	const customBaseSelect = getEl('hieqCustomBase');
	const resetBaseBtn = getEl('resetCustomBase');

	const getCurrentInputValues = () => hietInputs.map(id => {
		const el = getEl(id);
		if (!el) return 0;
		if (el.value === '') return 0;
		const parsed = parseInt(el.value, 10);
		return isNaN(parsed) ? 0 : parsed;
	});

	const updateGlobalState = (valuesArray) => {
		state.hieqCustomValues = valuesArray.join(',');
		updateOutput();
	};

	const updateSelectLabel = (baseKey, isModified) => {
		if (!customBaseSelect) return;
		try {
			const option = customBaseSelect.querySelector(`option[value="${baseKey}"]`);
			if (!option) return;

			Array.from(customBaseSelect.options).forEach(opt => {
				if (opt.value !== '' && opt.getAttribute('data-original-text')) {
					opt.text = opt.getAttribute('data-original-text');
				}
			});

			if (!option.getAttribute('data-original-text')) {
				option.setAttribute('data-original-text', option.text);
			}

			const originalText = option.getAttribute('data-original-text');
			option.text = isModified ? `${originalText} (modified)` : originalText;
		} catch(e) { }
	};

	const autoDetectBase = () => {
		if (!customBaseSelect) return;

		const currentValues = getCurrentInputValues();
		let closestMatch = null;
		let minDifference = Infinity;

		for (const [key, tplValues] of Object.entries(templateValues)) {
			const diff = tplValues.reduce((sum, val, idx) => sum + Math.abs(val - currentValues[idx]), 0);
			
			if (diff < minDifference) {
				minDifference = diff;
				closestMatch = key;
			}
		}

		if (closestMatch && minDifference < 2000) {
			customBaseSelect.value = closestMatch;
			checkModification();
		}
	};

	const checkModification = () => {
		if (!customBaseSelect) return;
		try {
			const currentBase = customBaseSelect.value;
			if (!currentBase || !templateValues[currentBase]) return;

			const currentValues = getCurrentInputValues();
			const baseValues = templateValues[currentBase];
			const isModified = currentValues.some((val, index) => parseInt(val) !== parseInt(baseValues[index]));
			
			updateSelectLabel(currentBase, isModified);
			saveCustomState(currentBase, currentValues);
			
			if (hIeqSelect && (hIeqSelect.value === 'C' || hIeqSelect.value === 'CB')) {
				updateGlobalState(currentValues);
			}
		} catch(e) { }
	};

	const saveCustomState = (base, values) => {
		try {
			const data = { base, values };
			localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
		} catch (e) {}
	};

	const loadValuesToInputs = (values) => {
		if (!values) return;
		hietInputs.forEach((id, index) => {
			const el = getEl(id);
			if (el) el.value = values[index];
		});
	};

	const loadTemplate = (baseKey) => {
		const values = templateValues[baseKey];
		if (!values) return;
		
		loadValuesToInputs(values);
		updateSelectLabel(baseKey, false);
		saveCustomState(baseKey, values);
		
		if (hIeqSelect && (hIeqSelect.value === 'C' || hIeqSelect.value === 'CB')) {
			updateGlobalState(values);
		}
	};

	const loadCustomState = () => {
		if (!customBaseSelect) return;
		const saved = localStorage.getItem(STORAGE_KEY);
		
		if (saved) {
			try {
				const data = JSON.parse(saved);
				if (data.base && templateValues[data.base]) {
					customBaseSelect.value = data.base;
					if (data.values && Array.isArray(data.values)) {
						loadValuesToInputs(data.values);
					}
				}
			} catch (e) { }
		}
		autoDetectBase();
	};

	const checkIeqCustomVisibility = () => {
		if (!hIeqSelect) return;

		const customContainer = getEl('hieqCustomInput'); 
		const customBaseContainer = getEl('hieqCustomBaseContainer');

		const isCustom = hIeqSelect.value === 'C' || hIeqSelect.value === 'CB';
		
		if (customContainer) {
			if (isCustom) {
				customContainer.style.removeProperty('display');
				customContainer.classList.add('visible');
			} else {
				customContainer.style.setProperty('display', 'none', 'important');
				customContainer.classList.remove('visible');
			}
		}
		
		if (customBaseContainer) {
			if (isCustom) {
				customBaseContainer.style.removeProperty('display');
			} else {
				customBaseContainer.style.setProperty('display', 'none', 'important');
			}
		}
	};

	// Restrict IEQ options based on Simple/Expert mode
	const handleModeRestrictions = () => {
		const isSimpleMode = document.body.classList.contains('simple-mode');
		const allowedInSimple = ['B', 'D', 'W'];
		
		const restrictSelect = (selectEl) => {
			if (!selectEl) return;
			
			let needsReset = false;
			const currentValue = selectEl.value;
			
			Array.from(selectEl.options).forEach(option => {
				const isAllowed = allowedInSimple.includes(option.value);
				
				if (isSimpleMode && !isAllowed) {
					option.style.display = 'none';
					// If currently selected option is being hidden, mark for reset
					if (currentValue === option.value) {
						needsReset = true;
					}
				} else {
					option.style.display = '';
				}
			});
			
			// Force reset to 'B' (Balanced) if the current selection is invalid for Simple Mode
			if (isSimpleMode && needsReset) {
				selectEl.value = 'B';
				// Trigger change event to update underlying data and UI
				selectEl.dispatchEvent(new Event('change'));
			}
		};

		restrictSelect(hIeqSelect);
		restrictSelect(sIeqSelect);
	};

	// Listen for mode changes using MutationObserver on body classList
	const setupModeObserver = () => {
		const observer = new MutationObserver((mutations) => {
			mutations.forEach((mutation) => {
				if (mutation.attributeName === 'class') {
					handleModeRestrictions();
				}
			});
		});
		
		observer.observe(document.body, { attributes: true });
	};

	const hStrengthInput = getEl('hieqstr');
	const hStrengthVal = getEl('hieqstr-value');
	
	const sStrengthInput = getEl('sieqstr');
	const sStrengthVal = getEl('sieqstr-value');

	const setupStrengthSlider = (input, valEl) => {
		if (input && valEl) {
			input.addEventListener('input', () => {
				valEl.textContent = input.value;
				updateOutput();
			});
			valEl.textContent = input.value;
		}
	};

	setupStrengthSlider(hStrengthInput, hStrengthVal);
	setupStrengthSlider(sStrengthInput, sStrengthVal);

	// Setup event listener for headphones IEQ
	if (hIeqSelect) {
		hIeqSelect.addEventListener('change', (e) => {
			checkIeqCustomVisibility(); 
			
			const val = e.target.value;
			if (val === 'C' || val === 'CB') {
				loadCustomState(); 
				updateGlobalState(getCurrentInputValues());
			} else if (val === 'N') {
				updateOutput();
			} else {
				const key = presetMap[val.toLowerCase()];
				if (key && templateValues[key]) {
					loadValuesToInputs(templateValues[key]);
				}
				updateOutput();
			}
		});
		
		checkIeqCustomVisibility();
	}
	
	// Setup event listener for speakers IEQ
	if (sIeqSelect) {
		sIeqSelect.addEventListener('change', () => {
			updateOutput();
		});
	}

	if (customBaseSelect) {
		customBaseSelect.addEventListener('change', (e) => loadTemplate(e.target.value));
	}

	if (resetBaseBtn) {
		resetBaseBtn.addEventListener('click', (e) => {
			e.preventDefault();
			if (customBaseSelect && customBaseSelect.value) {
				loadTemplate(customBaseSelect.value);
			}
		});
	}

	hietInputs.forEach(id => {
		const el = getEl(id);
		if (el) {
			el.addEventListener('input', checkModification);
			el.addEventListener('change', checkModification);
		}
	});

	if (hIeqSelect && (hIeqSelect.value === 'C' || hIeqSelect.value === 'CB')) {
		loadCustomState();
	}
	if (hIeqSelect) {
		checkIeqCustomVisibility();
	}
	
	if (!state.hieqCustomValues) {
		state.hieqCustomValues = getCurrentInputValues().join(',');
	}
	
	// Initial application of mode restrictions and observer setup
	handleModeRestrictions();
	setupModeObserver();

	let safetyChecks = 0;
	const safetyInterval = setInterval(() => {
		if (hIeqSelect) {
			checkIeqCustomVisibility();
			
			if ((hIeqSelect.value === 'C' || hIeqSelect.value === 'CB') && customBaseSelect && customBaseSelect.value === "") {
				autoDetectBase();
			}
			if (hStrengthInput && hStrengthVal) {
				hStrengthVal.textContent = hStrengthInput.value;
			}
		}
		if (sIeqSelect && sStrengthInput && sStrengthVal) {
			sStrengthVal.textContent = sStrengthInput.value;
		}
		safetyChecks++;
		if (safetyChecks > 30) clearInterval(safetyInterval);
	}, 100);
};