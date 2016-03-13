
try(
	DestroyDialog ToTex_UserInterface_Rollout
)catch()

projectFolder = "$userScripts/ToTex/"

global m_ToTex_UserInterface_System

filein(projectFolder+"AutoUpdate.ms")
fn IncludeFiles=(
	filein(projectFolder+"Events.ms")
	filein(projectFolder+"DialogMaster.ms")
	filein(projectFolder+"WindowSaver.ms")
	filein(projectFolder+"About.ms")
	filein(projectFolder+"Features.ms")
	filein(projectFolder+"Settings.ms")
	filein(projectFolder+"Model.ms")
	filein(projectFolder+"Bake.ms")
	filein(projectFolder+"Process.ms")
	filein(projectFolder+"UserInterface_FeatureList_listview.ms")
	filein(projectFolder+"UserInterface_FeatureThumbs.ms")
	filein(projectFolder+"UI_Settings.ms")
	filein(projectFolder+"UserInterface.ms")
	filein(projectFolder+"Feedback.ms")
)
if(m_ToTex_GoingToUpdate == undefined or m_ToTex_GoingToUpdate == false)then(
	IncludeFiles()
	IncludeFiles()
	m_ToTex_UserInterface_System.ShowDialog()
)


-- m_ToTex_Process_System.Process (m_Totex_Model_System.MakeToTexModelArr (selection as array)) #(m_ToTex_Features.GetFeatureByName "diffuse",m_ToTex_Features.GetFeatureByName "resolution")

