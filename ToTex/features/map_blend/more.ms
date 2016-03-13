rollout Blend_More_Rollout "Blend"(
	local m_IniPath = "$userScripts/totex/features/map_blend/settings.ini"
	checkbox checkbox_Lighting "Lighting"
	checkbox checkbox_Shadows "Shadows"
	checkbox checkbox_Diffuse "Diffuse"
	checkbox checkbox_Ambient "Ambient"
	checkbox checkbox_Specular "Specular"
	checkbox checkbox_Emission "Emission"
	checkbox checkbox_Reflection "Reflection"
	checkbox checkbox_Refraction "Refraction"
	label l1
	button btn_Close "Close" width:100 height:30
	
	fn GetIniBoolean _name=(
		if((getinisetting m_IniPath "settings" _name) == "true")then(
			return true
		)else(
			return false
		)
	)
	
	fn SetIniBoolean _name _bool=(
		setinisetting m_IniPath "settings" _name (_bool as string)
	)
	
	on Blend_More_Rollout open do(
		
		checkbox_Lighting.checked = GetIniBoolean "lighting"
		checkbox_Shadows.checked = GetIniBoolean "shadows"
		checkbox_Diffuse.checked = GetIniBoolean "diffuse"
		checkbox_Ambient.checked = GetIniBoolean "ambient"
		checkbox_Specular.checked = GetIniBoolean "specular"
		checkbox_Emission.checked = GetIniBoolean "emission"
		checkbox_Reflection.checked = GetIniBoolean "reflection"
		checkbox_Refraction.checked = GetIniBoolean "refraction"
		
		
	)
	
	on Blend_More_Rollout close do(
		SetIniBoolean "lighting" checkbox_Lighting.checked
		SetIniBoolean "shadows" checkbox_Shadows.checked
		SetIniBoolean "diffuse" checkbox_Diffuse.checked
		SetIniBoolean "ambient" checkbox_Ambient.checked
		SetIniBoolean "specular" checkbox_Specular.checked
		SetIniBoolean "emission" checkbox_Emission.checked
		SetIniBoolean "reflection" checkbox_Reflection.checked
		SetIniBoolean "refraction" checkbox_Refraction.checked
		
	)
	
	on btn_Close pressed do(
		destroydialog Blend_More_Rollout
	)
)

struct Blend_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog Blend_More_Rollout style_resizing:false
	)
)
m_Blend_More_System= Blend_More_System()
m_Blend_More_System.ShowDialog()

