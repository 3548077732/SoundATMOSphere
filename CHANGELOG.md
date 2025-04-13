# Changelog

## v0.1 - 0.3

- Initial build for other devices
- Finding dolby configuration logic change (0.2)
- Making two modes (ROM integrated and Module) instead of one (0.3)
- Many many changes across the versions about sound

## v0.4

- Rebuilt search logic
- Change in harmonics gains

## v0.5

-Change in harmonics gains (testing different values)

## v0.6

- Another change in harmonics (more balanced and mature sound)

## v0.7

- Added Custom preset tuning if dolby config have it
- Added informations about missing stuff and potential alternate tuning

## v0.8

- Rewrote searching & replacing lines system

## v0.82

- Adjusted Virtual bass linear gain to increase bass response

## v0.85

- Added searching range of devices depended on existence certain endpoints
- Setting lr-angle value from 90 to 135

## v0.86

- Bringing back lr-angle value to 90

## v0.90

- Rewrote Module mode. 
   Now dax file will be copied to mod and then its value changed

## v0.92 - 0.93

- Lowered virtual bass linear gain, and cranked up lowest hybgains value to maintain bass response with better clarity

## v0.94

- Transferred values from hybgains to harmgains

## v0.95 - 0.96

- Transferred values from harmgains to hybgains
- Adjusted values in harmgains, min and max frequencies of mix and src
- Lowered linear gain

## v0.97

- Separate variables and made it as function
- Adjusted values in linear gain hybgains, min and max frequencies of src for module mode
- Adjusted linear gain and hybgains for built-in

## v0.98

- Adjusted values in built-in and module mode
- Added speaker tuning

## v1.0
- Final release

## v1.01
- Minor change in mkdir command

## v1.03
- Turning module into Do It Yourself mode

## v1.04
- Fix for bass variable

## v1.05-1.08
- Various little fixes in texts

## v1.09
- Added Dialog Enhancer for speakers and headphones
- Added Virtualizer for speakers

## v1.10
- Added Volume leveler in/out target for headphones

## v1.11
- Switched order of executing functions
- Now module will first check for dolby, then execute rest

## v1.12
- Added two lines of text
- Changed some text with wrong values

## v1.13
- Added mechanism, which will disable this mod if script will detect new dolby atmos. For example when new module with different config base is flashed

## v1.14
- Added mechanism, which will delete this mod if script will detect dolby module uninstall (update is unaffected)

## v1.15
- Fix for multiple files detection

## v1.16
- Added custom advanced virtualizer renderer (for supported dolby)
- Optimization in installation scripts

## v1.17
- Added digital volume boost. Volume leveler is NOT needed for that. User now can choose how much dB output should change
- Some fixes and optimization in installation scripts
- Script will make a copy of old settings if there was older tuningDIY.txt present

## v1.18
- Until clearly stated in tuningDIY.txt, speaker options now are independent from SPEAKERTUNING (previously SPEAKERBOOST)

## v1.19
- Speaker and Headphones digital volume boost switch to calibration boost from audio optimizer method (in some dolby it's 32 lines vs 2000 lines)

## v1.20
- Some fixes in script, tuning file

## v1.21
- Added Warm IEQ choice
- Added safety switch, where user choose IEQ preset, which is not in their dolby config, balanced IEQ will be applied

## v1.22
- Minor code polishing

## v1.23
- Added Action button for supported root solution. User can now use action button to apply new changes without need to reflash or reboot device. UI of DA can crash once after that operation, but once.

## v1.25
- Added new variable HHARM. This variable change virtual bass by adding extra harmonics for bass for supported Dolby. This MIGHT help bass sound bigger.

## v1.26
- Change way of calculating speaker/headphone digital volume boost again to audio optimizer method, with improved formula
- Improved/more efficient tuning file reading

## v1.27
- Added new parameter: Surround Boost
- Bass calculation (based on HBASS and HHARM parameters) reforge
- Added support for Samsung Dolby (as much as possible...)

## v1.28
- Changed parameter: HVIRTREND to HADVIRTREND. Now this parameter will allow to set custom virtualizer soundstage in supported dolby (For expert users)

## v1.29
- Improved virtual bass accuracy
- Halved regulator stress amount
- Doubled regulator overdrive
- Few code improvements

## v1.30
- Change default values
- Added version of tuning backup in name

## v1.31
- Changed math on HHARM bass calculation

## v1.32
- Changed HHARM variable to HBASSHARMBOOST to highlight what it's doing
- HBASSHARMBOOST will let user choose value between 0, 1 and 2, to choose "preset" of bass. This will work only on Dolby Atmos with Virtual Bass feature

## v1.33
- Created WebUI with loading config, saving config and applying config

## v1.35
- Expanding WebUI + translations

## v1.36
- Divided action.sh and tuning.sh into smaller pieces, both files are using these pieces + easier to read and maintain

## v1.38
- Extrapolated global values from profiles and merged them in tuning_global_profiles.sh, so it's easier to read and maintain

## v1.40
- Attempt to give similar support to speaker as in headphones

## v1.42
- Overhaul of visual style in WebUI
- Many small bugs fixes in scripts

## v1.43
- Fixes in scripts
- Adjusting some toggles and other things to look better on smaller dpi

## v1.44
- Fixes bugs in webui
- Fixes bugs in scripts

## v1.45
- Equalize "More Harmonics" to other options (boost by 50%)
- Change "Even More Harmonics" to "Boosted 2+ Harmonics"
- Improved harmonic subgains
