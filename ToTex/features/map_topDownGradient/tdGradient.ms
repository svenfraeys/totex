
fn MakeTopDownGradient _polyObj _bakeToChannel=(
	bakeToChannel = _bakeToChannel
	polyObj = _polyObj
	select polyObj
	ChannelInfo.dialog()
	try(
	ChannelInfo.CopyChannel polyObj 3 bakeToChannel
	ChannelInfo.PasteChannel polyObj 3 2
	)catch(
		
	)

	--Adding Correct Modifier
	max modify mode
	gradientUVWMod = unwrap_UVW()
	gradientUVWMod.setMapChannel 1
	addModifier polyObj gradientUVWMod
	gradientUVWMod.setTVSubObjectMode 3
	actionMan.executeAction 0 "40021"  -- Selection: Select All
	gradientUVWMod.mappingMode 2
	
	gradientUVWMod.mappingFit()

	--Map
	gradMap = Gradient()

	invertBool = true
		
	if(invertBool == true)then(
	gradMap.color1 = color 255 255 255
	gradMap.color3 = color 0 0 0
	)

	mat = standardMaterial()
	
	mat.diffuseMap = gradMap
	mat.showInViewport = true
	polyObj.material = mat
)

-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()

MakeTopDownGradient polyObj (m_ToTex_Settings.GetChannel())

-- map and bake
dMap = DiffuseMap()
dMap.filterOn = false
dMap.shadowsOn = false
dMap.lightingOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "TopDownGradient"

-- Start The Baking
m_ToTex_Bake.SetChannel 2
m_ToTex_Bake.Bake()



ChannelInfo.closeDialog()