-- Test
iniPath = "$userScripts/totex/features/config_resolution/settings.ini"

widthStr = (getinisetting iniPath "settings" "width" )
heightStr = (getinisetting iniPath "settings" "height" )

label_returnValue = widthStr + " x " + heightStr
-- return true
