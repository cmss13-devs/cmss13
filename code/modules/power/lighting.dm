// The lighting system
//
// consists of light fixtures (/obj/structure/machinery/light) and light tube/bulb items (/obj/item/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3



/obj/structure/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	layer = FLY_LAYER
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/structure/machinery/light/newlight = null

/obj/structure/machinery/light_construct/Initialize()
	. = ..()
	if (fixture_type == "bulb")
		icon_state = "bulb-construct-stage1"

/obj/structure/machinery/light_construct/examine(mob/user)
	..()
	switch(stage)
		if(1)
			to_chat(user, "It's an empty frame.")
		if(2)
			to_chat(user, "It's wired.")
		if(3)
			to_chat(user, "The casing is closed.")


/obj/structure/machinery/light_construct/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/tool/wrench))
		if (src.stage == 1)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 25, 1)
			to_chat(usr, "You begin deconstructing [src].")
			if (!do_after(usr, 30, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
				return
			new /obj/item/stack/sheet/metal( get_turf(src.loc), sheets_refunded )
			user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 25, 1)
			qdel(src)
		if (src.stage == 2)
			to_chat(usr, "You have to remove the wires first.")
			return

		if (src.stage == 3)
			to_chat(usr, "You have to unscrew the case first.")
			return

	if(istype(W, /obj/item/tool/wirecutters))
		if (src.stage != 2) return
		src.stage = 1
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage1"
			if("bulb")
				src.icon_state = "bulb-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message("[user.name] removes the wiring from [src].", \
			"You remove the wiring from [src].", "You hear a noise.")
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
		return

	if(istype(W, /obj/item/stack/cable_coil))
		if (src.stage != 1) return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-construct-stage2"
				if("bulb")
					src.icon_state = "bulb-construct-stage2"
			src.stage = 2
			user.visible_message("[user.name] adds wires to [src].", \
				"You add wires to [src].")
		return

	if(istype(W, /obj/item/tool/screwdriver))
		if (src.stage == 2)
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-empty"
				if("bulb")
					src.icon_state = "bulb-empty"
			src.stage = 3
			user.visible_message("[user.name] closes [src]'s casing.", \
				"You close [src]'s casing.", "You hear a noise.")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)

			switch(fixture_type)

				if("tube")
					newlight = new /obj/structure/machinery/light/built(src.loc)
				if ("bulb")
					newlight = new /obj/structure/machinery/light/small/built(src.loc)

			newlight.dir = src.dir
			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/structure/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1

// the standard tube light fixture
/obj/structure/machinery/light
	name = "light fixture"
	icon = 'icons/obj/items/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = FLY_LAYER
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = POWER_CHANNEL_LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	var/on = 0					// 1 if on, 0 if off
	var/on_gs = 0
	var/brightness = 8			// luminosity when on, also used in power calculation
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/light_bulb/tube		// the type of light item
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode

	appearance_flags = TILE_BOUND

// containment lights
/obj/structure/machinery/light/containment
	name = "containment light fixture"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/light/containment/attack_alien(mob/living/carbon/Xenomorph/M)
	return
	

// the smaller bulb light fixture

/obj/structure/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness = 4
	desc = "A small lighting fixture."
	light_type = /obj/item/light_bulb/bulb

/obj/structure/machinery/light/spot
	name = "spotlight"
	fitting = "large tube"
	light_type = /obj/item/light_bulb/tube/large
	brightness = 12

/obj/structure/machinery/light/built/Initialize()
	. = ..()
	status = LIGHT_EMPTY
	update(0)

/obj/structure/machinery/light/small/built/Initialize()
	. = ..()
	status = LIGHT_EMPTY
	update(0)

// create a new lighting fixture
/obj/structure/machinery/light/Initialize()
	. = ..()
	switch(fitting)
		if("tube")
			brightness = 8
			if(prob(2))
				broken(1)
		if("bulb")
			brightness = 4
			if(prob(5))
				broken(1)

	add_timer(CALLBACK(src, .proc/update, 0), 1)

	set_pixel_location()

/obj/structure/machinery/light/set_pixel_location()
	switch(fitting)
		if("tube")
			switch(dir)
				if(NORTH)
					pixel_y = 23
				if(EAST)
					pixel_x = 10
				if(WEST)
					pixel_x = -10
		if("bulb")
			switch(dir)
				if(NORTH)
					pixel_y = 10
				if(SOUTH)
					pixel_y = -10
				if(EAST)
					pixel_x = 10
				if(WEST)
					pixel_x = -10

/obj/structure/machinery/light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
//		A.update_lights()
	SetLuminosity(0)
	. = ..()

/obj/structure/machinery/light/proc/is_broken()
	if(status == LIGHT_BROKEN)
		return 1
	return 0

