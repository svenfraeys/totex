
struct WindowSaver(
	m_Rollout,
	m_Name,
	m_Folder,
	m_IniLocation,
	fn GetIni _paramString=(
		return ((getinisetting m_IniLocation m_Name _paramString) as number)
	),
	fn SetIni _name _value=(
		setinisetting m_IniLocation m_Name _name (_value as string)
	),
	fn Load applySize:false applyPosition:true=(
		if(applyPosition)then(
			x =(GetIni "x")
			y = (GetIni "y")
			setDialogPos m_Rollout [x,y]	
		)
		if(applySize)then(
			m_Rollout.width = (GetIni "width")
			m_Rollout.height = (GetIni "height")	
		)
		
	),
	fn Initiate _ini _rollout applySize:false applyPosition:true=(
		m_Rollout = _rollout
		m_Name = m_Rollout.name
		m_IniLocation = _ini
		Load applySize:applySize applyPosition:applyPosition
	),

	fn Save=(
		pos = getDialogPos m_Rollout
		size = getDialogSize m_Rollout
		
		setIni "x" pos.x
		setIni "y" pos.y
		setIni "width" size.x
		setIni "height" size.y
	),
	fn onOpen _ini _rollout applySize:false applyPosition:true=(
		Initiate _ini _rollout applySize:applySize applyPosition:applyPosition
	),
	fn onClose=(
		Save()
	),
	fn open  _ini _rollout=(
		initiate _ini _rollout
-- 		load()
	),
	fn close =(
		save()
	)
)