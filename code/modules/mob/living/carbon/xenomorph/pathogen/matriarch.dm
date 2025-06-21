/datum/caste_datum/pathogen/matriarch
	caste_type = PATHOGEN_CREATURE_MATRIARCH
	tier = 4

	melee_damage_lower = XENO_DAMAGE_TIER_7
	melee_damage_upper = XENO_DAMAGE_TIER_7
	melee_vehicle_damage = XENO_DAMAGE_TIER_8
	max_health = XENO_HEALTH_KING
	plasma_gain = XENO_PLASMA_GAIN_TIER_9
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_5
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_1

	attack_delay = 0

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/matriarch

	deevolves_to = list()
	caste_desc = "Rage, rage, and rage some more."
	evolves_to = list()

	heal_resting = 1.6
	is_intelligent = TRUE

	minimap_icon = "venator"
	evolution_allowed = FALSE

/mob/living/carbon/xenomorph/pathogen/matriarch
	caste_type = PATHOGEN_CREATURE_MATRIARCH
	name = PATHOGEN_CREATURE_MATRIARCH
	desc = "A wandering ball of death."
	icon_size = 48
	icon_state = "Venator Walking"
	plasma_types = list()
	pixel_x = -8
	old_x = -8
	tier = 4
	organ_value = 15000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/pathogen_t3,
		/datum/action/xeno_action/onclick/rend, // Macro 1
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
	weed_food_states = list("Venator_1","Venator_2","Venator_3")
	weed_food_states_flipped = list("Venator_1","Venator_2","Venator_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "neo_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	counts_for_slots = FALSE

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
	var/shard_gain_onlife = 5
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

/*
	DOOM ABILITY
	King channels for a while shrieks which turns off all lights in the vicinity and applies a mild daze
	Medium cooldown soft CC
*/

/datum/action/xeno_action/activable/blight_wave/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	playsound(xeno, 'sound/voice/deep_alien_screech2.ogg', 75, 0, status = 0)
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
