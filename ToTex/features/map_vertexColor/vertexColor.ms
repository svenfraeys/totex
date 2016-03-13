
-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()

vertexMaterial = standardMaterial()
vertexColorMap = Vertex_Color()
vertexColorMap.map = m_ToTex_Settings.GetChannel()

vertexMaterial.diffuseMap = vertexColorMap

polyObj.material = vertexMaterial

dMap = DiffuseMap()
dMap.filterOn = false
dMap.shadowsOn = false
dMap.lightingOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "VertexColor"

-- Start The Baking
m_ToTex_Bake.Bake()


