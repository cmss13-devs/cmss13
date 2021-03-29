/obj/item/defenses/handheld
	name = "Don't see this."
	desc = "A compact version of the USCM defenses. Designed for quick deployment of the associated type in the field."
	icon = 'icons/obj/structures/machinery/defenses/sentry.dmi'
	icon_state = "uac_sentry_handheld"

	force = 5
	throwforce = 5
	throw_speed = SPEED_SLOW
	throw_range = 5
	w_class = SIZE_MEDIUM

	indestructible = TRUE
	var/defense_type = /obj/structure/machinery/defenses
	var/deployment_time = 3 SECONDS

	var/list/upgrade_list
	var/obj_health = 200
	var/obj_health_max = 200

/obj/item/defenses/handheld/examine(mob/user)
	. = ..()

	to_chat(user, SPAN_INFO("It is ready for deployment."))
	to_chat(user, SPAN_INFO("It has [SPAN_HELPFUL("[obj_health]/[obj_health_max]")] health."))

/obj/item/defenses/handheld/attack_self(var/mob/living/carbon/human/user)
	if(!istype(user))
		return

	deploy_handheld(user)

/obj/item/defenses/handheld/proc/deploy_handheld(var/mob/living/carbon/human/user)
	if(user.z == GLOB.interior_manager.interior_z)
		to_chat(usr, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return

	var/turf/T = get_step(user, user.dir)
	var/direction = user.dir

	var/blocked = FALSE
	for(var/obj/O in T)
		if(O.density)
			blocked = TRUE
			break

	for(var/mob/M in T)
		blocked = TRUE
		break

	if(istype(T, /turf/closed))
		blocked = TRUE

	if(blocked)
		to_chat(usr, SPAN_WARNING("You need a clear, open area to build \a [src], something is blocking the way in front of you!"))
		return

	if(!do_after(user, deployment_time * user.get_skill_duration_multiplier(SKILL_CONSTRUCTION), INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
		return

	var/factions = user.get_id_faction_group()
	var/obj/structure/machinery/defenses/D = new defense_type(T, factions)
	D.handheld_type = type
	D.setDir(direction)
	playsound(T, 'sound/mecha/mechmove01.ogg', 30, 1)
	D.name = replacetext(src.name, "handheld ", "") //fixed
	D.health = obj_health
	qdel(src)


// SENTRY BASE AND UPGRADES
/obj/item/defenses/handheld/sentry
	name = "handheld UA 571-C sentry gun"
	icon = 'icons/obj/structures/machinery/defenses/sentry.dmi'
	icon_state = "Normal uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry

/obj/item/defenses/handheld/sentry/Initialize(mapload, ...)
	. = ..()
	upgrade_list = list(
		"DMR turret" = /obj/item/defenses/handheld/sentry/dmr,
		"Shotgun turret" = /obj/item/defenses/handheld/sentry/shotgun,
		"Mini turret" = /obj/item/defenses/handheld/sentry/mini
	)

/obj/item/defenses/handheld/sentry/dmr
	name = "handheld UA 725-D sniper sentry"
	icon_state = "DMR uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/dmr

/obj/item/defenses/handheld/sentry/shotgun
	name = "handheld UA 12-G shotgun sentry"
	icon_state = "Shotgun uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/shotgun

/obj/item/defenses/handheld/sentry/mini
	name = "handheld UA 512-M mini sentry"
	icon_state = "Mini uac_sentry_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/mini
	deployment_time = 0.75 SECONDS

// FLAMER BASE AND UPGRADES
/obj/item/defenses/handheld/sentry/flamer
	name = "handheld UA 42-F sentry flamer"
	icon = 'icons/obj/structures/machinery/defenses/flamer.dmi'
	icon_state = "Normal uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer
	var/ammo_convert

/obj/item/defenses/handheld/sentry/flamer/Initialize(mapload, ...)
	. = ..()
	upgrade_list = list(
		"Assault flamer" = /obj/item/defenses/handheld/sentry/flamer/assault,
		"Plasma glob flamer" = /obj/item/defenses/handheld/sentry/flamer/plasma,
		"Mini flamer" = /obj/item/defenses/handheld/sentry/flamer/mini
	)

/obj/item/defenses/handheld/sentry/flamer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!ammo_convert) return

	if(!istype(target, /obj/item/ammo_magazine/sentry_flamer))
		return .

	user.visible_message(SPAN_NOTICE("[user] begins to tweak the ammo of [target]."), SPAN_NOTICE("You begin to tweak the ammo of [target]."))

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target))
		to_chat(user, SPAN_WARNING("You stop tweaking [target]'s ammo."))
		return

	var/obj/item/ammo_magazine/sentry_flamer/mag = new ammo_convert(get_turf(user))

	user.visible_message(SPAN_NOTICE("[user] converts the ammo of [target] to [mag]"), SPAN_NOTICE("You convert the ammo of [target] to [mag]"))

	qdel(target)
	user.put_in_any_hand_if_possible(mag)


