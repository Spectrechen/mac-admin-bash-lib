# Function Catalog

|| Category | Function | Description | Status | Notes | lib/ path |
||---|---|---|---|---|---|
| logging | `maclib::log::set_level` | Set global log level | implemented | debug/info/warn/error | `lib/core/log.sh` |
| logging | `maclib::log::{debug,info,warn,error}` | Log messages | implemented | warn/error -> stderr | `lib/core/log.sh` |
| os | `maclib::os::is_macos` | Check if running on macOS | implemented |  | `lib/core/os.sh` |
| os | `maclib::os::version` | macOS product version | implemented | uses sw_vers | `lib/core/os.sh` |
| os | `maclib::os::major_minor` | Major.Minor version | implemented |  | `lib/core/os.sh` |
| os | `maclib::os::arch` | CPU architecture | implemented | uname -m | `lib/core/os.sh` |
| user | `maclib::user::is_root` | Return 0 if running as root | implemented |  | `lib/core/user.sh` |
| user | `maclib::user::current_user` | Short name of current user | implemented | whoami | `lib/core/user.sh` |
| user | `maclib::user::home_dir` | Home directory of user (default: current) | implemented | uses dscl on macOS | `lib/core/user.sh` |
| system | `maclib::system::softwareupdate` | List available macOS updates | implemented | requires network + root | `lib/core/system.sh` |
| system | `maclib::system::softwareupdate_check` | Check for updates | implemented |  | `lib/core/system.sh` |
| system | `maclib::system::softwareupdate_download` | Download updates | implemented |  | `lib/core/system.sh` |
| system | `maclib::system::softwareupdate_install` | Install updates | implemented | requires root | `lib/core/system.sh` |
| system | `maclib::system::system_profiler` | Run system_profiler (SPALL default) | implemented |  | `lib/core/system.sh` |
| system | `maclib::system::sip_status` | Current SIP state string | implemented | csrutil | `lib/core/system.sh` |
| system | `maclib::system::is_sip_active` | Return 0 if SIP enabled | implemented |  | `lib/core/system.sh` |
| packages | `maclib::packages::pkg_install` | Install a .pkg | implemented | requires root | `lib/core/packages.sh` |
| packages | `maclib::packages::pkg_list` | List installed package IDs | implemented | pkgutil --pkgs | `lib/core/packages.sh` |
| packages | `maclib::packages::pkg_info` | Package metadata | implemented |  | `lib/core/packages.sh` |
| packages | `maclib::packages::pkg_forget` | Forget package from db | implemented |  | `lib/core/packages.sh` |
| packages | `maclib::packages::pkg_files` | Files installed by a package | implemented |  | `lib/core/packages.sh` |
| packages | `maclib::packages::pkg_receipts` | Receipt metadata files | implemented |  | `lib/core/packages.sh` |
| signing | `maclib::signing::codesign` | Code-sign an app/binary | implemented | Developer ID identity | `lib/core/signing.sh` |
| signing | `maclib::signing::verify` | Verify a code signature | implemented |  | `lib/core/signing.sh` |
| signing | `maclib::signing::identity` | Developer identity in signature | implemented |  | `lib/core/signing.sh` |
| signing | `maclib::signing::notarize` | Submit bundle to notary | implemented | xcr notarytool | `lib/core/signing.sh` |
| signing | `maclib::signing::notarize_preflight` | Pre-check bundle | implemented |  | `lib/core/signing.sh` |
| signing | `maclib::signing::notarize_staple` | Notarize ticket onto bundle | implemented |  | `lib/core/signing.sh` |
| keychain | `maclib::keychain::exists` | Check keychain name exists | implemented |  | `lib/core/keychain.sh` |
| keychain | `maclib::keychain::add` | Add generic password | implemented | requires root | `lib/core/keychain.sh` |
| keychain | `maclib::keychain::delete` | Delete generic password | implemented |  | `lib/core/keychain.sh` |
| keychain | `maclib::keychain::has_entry` | Check generic password entry | implemented |  | `lib/core/keychain.sh` |
| launchd | `maclib::launchd::load` | Bootstrap a launchd plist | implemented |  | `lib/core/launchd.sh` |
| launchd | `maclib::launchd::unload` | Bootout a launchd plist | implemented |  | `lib/core/launchd.sh` |
| launchd | `maclib::launchd::is_loaded` | Return 0 if service loaded | implemented |  | `lib/core/launchd.sh` |
| launchd | `maclib::launchd::state` | launchd state string | implemented |  | `lib/core/launchd.sh` |
| launchd | `maclib::launchd::reload` | Unload then load a plist | implemented |  | `lib/core/launchd.sh` |
| filevault | `maclib::filevault::fdestatus` | Current FileVault state | implemented |  | `lib/core/filevault.sh` |
| filevault | `maclib::filevault::enable` | Enable FileVault | implemented | requires root | `lib/core/filevault.sh` |
| filevault | `maclib::filevault::disable` | Disable FileVault | implemented | requires root | `lib/core/filevault.sh` |
| filevault | `maclib::filevault::is_enabled` | Return 0 if FileVault enabled | implemented |  | `lib/core/filevault.sh` |
| management | `maclib::management::mdmstatus` | Raw mdmstatus output | implemented |  | `lib/core/management.sh` |
| management | `maclib::management::isManaged` | Return 0 if machine managed | implemented |  | `lib/core/management.sh` |
| management | `maclib::management::server_url` | MDM server URL | implemented |  | `lib/core/management.sh` |
| management | `maclib::management::install_profile` | Install a config profile | implemented | requires root | `lib/core/management.sh` |
| management | `maclib::management::list_profiles` | List config profiles | implemented |  | `lib/core/management.sh` |
| management | `maclib::management::remove_profile` | Remove config profile by UUID | implemented |  | `lib/core/management.sh` |
| network | `maclib::network::primary_service` | Primary network service name | implemented |  | `lib/core/network.sh` |
| network | `maclib::network::primary_ip` | Primary IP address | implemented |  | `lib/core/network.sh` |
| network | `maclib::network::hostname` | Short hostname | implemented |  | `lib/core/network.sh` |
| network | `maclib::network::fqdn` | Fully-qualified hostname | implemented |  | `lib/core/network.sh` |
| network | `maclib::network::set_hostname` | Set machine hostname | implemented | requires root | `lib/core/network.sh` |
| app | `maclib::app::is_installed` | Return 0 if app bundle exists | implemented |  | `lib/core/app.sh` |
| app | `maclib::app::path` | Path to installed .app | implemented |  | `lib/core/app.sh` |
| app | `maclib::app::install` | Install an app bundle | implemented | requires root | `lib/core/app.sh` |
| app | `maclib::app::uninstall` | Uninstall an app bundle | implemented |  | `lib/core/app.sh` |
| app | `maclib::app::locations` | Common install locations | implemented |  | `lib/core/app.sh` |
| office | `maclib::office::suite_installer_url` | fwlink to Office for Mac suite installer | implemented | go.microsoft.com/fwlink/?linkid=525133 | `lib/productivity/office.sh` |
| office | `maclib::office::latest_version` | Current Office for Mac build version from CDN | implemented | resolves fwlink, parses package name | `lib/productivity/office.sh` |
| office | `maclib::office::is_installed` | Return 0 if core Office app bundle present | implemented | Word/Excel/Outlook/PowerPoint/OneNote | `lib/productivity/office.sh` |
| office | `maclib::office::installed_path` | Path to installed Office app bundle | implemented |  | `lib/productivity/office.sh` |
| office | `maclib::office::install` | Download suite installer and install it | implemented | requires root | `lib/productivity/office.sh` |
| office | `maclib::office::update` | Update via Microsoft AutoUpdate (msupdate) | implemented |  | `lib/productivity/office.sh` |
| chrome | `maclib::chrome::url` | Google Chrome package installer URL | implemented | dl.google.com CDN, .pkg, team EQHXZ8M8AV | `lib/browsers/chrome.sh` |
| chrome | `maclib::chrome::latest_version` | Current stable Chrome build from version-history API | implemented | parses Google Chrome version API | `lib/browsers/chrome.sh` |
| chrome | `maclib::chrome::is_installed` | Return 0 if Chrome bundle present | implemented | Google Chrome.app | `lib/browsers/chrome.sh` |
| chrome | `maclib::chrome::installed_path` | Path to installed Chrome bundle | implemented |  | `lib/browsers/chrome.sh` |
| chrome | `maclib::chrome::install` | Download package installer and install it | implemented | requires root, package ID com.google.chrome | `lib/browsers/chrome.sh` |
| chrome | `maclib::chrome::update` | Update via Google Software Update agent | implemented |  | `lib/browsers/chrome.sh` |
| firefox | `maclib::firefox::url` | Firefox package installer URL | implemented | download.mozilla.org, .pkg, team 43AQ936H96 | `lib/browsers/firefox.sh` |
| firefox | `maclib::firefox::latest_version` | Current stable Firefox build | implemented | product-details.mozilla.org JSON | `lib/browsers/firefox.sh` |
| firefox | `maclib::firefox::is_installed` | Return 0 if Firefox bundle present | implemented | Firefox.app | `lib/browsers/firefox.sh` |
| firefox | `maclib::firefox::installed_path` | Path to installed Firefox bundle | implemented |  | `lib/browsers/firefox.sh` |
| firefox | `maclib::firefox::install` | Download package installer and install it | implemented | requires root, org.mozilla.firefox | `lib/browsers/firefox.sh` |
| zoom | `maclib::zoom::url` | Zoom installer package URL | implemented | zoom.us/client/latest, .pkg, team BJ4HAAB9B3 | `lib/communication/zoom.sh` |
| zoom | `maclib::zoom::latest_version` | Current Zoom build from redirect header | implemented | parses Location header | `lib/communication/zoom.sh` |
| zoom | `maclib::zoom::is_installed` | Return 0 if Zoom bundle present | implemented | Zoom.app | `lib/communication/zoom.sh` |
| zoom | `maclib::zoom::installed_path` | Path to installed Zoom bundle | implemented |  | `lib/communication/zoom.sh` |
| zoom | `maclib::zoom::install` | Download installer package and install it | implemented | requires root | `lib/communication/zoom.sh` |
| 1password | `maclib::1password::url` | 1Password package installer URL | implemented | downloads.1password.com, .pkg, team 2BUA8C4S2C | `lib/security_tools/1password.sh` |
| 1password | `maclib::1password::latest_version` | Current 1Password build | implemented | releases.1password.com XML feed | `lib/security_tools/1password.sh` |
| 1password | `maclib::1password::is_installed` | Return 0 if 1Password bundle present | implemented | 1Password.app | `lib/security_tools/1password.sh` |
| 1password | `maclib::1password::installed_path` | Path to installed 1Password bundle | implemented |  | `lib/security_tools/1password.sh` |
| 1password | `maclib::1password::install` | Download package installer and install it | implemented | requires root, com.1password.1password | `lib/security_tools/1password.sh` |
| slack | `maclib::slack::url` | Slack package installer URL | implemented | slack.com API, .pkg, team BQR82RBBHL | `lib/communication/slack.sh` |
| slack | `maclib::slack::latest_version` | Current Slack build from redirect header | implemented | parses Location header | `lib/communication/slack.sh` |
| slack | `maclib::slack::is_installed` | Return 0 if Slack bundle present | implemented | Slack.app | `lib/communication/slack.sh` |
| slack | `maclib::slack::installed_path` | Path to installed Slack bundle | implemented |  | `lib/communication/slack.sh` |
| slack | `maclib::slack::install` | Download package installer and install it | implemented | requires root | `lib/communication/slack.sh` |
| dropbox | `maclib::dropbox::url` | Dropbox disk image URL | implemented | dropbox.com, .dmg, team G7HH3F8CAK | `lib/cloud_storage/dropbox.sh` |
| dropbox | `maclib::dropbox::latest_version` | Current Dropbox build from redirect header | implemented | parses Location header | `lib/cloud_storage/dropbox.sh` |
| dropbox | `maclib::dropbox::is_installed` | Return 0 if Dropbox bundle present | implemented | Dropbox.app | `lib/cloud_storage/dropbox.sh` |
| dropbox | `maclib::dropbox::installed_path` | Path to installed Dropbox bundle | implemented |  | `lib/cloud_storage/dropbox.sh` |
| dropbox | `maclib::dropbox::install` | Download and mount disk image, copy bundle | implemented | requires root | `lib/cloud_storage/dropbox.sh` |
| notion | `maclib::notion::url` | Notion disk image URL | implemented | notion.so, .dmg, team LBQJ96FQ8D | `lib/productivity/notion.sh` |
| notion | `maclib::notion::latest_version` | Current Notion build from redirect header | implemented | parses Location header | `lib/productivity/notion.sh` |
| notion | `maclib::notion::is_installed` | Return 0 if Notion bundle present | implemented | Notion.app | `lib/productivity/notion.sh` |
| notion | `maclib::notion::installed_path` | Path to installed Notion bundle | implemented |  | `lib/productivity/notion.sh` |
| notion | `maclib::notion::install` | Download and mount disk image, copy bundle | implemented | requires root | `lib/productivity/notion.sh` |
| vlc | `maclib::vlc::url` | VLC disk image URL (current version) | implemented | get.videolan.org, .dmg, team 75GAHG3SZQ | `lib/media/vlc.sh` |
| vlc | `maclib::vlc::latest_version` | Current VLC build | implemented | videolan.org page parse | `lib/media/vlc.sh` |
| vlc | `maclib::vlc::is_installed` | Return 0 if VLC bundle present | implemented | VLC.app | `lib/media/vlc.sh` |
| vlc | `maclib::vlc::installed_path` | Path to installed VLC bundle | implemented |  | `lib/media/vlc.sh` |
| vlc | `maclib::vlc::install` | Download and mount disk image, copy bundle | implemented | requires root | `lib/media/vlc.sh` |
| signal | `maclib::signal::url` | Signal disk image URL (from latest-mac.yml) | implemented | updates.signal.org, .dmg, team U68MSDN6DR | `lib/communication/signal.sh` |
| signal | `maclib::signal::latest_version` | Current Signal build | implemented | latest-mac.yml manifest | `lib/communication/signal.sh` |
| signal | `maclib::signal::is_installed` | Return 0 if Signal bundle present | implemented | Signal.app | `lib/communication/signal.sh` |
| signal | `maclib::signal::installed_path` | Path to installed Signal bundle | implemented |  | `lib/communication/signal.sh` |
| signal | `maclib::signal::install` | Download and mount disk image, copy bundle | implemented | requires root | `lib/communication/signal.sh` |
| libreoffice | `maclib::libreoffice::url` | LibreOffice disk image URL (arch-aware) | implemented | documentfoundation.org, .dmg, team 7P5S3ZLCN7 | `lib/productivity/libreoffice.sh` |
| libreoffice | `maclib::libreoffice::latest_version` | Current LibreOffice build | implemented | download directory listing | `lib/productivity/libreoffice.sh` |
| libreoffice | `maclib::libreoffice::is_installed` | Return 0 if LibreOffice bundle present | implemented | LibreOffice.app | `lib/productivity/libreoffice.sh` |
| libreoffice | `maclib::libreoffice::installed_path` | Path to installed LibreOffice bundle | implemented |  | `lib/productivity/libreoffice.sh` |
| libreoffice | `maclib::libreoffice::install` | Download and mount disk image, copy bundle | implemented | requires root | `lib/productivity/libreoffice.sh` |
| iterm2 | `maclib::iterm2::url` | iTerm2 zip archive URL | implemented | iterm2.com, .zip, team H7V7XYVQ7D | `lib/devops/iterm2.sh` |
| iterm2 | `maclib::iterm2::latest_version` | Current iTerm2 build from redirect header | implemented | parses Location header | `lib/devops/iterm2.sh` |
| iterm2 | `maclib::iterm2::is_installed` | Return 0 if iTerm2 bundle present | implemented | iTerm.app | `lib/devops/iterm2.sh` |
| iterm2 | `maclib::iterm2::installed_path` | Path to installed iTerm2 bundle | implemented |  | `lib/devops/iterm2.sh` |
| iterm2 | `maclib::iterm2::install` | Download zip and extract bundle | implemented | requires root | `lib/devops/iterm2.sh` |
| figma | `maclib::figma::url` | Figma zip archive URL (arch-aware) | implemented | desktop.figma.com, .zip, team T8RA8NE3B7 | `lib/creative/figma.sh` |
| figma | `maclib::figma::latest_version` | Current Figma build | implemented | RELEASE.json manifest | `lib/creative/figma.sh` |
| figma | `maclib::figma::is_installed` | Return 0 if Figma bundle present | implemented | Figma.app | `lib/creative/figma.sh` |
| figma | `maclib::figma::installed_path` | Path to installed Figma bundle | implemented |  | `lib/creative/figma.sh` |
| figma | `maclib::figma::install` | Download zip and extract bundle | implemented | requires root | `lib/creative/figma.sh` |
| chatgpt | `maclib::chatgpt::url` | ChatGPT disk image URL (Apple Silicon) | implemented | oaistatic.com, .dmg, team 2DC432GLL2 | `lib/ai/chatgpt.sh` |
| chatgpt | `maclib::chatgpt::latest_version` | Current ChatGPT build from appcast | implemented | public appcast title | `lib/ai/chatgpt.sh` |
| chatgpt | `maclib::chatgpt::is_installed` | Return 0 if ChatGPT bundle present | implemented | ChatGPT.app | `lib/ai/chatgpt.sh` |
| chatgpt | `maclib::chatgpt::installed_path` | Path to installed ChatGPT bundle | implemented |  | `lib/ai/chatgpt.sh` |
| chatgpt | `maclib::chatgpt::install` | Download and mount disk image, copy bundle | implemented | requires root | `lib/ai/chatgpt.sh` |
| jamf | `maclib::jamf::battery_cycle_count` | Integer battery cycle count (0 on batteryless) | implemented | SPPowerDataType + bc; no-battery -> 0 | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::battery_charge_percent` | Battery charge percentage 0-100 | implemented | pmset; empty on batteryless/AC | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::security_chip` | Apple Security Chip / T2 model identifier | implemented | SPiBridgeDataType, Model Identifier (palantir bugfix) | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::third_party_kexts` | Line list of third-party kernel extension load IDs | implemented | kmutil macOS 12.3+; empty on clean Apple Silicon | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::system_extensions` | Line list of enabled system extension bundle IDs | implemented | systemextensionsctl; bundle-ID column (palantir bugfix) | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::uptime_seconds` | Seconds since last boot | implemented | sysctl kern.boottime | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::xcode_clt_state` | Xcode CLT state (Bundled / Standalone / empty) | implemented | xcode-select; handles Xcode-beta path | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::startup_volume_name` | Name of the startup/boot volume | implemented | bless + diskutil + plutil | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::charger_wattage` | Power adapter wattage | implemented | SPPowerDataType; empty when no adapter | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::time_machine_autobackup` | Time Machine auto-backup status (Enabled/empty) | implemented | defaults read com.apple.TimeMachine.plist | `lib/mdm/jamf.sh` |
| jamf | `maclib::jamf::homebrew_outdated_formulae` | Line list of outdated Homebrew formulae | implemented | launchctl asuser <uid> brew (palantir sudo fix) | `lib/mdm/jamf.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::suite_installer_url` | "4K Video Downloader" installer URL (Installomator) | implemented | team "GHQ37VJF83"; "dmg" | `lib/apps/4/4kvideodownloader.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::latest_version` | "4K Video Downloader" current build | implemented | Installomator appNewVersion logic | `lib/apps/4/4kvideodownloader.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::is_installed` | Return 0 if "4K Video Downloader" installed | implemented | team "GHQ37VJF83"; "dmg" | `lib/apps/4/4kvideodownloader.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::installed_path` | Path to installed "4K Video Downloader" bundle | implemented |  | `lib/apps/4/4kvideodownloader.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::install` | Download installer and install "4K Video Downloader" | implemented | requires root | `lib/apps/4/4kvideodownloader.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::update` | Update "4K Video Downloader" | implemented | no update path | `lib/apps/4/4kvideodownloader.sh` |
| 4kvideodownloader | `maclib::4kvideodownloader::uninstall` | Uninstall "4K Video Downloader" | implemented | no clean uninstall | `lib/apps/4/4kvideodownloader.sh` |

| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::suite_installer_url` | "4K Video Downloader+" installer URL (Installomator) | implemented | team "GHQ37VJF83"; "dmg" | `lib/apps/4/4kvideodownloaderplus.sh` |
| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::latest_version` | "4K Video Downloader+" current build | implemented | Installomator appNewVersion logic | `lib/apps/4/4kvideodownloaderplus.sh` |
| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::is_installed` | Return 0 if "4K Video Downloader+" installed | implemented | team "GHQ37VJF83"; "dmg" | `lib/apps/4/4kvideodownloaderplus.sh` |
| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::installed_path` | Path to installed "4K Video Downloader+" bundle | implemented |  | `lib/apps/4/4kvideodownloaderplus.sh` |
| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::install` | Download installer and install "4K Video Downloader+" | implemented | requires root | `lib/apps/4/4kvideodownloaderplus.sh` |
| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::update` | Update "4K Video Downloader+" | implemented | no update path | `lib/apps/4/4kvideodownloaderplus.sh` |
| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::uninstall` | Uninstall "4K Video Downloader+" | implemented | no clean uninstall | `lib/apps/4/4kvideodownloaderplus.sh` |

| 8x8 | `maclib::8x8::suite_installer_url` | "8x8 Work" installer URL (Installomator) | implemented | team "FC967L3QRG"; "dmg" | `lib/apps/8/8x8.sh` |
| 8x8 | `maclib::8x8::latest_version` | "8x8 Work" current build | implemented | Installomator appNewVersion logic | `lib/apps/8/8x8.sh` |
| 8x8 | `maclib::8x8::is_installed` | Return 0 if "8x8 Work" installed | implemented | team "FC967L3QRG"; "dmg" | `lib/apps/8/8x8.sh` |
| 8x8 | `maclib::8x8::installed_path` | Path to installed "8x8 Work" bundle | implemented |  | `lib/apps/8/8x8.sh` |
| 8x8 | `maclib::8x8::install` | Download installer and install "8x8 Work" | implemented | requires root | `lib/apps/8/8x8.sh` |
| 8x8 | `maclib::8x8::update` | Update "8x8 Work" | implemented | no update path | `lib/apps/8/8x8.sh` |
| 8x8 | `maclib::8x8::uninstall` | Uninstall "8x8 Work" | implemented | no clean uninstall | `lib/apps/8/8x8.sh` |

