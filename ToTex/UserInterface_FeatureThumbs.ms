struct UIControl_FeatureThumbs(
	m_DotNetControl,
	m_FeaturesArr,
	m_ImageFolder = (symbolicPaths.getPathValue("$userScripts")+"\\ToTex\\"+"images\\"),
	fn Initiate _dotnetControl=(
		m_DotNetControl = _dotnetControl
		
		colorClass = dotnetclass "System.Drawing.Color"
		
		--m_DotNetControl.BackgroundColor = colorClass.fromArgb 100 100 100
	
	),
	fn LoadFeatures _features=(
		m_DotNetControl.ClearMaps()
		m_FeaturesArr = _features
		for feature in m_FeaturesArr do(
			hasMore = true
			if(feature.GetMore() == "")then(
				hasMore = false
			)
			
			m_DotNetControl.AddMap (feature.GetName()) (hasMore) (feature.GetPathDirectory()+feature.GetThumb()) (m_ImageFolder+"ThumbMore.png") (m_ImageFolder+"ThumbMore_over.png") (m_ImageFolder+"mapBorder.png")
			
		)
	),
	fn LoadCheckState=(
		
	),
	fn SaveCheckState=(
		
	),
	fn GetCheckedFeaturesArr=(
		
	),
	fn HandleClick _args=(
		
	),
	fn MapClicked _args=(
		print _args.Label
		print _args.isMoreButton
	)
)