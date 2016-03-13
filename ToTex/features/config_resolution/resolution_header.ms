m_IniPath = "$userScripts/totex/features/config_resolution/settings.ini"

featureObj = m_ToTex_Bake.GetFeatureByName "resolution"

widthValue = ((getinisetting m_IniPath "settings" "width" ) as integer)
heightValue= ((getinisetting m_IniPath "settings" "height" ) as integer)

m_ToTex_Bake.SetTextureWidth widthValue
m_ToTex_Bake.SetTextureHeight heightValue
