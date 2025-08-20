/// Dropship equipment, mainly weaponry but also utility implements
/obj/structure/dropship_equipment
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	climbable = TRUE
	layer = ABOVE_OBJ_LAYER //so they always appear above attach points when installed
	var/shorthand

	var/list/equip_categories //on what kind of base this can be installed.
	var/obj/effect/attach_point/ship_base //the ship base the equipment is currently installed on.
	var/uses_ammo = FALSE //whether it uses ammo
	var/obj/structure/ship_ammo/ammo_equipped //the ammo currently equipped.
	var/is_weapon = FALSE //whether the equipment is a weapon usable for dropship bombardment.
	var/obj/structure/machinery/computer/dropship_weapons/linked_console //the weapons console of the dropship we're installed on.
	var/is_interactable = FALSE //whether they get a button when shown on the shuttle console's equipment list.
	var/obj/docking_port/mobile/marine_dropship/linked_shuttle
	var/screen_mode = 0 //used by the dropship console code when this equipment is selected
	var/point_cost = 0 //how many points it costs to build this with the fabricator, set to 0 if unbuildable.
	var/skill_required = SKILL_PILOT_TRAINED
	var/combat_equipment = TRUE
	var/faction_exclusive //if null all factions can print it
	/// Whether the ammo inside this equipment can be directly replenished without needing to uninstall the existing ammo
	var/stackable_ammo = FALSE

	var/damaged = FALSE // TRUE if affected by any anti-air effect
	var/antiair_fire = FALSE // TRUE if anti-air disables firing
	var/antiair_reload = FALSE // TRUE if anti-air disables reloading

	var/list/active_effects = list() // List of active anti-air effects

/obj/structure/dropship_equipment/Destroy()
	QDEL_NULL(ammo_equipped)
	if(linked_shuttle)
		SEND_SIGNAL(linked_shuttle, COMSIG_DROPSHIP_REMOVE_EQUIPMENT, src)
		linked_shuttle = null
	if(ship_base)
		ship_base.installed_equipment = null
		ship_base = null
	if(linked_console)
		if(linked_console.selected_equipment && linked_console.selected_equipment == src)
			linked_console.selected_equipment = null
		linked_console = null
	. = ..()


/obj/structure/dropship_equipment/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/dropship_equipment/attackby(obj/item/item_equip, mob/user)
	if(istype(item_equip, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/powerloader_item = item_equip
		if(istype(src, /obj/structure/dropship_equipment/autoreloader))
			var/obj/structure/dropship_equipment/autoreloader/autoreloader_equipment = src
			// Loading ammo into autoreloader
			if(powerloader_item.loaded)
				// Prevent loading if shuttle is not idle
				if(!(autoreloader_equipment.linked_shuttle.mode in list(SHUTTLE_IDLE, SHUTTLE_IGNITING, SHUTTLE_RECHARGING)))
					to_chat(user, SPAN_WARNING("You cannot load ammo while the dropship is in flight or busy!"))
					return TRUE
				// Only allow compatible ammo types
				if(!istype(powerloader_item.loaded, /obj/structure/ship_ammo))
					to_chat(user, SPAN_WARNING("You need to use a powerloader holding dropship ammo to load [src]."))
					return TRUE
				var/obj/structure/ship_ammo/ammo = powerloader_item.loaded
				if(!(src.type in ammo.equipment_type))
					to_chat(user, SPAN_WARNING("[ammo] is not compatible with the autoreloader!"))
					return TRUE
				if(ammo in autoreloader_equipment.stored_ammo)
					to_chat(user, SPAN_WARNING("[ammo] is already stored in [src]."))
					return TRUE
				if(length(autoreloader_equipment.stored_ammo) >= autoreloader_equipment.max_ammo_slots)
					to_chat(user, SPAN_WARNING("[src] cannot store more ammo. Maximum capacity reached."))
					return TRUE
				to_chat(user, SPAN_NOTICE("You begin loading [ammo] into [src]."))
				playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
				if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target = src))
					to_chat(user, SPAN_WARNING("You stop loading [ammo] into [src]."))
					return TRUE
				// Directly add ammo to stored_ammo list
				if(length(autoreloader_equipment.stored_ammo) < autoreloader_equipment.max_ammo_slots)
					autoreloader_equipment.stored_ammo += ammo
					ammo.forceMove(src)
					powerloader_item.loaded = null
					playsound(src, 'sound/machines/hydraulics_2.ogg', 40, 1)
					powerloader_item.update_icon()
					to_chat(user, SPAN_NOTICE("You successfully load [ammo] into [src]."))
					autoreloader_equipment.update_icon()
				else
					to_chat(user, SPAN_WARNING("[src] cannot store more ammo. Maximum capacity reached."))
				return TRUE
			// Unloading ammo from autoreloader
			else if(!powerloader_item.loaded && length(autoreloader_equipment.stored_ammo) > 0)
				var/obj/structure/ship_ammo/ammo = autoreloader_equipment.stored_ammo[autoreloader_equipment.stored_ammo.len]
				to_chat(user, SPAN_NOTICE("You begin unloading [ammo] from [src]."))
				if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target = src))
					to_chat(user, SPAN_WARNING("You stop unloading [ammo] from [src]."))
					return TRUE
				// Directly remove ammo from stored_ammo list
				if(ammo in autoreloader_equipment.stored_ammo)
					autoreloader_equipment.stored_ammo -= ammo
					ammo.forceMove(powerloader_item)
					powerloader_item.loaded = ammo
					powerloader_item.update_icon()
					to_chat(user, SPAN_NOTICE("You unload [ammo] from [src] into the powerloader clamp."))
					autoreloader_equipment.selected_ammo = null
					autoreloader_equipment.update_icon()
				else
					to_chat(user, SPAN_WARNING("Failed to unload ammo from [src]."))
				return TRUE

		// Default behavior for other equipment
		if(powerloader_item.loaded)
			if(ammo_equipped)
				// Allow stacking if stackable_ammo is TRUE, types match, and not full
				if(stackable_ammo && istype(powerloader_item.loaded, /obj/structure/ship_ammo) && ammo_equipped.type == powerloader_item.loaded.type && ammo_equipped.ammo_count < ammo_equipped.max_ammo_count)
					// Add do_after before stacking
					if(!do_after(user, 1 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
						to_chat(user, SPAN_WARNING("You stop topping off [src] with the ammo."))
						return TRUE
					var/obj/structure/ship_ammo/powerloader_ammo = powerloader_item.loaded
					var/amt_to_add = min(powerloader_ammo.ammo_count, ammo_equipped.max_ammo_count - ammo_equipped.ammo_count)
					ammo_equipped.ammo_count += amt_to_add
					powerloader_ammo.ammo_count -= amt_to_add
					if(powerloader_ammo.ammo_count <= 0)
						qdel(powerloader_ammo)
					powerloader_item.loaded = null
					to_chat(user, SPAN_NOTICE("You top off [src] with the ammo."))
					update_equipment()
					return TRUE
				to_chat(user, SPAN_WARNING("You need to unload \the [ammo_equipped] from \the [src] first!"))
				return TRUE
			if(uses_ammo) //it handles on it's own whether the ammo fits
				load_ammo(powerloader_item, user)
				return TRUE
		else
			if(uses_ammo && ammo_equipped)
				unload_ammo(powerloader_item, user)
			else
				grab_equipment(powerloader_item, user)
		return TRUE

	// Support for loading handheld ship_ammo by hand
	if(istype(item_equip, /obj/structure/ship_ammo) || istype(item_equip, /obj/item/ship_ammo_handheld))
		var/obj/structure/ship_ammo/hand_ammo
		var/obj/item/ship_ammo_handheld/handheld_ammo
		if(istype(item_equip, /obj/structure/ship_ammo))
			hand_ammo = item_equip
		else if(istype(item_equip, /obj/item/ship_ammo_handheld))
			handheld_ammo = item_equip
			// Convert to structure for stacking, using the correct type
			var/typepath = handheld_ammo.structure_type ? handheld_ammo.structure_type : /obj/structure/ship_ammo/flare
			hand_ammo = new typepath()
			hand_ammo.ammo_count = handheld_ammo.ammo_count
			hand_ammo.max_ammo_count = handheld_ammo.max_ammo_count
			hand_ammo.safety_enabled = handheld_ammo.safety_enabled
			hand_ammo.icon_state = handheld_ammo.icon_state
			hand_ammo.handheld = TRUE
		if(stackable_ammo && ammo_equipped && hand_ammo && hand_ammo.type == ammo_equipped.type)
			// Add a 2 second do_after before stacking
			if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target = src))
				to_chat(user, SPAN_WARNING("You stop topping off [src] with the ammo."))
				return TRUE
			var/amt_to_add = min(hand_ammo.ammo_count, ammo_equipped.max_ammo_count - ammo_equipped.ammo_count)
			ammo_equipped.ammo_count += amt_to_add
			hand_ammo.ammo_count -= amt_to_add
			if(handheld_ammo)
				handheld_ammo.ammo_count = hand_ammo.ammo_count
				if(hand_ammo.ammo_count <= 0)
					qdel(handheld_ammo)
					if(hand_ammo != item_equip) // Only qdel if we created it
						qdel(hand_ammo)
			else
				if(hand_ammo.ammo_count <= 0)
					qdel(hand_ammo)
			to_chat(user, SPAN_NOTICE("You top off [src] with the ammo."))
			update_equipment()
			return TRUE

		// Manual install of ship_ammo_handheld if equipment is empty and compatible
		if(!ammo_equipped && handheld_ammo && handheld_ammo.structure_type)
			// Prevent loading flare ammo with safety enabled
			if(istype(handheld_ammo) && handheld_ammo.safety_enabled)
				to_chat(user, SPAN_WARNING("You must disable the safety on [handheld_ammo] before loading it into [src]!"))
				return TRUE
			var/typepath = handheld_ammo.structure_type
			var/obj/structure/ship_ammo/proto = new typepath()
			var/equip_types = proto.equipment_type
			var/compatible = FALSE
			if(islist(equip_types))
				for(var/eq_type in equip_types)
					if(istype(src, eq_type))
						compatible = TRUE
						break
			else if(equip_types)
				if(istype(src, equip_types))
					compatible = TRUE
			qdel(proto)
			if(compatible)
				to_chat(user, SPAN_NOTICE("You begin installing [handheld_ammo.name] into [src]."))
				if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target = src))
					to_chat(user, SPAN_WARNING("You stop installing [handheld_ammo.name] into [src]."))
					return TRUE
				var/obj/structure/ship_ammo/installed = new typepath(src)
				installed.ammo_count = handheld_ammo.ammo_count
				installed.max_ammo_count = handheld_ammo.max_ammo_count
				installed.safety_enabled = handheld_ammo.safety_enabled
				installed.icon_state = handheld_ammo.icon_state
				installed.handheld = TRUE
				ammo_equipped = installed
				qdel(handheld_ammo)
				to_chat(user, SPAN_NOTICE("You install [installed.name] into [src]."))
				update_equipment()
				return TRUE

	//Handle anti-air effect repair logic
	if(istype(item_equip, /obj/item/device/dropship_handheld))
		return ..()
	// Only allow people that have at least level 1 in Piloting or Engineering to repair damage
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED) && !skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
		to_chat(user, SPAN_WARNING("You don't even understand how to begin fixing this equipment!"))
		return TRUE
	// Block all repair tools if installed
	if(src.ship_base)
		var/is_tool = FALSE
		for(var/tool_type in GLOB.dropship_repair_tool_types)
			if(istype(item_equip, GLOB.dropship_repair_tool_types[tool_type]))
				is_tool = TRUE
				break
		if(is_tool)
			to_chat(user, SPAN_WARNING("You can't repair this while it's installed!"))
			return TRUE
	// Iterate over all active anti-air effects
	var/any_repairable = FALSE
	for(var/datum/dropship_antiair/effect in active_effects)
		if(!islist(effect.repair_steps) || !length(effect.repair_steps))
			continue
		if(!effect.repairing)
			effect.repairing = TRUE
			effect.repair_step_index = 1
		// Only allow one repair at a time per effect
		if(effect.repairing)
			var/next_step = effect.repair_steps[effect.repair_step_index]
			var/expected_type = get_dropship_repair_tool_type(next_step)
			//wear your insulated gloves, shocks the user before any do_after if the next step is wirecutters
			if(next_step == "WIRECUTTERS")
				var/mob/living/Living_mob = user
				if(Living_mob.electrocute_act(10, src))
					effect.repairing = FALSE
					to_chat(user, SPAN_DANGER("You are shocked by the exposed wiring!"))
					return TRUE
			//repair speed scales on engineering skill level, MTs and DCC repair faster than POs as a result
			if(!do_after(user, (5 SECONDS) * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target = src))
				effect.repairing = FALSE
				to_chat(user, SPAN_WARNING("Repair interrupted!"))
				return TRUE
			//if the tool is not the expected type, warn the user
			if(!expected_type || !istype(item_equip, expected_type))
				to_chat(user, SPAN_WARNING("Incorrect tool!"))
				// Stay on the same step, do not advance or reset anything
				return TRUE
			//need the welder to be active for welding repairs
			if(next_step == "WELDER" && istype(item_equip, /obj/item/tool/weldingtool))
				var/obj/item/tool/weldingtool/weld = item_equip
				if(!weld.welding)
					to_chat(user, SPAN_WARNING("The welder must be activated!"))
					effect.repairing = FALSE
					return TRUE
				weld.eyecheck(user)
			// Play sounds and effects
			if(next_step == "CROWBAR")
				playsound(src, 'sound/items/Crowbar.ogg', 25, 1)
			else if(next_step == "SCREWDRIVER")
				playsound(src, 'sound/items/Screwdriver.ogg', 25, 1)
			else if(next_step == "WELDER")
				playsound(src, 'sound/items/Welder.ogg', 25, 1)
			else if(next_step == "WIRECUTTERS")
				playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
				var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
				sparks.set_up(5, 1, src.loc)
				sparks.start()
			else if(next_step == "WRENCH")
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
			else if(next_step == "MULTITOOL")
				playsound(src, 'sound/items/tick.ogg', 35, 1)
			else if(next_step == "CABLE COIL")
				playsound(src, 'sound/items/component_pickup.ogg', 35, 1)
			// Advance repair step
			effect.repair_step_index++
			if(effect.repair_step_index > length(effect.repair_steps))
				effect.repairing = FALSE
				effect.repair_step_index = null
				effect.repair_steps = list() // Mark as repaired
				to_chat(user, SPAN_NOTICE("All repair steps complete for [effect.name]!"))
				remove_antiair_effect(effect)

				// Show completion message if no effects remain
				if(!active_effects || active_effects.len == 0)
					to_chat(user, SPAN_NOTICE("All malfunctions have been repaired! [src] is operational."))
				return TRUE
			any_repairable = TRUE
			return TRUE
	if(!any_repairable)
		to_chat(user, SPAN_WARNING("No malfunctions are available to repair."))
	return TRUE

