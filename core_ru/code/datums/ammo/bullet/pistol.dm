/*
//======
					Pistol Ammo
//======
*/

/datum/ammo/bullet/pistol/ap/cluster
	name = "cluster pistol bullet"
	shrapnel_chance = 0
	var/cluster_addon = 1.5

/datum/ammo/bullet/pistol/ap/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/heavy/cluster
	name = "heavy cluster pistol bullet"
	var/cluster_addon = 1.5

/datum/ammo/bullet/pistol/heavy/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/squash/cluster
	name = "cluster squash-head pistol bullet"
	shrapnel_chance = 0
	var/cluster_addon = 2

/datum/ammo/bullet/pistol/squash/cluster/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)
