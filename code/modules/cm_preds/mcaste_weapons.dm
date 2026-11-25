#define FIRE_MODE_INCENDIARY "Incendiary"
#define FIRE_MODE_EXPLOSIVE "Impact-Explosive"

/obj/item/weapon/gun/energy/yautja/plasmacarbine
	name = "plasma carbine"
	desc = "A short-barreled rapid-fire assault weapon only given to military caste soldiers, unsuitable for hunting actual prey. Features a deadly burst-fire mode, alongside incendiary or impact-explosive rounds. Although more accurate when wielded, it can be fired with one hand."
	icon_state = "plasmacarbine"
	item_state = "plasmacarbine"
	unacidable = TRUE
	fire_sound = 'sound/weapons/pred_plasma_shot.ogg'
	ammo = /datum/ammo/energy/yautja/rifle/bolt
	flags_equip_slot = SLOT_BACK
	w_class = SIZE_LARGE
	pixel_x = -2
	hud_offset = -2
	// total capacity
	var/charge_time = 40
	// charge drained per shot, double for explosive bolts
	var/shot_cost = 1
	// fire mode - incendiary or explosive
	var/mode = FIRE_MODE_INCENDIARY
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR|TWOHANDED

/obj/item/weapon/gun/energy/yautja/plasmacarbine/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	AddElement(/datum/element/corp_label/dltalt)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag

/obj/item/weapon/gun/energy/yautja/plasmacarbine/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/energy/yautja/plasmacarbine/process()
	if(charge_time < 40)
		charge_time++
		if(charge_time == 39)
			if(ismob(loc))
				to_chat(loc, SPAN_NOTICE("[src] hums as it achieves maximum charge."))

/obj/item/weapon/gun/energy/yautja/plasmacarbine/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_9)
	set_burst_amount(BURST_AMOUNT_TIER_2)
	set_burst_delay(FIRE_DELAY_TIER_11)
	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_8
	scatter = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/yautja/plasmacarbine/get_examine_text(mob/user)
	if(isyautja(user))
		. = ..()
		. += SPAN_NOTICE("It currently has <b>[charge_time]/40</b> charge.")

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
		log_debug("Plasma carbine refunded shot.")
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

/obj/item/weapon/gun/flamer/yautja
	name = "heavy gel defoliator"
	desc = "A high-power incendiary device used to rapidly expunge evidence of hives or dishonorable foes. Unsurprisingly, it is just as effective in direct combat, and lightweight enough to be fired with one hand."
	icon = 'icons/obj/items/weapons/guns/guns_by_faction/pred.dmi'
	icon_state = "defoliator"
	item_state = "defoliator"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/guns_by_type/pred_guns.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/clothing/back/guns_by_type/pred_guns.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/pred_guns_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/weapons/guns/pred_guns_righthand.dmi'
	)
	ignite_sound = 'sound/weapons/wy_flamer_ignite.ogg'
	extinguish_sound = 'sound/weapons/wy_flamer_extinguish.ogg'
	unload_sound = 'sound/weapons/handling/wy_flamer_unload.ogg'
	reload_sound = 'sound/weapons/handling/wy_flamer_reload.ogg'
	dry_fire_sound = list('sound/weapons/wy_flamer_dryfire.ogg')
	accepted_ammo = list(
		/obj/item/ammo_magazine/flamer_tank/yautja,
		/obj/item/ammo_magazine/flamer_tank/yautja/deathsquad,
	)
	current_mag = /obj/item/ammo_magazine/flamer_tank/yautja
	flags_equip_slot = SLOT_BACK
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR|TWOHANDED

/obj/item/weapon/gun/flamer/yautja/Initialize()
	. = ..()
	AddElement(/datum/element/corp_label/dltalt)

