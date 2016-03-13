
m_IniPath = "$userScripts/totex/features/map_blend/settings.ini"
fn GetIniBoolean _name=(
	if((getinisetting m_IniPath "settings" _name) == "true")then(
		return true
	)else(
		return false
	)
)

polyObj = m_ToTex_Bake.m_Model.GetModel()

dMap = BlendMap()
dMap.filterOn = false
dMap.enabled = true

dMap.lightingOn = GetIniBoolean "lighting"
dMap.shadowsOn =GetIniBoolean "shadows"
dMap.diffuseOn =  GetIniBoolean "diffuse"
dMap.ambientOn = GetIniBoolean "ambient"
dMap.specularOn = GetIniBoolean "specular"
dMap.emissionOn = GetIniBoolean "emission"
dMap.reflectionOn = GetIniBoolean "reflection"
dMap.refractionOn = GetIniBoolean "refraction"

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Blend"

-- Start The Baking
m_ToTex_Bake.Bake()


