/datum/caste_datum/pathogen/matriarch
	caste_type = PATHOGEN_CREATURE_MATRIARCH
	tier = 4

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_8
	melee_vehicle_damage = XENO_DAMAGE_TIER_8
	max_health = XENO_HEALTH_KING
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_5
	armor_deflection = XENO_ARMOR_TIER_4
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_1

	attack_delay = 0

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/matriarch

	deevolves_to = list()
	caste_desc = "Fury and death..."
	evolves_to = list()

	heal_resting = 1.6
	is_intelligent = TRUE

	minimap_icon = "matriarch"
	evolution_allowed = FALSE

/mob/living/carbon/xenomorph/pathogen/matriarch
	caste_type = PATHOGEN_CREATURE_MATRIARCH
	name = PATHOGEN_CREATURE_MATRIARCH
	desc = "Nothing will survive..."
	icon_size = 48
	icon_state = "Matriarch Walking"
	plasma_types = list()
	pixel_x = -16
	old_x = -16
	tier = 4
	organ_value = 15000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/tail_stab/pathogen_t3,
		/datum/action/xeno_action/onclick/shatter, // Macro 1
		/datum/action/xeno_action/activable/rav_spikes, // Macro 2
		/datum/action/xeno_action/onclick/spike_shed, // Macro 3
		/datum/action/xeno_action/activable/blight_wave, // Macro 4
		/datum/action/xeno_action/onclick/tacmap,
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	tackle_min = 2
	tackle_max = 5
	tackle_chance = 45

	icon_xeno = 'icons/mob/pathogen/matriarch.dmi'
	icon_xenonid = 'icons/mob/pathogen/matriarch.dmi'
	//need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Matriarch_1","Matriarch_2","Matriarch_3")
	weed_food_states_flipped = list("Matriarch_1","Matriarch_2","Matriarch_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	counts_for_slots = FALSE
	aura_strength = 5
	langchat_height = 64

/mob/living/carbon/xenomorph/pathogen/matriarch/Initialize()
	. = ..()
	AddComponent(/datum/component/footstep, 2 , 35, 11, 4, "alien_footstep_large")
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(check_block))

/mob/living/carbon/xenomorph/pathogen/matriarch/proc/check_block(mob/queen, turf/new_loc)
	SIGNAL_HANDLER
	if(body_position == LYING_DOWN || stat == UNCONSCIOUS)
		return
	for(var/mob/living/carbon/xenomorph/xeno in new_loc.contents)
		if(xeno.stat == DEAD)
			continue
		if(xeno.pass_flags.flags_pass & (PASS_MOB_THRU_XENO|PASS_MOB_THRU) || xeno.flags_pass_temp & PASS_MOB_THRU)
			continue
		if(xeno.hivenumber == hivenumber && !(queen.client?.prefs?.toggle_prefs & TOGGLE_AUTO_SHOVE_OFF))
			xeno.KnockDown((5 DECISECONDS) / GLOBAL_STATUS_MULTIPLIER)
			playsound(src, 'sound/weapons/alien_knockdown.ogg', 25, 1)


/datum/behavior_delegate/pathogen_base/matriarch
	name = "Base Matriarch Behavior Delegate"

	// Shard config
	var/max_shards = 300
	var/shard_gain_onlife = 3
	var/shards_per_projectile = 10
	var/shards_per_slash = 15
	var/armor_buff_per_fifty_shards = 2.50
	var/shard_lock_duration = 150
	var/shard_lock_speed_mod = 0.45

	// Shard state
	var/shards = 0
	var/shards_locked = FALSE //are we locked at 0 shards?

	// Armor buff state
	var/times_armor_buffed = 0

/datum/behavior_delegate/pathogen_base/matriarch/append_to_stat()
	. = list()
	. += "Bone Shards: [shards]/[max_shards]"
	. += "Shards Armor Bonus: [times_armor_buffed*armor_buff_per_fifty_shards]"

/datum/behavior_delegate/pathogen_base/matriarch/proc/lock_shards()
	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("You have shed your spikes and cannot gain any more for [shard_lock_duration/10] seconds!"))

	bound_xeno.speed_modifier -= shard_lock_speed_mod
	bound_xeno.recalculate_speed()

	shards = 0
	shards_locked = TRUE
	addtimer(CALLBACK(src, PROC_REF(unlock_shards)), shard_lock_duration)