/obj/structure/dropship_equipment/proc/load_ammo(obj/item/powerloader_clamp/PC, mob/living/user)
	if(istype(src, /obj/structure/dropship_equipment/weapon))
		var/obj/structure/dropship_equipment/weapon/W = src
		if(W.antiair_reload)
			to_chat(user, SPAN_WARNING("[W] is damaged and cannot be reloaded!"))
			return

	// Prevent loading bomb bay ammo while shuttle is in flight
	if(istype(src, /obj/structure/dropship_equipment/weapon/bomb_bay))
		if(linked_shuttle && !(linked_shuttle.mode in list(SHUTTLE_IDLE, SHUTTLE_IGNITING, SHUTTLE_RECHARGING)))
			to_chat(user, SPAN_WARNING("You cannot load ammo while the dropship is in flight or busy!"))
			return

	if(!ship_base || !uses_ammo || ammo_equipped || !istype(PC.loaded, /obj/structure/ship_ammo))
		return
	var/obj/structure/ship_ammo/SA = PC.loaded

	// Prevent loading any ship_ammo with safety enabled
	if(SA.safety_enabled)
		to_chat(user, SPAN_WARNING("You must disable the safety on [SA] before loading it into [src]!"))
		return

	// Check if equipment_type is a list
	if(istype(SA.equipment_type, /list))
		var/eq_types = SA.equipment_type
		var/found = FALSE
		for(var/eq_type in eq_types)
			if(istype(src, eq_type))  // Check if THIS object is of the allowed type
				found = TRUE
				break
		if(!found)
			to_chat(user, SPAN_WARNING("[SA] doesn't fit in [src]."))
			return
	else if(!istype(src, SA.equipment_type))
		to_chat(user, SPAN_WARNING("[SA] doesn't fit in [src]."))
		return

	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	var/point_loc = ship_base.loc
	if(!do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	if(!ship_base || ship_base.loc != point_loc)
		return

	// Default behavior for weapons and other equipment
	if(!ammo_equipped && PC.loaded == SA && PC.linked_powerloader && PC.linked_powerloader.buckled_mob == user)
		SA.forceMove(src)
		PC.loaded = null
		playsound(src, 'sound/machines/hydraulics_2.ogg', 40, 1)
		PC.update_icon()
		to_chat(user, SPAN_NOTICE("You load [SA] into [src]."))
		ammo_equipped = SA
		update_equipment()

/obj/structure/dropship_equipment/proc/unload_ammo(obj/item/powerloader_clamp/PC, mob/living/user)
	playsound(src, 'sound/machines/hydraulics_2.ogg', 40, 1)
	var/point_loc = ship_base ? ship_base.loc : null
	if(!do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	if(point_loc && ship_base.loc != point_loc) //dropship flew away
		return
	if(!ammo_equipped || !PC.linked_powerloader || PC.linked_powerloader.buckled_mob != user)
		return
	if(!ammo_equipped.ammo_count)
		ammo_equipped.moveToNullspace()
		to_chat(user, SPAN_NOTICE("You discard the empty [ammo_equipped.name] in \the [src]."))
		qdel(ammo_equipped)
	else
		if(ammo_equipped.ammo_name == "rocket")
			PC.grab_object(user, ammo_equipped, "ds_rocket")
		else
			PC.grab_object(user, ammo_equipped, "ds_ammo")
	ammo_equipped = null
	update_icon()

/obj/structure/dropship_equipment/proc/grab_equipment(obj/item/powerloader_clamp/PC, mob/living/user)
	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
	var/duration_time = 10
	var/point_loc
	if(ship_base)
		duration_time = 70 //uninstalling equipment takes more time
		point_loc = ship_base.loc
	if(user.action_busy)
		return
	if(!do_after(user, duration_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target_flags = INTERRUPT_DIFF_LOC, target = src))
		return
	if(point_loc && ship_base && ship_base.loc != point_loc) //dropship flew away
		return
	if(!PC.linked_powerloader || PC.loaded || PC.linked_powerloader.buckled_mob != user)
		return
	PC.grab_object(user, src, "ds_gear", 'sound/machines/hydraulics_1.ogg')
	if(ship_base)
		ship_base.installed_equipment = null
		ship_base = null
		if(linked_shuttle)
			SEND_SIGNAL(linked_shuttle, COMSIG_DROPSHIP_REMOVE_EQUIPMENT, src)
			linked_shuttle = null
			if(linked_console && linked_console.selected_equipment == src)
				linked_console.selected_equipment = null
	update_equipment()

/obj/structure/dropship_equipment/update_icon()
	return

/obj/structure/dropship_equipment/proc/update_equipment()
	return

//things to do when the shuttle this equipment is attached to is about to launch.
/obj/structure/dropship_equipment/proc/on_launch()
	return

//things to do when the shuttle this equipment is attached to land.
/obj/structure/dropship_equipment/proc/on_arrival()
	return

/obj/structure/dropship_equipment/proc/equipment_interact(mob/user)
	if(is_interactable)
		if(linked_console.selected_equipment)
			return
		linked_console.selected_equipment = src
		to_chat(user, SPAN_NOTICE("You select [src]."))

/obj/structure/dropship_equipment/get_examine_text(mob/user)
	. = ..()
	if(damaged && active_effects.len > 0) // shows the description of antiair effects, i'll add a visual icon later
		. +=  SPAN_WARNING("It appears to be damaged!")
		var/list/unique_descriptions = list()
		for(var/datum/dropship_antiair/effect in active_effects)
			if(!(effect.description in unique_descriptions))
				unique_descriptions += effect.description
		for(var/description in unique_descriptions)
			. += SPAN_WARNING("[description]")

/// Turret holder for dropship automated sentries
/obj/structure/dropship_equipment/sentry_holder
	equip_categories = list(DROPSHIP_WEAPON, DROPSHIP_CREW_WEAPON)
	name = "\improper A/A-32-P Sentry Defense System"
	desc = "A box that deploys a sentry turret. Fits on both the external weapon and crew compartment attach points of dropships. You need a powerloader to lift it."
	density = FALSE
	health = null
	icon_state = "sentry_system"
	is_interactable = TRUE
	point_cost = 200
	shorthand = "Sentry"
	var/deployment_cooldown
	var/obj/structure/machinery/defenses/sentry/premade/dropship/deployed_turret
	combat_equipment = FALSE
	var/auto_deploy = FALSE // allows dropship turrets to be auto deployed, a toggle

/obj/structure/dropship_equipment/sentry_holder/Initialize()
	. = ..()

	if(!deployed_turret)
		deployed_turret = new(src)
		deployed_turret.deployment_system = src

/obj/structure/dropship_equipment/sentry_holder/get_examine_text(mob/user)
	. = ..()
	if(!deployed_turret)
		. += "Its turret is missing."

/obj/structure/dropship_equipment/sentry_holder/ui_data(mob/user)
	var/obj/structure/machinery/defenses/defense = deployed_turret
	. = list()
	var/is_deployed = deployed_turret.loc != src
	.["name"] = defense.name
	.["area"] = get_area(defense)
	.["active"] = defense.turned_on
	.["nickname"] = defense.nickname
	.["camera_available"] = defense.has_camera && is_deployed
	.["selection_state"] = list()
	.["kills"] = defense.kills
	.["iff_status"] = defense.faction_group
	.["health"] = defense.health
	.["health_max"] = defense.health_max
	.["deployed"] = is_deployed
	.["auto_deploy"] = auto_deploy

	if(istype(defense, /obj/structure/machinery/defenses/sentry))
		var/obj/structure/machinery/defenses/sentry/sentrygun = defense
		.["rounds"] = sentrygun.ammo.current_rounds
		.["max_rounds"] = sentrygun.ammo.max_rounds
		.["engaged"] = length(sentrygun.targets)

/obj/structure/dropship_equipment/sentry_holder/on_launch()
	if(ship_base && ship_base.base_category == DROPSHIP_WEAPON) //only external sentires are automatically undeployed
		undeploy_sentry()

/obj/structure/dropship_equipment/sentry_holder/on_arrival()
	if(ship_base && auto_deploy && ship_base.base_category == DROPSHIP_WEAPON) //only external sentires are automatically deployed
		deploy_sentry()

/obj/structure/dropship_equipment/sentry_holder/equipment_interact(mob/user)
	if(deployed_turret)
		if(deployment_cooldown > world.time)
			to_chat(user, SPAN_WARNING("[src] is busy."))
			return //prevents spamming deployment/undeployment
		if(deployed_turret.loc == src) //not deployed
			if(is_reserved_level(z) && ship_base.base_category == DROPSHIP_WEAPON)
				to_chat(user, SPAN_WARNING("[src] can't deploy mid-flight."))
			else
				to_chat(user, SPAN_NOTICE("You deploy [src]."))
				deploy_sentry()
		else
			to_chat(user, SPAN_NOTICE("You retract [src]."))
			undeploy_sentry()
	else
		to_chat(user, SPAN_WARNING("[src] is unresponsive."))

/obj/structure/dropship_equipment/sentry_holder/update_equipment()
	if(ship_base)
		setDir(ship_base.dir)
		icon_state = "sentry_system_installed"
		if(deployed_turret)
			deployed_turret.setDir(dir)
			if(ship_base.base_category == DROPSHIP_WEAPON)
				switch(dir)
					if(SOUTH)
						deployed_turret.pixel_x = 0
						deployed_turret.pixel_y = 8
					if(NORTH)
						deployed_turret.pixel_x = 0
						deployed_turret.pixel_y = -8
					if(EAST)
						deployed_turret.pixel_x = -8
						deployed_turret.pixel_y = 0
					if(WEST)
						deployed_turret.pixel_x = 8
						deployed_turret.pixel_y = 0
			else
				deployed_turret.pixel_x = 0
				deployed_turret.pixel_y = 0
	else
		setDir(initial(dir))
		if(deployed_turret)
			icon_state = "sentry_system"
			deployed_turret.pixel_y = 0
			deployed_turret.pixel_x = 0
			deployed_turret.forceMove(src)
			deployed_turret.setDir(dir)
			deployed_turret.turned_on = 0
		else
			icon_state = "sentry_system_destroyed"

/obj/structure/dropship_equipment/sentry_holder/proc/deploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.turned_on = TRUE

	if(ship_base.base_category == DROPSHIP_WEAPON)
		deployed_turret.forceMove(get_step(src, dir))
	else
		deployed_turret.forceMove(src.loc)

	icon_state = "sentry_system_deployed"

	for(var/mob/M in deployed_turret.loc)
		if(deployed_turret.loc == src.loc)
			step(M, deployed_turret.dir)
		else
			step(M, get_dir(src,deployed_turret))

	deployed_turret.start_processing()
	deployed_turret.set_range()

	deployed_turret.linked_cam = new(deployed_turret.loc, "[capitalize_first_letters(ship_base.name)] [capitalize_first_letters(name)]")
	if (linked_shuttle.id == DROPSHIP_ALAMO)
		deployed_turret.linked_cam.network = list(CAMERA_NET_ALAMO)
	else if (linked_shuttle.id == DROPSHIP_NORMANDY)
		deployed_turret.linked_cam.network = list(CAMERA_NET_NORMANDY)
	else if (linked_shuttle.id == DROPSHIP_SAIPAN)
		deployed_turret.linked_cam.network = list(CAMERA_NET_SAIPAN)
	else if (linked_shuttle.id == DROPSHIP_MORANA)
		deployed_turret.linked_cam.network = list(CAMERA_NET_MORANA)
	else if (linked_shuttle.id == DROPSHIP_DEVANA)
		deployed_turret.linked_cam.network = list(CAMERA_NET_DEVANA)



/obj/structure/dropship_equipment/sentry_holder/proc/undeploy_sentry()
	if(!deployed_turret)
		return

	playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
	deployment_cooldown = world.time + 50
	deployed_turret.forceMove(src)
	deployed_turret.turned_on = FALSE
	deployed_turret.stop_processing()
	deployed_turret.unset_range()
	icon_state = "sentry_system_installed"
	QDEL_NULL(deployed_turret.linked_cam)

/obj/structure/dropship_equipment/sentry_holder/Destroy()
	if(deployed_turret)
		QDEL_NULL(deployed_turret.linked_cam)
		deployed_turret.deployment_system = null
		QDEL_NULL(deployed_turret)
	. = ..()


/// Holder for the dropship mannable machinegun system
/obj/structure/dropship_equipment/mg_holder
	name = "\improper MTU-4B Door Gunner Hardpoint System"
	desc = "A box that deploys a crew-served scoped M56D heavy machine gun. Fits on both the external weapon and crew compartment attach points of dropships. You need a powerloader to lift it."
	density = FALSE
	equip_categories = list(DROPSHIP_WEAPON, DROPSHIP_CREW_WEAPON)
	icon_state = "mg_system"
	point_cost = 50
	shorthand = "MG"
	var/deployment_cooldown
	var/obj/structure/machinery/m56d_hmg/mg_turret/dropship/deployed_mg
	combat_equipment = FALSE
	var/auto_deploy = FALSE

/obj/structure/dropship_equipment/mg_holder/Initialize()
	. = ..()
	if(!deployed_mg)
		deployed_mg = new(src)
		deployed_mg.deployment_system = src

/obj/structure/dropship_equipment/mg_holder/Destroy()
	QDEL_NULL(deployed_mg)
	. = ..()

/obj/structure/dropship_equipment/mg_holder/ui_data(mob/user)
	. = list()
	var/is_deployed = deployed_mg.loc != src
	.["name"] = name
	.["selection_state"] = list()
	.["health"] = health
	.["health_max"] = initial(health)
	.["rounds"] = deployed_mg.rounds
	.["max_rounds"] = deployed_mg.rounds_max
	.["deployed"] = is_deployed
	.["auto_deploy"] = auto_deploy

/obj/structure/dropship_equipment/mg_holder/get_examine_text(mob/user)
	. = ..()
	if(!deployed_mg)
		. += "Its machine gun is missing."

/obj/structure/dropship_equipment/mg_holder/on_launch()
	if(ship_base && ship_base.base_category == DROPSHIP_WEAPON) //only external mgs are automatically undeployed
		undeploy_mg()

/obj/structure/dropship_equipment/mg_holder/on_arrival()
	if(ship_base && auto_deploy && ship_base.base_category == DROPSHIP_WEAPON) //only external mgs are automatically deployed
		deploy_mg(null)

/obj/structure/dropship_equipment/mg_holder/attack_hand(user as mob)
	if(ship_base)
		if(deployed_mg)
			if(deployment_cooldown > world.time)
				to_chat(user, SPAN_WARNING("[src] is not ready."))
				return //prevents spamming deployment/undeployment
			if(deployed_mg.loc == src) //not deployed
				if(is_reserved_level(z) && ship_base.base_category == DROPSHIP_WEAPON)
					to_chat(user, SPAN_WARNING("[src] can't be deployed mid-flight."))
				else
					to_chat(user, SPAN_NOTICE("You pull out [deployed_mg]."))
					deploy_mg(user)
			else
				to_chat(user, SPAN_NOTICE("You stow [deployed_mg]."))
				undeploy_mg()
		else
			to_chat(user, SPAN_WARNING("[src] is empty."))
		return

	..()

/obj/structure/dropship_equipment/mg_holder/equipment_interact(mob/user)
	attack_hand(user)

/obj/structure/dropship_equipment/mg_holder/update_equipment()
	if(ship_base)
		setDir(ship_base.dir)
		icon_state = "mg_system_installed"
		if(deployed_mg)
			deployed_mg.setDir(dir)
			if(ship_base.base_category == DROPSHIP_WEAPON)
				switch(dir)
					if(NORTH)
						var/step_contents = get_step(src, EAST).contents
						if(locate(/obj/structure) in step_contents)
							deployed_mg.pixel_x = 5
						else
							deployed_mg.pixel_x = -5
					if(EAST)
						deployed_mg.pixel_y = 9
					if(WEST)
						deployed_mg.pixel_y = 9
			else
				deployed_mg.pixel_x = 0
				deployed_mg.pixel_y = 0
	else
		setDir(initial(dir))
		if(deployed_mg)
			icon_state = "mg_system"
			deployed_mg.pixel_y = 0
			deployed_mg.pixel_x = 0
			deployed_mg.forceMove(src)
			deployed_mg.setDir(dir)
		else
			icon_state = "sentry_system_destroyed"

/obj/structure/dropship_equipment/mg_holder/proc/deploy_mg(mob/user)
	if(deployed_mg)
		playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
		deployment_cooldown = world.time + 20
		if(ship_base.base_category == DROPSHIP_WEAPON)
			switch(dir)
				if(NORTH)
					var/step_contents = get_step(src, EAST).contents
					if(locate(/obj/structure) in step_contents)
						deployed_mg.forceMove(get_step(src, WEST))
					else
						deployed_mg.forceMove(get_step(src, EAST))
				if(EAST)
					deployed_mg.forceMove(get_step(src, SOUTH))
				if(WEST)
					deployed_mg.forceMove(get_step(src, SOUTH))
		else
			deployed_mg.forceMove(src.loc)
		icon_state = "mg_system_deployed"

		for(var/mob/M in deployed_mg.loc)
			if(M == user || deployed_mg.loc == src.loc)
				step( M, turn(deployed_mg.dir,180) )
			else
				step( M, get_dir(src,deployed_mg) )

/obj/structure/dropship_equipment/mg_holder/proc/undeploy_mg()
	if(deployed_mg)
		if(deployed_mg.operator)
			deployed_mg.operator.unset_interaction()
		playsound(loc, 'sound/machines/hydraulics_2.ogg', 40, 1)
		deployment_cooldown = world.time + 10
		deployed_mg.forceMove(src)
		icon_state = "mg_system_installed"


//================= FUEL EQUIPMENT =================//

/obj/structure/dropship_equipment/fuel
	icon = 'icons/obj/structures/props/dropship/dropship_equipment64.dmi'
	equip_categories = list(DROPSHIP_FUEL_EQP)


/obj/structure/dropship_equipment/fuel/update_equipment()
	if(ship_base)
		pixel_x = ship_base.pixel_x
		pixel_y = ship_base.pixel_y
		icon_state = "[initial(icon_state)]_installed"
	else
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
		bound_width = initial(bound_width)
		bound_height = initial(bound_height)
		icon_state = initial(icon_state)


/obj/structure/dropship_equipment/fuel/fuel_enhancer
	name = "\improper fuel enhancer"
	desc = "A fuel enhancement system for dropships. It improves the thrust produced by the fuel combustion for faster travels. Fits inside the engine attach points. You need a powerloader to lift it."
	icon_state = "fuel_enhancer"
	point_cost = 800

/obj/structure/dropship_equipment/fuel/cooling_system
	name = "\improper cooling system"
	desc = "A cooling system for dropships. It produces additional cooling reducing delays between launch. Fits inside the engine attach points. You need a powerloader to lift it."
	icon_state = "cooling_system"
	point_cost = 800

/obj/structure/dropship_equipment/fuel/ram_rocket
	name = "\improper TF-220/A-14 ramrocket"
	desc = "A ramrocket powered engine for dropships. It produces additional thrust during high-speed flight, allowing the dropship to operate at a wide range of speed envelopes. At low speeds though, it is extremely inefficient, leading to less overall flyby time and slower travel. Increases maximum firemission length by 4 and decreases engagement time by 50%. Fits inside the engine attach points. You need a powerloader to lift it."
	icon_state = "ram_rocket"
	bound_width = 64
	point_cost = 800


//================= ELECTRONICS =================//

/obj/structure/dropship_equipment/electronics
	equip_categories = list(DROPSHIP_ELECTRONICS)

/obj/structure/dropship_equipment/electronics/chaff_launcher
	name = "\improper AN/ALE-203 Chaff Launcher"
	icon_state = "chaff_launcher"
	point_cost = 0


/obj/structure/dropship_equipment/electronics/spotlights
	name = "\improper AN/LEN-15 Spotlight"
	shorthand = "Spotlight"
	icon_state = "spotlights"
	desc = "A set of high-powered spotlights to illuminate large areas. Fits on electronics attach points of dropships. Moving this will require a powerloader."
	is_interactable = TRUE
	point_cost = 200
	var/spotlights_cooldown
	var/brightness = 14
	var/obj/item/device/flashlight/spotlight_beam/signal_light // Track the spotlight beam object

/obj/structure/dropship_equipment/electronics/spotlights/equipment_interact(mob/user)
	if(spotlights_cooldown > world.time)
		to_chat(user, SPAN_WARNING("[src] is busy."))
		return //prevents spamming deployment/undeployment

	if(!light_on)
		turn_on_spotlight(user)
		to_chat(user, SPAN_NOTICE("You turn on [src]."))
	else
		turn_off_spotlight(user)
		to_chat(user, SPAN_NOTICE("You turn off [src]."))
	spotlights_cooldown = world.time + 50

/obj/structure/dropship_equipment/electronics/spotlights/proc/turn_on_spotlight(mob/user)
	set_light(brightness)
	icon_state = "spotlights_on"

	// If we're in flight and have a console with a camera target, also illuminate that target
	if(linked_shuttle && linked_shuttle.mode == SHUTTLE_CALL && linked_console && linked_console.camera_target_id)
		var/datum/cas_signal/target_signal = linked_console.get_cas_signal(linked_console.camera_target_id)
		if(target_signal && target_signal.valid_signal())
			create_signal_light(target_signal)

/obj/structure/dropship_equipment/electronics/spotlights/proc/turn_off_spotlight(mob/user)
	set_light(0)
	icon_state = "spotlights_off"
	clear_signal_light()

/obj/structure/dropship_equipment/electronics/spotlights/proc/create_signal_light(datum/cas_signal/signal)
	clear_signal_light() // Remove any existing light

	var/turf/target_turf = get_turf(signal.signal_loc)
	if(target_turf)
		signal_light = new /obj/item/device/flashlight/spotlight_beam(target_turf)
		signal_light.light_range = brightness
		signal_light.set_light_range(brightness)
		signal_light.set_light_on(TRUE)

/obj/structure/dropship_equipment/electronics/spotlights/proc/clear_signal_light()
	// Remove any existing spotlight light we created
	if(signal_light)
		qdel(signal_light)
		signal_light = null

/obj/structure/dropship_equipment/electronics/spotlights/update_equipment()
	..()

	// Update signal targeting when camera target changes or shuttle state changes
	if(light_on)
		if(linked_shuttle && linked_shuttle.mode == SHUTTLE_CALL && linked_console && linked_console.camera_target_id)
			var/datum/cas_signal/target_signal = linked_console.get_cas_signal(linked_console.camera_target_id)
			if(target_signal && target_signal.valid_signal())
				create_signal_light(target_signal)
			else
				clear_signal_light()
		else
			clear_signal_light()

	if(ship_base)
		if(!light_on)
			icon_state = "spotlights_off"
		else
			icon_state = "spotlights_on"
	else
		icon_state = "spotlights"
		if(light_on)
			set_light(0)
		clear_signal_light()

/obj/structure/dropship_equipment/electronics/spotlights/ui_data(mob/user)
	. = list()
	var/is_deployed = light_on
	.["name"] = name
	.["deployed"] = is_deployed

/obj/structure/dropship_equipment/electronics/spotlights/Destroy()
	clear_signal_light()
	return ..()

/obj/structure/dropship_equipment/electronics/targeting_system
	name = "\improper AN/AAQ-178 Weapon Targeting System"
	shorthand = "Targeting"
	icon_state = "targeting_system"
	desc = "A targeting system for dropships. It improves firing accuracy on laser targets. Fits on electronics attach points. You need a powerloader to lift this."
	point_cost = 800
	is_interactable = FALSE

/obj/structure/dropship_equipment/electronics/targeting_system/update_equipment()
	if(ship_base)
		icon_state = "[initial(icon_state)]_installed"
	else
		icon_state = initial(icon_state)

/obj/structure/dropship_equipment/electronics/landing_zone_detector
	name = "\improper AN/AVD-60 LZ detector"
	shorthand = "LZ Detector"
	desc = "An electronic device linked to the dropship's camera system that lets you observe your landing zone mid-flight."
	icon_state = "lz_detector"
	point_cost = 50
	var/obj/structure/machinery/computer/cameras/dropship/linked_cam_console

/obj/structure/dropship_equipment/electronics/landing_zone_detector/proc/connect_cameras() //searches for dropship_camera_console and connects with it
	if(linked_cam_console)
		return
	var/obj/structure/machinery/computer/cameras/dropship/dropship_camera_console = locate() in range(5, loc)
	linked_cam_console = dropship_camera_console
	linked_cam_console.network.Add(CAMERA_NET_LANDING_ZONES)

/obj/structure/dropship_equipment/electronics/landing_zone_detector/proc/disconnect_cameras() //clears up vars and updates users
	if(!linked_cam_console)
		return
	linked_cam_console.network.Remove(CAMERA_NET_LANDING_ZONES)
	for(var/datum/weakref/ref as anything in linked_cam_console.concurrent_users)
		var/mob/user = ref.resolve()
		if(user)
			linked_cam_console.update_static_data(user)
	linked_cam_console = null

/obj/structure/dropship_equipment/electronics/landing_zone_detector/update_equipment()
	if(ship_base)
		connect_cameras()
		icon_state = "[initial(icon_state)]_installed"
	else
		disconnect_cameras()
		icon_state = initial(icon_state)

/obj/structure/dropship_equipment/electronics/landing_zone_detector/Destroy()
	disconnect_cameras()
	return ..()

/obj/structure/dropship_equipment/electronics/targeting_designator
	name = "\improper AN/ASQ-183 Target Designation Pod"
	shorthand = "ASQ-183"
	icon_state = "laser_detector"
	desc = "A cutting edge target designation pod capable of utilizing its own laser spot tracker to further fine tune target profiling for the dropship's weapon operator. It effectively enables offsetting up to 3 paces off of a predefined target during suborbital bombardments. Fits on electronics attach points. You need a powerloader to lift this."
	point_cost = 900
	is_interactable = FALSE

/obj/structure/dropship_equipment/electronics/targeting_designator/update_equipment()
	if(ship_base)
		icon_state = "[initial(icon_state)]_installed"
	else
		icon_state = initial(icon_state)

/obj/structure/dropship_equipment/electronics/vertical_exhaust_nozzle
	name = "\improper TF-107/B-01 Vertical Exhaust Nozzle"
	shorthand = "TF-107"
	icon_state = "vertical_nozzle"
	desc = "A dynamic exhaust nozzle for VTOL capable dropships. This one fits near the cockpit, ducting air forward through the nozzle for aid in hovering operations. During high speed flight, vertical lift from the TF-107 and stern nozzles are bled in to prevent stall, allowing higher top speeds during firemissions. Increases execution speed of firemissions by 33%. Fits on electronics attach points. You need a powerloader to lift this."
	point_cost = 800
	is_interactable = FALSE

/obj/structure/dropship_equipment/electronics/vertical_exhaust_nozzle/update_equipment()
	if(ship_base)
		icon_state = "[initial(icon_state)]_installed"
	else
		icon_state = initial(icon_state)

/////////////////////////////////// COMPUTERS //////////////////////////////////////

//unfinished and unused
/obj/structure/dropship_equipment/adv_comp
	equip_categories = list(DROPSHIP_COMPUTER)
	point_cost = 0

/obj/structure/dropship_equipment/adv_comp/update_equipment()
	if(ship_base)
		icon_state = "[initial(icon_state)]_installed"
	else
		icon_state = initial(icon_state)


/obj/structure/dropship_equipment/adv_comp/docking
	name = "\improper AN/AKW-222 Docking Computer"
	icon_state = "docking_comp"
	point_cost = 0


/// CAS Dropship weaponry, used for aerial bombardment
/obj/structure/dropship_equipment/weapon
	name = "abstract weapon"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment64.dmi'
	equip_categories = list(DROPSHIP_WEAPON)
	bound_width = 32
	bound_height = 64
	uses_ammo = TRUE
	is_weapon = TRUE
	screen_mode = 1
	is_interactable = TRUE
	skill_required = SKILL_PILOT_EXPERT
	/// Time last fired, for weapon firing cooldown
	var/last_fired
	var/firing_sound
	/// Delay between firing, in deciseconds
	var/firing_delay = 20
	/// True if this weapon can only be fired in Fire Missions (not Direct)
	var/fire_mission_only = FALSE

/obj/structure/dropship_equipment/weapon/update_equipment()
	if(ship_base)
		setDir(ship_base.dir)
		bound_width = 32
		bound_height = 32
	else
		setDir(initial(dir))
		bound_width = initial(bound_width)
		bound_height = initial(bound_height)
	update_icon()

/obj/structure/dropship_equipment/weapon/equipment_interact(mob/user)
	if(is_interactable)
		if(linked_console.selected_equipment == src)
			linked_console.selected_equipment = null
		else
			linked_console.selected_equipment = src

/obj/structure/dropship_equipment/weapon/get_examine_text(mob/user)
	. = ..()
	if(ammo_equipped)
		var/ammo_info = ammo_equipped.show_loaded_desc(user)
		if(ammo_info)
			. += ammo_info
	else
		. += "It's empty."



/obj/structure/dropship_equipment/weapon/proc/deplete_ammo()
	if(ammo_equipped)
		ammo_equipped.ammo_count = max(ammo_equipped.ammo_count-ammo_equipped.ammo_used_per_firing, 0)
	update_icon()

/obj/structure/dropship_equipment/weapon/proc/open_fire(obj/selected_target, mob/user = usr)
	set waitfor = 0

	if(src.fire_mission_only)
		to_chat(user, SPAN_WARNING("[src] can only be used in a fire mission!"))
		return
	//block firing if the weapon is damaged
	if(src.antiair_fire)
		to_chat(user, SPAN_WARNING("[src] is damaged and can not be fired!"))
		return

	var/offset_x = 0
	var/offset_y = 0

	if(linked_console)
		offset_x += linked_console.direct_x_offset_value
		offset_y += linked_console.direct_y_offset_value

	var/turf/target_turf = get_turf(selected_target)
	if(!target_turf)
		return
	target_turf = locate(target_turf.x + offset_x, target_turf.y + offset_y, target_turf.z)

	if(firing_sound)
		playsound(loc, firing_sound, 70, 1)
	var/obj/structure/ship_ammo/SA = ammo_equipped //necessary because we nullify ammo_equipped when firing big rockets
	var/ammo_max_inaccuracy = SA.max_inaccuracy
	var/ammo_accuracy_range = SA.accuracy_range
	var/ammo_travelling_time = SA.travelling_time //how long the rockets/bullets take to reach the ground target.
	var/ammo_warn_sound = SA.warning_sound
	var/ammo_warn_sound_volume = SA.warning_sound_volume
	deplete_ammo()
	last_fired = world.time

	// Always apply improvements for heavygun/bay
	if(istype(src, /obj/structure/dropship_equipment/weapon/heavygun/bay))
		ammo_accuracy_range = max(ammo_accuracy_range-2, 0)
		ammo_max_inaccuracy = max(ammo_max_inaccuracy -3,1)
		ammo_travelling_time = max(ammo_travelling_time - 40, 10)
	else if(linked_shuttle)
		for(var/obj/structure/dropship_equipment/electronics/targeting_system/TS in linked_shuttle.equipments)
			// Skip applying targeting system effects if the weapon is a bomb bay
			if(istype(src, /obj/structure/dropship_equipment/weapon/bomb_bay))
				continue
			ammo_accuracy_range = max(ammo_accuracy_range-2, 0) //targeting system increase accuracy and reduce travelling time.
			ammo_max_inaccuracy = max(ammo_max_inaccuracy -3, 1)
			ammo_travelling_time = max(ammo_travelling_time - 20, 10)
			break

	// Apply debuff if vertical exhaust nozzle is installed
	if(linked_shuttle && linked_shuttle.equipments && locate(/obj/structure/dropship_equipment/electronics/vertical_exhaust_nozzle) in linked_shuttle.equipments)
		ammo_accuracy_range += 3
		ammo_max_inaccuracy += 3
		ammo_travelling_time += 20

	// Pick initial impact turf and spawn overlay
	var/list/possible_turfs = RANGE_TURFS(ammo_accuracy_range, target_turf)
	var/turf/impact = pick(possible_turfs)
	var/obj/effect/overlay/temp/dropship_reticle/direct/impact_overlay = null
	if(impact)
		impact_overlay = new()
		impact_overlay.target_x = impact.x
		impact_overlay.target_y = impact.y
		impact_overlay.target_z = impact.z
		impact_overlay.reticle_image = null
		// Only show to CAS HUD users
		if(GLOB.huds[MOB_HUD_DROPSHIP])
			for(var/mob/Mob_Pilot in GLOB.huds[MOB_HUD_DROPSHIP].hudusers)
				if(Mob_Pilot)
					impact_overlay.update_visibility_for_mob(Mob_Pilot)

	msg_admin_niche("[key_name(user)] is direct-firing [SA] onto [selected_target] at ([target_turf.x],[target_turf.y],[target_turf.z]) [ADMIN_JMP(target_turf)]")
	if(ammo_travelling_time)
		var/total_seconds = max(floor(ammo_travelling_time/10),1)
		for(var/second_index in 0 to total_seconds)
			sleep(10)
			if(!selected_target || !selected_target.loc)//if laser disappeared before we reached the target,
				ammo_accuracy_range++ //accuracy decreases
				ammo_accuracy_range = min(ammo_accuracy_range, ammo_max_inaccuracy)
				// Repick impact turf and update overlay
				if(impact_overlay)
					impact_overlay.remove_from_all_clients()
					qdel(impact_overlay)
					impact_overlay = null
				possible_turfs = RANGE_TURFS(ammo_accuracy_range, target_turf)
				impact = pick(possible_turfs)
				if(impact)
					impact_overlay = new()
					impact_overlay.target_x = impact.x
					impact_overlay.target_y = impact.y
					impact_overlay.target_z = impact.z
					impact_overlay.reticle_image = null
					// Show the new overlay to CAS HUD users
					if(GLOB.huds[MOB_HUD_DROPSHIP])
						for(var/mob/Mob_Pilot in GLOB.huds[MOB_HUD_DROPSHIP].hudusers)
							if(Mob_Pilot)
								impact_overlay.update_visibility_for_mob(Mob_Pilot)
	// clamp back to maximum inaccuracy
	ammo_accuracy_range = min(ammo_accuracy_range, ammo_max_inaccuracy)


	// Add mortar travel noise and text warnings for bomb_bay
	if(istype(src, /obj/structure/dropship_equipment/weapon/bomb_bay))
		playsound(target_turf, 'sound/effects/bomb_fall.ogg', 50, 1) // Audio warning for bomb bay dropped missiles
		sleep(25)
		var/relative_dir
		for(var/mob/mob in range(15, target_turf))
			if(get_turf(mob) == target_turf)
				relative_dir = 0
			else
				relative_dir = Get_Compass_Dir(mob, target_turf)
			mob.show_message( \
				SPAN_DANGER("A BOMB IS COMING DOWN [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_VISIBLE, \
				SPAN_DANGER("YOU HEAR SOMETHING COMING DOWN [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_AUDIBLE \
			)
		sleep(25) // Sleep a bit to give a message
		for(var/mob/mob in range(10, target_turf))
			if(get_turf(mob) == target_turf)
				relative_dir = 0
			else
				relative_dir = Get_Compass_Dir(mob, target_turf)
			mob.show_message( \
				SPAN_HIGHDANGER("A BOMB IS ABOUT TO IMPACT [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_VISIBLE, \
				SPAN_HIGHDANGER("YOU HEAR SOMETHING VERY CLOSE COMING DOWN [SPAN_UNDERLINE(relative_dir ? uppertext(("TO YOUR " + dir2text(relative_dir))) : uppertext("right above you"))]!"), SHOW_MESSAGE_AUDIBLE \
			)
		sleep(10)

	if(ammo_warn_sound)
		playsound(impact, ammo_warn_sound, ammo_warn_sound_volume, 1,15)
	new /obj/effect/overlay/temp/blinking_laser (impact)
	sleep(10)
	SA.source_mob = user
	SA.detonate_on(impact, src)
	// Impact reticle overlay
	if(impact_overlay)
		impact_overlay.remove_from_all_clients()
		qdel(impact_overlay)
	return

/obj/structure/dropship_equipment/weapon/proc/open_fire_firemission(obj/selected_target, mob/user = usr)
	set waitfor = 0
	//blocks firing if the weapon is damaged
	if(src.antiair_fire)
		return

	var/turf/target_turf = get_turf(selected_target)
	if(firing_sound)
		playsound(loc, firing_sound, 70, 1)
		playsound(target_turf, firing_sound, 70, 1)
	var/obj/structure/ship_ammo/SA = ammo_equipped //necessary because we nullify ammo_equipped when firing big rockets
	var/ammo_accuracy_range = SA.accuracy_range
	// no warning sound and no travel time
	deplete_ammo()
	last_fired = world.time
	if(linked_shuttle)
		for(var/obj/structure/dropship_equipment/electronics/targeting_system/TS in linked_shuttle.equipments)
			ammo_accuracy_range = max(ammo_accuracy_range-2, 0) //targeting system increase accuracy
			break

	ammo_accuracy_range /= 2 //buff for basically pointblanking the ground

	var/list/possible_turfs = RANGE_TURFS(ammo_accuracy_range, target_turf)
	var/turf/impact = pick(possible_turfs)
	sleep(3)
	SA.source_mob = user
	SA.detonate_on(impact, src)

/obj/structure/dropship_equipment/weapon/heavygun
	name = "\improper GAU-21 30mm cannon"
	desc = "A dismounted GAU-21 'Rattler' 30mm rotary cannon. It seems to be missing its feed links and has exposed connection wires. Capable of firing 5200 rounds a minute, feared by many for its power. Earned the nickname 'Rattler' from the vibrations it would cause on dropships in its initial production run. Accepts PGU-100/PGU-105 ammo crates"
	icon_state = "30mm_cannon"
	firing_sound = 'sound/effects/gau_incockpit.ogg'
	point_cost = 400
	skill_required = SKILL_PILOT_TRAINED
	fire_mission_only = FALSE
	shorthand = "GAU"

/obj/structure/dropship_equipment/weapon/heavygun/update_icon()
	if(ammo_equipped)
		icon_state = "30mm_cannon_loaded[ammo_equipped.ammo_count?"1":"0"]"
	else
		if(ship_base)
			icon_state = "30mm_cannon_installed"
		else
			icon_state = "30mm_cannon"


/obj/structure/dropship_equipment/weapon/heavygun/bay
	buckle_lying = 0
	anchored = TRUE
	var/obj/structure/machinery/computer/dropship_weapons/personal_console = null
	var/linked_equipment = null
	name = "\improper GAU-24/B Belly Gunner Station System"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	icon_state = "gunner_bay"
	desc = "A compartment that enables a gunner station underneath the dropship operated by crew, allowing manual fire of a GAU-24/B support rotary cannon. This version fits solely on crew compartment attach points of dropships. Utilizes the same 30mm ammunition as the standard GAU-21. Fits on crew compartment attach points. You need a powerloader to lift it."
	bound_height = 32
	shorthand = "GAU-B"
	firing_delay = 10
	is_weapon = TRUE
	uses_ammo = TRUE
	fire_mission_only = FALSE
	point_cost = 500
	equip_categories = list(DROPSHIP_CREW_WEAPON)
	density = FALSE
	can_buckle = TRUE
	density = TRUE
	// Buckling support
	var/buckling_y = 0 //pixel y shift to give to the buckled mob.
	var/buckling_x = 0 //pixel x shift to give to the buckled mob.
	buckle_lying = 0
	buckling_x = 0
	buckling_y = 0

/obj/structure/dropship_equipment/weapon/heavygun/bay/update_icon()
	if(ammo_equipped)
		density = FALSE
		icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
		icon_state = "gunner_bay_loaded[ammo_equipped.ammo_count?"1":"0"]"
	else
		if(ship_base)
			density = FALSE
			icon_state = "gunner_bay_installed"
		else
			icon_state = "gunner_bay"

	// Override afterbuckle to open UI for buckled mob
/obj/structure/dropship_equipment/weapon/heavygun/bay/afterbuckle(mob/M)
	. = ..()
	playsound(src, 'sound/machines/terminal_on.ogg', 20)
	if((!personal_console || QDELETED(personal_console)) && buckled_mob == M && ishuman(M))
		var/obj/docking_port/mobile/marine_dropship/dropship = src.linked_shuttle
		personal_console = new /obj/structure/machinery/computer/dropship_weapons/belly_gun(get_turf(src))
		personal_console.icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
		personal_console.icon_state = "gunner_bay_console"
		personal_console.layer = ABOVE_MOB_LAYER
		personal_console.shuttle_tag = dropship?.id
		personal_console.name = "Belly Gunner Weapons Console"
		personal_console.selected_equipment = src
		personal_console.faction = FACTION_MARINE
		// Link the console to this specific heavygun/bay
		var/obj/structure/machinery/computer/dropship_weapons/belly_gun/belly_console = personal_console
		belly_console.linked_heavygun = src
		personal_console.minimap_type = MINIMAP_FLAG_USCM
		personal_console.pixel_y = -4
		if(personal_console.tacmap && personal_console.tacmap.map_holder)
			personal_console.camera_mapname_update(personal_console, personal_console.tacmap.map_holder.map_ref)
		personal_console.tgui_interact(M)

// Clean up console on unbuckle
/obj/structure/dropship_equipment/weapon/heavygun/bay/unbuckle()
	if(personal_console)
		// Close the UI
		if(ismob(buckled_mob))
			personal_console.ui_close(buckled_mob)
		QDEL_NULL(personal_console)
		personal_console = null
	..()


/obj/structure/dropship_equipment/weapon/rocket_pod
	name = "\improper LAU-444 Guided Missile Launcher"
	icon_state = "rocket_pod" //I want to force whoever used rocket and missile interchangeably to come back and look at this god damn mess.
	desc = "A missile pod weapon system capable of launching a single laser-guided missile. Moving this will require some sort of lifter. Accepts AGM, AIM, BLU, and GBU missile systems."
	firing_sound = 'sound/effects/rocketpod_fire.ogg'
	firing_delay = 5
	point_cost = 600
	shorthand = "MSL"

/obj/structure/dropship_equipment/weapon/rocket_pod/deplete_ammo()
	ammo_equipped = null //nothing left to empty after firing
	update_icon()

/obj/structure/dropship_equipment/weapon/rocket_pod/update_icon()
	if(ammo_equipped && ammo_equipped.ammo_count)
		icon_state = "rocket_pod_loaded[ammo_equipped.ammo_id]"
	else
		if(ship_base)
			icon_state = "rocket_pod_installed"
		else
			icon_state = "rocket_pod"


/obj/structure/dropship_equipment/weapon/minirocket_pod
	name = "\improper LAU-229 Rocket Pod"
	icon_state = "minirocket_pod"
	desc = "A rocket pod capable of launching six laser-guided mini rockets. Moving this will require some sort of lifter. Accepts the AGR-59 series of minirockets."
	firing_sound = 'sound/effects/rocketpod_fire.ogg'
	firing_delay = 10 //1 seconds
	point_cost = 600
	shorthand = "RKT"
	stackable_ammo = TRUE

/obj/structure/dropship_equipment/weapon/minirocket_pod/update_icon()
	if(ammo_equipped && ammo_equipped.ammo_count)
		var/ammo_stage = ammo_equipped.ammo_count / ammo_equipped.ammo_used_per_firing
		icon_state = "[initial(icon_state)]_loaded_[ammo_stage]"

		if (ammo_equipped.ammo_count == ammo_equipped.max_ammo_count)
			icon_state = "[initial(icon_state)]_loaded"
	else
		if(ship_base)
			icon_state = "minirocket_pod_installed"
		else
			icon_state = "minirocket_pod"

/obj/structure/dropship_equipment/weapon/minirocket_pod/deplete_ammo()
	..()
	if(ammo_equipped && !ammo_equipped.ammo_count) //fired last minirocket
		ammo_equipped = null

/obj/structure/dropship_equipment/weapon/missile_silo
	name = "\improper MK. 14 Missile Silo"
	icon_state = "missile_silo"
	desc = "A missile silo that unfurls during subsonic flight, specialized in use for low altitude ground bombardments. Can not be used for suborbital strikes. Moving this will require some sort of lifter. Accepts MK and ATM missile systems."
	firing_sound = 'sound/effects/missilesilo_fire.ogg'
	firing_delay = 5 // redundant since it can't direct fire anyways
	point_cost = 600
	shorthand = "SIL"
	fire_mission_only = TRUE
	stackable_ammo = TRUE

/obj/structure/dropship_equipment/weapon/missile_silo/deplete_ammo()
	..()
	if(ammo_equipped && !ammo_equipped.ammo_count) //fired last missile
		ammo_equipped = null

/obj/structure/dropship_equipment/weapon/missile_silo/update_icon()
	if(ammo_equipped && ammo_equipped.ammo_count)
		var/ammo_stage = ammo_equipped.ammo_count / ammo_equipped.ammo_used_per_firing
		icon_state = "missile_silo_loaded[ammo_equipped.ammo_id]_[ammo_stage]"

		if (ammo_equipped.ammo_count == ammo_equipped.max_ammo_count)
			icon_state = "missile_silo_loaded[ammo_equipped.ammo_id]"
	else
		if(ship_base)
			icon_state = "missile_silo_installed"
		else
			icon_state = "missile_silo"

/obj/structure/dropship_equipment/weapon/laser_beam_gun
	name = "\improper LWU-6B Laser Cannon"
	icon_state = "laser_beam"
	desc = "State of the art technology recently acquired by the USCM, it fires a battery-fed pulsed laser beam at near lightspeed setting on fire everything it touches. Moving this will require some sort of lifter. Accepts the BTU-17/LW Hi-Cap Laser Batteries."
	firing_sound = 'sound/effects/phasein.ogg'
	firing_delay = 50 //5 seconds
	point_cost = 500
	skill_required = SKILL_PILOT_TRAINED
	fire_mission_only = FALSE
	shorthand = "LZR"

/obj/structure/dropship_equipment/weapon/laser_beam_gun/update_icon()
	if(ammo_equipped && ammo_equipped.ammo_count)
		icon_state = "laser_beam_loaded"
	else
		if(ship_base)
			icon_state = "laser_beam_installed"
		else
			icon_state = "laser_beam"

/obj/structure/dropship_equipment/weapon/launch_bay
	name = "\improper LAG-14 Internal Sentry Launcher"
	icon_state = "launch_bay"
	desc = "A launch bay to drop special ordnance. Fits inside the dropship's crew weapon emplacement. Moving this will require some sort of lifter. Accepts the A/C-49-P Air Deployable Sentry as ammunition."
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	firing_sound = 'sound/weapons/gun_flare_explode.ogg'
	firing_delay = 10 //1 seconds
	bound_height = 32
	equip_categories = list(DROPSHIP_CREW_WEAPON) //fits inside the central spot of the dropship
	point_cost = 200
	fire_mission_only = FALSE
	shorthand = "LCH"

/obj/structure/dropship_equipment/weapon/launch_bay/update_equipment()
	if(ship_base)
		icon_state = "launch_bay_deployed"
	else
		icon_state = "launch_bay"

/obj/structure/dropship_equipment/weapon/flare_launcher
	name = "\improper AN/ALE-557 Flare Launcher"
	desc = "A flare launcher that usually gets mounted onto dropships to help survivability against infrared tracking missiles. This one has been tweaked to allow battlefield illumination capabilities. Fits on electronics attach points. Moving this will require some sort of lifter."
	icon_state = "flare_launcher"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	bound_height = 32
	firing_sound = 'sound/weapons/gun_flare_explode.ogg'
	firing_delay = 20
	fire_mission_only = FALSE
	shorthand = "FLR"
	uses_ammo = TRUE
	is_interactable = TRUE
	combat_equipment = TRUE
	stackable_ammo = TRUE
	equip_categories = list(DROPSHIP_ELECTRONICS) //fits inside the front parts next to the weapons
	point_cost = 250

/obj/structure/dropship_equipment/weapon/flare_launcher/update_icon()
	if(ammo_equipped && ammo_equipped.ammo_count)
		if(ship_base)
			var/percent = ammo_equipped.ammo_count / ammo_equipped.max_ammo_count
			if(percent > 0.5)
				icon_state = "flare_launcher_installed1"
			else
				icon_state = "flare_launcher_installed2"
		else
			icon_state = "flare_launcher"
	else
		if(ship_base)
			icon_state = "flare_launcher_installed"
		else
			icon_state = "flare_launcher"

/obj/structure/dropship_equipment/weapon/bomb_bay
	name = "\improper LAB-107 Bomb Bay"
	desc = "A bomb bay capable of dropping unguided munitions by utilizing ejector racks. Ordinance released from these bomb cradles are capable of penetrating fortified bunkers, leading to it being commonly employed against CLF hideouts. Munitions must be manually locked into place after loading. Fits inside the dropship's crew weapon emplacement. Moving this will require some sort of lifter. Accepts select AGM and AIM missile systems."
	icon_state = "bomb_bay"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	firing_sound = 'sound/effects/rocketpod_fire.ogg'
	firing_delay = 1800 // 3 minutes
	bound_height = 32
	equip_categories = list(DROPSHIP_CREW_WEAPON) // fits inside the central spot of the dropship
	point_cost = 500
	fire_mission_only = FALSE
	shorthand = "BMB"
	uses_ammo = TRUE
	is_weapon = TRUE
	density = TRUE
	var/locked_ammo = FALSE // Tracks whether the ammo is locked in place

/obj/structure/dropship_equipment/weapon/bomb_bay/update_equipment()
	if(ship_base)
		icon = 'icons/obj/structures/props/dropship/dropship_equipment64.dmi' // installed state uses 64.dmi
		icon_state = "bomb_bay_installed"
		bound_height = 64
		density = FALSE // Only not dense when installed
	else
		icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi' // base state uses base dmi
		icon_state = "bomb_bay"
		bound_height = 32
		density = TRUE // Dense when not installed
	update_icon()

/obj/structure/dropship_equipment/weapon/bomb_bay/update_icon()
	if(!ship_base)
		return // Don't update icon when not installed

	if(!ammo_equipped)
		// No ammo equipped - use installed state
		icon_state = "bomb_bay_installed"
		return

	// Check if bomb has 0 ammo count first
	if(ammo_equipped.ammo_count <= 0)
		icon_state = "bomb_bay_loaded0"
		return

	if(locked_ammo)
		// Locked ammo - use locked state based on ammo_id
		var/ammo_id = ammo_equipped.ammo_id
		icon_state = "bomb_bay_locked[ammo_id]"
		return

	// Use the ammo_id to determine the loaded icon state
	var/ammo_id = ammo_equipped.ammo_id
	icon_state = "bomb_bay_loaded[ammo_id]"

	// Use attack_hand to lock the ammo
/obj/structure/dropship_equipment/weapon/bomb_bay/attack_hand(mob/user)
	if(!ammo_equipped)
		to_chat(user, SPAN_WARNING("[src] has no ammo loaded to lock in place."))
		return
	if(locked_ammo)
		to_chat(user, SPAN_NOTICE("[src]'s ammo is already locked in place."))
		return
	if(user.action_busy)
		to_chat(user, SPAN_WARNING("You are already performing an action."))
		return
	if(!skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
		to_chat(user, SPAN_WARNING("You don't have the necessary skills to lock the ammo in place for [src]."))
		return

	to_chat(user, SPAN_NOTICE("You begin locking the ammo in place for [src]."))
	if(!do_after(user, 20, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, target = src))
		to_chat(user, SPAN_WARNING("You stop locking the ammo in place for [src]."))
		return

	playsound(user, 'sound/machines/lockenable.ogg', 50, 1)
	locked_ammo = TRUE
	to_chat(user, SPAN_NOTICE("You successfully lock the ammo in place for [src]."))
	update_icon()

// Override the open_fire proc to check if ammo is locked
/obj/structure/dropship_equipment/weapon/bomb_bay/open_fire(obj/selected_target, mob/user = usr)
	if(!locked_ammo)
		to_chat(user, SPAN_WARNING("[src]'s ammo is not locked in place and cannot be fired."))
		return
	..()

// Reset locked_ammo when ammo is loaded
/obj/structure/dropship_equipment/weapon/bomb_bay/load_ammo(obj/item/powerloader_clamp/PC, mob/living/user)
	..()
	if(ammo_equipped) // If ammo was successfully loaded
		locked_ammo = FALSE // Reset the locked state
		update_icon()

// Reset locked_ammo when ammo is unloaded
/obj/structure/dropship_equipment/weapon/bomb_bay/unload_ammo(obj/item/powerloader_clamp/PC, mob/living/user)
	locked_ammo = FALSE // Reset the locked state
	..()
	update_icon()

//================= OTHER EQUIPMENT =================//



/obj/structure/dropship_equipment/medevac_system
	name = "\improper RMU-4M Medevac System"
	shorthand = "Medevac"
	desc = "A winch system to lift injured marines on medical stretchers onto the dropship. Acquire lift target through the dropship equipment console."
	equip_categories = list(DROPSHIP_CREW_WEAPON)
	icon_state = "medevac_system"
	point_cost = 300
	is_interactable = TRUE
	var/obj/structure/bed/medevac_stretcher/linked_stretcher
	var/medevac_cooldown
	var/busy_winch
	combat_equipment = FALSE
	faction_exclusive = FACTION_MARINE

/obj/structure/dropship_equipment/medevac_system/upp
	name = "\improper RMU-4M Medevac System UPP"
	faction_exclusive = FACTION_UPP

/obj/structure/dropship_equipment/medevac_system/Destroy()
	if(linked_stretcher)
		linked_stretcher.linked_medevac = null
		linked_stretcher = null
	. = ..()

/obj/structure/dropship_equipment/medevac_system/update_equipment()
	if(ship_base)
		icon_state = "medevac_system_deployed"
	else
		if(linked_stretcher)
			linked_stretcher.linked_medevac = null
			linked_stretcher = null
		icon_state = "medevac_system"

/obj/structure/dropship_equipment/medevac_system/proc/get_targets()
	. = list()

	for(var/obj/structure/bed/medevac_stretcher/MS in GLOB.activated_medevac_stretchers)
		if(MS.faction != faction_exclusive)
			continue
		var/area/AR = get_area(MS)
		var/evaccee_name
		var/evaccee_triagecard_color
		if(MS.buckled_mob)
			evaccee_name = MS.buckled_mob.real_name
			if (ishuman(MS.buckled_mob))
				var/mob/living/carbon/human/H = MS.buckled_mob
				evaccee_triagecard_color = H.holo_card_color
		else if(MS.buckled_bodybag)
			for(var/atom/movable/AM in MS.buckled_bodybag)
				if(isliving(AM))
					var/mob/living/L = AM
					evaccee_name = "[MS.buckled_bodybag.name]: [L.real_name]"
					if (ishuman(L))
						var/mob/living/carbon/human/H = L
						evaccee_triagecard_color = H.holo_card_color
					break
			if(!evaccee_name)
				evaccee_name = "Empty [MS.buckled_bodybag.name]"
		else
			evaccee_name = "Empty"

		if (evaccee_triagecard_color && evaccee_triagecard_color == "none")
			evaccee_triagecard_color = null

		var/key_name = strip_improper("[evaccee_name] [evaccee_triagecard_color ? "\[" + uppertext(evaccee_triagecard_color) + "\]" : ""] ([AR.name])")
		.[key_name] = MS

/obj/structure/dropship_equipment/medevac_system/proc/can_medevac(mob/user)
	if(!linked_shuttle)
		return FALSE

	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("[src] can only be used while in flight."))
		return FALSE

	if(busy_winch)
		to_chat(user, SPAN_WARNING("The winch is already in motion."))
		return FALSE

	if(world.time < medevac_cooldown)
		to_chat(user, SPAN_WARNING("[src] was just used, you need to wait a bit before using it again."))
		return FALSE

	var/list/possible_stretchers = get_targets()

	if(!length(possible_stretchers))
		to_chat(user, SPAN_WARNING("No active medevac stretcher detected."))
		return FALSE
	return TRUE

/obj/structure/dropship_equipment/medevac_system/proc/position_dropship(mob/user, obj/structure/bed/medevac_stretcher/selected_stretcher)
	if(!ship_base) //system was uninstalled midway
		return

	if(!selected_stretcher.stretcher_activated)//stretcher beacon was deactivated midway
		return

	if(!is_ground_level(selected_stretcher.z)) //in case the stretcher was on a groundside dropship that flew away during our input()
		return

	if(!selected_stretcher.buckled_mob && !selected_stretcher.buckled_bodybag)
		to_chat(user, SPAN_WARNING("This medevac stretcher is empty."))
		return

	if(selected_stretcher.linked_medevac && selected_stretcher.linked_medevac != src)
		to_chat(user, SPAN_WARNING("There's another dropship hovering over that medevac stretcher."))
		return

	if(!linked_shuttle)
		return

	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("[src] can only be used while in flight."))
		return

	if(busy_winch)
		to_chat(user, SPAN_WARNING(" The winch is already in motion."))
		return

	if(world.time < medevac_cooldown)
		to_chat(user, SPAN_WARNING("[src] was just used, you need to wait a bit before using it again."))
		return

	if(selected_stretcher == linked_stretcher) //already linked to us, unlink it
		to_chat(user, SPAN_NOTICE(" You move your dropship away from that stretcher's beacon."))
		linked_stretcher.visible_message(SPAN_NOTICE("[linked_stretcher] detects a dropship is no longer overhead."))
		linked_stretcher.linked_medevac = null
		linked_stretcher = null
		return

	to_chat(user, SPAN_NOTICE("You move your dropship above the selected stretcher's beacon. You can now manually activate the medevac system to hoist the patient up."))

	if(linked_stretcher)
		linked_stretcher.linked_medevac = null
		linked_stretcher.visible_message(SPAN_NOTICE("[linked_stretcher] detects a dropship is no longer overhead."))

	linked_stretcher = selected_stretcher
	linked_stretcher.linked_medevac = src
	linked_stretcher.visible_message(SPAN_NOTICE("[linked_stretcher] detects a dropship overhead."))

/obj/structure/dropship_equipment/medevac_system/proc/automate_interact(mob/user, stretcher_choice)
	if(!can_medevac(user))
		return

	var/list/possible_stretchers = get_targets()

	var/obj/structure/bed/medevac_stretcher/selected_stretcher = possible_stretchers[stretcher_choice]
	if(!selected_stretcher)
		return
	position_dropship(user, selected_stretcher)

/obj/structure/dropship_equipment/medevac_system/equipment_interact(mob/user)
	if(!can_medevac(user))
		return

	var/list/possible_stretchers = get_targets()

	var/stretcher_choice = tgui_input_list(usr, "Which emitting stretcher would you like to link with?", "Available stretchers", possible_stretchers)
	if(!stretcher_choice)
		return

	var/obj/structure/bed/medevac_stretcher/selected_stretcher = possible_stretchers[stretcher_choice]
	if(!selected_stretcher)
		return
	position_dropship(user, selected_stretcher)


//on arrival we break any link
/obj/structure/dropship_equipment/medevac_system/on_arrival()
	if(linked_stretcher)
		linked_stretcher.linked_medevac = null
		linked_stretcher = null


/obj/structure/dropship_equipment/medevac_system/attack_hand(mob/user)
	if(!ishuman(user))
		return
	if(!ship_base) //not installed
		return
	if(!skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED) && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_DOCTOR))
		to_chat(user, SPAN_WARNING(" You don't know how to use [src]."))
		return

	if(!linked_shuttle)
		return

	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("[src] can only be used while in flight."))
		return

	if(busy_winch)
		to_chat(user, SPAN_WARNING(" The winch is already in motion."))
		return

	if(!linked_stretcher)
		equipment_interact(user)
		return

	if(!is_ground_level(linked_stretcher.z))
		linked_stretcher.linked_medevac = null
		linked_stretcher = null
		to_chat(user, SPAN_WARNING(" There seems to be no medevac stretcher connected to [src]."))
		return

	if(world.time < medevac_cooldown)
		to_chat(user, SPAN_WARNING("[src] was just used, you need to wait a bit before using it again."))
		return

	activate_winch(user)

/obj/structure/dropship_equipment/medevac_system/ui_data(mob/user)
	var/list/stretchers = get_targets()

	. = list()
	for(var/stretcher_ref in stretchers)
		var/obj/structure/bed/medevac_stretcher/stretcher = stretchers[stretcher_ref]

		var/area/AR = get_area(stretcher)
		var/list/target_data = list()
		target_data["area"] = AR
		target_data["ref"] = stretcher_ref

		var/mob/living/carbon/human/occupant = stretcher.buckled_mob
		var/obj/structure/closet/bodybag/cryobag = stretcher.buckled_bodybag
		if(!occupant && cryobag)
			occupant = locate(/mob/living/carbon/human) in cryobag
			target_data["occupant"] = "(Empty stasis bag)"
		if(occupant)
			if(cryobag)
				target_data["occupant"] = "(Stasis bag) " + occupant.name
			else
				target_data["occupant"] = occupant.name
			target_data["time_of_death"] = occupant.tod
			target_data["damage"] = list(
				"hp" = occupant.health,
				"brute" = occupant.bruteloss,
				"oxy" = occupant.oxyloss,
				"tox" = occupant.toxloss,
				"fire" = occupant.fireloss
			)
			if(ishuman(occupant))
				target_data["damage"]["undefib"] = occupant.undefibbable
				target_data["triage_card"] = occupant.holo_card_color

		. += list(target_data)

/obj/structure/dropship_equipment/medevac_system/proc/activate_winch(mob/user)
	set waitfor = 0
	var/old_stretcher = linked_stretcher
	busy_winch = TRUE
	playsound(loc, 'sound/machines/medevac_extend.ogg', 40, 1)
	flick("medevac_system_active", src)
	user.visible_message(SPAN_NOTICE("[user] activates [src]'s winch."),
						SPAN_NOTICE("You activate [src]'s winch."))
	sleep(30)

	busy_winch = FALSE
	var/fail
	if(!linked_stretcher || linked_stretcher != old_stretcher || !is_ground_level(linked_stretcher.z))
		fail = TRUE

	else if(!ship_base) //uninstalled midway
		fail = TRUE

	else if(!linked_shuttle || linked_shuttle.mode != SHUTTLE_CALL)
		fail = TRUE

	if(fail)
		if(linked_stretcher)
			linked_stretcher.linked_medevac = null
			linked_stretcher = null
		to_chat(user, SPAN_WARNING("The winch finishes lifting but there seems to be no medevac stretchers connected to [src]."))
		return

	var/atom/movable/lifted_object
	if(linked_stretcher.buckled_mob)
		lifted_object = linked_stretcher.buckled_mob
	else if(linked_stretcher.buckled_bodybag)
		lifted_object = linked_stretcher.buckled_bodybag

	if(lifted_object)
		var/turf/T = get_turf(lifted_object)
		T.ceiling_debris_check(2)
		var/old_area = get_area(lifted_object)
		lifted_object.forceMove(loc)
		var/new_area = get_area(lifted_object)
		// Update HUD for marines moved from ground to dropship
		if(ismob(lifted_object))
			update_dropship_hud_on_move(lifted_object, old_area, new_area)
	else
		to_chat(user, SPAN_WARNING("The winch finishes lifting the medevac stretcher but it's empty!"))
		linked_stretcher.linked_medevac = null
		linked_stretcher = null
		return

	flick("winched_stretcher", linked_stretcher)
	linked_stretcher.visible_message(SPAN_NOTICE("A winch hook falls from the sky and starts lifting [linked_stretcher] up."))

	medevac_cooldown = world.time + DROPSHIP_MEDEVAC_COOLDOWN
	linked_stretcher.linked_medevac = null
	linked_stretcher = null

// Fulton extraction system

/obj/structure/dropship_equipment/fulton_system
	name = "\improper RMU-19 Fulton Recovery System"
	shorthand = "Fulton"
	desc = "A winch system to collect any fulton recovery balloons in high altitude. Make sure you turn it on!"
	equip_categories = list(DROPSHIP_CREW_WEAPON)
	icon_state = "fulton_system"
	point_cost = 200
	is_interactable = TRUE
	var/fulton_cooldown
	var/busy_winch
	combat_equipment = FALSE
	faction_exclusive = FACTION_MARINE

/obj/structure/dropship_equipment/fulton_system/upp
	name = "\improper UPP RMU-19 Fulton Recovery System"
	faction_exclusive = FACTION_UPP

/obj/structure/dropship_equipment/fulton_system/update_equipment()
	if(ship_base)
		icon_state = "fulton_system_deployed"
	else
		icon_state = "fulton_system"


/obj/structure/dropship_equipment/fulton_system/proc/automate_interact(mob/user, fulton_choice)
	if(!can_fulton(user))
		return

	var/list/possible_fultons = get_targets()

	if(!fulton_choice)
		return
	// Strip any \proper or \improper in order to match the entry in possible_fultons.
	fulton_choice = strip_improper(fulton_choice)
	var/obj/item/stack/fulton/fult = possible_fultons[fulton_choice]

	if(!ship_base) //system was uninstalled midway
		return

	if(is_ground_level(fult.z)) //in case the fulton popped during our input()
		return

	if(!fult.attached_atom)
		to_chat(user, SPAN_WARNING("This balloon stretcher is empty."))
		return

	if(!linked_shuttle)
		return

	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("[src] can only be used while in flight."))
		return

	if(busy_winch)
		to_chat(user, SPAN_WARNING(" The winch is already in motion."))
		return

	if(world.time < fulton_cooldown)
		to_chat(user, SPAN_WARNING("[src] was just used, you need to wait a bit before using it again."))
		return

	to_chat(user, SPAN_NOTICE(" You move your dropship above the selected balloon's beacon."))

	activate_winch(user, fult)


/obj/structure/dropship_equipment/fulton_system/proc/can_fulton(mob/user)
	if(!linked_shuttle)
		return FALSE

	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("[src] can only be used while in flight."))
		return FALSE

	if(busy_winch)
		to_chat(user, SPAN_WARNING(" The winch is already in motion."))
		return FALSE

	if(world.time < fulton_cooldown)
		to_chat(user, SPAN_WARNING("[src] was just used, you need to wait a bit before using it again."))
		return FALSE
	return TRUE

