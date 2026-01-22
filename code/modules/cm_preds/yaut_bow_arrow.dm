/obj/item/weapon/gun/bow
	name = "hunting bow"
	desc = "An abnormal-sized weapon with an exceptionally tight string. Requires extraordinary strength to draw."
	icon = 'icons/obj/items/hunter/bow.dmi'
	icon_state = "bow"
	item_state = "bow"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/hunter/items_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/hunter/items_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	current_mag = /obj/item/ammo_magazine/internal/bow
	reload_sound = 'sound/weapons/gun_shotgun_shell_insert.ogg'
	fire_sound = 'sound/weapons/bow_shot.ogg'
	aim_slowdown = 0
	flags_equip_slot = SLOT_BACK
	flags_gun_features = GUN_INTERNAL_MAG|GUN_CAN_POINTBLANK|GUN_WIELDED_FIRING_ONLY|GUN_UNUSUAL_DESIGN
	gun_category = GUN_CATEGORY_HEAVY
	muzzle_flash = null
	w_class = SIZE_LARGE
	explo_proof = TRUE
	unacidable = TRUE
	flags_item = TWOHANDED|ITEM_PREDATOR

/obj/item/weapon/gun/bow/Initialize(mapload, spawn_empty)
	spawn_empty = TRUE
	. = ..()

/obj/item/weapon/gun/bow/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_7)
	accuracy_mult = BASE_ACCURACY_MULT
	scatter = 0
	recoil = RECOIL_AMOUNT_TIER_4

/obj/item/weapon/gun/bow/reload_into_chamber(mob/user)
	. = ..()
	update_icon()
	update_item_state(user)

/obj/item/weapon/gun/bow/unload(mob/user)
	if(!current_mag || !current_mag.current_rounds)
		return
	var/obj/item/arrow/unloaded_arrow = new ammo.handful_type(get_turf(src))
	playsound(user, reload_sound, 25, TRUE)
	current_mag.current_rounds--
	if(user)
		to_chat(user, SPAN_NOTICE("You unload [unloaded_arrow] from [src]."))
		user.put_in_hands(unloaded_arrow)
	update_icon()
	update_item_state(user)

/obj/item/weapon/gun/bow/update_icon()
	..()
	if (!current_mag || current_mag.current_rounds == 0 || !istype(ammo, /datum/ammo/arrow))
		item_state = "bow"
		if(flags_item & WIELDED)
			item_state += "_w"
		return
	var/datum/ammo/arrow/arrow = ammo
	icon_state = "bow_[arrow.loaded_icon]"
	item_state = "bow_[arrow.loaded_icon]"
	if(flags_item & WIELDED)
		item_state += "_w"

/obj/item/weapon/gun/bow/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/arrow))
		to_chat(user, SPAN_WARNING("That's not an arrow!"))
		return
	if(!current_mag || current_mag.current_rounds == 1)
		to_chat(user, SPAN_WARNING("[src] is already loaded!"))
		return
	var/obj/item/arrow/attacking_arrow = attacking_item
	if (user.r_hand != src && user.l_hand != src)
		to_chat(user, SPAN_WARNING("You need to hold [src] in your hand in order to nock [attacking_arrow]!"))
		return
	if (!isyautja(user))
		to_chat(user, SPAN_WARNING("You're not nearly strong enough to pull back [src]'s drawstring!"))
		return
	ammo = GLOB.ammo_list[attacking_arrow.ammo_datum]
	playsound(user, reload_sound, 25, 1)
	to_chat(user, SPAN_NOTICE("You nock [attacking_arrow] onto [src]."))
	current_mag.current_rounds++
	qdel(attacking_arrow)
	update_icon()
	update_item_state(user)

