datum/controller/process/sun

datum/controller/process/sun/setup()
	name = "Xeno"
	schedule_interval = 20

datum/controller/process/sun/doWork()
	for(var/mob/living/carbon/Xenomorph/X in xeno_mob_list)
		if(X)
			X.Life()
			continue
		xeno_mob_list -= X
