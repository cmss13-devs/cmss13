/obj/effect/alien/resin/special/evolution_pod
	name = "Evolution pod"
	icon = 'icons/mob/xenos/cocoons.dmi'
	var/icon_prefix = "t2"
	icon_state = "t2_cocoon"
	var/mob/living/carbon/xenomorph/occupant
	var/open = FALSE

/obj/effect/alien/resin/special/evolution_pod/update_icon()
	. = ..()
	if(open)
		icon_state = "[icon_prefix]_cocoon_hatch"
		return
	if(!occupant && icon_state != "[icon_prefix]_cocoon_bursting") //so we do not trigger the animation more then once
		icon_state = "[icon_prefix]_cocoon_bursting"

/obj/effect/alien/resin/special/evolution_pod/update_health(damage)
	if(occupant && health - damage < 100)
		burst_open()
		return
	. = ..()

/obj/effect/alien/resin/special/evolution_pod/proc/burst_open()
	occupant.forceMove(src.loc)
	occupant = null
	update_icon()



/obj/effect/alien/resin/special/evolution_pod/proc/enter_pod(mob/living/carbon/xenomorph/xeno)
	xeno.forceMove(src)
	occupant = xeno
	RegisterSignal(occupant, COMSIG_PARENT_QDELETING, PROC_REF(open_pod))

/obj/effect/alien/resin/special/evolution_pod/proc/open_pod()
	open = TRUE
	update_icon()





/obj/effect/alien/resin/special/evolution_pod/tier_two
	name = "Tier two evolution pod"

/obj/effect/alien/resin/special/evolution_pod/tier_three
	name = "Tier three evolution pod"
	icon_prefix = "t3"


