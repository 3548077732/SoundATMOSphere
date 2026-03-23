# SoundATMOSphere

**Do It Yourself Edition.** A systemless module for rooted Android devices that modifies Dolby XML configuration files to provide a highly customizable and tuned to user taste audio experience.

---

## Features

* **DIY Tuning:** Take full control of your device's audio by modifying exposed, user-accessible Dolby configuration values.
* **WebUI Integration:** Easily configure your sound profile through a built-in web interface.
* **Systemless Modification:** Safely applies changes via Magisk/KernelSU without permanently altering your `/system` partition.
* **Open & Transparent:** Pure shell scripts and readable configuration files. No hidden binaries or obfuscated code.

## Prerequisites

* A rooted Android device (Magisk or KernelSU).
* Dolby Atmos on phone. Built-in or module.

## Installation

1. Download the latest release from the Releases page.
2. Open your root manager app (Magisk / KernelSU / Whatever root solution you're using).
3. Navigate to the **Modules** tab and select **Install from storage**.
4. Choose the downloaded ZIP file and wait for the installation to finish.
5. Reboot your device.

## Usage & WebUI

**Configuring & Applying Settings:**
1. Open the WebUI to access the **Dolby Tuning DIY** panel.
2. Select your tuning mode (Simple / Expert), theme, and configure your parameters.
3. Tap **Save Config** to store your changes. (Optional, as Apply Tuning also will save config)
4. Tap **Apply Tuning** directly within the WebUI! The action log at the bottom will display the real-time execution of the tuning scripts and service restarts.

*(Optional)* **Quick Apply:** You can also tap the action button next to **SoundATMOSphere** directly in the Magisk/KernelSU Modules tab. This triggers `action.sh` to quickly re-apply your last saved settings without opening the WebUI.

---

## ⚠️ Legal Disclaimer

This module is provided strictly for educational, research, and configuration testing purposes. It does **not** contain any proprietary Dolby binaries, nor does it circumvent DRM or licensing mechanisms. 

"Dolby" and "Dolby Atmos" are registered trademarks of Dolby Laboratories. This project is community-driven and is not affiliated with, authorized, or endorsed by Dolby Laboratories.

Please read the full [LEGAL DISCLAIMER](LEGAL_DISCLAIMER.txt) before using this module.

---

## License

Distributed under the terms specified in the [LICENSE.txt](LICENSE.txt) file.