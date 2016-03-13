struct DialogMaster(
	fn Initiate=(
		
	),
	function DialogMaster_DestroyDialog _dialog=(
		try(
			destroyDialog _dialog
		)catch()
	),
	function DialogMaster_CreateDialog _dialog style_resizing:false type:1 menu:undefined pos:undefined=(
		DialogMaster_DestroyDialog _dialog
		styleFlags =#()
		append styleFlags #style_sysmenu
		append styleFlags #style_minimizebox
		append styleFlags #style_titlebar
		append styleFlags #style_toolwindow
		if(style_resizing)then(
			append styleFlags #style_resizing
		)
		if(menu ==undefined)then(
			if(pos != undefined)then(
				CreateDialog _dialog style:styleFlags pos:pos	
			)else(
				CreateDialog _dialog style:styleFlags
			)
			
		)else(
			if(pos != undefined)then(
				CreateDialog _dialog style:styleFlags menu:menu pos:pos
			)else(
				CreateDialog _dialog style:styleFlags menu:menu
			)
		)
	)
)

m_DialogMaster = DialogMaster()
m_DialogMaster.Initiate()
-- m_DialogMaster.DialogMaster_CreateDialog MSPM_ProjectView_Rollout