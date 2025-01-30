# Changelog

## v0.1 - 0.3 - long time ago

- Initial build for other devices
- Finding dolby configuration logic change (0.2)
- Making two modes (ROM integrated and Module) instead of one (0.3)
- Many many changes across the versions about sound

## v0.4 - 01.08.2024

- Rebuilt search logic
- Change in harmonics gains

## v0.5 - 06.08.2024

- Change in harmonics gains (testing different values)

## v0.6 - 13.08.2024

- Another change in harmonics (more balanced and mature sound)

## v0.7 - 13.08.2024

- Added Custom preset tuning if dolby config have it
- Added informations about missing stuff and potential alternate tuning

## v0.8 - 14.08.2024

- Rewrote searching & replacing lines system

## v0.82 - 15.08.2024

- Adjusted Virtual bass linear gain to increase bass response

## v0.85 - 17.08.2024

- Added searching range of devices depended on existence certain endpoints
- Setting lr-angle value from 90 to 135

## v0.86 - 17.08.2024

- Bringing back lr-angle value to 90

## v0.90 - 18.08.2024

- Rewrote Module mode. 
   Now dax file will be copied to mod and then its value changed

## v0.92 -0.93 - 22.08.2024

- Lowered virtual bass linear gain, and cranked up lowest hybgains value to maintain bass response with better clarity

## v0.94 - 29.08.2024

- Transferred values from hybgains to harmgains

## v0.95-0.96 - 30.08.2024-1.09.2024

- Transferred values from harmgains to hybgains
- Adjusted values in harmgains, min and max frequencies of mix and src
- Lowered linear gain

## v0.97 - 6.09.2024

- Separate variables and made it as function
- Adjusted values in linear gain hybgains, min and max frequencies of src for module mode
- Adjusted linear gain and hybgains for built-in

## v0.98 - 10.09.2024

- Adjusted values in built-in and module mode
- Added speaker tuning

## v1.0 - 10.10.2024
- Final release

## v1.01 - 15.10.2024
- Minor change in mkdir command

## v1.03 - 23.10.2024
- Turning module into Do It Yourself mode

## v1.04 - 25.10.2024
- Fix for bass variable

## v1.05-1.08 - 26-30.10.2024
- Various little fixes in texts

## v1.09 - 31.10.2024
- Added Dialog Enhancer for speakers and headphones
- Added Virtualizer for speakers

## v1.10 - 4.11.2024
- Added Volume leveler in/out target for headphones

## v1.11 - 7.11.2024
- Switched order of executing functions
- Now module will first check for dolby, then execute rest

## v1.12 - 8.11.2024
- Added two lines of text
- Changed some text with wrong values

## v1.13 - 9.11.2024
- Added mechanism, which will disable this mod if script will detect new dolby atmos. For example when new module with different config base is flashed

## v1.14 - 10.11.2024
- Added mechanism, which will delete this mod if script will detect dolby module uninstall (update is unaffected)

## v1.15 - 11.11.2024
- Fix for multiple files detection

## v1.16 - 02.12.2024
- Added custom advanced virtualizer renderer (for supported dolby)
- Optimization in installation scripts

## v1.17 - 19.01.2025
- Added digital volume boost. Volume leveler is NOT needed for that. User now can choose how much dB output should change
- Some fixes and optimization in installation scripts
- Script will make a copy of old settings if there was older tuningDIY.txt present

## v1.18 - 21.01.2025
- Until clearly stated in tuningDIY.txt, speaker options now are independent from SPEAKERTUNING (previously SPEAKERBOOST)

## v1.19 - 24.01.2025
- Speaker and Headphones digital volume boost switch to calibration boost from audio optimizer method (in some dolby it's 32 lines vs 2000 lines)

## v1.20 - 26.01.2025
- Some fixes in script, tuning file

## v1.21 - 28.01.2025
- Added Warm IEQ choice
- Added safety switch, where user choose IEQ preset, which is not in their dolby config, balanced IEQ will be applied
