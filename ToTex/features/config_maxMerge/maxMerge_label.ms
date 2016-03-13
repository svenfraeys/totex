-- Test
iniPath = "$userScripts/totex/features/config_maxMerge/settings.ini"

maxMergeStr = (getinisetting iniPath "settings" "maxFile")

if(maxMergeStr != "")then(
	labelString = (getFilenameFile maxMergeStr)+(getFilenameType maxMergeStr)
	label_returnValue = labelString
)else(
	label_returnValue = "Max Merge"
)




-- return true