| abetterfinderattributes7 | `maclib::abetterfinderattributes7::suite_installer_url` | "A Better Finder Attributes 7" installer URL (Installomator) | implemented | team "7Y9KW4ND8W"; "dmg" | `lib/apps/a/abetterfinderattributes7.sh` |
| abetterfinderattributes7 | `maclib::abetterfinderattributes7::latest_version` | "A Better Finder Attributes 7" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abetterfinderattributes7.sh` |
| abetterfinderattributes7 | `maclib::abetterfinderattributes7::is_installed` | Return 0 if "A Better Finder Attributes 7" installed | implemented | team "7Y9KW4ND8W"; "dmg" | `lib/apps/a/abetterfinderattributes7.sh` |
| abetterfinderattributes7 | `maclib::abetterfinderattributes7::installed_path` | Path to installed "A Better Finder Attributes 7" bundle | implemented |  | `lib/apps/a/abetterfinderattributes7.sh` |
| abetterfinderattributes7 | `maclib::abetterfinderattributes7::install` | Download installer and install "A Better Finder Attributes 7" | implemented | requires root | `lib/apps/a/abetterfinderattributes7.sh` |
| abetterfinderattributes7 | `maclib::abetterfinderattributes7::update` | Update "A Better Finder Attributes 7" | implemented | no update path | `lib/apps/a/abetterfinderattributes7.sh` |
| abetterfinderattributes7 | `maclib::abetterfinderattributes7::uninstall` | Uninstall "A Better Finder Attributes 7" | implemented | no clean uninstall | `lib/apps/a/abetterfinderattributes7.sh` |

| abetterfinderrename11 | `maclib::abetterfinderrename11::suite_installer_url` | "A Better Finder Rename 11" installer URL (Installomator) | implemented | team "7Y9KW4ND8W"; "dmg" | `lib/apps/a/abetterfinderrename11.sh` |
| abetterfinderrename11 | `maclib::abetterfinderrename11::latest_version` | "A Better Finder Rename 11" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abetterfinderrename11.sh` |
| abetterfinderrename11 | `maclib::abetterfinderrename11::is_installed` | Return 0 if "A Better Finder Rename 11" installed | implemented | team "7Y9KW4ND8W"; "dmg" | `lib/apps/a/abetterfinderrename11.sh` |
| abetterfinderrename11 | `maclib::abetterfinderrename11::installed_path` | Path to installed "A Better Finder Rename 11" bundle | implemented |  | `lib/apps/a/abetterfinderrename11.sh` |
| abetterfinderrename11 | `maclib::abetterfinderrename11::install` | Download installer and install "A Better Finder Rename 11" | implemented | requires root | `lib/apps/a/abetterfinderrename11.sh` |
| abetterfinderrename11 | `maclib::abetterfinderrename11::update` | Update "A Better Finder Rename 11" | implemented | no update path | `lib/apps/a/abetterfinderrename11.sh` |
| abetterfinderrename11 | `maclib::abetterfinderrename11::uninstall` | Uninstall "A Better Finder Rename 11" | implemented | no clean uninstall | `lib/apps/a/abetterfinderrename11.sh` |

| abetterfinderrename12 | `maclib::abetterfinderrename12::suite_installer_url` | "A Better Finder Rename 12" installer URL (Installomator) | implemented | team "7Y9KW4ND8W"; "dmg" | `lib/apps/a/abetterfinderrename12.sh` |
| abetterfinderrename12 | `maclib::abetterfinderrename12::latest_version` | "A Better Finder Rename 12" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abetterfinderrename12.sh` |
| abetterfinderrename12 | `maclib::abetterfinderrename12::is_installed` | Return 0 if "A Better Finder Rename 12" installed | implemented | team "7Y9KW4ND8W"; "dmg" | `lib/apps/a/abetterfinderrename12.sh` |
| abetterfinderrename12 | `maclib::abetterfinderrename12::installed_path` | Path to installed "A Better Finder Rename 12" bundle | implemented |  | `lib/apps/a/abetterfinderrename12.sh` |
| abetterfinderrename12 | `maclib::abetterfinderrename12::install` | Download installer and install "A Better Finder Rename 12" | implemented | requires root | `lib/apps/a/abetterfinderrename12.sh` |
| abetterfinderrename12 | `maclib::abetterfinderrename12::update` | Update "A Better Finder Rename 12" | implemented | no update path | `lib/apps/a/abetterfinderrename12.sh` |
| abetterfinderrename12 | `maclib::abetterfinderrename12::uninstall` | Uninstall "A Better Finder Rename 12" | implemented | no clean uninstall | `lib/apps/a/abetterfinderrename12.sh` |

| abletonlive12intro | `maclib::abletonlive12intro::suite_installer_url` | "Ableton Live 12 Intro" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12intro.sh` |
| abletonlive12intro | `maclib::abletonlive12intro::latest_version` | "Ableton Live 12 Intro" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abletonlive12intro.sh` |
| abletonlive12intro | `maclib::abletonlive12intro::is_installed` | Return 0 if "Ableton Live 12 Intro" installed | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12intro.sh` |
| abletonlive12intro | `maclib::abletonlive12intro::installed_path` | Path to installed "Ableton Live 12 Intro" bundle | implemented |  | `lib/apps/a/abletonlive12intro.sh` |
| abletonlive12intro | `maclib::abletonlive12intro::install` | Download installer and install "Ableton Live 12 Intro" | implemented | requires root | `lib/apps/a/abletonlive12intro.sh` |
| abletonlive12intro | `maclib::abletonlive12intro::update` | Update "Ableton Live 12 Intro" | implemented | no update path | `lib/apps/a/abletonlive12intro.sh` |
| abletonlive12intro | `maclib::abletonlive12intro::uninstall` | Uninstall "Ableton Live 12 Intro" | implemented | no clean uninstall | `lib/apps/a/abletonlive12intro.sh` |

| abletonlive12lite | `maclib::abletonlive12lite::suite_installer_url` | "Ableton Live 12 Lite" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12lite.sh` |
| abletonlive12lite | `maclib::abletonlive12lite::latest_version` | "Ableton Live 12 Lite" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abletonlive12lite.sh` |
| abletonlive12lite | `maclib::abletonlive12lite::is_installed` | Return 0 if "Ableton Live 12 Lite" installed | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12lite.sh` |
| abletonlive12lite | `maclib::abletonlive12lite::installed_path` | Path to installed "Ableton Live 12 Lite" bundle | implemented |  | `lib/apps/a/abletonlive12lite.sh` |
| abletonlive12lite | `maclib::abletonlive12lite::install` | Download installer and install "Ableton Live 12 Lite" | implemented | requires root | `lib/apps/a/abletonlive12lite.sh` |
| abletonlive12lite | `maclib::abletonlive12lite::update` | Update "Ableton Live 12 Lite" | implemented | no update path | `lib/apps/a/abletonlive12lite.sh` |
| abletonlive12lite | `maclib::abletonlive12lite::uninstall` | Uninstall "Ableton Live 12 Lite" | implemented | no clean uninstall | `lib/apps/a/abletonlive12lite.sh` |

| abletonlive12standard | `maclib::abletonlive12standard::suite_installer_url` | "Ableton Live 12 Standard" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12standard.sh` |
| abletonlive12standard | `maclib::abletonlive12standard::latest_version` | "Ableton Live 12 Standard" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abletonlive12standard.sh` |
| abletonlive12standard | `maclib::abletonlive12standard::is_installed` | Return 0 if "Ableton Live 12 Standard" installed | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12standard.sh` |
| abletonlive12standard | `maclib::abletonlive12standard::installed_path` | Path to installed "Ableton Live 12 Standard" bundle | implemented |  | `lib/apps/a/abletonlive12standard.sh` |
| abletonlive12standard | `maclib::abletonlive12standard::install` | Download installer and install "Ableton Live 12 Standard" | implemented | requires root | `lib/apps/a/abletonlive12standard.sh` |
| abletonlive12standard | `maclib::abletonlive12standard::update` | Update "Ableton Live 12 Standard" | implemented | no update path | `lib/apps/a/abletonlive12standard.sh` |
| abletonlive12standard | `maclib::abletonlive12standard::uninstall` | Uninstall "Ableton Live 12 Standard" | implemented | no clean uninstall | `lib/apps/a/abletonlive12standard.sh` |

| abletonlive12suite | `maclib::abletonlive12suite::suite_installer_url` | "Ableton Live 12 Suite" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12suite.sh` |
| abletonlive12suite | `maclib::abletonlive12suite::latest_version` | "Ableton Live 12 Suite" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abletonlive12suite.sh` |
| abletonlive12suite | `maclib::abletonlive12suite::is_installed` | Return 0 if "Ableton Live 12 Suite" installed | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12suite.sh` |
| abletonlive12suite | `maclib::abletonlive12suite::installed_path` | Path to installed "Ableton Live 12 Suite" bundle | implemented |  | `lib/apps/a/abletonlive12suite.sh` |
| abletonlive12suite | `maclib::abletonlive12suite::install` | Download installer and install "Ableton Live 12 Suite" | implemented | requires root | `lib/apps/a/abletonlive12suite.sh` |
| abletonlive12suite | `maclib::abletonlive12suite::update` | Update "Ableton Live 12 Suite" | implemented | no update path | `lib/apps/a/abletonlive12suite.sh` |
| abletonlive12suite | `maclib::abletonlive12suite::uninstall` | Uninstall "Ableton Live 12 Suite" | implemented | no clean uninstall | `lib/apps/a/abletonlive12suite.sh` |

| abletonlive12trial | `maclib::abletonlive12trial::suite_installer_url` | "Ableton Live 12 Trial" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12trial.sh` |
| abletonlive12trial | `maclib::abletonlive12trial::latest_version` | "Ableton Live 12 Trial" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abletonlive12trial.sh` |
| abletonlive12trial | `maclib::abletonlive12trial::is_installed` | Return 0 if "Ableton Live 12 Trial" installed | implemented | team "MWR434WD94"; "dmg" | `lib/apps/a/abletonlive12trial.sh` |
| abletonlive12trial | `maclib::abletonlive12trial::installed_path` | Path to installed "Ableton Live 12 Trial" bundle | implemented |  | `lib/apps/a/abletonlive12trial.sh` |
| abletonlive12trial | `maclib::abletonlive12trial::install` | Download installer and install "Ableton Live 12 Trial" | implemented | requires root | `lib/apps/a/abletonlive12trial.sh` |
| abletonlive12trial | `maclib::abletonlive12trial::update` | Update "Ableton Live 12 Trial" | implemented | no update path | `lib/apps/a/abletonlive12trial.sh` |
| abletonlive12trial | `maclib::abletonlive12trial::uninstall` | Uninstall "Ableton Live 12 Trial" | implemented | no clean uninstall | `lib/apps/a/abletonlive12trial.sh` |

| abstract | `maclib::abstract::suite_installer_url` | "Abstract" installer URL (Installomator) | implemented | team "77MZLZE47D"; "zip" | `lib/apps/a/abstract.sh` |
| abstract | `maclib::abstract::latest_version` | "Abstract" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/abstract.sh` |
| abstract | `maclib::abstract::is_installed` | Return 0 if "Abstract" installed | implemented | team "77MZLZE47D"; "zip" | `lib/apps/a/abstract.sh` |
| abstract | `maclib::abstract::installed_path` | Path to installed "Abstract" bundle | implemented |  | `lib/apps/a/abstract.sh` |
| abstract | `maclib::abstract::install` | Download installer and install "Abstract" | implemented | requires root | `lib/apps/a/abstract.sh` |
| abstract | `maclib::abstract::update` | Update "Abstract" | implemented | no update path | `lib/apps/a/abstract.sh` |
| abstract | `maclib::abstract::uninstall` | Uninstall "Abstract" | implemented | no clean uninstall | `lib/apps/a/abstract.sh` |

| acorn | `maclib::acorn::suite_installer_url` | "Acorn" installer URL (Installomator) | implemented | team "WZCN9HJ4VP"; "zip" | `lib/apps/a/acorn.sh` |
| acorn | `maclib::acorn::latest_version` | "Acorn" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/acorn.sh` |
| acorn | `maclib::acorn::is_installed` | Return 0 if "Acorn" installed | implemented | team "WZCN9HJ4VP"; "zip" | `lib/apps/a/acorn.sh` |
| acorn | `maclib::acorn::installed_path` | Path to installed "Acorn" bundle | implemented |  | `lib/apps/a/acorn.sh` |
| acorn | `maclib::acorn::install` | Download installer and install "Acorn" | implemented | requires root | `lib/apps/a/acorn.sh` |
| acorn | `maclib::acorn::update` | Update "Acorn" | implemented | no update path | `lib/apps/a/acorn.sh` |
| acorn | `maclib::acorn::uninstall` | Uninstall "Acorn" | implemented | no clean uninstall | `lib/apps/a/acorn.sh` |

| adium | `maclib::adium::suite_installer_url` | "Adium" installer URL (Installomator) | implemented | team "VQ6ZEL8UD3"; "dmg" | `lib/apps/a/adium.sh` |
| adium | `maclib::adium::latest_version` | "Adium" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/adium.sh` |
| adium | `maclib::adium::is_installed` | Return 0 if "Adium" installed | implemented | team "VQ6ZEL8UD3"; "dmg" | `lib/apps/a/adium.sh` |
| adium | `maclib::adium::installed_path` | Path to installed "Adium" bundle | implemented |  | `lib/apps/a/adium.sh` |
| adium | `maclib::adium::install` | Download installer and install "Adium" | implemented | requires root | `lib/apps/a/adium.sh` |
| adium | `maclib::adium::update` | Update "Adium" | implemented | no update path | `lib/apps/a/adium.sh` |
| adium | `maclib::adium::uninstall` | Uninstall "Adium" | implemented | no clean uninstall | `lib/apps/a/adium.sh` |

| adobeacrobatprodc | `maclib::adobeacrobatprodc::suite_installer_url` | "Adobe Acrobat Pro DC" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "pkgInDmg" | `lib/apps/a/adobeacrobatprodc.sh` |
| adobeacrobatprodc | `maclib::adobeacrobatprodc::latest_version` | "Adobe Acrobat Pro DC" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/adobeacrobatprodc.sh` |
| adobeacrobatprodc | `maclib::adobeacrobatprodc::is_installed` | Return 0 if "Adobe Acrobat Pro DC" installed | implemented | team "JQ525L2MZD"; "pkgInDmg" | `lib/apps/a/adobeacrobatprodc.sh` |
| adobeacrobatprodc | `maclib::adobeacrobatprodc::installed_path` | Path to installed "Adobe Acrobat Pro DC" bundle | implemented |  | `lib/apps/a/adobeacrobatprodc.sh` |
| adobeacrobatprodc | `maclib::adobeacrobatprodc::install` | Download installer and install "Adobe Acrobat Pro DC" | implemented | requires root | `lib/apps/a/adobeacrobatprodc.sh` |
| adobeacrobatprodc | `maclib::adobeacrobatprodc::update` | Update "Adobe Acrobat Pro DC" | implemented | no update path | `lib/apps/a/adobeacrobatprodc.sh` |
| adobeacrobatprodc | `maclib::adobeacrobatprodc::uninstall` | Uninstall "Adobe Acrobat Pro DC" | implemented | no clean uninstall | `lib/apps/a/adobeacrobatprodc.sh` |

| adobeconnect | `maclib::adobeconnect::suite_installer_url` | "AdobeConnectInstaller" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "dmg" | `lib/apps/a/adobeconnect.sh` |
| adobeconnect | `maclib::adobeconnect::latest_version` | "AdobeConnectInstaller" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/adobeconnect.sh` |
| adobeconnect | `maclib::adobeconnect::is_installed` | Return 0 if "AdobeConnectInstaller" installed | implemented | team "JQ525L2MZD"; "dmg" | `lib/apps/a/adobeconnect.sh` |
| adobeconnect | `maclib::adobeconnect::installed_path` | Path to installed "AdobeConnectInstaller" bundle | implemented |  | `lib/apps/a/adobeconnect.sh` |
| adobeconnect | `maclib::adobeconnect::install` | Download installer and install "AdobeConnectInstaller" | implemented | requires root | `lib/apps/a/adobeconnect.sh` |
| adobeconnect | `maclib::adobeconnect::update` | Update "AdobeConnectInstaller" | implemented | no update path | `lib/apps/a/adobeconnect.sh` |
| adobeconnect | `maclib::adobeconnect::uninstall` | Uninstall "AdobeConnectInstaller" | implemented | no clean uninstall | `lib/apps/a/adobeconnect.sh` |

| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::suite_installer_url` | "Adobe Creative Cloud" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "dmg" | `lib/apps/a/adobecreativeclouddesktop.sh` |
| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::latest_version` | "Adobe Creative Cloud" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/adobecreativeclouddesktop.sh` |
| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::is_installed` | Return 0 if "Adobe Creative Cloud" installed | implemented | team "JQ525L2MZD"; "dmg" | `lib/apps/a/adobecreativeclouddesktop.sh` |
| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::installed_path` | Path to installed "Adobe Creative Cloud" bundle | implemented |  | `lib/apps/a/adobecreativeclouddesktop.sh` |
| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::install` | Download installer and install "Adobe Creative Cloud" | implemented | requires root | `lib/apps/a/adobecreativeclouddesktop.sh` |
| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::update` | Update "Adobe Creative Cloud" | implemented | no update path | `lib/apps/a/adobecreativeclouddesktop.sh` |
| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::uninstall` | Uninstall "Adobe Creative Cloud" | implemented | no clean uninstall | `lib/apps/a/adobecreativeclouddesktop.sh` |

||| adobereaderdc-update | `maclib::adobereaderdc-update::suite_installer_url` | "Adobe Acrobat Reader DC" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "pkgInDmg" |
||| adobereaderdc-update | `maclib::adobereaderdc-update::latest_version` | "Adobe Acrobat Reader DC" current build | implemented | Installomator appNewVersion logic |
||| adobereaderdc-update | `maclib::adobereaderdc-update::is_installed` | Return 0 if "Adobe Acrobat Reader DC" installed | implemented | team "JQ525L2MZD"; "pkgInDmg" |
||| adobereaderdc-update | `maclib::adobereaderdc-update::installed_path` | Path to installed "Adobe Acrobat Reader DC" bundle | implemented | |
||| adobereaderdc-update | `maclib::adobereaderdc-update::install` | Download installer and install "Adobe Acrobat Reader DC" | implemented | requires root |
||| adobereaderdc-update | `maclib::adobereaderdc-update::update` | Update "Adobe Acrobat Reader DC" | implemented | no update path |
||| adobereaderdc-update | `maclib::adobereaderdc-update::uninstall` | Uninstall "Adobe Acrobat Reader DC" | implemented | no clean uninstall |

| aftermath | `maclib::aftermath::suite_installer_url` | "Aftermath" installer URL (Installomator) | implemented | team "483DWKW443"; "pkg" | `lib/apps/a/aftermath.sh` |
| aftermath | `maclib::aftermath::latest_version` | "Aftermath" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/aftermath.sh` |
| aftermath | `maclib::aftermath::is_installed` | Return 0 if "Aftermath" installed | implemented | team "483DWKW443"; "pkg" | `lib/apps/a/aftermath.sh` |
| aftermath | `maclib::aftermath::installed_path` | Path to installed "Aftermath" bundle | implemented |  | `lib/apps/a/aftermath.sh` |
| aftermath | `maclib::aftermath::install` | Download installer and install "Aftermath" | implemented | requires root | `lib/apps/a/aftermath.sh` |
| aftermath | `maclib::aftermath::update` | Update "Aftermath" | implemented | no update path | `lib/apps/a/aftermath.sh` |
| aftermath | `maclib::aftermath::uninstall` | Uninstall "Aftermath" | implemented | no clean uninstall | `lib/apps/a/aftermath.sh` |

| airflow | `maclib::airflow::suite_installer_url` | "Air" installer URL (Installomator) | implemented | team "8RBYE8TY7T"; "dmg" | `lib/apps/a/airflow.sh` |
| airflow | `maclib::airflow::latest_version` | "Air" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/airflow.sh` |
| airflow | `maclib::airflow::is_installed` | Return 0 if "Air" installed | implemented | team "8RBYE8TY7T"; "dmg" | `lib/apps/a/airflow.sh` |
| airflow | `maclib::airflow::installed_path` | Path to installed "Air" bundle | implemented |  | `lib/apps/a/airflow.sh` |
| airflow | `maclib::airflow::install` | Download installer and install "Air" | implemented | requires root | `lib/apps/a/airflow.sh` |
| airflow | `maclib::airflow::update` | Update "Air" | implemented | no update path | `lib/apps/a/airflow.sh` |
| airflow | `maclib::airflow::uninstall` | Uninstall "Air" | implemented | no clean uninstall | `lib/apps/a/airflow.sh` |

| airserver | `maclib::airserver::suite_installer_url` | "AirServer" installer URL (Installomator) | implemented | team "6C755KS5W3"; "dmg" | `lib/apps/a/airserver.sh` |
| airserver | `maclib::airserver::latest_version` | "AirServer" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/airserver.sh` |
| airserver | `maclib::airserver::is_installed` | Return 0 if "AirServer" installed | implemented | team "6C755KS5W3"; "dmg" | `lib/apps/a/airserver.sh` |
| airserver | `maclib::airserver::installed_path` | Path to installed "AirServer" bundle | implemented |  | `lib/apps/a/airserver.sh` |
| airserver | `maclib::airserver::install` | Download installer and install "AirServer" | implemented | requires root | `lib/apps/a/airserver.sh` |
| airserver | `maclib::airserver::update` | Update "AirServer" | implemented | no update path | `lib/apps/a/airserver.sh` |
| airserver | `maclib::airserver::uninstall` | Uninstall "AirServer" | implemented | no clean uninstall | `lib/apps/a/airserver.sh` |

| aldente | `maclib::aldente::suite_installer_url` | "AlDente" installer URL (Installomator) | implemented | team "3WVC84GB99"; "dmg" | `lib/apps/a/aldente.sh` |
| aldente | `maclib::aldente::latest_version` | "AlDente" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/aldente.sh` |
| aldente | `maclib::aldente::is_installed` | Return 0 if "AlDente" installed | implemented | team "3WVC84GB99"; "dmg" | `lib/apps/a/aldente.sh` |
| aldente | `maclib::aldente::installed_path` | Path to installed "AlDente" bundle | implemented |  | `lib/apps/a/aldente.sh` |
| aldente | `maclib::aldente::install` | Download installer and install "AlDente" | implemented | requires root | `lib/apps/a/aldente.sh` |
| aldente | `maclib::aldente::update` | Update "AlDente" | implemented | no update path | `lib/apps/a/aldente.sh` |
| aldente | `maclib::aldente::uninstall` | Uninstall "AlDente" | implemented | no clean uninstall | `lib/apps/a/aldente.sh` |

| alephone | `maclib::alephone::suite_installer_url` | "Aleph One" installer URL (Installomator) | implemented | team "E8K89CXZE7"; "dmg" | `lib/apps/a/alephone.sh` |
| alephone | `maclib::alephone::latest_version` | "Aleph One" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/alephone.sh` |
| alephone | `maclib::alephone::is_installed` | Return 0 if "Aleph One" installed | implemented | team "E8K89CXZE7"; "dmg" | `lib/apps/a/alephone.sh` |
| alephone | `maclib::alephone::installed_path` | Path to installed "Aleph One" bundle | implemented |  | `lib/apps/a/alephone.sh` |
| alephone | `maclib::alephone::install` | Download installer and install "Aleph One" | implemented | requires root | `lib/apps/a/alephone.sh` |
| alephone | `maclib::alephone::update` | Update "Aleph One" | implemented | no update path | `lib/apps/a/alephone.sh` |
| alephone | `maclib::alephone::uninstall` | Uninstall "Aleph One" | implemented | no clean uninstall | `lib/apps/a/alephone.sh` |

| alfred | `maclib::alfred::suite_installer_url` | "Alfred" installer URL (Installomator) | implemented | team "XZZXE9SED4"; "dmg" | `lib/apps/a/alfred.sh` |
| alfred | `maclib::alfred::latest_version` | "Alfred" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/alfred.sh` |
| alfred | `maclib::alfred::is_installed` | Return 0 if "Alfred" installed | implemented | team "XZZXE9SED4"; "dmg" | `lib/apps/a/alfred.sh` |
| alfred | `maclib::alfred::installed_path` | Path to installed "Alfred" bundle | implemented |  | `lib/apps/a/alfred.sh` |
| alfred | `maclib::alfred::install` | Download installer and install "Alfred" | implemented | requires root | `lib/apps/a/alfred.sh` |
| alfred | `maclib::alfred::update` | Update "Alfred" | implemented | no update path | `lib/apps/a/alfred.sh` |
| alfred | `maclib::alfred::uninstall` | Uninstall "Alfred" | implemented | no clean uninstall | `lib/apps/a/alfred.sh` |

