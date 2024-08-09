/*
//======
					Shrapnel
//======
*/
/datum/ammo/bullet/shrapnel
	name = "shrapnel"
	icon_state = "buckshot"
	accurate_range_min = 5
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_STOPPED_BY_COVER

	accuracy = HIT_ACCURACY_TIER_3
	accurate_range = 32
	max_range = 8
	damage = 25
	damage_var_low = -PROJECTILE_VARIANCE_TIER_6
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_4
	shell_speed = AMMO_SPEED_TIER_2
	shrapnel_chance = 5

/datum/ammo/bullet/shrapnel/on_hit_obj(obj/O, obj/projectile/P)
	if(istype(O, /obj/structure/barricade))
		var/obj/structure/barricade/B = O
		B.health -= rand(2, 5)
		B.update_health(1)

/datum/ammo/bullet/shrapnel/rubber
	name = "rubber pellets"
	icon_state = "rubber_pellets"
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER

	damage = 0
	stamina_damage = 25
	shrapnel_chance = 0


/datum/ammo/bullet/shrapnel/hornet_rounds
	name = ".22 hornet round"
	icon_state = "hornet_round"
	flags_ammo_behavior = AMMO_BALLISTIC
	damage = 20
	shrapnel_chance = 0
	shell_speed = AMMO_SPEED_TIER_3//she fast af boi
	penetration = ARMOR_PENETRATION_TIER_5
	/// inflicts this many holo stacks per bullet hit
	var/holo_stacks = 10
	/// modifies the default cap limit of 100 by this amount
	var/bonus_damage_cap_increase = 0
	/// multiplies the default drain of 5 holo stacks per second by this amount
	var/stack_loss_multiplier = 1

/datum/ammo/bullet/shrapnel/hornet_rounds/on_hit_mob(mob/hit_mob, obj/projectile/bullet)
	. = ..()
	hit_mob.AddComponent(/datum/component/bonus_damage_stack, holo_stacks, world.time, bonus_damage_cap_increase, stack_loss_multiplier)


/datum/ammo/bullet/shrapnel/incendiary
	name = "flaming shrapnel"
	icon_state = "beanbag" // looks suprisingly a lot like flaming shrapnel chunks
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER

	shell_speed = AMMO_SPEED_TIER_1
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/shrapnel/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shrapnel/metal
	name = "metal shrapnel"
	icon_state = "shrapnelshot_bit"
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER|AMMO_BALLISTIC
	shell_speed = AMMO_SPEED_TIER_1
	damage = 30
	shrapnel_chance = 15
	accuracy = HIT_ACCURACY_TIER_8
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/shrapnel/light // weak shrapnel
	name = "light shrapnel"
	icon_state = "shrapnel_light"

	damage = 10
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_1
	shrapnel_chance = 0

/datum/ammo/bullet/shrapnel/light/human
	name = "human bone fragments"
	icon_state = "shrapnel_human"

	shrapnel_chance = 50
	shrapnel_type = /obj/item/shard/shrapnel/bone_chips/human

/datum/ammo/bullet/shrapnel/light/human/var1 // sprite variants
	icon_state = "shrapnel_human1"

/datum/ammo/bullet/shrapnel/light/human/var2 // sprite variants
	icon_state = "shrapnel_human2"

/datum/ammo/bullet/shrapnel/light/xeno
	name = "alien bone fragments"
	icon_state = "shrapnel_xeno"

	shrapnel_chance = 50
	shrapnel_type = /obj/item/shard/shrapnel/bone_chips/xeno

/datum/ammo/bullet/shrapnel/spall // weak shrapnel
	name = "spall"
	icon_state = "shrapnel_light"

	damage = 10
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_1
	shrapnel_chance = 0

/datum/ammo/bullet/shrapnel/light/glass
	name = "glass shrapnel"
	icon_state = "shrapnel_glass"

/particles/shrapnel
	icon = 'icons/obj/items/weapons/projectiles.dmi'
	icon_state = "shrapnel_bright2"
	width = 1000
	height = 1000
	count = 100
	spawning = 0
	lifespan = 0.6 SECONDS
	fadein = 0.2 SECONDS
	velocity = generator("square", 32 * 0.85, 32 * 1.15)
	rotation = generator("num", 0, 359)

/obj/shrapnel_effect
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

/obj/shrapnel_effect/New()
	. = ..()
	particles = new /particles/shrapnel
	particles.spawning = rand(5,9) + rand(5,9)
	addtimer(CALLBACK(src, PROC_REF(stop)), 0.1 SECONDS)
	QDEL_IN(src, 0.9 SECONDS)

/obj/shrapnel_effect/proc/stop()
	particles.spawning = 0

/obj/shrapnel_effect/get_applying_acid_time()
	return -1

/datum/ammo/bullet/shrapnel/jagged
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2
	accuracy = HIT_ACCURACY_TIER_MAX

/datum/ammo/bullet/shrapnel/jagged/on_hit_mob(mob/M, obj/projectile/P)
	if(isxeno(M))
		M.apply_effect(0.4, SLOW)

/*
//========
					CAS 30mm impacters
//========
*/
/datum/ammo/bullet/shrapnel/gau  //for the GAU to have a impact bullet instead of firecrackers
	name = "30mm Multi-Purpose shell"

	damage = 1 // ALL DAMAGE IS IN dropship_ammo SO WE CAN DEAL DAMAGE TO RESTING MOBS, these will still remain however so that we can get cause_data and status effects.
	damage_type = BRUTE
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_MAX
	max_range = 0
	shrapnel_chance = 100 //the least of your problems

/datum/ammo/bullet/shrapnel/gau/at
	name = "30mm Anti-Tank shell"

	damage = 1 // ALL DAMAGE IS IN dropship_ammo SO WE CAN DEAL DAMAGE TO RESTING MOBS, these will still remain however so that we can get cause_data and status effects.
	penetration = ARMOR_PENETRATION_TIER_8
	accuracy = HIT_ACCURACY_TIER_MAX
