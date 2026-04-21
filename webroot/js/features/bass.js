import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { debounce, actionLog } from '../shared/utils.js';
import { visibilityMap } from '../config/configmodel.js';
import { updateOutput } from '../view/renderer.js';

export const bassVisibility = (section, toggleId, featureKey = null) => {
	const toggle = state.domCache[toggleId] || document.getElementById(toggleId);
	if (!toggle) {
		console.log(`toggleVisibility: Toggle ${toggleId} not found`);
		return; 
	}
	
	const lang = state.domCache.languageSelect ? state.domCache.languageSelect.value : 'en';
	const isSimpleMode = document.body.classList.contains('simple-mode');
	
	// Determine current state: if data-state is 'false', Virtual Bass is active
	const isVB = isSimpleMode ? false : toggle.getAttribute('data-state') === 'false';
	
	// Process elements defined in visibilityMap
	if (visibilityMap[section]) {
		for (const [key, { id, showWhen }] of Object.entries(visibilityMap[section])) {
			const container = state.domCache[id];
			if (container) {
				const isExpertOnly = container.classList.contains('expert-only');
				const shouldShow = showWhen(isSimpleMode, isVB, state.supportedFeatures);
				const isVisible = shouldShow && (!isSimpleMode || !isExpertOnly);
				
				if (isVisible) {
					// Remove inline style to let CSS handle it (e.g., display: grid !important)
					container.style.removeProperty('display');
					container.classList.add('visible');
				} else {
					// Force hide overriding any CSS !important rules
					container.style.setProperty('display', 'none', 'important');
					container.classList.remove('visible');
				}
				
				container.querySelectorAll('.slider-container').forEach(slider => {
					if (isVisible) {
						slider.style.removeProperty('display');
					} else {
						slider.style.setProperty('display', 'none', 'important');
					}
					
					const input = slider.querySelector('input[type="range"]');
					if (input) {
						if (isVisible) {
							input.style.removeProperty('display');
						} else {
							input.style.setProperty('display', 'none', 'important');
						}
					}
				});
			}
		}
	}
	
	const warningId = section === 'headphone' ? 'vb-warning-headphone' : 'vb-warning-speaker';
	const warning = state.domCache[warningId] || document.getElementById(warningId);
	
	if (warning) {
		const beKeys = ['bassboostContainer', 'basscutoffContainer', 'basswidthContainer'];
		const vbKeys = ['bassharmtypeContainer', 'bassharmmixfreqminContainer', 'bassharmmixfreqmaxContainer', 'bassharmsrcfreqminContainer', 'bassharmsrcfreqmaxContainer', 'hbassharmgenfreqmaxContainer','bassharmboostContainer', 'basslingainContainer', 'basscompstrengthContainer'];

		// Helper function to toggle elements visibility safely with !important
		const setGroupVisibility = (keys, show) => {
			keys.forEach(key => {
				const containerId = section === 'headphone' ? `h${key}` : `s${key}`;
				const container = state.domCache[containerId] || document.getElementById(containerId);
				
				if (container) {
					if (show) {
						container.style.removeProperty('display');
						container.classList.add('visible');
					} else {
						container.style.setProperty('display', 'none', 'important');
						container.classList.remove('visible');
					}
					
					container.querySelectorAll('.slider-container').forEach(slider => {
						if (show) {
							slider.style.removeProperty('display');
						} else {
							slider.style.setProperty('display', 'none', 'important');
						}
						
						const input = slider.querySelector('input[type="range"]');
						if (input) {
							if (show) {
								input.style.removeProperty('display');
							} else {
								input.style.setProperty('display', 'none', 'important');
							}
						}
					});
				}
			});
		};

		// Hardware limitations override vs Standard toggle logic
		if (!state.supportedFeatures.harm && !isSimpleMode) {
			warning.textContent = state.translations[lang]['vb_unsupported'] || 'Virtual Bass is unsupported, use Bass Enhancer';
			warning.style.display = 'inline';
			toggle.setAttribute('data-state', 'true');
			toggle.textContent = state.translations[lang]['bass_enhancer'];
			toggle.disabled = true;
			
			// Force Bass Enhancer visibility, hide Virtual Bass completely
			setGroupVisibility(beKeys, true);
			setGroupVisibility(vbKeys, false);
		} else {
			warning.style.display = 'none';
			toggle.disabled = isSimpleMode;
			toggle.textContent = isVB ? state.translations[lang]['virtual_bass'] : state.translations[lang]['bass_enhancer'];
			
			// Apply dynamic visibility based on current toggle state
			// Bass Enhancer is always visible, Virtual Bass relies on the toggle
			setGroupVisibility(beKeys, true); 
			setGroupVisibility(vbKeys, isVB);
		}
	}
	
	const sectionElement = state.domCache[section === 'headphone' ? 'bass-boost-section' : 'sbass-boost-section'];
	if (sectionElement) {
		console.log(`Parent section ${sectionElement.id} visible: ${sectionElement.classList.contains('visible')}`);
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
	
	const sliders = ['hbassboost', 'hbasscutoff', 'hbassharmtype', 'hbasswidth', 'hbassharmmixfreqmin', 'hbassharmmixfreqmax', 'hbassharmgenfreqmax',
					'hbassharmsrcfreqmin', 'hbassharmsrcfreqmax', 'hbassharmboost', 'hbasslingain', 'hbasscompstrength', 
					'sbassboost', 'sbassharmboost', 'sbasslingain', 'sbasscompstrength'];
	sliders.forEach(id => {
		const slider = getDomElement(id);
		if (slider) {
			// Track previous value for each slider independently
			let prevValue = slider.value;

			slider.addEventListener('input', () => {
				// Skip zero value for specific sliders, this case is bass linear gain, as 0 is disabling harmonics completely
				if ((id === 'hbasslingain' || id === 'sbasslingain') && slider.value == 0) {
					slider.value = prevValue > 0 ? -1 : 1;
				}
				
				// Update previous value for the next input event
				prevValue = slider.value;

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