| altserver | `maclib::altserver::suite_installer_url` | "AltServer" installer URL (Installomator) | implemented | team "6XVY5G3U44"; "zip" | `lib/apps/a/altserver.sh` |
| altserver | `maclib::altserver::latest_version` | "AltServer" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/altserver.sh` |
| altserver | `maclib::altserver::is_installed` | Return 0 if "AltServer" installed | implemented | team "6XVY5G3U44"; "zip" | `lib/apps/a/altserver.sh` |
| altserver | `maclib::altserver::installed_path` | Path to installed "AltServer" bundle | implemented |  | `lib/apps/a/altserver.sh` |
| altserver | `maclib::altserver::install` | Download installer and install "AltServer" | implemented | requires root | `lib/apps/a/altserver.sh` |
| altserver | `maclib::altserver::update` | Update "AltServer" | implemented | no update path | `lib/apps/a/altserver.sh` |
| altserver | `maclib::altserver::uninstall` | Uninstall "AltServer" | implemented | no clean uninstall | `lib/apps/a/altserver.sh` |

| alttab | `maclib::alttab::suite_installer_url` | "AltTab" installer URL (Installomator) | implemented | team "QXD7GW8FHY"; "zip" | `lib/apps/a/alttab.sh` |
| alttab | `maclib::alttab::latest_version` | "AltTab" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/alttab.sh` |
| alttab | `maclib::alttab::is_installed` | Return 0 if "AltTab" installed | implemented | team "QXD7GW8FHY"; "zip" | `lib/apps/a/alttab.sh` |
| alttab | `maclib::alttab::installed_path` | Path to installed "AltTab" bundle | implemented |  | `lib/apps/a/alttab.sh` |
| alttab | `maclib::alttab::install` | Download installer and install "AltTab" | implemented | requires root | `lib/apps/a/alttab.sh` |
| alttab | `maclib::alttab::update` | Update "AltTab" | implemented | no update path | `lib/apps/a/alttab.sh` |
| alttab | `maclib::alttab::uninstall` | Uninstall "AltTab" | implemented | no clean uninstall | `lib/apps/a/alttab.sh` |

| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::suite_installer_url` | "Amazon Corretto 11 JDK" installer URL (Installomator) | implemented | "pkg" | `lib/apps/a/amazoncorretto11jdk.sh` |
| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::latest_version` | "Amazon Corretto 11 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto11jdk.sh` |
| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::is_installed` | Return 0 if "Amazon Corretto 11 JDK" installed | implemented | "pkg" | `lib/apps/a/amazoncorretto11jdk.sh` |
| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::installed_path` | Path to installed "Amazon Corretto 11 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto11jdk.sh` |
| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::install` | Download installer and install "Amazon Corretto 11 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto11jdk.sh` |
| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::update` | Update "Amazon Corretto 11 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto11jdk.sh` |
| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::uninstall` | Uninstall "Amazon Corretto 11 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto11jdk.sh` |

| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::suite_installer_url` | "Amazon Corretto 17 JDK" installer URL (Installomator) | implemented | "pkg" | `lib/apps/a/amazoncorretto17jdk.sh` |
| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::latest_version` | "Amazon Corretto 17 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto17jdk.sh` |
| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::is_installed` | Return 0 if "Amazon Corretto 17 JDK" installed | implemented | "pkg" | `lib/apps/a/amazoncorretto17jdk.sh` |
| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::installed_path` | Path to installed "Amazon Corretto 17 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto17jdk.sh` |
| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::install` | Download installer and install "Amazon Corretto 17 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto17jdk.sh` |
| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::update` | Update "Amazon Corretto 17 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto17jdk.sh` |
| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::uninstall` | Uninstall "Amazon Corretto 17 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto17jdk.sh` |

| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::suite_installer_url` | "Amazon Corretto 21 JDK" installer URL (Installomator) | implemented | "pkg" | `lib/apps/a/amazoncorretto21jdk.sh` |
| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::latest_version` | "Amazon Corretto 21 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto21jdk.sh` |
| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::is_installed` | Return 0 if "Amazon Corretto 21 JDK" installed | implemented | "pkg" | `lib/apps/a/amazoncorretto21jdk.sh` |
| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::installed_path` | Path to installed "Amazon Corretto 21 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto21jdk.sh` |
| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::install` | Download installer and install "Amazon Corretto 21 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto21jdk.sh` |
| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::update` | Update "Amazon Corretto 21 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto21jdk.sh` |
| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::uninstall` | Uninstall "Amazon Corretto 21 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto21jdk.sh` |

| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::suite_installer_url` | "Amazon Corretto 22 JDK" installer URL (Installomator) | implemented | "pkg" | `lib/apps/a/amazoncorretto22jdk.sh` |
| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::latest_version` | "Amazon Corretto 22 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto22jdk.sh` |
| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::is_installed` | Return 0 if "Amazon Corretto 22 JDK" installed | implemented | "pkg" | `lib/apps/a/amazoncorretto22jdk.sh` |
| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::installed_path` | Path to installed "Amazon Corretto 22 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto22jdk.sh` |
| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::install` | Download installer and install "Amazon Corretto 22 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto22jdk.sh` |
| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::update` | Update "Amazon Corretto 22 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto22jdk.sh` |
| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::uninstall` | Uninstall "Amazon Corretto 22 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto22jdk.sh` |

| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::suite_installer_url` | "Amazon Corretto 23 JDK" installer URL (Installomator) | implemented | "pkg" | `lib/apps/a/amazoncorretto23jdk.sh` |
| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::latest_version` | "Amazon Corretto 23 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto23jdk.sh` |
| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::is_installed` | Return 0 if "Amazon Corretto 23 JDK" installed | implemented | "pkg" | `lib/apps/a/amazoncorretto23jdk.sh` |
| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::installed_path` | Path to installed "Amazon Corretto 23 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto23jdk.sh` |
| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::install` | Download installer and install "Amazon Corretto 23 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto23jdk.sh` |
| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::update` | Update "Amazon Corretto 23 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto23jdk.sh` |
| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::uninstall` | Uninstall "Amazon Corretto 23 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto23jdk.sh` |

| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::suite_installer_url` | "Amazon Corretto 25 JDK" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/amazoncorretto25jdk.sh` |
| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::latest_version` | "Amazon Corretto 25 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto25jdk.sh` |
| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::is_installed` | Return 0 if "Amazon Corretto 25 JDK" installed | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/amazoncorretto25jdk.sh` |
| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::installed_path` | Path to installed "Amazon Corretto 25 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto25jdk.sh` |
| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::install` | Download installer and install "Amazon Corretto 25 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto25jdk.sh` |
| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::update` | Update "Amazon Corretto 25 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto25jdk.sh` |
| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::uninstall` | Uninstall "Amazon Corretto 25 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto25jdk.sh` |

| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::suite_installer_url` | "Amazon Corretto 8 JDK" installer URL (Installomator) | implemented | "pkg" | `lib/apps/a/amazoncorretto8jdk.sh` |
| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::latest_version` | "Amazon Corretto 8 JDK" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazoncorretto8jdk.sh` |
| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::is_installed` | Return 0 if "Amazon Corretto 8 JDK" installed | implemented | "pkg" | `lib/apps/a/amazoncorretto8jdk.sh` |
| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::installed_path` | Path to installed "Amazon Corretto 8 JDK" bundle | implemented |  | `lib/apps/a/amazoncorretto8jdk.sh` |
| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::install` | Download installer and install "Amazon Corretto 8 JDK" | implemented | requires root | `lib/apps/a/amazoncorretto8jdk.sh` |
| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::update` | Update "Amazon Corretto 8 JDK" | implemented | no update path | `lib/apps/a/amazoncorretto8jdk.sh` |
| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::uninstall` | Uninstall "Amazon Corretto 8 JDK" | implemented | no clean uninstall | `lib/apps/a/amazoncorretto8jdk.sh` |

| amazonq | `maclib::amazonq::suite_installer_url` | "Amazon Q" installer URL (Installomator) | implemented | team "94KV3E626L"; "dmg" | `lib/apps/a/amazonq.sh` |
| amazonq | `maclib::amazonq::latest_version` | "Amazon Q" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazonq.sh` |
| amazonq | `maclib::amazonq::is_installed` | Return 0 if "Amazon Q" installed | implemented | team "94KV3E626L"; "dmg" | `lib/apps/a/amazonq.sh` |
| amazonq | `maclib::amazonq::installed_path` | Path to installed "Amazon Q" bundle | implemented |  | `lib/apps/a/amazonq.sh` |
| amazonq | `maclib::amazonq::install` | Download installer and install "Amazon Q" | implemented | requires root | `lib/apps/a/amazonq.sh` |
| amazonq | `maclib::amazonq::update` | Update "Amazon Q" | implemented | no update path | `lib/apps/a/amazonq.sh` |
| amazonq | `maclib::amazonq::uninstall` | Uninstall "Amazon Q" | implemented | no clean uninstall | `lib/apps/a/amazonq.sh` |

| amazonworkspaces | `maclib::amazonworkspaces::suite_installer_url` | "Workspaces" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/amazonworkspaces.sh` |
| amazonworkspaces | `maclib::amazonworkspaces::latest_version` | "Workspaces" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/amazonworkspaces.sh` |
| amazonworkspaces | `maclib::amazonworkspaces::is_installed` | Return 0 if "Workspaces" installed | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/amazonworkspaces.sh` |
| amazonworkspaces | `maclib::amazonworkspaces::installed_path` | Path to installed "Workspaces" bundle | implemented |  | `lib/apps/a/amazonworkspaces.sh` |
| amazonworkspaces | `maclib::amazonworkspaces::install` | Download installer and install "Workspaces" | implemented | requires root | `lib/apps/a/amazonworkspaces.sh` |
| amazonworkspaces | `maclib::amazonworkspaces::update` | Update "Workspaces" | implemented | no update path | `lib/apps/a/amazonworkspaces.sh` |
| amazonworkspaces | `maclib::amazonworkspaces::uninstall` | Uninstall "Workspaces" | implemented | no clean uninstall | `lib/apps/a/amazonworkspaces.sh` |

| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::suite_installer_url` | "ExtensionManager" installer URL (Installomator) | implemented | team "D3SBBNFWTC"; "zip" | `lib/apps/a/anastasiysextensionmanager.sh` |
| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::latest_version` | "ExtensionManager" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/anastasiysextensionmanager.sh` |
| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::is_installed` | Return 0 if "ExtensionManager" installed | implemented | team "D3SBBNFWTC"; "zip" | `lib/apps/a/anastasiysextensionmanager.sh` |
| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::installed_path` | Path to installed "ExtensionManager" bundle | implemented |  | `lib/apps/a/anastasiysextensionmanager.sh` |
| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::install` | Download installer and install "ExtensionManager" | implemented | requires root | `lib/apps/a/anastasiysextensionmanager.sh` |
| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::update` | Update "ExtensionManager" | implemented | no update path | `lib/apps/a/anastasiysextensionmanager.sh` |
| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::uninstall` | Uninstall "ExtensionManager" | implemented | no clean uninstall | `lib/apps/a/anastasiysextensionmanager.sh` |

| androidfiletransfer | `maclib::androidfiletransfer::suite_installer_url` | "Android File Transfer" installer URL (Installomator) | implemented | team "EQHXZ8M8AV"; "dmg" | `lib/apps/a/androidfiletransfer.sh` |
| androidfiletransfer | `maclib::androidfiletransfer::latest_version` | "Android File Transfer" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/androidfiletransfer.sh` |
| androidfiletransfer | `maclib::androidfiletransfer::is_installed` | Return 0 if "Android File Transfer" installed | implemented | team "EQHXZ8M8AV"; "dmg" | `lib/apps/a/androidfiletransfer.sh` |
| androidfiletransfer | `maclib::androidfiletransfer::installed_path` | Path to installed "Android File Transfer" bundle | implemented |  | `lib/apps/a/androidfiletransfer.sh` |
| androidfiletransfer | `maclib::androidfiletransfer::install` | Download installer and install "Android File Transfer" | implemented | requires root | `lib/apps/a/androidfiletransfer.sh` |
| androidfiletransfer | `maclib::androidfiletransfer::update` | Update "Android File Transfer" | implemented | no update path | `lib/apps/a/androidfiletransfer.sh` |
| androidfiletransfer | `maclib::androidfiletransfer::uninstall` | Uninstall "Android File Transfer" | implemented | no clean uninstall | `lib/apps/a/androidfiletransfer.sh` |

| anki | `maclib::anki::suite_installer_url` | "Anki" installer URL (Installomator) | implemented | team "7ZM8SLJM4P"; "dmg" | `lib/apps/a/anki.sh` |
| anki | `maclib::anki::latest_version` | "Anki" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/anki.sh` |
| anki | `maclib::anki::is_installed` | Return 0 if "Anki" installed | implemented | team "7ZM8SLJM4P"; "dmg" | `lib/apps/a/anki.sh` |
| anki | `maclib::anki::installed_path` | Path to installed "Anki" bundle | implemented |  | `lib/apps/a/anki.sh` |
| anki | `maclib::anki::install` | Download installer and install "Anki" | implemented | requires root | `lib/apps/a/anki.sh` |
| anki | `maclib::anki::update` | Update "Anki" | implemented | no update path | `lib/apps/a/anki.sh` |
| anki | `maclib::anki::uninstall` | Uninstall "Anki" | implemented | no clean uninstall | `lib/apps/a/anki.sh` |

| antconc | `maclib::antconc::suite_installer_url` | "AntConc" installer URL (Installomator) | implemented | team "28C42U4N5U"; "dmg" | `lib/apps/a/antconc.sh` |
| antconc | `maclib::antconc::latest_version` | "AntConc" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/antconc.sh` |
| antconc | `maclib::antconc::is_installed` | Return 0 if "AntConc" installed | implemented | team "28C42U4N5U"; "dmg" | `lib/apps/a/antconc.sh` |
| antconc | `maclib::antconc::installed_path` | Path to installed "AntConc" bundle | implemented |  | `lib/apps/a/antconc.sh` |
| antconc | `maclib::antconc::install` | Download installer and install "AntConc" | implemented | requires root | `lib/apps/a/antconc.sh` |
| antconc | `maclib::antconc::update` | Update "AntConc" | implemented | no update path | `lib/apps/a/antconc.sh` |
| antconc | `maclib::antconc::uninstall` | Uninstall "AntConc" | implemented | no clean uninstall | `lib/apps/a/antconc.sh` |

| apachedirectorystudio | `maclib::apachedirectorystudio::suite_installer_url` | "ApacheDirectoryStudio" installer URL (Installomator) | implemented | team "2GLGAFWEQD"; "dmg" | `lib/apps/a/apachedirectorystudio.sh` |
| apachedirectorystudio | `maclib::apachedirectorystudio::latest_version` | "ApacheDirectoryStudio" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/apachedirectorystudio.sh` |
| apachedirectorystudio | `maclib::apachedirectorystudio::is_installed` | Return 0 if "ApacheDirectoryStudio" installed | implemented | team "2GLGAFWEQD"; "dmg" | `lib/apps/a/apachedirectorystudio.sh` |
| apachedirectorystudio | `maclib::apachedirectorystudio::installed_path` | Path to installed "ApacheDirectoryStudio" bundle | implemented |  | `lib/apps/a/apachedirectorystudio.sh` |
| apachedirectorystudio | `maclib::apachedirectorystudio::install` | Download installer and install "ApacheDirectoryStudio" | implemented | requires root | `lib/apps/a/apachedirectorystudio.sh` |
| apachedirectorystudio | `maclib::apachedirectorystudio::update` | Update "ApacheDirectoryStudio" | implemented | no update path | `lib/apps/a/apachedirectorystudio.sh` |
| apachedirectorystudio | `maclib::apachedirectorystudio::uninstall` | Uninstall "ApacheDirectoryStudio" | implemented | no clean uninstall | `lib/apps/a/apachedirectorystudio.sh` |

| ape | `maclib::ape::suite_installer_url` | "ApE" installer URL (Installomator) | implemented | team "F5459JB4SG"; "dmg" | `lib/apps/a/ape.sh` |
| ape | `maclib::ape::latest_version` | "ApE" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/ape.sh` |
| ape | `maclib::ape::is_installed` | Return 0 if "ApE" installed | implemented | team "F5459JB4SG"; "dmg" | `lib/apps/a/ape.sh` |
| ape | `maclib::ape::installed_path` | Path to installed "ApE" bundle | implemented |  | `lib/apps/a/ape.sh` |
| ape | `maclib::ape::install` | Download installer and install "ApE" | implemented | requires root | `lib/apps/a/ape.sh` |
| ape | `maclib::ape::update` | Update "ApE" | implemented | no update path | `lib/apps/a/ape.sh` |
| ape | `maclib::ape::uninstall` | Uninstall "ApE" | implemented | no clean uninstall | `lib/apps/a/ape.sh` |

| apparency | `maclib::apparency::suite_installer_url` | "Apparency" installer URL (Installomator) | implemented | team "936EB786NH"; "dmg" | `lib/apps/a/apparency.sh` |
| apparency | `maclib::apparency::latest_version` | "Apparency" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/apparency.sh` |
| apparency | `maclib::apparency::is_installed` | Return 0 if "Apparency" installed | implemented | team "936EB786NH"; "dmg" | `lib/apps/a/apparency.sh` |
| apparency | `maclib::apparency::installed_path` | Path to installed "Apparency" bundle | implemented |  | `lib/apps/a/apparency.sh` |
| apparency | `maclib::apparency::install` | Download installer and install "Apparency" | implemented | requires root | `lib/apps/a/apparency.sh` |
| apparency | `maclib::apparency::update` | Update "Apparency" | implemented | no update path | `lib/apps/a/apparency.sh` |
| apparency | `maclib::apparency::uninstall` | Uninstall "Apparency" | implemented | no clean uninstall | `lib/apps/a/apparency.sh` |

| appcleaner | `maclib::appcleaner::suite_installer_url` | "AppCleaner" installer URL (Installomator) | implemented | team "X85ZX835W9"; "zip" | `lib/apps/a/appcleaner.sh` |
| appcleaner | `maclib::appcleaner::latest_version` | "AppCleaner" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/appcleaner.sh` |
| appcleaner | `maclib::appcleaner::is_installed` | Return 0 if "AppCleaner" installed | implemented | team "X85ZX835W9"; "zip" | `lib/apps/a/appcleaner.sh` |
| appcleaner | `maclib::appcleaner::installed_path` | Path to installed "AppCleaner" bundle | implemented |  | `lib/apps/a/appcleaner.sh` |
| appcleaner | `maclib::appcleaner::install` | Download installer and install "AppCleaner" | implemented | requires root | `lib/apps/a/appcleaner.sh` |
| appcleaner | `maclib::appcleaner::update` | Update "AppCleaner" | implemented | no update path | `lib/apps/a/appcleaner.sh` |
| appcleaner | `maclib::appcleaner::uninstall` | Uninstall "AppCleaner" | implemented | no clean uninstall | `lib/apps/a/appcleaner.sh` |

| applenyfonts | `maclib::applenyfonts::suite_installer_url` | "Apple New York Font Collection" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applenyfonts.sh` |
| applenyfonts | `maclib::applenyfonts::latest_version` | "Apple New York Font Collection" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/applenyfonts.sh` |
| applenyfonts | `maclib::applenyfonts::is_installed` | Return 0 if "Apple New York Font Collection" installed | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applenyfonts.sh` |
| applenyfonts | `maclib::applenyfonts::installed_path` | Path to installed "Apple New York Font Collection" bundle | implemented |  | `lib/apps/a/applenyfonts.sh` |
| applenyfonts | `maclib::applenyfonts::install` | Download installer and install "Apple New York Font Collection" | implemented | requires root | `lib/apps/a/applenyfonts.sh` |
| applenyfonts | `maclib::applenyfonts::update` | Update "Apple New York Font Collection" | implemented | no update path | `lib/apps/a/applenyfonts.sh` |
| applenyfonts | `maclib::applenyfonts::uninstall` | Uninstall "Apple New York Font Collection" | implemented | no clean uninstall | `lib/apps/a/applenyfonts.sh` |

| appleprovideoformats | `maclib::appleprovideoformats::suite_installer_url` | "ProVideoFormats" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/appleprovideoformats.sh` |
| appleprovideoformats | `maclib::appleprovideoformats::latest_version` | "ProVideoFormats" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/appleprovideoformats.sh` |
| appleprovideoformats | `maclib::appleprovideoformats::is_installed` | Return 0 if "ProVideoFormats" installed | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/appleprovideoformats.sh` |
| appleprovideoformats | `maclib::appleprovideoformats::installed_path` | Path to installed "ProVideoFormats" bundle | implemented |  | `lib/apps/a/appleprovideoformats.sh` |
| appleprovideoformats | `maclib::appleprovideoformats::install` | Download installer and install "ProVideoFormats" | implemented | requires root | `lib/apps/a/appleprovideoformats.sh` |
| appleprovideoformats | `maclib::appleprovideoformats::update` | Update "ProVideoFormats" | implemented | no update path | `lib/apps/a/appleprovideoformats.sh` |
| appleprovideoformats | `maclib::appleprovideoformats::uninstall` | Uninstall "ProVideoFormats" | implemented | no clean uninstall | `lib/apps/a/appleprovideoformats.sh` |

| applesfarabic | `maclib::applesfarabic::suite_installer_url` | "San Francisco Arabic" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfarabic.sh` |
| applesfarabic | `maclib::applesfarabic::latest_version` | "San Francisco Arabic" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/applesfarabic.sh` |
| applesfarabic | `maclib::applesfarabic::is_installed` | Return 0 if "San Francisco Arabic" installed | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfarabic.sh` |
| applesfarabic | `maclib::applesfarabic::installed_path` | Path to installed "San Francisco Arabic" bundle | implemented |  | `lib/apps/a/applesfarabic.sh` |
| applesfarabic | `maclib::applesfarabic::install` | Download installer and install "San Francisco Arabic" | implemented | requires root | `lib/apps/a/applesfarabic.sh` |
| applesfarabic | `maclib::applesfarabic::update` | Update "San Francisco Arabic" | implemented | no update path | `lib/apps/a/applesfarabic.sh` |
| applesfarabic | `maclib::applesfarabic::uninstall` | Uninstall "San Francisco Arabic" | implemented | no clean uninstall | `lib/apps/a/applesfarabic.sh` |

