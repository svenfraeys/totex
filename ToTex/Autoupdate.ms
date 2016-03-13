--autoupdate
global m_MSPM_MZPIsUpdate = false

rollout ToTex_Upload_Rollout "Update ToTex" width:300(
	local m_IniPath
)

struct AutoUpdate_ToTex(
	m_ProjectFolder,
	m_AutoUpdateDir,
	m_AutoUpdateIni,
	m_InboxDir,
	function GetUpdateIniUrl=(
		m_AutoUpdateIni = (m_AutoUpdateDir+"version.ini")
		downloadUrl = getinisetting m_AutoUpdateIni "version" "download"
		return downloadUrl
	),
	function CreateNewVersionFile=(
		m_AutoUpdateIni = (m_AutoUpdateDir+"version.ini")
		createfile m_AutoUpdateIni
		dateTimeClass = dotnetclass ("DateTime")
		setinisetting m_AutoUpdateIni "version" "year" ((dateTimeClass.Now.Year) as string)
		setinisetting m_AutoUpdateIni "version" "month" ((dateTimeClass.Now.Month) as string)
		setinisetting m_AutoUpdateIni "version" "day" ((dateTimeClass.Now.Day) as string)
		setinisetting m_AutoUpdateIni "version" "hour" ((dateTimeClass.Now.Hour) as string)
		setinisetting m_AutoUpdateIni "version" "minutes" ((dateTimeClass.Now.Minute) as string)
		setinisetting m_AutoUpdateIni "version" "download" "http://sven.fraeys.be/fillMeIn.mzp"
	),
	function CreateInboxDir=(
		m_InboxDir=(m_AutoUpdateDir+"Inbox/")
		makedir m_InboxDir
	),
	function CreateUpdateDir=(
		m_AutoUpdateDir=(m_ProjectFolder+"autoUpdate/")
		makedir m_AutoUpdateDir
	),
	function Initiate _projectFolder=(
		
		m_ProjectFolder = _projectFolder
		CreateUpdateDir()
		CreateInboxDir()
		
		m_AutoUpdateIni = (m_AutoUpdateDir+"version.ini")
	),
	function GetValueAsInt _ini _str=(
		
		strVal = getinisetting _ini "version" _str
		intVal =(execute(strVal)) 
		return intVal
	),
	function CompareVersions _iniFileOriginal _iniFileUpdate=(
		(GetValueAsInt _iniFileOriginal "year")
		if ((GetValueAsInt _iniFileOriginal "year") < (GetValueAsInt _iniFileUpdate "year"))then(
			--update
			return true
		)
		
		if ((GetValueAsInt _iniFileOriginal "year") == (GetValueAsInt _iniFileUpdate "year"))then(
			--update
			if ((GetValueAsInt _iniFileOriginal "month") < (GetValueAsInt _iniFileUpdate "month"))then(
				--update
				return true
			)
			if ((GetValueAsInt _iniFileOriginal "month") == (GetValueAsInt _iniFileUpdate "month"))then(
				if ((GetValueAsInt _iniFileOriginal "day") < (GetValueAsInt _iniFileUpdate "day"))then(
					return true	
				)
				if ((GetValueAsInt _iniFileOriginal "day") == (GetValueAsInt _iniFileUpdate "day"))then(
					if ((GetValueAsInt _iniFileOriginal "hour") < (GetValueAsInt _iniFileUpdate "hour"))then(
						return true
					)
					if ((GetValueAsInt _iniFileOriginal "hour") == (GetValueAsInt _iniFileUpdate "hour"))then(
						if ((GetValueAsInt _iniFileOriginal "minutes") < (GetValueAsInt _iniFileUpdate "minutes"))then(
							return true
						)else(
							return false
						)
					)
				)
			)
			
		)
		
		return false
	),
	function DownloadMZPFromIni _ini=(
		MZPFilePath = getinisetting _ini "version" "mzp"
		
		downloadLocation =  (getDir #userscripts)+"\\"+ (getFilenameFile MZPFilePath)+".mzp"
		--messagebox downloadLocation
		try
		(
			(dotNetObject "System.Net.WebClient").downloadFile MZPFilePath downloadLocation
		)
		catch
		(
			messagebox "Error 404: File could not be downloaded."
		)
		if doesFileExist (downloadLocation) do
		(
			
			m_MSPM_MZPIsUpdate = true
			filein (downloadLocation)
			deleteFile (downloadLocation)
		)
	),
	function DownloadVersionIni _url=(
		deletefile (m_InboxDir+"version.ini")
		try
		(
			(dotNetObject "System.Net.WebClient").downloadFile _url (m_InboxDir+"version.ini")
		)
		catch
		(
			print "Update Error 404"
			return undefined
			
		)
		
		
		return (m_InboxDir+"version.ini")
	),
	function IsUpdateAvailable=(
		_url = GetUpdateIniUrl()
		iniFilePath = DownloadVersionIni _url
		if(iniFilePath == undefined)then(
			return undefined
		)
		updateBool = CompareVersions m_AutoUpdateIni iniFilePath
		if(updateBool == true)then(
			return (getinisetting iniFilePath "version" "version")
		)else(
			return undefined
		)
	),
	function CheckUpdate=(
		_url = GetUpdateIniUrl()
		iniFilePath = DownloadVersionIni _url
		if(iniFilePath == undefined)then(
			return false
		)
		updateBool = CompareVersions m_AutoUpdateIni iniFilePath
		if(updateBool == true)then(
			print "Update Found"
			createdialog ToTex_Upload_Rollout
			ToTex_Upload_Rollout.m_IniPath = iniFilePath	
			return true
		)else(
			print "No Update Found"
			return false
		)
	),
	function GetCurrentVersionString=(
		getinisetting m_AutoUpdateIni "version" "version"
	)
)

m_AutoUpdate_ToTex = AutoUpdate_ToTex()
m_AutoUpdate_ToTex.Initiate ((getdir #userScripts)+"/ToTex/")

rollout ToTex_Upload_Rollout "Update ToTex" width:300(
	local buttonSize = [100,30]
	local m_IniPath
	label l2 ""
	label label_Upload "New Update Available For ToTex !"
	label l "Do you want to install this?"
	label l3
	
	button btn_Yes "Yes" width:buttonSize[1] height:buttonSize[2] across:2
	button btn_No "No" width:buttonSize[1] height:buttonSize[2]
	
	function StartDownload _iniPath=(
		m_IniPath = _iniPath
	)
	
	
	on btn_No pressed do(
		destroyDialog ToTex_Upload_Rollout
	)
	
	on btn_Yes pressed do(
		destroyDialog ToTex_Upload_Rollout
		m_AutoUpdate_ToTex.DownloadMZPFromIni m_IniPath
		
	)
)





autoUpdateBool = getinisetting ((getdir #userScripts)+"/ToTex/settings.ini") "settings" "autoUpdate" 
if(autoUpdateBool== "true")then(
	m_AutoUpdate_ToTex.CheckUpdate()
)

/* Use This For Making New Version File (Publishing) */
--m_AutoUpdate_sketchUpImporters.CreateNewVersionFile()

