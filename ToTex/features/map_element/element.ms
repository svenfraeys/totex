fn GiveObjectElementColors obj=(
	orig_Name = obj.name
	max modify mode 
	newPieces = #()
	i = 0
	while obj.GetNumFaces() > 0 do(
		
		i += 1
		newName = ("ToTex_NewPiece"+(i as string))
		
		obj.SetSelection #Face #{1}
		obj.convertSelection #Face #Element
		obj.convertSelection #Element #Face
		elementSelectionBitArr = (obj.GetSelection #Face)
		
		polyop.detachFaces obj elementSelectionBitArr delete:true asNode:true name:newName
		--newObj = $ToTex_NewPiece
		newPiece = getNodeByName newName
		standmat = standardMaterial()
		newPiece.material = standmat
		standmat.diffuse = color (random 0 255) (random 0 255) (random 0 255)
		append newPieces newPiece
	)
	

	for i = 1 to newPieces.count do(
		polyop.attach obj newPieces[i]
	)

	obj.name = orig_Name
	return obj
	
	
)

-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()

polyObj = GiveObjectElementColors polyObj

m_ToTex_Bake.m_Model.SetModel polyObj
m_ToTex_Bake.ApplyParametersOnModel polyObj


dMap = DiffuseMap()
dMap.filterOn = false
dMap.shadowsOn = false
dMap.lightingOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Element"

-- Start The Baking
m_ToTex_Bake.Bake()