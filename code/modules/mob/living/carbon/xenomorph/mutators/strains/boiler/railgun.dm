/*
 *    Railgun strain
 *    Exchanges gassing for a perfectly accurate "sniper shot" of acid that deals heavy damage
 */

/datum/xeno_mutator/railgun
	name = "STRAIN: Boiler - Railgun"
	description = "In exchange for your gas and neurotoxin gas, you gain a new type of glob - the railgun glob. This will do a lot of damage to barricades and humans, with no scatter and perfect accuracy!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Boiler") //Only boiler.
	mutator_actions_to_remove = list("Toggle Bombard Type")
	mutator_actions_to_add = null
	keystone = TRUE

/datum/xeno_mutator/railgun/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return
	
	var/datum/new_ammo = /datum/ammo/xeno/railgun_glob
	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	if(B.is_zoomed)
		B.zoom_out()
	B.bombard_speed = 15 + round(MS.bombard_cooldown * 0.5)
	MS.bombard_cooldown = 0
	MS.min_bombard_dist = 0
	B.bomb_delay = 5 SECONDS
	B.remove_action("Toggle Bombard Type")
	B.ammo = ammo_list[new_ammo]
	B.mutation_type = BOILER_RAILGUN
	B.tileoffset = 9
	B.viewsize = 14
	B.plasma_types -= PLASMA_NEUROTOXIN
	mutator_update_actions(B)
	MS.recalculate_actions(description)

/*
 *    Railgun ammo
 */

/datum/ammo/xeno/railgun_glob
	name = "railgun glob of acid"
	icon_state = "boiler_railgun"
	ping = "ping_x_railgun"
	sound_hit = "acid_hit"
	sound_bounce = "acid_bounce"
	debilitate = list(1,1,0,0,1,1,0,0)
	flags_ammo_behavior = AMMO_XENO_ACID|AMMO_SKIPS_ALIENS|AMMO_IGNORE_ARMOR|AMMO_ANTISTRUCT|AMMO_STOPPED_BY_COVER

/datum/ammo/xeno/railgun_glob/New()
	..()
	accurate_range = config.max_shell_range
	damage = config.mhigh_hit_damage
	damage_var_high = config.min_proj_variance
	damage_type = BURN
	scatter = config.min_scatter_value
	accuracy = config.max_hit_accuracy
	max_range = config.long_shell_range
	penetration = config.hmed_armor_penetration
	shell_speed = config.ultra_shell_speed

/datum/ammo/xeno/railgun_glob/on_hit_obj(obj/O, obj/item/projectile/P)
	if(istype(O, /obj/structure/barricade))
		var/obj/structure/barricade/B = O
		B.health -= damage + rand(5)
		B.update_health(1)
