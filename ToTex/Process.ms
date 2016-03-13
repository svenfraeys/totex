struct ToTex_Process_System(
	m_ToTexBakeArr,
	fn Initiate=(
		m_ToTexBakeArr = #() 
	),
	fn CheckModel _obj=(
		
		if(superclassof (_obj.GetModel()) == GeometryClass)then(
			return true
		)else(
			return false
		)
		
	),
	fn ModelArrCheck _modelsArr=(
		for obj in _modelsArr do(
			res = CheckModel obj
			if(res == false)then(
				
				return false
				
			)
		)
		
		return true
	),
	fn Process _modelsArr _featuresArr =(
		max modify mode
		-- Creating All Bake Objects
		res = ModelArrCheck _modelsArr
		if(res == false)then(
			return false
		)
		m_ToTexBakeArr = #() 
		
		-- Filtering the configurations
		configurationArr = #()
		mapArr = #()
		
		for feature in _featuresArr do(
			if(feature.GetType() == "configuration")then(
				append configurationArr feature
			)
			if(feature.GetType() == "map")then(
				append mapArr feature
			)
		)
		
		
		for model in _modelsArr do(
			for feature in mapArr do(
				bakeObj = ToTex_Bake()
				bakeObj.Initiate bakeObj model feature configurationArr
				append m_ToTexBakeArr bakeObj
			)
		)
		
		for bakeObj in m_ToTexBakeArr do(
			bakeObj.StartBake()
		)
	)
)
m_ToTex_Process_System = ToTex_Process_System()
m_ToTex_Process_System.Initiate()

-- m_ToTex_Process_System.Process (m_Totex_Model_System.MakeToTexModelArr selection) #(m_ToTex_Features.GetFeatureByName "diffuse")