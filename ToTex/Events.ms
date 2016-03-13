struct ToTex_Events(
	m_EventListenerArr,	-- Array : This will contain all the listeners
	fn Initiate=(
		-- Filling in variabels with content
		m_EventListenerArr = #()
	), -- End Initiate
	fn RemoveEventListener _eventName _function=(
		-- Loop through all the events
		for i = 1 to m_EventListenerArr.count do(
			eventObj = m_EventListenerArr[i]
			-- If you find the correct event
			if(eventObj[1] == _eventName and eventObj[2] == _function)then(
				-- Remove it from the array and exit this for loop
				deleteItem m_EventListenerArr i
				exit
			)
		)
	), -- End RemoveEventListener
	fn AddEventListener _eventName _function=(
		-- Add an eventlistener to the EventListenerArr
		-- It will contain the event name and the function that it needs to call
		eventSlot = #(_eventName, _function)
		append m_EventListenerArr eventSlot
	),
	fn DispatchEvent _eventName=(
		-- Will send the event and announce this to all the listeners
		for eventObj in m_EventListenerArr do(
			if(eventObj[1] == _eventName)then(
				-- launch the function that the listener has given
				eventObj[2]()
			)
		)
	) -- End DispatchEvent
)

m_ToTex_Events = ToTex_Events()
m_ToTex_Events.Initiate()
-- m_ToTex_Events.AddEventListener "test" myTest
