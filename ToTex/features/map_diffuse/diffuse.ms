
-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()

dMap = DiffuseMap()
dMap.filterOn = false
dMap.shadowsOn = false
dMap.lightingOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Diffuse"

-- Start The Baking
m_ToTex_Bake.Bake()


