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
