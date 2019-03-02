datum/controller/process/humanlife

datum/controller/process/humanlife/setup()
	name = "Human Life"
	schedule_interval = 20 //2 seconds

datum/controller/process/humanlife/doWork()

	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H)
			H.Life()
			individual_ticks++
			continue
		human_mob_list -= H