/obj/structure/dropship_equipment/fulton_system/ui_data(mob/user)
	var/list/targets = get_targets()
	. = list()
	for(var/target_entry in targets)
		. += list(target_entry)


/obj/structure/dropship_equipment/fulton_system/proc/get_targets()
	. = list()
	for(var/obj/item/stack/fulton/fulton in GLOB.deployed_fultons)
		if(faction_exclusive != fulton.faction)
			continue
		var/recovery_object
		if(fulton.attached_atom)
			recovery_object = fulton.attached_atom.name
		else
			recovery_object = "Empty"
		.["[recovery_object]"] = fulton

/obj/structure/dropship_equipment/fulton_system/equipment_interact(mob/user)
	if(!can_fulton(user))
		return

	var/list/possible_fultons = get_targets()

	if(!length(possible_fultons))
		to_chat(user, SPAN_WARNING("No active balloons detected."))
		return

	var/fulton_choice = tgui_input_list(usr, "Which balloon would you like to link with?", "Available balloons", possible_fultons)
	if(!fulton_choice)
		return

	var/obj/item/stack/fulton/fulton = possible_fultons[fulton_choice]
	if(!fulton_choice)
		return

	if(!ship_base) //system was uninstalled midway
		return

	if(is_ground_level(fulton.z)) //in case the fulton popped during our input()
		return

	if(!fulton.attached_atom)
		to_chat(user, SPAN_WARNING("This balloon stretcher is empty."))
		return

	if(!linked_shuttle)
		return

	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("[src] can only be used while in flight."))
		return

	if(busy_winch)
		to_chat(user, SPAN_WARNING(" The winch is already in motion."))
		return

	if(world.time < fulton_cooldown)
		to_chat(user, SPAN_WARNING("[src] was just used, you need to wait a bit before using it again."))
		return

	to_chat(user, SPAN_NOTICE(" You move your dropship above the selected balloon's beacon."))

	activate_winch(user, fulton)

