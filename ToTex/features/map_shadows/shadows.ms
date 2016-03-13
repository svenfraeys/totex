
-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()


dMap = ShadowsMap()
dMap.filterOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Shadows"

-- Start The Baking
m_ToTex_Bake.Bake()


