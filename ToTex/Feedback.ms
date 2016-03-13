
try(destroydialog ToTex_Feedback_Rollout)catch()
rollout ToTex_Feedback_Rollout "Feedback" width:400 height:170(
	local buttonSize = [100,30]
	label txt_feedback "ToTex lives from your feedback!"
	label txt_feedback2 "If you find any bugs or have any cool ideas tell us!" offset:[0,10]
	label txt_feedback3 "I am happy to improve ToTex to a more enjoyable tool!"
	label txt_Sven "Sven Fraeys" align:#right offset:[-30,10]
	label txt_empty ""
	 
	button btn_Mail "E-mail" width:buttonSize[1] height:buttonSize[2] across:2
	button btn_Site "Site" width:buttonSize[1] height:buttonSize[2]
	on ToTex_Feedback_Rollout open do(
	
	)
	on btn_Mail pressed do(
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start("mailto:sven@fraeys.be?subject=Feedback ToTex 3.0")
	)
	on btn_Site pressed do(
		processClass = (dotnetclass "System.Diagnostics.Process")
		processClass.start("http://sven.fraeys.be/")
	)
	
)
--createdialog ToTex_Feedback_Rollout