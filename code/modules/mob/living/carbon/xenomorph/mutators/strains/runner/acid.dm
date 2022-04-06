/datum/xeno_mutator/acider
	name = "STRAIN: Runner - Acider"
	description = "You exchange all your abilities for a new organ that is filled with volatile and explosive acid. Your slashes apply acid to living lifeforms that slowly burns them, and you gain powerful acid to melt items and defenses. You can force your body to explode, covering everything with acid, but that process takes 20 seconds and is noticable to people around you."
	flavor_description = "Burn their walls, maim their face!"
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
		/datum/action/xeno_action/activable/acider_for_the_hive
	)

/datum/xeno_mutator/acider/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Runner/R = MS.xeno
	R.mutation_type = RUNNER_ACIDER
	R.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	R.armor_modifier += XENO_ARMOR_MOD_MED
	R.health_modifier += XENO_HEALTH_MOD_ACIDER
	apply_behavior_holder(R)
	mutator_update_actions(R)
	R.recalculate_everything()
	MS.recalculate_actions(description, flavor_description)

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

/datum/behavior_delegate/runner_acider/melee_attack_additional_effects_target(mob/living/carbon/A)
	if (ishuman(A))
		var/mob/living/carbon/human/H = A
		if (H.stat == DEAD)
			return
	for(var/datum/effects/acid/AA in A.effects_list)
		qdel(AA)
		break
	if(isXenoOrHuman(A))
		if(A.lying)
			modify_acid(acid_slash_regen_lying)
		else
			modify_acid(acid_slash_regen_standing)
	new /datum/effects/acid(A, bound_xeno, initial(bound_xeno.caste_type))

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

/datum/behavior_delegate/runner_acider/proc/do_caboom()
	if(!bound_xeno)
		return
	var/acid_range = acid_amount / caboom_acid_ratio
	var/max_burn_damage = acid_amount / caboom_burn_damage_ratio
	var/burn_range = acid_amount / caboom_burn_range_ratio

	for(var/O in view(bound_xeno, acid_range))
		if(istype(O, /obj/structure/barricade))
			new caboom_struct_acid_type(get_turf(O), O)
			continue
		if(istype(O, /mob))
			new /datum/effects/acid(O, bound_xeno, initial(bound_xeno.caste_type))
			continue
	var/x = bound_xeno.x
	var/y = bound_xeno.y
	for(var/mob/living/M in view(bound_xeno, burn_range))
		if (!isXenoOrHuman(M) || bound_xeno.can_not_harm(M))
			continue
		var/dist = 0
		// such cheap, much fast
		var/dx = abs(M.x - x)
		var/dy = abs(M.y - y)
		if(dx>=dy)
			dist = (0.934*dx) + (0.427*dy)
		else
			dist = (0.427*dx) + (0.934*dy)
		var/damage = round((burn_range - dist) * max_burn_damage / burn_range)
		if(isXeno(M))
			damage *= XVX_ACID_DAMAGEMULT

		M.apply_damage(damage, BURN)
	playsound(bound_xeno, 'sound/effects/blobattack.ogg', 75)
	if(bound_xeno.client && bound_xeno.hive)
		addtimer(CALLBACK(bound_xeno.hive, /datum/hive_status.proc/free_respawn, bound_xeno.client), 5 SECONDS)
	bound_xeno.gib()

/mob/living/carbon/Xenomorph/Runner/ventcrawl_carry()
	var/datum/behavior_delegate/runner_acider/BD = behavior_delegate
	if(istype(BD) && BD.caboom_trigger)
		to_chat(src, SPAN_XENOWARNING("You cannot ventcrawl when you are about to explode!"))
		return FALSE
	return ..()
