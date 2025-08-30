//Guns
/obj/item/weapon/gun/mech
	var/obj/vehicle/rx47_mech/linked_mech
	unacidable = TRUE
	explo_proof = TRUE
	flags_gun_features = GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK|GUN_TRIGGER_SAFETY
	flags_item = NODROP
	start_semiauto = FALSE
	start_automatic = TRUE
	akimbo_forbidden = TRUE
	has_empty_icon = FALSE

/obj/item/weapon/gun/mech/dropped(mob/user)
	if(!linked_mech)
		qdel(src)
	..()
	forceMove(linked_mech)
	if(linked_mech.buckled_mob && linked_mech.buckled_mob == user)
		linked_mech.clean_driver(linked_mech.buckled_mob)
		linked_mech.unbuckle()

/obj/item/weapon/gun/mech/cock()
	return

/obj/item/weapon/gun/mech/unload()
	return

/obj/item/weapon/gun/mech/unique_action(mob/user)
	. = ..()
	toggle_gun_safety()

//Chaingun
/obj/item/ammo_magazine/rx47_chaingun
	name = "rotating ammo drum (20x102mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = "20x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rx47_chaingun
	max_rounds = 5000
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/chaingun
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/rx47_chaingun
	name = "chaingun bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 12
	damage = 25
	penetration = ARMOR_PENETRATION_TIER_6

/obj/item/weapon/gun/mech/chaingun
	name = "\improper RX47 Chaingun"
	desc = "An enormous multi-barreled rotating gatling gun. This thing will no doubt pack a punch."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	icon_state = "chaingun"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'

	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/rx47_chaingun
	w_class = SIZE_HUGE
	force = 20
	gun_category = GUN_CATEGORY_HEAVY

/obj/item/weapon/gun/mech/chaingun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/mech/chaingun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9 // Most of the scatter should come from the recoil
	scatter_unwielded = SCATTER_AMOUNT_TIER_9
	fa_max_scatter = SCATTER_AMOUNT_TIER_8
	fa_scatter_peak = 6
	burst_scatter_mult = 1

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF
	recoil_buildup_limit = RECOIL_OFF

//Cannon
/obj/item/ammo_magazine/rx47_cannon
	name = "rotating ammo drum (50x228mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = "50x228mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER
	color = "#990000"

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rx47_cannon
	max_rounds = 500
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/cannon
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/rx47_cannon
	name = "50mm cannon round"
	icon_state = "ltb"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 12
	damage = 45
	penetration = ARMOR_PENETRATION_TIER_10
	var/explosion_power = 100
	var/explosion_falloff = 40

/datum/ammo/bullet/rx47_cannon/on_hit_mob(mob/M, obj/projectile/P)
	cell_explosion(get_turf(M), explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rx47_cannon/on_hit_obj(obj/O, obj/projectile/P)
	cell_explosion(get_turf(O), explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rx47_cannon/on_hit_turf(turf/T, obj/projectile/P)
	if(T.density)
		cell_explosion(T, explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/obj/item/weapon/gun/mech/cannon
	name = "\improper RX47 Siegebreaker"
	desc = "An enormous 50mm cannon. It has IFF targetting systems that prevent launching at friendly targets."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	icon_state = "chaingun"
	color = "#990000"
	mouse_pointer = 'icons/effects/mouse_pointer/lmg_mouse.dmi'
	muzzle_flash = "muzzle_laser"
	muzzle_flash_color = "#990000"
	fire_sound = 'sound/weapons/gun_vulture_fire.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/rx47_cannon
	w_class = SIZE_HUGE
	force = 20
	gun_category = GUN_CATEGORY_HEAVY
	start_semiauto = TRUE
	start_automatic = FALSE

/obj/item/weapon/gun/mech/cannon/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

	AddComponent(/datum/component/iff_fire_prevention, 5)
	SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, TRUE)

/obj/item/weapon/gun/mech/cannon/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_VULTURE)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = 1

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF
	recoil_buildup_limit = RECOIL_OFF



// Support Gun
/obj/item/ammo_magazine/rx47_cupola
	name = "rotating ammo drum (15x102mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = "15x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rx47_cupola
	max_rounds = 3000
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/cupola
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/rx47_cupola
	name = "cupola bullet"
	icon_state = "bullet_iff"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage_falloff = DAMAGE_FALLOFF_TIER_9
	max_range = 12
	accuracy = HIT_ACCURACY_TIER_4
	damage = 15
	penetration = 0
	effective_range_max = 5
	penetration = ARMOR_PENETRATION_TIER_2

/obj/item/weapon/gun/mech/cupola/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_10
	recoil = RECOIL_OFF

/obj/item/weapon/gun/mech/cupola/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/mech/cupola/attack_self(mob/user)
	..()
	activate_attachment_verb()
	if(!active_attachable)
		base_gun_icon = "aux_cupola"
		icon_state = "aux_cupola"
	else
		base_gun_icon = "aux_fire"
		icon_state = "aux_fire"
	return

/obj/item/weapon/gun/mech/cupola
	name = "\improper RX47 Auxilliary Cupola"
	desc = "A large Cupola smartgun with undermounted flamethrower."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	base_gun_icon = "aux_cupola"
	icon_state = "aux_cupola"
	mouse_pointer = 'icons/effects/mouse_pointer/smartgun_mouse.dmi'

	fire_sound = "gun_smartgun"
	fire_rattle = "gun_smartgun_rattle"
	current_mag = /obj/item/ammo_magazine/rx47_cupola
	w_class = SIZE_HUGE
	force = 20
	gun_category = GUN_CATEGORY_SMG
	muzzle_flash = "muzzle_flash_blue"
	muzzle_flash_color = COLOR_MUZZLE_BLUE
	attachable_allowed = list(
		/obj/item/attachable/attached_gun/flamer/advanced/rx47,
	)

/obj/item/weapon/gun/mech/cupola/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/flamer/advanced/rx47/flamer = new(src)
	flamer.Attach(src)

/obj/item/attachable/attached_gun/flamer/advanced/rx47
	name = "RX47 Auxilliary Flamer"
	max_rounds = 750
	current_rounds = 750
	max_range = 5
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON|ATTACH_WIELD_OVERRIDE
	hidden = TRUE
