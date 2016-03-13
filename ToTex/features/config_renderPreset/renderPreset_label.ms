-- Test
iniPath = "$userScripts/totex/features/config_renderPreset/settings.ini"

rpsStr = (getinisetting iniPath "settings" "rps")
if(rpsStr != "")then(
	label_returnValue = rpsStr
)else(
	label_returnValue = "Render Preset"
)

-- return true