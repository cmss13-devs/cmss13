/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/hud/screen1.dmi'
	icon_state = "x"
	unacidable = TRUE//Just to be sure.

/obj/effect/manifest/Initialize()
	. = ..()
	invisibility = 101

/obj/effect/manifest/proc/manifest()
	var/dat = "<B>Crew Manifest</B>:<BR>"
	for(var/mob/living/carbon/human/current_mob in GLOB.human_mob_list)
		if(current_mob.species && current_mob.species.name == "Yautja")
			continue
		dat += text(" [] <B>[]</B> -  []<BR>", current_mob.get_paygrade(0), current_mob.name, current_mob.get_assignment())
	var/obj/item/paper/new_paper = new /obj/item/paper( src.loc )
	new_paper.info = dat
	new_paper.name = "paper- 'Crew Manifest'"
	//SN src = null
	qdel(src)
	return
