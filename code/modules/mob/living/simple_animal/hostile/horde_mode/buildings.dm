/obj/structure/horde_mode_resin
	name = "resin structure"
	desc = "A large clump of gooey mass. It rhythmically pulses, as if its pumping something into the weeds below..."
	icon = 'icons/mob/xenos/structures48x48.dmi'
	icon_state = "hive_cluster_idle"

	pixel_x = -8
	pixel_y = -8

	health = 350
	var/datum/hive_status/linked_hive
	var/mob/living/simple_animal/hostile/alien/horde_mode/owner

/obj/structure/horde_mode_resin/Initialize(mapload, hive, xeno)
	. = ..()
	linked_hive = hive
	if(!hive)
		linked_hive = GLOB.hive_datum[XENO_HIVE_HORDEMODE]
	if(xeno)
		owner = xeno

/obj/structure/horde_mode_resin/Destroy()
	. = ..()
	owner?.max_buildings++

/obj/structure/horde_mode_resin/bullet_act(obj/projectile/proj)
	. = ..()
	health -= proj.damage
	update_health()

/obj/structure/horde_mode_resin/attackby(obj/item/weapon, mob/user)
	. = ..()
	playsound(loc, "alien_resin_break", 50)
	health -= weapon.force
	update_health()

/obj/structure/horde_mode_resin/update_health()
	if(health < 0)
		qdel(src)

//--------------------------------
// HIVE CLUSTER

/obj/structure/horde_mode_resin/hive_cluster
	name = "hive cluster"

	///What type of weeds this cluster spreads.
	var/node_type = /obj/effect/alien/weeds/node/horde_mode/cluster
	///Reference to the main node that is spreading weeds.
	var/node

/obj/structure/horde_mode_resin/hive_cluster/Initialize(mapload, hive_owner)
	. = ..()
	var/obj/effect/alien/weeds/node/horde_mode/cluster/weed_node = new node_type(loc, null, null, hive_owner)
	weed_node.resin_parent = src
	node = weed_node

/obj/structure/horde_mode_resin/hive_cluster/Destroy()
	. = ..()
	QDEL_NULL(node)

//--------------------------------
// RECOVERY NODE

/obj/structure/horde_mode_resin/recovery
	name = "recovery node"
	desc = "A warm, soothing light source that pulsates with a faint hum."
	health = 250
	icon = 'icons/mob/xenos/structures64x64.dmi'
	icon_state = "recovery"
	pixel_x = -16
	pixel_y = -16
	var/health_recovery = 0.15 //precentage
	var/cooldown_length = 5 SECONDS
	COOLDOWN_DECLARE(healing_cooldown)

/obj/structure/horde_mode_resin/recovery/Initialize(mapload, hive)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/horde_mode_resin/recovery/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/horde_mode_resin/recovery/process()
	if(!COOLDOWN_FINISHED(src, healing_cooldown))
		return

	for(var/mob/living/simple_animal/hostile/alien/horde_mode/alien in orange(src, 7))
		if(alien.health >= alien.maxHealth || alien.hivenumber != linked_hive.hivenumber || alien.stat == DEAD)
			continue
		alien.health += alien.maxHealth * health_recovery
		alien.flick_heal_overlay(4 SECONDS, "#D9F500")
		alien.update_wounds()

	COOLDOWN_START(src, healing_cooldown, cooldown_length)

