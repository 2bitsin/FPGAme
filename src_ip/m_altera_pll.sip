set_global_assignment -entity "m_altera_pll" -library "lib_m_altera_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "m_altera_pll" -library "lib_m_altera_pll" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "m_altera_pll" -library "lib_m_altera_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_m_altera_pll" -name SPD_FILE [file join $::quartus(sip_path) "m_altera_pll.spd"]

set_global_assignment -library "lib_m_altera_pll" -name MISC_FILE [file join $::quartus(sip_path) "m_altera_pll_sim/m_altera_pll.vo"]
