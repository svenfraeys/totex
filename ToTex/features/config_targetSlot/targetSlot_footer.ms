imageArr = m_ToTex_Bake.GetSaveImagePathArr()
model = (m_ToTex_Bake.GetModel()).GetOriginalModel()
model.material = standardmaterial()
materialObj  = model.material
materialObj.name = model.name

for i = 1 to imageArr.count do(
	bm = BitmapTexture()
 	bm.bitmap =openbitmap imageArr[i]
 	materialObj.diffuseMap = bm 
 	showTextureMap materialObj (materialObj.diffusemap) on
	exit
)
	