/obj/structure/dropship_equipment/fulton_system/proc/activate_winch(mob/user, obj/item/stack/fulton/linked_fulton)
	set waitfor = 0
	busy_winch = TRUE
	playsound(loc, 'sound/machines/medevac_extend.ogg', 40, 1)
	flick("fulton_system_active", src)
	user.visible_message(SPAN_NOTICE("[user] activates [src]'s winch."),
						SPAN_NOTICE("You activate [src]'s winch."))
	sleep(30)

	busy_winch = FALSE
	var/fail
	if(!linked_fulton || is_ground_level(linked_fulton.z))
		fail = TRUE

	else if(!ship_base) //uninstalled midway
		fail = TRUE

	else if(!linked_shuttle || linked_shuttle.mode != SHUTTLE_CALL)
		fail = TRUE

	if(fail)
		to_chat(user, SPAN_WARNING("The winch finishes lifting but there seems to be no balloon connected to [src]."))
		return

	if(linked_fulton.attached_atom)
		linked_fulton.return_fulton(get_turf(src))
	else
		to_chat(user, SPAN_WARNING("The winch finishes lifting the medevac stretcher but it's empty!"))
		return

	fulton_cooldown = world.time + 50

// Rappel deployment system
/obj/structure/dropship_equipment/rappel_system
	name = "\improper HRU-3 Rappel Deployment System"
	shorthand = "RDS"
	equip_categories = list(DROPSHIP_CREW_WEAPON)
	icon_state = "rappel_module_packaged"
	point_cost = 150
	combat_equipment = FALSE
	var/harness = /obj/item/rappel_harness
	var/obj/effect/rappel_rope/hatch_rope = null
	var/list/ground_ropes = list()
	var/rope_in_use = FALSE
	var/locked_target = null
	var/view = null
	var/system_cooldown
	var/manual_cancel_cooldown = 0
	var/manual_deploy_cooldown = 0
	var/datum/cas_signal/last_deployed_target = null

