/*
//======
					Special Ammo
//======
*/

/datum/ammo/bullet/smartgun
	damage = 35

/datum/ammo/bullet/smartgun/armor_piercing
	damage = 25

/datum/ammo/bullet/smartgun/m56c
	name = "armor-piercing smartgun bullet"
	icon_state = "bullet"
	debilitate = list(0,2,0,1,0,0,0,1)

	damage_falloff = DAMAGE_FALLOFF_TIER_10
	max_range = 24
	effective_range_max = 7
	accurate_range = 12
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_4
	pen_armor_punch = 2
	damage_armor_punch = 0.5

/datum/ammo/bullet/smartgun/m56c/holo_target
	name = "holo smartgun bullet"

	damage = 20
	penetration = ARMOR_PENETRATION_TIER_2
	pen_armor_punch = 1
	damage_armor_punch = 0

	/// inflicts this many holo stacks per bullet hit
	var/holo_stacks = 20
	/// modifies the default cap limit of 100 by this amount
	var/bonus_damage_cap_increase = 10
	/// multiplies the default drain of 5 holo stacks per second by this amount
	var/stack_loss_multiplier = 1

/datum/ammo/bullet/smartgun/m56c/holo_target/on_hit_mob(mob/hit_mob, obj/projectile/bullet)
	. = ..()
	hit_mob.AddComponent(/datum/component/bonus_damage_stack, holo_stacks, world.time, bonus_damage_cap_increase, stack_loss_multiplier)
