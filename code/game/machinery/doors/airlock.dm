#define AIRLOCK_WIRE_MAIN_POWER  1
#define AIRLOCK_WIRE_BACKUP_POWER   2
#define AIRLOCK_WIRE_DOOR_BOLTS  3
#define AIRLOCK_WIRE_OPEN_DOOR   4
#define AIRLOCK_WIRE_IDSCAN  5
#define AIRLOCK_WIRE_LIGHT   6
#define AIRLOCK_WIRE_SAFETY  7
#define AIRLOCK_WIRE_SPEED   8
#define AIRLOCK_WIRE_ELECTRIFY   9

GLOBAL_LIST_INIT(airlock_wire_descriptions, list(
		AIRLOCK_WIRE_MAIN_POWER   = "Main power",
		AIRLOCK_WIRE_BACKUP_POWER = "Backup power",
		AIRLOCK_WIRE_DOOR_BOLTS   = "Door bolts",
		AIRLOCK_WIRE_OPEN_DOOR = "Door motors",
		AIRLOCK_WIRE_IDSCAN    = "ID scanner",
		AIRLOCK_WIRE_LIGHT = "Bolt lights",
		AIRLOCK_WIRE_SAFETY    = "Proximity sensor",
		AIRLOCK_WIRE_SPEED = "Motor speed override",
		AIRLOCK_WIRE_ELECTRIFY = "Ground safety"
	))

/obj/structure/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/structures/doors/Door1.dmi'
	icon_state = "door_closed"
	power_channel = POWER_CHANNEL_ENVIRON

	var/secondsMainPowerLost = 0 //The number of seconds until power is restored.
	var/secondsBackupPowerLost = 0 //The number of seconds until power is restored.
	var/spawnPowerRestoreRunning = 0
	var/welded = null
	var/locked = 0
	var/lights = 1 // bolt lights show by default
	var/remoteDisabledIdScanner = FALSE

	var/wires = 1023 // Bitflag for which wires are cut (1 = uncut, 0 = cut)

	secondsElectrified = 0 //How many seconds remain until the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/obj/structure/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/airlock_assembly
	var/mineral = null
	var/justzap = 0
	var/safe = 1
	normalspeed = 1
	var/obj/item/circuitboard/airlock/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	var/secured_wires = 0 //for mapping use

	var/no_panel = 0 //the airlock has no panel that can be screwdrivered open
	var/not_weldable = 0 // stops people welding the door if true

	var/damage = 0
	var/damage_cap = HEALTH_DOOR // Airlock gets destroyed
	var/autoname = FALSE

	var/list/obj/item/device/assembly/signaller/attached_signallers = list()

	var/announce_hacked = TRUE

	//Resin constructions that will be SMUSHED by closing doors
	var/static/list/resin_door_shmushereds = list(
		/obj/effect/resin_construct/door,
		/obj/structure/mineral_door/resin,
		/obj/structure/bed/nest,
		/obj/effect/alien/resin/spike,
		/obj/effect/alien/resin/acid_pillar,
		/obj/effect/alien/resin/shield_pillar,
		/obj/item/explosive/grenade/alien/acid,
		/obj/structure/alien/movable_wall,
		/turf/closed/wall/resin,
	)

/obj/structure/machinery/door/airlock/Destroy()
	QDEL_NULL_LIST(attached_signallers)
	closeOther = null
	QDEL_NULL(electronics)
	return ..()

/obj/structure/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(istype(user) && !isRemoteControlling(user))
		if(isElectrified())
			if(!justzap && shock(user, 100))
				justzap = 1
				spawn (openspeed)
					justzap = 0
				return
		else if(user.hallucination > 50 && prob(10) && operating == 0)
			to_chat(user, SPAN_DANGER("<B>You feel a powerful shock course through your body!</B>"))
			user.halloss += 10
			user.apply_effect(10, STUN)
			return
	..(user)

