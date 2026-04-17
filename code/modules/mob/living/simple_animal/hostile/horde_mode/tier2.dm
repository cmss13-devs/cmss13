//--------------------------------
// LURKER

/mob/living/simple_animal/hostile/alien/horde_mode/lurker
	name = "Lurker"
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/mob/xenos/castes/tier_2/lurker.dmi'
	move_to_delay = HORDE_MODE_SPEED_FAST
	melee_damage_upper = HORDE_MODE_DAMAGE_MEDIUM
	melee_damage_lower = HORDE_MODE_DAMAGE_MEDIUM
	base_actions = list(/datum/action/horde_mode_action/invisibility)

// VAMPIRE
/mob/living/simple_animal/hostile/alien/horde_mode/lurker/vampire
	desc = "A fast alien with sharp claws, and an intense thirst for blood."
	strain_icon_path = 'icons/mob/xenos/castes/tier_2/lurker.dmi'
	strain_icon_state = "Vampire Lurker"
	health = HORDE_MODE_HEALTH_LOW
	maxHealth = HORDE_MODE_HEALTH_LOW
	melee_damage_lower = HORDE_MODE_DAMAGE_LOW
	move_to_delay = HORDE_MODE_SPEED_VERY_FAST

	base_actions = list(/datum/action/horde_mode_action/lifesteal, /datum/action/horde_mode_action/toss_mob/tail_jab, /datum/action/horde_mode_action/rush)


//--------------------------------
// SPITTER

/mob/living/simple_animal/hostile/alien/horde_mode/ranged/spitter
	name = "Spitter"
	desc = "A gross, oozing alien of some kind."
	icon = 'icons/mob/xenos/castes/tier_2/spitter.dmi'
	move_to_delay = HORDE_MODE_SPEED_SLOW

	projectile_to_fire = /datum/ammo/xeno/acid/glob
	ranged_distance = 5
	ranged_distance_min = 2
	ranged_delay = HORDE_MODE_ATTACK_DELAY_SLUGGISH * 2


//--------------------------------
// HIVELORD

/mob/living/simple_animal/hostile/alien/horde_mode/hivelord
	name = "Hivelord"
	desc = "A builder of really big hives."
	icon = 'icons/mob/xenos/castes/tier_2/hivelord.dmi'

	mob_size = MOB_SIZE_BIG
	health = HORDE_MODE_HEALTH_HIGH
	maxHealth = HORDE_MODE_HEALTH_HIGH
	melee_damage_lower = HORDE_MODE_DAMAGE_LOW
	move_to_delay = HORDE_MODE_SPEED_VERY_SLOW

	icon_size = 64
	pixel_x = -16
	old_x = -16
	status_flags = CANPUSH
	base_actions = list(/datum/action/horde_mode_action/plant_weeds, /datum/action/horde_mode_action/resin_construction, /datum/action/horde_mode_action/resin_construction/recovery)


//--------------------------------
// BURROWER

/mob/living/simple_animal/hostile/alien/horde_mode/burrower
	name = "Burrower"
	desc = "A beefy alien with sharp claws."
	icon = 'icons/mob/xenos/castes/tier_2/burrower.dmi'

	health = HORDE_MODE_HEALTH_HIGH
	maxHealth = HORDE_MODE_HEALTH_HIGH
	melee_damage_upper = HORDE_MODE_DAMAGE_MEDIUM
	move_to_delay = HORDE_MODE_SPEED_VERY_SLOW

	icon_size = 64
	pixel_x = -16
	old_x = -16
	//todo: add tunnel construction
	base_actions = list(/datum/action/horde_mode_action/tremor)

//WARRIOR
/////////
/mob/living/simple_animal/hostile/alien/horde_mode/warrior
	name = "Warrior"
	desc = "A beefy alien with an armored carapace."
	icon = 'icons/mob/xenos/castes/tier_2/warrior.dmi'
	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_4
	health = XENO_HEALTH_TIER_6
	move_to_delay = HORDE_MODE_SPEED_SLOW
	kill_reward = 250
	COOLDOWN_DECLARE(fling_cooldown)
	COOLDOWN_DECLARE(lunge_cooldown)

/mob/living/simple_animal/hostile/alien/horde_mode/warrior/AttackingTarget()
	if(Adjacent(target_mob) && prob(75) && COOLDOWN_FINISHED(src, fling_cooldown) && target_mob.mob_size < MOB_SIZE_BIG)
		COOLDOWN_START(src, fling_cooldown, 14 SECONDS)
		fling(target_mob, stun = TRUE)
		return
	. = ..()

/mob/living/simple_animal/hostile/alien/horde_mode/warrior/Life(delta_time)
	if(!Adjacent(target_mob) && prob(66) && COOLDOWN_FINISHED(src, lunge_cooldown) && get_dist(src, target_mob) <= 5)
		COOLDOWN_START(src, lunge_cooldown, 20 SECONDS)
		INVOKE_ASYNC(src, PROC_REF(lunge), target_mob, 5)
		return
	. = ..()

/mob/living/simple_animal/hostile/alien/horde_mode/warrior/Initialize()
	. = ..()
	status_flags &= ~CANPUSH
