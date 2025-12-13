//Guns
/obj/item/weapon/gun/mech
	var/obj/vehicle/rx47_mech/linked_mech
	var/never_linked = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	flags_gun_features = GUN_AMMO_COUNTER|GUN_CAN_POINTBLANK|GUN_TRIGGER_SAFETY
	flags_item = 0
	start_semiauto = FALSE
	start_automatic = TRUE
	akimbo_forbidden = TRUE
	has_empty_icon = FALSE
	force = MELEE_FORCE_VERY_STRONG
	w_class = SIZE_HUGE
	var/firing_arc = 160
	var/arm_icon = "cupola"


/obj/item/weapon/gun/mech/able_to_fire(mob/user, atom/target)
	if(!linked_mech)
		to_chat(user, SPAN_WARNING(SPAN_BOLD("You cannot fire this weapon without an Rx47 mechsuit!")))
		return FALSE
	if(!in_firing_arc(target))
		to_chat(user, SPAN_WARNING(SPAN_BOLD("The target is not within your firing arc!")))
		return FALSE
	return ..()

/obj/item/weapon/gun/mech/proc/in_firing_arc(atom/target)
	if(!firing_arc || !ISINRANGE_EX(firing_arc, 0, 360))
		return TRUE

	var/turf/muzzle_turf = get_turf(linked_mech)
	var/turf/target_turf = get_turf(target)

	//same tile angle returns EAST, returning FALSE to ensure consistency
	if(muzzle_turf == target_turf)
		return FALSE

	var/angle_diff = (dir2angle(linked_mech.dir) - Get_Angle(muzzle_turf, target_turf)) %% 360
	if(angle_diff < -180)
		angle_diff += 360
	else if(angle_diff > 180)
		angle_diff -= 360

	return abs(angle_diff) <= (firing_arc * 0.5)

/obj/item/weapon/gun/mech/dropped(mob/user)
	if(!linked_mech && !never_linked)
		qdel(src)
	..()
	if(!linked_mech || never_linked)
		return
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

// #####################################################
// ################# Primary - Chaingun ################
// #####################################################
/obj/item/weapon/gun/mech/chaingun
	name = "\improper RX47 Chaingun"
	desc = "An enormous multi-barreled rotating gatling gun. This thing will no doubt pack a punch."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	icon_state = "chaingun"
	fire_sound = 'sound/weapons/gun_minigun.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/rx47_chaingun
	gun_category = GUN_CATEGORY_HEAVY
	arm_icon = "chaingun"

/obj/item/weapon/gun/mech/chaingun/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

/obj/item/weapon/gun/mech/chaingun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/mech/chaingun/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_12)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	effective_range_max = 6

	scatter = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_9
	fa_max_scatter = SCATTER_AMOUNT_TIER_8
	fa_scatter_peak = 6
	burst_scatter_mult = 1

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF
	recoil_buildup_limit = RECOIL_OFF

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
	name = "RX47 chaingun bullet"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 12
	damage = 40
	penetration = ARMOR_PENETRATION_TIER_4

// #####################################################
// ############### Primary - Siegebreaker ##############
// #####################################################
/obj/item/weapon/gun/mech/siegebreaker
	name = "\improper RX47 Siegebreaker"
	desc = "An enormous 50mm cannon. It has IFF targetting systems that prevent launching at friendly targets."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	icon_state = "siegebreaker"
	muzzle_flash = "muzzle_laser"
	muzzle_flash_color = "#990000"
	fire_sound = 'sound/weapons/gun_vulture_fire.ogg'
	cocked_sound = 'sound/weapons/gun_minigun_cocked.ogg'
	current_mag = /obj/item/ammo_magazine/rx47_siegebreaker
	gun_category = GUN_CATEGORY_HEAVY
	start_semiauto = TRUE
	start_automatic = FALSE
	firing_arc = 90
	arm_icon = "cannon"

/obj/item/weapon/gun/mech/siegebreaker/Initialize(mapload, spawn_empty)
	. = ..()
	if(current_mag && current_mag.current_rounds > 0)
		load_into_chamber()

	AddComponent(/datum/component/iff_fire_prevention, 5)
	SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, TRUE)

/obj/item/weapon/gun/mech/siegebreaker/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_VULTURE)

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3

	scatter = SCATTER_AMOUNT_TIER_9
	scatter_unwielded = SCATTER_AMOUNT_TIER_9
	burst_scatter_mult = 1

	damage_mult = BASE_BULLET_DAMAGE_MULT
	recoil = RECOIL_OFF
	recoil_buildup_limit = RECOIL_OFF

/obj/item/ammo_magazine/rx47_siegebreaker
	name = "rotating ammo drum (50x228mm)"
	desc = "A huge ammo drum for a huge gun."
	caliber = "50x228mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER
	color = "#990000"

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/rx47_siegebreaker
	max_rounds = 500
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/siegebreaker
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/rx47_siegebreaker
	name = "50mm RX47 cannon round"
	icon_state = "ltb"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 12
	damage = 45
	penetration = ARMOR_PENETRATION_TIER_10
	var/explosion_power = 100
	var/explosion_falloff = 40

