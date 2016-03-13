m_ProjectName = "ToTex"
m_Location = "userScripts"
m_Version = "3.0"
m_ScriptNameToLaunch = "Install.ms"
m_RandomNumber = "6512.txt"
m_Site= ""
m_Author = "Sven Fraeys"
m_Author_Email = "sven@fraeys.be"
m_Author_Site= "http://sven.fraeys.be/"
m_Author_Donate= "http://sven.fraeys.be/"
m_InstallerImage= "images\promo_totex_3_Beta.png"
m_UninstallScript= ""
m_MZP_IsUpDatable= "true"
m_MaxscriptManagerBool = true
m_RepoUrl = "http://sven.fraeys.be/maxscript/SvenFraeys.msr"
m_ScriptID = "118007928"
fn showTopmost name act:on=(messagebox "dso")
fn getWinClass = ()

fn MaxScriptManager_Manual_uninstall theName theAuthor=()
fn MaxScriptManager_Manual_install theName theAuthor theWebsite=()

fn MaxScriptManager_uninstall theID theRepo =()
fn MaxScriptManager_install theName theID theRepo theVersion =()
fn CreateDotNetProcessor=()
/*
m_ProjectName = "TheMessageBoxProject"
m_Location = "userScripts"
m_Version = "0.0"
m_ScriptNameToLaunch = "Project.ms"
m_RandomNumber = "1833.txt"
m_Site= ""
m_Author = "Sven"
m_Author_Email = "sven@fraeys.be"
m_Author_Site= "http://sven.fraeys.be/"
m_Author_Donate= "http://sven.fraeys.be/"
m_InstallerImage= ""
m_UninstallScript= ""
m_MaxscriptManagerBool = true
m_RepoUrl = ""
m_ScriptID = ""
m_MZP_IsUpDatable = "true"
*/

fn HiddenDotNetCommand exe args input=()



---------------------------------------------------------------------------------------------------
-- Show Top Most
-- Credit: Denis Trofimov
-- URL: http://forums.cgsociety.org/showpost.php?p=6722189&postcount=2
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- GetWinClass
---------------------------------------------------------------------------------------------------

fn getWinClass = 
(
	source = ""
	source += "using System;\n"
	source += "using System.Runtime.InteropServices;\n"
	source += "public class Window\n"
	source += "{\n"
	source += "	[DllImport(\"user32.dll\")]\n"
	source += "	public static extern bool SetWindowPos(int hWnd, int hWndArg, int Left, int Top, int Width, int Height, int hWndFlags);\n"
	source += "	[DllImport(\"user32.dll\")]\n"
	source += "	static extern bool GetWindowRect(int hWnd, out POS rect);\n"
	source += "	public struct POS\n"
	source += "	{\n"
	source += "		public int Left;\n"
	source += "		public int Top;\n"
	source += "		public int Right;\n"
	source += "		public int Bottom;\n"
	source += "	}\n"
	source += "	public int[] GetWindowPosAndSize(int hWnd)\n"
	source += "	{\n"
	source += "		POS rect;\n"
	source += "		if ( GetWindowRect(hWnd, out rect) )\n"
	source += "		{\n"
	source += "			return new int[] { rect.Left, rect.Top, rect.Right - rect.Left, rect.Bottom - rect.Top };\n"
	source += "		}\n"
	source += "		return null;\n"
	source += "	}\n"
	source += "}\n"

	csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
	compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
	compilerParams.GenerateInMemory = on
	compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)
	compilerResults.CompiledAssembly.CreateInstance "Window"
)
if wndclass == undefined do global wndclass = getWinClass()

fn showTopmost name act:on = 
(
	
	if ((hwnd = windows.getChildHWND 0 name) == undefined)then(
		return false
	)
	
	HWND_TOPMOST 	= -1
	HWND_NOTOPMOST 	= -2
	wndclass.setWindowPos hwnd[1] (if act then HWND_TOPMOST else HWND_NOTOPMOST) 0 0 0 0 0x3 -- (SWP_NOSIZE = 0x1 and SWP_NOMOVE = 0x2)
	act
)


struct mzpInstall_System(
	fn Initiate=(
		messagebox "Error : Using the predefined mzpInstall System"
	)
)
global m_mzpInstall_System
m_mzpInstall_System = mzpInstall_System()

if(m_ProjectName == undefined)then(
	m_ProjectName = "undefined"
)
if(m_Location == undefined)then(
	m_Location = "undefined"
)
if(m_Version == undefined)then(
	m_Version = "undefined"
)
if(m_Version == undefined)then(
	m_ScriptNameToLaunch = "undefined"
)

try(
	destroyDialog installRollOut
)catch()


try(
	destroydialog Install_EnableAutoUpdate_Rollout
)catch()
rollout Install_EnableAutoUpdate_Rollout "Auto Update" width:300 height:85(
	local buttonSize = [100,30]
	local iniFile = ((pathConfig.GetDir (execute("#"+m_Location))+"\\" + m_ProjectName + "\\")+"settings.ini")
	local string_Label = ("Enable Auto Update For "+m_ProjectName+"?")
	label lbl_wantUpdate ""
	label spacer ""
	
	button btn_Yes "Yes" across:2 width:buttonSize[1] height:buttonSize[2]
	button btn_No "No" width:buttonSize[1] height:buttonSize[2]
	
	on Install_EnableAutoUpdate_Rollout open do(
		lbl_wantUpdate.text = string_Label
	)
	on btn_No pressed do(
		setinisetting iniFile "settings" "autoUpdate" "false"
		destroydialog Install_EnableAutoUpdate_Rollout
	)
	on btn_Yes pressed do(
		setinisetting iniFile "settings" "autoUpdate" "true"
		destroydialog Install_EnableAutoUpdate_Rollout
	)
)



