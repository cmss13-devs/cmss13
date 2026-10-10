/datum/caste_datum/horseman
	caste_type = XENO_CASTE_HORSEMAN
	caste_desc = "KILL THEM ALL"
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_8
	melee_damage_upper = XENO_DAMAGE_TIER_8
	melee_vehicle_damage = XENO_DAMAGE_TIER_7
	max_health = XENO_HEALTH_PUMPKING
	plasma_gain = XENO_PLASMA_GAIN_TIER_10
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_FACTOR_TIER_5
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_10
	attack_delay = -1
	heal_standing = 0
	heal_resting = 0

	innate_healing = 0

	evolution_allowed = FALSE
	minimum_evolve_time = 0
	behavior_delegate_type = /datum/behavior_delegate/horseman_base

	minimap_icon = "ravager"
	organ_type = /obj/item/organ/xeno/ravager

/mob/living/carbon/xenomorph/horseman
	AUTOWIKI_SKIP(TRUE)

	caste_type = XENO_CASTE_HORSEMAN
	name = XENO_CASTE_HORSEMAN
	desc = "horseman"
	icon = 'icons/mob/xenos/castes/tier_4/horseman.dmi'
	icon_size = 64
	icon_state = "Normal Horseman Walking"
	mob_size = MOB_SIZE_BIG
	drag_delay = 6
	tier = 3
	pixel_x = -16
	old_x = -16
	claw_type = CLAW_TYPE_VERY_SHARP
	show_age_prefix = FALSE
	age = XENO_NO_AGE

	counts_for_slots = FALSE
	counts_for_roundend = FALSE

	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/haunt,
		/datum/action/xeno_action/onclick/pumpkin_barrage,
		/datum/action/xeno_action/activable/doom,
		/datum/action/xeno_action/activable/boomerang_scythe,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_4/horseman.dmi'
	icon_xenonid = 'icons/mob/xenos/castes/tier_4/horseman.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Queen_1","Queen_2","Queen_3")
	weed_food_states_flipped = list("Queen_1","Queen_2","Queen_3")

	var/sound_song = 'sound/halloween/placeholder_song.ogg'
	var/sound_spawn = 'sound/halloween/placerholder_spawn.ogg'
	var/list/sounds_idle = list(
		'sound/halloween/idle_1.ogg',
		'sound/halloween/idle_2.ogg',
		'sound/halloween/idle_3.ogg',
	)
	var/list/sounds_death = list(
		'sound/halloween/death1.ogg',
		'sound/halloween/death2.ogg',
		'sound/halloween/death_3.ogg',
	)
	var/idle_sound_delay_min = 15 SECONDS
	var/idle_sound_delay_max = 25 SECONDS
	var/next_idle_sound = 0
	var/spawn_fog_radius = 3

/mob/living/carbon/xenomorph/horseman/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, h_number)
	. = ..(mapload, old_xeno, h_number || XENO_HIVE_HORSEMAN)
	next_idle_sound = world.time + rand(idle_sound_delay_min, idle_sound_delay_max)
	START_PROCESSING(SSobj, src)
	if(mapload)
		return
	for(var/client/player as anything in GLOB.clients)
		playsound_client(player, sound_song, vol = 50, channel = SOUND_CHANNEL_MUSIC)
		playsound_client(player, sound_spawn, vol = 75)
	var/datum/effect_system/smoke_spread/horseman/fog = new
	fog.set_up(spawn_fog_radius, 0, src)
	fog.start()
	RegisterSignal(src, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))



/mob/living/carbon/xenomorph/horseman/process(delta_time)
	if(stat == DEAD || world.time < next_idle_sound)
		return
	next_idle_sound = world.time + rand(idle_sound_delay_min, idle_sound_delay_max)
	playsound(src, pick(sounds_idle), 60, FALSE, 45) // 45 tiles because i want people to hear this mfer laughing from fob

/mob/living/carbon/xenomorph/horseman/death(cause, gibbed)
	. = ..()
	if(!.)
		return
	var/death_sound = pick(sounds_death)
	for(var/client/player as anything in GLOB.clients)
		playsound_client(player, death_sound, vol = 75)
	UnregisterSignal(src, COMSIG_MOB_WEED_SLOWDOWN, PROC_REF(handle_weed_slowdown))


