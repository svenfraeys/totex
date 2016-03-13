m_DialogMaster.DialogMaster_DestroyDialog ToTex_UI_Settings_Rollout
struct ToTex_UI_Settings_System(
	fn Initiate=(
		
	),
	function ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog ToTex_UI_Settings_Rollout style_resizing:false pos:[400, 400]
	)
)

m_ToTex_UI_Settings_System = ToTex_UI_Settings_System()
m_ToTex_UI_Settings_System.Initiate()

rollout ToTex_UI_Settings_Rollout "Settings" width:500 height:300(
	local m_UserInterFace_Configuration
	local m_UserInterFace_MapList
	
	dotNetControl Text_General "system.windows.forms.label" text:"General"
	edittext text_savePath "Save Path" across:2 width:400
	button btn_savePath "..." offset:[70,0]
	
	checkbox checkbox_AutoUpdate "Auto Update" offset:[0,7] across:3
	button btn_Update "Update" width:60 height:30 align:#left offset:[-60,0]
	label lbl_Update "" align:#left offset:[-150,7]
	
	dotNetControl Text_Rendering "system.windows.forms.label" text:"Rendering"
	radiobuttons radio_RenderPreview "Render Preview" labels:#("Yes","No")	across:2
	radiobuttons radio_EnableAccelerators "Enable Accelerators" labels:#("Yes","No")	
	
	
	dotNetControl Text_Maps "system.windows.forms.label" text:"Maps"
	
	dotNetControl listView_Maps "System.Windows.Forms.ListView" height:200 width:300
	dotnetcontrol pictureBox_Map "system.windows.forms.picturebox" pos:[0,0] width:50 height:50
	dotNetControl Text_Map "system.windows.forms.label" text:""
	dotNetControl Text_Map_Description "system.windows.forms.label" text:""
	
	dotNetControl Text_Configuration "system.windows.forms.label" text:"Configuration"
	dotNetControl listView_Configuration "System.Windows.Forms.ListView" height:200 width:300
	
	
	
	button btn_Close "Close" width:100 height:30
	
	fn RefreshFeatures=(
		m_UserInterFace_Configuration.LoadFeatures  (m_ToTex_Features.GetFeatures filter:#("configuration"))
		m_UserInterFace_Configuration.LoadCheckStateVisible()
		m_UserInterFace_MapList.LoadFeatures  (m_ToTex_Features.GetFeatures filter:#("map"))
		m_UserInterFace_MapList.LoadCheckStateVisible()
	)
	
	fn RefreshContent=(
		RefreshFeatures()
		text_savePath.text = m_ToTex_Settings.GetSaveRenderPath()
		
		if(m_ToTex_Settings.GetPreviewRender())then(
			radio_RenderPreview.state  = 1
		)else(
			radio_RenderPreview.state  = 2
		)
		if(m_ToTex_Settings.GetEnableAccelerators())then(
			radio_EnableAccelerators.state  = 1
		)else(
			radio_EnableAccelerators.state  = 2
		)
		
		if(m_ToTex_Settings.GetAutoUpdate())then(
			checkbox_AutoUpdate.checked = true
		)else(
			checkbox_AutoUpdate.checked = false
		)
	)
	
	fn SaveFeatures=(
		m_UserInterFace_Configuration.SaveCheckStateVisible()
		m_UserInterFace_MapList.SaveCheckStateVisible()
	)
	
	fn SaveSettings=(
		SaveFeatures()
		
		saveDir = text_savePath.text
		
		if(saveDir[saveDir.count] != "\\")then(
			saveDir+="\\"	
		)
		makedir saveDir all:true
		
		m_ToTex_Settings.SetSaveRenderPath saveDir
		if(radio_RenderPreview.state == 1)then(
			m_ToTex_Settings.SetPreviewRender true	
		)else(
			m_ToTex_Settings.SetPreviewRender false
		)
		
		if(radio_EnableAccelerators.state == 1)then(
			m_ToTex_Settings.SetEnableAccelerators true	
		)else(
			m_ToTex_Settings.SetEnableAccelerators false
		)
		
	)
	
	fn MoveContentMapInformation xpos:undefined ypos:undefined=(
		if(ypos != undefined)then(
			Text_Map.pos.y = yPos
			pictureBox_Map.pos.y = yPos + 20
			Text_Map_Description.pos.y = yPos + 20
		)
	)
	
	fn UpdateContentMapInformation _feature =(
		Text_Map.text = _feature.GetLabel scriptLabel:false
		Text_Map_Description.text = _feature.GetDescription()
-- 		pictureBox_Map.text = _feature.GetThumbPath()
		
		if(_feature.GetThumbPath() == "")then(
			pictureBox_Map.image = undefined
		)else(
			imageClass = dotnetclass "System.Drawing.Image"
			imageObj = imageClass.FromFile (_feature.GetThumbPath())
			pictureBox_Map.image = imageObj	
		)
		
	)
	
	
	fn UpdateControls=(
		
-- 		listView_Maps.height = 20
		Text_Map.pos.y = listView_Maps.pos.y
		Text_Map.pos.x = 320
		Text_Map.width = 167
		
		pictureBox_Map.pos.y = listView_Maps.pos.y + 20
		pictureBox_Map.pos.x = 320
		Text_Map_Description.pos.y = listView_Maps.pos.y + 20
		Text_Map_Description.pos.x = 380
		Text_Map_Description.width = 107
		Text_Map_Description.height = 75
		
		Text_Configuration.pos.y = listView_Maps.pos.y + listView_Maps.height + 20
		listView_Configuration.pos.y = Text_Configuration.pos.y +  20
-- 		listView_Configuration.height = 20
		
		ToTex_UI_Settings_Rollout.height = listView_Configuration.pos.y + listView_Configuration.height + 100
		
		btn_Close.pos.y = ToTex_UI_Settings_Rollout.height - 40
		btn_Close.pos.x = ToTex_UI_Settings_Rollout.width - 110
		
	)
	
	on btn_savePath pressed do(
		saveDir = getSavePath "Browse To Save Directory"
		if(saveDir == undefined)then(
			return false
		)
		
		if(saveDir[saveDir.count] != "\\")then(
			saveDir+="\\"	
		)
		
		text_savePath.text = saveDir
	)
	
	on listView_Maps ItemSelectionChanged _args do(
		featureArr = m_UserInterFace_MapList.GetSelectedFeatures()
		if(featureArr.count == 0)then(
			return false
		)
		UpdateContentMapInformation featureArr[1]
		MoveContentMapInformation ypos:listView_Maps.pos.y
		
	)
	
	on listView_Configuration ItemSelectionChanged _args do(
		featureArr = m_UserInterFace_Configuration.GetSelectedFeatures()
		if(featureArr.count == 0)then(
			return false
		)
		UpdateContentMapInformation featureArr[1]
		MoveContentMapInformation ypos:listView_Configuration.pos.y
	)
	
	on ToTex_UI_Settings_Rollout close do(
		SaveSettings()
		m_ToTex_Events.DispatchEvent "ToTexSaveSettings"
	)
	
	on ToTex_UI_Settings_Rollout open do(
			dotnetTitleBackgroundColor = m_ToTex_UserInterface_System.GetTitleBackgroundColorAsDotNet()
			dotnetBackgroundColor = m_ToTex_UserInterface_System.GetBackgroundColorAsDotNet()
			dotnetTitleForeColor = m_ToTex_UserInterface_System.GetTextColorAsDotNet()
			--Text_Configuration.backcolor = dotnetBackgroundColor
			--Text_Map.backcolor = dotnetBackgroundColor
			Text_Map_Description.backcolor = dotnetBackgroundColor
			Text_Configuration.backcolor = dotnetTitleBackgroundColor
			Text_Configuration.foreColor = dotnetTitleForeColor
		
			Text_Map.backcolor = dotnetTitleBackgroundColor
			Text_Map.foreColor = dotnetTitleForeColor
		
			Text_General.backcolor = dotnetTitleBackgroundColor
		Text_General.foreColor = dotnetTitleForeColor
			Text_Maps.backcolor = dotnetTitleBackgroundColor
		Text_Maps.foreColor = dotnetTitleForeColor
			Text_Rendering.backcolor = dotnetTitleBackgroundColor
		Text_Rendering.foreColor = dotnetTitleForeColor
		
			pictureBox_Map.backColor = dotnetBackgroundColor
		
		textColor = m_ToTex_UserInterface_System.GetTextColorAsDotNet();
		Text_Map_Description.foreColor = textColor
		listView_Configuration.foreColor = textColor
		listView_Maps.foreColor = textColor
		
		m_UserInterFace_Configuration = UIControl_FeatureList()
		m_UserInterFace_Configuration.Initiate listView_Configuration view:"List" scriptLabel:false
		
		
		m_UserInterFace_MapList = UIControl_FeatureList()
		m_UserInterFace_MapList.Initiate listView_Maps scriptLabel:false
		
		
		RefreshContent()
		m_UserInterFace_MapList.SetView "List"
		m_UserInterFace_Configuration.SetView "List"
		UpdateControls()
		
	)
	
	
	on btn_Update pressed do(
		res = m_AutoUpdate_ToTex.CheckUpdate()
		if(res == false)then(
			lbl_Update.text = "No Updates Available"
		)
		
	)
	
	on checkbox_AutoUpdate changed _val do(
		m_ToTex_Settings.SetAutoUpdate (_val as string)
	)
	
	on btn_Close pressed do(
		destroydialog ToTex_UI_Settings_Rollout
		
	)
)

-- m_ToTex_UI_Settings_System.ShowDialog()