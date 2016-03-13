m_IniPath = "$userScripts/totex/features/config_MaxMerge/settings.ini"
maxFileStr = (getinisetting m_IniPath "settings" "maxFile")

myxRefScene = xrefs.addNewXRefFile maxFileStr

Global m_ToTex_MaxMerge_XRef
m_ToTex_MaxMerge_XRef = myxRefScene

if(myxRefScene == undefined and maxFileStr != "")then(
	messageBox ("could not locate Max Merge:\n" + maxMergePath)
)