/datum/action/xeno_action/onclick/haunt
	name = "Haunt"
	action_icon_state = "tunnel"
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 60 SECONDS

	var/list/teleport_sound = list(
		'sound/halloween/teleport_1.ogg',
	)

/datum/action/xeno_action/onclick/haunt/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno) || !action_cooldown_check() || !xeno.check_state())
		return
	var/choice = tgui_alert(xeno, "Who do you want to haunt?", "Haunt", list("Marine", "Xeno"))
	if(!choice || !action_cooldown_check() || !xeno.check_state())
		return
	var/mob/living/victim = pick_victim(xeno, choice == "Xeno")
	if(!victim)
		to_chat(xeno, SPAN_XENOWARNING("There's no one groundside to haunt."))
		return
	if(!check_and_use_plasma_owner())
		return
	xeno.stop_pulling()
	xeno.forceMove(get_haunt_turf(victim))
	playsound(xeno, teleport_sound, 60, FALSE, 15)
	to_chat(xeno, SPAN_XENONOTICE("We haunt [victim]."))
	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/haunt/proc/pick_victim(mob/living/carbon/xenomorph/xeno, want_xeno)
	var/list/mob/living/victims = list()
	for(var/mob/living/candidate as anything in (want_xeno ? GLOB.living_xeno_list : GLOB.alive_human_list))
		if(candidate == xeno || candidate.stat == DEAD || islarva(candidate))
			continue
		if(!want_xeno && (!ishuman_strict(candidate) || candidate.faction != FACTION_MARINE))
			continue
		var/turf/candidate_turf = get_turf(candidate)
		if(candidate_turf && is_ground_level(candidate_turf.z))
			victims += candidate
	if(length(victims))
		return pick(victims)

/datum/action/xeno_action/onclick/haunt/proc/get_haunt_turf(mob/living/victim)
	var/turf/victim_turf = get_turf(victim)
	var/list/turf/options = list()
	for(var/turf/open/option in RANGE_TURFS(1, victim_turf))
		if(option != victim_turf && !is_blocked_turf(option))
			options += option
	return length(options) ? pick(options) : victim_turf


/datum/action/xeno_action/onclick/pumpkin_barrage
	name = "Pumpkin Barrage"
	action_icon_state = "bombard"
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS
	var/bomb_count = 5
	var/throw_range = 6

/datum/action/xeno_action/onclick/pumpkin_barrage/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno) || !action_cooldown_check() || !xeno.check_state())
		return
	if(!check_and_use_plasma_owner())
		return
	var/turf/origin = get_turf(xeno)
	var/list/turf/landing_spots = list()
	for(var/turf/open/spot in RANGE_TURFS(throw_range, origin))
		if(get_dist(spot, origin) >= 2)
			landing_spots += spot
	for(var/i in 1 to bomb_count)
		if(!length(landing_spots))
			break
		var/obj/item/horseman_pumpkin_bomb/bomb = new(origin)
		bomb.launch(pick_n_take(landing_spots), xeno)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] throws around pumpkinns!"), SPAN_XENOWARNING("We throw around pumpkins!"))
	apply_cooldown()
	return ..()

/obj/item/horseman_pumpkin_bomb
	name = "pumpkin bomb"
	desc = "bombs?"
	icon = 'icons/misc/events/pumpkins.dmi'
	icon_state = "pumpkin"
	throwforce = 0
	var/fuse_time = 1.5 SECONDS
	var/damage_min = 30
	var/damage_max = 40
	var/blast_radius = 3

/obj/item/horseman_pumpkin_bomb/attack_hand(mob/user)
	return

/obj/item/horseman_pumpkin_bomb/proc/launch(turf/target, mob/thrower)
	set waitfor = FALSE
	throw_atom(target, get_dist(src, target), SPEED_FAST, thrower, TRUE)
	if(QDELETED(src))
		return
	addtimer(CALLBACK(src, PROC_REF(explode)), fuse_time)

/obj/item/horseman_pumpkin_bomb/proc/explode()
	var/turf/blast_turf = get_turf(src)
	if(blast_turf)
		new /obj/effect/particle_effect/explosion(blast_turf)
		playsound(blast_turf, "explosion", 60, TRUE)
		for(var/mob/living/victim in range(blast_radius, blast_turf))
			if(victim.stat == DEAD || istype(victim, /mob/living/carbon/xenomorph/horseman))
				continue
			victim.take_overall_damage(rand(damage_min, damage_max), 0, "pumpkin bomb")
	qdel(src)

