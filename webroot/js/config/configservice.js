import { CONFIG_PATH, ACTION_PATH, ACTION_LOG, FEATURE_PATH } from '../shared/constants.js';
import { execCommand, actionLog, sleep } from '../shared/utils.js';
import { state } from '../shared/state.js';
import { defaultValues, configMap, visibilityMap, equalizerPresets } from './configmodel.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { updateOutput, updateDefaultValuesDisplay } from '../view/renderer.js';
import { bassVisibility } from '../features/bass.js';
import { FREQUENCIES, updateEqualizerSliders } from '../features/equalizer.js';
import { loadVirtualizerState } from '../features/virtualizer.js';

const parseConfigContent = (content) => {
	const config = {};
	const lines = content.split('\n');
	lines.forEach(line => {
		const match = line.trim().match(/^([A-Z0-9_]+)=(.+)$/i);
		if (match) {
			const key = match[1].toLowerCase().trim();
			const value = match[2].trim().replace(/['"]/g, '');
			config[key] = value;
		}
	});
	return config;
};

export const setSimpleModeDefaults = () => {
	const lang = state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en';
	
	if (state.domCache.hrenderbass) {
		state.domCache.hrenderbass.setAttribute('data-state', 'true');
		state.domCache.hrenderbass.textContent = state.translations[lang]['bass_enhancer'];
		state.domCache.hrenderbass.disabled = true;
	}
	if (state.domCache.srenderbass) {
		state.domCache.srenderbass.setAttribute('data-state', 'true');
		state.domCache.srenderbass.textContent = state.translations[lang]['bass_enhancer'];
		state.domCache.srenderbass.disabled = true;
	}
	
	const nonVisibleElements = new Set();
	['headphone', 'speaker'].forEach(section => {
		const isVB = false;
		Object.entries(visibilityMap[section]).forEach(([key, { id, showWhen }]) => {
			const container = state.domCache[id];
			const shouldShow = showWhen(isVB, state.supportedFeatures, state.isSimpleMode);
			const isExpertOnly = container && container.classList.contains('expert-only');
			if (container && (!shouldShow || isExpertOnly)) {
				nonVisibleElements.add(id);
			}
		});
	});

	for (const [key, value] of Object.entries(defaultValues)) {
		const element = state.domCache[key.toLowerCase()];
		if (!element) continue;

		const controlId = key.toLowerCase();
		const containerId = controlId + 'Container';
		const isNonVisible = nonVisibleElements.has(containerId);

		// Skip equalizer sliders to preserve their values
		if (isNonVisible && !key.startsWith('HEQ_') && !key.startsWith('SEQ_')) {
			if (element.type === 'range') {
				element.value = value;
				const valueDisplay = state.domCache[`${controlId}-value`];
				if (valueDisplay) valueDisplay.textContent = convertToLanguageNumerals(value, lang);
			} else if (element.tagName === 'SELECT') {
				element.value = value;
			} else if (element.classList.contains('toggle-btn')) {
				const isOn = value === 'ON' || value === 'YES' || value === 'BE';
				element.setAttribute('data-state', isOn);
				element.textContent = key === 'HRENDERBASS' || key === 'SRENDERBASS'
					? (isOn ? state.translations[lang]['bass_enhancer'] : state.translations[lang]['virtual_bass'])
					: (isOn ? state.translations[lang][key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'yes' : 'on'] : state.translations[lang][key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'no' : 'off']);
				element.classList.toggle('active', isOn);
			}
		}
	}
	
	// Reset custom values arrays
	state.hieqCustomValues = defaultValues.hieqCustomValues;
	state.sieqCustomValues = defaultValues.sieqCustomValues || defaultValues.hieqCustomValues;
	
	updateOutput();
	updateDefaultValuesDisplay();
	bassVisibility('headphone', 'hrenderbass');
	bassVisibility('speaker', 'srenderbass');
};

export const ensureDefaultValuesLoaded = () => {
	const lang = state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en';

	if (!state.configValues || Object.keys(state.configValues).length === 0) {
		state.configValues = { ...defaultValues };
	}
	
	state.hieqCustomValues = state.hieqCustomValues || defaultValues.hieqCustomValues;
	state.sieqCustomValues = state.sieqCustomValues || defaultValues.sieqCustomValues || defaultValues.hieqCustomValues;
	
	state.heqCustomValues = state.heqCustomValues || defaultValues.heqCustomValues;
	state.seqCustomValues = state.seqCustomValues || defaultValues.seqCustomValues;
};

// Load config
export const loadConfig = async () => {
	const lang = state.domCache.languageSelect?.value || 'en';
	try {
		const content = await execCommand(`cat ${CONFIG_PATH}`);
		state.configValues = parseConfigContent(content);
		console.log('Loaded config values:', state.configValues);
		parseConfig(content);
		const configObject = parseConfigContent(content); 

		Object.assign(state, configObject);

		console.log('DOM values after loadConfig:', Object.fromEntries(
			Object.entries(state.domCache)
				.filter(([k]) => k.includes('hieq') || k.includes('heq') || k.includes('dolbymi'))
				.map(([k, v]) => [k, v.value])
		));
	} catch (error) {
		actionLog(`${state.translations[lang]['error_loading_config']}: ${error}`);
		state.configValues = { ...defaultValues };
		console.log('Fallback to defaultValues:', state.configValues);
	}
	bassVisibility('headphone', 'hrenderbass', lang);
	bassVisibility('speaker', 'srenderbass', lang);
	loadVirtualizerState(); 
	updateOutput();
	updateDefaultValuesDisplay();
};

export const saveConfig = async () => {
	try {
		if (!state.domCache.output) {
			state.domCache.output = document.getElementById('output');
		}
		const output = state.domCache.output && state.domCache.output.value ? state.domCache.output.value : generateConfigString();
		console.log('output:', output);
		if (!output || output.trim() === '') {
			throw new Error('Output is empty, cannot save config');
		}
		const escapedOutput = output.replace(/"/g, '\\"').replace(/\$/g, '\\$');
		console.log('escapedOutput:', escapedOutput);
		const command = `cat << 'EOF' > ${CONFIG_PATH}\n${escapedOutput}\nEOF`;
		console.log(`Executing save command: ${command}`);
		await execCommand(command);
		actionLog(state.translations[state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en']['config_saved']);
	} catch (error) {
		actionLog(`${state.translations[state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en']['error_saving_config']}: ${error}`);
	}
};

// Parse config line
const parseConfigLine = (line, lang) => {
	if (!line.trim() || line.startsWith('#') || line.startsWith('---') || line.startsWith('V=')) {
		return;
	}
	const match = line.match(/^([A-Z0-9_]+)=(.+)$/);
	if (!match) {
		console.warn(`Invalid config line format: ${line}`);
		return;
	}
	const [, key, value] = match;
	const config = configMap[key];
	if (!config) {
		console.warn(`Unknown config key: ${key}`);
		return;
	}
	const element = state.domCache[config.id];
	if (!element) {
		console.warn(`Element ${config.id} not found in domCache for key ${key}`);
		return;
	}

	const isSimpleMode = state.isSimpleMode;
	if (isSimpleMode && (key === 'HRENDERBASS' || key === 'SRENDERBASS')) {
		return;
	}

	if (key === 'HEQPRESET' || key === 'SEQPRESET') {
		const stateKey = key === 'HEQPRESET' ? 'heqCustomValues' : 'seqCustomValues';
		element.value = Object.keys(equalizerPresets).includes(value) ? value : 'custom';
		if (element.value === 'custom') {
			state[stateKey] = state[stateKey] || defaultValues[stateKey];
		}
		updateEqualizerSliders(element.value, lang);

	} else if (key.startsWith('HEQ_') || key.startsWith('SEQ_')) {
		const isHeq = key.startsWith('HEQ_');
		const prefix = isHeq ? 'heq' : 'seq';
		
		const sliders = FREQUENCIES.map(freq => `${prefix}${freq}`);
		const index = sliders.indexOf(config.id);
		
		if (index !== -1) {
			let parsedValue = parseFloat(value);
			if (isNaN(parsedValue) || parsedValue < -12 || parsedValue > 12) {
				parsedValue = 0;
			}

			const stateKey = `${prefix}CustomValues`;
			state[stateKey] = state[stateKey] || defaultValues[stateKey] || sliders.map(() => '0').join(',');
			
			const values = state[stateKey].split(',');
			values[index] = parsedValue.toString();
			state[stateKey] = values.join(',');

			element.value = parsedValue;
			const valueDisplay = state.domCache[`${config.id}-value`];
			if (valueDisplay) {
				valueDisplay.textContent = convertToLanguageNumerals(parsedValue, lang) + ' dB';
			}
		}
	} else if (key.startsWith('HIET_') || key.startsWith('SIET_')) {
		// Logic for both headphones and speakers IEQ targets
		const prefix = key.startsWith('HIET_') ? 'h' : 's';
		const frequencies = ['47', '141', '234', '328', '469', '656', '844', '1031', '1313', '1688', '2250', '3000', '3750', '4688', '5813', '7125', '9000', '11250', '13875', '19688'];
		const ietInputs = frequencies.map(f => `${prefix}iet${f}`);
		
		const index = ietInputs.indexOf(config.id);
		if (index !== -1) {
			let parsedValue = parseFloat(value);
			// Validate value limits
			if (isNaN(parsedValue) || parsedValue < -500 || parsedValue > 500) {
				parsedValue = parseFloat(config.default) || 0;
			}
			
			const stateKey = `${prefix}ieqCustomValues`;
			state[stateKey] = state[stateKey] || defaultValues[stateKey] || defaultValues.hieqCustomValues;
			
			const values = state[stateKey].split(',');
			values[index] = parsedValue.toString();
			state[stateKey] = values.join(',');
			
			element.value = convertToLanguageNumerals(parsedValue, lang);
		}
	} else if (config.type === 'toggle') {
		const isOn = value === 'ON' || value === 'YES' || value === 'BE';
		element.setAttribute('data-state', isOn);
		element.textContent = key === 'HRENDERBASS' || key === 'SRENDERBASS'
			? (isOn ? state.translations[lang]['bass_enhancer'] : state.translations[lang]['virtual_bass'])
			: (isOn ? state.translations[lang][key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'yes' : 'on'] : state.translations[lang][key === 'SPEAKERTUNING' || key === 'HEADPHONETUNING' ? 'no' : 'off']);
		element.classList.toggle('active', isOn);
	} else if (config.type === 'range' && !key.startsWith('HEQ_') && !key.startsWith('SEQ_')) {
		element.value = value;
		const valueDisplay = state.domCache[`${config.id}-value`];
		if (valueDisplay) {
			valueDisplay.textContent = convertToLanguageNumerals(value, lang) + (key.includes('VOLBOOST') ? ' dB' : '');
		}
	} else if (config.type === 'select' && key !== 'HEQPRESET' && key !== 'SEQPRESET') {
		element.value = value;
	}
};

// Parse config
export const parseConfig = (content) => {
	const lang = state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en';
	content.split('\n').forEach(line => parseConfigLine(line, lang));
	bassVisibility('headphone', 'hrenderbass');
	bassVisibility('speaker', 'srenderbass');
	updateOutput();
	updateDefaultValuesDisplay();
};

// Apply tuning
export const applyTuning = async () => {
	if (state.actionRunning) {
		actionLog(state.translations[state.domCache.languageSelect?.value || 'en']['action_already_running']);
		return;
	}
	state.actionRunning = true;
	const lang = state.domCache.languageSelect?.value || 'en';
	try {
		await saveConfig();
		await sleep(1000);
		actionLog(state.translations[lang]['applying_tuning']);
		actionLog(state.translations[lang]['applying_tuning_time_warning']);

		await execCommand(`setsid ${ACTION_PATH} > ${ACTION_LOG} 2>&1 &`);
		await sleep(100);

		let processedLinesCount = 0;
		let isScriptFinished = false;

		const checkLogs = async () => {
			try {
				const scriptOutput = await execCommand(`cat ${ACTION_LOG}`);
				if (scriptOutput && typeof scriptOutput === 'string') {
					const outputLines = scriptOutput.split('\n');
					for (let i = processedLinesCount; i < outputLines.length; i++) {
						actionLog(outputLines[i]);
						if (outputLines[i].includes('DONE!')) isScriptFinished = true;
					}
					processedLinesCount = outputLines.length;
				}
			} catch (error) {
				actionLog(`${state.translations[lang]['error_reading_log']}: ${error}`);
			}
		};

		const intervalId = setInterval(async () => {
			await checkLogs();
			if (isScriptFinished) {
				clearInterval(intervalId);
				await execCommand(`rm ${ACTION_LOG}`);
				state.actionRunning = false;
			}
		}, 250);

		setTimeout(() => {
			if (!isScriptFinished) {
				clearInterval(intervalId);
				actionLog(state.translations[lang]['script_timeout']);
				state.actionRunning = false;
			}
		}, 120000);
	} catch (error) {
		actionLog(`${state.translations[lang]['error_applying_tuning']}: ${error}`);
		state.actionRunning = false;
	}
};

// Check feature support
export const checkFeatureSupport = async () => {
	const lang = state.domCache.languageSelect?.value || 'en';
	try {
		const featureContent = await execCommand(`cat ${FEATURE_PATH}`);
		const lines = featureContent.split(/[\r\n]+/);
		const newFeatures = { 
			harm: false, 
			angle: false, 
			distance: false, 
			hadvancedvirt: false, 
			sadvancedvirt: false,
			hvirtmode: false,
			svirtmode: false
		};
		lines.forEach(line => {
			const trimmedLine = line.trim();
			if (trimmedLine === 'harm=true') newFeatures.harm = true;
			else if (trimmedLine === 'angle=true') newFeatures.angle = true;
			else if (trimmedLine === 'distance=true') newFeatures.distance = true;
			else if (trimmedLine === 'hadvancedvirt=true') newFeatures.hadvancedvirt = true;
			else if (trimmedLine === 'sadvancedvirt=true') newFeatures.sadvancedvirt = true;
			else if (trimmedLine === 'hvirtmode=true') newFeatures.hvirtmode = true;
			else if (trimmedLine === 'svirtmode=true') newFeatures.svirtmode = true;
		});
		Object.assign(state.supportedFeatures, newFeatures);

		const featureLabels = {
			harm: 'Bass Harmonics',
			hvirtmode: 'Headphones Virtualizer Mode',
			distance: 'Headphones Source Distance',
			angle: 'Headphones Left-Right Angle',
			hadvancedvirt: 'Headphones Advanced Soundstage Renderer',
			svirtmode: 'Speaker Virtualizer Mode',
			sadvancedvirt: 'Speaker Advanced Soundstage Renderer'
		};

		const logMessage = [
			'User Dolby Features support:',
			...Object.entries(featureLabels).map(([key, label]) => 
				`	${label}: ${state.supportedFeatures[key]}`)
		].join('\n');

		actionLog(logMessage);
	} catch (error) {
		actionLog(`${state.translations[lang]?.['error_reading_feature_file'] || 'Error reading feature file'}: ${error}`);
	}
	return state.supportedFeatures;
};