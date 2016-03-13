m_DLLFolder = (symbolicPaths.getPathValue("$userScripts")+"\\ToTex\\"+"DLL\\")
--m_DLLFolder = @"C:\Users\sven\Documents\Visual Studio 2008\Projects\ToTex\ToTex\bin\Debug\"
dllPath = m_DLLFolder+@"ToTex.dll"
dotnet.loadAssembly dllPath

try(
	DestroyDialog ToTex_UserInterface_Rollout
)catch()

struct ToTex_UserInterface_System(
	function ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog ToTex_UserInterface_Rollout style_resizing:false pos:[400, 250]
	),
	function Initiate=(
		
	),
	function GetPredifinedColorAsDotNet _colorID=(
		bgColor = colorMan.getColor _colorID 
		bgColor = bgColor*255
		colorClass = dotnetclass "System.Drawing.Color"
		newColor = colorClass.fromArgb bgColor[1] bgColor[2] bgColor[3]
		return newColor
	),
	function GetBackgroundColorAsDotNet=(
		return (GetPredifinedColorAsDotNet #background)
	),
	function GetTitleBackgroundColorAsDotNet=(
		return (GetPredifinedColorAsDotNet #stackViewSelection)
	),
	function GetTextColorAsDotNet=(
		return (GetPredifinedColorAsDotNet #text)
	),
	function GetTitleForegroundColorAsDotNet=(
		return (GetPredifinedColorAsDotNet #toolTipBackground)
	)
	
	
)
global m_ToTex_UserInterface_System = ToTex_UserInterface_System()
m_ToTex_UserInterface_System.Initiate()

rcmenu ToTex_Settings_RcMenu(
	menuitem mi_Settings "Settings"
	menuitem mi_Feedback "Send Feedback !"
	menuitem mi_About "About"
	on mi_Settings picked do(
		m_ToTex_UI_Settings_System.ShowDialog()
	)
	on mi_About picked do(
		m_ToTex_About_System.ShowDialog()
	)
	on mi_Feedback picked do(
		createdialog ToTex_Feedback_Rollout
	)
)

rollout ToTex_UserInterface_Rollout "ToTex" width:170(
	local m_MapView = "thumbs"
	local m_windowSaver
	local m_ProjectFolder = (symbolicPaths.getPathValue("$userScripts")+"\\ToTex\\")
	dotnetcontrol pictureBox_Settings "system.windows.forms.picturebox" pos:[0,0] width:24 height:24
	
	local zPos = 5
	dotnetcontrol pictureBox_Resolution "ToTex.UI.ImageButton" pos:[5,zPos] width:16 height:16
	spinner spinner_Resolution "" type:#integer width:50 pos:[23, zPos] range:[1, 9999999, 999999]
	dotnetcontrol pictureBox_Channel "ToTex.UI.ImageButton" pos:[80,zPos] width:16 height:16
	spinner spinner_Channel "" type:#integer width:40 pos:[98, zPos] range:[1, 100, 10]
	
	dotNetControl Text_Configuration "system.windows.forms.label" text:"Configuration"
	
	local m_UserInterFace_Configuration
	dotNetControl listView_Configuration "System.Windows.Forms.ListView" height:200
	
	dotNetControl Text_Maps "system.windows.forms.label" text:"Map"
	
	dotnetcontrol pictureBox_MapView "ToTex.UI.ImageButton" pos:[0,0] width:16 height:16 visible:true
	
	local m_UserInterFace_MapList
	dotNetControl listView_Maps "System.Windows.Forms.ListView" height:200
	
	local m_UserInterFace_MapThumbs
	dotNetControl thumbView_Maps "ToTex.MapCollection" pos:[10,0] width:150
	
	
	button btn_Bake "Bake" width:130 height:30 across:2 offset:[20,0]
	button btn_OpenInExplorer "o" width:30 height:30 offset:[14,0]
	
	fn RefreshControlsPosition=(
		BakeUIFollowsControl
		if(m_MapView=="thumbs")then(
			listView_Maps.visible = false
			thumbView_Maps.visible = true
			BakeUIFollowsControl = thumbView_Maps
		)
		if(m_MapView=="list")then(
			listView_Maps.visible = true
			thumbView_Maps.visible = false
			BakeUIFollowsControl = listView_Maps
		)
		
		Text_Configuration.pos.y = 30
		Text_Configuration.pos.x = 5
		Text_Configuration.width = ToTex_UserInterface_Rollout.width - 40
		pictureBox_Settings.pos.x = ToTex_UserInterface_Rollout.width - 25
		
		listView_Configuration.pos.y = Text_Configuration.pos.y + 20
		listView_Configuration.pos.x = 0
		listView_Configuration.width = ToTex_UserInterface_Rollout.width
		
		Text_Maps.pos.y = listView_Configuration.pos.y + listView_Configuration.height + 10
		Text_Maps.pos.x = 5
		Text_Maps.width = ToTex_UserInterface_Rollout.width - 40
		
		pictureBox_MapView.pos.y = Text_Maps.pos.y
		pictureBox_MapView.pos.x = ToTex_UserInterface_Rollout.width - 25
		
		if(m_MapView=="list")then(
			pictureBox_MapView.ImagePath = m_ProjectFolder+"images\\View_Thumbs.png"
			
			
			listView_Maps.pos.y = Text_Maps.pos.y + 20
			listView_Maps.pos.x = 0
			listView_Maps.width = ToTex_UserInterface_Rollout.width
			m_UserInterFace_MapList.ResizeListView();
		)else(
			listView_Maps.pos.y = 0
			listView_Maps.pos.x = 0
			listView_Maps.height = 0
			listView_Maps.width = 0
		)
		
		if(m_MapView=="thumbs")then(
			pictureBox_MapView.ImagePath = m_ProjectFolder+"images\\View_List.png"
			
			thumbView_Maps.pos.x = 10
			thumbView_Maps.pos.y = Text_Maps.pos.y + 20
			thumbView_Maps.width = 150
			thumbView_Maps.height = thumbView_Maps.PerfectHeight
		)else(
			thumbView_Maps.pos.x = 0
			thumbView_Maps.pos.y = 0
			thumbView_Maps.width = 0
			thumbView_Maps.height = 0
		)
		
		
		
		
		
		btn_Bake.pos.y = BakeUIFollowsControl.pos.y + BakeUIFollowsControl.height + 10
		btn_Bake.pos.x = 5
		
		if(m_MapView == "thumbs")then(
			btn_Bake.enabled = false
		)else(
			btn_Bake.enabled = true
		)
		
		btn_OpenInExplorer.pos.y = BakeUIFollowsControl.pos.y + BakeUIFollowsControl.height + 10
		btn_OpenInExplorer.pos.x = 135
		ToTex_UserInterface_Rollout.height = btn_Bake.pos.y + 40
		
	)
	
	fn RefreshFeatures=(
		m_UserInterFace_Configuration.LoadFeatures  (m_ToTex_Features.GetFeatures filter:#("configuration","visible"))
		m_UserInterFace_Configuration.LoadCheckState()
		m_UserInterFace_MapList.LoadFeatures  (m_ToTex_Features.GetFeatures filter:#("map","visible"))
		m_UserInterFace_MapList.LoadCheckState()
		
		m_UserInterFace_MapThumbs.LoadFeatures (m_ToTex_Features.GetFeatures filter:#("map","visible"))
		m_UserInterFace_MapThumbs.LoadCheckState()
	)
	
	fn RefreshContent=(
		RefreshFeatures()
		spinner_Resolution.value = m_ToTex_Settings.GetTextureSize()
		spinner_Channel.value = m_ToTex_Settings.GetChannel()
	)
	
	fn SaveUISettings=(
		m_ToTex_Settings.SetChannel spinner_Channel.value
		m_ToTex_Settings.SetTextureSize spinner_Resolution.value
		
		m_UserInterFace_Configuration.SaveCheckState()
		m_UserInterFace_MapList.SaveCheckState()
		m_UserInterFace_MapThumbs.SaveCheckState()
		
		m_ToTex_Settings.SetMapView m_MapView
	)
	
	fn handleToTexSaveSettings=(
		RefreshContent()
		RefreshControlsPosition()
	)
	
	on ToTex_UserInterface_Rollout open do(
		m_MapView = m_ToTex_Settings.GetMapView()
		
		
		
		dotnetBackgroundColor = m_ToTex_UserInterface_System.GetBackgroundColorAsDotNet()
		titleBackgroundColor = m_ToTex_UserInterface_System.GetTitleBackgroundColorAsDotNet();
		titleForegroundColor = m_ToTex_UserInterface_System.GetTitleForegroundColorAsDotNet()
		
		
		textColor = m_ToTex_UserInterface_System.GetTextColorAsDotNet();
		Text_Configuration.backcolor = titleBackgroundColor
		Text_Configuration.forecolor = textColor
		Text_Maps.backcolor = titleBackgroundColor
		Text_Maps.forecolor = textColor
		
		pictureBox_Resolution.ImagePath = m_ProjectFolder+"images\\resolution.png"
		pictureBox_Resolution.backColor = dotnetBackgroundColor
		pictureBox_Resolution.ToolTip = "Resolution"
		pictureBox_Channel.ImagePath = m_ProjectFolder+"images\\channel.png"
		pictureBox_Channel.backColor = dotnetBackgroundColor
		pictureBox_Channel.ToolTip = "Channel"
		
		pictureBox_MapView.backColor = dotnetBackgroundColor
		pictureBox_MapView.ToolTip = "View"
		thumbView_Maps.backColor = dotnetBackgroundColor
		
		listView_Maps.foreColor = textColor
		listView_Configuration.foreColor = textColor
		
		m_windowSaver = windowSaver()
		m_windowSaver.initiate "$userScripts/ToTex/ToTex_Rollout.ini" ToTex_UserInterface_Rollout
		m_windowSaver.load()
		
		m_UserInterFace_Configuration = UIControl_FeatureList()
		m_UserInterFace_Configuration.Initiate listView_Configuration
		
		m_UserInterFace_MapList = UIControl_FeatureList()
		m_UserInterFace_MapList.Initiate listView_Maps
		
		m_UserInterFace_MapThumbs = UIControl_FeatureThumbs()
		m_UserInterFace_MapThumbs.Initiate thumbView_Maps
		
		RefreshContent()
		RefreshControlsPosition()
		m_UserInterFace_MapList.SetView "Detail"
		m_UserInterFace_Configuration.SetView "Detail"
		
		
		m_ToTex_Events.AddEventListener "ToTexSaveSettings" handleToTexSaveSettings
		
		
		imageClass = dotnetclass "System.Drawing.Image"
		imageObj = imageClass.FromFile (m_ProjectFolder + @"images\settings.png")
		pictureBox_Settings.image = imageObj
		
		
		theBmp = openbitmap (m_ProjectFolder+"images\\openFolder.bmp")
		btn_OpenInExplorer.images = #(theBmp, undefined, 1,1,1,1,1)
	)
	
	on ToTex_UserInterface_Rollout close do(
		m_ToTex_Events.RemoveEventListener "ToTexSaveSettings" handleToTexSaveSettings
		SaveUISettings()
		m_windowSaver.save()
	)
	
	on pictureBox_Settings MouseEnter _args do(
		imageClass = dotnetclass "System.Drawing.Image"
		imageObj = imageClass.FromFile (m_ProjectFolder + @"images\settings_over.png")
		pictureBox_Settings.image = imageObj
	)
	
	on pictureBox_Settings MouseLeave _args do(
		imageClass = dotnetclass "System.Drawing.Image"
		imageObj = imageClass.FromFile (m_ProjectFolder + @"images\settings.png")
		pictureBox_Settings.image = imageObj
	)
	
	
	on ToTex_UserInterface_Rollout resized _args do(
		
	)
	fn Bake maps:undefined features:undefined=(
		SaveUISettings()
		if(maps == undefined)then(
			maps = m_UserInterFace_MapList.GetCheckedFeaturesArr()
		)
		if(features == undefined)then(
			configuration = m_UserInterFace_Configuration.GetCheckedFeaturesArr()
		)
		featuresArr = #()
		join featuresArr configuration
		join featuresArr maps
		
		m_ToTex_Process_System.Process (m_Totex_Model_System.MakeToTexModelArr selection) featuresArr
	)
	on btn_OpenInExplorer pressed do(
		thePath = m_ToTex_Settings.GetSaveRenderPath()
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start(thePath)
	)
	
	on pictureBox_Settings MouseClick _args do(
		posUnderSettingsBox
		dialogPos = (getdialogpos ToTex_UserInterface_Rollout)
		
		
		
		popupmenu ToTex_Settings_RcMenu pos:[dialogPos[1]+pictureBox_Settings.pos.x+3,dialogPos[2]+pictureBox_Settings.pos.y+pictureBox_Settings.height+21]

	)
	
	on btn_Bake pressed do(
		Bake()
-- 		(maps as string)
		
-- 		m_UserInterFace_Configuration.SaveCheckState()
-- 		m_UserInterFace_MapList.SaveCheckState()
		
	)
	
	fn HandlePictureBox_MapView_MouseEnter _args =(
		if(m_MapView == "list")then(
			pictureBox_MapView.ImagePath = m_ProjectFolder+"images\\View_Thumbs_Over.png"
		)else(
			pictureBox_MapView.ImagePath = m_ProjectFolder+"images\\View_List_Over.png"
		)
	)
	
	on pictureBox_MapView ImageMouseEnter _args do(
		HandlePictureBox_MapView_MouseEnter _args
	)
	
	fn HandlePictureBox_MapView_MouseLeave _args=(
		if(m_MapView == "list")then(
			pictureBox_MapView.ImagePath = m_ProjectFolder+"images\\View_Thumbs.png"
		)else(
			pictureBox_MapView.ImagePath = m_ProjectFolder+"images\\View_List.png"
		)
	)
	
	on pictureBox_MapView ImageMouseLeave _args do(
		HandlePictureBox_MapView_MouseLeave  _args
		
	)
	
	
	on pictureBox_MapView imageClick _args do(
-- 		m_UserInterFace_MapList.SetView "LargeIcon"
		if(m_MapView == "list")then(
			m_MapView = "thumbs"
		)else(
			m_MapView = "list"
		)
		RefreshControlsPosition()
		HandlePictureBox_MapView_MouseEnter _args
	)
	
	on listView_Configuration MouseClick _args do(
		m_UserInterFace_Configuration.MouseClick _args
	)
	
	on listView_Maps MouseClick _args do(
		
		m_UserInterFace_MapList.MouseClick _args
	)
	
	on thumbView_Maps MapClicked _args do(
		m_UserInterFace_MapThumbs.MapClicked _args
		
		featureObj = m_ToTex_Features.GetFeatureByName (_args.Label)
		
		if(featureObj != undefined and _args.isMoreButton != true)then(
			Bake maps:#(featureObj)
		)
		
		if(featureObj != undefined and _args.isMoreButton == true)then(
			filein(featureObj.GetMore())
		)
		
		
	)
)


--m_ToTex_UserInterface_System.ShowDialog()