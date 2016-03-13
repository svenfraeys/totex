try(destroydialog MaxMerge_More_Rollout)catch()

rollout MaxMerge_More_Rollout "Max Merge" width:300(
	local m_IniPath = "$userScripts/totex/features/config_MaxMerge/settings.ini"
	
	label label_maxFileName ""
	edittext txt_maxFile "" across:2 width:240
	button btn_Browse "..." align:#right
	label l1 ""
	
	button btn_Close "Close" width:100 height:30
	
	fn RefreshContent=(
		maxMergeStr = txt_maxFile.text
		label_maxFileName.text = (getFilenameFile maxMergeStr)+(getFilenameType maxMergeStr)
	)
	
	on MaxMerge_More_Rollout open do(
		
		
		
		
		maxFile = getinisetting m_IniPath "settings" "maxFile"
		txt_maxFile.text = maxFile
		
		RefreshContent()
		
	)
	
	on btn_Browse pressed do(
		filename = getOpenFileName \ 
		caption:"Browse Max Merge File" \
		types:"*.max|*.max"
		if(filename != undefined and filename != "")then(
			txt_maxFile.text = filename
			RefreshContent()
		)
	)
	
	on MaxMerge_More_Rollout close do(
		maxFile = getinisetting m_IniPath "settings" "maxFile"
		
		setinisetting m_IniPath "settings" "maxFile" txt_maxFile.text
		
		m_ToTex_Events.DispatchEvent "ToTexSaveSettings"
	)
	
	on btn_Close pressed do(
		destroydialog MaxMerge_More_Rollout
	)
)

struct MaxMerge_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog MaxMerge_More_Rollout style_resizing:false
	)
)
m_MaxMerge_More_System = MaxMerge_More_System()
m_MaxMerge_More_System.ShowDialog()



createdialog MaxMerge_More_Rollout