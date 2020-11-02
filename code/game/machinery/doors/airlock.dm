#define AIRLOCK_WIRE_MAIN_POWER     1
#define AIRLOCK_WIRE_BACKUP_POWER   2
#define AIRLOCK_WIRE_DOOR_BOLTS     3
#define AIRLOCK_WIRE_OPEN_DOOR      4
#define AIRLOCK_WIRE_IDSCAN         5
#define AIRLOCK_WIRE_LIGHT          6
#define AIRLOCK_WIRE_SAFETY         7
#define AIRLOCK_WIRE_SPEED          8
#define AIRLOCK_WIRE_ELECTRIFY      9

/obj/structure/machinery/door/airlock
	name = "airlock"
	icon = 'icons/obj/structures/doors/Doorint.dmi'
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
	var/secured_wires = 0	//for mapping use

	var/no_panel = 0 //the airlock has no panel that can be screwdrivered open
	var/not_weldable = 0 // stops people welding the door if true

	var/damage = 0
	var/damage_cap = HEALTH_DOOR // Airlock gets destroyed
	var/autoname = FALSE

	var/list/obj/item/device/assembly/signaler/attached_signallers = list()

	var/announce_hacked = TRUE

/obj/structure/machinery/door/airlock/Destroy()
	QDEL_NULL_LIST(attached_signallers)
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
			user.stunned += 10
			return
	..(user)

/obj/structure/machinery/door/airlock/bumpopen(mob/living/simple_animal/user as mob)
	..(user)

/// DAMAGE CODE

/obj/structure/machinery/door/airlock/examine(mob/user)
	. = ..()
	var/dam = damage / damage_cap
	if(dam > 0.6)
		to_chat(user, SPAN_DANGER("It looks heavily damaged."))
	else if(dam > 0.3)
		to_chat(user, SPAN_WARNING("It looks moderately damaged."))
	else if(dam > 0)
		to_chat(user, SPAN_WARNING("It looks slightly damaged."))

/obj/structure/machinery/door/airlock/proc/take_damage(var/dam, var/mob/M)
	if(!dam || unacidable)
		return FALSE

	damage = max(0, damage + dam)

	if(damage >= damage_cap)
		if(M && istype(M))
			M.count_niche_stat(STATISTICS_NICHE_DESCTRUCTION_DOORS, 1)
			SEND_SIGNAL(M, COMSIG_MOB_DESTROY_AIRLOCK, src)
		destroy_airlock()
		return TRUE

	return FALSE

/obj/structure/machinery/door/airlock/proc/destroy_airlock()
	if(!src || unacidable)
		return
	var/turf/T = get_turf(src)

	to_chat(loc, SPAN_DANGER("[src] blows apart!"))
	if(width == 1)
		new /obj/item/stack/rods(T)
		new /obj/item/stack/cable_coil/cut(T)
		new /obj/effect/spawner/gibspawner/robot(T)
		new /obj/effect/decal/cleanable/blood/oil(T)
	else // big airlock, big debris
		for(var/turf/DT in locs) // locs = covered by airlock bounding box
			new /obj/item/stack/rods(DT)
			new /obj/item/stack/cable_coil/cut(DT)
			new /obj/effect/spawner/gibspawner/robot(DT)
			new /obj/effect/decal/cleanable/blood/oil(DT)

	playsound(src, 'sound/effects/metal_crash.ogg', 25, 1)
	qdel(src)

/obj/structure/machinery/door/airlock/ex_act(severity, explosion_direction)
	var/exp_damage = severity * EXPLOSION_DAMAGE_MULTIPLIER_DOOR
	var/location = get_turf(src)
	if(!density)
		exp_damage *= EXPLOSION_DAMAGE_MODIFIER_DOOR_OPEN
	if(take_damage(exp_damage)) // destroyed by explosion, shards go flying
		create_shrapnel(location, rand(2,5), explosion_direction, , /datum/ammo/bullet/shrapnel/light)

/obj/structure/machinery/door/airlock/get_explosion_resistance()
	if(density)
		if(unacidable)
			return 1000000
		else
			return (damage_cap-damage)/EXPLOSION_DAMAGE_MULTIPLIER_DOOR //this should exactly match the amount of damage needed to destroy the door
	else
		return FALSE

