datum/controller/process/xenolife

datum/controller/process/xenolife/setup()
	name = "Xeno Life"
	schedule_interval = 20 //2 seconds

datum/controller/process/xenolife/doWork()

	for(var/mob/living/carbon/Xenomorph/X in living_xeno_list)
		if(X)
			X.Life()
			continue
		living_xeno_list -= X
