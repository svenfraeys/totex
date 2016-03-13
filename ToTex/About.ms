--About
struct ToTex_About_System(
	fn Initiate=(
		
	),
	function ShowDialog=(
		m_DialogMaster.DialogMaster_CreateDialog ToTex_About_Rollout style_resizing:false
	)
)


try(destroydialog ToTex_About_Rollout)catch()
rollout ToTex_About_Rollout "About" width:200 height:240(
	local rolloutSize = 200
	local urlColor = (color 0 0 100)
	
	dotnetcontrol pictureBox_Logo "system.windows.forms.picturebox"  width:24 height:24 pos:[30,0]
	dotNetControl Text_Message "system.windows.forms.label" text:"Track Maker" pos:[60,12-7] width:(200-24) height:15
	dotnetcontrol pictureBox_BackGround "system.windows.forms.picturebox"  width:rolloutSize  height:24 pos:[0,0]
	label l1 "by Sven Fraeys"
	hyperlink lbl "http://sven.fraeys.be" align:#center address:"http://sven.fraeys.be" color:urlColor
	label spcr
	group "MaxScript Snippets"(
		label l3 "Denis Trofimov"
		hyperlink lbl_url "Change Dialog Icon" align:#center color:urlColor address:@"http://forums.cgsociety.org/showpost.php?p=6593207&postcount=1"
		label l4 "Norman 3D"
		hyperlink lbl_url2 "Auto Add Icon" align:#center color:urlColor address:@"http://www.norman3d.com/MaxScriptManager"
	)
	
	label l2
	button btn_Close "Close" width:100 height:30
	
	
	on ToTex_About_Rollout open do(
		userScriptFolder = (symbolicPaths.getPathValue("$userScripts")+"\\")
		imageClass = dotnetclass "System.Drawing.Image"
		imageObj = imageClass.FromFile (userScriptFolder + @"ToTex\images\ToTex_24i.bmp")
		pictureBox_Logo.image = imageObj
		Text_Message.text = "Track Maker"
	)
	
	on btn_Close pressed do(
		destroydialog ToTex_About_Rollout	
		
		
		
	)
)

m_ToTex_About_System = ToTex_About_System()
m_ToTex_About_System.Initiate()
-- m_ToTex_About_System.showdialog()