/obj/structure/machinery/door/airlock/bullet_act(var/obj/item/projectile/Proj)
	bullet_ping(Proj)
	if(Proj.ammo.damage)
		if(Proj.ammo.flags_ammo_behavior & AMMO_ROCKET)
			take_damage(Proj.ammo.damage * 4, Proj.firer) // rockets wreck airlocks
			return TRUE
		else
			take_damage(Proj.ammo.damage, Proj.firer)
			return TRUE
	return FALSE

// As opposed to a global var or a list that would clutter the airlock's var list
/obj/structure/machinery/door/airlock/proc/get_wire_descriptions()
	return list(
		AIRLOCK_WIRE_MAIN_POWER   = "Main power",
		AIRLOCK_WIRE_BACKUP_POWER = "Backup power",
		AIRLOCK_WIRE_DOOR_BOLTS   = "Door bolts",
		AIRLOCK_WIRE_OPEN_DOOR    = "Door motors",
		AIRLOCK_WIRE_IDSCAN       = "ID scanner",
		AIRLOCK_WIRE_LIGHT        = "Bolt lights",
		AIRLOCK_WIRE_SAFETY       = "Proximity sensor",
		AIRLOCK_WIRE_SPEED        = "Motor speed override",
		AIRLOCK_WIRE_ELECTRIFY    = "Ground safety"
	)

/obj/structure/machinery/door/airlock/proc/pulse(var/wire)
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
				if(density)	open()
				else		close()

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

/obj/structure/machinery/door/airlock/proc/cut(var/wire)
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

/obj/structure/machinery/door/airlock/proc/mend(var/wire)
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

/obj/structure/machinery/door/airlock/proc/isWireCut(var/wire)
	return !(wires & getWireFlag(wire))

/obj/structure/machinery/door/airlock/proc/getAssembly(var/wire)
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
						secondsMainPowerLost -= 1
					cont = 1

				if(secondsBackupPowerLost>0)
					if(!isWireCut(AIRLOCK_WIRE_BACKUP_POWER))
						secondsBackupPowerLost -= 1
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
		return FALSE	//Already shocked someone recently?
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
		if(ishuman(usr) && !skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(usr, SPAN_WARNING("You look into \the [src]'s access panel and can only see a jumbled mess of colored wires..."))
			return FALSE

		ui_interact(user)
	else
		..(user)
	return

/obj/structure/machinery/door/airlock/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()
	data["wires"] = null

	var/list/wire_descriptions = get_wire_descriptions()
	var/list/panel_wires = list()
	for(var/wire = 1 to wire_descriptions.len)
		panel_wires += list(list("desc" = wire_descriptions[wire], "cut" = isWireCut(wire), "attach" = !isnull(getAssembly(wire))))

	if(panel_wires.len)
		data["wires"] = panel_wires

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "airlock_panel.tmpl", "Access Panel", 400, 300)
		ui.set_initial_data(data)
		ui.open()

