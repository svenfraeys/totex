struct ToTex_Feature(
	m_PathDirectory,
	m_Ini,
	fn FileInMsLabel=(),
	fn GetMore=(
		moreValue = getinisetting m_Ini "totex" "more"
		if(moreValue == "")then(
			return ""
		)else(
			return (m_PathDirectory + moreValue)
		)
	),
	fn GetLabel scriptLabel:true=(
		returnValue
		
		resLabel = undefined
		if(scriptLabel)then(
			resLabel = FileInMsLabel()	
		)
		
		if(resLabel == undefined)then(
			returnValue = getinisetting m_Ini "totex" "label"	
			return returnValue
		)
		returnValue = resLabel
		return returnValue
		
	),
	fn GetName=(
		getinisetting m_Ini "totex" "name"
	),
	fn GetType=(
		getinisetting m_Ini "totex" "type"
	),
	fn GetMs=(
		getinisetting m_Ini "totex" "ms"
	),
	fn GetMsFooter=(
		getinisetting m_Ini "totex" "ms_footer"
	),
	fn GetMsHeader=(
		getinisetting m_Ini "totex" "ms_header"
	),
	fn GetMsLabel=(
		getinisetting m_Ini "totex" "ms_label"
	),
	fn GetVisible=(
		return (getinisetting "$userScripts/ToTex/userData/UI_State.ini" "visible" (GetName()))
	),
	fn GetPathDirectory=(
		return m_PathDirectory
	),
	fn Initiate _pathDirectory=(
		m_PathDirectory = _pathDirectory
		m_Ini = m_PathDirectory+"settings.ini"
		
		
		if((getfiles m_Ini).count == 0)then(
			return false
		)else(
			return true
		)
	),
	fn FileInMsLabel=(
		pathMs = m_PathDirectory+(GetMsLabel())
		if((getfiles pathMs).count != 0)then(
			label_returnValue
			filein (pathMs)
			return label_returnValue
		)
		return undefined
	),
	fn FileInMsFooter=(
		pathMs = m_PathDirectory+(GetMsFooter())
		if((getfiles pathMs).count != 0)then(
			filein (pathMs)
		)
	),
	fn FileInMsHeader=(
		pathMs = m_PathDirectory+(GetMsHeader())
		if((getfiles pathMs).count != 0)then(
			filein (pathMs)
		)
		
	),
	fn GetThumb=(
		getinisetting m_Ini "totex" "thumb"
	),
	fn GetThumbPath=(
		iniThumb = GetThumb()
		if(iniThumb == "")then(
			return ""
		)
		
		thumbPath = m_PathDirectory+(iniThumb)
		return thumbPath
	),
	fn GetDescription=(
		getinisetting m_Ini "totex" "description"
	),
	fn FileInMs=(
		pathMs = m_PathDirectory+(GetMs())
		if((getfiles pathMs).count != 0)then(
			filein (pathMs)
		)
	)
)

struct ToTex_Features(
	m_FeaturesIni,
	m_FeaturesPath,
	m_FeaturesArr,
	function Initiate=(
		m_FeaturesArr = #()
		m_FeaturesPath = "$userScripts/ToTex/features/*"
		m_FeaturesIni = "$userScripts/ToTex/features/features.ini"
	),
	function GetFeatureByLabel _label scriptLabel:true=(
		for feature in m_FeaturesArr do(
			f_name = feature.GetLabel scriptLabel:scriptLabel
			if(f_name == _label )then(
				return feature
			)
		)
		return undefined
	),
	function GetFeatureByName _name=(
		for feature in m_FeaturesArr do(
			f_name = feature.GetName()
			if(f_name == _name )then(
				return feature
			)
		)
		return undefined
	),
	function AddFeatureToCore _feature=(
		feature = _feature
		
		FeatureName = feature.GetName()
		
		setinisetting m_FeaturesIni FeatureName "exists" "1"
		setinisetting m_FeaturesIni FeatureName "enable" "1"
		append m_FeaturesArr feature
	),
	function AddFeature _pathDirectory=(
		totexFeature = ToTex_Feature()
		res = totexFeature.initiate(_pathDirectory)
		if(res)then(
			AddFeatureToCore totexFeature	
		)
	),
	function ReadFeatures=(
		directoryArr = getDirectories(m_FeaturesPath)
		
		for dir in directoryArr do(
			AddFeature dir
		)
	),
	function GetFeatures filter:#("all")=(
		
		
		if (findItem filter "all" != 0)then(
			return m_FeaturesArr	
		)
		
		if (findItem filter "map" != 0)then(
			returnArr = #()
			for feature in m_FeaturesArr do(
				if((feature.GetType()) == "map")then(
					if (findItem filter "visible" != 0)then(
						if(feature.GetVisible() == "true")then(
							append returnArr feature	
						)
					)else(
						append returnArr feature
					)
				)
			)
			return returnArr
		)
		if (findItem filter "configuration" != 0)then(
			returnArr = #()
			for feature in m_FeaturesArr do(
				if((feature.GetType()) == "configuration")then(
					if (findItem filter "visible" != 0)then(
						if(feature.GetVisible() == "true")then(
							append returnArr feature	
						)
					)else(
						append returnArr feature
					)
				)
			)
			return returnArr
		)
		return #()
	)
)
m_ToTex_Features = ToTex_Features()
m_ToTex_Features.Initiate()
m_ToTex_Features.ReadFeatures()