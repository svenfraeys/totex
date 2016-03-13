fn ResetDialog _ini _rolloutName=(
		setinisetting _ini _rolloutName "x" (150 as string)
		setinisetting _ini _rolloutName "y" (150 as string)
		setinisetting _ini _rolloutName "width" (0 as string)
		setinisetting _ini _rolloutName "height" (0 as string)
)

fn addButtonToolbarCheck _category _name=(
	Macro_Category=_category 
	Macro_Name=_name
	Macro_Extension = ".mcr"
	Macro_fileName = Macro_Category+"-"+Macro_Name+Macro_Extension
	pathToMacro = ((pathConfig.removePathLeaf((symbolicPaths.getPathValue "$userscripts")) + "\\ui\\usermacros\\"+Macro_fileName))
	theFile = pathToMacro
	
	AddButtonYesNo
	if(doesfileexist theFile)then(
		AddButtonYesNo = false	
	)else(
		AddButtonYesNo = true
	)
	
	return AddButtonYesNo
)
fn addButtonToolbar _category _name _addButtonYesNo=
(
	Macro_Category=_category 
	Macro_Name=_name
	Macro_Extension = ".mcr"
	Macro_fileName = Macro_Category+"-"+Macro_Name+Macro_Extension
	pathToMacro = ((pathConfig.removePathLeaf((symbolicPaths.getPathValue "$userscripts")) + "\\ui\\usermacros\\"+Macro_fileName))
	theFile = pathToMacro
	--Should we be adding it to the toolbar in the first place?
	
	AddButtonYesNo = _addButtonYesNo
	
	if AddButtonYesNo == true do
	(
		--Category and MacroScript name
		category_macroScript = filterString (getFilenameFile theFile) "-"
		maintoolbar_file = pathConfig.removePathLeaf((symbolicPaths.getPathValue "$userscripts")) + "\\ui\\MaxStartUI.cui"
		--First save our current CUI file as the MaxStartUI.cui
		deleteFile maintoolbar_file
		cui.saveConfigAs maintoolbar_file
		--Which Toolbar=
		ToolbarName = "Main Toolbar"
		--Get ItemCount
		current_itemcount = (getINISetting maintoolbar_file ToolbarName "ItemCount") as integer
		--Add 1 to ItemCount
		setINISetting maintoolbar_file ToolbarName "ItemCount" ((current_itemcount + 1) as string)
		--Add new Item
		setINISetting maintoolbar_file ToolbarName ("Item"+((current_itemcount) as string)) ("2|0|0|31|3|647394|" + category_macroScript[2] + "`" + category_macroScript[1] + "|0|0|" + "\"" + category_macroScript[2] + "\"" + "|" + "\"" + category_macroScript[2] + "\"" + "|-1|")
		--Finally we reload the MaxStartUI
		cui.loadConfig maintoolbar_file
	)
)

fn CreateMaxImageButtonIcon _folder _name=(
	ui_dir = cui.getDir ()
	size = "24"
	deletefile (ui_dir+"Icons\\"+_name+"_"+size+"i.bmp")
	deletefile (ui_dir+"Icons\\"+_name+"_"+size+"a.bmp")
	copyFile (_folder+""+_name+"_"+size+"i.bmp") (ui_dir+"Icons\\"+_name+"_"+size+"i.bmp")	
	copyFile (_folder+""+_name+"_"+size+"a.bmp") (ui_dir+"Icons\\"+_name+"_"+size+"a.bmp")	
	size = "16"
	deletefile (ui_dir+"Icons\\"+_name+"_"+size+"i.bmp")
	deletefile (ui_dir+"Icons\\"+_name+"_"+size+"a.bmp")
	copyFile (_folder+""+_name+"_"+size+"i.bmp") (ui_dir+"Icons\\"+_name+"_"+size+"i.bmp")
	copyFile (_folder+""+_name+"_"+size+"a.bmp") (ui_dir+"Icons\\"+_name+"_"+size+"a.bmp")	
	print (_folder+""+_name+"_"+size+"i.bmp")
)
CreateMaxImageButtonIcon ("$userScripts\\ToTex\\images\\") "ToTex"
colorman.reInitIcons()

res = addButtonToolbarCheck "ToTex" "ToTex"
--Install
macroScript ToTex
buttonText:"ToTex"
category:"ToTex"
icon:#("ToTex", 1)
(
	on execute do(
		filein("$userScripts/ToTex/ToTex.ms");
	)
)
addButtonToolbar "ToTex" "ToTex" res

ResetDialog "$userScripts/ToTex/ToTex_Rollout.ini" "ToTex_UserInterface_Rollout"

filein("$userScripts/ToTex/ToTex.ms")

m_ToTex_Settings.SetSaveRenderPath "c:\\"

