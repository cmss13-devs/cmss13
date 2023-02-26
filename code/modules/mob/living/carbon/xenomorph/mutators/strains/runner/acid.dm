/datum/xeno_mutator/acider
	name = "STRAIN: Runner - Acider"
	description = "At the cost of a little bit of your speed and all of your current abilities, you gain a considerable amount of health, some armor, and a new organ that fills with volatile acid over time. Your Tail Stab and slashes apply acid to living lifeforms that slowly burns them, and slashes against targets with acid stacks fill your acid glands. You also gain Corrosive Acid equivalent to that of a Praetorian that you can deploy more quickly than any other caste, at the cost of a chunk of your acid reserves with each use. Finally, after a twenty second windup, you can force your body to explode, covering everything near you with acid. The more acid you have stored, the more devastating the explosion will be, but during those twenty seconds before detonation you are slowed and give off several warning signals which give talls an opportunity to end you before you can detonate. If you successfully explode, you will reincarnate as a larva again!"
	flavor_description = "Burn their walls, maim their faces! Your life, for The Hive!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_RUNNER)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/runner_acider
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/acider_acid,
		/datum/action/xeno_action/activable/acider_for_the_hive,
	)

/datum/xeno_mutator/acider/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/xenomorph/runner/runner = mutator_set.xeno
	runner.mutation_icon_state = RUNNER_ACIDER
	runner.mutation_type = RUNNER_ACIDER
	runner.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	runner.armor_modifier += XENO_ARMOR_MOD_MED
	runner.health_modifier += XENO_HEALTH_MOD_ACIDER
	apply_behavior_holder(runner)
	mutator_update_actions(runner)
	runner.recalculate_everything()
	mutator_set.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/runner_acider
	var/acid_amount = 0

	var/caboom_left = 20
	var/caboom_trigger
	var/caboom_last_proc

	var/max_acid = 1000
	var/caboom_timer = 20
	var/acid_slash_regen_lying = 8
	var/acid_slash_regen_standing = 14
	var/acid_passive_regen = 1

	var/melt_acid_cost = 100

	var/list/caboom_sound = list('sound/effects/runner_charging_1.ogg','sound/effects/runner_charging_2.ogg')
	var/caboom_loop = 1

	var/caboom_acid_ratio = 200
	var/caboom_burn_damage_ratio = 5
	var/caboom_burn_range_ratio = 100
	var/caboom_struct_acid_type = /obj/effect/xenomorph/acid

/datum/behavior_delegate/runner_acider/proc/modify_acid(amount)
	acid_amount += amount
	if(acid_amount > max_acid)
		acid_amount = max_acid
	if(acid_amount < 0)
		acid_amount = 0

/datum/behavior_delegate/runner_acider/append_to_stat()
	. = list()
	. += "Acid: [acid_amount]"
	if(caboom_trigger)
		. += "FOR THE HIVE!: in [caboom_left] seconds"

/datum/behavior_delegate/runner_acider/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	if (ishuman(target_mob))
		var/mob/living/carbon/human/target_human = target_mob
		if (target_human.stat == DEAD)
			return
	for(var/datum/effects/acid/AA in target_mob.effects_list)
		qdel(AA)
		break
	if(isxeno_human(target_mob))
		if(target_mob.lying)
			modify_acid(acid_slash_regen_lying)
		else
			modify_acid(acid_slash_regen_standing)
	new /datum/effects/acid(target_mob, bound_xeno, initial(bound_xeno.caste_type))

/datum/behavior_delegate/runner_acider/on_life()
	modify_acid(acid_passive_regen)
	if(!bound_xeno)
		return
	if(bound_xeno.stat == DEAD)
		return
	if(caboom_trigger)
		var/wt = world.time
		if(caboom_last_proc)
			caboom_left -= (wt - caboom_last_proc)/10
		caboom_last_proc = wt
		var/amplitude = 50 + 50 * (caboom_timer - caboom_left) / caboom_timer
		playsound(bound_xeno, caboom_sound[caboom_loop], amplitude, FALSE, 10)
		caboom_loop++
		if(caboom_loop > caboom_sound.len)
			caboom_loop = 1
	if(caboom_left <= 0)
		caboom_trigger = FALSE
		do_caboom()
		return

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_acid = round((acid_amount / max_acid) * 100, 10)
	if(percentage_acid)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_acid]")

/datum/behavior_delegate/runner_acider/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()

/datum/behavior_delegate/runner_acider/proc/do_caboom()
	if(!bound_xeno)
		return
	var/acid_range = acid_amount / caboom_acid_ratio
	var/max_burn_damage = acid_amount / caboom_burn_damage_ratio
	var/burn_range = acid_amount / caboom_burn_range_ratio

	for(var/barricades in view(bound_xeno, acid_range))
		if(istype(barricades, /obj/structure/barricade))
			new caboom_struct_acid_type(get_turf(barricades), barricades)
			continue
		if(istype(barricades, /mob))
			new /datum/effects/acid(barricades, bound_xeno, initial(bound_xeno.caste_type))
			continue
	var/x = bound_xeno.x
	var/y = bound_xeno.y
	for(var/mob/living/target_living in view(bound_xeno, burn_range))
		if (!isxeno_human(target_living) || bound_xeno.can_not_harm(target_living))
			continue
		var/dist = 0
		// such cheap, much fast
		var/dx = abs(target_living.x - x)
		var/dy = abs(target_living.y - y)
		if(dx>=dy)
			dist = (0.934*dx) + (0.427*dy)
		else
			dist = (0.427*dx) + (0.934*dy)
		var/damage = round((burn_range - dist) * max_burn_damage / burn_range)
		if(isxeno(target_living))
			damage *= XVX_ACID_DAMAGEMULT

		target_living.apply_damage(damage, BURN)
	playsound(bound_xeno, 'sound/effects/blobattack.ogg', 75)
	if(bound_xeno.client && bound_xeno.hive)
		addtimer(CALLBACK(bound_xeno.hive, TYPE_PROC_REF(/datum/hive_status, free_respawn), bound_xeno.client), 5 SECONDS)
	bound_xeno.gib()

/mob/living/carbon/xenomorph/runner/ventcrawl_carry()
	var/datum/behavior_delegate/runner_acider/behavior_delegates = behavior_delegate
	if(istype(behavior_delegates) && behavior_delegates.caboom_trigger)
		to_chat(src, SPAN_XENOWARNING("You cannot ventcrawl when you are about to explode!"))
		return FALSE
	return ..()