/obj/structure/dropship_equipment/rappel_system/Destroy()
	cleanup_ropes(FALSE) // Clean up all deployed ropes without animation when system is destroyed
	. = ..()

/obj/structure/dropship_equipment/rappel_system/update_equipment()
	if(ship_base)
		icon_state = "rappel_hatch_closed"
		density = FALSE
	else
		icon_state = "rappel_module_packaged"

/obj/structure/dropship_equipment/rappel_system/proc/create_ropes(hatch_turf, deploy_turf)
	if(hatch_rope)
		qdel(hatch_rope)

	hatch_rope = new /obj/effect/rappel_rope(hatch_turf, TRUE)
	hatch_rope.linked_rappel = src

	// Find up to 4 unique valid turfs around deploy_turf
	var/turf/center_turf = get_turf(deploy_turf)
	if(!center_turf)
		return
	var/list/valid_turfs = list()
	var/list/possible_turfs = block(center_turf.x-2, center_turf.y-2, center_turf.z, center_turf.x+2, center_turf.y+2, center_turf.z)
	for(var/atom/possible_turf in possible_turfs)
		if(!istype(possible_turf, /turf))
			continue
		var/turf/current_turf = possible_turf
		var/area/current_area = get_area(current_turf)
		if(!current_area || CEILING_IS_PROTECTED(current_area.ceiling, CEILING_PROTECTION_TIER_1))
			continue
		if(current_turf.density)
			continue
		var/has_dense_object = FALSE
		for(var/atom/content in current_turf.contents)
			if(istype(content, /obj))
				var/obj/object_in_turf = content
				if(object_in_turf.density && object_in_turf.can_block_movement)
					has_dense_object = TRUE
					break
			else if(istype(content, /mob))
				var/mob/mob_in_turf = content
				if(mob_in_turf.density && mob_in_turf.can_block_movement)
					has_dense_object = TRUE
					break
		if(has_dense_object)
			continue
		if(protected_by_pylon(TURF_PROTECTION_MORTAR, current_turf))
			continue
		valid_turfs += current_turf

	// Pick up to 4 unique turfs for ropes
	if(ground_ropes)
		ground_ropes.Cut()
	ground_ropes = list()
	for(var/rope_index = 1 to min(4, length(valid_turfs)))
		var/turf/rope_turf = pick(valid_turfs)
		valid_turfs -= rope_turf
		var/obj/effect/rappel_rope/new_rope = new /obj/effect/rappel_rope(rope_turf, FALSE)
		new_rope.linked_rappel = src
		ground_ropes += new_rope

