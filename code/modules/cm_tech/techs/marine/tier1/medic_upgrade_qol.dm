/datum/tech/droppod/item/medic_czsp
	name = "Squad Medic Combat Zone Support Package"
	desc = "Gives medics to use powerful tools to heal marines."
	icon_state = "medic_qol"
	droppod_name = "Medic CZSP"

	flags = TREE_FLAG_MARINE

	required_points = 15
	tier = /datum/tier/one

/datum/tech/droppod/item/medic_czsp/on_unlock()
	. = ..()
	var/datum/supply_packs/SP = /datum/supply_packs/upgraded_medical_kits
	SP = supply_controller.supply_packs[initial(SP.name)]
	SP.buyable = TRUE

/datum/tech/droppod/item/medic_czsp/get_options(mob/living/carbon/human/H, obj/structure/droppod/D)
	. = ..()

	if(skillcheck(H, SKILL_MEDICAL, SKILL_MEDICAL_MEDIC))
		.["Medical CZSP"] = /obj/item/storage/box/combat_zone_support_package
	else
		var/type_to_add = /obj/item/stack/medical/bruise_pack
		if(prob(50))
			type_to_add = /obj/item/stack/medical/ointment

		if(prob(5))
			type_to_add = /obj/item/device/healthanalyzer

		.["Random Medical Item"] = type_to_add

/obj/item/storage/box/combat_zone_support_package
	name = "medical czsp"
	storage_slots = 3

/obj/item/storage/box/combat_zone_support_package/Initialize()
	. = ..()
	new /obj/item/storage/box/medic_upgraded_kits(src)
	new /obj/item/stack/medical/splint/nano(src)
	new /obj/item/device/defibrillator/upgraded(src)


/obj/item/storage/box/medic_upgraded_kits
	name = "medical upgrade kit"
	max_w_class = SIZE_MEDIUM

	storage_slots = 2

/obj/item/storage/box/medic_upgraded_kits/Initialize()
	. = ..()
	new /obj/item/stack/medical/advanced/bruise_pack/upgraded(src)
	new /obj/item/stack/medical/advanced/ointment/upgraded(src)

/obj/item/stack/medical/advanced/ointment/upgraded
	name = "upgraded advance burn kit"
	singular_name = "upgraded advance burn kit"
	stack_id = "upgraded advanced burn kit"

	icon_state = "burnkit_upgraded"

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/ointment/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_burn = initial(heal_burn) * 3 // 3x stronger

/obj/item/stack/medical/advanced/bruise_pack/upgraded
	name = "upgraded advance trauma kit"
	singular_name = "upgraded advance trauma kit"
	stack_id = "upgraded advanced trauma kit"

	icon_state = "traumakit_upgraded"

	max_amount = 10
	amount = 10

/obj/item/stack/medical/advanced/bruise_pack/upgraded/Initialize(mapload, ...)
	. = ..()
	heal_brute = initial(heal_brute) * 3 // 3x stronger

/obj/item/stack/medical/splint/nano
	name = "nano splints"
	singular_name = "nano splint"

	icon_state = "nanosplint"

	indestructible_splints = TRUE
	amount = 5
	max_amount = 5

	stack_id = "nano splint"

/obj/item/device/defibrillator/upgraded
	name = "upgraded emergency defibrillator"

	blocked_by_suit = FALSE
	heart_damage_to_deal = 0
	damage_threshold = 35

/obj/item/ammo_magazine/internal/pillgun
	name = "pill tube"
	desc = "An internal magazine. It is not supposed to be seen or removed."
	default_ammo = /datum/ammo/pill
	caliber = "pill"
	max_rounds = 1
	chamber_closed = FALSE

	var/list/pills

/obj/item/ammo_magazine/internal/pillgun/Initialize(mapload, spawn_empty)
	. = ..()
	current_rounds = LAZYLEN(pills)

/obj/item/ammo_magazine/internal/pillgun/Entered(Obj, OldLoc)
	. = ..()
	if(!istype(Obj, /obj/item/reagent_container/pill))
		return

	LAZYADD(pills, Obj)
	current_rounds = LAZYLEN(pills)