| applesfcompact | `maclib::applesfcompact::suite_installer_url` | "San Francisco Compact" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfcompact.sh` |
| applesfcompact | `maclib::applesfcompact::latest_version` | "San Francisco Compact" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/applesfcompact.sh` |
| applesfcompact | `maclib::applesfcompact::is_installed` | Return 0 if "San Francisco Compact" installed | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfcompact.sh` |
| applesfcompact | `maclib::applesfcompact::installed_path` | Path to installed "San Francisco Compact" bundle | implemented |  | `lib/apps/a/applesfcompact.sh` |
| applesfcompact | `maclib::applesfcompact::install` | Download installer and install "San Francisco Compact" | implemented | requires root | `lib/apps/a/applesfcompact.sh` |
| applesfcompact | `maclib::applesfcompact::update` | Update "San Francisco Compact" | implemented | no update path | `lib/apps/a/applesfcompact.sh` |
| applesfcompact | `maclib::applesfcompact::uninstall` | Uninstall "San Francisco Compact" | implemented | no clean uninstall | `lib/apps/a/applesfcompact.sh` |

| applesfmono | `maclib::applesfmono::suite_installer_url` | "San Francisco Mono" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfmono.sh` |
| applesfmono | `maclib::applesfmono::latest_version` | "San Francisco Mono" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/applesfmono.sh` |
| applesfmono | `maclib::applesfmono::is_installed` | Return 0 if "San Francisco Mono" installed | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfmono.sh` |
| applesfmono | `maclib::applesfmono::installed_path` | Path to installed "San Francisco Mono" bundle | implemented |  | `lib/apps/a/applesfmono.sh` |
| applesfmono | `maclib::applesfmono::install` | Download installer and install "San Francisco Mono" | implemented | requires root | `lib/apps/a/applesfmono.sh` |
| applesfmono | `maclib::applesfmono::update` | Update "San Francisco Mono" | implemented | no update path | `lib/apps/a/applesfmono.sh` |
| applesfmono | `maclib::applesfmono::uninstall` | Uninstall "San Francisco Mono" | implemented | no clean uninstall | `lib/apps/a/applesfmono.sh` |

| applesfpro | `maclib::applesfpro::suite_installer_url` | "San Francisco Pro" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfpro.sh` |
| applesfpro | `maclib::applesfpro::latest_version` | "San Francisco Pro" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/applesfpro.sh` |
| applesfpro | `maclib::applesfpro::is_installed` | Return 0 if "San Francisco Pro" installed | implemented | team "Software Update"; "pkgInDmg" | `lib/apps/a/applesfpro.sh` |
| applesfpro | `maclib::applesfpro::installed_path` | Path to installed "San Francisco Pro" bundle | implemented |  | `lib/apps/a/applesfpro.sh` |
| applesfpro | `maclib::applesfpro::install` | Download installer and install "San Francisco Pro" | implemented | requires root | `lib/apps/a/applesfpro.sh` |
| applesfpro | `maclib::applesfpro::update` | Update "San Francisco Pro" | implemented | no update path | `lib/apps/a/applesfpro.sh` |
| applesfpro | `maclib::applesfpro::uninstall` | Uninstall "San Francisco Pro" | implemented | no clean uninstall | `lib/apps/a/applesfpro.sh` |

| appsanywhere | `maclib::appsanywhere::suite_installer_url` | "AppsAnywhere Client (macOS)" installer URL (Installomator) | implemented | team "9ZNX23CMVD"; "pkg" | `lib/apps/a/appsanywhere.sh` |
| appsanywhere | `maclib::appsanywhere::latest_version` | "AppsAnywhere Client (macOS)" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/appsanywhere.sh` |
| appsanywhere | `maclib::appsanywhere::is_installed` | Return 0 if "AppsAnywhere Client (macOS)" installed | implemented | team "9ZNX23CMVD"; "pkg" | `lib/apps/a/appsanywhere.sh` |
| appsanywhere | `maclib::appsanywhere::installed_path` | Path to installed "AppsAnywhere Client (macOS)" bundle | implemented |  | `lib/apps/a/appsanywhere.sh` |
| appsanywhere | `maclib::appsanywhere::install` | Download installer and install "AppsAnywhere Client (macOS)" | implemented | requires root | `lib/apps/a/appsanywhere.sh` |
| appsanywhere | `maclib::appsanywhere::update` | Update "AppsAnywhere Client (macOS)" | implemented | no update path | `lib/apps/a/appsanywhere.sh` |
| appsanywhere | `maclib::appsanywhere::uninstall` | Uninstall "AppsAnywhere Client (macOS)" | implemented | no clean uninstall | `lib/apps/a/appsanywhere.sh` |

| aquamacs | `maclib::aquamacs::suite_installer_url` | "Aquamacs" installer URL (Installomator) | implemented | team "DTBC5BX3L9"; "dmg" | `lib/apps/a/aquamacs.sh` |
| aquamacs | `maclib::aquamacs::latest_version` | "Aquamacs" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/aquamacs.sh` |
| aquamacs | `maclib::aquamacs::is_installed` | Return 0 if "Aquamacs" installed | implemented | team "DTBC5BX3L9"; "dmg" | `lib/apps/a/aquamacs.sh` |
| aquamacs | `maclib::aquamacs::installed_path` | Path to installed "Aquamacs" bundle | implemented |  | `lib/apps/a/aquamacs.sh` |
| aquamacs | `maclib::aquamacs::install` | Download installer and install "Aquamacs" | implemented | requires root | `lib/apps/a/aquamacs.sh` |
| aquamacs | `maclib::aquamacs::update` | Update "Aquamacs" | implemented | no update path | `lib/apps/a/aquamacs.sh` |
| aquamacs | `maclib::aquamacs::uninstall` | Uninstall "Aquamacs" | implemented | no clean uninstall | `lib/apps/a/aquamacs.sh` |

| aquaskk | `maclib::aquaskk::suite_installer_url` | "aquaskk" installer URL (Installomator) | implemented | team "FPZK4WRGW7"; "pkg" | `lib/apps/a/aquaskk.sh` |
| aquaskk | `maclib::aquaskk::latest_version` | "aquaskk" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/aquaskk.sh` |
| aquaskk | `maclib::aquaskk::is_installed` | Return 0 if "aquaskk" installed | implemented | team "FPZK4WRGW7"; "pkg" | `lib/apps/a/aquaskk.sh` |
| aquaskk | `maclib::aquaskk::installed_path` | Path to installed "aquaskk" bundle | implemented |  | `lib/apps/a/aquaskk.sh` |
| aquaskk | `maclib::aquaskk::install` | Download installer and install "aquaskk" | implemented | requires root | `lib/apps/a/aquaskk.sh` |
| aquaskk | `maclib::aquaskk::update` | Update "aquaskk" | implemented | no update path | `lib/apps/a/aquaskk.sh` |
| aquaskk | `maclib::aquaskk::uninstall` | Uninstall "aquaskk" | implemented | no clean uninstall | `lib/apps/a/aquaskk.sh` |

| arcbrowser | `maclib::arcbrowser::suite_installer_url` | "Arc" installer URL (Installomator) | implemented | team "S6N382Y83G"; "dmg" | `lib/apps/a/arcbrowser.sh` |
| arcbrowser | `maclib::arcbrowser::latest_version` | "Arc" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/arcbrowser.sh` |
| arcbrowser | `maclib::arcbrowser::is_installed` | Return 0 if "Arc" installed | implemented | team "S6N382Y83G"; "dmg" | `lib/apps/a/arcbrowser.sh` |
| arcbrowser | `maclib::arcbrowser::installed_path` | Path to installed "Arc" bundle | implemented |  | `lib/apps/a/arcbrowser.sh` |
| arcbrowser | `maclib::arcbrowser::install` | Download installer and install "Arc" | implemented | requires root | `lib/apps/a/arcbrowser.sh` |
| arcbrowser | `maclib::arcbrowser::update` | Update "Arc" | implemented | no update path | `lib/apps/a/arcbrowser.sh` |
| arcbrowser | `maclib::arcbrowser::uninstall` | Uninstall "Arc" | implemented | no clean uninstall | `lib/apps/a/arcbrowser.sh` |

| archaeology | `maclib::archaeology::suite_installer_url` | "Archaeology" installer URL (Installomator) | implemented | team "936EB786NH"; "dmg" | `lib/apps/a/archaeology.sh` |
| archaeology | `maclib::archaeology::latest_version` | "Archaeology" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/archaeology.sh` |
| archaeology | `maclib::archaeology::is_installed` | Return 0 if "Archaeology" installed | implemented | team "936EB786NH"; "dmg" | `lib/apps/a/archaeology.sh` |
| archaeology | `maclib::archaeology::installed_path` | Path to installed "Archaeology" bundle | implemented |  | `lib/apps/a/archaeology.sh` |
| archaeology | `maclib::archaeology::install` | Download installer and install "Archaeology" | implemented | requires root | `lib/apps/a/archaeology.sh` |
| archaeology | `maclib::archaeology::update` | Update "Archaeology" | implemented | no update path | `lib/apps/a/archaeology.sh` |
| archaeology | `maclib::archaeology::uninstall` | Uninstall "Archaeology" | implemented | no clean uninstall | `lib/apps/a/archaeology.sh` |

| archimate | `maclib::archimate::suite_installer_url` | "Archi" installer URL (Installomator) | implemented | team "375WT5T296"; "dmg" | `lib/apps/a/archimate.sh` |
| archimate | `maclib::archimate::latest_version` | "Archi" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/archimate.sh` |
| archimate | `maclib::archimate::is_installed` | Return 0 if "Archi" installed | implemented | team "375WT5T296"; "dmg" | `lib/apps/a/archimate.sh` |
| archimate | `maclib::archimate::installed_path` | Path to installed "Archi" bundle | implemented |  | `lib/apps/a/archimate.sh` |
| archimate | `maclib::archimate::install` | Download installer and install "Archi" | implemented | requires root | `lib/apps/a/archimate.sh` |
| archimate | `maclib::archimate::update` | Update "Archi" | implemented | no update path | `lib/apps/a/archimate.sh` |
| archimate | `maclib::archimate::uninstall` | Uninstall "Archi" | implemented | no clean uninstall | `lib/apps/a/archimate.sh` |

| archiwareb2go | `maclib::archiwareb2go::suite_installer_url` | "P5 Workstation" installer URL (Installomator) | implemented | team "5H5EU6F965"; "pkgInDmg" | `lib/apps/a/archiwareb2go.sh` |
| archiwareb2go | `maclib::archiwareb2go::latest_version` | "P5 Workstation" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/archiwareb2go.sh` |
| archiwareb2go | `maclib::archiwareb2go::is_installed` | Return 0 if "P5 Workstation" installed | implemented | team "5H5EU6F965"; "pkgInDmg" | `lib/apps/a/archiwareb2go.sh` |
| archiwareb2go | `maclib::archiwareb2go::installed_path` | Path to installed "P5 Workstation" bundle | implemented |  | `lib/apps/a/archiwareb2go.sh` |
| archiwareb2go | `maclib::archiwareb2go::install` | Download installer and install "P5 Workstation" | implemented | requires root | `lib/apps/a/archiwareb2go.sh` |
| archiwareb2go | `maclib::archiwareb2go::update` | Update "P5 Workstation" | implemented | no update path | `lib/apps/a/archiwareb2go.sh` |
| archiwareb2go | `maclib::archiwareb2go::uninstall` | Uninstall "P5 Workstation" | implemented | no clean uninstall | `lib/apps/a/archiwareb2go.sh` |

| archiwarepst | `maclib::archiwarepst::suite_installer_url` | "P5" installer URL (Installomator) | implemented | team "5H5EU6F965"; "pkgInDmg" | `lib/apps/a/archiwarepst.sh` |
| archiwarepst | `maclib::archiwarepst::latest_version` | "P5" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/archiwarepst.sh` |
| archiwarepst | `maclib::archiwarepst::is_installed` | Return 0 if "P5" installed | implemented | team "5H5EU6F965"; "pkgInDmg" | `lib/apps/a/archiwarepst.sh` |
| archiwarepst | `maclib::archiwarepst::installed_path` | Path to installed "P5" bundle | implemented |  | `lib/apps/a/archiwarepst.sh` |
| archiwarepst | `maclib::archiwarepst::install` | Download installer and install "P5" | implemented | requires root | `lib/apps/a/archiwarepst.sh` |
| archiwarepst | `maclib::archiwarepst::update` | Update "P5" | implemented | no update path | `lib/apps/a/archiwarepst.sh` |
| archiwarepst | `maclib::archiwarepst::uninstall` | Uninstall "P5" | implemented | no clean uninstall | `lib/apps/a/archiwarepst.sh` |

| arduinoide | `maclib::arduinoide::suite_installer_url` | "Arduino IDE" installer URL (Installomator) | implemented | team "7KT7ZWMCJT"; "dmg" | `lib/apps/a/arduinoide.sh` |
| arduinoide | `maclib::arduinoide::latest_version` | "Arduino IDE" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/arduinoide.sh` |
| arduinoide | `maclib::arduinoide::is_installed` | Return 0 if "Arduino IDE" installed | implemented | team "7KT7ZWMCJT"; "dmg" | `lib/apps/a/arduinoide.sh` |
| arduinoide | `maclib::arduinoide::installed_path` | Path to installed "Arduino IDE" bundle | implemented |  | `lib/apps/a/arduinoide.sh` |
| arduinoide | `maclib::arduinoide::install` | Download installer and install "Arduino IDE" | implemented | requires root | `lib/apps/a/arduinoide.sh` |
| arduinoide | `maclib::arduinoide::update` | Update "Arduino IDE" | implemented | no update path | `lib/apps/a/arduinoide.sh` |
| arduinoide | `maclib::arduinoide::uninstall` | Uninstall "Arduino IDE" | implemented | no clean uninstall | `lib/apps/a/arduinoide.sh` |

| arq7 | `maclib::arq7::suite_installer_url` | "Arq7" installer URL (Installomator) | implemented | team "48ZCSDVL96"; "pkg" | `lib/apps/a/arq7.sh` |
| arq7 | `maclib::arq7::latest_version` | "Arq7" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/arq7.sh` |
| arq7 | `maclib::arq7::is_installed` | Return 0 if "Arq7" installed | implemented | team "48ZCSDVL96"; "pkg" | `lib/apps/a/arq7.sh` |
| arq7 | `maclib::arq7::installed_path` | Path to installed "Arq7" bundle | implemented |  | `lib/apps/a/arq7.sh` |
| arq7 | `maclib::arq7::install` | Download installer and install "Arq7" | implemented | requires root | `lib/apps/a/arq7.sh` |
| arq7 | `maclib::arq7::update` | Update "Arq7" | implemented | no update path | `lib/apps/a/arq7.sh` |
| arq7 | `maclib::arq7::uninstall` | Uninstall "Arq7" | implemented | no clean uninstall | `lib/apps/a/arq7.sh` |

| arturiamcc | `maclib::arturiamcc::suite_installer_url` | "MIDI Control Center" installer URL (Installomator) | implemented | team "T53ZHSF36C"; "pkg" | `lib/apps/a/arturiamcc.sh` |
| arturiamcc | `maclib::arturiamcc::latest_version` | "MIDI Control Center" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/arturiamcc.sh` |
| arturiamcc | `maclib::arturiamcc::is_installed` | Return 0 if "MIDI Control Center" installed | implemented | team "T53ZHSF36C"; "pkg" | `lib/apps/a/arturiamcc.sh` |
| arturiamcc | `maclib::arturiamcc::installed_path` | Path to installed "MIDI Control Center" bundle | implemented |  | `lib/apps/a/arturiamcc.sh` |
| arturiamcc | `maclib::arturiamcc::install` | Download installer and install "MIDI Control Center" | implemented | requires root | `lib/apps/a/arturiamcc.sh` |
| arturiamcc | `maclib::arturiamcc::update` | Update "MIDI Control Center" | implemented | no update path | `lib/apps/a/arturiamcc.sh` |
| arturiamcc | `maclib::arturiamcc::uninstall` | Uninstall "MIDI Control Center" | implemented | no clean uninstall | `lib/apps/a/arturiamcc.sh` |

| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::suite_installer_url` | "Arturia Software Center" installer URL (Installomator) | implemented | team "T53ZHSF36C"; "pkg" | `lib/apps/a/arturiasoftwarecenter.sh` |
| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::latest_version` | "Arturia Software Center" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/arturiasoftwarecenter.sh` |
| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::is_installed` | Return 0 if "Arturia Software Center" installed | implemented | team "T53ZHSF36C"; "pkg" | `lib/apps/a/arturiasoftwarecenter.sh` |
| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::installed_path` | Path to installed "Arturia Software Center" bundle | implemented |  | `lib/apps/a/arturiasoftwarecenter.sh` |
| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::install` | Download installer and install "Arturia Software Center" | implemented | requires root | `lib/apps/a/arturiasoftwarecenter.sh` |
| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::update` | Update "Arturia Software Center" | implemented | no update path | `lib/apps/a/arturiasoftwarecenter.sh` |
| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::uninstall` | Uninstall "Arturia Software Center" | implemented | no clean uninstall | `lib/apps/a/arturiasoftwarecenter.sh` |

| asana | `maclib::asana::suite_installer_url` | "Asana" installer URL (Installomator) | implemented | team "A679L395M8"; "dmg" | `lib/apps/a/asana.sh` |
| asana | `maclib::asana::latest_version` | "Asana" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/asana.sh` |
| asana | `maclib::asana::is_installed` | Return 0 if "Asana" installed | implemented | team "A679L395M8"; "dmg" | `lib/apps/a/asana.sh` |
| asana | `maclib::asana::installed_path` | Path to installed "Asana" bundle | implemented |  | `lib/apps/a/asana.sh` |
| asana | `maclib::asana::install` | Download installer and install "Asana" | implemented | requires root | `lib/apps/a/asana.sh` |
| asana | `maclib::asana::update` | Update "Asana" | implemented | no update path | `lib/apps/a/asana.sh` |
| asana | `maclib::asana::uninstall` | Uninstall "Asana" | implemented | no clean uninstall | `lib/apps/a/asana.sh` |

| asperaconnect | `maclib::asperaconnect::suite_installer_url` | "Aspera Connect" installer URL (Installomator) | implemented | team "PETKK2G752"; "module"' | grep -o "/.*.js") | `lib/apps/a/asperaconnect.sh` |
| asperaconnect | `maclib::asperaconnect::latest_version` | "Aspera Connect" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/asperaconnect.sh` |
| asperaconnect | `maclib::asperaconnect::is_installed` | Return 0 if "Aspera Connect" installed | implemented | team "PETKK2G752"; "module"' | grep -o "/.*.js") | `lib/apps/a/asperaconnect.sh` |
| asperaconnect | `maclib::asperaconnect::installed_path` | Path to installed "Aspera Connect" bundle | implemented |  | `lib/apps/a/asperaconnect.sh` |
| asperaconnect | `maclib::asperaconnect::install` | Download installer and install "Aspera Connect" | implemented | requires root | `lib/apps/a/asperaconnect.sh` |
| asperaconnect | `maclib::asperaconnect::update` | Update "Aspera Connect" | implemented | no update path | `lib/apps/a/asperaconnect.sh` |
| asperaconnect | `maclib::asperaconnect::uninstall` | Uninstall "Aspera Connect" | implemented | no clean uninstall | `lib/apps/a/asperaconnect.sh` |

| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::suite_installer_url` | "AsymmetricKeyGenerator" installer URL (Installomator) | implemented | team "89H83DPVB8"; "dmg" | `lib/apps/a/asymmetrickeygenerator.sh` |
| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::latest_version` | "AsymmetricKeyGenerator" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/asymmetrickeygenerator.sh` |
| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::is_installed` | Return 0 if "AsymmetricKeyGenerator" installed | implemented | team "89H83DPVB8"; "dmg" | `lib/apps/a/asymmetrickeygenerator.sh` |
| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::installed_path` | Path to installed "AsymmetricKeyGenerator" bundle | implemented |  | `lib/apps/a/asymmetrickeygenerator.sh` |
| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::install` | Download installer and install "AsymmetricKeyGenerator" | implemented | requires root | `lib/apps/a/asymmetrickeygenerator.sh` |
| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::update` | Update "AsymmetricKeyGenerator" | implemented | no update path | `lib/apps/a/asymmetrickeygenerator.sh` |
| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::uninstall` | Uninstall "AsymmetricKeyGenerator" | implemented | no clean uninstall | `lib/apps/a/asymmetrickeygenerator.sh` |

| atlassiancompanion | `maclib::atlassiancompanion::suite_installer_url` | "Atlassian Companion" installer URL (Installomator) | implemented | team "UPXU4CQZ5P"; "dmg" | `lib/apps/a/atlassiancompanion.sh` |
| atlassiancompanion | `maclib::atlassiancompanion::latest_version` | "Atlassian Companion" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/atlassiancompanion.sh` |
| atlassiancompanion | `maclib::atlassiancompanion::is_installed` | Return 0 if "Atlassian Companion" installed | implemented | team "UPXU4CQZ5P"; "dmg" | `lib/apps/a/atlassiancompanion.sh` |
| atlassiancompanion | `maclib::atlassiancompanion::installed_path` | Path to installed "Atlassian Companion" bundle | implemented |  | `lib/apps/a/atlassiancompanion.sh` |
| atlassiancompanion | `maclib::atlassiancompanion::install` | Download installer and install "Atlassian Companion" | implemented | requires root | `lib/apps/a/atlassiancompanion.sh` |
| atlassiancompanion | `maclib::atlassiancompanion::update` | Update "Atlassian Companion" | implemented | no update path | `lib/apps/a/atlassiancompanion.sh` |
| atlassiancompanion | `maclib::atlassiancompanion::uninstall` | Uninstall "Atlassian Companion" | implemented | no clean uninstall | `lib/apps/a/atlassiancompanion.sh` |

| audacity | `maclib::audacity::suite_installer_url` | "Audacity" installer URL (Installomator) | implemented | team "AWEYX923UX"; "dmg" | `lib/apps/a/audacity.sh` |
| audacity | `maclib::audacity::latest_version` | "Audacity" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/audacity.sh` |
| audacity | `maclib::audacity::is_installed` | Return 0 if "Audacity" installed | implemented | team "AWEYX923UX"; "dmg" | `lib/apps/a/audacity.sh` |
| audacity | `maclib::audacity::installed_path` | Path to installed "Audacity" bundle | implemented |  | `lib/apps/a/audacity.sh` |
| audacity | `maclib::audacity::install` | Download installer and install "Audacity" | implemented | requires root | `lib/apps/a/audacity.sh` |
| audacity | `maclib::audacity::update` | Update "Audacity" | implemented | no update path | `lib/apps/a/audacity.sh` |
| audacity | `maclib::audacity::uninstall` | Uninstall "Audacity" | implemented | no clean uninstall | `lib/apps/a/audacity.sh` |

| autodmg | `maclib::autodmg::suite_installer_url` | "AutoDMG" installer URL (Installomator) | implemented | team "5KQ3D3FG5H"; "dmg" | `lib/apps/a/autodmg.sh` |
| autodmg | `maclib::autodmg::latest_version` | "AutoDMG" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/autodmg.sh` |
| autodmg | `maclib::autodmg::is_installed` | Return 0 if "AutoDMG" installed | implemented | team "5KQ3D3FG5H"; "dmg" | `lib/apps/a/autodmg.sh` |
| autodmg | `maclib::autodmg::installed_path` | Path to installed "AutoDMG" bundle | implemented |  | `lib/apps/a/autodmg.sh` |
| autodmg | `maclib::autodmg::install` | Download installer and install "AutoDMG" | implemented | requires root | `lib/apps/a/autodmg.sh` |
| autodmg | `maclib::autodmg::update` | Update "AutoDMG" | implemented | no update path | `lib/apps/a/autodmg.sh` |
| autodmg | `maclib::autodmg::uninstall` | Uninstall "AutoDMG" | implemented | no clean uninstall | `lib/apps/a/autodmg.sh` |