/obj/structure/dropship_equipment/rappel_system/proc/set_icon_state(state)
	icon_state = state

/obj/structure/dropship_equipment/rappel_system/proc/retract_ropes()
	if(hatch_rope)
		qdel(hatch_rope)
		hatch_rope = null
	if(ground_ropes && length(ground_ropes))
		for(var/obj/effect/rappel_rope/R in ground_ropes)
			qdel(R)
		ground_ropes.Cut()
	rope_in_use = FALSE

/obj/structure/dropship_equipment/rappel_system/proc/descend_rope(mob/living/carbon/human/user, obj/effect/rappel_rope/rope)
	if(rope_in_use)
		to_chat(user, SPAN_WARNING("The rope is currently in use!"))
		return
	if(!ground_ropes || !length(ground_ropes))
		to_chat(user, SPAN_WARNING("The rope is not properly deployed!"))
		return
	rope_in_use = TRUE
	rope.icon_state = "rope_inuse"
	to_chat(user, SPAN_NOTICE("You begin rappelling down the rope..."))
	var/old_area = get_area(user)
	sleep(40)
	user.forceMove(rope.loc)
	var/new_area = get_area(user)
	update_dropship_hud_on_move(user, old_area, new_area)
	rope.release_rope()
	rope_in_use = FALSE

