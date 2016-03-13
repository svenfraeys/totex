
polyObj = m_ToTex_Bake.m_Model.GetModel()


dMap = CompleteMap()
dMap.filterOn = false
dMap.enabled = true

dMap.shadowsOn = true
dMap.enabled = true

-- Apply Defaults
m_ToTex_Bake.AddMap dMap "Complete"

-- Start The Baking
m_ToTex_Bake.Bake()


