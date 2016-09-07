## Pre-defined Variables
```bash
-----------lib use only--------
CURRENT_SCRIPT : /<PATH>/os_preparation/start.sh
CURRENT_FOLDER : /<PATH>/os_preparation
FUNCTIONS      : /<PATH>/os_preparation/functions
LIB            : /<PATH>/os_preparation/lib

-----------function use only--------
TEMPLATES      : /<PATH>/os_preparation/templates
TMP            : /<PATH>/os_preparation/tmp
CONFIG_FOLDER  : /<PATH>/os_preparation/templates/<FUNCTION_NAME>

-----------function use only - predefined vars--------
FIRST_ARGV     : [ -i | -a ]
ALL_ARGVS      : <FUNCTION_NAMES>
```

```bash
# ./start.sh -i F_00_echo_path
==============================
        F_00_echo_path
==============================
-----------lib use only--------
CURRENT_SCRIPT : /root/os_preparation/start.sh
CURRENT_FOLDER : /root/os_preparation
FUNCTIONS      : /root/os_preparation/functions
LIB            : /root/os_preparation/lib

-----------function use only--------
TEMPLATES      : /root/os_preparation/templates
TMP            : /root/os_preparation/tmp
CONFIG_FOLDER  : /root/os_preparation/templates/F_00_echo_path

-----------function use only - predefined vars--------
FIRST_ARGV     : -i
ALL_ARGVS      : F_00_echo_path
```

