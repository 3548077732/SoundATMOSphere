import { state } from '../shared/state.js';
import { getDomElement } from '../shared/dom.js';
import { convertFromLanguageNumerals } from '../shared/language.js';
import { getAdvancedRendererValue } from '../shared/utils.js';

export const defaultValues = {
	dolbymidvlev: 'OFF',
	dolbymiieq: 'OFF',
	dolbymisurcomp: 'OFF',
	dolbymiadaptvirt: 'OFF',
	dolbymivirtbin: 'OFF',
	dolbymidialenh: 'OFF',
    headphonetuning: 'YES',
    hieq: 'B',
    hieqstr: '6',
    hiet_47: '150',
    hiet_141: '142',
    hiet_234: '188',
    hiet_328: '216',
    hiet_469: '189',
    hiet_656: '195',
    hiet_844: '202',
    hiet_1031: '199',
    hiet_1313: '210',
    hiet_1688: '225',
    hiet_2250: '230',
    hiet_3000: '236',
    hiet_3750: '235',
    hiet_4688: '235',
    hiet_5813: '214',
    hiet_7125: '165',
    hiet_9000: '112',
    hiet_11250: '49',
    hiet_13875: '-24',
    hiet_19688: '-217',
    hieqstr: '6',
	heq_47: '0',
    heq_141: '0',
    heq_234: '0',
    heq_328: '0',
    heq_469: '0',
    heq_656: '0',
    heq_844: '0',
    heq_1031: '0',
    heq_1313: '0',
    heq_1688: '0',
    heq_2250: '0',
    heq_3000: '0',
    heq_3750: '0',
    heq_4688: '0',
    heq_5813: '0',
    heq_7125: '0',
    heq_9000: '0',
    heq_11250: '0',
    heq_13875: '0',
    heq_19688: '0',
	heqpreset: 'flat',
    hrenderbass: 'VB',
    hbassboost: '6',
    hbasscutoff: '90',
    hbasswidth: '16',
    hbassharmtype: '2',
    hbassharmmixfreqmin: '10',
    hbassharmmixfreqmax: '90',
    hbassharmsrcfreqmin: '10',
    hbassharmsrcfreqmax: '90',
    hbassharmboost: '6',
    hbasslingain: '7',
    hvolboost: '0',
    hde: '0',
    hdea: '6',
    hded: '0',
    hvirtdist: '40',
    hsurboost: '3',
    hvirtualizer: '1',
    hadvirtangle: '90',
    hvirtmod: '2',
    hadvirtrend: '160,85000,42000,12000,0,1,1,1',
    hheightfilter: '1',
    hleveler: 'OFF',
    hlevstr: '3',
    hlevamount: '0',
    hlevtargetin: '6',
    hlevtargetout: '6',
    hregulator: 'ON',
    hregoverdrive: '0',
    htimbre: '2',
	htunedrate: '48000',
	h_output_channels: '2',
    speakertuning: 'YES',
    sieq: 'B',
    sieqstr: '6',
    srenderbass: 'VB',
    sbassboost: '6',
    sbassharmtype: '3',
    sbassharmboost: '2',
    sbasslingain: '6',
    svolboost: '0',
    sde: '0',
    sdea: '6',
    sded: '0',
    ssurboost: '3',
    svirtualizer: '1',
    svirtmod: '2',
    sadvirtrend: '103,32568,11164,5090,0,3,3,3',
    sleveler: 'OFF',
    slevstr: '3',
    slevamount: '0',
    slevtargetin: '6',
    slevtargetout: '6',
    stimbre: '2',
	stunedrate: '48000',
	s_output_channels: '2'
};

export const equalizerPresets = {
    flat: '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
    bass_emphasis: '6,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
    treble_emphasis: '0,0,0,0,0,0,0,0,0,0,0,0,0,2,4,6,6,4,3,2',
    vocal_clarity: '0,0,0,1,2,3,4,5,6,6,5,4,3,2,1,0,0,0,0,0',
    pop_rock: '6,4,2,0,0,0,1,2,3,3,2,1,0,0,2,3,4,3,2,1',
    electro_dance: '8,6,4,2,0,0,0,0,0,0,0,0,0,1,3,5,6,5,3,2',
    edm: '8,7,5,3,1,0,0,0,0,1,2,2,1,0,2,4,6,5,4,2',
    drum_bass: '7,6,4,2,0,0,1,2,2,1,0,0,1,2,3,4,5,4,3,1',
    classical_acoustic: '2,1,0,0,1,2,3,3,2,1,0,0,1,2,3,2,1,1,0,0',
    metal: '6,5,3,2,1,0,1,2,3,4,4,3,2,1,2,3,4,3,2,1',
    reggae: '7,6,4,2,1,0,0,1,2,3,3,2,1,0,0,1,2,2,1,0',
    loudness: '4,3,2,1,0,0,1,2,3,4,4,3,2,2,3,4,5,4,3,2',
    custom: '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0'
};