/obj/structure/machinery/door/airlock/Topic(href, href_list, var/nowindow = 0)
	if(!nowindow)
		..()

	if(usr.stat || usr.is_mob_restrained() || usr.mob_size == MOB_SIZE_SMALL)
		return FALSE

	add_fingerprint(usr)

	if((in_range(src, usr) && istype(loc, /turf)) && panel_open)
		if(ishuman(usr) && !skillcheck(usr, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(usr, SPAN_WARNING("You don't understand anything about [src]'s wiring!"))
			return FALSE

		if(href_list["wire"])
			var/wireId = text2num(href_list["wire"])

			if(!iswirecutter(usr.get_active_hand()))
				to_chat(usr, SPAN_WARNING("You need wirecutters!"))
				return TRUE

			if(isWireCut(wireId))
				mend(wireId)
			else
				cut(wireId)

			if(announce_hacked && z == MAIN_SHIP_Z_LEVEL)
				announce_hacked = FALSE
				SSclues.create_print(get_turf(usr), usr, "The fingerprint contains oil and wire pieces.")
				if(usr.detectable_by_ai())
					ai_silent_announcement("DAMAGE REPORT: Structural damage detected at [get_area(src)], requesting Military Police supervision.")

		else if(href_list["pulse"])
			var/wireId = text2num(href_list["pulse"])

			if(!ismultitool(usr.get_active_hand()))
				to_chat(usr, SPAN_WARNING("You need a multitool!"))
				return TRUE

			pulse(wireId)
		else if(href_list["attach"])
			var/wireId = text2num(href_list["attach"])

			if(!issignaler(usr.get_active_hand()))
				to_chat(usr, SPAN_WARNING("You need a signaller in your hand!"))
				return TRUE
			
			if(getAssembly(wireId))
				return TRUE

			if(!skillcheck(usr, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
				to_chat(usr, SPAN_WARNING("You don't seem to know how to perform this action."))
				return TRUE

			var/obj/item/device/assembly/signaler/signaller = usr.get_active_hand()
			usr.drop_held_item(signaller)
			signaller.forceMove(src)

			signaller.airlock_wire = wireId
			attached_signallers.Add(signaller)

			attached_signallers[signaller] = wireId
			to_chat(usr, SPAN_NOTICE("You add [signaller] to [src]."))

		else if(href_list["unattach"])
			var/wireId = text2num(href_list["unattach"])
			var/obj/item/device/assembly/signaler/signaller = getAssembly(wireId)

			if(!signaller)
				return TRUE

			if(!usr.put_in_active_hand(signaller))
				to_chat(usr, SPAN_WARNING("Your hand needs to be free!"))
				return TRUE
			
			signaller.airlock_wire = null
			attached_signallers -= signaller
			to_chat(usr, SPAN_NOTICE("You remove [signaller] from [src]."))



	add_fingerprint(usr)
	update_icon()

	return TRUE

/obj/structure/machinery/door/airlock/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/clothing/mask/cigarette))
		if(isElectrified())
			var/obj/item/clothing/mask/cigarette/L = C
			L.light(SPAN_NOTICE("[user] lights their [L] on an electrical arc from the [src]"))
			return

	if(!isRemoteControlling(user))
		if(isElectrified())
			if(shock(user, 75))
				return

	add_fingerprint(user)

	if(istype(C, /obj/item/weapon/zombie_claws) && (welded || locked))
		user.visible_message(SPAN_NOTICE("[user] starts tearing into the door on the [src]!"), \
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

	if((istype(C, /obj/item/tool/weldingtool) && !operating && density))
		var/obj/item/tool/weldingtool/W = C

		if(not_weldable)
			to_chat(user, SPAN_WARNING("\The [src] would require something a lot stronger than [W] to weld!"))
			return

		if(W.remove_fuel(0,user))
			user.visible_message(SPAN_NOTICE("[user] starts working on \the [src] with [W]."), \
			SPAN_NOTICE("You start working on \the [src] with [W]."), \
			SPAN_NOTICE("You hear welding."))
			playsound(loc, 'sound/items/weldingtool_weld.ogg', 25)
			if(do_after(user, 50, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD) && density)
				if(!welded)
					welded = 1
				else
					welded = null
				update_icon()
		return

	else if(istype(C, /obj/item/tool/screwdriver))
		if(no_panel)
			to_chat(user, SPAN_WARNING("\The [src] has no panel to open!"))
			return

		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] [src]'s panel."))
		update_icon()

	else if(istype(C, /obj/item/tool/wirecutters))
		return attack_hand(user)

	else if(istype(C, /obj/item/device/multitool))
		return attack_hand(user)

	else if(istype(C, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/G = C
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/bayonet))
				if(arePowerSystemsOn())
					to_chat(user, SPAN_WARNING("The airlock's motors resist your efforts to force it."))
				else if(locked)
					to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))
				else if(welded)
					to_chat(user, SPAN_WARNING("The airlock is welded shut."))
				else if(!operating)
					spawn(0)
						if(density)
							to_chat(user, SPAN_NOTICE("You start forcing the airlock open with [G.attachments[slot]]."))
							if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
								open(1)
						else
							to_chat(user, SPAN_NOTICE("You start forcing the airlock shut with [G.attachments[slot]]."))
							if(do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
								close(1)

	else if(C.pry_capable)
		if(C.pry_capable == IS_PRY_CAPABLE_CROWBAR && panel_open && welded)
			if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
				to_chat(user, SPAN_WARNING("You don't seem to know how to deconstruct machines."))
				return
			if(width > 1)
				to_chat(user, SPAN_WARNING("Large doors seem impossible to disassemble."))
				return
			playsound(loc, 'sound/items/Crowbar.ogg', 25, 1)
			user.visible_message("[user] starts removing the electronics from the airlock assembly.", "You start removing electronics from the airlock assembly.")
			if(do_after(user, 40, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				to_chat(user, SPAN_NOTICE(" You removed the airlock electronics!"))

				var/obj/structure/airlock_assembly/da = new assembly_type(loc)
				if(istype(da, /obj/structure/airlock_assembly/multi_tile))
					da.dir = dir

				da.anchored = 1
				if(mineral)
					da.glass = mineral
				//else if(glass)
				else if(glass && !da.glass)
					da.glass = 1
				da.state = 0
				da.created_name = name
				da.update_icon()

				var/obj/item/circuitboard/airlock/ae
				if(!electronics)
					ae = new/obj/item/circuitboard/airlock( loc )
					if(!req_access || !req_one_access)
						check_access()
					if(req_access.len)
						ae.conf_access = req_access
					else if(req_one_access.len)
						ae.conf_access = req_one_access
						ae.one_access = 1
				else
					ae = electronics
					electronics = null
					ae.loc = loc
				if(operating == -1)
					ae.icon_state = "door_electronics_smoked"
					operating = 0

				msg_admin_niche("[key_name(user)] deconstructed [src] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z])")
				SEND_SIGNAL(user, COMSIG_MOB_DISASSEMBLE_AIRLOCK, src)
				qdel(src)
				return

		else if(arePowerSystemsOn() && C.pry_capable != IS_PRY_CAPABLE_FORCE)
			to_chat(user, SPAN_WARNING("The airlock's motors resist your efforts to force it."))

		else if(locked)
			to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))

		else if(welded)
			to_chat(user, SPAN_WARNING("The airlock is welded shut."))

		else if(C.pry_capable == IS_PRY_CAPABLE_FORCE)
			return FALSE //handled by the item's afterattack

		else if(!operating)
			spawn(0)
				if(density)
					open(1)
				else
					close(1)

		return TRUE //no afterattack call
	else
		return ..()


/obj/structure/machinery/door/airlock/open(var/forced=0)
	if( operating || welded || locked || !loc)
		return FALSE
	if(!forced)
		if( !arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_OPEN_DOOR) )
			return FALSE
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	if(istype(src, /obj/structure/machinery/door/airlock/glass))
		playsound(loc, 'sound/machines/windowdoor.ogg', 25, 1)
	else
		playsound(loc, 'sound/machines/airlock.ogg', 25, 0)
	if(closeOther != null && istype(closeOther, /obj/structure/machinery/door/airlock/) && !closeOther.density)
		closeOther.close()
	return ..(forced)