/obj/item/ammo_magazine/internal/pillgun/Exited(Obj, newloc)
	. = ..()
	if(!istype(Obj, /obj/item/reagent_container/pill))
		return

	LAZYREMOVE(pills, Obj)
	current_rounds = LAZYLEN(pills)

/obj/item/ammo_magazine/internal/pillgun/super
	max_rounds = 5

// upgraded version, currently no way of getting it
/obj/item/weapon/gun/pill/super
	name = "large pill gun"
	current_mag = /obj/item/ammo_magazine/internal/pillgun/super

/obj/item/weapon/gun/pill
	name = "pill gun"
	desc = "A spring loaded rifle designed to fit pills, designed to inject patients from a distance."
	icon = 'icons/obj/items/weapons/guns/gun.dmi'
	icon_state = "syringegun"
	item_state = "syringegun"
	w_class = SIZE_MEDIUM
	throw_speed = SPEED_SLOW
	throw_range = 10
	force = 4.0

	current_mag = /obj/item/ammo_magazine/internal/pillgun

	flags_gun_features = GUN_INTERNAL_MAG

	matter = list("metal" = 2000)

/obj/item/weapon/gun/pill/attackby(obj/item/I as obj, mob/user as mob)
	if(I.loc == current_mag)
		return

	if(!istype(I, /obj/item/reagent_container/pill))
		return

	if(current_mag.current_rounds >= current_mag.max_rounds)
		to_chat(user, SPAN_WARNING("[src] is at maximum ammo capacity!"))
		return

	user.drop_inv_item_on_ground(I)
	I.forceMove(current_mag)

/obj/item/weapon/gun/pill/update_icon()
	. = ..()
	if(!current_mag || !current_mag.current_rounds)
		icon_state = base_gun_icon
	else
		icon_state = base_gun_icon + "_e"

/obj/item/weapon/gun/pill/unload(mob/user, reload_override, drop_override, loc_override)
	var/obj/item/ammo_magazine/internal/pillgun/internal_mag = current_mag

	if(!istype(internal_mag))
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/obj/item/reagent_container/pill/pill_to_use = LAZYACCESS(internal_mag.pills, 1)

	if(!pill_to_use)
		return

	pill_to_use.forceMove(get_turf(H.loc))
	H.put_in_active_hand(pill_to_use)

/obj/item/weapon/gun/pill/Fire(atom/target, mob/living/user, params, reflex, dual_wield)
	if(!able_to_fire(user))
		return

	if(!current_mag.current_rounds)
		click_empty(user)
		return

	if(!istype(current_mag, /obj/item/ammo_magazine/internal/pillgun))
		return

	var/obj/item/ammo_magazine/internal/pillgun/internal_mag = current_mag
	var/obj/item/reagent_container/pill/pill_to_use = LAZYACCESS(internal_mag.pills, 1)

	if(QDELETED(pill_to_use))
		click_empty(user)
		return

	var/obj/item/projectile/pill/P = new /obj/item/projectile/pill(src, user, src)
	P.generate_bullet(GLOB.ammo_list[/datum/ammo/pill], 0, 0)

	pill_to_use.forceMove(P)
	P.source_pill = pill_to_use

	playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

	P.fire_at(target, user, src)

/datum/ammo/pill
	name = "syringe"
	icon_state = "syringe"
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_ALWAYS_FF

	damage = 0

/datum/ammo/pill/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()

	if(!ishuman(M))
		return

	if(!istype(P, /obj/item/projectile/pill))
		return

	var/obj/item/projectile/pill/pill_projectile = P

	if(QDELETED(pill_projectile.source_pill))
		pill_projectile.source_pill = null
		return

	var/datum/reagents/pill_reagents = pill_projectile.source_pill.reagents

	pill_reagents.trans_to(M, pill_reagents.total_volume)

/obj/item/projectile/pill
	var/obj/item/reagent_container/pill/source_pill

/obj/item/projectile/pill/Destroy()
	. = ..()
	source_pill = null