| automounter | `maclib::automounter::suite_installer_url` | "AutoMounter" installer URL (Installomator) | implemented | team "UKWABN4MGL"; "dmg" | `lib/apps/a/automounter.sh` |
| automounter | `maclib::automounter::latest_version` | "AutoMounter" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/automounter.sh` |
| automounter | `maclib::automounter::is_installed` | Return 0 if "AutoMounter" installed | implemented | team "UKWABN4MGL"; "dmg" | `lib/apps/a/automounter.sh` |
| automounter | `maclib::automounter::installed_path` | Path to installed "AutoMounter" bundle | implemented |  | `lib/apps/a/automounter.sh` |
| automounter | `maclib::automounter::install` | Download installer and install "AutoMounter" | implemented | requires root | `lib/apps/a/automounter.sh` |
| automounter | `maclib::automounter::update` | Update "AutoMounter" | implemented | no update path | `lib/apps/a/automounter.sh` |
| automounter | `maclib::automounter::uninstall` | Uninstall "AutoMounter" | implemented | no clean uninstall | `lib/apps/a/automounter.sh` |

| autopkgr | `maclib::autopkgr::suite_installer_url` | "AutoPkgr" installer URL (Installomator) | implemented | team "JVY2ZR6SEF"; "dmg" | `lib/apps/a/autopkgr.sh` |
| autopkgr | `maclib::autopkgr::latest_version` | "AutoPkgr" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/autopkgr.sh` |
| autopkgr | `maclib::autopkgr::is_installed` | Return 0 if "AutoPkgr" installed | implemented | team "JVY2ZR6SEF"; "dmg" | `lib/apps/a/autopkgr.sh` |
| autopkgr | `maclib::autopkgr::installed_path` | Path to installed "AutoPkgr" bundle | implemented |  | `lib/apps/a/autopkgr.sh` |
| autopkgr | `maclib::autopkgr::install` | Download installer and install "AutoPkgr" | implemented | requires root | `lib/apps/a/autopkgr.sh` |
| autopkgr | `maclib::autopkgr::update` | Update "AutoPkgr" | implemented | no update path | `lib/apps/a/autopkgr.sh` |
| autopkgr | `maclib::autopkgr::uninstall` | Uninstall "AutoPkgr" | implemented | no clean uninstall | `lib/apps/a/autopkgr.sh` |

| avertouch | `maclib::avertouch::suite_installer_url` | "AverTouch" installer URL (Installomator) | implemented | team "B6T3WCD59Q"; "zip" | `lib/apps/a/avertouch.sh` |
| avertouch | `maclib::avertouch::latest_version` | "AverTouch" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/avertouch.sh` |
| avertouch | `maclib::avertouch::is_installed` | Return 0 if "AverTouch" installed | implemented | team "B6T3WCD59Q"; "zip" | `lib/apps/a/avertouch.sh` |
| avertouch | `maclib::avertouch::installed_path` | Path to installed "AverTouch" bundle | implemented |  | `lib/apps/a/avertouch.sh` |
| avertouch | `maclib::avertouch::install` | Download installer and install "AverTouch" | implemented | requires root | `lib/apps/a/avertouch.sh` |
| avertouch | `maclib::avertouch::update` | Update "AverTouch" | implemented | no update path | `lib/apps/a/avertouch.sh` |
| avertouch | `maclib::avertouch::uninstall` | Uninstall "AverTouch" | implemented | no clean uninstall | `lib/apps/a/avertouch.sh` |

| aviatrix | `maclib::aviatrix::suite_installer_url` | "Aviatrix VPN Client" installer URL (Installomator) | implemented | team "32953Z7NBN"; "pkg" | `lib/apps/a/aviatrix.sh` |
| aviatrix | `maclib::aviatrix::latest_version` | "Aviatrix VPN Client" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/aviatrix.sh` |
| aviatrix | `maclib::aviatrix::is_installed` | Return 0 if "Aviatrix VPN Client" installed | implemented | team "32953Z7NBN"; "pkg" | `lib/apps/a/aviatrix.sh` |
| aviatrix | `maclib::aviatrix::installed_path` | Path to installed "Aviatrix VPN Client" bundle | implemented |  | `lib/apps/a/aviatrix.sh` |
| aviatrix | `maclib::aviatrix::install` | Download installer and install "Aviatrix VPN Client" | implemented | requires root | `lib/apps/a/aviatrix.sh` |
| aviatrix | `maclib::aviatrix::update` | Update "Aviatrix VPN Client" | implemented | no update path | `lib/apps/a/aviatrix.sh` |
| aviatrix | `maclib::aviatrix::uninstall` | Uninstall "Aviatrix VPN Client" | implemented | no clean uninstall | `lib/apps/a/aviatrix.sh` |

| awscli2 | `maclib::awscli2::suite_installer_url` | "AWSCLI" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/awscli2.sh` |
| awscli2 | `maclib::awscli2::latest_version` | "AWSCLI" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/awscli2.sh` |
| awscli2 | `maclib::awscli2::is_installed` | Return 0 if "AWSCLI" installed | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/awscli2.sh` |
| awscli2 | `maclib::awscli2::installed_path` | Path to installed "AWSCLI" bundle | implemented |  | `lib/apps/a/awscli2.sh` |
| awscli2 | `maclib::awscli2::install` | Download installer and install "AWSCLI" | implemented | requires root | `lib/apps/a/awscli2.sh` |
| awscli2 | `maclib::awscli2::update` | Update "AWSCLI" | implemented | no update path | `lib/apps/a/awscli2.sh` |
| awscli2 | `maclib::awscli2::uninstall` | Uninstall "AWSCLI" | implemented | no clean uninstall | `lib/apps/a/awscli2.sh` |

| awsvpnclient | `maclib::awsvpnclient::suite_installer_url` | "AWS VPN Client" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/awsvpnclient.sh` |
| awsvpnclient | `maclib::awsvpnclient::latest_version` | "AWS VPN Client" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/awsvpnclient.sh` |
| awsvpnclient | `maclib::awsvpnclient::is_installed` | Return 0 if "AWS VPN Client" installed | implemented | team "94KV3E626L"; "pkg" | `lib/apps/a/awsvpnclient.sh` |
| awsvpnclient | `maclib::awsvpnclient::installed_path` | Path to installed "AWS VPN Client" bundle | implemented |  | `lib/apps/a/awsvpnclient.sh` |
| awsvpnclient | `maclib::awsvpnclient::install` | Download installer and install "AWS VPN Client" | implemented | requires root | `lib/apps/a/awsvpnclient.sh` |
| awsvpnclient | `maclib::awsvpnclient::update` | Update "AWS VPN Client" | implemented | no update path | `lib/apps/a/awsvpnclient.sh` |
| awsvpnclient | `maclib::awsvpnclient::uninstall` | Uninstall "AWS VPN Client" | implemented | no clean uninstall | `lib/apps/a/awsvpnclient.sh` |

| axurerp10 | `maclib::axurerp10::suite_installer_url` | "Axure RP 10" installer URL (Installomator) | implemented | team "HUMW6UU796"; "dmg" | `lib/apps/a/axurerp10.sh` |
| axurerp10 | `maclib::axurerp10::latest_version` | "Axure RP 10" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/axurerp10.sh` |
| axurerp10 | `maclib::axurerp10::is_installed` | Return 0 if "Axure RP 10" installed | implemented | team "HUMW6UU796"; "dmg" | `lib/apps/a/axurerp10.sh` |
| axurerp10 | `maclib::axurerp10::installed_path` | Path to installed "Axure RP 10" bundle | implemented |  | `lib/apps/a/axurerp10.sh` |
| axurerp10 | `maclib::axurerp10::install` | Download installer and install "Axure RP 10" | implemented | requires root | `lib/apps/a/axurerp10.sh` |
| axurerp10 | `maclib::axurerp10::update` | Update "Axure RP 10" | implemented | no update path | `lib/apps/a/axurerp10.sh` |
| axurerp10 | `maclib::axurerp10::uninstall` | Uninstall "Axure RP 10" | implemented | no clean uninstall | `lib/apps/a/axurerp10.sh` |

| azuredatastudio | `maclib::azuredatastudio::suite_installer_url` | "Azure Data Studio" installer URL (Installomator) | implemented | team "UBF8T346G9"; "zip" | `lib/apps/a/azuredatastudio.sh` |
| azuredatastudio | `maclib::azuredatastudio::latest_version` | "Azure Data Studio" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/azuredatastudio.sh` |
| azuredatastudio | `maclib::azuredatastudio::is_installed` | Return 0 if "Azure Data Studio" installed | implemented | team "UBF8T346G9"; "zip" | `lib/apps/a/azuredatastudio.sh` |
| azuredatastudio | `maclib::azuredatastudio::installed_path` | Path to installed "Azure Data Studio" bundle | implemented |  | `lib/apps/a/azuredatastudio.sh` |
| azuredatastudio | `maclib::azuredatastudio::install` | Download installer and install "Azure Data Studio" | implemented | requires root | `lib/apps/a/azuredatastudio.sh` |
| azuredatastudio | `maclib::azuredatastudio::update` | Update "Azure Data Studio" | implemented | no update path | `lib/apps/a/azuredatastudio.sh` |
| azuredatastudio | `maclib::azuredatastudio::uninstall` | Uninstall "Azure Data Studio" | implemented | no clean uninstall | `lib/apps/a/azuredatastudio.sh` |

| backgroundmusic | `maclib::backgroundmusic::suite_installer_url` | "BackgroundMusic" installer URL (Installomator) | implemented | team "PR7PXC66S5"; "pkg" | `lib/apps/b/backgroundmusic.sh` |
| backgroundmusic | `maclib::backgroundmusic::latest_version` | "BackgroundMusic" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/backgroundmusic.sh` |
| backgroundmusic | `maclib::backgroundmusic::is_installed` | Return 0 if "BackgroundMusic" installed | implemented | team "PR7PXC66S5"; "pkg" | `lib/apps/b/backgroundmusic.sh` |
| backgroundmusic | `maclib::backgroundmusic::installed_path` | Path to installed "BackgroundMusic" bundle | implemented |  | `lib/apps/b/backgroundmusic.sh` |
| backgroundmusic | `maclib::backgroundmusic::install` | Download installer and install "BackgroundMusic" | implemented | requires root | `lib/apps/b/backgroundmusic.sh` |
| backgroundmusic | `maclib::backgroundmusic::update` | Update "BackgroundMusic" | implemented | no update path | `lib/apps/b/backgroundmusic.sh` |
| backgroundmusic | `maclib::backgroundmusic::uninstall` | Uninstall "BackgroundMusic" | implemented | no clean uninstall | `lib/apps/b/backgroundmusic.sh` |

| backgrounds | `maclib::backgrounds::suite_installer_url` | "Backgrounds" installer URL (Installomator) | implemented | team "7R5ZEU67FQ"; "pkg" | `lib/apps/b/backgrounds.sh` |
| backgrounds | `maclib::backgrounds::latest_version` | "Backgrounds" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/backgrounds.sh` |
| backgrounds | `maclib::backgrounds::is_installed` | Return 0 if "Backgrounds" installed | implemented | team "7R5ZEU67FQ"; "pkg" | `lib/apps/b/backgrounds.sh` |
| backgrounds | `maclib::backgrounds::installed_path` | Path to installed "Backgrounds" bundle | implemented |  | `lib/apps/b/backgrounds.sh` |
| backgrounds | `maclib::backgrounds::install` | Download installer and install "Backgrounds" | implemented | requires root | `lib/apps/b/backgrounds.sh` |
| backgrounds | `maclib::backgrounds::update` | Update "Backgrounds" | implemented | no update path | `lib/apps/b/backgrounds.sh` |
| backgrounds | `maclib::backgrounds::uninstall` | Uninstall "Backgrounds" | implemented | no clean uninstall | `lib/apps/b/backgrounds.sh` |

| balenaetcher | `maclib::balenaetcher::suite_installer_url` | "balenaEtcher" installer URL (Installomator) | implemented | team "66H43P8FRG"; "dmg" | `lib/apps/b/balenaetcher.sh` |
| balenaetcher | `maclib::balenaetcher::latest_version` | "balenaEtcher" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/balenaetcher.sh` |
| balenaetcher | `maclib::balenaetcher::is_installed` | Return 0 if "balenaEtcher" installed | implemented | team "66H43P8FRG"; "dmg" | `lib/apps/b/balenaetcher.sh` |
| balenaetcher | `maclib::balenaetcher::installed_path` | Path to installed "balenaEtcher" bundle | implemented |  | `lib/apps/b/balenaetcher.sh` |
| balenaetcher | `maclib::balenaetcher::install` | Download installer and install "balenaEtcher" | implemented | requires root | `lib/apps/b/balenaetcher.sh` |
| balenaetcher | `maclib::balenaetcher::update` | Update "balenaEtcher" | implemented | no update path | `lib/apps/b/balenaetcher.sh` |
| balenaetcher | `maclib::balenaetcher::uninstall` | Uninstall "balenaEtcher" | implemented | no clean uninstall | `lib/apps/b/balenaetcher.sh` |

| balsamiqwireframes | `maclib::balsamiqwireframes::suite_installer_url` | "Balsamiq Wireframes" installer URL (Installomator) | implemented | team "3DPKD72KQ7"; "dmg" | `lib/apps/b/balsamiqwireframes.sh` |
| balsamiqwireframes | `maclib::balsamiqwireframes::latest_version` | "Balsamiq Wireframes" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/balsamiqwireframes.sh` |
| balsamiqwireframes | `maclib::balsamiqwireframes::is_installed` | Return 0 if "Balsamiq Wireframes" installed | implemented | team "3DPKD72KQ7"; "dmg" | `lib/apps/b/balsamiqwireframes.sh` |
| balsamiqwireframes | `maclib::balsamiqwireframes::installed_path` | Path to installed "Balsamiq Wireframes" bundle | implemented |  | `lib/apps/b/balsamiqwireframes.sh` |
| balsamiqwireframes | `maclib::balsamiqwireframes::install` | Download installer and install "Balsamiq Wireframes" | implemented | requires root | `lib/apps/b/balsamiqwireframes.sh` |
| balsamiqwireframes | `maclib::balsamiqwireframes::update` | Update "Balsamiq Wireframes" | implemented | no update path | `lib/apps/b/balsamiqwireframes.sh` |
| balsamiqwireframes | `maclib::balsamiqwireframes::uninstall` | Uninstall "Balsamiq Wireframes" | implemented | no clean uninstall | `lib/apps/b/balsamiqwireframes.sh` |

| bambustudio | `maclib::bambustudio::suite_installer_url` | "BambuStudio" installer URL (Installomator) | implemented | team "T3UBR9Y3B2"; "dmg" | `lib/apps/b/bambustudio.sh` |
| bambustudio | `maclib::bambustudio::latest_version` | "BambuStudio" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bambustudio.sh` |
| bambustudio | `maclib::bambustudio::is_installed` | Return 0 if "BambuStudio" installed | implemented | team "T3UBR9Y3B2"; "dmg" | `lib/apps/b/bambustudio.sh` |
| bambustudio | `maclib::bambustudio::installed_path` | Path to installed "BambuStudio" bundle | implemented |  | `lib/apps/b/bambustudio.sh` |
| bambustudio | `maclib::bambustudio::install` | Download installer and install "BambuStudio" | implemented | requires root | `lib/apps/b/bambustudio.sh` |
| bambustudio | `maclib::bambustudio::update` | Update "BambuStudio" | implemented | no update path | `lib/apps/b/bambustudio.sh` |
| bambustudio | `maclib::bambustudio::uninstall` | Uninstall "BambuStudio" | implemented | no clean uninstall | `lib/apps/b/bambustudio.sh` |

| bartender | `maclib::bartender::suite_installer_url` | "Bartender 4" installer URL (Installomator) | implemented | team "8DD663WDX4"; "dmg" | `lib/apps/b/bartender.sh` |
| bartender | `maclib::bartender::latest_version` | "Bartender 4" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bartender.sh` |
| bartender | `maclib::bartender::is_installed` | Return 0 if "Bartender 4" installed | implemented | team "8DD663WDX4"; "dmg" | `lib/apps/b/bartender.sh` |
| bartender | `maclib::bartender::installed_path` | Path to installed "Bartender 4" bundle | implemented |  | `lib/apps/b/bartender.sh` |
| bartender | `maclib::bartender::install` | Download installer and install "Bartender 4" | implemented | requires root | `lib/apps/b/bartender.sh` |
| bartender | `maclib::bartender::update` | Update "Bartender 4" | implemented | no update path | `lib/apps/b/bartender.sh` |
| bartender | `maclib::bartender::uninstall` | Uninstall "Bartender 4" | implemented | no clean uninstall | `lib/apps/b/bartender.sh` |

| basecamp3 | `maclib::basecamp3::suite_installer_url` | "Basecamp 3" installer URL (Installomator) | implemented | team "2WNYUYRS7G"; "zip" | `lib/apps/b/basecamp3.sh` |
| basecamp3 | `maclib::basecamp3::latest_version` | "Basecamp 3" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/basecamp3.sh` |
| basecamp3 | `maclib::basecamp3::is_installed` | Return 0 if "Basecamp 3" installed | implemented | team "2WNYUYRS7G"; "zip" | `lib/apps/b/basecamp3.sh` |
| basecamp3 | `maclib::basecamp3::installed_path` | Path to installed "Basecamp 3" bundle | implemented |  | `lib/apps/b/basecamp3.sh` |
| basecamp3 | `maclib::basecamp3::install` | Download installer and install "Basecamp 3" | implemented | requires root | `lib/apps/b/basecamp3.sh` |
| basecamp3 | `maclib::basecamp3::update` | Update "Basecamp 3" | implemented | no update path | `lib/apps/b/basecamp3.sh` |
| basecamp3 | `maclib::basecamp3::uninstall` | Uninstall "Basecamp 3" | implemented | no clean uninstall | `lib/apps/b/basecamp3.sh` |

| baseline | `maclib::baseline::suite_installer_url` | "Baseline" installer URL (Installomator) | implemented | team "7Q6XP5698G"; "pkg" | `lib/apps/b/baseline.sh` |
| baseline | `maclib::baseline::latest_version` | "Baseline" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/baseline.sh` |
| baseline | `maclib::baseline::is_installed` | Return 0 if "Baseline" installed | implemented | team "7Q6XP5698G"; "pkg" | `lib/apps/b/baseline.sh` |
| baseline | `maclib::baseline::installed_path` | Path to installed "Baseline" bundle | implemented |  | `lib/apps/b/baseline.sh` |
| baseline | `maclib::baseline::install` | Download installer and install "Baseline" | implemented | requires root | `lib/apps/b/baseline.sh` |
| baseline | `maclib::baseline::update` | Update "Baseline" | implemented | no update path | `lib/apps/b/baseline.sh` |
| baseline | `maclib::baseline::uninstall` | Uninstall "Baseline" | implemented | no clean uninstall | `lib/apps/b/baseline.sh` |

||| baseline-nodaemon | `maclib::baseline-nodaemon::suite_installer_url` | "Baseline" installer URL (Installomator) | implemented | team "7Q6XP5698G"; "pkg" |
||| baseline-nodaemon | `maclib::baseline-nodaemon::latest_version` | "Baseline" current build | implemented | Installomator appNewVersion logic |
||| baseline-nodaemon | `maclib::baseline-nodaemon::is_installed` | Return 0 if "Baseline" installed | implemented | team "7Q6XP5698G"; "pkg" |
||| baseline-nodaemon | `maclib::baseline-nodaemon::installed_path` | Path to installed "Baseline" bundle | implemented | |
||| baseline-nodaemon | `maclib::baseline-nodaemon::install` | Download installer and install "Baseline" | implemented | requires root |
||| baseline-nodaemon | `maclib::baseline-nodaemon::update` | Update "Baseline" | implemented | no update path |
||| baseline-nodaemon | `maclib::baseline-nodaemon::uninstall` | Uninstall "Baseline" | implemented | no clean uninstall |

| bbedit | `maclib::bbedit::suite_installer_url` | "BBEdit" installer URL (Installomator) | implemented | team "W52GZAXT98"; "dmg" | `lib/apps/b/bbedit.sh` |
| bbedit | `maclib::bbedit::latest_version` | "BBEdit" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bbedit.sh` |
| bbedit | `maclib::bbedit::is_installed` | Return 0 if "BBEdit" installed | implemented | team "W52GZAXT98"; "dmg" | `lib/apps/b/bbedit.sh` |
| bbedit | `maclib::bbedit::installed_path` | Path to installed "BBEdit" bundle | implemented |  | `lib/apps/b/bbedit.sh` |
| bbedit | `maclib::bbedit::install` | Download installer and install "BBEdit" | implemented | requires root | `lib/apps/b/bbedit.sh` |
| bbedit | `maclib::bbedit::update` | Update "BBEdit" | implemented | no update path | `lib/apps/b/bbedit.sh` |
| bbedit | `maclib::bbedit::uninstall` | Uninstall "BBEdit" | implemented | no clean uninstall | `lib/apps/b/bbedit.sh` |

| bbeditpkg | `maclib::bbeditpkg::suite_installer_url` | "BBEdit" installer URL (Installomator) | implemented | team "W52GZAXT98"; "pkg" | `lib/apps/b/bbeditpkg.sh` |
| bbeditpkg | `maclib::bbeditpkg::latest_version` | "BBEdit" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bbeditpkg.sh` |
| bbeditpkg | `maclib::bbeditpkg::is_installed` | Return 0 if "BBEdit" installed | implemented | team "W52GZAXT98"; "pkg" | `lib/apps/b/bbeditpkg.sh` |
| bbeditpkg | `maclib::bbeditpkg::installed_path` | Path to installed "BBEdit" bundle | implemented |  | `lib/apps/b/bbeditpkg.sh` |
| bbeditpkg | `maclib::bbeditpkg::install` | Download installer and install "BBEdit" | implemented | requires root | `lib/apps/b/bbeditpkg.sh` |
| bbeditpkg | `maclib::bbeditpkg::update` | Update "BBEdit" | implemented | no update path | `lib/apps/b/bbeditpkg.sh` |
| bbeditpkg | `maclib::bbeditpkg::uninstall` | Uninstall "BBEdit" | implemented | no clean uninstall | `lib/apps/b/bbeditpkg.sh` |

| beamstudio | `maclib::beamstudio::suite_installer_url` | "Beam Studio" installer URL (Installomator) | implemented | team "4Y92JWKV94"; "dmg" | `lib/apps/b/beamstudio.sh` |
| beamstudio | `maclib::beamstudio::latest_version` | "Beam Studio" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/beamstudio.sh` |
| beamstudio | `maclib::beamstudio::is_installed` | Return 0 if "Beam Studio" installed | implemented | team "4Y92JWKV94"; "dmg" | `lib/apps/b/beamstudio.sh` |
| beamstudio | `maclib::beamstudio::installed_path` | Path to installed "Beam Studio" bundle | implemented |  | `lib/apps/b/beamstudio.sh` |
| beamstudio | `maclib::beamstudio::install` | Download installer and install "Beam Studio" | implemented | requires root | `lib/apps/b/beamstudio.sh` |
| beamstudio | `maclib::beamstudio::update` | Update "Beam Studio" | implemented | no update path | `lib/apps/b/beamstudio.sh` |
| beamstudio | `maclib::beamstudio::uninstall` | Uninstall "Beam Studio" | implemented | no clean uninstall | `lib/apps/b/beamstudio.sh` |

