/*
//======
					Rifle Ammo
//======
*/

/datum/ammo/bullet/rifle/ap/cluster
	name = "cluster rifle bullet"
	shrapnel_chance = 0

	penetration = ARMOR_PENETRATION_TIER_6
	var/cluster_addon = 1

/datum/ammo/bullet/rifle/ap/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)
