/*
//======
					Revolver Ammo
//======
*/

/datum/ammo/bullet/revolver/cluster
	name = "cluster revolver bullet"
	shrapnel_chance = 0
	var/cluster_addon = 4
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/revolver/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)
