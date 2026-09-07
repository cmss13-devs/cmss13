SUBSYSTEM_DEF(human_medhud)
	name       = "Human MedHUD"
	wait       = 2 SECONDS
	flags      = SS_NO_INIT | SS_KEEP_TIMING
	priority   = SS_PRIORITY_HUMAN_MEDHUD

	var/list/mob/living/carbon/human/currentrun

/datum/controller/subsystem/human_medhud/fire(resumed = FALSE)
	if(!resumed)
		currentrun = SShuman.processable_human_list.Copy()

	while(length(currentrun))
		var/mob/living/carbon/human/mob = currentrun[currentrun.len]
		currentrun.len--

		update_huds(mob)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/human_medhud/proc/update_huds(mob/living/carbon/human/mob)
	mob.med_hud_set_status()