| beekeeperstudio | `maclib::beekeeperstudio::suite_installer_url` | "Beekeeper Studio" installer URL (Installomator) | implemented | team "7KK583U8H2"; "dmg" | `lib/apps/b/beekeeperstudio.sh` |
| beekeeperstudio | `maclib::beekeeperstudio::latest_version` | "Beekeeper Studio" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/beekeeperstudio.sh` |
| beekeeperstudio | `maclib::beekeeperstudio::is_installed` | Return 0 if "Beekeeper Studio" installed | implemented | team "7KK583U8H2"; "dmg" | `lib/apps/b/beekeeperstudio.sh` |
| beekeeperstudio | `maclib::beekeeperstudio::installed_path` | Path to installed "Beekeeper Studio" bundle | implemented |  | `lib/apps/b/beekeeperstudio.sh` |
| beekeeperstudio | `maclib::beekeeperstudio::install` | Download installer and install "Beekeeper Studio" | implemented | requires root | `lib/apps/b/beekeeperstudio.sh` |
| beekeeperstudio | `maclib::beekeeperstudio::update` | Update "Beekeeper Studio" | implemented | no update path | `lib/apps/b/beekeeperstudio.sh` |
| beekeeperstudio | `maclib::beekeeperstudio::uninstall` | Uninstall "Beekeeper Studio" | implemented | no clean uninstall | `lib/apps/b/beekeeperstudio.sh` |

| betterdisplay | `maclib::betterdisplay::suite_installer_url` | "BetterDisplay" installer URL (Installomator) | implemented | team "299YSU96J7"; "dmg" | `lib/apps/b/betterdisplay.sh` |
| betterdisplay | `maclib::betterdisplay::latest_version` | "BetterDisplay" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/betterdisplay.sh` |
| betterdisplay | `maclib::betterdisplay::is_installed` | Return 0 if "BetterDisplay" installed | implemented | team "299YSU96J7"; "dmg" | `lib/apps/b/betterdisplay.sh` |
| betterdisplay | `maclib::betterdisplay::installed_path` | Path to installed "BetterDisplay" bundle | implemented |  | `lib/apps/b/betterdisplay.sh` |
| betterdisplay | `maclib::betterdisplay::install` | Download installer and install "BetterDisplay" | implemented | requires root | `lib/apps/b/betterdisplay.sh` |
| betterdisplay | `maclib::betterdisplay::update` | Update "BetterDisplay" | implemented | no update path | `lib/apps/b/betterdisplay.sh` |
| betterdisplay | `maclib::betterdisplay::uninstall` | Uninstall "BetterDisplay" | implemented | no clean uninstall | `lib/apps/b/betterdisplay.sh` |

| bettertouchtool | `maclib::bettertouchtool::suite_installer_url` | "BetterTouchTool" installer URL (Installomator) | implemented | team "DAFVSXZ82P"; "zip" | `lib/apps/b/bettertouchtool.sh` |
| bettertouchtool | `maclib::bettertouchtool::latest_version` | "BetterTouchTool" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bettertouchtool.sh` |
| bettertouchtool | `maclib::bettertouchtool::is_installed` | Return 0 if "BetterTouchTool" installed | implemented | team "DAFVSXZ82P"; "zip" | `lib/apps/b/bettertouchtool.sh` |
| bettertouchtool | `maclib::bettertouchtool::installed_path` | Path to installed "BetterTouchTool" bundle | implemented |  | `lib/apps/b/bettertouchtool.sh` |
| bettertouchtool | `maclib::bettertouchtool::install` | Download installer and install "BetterTouchTool" | implemented | requires root | `lib/apps/b/bettertouchtool.sh` |
| bettertouchtool | `maclib::bettertouchtool::update` | Update "BetterTouchTool" | implemented | no update path | `lib/apps/b/bettertouchtool.sh` |
| bettertouchtool | `maclib::bettertouchtool::uninstall` | Uninstall "BetterTouchTool" | implemented | no clean uninstall | `lib/apps/b/bettertouchtool.sh` |

| betterzip | `maclib::betterzip::suite_installer_url` | "BetterZip" installer URL (Installomator) | implemented | team "79RR9LPM2N"; "zip" | `lib/apps/b/betterzip.sh` |
| betterzip | `maclib::betterzip::latest_version` | "BetterZip" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/betterzip.sh` |
| betterzip | `maclib::betterzip::is_installed` | Return 0 if "BetterZip" installed | implemented | team "79RR9LPM2N"; "zip" | `lib/apps/b/betterzip.sh` |
| betterzip | `maclib::betterzip::installed_path` | Path to installed "BetterZip" bundle | implemented |  | `lib/apps/b/betterzip.sh` |
| betterzip | `maclib::betterzip::install` | Download installer and install "BetterZip" | implemented | requires root | `lib/apps/b/betterzip.sh` |
| betterzip | `maclib::betterzip::update` | Update "BetterZip" | implemented | no update path | `lib/apps/b/betterzip.sh` |
| betterzip | `maclib::betterzip::uninstall` | Uninstall "BetterZip" | implemented | no clean uninstall | `lib/apps/b/betterzip.sh` |

| beyondcomparepro | `maclib::beyondcomparepro::suite_installer_url` | "Beyond Compare" installer URL (Installomator) | implemented | team "BS29TEJF86"; "zip" | `lib/apps/b/beyondcomparepro.sh` |
| beyondcomparepro | `maclib::beyondcomparepro::latest_version` | "Beyond Compare" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/beyondcomparepro.sh` |
| beyondcomparepro | `maclib::beyondcomparepro::is_installed` | Return 0 if "Beyond Compare" installed | implemented | team "BS29TEJF86"; "zip" | `lib/apps/b/beyondcomparepro.sh` |
| beyondcomparepro | `maclib::beyondcomparepro::installed_path` | Path to installed "Beyond Compare" bundle | implemented |  | `lib/apps/b/beyondcomparepro.sh` |
| beyondcomparepro | `maclib::beyondcomparepro::install` | Download installer and install "Beyond Compare" | implemented | requires root | `lib/apps/b/beyondcomparepro.sh` |
| beyondcomparepro | `maclib::beyondcomparepro::update` | Update "Beyond Compare" | implemented | no update path | `lib/apps/b/beyondcomparepro.sh` |
| beyondcomparepro | `maclib::beyondcomparepro::uninstall` | Uninstall "Beyond Compare" | implemented | no clean uninstall | `lib/apps/b/beyondcomparepro.sh` |

| bezel | `maclib::bezel::suite_installer_url` | "Bezel" installer URL (Installomator) | implemented | team "WT5N9FK54M"; "dmg" | `lib/apps/b/bezel.sh` |
| bezel | `maclib::bezel::latest_version` | "Bezel" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bezel.sh` |
| bezel | `maclib::bezel::is_installed` | Return 0 if "Bezel" installed | implemented | team "WT5N9FK54M"; "dmg" | `lib/apps/b/bezel.sh` |
| bezel | `maclib::bezel::installed_path` | Path to installed "Bezel" bundle | implemented |  | `lib/apps/b/bezel.sh` |
| bezel | `maclib::bezel::install` | Download installer and install "Bezel" | implemented | requires root | `lib/apps/b/bezel.sh` |
| bezel | `maclib::bezel::update` | Update "Bezel" | implemented | no update path | `lib/apps/b/bezel.sh` |
| bezel | `maclib::bezel::uninstall` | Uninstall "Bezel" | implemented | no clean uninstall | `lib/apps/b/bezel.sh` |

| bibdesk | `maclib::bibdesk::suite_installer_url` | "BibDesk" installer URL (Installomator) | implemented | team "J33JTA7SY9"; "dmg" | `lib/apps/b/bibdesk.sh` |
| bibdesk | `maclib::bibdesk::latest_version` | "BibDesk" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bibdesk.sh` |
| bibdesk | `maclib::bibdesk::is_installed` | Return 0 if "BibDesk" installed | implemented | team "J33JTA7SY9"; "dmg" | `lib/apps/b/bibdesk.sh` |
| bibdesk | `maclib::bibdesk::installed_path` | Path to installed "BibDesk" bundle | implemented |  | `lib/apps/b/bibdesk.sh` |
| bibdesk | `maclib::bibdesk::install` | Download installer and install "BibDesk" | implemented | requires root | `lib/apps/b/bibdesk.sh` |
| bibdesk | `maclib::bibdesk::update` | Update "BibDesk" | implemented | no update path | `lib/apps/b/bibdesk.sh` |
| bibdesk | `maclib::bibdesk::uninstall` | Uninstall "BibDesk" | implemented | no clean uninstall | `lib/apps/b/bibdesk.sh` |

| bitrix24 | `maclib::bitrix24::suite_installer_url` | "Bitrix24" installer URL (Installomator) | implemented | team "5B3T3A994N"; "dmg" | `lib/apps/b/bitrix24.sh` |
| bitrix24 | `maclib::bitrix24::latest_version` | "Bitrix24" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bitrix24.sh` |
| bitrix24 | `maclib::bitrix24::is_installed` | Return 0 if "Bitrix24" installed | implemented | team "5B3T3A994N"; "dmg" | `lib/apps/b/bitrix24.sh` |
| bitrix24 | `maclib::bitrix24::installed_path` | Path to installed "Bitrix24" bundle | implemented |  | `lib/apps/b/bitrix24.sh` |
| bitrix24 | `maclib::bitrix24::install` | Download installer and install "Bitrix24" | implemented | requires root | `lib/apps/b/bitrix24.sh` |
| bitrix24 | `maclib::bitrix24::update` | Update "Bitrix24" | implemented | no update path | `lib/apps/b/bitrix24.sh` |
| bitrix24 | `maclib::bitrix24::uninstall` | Uninstall "Bitrix24" | implemented | no clean uninstall | `lib/apps/b/bitrix24.sh` |

| bitwarden | `maclib::bitwarden::suite_installer_url` | "Bitwarden" installer URL (Installomator) | implemented | team "LTZ2PFU5D6"; "dmg" | `lib/apps/b/bitwarden.sh` |
| bitwarden | `maclib::bitwarden::latest_version` | "Bitwarden" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bitwarden.sh` |
| bitwarden | `maclib::bitwarden::is_installed` | Return 0 if "Bitwarden" installed | implemented | team "LTZ2PFU5D6"; "dmg" | `lib/apps/b/bitwarden.sh` |
| bitwarden | `maclib::bitwarden::installed_path` | Path to installed "Bitwarden" bundle | implemented |  | `lib/apps/b/bitwarden.sh` |
| bitwarden | `maclib::bitwarden::install` | Download installer and install "Bitwarden" | implemented | requires root | `lib/apps/b/bitwarden.sh` |
| bitwarden | `maclib::bitwarden::update` | Update "Bitwarden" | implemented | no update path | `lib/apps/b/bitwarden.sh` |
| bitwarden | `maclib::bitwarden::uninstall` | Uninstall "Bitwarden" | implemented | no clean uninstall | `lib/apps/b/bitwarden.sh` |

| bitwigstudio | `maclib::bitwigstudio::suite_installer_url` | "Bitwig Studio" installer URL (Installomator) | implemented | team "2B6K987585"; "dmg" | `lib/apps/b/bitwigstudio.sh` |
| bitwigstudio | `maclib::bitwigstudio::latest_version` | "Bitwig Studio" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bitwigstudio.sh` |
| bitwigstudio | `maclib::bitwigstudio::is_installed` | Return 0 if "Bitwig Studio" installed | implemented | team "2B6K987585"; "dmg" | `lib/apps/b/bitwigstudio.sh` |
| bitwigstudio | `maclib::bitwigstudio::installed_path` | Path to installed "Bitwig Studio" bundle | implemented |  | `lib/apps/b/bitwigstudio.sh` |
| bitwigstudio | `maclib::bitwigstudio::install` | Download installer and install "Bitwig Studio" | implemented | requires root | `lib/apps/b/bitwigstudio.sh` |
| bitwigstudio | `maclib::bitwigstudio::update` | Update "Bitwig Studio" | implemented | no update path | `lib/apps/b/bitwigstudio.sh` |
| bitwigstudio | `maclib::bitwigstudio::uninstall` | Uninstall "Bitwig Studio" | implemented | no clean uninstall | `lib/apps/b/bitwigstudio.sh` |

| blackhole16ch | `maclib::blackhole16ch::suite_installer_url` | "BlackHole" installer URL (Installomator) | implemented | team "Q5C99V536K"; "pkg" | `lib/apps/b/blackhole16ch.sh` |
| blackhole16ch | `maclib::blackhole16ch::latest_version` | "BlackHole" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/blackhole16ch.sh` |
| blackhole16ch | `maclib::blackhole16ch::is_installed` | Return 0 if "BlackHole" installed | implemented | team "Q5C99V536K"; "pkg" | `lib/apps/b/blackhole16ch.sh` |
| blackhole16ch | `maclib::blackhole16ch::installed_path` | Path to installed "BlackHole" bundle | implemented |  | `lib/apps/b/blackhole16ch.sh` |
| blackhole16ch | `maclib::blackhole16ch::install` | Download installer and install "BlackHole" | implemented | requires root | `lib/apps/b/blackhole16ch.sh` |
| blackhole16ch | `maclib::blackhole16ch::update` | Update "BlackHole" | implemented | no update path | `lib/apps/b/blackhole16ch.sh` |
| blackhole16ch | `maclib::blackhole16ch::uninstall` | Uninstall "BlackHole" | implemented | no clean uninstall | `lib/apps/b/blackhole16ch.sh` |

| blackhole2ch | `maclib::blackhole2ch::suite_installer_url` | "BlackHole" installer URL (Installomator) | implemented | team "Q5C99V536K"; "pkg" | `lib/apps/b/blackhole2ch.sh` |
| blackhole2ch | `maclib::blackhole2ch::latest_version` | "BlackHole" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/blackhole2ch.sh` |
| blackhole2ch | `maclib::blackhole2ch::is_installed` | Return 0 if "BlackHole" installed | implemented | team "Q5C99V536K"; "pkg" | `lib/apps/b/blackhole2ch.sh` |
| blackhole2ch | `maclib::blackhole2ch::installed_path` | Path to installed "BlackHole" bundle | implemented |  | `lib/apps/b/blackhole2ch.sh` |
| blackhole2ch | `maclib::blackhole2ch::install` | Download installer and install "BlackHole" | implemented | requires root | `lib/apps/b/blackhole2ch.sh` |
| blackhole2ch | `maclib::blackhole2ch::update` | Update "BlackHole" | implemented | no update path | `lib/apps/b/blackhole2ch.sh` |
| blackhole2ch | `maclib::blackhole2ch::uninstall` | Uninstall "BlackHole" | implemented | no clean uninstall | `lib/apps/b/blackhole2ch.sh` |

| blackhole64ch | `maclib::blackhole64ch::suite_installer_url` | "BlackHole" installer URL (Installomator) | implemented | team "Q5C99V536K"; "pkg" | `lib/apps/b/blackhole64ch.sh` |
| blackhole64ch | `maclib::blackhole64ch::latest_version` | "BlackHole" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/blackhole64ch.sh` |
| blackhole64ch | `maclib::blackhole64ch::is_installed` | Return 0 if "BlackHole" installed | implemented | team "Q5C99V536K"; "pkg" | `lib/apps/b/blackhole64ch.sh` |
| blackhole64ch | `maclib::blackhole64ch::installed_path` | Path to installed "BlackHole" bundle | implemented |  | `lib/apps/b/blackhole64ch.sh` |
| blackhole64ch | `maclib::blackhole64ch::install` | Download installer and install "BlackHole" | implemented | requires root | `lib/apps/b/blackhole64ch.sh` |
| blackhole64ch | `maclib::blackhole64ch::update` | Update "BlackHole" | implemented | no update path | `lib/apps/b/blackhole64ch.sh` |
| blackhole64ch | `maclib::blackhole64ch::uninstall` | Uninstall "BlackHole" | implemented | no clean uninstall | `lib/apps/b/blackhole64ch.sh` |

| blitzit | `maclib::blitzit::suite_installer_url` | "Blitzit" installer URL (Installomator) | implemented | team "29VYWQJ9TL"; "dmg" | `lib/apps/b/blitzit.sh` |
| blitzit | `maclib::blitzit::latest_version` | "Blitzit" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/blitzit.sh` |
| blitzit | `maclib::blitzit::is_installed` | Return 0 if "Blitzit" installed | implemented | team "29VYWQJ9TL"; "dmg" | `lib/apps/b/blitzit.sh` |
| blitzit | `maclib::blitzit::installed_path` | Path to installed "Blitzit" bundle | implemented |  | `lib/apps/b/blitzit.sh` |
| blitzit | `maclib::blitzit::install` | Download installer and install "Blitzit" | implemented | requires root | `lib/apps/b/blitzit.sh` |
| blitzit | `maclib::blitzit::update` | Update "Blitzit" | implemented | no update path | `lib/apps/b/blitzit.sh` |
| blitzit | `maclib::blitzit::uninstall` | Uninstall "Blitzit" | implemented | no clean uninstall | `lib/apps/b/blitzit.sh` |

| boop | `maclib::boop::suite_installer_url` | "Boop" installer URL (Installomator) | implemented | team "RLZ8XBTX7G"; "zip" | `lib/apps/b/boop.sh` |
| boop | `maclib::boop::latest_version` | "Boop" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/boop.sh` |
| boop | `maclib::boop::is_installed` | Return 0 if "Boop" installed | implemented | team "RLZ8XBTX7G"; "zip" | `lib/apps/b/boop.sh` |
| boop | `maclib::boop::installed_path` | Path to installed "Boop" bundle | implemented |  | `lib/apps/b/boop.sh` |
| boop | `maclib::boop::install` | Download installer and install "Boop" | implemented | requires root | `lib/apps/b/boop.sh` |
| boop | `maclib::boop::update` | Update "Boop" | implemented | no update path | `lib/apps/b/boop.sh` |
| boop | `maclib::boop::uninstall` | Uninstall "Boop" | implemented | no clean uninstall | `lib/apps/b/boop.sh` |

| boxdrive | `maclib::boxdrive::suite_installer_url` | "Box" installer URL (Installomator) | implemented | team "M683GB7CPW"; "pkg" | `lib/apps/b/boxdrive.sh` |
| boxdrive | `maclib::boxdrive::latest_version` | "Box" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/boxdrive.sh` |
| boxdrive | `maclib::boxdrive::is_installed` | Return 0 if "Box" installed | implemented | team "M683GB7CPW"; "pkg" | `lib/apps/b/boxdrive.sh` |
| boxdrive | `maclib::boxdrive::installed_path` | Path to installed "Box" bundle | implemented |  | `lib/apps/b/boxdrive.sh` |
| boxdrive | `maclib::boxdrive::install` | Download installer and install "Box" | implemented | requires root | `lib/apps/b/boxdrive.sh` |
| boxdrive | `maclib::boxdrive::update` | Update "Box" | implemented | no update path | `lib/apps/b/boxdrive.sh` |
| boxdrive | `maclib::boxdrive::uninstall` | Uninstall "Box" | implemented | no clean uninstall | `lib/apps/b/boxdrive.sh` |

| boxsync | `maclib::boxsync::suite_installer_url` | "Box Sync" installer URL (Installomator) | implemented | team "M683GB7CPW"; "dmg" | `lib/apps/b/boxsync.sh` |
| boxsync | `maclib::boxsync::latest_version` | "Box Sync" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/boxsync.sh` |
| boxsync | `maclib::boxsync::is_installed` | Return 0 if "Box Sync" installed | implemented | team "M683GB7CPW"; "dmg" | `lib/apps/b/boxsync.sh` |
| boxsync | `maclib::boxsync::installed_path` | Path to installed "Box Sync" bundle | implemented |  | `lib/apps/b/boxsync.sh` |
| boxsync | `maclib::boxsync::install` | Download installer and install "Box Sync" | implemented | requires root | `lib/apps/b/boxsync.sh` |
| boxsync | `maclib::boxsync::update` | Update "Box Sync" | implemented | no update path | `lib/apps/b/boxsync.sh` |
| boxsync | `maclib::boxsync::uninstall` | Uninstall "Box Sync" | implemented | no clean uninstall | `lib/apps/b/boxsync.sh` |

| boxtools | `maclib::boxtools::suite_installer_url` | "Box Tools" installer URL (Installomator) | implemented | team "M683GB7CPW"; "pkg" | `lib/apps/b/boxtools.sh` |
| boxtools | `maclib::boxtools::latest_version` | "Box Tools" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/boxtools.sh` |
| boxtools | `maclib::boxtools::is_installed` | Return 0 if "Box Tools" installed | implemented | team "M683GB7CPW"; "pkg" | `lib/apps/b/boxtools.sh` |
| boxtools | `maclib::boxtools::installed_path` | Path to installed "Box Tools" bundle | implemented |  | `lib/apps/b/boxtools.sh` |
| boxtools | `maclib::boxtools::install` | Download installer and install "Box Tools" | implemented | requires root | `lib/apps/b/boxtools.sh` |
| boxtools | `maclib::boxtools::update` | Update "Box Tools" | implemented | no update path | `lib/apps/b/boxtools.sh` |
| boxtools | `maclib::boxtools::uninstall` | Uninstall "Box Tools" | implemented | no clean uninstall | `lib/apps/b/boxtools.sh` |

| bracketsio | `maclib::bracketsio::suite_installer_url` | "Brackets" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "dmg" | `lib/apps/b/bracketsio.sh` |
| bracketsio | `maclib::bracketsio::latest_version` | "Brackets" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bracketsio.sh` |
| bracketsio | `maclib::bracketsio::is_installed` | Return 0 if "Brackets" installed | implemented | team "JQ525L2MZD"; "dmg" | `lib/apps/b/bracketsio.sh` |
| bracketsio | `maclib::bracketsio::installed_path` | Path to installed "Brackets" bundle | implemented |  | `lib/apps/b/bracketsio.sh` |
| bracketsio | `maclib::bracketsio::install` | Download installer and install "Brackets" | implemented | requires root | `lib/apps/b/bracketsio.sh` |
| bracketsio | `maclib::bracketsio::update` | Update "Brackets" | implemented | no update path | `lib/apps/b/bracketsio.sh` |
| bracketsio | `maclib::bracketsio::uninstall` | Uninstall "Brackets" | implemented | no clean uninstall | `lib/apps/b/bracketsio.sh` |

| brave | `maclib::brave::suite_installer_url` | "Brave Browser" installer URL (Installomator) | implemented | team "KL8N8XSYF4"; "dmg" | `lib/apps/b/brave.sh` |
| brave | `maclib::brave::latest_version` | "Brave Browser" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/brave.sh` |
| brave | `maclib::brave::is_installed` | Return 0 if "Brave Browser" installed | implemented | team "KL8N8XSYF4"; "dmg" | `lib/apps/b/brave.sh` |
| brave | `maclib::brave::installed_path` | Path to installed "Brave Browser" bundle | implemented |  | `lib/apps/b/brave.sh` |
| brave | `maclib::brave::install` | Download installer and install "Brave Browser" | implemented | requires root | `lib/apps/b/brave.sh` |
| brave | `maclib::brave::update` | Update "Brave Browser" | implemented | no update path | `lib/apps/b/brave.sh` |
| brave | `maclib::brave::uninstall` | Uninstall "Brave Browser" | implemented | no clean uninstall | `lib/apps/b/brave.sh` |