/obj/structure/dropship_equipment/rappel_system/proc/ascend_rope(mob/living/carbon/human/user, obj/effect/rappel_rope/rope)
	if(rope_in_use)
		to_chat(user, SPAN_WARNING("The rope is currently in use!"))
		return
	if(!hatch_rope || !hatch_rope.loc)
		to_chat(user, SPAN_WARNING("The rope is not properly deployed!"))
		return
	rope_in_use = TRUE
	rope.icon_state = "rope_inuse"
	to_chat(user, SPAN_NOTICE("You begin climbing up the rope..."))
	var/old_area = get_area(user)
	sleep(40)
	user.forceMove(hatch_rope.loc)
	var/new_area = get_area(user)
	update_dropship_hud_on_move(user, old_area, new_area)
	rope.release_rope()
	rope_in_use = FALSE

/obj/structure/dropship_equipment/rappel_system/proc/spawn_rappel_warning(turf/target)
	if(!target) return
	var/obj/effect/warning/rappel/warn = new /obj/effect/warning/rappel(target)
	spawn(20)
		if(warn) qdel(warn)

/obj/structure/dropship_equipment/rappel_system/attack_hand(mob/living/carbon/human/user)
	if(world.time < manual_deploy_cooldown)
		to_chat(user, SPAN_WARNING("You must wait before deploying the rappel again!"))
		return
	if(!can_lock_rappel())
		to_chat(user, SPAN_WARNING("Rappel system is not ready to deploy."))
		return
	var/datum/cas_signal/sig = locked_target
	if(!sig)
		to_chat(user, SPAN_WARNING("No rappel target locked."))
		return
	if(last_deployed_target == sig)
		to_chat(user, SPAN_WARNING("Rappel is already deployed to this target."))
		return
	var/turf/location = get_turf(sig.signal_loc)
	var/area/location_area = get_area(location)
	if(CEILING_IS_PROTECTED(location_area.ceiling, CEILING_PROTECTION_TIER_1))
		to_chat(user, SPAN_WARNING("You cannot jump to the target. It is probably underground."))
		return
	var/list/valid_turfs = list()
	for(var/turf/possible_turf as anything in RANGE_TURFS(2, location))
		var/area/possible_area = get_area(possible_turf)
		if(!possible_area || CEILING_IS_PROTECTED(possible_area.ceiling, CEILING_PROTECTION_TIER_1))
			continue
		if(possible_turf.density)
			continue
		var/found_dense = FALSE
		for(var/atom/contained_atom in possible_turf)
			if(contained_atom.density && contained_atom.can_block_movement)
				found_dense = TRUE
				break
		if(found_dense)
			continue
		if(protected_by_pylon(TURF_PROTECTION_MORTAR, possible_turf))
			continue
		valid_turfs += possible_turf
	if(!length(valid_turfs))
		to_chat(user, SPAN_WARNING("There's nowhere safe for you to land, the landing zone is too congested."))
		return
	var/turf/deploy_turf = pick(valid_turfs)
	spawn_rappel_warning(deploy_turf)
	cleanup_ropes(FALSE)
	playsound(src, 'sound/machines/elevator_openclose.ogg', 50, 1)
	flick("rappel_hatch_opening", src)
	visible_message(SPAN_NOTICE("[src] flashes green as it locks to a signal."))
	icon_state = "rappel_hatch_open"
	spawn(17)
		var/turf/target_turf = get_turf(deploy_turf)
		if(target_turf)
			create_ropes(loc, target_turf)
			last_deployed_target = sig
			system_cooldown = world.time + 5 SECONDS  // Set cooldown when rappel is actually deployed
	manual_cancel_cooldown = world.time + 6 SECONDS
	return

/obj/effect/warning/rappel
	color = "#cf7a1e"

/obj/structure/dropship_equipment/rappel_system/proc/can_lock_rappel(mob/user)
	if(linked_shuttle.mode != SHUTTLE_CALL)
		to_chat(user, SPAN_WARNING("\The [src] can only be used while in flight."))
		return FALSE

	if(!linked_shuttle.in_flyby)
		to_chat(user, SPAN_WARNING("\The [src] requires a flyby flight to be used."))
		return FALSE
	return TURF_LAYER

/obj/structure/dropship_equipment/rappel_system/proc/can_use_rappel(mob/living/carbon/human/user)
	if(user.buckled)
		to_chat(user, SPAN_WARNING("You cannot rappel while buckled!"))
		return FALSE

	if(user.is_mob_incapacitated())
		to_chat(user, SPAN_WARNING("You are in no state to do that!"))
		return FALSE

	if(!istype(user.belt, harness))
		to_chat(user, SPAN_WARNING("You must have a rappel harness equipped in order to use \the [src]!"))
		return FALSE

	if(user.action_busy)
		return FALSE

	return TRUE

