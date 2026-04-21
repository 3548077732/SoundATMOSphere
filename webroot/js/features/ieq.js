import { state } from '../shared/state.js';
import { updateOutput } from '../view/renderer.js';

export const initIeq = () => {
	const frequencies = [
		47, 141, 234, 328, 469, 656, 844, 1031, 1313, 1688, 
		2250, 3000, 3750, 4688, 5813, 7125, 9000, 11250, 13875, 19688
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

	const getEl = (id) => document.getElementById(id);

	const isSelectCustom = (selectEl) => {
		return selectEl && (selectEl.value === 'C' || selectEl.value === 'CB' || selectEl.value === 'CD');
	};

	const setupIeq = (prefix) => {
		const config = {
			select: getEl(`${prefix}ieq`),
			customBase: getEl(`${prefix}ieqCustomBase`),
			resetBtn: getEl(`reset${prefix.toUpperCase()}CustomBase`), 
			inputs: frequencies.map(f => `${prefix}iet${f}`),
			customContainer: getEl(`${prefix}ieqCustomInput`),
			customBaseContainer: getEl(`${prefix}ieqCustomBaseContainer`),
			strInput: getEl(`${prefix}ieqstr`),
			strVal: getEl(`${prefix}ieqstr-value`),
			storageKey: `ieq_custom_state_${prefix}`, 
			stateKey: `${prefix}ieqCustomValues` 
		};

		const missingEls = [];
		if (!config.select) missingEls.push(`${prefix}ieq`);
		if (!config.customBase) missingEls.push(`${prefix}ieqCustomBase`);
		if (!config.customContainer) missingEls.push(`${prefix}ieqCustomInput`);
		if (!config.customBaseContainer) missingEls.push(`${prefix}ieqCustomBaseContainer`);
		if (missingEls.length > 0) {
			console.warn(`[IEQ Setup] Brakujące elementy HTML dla '${prefix}':`, missingEls.join(', '));
		}

		if (!config.select) return null;

		const getCurrentInputValues = () => config.inputs.map(id => {
			const el = getEl(id);
			if (!el || el.value === '') return 0;
			const parsed = parseInt(el.value, 10);
			return isNaN(parsed) ? 0 : parsed;
		});

		const updateGlobalState = () => {
			if (isSelectCustom(config.select)) {
				state[config.stateKey] = getCurrentInputValues().join(',');
				updateOutput();
			}
		};

		const updateSelectLabel = (baseKey, isModified) => {
			if (!config.customBase) return;
			try {
				const option = config.customBase.querySelector(`option[value="${baseKey}"]`);
				if (!option) return;

				Array.from(config.customBase.options).forEach(opt => {
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

		const checkModification = () => {
			if (!config.customBase) return;
			try {
				const currentBase = config.customBase.value;
				if (!currentBase || !templateValues[currentBase]) return;

				const currentValues = getCurrentInputValues();
				const baseValues = templateValues[currentBase];
				const isModified = currentValues.some((val, index) => parseInt(val) !== parseInt(baseValues[index]));
				
				updateSelectLabel(currentBase, isModified);
				saveCustomState(currentBase, currentValues);
				updateGlobalState();
			} catch(e) { }
		};

		const autoDetectBase = () => {
			if (!config.customBase) return;

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
				config.customBase.value = closestMatch;
				checkModification();
			}
		};

		const saveCustomState = (base, values) => {
			try {
				localStorage.setItem(config.storageKey, JSON.stringify({ base, values }));
			} catch (e) {}
		};

		const loadValuesToInputs = (values) => {
			if (!values) return;
			config.inputs.forEach((id, index) => {
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
			updateGlobalState();
		};

		const loadCustomState = () => {
			if (!config.customBase) return;
			const saved = localStorage.getItem(config.storageKey);
			
			if (saved) {
				try {
					const data = JSON.parse(saved);
					if (data.base && templateValues[data.base]) {
						config.customBase.value = data.base;
						if (data.values && Array.isArray(data.values)) {
							loadValuesToInputs(data.values);
						}
					}
				} catch (e) { }
			}
			autoDetectBase();
		};

		const checkVisibility = () => {
			const isCustom = isSelectCustom(config.select);
			
			if (config.customContainer) {
				if (isCustom) {
					config.customContainer.style.removeProperty('display');
					config.customContainer.classList.add('visible');
				} else {
					config.customContainer.style.setProperty('display', 'none', 'important');
					config.customContainer.classList.remove('visible');
				}
			}
			
			if (config.customBaseContainer) {
				if (isCustom) {
					config.customBaseContainer.style.removeProperty('display');
				} else {
					config.customBaseContainer.style.setProperty('display', 'none', 'important');
				}
			}
		};

		config.select.addEventListener('change', (e) => {
			const val = e.target.value;
			
			state[`${prefix}ieq`] = val; 
			checkVisibility(); 
			
			if (isSelectCustom(config.select)) {
				let targetBase = null;
				if (val === 'CB') targetBase = 'B';
				if (val === 'CD') targetBase = 'D';

				if (targetBase) {
					if (config.customBase) config.customBase.value = targetBase;
					
					const saved = localStorage.getItem(config.storageKey);
					let loadedFromSave = false;
					
					if (saved) {
						try {
							const data = JSON.parse(saved);
							if (data.base === targetBase && data.values && Array.isArray(data.values)) {
								loadValuesToInputs(data.values);
								loadedFromSave = true;
							}
						} catch (e) { }
					}
					
					if (!loadedFromSave && templateValues[targetBase]) {
						loadValuesToInputs(templateValues[targetBase]);
					}
					
					state[config.stateKey] = getCurrentInputValues().join(',');
					updateOutput();
					checkModification();
					
				} else {
					loadCustomState(); 
					updateGlobalState();
					updateOutput();
				}
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

		if (config.customBase) {
			config.customBase.addEventListener('change', (e) => loadTemplate(e.target.value));
		}

		if (config.resetBtn) {
			config.resetBtn.addEventListener('click', (e) => {
				e.preventDefault();
				if (config.customBase && config.customBase.value) {
					loadTemplate(config.customBase.value);
				}
			});
		}

		config.inputs.forEach(id => {
			const el = getEl(id);
			if (el) {
				el.addEventListener('input', checkModification);
				el.addEventListener('change', checkModification);
			}
		});

		if (config.strInput && config.strVal) {
			config.strInput.addEventListener('input', () => {
				config.strVal.textContent = config.strInput.value;
				updateOutput();
			});
			config.strVal.textContent = config.strInput.value;
		}

		if (isSelectCustom(config.select)) {
			loadCustomState();
		}
		checkVisibility();
		
		if (!state[config.stateKey]) {
			state[config.stateKey] = getCurrentInputValues().join(',');
		}

		return { checkVisibility, autoDetectBase, config };
	};

	const hIeqInstance = setupIeq('h');
	const sIeqInstance = setupIeq('s');

	const handleModeRestrictions = () => {
		const isSimpleMode = document.body.classList.contains('simple-mode');
		const allowedInSimple = ['B', 'D', 'W'];
		
		const restrictSelect = (instance) => {
			if (!instance || !instance.config.select) return;
			const selectEl = instance.config.select;
			let needsReset = false;
			const currentValue = selectEl.value;
			
			Array.from(selectEl.options).forEach(option => {
				const isAllowed = allowedInSimple.includes(option.value);
				if (isSimpleMode && !isAllowed) {
					option.style.display = 'none';
					if (currentValue === option.value) needsReset = true;
				} else {
					option.style.display = '';
				}
			});
			
			if (isSimpleMode && needsReset) {
				selectEl.value = 'B';
				selectEl.dispatchEvent(new Event('change'));
			}
		};

		restrictSelect(hIeqInstance);
		restrictSelect(sIeqInstance);
	};

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

	handleModeRestrictions();
	setupModeObserver();

	let safetyChecks = 0;
	const safetyInterval = setInterval(() => {
		const checkInstance = (instance) => {
			if (!instance) return;
			instance.checkVisibility();
			
			if (isSelectCustom(instance.config.select) && instance.config.customBase && instance.config.customBase.value === "") {
				instance.autoDetectBase();
			}
			if (instance.config.strInput && instance.config.strVal) {
				instance.config.strVal.textContent = instance.config.strInput.value;
			}
		};

		checkInstance(hIeqInstance);
		checkInstance(sIeqInstance);
		
		safetyChecks++;
		if (safetyChecks > 30) clearInterval(safetyInterval);
	}, 100);
};