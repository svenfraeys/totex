try(
	destroydialog easyMessagebox_Rollout
)catch()
struct EasyMessagebox_System(
	fn ShowMessage _string=(
		try(
			destroydialog easyMessagebox_Rollout
		)catch()
		createdialog easyMessagebox_Rollout style:#()
		easyMessagebox_Rollout.SetMessage _string
		
	)
)

rollout easyMessagebox_Rollout ""(
	dotNetControl Text_Message "system.windows.forms.label" text:"Configuration"
	
	fn SetMessage _messageStr=(
		Text_Message.text = _messageStr
		beep = dotnetclass "System.Media.SystemSounds"
		beep.asterisk.play()
	)
	on Text_Message mouseClick _args do(
		destroyDialog easyMessagebox_Rollout
	)
	on Text_Message mouseMove _args do(
		cursor = dotnetclass "system.windows.forms.cursors"
		Text_Message.Cursor.Current = cursor.hand
	)
	on easyMessagebox_Rollout open do(
		
		Text_Message.pos.x = 0
		Text_Message.pos.y = 0
		Text_Message.width = easyMessagebox_Rollout.width
		Text_Message.height = easyMessagebox_Rollout.height
		Text_Message.TextAlign= Text_Message.TextAlign.MiddleCenter
	)
)


m_EasyMessagebox_System = EasyMessagebox_System()
m_EasyMessagebox_System.ShowMessage "This is not good"