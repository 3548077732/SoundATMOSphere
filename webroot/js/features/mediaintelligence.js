import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { updateOutput } from '../view/renderer.js';

export const initMediaIntelligence = () => {
    const lang = state.domCache.languageSelect?.value || 'en';

    // 1. Stwórz listę wszystkich ID, które chcesz obsłużyć
    const toggleIds = [
        'dolbymidvlev',
        'dolbymiieq',
        'dolbymisurcomp',
        'dolbymiadaptvirt', // Zauważyłem tu literówkę "dolbmi..." - upewnij się, że jest poprawna
        'dolbymivirtbin',
        'dolbymidialenh'
    ];

    // 2. Przejdź pętlą po każdym ID
    toggleIds.forEach(id => {
        // Użycie "const toggle" tutaj jest bezpieczne, 
        // ponieważ każda iteracja pętli tworzy nowy, oddzielny zakres
        const toggle = getDomElement(id);

        if (toggle) {
            // 3. Przypisz każdemu ten sam event listener
            toggle.addEventListener('click', () => {
                const isOn = toggle.getAttribute('data-state') === 'true';
                const newState = !isOn; // Zapisz nowy stan do zmiennej dla czytelności

                toggle.setAttribute('data-state', newState);
                toggle.textContent = newState ? state.translations[lang]['on'] : state.translations[lang]['off'];
                toggle.classList.toggle('active', newState);
                updateOutput();
            });
        }
    });
};