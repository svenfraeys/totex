try(
-- 	DestroyDialog ToTex_UserInterface_Rollout
)catch()


struct UIControl_FeatureList(
	m_DotNet_DataGridView,
	m_FeatureArr,
	fn SetupListView=(
		m_DotNet_DataGridView.AllowUserToAddRows = off
		
		
		m_DotNet_DataGridView.ColumnHeadersDefaultCellStyle.Alignment = m_DotNet_DataGridView.ColumnHeadersDefaultCellStyle.Alignment.MiddleCenter 
		m_DotNet_DataGridView.ShowEditingIcon = m_DotNet_DataGridView.RowHeadersVisible = off 	
		
		txtclmn = dotNetObject "System.Windows.Forms.DataGridViewTextBoxColumn"
		cbclmn = dotNetObject "System.Windows.Forms.DataGridViewCheckBoxColumn" 
		
		showproperties m_DotNet_DataGridView
		m_DotNet_DataGridView.MultiSelect = true
		
		
		checkBoxFeatureColumn = cbclmn.clone()
		
		
		checkBoxFeatureColumn.HeaderText = "ch"
		checkBoxFeatureColumn.width = 200
		
		labelFeatureColumn = txtclmn.clone()
		labelFeatureColumn.ReadOnly = true
		labelFeatureColumn.HeaderText = "Name"
		labelFeatureColumn.width = 200
		
		m_DotNet_DataGridView.columns.add (checkBoxFeatureColumn)	
		m_DotNet_DataGridView.columns.add (labelFeatureColumn)	
		m_DotNet_DataGridView.RowCount = 5 
		 
		m_DotNet_DataGridView.DataSource
-- 		showproperties m_DotNet_DataGridView.DataSource
	),
	fn AddFeaturesToListView=(
		
	),
	
	fn LoadFeatures _featuresArr=(
		m_FeatureArr = _featuresArr
		AddFeaturesToListView()
	),
	fn Initiate _dotnetControl=(
-- 		showproperties _dotnetControl
		m_DotNet_DataGridView = _dotnetControl
		SetupListView()
	)
)

-- createDialog ToTex_UserInterface_Rollout pos:[200, 250]