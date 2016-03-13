

rollout Resolution_More_Rollout "Resolution"(
	local m_IniPath = "$userScripts/totex/features/config_resolution/settings.ini"
	
	spinner spinner_Width "Width" type:#integer range:[1,999999,0]
	spinner spinner_Height "Height" type:#integer range:[1,999999,0]
	label l1
	button btn_Close "Close" width:100 height:30
	on Resolution_More_Rollout open do(
		spinner_Width.value = ((getinisetting m_IniPath "settings" "width" ) as integer)
		spinner_Height.value = ((getinisetting m_IniPath "settings" "height" ) as integer)
	)
	
	on Resolution_More_Rollout close do(
		setinisetting m_IniPath "settings" "width" (spinner_Width.value as string)
		setinisetting m_IniPath "settings" "height" (spinner_Height.value as string)
		m_ToTex_Events.DispatchEvent "ToTexSaveSettings"
	)
	
	on btn_Close pressed do(
		destroydialog Resolution_More_Rollout
		
	)
)

struct Resolution_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog resolution_more_rollout style_resizing:false
	)
)
m_Resolution_More_System = Resolution_More_System()
m_Resolution_More_System.ShowDialog()

