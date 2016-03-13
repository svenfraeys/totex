
polyObj = m_ToTex_Bake.m_Model.GetModel()
select polyObj

editPolyModif = edit_Poly()
addmodifier polyObj editPolyModif

unwrapMod = Unwrap_UVW()
unwrapMod.setMapChannel (m_ToTex_Settings.GetChannel())
addModifier polyObj unwrapMod

unwrapMod.renderuv_width = m_ToTex_Bake.GetTextureWidth()
unwrapMod.renderuv_height = m_ToTex_Bake.GetTextureHeight()

uvRenderPath = m_ToTex_Bake.AddMap undefined "UV"

unwrapMod.renderUV uvRenderPath

previewRender = m_ToTex_Settings.GetPreviewRender()

if(previewRender == false)then(
	--find the uv windows and close them
	for w in (windows.getChildrenHWND 0) do (
		if((substring w[5] 1 10) == "Render Map" )then(
			UIAccessor.CloseDialog w[1]
		)
	)
)