| bravepkg | `maclib::bravepkg::suite_installer_url` | "Brave Browser" installer URL (Installomator) | implemented | team "KL8N8XSYF4"; "pkg" | `lib/apps/b/bravepkg.sh` |
| bravepkg | `maclib::bravepkg::latest_version` | "Brave Browser" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bravepkg.sh` |
| bravepkg | `maclib::bravepkg::is_installed` | Return 0 if "Brave Browser" installed | implemented | team "KL8N8XSYF4"; "pkg" | `lib/apps/b/bravepkg.sh` |
| bravepkg | `maclib::bravepkg::installed_path` | Path to installed "Brave Browser" bundle | implemented |  | `lib/apps/b/bravepkg.sh` |
| bravepkg | `maclib::bravepkg::install` | Download installer and install "Brave Browser" | implemented | requires root | `lib/apps/b/bravepkg.sh` |
| bravepkg | `maclib::bravepkg::update` | Update "Brave Browser" | implemented | no update path | `lib/apps/b/bravepkg.sh` |
| bravepkg | `maclib::bravepkg::uninstall` | Uninstall "Brave Browser" | implemented | no clean uninstall | `lib/apps/b/bravepkg.sh` |

| brosix | `maclib::brosix::suite_installer_url` | "Brosix" installer URL (Installomator) | implemented | team "TA6P23NW8H"; "pkg" | `lib/apps/b/brosix.sh` |
| brosix | `maclib::brosix::latest_version` | "Brosix" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/brosix.sh` |
| brosix | `maclib::brosix::is_installed` | Return 0 if "Brosix" installed | implemented | team "TA6P23NW8H"; "pkg" | `lib/apps/b/brosix.sh` |
| brosix | `maclib::brosix::installed_path` | Path to installed "Brosix" bundle | implemented |  | `lib/apps/b/brosix.sh` |
| brosix | `maclib::brosix::install` | Download installer and install "Brosix" | implemented | requires root | `lib/apps/b/brosix.sh` |
| brosix | `maclib::brosix::update` | Update "Brosix" | implemented | no update path | `lib/apps/b/brosix.sh` |
| brosix | `maclib::brosix::uninstall` | Uninstall "Brosix" | implemented | no clean uninstall | `lib/apps/b/brosix.sh` |

| browserosaurus | `maclib::browserosaurus::suite_installer_url` | "Browserosaurus" installer URL (Installomator) | implemented | team "Z89KPMLTFR"; "zip" | `lib/apps/b/browserosaurus.sh` |
| browserosaurus | `maclib::browserosaurus::latest_version` | "Browserosaurus" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/browserosaurus.sh` |
| browserosaurus | `maclib::browserosaurus::is_installed` | Return 0 if "Browserosaurus" installed | implemented | team "Z89KPMLTFR"; "zip" | `lib/apps/b/browserosaurus.sh` |
| browserosaurus | `maclib::browserosaurus::installed_path` | Path to installed "Browserosaurus" bundle | implemented |  | `lib/apps/b/browserosaurus.sh` |
| browserosaurus | `maclib::browserosaurus::install` | Download installer and install "Browserosaurus" | implemented | requires root | `lib/apps/b/browserosaurus.sh` |
| browserosaurus | `maclib::browserosaurus::update` | Update "Browserosaurus" | implemented | no update path | `lib/apps/b/browserosaurus.sh` |
| browserosaurus | `maclib::browserosaurus::uninstall` | Uninstall "Browserosaurus" | implemented | no clean uninstall | `lib/apps/b/browserosaurus.sh` |

| bruno | `maclib::bruno::suite_installer_url` | "Bruno" installer URL (Installomator) | implemented | team "P3WTZH48ZB"; "dmg" | `lib/apps/b/bruno.sh` |
| bruno | `maclib::bruno::latest_version` | "Bruno" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bruno.sh` |
| bruno | `maclib::bruno::is_installed` | Return 0 if "Bruno" installed | implemented | team "P3WTZH48ZB"; "dmg" | `lib/apps/b/bruno.sh` |
| bruno | `maclib::bruno::installed_path` | Path to installed "Bruno" bundle | implemented |  | `lib/apps/b/bruno.sh` |
| bruno | `maclib::bruno::install` | Download installer and install "Bruno" | implemented | requires root | `lib/apps/b/bruno.sh` |
| bruno | `maclib::bruno::update` | Update "Bruno" | implemented | no update path | `lib/apps/b/bruno.sh` |
| bruno | `maclib::bruno::uninstall` | Uninstall "Bruno" | implemented | no clean uninstall | `lib/apps/b/bruno.sh` |

| bugdom | `maclib::bugdom::suite_installer_url` | "Bugdom" installer URL (Installomator) | implemented | team "RVNL7XC27G"; "dmg" | `lib/apps/b/bugdom.sh` |
| bugdom | `maclib::bugdom::latest_version` | "Bugdom" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/bugdom.sh` |
| bugdom | `maclib::bugdom::is_installed` | Return 0 if "Bugdom" installed | implemented | team "RVNL7XC27G"; "dmg" | `lib/apps/b/bugdom.sh` |
| bugdom | `maclib::bugdom::installed_path` | Path to installed "Bugdom" bundle | implemented |  | `lib/apps/b/bugdom.sh` |
| bugdom | `maclib::bugdom::install` | Download installer and install "Bugdom" | implemented | requires root | `lib/apps/b/bugdom.sh` |
| bugdom | `maclib::bugdom::update` | Update "Bugdom" | implemented | no update path | `lib/apps/b/bugdom.sh` |
| bugdom | `maclib::bugdom::uninstall` | Uninstall "Bugdom" | implemented | no clean uninstall | `lib/apps/b/bugdom.sh` |

| burpsuiteprofessional | `maclib::burpsuiteprofessional::suite_installer_url` | "Burp Suite Professional" installer URL (Installomator) | implemented | team "N82YM748DZ"; macosx" | `lib/apps/b/burpsuiteprofessional.sh` |
| burpsuiteprofessional | `maclib::burpsuiteprofessional::latest_version` | "Burp Suite Professional" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/burpsuiteprofessional.sh` |
| burpsuiteprofessional | `maclib::burpsuiteprofessional::is_installed` | Return 0 if "Burp Suite Professional" installed | implemented | team "N82YM748DZ"; macosx" | `lib/apps/b/burpsuiteprofessional.sh` |
| burpsuiteprofessional | `maclib::burpsuiteprofessional::installed_path` | Path to installed "Burp Suite Professional" bundle | implemented |  | `lib/apps/b/burpsuiteprofessional.sh` |
| burpsuiteprofessional | `maclib::burpsuiteprofessional::install` | Download installer and install "Burp Suite Professional" | implemented | requires root | `lib/apps/b/burpsuiteprofessional.sh` |
| burpsuiteprofessional | `maclib::burpsuiteprofessional::update` | Update "Burp Suite Professional" | implemented | no update path | `lib/apps/b/burpsuiteprofessional.sh` |
| burpsuiteprofessional | `maclib::burpsuiteprofessional::uninstall` | Uninstall "Burp Suite Professional" | implemented | no clean uninstall | `lib/apps/b/burpsuiteprofessional.sh` |

| busycal | `maclib::busycal::suite_installer_url` | "BusyCal" installer URL (Installomator) | implemented | team "N4RA379GBW"; "dmg" | `lib/apps/b/busycal.sh` |
| busycal | `maclib::busycal::latest_version` | "BusyCal" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/busycal.sh` |
| busycal | `maclib::busycal::is_installed` | Return 0 if "BusyCal" installed | implemented | team "N4RA379GBW"; "dmg" | `lib/apps/b/busycal.sh` |
| busycal | `maclib::busycal::installed_path` | Path to installed "BusyCal" bundle | implemented |  | `lib/apps/b/busycal.sh` |
| busycal | `maclib::busycal::install` | Download installer and install "BusyCal" | implemented | requires root | `lib/apps/b/busycal.sh` |
| busycal | `maclib::busycal::update` | Update "BusyCal" | implemented | no update path | `lib/apps/b/busycal.sh` |
| busycal | `maclib::busycal::uninstall` | Uninstall "BusyCal" | implemented | no clean uninstall | `lib/apps/b/busycal.sh` |

| busycontacts | `maclib::busycontacts::suite_installer_url` | "BusyContacts" installer URL (Installomator) | implemented | team "N4RA379GBW"; "dmg" | `lib/apps/b/busycontacts.sh` |
| busycontacts | `maclib::busycontacts::latest_version` | "BusyContacts" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/busycontacts.sh` |
| busycontacts | `maclib::busycontacts::is_installed` | Return 0 if "BusyContacts" installed | implemented | team "N4RA379GBW"; "dmg" | `lib/apps/b/busycontacts.sh` |
| busycontacts | `maclib::busycontacts::installed_path` | Path to installed "BusyContacts" bundle | implemented |  | `lib/apps/b/busycontacts.sh` |
| busycontacts | `maclib::busycontacts::install` | Download installer and install "BusyContacts" | implemented | requires root | `lib/apps/b/busycontacts.sh` |
| busycontacts | `maclib::busycontacts::update` | Update "BusyContacts" | implemented | no update path | `lib/apps/b/busycontacts.sh` |
| busycontacts | `maclib::busycontacts::uninstall` | Uninstall "BusyContacts" | implemented | no clean uninstall | `lib/apps/b/busycontacts.sh` |

| buttercup | `maclib::buttercup::suite_installer_url` | "Buttercup" installer URL (Installomator) | implemented | team "9D8F4J769D"; "zip" | `lib/apps/b/buttercup.sh` |
| buttercup | `maclib::buttercup::latest_version` | "Buttercup" current build | implemented | Installomator appNewVersion logic | `lib/apps/b/buttercup.sh` |
| buttercup | `maclib::buttercup::is_installed` | Return 0 if "Buttercup" installed | implemented | team "9D8F4J769D"; "zip" | `lib/apps/b/buttercup.sh` |
| buttercup | `maclib::buttercup::installed_path` | Path to installed "Buttercup" bundle | implemented |  | `lib/apps/b/buttercup.sh` |
| buttercup | `maclib::buttercup::install` | Download installer and install "Buttercup" | implemented | requires root | `lib/apps/b/buttercup.sh` |
| buttercup | `maclib::buttercup::update` | Update "Buttercup" | implemented | no update path | `lib/apps/b/buttercup.sh` |
| buttercup | `maclib::buttercup::uninstall` | Uninstall "Buttercup" | implemented | no clean uninstall | `lib/apps/b/buttercup.sh` |

| caffeine | `maclib::caffeine::suite_installer_url` | "Caffeine" installer URL (Installomator) | implemented | team "YD6LEYT6WZ"; "dmg" | `lib/apps/c/caffeine.sh` |
| caffeine | `maclib::caffeine::latest_version` | "Caffeine" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/caffeine.sh` |
| caffeine | `maclib::caffeine::is_installed` | Return 0 if "Caffeine" installed | implemented | team "YD6LEYT6WZ"; "dmg" | `lib/apps/c/caffeine.sh` |
| caffeine | `maclib::caffeine::installed_path` | Path to installed "Caffeine" bundle | implemented |  | `lib/apps/c/caffeine.sh` |
| caffeine | `maclib::caffeine::install` | Download installer and install "Caffeine" | implemented | requires root | `lib/apps/c/caffeine.sh` |
| caffeine | `maclib::caffeine::update` | Update "Caffeine" | implemented | no update path | `lib/apps/c/caffeine.sh` |
| caffeine | `maclib::caffeine::uninstall` | Uninstall "Caffeine" | implemented | no clean uninstall | `lib/apps/c/caffeine.sh` |

| cakebrew | `maclib::cakebrew::suite_installer_url` | "Cakebrew" installer URL (Installomator) | implemented | team "R85D3K8ATT"; "zip" | `lib/apps/c/cakebrew.sh` |
| cakebrew | `maclib::cakebrew::latest_version` | "Cakebrew" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cakebrew.sh` |
| cakebrew | `maclib::cakebrew::is_installed` | Return 0 if "Cakebrew" installed | implemented | team "R85D3K8ATT"; "zip" | `lib/apps/c/cakebrew.sh` |
| cakebrew | `maclib::cakebrew::installed_path` | Path to installed "Cakebrew" bundle | implemented |  | `lib/apps/c/cakebrew.sh` |
| cakebrew | `maclib::cakebrew::install` | Download installer and install "Cakebrew" | implemented | requires root | `lib/apps/c/cakebrew.sh` |
| cakebrew | `maclib::cakebrew::update` | Update "Cakebrew" | implemented | no update path | `lib/apps/c/cakebrew.sh` |
| cakebrew | `maclib::cakebrew::uninstall` | Uninstall "Cakebrew" | implemented | no clean uninstall | `lib/apps/c/cakebrew.sh` |

| calcservice | `maclib::calcservice::suite_installer_url` | "CalcService" installer URL (Installomator) | implemented | team "679S2QUWR8"; "zip" | `lib/apps/c/calcservice.sh` |
| calcservice | `maclib::calcservice::latest_version` | "CalcService" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/calcservice.sh` |
| calcservice | `maclib::calcservice::is_installed` | Return 0 if "CalcService" installed | implemented | team "679S2QUWR8"; "zip" | `lib/apps/c/calcservice.sh` |
| calcservice | `maclib::calcservice::installed_path` | Path to installed "CalcService" bundle | implemented |  | `lib/apps/c/calcservice.sh` |
| calcservice | `maclib::calcservice::install` | Download installer and install "CalcService" | implemented | requires root | `lib/apps/c/calcservice.sh` |
| calcservice | `maclib::calcservice::update` | Update "CalcService" | implemented | no update path | `lib/apps/c/calcservice.sh` |
| calcservice | `maclib::calcservice::uninstall` | Uninstall "CalcService" | implemented | no clean uninstall | `lib/apps/c/calcservice.sh` |

| calibre | `maclib::calibre::suite_installer_url` | "calibre" installer URL (Installomator) | implemented | team "NTY7FVCEKP"; "dmg" | `lib/apps/c/calibre.sh` |
| calibre | `maclib::calibre::latest_version` | "calibre" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/calibre.sh` |
| calibre | `maclib::calibre::is_installed` | Return 0 if "calibre" installed | implemented | team "NTY7FVCEKP"; "dmg" | `lib/apps/c/calibre.sh` |
| calibre | `maclib::calibre::installed_path` | Path to installed "calibre" bundle | implemented |  | `lib/apps/c/calibre.sh` |
| calibre | `maclib::calibre::install` | Download installer and install "calibre" | implemented | requires root | `lib/apps/c/calibre.sh` |
| calibre | `maclib::calibre::update` | Update "calibre" | implemented | no update path | `lib/apps/c/calibre.sh` |
| calibre | `maclib::calibre::uninstall` | Uninstall "calibre" | implemented | no clean uninstall | `lib/apps/c/calibre.sh` |

| calibriteprofiler | `maclib::calibriteprofiler::suite_installer_url` | "calibrite PROFILER" installer URL (Installomator) | implemented | team "5C392763F5"; "dmg" | `lib/apps/c/calibriteprofiler.sh` |
| calibriteprofiler | `maclib::calibriteprofiler::latest_version` | "calibrite PROFILER" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/calibriteprofiler.sh` |
| calibriteprofiler | `maclib::calibriteprofiler::is_installed` | Return 0 if "calibrite PROFILER" installed | implemented | team "5C392763F5"; "dmg" | `lib/apps/c/calibriteprofiler.sh` |
| calibriteprofiler | `maclib::calibriteprofiler::installed_path` | Path to installed "calibrite PROFILER" bundle | implemented |  | `lib/apps/c/calibriteprofiler.sh` |
| calibriteprofiler | `maclib::calibriteprofiler::install` | Download installer and install "calibrite PROFILER" | implemented | requires root | `lib/apps/c/calibriteprofiler.sh` |
| calibriteprofiler | `maclib::calibriteprofiler::update` | Update "calibrite PROFILER" | implemented | no update path | `lib/apps/c/calibriteprofiler.sh` |
| calibriteprofiler | `maclib::calibriteprofiler::uninstall` | Uninstall "calibrite PROFILER" | implemented | no clean uninstall | `lib/apps/c/calibriteprofiler.sh` |

| cameracontroller | `maclib::cameracontroller::suite_installer_url` | "CameraController" installer URL (Installomator) | implemented | team "PY9WJ3M9MW"; "zip" | `lib/apps/c/cameracontroller.sh` |
| cameracontroller | `maclib::cameracontroller::latest_version` | "CameraController" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cameracontroller.sh` |
| cameracontroller | `maclib::cameracontroller::is_installed` | Return 0 if "CameraController" installed | implemented | team "PY9WJ3M9MW"; "zip" | `lib/apps/c/cameracontroller.sh` |
| cameracontroller | `maclib::cameracontroller::installed_path` | Path to installed "CameraController" bundle | implemented |  | `lib/apps/c/cameracontroller.sh` |
| cameracontroller | `maclib::cameracontroller::install` | Download installer and install "CameraController" | implemented | requires root | `lib/apps/c/cameracontroller.sh` |
| cameracontroller | `maclib::cameracontroller::update` | Update "CameraController" | implemented | no update path | `lib/apps/c/cameracontroller.sh` |
| cameracontroller | `maclib::cameracontroller::uninstall` | Uninstall "CameraController" | implemented | no clean uninstall | `lib/apps/c/cameracontroller.sh` |

| camostudio | `maclib::camostudio::suite_installer_url` | "Camo Studio" installer URL (Installomator) | implemented | team "Q248YREB53"; "zip" | `lib/apps/c/camostudio.sh` |
| camostudio | `maclib::camostudio::latest_version` | "Camo Studio" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/camostudio.sh` |
| camostudio | `maclib::camostudio::is_installed` | Return 0 if "Camo Studio" installed | implemented | team "Q248YREB53"; "zip" | `lib/apps/c/camostudio.sh` |
| camostudio | `maclib::camostudio::installed_path` | Path to installed "Camo Studio" bundle | implemented |  | `lib/apps/c/camostudio.sh` |
| camostudio | `maclib::camostudio::install` | Download installer and install "Camo Studio" | implemented | requires root | `lib/apps/c/camostudio.sh` |
| camostudio | `maclib::camostudio::update` | Update "Camo Studio" | implemented | no update path | `lib/apps/c/camostudio.sh` |
| camostudio | `maclib::camostudio::uninstall` | Uninstall "Camo Studio" | implemented | no clean uninstall | `lib/apps/c/camostudio.sh` |

| camunda | `maclib::camunda::suite_installer_url` | "Camunda Modeler" installer URL (Installomator) | implemented | team "3JVGD57JQZ"; "dmg" | `lib/apps/c/camunda.sh` |
| camunda | `maclib::camunda::latest_version` | "Camunda Modeler" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/camunda.sh` |
| camunda | `maclib::camunda::is_installed` | Return 0 if "Camunda Modeler" installed | implemented | team "3JVGD57JQZ"; "dmg" | `lib/apps/c/camunda.sh` |
| camunda | `maclib::camunda::installed_path` | Path to installed "Camunda Modeler" bundle | implemented |  | `lib/apps/c/camunda.sh` |
| camunda | `maclib::camunda::install` | Download installer and install "Camunda Modeler" | implemented | requires root | `lib/apps/c/camunda.sh` |
| camunda | `maclib::camunda::update` | Update "Camunda Modeler" | implemented | no update path | `lib/apps/c/camunda.sh` |
| camunda | `maclib::camunda::uninstall` | Uninstall "Camunda Modeler" | implemented | no clean uninstall | `lib/apps/c/camunda.sh` |

| canva | `maclib::canva::suite_installer_url` | "Canva" installer URL (Installomator) | implemented | team "5HD2ARTBFS"; "dmg" | `lib/apps/c/canva.sh` |
| canva | `maclib::canva::latest_version` | "Canva" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/canva.sh` |
| canva | `maclib::canva::is_installed` | Return 0 if "Canva" installed | implemented | team "5HD2ARTBFS"; "dmg" | `lib/apps/c/canva.sh` |
| canva | `maclib::canva::installed_path` | Path to installed "Canva" bundle | implemented |  | `lib/apps/c/canva.sh` |
| canva | `maclib::canva::install` | Download installer and install "Canva" | implemented | requires root | `lib/apps/c/canva.sh` |
| canva | `maclib::canva::update` | Update "Canva" | implemented | no update path | `lib/apps/c/canva.sh` |
| canva | `maclib::canva::uninstall` | Uninstall "Canva" | implemented | no clean uninstall | `lib/apps/c/canva.sh` |

| carboncopycloner | `maclib::carboncopycloner::suite_installer_url` | "Carbon Copy Cloner" installer URL (Installomator) | implemented | team "L4F2DED5Q7"; "zip" | `lib/apps/c/carboncopycloner.sh` |
| carboncopycloner | `maclib::carboncopycloner::latest_version` | "Carbon Copy Cloner" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/carboncopycloner.sh` |
| carboncopycloner | `maclib::carboncopycloner::is_installed` | Return 0 if "Carbon Copy Cloner" installed | implemented | team "L4F2DED5Q7"; "zip" | `lib/apps/c/carboncopycloner.sh` |
| carboncopycloner | `maclib::carboncopycloner::installed_path` | Path to installed "Carbon Copy Cloner" bundle | implemented |  | `lib/apps/c/carboncopycloner.sh` |
| carboncopycloner | `maclib::carboncopycloner::install` | Download installer and install "Carbon Copy Cloner" | implemented | requires root | `lib/apps/c/carboncopycloner.sh` |
| carboncopycloner | `maclib::carboncopycloner::update` | Update "Carbon Copy Cloner" | implemented | no update path | `lib/apps/c/carboncopycloner.sh` |
| carboncopycloner | `maclib::carboncopycloner::uninstall` | Uninstall "Carbon Copy Cloner" | implemented | no clean uninstall | `lib/apps/c/carboncopycloner.sh` |

| cardpresso | `maclib::cardpresso::suite_installer_url` | "cardpresso" installer URL (Installomator) | implemented | team "QH48YJ244W"; "dmg" | `lib/apps/c/cardpresso.sh` |
| cardpresso | `maclib::cardpresso::latest_version` | "cardpresso" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cardpresso.sh` |
| cardpresso | `maclib::cardpresso::is_installed` | Return 0 if "cardpresso" installed | implemented | team "QH48YJ244W"; "dmg" | `lib/apps/c/cardpresso.sh` |
| cardpresso | `maclib::cardpresso::installed_path` | Path to installed "cardpresso" bundle | implemented |  | `lib/apps/c/cardpresso.sh` |
| cardpresso | `maclib::cardpresso::install` | Download installer and install "cardpresso" | implemented | requires root | `lib/apps/c/cardpresso.sh` |
| cardpresso | `maclib::cardpresso::update` | Update "cardpresso" | implemented | no update path | `lib/apps/c/cardpresso.sh` |
| cardpresso | `maclib::cardpresso::uninstall` | Uninstall "cardpresso" | implemented | no clean uninstall | `lib/apps/c/cardpresso.sh` |

| catoclient | `maclib::catoclient::suite_installer_url` | "CatoClient" installer URL (Installomator) | implemented | team "CKGSB8CH43"; "pkg" | `lib/apps/c/catoclient.sh` |
| catoclient | `maclib::catoclient::latest_version` | "CatoClient" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/catoclient.sh` |
| catoclient | `maclib::catoclient::is_installed` | Return 0 if "CatoClient" installed | implemented | team "CKGSB8CH43"; "pkg" | `lib/apps/c/catoclient.sh` |
| catoclient | `maclib::catoclient::installed_path` | Path to installed "CatoClient" bundle | implemented |  | `lib/apps/c/catoclient.sh` |
| catoclient | `maclib::catoclient::install` | Download installer and install "CatoClient" | implemented | requires root | `lib/apps/c/catoclient.sh` |
| catoclient | `maclib::catoclient::update` | Update "CatoClient" | implemented | no update path | `lib/apps/c/catoclient.sh` |
| catoclient | `maclib::catoclient::uninstall` | Uninstall "CatoClient" | implemented | no clean uninstall | `lib/apps/c/catoclient.sh` |

