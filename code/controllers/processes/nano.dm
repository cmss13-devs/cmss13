datum/controller/process/nano

datum/controller/process/nano/setup()
	name = "Nano UI"
	schedule_interval = 60 //6 seconds

datum/controller/process/nano/doWork()

	var/i = 1
	while(i<=nanomanager.processing_uis.len)
		var/datum/nanoui/ui = nanomanager.processing_uis[i]
		if(ui)
			ui.process()
			individual_ticks++
			i++
			continue
		nanomanager.processing_uis.Cut(i,i+1)
		if(STUI.processing)		// Only do this if there is something processing.
			for(var/mob/M in admins)		// Cheaty fix to stop processing a list if it hasn't changed
				if(M:open_uis)
					for(var/datum/nanoui/stui in nanomanager.processing_uis)	// need to wait until all UI's are processed
						if(stui.title == "STUI")
							STUI.processing.Remove(ui.user.STUI_log)