/datum/behavior_delegate/pathogen_base/matriarch/proc/unlock_shards()
	if (!bound_xeno)
		return

	to_chat(bound_xeno, SPAN_XENODANGER("You feel your ability to gather shards return!"))

	bound_xeno.speed_modifier += shard_lock_speed_mod
	bound_xeno.recalculate_speed()
	shards_locked = FALSE

// Return true if we have enough shards, false otherwise
/datum/behavior_delegate/pathogen_base/matriarch/proc/check_shards(amount)
	if (!amount)
		return FALSE
	else
		return (shards >= amount)

/datum/behavior_delegate/pathogen_base/matriarch/proc/use_shards(amount)
	if (!amount)
		return
	shards = max(0, shards - amount)

/datum/behavior_delegate/pathogen_base/matriarch/on_life()
	if (!shards_locked)
		shards = min(max_shards, shards + shard_gain_onlife)

	var/armor_buff_count = shards/50 //0-6
	bound_xeno.armor_modifier -= times_armor_buffed * armor_buff_per_fifty_shards
	bound_xeno.armor_modifier += armor_buff_count * armor_buff_per_fifty_shards
	bound_xeno.recalculate_armor()
	times_armor_buffed = armor_buff_count

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_shards = round((shards / max_shards) * 100, 10)
	if(percentage_shards)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_shards]")

	if(percentage_shards >= 50)
		bound_xeno.small_explosives_stun = FALSE
		bound_xeno.add_filter("hedge_unstunnable", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	else
		bound_xeno.small_explosives_stun = TRUE
		bound_xeno.remove_filter("hedge_unstunnable", 1, list("type" = "outline", "color" = "#421313", "size" = 1))
	return

/datum/behavior_delegate/pathogen_base/matriarch/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/pathogen_base/matriarch/on_hitby_projectile()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_projectile)
	return

/datum/behavior_delegate/pathogen_base/matriarch/melee_attack_additional_effects_self()
	if (!shards_locked)
		shards = min(max_shards, shards + shards_per_slash)
	return




/// Screech which puts out lights in a 7 tile radius, slows and dazes.
/datum/action/xeno_action/activable/blight_wave
	name = "Blight Wave"
	action_icon_state = "screech"
	macro_path = /datum/action_xeno_action/verb/verb_doom
	xeno_cooldown = 45 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_4

	var/daze_length_seconds = 1
	var/slow_length_seconds = 4

/datum/action/xeno_action/activable/blight_wave/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	playsound(xeno, 'sound/pathogen_creatures/pathogen_matriarch_screech.ogg', 75, 0, status = 0)
	xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a raspy guttural roar!"))
	xeno.create_shriekwave()

	var/datum/effect_system/smoke_spread/blight_wave/smoke_gas = new()
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

/datum/effect_system/smoke_spread/blight_wave
	smoke_type = /obj/effect/particle_effect/smoke/blight

/obj/effect/particle_effect/smoke/blight
	name = "blight"
	opacity = FALSE
	color = "#000000"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER
	time_to_live = 5
	spread_speed = 1
	pixel_x = 0
	pixel_y = 0

/obj/effect/particle_effect/smoke/blight/affect(mob/living/carbon/creature)
	. = ..()
	if(!.)
		return FALSE
	if(creature.stat == DEAD)
		return FALSE
	if(issynth(creature))
		return FALSE
	if(can_not_harm(creature))
		return FALSE

	var/mob/living/carbon/xenomorph/xeno_creature
	var/mob/living/carbon/human/human_creature
	if(isxeno(creature))
		xeno_creature = creature
	else if(ishuman(creature))
		human_creature = creature

	if(isyautja(creature) && prob(75))
		return FALSE

	if(creature.wear_mask && (creature.wear_mask.flags_inventory & BLOCKGASEFFECT))
		return FALSE
	if(human_creature && (human_creature.head && (human_creature.head.flags_inventory & BLOCKGASEFFECT)))
		return FALSE

	var/effect_amt = floor(6 + amount*6)

	if(xeno_creature)
		xeno_creature.AddComponent(/datum/component/status_effect/interference, 10, 10)
		xeno_creature.blinded = TRUE
	else
		creature.apply_damage(12, OXY)

	creature.SetEarDeafness(max(creature.ear_deaf, floor(effect_amt*1.5))) //Paralysis of hearing system, aka deafness
	if(!xeno_creature && !creature.eye_blind) //Eye exposure damage
		to_chat(creature, SPAN_DANGER("Your eyes sting. You can't see!"))
		creature.SetEyeBlind(floor(effect_amt/3))

	if(human_creature && creature.coughedtime < world.time && !creature.stat) //Coughing/gasping
		creature.coughedtime = world.time + 1.5 SECONDS
		if(prob(50))
			creature.emote("cough")
		else
			creature.emote("gasp")

	var/stun_chance = 35
	if(prob(stun_chance))
		creature.KnockDown(2)

	//Topical damage (neurotoxin on exposed skin)
	if(xeno_creature)
		to_chat(xeno_creature, SPAN_XENODANGER("You are struggling to move, it's as if you're paralyzed!"))
	else
		to_chat(creature, SPAN_DANGER("Your body is going numb, almost as if paralyzed!"))
	if(prob(60 + floor(amount*15))) //Highly likely to drop items due to arms/hands seizing up
		creature.drop_held_item()
	if(human_creature)
		human_creature.temporary_slowdown = max(human_creature.temporary_slowdown, 4) //One tick every two second
		human_creature.recalculate_move_delay = TRUE
	return TRUE

