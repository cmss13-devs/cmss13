/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/items/lighting.dmi'
	icon_state = "flashlight"
	item_state = "flashlight"
	w_class = SIZE_SMALL
	flags_atom = FPRINT|CONDUCT
	flags_equip_slot = SLOT_WAIST

	matter = list("metal" = 50,"glass" = 20)

	light_range = 5
	light_power = 1
	ground_offset_x = 2
	ground_offset_y = 6

	actions_types = list(/datum/action/item_action)
	var/on = FALSE
	var/raillight_compatible = TRUE //Can this be turned into a rail light ?
	var/toggleable = TRUE

	var/can_be_broken = TRUE //can xenos swipe at this to break it/turn it off?
	var/breaking_sound = 'sound/handling/click_2.ogg' //sound used when this happens

/obj/item/device/flashlight/Initialize()
	. = ..()
	update_icon()
	set_light_on(on)

/obj/item/device/flashlight/update_icon()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)

/obj/item/device/flashlight/animation_spin(speed = 5, loop_amount = -1, clockwise = TRUE, sections = 3, angular_offset = 0, pixel_fuzz = 0)
	clockwise = pick(TRUE, FALSE)
	angular_offset = rand(360)
	return ..()

/obj/item/device/flashlight/proc/update_brightness(mob/user = null)
	if(on)
		set_light_range(light_range)
		set_light_on(TRUE)
		update_icon()
	else
		set_light_on(FALSE)

/obj/item/device/flashlight/attack_self(mob/user)
	..()

	if(!toggleable)
		to_chat(user, SPAN_WARNING("You cannot toggle \the [src.name] on or off."))
		return FALSE

	if(!isturf(user.loc))
		to_chat(user, SPAN_WARNING("You cannot turn the light [on ? "off" : "on"] while in [user.loc].")) //To prevent some lighting anomalies.
		return FALSE

	on = !on
	set_light_on(on)
	update_icon()
	for(var/X in actions)
		var/datum/action/A = X
		A.update_button_icon()

	return TRUE

/obj/item/device/flashlight/proc/turn_off_light(mob/bearer)
	if(on)
		on = FALSE
		set_light_on(on)
		update_icon()
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
		return 1
	return 0

/obj/item/device/flashlight/attackby(obj/item/I as obj, mob/user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER))
		if(!raillight_compatible) //No fancy messages, just no
			return
		if(on)
			to_chat(user, SPAN_WARNING("Turn off [src] first."))
			return
		if(isstorage(loc))
			var/obj/item/storage/S = loc
			S.remove_from_storage(src)
		if(loc == user)
			user.drop_inv_item_on_ground(src) //This part is important to make sure our light sources update, as it calls dropped()
		var/obj/item/attachable/flashlight/F = new(src.loc)
		user.put_in_hands(F) //This proc tries right, left, then drops it all-in-one.
		to_chat(user, SPAN_NOTICE("You modify [src]. It can now be mounted on a weapon."))
		to_chat(user, SPAN_NOTICE("Use a screwdriver on [F] to change it back."))
		qdel(src) //Delete da old flashlight
		return
	else
		..()

/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_selected == "eyes")

		if((user.getBrainLoss() >= 60) && prob(50)) //too dumb to use flashlight properly
			return ..() //just hit them in the head

		if((!ishuman(user) || SSticker) && SSticker.mode.name != "monkey") //don't have dexterity
			to_chat(user, SPAN_NOTICE("You don't have the dexterity to do this!"))
			return

		var/mob/living/carbon/human/H = M //mob has protective eyewear
		if(ishuman(H) && ((H.head && H.head.flags_inventory & COVEREYES) || (H.wear_mask && H.wear_mask.flags_inventory & COVEREYES) || (H.glasses && H.glasses.flags_inventory & COVEREYES)))
			to_chat(user, SPAN_NOTICE("You're going to need to remove that [(H.head && H.head.flags_inventory & COVEREYES) ? "helmet" : (H.wear_mask && H.wear_mask.flags_inventory & COVEREYES) ? "mask": "glasses"] first."))
			return

		if(M == user) //they're using it on themselves
			M.flash_eyes()
			M.visible_message(SPAN_NOTICE("[M] directs [src] to \his eyes."), \
							SPAN_NOTICE("You wave the light in front of your eyes! Trippy!"))
			return

		user.visible_message(SPAN_NOTICE("[user] directs [src] to [M]'s eyes."), \
							SPAN_NOTICE("You direct [src] to [M]'s eyes."))

		if(istype(M, /mob/living/carbon/human)) //robots and aliens are unaffected
			if(M.stat == DEAD || M.sdisabilities & DISABILITY_BLIND) //mob is dead or fully blind
				to_chat(user, SPAN_NOTICE("[M] pupils does not react to the light!"))
			else //they're okay!
				M.flash_eyes()
				to_chat(user, SPAN_NOTICE("[M]'s pupils narrow."))
	else
		return ..()