/mob/living/carbon/xenomorph/horseman/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/behavior_delegate/horseman_base
	name = "Base Horseman Behavior Delegate"


/obj/effect/particle_effect/smoke/horseman
	name = "spectral fog"
	color = "#8a2be2"
	time_to_live = 12

/datum/effect_system/smoke_spread/horseman
	smoke_type = /obj/effect/particle_effect/smoke/horseman
/datum/action/xeno_action/activable/boomerang_scythe
	name = "Boomerang Scythe"
	action_icon_state = "spin_slash"
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	var/scythe_range = 6

/datum/action/xeno_action/activable/boomerang_scythe/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno) || !action_cooldown_check() || !xeno.check_state())
		return
	var/turf/start_turf = get_turf(xeno)
	var/turf/aim_turf = get_turf(affected_atom)
	if(!start_turf || !aim_turf || aim_turf == start_turf || aim_turf.z != start_turf.z)
		return
	if(!check_and_use_plasma_owner())
		return
	var/dx = aim_turf.x - start_turf.x
	var/dy = aim_turf.y - start_turf.y
	var/scale = scythe_range / max(abs(dx), abs(dy)) // all of this fucking sucks
	var/turf/end_turf = locate(clamp(start_turf.x + round(dx * scale, 1), 1, world.maxx), clamp(start_turf.y + round(dy * scale, 1), 1, world.maxy), start_turf.z)
	var/obj/effect/horseman_scythe/scythe = new(start_turf)
	scythe.launch(xeno, get_line(start_turf, end_turf, FALSE))
	playsound(xeno, 'sound/weapons/slashmiss.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("[xeno] hurls a schytee!"), SPAN_XENOWARNING("We hurl a schyte!"))
	apply_cooldown()
	return ..()

/obj/effect/horseman_scythe
	name = "spectral scythe"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "predscythe"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/datum/weakref/owner_ref
	var/list/turf/outbound_path
	var/returning = FALSE
	var/list/mob/living/hit_this_pass = list()
	var/damage_min = 25
	var/damage_max = 35
	var/step_delay = 1
	var/steps_left = 40

/obj/effect/horseman_scythe/Destroy()
	owner_ref = null
	outbound_path = null
	hit_this_pass = null
	return ..()

/obj/effect/horseman_scythe/proc/launch(mob/living/carbon/xenomorph/thrower, list/turf/path)
	owner_ref = WEAKREF(thrower)
	outbound_path = path
	SpinAnimation(4, -1) // i was told anim_library is probably better for this but its too late
	addtimer(CALLBACK(src, PROC_REF(fly)), step_delay)

/obj/effect/horseman_scythe/proc/fly()
	var/mob/living/carbon/xenomorph/thrower = owner_ref?.resolve()
	steps_left--
	if(QDELETED(thrower) || thrower.stat == DEAD || thrower.z != z || steps_left <= 0)
		qdel(src)
		return
	if(!returning)
		var/turf/next_turf = length(outbound_path) ? outbound_path[1] : null
		if(next_turf && !blocks_scythe(next_turf))
			outbound_path.Cut(1, 2)
			move_and_slash(next_turf)
			return
		returning = TRUE
		hit_this_pass.Cut()
	var/turf/owner_turf = get_turf(thrower)
	if(loc == owner_turf)
		qdel(src)
		return
	move_and_slash(get_step_towards(src, owner_turf))

/obj/effect/horseman_scythe/proc/move_and_slash(turf/next_turf)
	if(!next_turf)
		qdel(src)
		return
	forceMove(next_turf)
	for(var/mob/living/victim in next_turf)
		if(victim.stat == DEAD || (victim in hit_this_pass) || istype(victim, /mob/living/carbon/xenomorph/horseman))
			continue
		hit_this_pass += victim
		victim.take_overall_damage(rand(damage_min, damage_max), 0, "spectral scythe")
		playsound(next_turf, 'sound/weapons/bladeslice.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(fly)), step_delay)

/obj/effect/horseman_scythe/proc/blocks_scythe(turf/target_turf)
	if(target_turf.density)
		return TRUE
	for(var/obj/thing in target_turf)
		if(thing.density)
			return TRUE
	return FALSE
