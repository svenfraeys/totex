
polyObj = m_ToTex_Bake.m_Model.GetModel()

matWhite = standardmaterial()
matWhite.name = "ToTex_SelectionMask_WhiteMaterial"
matWhite.diffuseColor = color 255 255 255

matBlack = standardmaterial()
matBlack.name = "ToTex_SelectionMask_BlackMaterial"
matBlack.diffuseColor = color 0 0 0

selectionMaskMaterial = multimaterial()
selectionMaskMaterial.name = "ToTex_SelectionMask"
selectionMaskMaterial.numsubs = 2
selectionMaskMaterial[1] = matWhite
selectionMaskMaterial[2] = matBlack

polyObj.material = selectionMaskMaterial
--max modify mode
--subobjectlevel = 4
visibleFaces = polyop.getFaceSelection polyObj
invisibleFaces = -visibleFaces

polyop.setFaceMatID polyObj visibleFaces 1
polyop.setFaceMatID polyObj invisibleFaces 2



-- messagebox m_ToTex_Bake.m_Model.m_Model.name


dMap = DiffuseMap()
dMap.filterOn = false
dMap.shadowsOn = false
dMap.lightingOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "SelectionMask"

-- Start The Baking
m_ToTex_Bake.Bake()