/obj/structure/machinery/door/airlock/bumpopen(mob/living/simple_animal/user as mob)
	..(user)

/// DAMAGE CODE

/obj/structure/machinery/door/airlock/get_examine_text(mob/user)
	. = ..()
	var/dam = damage / damage_cap
	if(dam > 0.6)
		. += SPAN_DANGER("It looks heavily damaged.")
	else if(dam > 0.3)
		. += SPAN_WARNING("It looks moderately damaged.")
	else if(dam > 0)
		. += SPAN_WARNING("It looks slightly damaged.")
	if(masterkey_resist)
		. += SPAN_INFO("It has been reinforced against breaching attempts.")

/obj/structure/machinery/door/airlock/proc/take_damage(dam, mob/M)
	if(!dam || unacidable)
		return FALSE

	damage = max(0, damage + dam)

	if(damage >= damage_cap)
		if(M && istype(M))
			M.count_niche_stat(STATISTICS_NICHE_DESTRUCTION_DOORS, 1)
			SEND_SIGNAL(M, COMSIG_MOB_DESTROY_AIRLOCK, src)
		to_chat(loc, SPAN_DANGER("[src] blows apart!"))
		deconstruct(FALSE)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
		return TRUE

	return FALSE

// no, i don't know why this provides stuff if you shoot it apart vs disassembling
/obj/structure/machinery/door/airlock/deconstruct(disassembled = TRUE)
	if(!disassembled)
		if(width == 1)
			new /obj/item/stack/rods(loc)
			new /obj/item/stack/cable_coil/cut(loc)
			new /obj/effect/spawner/gibspawner/robot(loc)
			new /obj/effect/decal/cleanable/blood/oil(loc)
		else // big airlock, big debris
			for(var/turf/DT in locs) // locs = covered by airlock bounding box
				new /obj/item/stack/rods(DT)
				new /obj/item/stack/cable_coil/cut(DT)
				new /obj/effect/spawner/gibspawner/robot(DT)
				new /obj/effect/decal/cleanable/blood/oil(DT)
	return ..()

/obj/structure/machinery/door/airlock/ex_act(severity, explosion_direction, datum/cause_data/cause_data)
	var/exp_damage = severity * EXPLOSION_DAMAGE_MULTIPLIER_DOOR
	var/location = get_turf(src)
	if(!density)
		exp_damage *= EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN
	if(take_damage(exp_damage)) // destroyed by explosion, shards go flying
		create_shrapnel(location, rand(2,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light, cause_data)

/obj/structure/machinery/door/airlock/get_explosion_resistance()
	if(density)
		if(unacidable)
			return 1000000
		else
			return (damage_cap-damage)/EXPLOSION_DAMAGE_MULTIPLIER_DOOR //this should exactly match the amount of damage needed to destroy the door
	else
		return FALSE

/obj/structure/machinery/door/airlock/bullet_act(obj/projectile/P)
	bullet_ping(P)
	if(P.damage)
		if(P.ammo.flags_ammo_behavior & AMMO_ROCKET)
			take_damage(P.damage * 4, P.firer) // rockets wreck airlocks
			return TRUE
		else
			take_damage(P.damage, P.firer)
			return TRUE
	return FALSE

/obj/structure/machinery/door/airlock/proc/pulse(wire)
	switch(wire)
		if(AIRLOCK_WIRE_IDSCAN)
			//Sending a pulse through this flashes the red light on the door (if the door has power).
			if((arePowerSystemsOn()) && (!(stat & NOPOWER)))
				do_animate("deny")

		if(AIRLOCK_WIRE_MAIN_POWER)
			//Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter).
			loseMainPower()

		if(AIRLOCK_WIRE_DOOR_BOLTS)
			//one wire for door bolts. Sending a pulse through this drops door bolts if they're not down (whether power's on or not),
			//raises them if they are down (only if power's on)
			if(!locked)
				lock()
			else
				unlock()

		if(AIRLOCK_WIRE_BACKUP_POWER)
			//two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter).
			loseBackupPower()

		if(AIRLOCK_WIRE_ELECTRIFY)
			//one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds.
			if(secondsElectrified==0)
				shockedby += text("\[[time_stamp()]\][key_name(usr)]")
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>")
				secondsElectrified = 30
				visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src] airlock!"))
				spawn(10)
					//TODO: Move this into process() and make pulsing reset secondsElectrified to 30
					while (secondsElectrified>0)
						secondsElectrified-=1
						if(secondsElectrified<0)
							secondsElectrified = 0
						sleep(10)

		if(AIRLOCK_WIRE_OPEN_DOOR)
			//tries to open the door without ID
			//will succeed only if the ID wire is cut or the door requires no access
			if(!requiresID() || check_access(null))
				if(density) open()
				else close()

		if(AIRLOCK_WIRE_SAFETY)
			safe = !safe
			if(!density)
				close()
			if(safe)
				visible_message(SPAN_NOTICE("\The [src] airlock flashes a green light and beeps once."))
			else
				visible_message(SPAN_WARNING("\The [src] airlock flashes a red light and beeps once."))

		if(AIRLOCK_WIRE_SPEED)
			normalspeed = !normalspeed
			if(normalspeed)
				visible_message(SPAN_NOTICE("\The [src] airlock flashes a green light and beeps twice."))
			else
				visible_message(SPAN_WARNING("\The [src] airlock flashes a red light and beeps twice."))

		if(AIRLOCK_WIRE_LIGHT)
			lights = !lights

