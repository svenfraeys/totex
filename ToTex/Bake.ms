global m_ToTex_Bake
struct ToTex_Bake(
	m_This,
	m_Model,
	m_Feature,
	m_Features_ConfigurationArr,
	m_Selection,
	m_Texture_Width,
	m_Texture_Height,
	m_Projection,
	m_Padding,
	m_RenderTotalTimeline,
	m_SaveImagePathArr,
	fn SetTextureHeight _size=(
		m_Texture_Height = _size
	),
	fn SetTextureWidth _size=(
		m_Texture_Width = _size
	),
	fn GetTextureHeight=(
		return m_Texture_Height
	),
	fn GetTextureWidth=(
		return m_Texture_Width
	),
	fn SetProjection _state=(
		
		m_Projection = _state
	),
	fn GetProjection=(
		return m_Projection
	),
	fn SetPadding _padding=(
		m_Padding = _padding
	),
	fn SetRenderTotalTimeline _value=(
		m_RenderTotalTimeline = _value
	),
	fn GetFeatureByName _nameStr=(
		if(m_Feature.GetName() == _nameStr)then(
			return m_Feature
		)
		for featureObj in m_Features_ConfigurationArr do(
			if(featureObj.GetName() == _nameStr)then(
				return m_Feature
			)
		)
		return undefined
	),
	
	fn GetModel=(
		return m_Model
	),
	fn GetFeature=(
		return m_Feature
	),
	fn GetSaveImagePathArr=(
		return m_SaveImagePathArr
	),
	fn Initiate _this _model _feature _configurationArr=(
		
		
		m_This = _this
		m_Model = _model
		m_Feature = _feature
		m_Features_ConfigurationArr = _configurationArr
		m_Texture_Width = m_ToTex_Settings.GetTextureWidth()
		m_Texture_Height = m_ToTex_Settings.GetTextureHeight()
		m_Padding = m_Texture_Width
		m_Projection = false
		m_RenderTotalTimeline = false
		m_SaveImagePathArr = #()
	),
	fn RemoveAllMaps=(
		m_Model.m_Model.INodeBakeProperties.removeAllBakeElements()
	),
	fn AddMap _BakeMap _mapName=(
		--ToTex Settings
		m_Texture_Width
		m_Texture_Height
		
		renderTimeline = m_RenderTotalTimeline
		fileType = m_ToTex_Settings.GetFileType()
		saveRenderPath = m_ToTex_Settings.GetSaveRenderPath()
		
		--Model Settings
		modelPoly = m_Model.GetModel()
		polyName = m_Model.GetName()
		
		
		if(_BakeMap != undefined)then(
			_BakeMap.outputSzX = m_Texture_Width
			_BakeMap.outputSzY = m_Texture_Height
		)
		saveFilePath = ""
		
		if(renderTimeline == true)then(
			timeStr = (slidertime as string)
			timeNumber = substring timeStr 1 (timeStr.count-1)
			saveFilePath  = saveRenderPath+(polyName + "_" +_mapName)+"_"+timeNumber+fileType
		)else
		(
			saveFilePath = saveRenderPath+(polyName + "_" +_mapName)+fileType	
		)
		
		if(_BakeMap != undefined)then(
			_BakeMap.fileType = saveFilePath
			_BakeMap.fileName = saveFilePath
			modelPoly.INodeBakeProperties.addBakeElement _BakeMap
		)
		append m_SaveImagePathArr saveFilePath
		return saveFilePath
		
	),
	fn BakeHeader=(
		m_Selection =( selection as array)
		m_Model.BakeState()
		
		for configuration in m_Features_ConfigurationArr do(
			configuration.FileInMsHeader()
		)
	),
	fn BakeFooter=(
		for configuration in m_Features_ConfigurationArr do(
			configuration.FileInMsFooter()
		)
		select m_Selection
		m_Model.NoBakeState()
	),
	fn Bake=(
		modelPoly = m_Model.GetModel()
		previewRender = m_ToTex_Settings.GetPreviewRender()
		textureWidth = m_Texture_Width
		textureHeight = m_Texture_Height
		
		-- Applying the Configuration
		
		for configuration in m_Features_ConfigurationArr do(
			configuration.FileInMs()
		)
		
		-- Baking
		select modelPoly
		macros.run "Render" "BakeDialog"
		wascancelled = false
		result = render renderType:#bakeSelected vfb:previewRender progressBar:true outputSize:[textureWidth,textureHeight ] cancelled:&wascancelled
		try(destroyDialog gTextureBakeDialog)catch()
	),
	fn SetChannel _channel=(
		m_Model.m_Model.INodeBakeProperties.bakeChannel = _channel
	),
	fn ApplyParametersOnModel _model=(
		modelPoly = _model
		modelPoly.INodeBakeProperties.removeAllBakeElements()
		
		modelPoly.INodeBakeProperties.bakeEnabled = true
		modelPoly.INodeBakeProperties.bakeChannel = m_ToTex_Settings.GetChannel()
		modelPoly.INodeBakeProperties.nDilations = m_Padding
		modelPoly.INodeBakeProjProperties.enabled = m_Projection
	),
	fn StartBake=(
		
		-- define for remaking
		global m_ToTex_Bake = m_This
		
		BakeHeader()

		--applying settings overall world
		enableAccelerators = m_ToTex_Settings.GetEnableAccelerators()
		
		
		--applying settings to poly model
		modelPoly = (m_Model.GetModel())
		ApplyParametersOnModel modelPoly
		
		--Adding the wanted maps from the features
		if(m_RenderTotalTimeline)then(
			for t = animationrange.start to animationrange.end do
			(
				modelPoly.INodeBakeProperties.removeAllBakeElements()
				sliderTime = t
				m_Feature.FileInMs()
			)	
		)else(
			modelPoly.INodeBakeProperties.removeAllBakeElements()
			m_Feature.FileInMs()
		)
		
		
		
		
		
		
		
		-- End Baking
-- 		modelPoly.INodeBakeProperties.removeAllBakeElements()	
		
		BakeFooter()
	)
)

