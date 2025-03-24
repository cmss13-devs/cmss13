/datum/moba_caste/spitter
	equivalent_caste_path = /datum/caste_datum/spitter
	equivalent_xeno_path = /mob/living/carbon/xenomorph/spitter
	name = XENO_CASTE_SPITTER
	desc = {"
		Supportive caste focused on healing allies while providing some offensive power.<br>
		<b>P:</b> Gain wards as a team faster and increase your team's ward capacity by 1.<br>
		<b>1:</b> Ready your tail to stab, giving your next attack increased range, attack damage, and daze.<br>
		<b>2:</b> Plant an empowering pillar that grows over a short period, granting nearby allies increased speed.<br>
		<b>3:</b> Create a beam between you and an ally, regenerating their health over time at the cost of plasma.<br>
		<b>U:</b> After a channel, heal all nearby allies for a portion of their max health.
	"}
	category = MOBA_ARCHETYPE_CASTER
	icon_state = "drone" // fixme
	ideal_roles = list(MOBA_LANE_SUPPORT, MOBA_LANE_BOT)
	starting_health = 380
	ending_health = 1520
	starting_health_regen = 1.2
	ending_health_regen = 4.8
	starting_plasma = 400
	ending_plasma = 850
	starting_plasma_regen = 1.5
	ending_plasma_regen = 4
	starting_armor = 0
	ending_armor = 0
	starting_acid_armor = 0
	ending_acid_armor = 5
	speed = 1
	attack_delay_modifier = 0
	starting_attack_damage = 27
	ending_attack_damage = 42
	abilities_to_add = list(
		/datum/action/xeno_action/activable/xeno_spit/marking,
		/datum/action/xeno_action/activable/spray_acid/moba,
		//datum/action/xeno_action/activable/life_transfer,
		//datum/action/xeno_action/onclick/rejuvenation_burst,
	)

/datum/action/xeno_action/activable/xeno_spit/marking
	name = "Marking Spit"
	var/real_cooldown = 5 SECONDS
	var/datum/ammo/xeno/acid/marking/marking_ammo

/datum/action/xeno_action/activable/xeno_spit/marking/New(Target, override_icon_state)
	. = ..()
	marking_ammo = new()

/datum/action/xeno_action/activable/xeno_spit/marking/Destroy()
	. = ..()
	QDEL_NULL(marking_ammo)

/datum/action/xeno_action/activable/xeno_spit/marking/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.ammo = marking_ammo
	. = ..()
	apply_cooldown_override(real_cooldown)

/datum/action/xeno_action/activable/xeno_spit/marking/level_up_ability(new_level)
	marking_ammo.damage = marking_ammo::damage + ((new_level - 1) * 12.5)
	marking_ammo.damage_percent_boost = marking_ammo::damage_percent_boost + ((new_level - 1) * 5)
	switch(new_level)
		if(2)
			marking_ammo.spit_cost = 60
		if(3)
			marking_ammo.spit_cost = 55

	desc = "Spit at a target, dealing [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 27.5, 40, 52.5)] (+60% AP) acid damage and increasing the target's damage taken by [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 10, 15, 20)]% for 3 seconds."

/datum/ammo/xeno/acid/marking
	name = "marking acid spit"
	spit_cost = 70
	damage = 27.5
	penetration = 0
	var/damage_percent_boost = 10

/datum/ammo/xeno/acid/marking/on_hit_mob(mob/M, obj/projectile/P)
	if(isliving(M))
		M.AddComponent(/datum/component/bonus_damage_stack, damage_percent_boost * 10, world.time, 100, 2000)
	return ..()

/datum/ammo/xeno/acid/marking/on_bullet_generation(obj/projectile/generated_projectile, mob/bullet_generator)
	. = ..()
	var/list/ap_list = list()
	SEND_SIGNAL(bullet_generator, COMSIG_MOBA_GET_AP, ap_list)
	generated_projectile.damage = damage + (ap_list[1] * 0.6)

/datum/action/xeno_action/activable/spray_acid/moba
	plasma_cost = 90
	xeno_cooldown = 10 SECONDS
	spray_effect_type = /obj/effect/xenomorph/spray/no_stun/moba

/datum/action/xeno_action/activable/spray_acid/moba/level_up_ability(new_level)
	desc = "Spit a slow-moving blast of acid that leaves a trail behind. Being directly hit by the acid deals [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 40, 60, 80)] (+70% AP) acid damage. Stepping into the acid trail slows the target and deals [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 10, 15, 20)] (+30% AP) acid damage per second for [/datum/status_effect/acid_soaked::duration * 0.1] seconds."

/obj/effect/xenomorph/spray/no_stun/moba //zonenote this applies extra damage on Initialize() maybe look into idk
	time_to_live = 5 SECONDS
	damage_amount = 40
	var/dot_damage = 10

/obj/effect/xenomorph/spray/no_stun/moba/Initialize(mapload, datum/cause_data/new_cause_data, hive)
	if(new_cause_data?.weak_mob)
		var/mob/living/carbon/xenomorph/xeno = new_cause_data.weak_mob.resolve()
		var/list/player_list = list()
		SEND_SIGNAL(xeno, COMSIG_MOBA_GET_PLAYER_DATUM, player_list)
		if(!length(player_list))
			return ..()
		var/datum/moba_player/player = player_list[1]
		switch(player.ability_path_level_dict[/datum/action/xeno_action/activable/spray_acid/moba])
			if(2)
				damage_amount = 60
				dot_damage = 15
			if(3)
				damage_amount = 80
				dot_damage = 20
		var/list/ap_list = list()
		SEND_SIGNAL(xeno, COMSIG_MOBA_GET_AP, ap_list)
		damage_amount += ap_list[1] * 0.7
	. = ..()
	if(new_cause_data?.weak_mob)
		var/mob/living/carbon/xenomorph/xeno = new_cause_data.weak_mob.resolve()
		var/list/ap_list = list()
		SEND_SIGNAL(xeno, COMSIG_MOBA_GET_AP, ap_list)
		damage_amount -= ap_list[1] * 0.7

/obj/effect/xenomorph/spray/no_stun/moba/apply_spray(mob/living/carbon/carbon, should_stun = FALSE)
	var/mob/living/carbon/xenomorph/xeno = carbon
	xeno.emote("hiss")
	var/list/ap_list = list()
	SEND_SIGNAL(xeno, COMSIG_MOBA_GET_AP, ap_list)
	xeno.apply_status_effect(/datum/status_effect/acid_soaked, dot_damage + (ap_list[1] * 0.3))

	xeno.last_damage_data = cause_data
	xeno..UpdateDamageIcon()
	xeno..updatehealth()

// Perhaps the most boring ability on the planet. Oh Well!
/datum/action/xeno_action/activable/xeno_spit/moba
	name = "Acid Spit"
	var/real_cooldown = 5 SECONDS
	var/datum/ammo/xeno/acid/moba/ammo

/datum/action/xeno_action/activable/xeno_spit/marking/New(Target, override_icon_state)
	. = ..()
	ammo = new()

/datum/action/xeno_action/activable/xeno_spit/marking/Destroy()
	. = ..()
	QDEL_NULL(ammo)

/datum/action/xeno_action/activable/xeno_spit/marking/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.ammo = ammo
	. = ..()
	apply_cooldown_override(real_cooldown)

/datum/action/xeno_action/activable/xeno_spit/marking/level_up_ability(new_level)
	ammo.damage = ammo::damage + ((new_level - 1) * 12.5)
	ammo.damage_percent_boost = ammo::damage_percent_boost + ((new_level - 1) * 5)
	switch(new_level)
		if(2)
			ammo.spit_cost = 60
		if(3)
			ammo.spit_cost = 55

	desc = "Spit at a target, dealing [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 27.5, 40, 52.5)] (+60% AP) acid damage."

/datum/ammo/xeno/acid/moba
	name = "marking acid spit"
	spit_cost = 70
	damage = 27.5
	penetration = 0
	var/damage_percent_boost = 10

/datum/ammo/xeno/acid/marking/on_hit_mob(mob/M, obj/projectile/P)
	if(isliving(M))
		M.AddComponent(/datum/component/bonus_damage_stack, damage_percent_boost * 10, world.time, 100, 2000)
	return ..()

/datum/ammo/xeno/acid/marking/on_bullet_generation(obj/projectile/generated_projectile, mob/bullet_generator)
	. = ..()
	var/list/ap_list = list()
	SEND_SIGNAL(bullet_generator, COMSIG_MOBA_GET_AP, ap_list)
	generated_projectile.damage = damage + (ap_list[1] * 0.6)
