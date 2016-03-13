

rollout aoMentalRay_More_Rollout "Resolution"(
	local m_IniPath = "$userScripts/totex/features/map_aoMentalRay/settings.ini"
	
	spinner spinner_Samples "Samples" type:#integer range:[1,999999,0]
	spinner spinner_Spread "Spread" type:#integer range:[1,999999,0]
	label l1
	button btn_Close "Close" width:100 height:30
	on aoMentalRay_More_Rollout open do(
		spinner_Samples.value = ((getinisetting m_IniPath "settings" "samples" ) as integer)
		spinner_Spread.value = ((getinisetting m_IniPath "settings" "spread" ) as integer)
	)
	
	on aoMentalRay_More_Rollout close do(
		setinisetting m_IniPath "settings" "samples" (spinner_Samples.value as string)
		setinisetting m_IniPath "settings" "spread" (spinner_Spread.value as string)
	)
	
	on btn_Close pressed do(
		destroydialog aoMentalRay_More_Rollout
	)
)

struct aoMentalRay_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog aoMentalRay_More_Rollout style_resizing:false
	)
)
m_aoMentalRay_More_System= aoMentalRay_More_System()
m_aoMentalRay_More_System.ShowDialog()

