

rollout aoLightTrace_More_Rollout "AO - LightTrace"(
	local m_IniPath = "$userScripts/totex/features/map_aoLightTrace/settings.ini"
	local btnWidth = 40
	local btn_Height = 30
	label lbl_Quality "Quality" align:#left
	checkbutton btn_Low "Low" width:btnWidth across:3 height:btn_Height
	checkbutton btn_Medium "Med" width:btnWidth height:btn_Height
	checkbutton btn_High "High" width:btnWidth height:btn_Height
	checkbox check_WhiteMaterial "White Material"
	checkbox check_GroundPlane "GroundPlane"
	
	
	label l1
	button btn_Close "Close" width:100 height:30
	on aoLightTrace_More_Rollout open do(
		quality = getinisetting m_IniPath "settings" "quality"
		if(quality == "1")then(
			btn_Low.checked = true
		)
		
		if(quality == "2")then(
			btn_Medium.checked = true
		)
		
		if(quality == "3")then(
			btn_High.checked = true
		)
		groundPlaneStr = getinisetting m_IniPath "settings" "groundPlane"
		if(groundPlaneStr == "true")then(
			check_GroundPlane.checked = true
		)
		whiteMaterialStr = getinisetting m_IniPath "settings" "whiteMaterial"
		if(whiteMaterialStr == "true")then(
			check_WhiteMaterial.checked = true
		)
		
		
		
-- 		spinner_Padding.value = ((getinisetting m_IniPath "settings" "padding" ) as integer)
	)
	
	on aoLightTrace_More_Rollout close do(
-- 		setinisetting m_IniPath "settings" "padding" (spinner_Padding.value as string)
		m_ToTex_Events.DispatchEvent "ToTexSaveSettings"
		setinisetting m_IniPath "settings" "groundPlane" (check_GroundPlane.checked as string)
		setinisetting m_IniPath "settings" "whiteMaterial" (check_WhiteMaterial.checked as string)
	)
	
	on btn_Close pressed do(
		destroydialog aoLightTrace_More_Rollout
	)
	
	on btn_Low changed _state do(
		btn_Low.checked = true
		btn_Medium.checked = false
		btn_High.checked = false
		setinisetting m_IniPath "settings" "quality" "1"
	)
	
	on btn_Medium changed _state do(
		btn_Low.checked = false
		btn_Medium.checked = true
		btn_High.checked = false
		setinisetting m_IniPath "settings" "quality" "2"
	)
	
	on btn_High changed _state do(
		btn_Low.checked = false
		btn_Medium.checked = false
		btn_High.checked = true
		setinisetting m_IniPath "settings" "quality" "3"
	)
	
)

struct aoLightTrace_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog aoLightTrace_More_Rollout style_resizing:false
	)
)
m_aoLightTrace_More_System = aoLightTrace_More_System()
m_aoLightTrace_More_System.ShowDialog()

