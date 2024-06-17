/*
//======
					SMG Ammo
//======
*/

/datum/ammo/bullet/smg/ap/cluster
	name = "cluster submachinegun bullet"
	shrapnel_chance = 0
	penetration = ARMOR_PENETRATION_TIER_4
	var/cluster_addon = 0.8

/datum/ammo/bullet/smg/ap/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)
