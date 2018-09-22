datum/controller/process/sun

datum/controller/process/sun/setup()
	name = "Xeno"
	schedule_interval = 20 

datum/controller/process/sun/doWork()
	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X)
			X.Life()
			continue
		living_xeno_list -= X
