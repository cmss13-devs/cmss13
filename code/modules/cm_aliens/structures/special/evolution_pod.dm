/obj/effect/alien/resin/special/evolution_pod
	name = "Evolution pod"
	icon = 'icons/mob/xenos/cocoons.dmi'
	var/icon_prefix = "t2"
	icon_state = "t2_cocoon"

/obj/effect/alien/resin/special/evolution_pod/update_icon()
	. = ..()
	if(!length(contents))
		if(health > 100)
			icon_state = "[icon_prefix]_cocoon_hatch"
		else
			icon_state = "[icon_prefix]_cocoon_explode"

/obj/effect/alien/resin/special/evolution_pod/tier_two
	name = "Tier two evolution pod"

/obj/effect/alien/resin/special/evolution_pod/tier_three
	name = "Tier three evolution pod"
	icon_prefix = "t3"