/obj/effect/particle_effect/smoke/blight/proc/can_not_harm(mob/living/carbon/attempt_harm_mob)
	if(!istype(attempt_harm_mob))
		return FALSE

	var/datum/hive_status/hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]

	if(!hive)
		return FALSE

	if(HAS_TRAIT(attempt_harm_mob, TRAIT_HAULED))
		return TRUE

	return hive.is_ally(attempt_harm_mob)




/datum/action/xeno_action/onclick/shatter
	name = "Shatter"
	action_icon_state = "butchering"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 100
	xeno_cooldown = 45 SECONDS
	var/shatter_range = 1
	var/shatter_damage = 35

/datum/action/xeno_action/onclick/shatter/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if(!xeno.check_state())
		return

	if (!action_cooldown_check())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] sweeps its huge arm in a wide circle!"),
	SPAN_XENOWARNING("We sweep our huge arm in a wide circle!"))

	if(!check_and_use_plasma_owner())
		return

	xeno.spin_circle()

	for(var/mob/living/carbon/human in orange(shatter_range, get_turf(xeno)))
		if (!isxeno_human(human) || xeno.can_not_harm(human))
			continue
		if(human.stat == DEAD)
			continue
		if(HAS_TRAIT(human, TRAIT_NESTED))
			continue
		step_away(human, xeno, shatter_range, 2)
		xeno.flick_attack_overlay(human, "punch")
		human.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		human.apply_armoured_damage(get_xeno_damage_slash(xeno, shatter_damage), ARMOR_MELEE, BRUTE)
		shake_camera(human, 2, 1)

		if(human.mob_size < MOB_SIZE_BIG)
			human.apply_effect(get_xeno_stun_duration(human, 2), WEAKEN)

		to_chat(human, SPAN_XENOWARNING("You are struck by [xeno]'s huge arm!"))
		playsound(human,'sound/weapons/alien_claw_block.ogg', 50, 1)

	apply_cooldown()
	return ..()

//#########################################################################
//#########################################################################
//#########################################################################
#define STAGE_GROWING 1
#define STAGE_HALFWAY 2
#define STAGE_VOTE 3
#define STAGE_PICK 4
#define STAGE_BEFORE_HATCH 5
#define STAGE_HATCH 6

/obj/effect/alien/resin/matriarch_cocoon
	name = PATHOGEN_STRUCTURE_COCOON_BIG
	desc = "A huge pulsating cocoon."
	icon = 'icons/mob/pathogen/MatriarchHatchery.dmi'
	icon_state = "static"
	health = 4000
	pixel_x = -48
	pixel_y = -64
	density = TRUE
	plane = FLOOR_PLANE

	/// The mob picked as a candidate to be the Matriarch
	var/client/chosen_candidate
	/// The hive associated with this cocoon
	hivenumber = XENO_HIVE_PATHOGEN
	/// Whether the cocoon has hatched
	var/hatched = FALSE
	/// Is currently rolling candidates
	var/rolling_candidates = FALSE
	/// Voting for Matriarch
	var/list/mob/living/carbon/xenomorph/votes = list()
	/// Candidates
	var/list/mob/living/carbon/xenomorph/candidates = list()
	/// Time to hatch
	var/time_to_hatch = 10 MINUTES
	/// Stage of hatching
	var/stage = 0