/obj/item/device/flashlight/attack_alien(mob/living/carbon/xenomorph/M)
	. = ..()

	if(on && can_be_broken)
		if(breaking_sound)
			playsound(src.loc, breaking_sound, 25, 1)
		turn_off_light()

/obj/item/device/flashlight/on
	on = TRUE

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	flags_atom = FPRINT|CONDUCT
	light_range = 2
	w_class = SIZE_TINY
	raillight_compatible = 0

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = ""
	light_range = 2
	w_class = SIZE_TINY
	raillight_compatible = 0

//The desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	item_state = "lamp"
	light_range = 5
	w_class = SIZE_LARGE
	on = 0
	raillight_compatible = 0

	breaking_sound = 'sound/effects/Glasshit.ogg'

/obj/item/device/flashlight/lamp/on
	on = TRUE

//Menorah!
/obj/item/device/flashlight/lamp/menorah
	name = "Menorah"
	desc = "For celebrating Chanukah."
	icon_state = "menorah"
	item_state = "menorah"
	light_range = 2
	w_class = SIZE_LARGE
	on = 1
	breaking_sound = null

//Generic Candelabra
/obj/item/device/flashlight/lamp/candelabra
	name = "candelabra"
	desc = "A fire hazard that can be used to thwack things with impunity."
	icon_state = "candelabra"
	force = 15
	on = TRUE

	breaking_sound = null

//Green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	item_state = "lampgreen"
	light_range = 5

/obj/item/device/flashlight/lamp/tripod
	name = "tripod lamp"
	desc = "An emergency light tube mounted onto a tripod. It seemingly lasts forever."
	icon_state = "tripod_lamp"
	light_range = 6//pretty good
	w_class = SIZE_LARGE
	on = 1

/obj/item/device/flashlight/lamp/tripod/grey
	icon_state = "tripod_lamp_grey"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(istype(usr, /mob/living/carbon/xenomorph)) //Sneaky xenos turning off the lights
		attack_alien(usr)
		return

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red USCM issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	w_class = SIZE_SMALL
	light_power = 2
	light_range = 5
	icon_state = "flare"
	item_state = "flare"
	actions = list() //just pull it manually, neckbeard.
	raillight_compatible = 0
	can_be_broken = FALSE
	var/burnt_out = FALSE
	var/fuel = 0
	var/fuel_rate = AMOUNT_PER_TIME(1 SECONDS, 1 SECONDS)
	var/on_damage = 7
	var/ammo_datum = /datum/ammo/flare

	/// Whether to use flame overlays for this flare type
	var/show_flame = TRUE
	/// Tint for the greyscale flare flame
	var/flame_tint = "#ffcccc"
	/// Color correction, added to the whole flame overlay
	var/flame_base_tint = "#ff0000"
	// "But, why are there two colors?"
	// The flame_tint is applied multiplicatively to the greyscale animation
	// However it represents levels within the flame, not the color of the flame as a whole.
	// To get around this, we additively apply flame_base_tint for coloring.

/obj/item/device/flashlight/flare/Initialize()
	. = ..()
	fuel = rand(9.5 MINUTES, 10.5 MINUTES)
	set_light_color(flame_tint)

/obj/item/device/flashlight/flare/update_icon()
	overlays?.Cut()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(show_flame)
			var/image/flame = image('icons/obj/items/lighting.dmi', src, "flare_flame")
			flame.color = flame_tint
			flame.appearance_flags = KEEP_APART|RESET_COLOR|RESET_TRANSFORM
			var/image/flame_base = image('icons/obj/items/lighting.dmi', src, "flare_flame")
			flame_base.color = flame_base_tint
			flame_base.appearance_flags = KEEP_APART|RESET_COLOR
			flame_base.blend_mode = BLEND_ADD
			flame.overlays += flame_base
			overlays += flame
	else if(burnt_out)
		icon_state = "[initial(icon_state)]-empty"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/device/flashlight/flare/dropped(mob/user)
	. = ..()
	if(iscarbon(user) && on)
		var/mob/living/carbon/flare_user = user
		flare_user.toggle_throw_mode(THROW_MODE_OFF)

