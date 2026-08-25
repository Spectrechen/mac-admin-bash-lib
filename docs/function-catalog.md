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
||| 4kvideodownloader | `maclib::4kvideodownloader::suite_installer_url` | "4K Video Downloader" installer URL (Installomator) | implemented | team "GHQ37VJF83"; "dmg" |
||| 4kvideodownloader | `maclib::4kvideodownloader::latest_version` | "4K Video Downloader" current build | implemented | Installomator appNewVersion logic |
||| 4kvideodownloader | `maclib::4kvideodownloader::is_installed` | Return 0 if "4K Video Downloader" installed | implemented | team "GHQ37VJF83"; "dmg" |
||| 4kvideodownloader | `maclib::4kvideodownloader::installed_path` | Path to installed "4K Video Downloader" bundle | implemented | |
||| 4kvideodownloader | `maclib::4kvideodownloader::install` | Download installer and install "4K Video Downloader" | implemented | requires root |
||| 4kvideodownloader | `maclib::4kvideodownloader::update` | Update "4K Video Downloader" | implemented | no update path |
||| 4kvideodownloader | `maclib::4kvideodownloader::uninstall` | Uninstall "4K Video Downloader" | implemented | no clean uninstall |

||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::suite_installer_url` | "4K Video Downloader+" installer URL (Installomator) | implemented | team "GHQ37VJF83"; "dmg" |
||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::latest_version` | "4K Video Downloader+" current build | implemented | Installomator appNewVersion logic |
||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::is_installed` | Return 0 if "4K Video Downloader+" installed | implemented | team "GHQ37VJF83"; "dmg" |
||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::installed_path` | Path to installed "4K Video Downloader+" bundle | implemented | |
||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::install` | Download installer and install "4K Video Downloader+" | implemented | requires root |
||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::update` | Update "4K Video Downloader+" | implemented | no update path |
||| 4kvideodownloaderplus | `maclib::4kvideodownloaderplus::uninstall` | Uninstall "4K Video Downloader+" | implemented | no clean uninstall |

||| 8x8 | `maclib::8x8::suite_installer_url` | "8x8 Work" installer URL (Installomator) | implemented | team "FC967L3QRG"; "dmg" |
||| 8x8 | `maclib::8x8::latest_version` | "8x8 Work" current build | implemented | Installomator appNewVersion logic |
||| 8x8 | `maclib::8x8::is_installed` | Return 0 if "8x8 Work" installed | implemented | team "FC967L3QRG"; "dmg" |
||| 8x8 | `maclib::8x8::installed_path` | Path to installed "8x8 Work" bundle | implemented | |
||| 8x8 | `maclib::8x8::install` | Download installer and install "8x8 Work" | implemented | requires root |
||| 8x8 | `maclib::8x8::update` | Update "8x8 Work" | implemented | no update path |
||| 8x8 | `maclib::8x8::uninstall` | Uninstall "8x8 Work" | implemented | no clean uninstall |

||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::suite_installer_url` | "A Better Finder Attributes 7" installer URL (Installomator) | implemented | team "7Y9KW4ND8W"; "dmg" |
||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::latest_version` | "A Better Finder Attributes 7" current build | implemented | Installomator appNewVersion logic |
||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::is_installed` | Return 0 if "A Better Finder Attributes 7" installed | implemented | team "7Y9KW4ND8W"; "dmg" |
||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::installed_path` | Path to installed "A Better Finder Attributes 7" bundle | implemented | |
||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::install` | Download installer and install "A Better Finder Attributes 7" | implemented | requires root |
||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::update` | Update "A Better Finder Attributes 7" | implemented | no update path |
||| abetterfinderattributes7 | `maclib::abetterfinderattributes7::uninstall` | Uninstall "A Better Finder Attributes 7" | implemented | no clean uninstall |

||| abetterfinderrename11 | `maclib::abetterfinderrename11::suite_installer_url` | "A Better Finder Rename 11" installer URL (Installomator) | implemented | team "7Y9KW4ND8W"; "dmg" |
||| abetterfinderrename11 | `maclib::abetterfinderrename11::latest_version` | "A Better Finder Rename 11" current build | implemented | Installomator appNewVersion logic |
||| abetterfinderrename11 | `maclib::abetterfinderrename11::is_installed` | Return 0 if "A Better Finder Rename 11" installed | implemented | team "7Y9KW4ND8W"; "dmg" |
||| abetterfinderrename11 | `maclib::abetterfinderrename11::installed_path` | Path to installed "A Better Finder Rename 11" bundle | implemented | |
||| abetterfinderrename11 | `maclib::abetterfinderrename11::install` | Download installer and install "A Better Finder Rename 11" | implemented | requires root |
||| abetterfinderrename11 | `maclib::abetterfinderrename11::update` | Update "A Better Finder Rename 11" | implemented | no update path |
||| abetterfinderrename11 | `maclib::abetterfinderrename11::uninstall` | Uninstall "A Better Finder Rename 11" | implemented | no clean uninstall |

||| abetterfinderrename12 | `maclib::abetterfinderrename12::suite_installer_url` | "A Better Finder Rename 12" installer URL (Installomator) | implemented | team "7Y9KW4ND8W"; "dmg" |
||| abetterfinderrename12 | `maclib::abetterfinderrename12::latest_version` | "A Better Finder Rename 12" current build | implemented | Installomator appNewVersion logic |
||| abetterfinderrename12 | `maclib::abetterfinderrename12::is_installed` | Return 0 if "A Better Finder Rename 12" installed | implemented | team "7Y9KW4ND8W"; "dmg" |
||| abetterfinderrename12 | `maclib::abetterfinderrename12::installed_path` | Path to installed "A Better Finder Rename 12" bundle | implemented | |
||| abetterfinderrename12 | `maclib::abetterfinderrename12::install` | Download installer and install "A Better Finder Rename 12" | implemented | requires root |
||| abetterfinderrename12 | `maclib::abetterfinderrename12::update` | Update "A Better Finder Rename 12" | implemented | no update path |
||| abetterfinderrename12 | `maclib::abetterfinderrename12::uninstall` | Uninstall "A Better Finder Rename 12" | implemented | no clean uninstall |

||| abletonlive12intro | `maclib::abletonlive12intro::suite_installer_url` | "Ableton Live 12 Intro" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12intro | `maclib::abletonlive12intro::latest_version` | "Ableton Live 12 Intro" current build | implemented | Installomator appNewVersion logic |
||| abletonlive12intro | `maclib::abletonlive12intro::is_installed` | Return 0 if "Ableton Live 12 Intro" installed | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12intro | `maclib::abletonlive12intro::installed_path` | Path to installed "Ableton Live 12 Intro" bundle | implemented | |
||| abletonlive12intro | `maclib::abletonlive12intro::install` | Download installer and install "Ableton Live 12 Intro" | implemented | requires root |
||| abletonlive12intro | `maclib::abletonlive12intro::update` | Update "Ableton Live 12 Intro" | implemented | no update path |
||| abletonlive12intro | `maclib::abletonlive12intro::uninstall` | Uninstall "Ableton Live 12 Intro" | implemented | no clean uninstall |

||| abletonlive12lite | `maclib::abletonlive12lite::suite_installer_url` | "Ableton Live 12 Lite" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12lite | `maclib::abletonlive12lite::latest_version` | "Ableton Live 12 Lite" current build | implemented | Installomator appNewVersion logic |
||| abletonlive12lite | `maclib::abletonlive12lite::is_installed` | Return 0 if "Ableton Live 12 Lite" installed | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12lite | `maclib::abletonlive12lite::installed_path` | Path to installed "Ableton Live 12 Lite" bundle | implemented | |
||| abletonlive12lite | `maclib::abletonlive12lite::install` | Download installer and install "Ableton Live 12 Lite" | implemented | requires root |
||| abletonlive12lite | `maclib::abletonlive12lite::update` | Update "Ableton Live 12 Lite" | implemented | no update path |
||| abletonlive12lite | `maclib::abletonlive12lite::uninstall` | Uninstall "Ableton Live 12 Lite" | implemented | no clean uninstall |

||| abletonlive12standard | `maclib::abletonlive12standard::suite_installer_url` | "Ableton Live 12 Standard" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12standard | `maclib::abletonlive12standard::latest_version` | "Ableton Live 12 Standard" current build | implemented | Installomator appNewVersion logic |
||| abletonlive12standard | `maclib::abletonlive12standard::is_installed` | Return 0 if "Ableton Live 12 Standard" installed | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12standard | `maclib::abletonlive12standard::installed_path` | Path to installed "Ableton Live 12 Standard" bundle | implemented | |
||| abletonlive12standard | `maclib::abletonlive12standard::install` | Download installer and install "Ableton Live 12 Standard" | implemented | requires root |
||| abletonlive12standard | `maclib::abletonlive12standard::update` | Update "Ableton Live 12 Standard" | implemented | no update path |
||| abletonlive12standard | `maclib::abletonlive12standard::uninstall` | Uninstall "Ableton Live 12 Standard" | implemented | no clean uninstall |

||| abletonlive12suite | `maclib::abletonlive12suite::suite_installer_url` | "Ableton Live 12 Suite" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12suite | `maclib::abletonlive12suite::latest_version` | "Ableton Live 12 Suite" current build | implemented | Installomator appNewVersion logic |
||| abletonlive12suite | `maclib::abletonlive12suite::is_installed` | Return 0 if "Ableton Live 12 Suite" installed | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12suite | `maclib::abletonlive12suite::installed_path` | Path to installed "Ableton Live 12 Suite" bundle | implemented | |
||| abletonlive12suite | `maclib::abletonlive12suite::install` | Download installer and install "Ableton Live 12 Suite" | implemented | requires root |
||| abletonlive12suite | `maclib::abletonlive12suite::update` | Update "Ableton Live 12 Suite" | implemented | no update path |
||| abletonlive12suite | `maclib::abletonlive12suite::uninstall` | Uninstall "Ableton Live 12 Suite" | implemented | no clean uninstall |

||| abletonlive12trial | `maclib::abletonlive12trial::suite_installer_url` | "Ableton Live 12 Trial" installer URL (Installomator) | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12trial | `maclib::abletonlive12trial::latest_version` | "Ableton Live 12 Trial" current build | implemented | Installomator appNewVersion logic |
||| abletonlive12trial | `maclib::abletonlive12trial::is_installed` | Return 0 if "Ableton Live 12 Trial" installed | implemented | team "MWR434WD94"; "dmg" |
||| abletonlive12trial | `maclib::abletonlive12trial::installed_path` | Path to installed "Ableton Live 12 Trial" bundle | implemented | |
||| abletonlive12trial | `maclib::abletonlive12trial::install` | Download installer and install "Ableton Live 12 Trial" | implemented | requires root |
||| abletonlive12trial | `maclib::abletonlive12trial::update` | Update "Ableton Live 12 Trial" | implemented | no update path |
||| abletonlive12trial | `maclib::abletonlive12trial::uninstall` | Uninstall "Ableton Live 12 Trial" | implemented | no clean uninstall |

||| abstract | `maclib::abstract::suite_installer_url` | "Abstract" installer URL (Installomator) | implemented | team "77MZLZE47D"; "zip" |
||| abstract | `maclib::abstract::latest_version` | "Abstract" current build | implemented | Installomator appNewVersion logic |
||| abstract | `maclib::abstract::is_installed` | Return 0 if "Abstract" installed | implemented | team "77MZLZE47D"; "zip" |
||| abstract | `maclib::abstract::installed_path` | Path to installed "Abstract" bundle | implemented | |
||| abstract | `maclib::abstract::install` | Download installer and install "Abstract" | implemented | requires root |
||| abstract | `maclib::abstract::update` | Update "Abstract" | implemented | no update path |
||| abstract | `maclib::abstract::uninstall` | Uninstall "Abstract" | implemented | no clean uninstall |

||| acorn | `maclib::acorn::suite_installer_url` | "Acorn" installer URL (Installomator) | implemented | team "WZCN9HJ4VP"; "zip" |
||| acorn | `maclib::acorn::latest_version` | "Acorn" current build | implemented | Installomator appNewVersion logic |
||| acorn | `maclib::acorn::is_installed` | Return 0 if "Acorn" installed | implemented | team "WZCN9HJ4VP"; "zip" |
||| acorn | `maclib::acorn::installed_path` | Path to installed "Acorn" bundle | implemented | |
||| acorn | `maclib::acorn::install` | Download installer and install "Acorn" | implemented | requires root |
||| acorn | `maclib::acorn::update` | Update "Acorn" | implemented | no update path |
||| acorn | `maclib::acorn::uninstall` | Uninstall "Acorn" | implemented | no clean uninstall |

||| adium | `maclib::adium::suite_installer_url` | "Adium" installer URL (Installomator) | implemented | team "VQ6ZEL8UD3"; "dmg" |
||| adium | `maclib::adium::latest_version` | "Adium" current build | implemented | Installomator appNewVersion logic |
||| adium | `maclib::adium::is_installed` | Return 0 if "Adium" installed | implemented | team "VQ6ZEL8UD3"; "dmg" |
||| adium | `maclib::adium::installed_path` | Path to installed "Adium" bundle | implemented | |
||| adium | `maclib::adium::install` | Download installer and install "Adium" | implemented | requires root |
||| adium | `maclib::adium::update` | Update "Adium" | implemented | no update path |
||| adium | `maclib::adium::uninstall` | Uninstall "Adium" | implemented | no clean uninstall |

||| adobeacrobatprodc | `maclib::adobeacrobatprodc::suite_installer_url` | "Adobe Acrobat Pro DC" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "pkgInDmg" |
||| adobeacrobatprodc | `maclib::adobeacrobatprodc::latest_version` | "Adobe Acrobat Pro DC" current build | implemented | Installomator appNewVersion logic |
||| adobeacrobatprodc | `maclib::adobeacrobatprodc::is_installed` | Return 0 if "Adobe Acrobat Pro DC" installed | implemented | team "JQ525L2MZD"; "pkgInDmg" |
||| adobeacrobatprodc | `maclib::adobeacrobatprodc::installed_path` | Path to installed "Adobe Acrobat Pro DC" bundle | implemented | |
||| adobeacrobatprodc | `maclib::adobeacrobatprodc::install` | Download installer and install "Adobe Acrobat Pro DC" | implemented | requires root |
||| adobeacrobatprodc | `maclib::adobeacrobatprodc::update` | Update "Adobe Acrobat Pro DC" | implemented | no update path |
||| adobeacrobatprodc | `maclib::adobeacrobatprodc::uninstall` | Uninstall "Adobe Acrobat Pro DC" | implemented | no clean uninstall |

||| adobeconnect | `maclib::adobeconnect::suite_installer_url` | "AdobeConnectInstaller" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "dmg" |
||| adobeconnect | `maclib::adobeconnect::latest_version` | "AdobeConnectInstaller" current build | implemented | Installomator appNewVersion logic |
||| adobeconnect | `maclib::adobeconnect::is_installed` | Return 0 if "AdobeConnectInstaller" installed | implemented | team "JQ525L2MZD"; "dmg" |
||| adobeconnect | `maclib::adobeconnect::installed_path` | Path to installed "AdobeConnectInstaller" bundle | implemented | |
||| adobeconnect | `maclib::adobeconnect::install` | Download installer and install "AdobeConnectInstaller" | implemented | requires root |
||| adobeconnect | `maclib::adobeconnect::update` | Update "AdobeConnectInstaller" | implemented | no update path |
||| adobeconnect | `maclib::adobeconnect::uninstall` | Uninstall "AdobeConnectInstaller" | implemented | no clean uninstall |

||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::suite_installer_url` | "Adobe Creative Cloud" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "dmg" |
||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::latest_version` | "Adobe Creative Cloud" current build | implemented | Installomator appNewVersion logic |
||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::is_installed` | Return 0 if "Adobe Creative Cloud" installed | implemented | team "JQ525L2MZD"; "dmg" |
||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::installed_path` | Path to installed "Adobe Creative Cloud" bundle | implemented | |
||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::install` | Download installer and install "Adobe Creative Cloud" | implemented | requires root |
||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::update` | Update "Adobe Creative Cloud" | implemented | no update path |
||| adobecreativeclouddesktop | `maclib::adobecreativeclouddesktop::uninstall` | Uninstall "Adobe Creative Cloud" | implemented | no clean uninstall |

||| adobereaderdc-update | `maclib::adobereaderdc-update::suite_installer_url` | "Adobe Acrobat Reader DC" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "pkgInDmg" |
||| adobereaderdc-update | `maclib::adobereaderdc-update::latest_version` | "Adobe Acrobat Reader DC" current build | implemented | Installomator appNewVersion logic |
||| adobereaderdc-update | `maclib::adobereaderdc-update::is_installed` | Return 0 if "Adobe Acrobat Reader DC" installed | implemented | team "JQ525L2MZD"; "pkgInDmg" |
||| adobereaderdc-update | `maclib::adobereaderdc-update::installed_path` | Path to installed "Adobe Acrobat Reader DC" bundle | implemented | |
||| adobereaderdc-update | `maclib::adobereaderdc-update::install` | Download installer and install "Adobe Acrobat Reader DC" | implemented | requires root |
||| adobereaderdc-update | `maclib::adobereaderdc-update::update` | Update "Adobe Acrobat Reader DC" | implemented | no update path |
||| adobereaderdc-update | `maclib::adobereaderdc-update::uninstall` | Uninstall "Adobe Acrobat Reader DC" | implemented | no clean uninstall |

