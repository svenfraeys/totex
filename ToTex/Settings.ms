struct ToTex_Bake_Object(
	m_Model
)

struct ToTex_Settings(
	m_Ini,
	m_AutoUpdateIni,
	fn Initiate=(
		m_Ini = "$userScripts/ToTex/userData/Settings.ini"
		m_AutoUpdateIni = "$userScripts/ToTex/Settings.ini"
	),
	fn GetPadding=(
		return 5
	),
	fn GetEnableAccelerators=(
		iniVal = getinisetting m_Ini "settings" "EnableAccelerators"
		if(iniVal == "true")then(
			return true	
		)else(
			return false
		)
	),
	fn SetEnableAccelerators _value=(
		iniVal = setinisetting m_Ini "settings" "EnableAccelerators" (_value as string)
	),
	fn GetChannel=(
		iniVal = getinisetting m_Ini "settings" "channel"
		if(iniVal == "")then(
			return 1	
		)else(
			return (iniVal as integer)
		)
		
	),
	fn SetChannel _value=(
		setinisetting m_Ini "settings" "channel" (_value as string)
	),
	fn GetPadding=(
		return 20
	),
	fn GetProjection=(
		return false
	),
	fn GetPreviewRender=(
		iniVal = getinisetting m_Ini "settings" "previewRender"
		if(iniVal == "true")then(
			return true	
		)else(
			return false
		)
	),
	fn SetPreviewRender _state=(
		setinisetting m_Ini "settings" "previewRender" (_state as string)
	),
	fn GetTextureWidth=(
		iniVal = getinisetting m_Ini "settings" "textureWidth"
		if(iniVal == "")then(
			return 256
		)else(
			return (iniVal as integer)
		)
	),
	fn SetTextureWidth _value=(
		setinisetting m_Ini "settings" "textureWidth" (_value as string)
		
	),
	fn GetTextureHeight=(
		iniVal = getinisetting m_Ini "settings" "textureHeight"
		if(iniVal == "")then(
			return 256
		)else(
			return (iniVal as integer)
		)
	),
	fn SetMapView _value=(
		setinisetting m_AutoUpdateIni "settings" "MapView" (_value as string)
	),
	fn GetMapView=(
		getinisetting m_AutoUpdateIni "settings" "MapView"
	),
	fn SetAutoUpdate _value=(
		setinisetting m_AutoUpdateIni "settings" "AutoUpdate" (_value as string)
	),
	fn GetAutoUpdate =(
		
		if((getinisetting m_AutoUpdateIni "settings" "AutoUpdate") == "true")then(
			return true
		)else(
			return false
		)
	),
	fn SetTextureHeight _value=(
		setinisetting m_Ini "settings" "textureHeight" (_value as string)
		
	),
	
	fn SetTextureSize _value=(
		SetTextureHeight _value
		SetTextureWidth _value
	),
	fn GetTextureSize =(
		GetTextureHeight()
	),
	fn GetRenderTimeline=(
		return true
	),
	fn GetFileType=(
		return ".png"
	),
	fn GetSaveRenderPath=(
		rp = getinisetting m_Ini "settings" "renderPath"
		return rp
-- 		imagesFolder = (symbolicPaths.getPathValue("$images")+"\\")
-- 		return imagesFolder
	),
	fn SetSaveRenderPath _path=(
		setinisetting m_Ini "settings" "renderPath" _path
	),
	fn GetSettingsURLPath=(
		userScriptsPath = (symbolicPaths.getPathValue("$userScripts")+"\\")
		return (userScriptsPath+ "ToTex\\Settings\\Settings.html")
	)
)
m_ToTex_Settings = ToTex_Settings()
m_ToTex_Settings.Initiate()