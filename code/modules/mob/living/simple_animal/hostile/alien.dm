/mob/living/simple_animal/hostile/alien
	name = "Drone"
	var/caste_name = null
	desc = "A builder of hives. Only drones may evolve into Queens."
	icon = 'icons/mob/hostiles/drone.dmi'
	icon_gib = "syndicate_gib"
	layer = BIG_XENO_LAYER
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	status_flags = CANSTUN|CANKNOCKDOWN|CANPUSH
	speed = XENO_SPEED_TIER_6
	meat_type = /obj/item/reagent_container/food/snacks/meat/xenomeat
	health = XENO_HEALTH_TIER_4
	harm_intent_damage = 5
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	attacktext = "slashes"
	a_intent = INTENT_HARM
	attack_sound = 'sound/weapons/alien_claw_flesh1.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	attack_same = TRUE
	faction = FACTION_XENOMORPH
	var/hivenumber = XENO_HIVE_NORMAL
	wall_smash = 1
	minbodytemp = 0
	heat_damage_per_tick = 20
	stop_automated_movement_when_pulled = TRUE
	break_stuff_probability = 90
	mob_size = MOB_SIZE_XENO_SMALL

	pixel_x = -12
	old_x = -12

	var/atom/movable/vis_obj/xeno_wounds/wound_icon_carrier

/mob/living/simple_animal/hostile/alien/Initialize()
	maxHealth = health
	caste_name = name
	handle_icon()
	generate_name()
	. = ..()
	if(hivenumber)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		color = hive.color

	wound_icon_carrier = new(null, src)
	vis_contents += wound_icon_carrier

/mob/living/simple_animal/hostile/alien/proc/generate_name()
	change_real_name(src, "[caste_name] (BD-[rand(1, 999)])")

/mob/living/simple_animal/hostile/alien/proc/handle_icon()
	icon_state = "Normal [caste_name] Running"
	icon_living = "Normal [caste_name] Running"
	icon_dead = "Normal [caste_name] Dead"

/mob/living/simple_animal/hostile/alien/update_transform()
	if(lying != lying_prev)
		lying_prev = lying
	if(stat == DEAD)
		icon_state = "Normal [caste_name] Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Normal [caste_name] Sleeping"
		else
			icon_state = "Normal [caste_name] Knocked Down"
	else
		icon_state = "Normal [caste_name] Running"
	update_wounds()

/mob/living/simple_animal/hostile/alien/evaluate_target(var/mob/living/carbon/target)
	. = ..()
	if(!. || !hivenumber)
		return
	if(istype(target, /mob/living/simple_animal/hostile/alien))
		var/mob/living/simple_animal/hostile/alien/alien_target = target
		if(alien_target.hivenumber == hivenumber)
			return FALSE
	var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
	if(hive.is_ally(target))
		return FALSE

/mob/living/simple_animal/hostile/alien/pull_response(mob/puller)
	if(stat != DEAD && has_species(puller, "Human")) // If the Xeno is alive, fight back against a grab/pull
		var/mob/living/carbon/human/H = puller
		if(H.ally_of_hivenumber(hivenumber))
			return TRUE
		puller.KnockDown(2)
		playsound(puller.loc, 'sound/weapons/pierce.ogg', 25, 1)
		puller.visible_message(SPAN_WARNING("[puller] tried to pull [src] but instead gets a tail swipe to the head!"))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/alien/updatehealth()
	. = ..()
	update_wounds()

/mob/living/simple_animal/hostile/alien/proc/update_wounds()
	if(!wound_icon_carrier)
		return

	wound_icon_carrier.layer = layer + 0.01
	wound_icon_carrier.dir = dir
	var/health_threshold = max(CEILING((health * 4) / (maxHealth), 1), 0) //From 0 to 4, in 25% chunks
	if(health > HEALTH_THRESHOLD_DEAD)
		if(health_threshold > 3)
			wound_icon_carrier.icon_state = "none"
		else if(lying)
			if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
				wound_icon_carrier.icon_state = "[caste_name]_rest_[health_threshold]"
			else
				wound_icon_carrier.icon_state = "[caste_name]_downed_[health_threshold]"
		else
			wound_icon_carrier.icon_state = "[caste_name]_walk_[health_threshold]"

/mob/living/simple_animal/hostile/alien/bullet_act(obj/item/projectile/P)
	. = ..()
	if(P.damage)
		var/splatter_dir = get_dir(P.starting, loc)//loc is the xeno getting hit, P.starting is the turf of where the projectile got spawned
		new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(loc, splatter_dir)
		if(prob(15))
			roar_emote()

/mob/living/simple_animal/hostile/alien/AttackingTarget()
	. = ..()
	if(. && prob(15))
		roar_emote()

/mob/living/simple_animal/hostile/alien/proc/roar_emote()
	visible_message("<B>The [name]</B> roars!")
	playsound(loc, "alien_roar", 40)

/mob/living/simple_animal/hostile/alien/death(cause, gibbed, deathmessage = "lets out a waning guttural screech, green blood bubbling from its maw. The caustic acid starts melting the body away...")
	. = ..()
	if(!.)
		return //If they were already dead, it will return.
	playsound(src, 'sound/voice/alien_death.ogg', 50, 1)
	QDEL_IN(src, 5 SECONDS)
	animate(src, 5 SECONDS, alpha = 0, easing = CUBIC_EASING)

/mob/living/simple_animal/hostile/alien/Destroy()
	vis_contents -= wound_icon_carrier
	QDEL_NULL(wound_icon_carrier)
	return ..()

/mob/living/simple_animal/hostile/alien/ravager
	name = "Ravager"
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/hostiles/ravager.dmi'
	melee_damage_lower = XENO_DAMAGE_TIER_5
	melee_damage_upper = XENO_DAMAGE_TIER_5
	health = XENO_HEALTH_TIER_7
	speed = XENO_SPEED_TIER_2
	mob_size = MOB_SIZE_XENO

	pixel_x = -16
	old_x = -16

/mob/living/simple_animal/hostile/alien/lurker
	name = "Lurker"
	desc = "A fast, powerful backline combatant."
	icon = 'icons/mob/hostiles/lurker.dmi'
	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_3
	health = XENO_HEALTH_TIER_3
	speed = XENO_SPEED_TIER_7

	pixel_x = -12
	old_x = -12

/mob/living/simple_animal/hostile/alien/lurker/handle_icon()
	icon = get_icon_from_source(CONFIG_GET(string/alien_lurker))
	return ..()

// Still using old projectile code - commenting this out for now
// /mob/living/simple_animal/hostile/alien/sentinel
// 	name = "alien sentinel"
// 	icon_state = "Sentinel Running"
// 	icon_living = "Sentinel Running"
// 	icon_dead = "Sentinel Dead"
// 	health = 120
// 	melee_damage_lower = 15
// 	melee_damage_upper = 15
// 	ranged = 1
// 	projectiletype = /obj/item/projectile/neurotox
// 	projectilesound = 'sound/weapons/pierce.ogg'
/obj/item/projectile/neurotox
	damage = 30
	icon_state = "toxin"
