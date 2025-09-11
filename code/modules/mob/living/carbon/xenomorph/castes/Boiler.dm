/datum/caste_datum/boiler
	caste_type = XENO_CASTE_BOILER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_6	//being a T3 AND an acid-focused xeno, gets higher damage for self defense
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_3

	available_strains = list(/datum/xeno_strain/trapper)
	behavior_delegate_type = /datum/behavior_delegate/boiler_base

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_SPITTER)
	caste_desc = "Gross!"
	acid_level = 3
	caste_luminosity = 2
	spit_types = list(/datum/ammo/xeno/boiler_gas/acid, /datum/ammo/xeno/boiler_gas)
	fire_immunity = FIRE_VULNERABILITY
	// 3x fire damage
	fire_vulnerability_mult = FIRE_MULTIPLIER_DEADLY

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 25
	tacklestrength_min = 3
	tacklestrength_max = 4

	minimum_evolve_time = 15 MINUTES

	minimap_icon = "boiler"

/mob/living/carbon/xenomorph/boiler
	caste_type = XENO_CASTE_BOILER
	name = XENO_CASTE_BOILER
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon = 'icons/mob/xenos/castes/tier_3/boiler.dmi'
	icon_size = 64
	icon_state = "Boiler Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 3
	gib_chance = 100
	drag_delay = 6 //pulling a big dead xeno is hard
	tileoffset = 3
	viewsize = 7

	icon_xeno = 'icons/mob/xenos/castes/tier_3/boiler.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_3/boiler.dmi'

	acid_overlay = icon('icons/mob/xenos/castes/tier_3/boiler.dmi', "Boiler-Spit")

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Boiler_1","Boiler_2","Boiler_3")
	weed_food_states_flipped = list("Boiler_1","Boiler_2","Boiler_3")

	var/datum/effect_system/smoke_spread/xeno_acid/smoke
	/// Last time a psychic pulse detected CAS camera movement
	COOLDOWN_DECLARE(last_psychic_pulse_time)

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/boiler,
		/datum/action/xeno_action/activable/corrosive_acid/strong,
		/datum/action/xeno_action/activable/xeno_spit/bombard, //1st macro
		/datum/action/xeno_action/activable/skyspit/boiler, //2nd macro
		/datum/action/xeno_action/activable/spray_acid/boiler, //3rd macro
		/datum/action/xeno_action/onclick/toggle_long_range/boiler, //4th macro
		/datum/action/xeno_action/onclick/acid_shroud, //5th macro
		/datum/action/xeno_action/onclick/shift_spits/boiler,
		/datum/action/xeno_action/onclick/tacmap,
	)
	skull = /obj/item/skull/boiler
	pelt = /obj/item/pelt/boiler

/mob/living/carbon/xenomorph/boiler/Initialize(mapload, mob/living/carbon/xenomorph/oldxeno, h_number)
	. = ..()
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)
	smoke.cause_data = create_cause_data(initial(caste_type), src)
	see_in_dark = 20

	update_icon_source()

/mob/living/carbon/xenomorph/boiler/Destroy()
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

// motion detector pulse for dropship
/mob/living/carbon/xenomorph/boiler/proc/psychic_pulse_ready()
	if(world.time < last_psychic_pulse_time + 4 SECONDS)
		return FALSE
	last_psychic_pulse_time = world.time
	return TRUE

/mob/living/carbon/xenomorph/boiler/proc/show_psychic_blip(turf/at)
	if(!client)
		return
	var/datum/mob_hud/xeno/hud = GLOB.huds[MOB_HUD_XENO_STATUS]
	if(!hud || !hud.hudusers[src])
		return
	if(!istype(at))
		at = get_turf(src)
	var/obj/effect/overlay/temp/psychic_blip/blip = new()
	var/image/I = blip.get_blip_image()
	I.loc = at
	client.images += I
	SEND_SOUND(src, sound('sound/effects/alien_psychic_warning.ogg', volume = 60))
	addtimer(CALLBACK(src, PROC_REF(clear_psychic_blip), I, blip), 1 SECONDS)

/mob/living/carbon/xenomorph/boiler/proc/clear_psychic_blip(image/I, obj/effect/overlay/temp/psychic_blip/blip)
	if(client && I)
		client.images -= I
	if(blip)
		qdel(blip)

// No special behavior for boilers
/datum/behavior_delegate/boiler_base
	name = "Base Boiler Behavior Delegate"