--maxscriptproject
-- m_MaxscriptManagerBool = true
-- m_ScriptID = "61165487465"
-- m_RepoUrl = "http://www.norman3d.com/repo.xml"
try(destroydialog MZP_updateInformation_Rollout)catch()
m_Update_Text_Message = ""
rollout MZP_updateInformation_Rollout "Update" width:500 height:270(
	label lbl_Reboot "Update completed! Please restart 3ds Max" align:#left
	dotnetcontrol txt_Message "System.Windows.Forms.Textbox" height:200
	
	checkbox checkbox_EnableAutoUpdate "Auto Update Next Time" across:2 offset:[0,16]
	
	button btn_Close "Close" width:100 height:30 offset:[0,10] align:#right 
	
	on MZP_updateInformation_Rollout close do(
		setinisetting ((getdir #userScripts)+"/"+m_ProjectName+"/settings.ini") "settings" "autoUpdate" (checkbox_EnableAutoUpdate.checked as string)
	)
	
	on MZP_updateInformation_Rollout open do(
		txt_Message.text = m_Update_Text_Message
		txt_Message.Multiline = true;
		--txt_Message.readonly = true;
		txt_Message.height=200
		txt_Message.AcceptsReturn = true;
		txt_Message.AcceptsTab = true;
		txt_Message.WordWrap = false;
		txt_Message.ScrollBars = txt_Message.ScrollBars.Vertical;
		MZP_updateInformation_Rollout.title = m_ProjectName + " " +m_Version
		
		if(getinisetting ((getdir #userScripts)+"/TrackMaker/settings.ini") "settings" "autoUpdate" == "true")then(
			checkbox_EnableAutoUpdate.checked = true
		)
	)
	on btn_Close pressed do(
		destroydialog MZP_updateInformation_Rollout
	)
)

rollout install_About_Rollout "About"(
	label l3
	label l2 "MaxScript Project Manager - Installer 1.0 BETA" align:#center
	label l1 "by Sven Fraeys" align:#center
	hyperlink link_Home "http://sven.fraeys.be/" address:"http://sven.fraeys.be/" align:#center color: (color 0 0 255)
)

--predefine rollout
rollout installRollOut ""(
	fn HandleManualInstall=(
		
	)
)


rcmenu installRollout_menu(
	
	fn HasDataAboutProject=(
		if(m_Site == "")then(
			return false
		)
		return true
	)
	
	fn HasDataAboutAuthor=(
		if(m_Author_Site == "")then(
			return false
		)
		return true
	)
	fn HasDataAboutAuthorEmail=(
		if(m_Author_Site == "")then(
			return false
		)
		return true
	)
	
	submenu "File"(
		menuItem mi_ManualInstall "Manual Install"
		seperator sep3
		menuItem mi_Exit "Exit"
	)
	
	submenu "Help"(
		menuItem mi_AboutProject "About Project" filter:HasDataAboutProject
		seperator sep2
		menuItem mi_AboutAuthor "About Author"
		menuItem mi_AboutContact "Contact author@author.com"
		seperator sep1
		menuItem mi_AboutMSPM "About MSPM Installer"
	)
	
	on mi_ManualInstall picked do(
		installRollOut.HandleManualInstall()
			
	)
	on mi_Exit picked do(
		
		destroydialog installRollOut
	)
	
	on installRollout_menu open do(
		
		mi_AboutProject.text = "About " + m_ProjectName
		mi_AboutAuthor.text = "About " + m_Author
		mi_AboutContact.text = "Contact " + m_Author_Email
-- 		mi_AboutMSPM.enabled = false
	)
	
	on mi_AboutProject picked do(
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start(m_Site)
	)
	
	on mi_AboutAuthor picked do(
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start(m_Author_Site)
	)
	
	on mi_AboutContact picked do(
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start("mailto:"+m_Author_Email)
	)
	
	on mi_AboutMSPM picked do(
		styleFlags =#()
		append styleFlags #style_sysmenu
		append styleFlags #style_minimizebox
		append styleFlags #style_titlebar
		append styleFlags #style_toolwindow
		CreateDialog install_About_Rollout style:styleFlags width:300 height:100
		
-- 		processClass = (dotnetclass "System.Diagnostics.Process")
-- 		processClass.start("http://sven.fraeys.be/mspm/")
	)
	
	
		
	
)



rollout installRollOut "MSPM Installer v1.0" width:200
(
		local m_MZP_Url
		local m_SmallerHeightWindow
		local m_SmallerWidthWindow
		dotNetControl label_Project "system.windows.forms.label" height:25 
		
		dotnetcontrol bmp_header "system.windows.forms.picturebox"
-- 		bitmap bmp_header filename:"ProjectImage.bmp"
-- 		imgtag img_header
		
		button btn_Install "Install" width:100 height:30 across:3
		button btn_Uninstall "Uninstall" width:100 height:30 across:3
		button btn_Exit "Exit" width:100 height:30
		label lbl_Spcr ""
		hyperlink lbl_MSPM "Created with MaxScriptProjectManager" address:"http://sven.fraeys.be/mspm/" color:(color 0 0 0) hovercolor:(color 0 0 0) visitedColor:(color 0 0 0)
		
		local m_InformationExpandedBool
	
	dotNetControl label_Information "system.windows.forms.label" height:25 pos:[0,0] visible:false
	dotNetControl label_Message "system.windows.forms.label" height:25 pos:[50,50]
		
		function SetGreenMessageColors=(
			label_Message.backcolor = label_Message.backcolor.fromArgb 0 0 0 0
			label_Message.Forecolor = label_Message.Forecolor.White
		)
		function SetRedMessageColors=(
			label_Message.backcolor = label_Message.backcolor.Red
			label_Message.Forecolor = label_Message.Forecolor.White
		)
		function SetDefaultMessageColors=(
			label_Message.ResetBackColor()
			label_Message.ResetForeColor()
		)
		
		function SetMessage _messageStr style:undefined=(
			label_Message.visible = true
			label_Message.BorderStyle=label_Information.BorderStyle.FixedSingle
			label_Message.TextAlign = label_Message.TextAlign.MiddleCenter
			label_Message.Text = "  "+_messageStr
			
			posRollout = getdialogpos installRollOut
			
			label_Message.width = installRollOut.width - 50
			label_Message.height = 100
			label_Message.pos.x = (installRollOut.width / 2) - (label_Message.width / 2)
			label_Message.pos.y = (installRollOut.height / 2) - (label_Message.height / 2) - (installRollOut.height / 8)
			label_Message.backcolor = label_Message.backcolor.fromArgb 200 200 200
			if(style == true)then(
-- 				SetGreenMessageColors()
			)else if(style == false)then(
-- 				SetRedMessageColors()
			)else(
-- 				SetDefaultMessageColors()
			)
			
		
		)
		function GetInformationString=(
			returnStr = ""
			append returnStr ("\n")
			append returnStr ("Project : " + m_ProjectName+"\n")
			append returnStr ("Version : " + m_Version+"\n")
			if(m_Site != "")then(
				append returnStr	("Site : " + m_Site+"\n")	
			)
			
			append returnStr	("\n")
			append returnStr	("Author : " + m_Author+"\n")
			if(m_Author_Site != "")then(
				append returnStr	("Site : " + m_Author_Site+"\n")
			)
			if(m_Author_Email != "")then(
				append returnStr	("E-mail : " + m_Author_Email+"\n")
			)
			append returnStr	("\n")
			append returnStr	("Location : $" + m_Location+"\n")
			
			append returnStr	("\n")
			append returnStr	("(Click For More Information)")
			
			return returnStr
		)
		
		fn ShowInstallInformation expanded:false=(
			if(expanded)then(
				label_Information.text = GetInformationString()
				if(m_SmallerHeightWindow != true)then(
					label_Information.height = bmp_header.height - 4	
				)else(
					label_Information.height = 140
				)
				if(m_SmallerWidthWindow != true)then(
					label_Information.pos.x = bmp_header.pos.x + 2
					label_Information.width = bmp_header.width / 2
				)else(
					label_Information.pos.x = 5
					label_Information.width = 200
				)
				
			)else(
				label_Information.text = "More Information >>"
				label_Information.height = 15
				if(m_SmallerWidthWindow != true)then(
					label_Information.pos.x = bmp_header.pos.x + 2
					label_Information.width = bmp_header.width / 2
				)else(
					label_Information.pos.x = 5
					label_Information.width = 200
				)
			)
			
			
			
			if(m_SmallerHeightWindow != true)then(
				label_Information.pos.y = bmp_header.pos.y + bmp_header.height - label_Information.height - 2	
			)else(
				label_Information.pos.y = (installRollOut.height - 100) - label_Information.height
			)
			
			
			
			
		)
			
		
		
		
		fn StyleInstallInformation expanded:false=(
			label_Information.BorderStyle=label_Information.BorderStyle.FixedSingle
-- 			showproperties label_Information.backcolor.Transparent
			label_Information.visible = true
			label_Information.pos = bmp_header.pos
			label_Information.height = 15
			
			
			
			
-- 			colorClass = dotNetObject "system.drawing.color"
-- 			showproperties colorClass
			(label_Information.backcolor.FromArgb 0 0 0 0)
			label_Information.backcolor = label_Information.backcolor.FromArgb 0 0 0 0
		)
		
		fn ToggleExpandStateInformation=(
			if(m_InformationExpandedBool == false)then(
				 ShowInstallInformation expanded:true
				m_InformationExpandedBool = true
			)else(
				 ShowInstallInformation expanded:false
				m_InformationExpandedBool = false
			)
		)
		
		fn InstallApplication=(
			installApp()
			if(m_MaxscriptManagerBool == true)then(
				ApplyMaxscriptManager()	
			)
			messageBox "Installation Completed!"
			scriptPathToLaunch = ""
			append scriptPathToLaunch (("$"+m_Location))
			append scriptPathToLaunch "\\"
			append scriptPathToLaunch m_ScriptNameToLaunch
			append scriptPathToLaunch ".ms"
			filein(scriptPathToLaunch)
		)
		
		on btn_Uninstall pressed do
		(
			res = querybox ("Uninstall '"+m_ProjectName+"' from '$"+m_Location+"' and all related content?\n\nYes = Uninstall '"+m_ProjectName+"'\nNo = Abort Uninstall")
			if(res == false)then(
				return false
			)
			
			res = m_mzpInstall_System.StartMZPUninstall()
			if(res == true)then(
				SetMessage ("'"+m_ProjectName+"' "+" is uninstalled from '$"+m_Location+"' with success")
				beep = dotnetclass "System.Media.SystemSounds"
				beep.asterisk.play()
				btn_Install.text = "Install"
				btn_Install.enabled = true
				btn_Uninstall.enabled = false
			)else(
				btn_Install.enabled = true
				btn_Uninstall.enabled = true
			)
		)
		
		on btn_Install pressed do
		(
			
			res = m_mzpInstall_System.StartMZPInstall()
			if(res)then(
				beep = dotnetclass "System.Media.SystemSounds"
				beep.asterisk.play()
				SetMessage (m_ProjectName + " is installed in '$"+m_Location+"' with success")
				btn_Uninstall.enabled = true
				btn_Install.enabled = false
				destroydialog installRollOut
				return true
			)
-- 			InstallApplication()
			rolloutTitleStr = installRollOut.title
			
			
			showTopmost installRollOut.title
			showTopmost installRollOut.title act:off
-- 			WM_SETFOCUS = 0x07
-- 			for w in (windows.getChildrenHWND 0) do (
-- 				if(w[5] == rolloutTitleStr )then(
-- 					(UIAccessor.SendMessage w[1] WM_SETFOCUS 20 20)
-- 				)
-- 			)
			
		)
		on btn_Exit  pressed do
		(
			destroyDialog installRollOut
		)
		on label_Message MouseMove _args do(

			cursor = dotnetclass "system.windows.forms.cursors"
			
			label_Message.Cursor.Current = cursor.hand
		)
		
		on label_Information MouseMove _args do(

			cursor = dotnetclass "system.windows.forms.cursors"
			
			label_Information.Cursor.Current = cursor.hand
		)
		
		on label_Project MouseMove _args do(

			cursor = dotnetclass "system.windows.forms.cursors"
			
			label_Project.Cursor.Current = cursor.hand
		)
		
		on label_Information MouseEnter _args do(
			
			
			ShowInstallInformation expanded:true
			
		)
		
		fn SurfToProjectSite=(
			
			processClass = (dotnetclass "System.Diagnostics.Process")
			if(m_Site != "")then(
				
					processClass.Start(m_Site);		
				
				
			)else(
				if(m_Author_Site != "")then(
					processClass.Start(m_Author_Site);		
				)else(
					
					if(m_Author_Email != "")then(
						
						processClass.start(("mailto:"+m_Author_Email))
					)
				)
				
				
				
			)
		)
		
		on label_Information MouseClick _args do(
			
			SurfToProjectSite()
		)
		
		on label_Project MouseClick _args do(
			SurfToProjectSite()
		)
		
		on bmp_header MouseDown _args do(
			label_Message.width = 0
			label_Message.height = 0
			label_Message.visible = false
		)
		on label_Information MouseLeave _args do(
			
			ShowInstallInformation expanded:false
		)
		
		fn RefreshControls=(
			elementWidth = installRollOut.width - 25
			label_Project.width = elementWidth
			label_Information.width = elementWidth
			bmp_header.pos.x = 12
			
			bmp_header.pos.x = (installRollOut.width / 2) - (bmp_header.width / 2)
			
			
			
			
			if(m_SmallerHeightWindow != true)then(
				
				btn_Install.pos.y = bmp_header.pos.y + bmp_header.image.height + 30
				btn_Uninstall.pos.y = bmp_header.pos.y + bmp_header.image.height + 30
				btn_Exit.pos.y = bmp_header.pos.y + bmp_header.image.height + 30
				lbl_MSPM.pos.y = bmp_header.pos.y + bmp_header.image.height + 70	
			)else(
				btn_Install.pos.y = installRollOut.height - 70
				btn_Uninstall.pos.y = installRollOut.height - 70
				btn_Exit.pos.y = installRollOut.height - 70
				lbl_MSPM.pos.y = installRollOut.height - 30
			)
			
			btn_Uninstall.pos.x = elementWidth - 230
			btn_Install.pos.x = elementWidth - 360
			btn_Exit.pos.x = elementWidth - 100
			lbl_MSPM.pos.x = elementWidth - 170
			
			
			ShowInstallInformation()
			
		)
		
		on installRollOut open do(
			
			
			if(m_mzpInstall_System.DirectoryExists (pathConfig.GetDir (execute("#"+m_Location))+"\\" + m_ProjectName + "\\"))then(
				btn_Uninstall.enabled = true
				btn_Install.text = "Upgrade"
			)else(
				btn_Uninstall.enabled = false
				btn_Install.text = "Install"
			)
			
			originalSize = getdialogsize installRollOut
			
			label_Message.BorderStyle=label_Information.BorderStyle.FixedSingle			
			m_MZP_Url = ""
			possibleUrl = m_mzpInstall_System.Find_MZP_url()
			if(possibleUrl != "")then(
				m_MZP_Url= possibleUrl
			)
			label_Message.visible = false
			
			m_InformationExpandedBool = false
			label_Information.visible = false
			
			label_Project.TextAlign = label_Project.TextAlign.MiddleCenter
			
			newBitmap = openbitmap (m_MZP_Url +m_ProjectName+"\\"+m_InstallerImage)
			if(newBitmap != undefined)then(
				imageClass = dotnetclass "System.Drawing.Image"
				imageObj = imageClass.FromFile (m_MZP_Url +m_ProjectName+"\\"+m_InstallerImage)
				bmp_header.image = imageObj
				
-- 				bmp_header.bitmap = newBitmap
				bmp_header.width = newBitmap.width
				bmp_header.height = newBitmap.height
			)else(
				newBitmap = openbitmap (m_MZP_Url +"ProjectImage.bmp")
				imageClass = dotnetclass "System.Drawing.Image"
				imageObj = imageClass.FromFile (m_MZP_Url +"ProjectImage.bmp")
				bmp_header.image = imageObj
				
-- 				bmp_header.bitmap = newBitmap
				bmp_header.width = newBitmap.width
				bmp_header.height = newBitmap.height
			)
			
			
			pathLocation = pathConfig.GetDir  (execute("#"+m_Location))
				
			projectFinalDirectory = (pathLocation+"\\" + m_ProjectName + "\\")
			if(m_mzpInstall_System.DirectoryExists projectFinalDirectory)then(
				btn_Install.enabled = true
			)else(
				btn_Uninstall.enabled = false
			)
			
			
			newRolloutWidth = bmp_header.width + 25
			newRolloutHeight = bmp_header.height + 125
			if(bmp_header.width < 200)then(
				newRolloutWidth = 400 + 25
				m_SmallerWidthWindow = true
			)
			if(bmp_header.height < 130)then(
				
				newRolloutHeight = 250
				m_SmallerHeightWindow = true
			)
			
			installRollOut.width = newRolloutWidth
			installRollOut.height = newRolloutHeight
			RefreshControls()
			StyleInstallInformation()
			ShowInstallInformation expanded:false
			
			
			label_Project.text = (m_ProjectName) + " - " + m_Version
			if(m_Version == "undefined")then(
				label_Project.text = (m_ProjectName)
			)
			
			
			rolloutTitleStr = (m_ProjectName) + " - " + m_Version
			if(m_Version == "undefined")then(
				rolloutTitleStr = (m_ProjectName)
			)
			installRollOut.title = rolloutTitleStr
			
			WM_SETFOCUS = 0x07
			for w in (windows.getChildrenHWND 0) do (
				if(w[5] == rolloutTitleStr )then(
					(UIAccessor.SendMessage w[1] WM_SETFOCUS 20 20)
	
				)
			)
			
			newSize = getdialogsize installRollOut
			diffSize = originalSize - newSize
			
			posDialog = getdialogpos installRollOut
			posDialog = posDialog + (diffSize/2)
			setdialogpos installRollOut posDialog
			
			showTopmost installRollOut.title
			showTopmost installRollOut.title act:off
			
		)
		
		fn HandleManualInstall=(
			
			possibleUrl = m_mzpInstall_System.Find_MZP_url()
			if(possibleUrl != "")then(
				installRollOut.SetMessage ("Manual Install : \n\n1. Copy the '"+m_ProjectName+"' folder into the '$"+m_Location+"' folder\n2. Run the '"+m_ProjectName+"\\"+m_ScriptNameToLaunch+"'")
				mzpTempUrl= possibleUrl
				processClass = (dotnetclass "System.Diagnostics.Process")
				processClass.start(mzpTempUrl)
			)else(
				installRollOut.SetMessage ("Error 404 : Could not find the Temp folder\n\nSomething must went wrong when placing the MZP in the temp folder")
			)
		)
)

struct mzpInstall_System(
	function Initiate=(
		
	),
	fn GetFolderName _path=(
		_parts = filterstring _path "\\"
		return _parts[_parts.count]
	),
	fn CopyDir _dir1 _dir2=(
			
			final_url = _dir1;
		
				--prepare to copy files
				local _scriptDir = _dir2;
				local accessFolder = makeDir _scriptDir;
				if (accessFolder == true)then(
					
					
					local _filesSource = getFiles (final_url+"*");
					
					local _pCnt = 0.0;
					
					
					for sf in _filesSource do (
						
						
						_pCnt+=1.0;
						
						
						local tf = _scriptDir+"\\"+filenameFromPath sf;
						
						
						
						local accessFile = deleteFile tf;--try to delete the icons if they can not be replaced below
						local accessFile = copyFile sf tf;
						
						if (accessFile == true)then(
							local p = (_pCnt / _filesSource.count) * 50.0+25.0;
							
							
						)else(
							
							failing = true;
						)
					)
					
					
					
					local myfolders = getDirectories(final_url+"\\*")
					for i = 1 to myfolders.count do(
						folder = myfolders[i]
						
						
						folderName = GetFolderName (folder)
						makedir (_dir2+"\\"+folderName+"\\")
						CopyDir (folder) (_dir2+"\\"+folderName+"\\")
					)
				)else
				(
					installRollOut.SetMessage "Error : Not enough accessRights, try to run 3ds max as administrator"
				)
			
	),
	function Find_MZP_url =(
		local url = sysInfo.tempdir as string;
		
		local folders = getDirectories (url+"mzptmp*");--temporay MZP folders
		
		local _mathchUrls = #();
		local _matchDates = #();
		local _folderNumbers = #();
		local _pCnt = 0.0;
		for f in folders do (
			_pCnt+=1.0;
			
			--find the right folder and file from theh MZP archive
			local  has_versionTextFile= getFiles (f+m_Version+".txt");
			local  has_folder= getDirectories (f+m_ProjectName);
			local  has_random= getFiles (f+m_RandomNumber);
			local  has_mzp= getFiles (f+"mzp.run");
			
			local p = _pCnt / folders.count* 18.0;
			
			if (has_folder.count == 1 and has_mzp.count == 1 and has_versionTextFile.count == 1 and has_random.count == 1)then(
				local _date = getFileCreateDate has_mzp[1];
				
				append _matchDates _date;
				append _mathchUrls f;
				
				posStartFolder = (findString f "mzptmp")+6
				posEndFolder = (f.count - posStartFolder )
				
				Foldernumber = substring f posStartFolder posEndFolder
				
				append _folderNumbers (Foldernumber as number)
			)
		)
		
		if (_mathchUrls.count > 0)then(
			
			local _highestnumber = amax _folderNumbers
			local _new = amax _matchDates;--the latest date item
			
			local _indx = findItem _matchDates _new;
			local final_url = _mathchUrls[_indx];
			
			return final_url;
		)else(
			return "";
		)
	),
	fn DirectoryExists _path=(),
	fn ApplyMaxscriptManager=(
		if(m_ScriptID == "" and m_RepoUrl== "")then(
			
			MaxScriptManager_Manual_install m_ProjectName m_Author
		)else(
			MaxScriptManager_install m_ProjectName m_ScriptID m_RepoUrl m_Version
		)
			
	),
	fn RunUserInstallScript=(
		scriptPathToLaunch = ""
		append scriptPathToLaunch (("$"+m_Location))
		
		append scriptPathToLaunch "\\"
		append scriptPathToLaunch m_ProjectName
		append scriptPathToLaunch "\\"
		append scriptPathToLaunch m_ScriptNameToLaunch
		
		filein(scriptPathToLaunch)
		
	),
	fn DirectoryExists _path=(
		_path
		pathArr = filterstring _path "\\"
		parentFolder = ""
		arrSize= ((pathArr.count))
		for i = 1 to (arrSize-1) do(
			append parentFolder pathArr[i]
			append parentFolder "\\"
		)
		filesArr = (getdirectories (parentFolder+"*"))
		for file in filesArr do(
			if((toUpper file) == (toUpper _path))then(
				return true
			)
		)
		return false
	),
	fn installApp final_url=(
			--prepare to copy files
			local _scriptDir = pathConfig.GetDir (execute("#"+m_Location))+"\\" + m_ProjectName + "\\";
			if((DirectoryExists _scriptDir))then(

			)
				
			local accessFolder = makeDir _scriptDir;
			if(accessFolder != true)then(
				installRollOut.SetMessage "Error : Not enough accessRights, try to run 3ds max as administrator"
				return false
			)
				--copy directories
				local folders = getDirectories (final_url+""+m_ProjectName+"\\*");
				
				for f in folders do(
					folderName = GetFolderName (f)
					makedir (_scriptDir+""+folderName+"\\")
					CopyDir f (_scriptDir+""+folderName+"\\")
				)
				
				local _filesSource = getFiles (final_url+""+m_ProjectName+"\\*");
				
				local _pCnt = 0.0;
				
				--copy content for ToTex
				for sf in _filesSource do (
					_pCnt+=1.0;

					local tf = _scriptDir+"\\"+filenameFromPath sf;
					
					local accessFile = deleteFile tf;--try to delete the icons if they can not be replaced below
					local accessFile = copyFile sf tf;

					if (accessFile == true)then(
						local p = (_pCnt / _filesSource.count) * 50.0+25.0;
						
					)else(
						failing = true;
					)
				)
				
				return true
				
			
			
				
	
	

	),
	fn StartDefaultUninstall=(
		
		
		
		m_MZP_Url
		userScriptFolderPath = (pathConfig.GetDir (execute("#"+m_Location))+"\\" + m_ProjectName + "\\")
		if(DirectoryExists userScriptFolderPath)then(
			DeleteDosCommand = "RMDIR \""
			DeleteDosCommand = append DeleteDosCommand userScriptFolderPath
			DeleteDosCommand = append DeleteDosCommand "\" /S /Q"
			DOSCommand DeleteDosCommand
		)
		return true
	),
	fn StartMZPUninstall=(
		if(m_ScriptID == "" and m_RepoUrl== "")then(
			MaxScriptManager_Manual_uninstall m_ProjectName m_Author
		)else(
			MaxScriptManager_uninstall m_ScriptID m_RepoUrl	
		)
		
		
		
		
		
		if( m_UninstallScript == "")then(
			res = StartDefaultUninstall()
			return res
		)
		possibleUrl = m_mzpInstall_System.Find_MZP_url()
		if(possibleUrl != "")then(
			m_MZP_Url= possibleUrl
		)
		
		if((getfiles (m_MZP_Url+m_ProjectName+"\\"+m_UninstallScript)).count == 0)then(
			res = querybox ("The uninstall script was not found. Do you want me to remove the '"+m_ProjectName+"' folder in '$"+m_Location+"' ?\n\nYes = Remove the folder and its content\nNo = Abort Uninstall")
			if(res)then(
				res2=StartDefaultUninstall()	
				return res2
			)else(
				return false
			)
			
			return true
		)
		
		filein((m_MZP_Url+m_ProjectName+"\\"+m_UninstallScript))
		
		return true
	),
	fn StartMZPInstall=(
		final_url = Find_MZP_url();
		if(final_url == "")then(
			installRollOut.SetMessage "Error : Could not locate files in Temporary Folder"
			return false
		)
		res = installApp final_url
		if(res == true)then(
			
			if(m_MSPM_MZPIsUpdate != true)then(
				installRollOut.SetMessage (m_ProjectName + " Is Installed")
			)
			
			if(m_MSPM_MZPIsUpdate != true and (m_MZP_IsUpDatable == "true"))then(
				createdialog Install_EnableAutoUpdate_Rollout	
			)
		)else if(res == "ABORT")then(
-- 			installRollOut.SetMessage "Error : Could Not Install"
			return false
		)else(
			if(m_MSPM_MZPIsUpdate != true)then(
				installRollOut.SetMessage "Error : Could Not Install"
			)
			return false
		)
		if(m_MaxscriptManagerBool == true)then(
			ApplyMaxscriptManager()	
		)
		RunUserInstallScript()
		return true
	),
	fn ShowUpdate=(
		urlString = m_mzpInstall_System.Find_MZP_url()
		updateInfoText = urlString+"updateInformation.txt"
		
		res = (doesfileexist updateInfoText)
		
		if(res)then(
			fs = openfile updateInfoText
			messageStr = ""
			while (eof fs == false) do(
				lineStr = (readLine fs)
				messageStr += lineStr 
				messageStr += "\n\r"
			)
			close fs
			
			
			if(messageStr.count == 0)then(
				messageStr= "No Information Was Found About This Update"
			)
			m_Update_Text_Message = messageStr
			createdialog MZP_updateInformation_Rollout
		)
	),
	fn Start=(
		
		
		if(m_MSPM_MZPIsUpdate == true)then(
			--found out that this is an update MZP
			res = m_mzpInstall_System.StartMZPInstall()
			if(res == true)then(
				ShowUpdate()
			)else(
				
			)
			m_MSPM_MZPIsUpdate = false
		)else(
			styleFlags =#()
			append styleFlags #style_sysmenu
			append styleFlags #style_minimizebox
			append styleFlags #style_titlebar
			append styleFlags #style_toolwindow
			CreateDialog installRollOut style:styleFlags menu:installRollout_menu
		)
		
	)
)

-- m_mzpInstall_System = mzpInstall_System()
-- m_mzpInstall_System.Initiate()

global m_mzpInstall_System
m_mzpInstall_System = mzpInstall_System()
m_mzpInstall_System.Initiate()
m_mzpInstall_System.Start()

/*
*
*/

--fn MaxScriptManager_Manual_install theName theID theRepo theVersion =

fn MaxScriptManager_Manual_uninstall theName theAuthor=(
	-- Script
	userScriptFolder = (symbolicPaths.getPathValue("$userScripts")+"\\")
	scriptLocation = userScriptFolder+"MaxScriptManager\\SCRIPT_Manual\\"
	
	HiddenDotNetCommand "cmd.exe" ("/K rmDir " + "\"" + (scriptLocation + m_ProjectName + "\\") + "\"" + " /s /q") ""

	
	--Let's check if there is a INI file already there with the same ID and Repository URL
	for f in getFiles "$userscripts\\MaxScriptManager\\INI_Manual\\*.ini" do
	(
		f_Name = getINIsetting f "Script" "Name"
		f_Author = getINIsetting f "Script" "Author"

		if f_Name == theName AND f_Author == theAuthor do
		(
			--Yes, we found a script with the same ID and Repository URL
			--Just delete it
			deleteFile f
			--Refresh the MaxScriptManager Listview
			if doesFileExist "$userscripts\\MaxScriptManager\\MSM_Functions.ms" do 
			(
				filein "$userscripts\\MaxScriptManager\\MSM_Functions.ms"
				try
				(
					fill_lv_1()
				)
				catch()
			)
		)
	)
)

fn MaxScriptManager_Manual_install theName theAuthor=(
	-- copy the mzp content
	mzpTemp = m_mzpInstall_System.Find_MZP_url()
	scriptLocation = "$userscripts\\MaxScriptManager\\SCRIPT_Manual\\"
	makedir scriptLocation
	m_mzpInstall_System.copyDir mzpTemp (scriptLocation + m_ProjectName)	
	
	
	--First we create the Folder structure
	makedir "$userscripts\\MaxScriptManager\\INI_Manual\\"
	
	SCRIPT_Manual
	
	ini_filePath = ("$userscripts\\MaxScriptManager\\INI_Manual\\" + theName + "_" + theAuthor + ".ini")
-- 		setINIsetting ini_filePath "Script" "MD5"
-- 		setINIsetting ini_filePath "Script" "RunFile" ""
	
	siteUrlToPut = m_Site
	if(m_Site == "")then(
		siteUrlToPut = m_Author_Site
	)
	setINIsetting ini_filePath "Script" "Website" siteUrlToPut
	setINIsetting ini_filePath "Script" "LocalVersion" ""
	setINIsetting ini_filePath "Script" "MZP"  (scriptLocation + m_ProjectName + "\\" + "mzpInstall.ms")
	setINIsetting ini_filePath "Script" "Name" theName
	setINIsetting ini_filePath "Script" "Author" theAuthor
	
	
	scriptPathToLaunch = ""
	append scriptPathToLaunch (("$"+m_Location))
	append scriptPathToLaunch "\\"
	append scriptPathToLaunch m_ProjectName
	append scriptPathToLaunch "\\"
	append scriptPathToLaunch m_ScriptNameToLaunch
	
	setINIsetting ini_filePath "Script" "RunFile" scriptPathToLaunch
	

	
	--Refresh the MaxScriptManager Listview
	if doesFileExist "$userscripts\\MaxScriptManager\\MSM_Functions.ms" do 
	(
		filein "$userscripts\\MaxScriptManager\\MSM_Functions.ms"
		try
		(
			fill_lv_1()
		)
		catch()
	)
)


/*
MaxScriptManager install/uninstall functions - V.1.2
*/

---------------------------------------------------------------------------------------------------
-- Place this function in your "install" script.
--Example:
--MaxScriptManager_install "GoMax" "264506456" "http://www.norman3d.com/repo.msr" "2.2"
---------------------------------------------------------------------------------------------------
fn MaxScriptManager_install theName theID theRepo theVersion =
(
	--First we create the Folder structure
	makedir "$userscripts\\MaxScriptManager\\INI_Auto\\"
	
	--Let's check if there is a INI file already there with the same ID and Repository URL
	found_theFile = false
	for f in getFiles "$userscripts\\MaxScriptManager\\INI_Auto\\*.ini" do
	(
		f_ID = getINIsetting f "Script" "ID"
		f_theRepo = getINIsetting f "Script" "Repo"
		--Yes, we found a script with the same ID and Repository URL
		if f_ID == theID AND f_theRepo == theRepo do
		(
			--Let's update the Version
			found_theFile = true
			setINIsetting f "Script" "LocalVersion" theVersion
		)
	)
	
	--If we did not find the INI file, let's create it
	if found_theFile == false do
	(
		setINIsetting ("$userscripts\\MaxScriptManager\\INI_Auto\\" + theName + "_" + theID + ".ini") "Script" "Repo" theRepo
		setINIsetting ("$userscripts\\MaxScriptManager\\INI_Auto\\" + theName + "_" + theID + ".ini") "Script" "ID" theID
		setINIsetting ("$userscripts\\MaxScriptManager\\INI_Auto\\" + theName + "_" + theID + ".ini") "Script" "LocalVersion" theVersion
	)
	
	--Finally let's add the repository URL to the repository list.
	theRepoList = "$userscripts\\MaxScriptManager\\Repositories.ini"
	if doesFileExist theRepoList do 
	(
		itemCount = (getINIsetting theRepoList "Repositories" "Count") as integer
		--Is the Repo already in the list?
		is_repo_in_list = false
		for i=1 to itemCount do
		(
			f_repo = getINIsetting theRepoList "Repositories" ("Item_" + (i as string))
			if f_repo == theRepo do
			(
				--Yes it's already there, no need to add it
				is_repo_in_list = true
			)
		)
		if is_repo_in_list == false do
		(
			setINIsetting theRepoList "Repositories" "Count" ((itemCount + 1) as string)
			setINIsetting theRepoList "Repositories" ("Item_" + ((itemCount + 1) as string)) theRepo
		)
	)
	
	--Refresh the MaxScriptManager Listview
	if doesFileExist "$userscripts\\MaxScriptManager\\MSM_Functions.ms" do 
	(
		filein "$userscripts\\MaxScriptManager\\MSM_Functions.ms"
		try
		(
			fill_lv_1()
		)
		catch()
	)
)

---------------------------------------------------------------------------------------------------
-- Place this function in your "install" script.
--Example:
--MaxScriptManager_uninstall "264506456" "http://www.norman3d.com/repo.msr"
---------------------------------------------------------------------------------------------------
fn MaxScriptManager_uninstall theID theRepo =
(
	--Let's check if there is a INI file already there with the same ID and Repository URL
	for f in getFiles "$userscripts\\MaxScriptManager\\INI_Auto\\*.ini" do
	(
		f_ID = getINIsetting f "Script" "ID"
		f_theRepo = getINIsetting f "Script" "Repo"

		if f_ID == theID AND f_theRepo == theRepo do
		(
			--Yes, we found a script with the same ID and Repository URL
			--Just delete it
			deleteFile f
			--Refresh the MaxScriptManager Listview
			if doesFileExist "$userscripts\\MaxScriptManager\\MSM_Functions.ms" do 
			(
				filein "$userscripts\\MaxScriptManager\\MSM_Functions.ms"
				try
				(
					fill_lv_1()
				)
				catch()
			)
		)
	)
)

---------------------------------------------------------------------------------------------------
-- HiddenDotNetCommand
---------------------------------------------------------------------------------------------------

fn HiddenDotNetCommand exe args input=
(
	dnp = CreateDotNetProcessor()
	dnp.execute exe args input
)



fn CreateDotNetProcessor = 
(
	if dotnet.GetType "DotNetProcessor" == undefined do
	(
		format "Constructing .NET Processor...\n"
		-- If layout of this text looks ragged, press ctrl-F11 to switch to a monospaced font...
		sb = ""
		sb +="    using System;																			\n"
		sb +="    using System.Text;																	\n"
		sb +="    using System.Diagnostics;																\n"
		sb +="																							\n"
		sb +="    class DotNetProcessor																	\n"
		sb +="    {																						\n" 
		sb +="																							\n"
		sb +="		private static StringBuilder stdOut = null;											\n"
		sb +="		private static StringBuilder stdErr = null;											\n"
		sb +="																							\n"
		sb +="		public String Output() { return stdOut == null ? \"\" : stdOut.ToString(); }		\n"
		sb +="		public String Errors() { return stdErr == null ? \"\" : stdErr.ToString(); }		\n"
		sb +="																							\n"
		sb +="		public void Execute(String filename, String args, String stdinbuff)					\n"
		sb +="		{																					\n"
		sb +="			Process p = new System.Diagnostics.Process();									\n"
		sb +="																							\n"
		sb +="			stdErr = new StringBuilder();													\n"
		sb +="			stdOut = new StringBuilder();													\n"
		sb +="			                               													\n"
		sb +="			p.EnableRaisingEvents = true;													\n"
		sb +="			p.StartInfo.FileName = filename;												\n"
		sb +="			p.StartInfo.Arguments = args;													\n"
		sb +="			p.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden	;		\n"
		sb +="			p.StartInfo.UseShellExecute = false;											\n"
		sb +="			p.StartInfo.RedirectStandardOutput = true;										\n"
		sb +="			p.StartInfo.RedirectStandardError = true;										\n"
		sb +="			p.StartInfo.RedirectStandardInput = stdinbuff.Length > 0;						\n"
		sb +="																							\n"
		sb +="			p.StartInfo.CreateNoWindow = true;												\n"
		sb +="																							\n"
		sb +="			p.OutputDataReceived += new DataReceivedEventHandler(OutputHandler);			\n"
		sb +="			p.ErrorDataReceived += new DataReceivedEventHandler(ErrorHandler);				\n"
		sb +="																							\n"
		sb +="			p.Start();																		\n"
		sb +="																							\n"
		sb +="			if (stdinbuff.Length > 0)														\n" 
		sb +="			{																				\n"
		sb +="				p.StandardInput.Write(stdinbuff);											\n"
		sb +="				p.StandardInput.Close();													\n"
		sb +="			}																				\n"
		sb +="																							\n"
		sb +="			stdErr = new StringBuilder();													\n"
		sb +="			stdOut = new StringBuilder();													\n"
		sb +="																							\n"
		sb +="			p.BeginOutputReadLine();														\n"
		sb +="			p.BeginErrorReadLine();															\n"
		sb +="																							\n"
		sb +="			p.WaitForExit();																\n"
		sb +="			p.Close();																		\n"	
		sb +="		}																					\n"
		sb +="																							\n"
		sb +="		private static void OutputHandler(object sendingProcess, DataReceivedEventArgs d)	\n"
		sb +="		{																					\n"
		sb +="			if (!String.IsNullOrEmpty(d.Data)) stdOut.Append(d.Data + \"\\n\");				\n"
		sb +="		}																					\n"
		sb +="																							\n"
		sb +="		private static void ErrorHandler(object sendingProcess, DataReceivedEventArgs d)	\n"
		sb +="		{																					\n"
		sb +="			if (!String.IsNullOrEmpty(d.Data)) stdErr.Append(d.Data + \"\\n\");				\n"
		sb +="		}																					\n"
		sb +="   }																						\n"

		csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
		compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
		
		compilerParams.ReferencedAssemblies.Add("System.dll");
		
		compilerParams.GenerateInMemory = true
		compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(sb)
		
		if (compilerResults.Errors.Count > 0 ) then
		(
			errs = stringstream ""
			for i = 0 to (compilerResults.Errors.Count-1) do
			(
				err = compilerResults.Errors.Item[i]
				format "Error:"+err.ErrorNumber+" Line:"+err.Line+" Column:"+err.Column+" "+err.ErrorText+"\n" to:errs
			)
			MessageBox (errs as string) title: "Errors encountered while compiling C# code"
			return undefined
		)
	)
	dotnetobject "DotNetProcessor"	
)
--createdialog MZP_updateInformation_Rollout
