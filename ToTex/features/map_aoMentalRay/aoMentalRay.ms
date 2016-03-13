
m_IniPath = "$userScripts/totex/features/map_aoMentalRay/settings.ini"

featureObj = m_ToTex_Bake.GetFeatureByName "resolution"

samples = ((getinisetting m_IniPath "settings" "samples" ) as integer)
spread = ((getinisetting m_IniPath "settings" "spread" ) as integer)

--material
aoMaterial = standardmaterial()
aoMaterial.diffuseColor = color 255 255 255


polyObj = m_ToTex_Bake.m_Model.GetModel()
polyObj.material = aoMaterial

AO_MentalRay_Quality = "1"
if(AO_MentalRay_Quality != "")then(
	rpsTemppFilePath = (GetDir #userScripts+"\\ToTex\\features\\map_aoMentalRay\\rps\\ToTex_aoMentalRay_"+"Temp"+".rps")
	renderpresets.SaveAll 1 rpsTemppFilePath
	rpsFilePath = (GetDir #userScripts+"\\ToTex\\features\\map_aoMentalRay\\rps\\ToTex_aoMentalRay_"+(AO_MentalRay_Quality as string)+".rps")
	renderpresets.Loadall 1 rpsFilePath
)

tempMaterialArr = #()
if (m_ToTex_Bake.GetProjection() == true)then(
	ProjectionModifier = polyObj.modifiers[#Projection]
	if(ProjectionModifier != undefined)then(
		-- projection exsists
		--for each object you have for projection do
		projectionNodes = ProjectionModifier.geomNodes
		for _node in ProjectionModifier.geomNodes do
		(
			append tempMaterialArr _node.material
			_node.material = aoMaterial
		)
	)
)

dMap = Ambient_Occlusion()
dMap.filterOn = false
dMap.samples = samples
dMap.spread = spread

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "AOMentalRay"

-- Start The Baking
m_ToTex_Bake.Bake()

if(AO_LightTrace_Quality != "")then(
	rpsTemppFilePath = (GetDir #userScripts+"\\ToTex\\features\\map_aoMentalRay\\rps\\ToTex_aoMentalRay_"+"Temp"+".rps")
	renderpresets.LoadAll 1 rpsTemppFilePath
)

if (m_ToTex_Bake.GetProjection() == true)then(
	ProjectionModifier = polyObj.modifiers[#Projection]
	if(ProjectionModifier != undefined)then(
		-- projection exsists
		--for each object you have for projection do
		projectionNodes = ProjectionModifier.geomNodes
		for i = 1 to ProjectionModifier.geomNodes.count do
		(
			_node = ProjectionModifier.geomNodes[i]
			_node.material = tempMaterialArr[i]
		)
	)
)