
/// Dropship equipment, mainly weaponry but also utility implements
/obj/structure/dropship_equipment
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/structures/props/almayer_props.dmi'
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

/obj/structure/dropship_equipment/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(PC.loaded)
			if(ammo_equipped)
				to_chat(user, SPAN_WARNING("You need to unload \the [ammo_equipped] from \the [src] first!"))
				return TRUE
			if(uses_ammo)
				load_ammo(PC, user) //it handles on it's own whether the ammo fits
				return

		else
			if(uses_ammo && ammo_equipped)
				unload_ammo(PC, user)
			else
				grab_equipment(PC, user)
		return TRUE

/obj/structure/dropship_equipment/proc/load_ammo(obj/item/powerloader_clamp/PC, mob/living/user)
	if(!ship_base || !uses_ammo || ammo_equipped || !istype(PC.loaded, /obj/structure/ship_ammo))
		return
	var/obj/structure/ship_ammo/SA = PC.loaded
	if(SA.equipment_type != type)
		to_chat(user, SPAN_WARNING("[SA] doesn't fit in [src]."))
		return
	playsound(src, 'sound/machines/hydraulics_1.ogg', 40, 1)
	var/point_loc = ship_base.loc
	if(!do_after(user, 30 * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	if(!ship_base || ship_base.loc != point_loc)
		return
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
	if(!do_after(user, duration_time * user.get_skill_duration_multiplier(SKILL_ENGINEER), INTERRUPT_NO_NEEDHAND|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
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
		if(linked_console.selected_equipment) return
		linked_console.selected_equipment = src
		to_chat(user, SPAN_NOTICE("You select [src]."))



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

	if(istype(defense, /obj/structure/machinery/defenses/sentry))
		var/obj/structure/machinery/defenses/sentry/sentrygun = defense
		.["rounds"] = sentrygun.ammo.current_rounds
		.["max_rounds"] = sentrygun.ammo.max_rounds
		.["engaged"] = length(sentrygun.targets)

/obj/structure/dropship_equipment/sentry_holder/on_launch()
	if(ship_base && ship_base.base_category == DROPSHIP_WEAPON) //only external sentires are automatically undeployed
		undeploy_sentry()

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

/obj/structure/dropship_equipment/mg_holder/get_examine_text(mob/user)
	. = ..()
	if(!deployed_mg)
		. += "Its machine gun is missing."

/obj/structure/dropship_equipment/mg_holder/on_launch()
	if(ship_base && ship_base.base_category == DROPSHIP_WEAPON) //only external mgs are automatically undeployed
		undeploy_mg()

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
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
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
	point_cost = 50
	var/spotlights_cooldown
	var/brightness = 11

/obj/structure/dropship_equipment/electronics/spotlights/equipment_interact(mob/user)
	if(spotlights_cooldown > world.time)
		to_chat(user, SPAN_WARNING("[src] is busy."))
		return //prevents spamming deployment/undeployment
	if(!light_on)
		set_light(brightness)
		icon_state = "spotlights_on"
		to_chat(user, SPAN_NOTICE("You turn on [src]."))
	else
		set_light(0)
		icon_state = "spotlights_off"
		to_chat(user, SPAN_NOTICE("You turn off [src]."))
	spotlights_cooldown = world.time + 50

/obj/structure/dropship_equipment/electronics/spotlights/update_equipment()
	..()
	if(ship_base)
		if(!light_on)
			icon_state = "spotlights_off"
		else
			icon_state = "spotlights_on"
	else
		icon_state = "spotlights"
		if(light_on)
			set_light(0)

/obj/structure/dropship_equipment/electronics/spotlights/ui_data(mob/user)
	. = list()
	var/is_deployed = light_on
	.["name"] = name
	.["health"] = health
	.["health_max"] = initial(health)
	.["deployed"] = is_deployed



/obj/structure/dropship_equipment/electronics/flare_launcher
	name = "\improper AN/ALE-557 Flare Launcher"
	icon_state = "flare_launcher"
	point_cost = 0

/obj/structure/dropship_equipment/electronics/targeting_system
	name = "\improper AN/AAQ-178 Weapon Targeting System"
	shorthand = "Targeting"
	icon_state = "targeting_system"
	desc = "A targeting system for dropships. It improves firing accuracy on laser targets. Fits on electronics attach points. You need a powerloader to lift this."
	point_cost = 800

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
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
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
	var/fire_mission_only = TRUE

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
	var/turf/target_turf = get_turf(selected_target)
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
	if(linked_shuttle)
		for(var/obj/structure/dropship_equipment/electronics/targeting_system/TS in linked_shuttle.equipments)
			ammo_accuracy_range = max(ammo_accuracy_range-2, 0) //targeting system increase accuracy and reduce travelling time.
			ammo_max_inaccuracy = max(ammo_max_inaccuracy -3, 1)
			ammo_travelling_time = max(ammo_travelling_time - 20, 10)
			break

	msg_admin_niche("[key_name(user)] is direct-firing [SA] onto [selected_target] at ([target_turf.x],[target_turf.y],[target_turf.z]) [ADMIN_JMP(target_turf)]")
	if(ammo_travelling_time)
		var/total_seconds = max(floor(ammo_travelling_time/10),1)
		for(var/i = 0 to total_seconds)
			sleep(10)
			if(!selected_target || !selected_target.loc)//if laser disappeared before we reached the target,
				ammo_accuracy_range++ //accuracy decreases

	// clamp back to maximum inaccuracy
	ammo_accuracy_range = min(ammo_accuracy_range, ammo_max_inaccuracy)

	var/list/possible_turfs = RANGE_TURFS(ammo_accuracy_range, target_turf)
	var/turf/impact = pick(possible_turfs)
	if(ammo_warn_sound)
		playsound(impact, ammo_warn_sound, ammo_warn_sound_volume, 1,15)
	new /obj/effect/overlay/temp/blinking_laser (impact)
	sleep(10)
	SA.source_mob = user
	SA.detonate_on(impact, src)

/obj/structure/dropship_equipment/weapon/proc/open_fire_firemission(obj/selected_target, mob/user = usr)
	set waitfor = 0
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

	var/list/possible_turfs = list()
	for(var/turf/TU in range(ammo_accuracy_range, target_turf))
		possible_turfs += TU
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
		if(ship_base) icon_state = "30mm_cannon_installed"
		else icon_state = "30mm_cannon"


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
		if(ship_base) icon_state = "rocket_pod_installed"
		else icon_state = "rocket_pod"


/obj/structure/dropship_equipment/weapon/minirocket_pod
	name = "\improper LAU-229 Rocket Pod"
	icon_state = "minirocket_pod"
	desc = "A rocket pod capable of launching six laser-guided mini rockets. Moving this will require some sort of lifter. Accepts the AGR-59 series of minirockets."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
	firing_sound = 'sound/effects/rocketpod_fire.ogg'
	firing_delay = 10 //1 seconds
	point_cost = 600
	shorthand = "RKT"

/obj/structure/dropship_equipment/weapon/minirocket_pod/update_icon()
	if(ammo_equipped && ammo_equipped.ammo_count)
		icon_state = "minirocket_pod_loaded"
	else
		if(ship_base) icon_state = "minirocket_pod_installed"
		else icon_state = "minirocket_pod"

/obj/structure/dropship_equipment/weapon/minirocket_pod/deplete_ammo()
	..()
	if(ammo_equipped && !ammo_equipped.ammo_count) //fired last minirocket
		ammo_equipped = null

/obj/structure/dropship_equipment/weapon/laser_beam_gun
	name = "\improper LWU-6B Laser Cannon"
	icon_state = "laser_beam"
	desc = "State of the art technology recently acquired by the USCM, it fires a battery-fed pulsed laser beam at near lightspeed setting on fire everything it touches. Moving this will require some sort of lifter. Accepts the BTU-17/LW Hi-Cap Laser Batteries."
	icon = 'icons/obj/structures/props/almayer_props64.dmi'
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
		if(ship_base) icon_state = "laser_beam_installed"
		else icon_state = "laser_beam"

/obj/structure/dropship_equipment/weapon/launch_bay
	name = "\improper LAG-14 Internal Sentry Launcher"
	icon_state = "launch_bay"
	desc = "A launch bay to drop special ordnance. Fits inside the dropship's crew weapon emplacement. Moving this will require some sort of lifter. Accepts the A/C-49-P Air Deployable Sentry as ammunition."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	firing_sound = 'sound/weapons/gun_flare_explode.ogg'
	firing_delay = 10 //1 seconds
	bound_height = 32
	equip_categories = list(DROPSHIP_CREW_WEAPON) //fits inside the central spot of the dropship
	point_cost = 200
	shorthand = "LCH"

/obj/structure/dropship_equipment/weapon/launch_bay/update_equipment()
	if(ship_base)
		icon_state = "launch_bay_deployed"
	else
		icon_state = "launch_bay"

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
		to_chat(user, SPAN_WARNING(" The winch is already in motion."))
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
		if(occupant)
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
	user.visible_message(SPAN_NOTICE("[user] activates [src]'s winch."), \
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
		lifted_object.forceMove(loc)
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
	for(var/i in targets)
		. += list(i)


/obj/structure/dropship_equipment/fulton_system/proc/get_targets()
	. = list()
	for(var/obj/item/stack/fulton/F in GLOB.deployed_fultons)
		var/recovery_object
		if(F.attached_atom)
			recovery_object = F.attached_atom.name
		else
			recovery_object = "Empty"
		.["[recovery_object]"] = F

/obj/structure/dropship_equipment/fulton_system/equipment_interact(mob/user)
	if(!can_fulton(user))
		return

	var/list/possible_fultons = get_targets()

	if(!possible_fultons.len)
		to_chat(user, SPAN_WARNING("No active balloons detected."))
		return

	var/fulton_choice = tgui_input_list(usr, "Which balloon would you like to link with?", "Available balloons", possible_fultons)
	if(!fulton_choice)
		return

	var/obj/item/stack/fulton/F = possible_fultons[fulton_choice]
	if(!fulton_choice)
		return

	if(!ship_base) //system was uninstalled midway
		return

	if(is_ground_level(F.z)) //in case the fulton popped during our input()
		return

	if(!F.attached_atom)
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

	activate_winch(user, F)

/obj/structure/dropship_equipment/fulton_system/proc/activate_winch(mob/user, obj/item/stack/fulton/linked_fulton)
	set waitfor = 0
	busy_winch = TRUE
	playsound(loc, 'sound/machines/medevac_extend.ogg', 40, 1)
	flick("fulton_system_active", src)
	user.visible_message(SPAN_NOTICE("[user] activates [src]'s winch."), \
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
/obj/structure/dropship_equipment/paradrop_system
	name = "\improper HPU-1 Paradrop Deployment System"
	shorthand = "PDS"
	equip_categories = list(DROPSHIP_CREW_WEAPON)
	icon_state = "rappel_module_packaged"
	point_cost = 50
	combat_equipment = FALSE
	var/system_cooldown

/obj/structure/dropship_equipment/paradrop_system/ui_data(mob/user)
	. = list()
	.["signal"] = "[linked_shuttle.paradrop_signal]"
	.["locked"] = !!linked_shuttle.paradrop_signal

/obj/structure/dropship_equipment/paradrop_system/update_equipment()
	if(ship_base)
		icon_state = "rappel_hatch_closed"
		density = FALSE
	else
		icon_state = "rappel_module_packaged"

/obj/structure/dropship_equipment/paradrop_system/attack_hand(mob/living/carbon/human/user)
	return

// used in the simulation room for cas runs, removed the sound and ammo depletion methods.
// copying code is definitely bad, but adding an unnecessary sim or not sim boolean check in the open_fire_firemission just doesn't seem right.
/obj/structure/dropship_equipment/weapon/proc/open_simulated_fire_firemission(obj/selected_target, mob/user = usr)
	set waitfor = FALSE
	var/turf/target_turf = get_turf(selected_target)
	var/obj/structure/ship_ammo/SA = ammo_equipped //necessary because we nullify ammo_equipped when firing big rockets
	var/ammo_accuracy_range = SA.accuracy_range
	// no warning sound and no travel time
	last_fired = world.time

	if(locate(/obj/structure/dropship_equipment/electronics/targeting_system) in linked_shuttle.equipments) ammo_accuracy_range = max(ammo_accuracy_range - 2, 0)

	ammo_accuracy_range /= 2 //buff for basically pointblanking the ground

	var/list/possible_turfs = list()
	for(var/turf/TU in range(ammo_accuracy_range, target_turf))
		possible_turfs += TU
	var/turf/impact = pick(possible_turfs)
	sleep(3)
	SA.source_mob = user
	SA.detonate_on(impact, src)