/obj/structure/machinery/door/airlock/close(var/forced=0)
	if(operating || welded || locked || !loc)
		return
	if(!forced)
		if( !arePowerSystemsOn() || isWireCut(AIRLOCK_WIRE_DOOR_BOLTS) )
			return
	if(safe)
		for(var/turf/turf in locs)
			if(locate(/mob/living) in turf)
			//	playsound(loc, 'sound/machines/buzz-two.ogg', 25, 0)	//THE BUZZING IT NEVER STOPS	-Pete
				spawn (60 + openspeed)
					close()
				return

	for(var/turf/turf in locs)
		for(var/mob/living/M in turf)
			if(isborg(M))
				M.apply_damage(DOOR_CRUSH_DAMAGE, BRUTE)
			else
				M.apply_damage(DOOR_CRUSH_DAMAGE, BRUTE)
				M.SetStunned(5)
				M.SetKnockeddown(5)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					if(H.pain.feels_pain)
						M.emote("pain")
			var/turf/location = loc
			if(istype(location, /turf))
				location.add_mob_blood(M)

	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
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

/obj/structure/machinery/door/airlock/proc/lock(var/forced=0)
	if(operating || locked) return

	playsound(loc, 'sound/machines/hydraulics_1.ogg', 25)
	locked = 1
	visible_message(SPAN_NOTICE("\The [src] airlock emits a loud thunk, then a click."))
	update_icon()

/obj/structure/machinery/door/airlock/proc/unlock(var/forced=0)
	if(operating || !locked) return

	if(forced || (arePowerSystemsOn())) //only can raise bolts if power's on
		locked = 0

		playsound(loc, 'sound/machines/hydraulics_2.ogg', 25)
		visible_message(SPAN_NOTICE("\The [src] airlock emits a click, then hums slightly."))
		update_icon()
		return TRUE
	return FALSE

/obj/structure/machinery/door/airlock/New()
	..()

	wall_check()

	if(autoname)
		var/area/A = get_area(loc)
		name = A.name

	if(closeOtherId != null)
		spawn (5)
			for(var/obj/structure/machinery/door/airlock/A in machines)
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
	if(isWireCut(AIRLOCK_WIRE_IDSCAN) || (maint_all_access && check_access_list(list(ACCESS_MARINE_ENGINEERING))))
		return TRUE
	return ..(M)
