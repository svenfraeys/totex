iniPath = "$userScripts/totex/features/map_aoLightTrace/settings.ini"


-- Get The Model
polyObj = m_ToTex_Bake.m_Model.GetModel()
-- polyObj = $Teapot01

-- Settings
AO_LightTrace_Bool_GroundPlane = (getinisetting iniPath "settings" "groundPlane")
AO_LightTrace_Bool_WhiteMaterial = (getinisetting iniPath "settings" "whiteMaterial")
AO_LightTrace_Quality = getinisetting iniPath "settings" "quality"


-- Materials
aoMaterial = standardmaterial()
aoMaterial.diffuseColor = color 255 255 255

aoPlaneMaterial = standardmaterial()
aoPlaneMaterial.diffuseColor = color 255 255 255



if(AO_LightTrace_Quality != "")then(
	rpsTemppFilePath = (GetDir #userScripts+"\\ToTex\\features\\map_aoLightTrace\\rps\\ToTex_aoLightTrace_"+"Temp"+".rps")
	renderpresets.SaveAll 1 rpsTemppFilePath
	rpsFilePath = (GetDir #userScripts+"\\ToTex\\features\\map_aoLightTrace\\rps\\ToTex_aoLightTrace_"+(AO_LightTrace_Quality as string)+".rps")
	renderpresets.Loadall 1 rpsFilePath
)


-- Create Groundplane
mesh_plane
if(AO_LightTrace_Bool_GroundPlane == "true")then(
	
	bb= nodeLocalBoundingBox polyObj
	width = bb[1][2] - bb[2][2]
	height = bb[1][1] - bb[2][1]
	mesh_plane = plane()	
	mesh_plane.name = "ToTex_BakePlane"
	mesh_plane.pos = [polyObj.pos[1], polyObj.pos[2], 0]
	mesh_plane.length = width * 2
	mesh_plane.width = height * 2
	mesh_plane.material = aoPlaneMaterial
)


-- Creating Light
AO_LightTrace_SkyLight = skylight()

if(AO_LightTrace_Bool_WhiteMaterial == "true")then(
	polyObj.material = aoMaterial	
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


dMap = CompleteMap()
dMap.filterOn = false
dMap.enabled = true
dMap.shadowsOn = true
dMap.enabled = true


-- Apply Defaults
m_ToTex_Bake.AddMap dMap "AOLightTrace"
m_ToTex_Bake.Bake()


-- reset rps
if(AO_LightTrace_Quality != "")then(
	rpsTemppFilePath = (GetDir #userScripts+"\\ToTex\\features\\map_aoLightTrace\\rps\\ToTex_aoLightTrace_"+"Temp"+".rps")
	renderpresets.LoadAll 1 rpsTemppFilePath
)

-- Removing all objects
try(delete mesh_plane)catch()
try(delete AO_LightTrace_SkyLight)catch()

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
