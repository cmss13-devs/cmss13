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
	for(var/mob/living/carbon/human/M in mob_list)
		if(M.species && M.species.name == "Yautja") 
			continue
		dat += text("    [] <B>[]</B> -  []<BR>", M.get_paygrade(0), M.name, M.get_assignment())
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	qdel(src)
	return
