procedure( IPHgridLinesMenu()
    prog( (cv techName techId mfgGrid defaultGrid
	title gridChoices
    )
	(cv = geGetWindowCellView())
	(techName = ((cv~>lib)~>techLibName))
	(techId = techGetTechFile((cv~>lib)))
	(mfgGrid = float(techGetMfgGridResolution(techId)))
	(defaultGrid = sprintf(nil "%Lx%L" mfgGrid mfgGrid))
	(title = sprintf(nil "Grid Setting For %s" techName))
	printf("Grid Setup For Library CellView: %s/%s/%s (Reference TechLib: %s)\n" 
	    (cv~>libName) 
	    (cv~>cellName) 
	    (cv~>viewName) techName
	)
	case( techName
	    (("tsmcN16" || "tsmcN16_Inphi_pCells")
		(gridChoices = list("0.005x0.012" "0.010x0.012" "0.010x0.048" "0.100x0.100" "0.010x0.010"
			"Custom"
		    )))
	    (t
		(gridChoices = list("0.01x0.01" "0.05x0.05" "0.1x0.1" "0.5x0.5" "1x1"
			"5x5" "Custom"
		    )))
	)
	IPHlayGridSetup(cv defaultGrid gridChoices title)
    )
)



procedure( IPHlayGridSetup(cvId defaultGrid gridChoices title)
    prog( (winId gridStringField gridRadioField IPHlayGridSetup_AppForm)
	(winId = hiGetCurrentWindow())
	(gridStringField = hiCreateStringField(?name 
		'gridStringFieldHandle ?prompt "XY Snap (um) " ?value
		defaultGrid ?defValue defaultGrid ?editable t
		?enabled t ?callback "IPHlayGridSetup_gridStringFieldCB(hiGetCurrentForm())"
	    ))
	unless(member(defaultGrid gridChoices) 
	    (gridChoices = cons(defaultGrid gridChoices))
	)
	(gridRadioField = hiCreateRadioField(?name 
		'gridRadioFieldHandle ?prompt "Snap To Grid\n" ?choices
		gridChoices ?itemsPerRow 3 ?callback 
		list("IPHlayGridSetup_gridRadioFieldCB(hiGetCurrentForm())")
ll *	    ))
	(IPHlayGridSetup_AppForm = hiCreateAppForm(?name 
		'IPHlayGridSetup_AppFormHandle ?fields 
		list(list(gridStringField 
			(0:0) 
			(250:10) 100
		    ) 
		    list(gridRadioField 
			(0:40) 
			(50:10) 100
		    )
		) ?formTitle
		title ?callback "IPHlayGridSetup_setGridCB(hiGetCurrentForm())"
	    ))
	hiDisplayForm(IPHlayGridSetup_AppForm)
	return(t)
    )
)


procedure( IPHlayGridSetup_gridStringFieldCB(the_form)
    prog( nil
	unless(member(((the_form~>gridStringFieldHandle)~>value) 
		((the_form~>gridRadioFieldHandle)~>choices)
	    ) 
	    setSGq((the_form~>gridRadioFieldHandle) "Custom" value) 
	    setSGq((the_form~>gridStringFieldHandle) 
		((the_form~>gridStringFieldHandle)~>value) value
	    )
	)
	IPHlayGridSetup_setGridCB(the_form)
	return(t)
    )
)