/obj/structure/machinery/door/airlock/proc/cut(wire)
	wires ^= getWireFlag(wire)

	switch(wire)
		if(AIRLOCK_WIRE_MAIN_POWER)
			//Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be crowbarred open, but bolts-raising will not work. Cutting these wires may electocute the user.
			loseMainPower()
			shock(usr, 50)

		if(AIRLOCK_WIRE_DOOR_BOLTS)
			//Cutting this wire also drops the door bolts, and mending it does not raise them. (This is what happens now, except there are a lot more wires going to door bolts at present)
			lock()

		if(AIRLOCK_WIRE_BACKUP_POWER)
			//Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
			loseBackupPower()
			shock(usr, 50)

		if(AIRLOCK_WIRE_ELECTRIFY)
			//Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted.
			if(secondsElectrified != -1)
				shockedby += text("\[[time_stamp()]\][key_name(usr)]")
				usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Electrified the [name] at [x] [y] [z]</font>")
				secondsElectrified = -1
				visible_message(SPAN_DANGER("Electric arcs shoot off from \the [src] airlock!"))

		if(AIRLOCK_WIRE_SAFETY)
			safe = 0
			visible_message(SPAN_WARNING("\The [src] airlock flashes a red light and beeps once."))

		if(AIRLOCK_WIRE_SPEED)
			autoclose = 0
			visible_message(SPAN_WARNING("\The [src] airlock flashes a red light."))

		if(AIRLOCK_WIRE_LIGHT)
			lights = 0

/obj/structure/machinery/door/airlock/proc/mend(wire)
	wires |= getWireFlag(wire)

	switch(wire)
		if(AIRLOCK_WIRE_MAIN_POWER)
			if(!isWireCut(AIRLOCK_WIRE_MAIN_POWER))
				regainMainPower()
				shock(usr, 50)

		if(AIRLOCK_WIRE_BACKUP_POWER)
			if(!isWireCut(AIRLOCK_WIRE_BACKUP_POWER))
				regainBackupPower()
				shock(usr, 50)

		if(AIRLOCK_WIRE_ELECTRIFY)
			if(secondsElectrified == -1)
				secondsElectrified = 0

		if(AIRLOCK_WIRE_SAFETY)
			safe = 1

		if(AIRLOCK_WIRE_SPEED)
			autoclose = 1
			if(!density)
				close()

		if(AIRLOCK_WIRE_LIGHT)
			lights = 1


