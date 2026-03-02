#define FIRE_MODE_INCENDIARY "Incendiary"
#define FIRE_MODE_EXPLOSIVE "Impact-Explosive"

/obj/item/weapon/gun/energy/yautja/plasmacarbine
	name = "plasma carbine"
	desc = "A short-barreled rapid-fire assault weapon only given to military caste soldiers, unsuitable for hunting actual prey. Features a deadly burst-fire mode, alongside incendiary or impact-explosive rounds."
	icon_state = "plasmacarbine"
	item_state = "plasmacarbine"
	unacidable = TRUE
	fire_sound = 'sound/weapons/pred_plasma_shot.ogg'
	ammo = /datum/ammo/energy/yautja/rifle/bolt
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	// total capacity
	var/charge_time = 50
	// charge drained per shot, double for explosive bolts
	var/shot_cost = 1
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR|TWOHANDED

/obj/item/weapon/gun/energy/yautja/plasmacarbine/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/energy/yautja/plasmacarbine/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/energy/yautja/plasmacarbine/process()
	if(charge_time < 50)
		charge_time++
		if(charge_time == 49)
			if(ismob(loc))
				to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))

/obj/item/weapon/gun/energy/yautja/plasmacarbine/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_9
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/yautja/plasmacarbine/get_examine_text(mob/user)
	if(isyautja(user))
		. = ..()
		. += SPAN_NOTICE("It currently has <b>[charge_time]/50</b> charge.")

		if(mode == FIRE_MODE_EXPLOSIVE)
			. += SPAN_RED("It is set to fire impact-explosive plasma bolts.")
		else
			. += SPAN_ORANGE("It is set to fire incendiary plasma bolts.")
	else
		. = list()
		. += SPAN_NOTICE("This thing looks like a rifle, but there's no mag or proper barrel. What the hell is it?")

/obj/item/weapon/gun/energy/yautja/plasmacarbine/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("The weapon beeps and refuses to fire. Must be some sort of fancy grip safety!"))
		return
	else
		return ..()

/obj/item/weapon/gun/energy/yautja/plasmacarbine/load_into_chamber()
	if(charge_time < 1)
		return
	var/obj/projectile/projectile = create_bullet(ammo, initial(name))
	projectile.set_light(1)
	in_chamber = projectile
	charge_time -= shot_cost
	return in_chamber

/obj/item/weapon/gun/energy/yautja/plasmacarbine/has_ammunition()
	if(charge_time >= 1)
		return TRUE

/obj/item/weapon/gun/energy/yautja/plasmacarbine/reload_into_chamber()
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmacarbine/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		charge_time += shot_cost
		log_debug("Plasma Carbine refunded shot.")
	return TRUE

/obj/item/weapon/gun/energy/yautja/plasmacarbine/use_unique_action()
	switch(mode)
		if(FIRE_MODE_INCENDIARY)
			mode = FIRE_MODE_EXPLOSIVE
			shot_cost = 2 // double cost
			fire_delay = FIRE_DELAY_TIER_6
			to_chat(usr, SPAN_NOTICE("[src] will now fire impact-explosive plasma bolts."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/caster/bolt/single_lethal] // explodes on impact, harmless if it hits terrain

		if(FIRE_MODE_EXPLOSIVE)
			mode = FIRE_MODE_INCENDIARY
			shot_cost = 1
			fire_delay = FIRE_DELAY_TIER_8
			to_chat(usr, SPAN_NOTICE("[src] will now fire incendiary plasma bolts."))
			ammo = GLOB.ammo_list[/datum/ammo/energy/yautja/rifle/bolt] // high ap and incendiary, but lower damage than the impact-explosive

#undef FIRE_MODE_INCENDIARY
#undef FIRE_MODE_EXPLOSIVE

/obj/item/weapon/gun/energy/yautja/cannon
	name = "dual plasma cannons"
	desc = "A pair of powerful, shoulder-mounted energy weapons that are remotely operated via bracers. Unlike normal plasma casters, they only feature one fire mode."
	icon_state = "plasma_cannons"
	item_state = "plasma_cannons"
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/suit_storage.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/hunter/suit_storage.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi'
	)
	fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
	ammo = /datum/ammo/energy/yautja/caster/bolt/single_stun
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MAGENTA
	w_class = SIZE_HUGE
	force = 0
	fire_delay = 3
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_item = NOBLUDGEON|IGNITING_ITEM
	flags_gun_features = GUN_UNUSUAL_DESIGN

	var/obj/item/clothing/gloves/yautja/hunter/source = null
	charge_cost = 200

	var/obj/effect/ebeam/plasma_beam_type = /obj/effect/ebeam/laser/plasma_lance // hitscan! shaboomboom!

/obj/item/weapon/gun/energy/yautja/cannon/Initialize(mapload)
	. = ..()
	icon_state = "plasma_cannons"
	item_state = "plasma_cannons"
	. = ..()
	source = loc
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/verb/use_unique_action

/obj/item/weapon/gun/energy/yautja/cannon/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_6)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + FIRE_DELAY_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/yautja/cannon/dropped(mob/living/carbon/human/M)
	playsound(M, 'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
	to_chat(M, SPAN_NOTICE("You deactivate your plasma cannons."))
	update_mouse_pointer(M, FALSE)

	var/datum/action/predator_action/bracer/caster/caster_action
	for(caster_action as anything in M.actions)
		if(istypestrict(caster_action, /datum/action/predator_action/bracer/caster))
			caster_action.update_button_icon(FALSE)
			break

	if(source)
		forceMove(source)
		source.caster_deployed = FALSE
	..()

/obj/item/weapon/gun/energy/yautja/cannon/able_to_fire(mob/user)
	if(!source)
		return
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return
	return ..()

/obj/item/weapon/gun/energy/yautja/cannon/load_into_chamber(mob/user)
	if(source.drain_power(user, charge_cost))
		in_chamber = create_bullet(ammo, initial(name))
		return in_chamber

/obj/item/weapon/gun/energy/yautja/cannon/has_ammunition()
	if(source?.charge >= charge_cost)
		return TRUE

/obj/item/weapon/gun/energy/yautja/cannon/reload_into_chamber()
	return TRUE

/obj/item/weapon/gun/energy/yautja/cannon/delete_bullet(obj/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund)
		source.charge += charge_cost
		var/perc = source.charge / source.charge_max * 100
		var/mob/living/carbon/human/user = usr
		user.update_power_display(perc)
	return TRUE

/obj/item/weapon/gun/energy/yautja/cannon/handle_fire(atom/target, mob/living/user)
	var/datum/beam/plasma_lance
	if(!has_ammunition)
		click_empty(user)
		return
	plasma_lance = target.beam(user, "light_beam", 'icons/effects/beam.dmi', time = 0.7 SECONDS, maxdistance = 30, beam_type = plasma_beam_type, always_turn = TRUE)
	animate(plasma_lance.visuals, alpha = 255, time = 0.7 SECONDS, color = COLOR_PURPLE, luminosity = 3 , easing = SINE_EASING|EASE_OUT) // imaginary technique: hollow purple
	. = ..() // fire the hitscan bolt after visualizing the death beam