/datum/action/xeno_action/activable/acid_lance/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno) || !xeno.check_state())
		return

	if (!activated_once && !action_cooldown_check())
		return

	if(!affected_atom || affected_atom.layer >= FLY_LAYER || !isturf(xeno.loc))
		return

	if (!activated_once)
		// Start our 'charging'

		if (!check_and_use_plasma_owner())
			return

		xeno.create_empower()
		xeno.visible_message(SPAN_XENODANGER("[xeno] starts to gather its acid for a massive blast!"), SPAN_XENODANGER("We start to gather our acid for a massive blast!"))
		activated_once = TRUE
		stack()
		addtimer(CALLBACK(src, PROC_REF(timeout)), max_stacks*stack_time + time_after_max_before_end)
		apply_cooldown()
		return ..()

	else
		activated_once = FALSE
		var/range = base_range + stacks*range_per_stack
		var/damage = base_damage + stacks*damage_per_stack
		var/turfs_visited = 0
		for (var/turf/turf in get_line(get_turf(xeno), affected_atom))
			if(turf.density || turf.opacity)
				break

			var/should_stop = FALSE
			for(var/obj/structure/structure in turf)
				if(istype(structure, /obj/structure/window/framed))
					var/obj/structure/window/framed/window_frame = structure
					if(!window_frame.unslashable)
						window_frame.deconstruct(disassembled = FALSE)

				if(structure.opacity)
					should_stop = TRUE
					break

			if (should_stop)
				break

			if (turfs_visited >= range)
				break

			turfs_visited++

			new /obj/effect/xenomorph/acid_damage_delay(turf, damage, 7, FALSE, "You are blasted with a stream of high-velocity acid!", xeno)

		xeno.visible_message(SPAN_XENODANGER("[xeno] fires a massive blast of acid at [affected_atom]!"), SPAN_XENODANGER("We fire a massive blast of acid at [affected_atom]!"))
		remove_stack_effects("We feel our speed return to normal!")
		return TRUE

/datum/action/xeno_action/activable/acid_lance/proc/stack()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!activated_once)
		return

	stacks = min(max_stacks, stacks + 1)
	if (stacks != max_stacks)
		xeno.speed_modifier += movespeed_per_stack
		movespeed_nerf_applied += movespeed_per_stack
		xeno.recalculate_speed()
		addtimer(CALLBACK(src, PROC_REF(stack)), stack_time)
		return
	else
		to_chat(xeno, SPAN_XENOHIGHDANGER("We have charged our acid lance to maximum!"))
		return

/datum/action/xeno_action/activable/acid_lance/proc/remove_stack_effects(message = null)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (stacks <= 0)
		return

	if (message)
		to_chat(xeno, SPAN_XENODANGER(message))

	stacks = 0
	xeno.speed_modifier -= movespeed_nerf_applied
	movespeed_nerf_applied = 0
	xeno.recalculate_speed()

/datum/action/xeno_action/activable/acid_lance/proc/timeout()
	if (activated_once)
		activated_once = FALSE
		remove_stack_effects("We have waited too long and can no longer use our acid lance!")


/datum/action/xeno_action/activable/acid_lance/action_cooldown_check()
	return (activated_once || ..())

/datum/action/xeno_action/activable/xeno_spit/bombard/use_ability(atom/affected_atom)
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!action_cooldown_check()) // activate c/d only if we already spit
		for (var/action_type in action_types_to_cd)
			var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
			if (!istype(xeno_action))
				continue

			xeno_action.apply_cooldown_override(cooldown_duration)


