//most code (and the sound) stolen from https://github.com/tgstation/TerraGov-Marine-Corps/pull/5811, thank you BraveMole

#define NO_FUEL 0
#define FUELED 1
#define KABOOM 2

#define FUEL_USAGE 9 //minus oxidizer level

#define EXPLOSIVE_PROPERTIES list(PROPERTY_FUELING, PROPERTY_FLOWING, PROPERTY_VISCOUS, PROPERTY_EXPLOSIVE)

/obj/item/hoverpack
	name = "experimental hoverpack"
	desc = "This prototype hoverpack allows marines to quickly jump over to strategic locations on the battlefield, at the cost of their backpack. You think you could change the settings with a screwdriver."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "hoverpack"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK
	actions_types = list(/datum/action/item_action/hover)
	var/hover_cooldown = 7.5 SECONDS
	/// If you can use it, used for cooldowns.
	var/can_hover = TRUE

	// These vars change in attackby().
	var/fuel_multiplier = 1
	///How quick you will fly
	var/speed = 5
	///How many tiles you can leap to at once.
	var/max_distance = 4

	/// Reservoir that stores the reagents that fuel the propellant for the hoverpack. Or something like that..
	var/obj/item/reagent_container/glass/beaker/reservoir/reservoir

	var/last_fuel

/obj/item/hoverpack/Initialize(mapload, ...)
	. = ..()
	reservoir = new()
	reservoir.reagents.add_reagent("oxidizing_agent", 90) //Start with a custom agent. Enterprising marines and researchers/doctors can theoretically boost the formula, or you could refuel it with beer or basic oxygen.
	reservoir.name = "internal propellant tank"
	update_icon()

/obj/item/hoverpack/update_icon()
	overlays.Cut()
	. = ..()
	if(!can_hover || !reservoir.reagents.total_volume)
		return
	var/image/I = image(icon, "+[icon_state]_charged")
	overlays += I