/obj/structure/machinery/door/airlock/proc/isElectrified()
	if(secondsElectrified != 0)
		return TRUE
	return FALSE

/obj/structure/machinery/door/airlock/proc/isWireCut(wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/door/airlock/proc/getAssembly(wire)
	for(var/signaller in attached_signallers)
		if(wire == attached_signallers[signaller])
			return signaller

	return

/obj/structure/machinery/door/airlock/proc/arePowerSystemsOn()
	if(stat & NOPOWER)
		return FALSE
	return (secondsMainPowerLost==0 || secondsBackupPowerLost==0)

/obj/structure/machinery/door/airlock/requiresID()
	return !(isWireCut(AIRLOCK_WIRE_IDSCAN) || remoteDisabledIdScanner)

/obj/structure/machinery/door/airlock/proc/isAllPowerLost()
	if(stat & NOPOWER)
		return TRUE
	if(isWireCut(AIRLOCK_WIRE_MAIN_POWER) && isWireCut(AIRLOCK_WIRE_BACKUP_POWER))
		return TRUE
	return FALSE

/obj/structure/machinery/door/airlock/proc/regainMainPower()
	if(secondsMainPowerLost > 0)
		secondsMainPowerLost = 0
	visible_message(SPAN_NOTICE("\The [src] airlock lets out a long beep as a slight droning sound fades in."))

/obj/structure/machinery/door/airlock/proc/loseMainPower()
	if(secondsMainPowerLost <= 0)
		secondsMainPowerLost = 60
		if(secondsBackupPowerLost < 10)
			secondsBackupPowerLost = 10
	if(!spawnPowerRestoreRunning)
		spawnPowerRestoreRunning = 1
		spawn(0)
			var/cont = 1
			while (cont)
				sleep(10)
				cont = 0
				if(secondsMainPowerLost>0)
					if(!isWireCut(AIRLOCK_WIRE_MAIN_POWER))
						secondsMainPowerLost--
					cont = 1

				if(secondsBackupPowerLost>0)
					if(!isWireCut(AIRLOCK_WIRE_BACKUP_POWER))
						secondsBackupPowerLost--
					cont = 1
			spawnPowerRestoreRunning = 0

	visible_message(SPAN_NOTICE("The slight, droning sound of \the [src] airlock slowly fades out."))

/obj/structure/machinery/door/airlock/proc/loseBackupPower()
	if(secondsBackupPowerLost < 60)
		secondsBackupPowerLost = 60
	visible_message(SPAN_NOTICE("\The [src] beeps three times."))

/obj/structure/machinery/door/airlock/proc/regainBackupPower()
	if(secondsBackupPowerLost > 0)
		secondsBackupPowerLost = 0
	visible_message(SPAN_NOTICE("\The [src] beeps two times."))

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/structure/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return FALSE
	if(hasShocked)
		return FALSE //Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return TRUE
	else
		return FALSE


/obj/structure/machinery/door/airlock/update_icon()
	if(overlays) overlays.Cut()
	if(density)
		if(locked && lights)
			icon_state = "door_locked"
		else
			icon_state = "door_closed"
		if(panel_open || welded)
			overlays = list()
			if(panel_open)
				overlays += image(icon, "panel_open")
			if(welded)
				overlays += image(icon, "welded")
	else
		icon_state = "door_open"

	return

/obj/structure/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			if(overlays) overlays.Cut()
			if(panel_open)
				spawn(2) // The only work around that works. Downside is that the door will be gone for a millisecond.
					flick("o_door_opening", src)  //can not use flick due to BYOND bug updating overlays right before flicking
			else
				flick("door_opening", src)
		if("closing")
			if(overlays) overlays.Cut()
			if(panel_open)
				flick("o_door_closing", src)
			else
				flick("door_closing", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density)
				flick("door_deny", src)
	return

/obj/structure/machinery/door/airlock/attack_hand(mob/user as mob)
	if(!isRemoteControlling(usr))
		if(isElectrified())
			if(shock(user, 100))
				return

	if(panel_open)
		if(ishuman(usr) && !skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(usr, SPAN_WARNING("You look into \the [src]'s access panel and can only see a jumbled mess of colored wires..."))
			return FALSE

		tgui_interact(user)
	else
		..(user)
	return

/obj/structure/machinery/door/airlock/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Wires", "[name] Wires")
		ui.open()

/obj/structure/machinery/door/airlock/ui_data(mob/user)
	. = list()
	var/list/payload = list()

	for(var/wire in 1 to length(GLOB.airlock_wire_descriptions))
		payload.Add(list(list(
			"number" = wire,
			"cut" = isWireCut(wire),
			"attached" = !isnull(getAssembly(wire)),
		)))
	.["wires"] = payload
	.["proper_name"] = name

/obj/structure/machinery/door/airlock/ui_static_data(mob/user)
	. = list()
	.["wire_descs"] = GLOB.airlock_wire_descriptions

/obj/structure/machinery/door/airlock/ui_act(action, params)
	. = ..()

	if(. )//|| !interactable(usr))
		return

	if(usr.stat || usr.is_mob_restrained() || usr.mob_size == MOB_SIZE_SMALL)
		return FALSE

	add_fingerprint(usr)

	if((in_range(src, usr) && istype(loc, /turf)) && panel_open)
		if(ishuman(usr) && !skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
			to_chat(usr, SPAN_WARNING("You don't understand anything about [src]'s wiring!"))
			return FALSE

		var/target_wire = params["wire"]

		switch(action)
			if("cut")
				var/obj/item/held_item = usr.get_held_item()
				if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_WIRECUTTERS))
					to_chat(usr, SPAN_WARNING("You need wirecutters!"))
					return TRUE

				if(isWireCut(target_wire))
					mend(target_wire)
				else
					cut(target_wire)

				if(announce_hacked && is_mainship_level(z))
					announce_hacked = FALSE
					SSclues.create_print(get_turf(usr), usr, "The fingerprint contains oil and wire pieces.")
				. = TRUE
			if("pulse")
				var/obj/item/held_item = usr.get_held_item()
				if (!held_item || !HAS_TRAIT(held_item, TRAIT_TOOL_MULTITOOL))
					to_chat(usr, SPAN_WARNING("You need a multitool!"))
					return TRUE

				pulse(target_wire)
				. = TRUE
			if("attach")
				if(isnull(getAssembly(target_wire)))
					if(!issignaller(usr.get_active_hand()))
						to_chat(usr, SPAN_WARNING("You need a signaller in your hand!"))
						return TRUE

					if(getAssembly(target_wire))
						return TRUE

					var/obj/item/device/assembly/signaller/signaller = usr.get_active_hand()
					usr.drop_held_item(signaller)
					signaller.forceMove(src)

					signaller.airlock_wire = target_wire
					attached_signallers.Add(signaller)

					attached_signallers[signaller] = target_wire
					to_chat(usr, SPAN_NOTICE("You add [signaller] to [src]."))
					. = TRUE
				else
					var/obj/item/device/assembly/signaller/signaller = getAssembly(target_wire)

					if(!signaller)
						return TRUE

					if(!usr.put_in_active_hand(signaller))
						to_chat(usr, SPAN_WARNING("Your hand needs to be free!"))
						return TRUE

					signaller.airlock_wire = null
					attached_signallers -= signaller
					to_chat(usr, SPAN_NOTICE("You remove [signaller] from [src]."))
					. = TRUE

	add_fingerprint(usr)
	update_icon()

/obj/structure/machinery/door/airlock/attackby(obj/item/attacking_item, mob/user)
	if(SEND_SIGNAL(attacking_item, COMSIG_ITEM_ATTACK_AIRLOCK, src, user) & COMPONENT_CANCEL_AIRLOCK_ATTACK)
		return

	if(istype(attacking_item, /obj/item/clothing/mask/cigarette))
		if(isElectrified())
			var/obj/item/clothing/mask/cigarette/L = attacking_item
			L.light(SPAN_NOTICE("[user] lights their [L] on an electrical arc from [src]"))
			return

	if(!isRemoteControlling(user))
		if(isElectrified())
			if(shock(user, 75))
				return

	add_fingerprint(user)

	if(istype(attacking_item, /obj/item/weapon/zombie_claws) && (welded || locked))
		user.visible_message(SPAN_NOTICE("[user] starts tearing into the door on [src]!"), \
			SPAN_NOTICE("You start prying your hand into the gaps of the door with your fingers... This will take about 30 seconds."), \
			SPAN_NOTICE("You hear tearing noises!"))

		if(do_after(user, 300, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			user.visible_message(SPAN_NOTICE("[user] slams the door open [src]!"), \
			SPAN_NOTICE("You slam the door open!"), \
			SPAN_NOTICE("You hear metal screeching!"))
			locked = 0
			welded = 0
			update_icon()
			open()
			locked = 1

		return

	if((iswelder(attacking_item) && !operating && density))
		var/obj/item/tool/weldingtool/W = attacking_item
		var/weldtime = 50
		if(!HAS_TRAIT(W, TRAIT_TOOL_BLOWTORCH))
			weldtime = 70

		if(not_weldable)
			to_chat(user, SPAN_WARNING("\The [src] would require something a lot stronger than \the [W] to weld!"))
			return
		if(!W.isOn())
			to_chat(user, SPAN_WARNING("\The [W] needs to be on!"))
			return
		if(W.remove_fuel(0,user))
			user.visible_message(SPAN_NOTICE("[user] starts working on \the [src] with \the [W]."), \
			SPAN_NOTICE("You start working on \the [src] with \the [W]."), \
			SPAN_NOTICE("You hear welding."))
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			if(do_after(user, weldtime, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && density)
				if(!welded)
					welded = 1
				else
					welded = null
				update_icon()
		return

	else if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER))
		if(no_panel)
			to_chat(user, SPAN_WARNING("\The [src] has no panel to open!"))
			return

		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] [src]'s panel."))
		update_icon()
		return

	else if(HAS_TRAIT(attacking_item, TRAIT_TOOL_WIRECUTTERS))
		return attack_hand(user)

	else if(HAS_TRAIT(attacking_item, TRAIT_TOOL_MULTITOOL))
		return attack_hand(user)

	else if(isgun(attacking_item))
		var/obj/item/weapon/gun/gun_item = attacking_item
		for(var/slot in gun_item.attachments)
			if(istype(gun_item.attachments[slot], /obj/item/attachable/bayonet))
				var/obj/item/attachable/bayonet/a_bayonet = gun_item.attachments[slot]
				if(arePowerSystemsOn())
					to_chat(user, SPAN_WARNING("The airlock's motors resist your efforts to force it."))
				else if(locked)
					to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))
				else if(welded)
					to_chat(user, SPAN_WARNING("The airlock is welded shut."))
				else if(!operating)
					spawn(0)
						if(density)
							to_chat(user, SPAN_NOTICE("You start forcing the airlock open with [a_bayonet]."))
							if(do_after(user, a_bayonet.pry_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
								open(1)
						else
							to_chat(user, SPAN_NOTICE("You start forcing the airlock shut with [a_bayonet]."))
							if(do_after(user, a_bayonet.pry_delay, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
								close(1)

	else if(attacking_item.pry_capable)
		if(attacking_item.pry_capable == IS_PRY_CAPABLE_CROWBAR && panel_open && welded)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_TRAINED))
				to_chat(user, SPAN_WARNING("You don't seem to know how to deconstruct machines."))
				return
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message("[user] starts removing the electronics from the airlock assembly.", "You start removing electronics from the airlock assembly.")
			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(user, SPAN_NOTICE(" You removed the airlock electronics!"))

				var/obj/structure/airlock_assembly/doors_assembly = new assembly_type(loc)
				if(istype(doors_assembly, /obj/structure/airlock_assembly/multi_tile))
					doors_assembly.setDir(dir)
					doors_assembly.update_collision_box()

				doors_assembly.anchored = TRUE
				if(mineral)
					doors_assembly.glass = mineral
				//else if(glass)
				else if(glass && !doors_assembly.glass)
					doors_assembly.glass = TRUE
				doors_assembly.state = 0
				doors_assembly.created_name = name
				doors_assembly.update_icon()

				var/obj/item/circuitboard/airlock/airlock_electronics
				if(!electronics)
					airlock_electronics = new/obj/item/circuitboard/airlock(loc)
					if(!req_access || !req_one_access)
						check_access()
					if(length(req_access))
						airlock_electronics.conf_access = req_access
					else if(length(req_one_access))
						airlock_electronics.conf_access = req_one_access
						airlock_electronics.one_access = TRUE
				else
					airlock_electronics = electronics
					electronics = null
					airlock_electronics.forceMove(loc)
				if(operating == -1)
					airlock_electronics.fried = TRUE
					airlock_electronics.update_icon()
					operating = 0

				msg_admin_niche("[key_name(user)] deconstructed [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z])")
				SEND_SIGNAL(user, COMSIG_MOB_DISASSEMBLE_AIRLOCK, src)
				deconstruct()
				return

		else if(arePowerSystemsOn() && attacking_item.pry_capable != IS_PRY_CAPABLE_FORCE)
			to_chat(user, SPAN_WARNING("The airlock's motors resist your efforts to force it."))

		else if(locked)
			to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))

		else if(welded)
			to_chat(user, SPAN_WARNING("The airlock is welded shut."))

		else if(attacking_item.pry_capable == IS_PRY_CAPABLE_FORCE)
			return FALSE //handled by the item's afterattack

		else if(!operating)
			spawn(0)
				if(density)
					open(1)
				else
					close(1)

		return TRUE //no afterattack call

	if(istype(attacking_item, /obj/item/large_shrapnel))
		return FALSE //trigger afterattack call
	else
		return ..()


