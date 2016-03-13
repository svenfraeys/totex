
m_IniPath = "$userScripts/totex/features/config_padding/settings.ini"

paddingValue = ((getinisetting m_IniPath "settings" "padding" ) as integer)

m_ToTex_Bake.SetPadding paddingValue