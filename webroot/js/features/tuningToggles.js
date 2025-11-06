import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { updateOutput, updateOutputVisibility } from '../view/renderer.js';

const HEADPHONE_SECTION_ID = 'headphone-group'; 
const SPEAKER_SECTION_ID = 'speaker-group';     

const switchActiveSection = (newSection) => {
    state.currentSection = newSection; 

    const hpSection = getDomElement(HEADPHONE_SECTION_ID);
    const spSection = getDomElement(SPEAKER_SECTION_ID);
    
    const hpTab = getDomElement('headphone-toggle');
    const spTab = getDomElement('speaker-toggle');

    if (hpSection) {
        hpSection.style.display = newSection === 'headphone' ? 'block' : 'none';
    }
    if (spSection) {
        spSection.style.display = newSection === 'speaker' ? 'block' : 'none';
    }
    
    if (hpTab) hpTab.classList.toggle('active', newSection === 'headphone');
    if (spTab) spTab.classList.toggle('active', newSection === 'speaker');
    updateOutputVisibility();
};

export const initTuningToggles = () => {
    const hpTab = getDomElement('headphone-toggle');
    const spTab = getDomElement('speaker-toggle');

    if (hpTab) {
        hpTab.addEventListener('click', () => {
            switchActiveSection('headphone');
            updateOutput(); 
        });
    }

    if (spTab) {
        spTab.addEventListener('click', () => {
            switchActiveSection('speaker');
            updateOutput(); 
        });
    }

    const initialSection = state.configValues.headphonetuning === 'YES' ? 'headphone' : 'speaker';
    switchActiveSection(initialSection);

    console.log('Headphone/Speaker View initialized.');
};