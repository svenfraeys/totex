
m_IniPath = "$userScripts/totex/features/map_normal/settings.ini"
-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()


dMap = NormalsMap()
dMap.filterOn = false
dMap.enabled = true

-- Adjusting Object Parametres
polyObj.INodeBakeProjProperties.normalSpace = #world

flipGreenValueStr = getinisetting m_IniPath "settings" "flipGreen" 
if(flipGreenValueStr == "true")then(
	polyObj.INodeBakeProjProperties.tangentYDir = #Y_Up
)else(
	polyObj.INodeBakeProjProperties.tangentYDir = #Y_Down
)

flipRedValueStr = getinisetting m_IniPath "settings" "flipRed" 
if(flipRedValueStr == "true")then(
	polyObj.INodeBakeProjProperties.tangentXDir = #X_Left
)else(
	polyObj.INodeBakeProjProperties.tangentXDir = #X_Right
)


-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Normal"

-- Start The Baking
m_ToTex_Bake.Bake()