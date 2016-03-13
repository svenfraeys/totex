try(
-- 	DestroyDialog ToTex_UserInterface_Rollout
)catch()

m_DialogMaster.DialogMaster_DestroyDialog ToTex_UserInterface_Rollout

global m_ToTex_UserInterface_SelectedFeature

rcmenu rc_Feature_RightClick(
	fn isMap=(
		if(m_ToTex_UserInterface_SelectedFeature.GetType() == "map")then(
			return true
		)else(
			return false
		)
	)
	
	fn hasProperties =(
		if(m_ToTex_UserInterface_SelectedFeature.GetMore() == "")then(
			return false
		)else(
			return true	
		)
	)
	menuItem mi_Bake "Bake" filter:isMap
	seperator sep1
	menuItem mi_Properties "Properties" filter:hasProperties
	
	on mi_Bake picked do(
		ToTex_UserInterface_Rollout.Bake maps:#(m_ToTex_UserInterface_SelectedFeature)
	)
	
	on mi_Properties picked do(
		moreMsPath = m_ToTex_UserInterface_SelectedFeature.GetMore()
		filein(moreMsPath)
	)
)

struct UIControl_FeatureList(
	m_ScriptLabel,
	m_DotNet_ListView,
	m_FeatureArr,
	fn colorManColorAsArgb _colorManColor=(
		colorClass = dotnetClass "System.Drawing.Color"
		multiplyValue = 255
		
		redValue = (_colorManColor[1]*multiplyValue)
		greenValue = (_colorManColor[2]*multiplyValue)
		blueValue = (_colorManColor[3]*multiplyValue)
		
		dotnetColor = colorClass.FromArgb redValue greenValue blueValue
		
		return dotnetColor
		
		
	),
	fn GetSelectedFeatures=(
		returnFeatureArr = #()
		for i = 0 to (m_DotNet_ListView.SelectedItems.Count - 1) do(
			featureItem = m_DotNet_ListView.SelectedItems.Item[i]
			
			featureObj = m_ToTex_Features.GetFeatureByLabel featureItem.Text scriptLabel:m_ScriptLabel
			append returnFeatureArr featureObj
			
-- 			messagebox featureItem.text
			
		)
		return returnFeatureArr
	),
	fn GetCheckedFeaturesArr=(
		returnFeatureArr = #()
		for i = 0 to (m_DotNet_ListView.Items.Count - 1) do(
			featureItem = m_DotNet_ListView.Items.Item[i]
			if(featureItem.Checked)then(
				featureObj = m_ToTex_Features.GetFeatureByLabel featureItem.Text
				
				append returnFeatureArr featureObj
			)
-- 			messagebox featureItem.text
			
		)
		return returnFeatureArr
	),
	fn ResizeListView=(
		-- Checkbox Size
		if(m_DotNet_ListView.View == m_DotNet_ListView.View.Details)then(
			m_DotNet_ListView.columns.Item[0].width = 20
			m_DotNet_ListView.columns.Item[1].width = m_DotNet_ListView.width - 20 - 20
			m_DotNet_ListView.columns.Item[2].width =  20
			m_DotNet_ListView.height = m_DotNet_ListView.Items.Count * 18
		)
		
		if(m_DotNet_ListView.View == m_DotNet_ListView.View.List)then(
			m_DotNet_ListView.columns.Item[0].width = 120
			m_DotNet_ListView.columns.Item[1].width = 100
			m_DotNet_ListView.columns.Item[2].width =  20
			
			totalItems = m_DotNet_ListView.Items.Count
-- 			messagebox totalItems
			numRows = ((totalItems as float) / 4)
			numRows = numRows
			if(numRows < 1)then(
				numRows = 1
			)
			
			m_DotNet_ListView.height  = (numRows) * 45.0
			
-- 			m_DotNet_ListView.height = ((m_DotNet_ListView.Items.Item[totalItems - 1]).Position.Y) + 20
		)
		if(m_DotNet_ListView.View == m_DotNet_ListView.View.LargeIcon)then(
			m_DotNet_ListView.height =200
		)
		
	),
	
	fn SetupListView_Recolor=(
-- 		m_DotNet_ListView.BorderStyle = m_DotNet_ListView.BorderStyle.None
		theBackgroundColor = (colorMan.getColor #background )
		theBackgroundColor = colorManColorAsArgb theBackgroundColor
		m_DotNet_ListView.backColor=theBackgroundColor
	),
	
	fn SetView _type=(
		if(_type == "Details")then(
			m_DotNet_ListView.View = (dotNetClass "System.Windows.Forms.View").Details -- this is what allows the grid-like format to be used
			
		)
		if(_type == "List")then(
		m_DotNet_ListView.View = (dotNetClass "System.Windows.Forms.View").List -- this is what allows the grid-like format to be used
			
		)
		if(_type == "LargeIcon")then(
		m_DotNet_ListView.View = (dotNetClass "System.Windows.Forms.View").LargeIcon -- this is what allows the grid-like format to be used
			
		)
		
		ResizeListView()
	),
	
	fn SetupListView=(
		
		m_DotNet_ListView.CheckBoxes = true
		m_DotNet_ListView.Clear()
-- 		listView_Projects.Clear()
		m_DotNet_ListView.fullRowSelect = true -- When item is clicked, all columns in that item are selected
		m_DotNet_ListView.gridLines = false-- turn off the grid lines
		m_DotNet_ListView.HideSelection=true -- When this ListView loses the focus, it will still show what's selected
		m_DotNet_ListView.BorderStyle=m_DotNet_ListView.BorderStyle.None -- make the border a flat solid color instead of the Windows 3D look
		m_DotNet_ListView.HeaderStyle=m_DotNet_ListView.HeaderStyle.None -- Flattens the headers a bit (although they're still somewhat 3D) and keeps them from being clickable 
-- 		showproperties m_DotNet_ListView.View 
		m_DotNet_ListView.View = (dotNetClass "System.Windows.Forms.View").Details -- this is what allows the grid-like format to be used
		
		m_DotNet_ListView.Columns.add "d" 20 -- create a couple of columns and optionally specify their width
		m_DotNet_ListView.Columns.add "name" 80
		m_DotNet_ListView.Columns.add "+" 20
		
		
		ResizeListView()
		SetupListView_Recolor()
-- 		showproperties m_DotNet_ListView
	),
	fn AddFeaturesToListView=(
		theRange=#()
		for feature in m_FeatureArr do(
			labelStr
			
			labelStr = feature.GetLabel scriptLabel:m_ScriptLabel
			
			--(m_ScriptLabel as string)
			--labelStr = feature.GetLabel()
			
			
			listviewItemObj = dotNetObject "System.Windows.Forms.ListViewItem"
			listviewItemObj.text = labelStr
			listviewItemObj.SubItems.Add (feature.GetLabel())
			listviewItemObj.ImageIndex = 0
			if(feature.GetMore() != "")then(
				listviewItemObj.SubItems.Add ("+")	
			)
			
			m_DotNet_ListView.LargeImageList
			
-- 			showmethods listviewItemObj
			
			
			
-- 			listviewItemObj.imageList = imgList
			
			
-- 			showmethods listviewItemObj
			append theRange listviewItemObj
-- 			append theRange2 listviewItemObj
		)
		
		m_DotNet_ListView.Items.Clear()
		m_DotNet_ListView.Items.AddRange theRange
		
		imgList = dotnetobject "System.Windows.Forms.ImageList"
		ImageClass = dotnetClass "System.Drawing.Image"
		--imgList.Images.Add (ImageClass.FromFile("c:\\Teapot001_normalsMap.png"));
		imgList.ImageSize = dotNetObject "System.Drawing.Size" 50 50
		m_DotNet_ListView.LargeImageList = imgList
		
		ResizeListView()
	),
	
	fn LoadFeatures _featuresArr=(
		m_FeatureArr = _featuresArr
		AddFeaturesToListView()
	),
	fn Initiate _dotnetControl scriptLabel:true=(
		m_ScriptLabel = scriptLabel
-- 		showproperties _dotnetControl
		m_DotNet_ListView = _dotnetControl
		SetupListView()
	),
	fn SaveCheckStateVisible=(
		iniPath = "$userScripts/ToTex/userData/UI_State.ini"
		for i = 0 to (m_DotNet_ListView.Items.Count - 1) do(
			featureItem = m_DotNet_ListView.Items.Item[i]
			featureObj = m_ToTex_Features.GetFeatureByLabel featureItem.Text scriptLabel:m_ScriptLabel
			if(featureItem.Checked)then(
				setinisetting iniPath "visible" (featureObj.GetName()) "true"
			)else(
				setinisetting iniPath "visible" (featureObj.GetName()) "false"
			)
		)
	),
	fn LoadCheckStateVisible=(
		iniPath = "$userScripts/ToTex/userData/UI_State.ini"
		for i = 0 to (m_DotNet_ListView.Items.Count - 1) do(
			featureItem = m_DotNet_ListView.Items.Item[i]
			featureObj = m_ToTex_Features.GetFeatureByLabel featureItem.Text scriptLabel:m_ScriptLabel
			
			checkValue = getinisetting iniPath "visible" (featureObj.GetName())
			if(checkValue == "true")then(
				featureItem.Checked = true
			)else(
				featureItem.Checked = false
			)
		)
	),
	fn LoadCheckState=(
		iniPath = "$userScripts/ToTex/userData/UI_State.ini"
		for i = 0 to (m_DotNet_ListView.Items.Count - 1) do(
			featureItem = m_DotNet_ListView.Items.Item[i]
			featureObj = m_ToTex_Features.GetFeatureByLabel featureItem.Text scriptLabel:m_ScriptLabel
			
			checkValue = getinisetting iniPath "checkbox" (featureObj.GetName())
			if(checkValue == "true")then(
				featureItem.Checked = true
			)else(
				featureItem.Checked = false
			)
			
		)
	),
	fn SaveCheckState=(
		iniPath = "$userScripts/ToTex/userData/UI_State.ini"
		for i = 0 to (m_DotNet_ListView.Items.Count - 1) do(
			featureItem = m_DotNet_ListView.Items.Item[i]
			featureObj = m_ToTex_Features.GetFeatureByLabel featureItem.Text
			if(featureItem.Checked)then(
				setinisetting iniPath "checkbox" (featureObj.GetName()) "true"
			)else(
				setinisetting iniPath "checkbox" (featureObj.GetName()) "false"
			)
			
		)
		
	),
	fn DoubleClick _args=(
		
	),
	fn HandeMouseClickRight _args=(
		featureItem = m_DotNet_ListView.SelectedItems.Item[0]
		m_ToTex_UserInterface_SelectedFeature = m_ToTex_Features.GetFeatureByLabel featureItem.Text
		popupmenu rc_Feature_RightClick
	),
	fn HandeMouseClickLeft _args =(
		if(_args.x >= 150)then(
			HandeMouseClickRight _args
		)
	),
	fn MouseClick _args =(
		if( _args.Button == _args.Button.Right)then(
			HandeMouseClickRight _args
		)
		if( _args.Button == _args.Button.Left)then(
			HandeMouseClickLeft _args
		)
		
	)
)


-- createDialog ToTex_UserInterface_Rollout pos:[400, 250] style:#(#style_resizing)
-- m_ToTex_UserInterface_System.ShowDialog()