/obj/structure/machinery/door/airlock/open(forced=0)
	if( operating || welded || locked || !loc)
		return FALSE
	if(!forced)
		if( !arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR) )
			return FALSE
	use_power(360) //360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(istype(src, /obj/structure/machinery/door/airlock/glass))
		playsound(loc, 'sound/machines/windowdoor.ogg', 25, 1)
	else
		playsound(loc, 'sound/machines/airlock.ogg', 25, 0)
	if(closeOther != null && istype(closeOther, /obj/structure/machinery/door/airlock/) && !closeOther.density)
		closeOther.close()
	return ..(forced)

/obj/structure/machinery/door/airlock/close(forced = FALSE)
	if(operating || welded || locked || !loc)
		return
	if(!forced)
		if( !arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS) )
			return
	if(safe)
		for(var/turf/turf in locs)
			if(locate(/mob/living) in turf)
			// playsound(loc, 'sound/machines/buzz-two.ogg', 25, 0) //THE BUZZING IT NEVER STOPS -Pete
				spawn (60 + openspeed)
					close()
				return

	for(var/turf/turf in locs)
		for(var/mob/living/M in turf)
			if(HAS_TRAIT(M, TRAIT_SUPER_STRONG))
				M.apply_damage(DOOR_CRUSH_DAMAGE, BRUTE)
			else
				M.apply_damage(DOOR_CRUSH_DAMAGE, BRUTE)
				M.set_effect(5, STUN)
				M.set_effect(5, WEAKEN)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.pain.feels_pain)
						M.emote("pain")
			var/turf/location = loc
			if(istype(location, /turf))
				location.add_mob_blood(M)

	break_resin_objects()

	use_power(360) //360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(istype(src, /obj/structure/machinery/door/airlock/glass))
		playsound(loc, 'sound/machines/windowdoor.ogg', 25, 1)
	else
		playsound(loc, 'sound/machines/airlock.ogg', 25, 0)
	for(var/turf/turf in locs)
		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(killthis)
			killthis.ex_act(EXPLOSION_THRESHOLD_LOW)//Smashin windows
	..()
	return