||| aftermath | `maclib::aftermath::suite_installer_url` | "Aftermath" installer URL (Installomator) | implemented | team "483DWKW443"; "pkg" |
||| aftermath | `maclib::aftermath::latest_version` | "Aftermath" current build | implemented | Installomator appNewVersion logic |
||| aftermath | `maclib::aftermath::is_installed` | Return 0 if "Aftermath" installed | implemented | team "483DWKW443"; "pkg" |
||| aftermath | `maclib::aftermath::installed_path` | Path to installed "Aftermath" bundle | implemented | |
||| aftermath | `maclib::aftermath::install` | Download installer and install "Aftermath" | implemented | requires root |
||| aftermath | `maclib::aftermath::update` | Update "Aftermath" | implemented | no update path |
||| aftermath | `maclib::aftermath::uninstall` | Uninstall "Aftermath" | implemented | no clean uninstall |

||| airflow | `maclib::airflow::suite_installer_url` | "Air" installer URL (Installomator) | implemented | team "8RBYE8TY7T"; "dmg" |
||| airflow | `maclib::airflow::latest_version` | "Air" current build | implemented | Installomator appNewVersion logic |
||| airflow | `maclib::airflow::is_installed` | Return 0 if "Air" installed | implemented | team "8RBYE8TY7T"; "dmg" |
||| airflow | `maclib::airflow::installed_path` | Path to installed "Air" bundle | implemented | |
||| airflow | `maclib::airflow::install` | Download installer and install "Air" | implemented | requires root |
||| airflow | `maclib::airflow::update` | Update "Air" | implemented | no update path |
||| airflow | `maclib::airflow::uninstall` | Uninstall "Air" | implemented | no clean uninstall |

||| airserver | `maclib::airserver::suite_installer_url` | "AirServer" installer URL (Installomator) | implemented | team "6C755KS5W3"; "dmg" |
||| airserver | `maclib::airserver::latest_version` | "AirServer" current build | implemented | Installomator appNewVersion logic |
||| airserver | `maclib::airserver::is_installed` | Return 0 if "AirServer" installed | implemented | team "6C755KS5W3"; "dmg" |
||| airserver | `maclib::airserver::installed_path` | Path to installed "AirServer" bundle | implemented | |
||| airserver | `maclib::airserver::install` | Download installer and install "AirServer" | implemented | requires root |
||| airserver | `maclib::airserver::update` | Update "AirServer" | implemented | no update path |
||| airserver | `maclib::airserver::uninstall` | Uninstall "AirServer" | implemented | no clean uninstall |

||| aldente | `maclib::aldente::suite_installer_url` | "AlDente" installer URL (Installomator) | implemented | team "3WVC84GB99"; "dmg" |
||| aldente | `maclib::aldente::latest_version` | "AlDente" current build | implemented | Installomator appNewVersion logic |
||| aldente | `maclib::aldente::is_installed` | Return 0 if "AlDente" installed | implemented | team "3WVC84GB99"; "dmg" |
||| aldente | `maclib::aldente::installed_path` | Path to installed "AlDente" bundle | implemented | |
||| aldente | `maclib::aldente::install` | Download installer and install "AlDente" | implemented | requires root |
||| aldente | `maclib::aldente::update` | Update "AlDente" | implemented | no update path |
||| aldente | `maclib::aldente::uninstall` | Uninstall "AlDente" | implemented | no clean uninstall |

||| alephone | `maclib::alephone::suite_installer_url` | "Aleph One" installer URL (Installomator) | implemented | team "E8K89CXZE7"; "dmg" |
||| alephone | `maclib::alephone::latest_version` | "Aleph One" current build | implemented | Installomator appNewVersion logic |
||| alephone | `maclib::alephone::is_installed` | Return 0 if "Aleph One" installed | implemented | team "E8K89CXZE7"; "dmg" |
||| alephone | `maclib::alephone::installed_path` | Path to installed "Aleph One" bundle | implemented | |
||| alephone | `maclib::alephone::install` | Download installer and install "Aleph One" | implemented | requires root |
||| alephone | `maclib::alephone::update` | Update "Aleph One" | implemented | no update path |
||| alephone | `maclib::alephone::uninstall` | Uninstall "Aleph One" | implemented | no clean uninstall |

||| alfred | `maclib::alfred::suite_installer_url` | "Alfred" installer URL (Installomator) | implemented | team "XZZXE9SED4"; "dmg" |
||| alfred | `maclib::alfred::latest_version` | "Alfred" current build | implemented | Installomator appNewVersion logic |
||| alfred | `maclib::alfred::is_installed` | Return 0 if "Alfred" installed | implemented | team "XZZXE9SED4"; "dmg" |
||| alfred | `maclib::alfred::installed_path` | Path to installed "Alfred" bundle | implemented | |
||| alfred | `maclib::alfred::install` | Download installer and install "Alfred" | implemented | requires root |
||| alfred | `maclib::alfred::update` | Update "Alfred" | implemented | no update path |
||| alfred | `maclib::alfred::uninstall` | Uninstall "Alfred" | implemented | no clean uninstall |

||| altserver | `maclib::altserver::suite_installer_url` | "AltServer" installer URL (Installomator) | implemented | team "6XVY5G3U44"; "zip" |
||| altserver | `maclib::altserver::latest_version` | "AltServer" current build | implemented | Installomator appNewVersion logic |
||| altserver | `maclib::altserver::is_installed` | Return 0 if "AltServer" installed | implemented | team "6XVY5G3U44"; "zip" |
||| altserver | `maclib::altserver::installed_path` | Path to installed "AltServer" bundle | implemented | |
||| altserver | `maclib::altserver::install` | Download installer and install "AltServer" | implemented | requires root |
||| altserver | `maclib::altserver::update` | Update "AltServer" | implemented | no update path |
||| altserver | `maclib::altserver::uninstall` | Uninstall "AltServer" | implemented | no clean uninstall |

||| alttab | `maclib::alttab::suite_installer_url` | "AltTab" installer URL (Installomator) | implemented | team "QXD7GW8FHY"; "zip" |
||| alttab | `maclib::alttab::latest_version` | "AltTab" current build | implemented | Installomator appNewVersion logic |
||| alttab | `maclib::alttab::is_installed` | Return 0 if "AltTab" installed | implemented | team "QXD7GW8FHY"; "zip" |
||| alttab | `maclib::alttab::installed_path` | Path to installed "AltTab" bundle | implemented | |
||| alttab | `maclib::alttab::install` | Download installer and install "AltTab" | implemented | requires root |
||| alttab | `maclib::alttab::update` | Update "AltTab" | implemented | no update path |
||| alttab | `maclib::alttab::uninstall` | Uninstall "AltTab" | implemented | no clean uninstall |

