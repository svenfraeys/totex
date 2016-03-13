

rollout Padding_More_Rollout "Padding"(
	local m_IniPath = "$userScripts/totex/features/config_padding/settings.ini"
	
	spinner spinner_Padding "Padding" type:#integer range:[1,999999,0]
	label l1
	button btn_Close "Close" width:100 height:30
	on Padding_More_Rollout open do(
		spinner_Padding.value = ((getinisetting m_IniPath "settings" "padding" ) as integer)
	)
	
	on Padding_More_Rollout close do(
		setinisetting m_IniPath "settings" "padding" (spinner_Padding.value as string)
		m_ToTex_Events.DispatchEvent "ToTexSaveSettings"
	)
	
	on btn_Close pressed do(
		destroydialog Padding_More_Rollout
	)
)

struct Padding_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog Padding_More_Rollout style_resizing:false
	)
)
m_Padding_More_System = Padding_More_System()
m_Padding_More_System.ShowDialog()

