
m_IniPath = "$userScripts/totex/features/config_renderPreset/settings.ini"

rpsDirectory = "$userScripts/totex/features/config_RenderPreset/rps/"

rpsStr = (getinisetting m_IniPath "settings" "rps")

rpsPath = rpsDirectory+rpsStr

tempRpsPath = rpsDirectory+"temp.rps"

renderpresets.SaveAll 1 tempRpsPath
renderpresets.Loadall 1 rpsPath