/datum/action/xeno_action/onclick/acid_shroud/use_ability(atom/affected_atom)
	var/datum/effect_system/smoke_spread/xeno_acid/spicy_gas
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!isxeno(owner))
		return

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(sound_play)
		playsound(xeno,"acid_strike", 35, 1)
		sound_play = FALSE
		addtimer(VARSET_CALLBACK(src, sound_play, TRUE), 2 SECONDS)

	if (!do_after(xeno, xeno.ammo.spit_windup/6.5, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE, numticks = 2)) /// 0.7 seconds
		to_chat(xeno, SPAN_XENODANGER("We decide to cancel our gas shroud."))
		return

	playsound(xeno,"acid_sizzle", 50, 1)

	if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid])
		spicy_gas = new /datum/effect_system/smoke_spread/xeno_acid
	else if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas])
		spicy_gas = new /datum/effect_system/smoke_spread/xeno_weaken
	else
		CRASH("Globber has unknown ammo [xeno.ammo]! Oh no!")
	var/datum/cause_data/cause_data = create_cause_data("acid shroud gas", owner)
	spicy_gas.set_up(1, 0, get_turf(xeno), null, 6, new_cause_data = cause_data)
	spicy_gas.start()
	to_chat(xeno, SPAN_XENOHIGHDANGER("We dump our acid through our pores, creating a shroud of gas!"))

	for (var/action_type in action_types_to_cd)
		var/datum/action/xeno_action/xeno_action = get_action(xeno, action_type)
		if (!istype(xeno_action))
			continue

		xeno_action.apply_cooldown_override(cooldown_duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/shift_spits/boiler/use_ability(atom/affected_atom)
	. = ..()
	apply_cooldown()

/datum/action/xeno_action/activable/tail_stab/boiler/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner
	var/target = ..()
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		if(stabbing_xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid])
			carbon_target.reagents.add_reagent("molecularacid", 6)
			carbon_target.reagents.set_source_mob(owner, /datum/reagent/toxin/molecular_acid)
		else if(stabbing_xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas])
			var/datum/effects/neurotoxin/neuro_effect = locate() in carbon_target.effects_list
			if(!neuro_effect)
				neuro_effect = new(carbon_target, owner)
			neuro_effect.duration += 20
			to_chat(carbon_target,SPAN_HIGHDANGER("You are injected with something from [stabbing_xeno]'s tailstab!"))
		else
			CRASH("Globber has unknown ammo [stabbing_xeno.ammo]! Oh no!")
		return TRUE

/datum/action/xeno_action/activable/skyspit/boiler/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!xeno.is_zoomed)
		to_chat(xeno, SPAN_WARNING("You must be zoomed in to use Skyspit!"))
		return FALSE

	if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas/acid])
		return ..()
	else if(xeno.ammo == GLOB.ammo_list[/datum/ammo/xeno/boiler_gas])
		skyspit_range = 3 // 7x7 area
		antiair_duration = 150 // 15 seconds
		return handle_neurotoxin_chaff(affected_atom)

	return ..()