/obj/effect/alien/resin/matriarch_cocoon/Destroy()
	if(!hatched)
		marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP IN [uppertext(get_area_name(loc))] HAS BEEN STOPPED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
		elder_overseer_message("The Pathogen Matriarch's cocoon was destroyed.")
		var/datum/hive_status/hive
		for(var/cur_hive_num in GLOB.hive_datum)
			hive = GLOB.hive_datum[cur_hive_num]
			if(!length(hive.totalXenos))
				continue
			if(cur_hive_num == hivenumber)
				xeno_announcement(SPAN_XENOANNOUNCE("THE MATRIARCH'S COCOON WAS DESTROYED! VENGEANCE!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
				hive.has_hatchery = FALSE
			else
				xeno_announcement(SPAN_XENOANNOUNCE("THE STRANGE COCOON WAS DESTROYED!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)

	votes = null
	chosen_candidate = null
	candidates = null

	. = ..()

/obj/effect/alien/resin/matriarch_cocoon/Initialize(mapload)
	. = ..()

	var/datum/hive_status/hatchery_hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	hatchery_hive.has_hatchery = TRUE

	for(var/x_offset in -1 to 1)
		for(var/y_offset in -1 to 1)
			var/turf/turf_to_block = locate(x + x_offset, y + y_offset, z)
			var/obj/effect/build_blocker/blocker = new(turf_to_block, src)
			blockers += blocker

	START_PROCESSING(SSobj, src)

	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - 10 MINUTES.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	elder_overseer_message("A Pathogen Matriarch is now growing at [get_area_name(loc)].")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch is growing at [get_area_name(loc)]. Protect it, at all costs!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Something unusual is growing at [get_area_name(loc)]."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/obj/effect/alien/resin/matriarch_cocoon/process(delta_time)
	if(hatched)
		STOP_PROCESSING(SSobj, src)
		return

	var/groundside_humans = 0
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue

		var/turf/turf = get_turf(current_human)
		if(is_ground_level(turf?.z))
			groundside_humans += 1

			if(groundside_humans > 12)
				break

	if(groundside_humans < 12)
		// Too few marines are now groundside, hatch immediately
		start_vote()
		addtimer(CALLBACK(src, PROC_REF(roll_candidates)), 20 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(start_hatching), TRUE), 25 SECONDS)
		STOP_PROCESSING(SSobj, src)
		return

	time_to_hatch -= delta_time SECONDS

	if(!stage && time_to_hatch < 10 MINUTES)
		icon_state = "growing"
		stage = STAGE_GROWING
	else if (stage == STAGE_GROWING && time_to_hatch <= 5 MINUTES)
		announce_halfway()
		stage = STAGE_HALFWAY
	else if (stage == STAGE_HALFWAY && time_to_hatch <= 1 MINUTES)
		start_vote()
		stage = STAGE_VOTE
	else if (stage == STAGE_VOTE && time_to_hatch <= 40 SECONDS)
		roll_candidates()
		stage = STAGE_PICK
	else if (stage == STAGE_PICK && time_to_hatch <= 20 SECONDS)
		start_hatching()
		stage = STAGE_BEFORE_HATCH
	else if (stage == STAGE_BEFORE_HATCH && time_to_hatch <= 0)
		animate_hatch()
		STOP_PROCESSING(SSobj, src)

#undef STAGE_GROWING
#undef STAGE_HALFWAY
#undef STAGE_VOTE
#undef STAGE_PICK
#undef STAGE_BEFORE_HATCH
#undef STAGE_HATCH

/// Causes the halfway announcements and initiates the next timer.
/obj/effect/alien/resin/matriarch_cocoon/proc/announce_halfway()
	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [uppertext(get_area_name(loc))].\n\nESTIMATED TIME UNTIL COMPLETION - 5 MINUTES. RECOMMEND TERMINATION OF MYCELIAL STRUCTURE AT THIS LOCATION.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	elder_overseer_message("A Pathogen Matriarch will hatch in 5 minutes.")
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch will hatch in approximately 5 minutes."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Something unusual is growing... it will hatch in approximately 5 minutes."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

#define PATH_MAT_PLAYTIME_HOURS (50 HOURS)

/**
 * Returns TRUE is the candidate passed is valid: Returns TRUE is the candidate passed is valid: Has client, not facehugger, not lesser drone, not banished, and conditionally on playtime.
 *
 * Arguments:
 * * hive: The hive_status to check banished ckeys against
 * * candidate: The mob that we want to check
 * * playtime_restricted: Determines whether being below PATH_MAT_PLAYTIME_HOURS makes the candidate invalid
 * * skip_playtime: Determines whether being above PATH_MAT_PLAYTIME_HOURS makes the candidate invalid (does nothing unless playtime_restricted is FALSE)
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/is_candidate_valid(datum/hive_status/hive, mob/candidate, playtime_restricted = TRUE, skip_playtime = TRUE)
	if(!candidate?.client)
		return FALSE
	if(isfacehugger(candidate) || islesserdrone(candidate) || ispopper(candidate))
		return FALSE
	if(playtime_restricted)
		if(candidate.client.get_total_xeno_playtime() < PATH_MAT_PLAYTIME_HOURS)
			return FALSE
	else if(candidate.client.get_total_xeno_playtime() >= PATH_MAT_PLAYTIME_HOURS && skip_playtime)
		return FALSE // We do this under the assumption we tried it the other way already so don't ask twice
	for(var/mob_name in hive.banished_ckeys)
		if(hive.banished_ckeys[mob_name] == candidate.ckey)
			return FALSE
	return TRUE

/**
 * Returns TRUE if a valid candidate accepts a TGUI alert asking them to be Matriarch.
 *
 * Arguments:
 * * hive: The hive_status to check banished ckeys against
 * * candidate: The mob that we want to ask
 * * playtime_restricted: Determines whether being below PATH_MAT_PLAYTIME_HOURS makes the candidate invalid (otherwise above)
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/try_roll_candidate(datum/hive_status/hive, mob/candidate, playtime_restricted = TRUE)
	if(!is_candidate_valid(hive, candidate, playtime_restricted))
		return FALSE

	if(!candidate.client)
		return FALSE

	return candidate.client.prefs.be_special & BE_KING

#undef PATH_MAT_PLAYTIME_HOURS

/**
 * Tallies up votes by asking the passed candidate who they wish to vote for Matriarch.
 *
 * Arguments:
 * * candidate: The mob that was want to ask
 * * voting_candidates: A list of xenomorph mobs that are candidates
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/cast_vote(mob/candidate, list/mob/living/carbon/xenomorph/voting_candidates)
	var/mob/living/carbon/xenomorph/choice = tgui_input_list(candidate, "Vote for a sister you wish to become the Matriarch.", "Choose a creature", voting_candidates , 20 SECONDS)

	if(votes[choice])
		votes[choice] += 1
	else
		votes[choice] = 1

/// Initiates a vote that will end in 20 seconds to vote for the Matriarch. Hatching will then begin in 1 minute unless expedited.
/obj/effect/alien/resin/matriarch_cocoon/proc/start_vote()
	rolling_candidates = TRUE
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	var/list/mob/living/carbon/xenomorph/voting_candidates = hive.totalXenos.Copy() - hive.living_xeno_queen

	for(var/mob/living/carbon/xenomorph/voting_candidate in voting_candidates)
		if(!is_candidate_valid(hive, voting_candidate))
			voting_candidates -= voting_candidate

	for(var/mob/living/carbon/xenomorph/candidate in hive.totalXenos)
		if(is_candidate_valid(hive, candidate, playtime_restricted = FALSE, skip_playtime = FALSE))
			INVOKE_ASYNC(src, PROC_REF(cast_vote), candidate, voting_candidates)

	candidates = voting_candidates


/**
 * Finalizes the vote for Matriarch opting to use a series of fallbacks in case a candidate declines.
 *
 * First is a vote where the first and or second top picked is asked.
 * Then all other living xenos meeting the playtime requirement are asked.
 * Then all xeno observer candidates meeting the playtime requirement are asked.
 * Then all other living xenos not meeting the playtime requirement are asked.
 * Then all other xeno observer candidates not meeting the playtime requirement are asked.
 * Then finally if after all that, the search is given up and will ultimately result in a freed Matriarch mob.
 */
/obj/effect/alien/resin/matriarch_cocoon/proc/roll_candidates()
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]

	var/primary_votes = 0
	var/mob/living/carbon/xenomorph/primary_candidate
	var/secondary_votes = 0
	var/mob/living/carbon/xenomorph/secondary_candidate

	for(var/mob/living/carbon/xenomorph/candidate in votes)
		if(votes[candidate] > primary_votes)
			primary_votes = votes[candidate]
			primary_candidate = candidate
		else if(votes[candidate] > secondary_votes)
			secondary_votes = votes[candidate]
			secondary_candidate = candidate

	votes.Cut()

	if(prob(50) && try_roll_candidate(hive, primary_candidate, playtime_restricted = TRUE))
		chosen_candidate = primary_candidate.client
		rolling_candidates = FALSE
		return

	candidates -= primary_candidate


	if(try_roll_candidate(hive, secondary_candidate, playtime_restricted = TRUE))
		chosen_candidate = secondary_candidate.client
		rolling_candidates = FALSE
		return

	candidates -= secondary_candidate

	// Otherwise ask all the living xenos (minus the player(s) who got voted on earlier)
	for(var/mob/living/carbon/xenomorph/candidate in shuffle(candidates))
		if(try_roll_candidate(hive, candidate, playtime_restricted = TRUE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	// Then observers
	var/list/observer_list_copy = shuffle(get_alien_candidates(hive))

	for(var/mob/candidate in observer_list_copy)
		if(try_roll_candidate(hive, candidate, playtime_restricted = TRUE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	// Lastly all of the above again, without playtime requirements
	for(var/mob/living/carbon/xenomorph/candidate in shuffle(hive.totalXenos.Copy() - hive.living_xeno_queen))
		if(try_roll_candidate(hive, candidate, playtime_restricted = FALSE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return

	for(var/mob/candidate in observer_list_copy)
		if(try_roll_candidate(hive, candidate, playtime_restricted = FALSE))
			chosen_candidate = candidate.client
			rolling_candidates = FALSE
			return
	message_admins("Failed to find a client for the Matriarch, releasing as freed mob.")


/// Starts the hatching in twenty seconds, otherwise immediately if expedited
/obj/effect/alien/resin/matriarch_cocoon/proc/start_hatching(expedite = FALSE)
	votes = null
	candidates = null
	if(expedite)
		animate_hatch()
		return

	elder_overseer_message("A Pathogen Matriarch will hatch in twenty seconds.")
	marine_announcement("ALERT.\n\nUNUSUAL ENERGY BUILDUP DETECTED IN [get_area_name(loc)].\n\nESTIMATED TIME UNTIL COMPLETION - 20 SECONDS. RECOMMEND TERMINATION OF MYCELIAL STRUCTURE AT THIS LOCATION.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("The Matriarch will hatch in approximately twenty seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("Something unusual will hatch in approximately twenty seconds."), cur_hive_num, XENO_GENERAL_ANNOUNCE)

/// Causes the cocoon to change visually for hatching and initiates the next timer.
/obj/effect/alien/resin/matriarch_cocoon/proc/animate_hatch()
	flick("hatching", src)
	addtimer(CALLBACK(src, PROC_REF(hatch)), 2 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)

	elder_overseer_message("A Pathogen Matriarch has hatched; I advise extreme caution.")
	marine_announcement("ALERT.\n\nEXTREME ENERGY INFLUX DETECTED IN [get_area_name(loc)].\n\nCAUTION IS ADVISED.", "[MAIN_AI_SYSTEM] Biological Scanner", 'sound/misc/notice1.ogg')
	var/datum/hive_status/hive
	for(var/cur_hive_num in GLOB.hive_datum)
		hive = GLOB.hive_datum[cur_hive_num]
		if(!length(hive.totalXenos))
			continue
		if(cur_hive_num == hivenumber)
			xeno_announcement(SPAN_XENOANNOUNCE("All hail the Matriarch."), cur_hive_num, XENO_GENERAL_ANNOUNCE)
		else
			xeno_announcement(SPAN_XENOANNOUNCE("The unusual entity has hatched!"), cur_hive_num, XENO_GENERAL_ANNOUNCE)


/// Actually hatches the Matriarch transferring the candidate into the spawned mob and initiates the next timer.
/obj/effect/alien/resin/matriarch_cocoon/proc/hatch()
	icon_state = "hatched"
	hatched = TRUE

	QDEL_LIST(blockers)

	var/mob/living/carbon/xenomorph/pathogen/matriarch/matriarch = new(get_turf(src), null, hivenumber)
	if(chosen_candidate?.mob)
		var/mob/old_mob = chosen_candidate.mob
		old_mob.mind.transfer_to(matriarch)

		if(isliving(old_mob) && old_mob.stat != DEAD)
			old_mob.free_for_ghosts(TRUE)
	else
		matriarch.free_for_ghosts(TRUE)
	playsound(src, 'sound/voice/alien_queen_command.ogg', 75, 0)

	chosen_candidate = null
