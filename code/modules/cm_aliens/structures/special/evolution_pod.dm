/obj/effect/alien/resin/special/evolution_pod
	name = "evolution pod"
	icon = 'icons/mob/xenos/cocoons.dmi'
	icon_state = "t2_cocoon"
	pixel_x = -32
	pixel_y = -32

	var/icon_prefix = ""

	var/mob/living/carbon/xenomorph/occupant
	var/open = FALSE //if we did open voluntarly
	var/exploading = FALSE
	var/exploaded = FALSE

/obj/effect/alien/resin/special/evolution_pod/update_icon()
	. = ..()
	if(open)
		icon_state = "[icon_prefix]_cocoon_hatch"
		return
	if(!occupant && exploading && !exploaded) //so we do not trigger the animation more then once
		icon_state = "[icon_prefix]_cocoon_explode"
		exploaded = TRUE
		return
	if(!open && !exploaded)
		icon_state = "[icon_prefix]_cocoon" //first update icon is called on init and occupant is not in we need to update it afterwards
/obj/effect/alien/resin/special/evolution_pod/Destroy()
	. = ..()
	if(occupant) //this should not be possible but better safe then sorry
		burst_open()


/obj/effect/alien/resin/special/evolution_pod/healthcheck()
	if(occupant && health < 0.25 * maxhealth && !open) //first time the hp would go low we instead eject the occupant and set fixed health of the pod
		burst_open()
		return
	. = ..()

/obj/effect/alien/resin/special/evolution_pod/proc/burst_open()
	health = 0.25 * maxhealth
	if(occupant)
		occupant.forceMove(get_turf(src))
		occupant.hive.remove_from_evo_list(occupant)
		UnregisterSignal(occupant, COMSIG_PARENT_QDELETING)
		UnregisterSignal(occupant, COMSIG_MOB_RESISTED)
		occupant = null
	exploading = TRUE
	update_icon()



/obj/effect/alien/resin/special/evolution_pod/proc/enter_pod(mob/living/carbon/xenomorph/xeno)
	xeno.forceMove(src)
	occupant = xeno
	update_icon()
	RegisterSignal(occupant, COMSIG_PARENT_QDELETING, PROC_REF(open_pod))
	RegisterSignal(occupant, COMSIG_MOB_RESISTED, PROC_REF(try_to_exit))

/obj/effect/alien/resin/special/evolution_pod/proc/try_to_exit()
	to_chat(src, "You are tring to get out of the [name]!")
	if(do_after(src, 2 SECONDS, INTERRUPT_ALL))
		burst_open()
	else
		to_chat(src, "You are no longer tring to get out of the [name]!")

/obj/effect/alien/resin/special/evolution_pod/proc/open_pod()
	UnregisterSignal(occupant, COMSIG_PARENT_QDELETING)
	UnregisterSignal(occupant, COMSIG_MOB_RESISTED)
	open = TRUE
	occupant = null
	update_icon()





/obj/effect/alien/resin/special/evolution_pod/tier_two
	icon_prefix = "t2"
	health = 550
	maxhealth = 550

/obj/effect/alien/resin/special/evolution_pod/tier_three
	icon_prefix = "t3"
	health = 650
	maxhealth = 650

