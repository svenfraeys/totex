

rollout Normal_More_Rollout "Normal"(
	local m_IniPath = "$userScripts/totex/features/map_normal/settings.ini"
	checkbox checkbox_FlipGreen "Flip Green"
	checkbox checkbox_FlipRed "Flip Red"
	label l1
	button btn_Close "Close" width:100 height:30
	on Normal_More_Rollout open do(
		iniValue = getinisetting m_IniPath "settings" "flipGreen" 
		
		if(iniValue == "true")then(
			checkbox_FlipGreen.checked = true
		)else(
			checkbox_FlipGreen.checked = false
		)
		
		iniValue = getinisetting m_IniPath "settings" "flipRed" 
		if(iniValue == "true")then(
			checkbox_FlipRed.checked = true
		)else(
			checkbox_FlipRed.checked = false
		)
		
	)
	
	on Normal_More_Rollout close do(
		setinisetting m_IniPath "settings" "flipGreen" (checkbox_FlipGreen.checked as string)
		setinisetting m_IniPath "settings" "flipRed" (checkbox_FlipRed.checked as string)
	)
	
	on btn_Close pressed do(
		destroydialog Normal_More_Rollout
	)
)

struct Normal_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog Normal_More_Rollout style_resizing:false
	)
)
m_Normal_More_System = Normal_More_System()
m_Normal_More_System.ShowDialog()