/obj/item/hoverpack/attack_self(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("You start dumping the contents of [src]'s reservoir..."))
	if(!do_after(user, 5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return
	to_chat(user, SPAN_NOTICE("You dump the contents of [src]'s reservoir."))
	reservoir.reagents.clear_reagents()
	update_icon()

/obj/item/hoverpack/afterattack(obj/item/W, mob/user)
	if(W.is_open_container())
		reservoir.afterattack(W, user, TRUE)

/obj/item/hoverpack/attackby(obj/item/W, mob/user)
	if(HAS_TRAIT(W, TRAIT_TOOL_SCREWDRIVER))
		var/input = tgui_input_list(user, "Change the air canister's pressure?", "Select an intensity level", list("Strong (Dash)", "Normal (Jump)", "Weak (Leap)"))
		if(!input)
			return
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, TRUE)
		switch(input)
			if("Strong (Dash)")
				speed = 6
				max_distance = 2
				fuel_multiplier = 1
				hover_cooldown = 5 SECONDS
			if("Normal (Jump)")
				speed = 5
				max_distance = 4
				fuel_multiplier = 1
				hover_cooldown = 7.5 SECONDS
			if("Weak (Leap)")
				speed = 3
				max_distance = 6
				fuel_multiplier = 0.75
				hover_cooldown = 10 SECONDS

		to_chat(user, SPAN_NOTICE("You set the hoverpack's pressure output to [input]."))

	else if(W.is_open_container())
		W.afterattack(reservoir, user, TRUE)

	else
		..()

/obj/item/hoverpack/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("A meter next to the tank intake indicates it has [round(reservoir.reagents.total_volume/reservoir.reagents.maximum_volume * 100, 0.1)]% propellant left. You see on a readout:")
	. += SPAN_BOLDNOTICE(" DISTANCE: [max_distance] METERS <br/> SPEED: [speed] METERS PER SECOND <br/> USAGE: [fuel_multiplier * 100]% PROPELLANT USAGE <br/> COOLDOWN: [hover_cooldown * 0.1] SECONDS")

/obj/item/hoverpack/proc/expend_fuel(mob/user) //jesus
	if(!reservoir.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("\The [reservoir] is empty!"))
		return NO_FUEL
	var/datum/chem_property/OP
	var/boom_chance = 0
	for(var/datum/reagent/FR as anything in reservoir.reagents.reagent_list)
		for(var/datum/chem_property/P as anything in FR.properties)
			if(P.name in EXPLOSIVE_PROPERTIES)
				boom_chance += P.level // If the reagent is explosive, risk blowing up.

			if(P.name == PROPERTY_OXIDIZING)
				if(P.level > OP?.level)
					OP = P

	if(prob(boom_chance))
		to_chat(user, SPAN_DANGER("Something feels wrong..."))
		return KABOOM

	if(!OP)
		to_chat(user, SPAN_NOTICE("\The [src] makes a clanking noise. You think you put the wrong stuff inside."))
		return NO_FUEL

	var/reduction_modifier = OP.level
	var/final_expense = (FUEL_USAGE - reduction_modifier) * fuel_multiplier
	reservoir.reagents.remove_reagent(OP.holder.id, final_expense)
	last_fuel = final_expense
	return FUELED

/obj/item/hoverpack/proc/hover(mob/living/carbon/human/user, atom/A)
	var/result = can_use_hoverpack(user)

	if( !A || A.layer >= FLY_LAYER)
		return

	if(result == NO_FUEL)
		return

	can_hover = FALSE

	if(result == KABOOM) //oh boy
		user.visible_message(SPAN_HIGHDANGER("A weird groaning sound emerges from [user]'s [src.name]..."))
		color = COLOR_RED
		do_after(user, 3 SECONDS, INTERRUPT_NONE, BUSY_ICON_HOSTILE, src, INTERRUPT_NONE, BUSY_ICON_HOSTILE)
		src.visible_message(SPAN_HIGHDANGER("[src] explodes!"))
		var/datum/cause_data/cause_data = create_cause_data("hoverpack explosion", user)
		INVOKE_ASYNC(GLOBAL_PROC, TYPE_PROC_REF(/atom, cell_explosion), get_turf(src), 90, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, user.dir, cause_data)
		color = initial(color)
		addtimer(CALLBACK(src, PROC_REF(end_cooldown), user), hover_cooldown)
		return

	var/fuel_used = FUEL_USAGE
	if(last_fuel)
		fuel_used = last_fuel

	to_chat(user, SPAN_BOLDNOTICE(" PROPELLANT EXPENDED: [round(fuel_used/reservoir.reagents.maximum_volume * 100, 0.1)]% <br> PROPELLANT REMAINING: [round(reservoir.reagents.total_volume/reservoir.reagents.maximum_volume * 100, 0.1)]%"))
	update_icon()
	playsound(user, 'sound/items/jetpack_sound.ogg', 45, TRUE)

	var/turf/t_turf = get_turf(A)
	var/obj/effect/warning/hover/warning = new(t_turf)
	calculate_warning_turf(warning, user, t_turf)

	//has sleep
	RegisterSignal(user, COMSIG_CLIENT_MOB_MOVE, PROC_REF(disable_flying_movement))
	user.throw_atom(t_turf, max_distance, speed, launch_type = HIGH_LAUNCH)
	UnregisterSignal(user, COMSIG_CLIENT_MOB_MOVE)
	qdel(warning)
	last_fuel = null
	addtimer(CALLBACK(src, PROC_REF(end_cooldown), user), hover_cooldown)

/obj/item/hoverpack/proc/disable_flying_movement(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	return COMPONENT_OVERRIDE_MOVE

/obj/item/hoverpack/proc/end_cooldown(mob/living/carbon/human/user)
	can_hover = TRUE
	update_icon()
	playsound(src, 'sound/items/jetpack_beep.ogg', 60, FALSE)

/obj/item/hoverpack/proc/calculate_warning_turf(obj/effect/warning/warning, mob/living/user, turf/t_turf)
	var/t_dist = get_dist(user, t_turf)
	if(!(t_dist > max_distance))
		return
	var/list/turf/path = get_line(user, t_turf, FALSE)
	warning.forceMove(path[max_distance])

/obj/item/hoverpack/proc/can_use_hoverpack(mob/living/carbon/human/user)
	if(user.is_mob_incapacitated())
		to_chat(user, SPAN_WARNING("You're a bit too incapacitated for that."))
		return FALSE

	if(!can_hover)
		to_chat(user, SPAN_WARNING("You cannot use the hoverpack yet!"))
		return FALSE

	return expend_fuel(user)

/datum/action/item_action/hover/New(mob/living/user, obj/item/holder)
	..()
	name = "Use Hoverpack"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "hoverpack_charged")
	button.overlays += IMG

/datum/action/item_action/hover/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(!H.is_mob_incapacitated() && holder_item == H.back)
		return TRUE

/datum/action/item_action/hover/action_activate()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		H.selected_ability = null
	else
		to_chat(H, "You will now use [name] with \
			[H.client && H.client.prefs && H.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.selected_ability = null
		button.icon_state = "template_on"
		H.selected_ability = src

/datum/action/item_action/hover/update_button_icon()
	var/obj/item/hoverpack/HP = holder_item
	button.overlays.Cut()
	var/image/IMG
	if(!HP.can_hover)
		button.color = rgb(120,120,120,200)
		IMG = image('icons/mob/hud/actions.dmi', button, "hoverpack")
	else
		button.color = rgb(255,255,255,255)
		IMG = image('icons/mob/hud/actions.dmi', button, "hoverpack_charged")
	button.overlays += IMG

/datum/action/item_action/hover/proc/use_ability(atom/A)
	var/mob/living/carbon/human/H = owner
	var/obj/item/hoverpack/HP = holder_item
	HP.hover(H, A)
	update_button_icon()
	addtimer(CALLBACK(src, PROC_REF(update_button_icon)), HP.hover_cooldown)

/datum/action/item_action/hover/remove_from(mob/living/carbon/human/H)
	..()
	if(H.selected_ability == src)
		H.selected_ability = null
		update_button_icon()
		button.icon_state = "template"

/obj/item/reagent_container/glass/beaker/reservoir
	name = "internal propellant tank"
	desc = "You shouldn't be able to see this"
	volume = 90
	amount_per_transfer_from_this = 10


#undef NO_FUEL
#undef FUELED
#undef KABOOM
#undef FUEL_USAGE
#undef EXPLOSIVE_PROPERTIES