/datum/action/xeno_action/activable/skyspit/boiler/proc/handle_neurotoxin_chaff(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno) || !xeno.check_state() || !action_cooldown_check() || xeno.action_busy)
		return FALSE

	if(!check_and_use_plasma_owner())
		to_chat(xeno, SPAN_WARNING("We do not have enough plasma!"))
		return FALSE

	var/turf/center = get_turf(xeno)
	if(!center)
		to_chat(xeno, SPAN_WARNING("No valid areas to mark!"))
		return FALSE

	if(windup_time > 0)
		xeno.visible_message(SPAN_WARNING("[xeno] begins to prepare a massive corrosive spit towards the sky!"),
			SPAN_WARNING("We begin to prepare our skyspit bombardment!"))
		if(!do_after(xeno, windup_time, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			to_chat(xeno, SPAN_XENODANGER("We decide to cancel our skyspit."))
			return FALSE

	xeno.visible_message(SPAN_XENOWARNING("[xeno] launches a massive neurotoxic cloud into the sky!"),
		SPAN_XENOWARNING("We launch our neurotoxic payload into the sky!"))
	playsound(xeno.loc, 'sound/effects/blobattack.ogg', 25, 1)

	var/list/affected_turfs = list()
	for(var/turf/targeted_turf in range(skyspit_range, center))
		if(targeted_turf.chaff_active)
			continue
		targeted_turf.chaff_active = TRUE
		targeted_turf.turf_protection_flags |= TURF_PROTECTION_CHAFF
		targeted_turf.chaff_expire_timer = addtimer(CALLBACK(targeted_turf, /turf/proc/remove_chaff_marker), antiair_duration, TIMER_UNIQUE)
		if(!targeted_turf.chaff_overlay)
			targeted_turf.chaff_overlay = new /obj/effect/xenomorph/xeno_telegraph/chaff(targeted_turf, antiair_duration)
		// Add dropship protection flag overlay for chaff
		if(!targeted_turf.protection_flag_overlay)
			targeted_turf.protection_flag_overlay = new /obj/effect/overlay/temp/protection_flag/chaff(targeted_turf)
		affected_turfs += targeted_turf

	if(affected_turfs.len)
		to_chat(xeno, SPAN_NOTICE("You mark the sky with neurotoxic chaff!"))

		// Check for and extinguish illumination flares in the area
		for(var/turf/illumination_turf in affected_turfs)
			for(var/obj/item/device/flashlight/flare/on/illumination/flare in illumination_turf)
				flare.visible_message(SPAN_WARNING("[flare]'s light in the sky fizzles out!"))
				flare.turn_off()

		apply_cooldown()
		return TRUE
	else
		to_chat(xeno, SPAN_WARNING("The area is already marked!"))
		return FALSE

/turf/proc/remove_skyspit_marker()
	if(skyspit_active)
		skyspit_active = FALSE
		skyspit_expire_timer = null
		if(skyspit_overlay)
			qdel(skyspit_overlay)
			skyspit_overlay = null

		// Check if this turf is still protected by antiair pylons before removing protection
		var/still_protected = FALSE
		for(var/obj/antiair_pylon in range(5, src)) // 5 is pylon protection range
			if(istype(antiair_pylon, /obj/effect/alien/resin/special/antiair_pylon) && !QDELETED(antiair_pylon))
				still_protected = TRUE
				break

		// Only remove antiair protection and overlays if no pylon is protecting this area
		if(!still_protected)
			turf_protection_flags &= ~TURF_PROTECTION_ANTIAIR
			// Remove dropship protection flag overlay
			if(protection_flag_overlay)
				qdel(protection_flag_overlay)
				protection_flag_overlay = null

		for(var/mob/nearby_mobs in src)
			to_chat(nearby_mobs, SPAN_INFO("The cloud of acidic gas in the sky evaporates."))

// Add cleanup for chaff overlay and flag
/turf/proc/remove_chaff_marker()
	if(chaff_active)
		chaff_active = FALSE
		turf_protection_flags &= ~TURF_PROTECTION_CHAFF
		chaff_expire_timer = null
		if(chaff_overlay)
			qdel(chaff_overlay)
			chaff_overlay = null
		// Remove dropship protection flag overlay
		if(protection_flag_overlay)
			qdel(protection_flag_overlay)
			protection_flag_overlay = null
		for(var/mob/nearby_mobs in src)
			to_chat(nearby_mobs, SPAN_INFO("The cloud of neurotoxic chaff in the sky dissipates."))

#define ACID_COST_BOILER 200 // ACID_COST_LEVEL_3

/mob/living/carbon/xenomorph/boiler/try_fill_trap(obj/effect/alien/resin/trap/target)
	if(!istype(target))
		return FALSE

	if(!acid_level)
		to_chat(src, SPAN_XENONOTICE("You can't secrete any acid into [target]."))
		return FALSE

	var/trap_acid_level = 0
	if(target.trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + target.trap_type - RESIN_TRAP_ACID1

	if(trap_acid_level >= acid_level)
		to_chat(src, SPAN_XENONOTICE("It already has good acid in."))
		return FALSE

	if(!check_plasma(ACID_COST_BOILER))
		to_chat(src, SPAN_XENOWARNING("You must produce more plasma before doing this."))
		return FALSE

	to_chat(src, SPAN_XENONOTICE("You begin charging the resin trap with acid gas."))
	xeno_attack_delay(src)
	if(!do_after(src, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, src))
		return FALSE

	if(target.trap_type >= RESIN_TRAP_ACID1)
		trap_acid_level = 1 + target.trap_type - RESIN_TRAP_ACID1

	if(trap_acid_level >= acid_level)
		return FALSE

	if(!check_plasma(ACID_COST_BOILER))
		return FALSE

	use_plasma(ACID_COST_BOILER)

	if(ammo.type == /datum/ammo/xeno/boiler_gas)
		target.smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()
	else
		target.smoke_system = new /datum/effect_system/smoke_spread/xeno_acid()
	target.cause_data = create_cause_data("resin gas trap", src)
	target.setup_tripwires()
	target.set_state(RESIN_TRAP_GAS)

	playsound(target, 'sound/effects/refill.ogg', 25, 1)
	visible_message(SPAN_XENOWARNING("[src] pressurises the resin trap with acid gas!"),
	SPAN_XENOWARNING("You pressurise the resin trap with acid gas!"), null, 5)
	return TRUE

#undef ACID_COST_BOILER