/datum/ammo/bullet/rx47_siegebreaker/on_hit_mob(mob/M, obj/projectile/P)
	cell_explosion(get_turf(M), explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rx47_siegebreaker/on_hit_obj(obj/O, obj/projectile/P)
	cell_explosion(get_turf(O), explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rx47_siegebreaker/on_hit_turf(turf/T, obj/projectile/P)
	if(T.density)
		cell_explosion(T, explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

// #####################################################
// ################ Secondary - Smartgun ###############
// #####################################################
/obj/item/attachable/attached_gun/flamer/advanced/rx47
	name = "RX47 Auxilliary Flamer"
	max_rounds = 750
	current_rounds = 750
	max_range = 5
	flags_attach_features = ATTACH_ACTIVATION|ATTACH_RELOADABLE|ATTACH_WEAPON|ATTACH_WIELD_OVERRIDE
	hidden = TRUE

/obj/item/weapon/gun/mech/cupola
	name = "\improper RX47 Auxilliary Cupola"
	desc = "A large Cupola smartgun with undermounted flamethrower."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	base_gun_icon = "cupola"
	icon_state = "cupola"
	fire_sound = "gun_smartgun"
	fire_rattle = "gun_smartgun_rattle"
	current_mag = /obj/item/ammo_magazine/rx47_cupola
	force = MELEE_FORCE_TIER_4
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

/obj/item/weapon/gun/mech/cupola/set_gun_config_values()
	..()
	set_fire_delay(FIRE_DELAY_TIER_SG)
	fa_scatter_peak = FULL_AUTO_SCATTER_PEAK_TIER_8
	fa_max_scatter = SCATTER_AMOUNT_TIER_9
	accuracy_mult += HIT_ACCURACY_MULT_TIER_3
	scatter = SCATTER_AMOUNT_TIER_10
	recoil = RECOIL_OFF

	accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_3
	effective_range_max = 6

/obj/item/weapon/gun/mech/cupola/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("iff", /datum/element/bullet_trait_iff)
	))

/obj/item/weapon/gun/mech/cupola/attack_self(mob/user)
	..()
	activate_attachment_verb()
	if(!active_attachable)
		base_gun_icon = "cupola"
		icon_state = "cupola"
	else
		base_gun_icon = "cupola_fire"
		icon_state = "cupola_fire"
	return

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
	name = "RX47 cupola bullet"
	icon_state = "bullet_iff"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage_falloff = DAMAGE_FALLOFF_TIER_9
	max_range = 12
	accuracy = HIT_ACCURACY_TIER_4
	damage = 25
	penetration = 0
	effective_range_max = 5
	penetration = ARMOR_PENETRATION_TIER_2

// #####################################################
// ################ Secondary - Shotgun ################
// #####################################################
/obj/item/weapon/gun/mech/scattergun
	name = "\improper RX47 Auxilliary Scattergun"
	desc = "A large shotgun with undermounted flamethrower."
	icon = 'icons/obj/vehicles/wymech_guns.dmi'
	base_gun_icon = "shotgun"
	icon_state = "shotgun"
	mouse_pointer = 'icons/effects/mouse_pointer/smartgun_mouse.dmi'

	fire_sound = 'sound/weapons/gun_type23.ogg'
	current_mag = /obj/item/ammo_magazine/rx47_scattergun
	force = MELEE_FORCE_TIER_4
	gun_category = GUN_CATEGORY_SHOTGUN
	attachable_allowed = list(
		/obj/item/attachable/attached_gun/flamer/advanced/rx47,
	)
	start_automatic = FALSE
	start_semiauto = TRUE
	arm_icon = "shotgun"

/obj/item/weapon/gun/mech/scattergun/Initialize(mapload, spawn_empty)
	. = ..()

	AddComponent(/datum/component/iff_fire_prevention, 5)
	SEND_SIGNAL(src, COMSIG_GUN_ALT_IFF_TOGGLED, TRUE)

/obj/item/weapon/gun/mech/scattergun/set_gun_config_values()
	fire_delay = FIRE_DELAY_TIER_SHOTGUN_SLOW

/obj/item/weapon/gun/mech/scattergun/attack_self(mob/user)
	..()
	activate_attachment_verb()
	if(!active_attachable)
		base_gun_icon = "shotgun"
		icon_state = "shotgun"
	else
		base_gun_icon = "shotgun_fire"
		icon_state = "shotgun_fire"
	return

/obj/item/weapon/gun/mech/scattergun/handle_starting_attachment()
	..()
	var/obj/item/attachable/attached_gun/flamer/advanced/rx47/flamer = new(src)
	flamer.Attach(src)

/obj/item/weapon/gun/mech/scattergun/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY_ID("turfs", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_turfs),
		BULLET_TRAIT_ENTRY_ID("breaching", /datum/element/bullet_trait_damage_boost, 10.8, GLOB.damage_boost_breaching),
		BULLET_TRAIT_ENTRY_ID("pylons", /datum/element/bullet_trait_damage_boost, 5, GLOB.damage_boost_pylons)
	))

/obj/item/ammo_magazine/rx47_scattergun
	name = "rotating shrapnel drum"
	desc = "A huge ammo drum for a huge gun."
	caliber = "15x102mm"
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/event.dmi'
	icon_state = "painless" //PLACEHOLDER
	color = "#0c5522"

	matter = list("metal" = 10000)
	default_ammo = /datum/ammo/bullet/shotgun/heavy/buckshot/rx47_scattergun
	max_rounds = 1000
	reload_delay = 24 //Hard to reload.
	gun_type = /obj/item/weapon/gun/mech/scattergun
	w_class = SIZE_MEDIUM

/datum/ammo/bullet/shotgun/heavy/buckshot/rx47_scattergun
	name = "RX47 scattershot"
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/buckshot/spread/rx47_scattergun
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3

/datum/ammo/bullet/shotgun/heavy/buckshot/spread/rx47_scattergun
	name = "additional RX47 scattershot"
	max_range = 4
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
