/*
	REND ABILITY
	3x3 aoe damage centred on the destroyer. Basic ability, spammable, low damage.
*/

/datum/action/xeno_action/onclick/rend/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK(xeno)
	xeno.spin_circle()
	for(var/mob/living/carbon/carbon in orange(1, xeno) - xeno)
		carbon.apply_armoured_damage(25)
		xeno.flick_attack_overlay(carbon, "slash")
		to_chat(carbon, SPAN_DANGER("[xeno] slices into you with its razor sharp talons"))

	xeno.visible_message(SPAN_DANGER("[xeno] slices around itself!"), SPAN_NOTICE("We slice around ourself!"))
	..()


/*
	DOOM ABILITY
	Destroyer channels for a while shrieks which turns off all lights in the vicinity and applies a mild daze
	Medium cooldown soft CC
*/

/datum/action/xeno_action/activable/doom/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK(xeno)

	addtimer(CALLBACK(src, PROC_REF(extinguish_lights), 1), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(extinguish_lights), 3), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(extinguish_lights), 5), 3 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(extinguish_lights), 7), 4 SECONDS)
	for(var/mob/living/carbon/carbon in orange(2, owner))
		carbon.Daze(1)

	apply_cooldown()
	..()

/datum/action/xeno_action/activable/doom/proc/extinguish_lights(range)
	for(var/obj/item/device/flashlight/flight in orange(range, owner))
		flight.turn_off_light()

/*
	DESTROY ABILITY
	Destroyer leaps into the air and crashes down damaging cades and mobs in a 3x3 area centred on him.
	Long cooldown high damage ability, massive damage against cades, highly telegraphed.
*/

#define LEAP_HEIGHT 210 //how high up swoops go, in pixels
#define LEAP_DIRECTION_CHANGE_RANGE 5 //the range our x has to be within to not change the direction we slam from

/datum/action/xeno_action/activable/destroy/use_ability(atom/target)

	// TODO: Make sure we're not targetting a space tile or a wall etc!!!

	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK(xeno)

	to_chat(xeno, SPAN_XENONOTICE("Our muscles tense as we prepare ourself for a giant leap."))
	if(!do_after(xeno, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(xeno, SPAN_XENONOTICE("We relax our muslces and end our leap."))
		return
	if(leaping || !target)
		return
	// stop swooped target movement
	leaping = TRUE
	ADD_TRAIT(owner, TRAIT_UNDENSE, "Destroy")
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "Destroy")
	owner.visible_message(SPAN_WARNING("[owner] takes a giant leap into the air!"))

	var/negative
	var/initial_x = owner.x
	if(target.x < initial_x) //if the target's x is lower than ours, swoop to the left
		negative = TRUE
	else if(target.x > initial_x)
		negative = FALSE
	else if(target.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)

	owner.face_atom(target)
	owner.emote("roar")

	//Initial visual
	var/obj/effect/temp_visual/destroyer_leap/F = new /obj/effect/temp_visual/destroyer_leap(owner.loc, negative, owner.dir)

	negative = !negative //invert it for the swoop down later

	var/oldtransform = owner.transform
	owner.alpha = 255
	animate(owner, alpha = 0, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(0.1 SECONDS)
		if(QDELETED(owner) || owner.stat == DEAD) //we got hit and died, rip us

			//Initial effect
			qdel(F)

			if(owner.stat == DEAD)
				leaping = FALSE
				animate(owner, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return
	owner.status_flags |= GODMODE
	//SEND_SIGNAL(owner, COMSIG_SWOOP_INVULNERABILITY_STARTED)

	new /obj/effect/xenomorph/xeno_telegraph(get_turf(target), 2 SECONDS)

	owner.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SLEEP_CHECK_DEATH(7, owner)

	while(target && owner.loc != get_turf(target))
		owner.forceMove(get_step(owner, get_dir(owner, target)))
		SLEEP_CHECK_DEATH(0.5, owner)

	animate(owner, alpha = 100, transform = matrix()*0.7, time = 7)
	// Ash drake flies onto its target and rains fire down upon them
	var/descentTime = 15

	//ensure swoop direction continuity.
	if(negative)
		if(ISINRANGE(owner.x, initial_x + 1, initial_x + LEAP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(owner.x, initial_x - LEAP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE

	//Visuals
	new /obj/effect/temp_visual/destroyer_leap/end(owner.loc, negative, owner.dir)


	animate(owner, alpha = 255, transform = oldtransform, descentTime)
	SLEEP_CHECK_DEATH(descentTime, owner)
	owner.mouse_opacity = initial(owner.mouse_opacity)
	//Sounds
	//playsound(owner.loc, 'sound/effects/meteorimpact.ogg', 200, TRUE)


	/// Actual Damaging Effects - Add stuff for cades - NEED TELEGRAPHS NEED EFFECTS

	for(var/mob/living/L in orange(1, owner) - owner)
		L.adjustBruteLoss(75)
		if(!QDELETED(L)) // Some mobs are deleted on death
			var/throw_dir = get_dir(owner, L)
			if(L.loc == owner.loc)
				throw_dir = pick(GLOB.alldirs)
			var/throwtarget = get_edge_target_turf(owner, throw_dir)
			L.throw_atom(throwtarget, 2, SPEED_REALLY_FAST, owner, TRUE)
			L.KnockDown(0.5)
			owner.visible_message(SPAN_WARNING("[L] is thrown clear of [owner]!"))

	/// DAMAGING CADES HERE

	for(var/obj/structure/barricade/cade in orange(2, owner))
		cade.add_filter("cluster_stacks", 2, list("type" = "outline", "color" = COLOR_RED, "size" = 1))
		cade.take_damage(250)

	for(var/mob/M in range(7, owner))
		shake_camera(M, 15, 1)

	REMOVE_TRAIT(owner, TRAIT_UNDENSE, "Destroy")
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "Destroy")

	SLEEP_CHECK_DEATH(1, owner)
	leaping = FALSE
	owner.status_flags &= ~GODMODE
	apply_cooldown()
	..()

/obj/effect/temp_visual/destroyer_leap
	icon = 'icons/mob/xenos/destroyer.dmi'
	icon_state = "Normal Destroyer Charging"
	layer = 4.7
	plane = -4
	pixel_x = -32
	duration = 10
	randomdir = FALSE

/obj/effect/temp_visual/destroyer_leap/Initialize(mapload, negative, dir)
	. = ..()
	setDir(dir)
	INVOKE_ASYNC(src, PROC_REF(flight), negative)

/obj/effect/temp_visual/destroyer_leap/proc/flight(negative)
	if(negative)
		animate(src, pixel_x = -LEAP_HEIGHT*0.1, pixel_z = LEAP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	else
		animate(src, pixel_x = LEAP_HEIGHT*0.1, pixel_z = LEAP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	sleep(0.3 SECONDS)
	icon_state = "Normal Destroyer Charging"
	if(negative)
		animate(src, pixel_x = -LEAP_HEIGHT, pixel_z = LEAP_HEIGHT, time = 7)
	else
		animate(src, pixel_x = LEAP_HEIGHT, pixel_z = LEAP_HEIGHT, time = 7)

/obj/effect/temp_visual/destroyer_leap/end
	pixel_x = LEAP_HEIGHT
	pixel_z = LEAP_HEIGHT
	duration = 10

/obj/effect/temp_visual/destroyer_leap/end/flight(negative)
	if(negative)
		pixel_x = -LEAP_HEIGHT
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)
	else
		animate(src, pixel_x = -16, pixel_z = 0, time = 5)