/obj/item/weapon/gun/bow/proc/update_item_state(mob/user)
	if(!user)
		return
	var/hand = user.hand
	if(user.get_inactive_hand() == src)
		hand = !hand
	if(hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()

/obj/item/weapon/gun/bow/dropped(mob/user)
	. = ..()
	if(!current_mag || !current_mag.current_rounds)
		return
	to_chat(user, SPAN_WARNING("The projectile falls out of [src]!"))
	unload()

/obj/item/weapon/gun/bow/click_empty(mob/user)
	update_icon()
	update_item_state(user)
	return

/obj/item/ammo_magazine/internal/bow
	name = "bow internal magazine"
	caliber = "arrow"
	max_rounds = 1
	default_ammo = /datum/ammo/arrow

/obj/item/arrow
	name = "inert arrow"
	desc = "A heavy arrow made of a strange metal. Used by alien hunters with powerful bows."
	w_class = SIZE_SMALL
	icon = 'icons/obj/items/hunter/bow.dmi'
	icon_state = "arrow_expl"
	item_state = "arrow"
	sharp = IS_SHARP_ITEM_ACCURATE
	edge = TRUE
	force = 20
	explo_proof = TRUE
	unacidable = TRUE

	var/activated = FALSE
	var/datum/ammo/arrow/ammo_datum = /datum/ammo/arrow
	var/datum/ammo/arrow/primary_ammo = /datum/ammo/arrow
	var/datum/ammo/arrow/secondary_ammo = /datum/ammo/arrow/expl

/obj/item/arrow/expl_active
	name = "\improper activated explosive arrow"
	activated = TRUE
	icon_state = "arrow_expl_active"
	ammo_datum = /datum/ammo/arrow/expl

/obj/item/arrow/emp
	icon_state = "arrow_emp"
	secondary_ammo = /datum/ammo/arrow/emp

/obj/item/arrow/emp/active
	name = "\improper activated emp arrow"
	activated = TRUE
	icon_state = "arrow_emp_active"
	ammo_datum = /datum/ammo/arrow/emp

/obj/item/arrow/attack_self(mob/user)
	. = ..()
	change_warhead(user)

/obj/item/arrow/proc/change_warhead(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_NOTICE("You attempt to [activated ? "deactivate" : "activate"] [src], but nothing happens."))
		return
	if(activated)
		activated = FALSE
		ammo_datum = primary_ammo
		icon_state = ammo_datum.arrow_icon
		name = ammo_datum.name
		to_chat(user, SPAN_NOTICE("You deactivate [src]."))
		return
	activated = TRUE
	ammo_datum = secondary_ammo
	icon_state = ammo_datum.arrow_icon
	name = ammo_datum.name
	to_chat(user, SPAN_NOTICE("You activate [src]."))

/obj/item/arrow/dynamic_warhead
	name = "inert dynamic arrow"
	icon_state = "arrow_inert"
	ammo_datum = /datum/ammo/arrow/dynamic
	primary_ammo = /datum/ammo/arrow/dynamic
	secondary_ammo = /datum/ammo/arrow/dynamic

/obj/item/arrow/dynamic_warhead/change_warhead(mob/user)
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_NOTICE("You attempt to [activated ? "deactivate" : "activate"] [src], but nothing happens."))
		return
	if(activated)
		activated = FALSE
		ammo_datum = /datum/ammo/arrow/dynamic
		icon_state = ammo_datum.arrow_icon
		name = "inert dynamic arrow"
		to_chat(user, SPAN_NOTICE("You deactivate [src]."))
		return
	var/list/warhead_options = list(
		"Explosive" = /datum/ammo/arrow/expl/dynamic,
		"EMP" = /datum/ammo/arrow/emp/dynamic,
	)
	var/choice = tgui_input_list(user, "Which warhead do you wish to use?", "Pick Warhead", warhead_options)
	var/datum/ammo/arrow/arrow = warhead_options[choice]
	if(!ispath(arrow, /datum/ammo/arrow))
		to_chat(user, SPAN_WARNING("There was an error with the warhead. Arrow remains inert."))
		return
	activated = TRUE
	ammo_datum = arrow
	icon_state = arrow.arrow_icon
	name = ammo_datum.name
	to_chat(user, SPAN_NOTICE("You change the warhead to [choice]."))

