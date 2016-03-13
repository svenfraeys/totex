try(destroydialog RenderPreset_More_Rollout)catch()

rollout RenderPreset_More_Rollout "Render Preset"(
	local rpsDirectory = "$userScripts/totex/features/config_RenderPreset/rps/"
	local m_IniPath = "$userScripts/totex/features/config_RenderPreset/settings.ini"
	
	label label_dropdown "Render Preset" align:#left
	dropdownlist dropdownlist_RpsFiles ""
	button btn_OpenFolder "Open Directory"
	label l1
	button btn_Close "Close" width:100 height:30
	on RenderPreset_More_Rollout open do(
		
		rpsFilesArr = getfiles (rpsDirectory+"*.rps")
		
		itemsArr = #()
		
		rpsSettingValue = getinisetting m_IniPath "settings" "rps"
		
		selectedIndex = 0
		
		for i = 1 to rpsFilesArr.count do(
			rpsFile  = rpsFilesArr[i]
			labelValue = ((getFilenameFile rpsFile)+(getFilenameType rpsFile))
			
			if(labelValue == rpsSettingValue)then(
				selectedIndex = i
			)
			append itemsArr labelValue
		)
		
		dropdownlist_RpsFiles.items = itemsArr
		if(selectedIndex != 0 )then(
			dropdownlist_RpsFiles.selection = selectedIndex
		)
		
		
		
		
	)
	on btn_OpenFolder pressed do(
		thePath = (getdir #userScripts)+"/totex/features/config_RenderPreset/rps/"
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start(thePath)
	)
	
	
	on RenderPreset_More_Rollout close do(
		setinisetting m_IniPath "settings" "rps" (dropdownlist_RpsFiles.selected as string)
		
		m_ToTex_Events.DispatchEvent "ToTexSaveSettings"
	)
	
	on btn_Close pressed do(
		destroydialog RenderPreset_More_Rollout
	)
)

struct RenderPreset_More_System(
	fn ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog RenderPreset_More_Rollout style_resizing:false
	)
)
m_RenderPreset_More_System = RenderPreset_More_System()
m_RenderPreset_More_System.ShowDialog()



createdialog RenderPreset_More_Rollout