/datum/caste_datum/king
	caste_type = XENO_CASTE_KING
	caste_desc = "The end of the line."
	tier = 4

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_8
	melee_vehicle_damage = XENO_DAMAGE_TIER_5
	max_health = XENO_HEALTH_KING
	plasma_gain = XENO_PLASMA_GAIN_TIER_3
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_7
	armor_deflection = XENO_ARMOR_FACTOR_TIER_5
	speed = XENO_SPEED_TIER_1

	evolves_to = null
	deevolves_to = null
	evolution_allowed = FALSE
	can_vent_crawl = FALSE

	behavior_delegate_type = /datum/behavior_delegate/king_base

	tackle_min = 6
	tackle_max = 10

	minimap_icon = "xenoqueen"

	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE

/mob/living/carbon/xenomorph/king
	caste_type = XENO_CASTE_KING
	name = XENO_CASTE_KING
	desc = "A massive alien covered in spines and armoured plates."
	icon = 'icons/mob/xenos/castes/tier_4/king.dmi'
	icon_size = 64
	icon_state = "King Walking"
	plasma_types = list(PLASMA_CHITIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_IMMOBILE
	tier = 4
	small_explosives_stun = FALSE
	counts_for_slots = FALSE
	organ_value = 50000

	claw_type = CLAW_TYPE_VERY_SHARP
	age = -1
	aura_strength = 6

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/rend,
		/datum/action/xeno_action/activable/doom,
		/datum/action/xeno_action/activable/destroy,
		/datum/action/xeno_action/onclick/king_shield,
		/datum/action/xeno_action/onclick/emit_pheromones,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_4/king.dmi'
	weed_food_states = list()
	weed_food_states_flipped = list()

	bubble_icon = "alienroyal"

	skull = /obj/item/skull/king
	pelt = /obj/item/pelt/king

/mob/living/carbon/xenomorph/king/get_organ_icon()
	return "heart_t3"

/mob/living/carbon/xenomorph/king/Destroy()
	UnregisterSignal(src, COMSIG_MOVABLE_PRE_MOVE)

	return ..()

/mob/living/carbon/xenomorph/king/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(post_move))

/mob/living/carbon/xenomorph/king/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	. = ..()
	if(!pass_flags)
		return

	pass_flags.flags_pass |= PASS_MOB_THRU

/mob/living/carbon/xenomorph/king/proc/post_move(mob/king)
	SIGNAL_HANDLER

	var/turf/new_loc = get_turf(src)

	for(var/mob/living/carbon/carbon in new_loc.contents)
		if(carbon == src)
			continue
		if(isxeno(carbon))
			var/mob/living/carbon/xenomorph/xeno = carbon
			if(xeno.hivenumber == src.hivenumber && !(king.client?.prefs?.toggle_prefs & TOGGLE_AUTO_SHOVE_OFF))
				xeno.KnockDown((5 DECISECONDS) / GLOBAL_STATUS_MULTIPLIER)
				playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)
			else if(xeno.hivenumber != src.hivenumber)
				xeno.KnockDown((1 SECONDS) / GLOBAL_STATUS_MULTIPLIER)
				playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)
		else
			if(carbon.stat != DEAD)
				carbon.apply_armoured_damage(20)
				carbon.KnockDown((1 SECONDS) / GLOBAL_STATUS_MULTIPLIER)
				playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)

/mob/living/carbon/xenomorph/king/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, 1)

/datum/behavior_delegate/king_base
	name = "Base King Behavior Delegate"

/mob/living/carbon/xenomorph/king/rogue
	icon_xeno = 'icons/mob/xenos/castes/tier_4/rogueking.dmi'
	icon = 'icons/mob/xenos/castes/tier_4/rogueking.dmi'

/*
	REND ABILITY
	3x3 aoe damage centred on the King. Basic ability, spammable, low damage.
*/