/obj/structure/dropship_equipment/rappel_system/proc/cleanup_ropes(animated = TRUE)
	if(hatch_rope)
		if(animated)
			playsound(src, 'sound/machines/door_close.ogg', 50, 1)
			flick("rappel_hatch_closing", src)
		qdel(hatch_rope)
		hatch_rope = null
	if(length(ground_ropes))
		for(var/obj/effect/rappel_rope/Ropes in ground_ropes)
			qdel(Ropes)
		ground_ropes.Cut()
	if(animated)
		icon_state = "rappel_hatch_closed"

/obj/structure/dropship_equipment/rappel_system/ui_data(mob/user)
	var/list/data = list()
	if(locked_target && istype(locked_target, /datum/cas_signal))
		var/datum/cas_signal/signal = locked_target
		var/area/target_area = get_area(signal.signal_loc)
		data["locked_target"] = list(
			"target_name" = signal.name,
			"target_tag" = signal.target_id,
			"area_name" = target_area ? target_area.name : "Unknown Area"
		)
	else
		data["locked_target"] = null
	return data

/obj/structure/dropship_equipment/rappel_system/on_arrival()
	..()
	cleanup_ropes()

// Paradrop deployment system
/obj/structure/dropship_equipment/paradrop_system
	name = "\improper HPU-1 Paradrop Deployment System"
	shorthand = "PDS"
	equip_categories = list(DROPSHIP_CREW_WEAPON)
	icon_state = "paradrop_module_packaged"
	point_cost = 150
	combat_equipment = FALSE
	var/system_cooldown
	var/signal_registered = FALSE

/obj/structure/dropship_equipment/paradrop_system/Initialize()
	. = ..()

/obj/structure/dropship_equipment/paradrop_system/Destroy()
	if(linked_shuttle && signal_registered)
		UnregisterSignal(linked_shuttle, COMSIG_SHUTTLE_SETMODE)
		signal_registered = FALSE
	. = ..()

/obj/structure/dropship_equipment/paradrop_system/proc/on_shuttle_mode_change(source, new_mode)
	SIGNAL_HANDLER
	update_icon_for_mode(new_mode)

/obj/structure/dropship_equipment/paradrop_system/proc/update_icon_for_mode(shuttle_mode)
	if(!ship_base)
		return

	switch(shuttle_mode)
		if(SHUTTLE_IDLE, SHUTTLE_RECHARGING, SHUTTLE_IGNITING)
			icon_state = "paradrop_hatch_idle"
		if(SHUTTLE_CALL, SHUTTLE_RECALL, SHUTTLE_PREARRIVAL)
			if(linked_shuttle?.paradrop_signal)
				icon_state = "paradrop_hatch_open"
			else
				icon_state = "paradrop_hatch_closed"

/obj/structure/dropship_equipment/paradrop_system/ui_data(mob/user)
	. = list()
	.["signal"] = "[linked_shuttle.paradrop_signal]"
	.["locked"] = !!linked_shuttle.paradrop_signal

/obj/structure/dropship_equipment/paradrop_system/update_equipment()
	if(ship_base)
		if(linked_shuttle && !signal_registered)
			RegisterSignal(linked_shuttle, COMSIG_SHUTTLE_SETMODE, PROC_REF(on_shuttle_mode_change))
			signal_registered = TRUE
		if(linked_shuttle)
			update_icon_for_mode(linked_shuttle.mode)
		else
			icon_state = "paradrop_hatch_idle"
		density = FALSE
	else
		icon_state = "paradrop_module_packaged"

/obj/structure/dropship_equipment/paradrop_system/proc/on_signal_lock()
	if(linked_shuttle?.mode in list(SHUTTLE_CALL, SHUTTLE_RECALL, SHUTTLE_PREARRIVAL))
		icon_state = "paradrop_hatch_open"
		playsound(src, 'sound/machines/chime.ogg', 25, 1)
		visible_message(SPAN_NOTICE("[src] chimes as the paradrop hatch opens."))

/obj/structure/dropship_equipment/paradrop_system/proc/on_signal_lost()
	if(linked_shuttle?.mode in list(SHUTTLE_CALL, SHUTTLE_RECALL, SHUTTLE_PREARRIVAL))
		icon_state = "paradrop_hatch_closed"
		playsound(src, 'sound/machines/ding_short.ogg', 25, 1)
		visible_message(SPAN_WARNING("[src] alerts as the paradrop hatch closes."))

/obj/structure/dropship_equipment/paradrop_system/attack_hand(mob/living/carbon/human/user)
	return

// Autoreloader System

/obj/structure/dropship_equipment/autoreloader
	name = "\improper RMT-08 Autoreloader System"
	desc = "An automated reloading system capable of storing three munitions and reloading a selected dropship weapon. Accepts rocket and missile munitions. Fits inside the crew weapon emplacement."
	icon_state = "autoreloader"
	shorthand = "RMT"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	equip_categories = list(DROPSHIP_CREW_WEAPON) // Fits inside the central spot of the dropship
	bound_height = 32
	density = TRUE
	point_cost = 500
	is_interactable = TRUE
	combat_equipment = FALSE
	uses_ammo = FALSE // the ammo that it accepts is decided underneath the specific ammo type itself, currently intended for only rocket_pod/missile_silo ammo types

	// Variables for ammo storage
	var/list/stored_ammo = list() // Stored ammo list
	var/max_ammo_slots = 3 // Maximum number of ammo slots
	var/reload_cooldown = 20
	var/idle_animation_cooldown = 0 // Cooldown for idle reload animation
	var/obj/structure/ship_ammo/selected_ammo = null
	var/obj/structure/dropship_equipment/weapon/selected_weapon = null

/obj/structure/dropship_equipment/autoreloader/update_equipment()
	if(ship_base)
		icon = 'icons/obj/structures/props/dropship/dropship_equipment64.dmi'
		icon_state = "autoreloader_installed"
		bound_height = 64
		density = FALSE // Only not dense when installed
	else
		icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
		icon_state = "autoreloader"
		bound_height = 32
		density = TRUE // Dense when installed

/obj/structure/dropship_equipment/autoreloader/update_icon()
	if(selected_ammo)
		icon_state = "autoreloader_loaded[selected_ammo.ammo_id]"
	else
		if(ship_base)
			icon_state = "autoreloader_installed"
		else
			icon_state = "autoreloader"

/obj/structure/dropship_equipment/autoreloader/get_examine_text(mob/user)
	. = ..()
	if(length(stored_ammo) > 0)
		. += "Currently loaded with:"
		for(var/obj/structure/ship_ammo/ammo in stored_ammo)
			. += "- [ammo.name]"
	else
		. += "No munitions currently stored."
	. += "Storage capacity: [length(stored_ammo)]/[max_ammo_slots]"

/obj/structure/dropship_equipment/autoreloader/ui_data(mob/user)
	. = list()
	.["name"] = name
	.["max_ammo_slots"] = max_ammo_slots
	.["available_slots"] = max_ammo_slots - length(stored_ammo)
	.["selected_weapon"] = selected_weapon ? ref(selected_weapon) : null
	.["selected_ammo"] = selected_ammo ? selected_ammo.name : null

/obj/structure/dropship_equipment/autoreloader/proc/reload_weapon(mob/user)
	if(!selected_weapon)
		to_chat(user, SPAN_WARNING("No weapon selected for reloading."))
		return
	if(!selected_ammo)
		to_chat(user, SPAN_WARNING("No ammo selected for reloading."))
		return

	// Check if the selected weapon still exists or is installed
	if(QDELETED(selected_weapon))
		to_chat(user, SPAN_WARNING("The selected weapon no longer exists. Please select a new weapon."))
		selected_weapon = null
		return
	if(!selected_weapon.ship_base)
		to_chat(user, SPAN_WARNING("The selected weapon has been uninstalled. Please select a new weapon."))
		selected_weapon = null
		return

	// Check if the selected weapon has reloading disabled from antiair boily
	if(selected_weapon.antiair_reload)
		to_chat(user, SPAN_WARNING("[selected_weapon.name] cannot be reloaded due to internal damage on the selected equipment. Repair the weapon first!"))
		return

	// Lets DCC operate it
	if(!skillcheck(user, SKILL_PILOT, SKILL_PILOT_TRAINED))
		to_chat(user, SPAN_WARNING("You don't know what all the buttons and readings do!"))
		return

	if(reload_cooldown > world.time)
		var/remaining = round((reload_cooldown - world.time) / 10, 1)
		to_chat(user, SPAN_WARNING("Autoreloader is cooling down. Please wait [remaining] seconds."))
		return

	// Check idle animation cooldown to prevent interrupting animations
	if(idle_animation_cooldown > world.time)
		var/remaining = round((idle_animation_cooldown - world.time) / 10, 1)
		to_chat(user, SPAN_WARNING("Autoreloader is busy. Please wait [remaining] seconds."))
		return

	// Prevent reloading the same ammo repeatedly
	if(selected_weapon.ammo_equipped == selected_ammo)
		to_chat(user, SPAN_WARNING("[selected_ammo.name] is already loaded in [selected_weapon.name]."))
		return

	// Prevent reloading if weapon already has ammo equipped
	if(selected_weapon.ammo_equipped)
		to_chat(user, SPAN_WARNING("[selected_weapon.name] already has ammo loaded. Unload it first!"))
		return

	// Check if the ammo is compatible with the weapon
	if(istype(selected_ammo.equipment_type, /list))
		var/eq_types = selected_ammo.equipment_type
		var/found = FALSE
		for(var/eq_type in eq_types)
			if(istype(selected_weapon, eq_type))
				found = TRUE
				break
		if(!found)
			to_chat(user, SPAN_WARNING("[selected_ammo.name] is not compatible with [selected_weapon.name]."))
			return
	else if(!istype(selected_weapon, selected_ammo.equipment_type))
		to_chat(user, SPAN_WARNING("[selected_ammo.name] is not compatible with [selected_weapon.name]."))
		return

	selected_weapon.ammo_equipped = selected_ammo
	stored_ammo -= selected_ammo
	flick("autoreloader_reloading[selected_ammo.ammo_id]", src)
	idle_animation_cooldown = world.time + 18
	playsound(src, 'sound/machines/outputclick2.ogg', 50, 1)
	to_chat(user, SPAN_NOTICE("You load [selected_ammo.name] into [selected_weapon.name]."))
	selected_weapon.update_icon()
	selected_ammo = null
	selected_weapon = null
	update_icon()
	reload_cooldown = world.time + (10 * initial(reload_cooldown))

/obj/structure/dropship_equipment/autoreloader/attack_hand(mob/user)
	if(!ishuman(user))
		return

	// If no ammo is selected, play idle animation with cooldown check
	if(!selected_ammo)
		// Check idle animation cooldown
		if(idle_animation_cooldown > world.time)
			var/remaining = round((idle_animation_cooldown - world.time) / 10, 1)
			to_chat(user, SPAN_WARNING("Autoreloader is busy. Please wait [remaining] seconds."))
			return

		flick("autoreloader_reloading_idle", src)
		to_chat(user, SPAN_WARNING("No ammo selected for reloading."))
		// Set cooldown for idle animation
		idle_animation_cooldown = world.time + 18
		return

	reload_weapon(user)


// used in the simulation room for cas runs, removed the sound and ammo depletion methods.
// copying code is definitely bad, but adding an unnecessary sim or not sim boolean check in the open_fire_firemission just doesn't seem right.
/obj/structure/dropship_equipment/weapon/proc/open_simulated_fire_firemission(obj/selected_target, mob/user = usr)
	set waitfor = FALSE
	var/turf/target_turf = get_turf(selected_target)
	var/obj/structure/ship_ammo/SA = ammo_equipped //necessary because we nullify ammo_equipped when firing big rockets
	var/ammo_accuracy_range = SA.accuracy_range
	// no warning sound and no travel time
	last_fired = world.time

	if(locate(/obj/structure/dropship_equipment/electronics/targeting_system) in linked_shuttle.equipments)
		ammo_accuracy_range = max(ammo_accuracy_range - 2, 0)

	ammo_accuracy_range /= 2 //buff for basically pointblanking the ground

	var/list/possible_turfs = RANGE_TURFS(ammo_accuracy_range, target_turf)
	var/turf/impact = pick(possible_turfs)
	sleep(3)
	SA.source_mob = user
	SA.detonate_on(impact, src)

//anti-air backend
/obj/structure/dropship_equipment/proc/apply_antiair_effect(datum/dropship_antiair/effect)
	if(!active_effects)
		active_effects = list()
	// Ensure we don't add the same effect twice
	if(!(effect in active_effects))
		active_effects[effect] = TRUE
		effect.apply(src)

/obj/structure/dropship_equipment/proc/remove_antiair_effect(datum/dropship_antiair/effect)
	if(active_effects && (effect in active_effects))
		active_effects[effect] = null
		active_effects -= effect

	for(var/varname in vars)
		if(findtext(varname, "antiair_"))
			var/effect_stacked = FALSE
			// Check if any remaining effects still need this flag
			if(active_effects)
				for(var/datum/dropship_antiair/remaining_effect in active_effects)
					if(findtext(varname, "antiair_") && (varname in remaining_effect.vars) && remaining_effect.vars[varname])
						effect_stacked = TRUE
						break
			// Only set to FALSE if no remaining effects need it
			if(!effect_stacked)
				vars[varname] = FALSE

	// Only set damaged to FALSE if no antiair effects remain
	if(!active_effects || active_effects.len == 0)
		damaged = FALSE

	// Clean up the effect if it was set to delete on timeout
	if(effect.antiair_destroy)
		qdel(effect)

/obj/structure/dropship_equipment/proc/has_active_antiair_effect()
	return islist(src.active_effects) && src.active_effects.len > 0
