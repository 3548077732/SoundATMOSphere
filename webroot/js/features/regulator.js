import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { updateOutput } from '../view/renderer.js';

export const initRegulator = () => {
    const lang = state.domCache.languageSelect?.value || 'en';

    // Regulator toggle
    const hRegToggle = getDomElement('hregulator');
    if (hRegToggle) {
        hRegToggle.addEventListener('click', () => {
            const isOn = hRegToggle.getAttribute('data-state') === 'true';
            hRegToggle.setAttribute('data-state', !isOn);
            hRegToggle.textContent = !isOn ? state.translations[lang]['on'] : state.translations[lang]['off'];
            hRegToggle.classList.toggle('active', !isOn);
            updateOutput();
        });
    }

    // Overdrive slider
    const hRegOverdrive = getDomElement('hregoverdrive');
    if (hRegOverdrive) {
        hRegOverdrive.addEventListener('input', () => {
            const valueDisplay = getDomElement('hregoverdrive-value');
            if (valueDisplay) {
                valueDisplay.textContent = convertToLanguageNumerals(hRegOverdrive.value, lang);
            }
            updateOutput();
        });
    }

    // Timbre select
    const hTimbre = getDomElement('htimbre');
    if (hTimbre) {
        hTimbre.addEventListener('change', () => {
            updateOutput();
        });
    }

    const sTimbre = getDomElement('stimbre');
    if (sTimbre) {
        sTimbre.addEventListener('change', () => {
            updateOutput();
        });
    }
};