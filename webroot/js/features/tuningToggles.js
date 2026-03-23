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

	/* 1. Clear inline styles and remove active classes from both */
	if (hpSection) {
		hpSection.style.display = ''; 
		hpSection.classList.remove('active-view');
	}
	if (spSection) {
		spSection.style.display = '';
		spSection.classList.remove('active-view');
	}
	
	/* 2. Add active-view class to trigger CSS display:block and fadeIn animation */
	if (newSection === 'headphone' && hpSection) {
		hpSection.classList.add('active-view');
	} else if (newSection === 'speaker' && spSection) {
		spSection.classList.add('active-view');
	}
	
	/* 3. Update the bottom navigation visual state */
	if (hpTab) hpTab.classList.toggle('active', newSection === 'headphone');
	if (spTab) spTab.classList.toggle('active', newSection === 'speaker');
	
	updateOutputVisibility();
};

export const initTuningToggles = () => {
	const hpTab = getDomElement('headphone-toggle');
	const spTab = getDomElement('speaker-toggle');

	/* Attach modern event listeners instead of inline HTML onclick */
	if (hpTab) {
		hpTab.addEventListener('click', (e) => {
			e.preventDefault();
			switchActiveSection('headphone');
			updateOutput(); 
		});
	}

	if (spTab) {
		spTab.addEventListener('click', (e) => {
			e.preventDefault();
			switchActiveSection('speaker');
			updateOutput(); 
		});
	}

	/* Initial load state */
	const initialSection = state.configValues?.headphonetuning === 'YES' ? 'headphone' : 'speaker';
	switchActiveSection(initialSection);

	console.log('Headphone/Speaker View initialized.');
};