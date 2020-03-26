#define COLLECTOR_DEFCON_RATE 1

var/global/list/faction_phoron_stored_list = list(
	FACTION_MARINE = 0,
	FACTION_PMC = 0,
	FACTION_UPP = 0,
	FACTION_FREELANCER = 0,
	FACTION_CLF = 0
)

/obj/item/collector
	name = "deployable collector"
	desc = "The newest technology from Weston-Yamada, a portable collector of the precious resource phoron. Phoron is used as fuel for the generators."
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	icon_state = "collector"
	w_class = SIZE_TINY

/obj/item/collector/attackby(var/obj/item/O, var/mob/user)
	if(iscrowbar(O))
		user.visible_message(SPAN_NOTICE("[user] pulls [src] apart."), SPAN_NOTICE("You pull [src] apart."))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		new /obj/item/stack/sheet/metal(loc, DEFENSE_METAL_COST)
		qdel(src)
		return
	
	. = ..()

/obj/structure/resource_node/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/collector))
		if(locate(/obj/structure/machinery/collector) in loc)
			to_chat(user, SPAN_WARNING("[src] already has an active [I]."))
			return

		user.visible_message(SPAN_NOTICE("[user] starts setting up [I]."), SPAN_NOTICE("You start setting up [I]."))
		if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
			return
		user.visible_message(SPAN_NOTICE("[user] assembles [I]."), SPAN_NOTICE("You assemble [I]."))

		qdel(I)
		var/obj/structure/machinery/collector/C = new(loc)
		C.RN = src 
		C.belonging_to_faction = user.faction
		return


/obj/structure/machinery/collector
	name = "deployed collector"
	desc = "A deployed collector currently harvesting the phoron."
	icon = 'icons/obj/structures/machinery/defenses.dmi'
	icon_state = "deployed_collector"
	anchored = TRUE
	unacidable = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER //So you can't hide it under corpses
	use_power = FALSE
	stat = WORKING
	health = 150
	var/health_max = 150
	var/obj/structure/resource_node/RN = null
	var/last_gathered_time = 0
	var/gather_cooldown = SECONDS_15
	var/belonging_to_faction = FACTION_MARINE

/obj/structure/machinery/collector/Initialize()
	. = ..()
	
	if(!(belonging_to_faction in faction_phoron_stored_list))
		belonging_to_faction = FACTION_MARINE

	marine_collectors += src
	start_processing()

/obj/structure/machinery/collector/process()
	if(!RN || world.time < (last_gathered_time + gather_cooldown) || faction_phoron_stored_list[belonging_to_faction] >= MAX_PHORON_STORAGE)
		return

	flick("+collect", src)
	last_gathered_time = world.time
	faction_phoron_stored_list[belonging_to_faction] += RN.gather_resource(RN.collect_amount)

	if(FACTION_MARINE == belonging_to_faction)
		objectives_controller.add_admin_points(COLLECTOR_DEFCON_RATE)

	if(RN.disposed)
		break_down()

/obj/structure/machinery/collector/attackby(var/obj/item/O, var/mob/user)
	if(iscrowbar(O))
		user.visible_message(SPAN_NOTICE("[user] begins pulling apart [src]."), SPAN_NOTICE("You begin pulling apart [src]."))

		if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			return

		user.visible_message(SPAN_NOTICE("[user] pulls [src] apart."), SPAN_NOTICE("You pull [src] apart."))
		playsound(loc, 'sound/items/Deconstruct.ogg', 25, 1)
		if(health >= health_max)
			new /obj/item/stack/sheet/metal(loc, DEFENSE_METAL_COST)
		qdel(src)
		return

	if(iswelder(O))
		var/obj/item/tool/weldingtool/WT = O
		if(health < 0)
			to_chat(user, SPAN_WARNING("[src]'s internal circuitry is ruined, there's no way you can salvage this on the go."))
			return

		if(health >= health_max)
			to_chat(user, SPAN_WARNING("[src] isn't in need of repairs."))
			return

		if(WT.remove_fuel(0, user))
			user.visible_message(SPAN_NOTICE("[user] begins repairing [src]."), SPAN_NOTICE("You begin repairing [src]."))
			if(!do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_FRIENDLY, src))
				return
			user.visible_message(SPAN_NOTICE("[user] repairs [src]."), SPAN_NOTICE("You repair [src]."))

			update_health(-50)
			playsound(src.loc, 'sound/items/Welder2.ogg', 25, 1)
			return
	
	. = ..()

/obj/structure/machinery/collector/update_health(var/damage = 0)
	if(damage)
		health -= damage

	if(health <= 0)
		break_down()

/obj/structure/machinery/collector/attack_alien(mob/living/carbon/Xenomorph/M)
	M.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	update_health(rand(M.melee_damage_lower, M.melee_damage_upper))
	if(health <= 0)
		M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"), SPAN_DANGER("You slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		M.visible_message(SPAN_DANGER("[M] slashes [src]!"), SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)

/obj/structure/machinery/collector/proc/break_down()
	var/turf/T = get_turf(src)
	playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
	new /obj/effect/spawner/gibspawner/robot(T)
	new /obj/effect/decal/cleanable/blood/oil(T)
	qdel(src)

/obj/structure/machinery/collector/power_change()
	return

/obj/structure/machinery/collector/Dispose()
	marine_collectors -= src
	RN = null

	. = ..()
	