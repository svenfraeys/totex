
-- messagebox m_ToTex_Bake.m_Model.m_Model.name
polyObj = m_ToTex_Bake.m_Model.GetModel()


dMap = AlphaMap()
dMap.filterOn = false
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Alpha"

-- Start The Baking
m_ToTex_Bake.Bake()