/obj/structure/machinery/door/airlock/proc/lock(forced = FALSE)
	if((operating && !forced) || locked)
		return

	playsound(loc, 'sound/machines/hydraulics_1.ogg', 25)
	locked = TRUE
	visible_message(SPAN_NOTICE("\The [src] airlock emits a loud thunk, then a click."))
	update_icon()

/obj/structure/machinery/door/airlock/proc/unlock(forced=0)
	if(operating || !locked) return

	if(forced || (arePowerSystemsOn())) //only can raise bolts if power's on
		locked = FALSE

		playsound(loc, 'sound/machines/hydraulics_2.ogg', 25)
		visible_message(SPAN_NOTICE("\The [src] airlock emits a click, then hums slightly."))
		update_icon()
		return TRUE
	return FALSE

/obj/structure/machinery/door/airlock/Initialize()
	. = ..()

	if(autoname)
		var/area/A = get_area(loc)
		name = A.name

	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/LateInitialize()
	. = ..()
	if(closeOtherId != null)
		for(var/obj/structure/machinery/door/airlock/A in GLOB.machines)
			if(A.closeOtherId == closeOtherId && A != src)
				closeOther = A
				break
	// fix smoothing
	for(var/turf/closed/wall/W in orange(1))
		W.update_connections()
		W.update_icon()