| charles | `maclib::charles::suite_installer_url` | "Charles" installer URL (Installomator) | implemented | team "9A5PCU4FSD"; "dmg" | `lib/apps/c/charles.sh` |
| charles | `maclib::charles::latest_version` | "Charles" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/charles.sh` |
| charles | `maclib::charles::is_installed` | Return 0 if "Charles" installed | implemented | team "9A5PCU4FSD"; "dmg" | `lib/apps/c/charles.sh` |
| charles | `maclib::charles::installed_path` | Path to installed "Charles" bundle | implemented |  | `lib/apps/c/charles.sh` |
| charles | `maclib::charles::install` | Download installer and install "Charles" | implemented | requires root | `lib/apps/c/charles.sh` |
| charles | `maclib::charles::update` | Update "Charles" | implemented | no update path | `lib/apps/c/charles.sh` |
| charles | `maclib::charles::uninstall` | Uninstall "Charles" | implemented | no clean uninstall | `lib/apps/c/charles.sh` |

| chatwork | `maclib::chatwork::suite_installer_url` | "Chatwork" installer URL (Installomator) | implemented | team "H34A3H2Y54"; "dmg" | `lib/apps/c/chatwork.sh` |
| chatwork | `maclib::chatwork::latest_version` | "Chatwork" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/chatwork.sh` |
| chatwork | `maclib::chatwork::is_installed` | Return 0 if "Chatwork" installed | implemented | team "H34A3H2Y54"; "dmg" | `lib/apps/c/chatwork.sh` |
| chatwork | `maclib::chatwork::installed_path` | Path to installed "Chatwork" bundle | implemented |  | `lib/apps/c/chatwork.sh` |
| chatwork | `maclib::chatwork::install` | Download installer and install "Chatwork" | implemented | requires root | `lib/apps/c/chatwork.sh` |
| chatwork | `maclib::chatwork::update` | Update "Chatwork" | implemented | no update path | `lib/apps/c/chatwork.sh` |
| chatwork | `maclib::chatwork::uninstall` | Uninstall "Chatwork" | implemented | no clean uninstall | `lib/apps/c/chatwork.sh` |

| chemdoodle2d | `maclib::chemdoodle2d::suite_installer_url` | "ChemDoodle" installer URL (Installomator) | implemented | team "9XP397UW95"; "dmg" | `lib/apps/c/chemdoodle2d.sh` |
| chemdoodle2d | `maclib::chemdoodle2d::latest_version` | "ChemDoodle" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/chemdoodle2d.sh` |
| chemdoodle2d | `maclib::chemdoodle2d::is_installed` | Return 0 if "ChemDoodle" installed | implemented | team "9XP397UW95"; "dmg" | `lib/apps/c/chemdoodle2d.sh` |
| chemdoodle2d | `maclib::chemdoodle2d::installed_path` | Path to installed "ChemDoodle" bundle | implemented |  | `lib/apps/c/chemdoodle2d.sh` |
| chemdoodle2d | `maclib::chemdoodle2d::install` | Download installer and install "ChemDoodle" | implemented | requires root | `lib/apps/c/chemdoodle2d.sh` |
| chemdoodle2d | `maclib::chemdoodle2d::update` | Update "ChemDoodle" | implemented | no update path | `lib/apps/c/chemdoodle2d.sh` |
| chemdoodle2d | `maclib::chemdoodle2d::uninstall` | Uninstall "ChemDoodle" | implemented | no clean uninstall | `lib/apps/c/chemdoodle2d.sh` |

| chemdoodle3d | `maclib::chemdoodle3d::suite_installer_url` | "ChemDoodle3D" installer URL (Installomator) | implemented | team "9XP397UW95"; "dmg" | `lib/apps/c/chemdoodle3d.sh` |
| chemdoodle3d | `maclib::chemdoodle3d::latest_version` | "ChemDoodle3D" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/chemdoodle3d.sh` |
| chemdoodle3d | `maclib::chemdoodle3d::is_installed` | Return 0 if "ChemDoodle3D" installed | implemented | team "9XP397UW95"; "dmg" | `lib/apps/c/chemdoodle3d.sh` |
| chemdoodle3d | `maclib::chemdoodle3d::installed_path` | Path to installed "ChemDoodle3D" bundle | implemented |  | `lib/apps/c/chemdoodle3d.sh` |
| chemdoodle3d | `maclib::chemdoodle3d::install` | Download installer and install "ChemDoodle3D" | implemented | requires root | `lib/apps/c/chemdoodle3d.sh` |
| chemdoodle3d | `maclib::chemdoodle3d::update` | Update "ChemDoodle3D" | implemented | no update path | `lib/apps/c/chemdoodle3d.sh` |
| chemdoodle3d | `maclib::chemdoodle3d::uninstall` | Uninstall "ChemDoodle3D" | implemented | no clean uninstall | `lib/apps/c/chemdoodle3d.sh` |

| cherryaudioblue3 | `maclib::cherryaudioblue3::suite_installer_url` | "Blue3 Organ" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioblue3.sh` |
| cherryaudioblue3 | `maclib::cherryaudioblue3::latest_version` | "Blue3 Organ" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudioblue3.sh` |
| cherryaudioblue3 | `maclib::cherryaudioblue3::is_installed` | Return 0 if "Blue3 Organ" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioblue3.sh` |
| cherryaudioblue3 | `maclib::cherryaudioblue3::installed_path` | Path to installed "Blue3 Organ" bundle | implemented |  | `lib/apps/c/cherryaudioblue3.sh` |
| cherryaudioblue3 | `maclib::cherryaudioblue3::install` | Download installer and install "Blue3 Organ" | implemented | requires root | `lib/apps/c/cherryaudioblue3.sh` |
| cherryaudioblue3 | `maclib::cherryaudioblue3::update` | Update "Blue3 Organ" | implemented | no update path | `lib/apps/c/cherryaudioblue3.sh` |
| cherryaudioblue3 | `maclib::cherryaudioblue3::uninstall` | Uninstall "Blue3 Organ" | implemented | no clean uninstall | `lib/apps/c/cherryaudioblue3.sh` |

| cherryaudioca2600 | `maclib::cherryaudioca2600::suite_installer_url` | "CA2600" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioca2600.sh` |
| cherryaudioca2600 | `maclib::cherryaudioca2600::latest_version` | "CA2600" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudioca2600.sh` |
| cherryaudioca2600 | `maclib::cherryaudioca2600::is_installed` | Return 0 if "CA2600" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioca2600.sh` |
| cherryaudioca2600 | `maclib::cherryaudioca2600::installed_path` | Path to installed "CA2600" bundle | implemented |  | `lib/apps/c/cherryaudioca2600.sh` |
| cherryaudioca2600 | `maclib::cherryaudioca2600::install` | Download installer and install "CA2600" | implemented | requires root | `lib/apps/c/cherryaudioca2600.sh` |
| cherryaudioca2600 | `maclib::cherryaudioca2600::update` | Update "CA2600" | implemented | no update path | `lib/apps/c/cherryaudioca2600.sh` |
| cherryaudioca2600 | `maclib::cherryaudioca2600::uninstall` | Uninstall "CA2600" | implemented | no clean uninstall | `lib/apps/c/cherryaudioca2600.sh` |

| cherryaudiochroma | `maclib::cherryaudiochroma::suite_installer_url` | "Chroma" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiochroma.sh` |
| cherryaudiochroma | `maclib::cherryaudiochroma::latest_version` | "Chroma" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudiochroma.sh` |
| cherryaudiochroma | `maclib::cherryaudiochroma::is_installed` | Return 0 if "Chroma" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiochroma.sh` |
| cherryaudiochroma | `maclib::cherryaudiochroma::installed_path` | Path to installed "Chroma" bundle | implemented |  | `lib/apps/c/cherryaudiochroma.sh` |
| cherryaudiochroma | `maclib::cherryaudiochroma::install` | Download installer and install "Chroma" | implemented | requires root | `lib/apps/c/cherryaudiochroma.sh` |
| cherryaudiochroma | `maclib::cherryaudiochroma::update` | Update "Chroma" | implemented | no update path | `lib/apps/c/cherryaudiochroma.sh` |
| cherryaudiochroma | `maclib::cherryaudiochroma::uninstall` | Uninstall "Chroma" | implemented | no clean uninstall | `lib/apps/c/cherryaudiochroma.sh` |

| cherryaudiocr78 | `maclib::cherryaudiocr78::suite_installer_url` | "CR-78" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiocr78.sh` |
| cherryaudiocr78 | `maclib::cherryaudiocr78::latest_version` | "CR-78" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudiocr78.sh` |
| cherryaudiocr78 | `maclib::cherryaudiocr78::is_installed` | Return 0 if "CR-78" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiocr78.sh` |
| cherryaudiocr78 | `maclib::cherryaudiocr78::installed_path` | Path to installed "CR-78" bundle | implemented |  | `lib/apps/c/cherryaudiocr78.sh` |
| cherryaudiocr78 | `maclib::cherryaudiocr78::install` | Download installer and install "CR-78" | implemented | requires root | `lib/apps/c/cherryaudiocr78.sh` |
| cherryaudiocr78 | `maclib::cherryaudiocr78::update` | Update "CR-78" | implemented | no update path | `lib/apps/c/cherryaudiocr78.sh` |
| cherryaudiocr78 | `maclib::cherryaudiocr78::uninstall` | Uninstall "CR-78" | implemented | no clean uninstall | `lib/apps/c/cherryaudiocr78.sh` |

| cherryaudiodco106 | `maclib::cherryaudiodco106::suite_installer_url` | "DCO-106" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiodco106.sh` |
| cherryaudiodco106 | `maclib::cherryaudiodco106::latest_version` | "DCO-106" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudiodco106.sh` |
| cherryaudiodco106 | `maclib::cherryaudiodco106::is_installed` | Return 0 if "DCO-106" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiodco106.sh` |
| cherryaudiodco106 | `maclib::cherryaudiodco106::installed_path` | Path to installed "DCO-106" bundle | implemented |  | `lib/apps/c/cherryaudiodco106.sh` |
| cherryaudiodco106 | `maclib::cherryaudiodco106::install` | Download installer and install "DCO-106" | implemented | requires root | `lib/apps/c/cherryaudiodco106.sh` |
| cherryaudiodco106 | `maclib::cherryaudiodco106::update` | Update "DCO-106" | implemented | no update path | `lib/apps/c/cherryaudiodco106.sh` |
| cherryaudiodco106 | `maclib::cherryaudiodco106::uninstall` | Uninstall "DCO-106" | implemented | no clean uninstall | `lib/apps/c/cherryaudiodco106.sh` |

| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::suite_installer_url` | "Dreamsynth" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiodreamsynth.sh` |
| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::latest_version` | "Dreamsynth" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudiodreamsynth.sh` |
| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::is_installed` | Return 0 if "Dreamsynth" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiodreamsynth.sh` |
| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::installed_path` | Path to installed "Dreamsynth" bundle | implemented |  | `lib/apps/c/cherryaudiodreamsynth.sh` |
| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::install` | Download installer and install "Dreamsynth" | implemented | requires root | `lib/apps/c/cherryaudiodreamsynth.sh` |
| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::update` | Update "Dreamsynth" | implemented | no update path | `lib/apps/c/cherryaudiodreamsynth.sh` |
| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::uninstall` | Uninstall "Dreamsynth" | implemented | no clean uninstall | `lib/apps/c/cherryaudiodreamsynth.sh` |

| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::suite_installer_url` | "Eight Voice" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioeightvoice.sh` |
| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::latest_version` | "Eight Voice" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudioeightvoice.sh` |
| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::is_installed` | Return 0 if "Eight Voice" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioeightvoice.sh` |
| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::installed_path` | Path to installed "Eight Voice" bundle | implemented |  | `lib/apps/c/cherryaudioeightvoice.sh` |
| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::install` | Download installer and install "Eight Voice" | implemented | requires root | `lib/apps/c/cherryaudioeightvoice.sh` |
| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::update` | Update "Eight Voice" | implemented | no update path | `lib/apps/c/cherryaudioeightvoice.sh` |
| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::uninstall` | Uninstall "Eight Voice" | implemented | no clean uninstall | `lib/apps/c/cherryaudioeightvoice.sh` |

| cherryaudioelkax | `maclib::cherryaudioelkax::suite_installer_url` | "Elka-X" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioelkax.sh` |
| cherryaudioelkax | `maclib::cherryaudioelkax::latest_version` | "Elka-X" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudioelkax.sh` |
| cherryaudioelkax | `maclib::cherryaudioelkax::is_installed` | Return 0 if "Elka-X" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudioelkax.sh` |
| cherryaudioelkax | `maclib::cherryaudioelkax::installed_path` | Path to installed "Elka-X" bundle | implemented |  | `lib/apps/c/cherryaudioelkax.sh` |
| cherryaudioelkax | `maclib::cherryaudioelkax::install` | Download installer and install "Elka-X" | implemented | requires root | `lib/apps/c/cherryaudioelkax.sh` |
| cherryaudioelkax | `maclib::cherryaudioelkax::update` | Update "Elka-X" | implemented | no update path | `lib/apps/c/cherryaudioelkax.sh` |
| cherryaudioelkax | `maclib::cherryaudioelkax::uninstall` | Uninstall "Elka-X" | implemented | no clean uninstall | `lib/apps/c/cherryaudioelkax.sh` |

| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::suite_installer_url` | "Galactic Reverb" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiogalacticreverb.sh` |
| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::latest_version` | "Galactic Reverb" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudiogalacticreverb.sh` |
| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::is_installed` | Return 0 if "Galactic Reverb" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiogalacticreverb.sh` |
| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::installed_path` | Path to installed "Galactic Reverb" bundle | implemented |  | `lib/apps/c/cherryaudiogalacticreverb.sh` |
| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::install` | Download installer and install "Galactic Reverb" | implemented | requires root | `lib/apps/c/cherryaudiogalacticreverb.sh` |
| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::update` | Update "Galactic Reverb" | implemented | no update path | `lib/apps/c/cherryaudiogalacticreverb.sh` |
| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::uninstall` | Uninstall "Galactic Reverb" | implemented | no clean uninstall | `lib/apps/c/cherryaudiogalacticreverb.sh` |

| cherryaudiogx80 | `maclib::cherryaudiogx80::suite_installer_url` | "GX-80" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiogx80.sh` |
| cherryaudiogx80 | `maclib::cherryaudiogx80::latest_version` | "GX-80" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/cherryaudiogx80.sh` |
| cherryaudiogx80 | `maclib::cherryaudiogx80::is_installed` | Return 0 if "GX-80" installed | implemented | team "A2XFV22B2X"; "pkg" | `lib/apps/c/cherryaudiogx80.sh` |
| cherryaudiogx80 | `maclib::cherryaudiogx80::installed_path` | Path to installed "GX-80" bundle | implemented |  | `lib/apps/c/cherryaudiogx80.sh` |
| cherryaudiogx80 | `maclib::cherryaudiogx80::install` | Download installer and install "GX-80" | implemented | requires root | `lib/apps/c/cherryaudiogx80.sh` |
| cherryaudiogx80 | `maclib::cherryaudiogx80::update` | Update "GX-80" | implemented | no update path | `lib/apps/c/cherryaudiogx80.sh` |
| cherryaudiogx80 | `maclib::cherryaudiogx80::uninstall` | Uninstall "GX-80" | implemented | no clean uninstall | `lib/apps/c/cherryaudiogx80.sh` |

| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::suite_installer_url` | "Acronis Cyber Protect Connect" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::latest_version` | "Acronis Cyber Protect Connect" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::is_installed` | Return 0 if "Acronis Cyber Protect Connect" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::installed_path` | Path to installed "Acronis Cyber Protect Connect" bundle | implemented |  | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::install` | Download installer and install "Acronis Cyber Protect Connect" | implemented | requires root; no vendor URL documented | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::update` | Update "Acronis Cyber Protect Connect" | implemented | no update path (re-run install) | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::uninstall` | Uninstall "Acronis Cyber Protect Connect" | implemented | no clean uninstall | `lib/apps/a/acroniscyberprotectconnect.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::suite_installer_url` | "Acronis Cyber Protect Connect Agent" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::latest_version` | "Acronis Cyber Protect Connect Agent" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::is_installed` | Return 0 if "Acronis Cyber Protect Connect Agent" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::installed_path` | Path to installed "Acronis Cyber Protect Connect Agent" bundle | implemented |  | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::install` | Download installer and install "Acronis Cyber Protect Connect Agent" | implemented | requires root; no vendor URL documented | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::update` | Update "Acronis Cyber Protect Connect Agent" | implemented | no update path (re-run install) | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::uninstall` | Uninstall "Acronis Cyber Protect Connect Agent" | implemented | no clean uninstall | `lib/apps/a/acroniscyberprotectconnectagent.sh` |
| adobebrackets | `maclib::adobebrackets::suite_installer_url` | "Brackets" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/adobebrackets.sh` |
| adobebrackets | `maclib::adobebrackets::latest_version` | "Brackets" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/adobebrackets.sh` |
| adobebrackets | `maclib::adobebrackets::is_installed` | Return 0 if "Brackets" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/adobebrackets.sh` |
| adobebrackets | `maclib::adobebrackets::installed_path` | Path to installed "Brackets" bundle | implemented |  | `lib/apps/a/adobebrackets.sh` |
| adobebrackets | `maclib::adobebrackets::install` | Download installer and install "Brackets" | implemented | requires root; no vendor URL documented | `lib/apps/a/adobebrackets.sh` |
| adobebrackets | `maclib::adobebrackets::update` | Update "Brackets" | implemented | no update path (re-run install) | `lib/apps/a/adobebrackets.sh` |
| adobebrackets | `maclib::adobebrackets::uninstall` | Uninstall "Brackets" | implemented | no clean uninstall | `lib/apps/a/adobebrackets.sh` |
| adobereaderdc | `maclib::adobereaderdc::suite_installer_url` | "Adobe Acrobat Reader DC" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/adobereaderdc.sh` |
| adobereaderdc | `maclib::adobereaderdc::latest_version` | "Adobe Acrobat Reader DC" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/adobereaderdc.sh` |
| adobereaderdc | `maclib::adobereaderdc::is_installed` | Return 0 if "Adobe Acrobat Reader DC" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/adobereaderdc.sh` |
| adobereaderdc | `maclib::adobereaderdc::installed_path` | Path to installed "Adobe Acrobat Reader DC" bundle | implemented |  | `lib/apps/a/adobereaderdc.sh` |
| adobereaderdc | `maclib::adobereaderdc::install` | Download installer and install "Adobe Acrobat Reader DC" | implemented | requires root; no vendor URL documented | `lib/apps/a/adobereaderdc.sh` |
| adobereaderdc | `maclib::adobereaderdc::update` | Update "Adobe Acrobat Reader DC" | implemented | no update path (re-run install) | `lib/apps/a/adobereaderdc.sh` |
| adobereaderdc | `maclib::adobereaderdc::uninstall` | Uninstall "Adobe Acrobat Reader DC" | implemented | no clean uninstall | `lib/apps/a/adobereaderdc.sh` |
||| adobereaderdc-install | `maclib::adobereaderdc-install::suite_installer_url` | "Adobe Acrobat Reader DC (install)" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobereaderdc-install | `maclib::adobereaderdc-install::latest_version` | "Adobe Acrobat Reader DC (install)" current build | implemented | Installomator appNewVersion logic |
||| adobereaderdc-install | `maclib::adobereaderdc-install::is_installed` | Return 0 if "Adobe Acrobat Reader DC (install)" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobereaderdc-install | `maclib::adobereaderdc-install::installed_path` | Path to installed "Adobe Acrobat Reader DC (install)" bundle | implemented | |
||| adobereaderdc-install | `maclib::adobereaderdc-install::install` | Download installer and install "Adobe Acrobat Reader DC (install)" | implemented | requires root; no vendor URL documented |
||| adobereaderdc-install | `maclib::adobereaderdc-install::update` | Update "Adobe Acrobat Reader DC (install)" | implemented | no update path (re-run install) |
||| adobereaderdc-install | `maclib::adobereaderdc-install::uninstall` | Uninstall "Adobe Acrobat Reader DC (install)" | implemented | no clean uninstall |
| applesfsymbols | `maclib::applesfsymbols::suite_installer_url` | "Symbols" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/applesfsymbols.sh` |
| applesfsymbols | `maclib::applesfsymbols::latest_version` | "Symbols" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/applesfsymbols.sh` |
| applesfsymbols | `maclib::applesfsymbols::is_installed` | Return 0 if "Symbols" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/applesfsymbols.sh` |
| applesfsymbols | `maclib::applesfsymbols::installed_path` | Path to installed "Symbols" bundle | implemented |  | `lib/apps/a/applesfsymbols.sh` |
| applesfsymbols | `maclib::applesfsymbols::install` | Download installer and install "Symbols" | implemented | requires root; no vendor URL documented | `lib/apps/a/applesfsymbols.sh` |
| applesfsymbols | `maclib::applesfsymbols::update` | Update "Symbols" | implemented | no update path (re-run install) | `lib/apps/a/applesfsymbols.sh` |
| applesfsymbols | `maclib::applesfsymbols::uninstall` | Uninstall "Symbols" | implemented | no clean uninstall | `lib/apps/a/applesfsymbols.sh` |
| aspera | `maclib::aspera::suite_installer_url` | "Aspera" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/aspera.sh` |
| aspera | `maclib::aspera::latest_version` | "Aspera" current build | implemented | Installomator appNewVersion logic | `lib/apps/a/aspera.sh` |
| aspera | `maclib::aspera::is_installed` | Return 0 if "Aspera" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/a/aspera.sh` |
| aspera | `maclib::aspera::installed_path` | Path to installed "Aspera" bundle | implemented |  | `lib/apps/a/aspera.sh` |
| aspera | `maclib::aspera::install` | Download installer and install "Aspera" | implemented | requires root; no vendor URL documented | `lib/apps/a/aspera.sh` |
| aspera | `maclib::aspera::update` | Update "Aspera" | implemented | no update path (re-run install) | `lib/apps/a/aspera.sh` |
| aspera | `maclib::aspera::uninstall` | Uninstall "Aspera" | implemented | no clean uninstall | `lib/apps/a/aspera.sh` |
| chemdoodle | `maclib::chemdoodle::suite_installer_url` | "ChemDoodle" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/c/chemdoodle.sh` |
| chemdoodle | `maclib::chemdoodle::latest_version` | "ChemDoodle" current build | implemented | Installomator appNewVersion logic | `lib/apps/c/chemdoodle.sh` |
| chemdoodle | `maclib::chemdoodle::is_installed` | Return 0 if "ChemDoodle" installed | implemented | team "n/a"; "dmg"; no vendor URL | `lib/apps/c/chemdoodle.sh` |
| chemdoodle | `maclib::chemdoodle::installed_path` | Path to installed "ChemDoodle" bundle | implemented |  | `lib/apps/c/chemdoodle.sh` |
| chemdoodle | `maclib::chemdoodle::install` | Download installer and install "ChemDoodle" | implemented | requires root; no vendor URL documented | `lib/apps/c/chemdoodle.sh` |
| chemdoodle | `maclib::chemdoodle::update` | Update "ChemDoodle" | implemented | no update path (re-run install) | `lib/apps/c/chemdoodle.sh` |
| chemdoodle | `maclib::chemdoodle::uninstall` | Uninstall "ChemDoodle" | implemented | no clean uninstall | `lib/apps/c/chemdoodle.sh` |