/obj/structure/machinery/light/update_icon()

	switch(status)		// set icon_states
		if(LIGHT_OK)
			icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
	return

// update the icon_state and luminosity of the light depending on its state
/obj/structure/machinery/light/proc/update(var/trigger = 1)
	SSlighting.lights_current.Add(light)
	update_icon()
	if(on)
		if(luminosity != brightness)
			switchcount++
			if(rigged)
				if(status == LIGHT_OK && trigger)

					message_staff("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else if( prob( min(60, switchcount*switchcount*0.01) ) )
				if(status == LIGHT_OK && trigger)
					status = LIGHT_BURNED
					icon_state = "[base_state]-burned"
					on = 0
					SetLuminosity(0)
			else
				update_use_power(2)
				SetLuminosity(brightness)
	else
		update_use_power(1)
		SetLuminosity(0)

	active_power_usage = (luminosity * 10)
	if(on != on_gs)
		on_gs = on

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/structure/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/structure/machinery/light/examine(mob/user)
	..()
	switch(status)
		if(LIGHT_OK)
			to_chat(user, "It is turned [on? "on" : "off"].")
		if(LIGHT_EMPTY)
			to_chat(user, "The [fitting] has been removed.")
		if(LIGHT_BURNED)
			to_chat(user, "The [fitting] is burnt out.")
		if(LIGHT_BROKEN)
			to_chat(user, "The [fitting] has been smashed.")



// attack with item - insert light (if right type), otherwise try to break the light

/obj/structure/machinery/light/attackby(obj/item/W, mob/user)

	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/light_bulb))
		if(status != LIGHT_EMPTY)
			to_chat(user, "There is a [fitting] already inserted.")
			return
		else
			src.add_fingerprint(user)
			var/obj/item/light_bulb/L = W
			if(istype(L, light_type))
				status = L.status
				to_chat(user, "You insert the [L.name].")
				switchcount = L.switchcount
				rigged = L.rigged
				brightness = L.brightness
				on = has_power()
				update()

				if(user.temp_drop_inv_item(L))
					qdel(L)

					if(on && rigged)

						message_staff("LOG: Rigged light explosion, last touched by [fingerprintslast]")

						explode()
			else
				to_chat(user, "This type of light requires a [fitting].")
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)


		if(prob(1+W.force * 5))

			to_chat(user, "You hit the light, and it smashes!")
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags_atom & CONDUCT))
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			to_chat(user, "You hit the light!")

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/tool/screwdriver)) //If it's a screwdriver open it.
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")
			var/obj/structure/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/structure/machinery/light_construct(src.loc)
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/structure/machinery/light_construct/small(src.loc)
					newlight.icon_state = "bulb-construct-stage2"
			newlight.dir = src.dir
			newlight.stage = 2
			transfer_fingerprints_to(newlight)
			qdel(src)
			return

		to_chat(user, "You stick \the [W] into the light socket!")
		if(has_power() && (W.flags_atom & CONDUCT))
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))


// returns whether this light has power
// true if area has power and lightswitch is on
/obj/structure/machinery/light/proc/has_power()
	var/area/A = src.loc.loc
	return A.master.lightswitch && A.master.power_light

/obj/structure/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK) break
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/structure/machinery/light/attack_remote(mob/user)
	src.flicker(1)
	return

/obj/structure/machinery/light/AIShiftClick()
	broken()
	return

/obj/structure/machinery/light/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)	return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		to_chat(M, SPAN_WARNING("That object is useless to you."))
		return
	else if (status == LIGHT_OK||status == LIGHT_BURNED)
		for(var/mob/O in viewers(src))
			O.show_message(SPAN_DANGER("[M.name] smashed the light!"), 3, "You hear a tinkle of breaking glass", 2)
		broken()
	return
// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/structure/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		to_chat(user, "There is no [fitting] in this light.")
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			for(var/mob/M in viewers(src))
				M.show_message(SPAN_DANGER("[user.name] smashed the light!"), 3, "You hear a tinkle of breaking glass", 2)
			broken()
			return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))

			if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					prot = (G.max_heat_protection_temperature > 360)
		else
			prot = 1

		if(prot > 0)
			to_chat(user, "You remove the light [fitting]")
		else
			to_chat(user, "You try to remove the light [fitting], but it's too hot and you don't want to burn your hand.")
			return				// if burned, don't remove the light
	else
		to_chat(user, "You remove the light [fitting].")

	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/light_bulb/L = new light_type()
	L.status = status
	L.rigged = rigged
	L.brightness = src.brightness

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()

	if(user.put_in_active_hand(L))	//succesfully puts it in our active hand
		L.add_fingerprint(user)
	else
		L.forceMove(loc) //if not, put it on the ground
	status = LIGHT_EMPTY
	update()

