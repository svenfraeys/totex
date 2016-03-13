-- Test
iniPath = "$userScripts/totex/features/config_padding/settings.ini"

padStr = (getinisetting iniPath "settings" "padding" )
label_returnValue = "Padding ("+padStr+")"
-- return true