/obj/item/device/flashlight/flare/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/flashlight/flare/process(delta_time)
	fuel -= fuel_rate * delta_time
	if(fuel <= 0 || !on)
		burn_out()

// Causes flares to stop with a rotation offset for visual purposes
/obj/item/device/flashlight/flare/animation_spin(speed = 5, loop_amount = -1, clockwise = TRUE, sections = 3, angular_offset = 0, pixel_fuzz = 0)
	pixel_fuzz = 16
	return ..()
/obj/item/device/flashlight/flare/pickup()
	if(transform)
		apply_transform(matrix()) // reset rotation
	pixel_x = 0
	pixel_y = 0
	return ..()

/obj/item/device/flashlight/flare/proc/burn_out()
	turn_off()
	fuel = 0
	burnt_out = TRUE
	update_icon()
	add_to_garbage(src)
	STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/proc/turn_on()
	on = TRUE
	heat_source = 1500
	update_brightness()
	force = on_damage
	damtype = "fire"
	START_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = FALSE
	heat_source = 0
	force = initial(force)
	damtype = initial(damtype)
	if(ismob(loc))
		var/mob/U = loc
		update_brightness(U)
	else
		update_brightness(null)

/obj/item/device/flashlight/flare/attack_self(mob/living/user)

	// Usual checks
	if(!fuel)
		to_chat(user, SPAN_NOTICE("It's out of fuel."))
		return FALSE
	if(on)
		if(!do_after(user, 2.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		if(!on)
			return
		var/hand = user.hand ? "l_hand" : "r_hand"
		user.visible_message(SPAN_WARNING("[user] snuffs out [src]."),\
		SPAN_WARNING("You snuff out [src], singing your hand."))
		user.apply_damage(7, BURN, hand)
		burn_out()
		//TODO: add snuff out sound so guerilla CLF snuffing flares get noticed
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message(SPAN_NOTICE("[user] activates the flare."), SPAN_NOTICE("You pull the cord on the flare, activating it!"))
		playsound(src,'sound/handling/flare_activate_2.ogg', 50, 1) //cool guy sound
		turn_on()
		var/mob/living/carbon/U = user
		if(istype(U) && !U.throw_mode)
			U.toggle_throw_mode(THROW_MODE_NORMAL)

/obj/item/device/flashlight/flare/proc/activate_signal(mob/living/carbon/human/user)
	return

/obj/item/device/flashlight/flare/on/Initialize()
	. = ..()
	turn_on()

/// Flares deployed by a flare gun
/obj/item/device/flashlight/flare/on/gun

//Special flare subtype for the illumination flare shell
//Acts like a flare, just even stronger, and set length
/obj/item/device/flashlight/flare/on/illumination
	name = "illumination flare"
	desc = "It's really bright, and unreachable."
	icon_state = "" //No sprite
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	show_flame = FALSE

/obj/item/device/flashlight/flare/on/illumination/Initialize()
	. = ..()
	fuel = rand(4.5 MINUTES, 5.5 MINUTES) // Half the duration of a flare, but justified since it's invincible

/obj/item/device/flashlight/flare/on/illumination/update_icon()
	return

/obj/item/device/flashlight/flare/on/illumination/turn_off()
	..()
	qdel(src)

/obj/item/device/flashlight/flare/on/illumination/ex_act(severity)
	return //Nope

/obj/item/device/flashlight/flare/on/starshell_ash
	name = "burning star shell ash"
	desc = "Bright burning ash from a Star Shell 40mm. Don't touch, or it'll burn ya'."
	icon_state = "starshell_ash"
	anchored = TRUE//can't be picked up
	ammo_datum = /datum/ammo/flare/starshell
	show_flame = FALSE

/obj/item/device/flashlight/flare/on/starshell_ash/Initialize(mapload, ...)
	if(mapload)
		return INITIALIZE_HINT_QDEL
	. = ..()
	fuel = rand(30 SECONDS,	60 SECONDS)

/obj/item/device/flashlight/flare/on/illumination/chemical
	name = "chemical light"
	light_range = 0

/obj/item/device/flashlight/flare/on/illumination/chemical/Initialize(mapload, amount)
	. = ..()
	light_range = floor(amount * 0.04)
	if(!light_range)
		return INITIALIZE_HINT_QDEL
	set_light(light_range)
	fuel = amount * 5 SECONDS

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime"
	desc = "A glowing ball of what appears to be amber."
	icon = 'icons/obj/items/lighting.dmi'
	// not a slime extract sprite but... something close enough!
	icon_state = "floor1"
	item_state = "slime"
	w_class = SIZE_TINY
	light_range = 6
	// Bio-luminesence has one setting, on.
	on = TRUE
	raillight_compatible = FALSE
	// Bio-luminescence does not toggle.
	toggleable = FALSE

/obj/item/device/flashlight/slime/Initialize()
	. = ..()
	set_light(light_range)
	update_brightness()
	icon_state = initial(icon_state)

//******************************Lantern*******************************/

/obj/item/device/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	light_range = 6 // luminosity when on

//Signal Flare
/obj/item/device/flashlight/flare/signal
	name = "signal flare"
	desc = "A green USCM issued signal flare. The telemetry computer works on chemical reaction that releases smoke and light and thus works only while the flare is burning."
	icon_state = "cas_flare"
	item_state = "cas_flare"
	layer = ABOVE_FLY_LAYER
	ammo_datum = /datum/ammo/flare/signal
	var/faction = ""
	var/datum/cas_signal/signal
	var/activate_message = TRUE
	flame_base_tint = "#00aa00"
	flame_tint = "#aaccaa"

/obj/item/device/flashlight/flare/signal/Initialize()
	. = ..()
	fuel = rand(160 SECONDS, 200 SECONDS)

/obj/item/device/flashlight/flare/signal/attack_self(mob/living/carbon/human/user)
	if(!istype(user))
		return

	. = ..()

	if(.)
		faction = user.faction
		addtimer(CALLBACK(src, PROC_REF(activate_signal), user), 5 SECONDS)

/obj/item/device/flashlight/flare/signal/activate_signal(mob/living/carbon/human/user)
	..()
	if(faction && GLOB.cas_groups[faction])
		signal = new(src)
		signal.target_id = ++GLOB.cas_tracking_id_increment
		name = "[user.assigned_squad ? user.assigned_squad.name : "X"]-[signal.target_id] flare"
		signal.name = name
		signal.linked_cam = new(loc, name)
		GLOB.cas_groups[user.faction].add_signal(signal)
		anchored = TRUE
		if(activate_message)
			visible_message(SPAN_DANGER("[src]'s flame reaches full strength. It's fully active now."), null, 5)
		var/turf/target_turf = get_turf(src)
		msg_admin_niche("Flare target [src] has been activated by [key_name(user, 1)] at ([target_turf.x], [target_turf.y], [target_turf.z]). (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[target_turf.x];Y=[target_turf.y];Z=[target_turf.z]'>JMP LOC</a>)")
		log_game("Flare target [src] has been activated by [key_name(user, 1)] at ([target_turf.x], [target_turf.y], [target_turf.z]).")
		return TRUE

/obj/item/device/flashlight/flare/signal/attack_hand(mob/user)
	if (!user) return

	if(anchored)
		to_chat(user, "[src] is too hot. You will burn your hand if you pick it up.")
		return
	..()

/obj/item/device/flashlight/flare/signal/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(signal)
		GLOB.cas_groups[faction].remove_signal(signal)
		QDEL_NULL(signal)
	return ..()

/obj/item/device/flashlight/flare/signal/turn_off()
	anchored = FALSE
	if(signal)
		GLOB.cas_groups[faction].remove_signal(signal)
		qdel(signal)
	..()

/// Signal flares deployed by a flare gun
/obj/item/device/flashlight/flare/signal/gun
	activate_message = FALSE

/obj/item/device/flashlight/flare/signal/gun/activate_signal(mob/living/carbon/human/user)
	turn_on()
	faction = user.faction
	return ..()

/obj/item/device/flashlight/flare/signal/debug
	name = "debug signal flare"
	desc = "A signal flare used to test CAS runs. If you're seeing this, someone messed up."

/obj/item/device/flashlight/flare/signal/debug/Initialize()
	. = ..()
	fuel = INFINITY
	return INITIALIZE_HINT_ROUNDSTART

/obj/item/device/flashlight/flare/signal/debug/LateInitialize()
	activate_signal()

/obj/item/device/flashlight/flare/signal/debug/activate_signal()
	turn_on()
	faction = FACTION_MARINE
	signal = new(src)
	signal.target_id = ++GLOB.cas_tracking_id_increment
	name += " [rand(100, 999)]"
	signal.name = name
	signal.linked_cam = new(loc, name)
	GLOB.cas_groups[FACTION_MARINE].add_signal(signal)
	anchored = TRUE
