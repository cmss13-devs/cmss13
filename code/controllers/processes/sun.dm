datum/controller/process/sun

datum/controller/process/sun/setup()
	name = "Xeno"
	schedule_interval = 20
	hang_warning_time = 5
	hang_alert_time = 10
	hang_restart_time = 50
	own_data = xeno_mob_list

datum/controller/process/sun/doWork()
	for(var/mob/living/carbon/Xenomorph/X in xeno_mob_list)
		if(X)
			X.Life()
			individual_ticks++
			continue
		xeno_mob_list -= X
