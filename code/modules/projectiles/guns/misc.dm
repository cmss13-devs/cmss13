//-------------------------------------------------------
//This gun is very powerful, but also has a kick.

/obj/item/weapon/gun/minigun
	name = "\improper Ol' Painless"
	desc = "An enormous multi-barreled rotating gatling gun. This thing will no doubt pack a punch."
	icon_state = "painless"
	item_state = "painless"

	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/minigun
	w_class = SIZE_HUGE
	force = 20
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_HAS_FULL_AUTO
	gun_category = GUN_CATEGORY_HEAVY

/obj/item/weapon/gun/minigun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0) load_into_chamber()

/obj/item/weapon/gun/minigun/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9 // Most of the scatter should come from the recoil

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	recoil_buildup_limit = RECOIL_AMOUNT_TIER_3 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

//Minigun UPP
/obj/item/weapon/gun/minigun/upp
	name = "\improper GSh-7.62 rotary machine gun"
	desc = "A gas-operated rotary machine gun used by UPP heavies. Its enormous volume of fire and ammunition capacity allows the suppression of large concentrations of enemy forces. Heavy weapons training is required control its recoil."
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_HAS_FULL_AUTO

/obj/item/weapon/gun/minigun/upp/able_to_fire(mob/living/user)
	. = ..()
	if(!. || !istype(user)) //Let's check all that other stuff first.
		return 0
	if(!skillcheck(user, SKILL_FIREARMS, SKILL_FIREARMS_DEFAULT))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0
	if(!skillcheck(user, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && user.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_UPP)
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return 0


/obj/item/weapon/gun/minigun/upp/handle_starting_attachment()
	..()
	//invisible mag harness
	var/obj/item/attachable/magnetic_harness/M = new(src)
	M.hidden = TRUE
	M.flags_attach_features &= ~ATTACH_REMOVABLE
	M.Attach(src)
	update_attachable(M.slot)

// Minigun UPP HvH
/obj/item/weapon/gun/minigun/upp/hvh

/obj/item/weapon/gun/minigun/upp/hvh/set_gun_config_values()
	..()
	damage_mult = BASE_BULLET_DAMAGE_MULT + BULLET_DAMAGE_MULT_TIER_2
	recoil_buildup_limit = RECOIL_AMOUNT_TIER_4 / RECOIL_BUILDUP_VIEWPUNCH_MULTIPLIER

//M60
/obj/item/weapon/gun/m60
	name = "\improper M60 General Purpose Machine Gun"
	desc = "The M60. The Pig. The Action Hero's wet dream."
	icon_state = "m60"
	item_state = "m60"

	fire_sound = 'sound/weapons/gun_m60.ogg'
	cocked_sound = 'sound/weapons/gun_m60_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/m60
	w_class = SIZE_LARGE
	force = 20
	flags_gun_features = GUN_BURST_ON|GUN_WIELDED_FIRING_ONLY
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(/obj/item/attachable/m60barrel,
							/obj/item/attachable/bipod/m60)
	starting_attachment_types = list(/obj/item/attachable/m60barrel,
									/obj/item/attachable/bipod/m60)


/obj/item/weapon/gun/m60/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/m60/set_gun_attachment_offsets()
	attachable_offset = list("muzzle_x" = 34, "muzzle_y" = 16,"rail_x" = 0, "rail_y" = 0, "under_x" = 39, "under_y" = 7, "stock_x" = 0, "stock_y" = 0)


/obj/item/weapon/gun/m60/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_10
	burst_amount = 5
	burst_delay = FIRE_DELAY_TIER_10
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_10
	burst_scatter_mult = SCATTER_AMOUNT_TIER_8
	scatter_unwielded = SCATTER_AMOUNT_TIER_10
	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_AMOUNT_TIER_5
	empty_sound = 'sound/weapons/gun_empty.ogg'

//Spike launcher

/obj/item/weapon/gun/launcher/spike
	name = "spike launcher"
	desc = "A compact Yautja device in the shape of a crescent. It can rapidly fire damaging spikes and automatically recharges."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "spikelauncher"
	item_state = "spikelauncher"
	muzzle_flash = null // TO DO, add a decent one.

	unacidable = TRUE
	fire_sound = 'sound/effects/woodhit.ogg' // TODO: Decent THWOK noise.
	ammo = /datum/ammo/alloy_spike
	flags_equip_slot = SLOT_WAIST|SLOT_BACK
	w_class = SIZE_MEDIUM //Fits in yautja bags.
	var/spikes = 12
	var/max_spikes = 12
	var/last_regen
	flags_gun_features = GUN_UNUSUAL_DESIGN
	flags_item = ITEM_PREDATOR

/obj/item/weapon/gun/launcher/spike/dropped(mob/living/user)
	add_to_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/launcher/spike/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/weapon/gun/launcher/spike/Destroy()
	. = ..()
	remove_from_missing_pred_gear(src)
	STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/launcher/spike/process()
	if(spikes < max_spikes && world.time > last_regen + 100 && prob(70))
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/weapon/gun/launcher/spike/Initialize(mapload, spawn_empty)
	. = ..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time
	update_icon()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/weapon/gun/verb/use_unique_action

/obj/item/weapon/gun/launcher/spike/set_gun_config_values()
	..()
	fire_delay = FIRE_DELAY_TIER_6
	accuracy_mult = BASE_ACCURACY_MULT
	accuracy_mult_unwielded = BASE_ACCURACY_MULT
	scatter = SCATTER_AMOUNT_TIER_6
	scatter_unwielded = SCATTER_AMOUNT_TIER_6
	damage_mult = BASE_BULLET_DAMAGE_MULT


/obj/item/weapon/gun/launcher/spike/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [spikes] / [max_spikes] spikes.")
	else to_chat(user, "Looks like some kind of...mechanical donut.")

/obj/item/weapon/gun/launcher/spike/update_icon()
	..()
	var/new_icon_state = spikes <=1 ? null : icon_state + "[round(spikes/4, 1)]"
	update_special_overlay(new_icon_state)

/obj/item/weapon/gun/launcher/spike/able_to_fire(mob/user)
	if(!isYautja(user))
		to_chat(user, SPAN_WARNING("You have no idea how this thing works!"))
		return

	return ..()

/obj/item/weapon/gun/launcher/spike/load_into_chamber()
	if(spikes > 0)
		in_chamber = create_bullet(ammo, initial(name))
		spikes--
		return in_chamber

/obj/item/weapon/gun/launcher/spike/reload_into_chamber()
	update_icon()
	return 1

/obj/item/weapon/gun/launcher/spike/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	qdel(projectile_to_fire)
	if(refund) spikes++
	return 1

/obj/effect/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "null"
	anchored = 1
	density = 0

/obj/effect/syringe_gun_dummy/Initialize()
		create_reagents(15)
		..()
