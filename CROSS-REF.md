# macAdmin Library - Cross-Reference Map

Total .sh files: 179
Modules defining maclib functions: 175
Total maclib functions defined: 1191

## Dependency Summary

- **171 of 175 app modules** reference ONLY `maclib::log::<name>()` — they are self-contained leaf modules that only use the logging helper.
- Some app modules also call core helpers: os, security

## Core Module Dependencies

- `lib/app.sh` calls: log
- `lib/filevault.sh` calls: 
- `lib/jamf.sh` calls: security
- `lib/keychain.sh` calls: log
- `lib/launchd.sh` calls: log
- `lib/log.sh` calls: 
- `lib/management.sh` calls: log
- `lib/network.sh` calls: log
- `lib/office.sh` calls: log
- `lib/os.sh` calls: 
- `lib/packages.sh` calls: log
- `lib/security.sh` calls: 
- `lib/signing.sh` calls: log
- `lib/system.sh` calls: 
- `lib/user.sh` calls: os

## All Defined Functions by Core Module

### lib/app.sh
- `maclib::app::install`
- `maclib::app::is_installed`
- `maclib::app::locations`
- `maclib::app::path`
- `maclib::app::uninstall`

### lib/filevault.sh
- `maclib::filevault::disable`
- `maclib::filevault::enable`
- `maclib::filevault::fdestatus`
- `maclib::filevault::is_enabled`

### lib/jamf.sh
- `maclib::jamf::battery_charge_percent`
- `maclib::jamf::battery_cycle_count`
- `maclib::jamf::charger_wattage`
- `maclib::jamf::homebrew_outdated_formulae`
- `maclib::jamf::security_chip`
- `maclib::jamf::startup_volume_name`
- `maclib::jamf::system_extensions`
- `maclib::jamf::third_party_kexts`
- `maclib::jamf::time_machine_autobackup`
- `maclib::jamf::uptime_seconds`
- `maclib::jamf::xcode_clt_state`

### lib/keychain.sh
- `maclib::keychain::add`
- `maclib::keychain::delete`
- `maclib::keychain::exists`
- `maclib::keychain::has_entry`

### lib/launchd.sh
- `maclib::launchd::is_loaded`
- `maclib::launchd::load`
- `maclib::launchd::reload`
- `maclib::launchd::state`
- `maclib::launchd::unload`

### lib/log.sh
- `maclib::log::_emit`
- `maclib::log::_ts`
- `maclib::log::debug`
- `maclib::log::error`
- `maclib::log::info`
- `maclib::log::is_tty`
- `maclib::log::set_level`
- `maclib::log::warn`

### lib/management.sh
- `maclib::management::install_profile`
- `maclib::management::is_managed`
- `maclib::management::list_profiles`
- `maclib::management::mdmstatus`
- `maclib::management::remove_profile`
- `maclib::management::server_url`

### lib/network.sh
- `maclib::network::fqdn`
- `maclib::network::hostname`
- `maclib::network::primary_ip`
- `maclib::network::primary_service`
- `maclib::network::set_hostname`

### lib/office.sh
- `maclib::office::install`
- `maclib::office::installed_path`
- `maclib::office::is_installed`
- `maclib::office::latest_version`
- `maclib::office::suite_installer_url`
- `maclib::office::update`

### lib/os.sh
- `maclib::os::arch`
- `maclib::os::is_macos`
- `maclib::os::major_minor`
- `maclib::os::version`

### lib/packages.sh
- `maclib::packages::pkg_files`
- `maclib::packages::pkg_forget`
- `maclib::packages::pkg_info`
- `maclib::packages::pkg_install`
- `maclib::packages::pkg_list`
- `maclib::packages::pkg_receipts`

### lib/security.sh
- `maclib::security::audit`
- `maclib::security::fail`
- `maclib::security::firewall_state`
- `maclib::security::gatekeeper_state`
- `maclib::security::is_application_firewall_enabled`
- `maclib::security::is_gatekeeper_enforced`
- `maclib::security::is_ssh_disabled`
- `maclib::security::pass`
- `maclib::security::remediate_firewall`
- `maclib::security::remediate_gatekeeper`
- `maclib::security::remediate_ssh`
- `maclib::security::report`
- `maclib::security::reset`
- `maclib::security::warn`

### lib/signing.sh
- `maclib::signing::codesign`
- `maclib::signing::identity`
- `maclib::signing::notarize`
- `maclib::signing::notarize_preflight`
- `maclib::signing::notarize_staple`
- `maclib::signing::verify`

### lib/system.sh
- `maclib::system::is_sip_active`
- `maclib::system::sip_status`
- `maclib::system::softwareupdate`
- `maclib::system::softwareupdate_check`
- `maclib::system::softwareupdate_download`
- `maclib::system::softwareupdate_install`
- `maclib::system::system_profiler`

### lib/user.sh
- `maclib::user::current_user`
- `maclib::user::home_dir`
- `maclib::user::home_dir_full`
- `maclib::user::is_root`
- `maclib::user::whoami`

