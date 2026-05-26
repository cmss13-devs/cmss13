/datum/ammo/energy/plasma
	name = "plasma bolt"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	shell_speed = AMMO_SPEED_TIER_3
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit = "plasma_impact"
	sound_miss = "plasma_miss"
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_7

/datum/ammo/energy/plasma/plasma_pistol
	name = "light plasma bolt"
	icon_state = "plasma_teal"
	accurate_range = 8
	max_range = 20
	damage = 28
	accuracy = HIT_ACCURACY_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10

/datum/ammo/energy/plasma/plasma_pistol/overcharge
	name = "overcharged light plasma bolt"
	damage = 80
	shell_speed = AMMO_SPEED_TIER_4

// Shooting a warthog (or any vehicle) with a charged plasma shot stops it from moving momentarily
/datum/ammo/energy/plasma/plasma_pistol/overcharge/on_hit_obj(obj/target_object, obj/projectile/projectile)
	if(!istype(target_object, /obj/vehicle/multitile))
		return ..()

	var/vehicle_slowdown_time = 5 SECONDS
	var/obj/vehicle/multitile/wart = target_object
	wart.next_move = world.time + vehicle_slowdown_time
	playsound(wart, 'sound/effects/sebb_explode.ogg', 35)
	wart.visible_message(SPAN_HIGHDANGER("[icon2html(wart, viewers(wart))] \The [wart] lurches as overcharged plasma slams into it-- it's temporarily EMPed!"))
	new /obj/effect/overlay/temp/sebb(get_turf(wart))
	new /obj/effect/overlay/temp/emp_sparks(get_turf(src))
	empulse(wart, 1, 2)


/datum/ammo/energy/plasma/plasma_rifle
	name = "plasma bolt"
	icon_state = "plasma_blue"
	shell_speed = AMMO_SPEED_TIER_4
	accurate_range = 6
	max_range = 24
	damage = 38

/datum/ammo/needler
	name = "needle"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	icon_state = "needle"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 28
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 16
	accuracy = HIT_ACCURACY_TIER_MAX
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = AMMO_SPEED_TIER_3
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 24
	shrapnel_type = /obj/item/shard/shrapnel/needler
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_10

/datum/ammo/needler/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	if(ishuman(M))
		M.AddComponent(/datum/component/supercombine, M, P.dir)

/datum/ammo/bullet/rifle/carbine
	name = "carbine bullet"
	icon = 'icons/halo/obj/items/weapons/halo_projectiles.dmi'
	icon_state = "carbine"
	headshot_state = HEADSHOT_OVERLAY_MEDIUM
	damage = 50
	penetration = ARMOR_PENETRATION_TIER_3
	accurate_range = 24
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = 1.5*AMMO_SPEED_TIER_6
	effective_range_max = 24
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 32
	shrapnel_chance = null