/obj/structure/machinery/door/airlock/proc/prison_open()
	unlock()
	open()
	lock()
	return

/obj/structure/machinery/door/airlock/allowed(mob/M)
	if(isWireCut(AIRLOCK_WIRE_IDSCAN) || (GLOB.maint_all_access && check_access_list(list(ACCESS_MARINE_MAINT))))
		return TRUE
	return ..(M)

/obj/structure/machinery/door/airlock/proc/break_resin_objects()
	var/list/things_to_shmush = locs
	for(var/turf/i in things_to_shmush)
		things_to_shmush |= i.contents
	for(var/x in things_to_shmush)
		for(var/i in resin_door_shmushereds)
			if(istype(x,i)) //I would like to just use a if(locate() in ) here but Im not gonna add every child to GLOB.resin_door_shmushereds so it works
				playsound(loc, "alien_resin_break", 25)
				visible_message(SPAN_WARNING("The [src.name] closes on [x], shmushing it!"))
				if(isturf(x))
					var/turf/closed/wall/resin_wall_to_destroy = x
					resin_wall_to_destroy.dismantle_wall()
				else
					qdel(x)
				break

/obj/structure/machinery/door/airlock/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	if(isElectrified() && arePowerSystemsOn())
		var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
		sparks.set_up(5, 1, src)
		sparks.start()
		xeno.KnockDown(1)
		xeno.Stun(1)

	playsound(src, 'sound/effects/metalhit.ogg', 50, TRUE)
	xeno.visible_message(SPAN_XENOWARNING("\The [xeno] strikes \the [src] with its tail!"), SPAN_XENOWARNING("You strike \the [src] with your tail!"))
	xeno.emote("tail")
	var/damage = xeno.melee_damage_upper * TAILSTAB_AIRLOCK_DAMAGE_MULTIPLIER
	take_damage(damage, xeno)
	return TAILSTAB_COOLDOWN_NORMAL

/obj/structure/machinery/door/airlock/autoclose()
	if(locked)
		return
	..()
