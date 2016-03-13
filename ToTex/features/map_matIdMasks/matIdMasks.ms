

-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()

m_Materials = #()

fn CheckForMaterialID obj index = 
	(
		_prevSel = $
		select obj
		
		_matIdexists = false
		MatChkMod_01 = Edit_Poly()
		MatChkMod_01.name = "MaterialIDCheck"

		modPanel.addModToSelection (MatChkMod_01) ui:on
		print "erroring"
		print obj.modifiers["MaterialIDCheck"]
		
		modPanel.setCurrentObject obj.modifiers["MaterialIDCheck"]

		MatChkMod_01.SetEPolySelLevel #Face
		MatChkMod_01.selectByMaterialID = index-1 --Index passed needs to be one less than that displayed in the UI
		MatChkMod_01.selectByMaterialClear = true
		MatChkMod_01.ButtonOp #SelectByMaterial
		if ( (MatChkMod_01.GetSelection #Face) as array).count > 0 then
		(
			_matIdexists = true
		)
		else(
			--print "Material ID doesn't exist"
			_matIdexists = false
		)
			
		deleteModifier obj MatChkMod_01 
		
		
		
		deselect obj
		select _prevSel
		
		return _matIdexists

)

fn AnalyzeMaterialsOfObject _obj=(
		node = _obj
		if(_obj.material != undefined)then(
		--if its multimaterial
		if ( iskindof node.material multimaterial ) then
		(
			-- check if the mmaterial is not yet in the mmaterials arrays
			
				-- add to mmaterials list because it is not yet in the array list
				
				--append to list of mmaterials
				
				-- go through each material in the multimateiral
				
				--for m in node.material.materialList do
				for i = 1 to node.material.materialList.count do
				(
					m = node.material.materialList[i]
					if finditem m_Materials m == 0 then
					(
						
						MaterialMatId = node.material.materialIDList[i]
						
						if(m_MaterialIDExistCheck == on)then(
							-- i still need to filter here to check what materials are actually active in the mesh? because otherwise we will render way too much!
							if(CheckForMaterialID node MaterialMatId)then(
								--it is used in the object so you can add it
								m.effectsChannel = 1
								append m_Materials m
								--node.selectByMaterial MaterialMatId
							)else(
								-- it is not used in the object
								--print "do not add to list!!!"
							)
						)else(
							m.effectsChannel = 1
							append m_Materials m
							--node.selectByMaterial MaterialMatId
						)
					)
				)
			
		)else(
			--if its not a multimaterial
			if finditem m_Materials node.material == 0 then
			(
				--add to array not yet in material array list
				append m_Materials node.material
			)else(
				
				--do not add allready exists
			)
		)
		
		)
		
		return m_Materials
)


if((m_ToTex_Bake.GetProjection()) == true)then(
	m_ProjectionModifier = polyObj.modifiers[#Projection]
	if(m_ProjectionModifier != undefined)then(
		-- projection exsists
		--for each object you have for projection do
		for _node in m_ProjectionModifier.geomNodes do
		(
			AnalyzeMaterialsOfObject _node
		)
	)
)else(
	AnalyzeMaterialsOfObject polyObj
)



counter = 0
for mat in m_Materials do
(
	counter = counter+1
	--setting correct colors
	for i = 1 to m_Materials.count do
	(			
		-- set masking color
		if (m_Materials[i] != mat) then
		(
			m_Materials[i].diffuse = color 0 0 0 0
			m_Materials[i].ambient = color 0 0 0 0
		)else(
			m_Materials[i].diffuse = color 255 255 255 0
			m_Materials[i].ambient = color 255 255 255 0
		)
	)
	
	dMap = DiffuseMap()
	dMap.filterOn = false
	dMap.shadowsOn = false
	dMap.lightingOn = false
	dMap.enabled = true

	-- Apply Defaults
	m_ToTex_Bake.RemoveAllMaps()
	m_ToTex_Bake.AddMap dMap ("MaterialIDMask_"+(counter as string))

	-- Start The Baking
	m_ToTex_Bake.Bake()
	
)







