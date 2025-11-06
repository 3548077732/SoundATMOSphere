import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertToLanguageNumerals } from '../shared/language.js';
import { updateOutput } from '../view/renderer.js';

export const initVolBoost = () => {
    const lang = state.domCache.languageSelect?.value || 'en';

    // Headphone volume boost
    const hVolBoost = getDomElement('hvolboost');
    if (hVolBoost) {
        hVolBoost.addEventListener('input',() => {
            const valueDisplay = getDomElement('hvolboost-value');
            if (valueDisplay) {
                valueDisplay.textContent = convertToLanguageNumerals(hVolBoost.value, lang) + ' dB';
            }
            updateOutput();
        });
    }

    // Speaker volume boost
    const sVolBoost = getDomElement('svolboost');
    if (sVolBoost) {
        sVolBoost.addEventListener('input',() => {
            const valueDisplay = getDomElement('svolboost-value');
            if (valueDisplay) {
                valueDisplay.textContent = convertToLanguageNumerals(sVolBoost.value, lang) + ' dB';
            }
            updateOutput();
        });
    }
};