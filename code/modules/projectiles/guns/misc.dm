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
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_HAS_FULL_AUTO|GUN_CAN_POINTBLANK
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
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_SPECIALIST|GUN_WIELDED_FIRING_ONLY|GUN_AMMO_COUNTER|GUN_RECOIL_BUILDUP|GUN_HAS_FULL_AUTO|GUN_CAN_POINTBLANK

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
	flags_gun_features = GUN_BURST_ON|GUN_WIELDED_FIRING_ONLY|GUN_CAN_POINTBLANK
	gun_category = GUN_CATEGORY_HEAVY
	attachable_allowed = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
	)
	starting_attachment_types = list(
		/obj/item/attachable/m60barrel,
		/obj/item/attachable/bipod/m60,
	)


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

/obj/effect/syringe_gun_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "null"
	anchored = TRUE
	density = FALSE

/obj/effect/syringe_gun_dummy/Initialize()
		create_reagents(15)
		..()
