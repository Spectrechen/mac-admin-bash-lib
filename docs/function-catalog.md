# Function Catalog

| Category | Function | Description | Status | Notes |
|---|---|---|---|---|
| logging | `maclib::log::set_level` | Set global log level | implemented | debug/info/warn/error |
| logging | `maclib::log::{debug,info,warn,error}` | Log messages | implemented | warn/error -> stderr |
| os | `maclib::os::is_macos` | Check if running on macOS | implemented | |
| os | `maclib::os::version` | macOS product version | implemented | uses sw_vers |
| os | `maclib::os::major_minor` | Major.Minor version | implemented | |
| os | `maclib::os::arch` | CPU architecture | implemented | uname -m |
