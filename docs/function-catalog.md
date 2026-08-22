# Function Catalog

| Category | Function | Description | Status | Notes |
|---|---|---|---|---|
| logging | `maclib::log::set_level` | Set global log level | implemented | debug/info/warn/error |
| logging | `maclib::log::{debug,info,warn,error}` | Log messages | implemented | warn/error -> stderr |
| os | `maclib::os::is_macos` | Check if running on macOS | implemented | |
| os | `maclib::os::version` | macOS product version | implemented | uses sw_vers |
| os | `maclib::os::major_minor` | Major.Minor version | implemented | |
| os | `maclib::os::arch` | CPU architecture | implemented | uname -m |
| user | `maclib::user::is_root` | Return 0 if running as root | implemented | |
| user | `maclib::user::current_user` | Short name of current user | implemented | whoami |
| user | `maclib::user::home_dir` | Home directory of user (default: current) | implemented | uses dscl on macOS |
| system | `maclib::system::softwareupdate` | List available macOS updates | implemented | requires network + root |
| system | `maclib::system::softwareupdate_check` | Check for updates | implemented | |
| system | `maclib::system::softwareupdate_download` | Download updates | implemented | |
| system | `maclib::system::softwareupdate_install` | Install updates | implemented | requires root |
| system | `maclib::system::system_profiler` | Run system_profiler (SPALL default) | implemented | |
| system | `maclib::system::sip_status` | Current SIP state string | implemented | csrutil |
| system | `maclib::system::is_sip_active` | Return 0 if SIP enabled | implemented | |
| packages | `maclib::packages::pkg_install` | Install a .pkg | implemented | requires root |
| packages | `maclib::packages::pkg_list` | List installed package IDs | implemented | pkgutil --pkgs |
| packages | `maclib::packages::pkg_info` | Package metadata | implemented | |
| packages | `maclib::packages::pkg_forget` | Forget package from db | implemented | |
| packages | `maclib::packages::pkg_files` | Files installed by a package | implemented | |
| packages | `maclib::packages::pkg_receipts` | Receipt metadata files | implemented | |
| signing | `maclib::signing::codesign` | Code-sign an app/binary | implemented | Developer ID identity |
| signing | `maclib::signing::verify` | Verify a code signature | implemented | |
| signing | `maclib::signing::identity` | Developer identity in signature | implemented | |
| signing | `maclib::signing::notarize` | Submit bundle to notary | implemented | xcr notarytool |
| signing | `maclib::signing::notarize_preflight` | Pre-check bundle | implemented | |
| signing | `maclib::signing::notarize_staple` | Notarize ticket onto bundle | implemented | |
| keychain | `maclib::keychain::exists` | Check keychain name exists | implemented | |
| keychain | `maclib::keychain::add` | Add generic password | implemented | requires root |
| keychain | `maclib::keychain::delete` | Delete generic password | implemented | |
| keychain | `maclib::keychain::has_entry` | Check generic password entry | implemented | |
| launchd | `maclib::launchd::load` | Bootstrap a launchd plist | implemented | |
| launchd | `maclib::launchd::unload` | Bootout a launchd plist | implemented | |
| launchd | `maclib::launchd::is_loaded` | Return 0 if service loaded | implemented | |
| launchd | `maclib::launchd::state` | launchd state string | implemented | |
| launchd | `maclib::launchd::reload` | Unload then load a plist | implemented | |
| filevault | `maclib::filevault::fdestatus` | Current FileVault state | implemented | |
| filevault | `maclib::filevault::enable` | Enable FileVault | implemented | requires root |
| filevault | `maclib::filevault::disable` | Disable FileVault | implemented | requires root |
| filevault | `maclib::filevault::is_enabled` | Return 0 if FileVault enabled | implemented | |
| management | `maclib::management::mdmstatus` | Raw mdmstatus output | implemented | |
| management | `maclib::management::isManaged` | Return 0 if machine managed | implemented | |
| management | `maclib::management::server_url` | MDM server URL | implemented | |
| management | `maclib::management::install_profile` | Install a config profile | implemented | requires root |
| management | `maclib::management::list_profiles` | List config profiles | implemented | |
| management | `maclib::management::remove_profile` | Remove config profile by UUID | implemented | |
| network | `maclib::network::primary_service` | Primary network service name | implemented | |
| network | `maclib::network::primary_ip` | Primary IP address | implemented | |
| network | `maclib::network::hostname` | Short hostname | implemented | |
| network | `maclib::network::fqdn` | Fully-qualified hostname | implemented | |
| network | `maclib::network::set_hostname` | Set machine hostname | implemented | requires root |
| app | `maclib::app::is_installed` | Return 0 if app bundle exists | implemented | |
| app | `maclib::app::path` | Path to installed .app | implemented | |
| app | `maclib::app::install` | Install an app bundle | implemented | requires root |
| app | `maclib::app::uninstall` | Uninstall an app bundle | implemented | |
| app | `maclib::app::locations` | Common install locations | implemented | |
|| office | `maclib::office::suite_installer_url` | fwlink to Office for Mac suite installer | implemented | go.microsoft.com/fwlink/?linkid=525133 |
|| office | `maclib::office::latest_version` | Current Office for Mac build version from CDN | implemented | resolves fwlink, parses package name |
|| office | `maclib::office::is_installed` | Return 0 if core Office app bundle present | implemented | Word/Excel/Outlook/PowerPoint/OneNote |
|| office | `maclib::office::installed_path` | Path to installed Office app bundle | implemented | |
|| office | `maclib::office::install` | Download suite installer and install it | implemented | requires root |
|| office | `maclib::office::update` | Update via Microsoft AutoUpdate (msupdate) | implemented | |
||| chrome | `maclib::chrome::url` | Google Chrome package installer URL | implemented | dl.google.com CDN, .pkg, team EQHXZ8M8AV |
||| chrome | `maclib::chrome::latest_version` | Current stable Chrome build from version-history API | implemented | parses Google Chrome version API |
||| chrome | `maclib::chrome::is_installed` | Return 0 if Chrome bundle present | implemented | Google Chrome.app |
||| chrome | `maclib::chrome::installed_path` | Path to installed Chrome bundle | implemented | |
||| chrome | `maclib::chrome::install` | Download package installer and install it | implemented | requires root, package ID com.google.chrome |
||| chrome | `maclib::chrome::update` | Update via Google Software Update agent | implemented | |
||| firefox | `maclib::firefox::url` | Firefox package installer URL | implemented | download.mozilla.org, .pkg, team 43AQ936H96 |
||| firefox | `maclib::firefox::latest_version` | Current stable Firefox build | implemented | product-details.mozilla.org JSON |
||| firefox | `maclib::firefox::is_installed` | Return 0 if Firefox bundle present | implemented | Firefox.app |
||| firefox | `maclib::firefox::installed_path` | Path to installed Firefox bundle | implemented | |
||| firefox | `maclib::firefox::install` | Download package installer and install it | implemented | requires root, org.mozilla.firefox |
||| zoom | `maclib::zoom::url` | Zoom installer package URL | implemented | zoom.us/client/latest, .pkg, team BJ4HAAB9B3 |
||| zoom | `maclib::zoom::latest_version` | Current Zoom build from redirect header | implemented | parses Location header |
||| zoom | `maclib::zoom::is_installed` | Return 0 if Zoom bundle present | implemented | Zoom.app |
||| zoom | `maclib::zoom::installed_path` | Path to installed Zoom bundle | implemented | |
||| zoom | `maclib::zoom::install` | Download installer package and install it | implemented | requires root |
||| 1password | `maclib::1password::url` | 1Password package installer URL | implemented | downloads.1password.com, .pkg, team 2BUA8C4S2C |
||| 1password | `maclib::1password::latest_version` | Current 1Password build | implemented | releases.1password.com XML feed |
||| 1password | `maclib::1password::is_installed` | Return 0 if 1Password bundle present | implemented | 1Password.app |
||| 1password | `maclib::1password::installed_path` | Path to installed 1Password bundle | implemented | |
||| 1password | `maclib::1password::install` | Download package installer and install it | implemented | requires root, com.1password.1password |
||| slack | `maclib::slack::url` | Slack package installer URL | implemented | slack.com API, .pkg, team BQR82RBBHL |
||| slack | `maclib::slack::latest_version` | Current Slack build from redirect header | implemented | parses Location header |
||| slack | `maclib::slack::is_installed` | Return 0 if Slack bundle present | implemented | Slack.app |
||| slack | `maclib::slack::installed_path` | Path to installed Slack bundle | implemented | |
||| slack | `maclib::slack::install` | Download package installer and install it | implemented | requires root |
||| dropbox | `maclib::dropbox::url` | Dropbox disk image URL | implemented | dropbox.com, .dmg, team G7HH3F8CAK |
||| dropbox | `maclib::dropbox::latest_version` | Current Dropbox build from redirect header | implemented | parses Location header |
||| dropbox | `maclib::dropbox::is_installed` | Return 0 if Dropbox bundle present | implemented | Dropbox.app |
||| dropbox | `maclib::dropbox::installed_path` | Path to installed Dropbox bundle | implemented | |
||| dropbox | `maclib::dropbox::install` | Download and mount disk image, copy bundle | implemented | requires root |
||| notion | `maclib::notion::url` | Notion disk image URL | implemented | notion.so, .dmg, team LBQJ96FQ8D |
||| notion | `maclib::notion::latest_version` | Current Notion build from redirect header | implemented | parses Location header |
||| notion | `maclib::notion::is_installed` | Return 0 if Notion bundle present | implemented | Notion.app |
||| notion | `maclib::notion::installed_path` | Path to installed Notion bundle | implemented | |
||| notion | `maclib::notion::install` | Download and mount disk image, copy bundle | implemented | requires root |
||| vlc | `maclib::vlc::url` | VLC disk image URL (current version) | implemented | get.videolan.org, .dmg, team 75GAHG3SZQ |
||| vlc | `maclib::vlc::latest_version` | Current VLC build | implemented | videolan.org page parse |
||| vlc | `maclib::vlc::is_installed` | Return 0 if VLC bundle present | implemented | VLC.app |
||| vlc | `maclib::vlc::installed_path` | Path to installed VLC bundle | implemented | |
||| vlc | `maclib::vlc::install` | Download and mount disk image, copy bundle | implemented | requires root |
||| signal | `maclib::signal::url` | Signal disk image URL (from latest-mac.yml) | implemented | updates.signal.org, .dmg, team U68MSDN6DR |
||| signal | `maclib::signal::latest_version` | Current Signal build | implemented | latest-mac.yml manifest |
||| signal | `maclib::signal::is_installed` | Return 0 if Signal bundle present | implemented | Signal.app |
||| signal | `maclib::signal::installed_path` | Path to installed Signal bundle | implemented | |
||| signal | `maclib::signal::install` | Download and mount disk image, copy bundle | implemented | requires root |
||| libreoffice | `maclib::libreoffice::url` | LibreOffice disk image URL (arch-aware) | implemented | documentfoundation.org, .dmg, team 7P5S3ZLCN7 |
||| libreoffice | `maclib::libreoffice::latest_version` | Current LibreOffice build | implemented | download directory listing |
||| libreoffice | `maclib::libreoffice::is_installed` | Return 0 if LibreOffice bundle present | implemented | LibreOffice.app |
||| libreoffice | `maclib::libreoffice::installed_path` | Path to installed LibreOffice bundle | implemented | |
||| libreoffice | `maclib::libreoffice::install` | Download and mount disk image, copy bundle | implemented | requires root |
||| iterm2 | `maclib::iterm2::url` | iTerm2 zip archive URL | implemented | iterm2.com, .zip, team H7V7XYVQ7D |
||| iterm2 | `maclib::iterm2::latest_version` | Current iTerm2 build from redirect header | implemented | parses Location header |
||| iterm2 | `maclib::iterm2::is_installed` | Return 0 if iTerm2 bundle present | implemented | iTerm.app |
||| iterm2 | `maclib::iterm2::installed_path` | Path to installed iTerm2 bundle | implemented | |
||| iterm2 | `maclib::iterm2::install` | Download zip and extract bundle | implemented | requires root |
||| figma | `maclib::figma::url` | Figma zip archive URL (arch-aware) | implemented | desktop.figma.com, .zip, team T8RA8NE3B7 |
||| figma | `maclib::figma::latest_version` | Current Figma build | implemented | RELEASE.json manifest |
||| figma | `maclib::figma::is_installed` | Return 0 if Figma bundle present | implemented | Figma.app |
||| figma | `maclib::figma::installed_path` | Path to installed Figma bundle | implemented | |
||| figma | `maclib::figma::install` | Download zip and extract bundle | implemented | requires root |
||| chatgpt | `maclib::chatgpt::url` | ChatGPT disk image URL (Apple Silicon) | implemented | oaistatic.com, .dmg, team 2DC432GLL2 |
||| chatgpt | `maclib::chatgpt::latest_version` | Current ChatGPT build from appcast | implemented | public appcast title |
||| chatgpt | `maclib::chatgpt::is_installed` | Return 0 if ChatGPT bundle present | implemented | ChatGPT.app |
||| chatgpt | `maclib::chatgpt::installed_path` | Path to installed ChatGPT bundle | implemented | |
||| chatgpt | `maclib::chatgpt::install` | Download and mount disk image, copy bundle | implemented | requires root |
|| jamf | `maclib::jamf::battery_cycle_count` | Integer battery cycle count (0 on batteryless) | implemented | SPPowerDataType + bc; no-battery -> 0 |
|| jamf | `maclib::jamf::battery_charge_percent` | Battery charge percentage 0-100 | implemented | pmset; empty on batteryless/AC |
|| jamf | `maclib::jamf::security_chip` | Apple Security Chip / T2 model identifier | implemented | SPiBridgeDataType, Model Identifier (palantir bugfix) |
|| jamf | `maclib::jamf::third_party_kexts` | Line list of third-party kernel extension load IDs | implemented | kmutil macOS 12.3+; empty on clean Apple Silicon |
|| jamf | `maclib::jamf::system_extensions` | Line list of enabled system extension bundle IDs | implemented | systemextensionsctl; bundle-ID column (palantir bugfix) |
|| jamf | `maclib::jamf::uptime_seconds` | Seconds since last boot | implemented | sysctl kern.boottime |
|| jamf | `maclib::jamf::xcode_clt_state` | Xcode CLT state (Bundled / Standalone / empty) | implemented | xcode-select; handles Xcode-beta path |
|| jamf | `maclib::jamf::startup_volume_name` | Name of the startup/boot volume | implemented | bless + diskutil + plutil |
|| jamf | `maclib::jamf::charger_wattage` | Power adapter wattage | implemented | SPPowerDataType; empty when no adapter |
|| jamf | `maclib::jamf::time_machine_autobackup` | Time Machine auto-backup status (Enabled/empty) | implemented | defaults read com.apple.TimeMachine.plist |
|| jamf | `maclib::jamf::homebrew_outdated_formulae` | Line list of outdated Homebrew formulae | implemented | launchctl asuser <uid> brew (palantir sudo fix) |
