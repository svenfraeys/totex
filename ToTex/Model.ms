struct ToTex_Model(
	m_OriginalModel,
	m_Model,
	fn GetModel=(
		return m_Model
	),
	fn GetName=(
		return m_Model.name
	),
	fn Initiate _model=(
		m_Model = _model
		m_OriginalModel = m_Model
	),
	fn GetOriginalModel=(
		return m_OriginalModel
	),
	fn BakeState=(
		m_Model = copy m_OriginalModel
		converttopoly m_Model
		m_Model.name = m_OriginalModel.name
		m_Model.wirecolor = m_OriginalModel.wirecolor
-- 		m_Model = converttopoly m_Model
	),
	fn NoBakeState=(
		if(m_Model != m_OriginalModel)then(
			delete m_Model
			m_Model = m_OriginalModel
		)
	),
	fn SetModel _model=(
		m_Model = _model
	)
)

struct Totex_Model_System(
	fn Initiate=(
		
	),
	fn MakeToTexModelArr _objects=(
		returnArr = #()
		
		for obj in _objects do(
			_model = ToTex_Model()
			_model.Initiate obj
			append returnArr _model
		)
		
		return returnArr
		
	)
)
m_Totex_Model_System = Totex_Model_System()
m_Totex_Model_System.Initiate()