/datum/action/xeno_action/onclick/rend/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	xeno.spin_circle()
	xeno.emote("hiss")
	for(var/mob/living/carbon/carbon in orange(1, xeno) - xeno)

		if(carbon.stat == DEAD)
			continue
		if(xeno.can_not_harm(carbon))
			continue
		carbon.apply_armoured_damage(damage)
		carbon.last_damage_data = create_cause_data(initial(xeno.name), xeno)
		xeno.flick_attack_overlay(carbon, "slash")
		to_chat(carbon, SPAN_DANGER("[xeno] slices into you with its razor sharp talons."))
		log_attack("[key_name(xeno)] hit [key_name(carbon)] with [name]")
		playsound(carbon, pick(slash_sounds), 30, TRUE)

	xeno.visible_message(SPAN_DANGER("[xeno] slices around itself!"), SPAN_NOTICE("We slice around ourself!"))
	apply_cooldown()
	..()



/*
	DOOM ABILITY
	King channels for a while shrieks which turns off all lights in the vicinity and applies a mild daze
	Medium cooldown soft CC
*/

/datum/action/xeno_action/activable/doom/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	playsound(xeno, 'sound/voice/deep_alien_screech2.ogg', 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a raspy guttural roar!"))
	xeno.create_shriekwave()

	var/datum/effect_system/smoke_spread/king_doom/smoke_gas = new()
	smoke_gas.set_up(7, 0, get_turf(xeno), null, 6)
	smoke_gas.start()

	for(var/atom/current_atom as anything in view(owner))
		if(istype(current_atom, /obj/item/device))
			var/obj/item/device/potential_lightsource = current_atom

			var/time_to_extinguish = get_dist(owner, potential_lightsource) DECISECONDS

			//Flares
			if(istype(potential_lightsource, /obj/item/device/flashlight/flare))
				var/obj/item/device/flashlight/flare/flare = potential_lightsource
				addtimer(CALLBACK(flare, TYPE_PROC_REF(/obj/item/device/flashlight/flare/, burn_out)), time_to_extinguish)

			//Flashlights
			if(istype(potential_lightsource, /obj/item/device/flashlight))
				var/obj/item/device/flashlight/flashlight = potential_lightsource
				addtimer(CALLBACK(flashlight, TYPE_PROC_REF(/obj/item/device/flashlight, turn_off_light)), time_to_extinguish)

		else if(iscarbon(current_atom))
			// "Confuse" and slow humans in the area and turn off their armour lights.
			var/mob/living/carbon/carbon = current_atom
			if(xeno.can_not_harm(carbon))
				continue

			carbon.EyeBlur(daze_length_seconds)
			carbon.Daze(daze_length_seconds)
			carbon.Superslow(slow_length_seconds)
			carbon.add_client_color_matrix("doom", 99, color_matrix_multiply(color_matrix_saturation(0), color_matrix_from_string("#eeeeee")))
			carbon.overlay_fullscreen("doom", /atom/movable/screen/fullscreen/flash/noise/nvg)
			addtimer(CALLBACK(carbon, TYPE_PROC_REF(/mob, remove_client_color_matrix), "doom", 1 SECONDS), 5 SECONDS)
			addtimer(CALLBACK(carbon, TYPE_PROC_REF(/mob, clear_fullscreen), "doom", 0.5 SECONDS), 5 SECONDS)

			to_chat(carbon, SPAN_HIGHDANGER("[xeno]'s roar overwhelms your entire being!"))
			shake_camera(carbon, 6, 1)

			if(ishuman(current_atom))
				var/mob/living/carbon/human/human = carbon
				var/time_to_extinguish = get_dist(owner, human) DECISECONDS
				var/obj/item/clothing/suit/suit = human.get_item_by_slot(WEAR_JACKET)
				if(istype(suit, /obj/item/clothing/suit/storage/marine))
					var/obj/item/clothing/suit/storage/marine/armour = suit
					addtimer(CALLBACK(armour, TYPE_PROC_REF(/atom, turn_light), null, FALSE), time_to_extinguish)
				for(var/datum/reagent/x in human.reagents.reagent_list)
					human.reagents.remove_reagent(x.id, 100)


		if(!istype(current_atom, /mob/dead))
			var/power = current_atom.light_power
			var/range = current_atom.light_range
			if(power > 0 && range > 0)
				if(current_atom.light_system != MOVABLE_LIGHT)
					current_atom.set_light(l_range=0)
					addtimer(CALLBACK(current_atom, TYPE_PROC_REF(/atom, set_light), range, power), 10 SECONDS)
				else
					current_atom.set_light_range(0)
					addtimer(CALLBACK(current_atom, TYPE_PROC_REF(/atom, set_light_range), range), 10 SECONDS)


	apply_cooldown()
	..()

/*
	BULWARK ABILITY - AoE shield
	Long cooldown defensive ability, provides a shield which caps damage taken to 10% of the xeno's max health per individual source of damage.
*/

/datum/action/xeno_action/onclick/king_shield/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK_USE_PLASMA(xeno)


	playsound(xeno.loc, 'sound/voice/deep_alien_screech.ogg', 50, 0, status = 0)
	// Add our shield
	start_shield(xeno)

	// Add other xeno's shields in AoE range
	for(var/mob/living/carbon/xenomorph/xeno_in_aoe in range(area_of_effect, xeno))
		if(xeno_in_aoe == xeno)
			continue
		if(xeno_in_aoe.stat == DEAD)
			continue
		if(xeno_in_aoe.hivenumber != xeno.hivenumber)
			continue
		start_shield(xeno_in_aoe)
		xeno.beam(xeno_in_aoe, "purple_lightning", time = 4 SECONDS)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/king_shield/proc/start_shield(mob/living/carbon/xenomorph/xeno)
	var/datum/xeno_shield/shield = xeno.add_xeno_shield(shield_amount, XENO_SHIELD_SOURCE_KING_BULWARKSPELL, /datum/xeno_shield/king_shield)
	if(shield)
		xeno.create_shield(shield_duration, "purple_animated_shield_full")


/*
	DESTROY ABILITY
	King leaps into the air and crashes down damaging cades and mobs in a 3x3 area centred on him.
	Long cooldown high damage ability, massive damage against cades, highly telegraphed.
*/

#define LEAP_DIRECTION_CHANGE_RANGE 5 //the range our x has to be within to not change the direction we slam from

/datum/action/xeno_action/activable/destroy/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK(xeno)

	if(get_dist(owner, target) > range)
		to_chat(xeno, SPAN_XENONOTICE("We cannot leap that far!"))
		return

	var/turf/target_turf = get_turf(target)

	if(!target_turf || target_turf.density)
		to_chat(xeno, SPAN_XENONOTICE("We cannot leap to that!"))
		return

	if(istype(target_turf, /turf/open/space))
		to_chat(xeno, SPAN_XENONOTICE("It would not be wise to try to leap there..."))
		return

	if(istype(target, /obj/vehicle/multitile))
		to_chat(xeno, SPAN_XENONOTICE("It would not be wise to try to leap there..."))
		return

	var/area/target_area = get_area(target_turf)
	if(target_area.flags_area & AREA_NOTUNNEL)
		to_chat(xeno, SPAN_XENONOTICE("We cannot leap to that area!"))

	var/list/leap_line = get_line(xeno, target)
	for(var/turf/jump_turf in leap_line)
		if(jump_turf.density)
			to_chat(xeno, SPAN_XENONOTICE("We don't have a clear path to leap to that location!"))
			return

		for(var/obj/structure/possible_blocker in jump_turf)
			if(possible_blocker.density && !possible_blocker.throwpass)
				to_chat(xeno, SPAN_XENONOTICE("There's something blocking us from leaping."))
				return

	if(!check_and_use_plasma_owner())
		to_chat(xeno, SPAN_XENONOTICE("We don't have enough plasma to use [name]."))
		return

	var/turf/template_turf = get_step(target_turf, SOUTHWEST)

	to_chat(xeno, SPAN_XENONOTICE("Our muscles tense as we prepare ourself for a giant leap."))
	xeno.make_jittery(2 SECONDS)
	if(!do_after(xeno, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(xeno, SPAN_XENONOTICE("We relax our muslces and end our leap."))
		return
	if(leaping || !target)
		return
	// stop target movement
	leaping = TRUE
	ADD_TRAIT(owner, TRAIT_UNDENSE, "Destroy")
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "Destroy")
	owner.visible_message(SPAN_WARNING("[owner] takes a giant leap into the air!"))

	var/negative
	var/initial_x = owner.x
	if(target.x < initial_x) //if the target's x is lower than ours, go to the left
		negative = TRUE
	else if(target.x > initial_x)
		negative = FALSE
	else if(target.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)

	owner.face_atom(target)
	owner.emote("roar")

	//Initial visual
	var/obj/effect/king_leap/leap_visual = new(owner.loc, negative, owner.dir)
	new /obj/effect/xenomorph/xeno_telegraph/king_attack_template(template_turf, 20)

	negative = !negative //invert it for the descent later

	var/oldtransform = owner.transform
	owner.alpha = 255
	animate(owner, alpha = 0, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(1 DECISECONDS)
		if(QDELETED(owner) || owner.stat == DEAD) //we got hit and died, rip us

			//Initial effect
			qdel(leap_visual)

			if(owner.stat == DEAD)
				leaping = FALSE
				animate(owner, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return

	owner.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SLEEP_CHECK_DEATH(7, owner)

	while(target_turf && owner.loc != target_turf)
		owner.forceMove(get_step(owner, get_dir(owner, target_turf)))
		SLEEP_CHECK_DEATH(0.5, owner)

	animate(owner, alpha = 100, transform = matrix()*0.7, time = 7)
	var/descentTime = 5

	if(negative)
		if(ISINRANGE(owner.x, initial_x + 1, initial_x + LEAP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(owner.x, initial_x - LEAP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE

	new /obj/effect/king_leap/end(owner.loc, negative, owner.dir)

	SLEEP_CHECK_DEATH(descentTime, owner)
	animate(owner, alpha = 255, transform = oldtransform, descentTime)
	owner.mouse_opacity = initial(owner.mouse_opacity)
	playsound(owner.loc, 'sound/effects/meteorimpact.ogg', 200, TRUE)

	/// Effects for landing
	new /obj/effect/heavy_impact(owner.loc)
	for(var/step in CARDINAL_ALL_DIRS)
		new /obj/effect/heavy_impact(get_step(owner.loc, step))

	// Actual Damaging Effects - Add stuff for cades - NEED TELEGRAPHS NEED EFFECTS

	// Mobs first high damage and knockback away from centre
	for(var/mob/living/carbon/carbon in orange(1, owner) - owner)
		if(xeno.can_not_harm(carbon))
			continue

		log_attack("[key_name(xeno)] hit [key_name(carbon)] with [name]")
		carbon.gib()

	// Any items get thrown away
	for(var/obj/item/item in orange(1, owner))
		if(!QDELETED(item))
			var/throw_dir = get_dir(owner, item)
			if(item.loc == owner.loc)
				throw_dir = pick(GLOB.alldirs)
			var/throwtarget = get_edge_target_turf(owner, throw_dir)
			item.throw_atom(throwtarget, 2, SPEED_REALLY_FAST, owner, TRUE)

	for(var/obj/structure/structure in orange(1, owner))
		structure.ex_act(1000, get_dir(owner, structure))

	for(var/mob/living in range(7, owner))
		shake_camera(living, 15, 1)

	REMOVE_TRAIT(owner, TRAIT_UNDENSE, "Destroy")
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "Destroy")

	SLEEP_CHECK_DEATH(1, owner)
	leaping = FALSE
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/destroy/proc/second_template(turf/template_turf)
	new /obj/effect/xenomorph/xeno_telegraph/king_attack_template(template_turf, 10)
