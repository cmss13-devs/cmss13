#define TANK_MAX_RELEASE_PRESSURE (3*ONE_ATMOSPHERE)
#define TANK_DEFAULT_RELEASE_PRESSURE 24
#define TANK_MIN_RELEASE_PRESSURE 0

/obj/item/tank
	name = "tank"
	icon = 'icons/obj/items/tank.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/tanks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/tanks_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/misc.dmi'
	)
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_MEDIUM

	var/pressure_full = ONE_ATMOSPHERE*4

	var/pressure = ONE_ATMOSPHERE*4
	var/gas_type = GAS_TYPE_AIR
	var/temperature = T20C

	force = 5
	throwforce = 10
	throw_speed = SPEED_FAST
	throw_range = 4

	var/distribute_pressure = ONE_ATMOSPHERE
	var/integrity = 3
	var/volume = 70
	var/manipulated_by = null //Used by _onclick/hud/screen_objects.dm internals to determine if someone has messed with our tank or not.
						//If they have and we haven't scanned it with the PDA or gas analyzer then we might just breath whatever they put in it.

/obj/item/tank/get_examine_text(mob/user)
	. = ..()
	if(in_range(src, user))
		var/celsius_temperature = temperature-T0C
		var/descriptive
		switch(celsius_temperature)
			if(-280 to 20)
				descriptive = "cold"
			if(20 to 40)
				descriptive = "room temperature"
			if(40 to 80)
				descriptive = "lukewarm"
			if(80 to 100)
				descriptive = "warm"
			if(100 to 300)
				descriptive = "hot"
			else
				descriptive = "furiously hot"

		. += SPAN_NOTICE("\The [icon2html(src, user)][src] feels [descriptive]")


/obj/item/tank/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if((istype(W, /obj/item/device/analyzer)) && get_dist(user, src) <= 1)
		for(var/mob/O in viewers(user, null))
			to_chat(O, SPAN_DANGER("[user] has used [W] on [icon2html(src, O)] [src]"))

		manipulated_by = user.real_name //This person is aware of the contents of the tank.

		to_chat(user, SPAN_NOTICE("Results of analysis of [icon2html(src, user)]"))
		if(pressure>0)
			to_chat(user, SPAN_NOTICE("Pressure: [round(pressure,0.1)] kPa"))
			to_chat(user, SPAN_NOTICE("[gas_type]: 100%"))
			to_chat(user, SPAN_NOTICE("Temperature: [floor(temperature-T0C)]&deg;C"))
		else
			to_chat(user, SPAN_NOTICE("Tank is empty!"))
		src.add_fingerprint(user)


/obj/item/tank/attack_self(mob/user)
	. = ..()

	tgui_interact(user)

/obj/item/tank/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Tank", name)
		ui.open()

/obj/item/tank/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/tank/ui_data(mob/user)
	var/list/data = list()

	data["tankPressure"] = floor(pressure)
	data["tankMaxPressure"] = floor(pressure_full)
	data["ReleasePressure"] = floor(distribute_pressure)
	data["defaultReleasePressure"] = floor(TANK_DEFAULT_RELEASE_PRESSURE)
	data["maxReleasePressure"] = floor(TANK_MAX_RELEASE_PRESSURE)
	data["minReleasePressure"] = floor(TANK_MIN_RELEASE_PRESSURE)

	var/mask_connected = FALSE
	var/using_internal = FALSE

	if(istype(loc,/mob/living/carbon))
		var/mob/living/carbon/location = loc
		if(location.internal == src)
			using_internal = TRUE
		if(location.internal == src || (location.wear_mask && (location.wear_mask.flags_inventory & ALLOWINTERNALS)))
			mask_connected = TRUE

	data["mask_connected"] = mask_connected
	data["valve_open"] = using_internal

	return data

/obj/item/tank/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("pressure")
			var/tgui_pressure = params["pressure"]
			if(tgui_pressure == "reset")
				src.distribute_pressure = TANK_DEFAULT_RELEASE_PRESSURE
			else if(tgui_pressure == "max")
				src.distribute_pressure = TANK_MAX_RELEASE_PRESSURE
			else if(tgui_pressure == "min")
				src.distribute_pressure = TANK_MIN_RELEASE_PRESSURE
			else if(text2num(tgui_pressure) != null)
				pressure = text2num(tgui_pressure)
			src.distribute_pressure = min(max(floor(src.distribute_pressure), 0), TANK_MAX_RELEASE_PRESSURE)
			. = TRUE

		if("valve")
			if(istype(loc,/mob/living/carbon))
				var/mob/living/carbon/location = loc
				if(location.internal == src)
					location.internal = null
					to_chat(usr, SPAN_NOTICE("You close the tank release valve."))
				else
					if(location.wear_mask && (location.wear_mask.flags_inventory & ALLOWINTERNALS))
						location.internal = src
						to_chat(usr, SPAN_NOTICE("You open \the [src]'s valve."))
					else
						to_chat(usr, SPAN_NOTICE("You need something to connect to \the [src]."))
				. = TRUE

/obj/item/tank/return_air()
	return list(gas_type, temperature, pressure)

/obj/item/tank/return_pressure()
	return pressure

/obj/item/tank/return_temperature()
	return temperature

/obj/item/tank/return_gas()
	return gas_type
