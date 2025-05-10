GLOBAL_LIST_INIT(resin_build_order_palatine, list(
	/datum/resin_construction/resin_turf/wall/thick,
	/datum/resin_construction/resin_turf/wall/reflective/royal,
	/datum/resin_construction/resin_turf/membrane/thick,
	/datum/resin_construction/resin_obj/door/thick,
	/datum/resin_construction/resin_obj/acid_pillar/palatine,
	/datum/resin_construction/resin_obj/sticky_resin,
	/datum/resin_construction/resin_obj/resin_spike,
	/datum/resin_construction/resin_obj/movable/thick_wall,
	/datum/resin_construction/resin_obj/movable/thick_membrane,
	/datum/resin_construction/resin_obj/resin_node
//	/datum/resin_construction/resin_obj/movable/reflective_royal
))

/datum/resin_construction/resin_obj/acid_pillar/palatine
	name = "Royal Acid Pillar"
	desc = "A tall, green pillar that is capable of firing at multiple targets at once. Fires strong acid."
	construction_name = "acid pillar"

	build_overlay_icon = /obj/effect/warning/alien

	build_path = /obj/effect/alien/resin/acid_pillar/palatine
	build_time = 6 SECONDS

/obj/effect/alien/resin/acid_pillar/palatine
	name = "royal acid pillar"
	desc = "An enhanced resin pillar that is oozing with acid."

	health = (HEALTH_RESIN_XENO_ACID_PILLAR * 2)
	should_track_build = TRUE
	anchored = TRUE

	acid_type = /obj/effect/xenomorph/spray/strong/no_stun
	range = 6

/obj/effect/alien/resin/acid_pillar/palatine/Initialize(mapload, hive)
	. = ..()
	add_filter("royal_glow", priority = 1, params = list("type" = "outline", "color" = BLOOD_COLOR_XENO_ROYAL, "size" = 1))

/datum/resin_construction/resin_turf/wall/reflective/royal
	name = "Royal Reflective Resin Wall"
	desc = "A reflective resin wall, able to reflect any and all projectiles back to the shooter."
	construction_name = "reflective resin wall"
	cost = XENO_RESIN_WALL_REFLECT_COST
	max_per_xeno = 10

	build_path = /turf/closed/wall/resin/reflective/royal

/turf/closed/wall/resin/reflective/royal
	name = "royal reflective membrane"
	damage_cap = HEALTH_WALL_XENO_MEMBRANE_THICK

/datum/action/xeno_action/onclick/plant_weeds/palatine
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/onclick/choose_resin/palatine
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/activable/secrete_resin/palatine
	name = "Secrete Royal Resin"
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	thick = TRUE




///##############################################

/datum/action/xeno_action/onclick/palatine_roar
	name = "Roar"
	icon_file = 'icons/mob/hud/actions_palatine.dmi'
	action_icon_state = "screech_empower"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 60 SECONDS
	plasma_cost = 50

	var/roar_type = "piercing"
	var/screech_sound_effect = "sound/voice/alien_distantroar_3.ogg"
	var/bonus_damage_scale = 2.5
	var/bonus_speed_scale = 0.05

/datum/action/xeno_action/onclick/palatine_change_roar
	name = "Change Roar"
	icon_file = 'icons/mob/hud/actions_palatine.dmi'
	action_icon_state = "screech_shift"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	plasma_cost = 0

/datum/action/xeno_action/onclick/palatine_change_roar/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/onclick/palatine_roar/PR = get_action(X, /datum/action/xeno_action/onclick/palatine_roar)
	if (!istype(PR))
		return

	if (PR.roar_type == "piercing")
		action_icon_result = "screech_disrupt"
		PR.roar_type = "thundering"
		PR.screech_sound_effect = "sound/voice/4_xeno_roars.ogg"
		to_chat(X, SPAN_XENOWARNING("You will now disrupt dangers to the hive!"))

	else
		action_icon_result = "screech_empower"
		PR.roar_type = "piercing"
		PR.screech_sound_effect = "sound/voice/alien_distantroar_3.ogg"
		to_chat(X, SPAN_XENOWARNING("You will now empower your allies with rage!"))

	PR.button.overlays.Cut()
	PR.button.overlays += image('icons/mob/hud/actions_palatine.dmi', button, action_icon_result)
	return ..()