/obj/item/storage/belt/gun/quiver
	name = "quiver strap"
	desc = "A strap that can hold a bow with a quiver for arrows."
	storage_slots = 8
	max_storage_space = 20
	icon_state = "quiver"
	item_state = "s_marinebelt"
	flags_equip_slot = SLOT_WAIST|SLOT_SUIT_STORE|SLOT_BACK // it's a quiver, quivers go on your back
	max_w_class = SIZE_LARGE
	icon = 'icons/obj/items/hunter/bow.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/hunter/pred_gear.dmi',
		WEAR_J_STORE = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)
	can_hold = list(
		/obj/item/weapon/gun/bow,
		/obj/item/arrow,
	)
	explo_proof = TRUE
	unacidable = TRUE

/obj/item/storage/belt/gun/quiver/full/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/bow())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/arrow(src)

/obj/item/storage/belt/gun/quiver/dynamic/fill_preset_inventory()
	handle_item_insertion(new /obj/item/weapon/gun/bow())
	for(var/i = 1 to storage_slots - 1)
		new /obj/item/arrow/dynamic_warhead(src)

/obj/item/arrow/snare
	name = "snare arrow"
	desc = "A bow launched snare."
	activated = TRUE
	icon_state = "arrow_trap"
	ammo_datum = /datum/ammo/arrow/snare
	primary_ammo = /datum/ammo/arrow/snare
	secondary_ammo = /datum/ammo/arrow/snare
	var/datum/effects/tethering/tether_effect
	var/mob/trapped_mob
	var/disarm_timer

/obj/item/arrow/snare/change_warhead(mob/user)
	return

/obj/item/arrow/snare/proc/trigger_snare(mob/living/carbon/C)
	anchored = TRUE

	var/list/tether_effects = apply_tether(src, C, range = 5, resistable = TRUE)
	tether_effect = tether_effects["tetherer_tether"]
	RegisterSignal(tether_effect, COMSIG_PARENT_QDELETING, PROC_REF(disarm))

	trapped_mob = C

	icon_state = "arrow_trap_active"
	playsound(C,'sound/weapons/tablehit1.ogg', 25, 1)
	to_chat(C, "[icon2html(src, C)] \red <B>You get caught in \the [src]!</B>")

	C.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(C)] was caught in \a [src] at [get_location_in_text(C)].</font>")
	log_attack("[key_name(C)] was caught in \a [src] at [get_location_in_text(C)].")

	if(ishuman(C))
		C.emote("pain")
	if(isxeno(C))
		var/mob/living/carbon/xenomorph/xeno = C
		C.emote("needhelp")
		xeno.AddComponent(/datum/component/status_effect/interference, 100) // Some base interference to give pred time to get some damage in, if it cannot land a single hit during this time pred is cheeks
		RegisterSignal(xeno, COMSIG_XENO_PRE_HEAL, PROC_REF(block_heal))
	disarm_timer = addtimer(CALLBACK(src, PROC_REF(disarm)), 30 SECONDS, TIMER_UNIQUE|TIMER_STOPPABLE)
	return TRUE

/obj/item/arrow/snare/proc/disarm(mob/user)
	if(disarm_timer)
		deltimer(disarm_timer)
	anchored = FALSE
	icon_state = "arrow_trap"
	if(user)
		to_chat(user, SPAN_NOTICE("[src] is now disarmed."))
		user.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(user)] has disarmed \the [src] at [get_location_in_text(user)].</font>")
		log_attack("[key_name(user)] has disarmed \a [src] at [get_location_in_text(user)].")
	if(trapped_mob)
		if(isxeno(trapped_mob))
			var/mob/living/carbon/xenomorph/X = trapped_mob
			UnregisterSignal(X, COMSIG_XENO_PRE_HEAL)
		trapped_mob.attack_log += text("\[[time_stamp()]\] <font color='orange'>[key_name(trapped_mob)] was freed frin \a [src].</font>")
		trapped_mob = null
	cleanup_tether()

/obj/item/arrow/snare/proc/cleanup_tether()
	if (tether_effect)
		UnregisterSignal(tether_effect, COMSIG_PARENT_QDELETING)
		qdel(tether_effect)
		tether_effect = null

/obj/item/arrow/snare/proc/block_heal(mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_XENO_HEAL

/obj/item/arrow/snare/attack_hand(mob/living/carbon/human/user)
	if(anchored)
		if(trapped_mob && (trapped_mob == user))
			user.resist()
			return
		else if(HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
			disarm(user)
		else
			return
	. = ..()