/obj/item/weapon/gun/flamer/yautja/get_fire_sound()
	var/list/fire_sounds = list(
		'sound/weapons/wy_flamethrower1.ogg',
		'sound/weapons/wy_flamethrower2.ogg',
		'sound/weapons/wy_flamethrower3.ogg')
	return pick(fire_sounds)

/obj/item/weapon/gun/flamer/yautja/get_examine_text(mob/user)
	if(isyautja(user))
		. = ..()
	else
		. = list()
		. += SPAN_NOTICE("Looks like some massively fucked up alien flamethrower.")

/obj/item/weapon/gun/flamer/yautja/able_to_fire(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("The weapon beeps and refuses to fire. Must be some sort of fancy grip safety!"))
		return
	else
		return ..()

/obj/item/weapon/gun/flamer/yautja/deathsquad
	current_mag = /obj/item/ammo_magazine/flamer_tank/yautja/deathsquad

/obj/item/ammo_magazine/flamer_tank/yautja
	name = "gel defoliator fuel tank"
	desc = "A high-capacity heat-resistant tank of highly-flammable gel fuel for a heavy defoliator."
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/pred.dmi'
	icon_state = "defoliator"
	item_state = "defoliator"
	gun_type = /obj/item/weapon/gun/flamer/yautja
	max_rounds = 100
	max_range = 8
	max_intensity = 70
	stripe_icon = FALSE

/obj/item/ammo_magazine/flamer_tank/yautja/deathsquad
	name = "gel defoliator fuel tank (EX)"
	desc = "A high-capacity heat-resistant tank of terrifyingly powerful gelled plasma, capable of burning right through almost anything. Handle with extreme caution."
	caliber = "Napalm EX"
	flamer_chem = "napalmex"

/obj/item/weapon/gun/energy/yautja/cannon
	name = "\improper dual plasma cannons"
	desc = "A pair of powerful, shoulder-mounted energy weapons that are remotely operated via bracers. Unlike normal plasma casters, they only feature one fire mode, and are designed to obliterate most targets without leaving any material behind."
	icon_state = "plasma_cannons"
	item_state = "plasma_cannons"
	icon = 'icons/obj/items/hunter/mcaste_gear.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi', // we don't really care about handedness, it looks the exact same either way
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi'
	)
	fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
	ammo = /datum/ammo/energy/yautja/caster/lance
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MAGENTA
	w_class = SIZE_HUGE
	force = 0
	fire_delay = 3
	flags_atom = FPRINT|QUICK_DRAWABLE|CONDUCT
	flags_item = NOBLUDGEON|IGNITING_ITEM
	flags_gun_features = GUN_UNUSUAL_DESIGN

	var/obj/item/yautja_cannon_pack/source = null
	charge_cost = 1000 // you get two shots at full charge, because you have two casters. duh

/obj/item/weapon/gun/energy/yautja/cannon/Initialize(mapload)
	. = ..()
	icon_state = "plasma_cannons"
	item_state = "plasma_cannons"
	source = loc
	AddElement(/datum/element/corp_label/dltalt)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/use_toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/verb/use_unique_action

/obj/item/weapon/gun/energy/yautja/cannon/Destroy()
	. = ..()
	source = null

/obj/item/weapon/gun/energy/yautja/cannon/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_2 * 6)
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + FIRE_DELAY_TIER_6
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT

/obj/item/weapon/gun/energy/yautja/cannon/dropped(mob/living/carbon/human/M)
	playsound(M, 'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
	to_chat(M, SPAN_NOTICE("You deactivate your plasma cannons."))
	update_mouse_pointer(M, FALSE)
	var/datum/action/predator_action/pack/cannons/cannon_action
	for(cannon_action as anything in M.actions)
		if(istypestrict(cannon_action, /datum/action/predator_action/pack/cannons))
			cannon_action.update_button_icon(FALSE)
			break

	if(source)
		forceMove(source)
		source.cannons_deployed = FALSE
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
		log_debug("Plasma cannons refunded shot.")
	return TRUE
