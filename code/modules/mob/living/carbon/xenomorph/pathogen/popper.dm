/datum/caste_datum/pathogen/popper
	caste_type = PATHOGEN_CREATURE_POPPER
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_1
	melee_vehicle_damage = 0
	max_health = XENO_HEALTH_TIER_2
	plasma_gain = XENO_PLASMA_GAIN_TIER_2
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_8

	attack_delay = 2 // VERY high slash damage, but attacks relatively slowly

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base

	deevolves_to = list(PATHOGEN_CREATURE_BURSTER)
	caste_desc = "A fast, powerful combatant."
	evolves_to = list(PATHOGEN_CREATURE_NEOMORPH)

	heal_resting = 1

	minimap_icon = "popper"

/mob/living/carbon/xenomorph/popper
	caste_type = PATHOGEN_CREATURE_POPPER
	name = PATHOGEN_CREATURE_POPPER
	desc = "A sleek, fast alien with sharp claws."
	icon_size = 32
	icon_state = "Popper Walking"
	plasma_types = list()
	tier = 1
	base_pixel_x = 0
	base_pixel_y = -20
	organ_value = 10000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen/popper,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/place_spore_sac,
		/datum/action/xeno_action/onclick/release_spores,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_NORMAL

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/pathogen/popper.dmi'
	icon_xenonid = 'icons/mob/pathogen/popper.dmi'
	need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")
	gib_chance = 100

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "neo_talk"

	mob_size = MOB_SIZE_XENO_SMALL
	acid_blood_damage = 0
	bubble_icon = "pathogen"
	aura_strength = 2

/mob/living/carbon/xenomorph/popper/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	make_pathogen_speaker()

/mob/living/carbon/xenomorph/popper/death(cause, gibbed)
	. = ..()
	new /obj/effect/pathogen/spore_cloud(loc)

/datum/action/xeno_action/onclick/place_spore_sac
	name = "Place spore sac (700)"
	action_icon_state = "place_trap"
	plasma_cost = 700
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/place_spore_sac/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/popper = owner
	if(!popper.check_state())
		return

	var/turf/target_turf = get_turf(popper)
	if(!istype(target_turf))
		to_chat(popper, SPAN_XENOWARNING("We can't do that here."))
		return
	var/area/turf_area = get_area(target_turf)
	if(istype(turf_area,/area/shuttle/drop1/lz1) || istype(turf_area,/area/shuttle/drop2/lz2) || SSinterior.in_interior(owner))
		to_chat(popper, SPAN_WARNING("We sense this is not a suitable area for creating a spore sac."))
		return
	if(!target_turf.check_spore_sac_placement(popper))
		return
	if(!popper.check_plasma(plasma_cost))
		return
	popper.use_plasma(plasma_cost)
	playsound(popper.loc, "alien_resin_build", 25)
	new /obj/effect/pathogen/spore_sac(target_turf)
	to_chat(popper, SPAN_XENONOTICE("We place a spore sac on the ground."))
	return ..()

/turf/proc/check_spore_sac_placement(mob/living/carbon/xenomorph/xeno)
	if(is_weedable < FULLY_WEEDABLE)
		to_chat(xeno, SPAN_XENOWARNING("This place cannot support a spore sac."))
		return FALSE

	var/obj/effect/alien/weeds/alien_weeds = locate() in src
	if(alien_weeds && (alien_weeds.linked_hive.hivenumber != xeno.hivenumber))
		to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on this contaminant!"))
		return FALSE

	// This snowflake check exists because stairs specifically are indestructable, tile-covering, and cannot be moved, which allows resin holes to be
	// planted under them without any possible counterplay. In the future if resin holes stop being able to be hidden under objects, remove this check.
	if(locate(/obj/structure) in src)
		if(locate(/obj/structure/stairs) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a staircase!"))
			return FALSE

		if(locate(/obj/structure/monorail) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a track!"))
			return FALSE

		if(locate(/obj/structure/machinery/conveyor) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a conveyor!"))
			return FALSE

		if(locate(/obj/structure/machinery/colony_floodlight) in src)
			to_chat(xeno, SPAN_XENOWARNING("We cannot grow spores on a light!"))
			return FALSE

	if(!xeno.check_alien_construction(src, check_doors = TRUE))
		return FALSE

	if(locate(/obj/effect/alien/resin/trap) in orange(1, src)) // obj/effect/alien/resin presence is checked on turf by check_alien_construction, so we just check orange.
		to_chat(xeno, SPAN_XENOWARNING("This is too close to a contaminant!"))
		return FALSE

	for(var/mob/living/body in src)
		if(body.stat == DEAD)
			to_chat(xeno, SPAN_XENOWARNING("The body is in the way!"))
			return FALSE

	return TRUE

/datum/action/xeno_action/onclick/release_spores
	name = "Release Spore Cloud (200)"
	action_icon_state = "gas mine"
	plasma_cost = 200
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/onclick/release_spores/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/popper = owner
	if(!popper.check_state())
		return

	var/turf/target_turf = get_turf(popper)
	if(!istype(target_turf))
		to_chat(popper, SPAN_XENOWARNING("We can't do that here."))
		return
	if(!popper.check_plasma(plasma_cost))
		return
	if(!do_after(popper, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		return
	popper.use_plasma(plasma_cost)
	playsound(popper.loc, "alien_resin_build", 25)
	new /obj/effect/pathogen/spore_cloud(target_turf)
	popper.visible_message(SPAN_DANGER("[src] releases a cloud of spores!"), SPAN_XENONOTICE("We release a spore cloud."))
	return ..()