/obj/item/defenses/handheld/sentry/flamer/mini
	name = "handheld UA 45-FM mini sentry"
	icon_state = "Mini uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer/mini
	deployment_time = 0.75 SECONDS
	ammo_convert = /obj/item/ammo_magazine/sentry_flamer/mini
/obj/item/defenses/handheld/sentry/flamer/plasma
	name = "handheld UA 60-FP plasma sentry"
	icon_state = "Plasma uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer/plasma
	ammo_convert = /obj/item/ammo_magazine/sentry_flamer/glob

/obj/item/defenses/handheld/sentry/flamer/assault
	name = "handheld UA 55-FA flamer assault sentry"
	icon_state = "Assault uac_flamer_handheld"
	defense_type = /obj/structure/machinery/defenses/sentry/flamer/assault
	ammo_convert = /obj/item/ammo_magazine/sentry_flamer/assault

// TESLA BASE AND UPGRADES
/obj/item/defenses/handheld/tesla_coil
	name = "handheld 21S tesla coil"
	icon = 'icons/obj/structures/machinery/defenses/tesla.dmi'
	icon_state = "Normal tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil
	obj_health = 150
	obj_health_max = 150


/obj/item/defenses/handheld/tesla_coil/stun
	name = "handheld 21S overclocked tesla coil"
	icon_state = "Stun tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil/stun
/obj/item/defenses/handheld/tesla_coil/micro
	name = "handheld 25S micro tesla coil"
	icon_state = "Micro tesla_coil_handheld"
	defense_type = /obj/structure/machinery/defenses/tesla_coil/micro
	deployment_time = 0.75 SECONDS
	obj_health = 75
	obj_health_max = 75

/obj/item/defenses/handheld/tesla_coil/Initialize(mapload, ...)
	. = ..()
	upgrade_list = list(
		"Increased Voltage" = /obj/item/defenses/handheld/tesla_coil/stun,
		"Micro-tesla" = /obj/item/defenses/handheld/tesla_coil/micro
	)

// BELL TOWER BASE AND UPGRADES
/obj/item/defenses/handheld/bell_tower
	name = "handheld R-1NG bell tower"
	icon = 'icons/obj/structures/machinery/defenses/bell_tower.dmi'
	icon_state = "Normal bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower

/obj/item/defenses/handheld/bell_tower/md
	name = "handheld R-1NG motion detector tower"
	icon_state = "MD bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower/md

/obj/item/defenses/handheld/bell_tower/cloaker
	name = "handheld camouflaged R-1NG bell tower"
	icon_state = "Cloaker bell_tower_handheld"
	defense_type = /obj/structure/machinery/defenses/bell_tower/cloaker

/obj/item/defenses/handheld/bell_tower/Initialize(mapload, ...)
	. = ..()
	upgrade_list = list(
		"Motion Detector" = /obj/item/defenses/handheld/bell_tower/md,
		"Cloaker" = /obj/item/defenses/handheld/bell_tower/cloaker,
		"IMP frame mount" = /obj/item/device/imp
	)

// JIMA TOWER BASE AND UPGRADES
/obj/item/defenses/handheld/planted_flag
	name = "handheld JIMA planted flag"
	icon = 'icons/obj/structures/machinery/defenses/planted_flag.dmi'
	icon_state = "Normal planted_flag_handheld"
	defense_type = /obj/structure/machinery/defenses/planted_flag
	deployment_time = 1 SECONDS

/obj/item/defenses/handheld/planted_flag/Initialize(mapload, ...)
	. = ..()
	upgrade_list = list(
		"Warbanner" = /obj/item/defenses/handheld/planted_flag/warbanner,
		"extended JIMA" = /obj/item/defenses/handheld/planted_flag/range,
		"JIMA frame mount" = /obj/item/device/jima
	)

/obj/item/defenses/handheld/planted_flag/warbanner
	name = "handheld JIMA planted warbanner"
	icon_state = "Warbanner planted_flag_handheld"
	defense_type = /obj/structure/machinery/defenses/planted_flag/warbanner

/obj/item/defenses/handheld/planted_flag/range
	name = "handheld extended JIMA planted flag"
	icon_state = "Range planted_flag_handheld"
	defense_type = /obj/structure/machinery/defenses/planted_flag/range