||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::suite_installer_url` | "Amazon Corretto 11 JDK" installer URL (Installomator) | implemented | "pkg" |
||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::latest_version` | "Amazon Corretto 11 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::is_installed` | Return 0 if "Amazon Corretto 11 JDK" installed | implemented | "pkg" |
||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::installed_path` | Path to installed "Amazon Corretto 11 JDK" bundle | implemented | |
||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::install` | Download installer and install "Amazon Corretto 11 JDK" | implemented | requires root |
||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::update` | Update "Amazon Corretto 11 JDK" | implemented | no update path |
||| amazoncorretto11jdk | `maclib::amazoncorretto11jdk::uninstall` | Uninstall "Amazon Corretto 11 JDK" | implemented | no clean uninstall |

||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::suite_installer_url` | "Amazon Corretto 17 JDK" installer URL (Installomator) | implemented | "pkg" |
||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::latest_version` | "Amazon Corretto 17 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::is_installed` | Return 0 if "Amazon Corretto 17 JDK" installed | implemented | "pkg" |
||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::installed_path` | Path to installed "Amazon Corretto 17 JDK" bundle | implemented | |
||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::install` | Download installer and install "Amazon Corretto 17 JDK" | implemented | requires root |
||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::update` | Update "Amazon Corretto 17 JDK" | implemented | no update path |
||| amazoncorretto17jdk | `maclib::amazoncorretto17jdk::uninstall` | Uninstall "Amazon Corretto 17 JDK" | implemented | no clean uninstall |

||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::suite_installer_url` | "Amazon Corretto 21 JDK" installer URL (Installomator) | implemented | "pkg" |
||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::latest_version` | "Amazon Corretto 21 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::is_installed` | Return 0 if "Amazon Corretto 21 JDK" installed | implemented | "pkg" |
||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::installed_path` | Path to installed "Amazon Corretto 21 JDK" bundle | implemented | |
||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::install` | Download installer and install "Amazon Corretto 21 JDK" | implemented | requires root |
||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::update` | Update "Amazon Corretto 21 JDK" | implemented | no update path |
||| amazoncorretto21jdk | `maclib::amazoncorretto21jdk::uninstall` | Uninstall "Amazon Corretto 21 JDK" | implemented | no clean uninstall |

||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::suite_installer_url` | "Amazon Corretto 22 JDK" installer URL (Installomator) | implemented | "pkg" |
||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::latest_version` | "Amazon Corretto 22 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::is_installed` | Return 0 if "Amazon Corretto 22 JDK" installed | implemented | "pkg" |
||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::installed_path` | Path to installed "Amazon Corretto 22 JDK" bundle | implemented | |
||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::install` | Download installer and install "Amazon Corretto 22 JDK" | implemented | requires root |
||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::update` | Update "Amazon Corretto 22 JDK" | implemented | no update path |
||| amazoncorretto22jdk | `maclib::amazoncorretto22jdk::uninstall` | Uninstall "Amazon Corretto 22 JDK" | implemented | no clean uninstall |

||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::suite_installer_url` | "Amazon Corretto 23 JDK" installer URL (Installomator) | implemented | "pkg" |
||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::latest_version` | "Amazon Corretto 23 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::is_installed` | Return 0 if "Amazon Corretto 23 JDK" installed | implemented | "pkg" |
||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::installed_path` | Path to installed "Amazon Corretto 23 JDK" bundle | implemented | |
||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::install` | Download installer and install "Amazon Corretto 23 JDK" | implemented | requires root |
||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::update` | Update "Amazon Corretto 23 JDK" | implemented | no update path |
||| amazoncorretto23jdk | `maclib::amazoncorretto23jdk::uninstall` | Uninstall "Amazon Corretto 23 JDK" | implemented | no clean uninstall |

||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::suite_installer_url` | "Amazon Corretto 25 JDK" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" |
||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::latest_version` | "Amazon Corretto 25 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::is_installed` | Return 0 if "Amazon Corretto 25 JDK" installed | implemented | team "94KV3E626L"; "pkg" |
||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::installed_path` | Path to installed "Amazon Corretto 25 JDK" bundle | implemented | |
||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::install` | Download installer and install "Amazon Corretto 25 JDK" | implemented | requires root |
||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::update` | Update "Amazon Corretto 25 JDK" | implemented | no update path |
||| amazoncorretto25jdk | `maclib::amazoncorretto25jdk::uninstall` | Uninstall "Amazon Corretto 25 JDK" | implemented | no clean uninstall |

||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::suite_installer_url` | "Amazon Corretto 8 JDK" installer URL (Installomator) | implemented | "pkg" |
||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::latest_version` | "Amazon Corretto 8 JDK" current build | implemented | Installomator appNewVersion logic |
||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::is_installed` | Return 0 if "Amazon Corretto 8 JDK" installed | implemented | "pkg" |
||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::installed_path` | Path to installed "Amazon Corretto 8 JDK" bundle | implemented | |
||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::install` | Download installer and install "Amazon Corretto 8 JDK" | implemented | requires root |
||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::update` | Update "Amazon Corretto 8 JDK" | implemented | no update path |
||| amazoncorretto8jdk | `maclib::amazoncorretto8jdk::uninstall` | Uninstall "Amazon Corretto 8 JDK" | implemented | no clean uninstall |

||| amazonq | `maclib::amazonq::suite_installer_url` | "Amazon Q" installer URL (Installomator) | implemented | team "94KV3E626L"; "dmg" |
||| amazonq | `maclib::amazonq::latest_version` | "Amazon Q" current build | implemented | Installomator appNewVersion logic |
||| amazonq | `maclib::amazonq::is_installed` | Return 0 if "Amazon Q" installed | implemented | team "94KV3E626L"; "dmg" |
||| amazonq | `maclib::amazonq::installed_path` | Path to installed "Amazon Q" bundle | implemented | |
||| amazonq | `maclib::amazonq::install` | Download installer and install "Amazon Q" | implemented | requires root |
||| amazonq | `maclib::amazonq::update` | Update "Amazon Q" | implemented | no update path |
||| amazonq | `maclib::amazonq::uninstall` | Uninstall "Amazon Q" | implemented | no clean uninstall |

||| amazonworkspaces | `maclib::amazonworkspaces::suite_installer_url` | "Workspaces" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" |
||| amazonworkspaces | `maclib::amazonworkspaces::latest_version` | "Workspaces" current build | implemented | Installomator appNewVersion logic |
||| amazonworkspaces | `maclib::amazonworkspaces::is_installed` | Return 0 if "Workspaces" installed | implemented | team "94KV3E626L"; "pkg" |
||| amazonworkspaces | `maclib::amazonworkspaces::installed_path` | Path to installed "Workspaces" bundle | implemented | |
||| amazonworkspaces | `maclib::amazonworkspaces::install` | Download installer and install "Workspaces" | implemented | requires root |
||| amazonworkspaces | `maclib::amazonworkspaces::update` | Update "Workspaces" | implemented | no update path |
||| amazonworkspaces | `maclib::amazonworkspaces::uninstall` | Uninstall "Workspaces" | implemented | no clean uninstall |

||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::suite_installer_url` | "ExtensionManager" installer URL (Installomator) | implemented | team "D3SBBNFWTC"; "zip" |
||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::latest_version` | "ExtensionManager" current build | implemented | Installomator appNewVersion logic |
||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::is_installed` | Return 0 if "ExtensionManager" installed | implemented | team "D3SBBNFWTC"; "zip" |
||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::installed_path` | Path to installed "ExtensionManager" bundle | implemented | |
||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::install` | Download installer and install "ExtensionManager" | implemented | requires root |
||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::update` | Update "ExtensionManager" | implemented | no update path |
||| anastasiysextensionmanager | `maclib::anastasiysextensionmanager::uninstall` | Uninstall "ExtensionManager" | implemented | no clean uninstall |

||| androidfiletransfer | `maclib::androidfiletransfer::suite_installer_url` | "Android File Transfer" installer URL (Installomator) | implemented | team "EQHXZ8M8AV"; "dmg" |
||| androidfiletransfer | `maclib::androidfiletransfer::latest_version` | "Android File Transfer" current build | implemented | Installomator appNewVersion logic |
||| androidfiletransfer | `maclib::androidfiletransfer::is_installed` | Return 0 if "Android File Transfer" installed | implemented | team "EQHXZ8M8AV"; "dmg" |
||| androidfiletransfer | `maclib::androidfiletransfer::installed_path` | Path to installed "Android File Transfer" bundle | implemented | |
||| androidfiletransfer | `maclib::androidfiletransfer::install` | Download installer and install "Android File Transfer" | implemented | requires root |
||| androidfiletransfer | `maclib::androidfiletransfer::update` | Update "Android File Transfer" | implemented | no update path |
||| androidfiletransfer | `maclib::androidfiletransfer::uninstall` | Uninstall "Android File Transfer" | implemented | no clean uninstall |

||| anki | `maclib::anki::suite_installer_url` | "Anki" installer URL (Installomator) | implemented | team "7ZM8SLJM4P"; "dmg" |
||| anki | `maclib::anki::latest_version` | "Anki" current build | implemented | Installomator appNewVersion logic |
||| anki | `maclib::anki::is_installed` | Return 0 if "Anki" installed | implemented | team "7ZM8SLJM4P"; "dmg" |
||| anki | `maclib::anki::installed_path` | Path to installed "Anki" bundle | implemented | |
||| anki | `maclib::anki::install` | Download installer and install "Anki" | implemented | requires root |
||| anki | `maclib::anki::update` | Update "Anki" | implemented | no update path |
||| anki | `maclib::anki::uninstall` | Uninstall "Anki" | implemented | no clean uninstall |

||| antconc | `maclib::antconc::suite_installer_url` | "AntConc" installer URL (Installomator) | implemented | team "28C42U4N5U"; "dmg" |
||| antconc | `maclib::antconc::latest_version` | "AntConc" current build | implemented | Installomator appNewVersion logic |
||| antconc | `maclib::antconc::is_installed` | Return 0 if "AntConc" installed | implemented | team "28C42U4N5U"; "dmg" |
||| antconc | `maclib::antconc::installed_path` | Path to installed "AntConc" bundle | implemented | |
||| antconc | `maclib::antconc::install` | Download installer and install "AntConc" | implemented | requires root |
||| antconc | `maclib::antconc::update` | Update "AntConc" | implemented | no update path |
||| antconc | `maclib::antconc::uninstall` | Uninstall "AntConc" | implemented | no clean uninstall |

||| apachedirectorystudio | `maclib::apachedirectorystudio::suite_installer_url` | "ApacheDirectoryStudio" installer URL (Installomator) | implemented | team "2GLGAFWEQD"; "dmg" |
||| apachedirectorystudio | `maclib::apachedirectorystudio::latest_version` | "ApacheDirectoryStudio" current build | implemented | Installomator appNewVersion logic |
||| apachedirectorystudio | `maclib::apachedirectorystudio::is_installed` | Return 0 if "ApacheDirectoryStudio" installed | implemented | team "2GLGAFWEQD"; "dmg" |
||| apachedirectorystudio | `maclib::apachedirectorystudio::installed_path` | Path to installed "ApacheDirectoryStudio" bundle | implemented | |
||| apachedirectorystudio | `maclib::apachedirectorystudio::install` | Download installer and install "ApacheDirectoryStudio" | implemented | requires root |
||| apachedirectorystudio | `maclib::apachedirectorystudio::update` | Update "ApacheDirectoryStudio" | implemented | no update path |
||| apachedirectorystudio | `maclib::apachedirectorystudio::uninstall` | Uninstall "ApacheDirectoryStudio" | implemented | no clean uninstall |

||| ape | `maclib::ape::suite_installer_url` | "ApE" installer URL (Installomator) | implemented | team "F5459JB4SG"; "dmg" |
||| ape | `maclib::ape::latest_version` | "ApE" current build | implemented | Installomator appNewVersion logic |
||| ape | `maclib::ape::is_installed` | Return 0 if "ApE" installed | implemented | team "F5459JB4SG"; "dmg" |
||| ape | `maclib::ape::installed_path` | Path to installed "ApE" bundle | implemented | |
||| ape | `maclib::ape::install` | Download installer and install "ApE" | implemented | requires root |
||| ape | `maclib::ape::update` | Update "ApE" | implemented | no update path |
||| ape | `maclib::ape::uninstall` | Uninstall "ApE" | implemented | no clean uninstall |

||| apparency | `maclib::apparency::suite_installer_url` | "Apparency" installer URL (Installomator) | implemented | team "936EB786NH"; "dmg" |
||| apparency | `maclib::apparency::latest_version` | "Apparency" current build | implemented | Installomator appNewVersion logic |
||| apparency | `maclib::apparency::is_installed` | Return 0 if "Apparency" installed | implemented | team "936EB786NH"; "dmg" |
||| apparency | `maclib::apparency::installed_path` | Path to installed "Apparency" bundle | implemented | |
||| apparency | `maclib::apparency::install` | Download installer and install "Apparency" | implemented | requires root |
||| apparency | `maclib::apparency::update` | Update "Apparency" | implemented | no update path |
||| apparency | `maclib::apparency::uninstall` | Uninstall "Apparency" | implemented | no clean uninstall |

||| appcleaner | `maclib::appcleaner::suite_installer_url` | "AppCleaner" installer URL (Installomator) | implemented | team "X85ZX835W9"; "zip" |
||| appcleaner | `maclib::appcleaner::latest_version` | "AppCleaner" current build | implemented | Installomator appNewVersion logic |
||| appcleaner | `maclib::appcleaner::is_installed` | Return 0 if "AppCleaner" installed | implemented | team "X85ZX835W9"; "zip" |
||| appcleaner | `maclib::appcleaner::installed_path` | Path to installed "AppCleaner" bundle | implemented | |
||| appcleaner | `maclib::appcleaner::install` | Download installer and install "AppCleaner" | implemented | requires root |
||| appcleaner | `maclib::appcleaner::update` | Update "AppCleaner" | implemented | no update path |
||| appcleaner | `maclib::appcleaner::uninstall` | Uninstall "AppCleaner" | implemented | no clean uninstall |

||| applenyfonts | `maclib::applenyfonts::suite_installer_url` | "Apple New York Font Collection" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" |
||| applenyfonts | `maclib::applenyfonts::latest_version` | "Apple New York Font Collection" current build | implemented | Installomator appNewVersion logic |
||| applenyfonts | `maclib::applenyfonts::is_installed` | Return 0 if "Apple New York Font Collection" installed | implemented | team "Software Update"; "pkgInDmg" |
||| applenyfonts | `maclib::applenyfonts::installed_path` | Path to installed "Apple New York Font Collection" bundle | implemented | |
||| applenyfonts | `maclib::applenyfonts::install` | Download installer and install "Apple New York Font Collection" | implemented | requires root |
||| applenyfonts | `maclib::applenyfonts::update` | Update "Apple New York Font Collection" | implemented | no update path |
||| applenyfonts | `maclib::applenyfonts::uninstall` | Uninstall "Apple New York Font Collection" | implemented | no clean uninstall |

||| appleprovideoformats | `maclib::appleprovideoformats::suite_installer_url` | "ProVideoFormats" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" |
||| appleprovideoformats | `maclib::appleprovideoformats::latest_version` | "ProVideoFormats" current build | implemented | Installomator appNewVersion logic |
||| appleprovideoformats | `maclib::appleprovideoformats::is_installed` | Return 0 if "ProVideoFormats" installed | implemented | team "Software Update"; "pkgInDmg" |
||| appleprovideoformats | `maclib::appleprovideoformats::installed_path` | Path to installed "ProVideoFormats" bundle | implemented | |
||| appleprovideoformats | `maclib::appleprovideoformats::install` | Download installer and install "ProVideoFormats" | implemented | requires root |
||| appleprovideoformats | `maclib::appleprovideoformats::update` | Update "ProVideoFormats" | implemented | no update path |
||| appleprovideoformats | `maclib::appleprovideoformats::uninstall` | Uninstall "ProVideoFormats" | implemented | no clean uninstall |

||| applesfarabic | `maclib::applesfarabic::suite_installer_url` | "San Francisco Arabic" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" |
||| applesfarabic | `maclib::applesfarabic::latest_version` | "San Francisco Arabic" current build | implemented | Installomator appNewVersion logic |
||| applesfarabic | `maclib::applesfarabic::is_installed` | Return 0 if "San Francisco Arabic" installed | implemented | team "Software Update"; "pkgInDmg" |
||| applesfarabic | `maclib::applesfarabic::installed_path` | Path to installed "San Francisco Arabic" bundle | implemented | |
||| applesfarabic | `maclib::applesfarabic::install` | Download installer and install "San Francisco Arabic" | implemented | requires root |
||| applesfarabic | `maclib::applesfarabic::update` | Update "San Francisco Arabic" | implemented | no update path |
||| applesfarabic | `maclib::applesfarabic::uninstall` | Uninstall "San Francisco Arabic" | implemented | no clean uninstall |

||| applesfcompact | `maclib::applesfcompact::suite_installer_url` | "San Francisco Compact" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" |
||| applesfcompact | `maclib::applesfcompact::latest_version` | "San Francisco Compact" current build | implemented | Installomator appNewVersion logic |
||| applesfcompact | `maclib::applesfcompact::is_installed` | Return 0 if "San Francisco Compact" installed | implemented | team "Software Update"; "pkgInDmg" |
||| applesfcompact | `maclib::applesfcompact::installed_path` | Path to installed "San Francisco Compact" bundle | implemented | |
||| applesfcompact | `maclib::applesfcompact::install` | Download installer and install "San Francisco Compact" | implemented | requires root |
||| applesfcompact | `maclib::applesfcompact::update` | Update "San Francisco Compact" | implemented | no update path |
||| applesfcompact | `maclib::applesfcompact::uninstall` | Uninstall "San Francisco Compact" | implemented | no clean uninstall |

||| applesfmono | `maclib::applesfmono::suite_installer_url` | "San Francisco Mono" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" |
||| applesfmono | `maclib::applesfmono::latest_version` | "San Francisco Mono" current build | implemented | Installomator appNewVersion logic |
||| applesfmono | `maclib::applesfmono::is_installed` | Return 0 if "San Francisco Mono" installed | implemented | team "Software Update"; "pkgInDmg" |
||| applesfmono | `maclib::applesfmono::installed_path` | Path to installed "San Francisco Mono" bundle | implemented | |
||| applesfmono | `maclib::applesfmono::install` | Download installer and install "San Francisco Mono" | implemented | requires root |
||| applesfmono | `maclib::applesfmono::update` | Update "San Francisco Mono" | implemented | no update path |
||| applesfmono | `maclib::applesfmono::uninstall` | Uninstall "San Francisco Mono" | implemented | no clean uninstall |

||| applesfpro | `maclib::applesfpro::suite_installer_url` | "San Francisco Pro" installer URL (Installomator) | implemented | team "Software Update"; "pkgInDmg" |
||| applesfpro | `maclib::applesfpro::latest_version` | "San Francisco Pro" current build | implemented | Installomator appNewVersion logic |
||| applesfpro | `maclib::applesfpro::is_installed` | Return 0 if "San Francisco Pro" installed | implemented | team "Software Update"; "pkgInDmg" |
||| applesfpro | `maclib::applesfpro::installed_path` | Path to installed "San Francisco Pro" bundle | implemented | |
||| applesfpro | `maclib::applesfpro::install` | Download installer and install "San Francisco Pro" | implemented | requires root |
||| applesfpro | `maclib::applesfpro::update` | Update "San Francisco Pro" | implemented | no update path |
||| applesfpro | `maclib::applesfpro::uninstall` | Uninstall "San Francisco Pro" | implemented | no clean uninstall |

||| appsanywhere | `maclib::appsanywhere::suite_installer_url` | "AppsAnywhere Client (macOS)" installer URL (Installomator) | implemented | team "9ZNX23CMVD"; "pkg" |
||| appsanywhere | `maclib::appsanywhere::latest_version` | "AppsAnywhere Client (macOS)" current build | implemented | Installomator appNewVersion logic |
||| appsanywhere | `maclib::appsanywhere::is_installed` | Return 0 if "AppsAnywhere Client (macOS)" installed | implemented | team "9ZNX23CMVD"; "pkg" |
||| appsanywhere | `maclib::appsanywhere::installed_path` | Path to installed "AppsAnywhere Client (macOS)" bundle | implemented | |
||| appsanywhere | `maclib::appsanywhere::install` | Download installer and install "AppsAnywhere Client (macOS)" | implemented | requires root |
||| appsanywhere | `maclib::appsanywhere::update` | Update "AppsAnywhere Client (macOS)" | implemented | no update path |
||| appsanywhere | `maclib::appsanywhere::uninstall` | Uninstall "AppsAnywhere Client (macOS)" | implemented | no clean uninstall |

||| aquamacs | `maclib::aquamacs::suite_installer_url` | "Aquamacs" installer URL (Installomator) | implemented | team "DTBC5BX3L9"; "dmg" |
||| aquamacs | `maclib::aquamacs::latest_version` | "Aquamacs" current build | implemented | Installomator appNewVersion logic |
||| aquamacs | `maclib::aquamacs::is_installed` | Return 0 if "Aquamacs" installed | implemented | team "DTBC5BX3L9"; "dmg" |
||| aquamacs | `maclib::aquamacs::installed_path` | Path to installed "Aquamacs" bundle | implemented | |
||| aquamacs | `maclib::aquamacs::install` | Download installer and install "Aquamacs" | implemented | requires root |
||| aquamacs | `maclib::aquamacs::update` | Update "Aquamacs" | implemented | no update path |
||| aquamacs | `maclib::aquamacs::uninstall` | Uninstall "Aquamacs" | implemented | no clean uninstall |

||| aquaskk | `maclib::aquaskk::suite_installer_url` | "aquaskk" installer URL (Installomator) | implemented | team "FPZK4WRGW7"; "pkg" |
||| aquaskk | `maclib::aquaskk::latest_version` | "aquaskk" current build | implemented | Installomator appNewVersion logic |
||| aquaskk | `maclib::aquaskk::is_installed` | Return 0 if "aquaskk" installed | implemented | team "FPZK4WRGW7"; "pkg" |
||| aquaskk | `maclib::aquaskk::installed_path` | Path to installed "aquaskk" bundle | implemented | |
||| aquaskk | `maclib::aquaskk::install` | Download installer and install "aquaskk" | implemented | requires root |
||| aquaskk | `maclib::aquaskk::update` | Update "aquaskk" | implemented | no update path |
||| aquaskk | `maclib::aquaskk::uninstall` | Uninstall "aquaskk" | implemented | no clean uninstall |

||| arcbrowser | `maclib::arcbrowser::suite_installer_url` | "Arc" installer URL (Installomator) | implemented | team "S6N382Y83G"; "dmg" |
||| arcbrowser | `maclib::arcbrowser::latest_version` | "Arc" current build | implemented | Installomator appNewVersion logic |
||| arcbrowser | `maclib::arcbrowser::is_installed` | Return 0 if "Arc" installed | implemented | team "S6N382Y83G"; "dmg" |
||| arcbrowser | `maclib::arcbrowser::installed_path` | Path to installed "Arc" bundle | implemented | |
||| arcbrowser | `maclib::arcbrowser::install` | Download installer and install "Arc" | implemented | requires root |
||| arcbrowser | `maclib::arcbrowser::update` | Update "Arc" | implemented | no update path |
||| arcbrowser | `maclib::arcbrowser::uninstall` | Uninstall "Arc" | implemented | no clean uninstall |

||| archaeology | `maclib::archaeology::suite_installer_url` | "Archaeology" installer URL (Installomator) | implemented | team "936EB786NH"; "dmg" |
||| archaeology | `maclib::archaeology::latest_version` | "Archaeology" current build | implemented | Installomator appNewVersion logic |
||| archaeology | `maclib::archaeology::is_installed` | Return 0 if "Archaeology" installed | implemented | team "936EB786NH"; "dmg" |
||| archaeology | `maclib::archaeology::installed_path` | Path to installed "Archaeology" bundle | implemented | |
||| archaeology | `maclib::archaeology::install` | Download installer and install "Archaeology" | implemented | requires root |
||| archaeology | `maclib::archaeology::update` | Update "Archaeology" | implemented | no update path |
||| archaeology | `maclib::archaeology::uninstall` | Uninstall "Archaeology" | implemented | no clean uninstall |

||| archimate | `maclib::archimate::suite_installer_url` | "Archi" installer URL (Installomator) | implemented | team "375WT5T296"; "dmg" |
||| archimate | `maclib::archimate::latest_version` | "Archi" current build | implemented | Installomator appNewVersion logic |
||| archimate | `maclib::archimate::is_installed` | Return 0 if "Archi" installed | implemented | team "375WT5T296"; "dmg" |
||| archimate | `maclib::archimate::installed_path` | Path to installed "Archi" bundle | implemented | |
||| archimate | `maclib::archimate::install` | Download installer and install "Archi" | implemented | requires root |
||| archimate | `maclib::archimate::update` | Update "Archi" | implemented | no update path |
||| archimate | `maclib::archimate::uninstall` | Uninstall "Archi" | implemented | no clean uninstall |

||| archiwareb2go | `maclib::archiwareb2go::suite_installer_url` | "P5 Workstation" installer URL (Installomator) | implemented | team "5H5EU6F965"; "pkgInDmg" |
||| archiwareb2go | `maclib::archiwareb2go::latest_version` | "P5 Workstation" current build | implemented | Installomator appNewVersion logic |
||| archiwareb2go | `maclib::archiwareb2go::is_installed` | Return 0 if "P5 Workstation" installed | implemented | team "5H5EU6F965"; "pkgInDmg" |
||| archiwareb2go | `maclib::archiwareb2go::installed_path` | Path to installed "P5 Workstation" bundle | implemented | |
||| archiwareb2go | `maclib::archiwareb2go::install` | Download installer and install "P5 Workstation" | implemented | requires root |
||| archiwareb2go | `maclib::archiwareb2go::update` | Update "P5 Workstation" | implemented | no update path |
||| archiwareb2go | `maclib::archiwareb2go::uninstall` | Uninstall "P5 Workstation" | implemented | no clean uninstall |

||| archiwarepst | `maclib::archiwarepst::suite_installer_url` | "P5" installer URL (Installomator) | implemented | team "5H5EU6F965"; "pkgInDmg" |
||| archiwarepst | `maclib::archiwarepst::latest_version` | "P5" current build | implemented | Installomator appNewVersion logic |
||| archiwarepst | `maclib::archiwarepst::is_installed` | Return 0 if "P5" installed | implemented | team "5H5EU6F965"; "pkgInDmg" |
||| archiwarepst | `maclib::archiwarepst::installed_path` | Path to installed "P5" bundle | implemented | |
||| archiwarepst | `maclib::archiwarepst::install` | Download installer and install "P5" | implemented | requires root |
||| archiwarepst | `maclib::archiwarepst::update` | Update "P5" | implemented | no update path |
||| archiwarepst | `maclib::archiwarepst::uninstall` | Uninstall "P5" | implemented | no clean uninstall |

||| arduinoide | `maclib::arduinoide::suite_installer_url` | "Arduino IDE" installer URL (Installomator) | implemented | team "7KT7ZWMCJT"; "dmg" |
||| arduinoide | `maclib::arduinoide::latest_version` | "Arduino IDE" current build | implemented | Installomator appNewVersion logic |
||| arduinoide | `maclib::arduinoide::is_installed` | Return 0 if "Arduino IDE" installed | implemented | team "7KT7ZWMCJT"; "dmg" |
||| arduinoide | `maclib::arduinoide::installed_path` | Path to installed "Arduino IDE" bundle | implemented | |
||| arduinoide | `maclib::arduinoide::install` | Download installer and install "Arduino IDE" | implemented | requires root |
||| arduinoide | `maclib::arduinoide::update` | Update "Arduino IDE" | implemented | no update path |
||| arduinoide | `maclib::arduinoide::uninstall` | Uninstall "Arduino IDE" | implemented | no clean uninstall |

||| arq7 | `maclib::arq7::suite_installer_url` | "Arq7" installer URL (Installomator) | implemented | team "48ZCSDVL96"; "pkg" |
||| arq7 | `maclib::arq7::latest_version` | "Arq7" current build | implemented | Installomator appNewVersion logic |
||| arq7 | `maclib::arq7::is_installed` | Return 0 if "Arq7" installed | implemented | team "48ZCSDVL96"; "pkg" |
||| arq7 | `maclib::arq7::installed_path` | Path to installed "Arq7" bundle | implemented | |
||| arq7 | `maclib::arq7::install` | Download installer and install "Arq7" | implemented | requires root |
||| arq7 | `maclib::arq7::update` | Update "Arq7" | implemented | no update path |
||| arq7 | `maclib::arq7::uninstall` | Uninstall "Arq7" | implemented | no clean uninstall |

||| arturiamcc | `maclib::arturiamcc::suite_installer_url` | "MIDI Control Center" installer URL (Installomator) | implemented | team "T53ZHSF36C"; "pkg" |
||| arturiamcc | `maclib::arturiamcc::latest_version` | "MIDI Control Center" current build | implemented | Installomator appNewVersion logic |
||| arturiamcc | `maclib::arturiamcc::is_installed` | Return 0 if "MIDI Control Center" installed | implemented | team "T53ZHSF36C"; "pkg" |
||| arturiamcc | `maclib::arturiamcc::installed_path` | Path to installed "MIDI Control Center" bundle | implemented | |
||| arturiamcc | `maclib::arturiamcc::install` | Download installer and install "MIDI Control Center" | implemented | requires root |
||| arturiamcc | `maclib::arturiamcc::update` | Update "MIDI Control Center" | implemented | no update path |
||| arturiamcc | `maclib::arturiamcc::uninstall` | Uninstall "MIDI Control Center" | implemented | no clean uninstall |

||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::suite_installer_url` | "Arturia Software Center" installer URL (Installomator) | implemented | team "T53ZHSF36C"; "pkg" |
||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::latest_version` | "Arturia Software Center" current build | implemented | Installomator appNewVersion logic |
||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::is_installed` | Return 0 if "Arturia Software Center" installed | implemented | team "T53ZHSF36C"; "pkg" |
||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::installed_path` | Path to installed "Arturia Software Center" bundle | implemented | |
||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::install` | Download installer and install "Arturia Software Center" | implemented | requires root |
||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::update` | Update "Arturia Software Center" | implemented | no update path |
||| arturiasoftwarecenter | `maclib::arturiasoftwarecenter::uninstall` | Uninstall "Arturia Software Center" | implemented | no clean uninstall |

||| asana | `maclib::asana::suite_installer_url` | "Asana" installer URL (Installomator) | implemented | team "A679L395M8"; "dmg" |
||| asana | `maclib::asana::latest_version` | "Asana" current build | implemented | Installomator appNewVersion logic |
||| asana | `maclib::asana::is_installed` | Return 0 if "Asana" installed | implemented | team "A679L395M8"; "dmg" |
||| asana | `maclib::asana::installed_path` | Path to installed "Asana" bundle | implemented | |
||| asana | `maclib::asana::install` | Download installer and install "Asana" | implemented | requires root |
||| asana | `maclib::asana::update` | Update "Asana" | implemented | no update path |
||| asana | `maclib::asana::uninstall` | Uninstall "Asana" | implemented | no clean uninstall |

||| asperaconnect | `maclib::asperaconnect::suite_installer_url` | "Aspera Connect" installer URL (Installomator) | implemented | team "PETKK2G752"; "module"' | grep -o "/.*.js") |
||| asperaconnect | `maclib::asperaconnect::latest_version` | "Aspera Connect" current build | implemented | Installomator appNewVersion logic |
||| asperaconnect | `maclib::asperaconnect::is_installed` | Return 0 if "Aspera Connect" installed | implemented | team "PETKK2G752"; "module"' | grep -o "/.*.js") |
||| asperaconnect | `maclib::asperaconnect::installed_path` | Path to installed "Aspera Connect" bundle | implemented | |
||| asperaconnect | `maclib::asperaconnect::install` | Download installer and install "Aspera Connect" | implemented | requires root |
||| asperaconnect | `maclib::asperaconnect::update` | Update "Aspera Connect" | implemented | no update path |
||| asperaconnect | `maclib::asperaconnect::uninstall` | Uninstall "Aspera Connect" | implemented | no clean uninstall |

||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::suite_installer_url` | "AsymmetricKeyGenerator" installer URL (Installomator) | implemented | team "89H83DPVB8"; "dmg" |
||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::latest_version` | "AsymmetricKeyGenerator" current build | implemented | Installomator appNewVersion logic |
||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::is_installed` | Return 0 if "AsymmetricKeyGenerator" installed | implemented | team "89H83DPVB8"; "dmg" |
||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::installed_path` | Path to installed "AsymmetricKeyGenerator" bundle | implemented | |
||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::install` | Download installer and install "AsymmetricKeyGenerator" | implemented | requires root |
||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::update` | Update "AsymmetricKeyGenerator" | implemented | no update path |
||| asymmetrickeygenerator | `maclib::asymmetrickeygenerator::uninstall` | Uninstall "AsymmetricKeyGenerator" | implemented | no clean uninstall |

||| atlassiancompanion | `maclib::atlassiancompanion::suite_installer_url` | "Atlassian Companion" installer URL (Installomator) | implemented | team "UPXU4CQZ5P"; "dmg" |
||| atlassiancompanion | `maclib::atlassiancompanion::latest_version` | "Atlassian Companion" current build | implemented | Installomator appNewVersion logic |
||| atlassiancompanion | `maclib::atlassiancompanion::is_installed` | Return 0 if "Atlassian Companion" installed | implemented | team "UPXU4CQZ5P"; "dmg" |
||| atlassiancompanion | `maclib::atlassiancompanion::installed_path` | Path to installed "Atlassian Companion" bundle | implemented | |
||| atlassiancompanion | `maclib::atlassiancompanion::install` | Download installer and install "Atlassian Companion" | implemented | requires root |
||| atlassiancompanion | `maclib::atlassiancompanion::update` | Update "Atlassian Companion" | implemented | no update path |
||| atlassiancompanion | `maclib::atlassiancompanion::uninstall` | Uninstall "Atlassian Companion" | implemented | no clean uninstall |

||| audacity | `maclib::audacity::suite_installer_url` | "Audacity" installer URL (Installomator) | implemented | team "AWEYX923UX"; "dmg" |
||| audacity | `maclib::audacity::latest_version` | "Audacity" current build | implemented | Installomator appNewVersion logic |
||| audacity | `maclib::audacity::is_installed` | Return 0 if "Audacity" installed | implemented | team "AWEYX923UX"; "dmg" |
||| audacity | `maclib::audacity::installed_path` | Path to installed "Audacity" bundle | implemented | |
||| audacity | `maclib::audacity::install` | Download installer and install "Audacity" | implemented | requires root |
||| audacity | `maclib::audacity::update` | Update "Audacity" | implemented | no update path |
||| audacity | `maclib::audacity::uninstall` | Uninstall "Audacity" | implemented | no clean uninstall |

||| autodmg | `maclib::autodmg::suite_installer_url` | "AutoDMG" installer URL (Installomator) | implemented | team "5KQ3D3FG5H"; "dmg" |
||| autodmg | `maclib::autodmg::latest_version` | "AutoDMG" current build | implemented | Installomator appNewVersion logic |
||| autodmg | `maclib::autodmg::is_installed` | Return 0 if "AutoDMG" installed | implemented | team "5KQ3D3FG5H"; "dmg" |
||| autodmg | `maclib::autodmg::installed_path` | Path to installed "AutoDMG" bundle | implemented | |
||| autodmg | `maclib::autodmg::install` | Download installer and install "AutoDMG" | implemented | requires root |
||| autodmg | `maclib::autodmg::update` | Update "AutoDMG" | implemented | no update path |
||| autodmg | `maclib::autodmg::uninstall` | Uninstall "AutoDMG" | implemented | no clean uninstall |

||| automounter | `maclib::automounter::suite_installer_url` | "AutoMounter" installer URL (Installomator) | implemented | team "UKWABN4MGL"; "dmg" |
||| automounter | `maclib::automounter::latest_version` | "AutoMounter" current build | implemented | Installomator appNewVersion logic |
||| automounter | `maclib::automounter::is_installed` | Return 0 if "AutoMounter" installed | implemented | team "UKWABN4MGL"; "dmg" |
||| automounter | `maclib::automounter::installed_path` | Path to installed "AutoMounter" bundle | implemented | |
||| automounter | `maclib::automounter::install` | Download installer and install "AutoMounter" | implemented | requires root |
||| automounter | `maclib::automounter::update` | Update "AutoMounter" | implemented | no update path |
||| automounter | `maclib::automounter::uninstall` | Uninstall "AutoMounter" | implemented | no clean uninstall |

||| autopkgr | `maclib::autopkgr::suite_installer_url` | "AutoPkgr" installer URL (Installomator) | implemented | team "JVY2ZR6SEF"; "dmg" |
||| autopkgr | `maclib::autopkgr::latest_version` | "AutoPkgr" current build | implemented | Installomator appNewVersion logic |
||| autopkgr | `maclib::autopkgr::is_installed` | Return 0 if "AutoPkgr" installed | implemented | team "JVY2ZR6SEF"; "dmg" |
||| autopkgr | `maclib::autopkgr::installed_path` | Path to installed "AutoPkgr" bundle | implemented | |
||| autopkgr | `maclib::autopkgr::install` | Download installer and install "AutoPkgr" | implemented | requires root |
||| autopkgr | `maclib::autopkgr::update` | Update "AutoPkgr" | implemented | no update path |
||| autopkgr | `maclib::autopkgr::uninstall` | Uninstall "AutoPkgr" | implemented | no clean uninstall |

||| avertouch | `maclib::avertouch::suite_installer_url` | "AverTouch" installer URL (Installomator) | implemented | team "B6T3WCD59Q"; "zip" |
||| avertouch | `maclib::avertouch::latest_version` | "AverTouch" current build | implemented | Installomator appNewVersion logic |
||| avertouch | `maclib::avertouch::is_installed` | Return 0 if "AverTouch" installed | implemented | team "B6T3WCD59Q"; "zip" |
||| avertouch | `maclib::avertouch::installed_path` | Path to installed "AverTouch" bundle | implemented | |
||| avertouch | `maclib::avertouch::install` | Download installer and install "AverTouch" | implemented | requires root |
||| avertouch | `maclib::avertouch::update` | Update "AverTouch" | implemented | no update path |
||| avertouch | `maclib::avertouch::uninstall` | Uninstall "AverTouch" | implemented | no clean uninstall |

||| aviatrix | `maclib::aviatrix::suite_installer_url` | "Aviatrix VPN Client" installer URL (Installomator) | implemented | team "32953Z7NBN"; "pkg" |
||| aviatrix | `maclib::aviatrix::latest_version` | "Aviatrix VPN Client" current build | implemented | Installomator appNewVersion logic |
||| aviatrix | `maclib::aviatrix::is_installed` | Return 0 if "Aviatrix VPN Client" installed | implemented | team "32953Z7NBN"; "pkg" |
||| aviatrix | `maclib::aviatrix::installed_path` | Path to installed "Aviatrix VPN Client" bundle | implemented | |
||| aviatrix | `maclib::aviatrix::install` | Download installer and install "Aviatrix VPN Client" | implemented | requires root |
||| aviatrix | `maclib::aviatrix::update` | Update "Aviatrix VPN Client" | implemented | no update path |
||| aviatrix | `maclib::aviatrix::uninstall` | Uninstall "Aviatrix VPN Client" | implemented | no clean uninstall |

||| awscli2 | `maclib::awscli2::suite_installer_url` | "AWSCLI" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" |
||| awscli2 | `maclib::awscli2::latest_version` | "AWSCLI" current build | implemented | Installomator appNewVersion logic |
||| awscli2 | `maclib::awscli2::is_installed` | Return 0 if "AWSCLI" installed | implemented | team "94KV3E626L"; "pkg" |
||| awscli2 | `maclib::awscli2::installed_path` | Path to installed "AWSCLI" bundle | implemented | |
||| awscli2 | `maclib::awscli2::install` | Download installer and install "AWSCLI" | implemented | requires root |
||| awscli2 | `maclib::awscli2::update` | Update "AWSCLI" | implemented | no update path |
||| awscli2 | `maclib::awscli2::uninstall` | Uninstall "AWSCLI" | implemented | no clean uninstall |

||| awsvpnclient | `maclib::awsvpnclient::suite_installer_url` | "AWS VPN Client" installer URL (Installomator) | implemented | team "94KV3E626L"; "pkg" |
||| awsvpnclient | `maclib::awsvpnclient::latest_version` | "AWS VPN Client" current build | implemented | Installomator appNewVersion logic |
||| awsvpnclient | `maclib::awsvpnclient::is_installed` | Return 0 if "AWS VPN Client" installed | implemented | team "94KV3E626L"; "pkg" |
||| awsvpnclient | `maclib::awsvpnclient::installed_path` | Path to installed "AWS VPN Client" bundle | implemented | |
||| awsvpnclient | `maclib::awsvpnclient::install` | Download installer and install "AWS VPN Client" | implemented | requires root |
||| awsvpnclient | `maclib::awsvpnclient::update` | Update "AWS VPN Client" | implemented | no update path |
||| awsvpnclient | `maclib::awsvpnclient::uninstall` | Uninstall "AWS VPN Client" | implemented | no clean uninstall |

||| axurerp10 | `maclib::axurerp10::suite_installer_url` | "Axure RP 10" installer URL (Installomator) | implemented | team "HUMW6UU796"; "dmg" |
||| axurerp10 | `maclib::axurerp10::latest_version` | "Axure RP 10" current build | implemented | Installomator appNewVersion logic |
||| axurerp10 | `maclib::axurerp10::is_installed` | Return 0 if "Axure RP 10" installed | implemented | team "HUMW6UU796"; "dmg" |
||| axurerp10 | `maclib::axurerp10::installed_path` | Path to installed "Axure RP 10" bundle | implemented | |
||| axurerp10 | `maclib::axurerp10::install` | Download installer and install "Axure RP 10" | implemented | requires root |
||| axurerp10 | `maclib::axurerp10::update` | Update "Axure RP 10" | implemented | no update path |
||| axurerp10 | `maclib::axurerp10::uninstall` | Uninstall "Axure RP 10" | implemented | no clean uninstall |

||| azuredatastudio | `maclib::azuredatastudio::suite_installer_url` | "Azure Data Studio" installer URL (Installomator) | implemented | team "UBF8T346G9"; "zip" |
||| azuredatastudio | `maclib::azuredatastudio::latest_version` | "Azure Data Studio" current build | implemented | Installomator appNewVersion logic |
||| azuredatastudio | `maclib::azuredatastudio::is_installed` | Return 0 if "Azure Data Studio" installed | implemented | team "UBF8T346G9"; "zip" |
||| azuredatastudio | `maclib::azuredatastudio::installed_path` | Path to installed "Azure Data Studio" bundle | implemented | |
||| azuredatastudio | `maclib::azuredatastudio::install` | Download installer and install "Azure Data Studio" | implemented | requires root |
||| azuredatastudio | `maclib::azuredatastudio::update` | Update "Azure Data Studio" | implemented | no update path |
||| azuredatastudio | `maclib::azuredatastudio::uninstall` | Uninstall "Azure Data Studio" | implemented | no clean uninstall |

||| backgroundmusic | `maclib::backgroundmusic::suite_installer_url` | "BackgroundMusic" installer URL (Installomator) | implemented | team "PR7PXC66S5"; "pkg" |
||| backgroundmusic | `maclib::backgroundmusic::latest_version` | "BackgroundMusic" current build | implemented | Installomator appNewVersion logic |
||| backgroundmusic | `maclib::backgroundmusic::is_installed` | Return 0 if "BackgroundMusic" installed | implemented | team "PR7PXC66S5"; "pkg" |
||| backgroundmusic | `maclib::backgroundmusic::installed_path` | Path to installed "BackgroundMusic" bundle | implemented | |
||| backgroundmusic | `maclib::backgroundmusic::install` | Download installer and install "BackgroundMusic" | implemented | requires root |
||| backgroundmusic | `maclib::backgroundmusic::update` | Update "BackgroundMusic" | implemented | no update path |
||| backgroundmusic | `maclib::backgroundmusic::uninstall` | Uninstall "BackgroundMusic" | implemented | no clean uninstall |

||| backgrounds | `maclib::backgrounds::suite_installer_url` | "Backgrounds" installer URL (Installomator) | implemented | team "7R5ZEU67FQ"; "pkg" |
||| backgrounds | `maclib::backgrounds::latest_version` | "Backgrounds" current build | implemented | Installomator appNewVersion logic |
||| backgrounds | `maclib::backgrounds::is_installed` | Return 0 if "Backgrounds" installed | implemented | team "7R5ZEU67FQ"; "pkg" |
||| backgrounds | `maclib::backgrounds::installed_path` | Path to installed "Backgrounds" bundle | implemented | |
||| backgrounds | `maclib::backgrounds::install` | Download installer and install "Backgrounds" | implemented | requires root |
||| backgrounds | `maclib::backgrounds::update` | Update "Backgrounds" | implemented | no update path |
||| backgrounds | `maclib::backgrounds::uninstall` | Uninstall "Backgrounds" | implemented | no clean uninstall |

||| balenaetcher | `maclib::balenaetcher::suite_installer_url` | "balenaEtcher" installer URL (Installomator) | implemented | team "66H43P8FRG"; "dmg" |
||| balenaetcher | `maclib::balenaetcher::latest_version` | "balenaEtcher" current build | implemented | Installomator appNewVersion logic |
||| balenaetcher | `maclib::balenaetcher::is_installed` | Return 0 if "balenaEtcher" installed | implemented | team "66H43P8FRG"; "dmg" |
||| balenaetcher | `maclib::balenaetcher::installed_path` | Path to installed "balenaEtcher" bundle | implemented | |
||| balenaetcher | `maclib::balenaetcher::install` | Download installer and install "balenaEtcher" | implemented | requires root |
||| balenaetcher | `maclib::balenaetcher::update` | Update "balenaEtcher" | implemented | no update path |
||| balenaetcher | `maclib::balenaetcher::uninstall` | Uninstall "balenaEtcher" | implemented | no clean uninstall |

||| balsamiqwireframes | `maclib::balsamiqwireframes::suite_installer_url` | "Balsamiq Wireframes" installer URL (Installomator) | implemented | team "3DPKD72KQ7"; "dmg" |
||| balsamiqwireframes | `maclib::balsamiqwireframes::latest_version` | "Balsamiq Wireframes" current build | implemented | Installomator appNewVersion logic |
||| balsamiqwireframes | `maclib::balsamiqwireframes::is_installed` | Return 0 if "Balsamiq Wireframes" installed | implemented | team "3DPKD72KQ7"; "dmg" |
||| balsamiqwireframes | `maclib::balsamiqwireframes::installed_path` | Path to installed "Balsamiq Wireframes" bundle | implemented | |
||| balsamiqwireframes | `maclib::balsamiqwireframes::install` | Download installer and install "Balsamiq Wireframes" | implemented | requires root |
||| balsamiqwireframes | `maclib::balsamiqwireframes::update` | Update "Balsamiq Wireframes" | implemented | no update path |
||| balsamiqwireframes | `maclib::balsamiqwireframes::uninstall` | Uninstall "Balsamiq Wireframes" | implemented | no clean uninstall |

||| bambustudio | `maclib::bambustudio::suite_installer_url` | "BambuStudio" installer URL (Installomator) | implemented | team "T3UBR9Y3B2"; "dmg" |
||| bambustudio | `maclib::bambustudio::latest_version` | "BambuStudio" current build | implemented | Installomator appNewVersion logic |
||| bambustudio | `maclib::bambustudio::is_installed` | Return 0 if "BambuStudio" installed | implemented | team "T3UBR9Y3B2"; "dmg" |
||| bambustudio | `maclib::bambustudio::installed_path` | Path to installed "BambuStudio" bundle | implemented | |
||| bambustudio | `maclib::bambustudio::install` | Download installer and install "BambuStudio" | implemented | requires root |
||| bambustudio | `maclib::bambustudio::update` | Update "BambuStudio" | implemented | no update path |
||| bambustudio | `maclib::bambustudio::uninstall` | Uninstall "BambuStudio" | implemented | no clean uninstall |

||| bartender | `maclib::bartender::suite_installer_url` | "Bartender 4" installer URL (Installomator) | implemented | team "8DD663WDX4"; "dmg" |
||| bartender | `maclib::bartender::latest_version` | "Bartender 4" current build | implemented | Installomator appNewVersion logic |
||| bartender | `maclib::bartender::is_installed` | Return 0 if "Bartender 4" installed | implemented | team "8DD663WDX4"; "dmg" |
||| bartender | `maclib::bartender::installed_path` | Path to installed "Bartender 4" bundle | implemented | |
||| bartender | `maclib::bartender::install` | Download installer and install "Bartender 4" | implemented | requires root |
||| bartender | `maclib::bartender::update` | Update "Bartender 4" | implemented | no update path |
||| bartender | `maclib::bartender::uninstall` | Uninstall "Bartender 4" | implemented | no clean uninstall |

||| basecamp3 | `maclib::basecamp3::suite_installer_url` | "Basecamp 3" installer URL (Installomator) | implemented | team "2WNYUYRS7G"; "zip" |
||| basecamp3 | `maclib::basecamp3::latest_version` | "Basecamp 3" current build | implemented | Installomator appNewVersion logic |
||| basecamp3 | `maclib::basecamp3::is_installed` | Return 0 if "Basecamp 3" installed | implemented | team "2WNYUYRS7G"; "zip" |
||| basecamp3 | `maclib::basecamp3::installed_path` | Path to installed "Basecamp 3" bundle | implemented | |
||| basecamp3 | `maclib::basecamp3::install` | Download installer and install "Basecamp 3" | implemented | requires root |
||| basecamp3 | `maclib::basecamp3::update` | Update "Basecamp 3" | implemented | no update path |
||| basecamp3 | `maclib::basecamp3::uninstall` | Uninstall "Basecamp 3" | implemented | no clean uninstall |

||| baseline | `maclib::baseline::suite_installer_url` | "Baseline" installer URL (Installomator) | implemented | team "7Q6XP5698G"; "pkg" |
||| baseline | `maclib::baseline::latest_version` | "Baseline" current build | implemented | Installomator appNewVersion logic |
||| baseline | `maclib::baseline::is_installed` | Return 0 if "Baseline" installed | implemented | team "7Q6XP5698G"; "pkg" |
||| baseline | `maclib::baseline::installed_path` | Path to installed "Baseline" bundle | implemented | |
||| baseline | `maclib::baseline::install` | Download installer and install "Baseline" | implemented | requires root |
||| baseline | `maclib::baseline::update` | Update "Baseline" | implemented | no update path |
||| baseline | `maclib::baseline::uninstall` | Uninstall "Baseline" | implemented | no clean uninstall |

||| baseline-nodaemon | `maclib::baseline-nodaemon::suite_installer_url` | "Baseline" installer URL (Installomator) | implemented | team "7Q6XP5698G"; "pkg" |
||| baseline-nodaemon | `maclib::baseline-nodaemon::latest_version` | "Baseline" current build | implemented | Installomator appNewVersion logic |
||| baseline-nodaemon | `maclib::baseline-nodaemon::is_installed` | Return 0 if "Baseline" installed | implemented | team "7Q6XP5698G"; "pkg" |
||| baseline-nodaemon | `maclib::baseline-nodaemon::installed_path` | Path to installed "Baseline" bundle | implemented | |
||| baseline-nodaemon | `maclib::baseline-nodaemon::install` | Download installer and install "Baseline" | implemented | requires root |
||| baseline-nodaemon | `maclib::baseline-nodaemon::update` | Update "Baseline" | implemented | no update path |
||| baseline-nodaemon | `maclib::baseline-nodaemon::uninstall` | Uninstall "Baseline" | implemented | no clean uninstall |

||| bbedit | `maclib::bbedit::suite_installer_url` | "BBEdit" installer URL (Installomator) | implemented | team "W52GZAXT98"; "dmg" |
||| bbedit | `maclib::bbedit::latest_version` | "BBEdit" current build | implemented | Installomator appNewVersion logic |
||| bbedit | `maclib::bbedit::is_installed` | Return 0 if "BBEdit" installed | implemented | team "W52GZAXT98"; "dmg" |
||| bbedit | `maclib::bbedit::installed_path` | Path to installed "BBEdit" bundle | implemented | |
||| bbedit | `maclib::bbedit::install` | Download installer and install "BBEdit" | implemented | requires root |
||| bbedit | `maclib::bbedit::update` | Update "BBEdit" | implemented | no update path |
||| bbedit | `maclib::bbedit::uninstall` | Uninstall "BBEdit" | implemented | no clean uninstall |

||| bbeditpkg | `maclib::bbeditpkg::suite_installer_url` | "BBEdit" installer URL (Installomator) | implemented | team "W52GZAXT98"; "pkg" |
||| bbeditpkg | `maclib::bbeditpkg::latest_version` | "BBEdit" current build | implemented | Installomator appNewVersion logic |
||| bbeditpkg | `maclib::bbeditpkg::is_installed` | Return 0 if "BBEdit" installed | implemented | team "W52GZAXT98"; "pkg" |
||| bbeditpkg | `maclib::bbeditpkg::installed_path` | Path to installed "BBEdit" bundle | implemented | |
||| bbeditpkg | `maclib::bbeditpkg::install` | Download installer and install "BBEdit" | implemented | requires root |
||| bbeditpkg | `maclib::bbeditpkg::update` | Update "BBEdit" | implemented | no update path |
||| bbeditpkg | `maclib::bbeditpkg::uninstall` | Uninstall "BBEdit" | implemented | no clean uninstall |

||| beamstudio | `maclib::beamstudio::suite_installer_url` | "Beam Studio" installer URL (Installomator) | implemented | team "4Y92JWKV94"; "dmg" |
||| beamstudio | `maclib::beamstudio::latest_version` | "Beam Studio" current build | implemented | Installomator appNewVersion logic |
||| beamstudio | `maclib::beamstudio::is_installed` | Return 0 if "Beam Studio" installed | implemented | team "4Y92JWKV94"; "dmg" |
||| beamstudio | `maclib::beamstudio::installed_path` | Path to installed "Beam Studio" bundle | implemented | |
||| beamstudio | `maclib::beamstudio::install` | Download installer and install "Beam Studio" | implemented | requires root |
||| beamstudio | `maclib::beamstudio::update` | Update "Beam Studio" | implemented | no update path |
||| beamstudio | `maclib::beamstudio::uninstall` | Uninstall "Beam Studio" | implemented | no clean uninstall |

||| beekeeperstudio | `maclib::beekeeperstudio::suite_installer_url` | "Beekeeper Studio" installer URL (Installomator) | implemented | team "7KK583U8H2"; "dmg" |
||| beekeeperstudio | `maclib::beekeeperstudio::latest_version` | "Beekeeper Studio" current build | implemented | Installomator appNewVersion logic |
||| beekeeperstudio | `maclib::beekeeperstudio::is_installed` | Return 0 if "Beekeeper Studio" installed | implemented | team "7KK583U8H2"; "dmg" |
||| beekeeperstudio | `maclib::beekeeperstudio::installed_path` | Path to installed "Beekeeper Studio" bundle | implemented | |
||| beekeeperstudio | `maclib::beekeeperstudio::install` | Download installer and install "Beekeeper Studio" | implemented | requires root |
||| beekeeperstudio | `maclib::beekeeperstudio::update` | Update "Beekeeper Studio" | implemented | no update path |
||| beekeeperstudio | `maclib::beekeeperstudio::uninstall` | Uninstall "Beekeeper Studio" | implemented | no clean uninstall |

||| betterdisplay | `maclib::betterdisplay::suite_installer_url` | "BetterDisplay" installer URL (Installomator) | implemented | team "299YSU96J7"; "dmg" |
||| betterdisplay | `maclib::betterdisplay::latest_version` | "BetterDisplay" current build | implemented | Installomator appNewVersion logic |
||| betterdisplay | `maclib::betterdisplay::is_installed` | Return 0 if "BetterDisplay" installed | implemented | team "299YSU96J7"; "dmg" |
||| betterdisplay | `maclib::betterdisplay::installed_path` | Path to installed "BetterDisplay" bundle | implemented | |
||| betterdisplay | `maclib::betterdisplay::install` | Download installer and install "BetterDisplay" | implemented | requires root |
||| betterdisplay | `maclib::betterdisplay::update` | Update "BetterDisplay" | implemented | no update path |
||| betterdisplay | `maclib::betterdisplay::uninstall` | Uninstall "BetterDisplay" | implemented | no clean uninstall |

||| bettertouchtool | `maclib::bettertouchtool::suite_installer_url` | "BetterTouchTool" installer URL (Installomator) | implemented | team "DAFVSXZ82P"; "zip" |
||| bettertouchtool | `maclib::bettertouchtool::latest_version` | "BetterTouchTool" current build | implemented | Installomator appNewVersion logic |
||| bettertouchtool | `maclib::bettertouchtool::is_installed` | Return 0 if "BetterTouchTool" installed | implemented | team "DAFVSXZ82P"; "zip" |
||| bettertouchtool | `maclib::bettertouchtool::installed_path` | Path to installed "BetterTouchTool" bundle | implemented | |
||| bettertouchtool | `maclib::bettertouchtool::install` | Download installer and install "BetterTouchTool" | implemented | requires root |
||| bettertouchtool | `maclib::bettertouchtool::update` | Update "BetterTouchTool" | implemented | no update path |
||| bettertouchtool | `maclib::bettertouchtool::uninstall` | Uninstall "BetterTouchTool" | implemented | no clean uninstall |

||| betterzip | `maclib::betterzip::suite_installer_url` | "BetterZip" installer URL (Installomator) | implemented | team "79RR9LPM2N"; "zip" |
||| betterzip | `maclib::betterzip::latest_version` | "BetterZip" current build | implemented | Installomator appNewVersion logic |
||| betterzip | `maclib::betterzip::is_installed` | Return 0 if "BetterZip" installed | implemented | team "79RR9LPM2N"; "zip" |
||| betterzip | `maclib::betterzip::installed_path` | Path to installed "BetterZip" bundle | implemented | |
||| betterzip | `maclib::betterzip::install` | Download installer and install "BetterZip" | implemented | requires root |
||| betterzip | `maclib::betterzip::update` | Update "BetterZip" | implemented | no update path |
||| betterzip | `maclib::betterzip::uninstall` | Uninstall "BetterZip" | implemented | no clean uninstall |

||| beyondcomparepro | `maclib::beyondcomparepro::suite_installer_url` | "Beyond Compare" installer URL (Installomator) | implemented | team "BS29TEJF86"; "zip" |
||| beyondcomparepro | `maclib::beyondcomparepro::latest_version` | "Beyond Compare" current build | implemented | Installomator appNewVersion logic |
||| beyondcomparepro | `maclib::beyondcomparepro::is_installed` | Return 0 if "Beyond Compare" installed | implemented | team "BS29TEJF86"; "zip" |
||| beyondcomparepro | `maclib::beyondcomparepro::installed_path` | Path to installed "Beyond Compare" bundle | implemented | |
||| beyondcomparepro | `maclib::beyondcomparepro::install` | Download installer and install "Beyond Compare" | implemented | requires root |
||| beyondcomparepro | `maclib::beyondcomparepro::update` | Update "Beyond Compare" | implemented | no update path |
||| beyondcomparepro | `maclib::beyondcomparepro::uninstall` | Uninstall "Beyond Compare" | implemented | no clean uninstall |

||| bezel | `maclib::bezel::suite_installer_url` | "Bezel" installer URL (Installomator) | implemented | team "WT5N9FK54M"; "dmg" |
||| bezel | `maclib::bezel::latest_version` | "Bezel" current build | implemented | Installomator appNewVersion logic |
||| bezel | `maclib::bezel::is_installed` | Return 0 if "Bezel" installed | implemented | team "WT5N9FK54M"; "dmg" |
||| bezel | `maclib::bezel::installed_path` | Path to installed "Bezel" bundle | implemented | |
||| bezel | `maclib::bezel::install` | Download installer and install "Bezel" | implemented | requires root |
||| bezel | `maclib::bezel::update` | Update "Bezel" | implemented | no update path |
||| bezel | `maclib::bezel::uninstall` | Uninstall "Bezel" | implemented | no clean uninstall |

||| bibdesk | `maclib::bibdesk::suite_installer_url` | "BibDesk" installer URL (Installomator) | implemented | team "J33JTA7SY9"; "dmg" |
||| bibdesk | `maclib::bibdesk::latest_version` | "BibDesk" current build | implemented | Installomator appNewVersion logic |
||| bibdesk | `maclib::bibdesk::is_installed` | Return 0 if "BibDesk" installed | implemented | team "J33JTA7SY9"; "dmg" |
||| bibdesk | `maclib::bibdesk::installed_path` | Path to installed "BibDesk" bundle | implemented | |
||| bibdesk | `maclib::bibdesk::install` | Download installer and install "BibDesk" | implemented | requires root |
||| bibdesk | `maclib::bibdesk::update` | Update "BibDesk" | implemented | no update path |
||| bibdesk | `maclib::bibdesk::uninstall` | Uninstall "BibDesk" | implemented | no clean uninstall |

||| bitrix24 | `maclib::bitrix24::suite_installer_url` | "Bitrix24" installer URL (Installomator) | implemented | team "5B3T3A994N"; "dmg" |
||| bitrix24 | `maclib::bitrix24::latest_version` | "Bitrix24" current build | implemented | Installomator appNewVersion logic |
||| bitrix24 | `maclib::bitrix24::is_installed` | Return 0 if "Bitrix24" installed | implemented | team "5B3T3A994N"; "dmg" |
||| bitrix24 | `maclib::bitrix24::installed_path` | Path to installed "Bitrix24" bundle | implemented | |
||| bitrix24 | `maclib::bitrix24::install` | Download installer and install "Bitrix24" | implemented | requires root |
||| bitrix24 | `maclib::bitrix24::update` | Update "Bitrix24" | implemented | no update path |
||| bitrix24 | `maclib::bitrix24::uninstall` | Uninstall "Bitrix24" | implemented | no clean uninstall |

||| bitwarden | `maclib::bitwarden::suite_installer_url` | "Bitwarden" installer URL (Installomator) | implemented | team "LTZ2PFU5D6"; "dmg" |
||| bitwarden | `maclib::bitwarden::latest_version` | "Bitwarden" current build | implemented | Installomator appNewVersion logic |
||| bitwarden | `maclib::bitwarden::is_installed` | Return 0 if "Bitwarden" installed | implemented | team "LTZ2PFU5D6"; "dmg" |
||| bitwarden | `maclib::bitwarden::installed_path` | Path to installed "Bitwarden" bundle | implemented | |
||| bitwarden | `maclib::bitwarden::install` | Download installer and install "Bitwarden" | implemented | requires root |
||| bitwarden | `maclib::bitwarden::update` | Update "Bitwarden" | implemented | no update path |
||| bitwarden | `maclib::bitwarden::uninstall` | Uninstall "Bitwarden" | implemented | no clean uninstall |

||| bitwigstudio | `maclib::bitwigstudio::suite_installer_url` | "Bitwig Studio" installer URL (Installomator) | implemented | team "2B6K987585"; "dmg" |
||| bitwigstudio | `maclib::bitwigstudio::latest_version` | "Bitwig Studio" current build | implemented | Installomator appNewVersion logic |
||| bitwigstudio | `maclib::bitwigstudio::is_installed` | Return 0 if "Bitwig Studio" installed | implemented | team "2B6K987585"; "dmg" |
||| bitwigstudio | `maclib::bitwigstudio::installed_path` | Path to installed "Bitwig Studio" bundle | implemented | |
||| bitwigstudio | `maclib::bitwigstudio::install` | Download installer and install "Bitwig Studio" | implemented | requires root |
||| bitwigstudio | `maclib::bitwigstudio::update` | Update "Bitwig Studio" | implemented | no update path |
||| bitwigstudio | `maclib::bitwigstudio::uninstall` | Uninstall "Bitwig Studio" | implemented | no clean uninstall |

||| blackhole16ch | `maclib::blackhole16ch::suite_installer_url` | "BlackHole" installer URL (Installomator) | implemented | team "Q5C99V536K"; "pkg" |
||| blackhole16ch | `maclib::blackhole16ch::latest_version` | "BlackHole" current build | implemented | Installomator appNewVersion logic |
||| blackhole16ch | `maclib::blackhole16ch::is_installed` | Return 0 if "BlackHole" installed | implemented | team "Q5C99V536K"; "pkg" |
||| blackhole16ch | `maclib::blackhole16ch::installed_path` | Path to installed "BlackHole" bundle | implemented | |
||| blackhole16ch | `maclib::blackhole16ch::install` | Download installer and install "BlackHole" | implemented | requires root |
||| blackhole16ch | `maclib::blackhole16ch::update` | Update "BlackHole" | implemented | no update path |
||| blackhole16ch | `maclib::blackhole16ch::uninstall` | Uninstall "BlackHole" | implemented | no clean uninstall |

||| blackhole2ch | `maclib::blackhole2ch::suite_installer_url` | "BlackHole" installer URL (Installomator) | implemented | team "Q5C99V536K"; "pkg" |
||| blackhole2ch | `maclib::blackhole2ch::latest_version` | "BlackHole" current build | implemented | Installomator appNewVersion logic |
||| blackhole2ch | `maclib::blackhole2ch::is_installed` | Return 0 if "BlackHole" installed | implemented | team "Q5C99V536K"; "pkg" |
||| blackhole2ch | `maclib::blackhole2ch::installed_path` | Path to installed "BlackHole" bundle | implemented | |
||| blackhole2ch | `maclib::blackhole2ch::install` | Download installer and install "BlackHole" | implemented | requires root |
||| blackhole2ch | `maclib::blackhole2ch::update` | Update "BlackHole" | implemented | no update path |
||| blackhole2ch | `maclib::blackhole2ch::uninstall` | Uninstall "BlackHole" | implemented | no clean uninstall |

||| blackhole64ch | `maclib::blackhole64ch::suite_installer_url` | "BlackHole" installer URL (Installomator) | implemented | team "Q5C99V536K"; "pkg" |
||| blackhole64ch | `maclib::blackhole64ch::latest_version` | "BlackHole" current build | implemented | Installomator appNewVersion logic |
||| blackhole64ch | `maclib::blackhole64ch::is_installed` | Return 0 if "BlackHole" installed | implemented | team "Q5C99V536K"; "pkg" |
||| blackhole64ch | `maclib::blackhole64ch::installed_path` | Path to installed "BlackHole" bundle | implemented | |
||| blackhole64ch | `maclib::blackhole64ch::install` | Download installer and install "BlackHole" | implemented | requires root |
||| blackhole64ch | `maclib::blackhole64ch::update` | Update "BlackHole" | implemented | no update path |
||| blackhole64ch | `maclib::blackhole64ch::uninstall` | Uninstall "BlackHole" | implemented | no clean uninstall |

||| blitzit | `maclib::blitzit::suite_installer_url` | "Blitzit" installer URL (Installomator) | implemented | team "29VYWQJ9TL"; "dmg" |
||| blitzit | `maclib::blitzit::latest_version` | "Blitzit" current build | implemented | Installomator appNewVersion logic |
||| blitzit | `maclib::blitzit::is_installed` | Return 0 if "Blitzit" installed | implemented | team "29VYWQJ9TL"; "dmg" |
||| blitzit | `maclib::blitzit::installed_path` | Path to installed "Blitzit" bundle | implemented | |
||| blitzit | `maclib::blitzit::install` | Download installer and install "Blitzit" | implemented | requires root |
||| blitzit | `maclib::blitzit::update` | Update "Blitzit" | implemented | no update path |
||| blitzit | `maclib::blitzit::uninstall` | Uninstall "Blitzit" | implemented | no clean uninstall |

||| boop | `maclib::boop::suite_installer_url` | "Boop" installer URL (Installomator) | implemented | team "RLZ8XBTX7G"; "zip" |
||| boop | `maclib::boop::latest_version` | "Boop" current build | implemented | Installomator appNewVersion logic |
||| boop | `maclib::boop::is_installed` | Return 0 if "Boop" installed | implemented | team "RLZ8XBTX7G"; "zip" |
||| boop | `maclib::boop::installed_path` | Path to installed "Boop" bundle | implemented | |
||| boop | `maclib::boop::install` | Download installer and install "Boop" | implemented | requires root |
||| boop | `maclib::boop::update` | Update "Boop" | implemented | no update path |
||| boop | `maclib::boop::uninstall` | Uninstall "Boop" | implemented | no clean uninstall |

||| boxdrive | `maclib::boxdrive::suite_installer_url` | "Box" installer URL (Installomator) | implemented | team "M683GB7CPW"; "pkg" |
||| boxdrive | `maclib::boxdrive::latest_version` | "Box" current build | implemented | Installomator appNewVersion logic |
||| boxdrive | `maclib::boxdrive::is_installed` | Return 0 if "Box" installed | implemented | team "M683GB7CPW"; "pkg" |
||| boxdrive | `maclib::boxdrive::installed_path` | Path to installed "Box" bundle | implemented | |
||| boxdrive | `maclib::boxdrive::install` | Download installer and install "Box" | implemented | requires root |
||| boxdrive | `maclib::boxdrive::update` | Update "Box" | implemented | no update path |
||| boxdrive | `maclib::boxdrive::uninstall` | Uninstall "Box" | implemented | no clean uninstall |

||| boxsync | `maclib::boxsync::suite_installer_url` | "Box Sync" installer URL (Installomator) | implemented | team "M683GB7CPW"; "dmg" |
||| boxsync | `maclib::boxsync::latest_version` | "Box Sync" current build | implemented | Installomator appNewVersion logic |
||| boxsync | `maclib::boxsync::is_installed` | Return 0 if "Box Sync" installed | implemented | team "M683GB7CPW"; "dmg" |
||| boxsync | `maclib::boxsync::installed_path` | Path to installed "Box Sync" bundle | implemented | |
||| boxsync | `maclib::boxsync::install` | Download installer and install "Box Sync" | implemented | requires root |
||| boxsync | `maclib::boxsync::update` | Update "Box Sync" | implemented | no update path |
||| boxsync | `maclib::boxsync::uninstall` | Uninstall "Box Sync" | implemented | no clean uninstall |

||| boxtools | `maclib::boxtools::suite_installer_url` | "Box Tools" installer URL (Installomator) | implemented | team "M683GB7CPW"; "pkg" |
||| boxtools | `maclib::boxtools::latest_version` | "Box Tools" current build | implemented | Installomator appNewVersion logic |
||| boxtools | `maclib::boxtools::is_installed` | Return 0 if "Box Tools" installed | implemented | team "M683GB7CPW"; "pkg" |
||| boxtools | `maclib::boxtools::installed_path` | Path to installed "Box Tools" bundle | implemented | |
||| boxtools | `maclib::boxtools::install` | Download installer and install "Box Tools" | implemented | requires root |
||| boxtools | `maclib::boxtools::update` | Update "Box Tools" | implemented | no update path |
||| boxtools | `maclib::boxtools::uninstall` | Uninstall "Box Tools" | implemented | no clean uninstall |

||| bracketsio | `maclib::bracketsio::suite_installer_url` | "Brackets" installer URL (Installomator) | implemented | team "JQ525L2MZD"; "dmg" |
||| bracketsio | `maclib::bracketsio::latest_version` | "Brackets" current build | implemented | Installomator appNewVersion logic |
||| bracketsio | `maclib::bracketsio::is_installed` | Return 0 if "Brackets" installed | implemented | team "JQ525L2MZD"; "dmg" |
||| bracketsio | `maclib::bracketsio::installed_path` | Path to installed "Brackets" bundle | implemented | |
||| bracketsio | `maclib::bracketsio::install` | Download installer and install "Brackets" | implemented | requires root |
||| bracketsio | `maclib::bracketsio::update` | Update "Brackets" | implemented | no update path |
||| bracketsio | `maclib::bracketsio::uninstall` | Uninstall "Brackets" | implemented | no clean uninstall |

||| brave | `maclib::brave::suite_installer_url` | "Brave Browser" installer URL (Installomator) | implemented | team "KL8N8XSYF4"; "dmg" |
||| brave | `maclib::brave::latest_version` | "Brave Browser" current build | implemented | Installomator appNewVersion logic |
||| brave | `maclib::brave::is_installed` | Return 0 if "Brave Browser" installed | implemented | team "KL8N8XSYF4"; "dmg" |
||| brave | `maclib::brave::installed_path` | Path to installed "Brave Browser" bundle | implemented | |
||| brave | `maclib::brave::install` | Download installer and install "Brave Browser" | implemented | requires root |
||| brave | `maclib::brave::update` | Update "Brave Browser" | implemented | no update path |
||| brave | `maclib::brave::uninstall` | Uninstall "Brave Browser" | implemented | no clean uninstall |

||| bravepkg | `maclib::bravepkg::suite_installer_url` | "Brave Browser" installer URL (Installomator) | implemented | team "KL8N8XSYF4"; "pkg" |
||| bravepkg | `maclib::bravepkg::latest_version` | "Brave Browser" current build | implemented | Installomator appNewVersion logic |
||| bravepkg | `maclib::bravepkg::is_installed` | Return 0 if "Brave Browser" installed | implemented | team "KL8N8XSYF4"; "pkg" |
||| bravepkg | `maclib::bravepkg::installed_path` | Path to installed "Brave Browser" bundle | implemented | |
||| bravepkg | `maclib::bravepkg::install` | Download installer and install "Brave Browser" | implemented | requires root |
||| bravepkg | `maclib::bravepkg::update` | Update "Brave Browser" | implemented | no update path |
||| bravepkg | `maclib::bravepkg::uninstall` | Uninstall "Brave Browser" | implemented | no clean uninstall |

||| brosix | `maclib::brosix::suite_installer_url` | "Brosix" installer URL (Installomator) | implemented | team "TA6P23NW8H"; "pkg" |
||| brosix | `maclib::brosix::latest_version` | "Brosix" current build | implemented | Installomator appNewVersion logic |
||| brosix | `maclib::brosix::is_installed` | Return 0 if "Brosix" installed | implemented | team "TA6P23NW8H"; "pkg" |
||| brosix | `maclib::brosix::installed_path` | Path to installed "Brosix" bundle | implemented | |
||| brosix | `maclib::brosix::install` | Download installer and install "Brosix" | implemented | requires root |
||| brosix | `maclib::brosix::update` | Update "Brosix" | implemented | no update path |
||| brosix | `maclib::brosix::uninstall` | Uninstall "Brosix" | implemented | no clean uninstall |

||| browserosaurus | `maclib::browserosaurus::suite_installer_url` | "Browserosaurus" installer URL (Installomator) | implemented | team "Z89KPMLTFR"; "zip" |
||| browserosaurus | `maclib::browserosaurus::latest_version` | "Browserosaurus" current build | implemented | Installomator appNewVersion logic |
||| browserosaurus | `maclib::browserosaurus::is_installed` | Return 0 if "Browserosaurus" installed | implemented | team "Z89KPMLTFR"; "zip" |
||| browserosaurus | `maclib::browserosaurus::installed_path` | Path to installed "Browserosaurus" bundle | implemented | |
||| browserosaurus | `maclib::browserosaurus::install` | Download installer and install "Browserosaurus" | implemented | requires root |
||| browserosaurus | `maclib::browserosaurus::update` | Update "Browserosaurus" | implemented | no update path |
||| browserosaurus | `maclib::browserosaurus::uninstall` | Uninstall "Browserosaurus" | implemented | no clean uninstall |

||| bruno | `maclib::bruno::suite_installer_url` | "Bruno" installer URL (Installomator) | implemented | team "P3WTZH48ZB"; "dmg" |
||| bruno | `maclib::bruno::latest_version` | "Bruno" current build | implemented | Installomator appNewVersion logic |
||| bruno | `maclib::bruno::is_installed` | Return 0 if "Bruno" installed | implemented | team "P3WTZH48ZB"; "dmg" |
||| bruno | `maclib::bruno::installed_path` | Path to installed "Bruno" bundle | implemented | |
||| bruno | `maclib::bruno::install` | Download installer and install "Bruno" | implemented | requires root |
||| bruno | `maclib::bruno::update` | Update "Bruno" | implemented | no update path |
||| bruno | `maclib::bruno::uninstall` | Uninstall "Bruno" | implemented | no clean uninstall |

||| bugdom | `maclib::bugdom::suite_installer_url` | "Bugdom" installer URL (Installomator) | implemented | team "RVNL7XC27G"; "dmg" |
||| bugdom | `maclib::bugdom::latest_version` | "Bugdom" current build | implemented | Installomator appNewVersion logic |
||| bugdom | `maclib::bugdom::is_installed` | Return 0 if "Bugdom" installed | implemented | team "RVNL7XC27G"; "dmg" |
||| bugdom | `maclib::bugdom::installed_path` | Path to installed "Bugdom" bundle | implemented | |
||| bugdom | `maclib::bugdom::install` | Download installer and install "Bugdom" | implemented | requires root |
||| bugdom | `maclib::bugdom::update` | Update "Bugdom" | implemented | no update path |
||| bugdom | `maclib::bugdom::uninstall` | Uninstall "Bugdom" | implemented | no clean uninstall |

||| burpsuiteprofessional | `maclib::burpsuiteprofessional::suite_installer_url` | "Burp Suite Professional" installer URL (Installomator) | implemented | team "N82YM748DZ"; macosx" |
||| burpsuiteprofessional | `maclib::burpsuiteprofessional::latest_version` | "Burp Suite Professional" current build | implemented | Installomator appNewVersion logic |
||| burpsuiteprofessional | `maclib::burpsuiteprofessional::is_installed` | Return 0 if "Burp Suite Professional" installed | implemented | team "N82YM748DZ"; macosx" |
||| burpsuiteprofessional | `maclib::burpsuiteprofessional::installed_path` | Path to installed "Burp Suite Professional" bundle | implemented | |
||| burpsuiteprofessional | `maclib::burpsuiteprofessional::install` | Download installer and install "Burp Suite Professional" | implemented | requires root |
||| burpsuiteprofessional | `maclib::burpsuiteprofessional::update` | Update "Burp Suite Professional" | implemented | no update path |
||| burpsuiteprofessional | `maclib::burpsuiteprofessional::uninstall` | Uninstall "Burp Suite Professional" | implemented | no clean uninstall |

||| busycal | `maclib::busycal::suite_installer_url` | "BusyCal" installer URL (Installomator) | implemented | team "N4RA379GBW"; "dmg" |
||| busycal | `maclib::busycal::latest_version` | "BusyCal" current build | implemented | Installomator appNewVersion logic |
||| busycal | `maclib::busycal::is_installed` | Return 0 if "BusyCal" installed | implemented | team "N4RA379GBW"; "dmg" |
||| busycal | `maclib::busycal::installed_path` | Path to installed "BusyCal" bundle | implemented | |
||| busycal | `maclib::busycal::install` | Download installer and install "BusyCal" | implemented | requires root |
||| busycal | `maclib::busycal::update` | Update "BusyCal" | implemented | no update path |
||| busycal | `maclib::busycal::uninstall` | Uninstall "BusyCal" | implemented | no clean uninstall |

||| busycontacts | `maclib::busycontacts::suite_installer_url` | "BusyContacts" installer URL (Installomator) | implemented | team "N4RA379GBW"; "dmg" |
||| busycontacts | `maclib::busycontacts::latest_version` | "BusyContacts" current build | implemented | Installomator appNewVersion logic |
||| busycontacts | `maclib::busycontacts::is_installed` | Return 0 if "BusyContacts" installed | implemented | team "N4RA379GBW"; "dmg" |
||| busycontacts | `maclib::busycontacts::installed_path` | Path to installed "BusyContacts" bundle | implemented | |
||| busycontacts | `maclib::busycontacts::install` | Download installer and install "BusyContacts" | implemented | requires root |
||| busycontacts | `maclib::busycontacts::update` | Update "BusyContacts" | implemented | no update path |
||| busycontacts | `maclib::busycontacts::uninstall` | Uninstall "BusyContacts" | implemented | no clean uninstall |

||| buttercup | `maclib::buttercup::suite_installer_url` | "Buttercup" installer URL (Installomator) | implemented | team "9D8F4J769D"; "zip" |
||| buttercup | `maclib::buttercup::latest_version` | "Buttercup" current build | implemented | Installomator appNewVersion logic |
||| buttercup | `maclib::buttercup::is_installed` | Return 0 if "Buttercup" installed | implemented | team "9D8F4J769D"; "zip" |
||| buttercup | `maclib::buttercup::installed_path` | Path to installed "Buttercup" bundle | implemented | |
||| buttercup | `maclib::buttercup::install` | Download installer and install "Buttercup" | implemented | requires root |
||| buttercup | `maclib::buttercup::update` | Update "Buttercup" | implemented | no update path |
||| buttercup | `maclib::buttercup::uninstall` | Uninstall "Buttercup" | implemented | no clean uninstall |

||| caffeine | `maclib::caffeine::suite_installer_url` | "Caffeine" installer URL (Installomator) | implemented | team "YD6LEYT6WZ"; "dmg" |
||| caffeine | `maclib::caffeine::latest_version` | "Caffeine" current build | implemented | Installomator appNewVersion logic |
||| caffeine | `maclib::caffeine::is_installed` | Return 0 if "Caffeine" installed | implemented | team "YD6LEYT6WZ"; "dmg" |
||| caffeine | `maclib::caffeine::installed_path` | Path to installed "Caffeine" bundle | implemented | |
||| caffeine | `maclib::caffeine::install` | Download installer and install "Caffeine" | implemented | requires root |
||| caffeine | `maclib::caffeine::update` | Update "Caffeine" | implemented | no update path |
||| caffeine | `maclib::caffeine::uninstall` | Uninstall "Caffeine" | implemented | no clean uninstall |

||| cakebrew | `maclib::cakebrew::suite_installer_url` | "Cakebrew" installer URL (Installomator) | implemented | team "R85D3K8ATT"; "zip" |
||| cakebrew | `maclib::cakebrew::latest_version` | "Cakebrew" current build | implemented | Installomator appNewVersion logic |
||| cakebrew | `maclib::cakebrew::is_installed` | Return 0 if "Cakebrew" installed | implemented | team "R85D3K8ATT"; "zip" |
||| cakebrew | `maclib::cakebrew::installed_path` | Path to installed "Cakebrew" bundle | implemented | |
||| cakebrew | `maclib::cakebrew::install` | Download installer and install "Cakebrew" | implemented | requires root |
||| cakebrew | `maclib::cakebrew::update` | Update "Cakebrew" | implemented | no update path |
||| cakebrew | `maclib::cakebrew::uninstall` | Uninstall "Cakebrew" | implemented | no clean uninstall |

||| calcservice | `maclib::calcservice::suite_installer_url` | "CalcService" installer URL (Installomator) | implemented | team "679S2QUWR8"; "zip" |
||| calcservice | `maclib::calcservice::latest_version` | "CalcService" current build | implemented | Installomator appNewVersion logic |
||| calcservice | `maclib::calcservice::is_installed` | Return 0 if "CalcService" installed | implemented | team "679S2QUWR8"; "zip" |
||| calcservice | `maclib::calcservice::installed_path` | Path to installed "CalcService" bundle | implemented | |
||| calcservice | `maclib::calcservice::install` | Download installer and install "CalcService" | implemented | requires root |
||| calcservice | `maclib::calcservice::update` | Update "CalcService" | implemented | no update path |
||| calcservice | `maclib::calcservice::uninstall` | Uninstall "CalcService" | implemented | no clean uninstall |

||| calibre | `maclib::calibre::suite_installer_url` | "calibre" installer URL (Installomator) | implemented | team "NTY7FVCEKP"; "dmg" |
||| calibre | `maclib::calibre::latest_version` | "calibre" current build | implemented | Installomator appNewVersion logic |
||| calibre | `maclib::calibre::is_installed` | Return 0 if "calibre" installed | implemented | team "NTY7FVCEKP"; "dmg" |
||| calibre | `maclib::calibre::installed_path` | Path to installed "calibre" bundle | implemented | |
||| calibre | `maclib::calibre::install` | Download installer and install "calibre" | implemented | requires root |
||| calibre | `maclib::calibre::update` | Update "calibre" | implemented | no update path |
||| calibre | `maclib::calibre::uninstall` | Uninstall "calibre" | implemented | no clean uninstall |

||| calibriteprofiler | `maclib::calibriteprofiler::suite_installer_url` | "calibrite PROFILER" installer URL (Installomator) | implemented | team "5C392763F5"; "dmg" |
||| calibriteprofiler | `maclib::calibriteprofiler::latest_version` | "calibrite PROFILER" current build | implemented | Installomator appNewVersion logic |
||| calibriteprofiler | `maclib::calibriteprofiler::is_installed` | Return 0 if "calibrite PROFILER" installed | implemented | team "5C392763F5"; "dmg" |
||| calibriteprofiler | `maclib::calibriteprofiler::installed_path` | Path to installed "calibrite PROFILER" bundle | implemented | |
||| calibriteprofiler | `maclib::calibriteprofiler::install` | Download installer and install "calibrite PROFILER" | implemented | requires root |
||| calibriteprofiler | `maclib::calibriteprofiler::update` | Update "calibrite PROFILER" | implemented | no update path |
||| calibriteprofiler | `maclib::calibriteprofiler::uninstall` | Uninstall "calibrite PROFILER" | implemented | no clean uninstall |

||| cameracontroller | `maclib::cameracontroller::suite_installer_url` | "CameraController" installer URL (Installomator) | implemented | team "PY9WJ3M9MW"; "zip" |
||| cameracontroller | `maclib::cameracontroller::latest_version` | "CameraController" current build | implemented | Installomator appNewVersion logic |
||| cameracontroller | `maclib::cameracontroller::is_installed` | Return 0 if "CameraController" installed | implemented | team "PY9WJ3M9MW"; "zip" |
||| cameracontroller | `maclib::cameracontroller::installed_path` | Path to installed "CameraController" bundle | implemented | |
||| cameracontroller | `maclib::cameracontroller::install` | Download installer and install "CameraController" | implemented | requires root |
||| cameracontroller | `maclib::cameracontroller::update` | Update "CameraController" | implemented | no update path |
||| cameracontroller | `maclib::cameracontroller::uninstall` | Uninstall "CameraController" | implemented | no clean uninstall |

||| camostudio | `maclib::camostudio::suite_installer_url` | "Camo Studio" installer URL (Installomator) | implemented | team "Q248YREB53"; "zip" |
||| camostudio | `maclib::camostudio::latest_version` | "Camo Studio" current build | implemented | Installomator appNewVersion logic |
||| camostudio | `maclib::camostudio::is_installed` | Return 0 if "Camo Studio" installed | implemented | team "Q248YREB53"; "zip" |
||| camostudio | `maclib::camostudio::installed_path` | Path to installed "Camo Studio" bundle | implemented | |
||| camostudio | `maclib::camostudio::install` | Download installer and install "Camo Studio" | implemented | requires root |
||| camostudio | `maclib::camostudio::update` | Update "Camo Studio" | implemented | no update path |
||| camostudio | `maclib::camostudio::uninstall` | Uninstall "Camo Studio" | implemented | no clean uninstall |

||| camunda | `maclib::camunda::suite_installer_url` | "Camunda Modeler" installer URL (Installomator) | implemented | team "3JVGD57JQZ"; "dmg" |
||| camunda | `maclib::camunda::latest_version` | "Camunda Modeler" current build | implemented | Installomator appNewVersion logic |
||| camunda | `maclib::camunda::is_installed` | Return 0 if "Camunda Modeler" installed | implemented | team "3JVGD57JQZ"; "dmg" |
||| camunda | `maclib::camunda::installed_path` | Path to installed "Camunda Modeler" bundle | implemented | |
||| camunda | `maclib::camunda::install` | Download installer and install "Camunda Modeler" | implemented | requires root |
||| camunda | `maclib::camunda::update` | Update "Camunda Modeler" | implemented | no update path |
||| camunda | `maclib::camunda::uninstall` | Uninstall "Camunda Modeler" | implemented | no clean uninstall |

||| canva | `maclib::canva::suite_installer_url` | "Canva" installer URL (Installomator) | implemented | team "5HD2ARTBFS"; "dmg" |
||| canva | `maclib::canva::latest_version` | "Canva" current build | implemented | Installomator appNewVersion logic |
||| canva | `maclib::canva::is_installed` | Return 0 if "Canva" installed | implemented | team "5HD2ARTBFS"; "dmg" |
||| canva | `maclib::canva::installed_path` | Path to installed "Canva" bundle | implemented | |
||| canva | `maclib::canva::install` | Download installer and install "Canva" | implemented | requires root |
||| canva | `maclib::canva::update` | Update "Canva" | implemented | no update path |
||| canva | `maclib::canva::uninstall` | Uninstall "Canva" | implemented | no clean uninstall |

||| carboncopycloner | `maclib::carboncopycloner::suite_installer_url` | "Carbon Copy Cloner" installer URL (Installomator) | implemented | team "L4F2DED5Q7"; "zip" |
||| carboncopycloner | `maclib::carboncopycloner::latest_version` | "Carbon Copy Cloner" current build | implemented | Installomator appNewVersion logic |
||| carboncopycloner | `maclib::carboncopycloner::is_installed` | Return 0 if "Carbon Copy Cloner" installed | implemented | team "L4F2DED5Q7"; "zip" |
||| carboncopycloner | `maclib::carboncopycloner::installed_path` | Path to installed "Carbon Copy Cloner" bundle | implemented | |
||| carboncopycloner | `maclib::carboncopycloner::install` | Download installer and install "Carbon Copy Cloner" | implemented | requires root |
||| carboncopycloner | `maclib::carboncopycloner::update` | Update "Carbon Copy Cloner" | implemented | no update path |
||| carboncopycloner | `maclib::carboncopycloner::uninstall` | Uninstall "Carbon Copy Cloner" | implemented | no clean uninstall |

||| cardpresso | `maclib::cardpresso::suite_installer_url` | "cardpresso" installer URL (Installomator) | implemented | team "QH48YJ244W"; "dmg" |
||| cardpresso | `maclib::cardpresso::latest_version` | "cardpresso" current build | implemented | Installomator appNewVersion logic |
||| cardpresso | `maclib::cardpresso::is_installed` | Return 0 if "cardpresso" installed | implemented | team "QH48YJ244W"; "dmg" |
||| cardpresso | `maclib::cardpresso::installed_path` | Path to installed "cardpresso" bundle | implemented | |
||| cardpresso | `maclib::cardpresso::install` | Download installer and install "cardpresso" | implemented | requires root |
||| cardpresso | `maclib::cardpresso::update` | Update "cardpresso" | implemented | no update path |
||| cardpresso | `maclib::cardpresso::uninstall` | Uninstall "cardpresso" | implemented | no clean uninstall |

||| catoclient | `maclib::catoclient::suite_installer_url` | "CatoClient" installer URL (Installomator) | implemented | team "CKGSB8CH43"; "pkg" |
||| catoclient | `maclib::catoclient::latest_version` | "CatoClient" current build | implemented | Installomator appNewVersion logic |
||| catoclient | `maclib::catoclient::is_installed` | Return 0 if "CatoClient" installed | implemented | team "CKGSB8CH43"; "pkg" |
||| catoclient | `maclib::catoclient::installed_path` | Path to installed "CatoClient" bundle | implemented | |
||| catoclient | `maclib::catoclient::install` | Download installer and install "CatoClient" | implemented | requires root |
||| catoclient | `maclib::catoclient::update` | Update "CatoClient" | implemented | no update path |
||| catoclient | `maclib::catoclient::uninstall` | Uninstall "CatoClient" | implemented | no clean uninstall |

||| charles | `maclib::charles::suite_installer_url` | "Charles" installer URL (Installomator) | implemented | team "9A5PCU4FSD"; "dmg" |
||| charles | `maclib::charles::latest_version` | "Charles" current build | implemented | Installomator appNewVersion logic |
||| charles | `maclib::charles::is_installed` | Return 0 if "Charles" installed | implemented | team "9A5PCU4FSD"; "dmg" |
||| charles | `maclib::charles::installed_path` | Path to installed "Charles" bundle | implemented | |
||| charles | `maclib::charles::install` | Download installer and install "Charles" | implemented | requires root |
||| charles | `maclib::charles::update` | Update "Charles" | implemented | no update path |
||| charles | `maclib::charles::uninstall` | Uninstall "Charles" | implemented | no clean uninstall |

||| chatwork | `maclib::chatwork::suite_installer_url` | "Chatwork" installer URL (Installomator) | implemented | team "H34A3H2Y54"; "dmg" |
||| chatwork | `maclib::chatwork::latest_version` | "Chatwork" current build | implemented | Installomator appNewVersion logic |
||| chatwork | `maclib::chatwork::is_installed` | Return 0 if "Chatwork" installed | implemented | team "H34A3H2Y54"; "dmg" |
||| chatwork | `maclib::chatwork::installed_path` | Path to installed "Chatwork" bundle | implemented | |
||| chatwork | `maclib::chatwork::install` | Download installer and install "Chatwork" | implemented | requires root |
||| chatwork | `maclib::chatwork::update` | Update "Chatwork" | implemented | no update path |
||| chatwork | `maclib::chatwork::uninstall` | Uninstall "Chatwork" | implemented | no clean uninstall |

||| chemdoodle2d | `maclib::chemdoodle2d::suite_installer_url` | "ChemDoodle" installer URL (Installomator) | implemented | team "9XP397UW95"; "dmg" |
||| chemdoodle2d | `maclib::chemdoodle2d::latest_version` | "ChemDoodle" current build | implemented | Installomator appNewVersion logic |
||| chemdoodle2d | `maclib::chemdoodle2d::is_installed` | Return 0 if "ChemDoodle" installed | implemented | team "9XP397UW95"; "dmg" |
||| chemdoodle2d | `maclib::chemdoodle2d::installed_path` | Path to installed "ChemDoodle" bundle | implemented | |
||| chemdoodle2d | `maclib::chemdoodle2d::install` | Download installer and install "ChemDoodle" | implemented | requires root |
||| chemdoodle2d | `maclib::chemdoodle2d::update` | Update "ChemDoodle" | implemented | no update path |
||| chemdoodle2d | `maclib::chemdoodle2d::uninstall` | Uninstall "ChemDoodle" | implemented | no clean uninstall |

||| chemdoodle3d | `maclib::chemdoodle3d::suite_installer_url` | "ChemDoodle3D" installer URL (Installomator) | implemented | team "9XP397UW95"; "dmg" |
||| chemdoodle3d | `maclib::chemdoodle3d::latest_version` | "ChemDoodle3D" current build | implemented | Installomator appNewVersion logic |
||| chemdoodle3d | `maclib::chemdoodle3d::is_installed` | Return 0 if "ChemDoodle3D" installed | implemented | team "9XP397UW95"; "dmg" |
||| chemdoodle3d | `maclib::chemdoodle3d::installed_path` | Path to installed "ChemDoodle3D" bundle | implemented | |
||| chemdoodle3d | `maclib::chemdoodle3d::install` | Download installer and install "ChemDoodle3D" | implemented | requires root |
||| chemdoodle3d | `maclib::chemdoodle3d::update` | Update "ChemDoodle3D" | implemented | no update path |
||| chemdoodle3d | `maclib::chemdoodle3d::uninstall` | Uninstall "ChemDoodle3D" | implemented | no clean uninstall |

||| cherryaudioblue3 | `maclib::cherryaudioblue3::suite_installer_url` | "Blue3 Organ" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioblue3 | `maclib::cherryaudioblue3::latest_version` | "Blue3 Organ" current build | implemented | Installomator appNewVersion logic |
||| cherryaudioblue3 | `maclib::cherryaudioblue3::is_installed` | Return 0 if "Blue3 Organ" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioblue3 | `maclib::cherryaudioblue3::installed_path` | Path to installed "Blue3 Organ" bundle | implemented | |
||| cherryaudioblue3 | `maclib::cherryaudioblue3::install` | Download installer and install "Blue3 Organ" | implemented | requires root |
||| cherryaudioblue3 | `maclib::cherryaudioblue3::update` | Update "Blue3 Organ" | implemented | no update path |
||| cherryaudioblue3 | `maclib::cherryaudioblue3::uninstall` | Uninstall "Blue3 Organ" | implemented | no clean uninstall |

||| cherryaudioca2600 | `maclib::cherryaudioca2600::suite_installer_url` | "CA2600" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioca2600 | `maclib::cherryaudioca2600::latest_version` | "CA2600" current build | implemented | Installomator appNewVersion logic |
||| cherryaudioca2600 | `maclib::cherryaudioca2600::is_installed` | Return 0 if "CA2600" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioca2600 | `maclib::cherryaudioca2600::installed_path` | Path to installed "CA2600" bundle | implemented | |
||| cherryaudioca2600 | `maclib::cherryaudioca2600::install` | Download installer and install "CA2600" | implemented | requires root |
||| cherryaudioca2600 | `maclib::cherryaudioca2600::update` | Update "CA2600" | implemented | no update path |
||| cherryaudioca2600 | `maclib::cherryaudioca2600::uninstall` | Uninstall "CA2600" | implemented | no clean uninstall |

||| cherryaudiochroma | `maclib::cherryaudiochroma::suite_installer_url` | "Chroma" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiochroma | `maclib::cherryaudiochroma::latest_version` | "Chroma" current build | implemented | Installomator appNewVersion logic |
||| cherryaudiochroma | `maclib::cherryaudiochroma::is_installed` | Return 0 if "Chroma" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiochroma | `maclib::cherryaudiochroma::installed_path` | Path to installed "Chroma" bundle | implemented | |
||| cherryaudiochroma | `maclib::cherryaudiochroma::install` | Download installer and install "Chroma" | implemented | requires root |
||| cherryaudiochroma | `maclib::cherryaudiochroma::update` | Update "Chroma" | implemented | no update path |
||| cherryaudiochroma | `maclib::cherryaudiochroma::uninstall` | Uninstall "Chroma" | implemented | no clean uninstall |

||| cherryaudiocr78 | `maclib::cherryaudiocr78::suite_installer_url` | "CR-78" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiocr78 | `maclib::cherryaudiocr78::latest_version` | "CR-78" current build | implemented | Installomator appNewVersion logic |
||| cherryaudiocr78 | `maclib::cherryaudiocr78::is_installed` | Return 0 if "CR-78" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiocr78 | `maclib::cherryaudiocr78::installed_path` | Path to installed "CR-78" bundle | implemented | |
||| cherryaudiocr78 | `maclib::cherryaudiocr78::install` | Download installer and install "CR-78" | implemented | requires root |
||| cherryaudiocr78 | `maclib::cherryaudiocr78::update` | Update "CR-78" | implemented | no update path |
||| cherryaudiocr78 | `maclib::cherryaudiocr78::uninstall` | Uninstall "CR-78" | implemented | no clean uninstall |

||| cherryaudiodco106 | `maclib::cherryaudiodco106::suite_installer_url` | "DCO-106" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiodco106 | `maclib::cherryaudiodco106::latest_version` | "DCO-106" current build | implemented | Installomator appNewVersion logic |
||| cherryaudiodco106 | `maclib::cherryaudiodco106::is_installed` | Return 0 if "DCO-106" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiodco106 | `maclib::cherryaudiodco106::installed_path` | Path to installed "DCO-106" bundle | implemented | |
||| cherryaudiodco106 | `maclib::cherryaudiodco106::install` | Download installer and install "DCO-106" | implemented | requires root |
||| cherryaudiodco106 | `maclib::cherryaudiodco106::update` | Update "DCO-106" | implemented | no update path |
||| cherryaudiodco106 | `maclib::cherryaudiodco106::uninstall` | Uninstall "DCO-106" | implemented | no clean uninstall |

||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::suite_installer_url` | "Dreamsynth" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::latest_version` | "Dreamsynth" current build | implemented | Installomator appNewVersion logic |
||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::is_installed` | Return 0 if "Dreamsynth" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::installed_path` | Path to installed "Dreamsynth" bundle | implemented | |
||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::install` | Download installer and install "Dreamsynth" | implemented | requires root |
||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::update` | Update "Dreamsynth" | implemented | no update path |
||| cherryaudiodreamsynth | `maclib::cherryaudiodreamsynth::uninstall` | Uninstall "Dreamsynth" | implemented | no clean uninstall |

||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::suite_installer_url` | "Eight Voice" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::latest_version` | "Eight Voice" current build | implemented | Installomator appNewVersion logic |
||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::is_installed` | Return 0 if "Eight Voice" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::installed_path` | Path to installed "Eight Voice" bundle | implemented | |
||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::install` | Download installer and install "Eight Voice" | implemented | requires root |
||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::update` | Update "Eight Voice" | implemented | no update path |
||| cherryaudioeightvoice | `maclib::cherryaudioeightvoice::uninstall` | Uninstall "Eight Voice" | implemented | no clean uninstall |

||| cherryaudioelkax | `maclib::cherryaudioelkax::suite_installer_url` | "Elka-X" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioelkax | `maclib::cherryaudioelkax::latest_version` | "Elka-X" current build | implemented | Installomator appNewVersion logic |
||| cherryaudioelkax | `maclib::cherryaudioelkax::is_installed` | Return 0 if "Elka-X" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudioelkax | `maclib::cherryaudioelkax::installed_path` | Path to installed "Elka-X" bundle | implemented | |
||| cherryaudioelkax | `maclib::cherryaudioelkax::install` | Download installer and install "Elka-X" | implemented | requires root |
||| cherryaudioelkax | `maclib::cherryaudioelkax::update` | Update "Elka-X" | implemented | no update path |
||| cherryaudioelkax | `maclib::cherryaudioelkax::uninstall` | Uninstall "Elka-X" | implemented | no clean uninstall |

||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::suite_installer_url` | "Galactic Reverb" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::latest_version` | "Galactic Reverb" current build | implemented | Installomator appNewVersion logic |
||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::is_installed` | Return 0 if "Galactic Reverb" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::installed_path` | Path to installed "Galactic Reverb" bundle | implemented | |
||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::install` | Download installer and install "Galactic Reverb" | implemented | requires root |
||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::update` | Update "Galactic Reverb" | implemented | no update path |
||| cherryaudiogalacticreverb | `maclib::cherryaudiogalacticreverb::uninstall` | Uninstall "Galactic Reverb" | implemented | no clean uninstall |

||| cherryaudiogx80 | `maclib::cherryaudiogx80::suite_installer_url` | "GX-80" installer URL (Installomator) | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiogx80 | `maclib::cherryaudiogx80::latest_version` | "GX-80" current build | implemented | Installomator appNewVersion logic |
||| cherryaudiogx80 | `maclib::cherryaudiogx80::is_installed` | Return 0 if "GX-80" installed | implemented | team "A2XFV22B2X"; "pkg" |
||| cherryaudiogx80 | `maclib::cherryaudiogx80::installed_path` | Path to installed "GX-80" bundle | implemented | |
||| cherryaudiogx80 | `maclib::cherryaudiogx80::install` | Download installer and install "GX-80" | implemented | requires root |
||| cherryaudiogx80 | `maclib::cherryaudiogx80::update` | Update "GX-80" | implemented | no update path |
||| cherryaudiogx80 | `maclib::cherryaudiogx80::uninstall` | Uninstall "GX-80" | implemented | no clean uninstall |

||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::suite_installer_url` | "Acronis Cyber Protect Connect" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::latest_version` | "Acronis Cyber Protect Connect" current build | implemented | Installomator appNewVersion logic |
||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::is_installed` | Return 0 if "Acronis Cyber Protect Connect" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::installed_path` | Path to installed "Acronis Cyber Protect Connect" bundle | implemented | |
||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::install` | Download installer and install "Acronis Cyber Protect Connect" | implemented | requires root; no vendor URL documented |
||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::update` | Update "Acronis Cyber Protect Connect" | implemented | no update path (re-run install) |
||| acroniscyberprotectconnect | `maclib::acroniscyberprotectconnect::uninstall` | Uninstall "Acronis Cyber Protect Connect" | implemented | no clean uninstall |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::suite_installer_url` | "Acronis Cyber Protect Connect Agent" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::latest_version` | "Acronis Cyber Protect Connect Agent" current build | implemented | Installomator appNewVersion logic |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::is_installed` | Return 0 if "Acronis Cyber Protect Connect Agent" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::installed_path` | Path to installed "Acronis Cyber Protect Connect Agent" bundle | implemented | |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::install` | Download installer and install "Acronis Cyber Protect Connect Agent" | implemented | requires root; no vendor URL documented |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::update` | Update "Acronis Cyber Protect Connect Agent" | implemented | no update path (re-run install) |
||| acroniscyberprotectconnectagent | `maclib::acroniscyberprotectconnectagent::uninstall` | Uninstall "Acronis Cyber Protect Connect Agent" | implemented | no clean uninstall |
||| adobebrackets | `maclib::adobebrackets::suite_installer_url` | "Brackets" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobebrackets | `maclib::adobebrackets::latest_version` | "Brackets" current build | implemented | Installomator appNewVersion logic |
||| adobebrackets | `maclib::adobebrackets::is_installed` | Return 0 if "Brackets" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobebrackets | `maclib::adobebrackets::installed_path` | Path to installed "Brackets" bundle | implemented | |
||| adobebrackets | `maclib::adobebrackets::install` | Download installer and install "Brackets" | implemented | requires root; no vendor URL documented |
||| adobebrackets | `maclib::adobebrackets::update` | Update "Brackets" | implemented | no update path (re-run install) |
||| adobebrackets | `maclib::adobebrackets::uninstall` | Uninstall "Brackets" | implemented | no clean uninstall |
||| adobereaderdc | `maclib::adobereaderdc::suite_installer_url` | "Adobe Acrobat Reader DC" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobereaderdc | `maclib::adobereaderdc::latest_version` | "Adobe Acrobat Reader DC" current build | implemented | Installomator appNewVersion logic |
||| adobereaderdc | `maclib::adobereaderdc::is_installed` | Return 0 if "Adobe Acrobat Reader DC" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobereaderdc | `maclib::adobereaderdc::installed_path` | Path to installed "Adobe Acrobat Reader DC" bundle | implemented | |
||| adobereaderdc | `maclib::adobereaderdc::install` | Download installer and install "Adobe Acrobat Reader DC" | implemented | requires root; no vendor URL documented |
||| adobereaderdc | `maclib::adobereaderdc::update` | Update "Adobe Acrobat Reader DC" | implemented | no update path (re-run install) |
||| adobereaderdc | `maclib::adobereaderdc::uninstall` | Uninstall "Adobe Acrobat Reader DC" | implemented | no clean uninstall |
||| adobereaderdc-install | `maclib::adobereaderdc-install::suite_installer_url` | "Adobe Acrobat Reader DC (install)" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobereaderdc-install | `maclib::adobereaderdc-install::latest_version` | "Adobe Acrobat Reader DC (install)" current build | implemented | Installomator appNewVersion logic |
||| adobereaderdc-install | `maclib::adobereaderdc-install::is_installed` | Return 0 if "Adobe Acrobat Reader DC (install)" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| adobereaderdc-install | `maclib::adobereaderdc-install::installed_path` | Path to installed "Adobe Acrobat Reader DC (install)" bundle | implemented | |
||| adobereaderdc-install | `maclib::adobereaderdc-install::install` | Download installer and install "Adobe Acrobat Reader DC (install)" | implemented | requires root; no vendor URL documented |
||| adobereaderdc-install | `maclib::adobereaderdc-install::update` | Update "Adobe Acrobat Reader DC (install)" | implemented | no update path (re-run install) |
||| adobereaderdc-install | `maclib::adobereaderdc-install::uninstall` | Uninstall "Adobe Acrobat Reader DC (install)" | implemented | no clean uninstall |
||| applesfsymbols | `maclib::applesfsymbols::suite_installer_url` | "Symbols" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| applesfsymbols | `maclib::applesfsymbols::latest_version` | "Symbols" current build | implemented | Installomator appNewVersion logic |
||| applesfsymbols | `maclib::applesfsymbols::is_installed` | Return 0 if "Symbols" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| applesfsymbols | `maclib::applesfsymbols::installed_path` | Path to installed "Symbols" bundle | implemented | |
||| applesfsymbols | `maclib::applesfsymbols::install` | Download installer and install "Symbols" | implemented | requires root; no vendor URL documented |
||| applesfsymbols | `maclib::applesfsymbols::update` | Update "Symbols" | implemented | no update path (re-run install) |
||| applesfsymbols | `maclib::applesfsymbols::uninstall` | Uninstall "Symbols" | implemented | no clean uninstall |
||| aspera | `maclib::aspera::suite_installer_url` | "Aspera" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| aspera | `maclib::aspera::latest_version` | "Aspera" current build | implemented | Installomator appNewVersion logic |
||| aspera | `maclib::aspera::is_installed` | Return 0 if "Aspera" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| aspera | `maclib::aspera::installed_path` | Path to installed "Aspera" bundle | implemented | |
||| aspera | `maclib::aspera::install` | Download installer and install "Aspera" | implemented | requires root; no vendor URL documented |
||| aspera | `maclib::aspera::update` | Update "Aspera" | implemented | no update path (re-run install) |
||| aspera | `maclib::aspera::uninstall` | Uninstall "Aspera" | implemented | no clean uninstall |
||| chemdoodle | `maclib::chemdoodle::suite_installer_url` | "ChemDoodle" installer URL (Installomator) | implemented | team "n/a"; "dmg"; no vendor URL |
||| chemdoodle | `maclib::chemdoodle::latest_version` | "ChemDoodle" current build | implemented | Installomator appNewVersion logic |
||| chemdoodle | `maclib::chemdoodle::is_installed` | Return 0 if "ChemDoodle" installed | implemented | team "n/a"; "dmg"; no vendor URL |
||| chemdoodle | `maclib::chemdoodle::installed_path` | Path to installed "ChemDoodle" bundle | implemented | |
||| chemdoodle | `maclib::chemdoodle::install` | Download installer and install "ChemDoodle" | implemented | requires root; no vendor URL documented |
||| chemdoodle | `maclib::chemdoodle::update` | Update "ChemDoodle" | implemented | no update path (re-run install) |
||| chemdoodle | `maclib::chemdoodle::uninstall` | Uninstall "ChemDoodle" | implemented | no clean uninstall |