export const configMap = {
	
    DOLBYMIDVLEV: { id: 'dolbymidvlev', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    DOLBYMIIEQ: { id: 'dolbymiieq', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    DOLBYMISURCOMP: { id: 'dolbymisurcomp', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    DOLBYMIADAPTVIRT: { id: 'dolbymiadaptvirt', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    DOLBYMIVIRTBIN: { id: 'dolbymivirtbin', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    DOLBYMIDIALENH: { id: 'dolbymidialenh', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    HEADPHONETUNING: { id: 'headphonetuning', type: 'toggle', default: 'YES', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'YES' : 'NO' },
    HIEQ: { id: 'hieq', type: 'select', default: 'B' },
    HIEQSTR: { id: 'hieqstr', type: 'range', default: '6' },
	HEQPRESET: { id: 'heqpreset', type: 'select', default: 'flat', transform: (el) => el ? el.value : 'flat' },
	HIEQ: { id: 'hieq', type: 'select', default: 'B', transform: (el) => el ? el.value : 'B' },
    HIET_47: { id: 'hiet47', type: 'text', default: '150', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_47'] : (parseFloat(state.hieqCustomValues.split(',')[0]) || 150) },
    HIET_141: { id: 'hiet141', type: 'text', default: '142', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_141'] : (parseFloat(state.hieqCustomValues.split(',')[1]) || 142) },
    HIET_234: { id: 'hiet234', type: 'text', default: '188', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_234'] : (parseFloat(state.hieqCustomValues.split(',')[2]) || 188) },
    HIET_328: { id: 'hiet328', type: 'text', default: '216', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_328'] : (parseFloat(state.hieqCustomValues.split(',')[3]) || 216) },
    HIET_469: { id: 'hiet469', type: 'text', default: '189', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_469'] : (parseFloat(state.hieqCustomValues.split(',')[4]) || 189) },
    HIET_656: { id: 'hiet656', type: 'text', default: '195', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_656'] : (parseFloat(state.hieqCustomValues.split(',')[5]) || 195) },
    HIET_844: { id: 'hiet844', type: 'text', default: '202', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_844'] : (parseFloat(state.hieqCustomValues.split(',')[6]) || 202) },
    HIET_1031: { id: 'hiet1031', type: 'text', default: '199', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_1031'] : (parseFloat(state.hieqCustomValues.split(',')[7]) || 199) },
    HIET_1313: { id: 'hiet1313', type: 'text', default: '210', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_1313'] : (parseFloat(state.hieqCustomValues.split(',')[8]) || 210) },
    HIET_1688: { id: 'hiet1688', type: 'text', default: '225', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_1688'] : (parseFloat(state.hieqCustomValues.split(',')[9]) || 225) },
    HIET_2250: { id: 'hiet2250', type: 'text', default: '230', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_2250'] : (parseFloat(state.hieqCustomValues.split(',')[10]) || 230) },
    HIET_3000: { id: 'hiet3000', type: 'text', default: '236', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_3000'] : (parseFloat(state.hieqCustomValues.split(',')[11]) || 236) },
    HIET_3750: { id: 'hiet3750', type: 'text', default: '235', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_3750'] : (parseFloat(state.hieqCustomValues.split(',')[12]) || 235) },
    HIET_4688: { id: 'hiet4688', type: 'text', default: '235', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_4688'] : (parseFloat(state.hieqCustomValues.split(',')[13]) || 235) },
    HIET_5813: { id: 'hiet5813', type: 'text', default: '214', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_5813'] : (parseFloat(state.hieqCustomValues.split(',')[14]) || 214) },
    HIET_7125: { id: 'hiet7125', type: 'text', default: '165', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_7125'] : (parseFloat(state.hieqCustomValues.split(',')[15]) || 165) },
    HIET_9000: { id: 'hiet9000', type: 'text', default: '112', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_9000'] : (parseFloat(state.hieqCustomValues.split(',')[16]) || 112) },
    HIET_11250: { id: 'hiet11250', type: 'text', default: '49', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_11250'] : (parseFloat(state.hieqCustomValues.split(',')[17]) || 49) },
    HIET_13875: { id: 'hiet13875', type: 'text', default: '-24', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_13875'] : (parseFloat(state.hieqCustomValues.split(',')[18]) || -24) },
    HIET_19688: { id: 'hiet19688', type: 'text', default: '-217', transform: (el) => state.domCache.hieq?.value !== 'C' ? defaultValues['hiet_19688'] : (parseFloat(state.hieqCustomValues.split(',')[19]) || -217) },
	HEQ_47: { id: 'heq47', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[0] : (parseFloat(state.heqCustomValues.split(',')[0] || '0')) },
	HEQ_141: { id: 'heq141', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[1] : (parseFloat(state.heqCustomValues.split(',')[1] || '0')) },
	HEQ_234: { id: 'heq234', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[2] : (parseFloat(state.heqCustomValues.split(',')[2] || '0')) },
	HEQ_328: { id: 'heq328', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[3] : (parseFloat(state.heqCustomValues.split(',')[3] || '0')) },
	HEQ_469: { id: 'heq469', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[4] : (parseFloat(state.heqCustomValues.split(',')[4] || '0')) },
	HEQ_656: { id: 'heq656', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[5] : (parseFloat(state.heqCustomValues.split(',')[5] || '0')) },
	HEQ_844: { id: 'heq844', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[6] : (parseFloat(state.heqCustomValues.split(',')[6] || '0')) },
	HEQ_1031: { id: 'heq1031', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[7] : (parseFloat(state.heqCustomValues.split(',')[7] || '0')) },
	HEQ_1313: { id: 'heq1313', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[8] : (parseFloat(state.heqCustomValues.split(',')[8] || '0')) },
	HEQ_1688: { id: 'heq1688', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[9] : (parseFloat(state.heqCustomValues.split(',')[9] || '0')) },
	HEQ_2250: { id: 'heq2250', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[10] : (parseFloat(state.heqCustomValues.split(',')[10] || '0')) },
	HEQ_3000: { id: 'heq3000', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[11] : (parseFloat(state.heqCustomValues.split(',')[11] || '0')) },
	HEQ_3750: { id: 'heq3750', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[12] : (parseFloat(state.heqCustomValues.split(',')[12] || '0')) },
	HEQ_4688: { id: 'heq4688', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[13] : (parseFloat(state.heqCustomValues.split(',')[13] || '0')) },
	HEQ_5813: { id: 'heq5813', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[14] : (parseFloat(state.heqCustomValues.split(',')[14] || '0')) },
	HEQ_7125: { id: 'heq7125', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[15] : (parseFloat(state.heqCustomValues.split(',')[15] || '0')) },
	HEQ_9000: { id: 'heq9000', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[16] : (parseFloat(state.heqCustomValues.split(',')[16] || '0')) },
	HEQ_11250: { id: 'heq11250', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[17] : (parseFloat(state.heqCustomValues.split(',')[17] || '0')) },
	HEQ_13875: { id: 'heq13875', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[18] : (parseFloat(state.heqCustomValues.split(',')[18] || '0')) },
	HEQ_19688: { id: 'heq19688', type: 'range', default: '0', transform: (el) => state.domCache.heqpreset?.value !== 'custom' ? equalizerPresets[state.domCache.heqpreset?.value || 'flat'].split(',')[19] : (parseFloat(state.heqCustomValues.split(',')[19] || '0')) },
    HRENDERBASS: { id: 'hrenderbass', type: 'toggle', default: 'VB', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'BE' : 'VB' },
    HBASSBOOST: { id: 'hbassboost', type: 'range', default: '6' },
    HBASSCUTOFF: { id: 'hbasscutoff', type: 'range', default: '90' },
    HBASSWIDTH: { id: 'hbasswidth', type: 'range', default: '16' },
    HBASSHARMTYPE: { id: 'hbassharmtype', type: 'select', default: '2' },
    HBASSHARMMIXFREQMIN: { id: 'hbassharmmixfreqmin', type: 'range', default: '10' },
    HBASSHARMMIXFREQMAX: { id: 'hbassharmmixfreqmax', type: 'range', default: '90' },
    HBASSHARMSRCFREQMIN: { id: 'hbassharmsrcfreqmin', type: 'range', default: '10' },
    HBASSHARMSRCFREQMAX: { id: 'hbassharmsrcfreqmax', type: 'range', default: '90' },
    HBASSHARMBOOST: { id: 'hbassharmboost', type: 'range', default: '6' },
    HBASSLINGAIN: { id: 'hbasslingain', type: 'range', default: '7' },
    HVOLBOOST: { id: 'hvolboost', type: 'range', default: '0' },
    HDE: { id: 'hde', type: 'select', default: '0' },
    HDEA: { id: 'hdea', type: 'range', default: '6' },
    HDED: { id: 'hded', type: 'range', default: '0' },
    HVIRTDIST: { id: 'hvirtdist', type: 'range', default: '40' },
    HSURBOOST: { id: 'hsurboost', type: 'range', default: '3' },
    HVIRTUALIZER: { id: 'hvirtualizer', type: 'select', default: '1' },
    HADVIRTANGLE: { id: 'hadvirtangle', type: 'range', default: '90' },
    HVIRTMOD: { id: 'hvirtmod', type: 'select', default: '2' },
    HADVIRTREND: { id: 'hadvirtrend', type: 'select', default: '160,85000,42000,12000,0,1,1,1', transform: (el) => { if (el && el.value && el.value !== 'custom') { return el.value; } return state.hadvirtrend; } },
    HHEIGHTFILTER: { id: 'hheightfilter', type: 'select', default: '1' },
    HLEVELER: { id: 'hleveler', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    HLEVSTR: { id: 'hlevstr', type: 'range', default: '3' },
    HLEVAMOUNT: { id: 'hlevamount', type: 'range', default: '0' },
    HLEVTARGETIN: { id: 'hlevtargetin', type: 'range', default: '6' },
    HLEVTARGETOUT: { id: 'hlevtargetout', type: 'range', default: '6' },
    HREGULATOR: { id: 'hregulator', type: 'toggle', default: 'ON', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    HREGOVERDRIVE: { id: 'hregoverdrive', type: 'range', default: '0' },
    HTIMBRE: { id: 'htimbre', type: 'select', default: '2' },
	HTUNEDRATE: { id: 'htunedrate', type: 'select', default: '48000' },
	H_OUTPUT_CHANNELS: { id: 'h_output_channels', type: 'select', default: '2' },
    SPEAKERTUNING: { id: 'speakertuning', type: 'toggle', default: 'YES', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'YES' : 'NO' },
    SIEQ: { id: 'sieq', type: 'select', default: 'B' },
    SIEQSTR: { id: 'sieqstr', type: 'range', default: '6' },
    SRENDERBASS: { id: 'srenderbass', type: 'toggle', default: 'VB', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'BE' : 'VB' },
    SBASSBOOST: { id: 'sbassboost', type: 'range', default: '6' },
    SBASSHARMTYPE: { id: 'sbassharmtype', type: 'select', default: '3' },
    SBASSHARMBOOST: { id: 'sbassharmboost', type: 'range', default: '2' },
    SBASSLINGAIN: { id: 'sbasslingain', type: 'range', default: '6' },
    SVOLBOOST: { id: 'svolboost', type: 'range', default: '0' },
    SDE: { id: 'sde', type: 'select', default: '0' },
    SDEA: { id: 'sdea', type: 'range', default: '6' },
    SDED: { id: 'sded', type: 'range', default: '0' },
    SSURBOOST: { id: 'ssurboost', type: 'range', default: '3' },
    SVIRTUALIZER: { id: 'svirtualizer', type: 'select', default: '1' },
    SVIRTMOD: { id: 'svirtmod', type: 'select', default: '2' },
    SADVIRTREND: { id: 'sadvirtrend', type: 'select', default: '103,32568,11164,5090,0,3,3,3', transform: (el) => { if (el && el.value && el.value !== 'custom') { return el.value; } return state.sadvirtrend; } },
    SLEVELER: { id: 'sleveler', type: 'toggle', default: 'OFF', transform: (el) => el && el.getAttribute('data-state') === 'true' ? 'ON' : 'OFF' },
    SLEVSTR: { id: 'slevstr', type: 'range', default: '3' },
    SLEVAMOUNT: { id: 'slevamount', type: 'range', default: '0' },
    SLEVTARGETIN: { id: 'slevtargetin', type: 'range', default: '6' },
    SLEVTARGETOUT: { id: 'slevtargetout', type: 'range', default: '6' },
    STIMBRE: { id: 'stimbre', type: 'select', default: '2' },
	STUNEDRATE: { id: 'stunedrate', type: 'select', default: '48000' },
	S_OUTPUT_CHANNELS: { id: 's_output_channels', type: 'select', default: '2' }
};

export const visibilityMap = {
    headphone: {
		ieqCustomInput: { id: 'hieqCustomInput', showWhen: () => state.domCache.hieq?.value === 'C' },
        bassboostContainer: { id: 'hbassboostContainer', showWhen: (isVB, features) => !isVB },
        basscutoffContainer: { id: 'hbasscutoffContainer', showWhen: (isVB, features) => !isVB },
        basswidthContainer: { id: 'hbasswidthContainer', showWhen: (isVB, features) => !isVB },
        bassharmtypeContainer: { id: 'hbassharmtypeContainer', showWhen: (isVB, features) => isVB && features.harm },
        bassharmmixfreqminContainer: { id: 'hbassharmmixfreqminContainer', showWhen: (isVB, features) => isVB && features.harm },
        bassharmmixfreqmaxContainer: { id: 'hbassharmmixfreqmaxContainer', showWhen: (isVB, features) => isVB && features.harm },
        bassharmsrcfreqminContainer: { id: 'hbassharmsrcfreqminContainer', showWhen: (isVB, features) => isVB && features.harm },
        bassharmsrcfreqmaxContainer: { id: 'hbassharmsrcfreqmaxContainer', showWhen: (isVB, features) => isVB && features.harm },
        bassharmboostContainer: { id: 'hbassharmboostContainer', showWhen: (isVB, features) => isVB && features.harm },
        basslingainContainer: { id: 'hbasslingainContainer', showWhen: (isVB, features) => isVB && features.harm },
        advirtangleContainer: { id: 'hadvirtangleContainer', showWhen: (isSimpleMode) => !isSimpleMode && state.supportedFeatures.angle },
        advirtdistContainer: { id: 'hvirtdistContainer', showWhen: (isSimpleMode) => !isSimpleMode && state.supportedFeatures.distance },
        advirtrendContainer: { id: 'hadvirtrendContainer', showWhen: (isSimpleMode) => !isSimpleMode && state.supportedFeatures.advancedvirt },
        virtmodContainer: { id: 'hvirtmodContainer', showWhen: (isSimpleMode) => !isSimpleMode && state.supportedFeatures.hvirtmode },
        ieqstrContainer: { id: 'hieqstrContainer', showWhen: () => true },
        eqPreset: { id: 'heqpreset', showWhen: () => true },
        deContainer: { id: 'hdeContainer', showWhen: () => true },
        deaContainer: { id: 'hdeaContainer', showWhen: () => true },
        dedContainer: { id: 'hdedContainer', showWhen: () => true },
        virtualizerContainer: { id: 'hvirtualizerContainer', showWhen: () => true },
        surboostContainer: { id: 'hsurboostContainer', showWhen: () => true  },
        heightfilterContainer: { id: 'hheightfilterContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levstrContainer: { id: 'hlevstrContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levamountContainer: { id: 'hlevamountContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levtargetinContainer: { id: 'hlevtargetinContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levtargetoutContainer: { id: 'hlevtargetoutContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        regulatorContainer: { id: 'hregulatorContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        regoverdriveContainer: { id: 'hregoverdriveContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        timbreContainer: { id: 'htimbreContainer', showWhen: () => true },
		tunedrateContainer: { id: 'htunedrateContainer', showWhen: (isSimpleMode) => !isSimpleMode },
		output_channelsContainer: { id: 'h_output_channelsContainer', showWhen: (isSimpleMode) => !isSimpleMode }
    },
    speaker: {
        bassboostContainer: { id: 'sbassboostContainer', showWhen: (isVB, features) => !isVB },
        basscutoffContainer: { id: 'sbasscutoffContainer', showWhen: (isVB, features) => !isVB },
        basswidthContainer: { id: 'sbasswidthContainer', showWhen: (isVB, features) => !isVB },
        bassharmtypeContainer: { id: 'sbassharmtypeContainer', showWhen: (isVB, features) => isVB && features.harm },
        bassharmboostContainer: { id: 'sbassharmboostContainer', showWhen: (isVB, features) => isVB && features.harm },
        basslingainContainer: { id: 'sbasslingainContainer', showWhen: (isVB, features) => isVB && features.harm },
        advirtrendContainer: { id: 'sadvirtrendContainer', showWhen: (isSimpleMode) => !isSimpleMode && state.supportedFeatures.sadvancedvirt },
        virtmodContainer: { id: 'svirtmodContainer', showWhen: (isSimpleMode) => !isSimpleMode && state.supportedFeatures.svirtmode },
        ieqstrContainer: { id: 'sieqstrContainer', showWhen: () => true },
        deContainer: { id: 'sdeContainer', showWhen: () => true },
        deaContainer: { id: 'sdeaContainer', showWhen: () => true },
        dedContainer: { id: 'sdedContainer', showWhen: () => true },
        virtualizerContainer: { id: 'svirtualizerContainer', showWhen: () => true },
        surboostContainer: { id: 'ssurboostContainer', showWhen: () => true },
        levstrContainer: { id: 'slevstrContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levamountContainer: { id: 'slevamountContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levtargetinContainer: { id: 'slevtargetinContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        levtargetoutContainer: { id: 'slevtargetoutContainer', showWhen: (isSimpleMode) => !isSimpleMode },
        timbreContainer: { id: 'stimbreContainer', showWhen: () => true },
		tunedrateContainer: { id: 'stunedrateContainer', showWhen: (isSimpleMode) => !isSimpleMode },
		output_channelsContainer: { id: 's_output_channelsContainer', showWhen: (isSimpleMode) => !isSimpleMode }
    }
};

export const translationMaps = {
    bassHarmType: { '1': 'first_harmonic', '2': 'more_harmonics', '3': 'extra_harmonics' },
    virtMod: { '1': 'center_oriented', '2': 'expanded' },
    dialogEnhancer: { '0': 'off', '1': 'movie_profile_only', '2': 'all_profiles' },
    ieq: { 'B': 'balanced', 'D': 'detailed', 'W': 'warm', 'N': 'no_ieq' },
    heightFilter: { '0': 'off', '1': 'slightly_elevated', '2': 'more_elevated' },
    advVirtRend: {
        '103,32568,11164,5090,0,3,3,3': 'stock',
        '160,32767,14379,7090,2,2,3,1': 'option_1',
        '200,32767,16379,7090,3,3,3,1': 'option_2',
        '160,32767,16379,2065,0,3,3,0': 'motorola_spatializer',
        '103,32568,11164,5090,0,1,2,2': 'xiaomi_15_spatializer',
        '200,32568,15164,8090,1,2,2,1': 'ShadoV_favorite_1',
        '200,32568,15164,8090,1,2,3,1': 'ShadoV_favorite_2',
        '160,85000,42000,12000,0,1,1,1': 'ShadoV_favorite_3'
    },
    timbre: { '1': 'level_1', '2': 'level_2', '3': 'level_3', '4': 'level_4' }
};

const heqDefaultKeys = [
    'heq_47', 'heq_141', 'heq_234', 'heq_328', 'heq_469', 'heq_656', 'heq_844', 
    'heq_1031', 'heq_1313', 'heq_1688', 'heq_2250', 'heq_3000', 'heq_3750', 
    'heq_4688', 'heq_5813', 'heq_7125', 'heq_9000', 'heq_11250', 'heq_13875', 'heq_19688'
];

const hietDefaultKeys = [
    'hiet_47', 'hiet_141', 'hiet_234', 'hiet_328', 'hiet_469', 'hiet_656', 
    'hiet_844', 'hiet_1031', 'hiet_1313', 'hiet_1688', 'hiet_2250', 'hiet_3000', 
    'hiet_3750', 'hiet_4688', 'hiet_5813', 'hiet_7125', 'hiet_9000', 'hiet_11250', 
    'hiet_13875', 'hiet_19688'
];

defaultValues.heqCustomValues = heqDefaultKeys
    .map(key => defaultValues[key])
    .join(',');

defaultValues.hieqCustomValues = hietDefaultKeys
    .map(key => defaultValues[key])
    .join(',');

export const generateConfigString = () => {
    const config = {};
    const lang = state.domCache.languageSelect?.value || 'en';
    for (const [key, configEntry] of Object.entries(configMap)) {
    const el = state.domCache[configEntry.id];
    let value;

    if (!el) {
        console.warn(`generateConfigString: Element not found for key=${key}, id=${configEntry.id}, using default.`);
        value = configEntry.default;
    } else if (configEntry.transform) {
        value = configEntry.transform(el);
    } else {
        value = configEntry.type === 'toggle' ? el.getAttribute('data-state') : el.value;
    }

    if (value === null || value === undefined || value === '') {
        console.warn(`generateConfigString: Value for key=${key} was invalid, empty, or null. Falling back to default: ${configEntry.default}`);
        value = configEntry.default;
    }

    if (configEntry.type === 'range') {
        const converted = convertFromLanguageNumerals(value.toString(), lang);
        const parsed = parseFloat(converted);
        if (isNaN(parsed)) {
            console.warn(`generateConfigString: NaN detected for key=${key}, rawValue=${value}, converted=${converted}, using default=${configEntry.default}`);
            value = parseFloat(configEntry.default);
        } else {
            value = parsed;
        }
    }
    config[key.toLowerCase()] = value.toString();
    }
    return `
V=55
### Dolby tuning DIY
#Blank or wrong filled variable will cause setting default value

-----------------------------------
#########################
### HEADPHONE SECTION ###
#########################
-----------------------------------

# Dolby Media Intelligence 
# (Dolby choose values and parameters itself)
# should it be turned ON or OFF globally?
# Values [ON or OFF] (default OFF)

DOLBYMIDVLEV=${config.dolbymidvlev}
DOLBYMIIEQ=${config.dolbymiieq}
DOLBYMISURCOMP=${config.dolbymisurcomp}
DOLBYMIADAPTVIRT=${config.dolbymiadaptvirt}
DOLBYMIVIRTBIN=${config.dolbymivirtbin}
DOLBYMIDIALENH=${config.dolbymidialenh}

-----------------------------------

# Do you want to modify your headphones experience?
# Values [YES or NO] (default YES)

HEADPHONETUNING=${config.headphonetuning}

-----------------------------------

# Which Intelligent EQ preset you want? 
# (values B - balanced, D - detailed, W - Warm, C - Custom, N - no IEQ)
# (default and stock: B)

HIEQ=${config.hieq}

#INTELLIGENT EQUALIZER
# Values [-500 to 500]
# HIEQ must be set to "C" to freely change values

HIET_47=${parseFloat(config.hiet_47)}
HIET_141=${parseFloat(config.hiet_141)}
HIET_234=${parseFloat(config.hiet_234)}
HIET_328=${parseFloat(config.hiet_328)}
HIET_469=${parseFloat(config.hiet_469)}
HIET_656=${parseFloat(config.hiet_656)}
HIET_844=${parseFloat(config.hiet_844)}
HIET_1031=${parseFloat(config.hiet_1031)}
HIET_1313=${parseFloat(config.hiet_1313)}
HIET_1688=${parseFloat(config.hiet_1688)}
HIET_2250=${parseFloat(config.hiet_2250)}
HIET_3000=${parseFloat(config.hiet_3000)}
HIET_3750=${parseFloat(config.hiet_3750)}
HIET_4688=${parseFloat(config.hiet_4688)}
HIET_5813=${parseFloat(config.hiet_5813)}
HIET_7125=${parseFloat(config.hiet_7125)}
HIET_9000=${parseFloat(config.hiet_9000)}
HIET_11250=${parseFloat(config.hiet_11250)}
HIET_13875=${parseFloat(config.hiet_13875)}
HIET_19688=${parseFloat(config.hiet_19688)}

-----------------------------------

# How strong Intelligent EQ should be? 
# Generally values: 1-3 is weak, 4-6 is medium, 7-10 is strong, 10-15 is very strong, 16-20 is extreme
# ** stock values differ, mostly 3-8 **
# values [1-20] (default: 6)

HIEQSTR=${config.hieqstr}

-----------------------------------

# Headphone Equalizer Preset
# Values [flat, bass_emphasis, treble_emphasis, vocal_clarity, custom] (default: flat)

HEQPRESET=${config.heqpreset}

-----------------------------------

#EQUALIZER
# Values [-12 to 12] (default: 0 for all frequencies)
# HEQPRESET must be set to custom to freely change values

HEQ_47=${parseFloat(config.heq_47)}
HEQ_141=${parseFloat(config.heq_141)}
HEQ_234=${parseFloat(config.heq_234)}
HEQ_328=${parseFloat(config.heq_328)}
HEQ_469=${parseFloat(config.heq_469)}
HEQ_656=${parseFloat(config.heq_656)}
HEQ_844=${parseFloat(config.heq_844)}
HEQ_1031=${parseFloat(config.heq_1031)}
HEQ_1313=${parseFloat(config.heq_1313)}
HEQ_1688=${parseFloat(config.heq_1688)}
HEQ_2250=${parseFloat(config.heq_2250)}
HEQ_3000=${parseFloat(config.heq_3000)}
HEQ_3750=${parseFloat(config.heq_3750)}
HEQ_4688=${parseFloat(config.heq_4688)}
HEQ_5813=${parseFloat(config.heq_5813)}
HEQ_7125=${parseFloat(config.heq_7125)}
HEQ_9000=${parseFloat(config.heq_9000)}
HEQ_11250=${parseFloat(config.heq_11250)}
HEQ_13875=${parseFloat(config.heq_13875)}
HEQ_19688=${parseFloat(config.heq_19688)}

-----------------------------------

# Bass enhancer (BE) or Virtual Bass (VB)?
# values [BE or VB] (default: Virtual Bass)

HRENDERBASS=${config.hrenderbass}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# How strong Bass Enhancer boost you want?
# ** stock settings uses wide range, from 2 to 6 **
# values [0-30] (default: 6)

HBASSBOOST=${config.hbassboost}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# Where bass enhancer should cut its boost?
# ** stock settings uses wide range **
# values [10-200] (default: 90)

HBASSCUTOFF=${config.hbasscutoff}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# How broad Bass Enhancer boost you want around cutoff?
# ** stock settings mostly use ranges from 16 to 32 **
# values [1-128] (default: 16)

HBASSWIDTH=${config.hbasswidth}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Value 1 will render bass like in 1.16 (only first harmonic)
# Value 2 will boost bass with more harmonics
# Value 3 will also boost bass with even more harmonics
# Values [1-3] (default: 2)

HBASSHARMTYPE=${config.hbassharmtype}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Minimum frequency on which Virtual Bass will operate
# values [10-200] (default: 10)

HBASSHARMMIXFREQMIN=${config.hbassharmmixfreqmin}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Maximum frequency on which Virtual Bass will operate
# values [10-500] (default: 90)

HBASSHARMMIXFREQMAX=${config.hbassharmmixfreqmax}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Minimum source frequency for Virtual Bass harmonics
# values [10-200] (default: 10)

HBASSHARMSRCFREQMIN=${config.hbassharmsrcfreqmin}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Maximum source frequency for Virtual Bass harmonics
# values [10-500] (default: 90)

HBASSHARMSRCFREQMAX=${config.hbassharmsrcfreqmax}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# How strong Bass Harmonics boost you want?
# values [0-15] (default: 6)

HBASSHARMBOOST=${config.hbassharmboost}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Here you can set linear bass gain
# Values [0-20] (default: 7)

HBASSLINGAIN=${config.hbasslingain}

-----------------------------------

# Headphone Digital Volume booster
# How much in dB volume should be boosted?
# values [-15 to 15] (default and stock:0)

HVOLBOOST=${config.hvolboost}

-----------------------------------

# Dialog Enhancer. Should be turned on? or off?
# Value of 0 will turn off Dialog Enhancer
# Value of 1 will turn on Dialog Enhancer only for Movie profile
# Value of 2 will turn on Dialog Enhancer for every profile
# values [0-2] (default: 0)

HDE=${config.hde}

-----------------------------------

# This setting is working only with enabled Dialog Enhancer
# How strong Dialog Enhancer should be?
# values [1-10] (default: 6)

HDEA=${config.hdea}

-----------------------------------

# This setting is working only with enabled Dialog Enhancer
# How strong Dialog Enhancer ducking should be?
# values [0-10] (default: 0)

HDED=${config.hded}

-----------------------------------

# Choose how virtualizer setting should be set
# 0 - virtualizer will be off
# 1 - Virtualizer will be enabled in Movie preset and disabled in Music preset
# 2 - virtualizer will be enabled in every profile

HVIRTUALIZER=${config.hvirtualizer}

-----------------------------------

# This will set Virtualizer source distance 
# FOR SUPPORTED DOLBY
# values [4-100] (default: 40)

HVIRTDIST=${config.hvirtdist}

-----------------------------------

# Surround boost
# values [0-15] (default: 3)

HSURBOOST=${config.hsurboost}

-----------------------------------

# Headphone Advanced left-right Angle
# How wide (left-right angle) Virtualizer effect you want? 
# FOR SUPPORTED DOLBY
# values [45-90] (default: 90)

HADVIRTANGLE=${config.hadvirtangle}

-----------------------------------

# Which mode of Virtualizer effect you want?
# FOR SUPPORTED DOLBY
# Mode 1 means, Virtualizer is center oriented, soundscene is narrow.
# Mode 2 means, Virtualizer is much more expanded to sides.
# values [1 or 2] (default and stock: 2)

HVIRTMOD=${config.hvirtmod}

-----------------------------------

# Hadphone Advanced Virtualizer Renderer
# FOR ADVANCED USERS ONLY!
# THIS SETTING HAVE HUGE IMPACT ON VIRTUALIZER SOUNDSTAGE RENDERING
# FOR SUPPORTED DOLBY
#
# STOCK values are: 103,32568,11164,5090,0,3,3,3
# Some good and possible options:
# 160,32767,14379,7090,2,2,3,1
# 160,32767,16379,2065,0,3,3,0 - motorola spatializer 
# 103,32568,11164,5090,0,1,2,2 - xiaomi 15 spatializer
# 200,32767,16379,7090,3,3,3,1
# 200,32568,15164,8090,1,2,2,1 (one of my favorite)
# 200,32568,15164,8090,1,2,3,1 (also one of my favorite)
# 160,85000,42000,12000,0,1,1,1 (one of my favorite and currently used)
# I encourage to experiment but be careful with modifying it ^^

HADVIRTREND=${config.hadvirtrend}

-----------------------------------

# Which value of Virtualizer height filter effect you want?
# Value of 0 means, Virtualizer height filter is off.
# Value of 1 means, Virtualizer height filter is on, sound should be slightly elevated.
# Value of 2 means, Virtualizer height filter is on, sound should be more elevated.
# values [0-2] (default and stock: 1)

HHEIGHTFILTER=${config.hheightfilter}

-----------------------------------

# Should Volume Leveler be turned on or off? 
# values [ON or OFF] (default and stock: OFF)

HLEVELER=${config.hleveler}

-----------------------------------

# How strong volume boost with volume leveler should be? 
# values [0-10] (default: 3)

HLEVSTR=${config.hlevstr}

-----------------------------------

# This setting is working when Volume Leveler
# How fast HLEVELER should react?
# values [0-10] (default: 0)

HLEVAMOUNT=${config.hlevamount}

-----------------------------------

# FOR A BIT MORE ADVANCED USERS!
# This setting is working when Volume Leveler
# How aggressive volume leveler should be in attenuation peaks?
# values [1-10] (default and stock: 6)

HLEVTARGETIN=${config.hlevtargetin}

-----------------------------------

# FOR A BIT MORE ADVANCED USERS!
# This setting is working when Volume Leveler
# How aggressive volume leveler should be in modifying signal?
# values [1-10] (default and stock: 6)

HLEVTARGETOUT=${config.hlevtargetout}

-----------------------------------

# FOR A BIT MORE ADVANCED USERS!
# Regulator applies restrictions to overly gained signal
# values [ON or OFF] (default: ON)

HREGULATOR=${config.hregulator}

-----------------------------------

# FOR A BIT MORE ADVANCED USERS!
# Regulator overdrive let enhance signal above regulator restrictions
# values [0-10] (default: 0 stock: 0)

HREGOVERDRIVE=${config.hregoverdrive}

-----------------------------------

# How hard regulator should try to preserve timbre?
# values [1-4] (default and stock: 2)

HTIMBRE=${config.htimbre}

-----------------------------------

# To which samplerate should dolby tune itself?
# possible values [44100,48000,88200,96000,176400,192000,352800,384000] 
# (default and stock: 48000)

HTUNEDRATE=${config.htunedrate}

-----------------------------------

# Select amount of output channels
# values [1-8] (default and stock: 2)

H_OUTPUT_CHANNELS=${config.h_output_channels}

-----------------------------------
#########################
### SPEAKER SECTION ###
#########################
-----------------------------------

# Do you want to modify your Speaker experience?
# Values [YES or NO] (default YES)

SPEAKERTUNING=${config.speakertuning}

-----------------------------------

# Which Intelligent EQ preset you want? 
# (values B - balanced, D - detailed, W - Warm, N - no IEQ)
# (default and stock: B)

SIEQ=${config.sieq}

-----------------------------------

# How strong Intelligent EQ should be? 
# values [1-20] (default: 6)

SIEQSTR=${config.sieqstr}

-----------------------------------

# Bass enhancer (BE) or Virtual Bass (VB)?
# values [BE or VB] (default: Virtual Bass)

SRENDERBASS=${config.srenderbass}

-----------------------------------

# This parameter work ONLY with Bass Enhancer
# How strong Bass Enhancer boost you want?
# values [0-15] (default: 6)

SBASSBOOST=${config.sbassboost}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Value 1 will render bass like in 1.16 (only first harmonic)
# Value 2 will boost bass with more harmonics
# Value 3 will also boost bass with even more harmonics
# Values [1-3] (default: 3)

SBASSHARMTYPE=${config.sbassharmtype}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# How strong Bass Harmonics boost you want?
# values [0-15] (default: 3)

SBASSHARMBOOST=${config.sbassharmboost}

-----------------------------------

# This parameter work ONLY with Virtual Bass
# Here you can set linear bass gain
# Values [0-20] (default: 5)

SBASSLINGAIN=${config.sbasslingain}

-----------------------------------

# Speaker Digital Volume booster
# How much in dB volume should be boosted?
# values [-15 to 15] (default and stock:0)

SVOLBOOST=${config.svolboost}

-----------------------------------

# Dialog Enhancer. Should be turned on? or off?
# Value of 0 will turn off Dialog Enhancer
# Value of 1 will turn on Dialog Enhancer only for Movie profile
# Value of 2 will turn on Dialog Enhancer for every profile
# values [0-2] (default: 0)

SDE=${config.sde}

-----------------------------------

# This setting is working only with enabled Dialog Enhancer
# How strong Dialog Enhancer should be?
# values [1-10] (default: 6)

SDEA=${config.sdea}

-----------------------------------

# This setting is working only with enabled Dialog Enhancer
# How strong Dialog Enhancer ducking should be?
# values [0-10] (default: 0)

SDED=${config.sded}

-----------------------------------

# Choose how virtualizer setting should be set
# 0 - virtualizer will be off
# 1 - Virtualizer will be enabled in Movie preset and disabled in Music preset
# 2 - virtualizer will be enabled in every profile

SVIRTUALIZER=${config.svirtualizer}

-----------------------------------

# Surround boost
# values [0-15] (default: 3)

SSURBOOST=${config.ssurboost}

-----------------------------------

# Which mode of Virtualizer effect you want?
# FOR SUPPORTED DOLBY
# Mode 1 means, Virtualizer is center oriented, soundscene is narrow.
# Mode 2 means, Virtualizer is much more expanded to sides.
# values [1 or 2] (default and stock: 2)

SVIRTMOD=${config.svirtmod}

-----------------------------------

# Speaker Advanced Virtualizer Renderer
# FOR ADVANCED USERS ONLY!
# THIS SETTING HAVE HUGE IMPACT ON VIRTUALIZER SOUNDSTAGE RENDERING
# FOR SUPPORTED DOLBY
#
# STOCK values are: 103,32568,11164,5090,0,3,3,3
# Some good and possible options:
# 160,32767,14379,7090,2,2,3,1
# 160,32767,16379,2065,0,3,3,0 - motorola spatializer 
# 103,32568,11164,5090,0,1,2,2 - xiaomi 15 spatializer
# 200,32767,16379,7090,3,3,3,1
# 200,32568,15164,8090,1,2,2,1 (one of my favorite)
# 200,32568,15164,8090,1,2,3,1 (also one of my favorite)
# 160,85000,42000,12000,0,1,1,1 (one of my favorite and currently used)
# I encourage to experiment but be careful with modifying it ^^

SADVIRTREND=${config.sadvirtrend}

-----------------------------------

# Should Volume Leveler be turned on or off? 
# values [ON or OFF] (default and stock: OFF)

SLEVELER=${config.sleveler}

-----------------------------------
# How strong volume boost with volume leveler should be? 
# values [0-10] (default: 3)

SLEVSTR=${config.slevstr}

-----------------------------------

# This setting is working when Volume Leveler
# How fast SLEVELER should react?
# values [0-10] (default: 0)

SLEVAMOUNT=${config.slevamount}

-----------------------------------

# FOR A BIT MORE ADVANCED USERS!
# This setting is working when Volume Leveler
# How aggressive volume leveler should be in attenuation peaks?
# values [1-10] (default and stock: 6)

SLEVTARGETIN=${config.slevtargetin}

-----------------------------------

# FOR A BIT MORE ADVANCED USERS!
# This setting is working when Volume Leveler
# How aggressive volume leveler should be in modifying signal?
# values [1-10] (default and stock: 6)

SLEVTARGETOUT=${config.slevtargetout}

-----------------------------------

# How hard regulator should try to preserve timbre?
# values [1-4] (default and stock: 2)

STIMBRE=${config.stimbre}

-----------------------------------

# To which samplerate should dolby tune itself?
# possible values [44100,48000,88200,96000,176400,192000,352800,384000] 
# (default and stock: 48000)

STUNEDRATE=${config.stunedrate}

-----------------------------------

# Select amount of output channels
# values [1-8] (default and stock: 2)

S_OUTPUT_CHANNELS=${config.s_output_channels}

-----------------------------------
`;
};