// break the light and make sparks if was on

/obj/structure/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
//		if(on)
//			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
//			s.set_up(3, 1, src)
//			s.start()
	status = LIGHT_BROKEN
	update()

/obj/structure/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	brightness = initial(brightness)
	on = 1
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/structure/machinery/light/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(50))
				broken()
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(75))
				broken()
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
	return

//timed process
//use power
#define LIGHTING_POWER_FACTOR 20		//20W per unit luminosity

/*
/obj/structure/machinery/light/process()//TODO: remove/add this from machines to save on processing as needed ~Carn PRIORITY
	if(on)
		use_power(luminosity * LIGHTING_POWER_FACTOR, LIGHT)
*/

// called when area power state changes
/obj/structure/machinery/light/power_change()
	spawn(10)
		if(loc)
			var/area/A = src.loc.loc
			A = A.master
			seton(A.lightswitch && A.power_light)

// called when on fire

/obj/structure/machinery/light/fire_act(exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

/obj/structure/machinery/light/bullet_act(obj/item/projectile/P)
	src.bullet_ping(P)
	if(P.ammo.damage_type == BRUTE)
		if(P.damage > config.base_hit_damage)
			broken()
		else
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
	return 1

// explode the light

/obj/structure/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/structure/machinery/light of the corresponding type

/obj/item/light_bulb
	icon = 'icons/obj/items/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = SIZE_SMALL
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	matter = list("metal" = 60)
	var/rigged = 0		// true if rigged to explode
	var/brightness = 2 //how much light it gives off

/obj/item/light_bulb/launch_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/light_bulb/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	matter = list("glass" = 100)
	brightness = 8

/obj/item/light_bulb/tube/large
	w_class = SIZE_SMALL
	name = "large light tube"
	brightness = 15

/obj/item/light_bulb/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	matter = list("glass" = 100)
	brightness = 5

/obj/item/light_bulb/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	matter = list("glass" = 100)
	brightness = 5

// update the icon state and description of the light

/obj/item/light_bulb/proc/update()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."


/obj/item/light_bulb/Initialize()
	. = ..()
	switch(name)
		if("light tube")
			brightness = rand(6,9)
		if("light bulb")
			brightness = rand(4,6)
	update()

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/light_bulb/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/structure/machinery/light))
		return
	if(user.a_intent != INTENT_HARM)
		return

	shatter()

/obj/item/light_bulb/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message(SPAN_DANGER("[name] shatters."),SPAN_DANGER("You hear a small glass object shatter."))
		status = LIGHT_BROKEN
		force = 5
		sharp = IS_SHARP_ITEM_SIMPLE
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 25, 1)
		update()

/obj/structure/machinery/landinglight
	name = "landing light"
	icon = 'icons/obj/structures/props/landinglights.dmi'
	icon_state = "landingstripetop"
	desc = "A landing light, if it's flashing stay clear!"
	var/id = "" // ID for landing zone
	anchored = 1
	density = 0
	layer = BELOW_TABLE_LAYER
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20
	power_channel = POWER_CHANNEL_LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	unslashable = TRUE
	unacidable = TRUE

//Don't allow blowing those up, so Marine nades don't fuck them
/obj/structure/machinery/landinglight/ex_act(severity)
	return

/obj/structure/machinery/landinglight/New()
	..()
	turn_off()

/obj/structure/machinery/landinglight/proc/turn_off()
	icon_state = "landingstripe"
	SetLuminosity(0)

/obj/structure/machinery/landinglight/ds1
	id = "USS Almayer Dropship 1" // ID for landing zone

/obj/structure/machinery/landinglight/ds2
	id = "USS Almayer Dropship 2" // ID for landing zone

/obj/structure/machinery/landinglight/proc/turn_on()
	icon_state = "landingstripe0"
	SetLuminosity(2)

/obj/structure/machinery/landinglight/ds1/delayone/turn_on()
	icon_state = "landingstripe1"
	SetLuminosity(2)

/obj/structure/machinery/landinglight/ds1/delaytwo/turn_on()
	icon_state = "landingstripe2"
	SetLuminosity(2)

/obj/structure/machinery/landinglight/ds1/delaythree/turn_on()
	icon_state = "landingstripe3"
	SetLuminosity(2)

/obj/structure/machinery/landinglight/ds2/delayone/turn_on()
	icon_state = "landingstripe1"
	SetLuminosity(2)

/obj/structure/machinery/landinglight/ds2/delaytwo/turn_on()
	icon_state = "landingstripe2"
	SetLuminosity(2)

/obj/structure/machinery/landinglight/ds2/delaythree/turn_on()
	icon_state = "landingstripe3"
	SetLuminosity(2)
