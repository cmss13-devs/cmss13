/datum/xeno_strain/acider
	name = RUNNER_ACIDER
	description = "At the cost of a little bit of your speed and all of your current abilities, you gain a considerable amount of health, some armor, and a new organ that fills with volatile acid over time. When outside of combat, only a limited amount of acid will generate. Your Tail Stab and slashes apply acid to living lifeforms that slowly burns them and fills your acid glands. You also gain Corrosive Acid equivalent to that of a boiler that you can deploy more quickly than any other caste, at the cost of a chunk of your acid reserves with each use. Finally, after a twenty second windup, you can force your body to explode, covering everything near you with acid. The more acid you have stored, the more devastating the explosion will be, but during those twenty seconds before detonation you are slowed and give off several warning signals which give talls an opportunity to end you before you can detonate. If you successfully explode, you will reincarnate as a larva again!"
	flavor_description = "This one will be the last thing they hear. A martyr."
	icon_state_prefix = "Acider"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/acider_acid,
		/datum/action/xeno_action/activable/acider_for_the_hive,
	)

	behavior_delegate_type = /datum/behavior_delegate/runner_acider

/datum/xeno_strain/acider/apply_strain(mob/living/carbon/xenomorph/runner/runner)
	runner.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	runner.armor_modifier += XENO_ARMOR_MOD_MED
	runner.health_modifier += XENO_HEALTH_MOD_ACIDER

	runner.recalculate_everything()

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
	/// Amount of acid before passive (non-combat) acid generation stops
	var/acid_gen_cap = 400

	/// How much acid is generated per tick in combat
	var/combat_acid_regen = 1
	/// Duration of combat acid generation after a slash/tailstab
	var/combat_gen_timer = 60
	/// Determines whether the combat acid generation is on or off
	var/combat_gen_active = FALSE

	/// How much acid is required to melt something
	var/melt_acid_cost = 100
	/// How much acid is required to fill a trap
	var/fill_acid_cost = 75

	var/list/caboom_sound = list('sound/effects/runner_charging_1.ogg','sound/effects/runner_charging_2.ogg')
	var/caboom_loop = 1

	var/caboom_acid_ratio = 200
	var/caboom_burn_damage_ratio = 5
	var/caboom_burn_range_ratio = 100
	var/caboom_struct_acid_type = /obj/effect/xenomorph/acid

	var/drool_overlay_active = FALSE
	var/mutable_appearance/drool_applied_icon

/datum/behavior_delegate/runner_acider/New()
	. = ..()
	drool_applied_icon = mutable_appearance('icons/mob/xenos/castes/tier_1/runner_strain_overlays.dmi', "Acider Runner Walking")

/datum/behavior_delegate/runner_acider/proc/modify_acid(amount)
	acid_amount += amount
	if(acid_amount > max_acid)
		acid_amount = max_acid
	if(acid_amount < 0)
		acid_amount = 0

/datum/behavior_delegate/runner_acider/append_to_stat() //The status panel info for Acid Runner is handed here.
	. = list()
	. += "Acid: [acid_amount]/[max_acid]"
	if(acid_amount >= acid_gen_cap)
		. += "Passive acid generation cap ([acid_gen_cap]) reached"
	. += "Battle acid generation: [combat_gen_active ? "Active" : "Inactive"]"
	if(caboom_trigger)
		. += "FOR THE HIVE!: in [caboom_left] seconds"

/datum/behavior_delegate/runner_acider/melee_attack_additional_effects_target(mob/living/carbon/target_mob)
	if(ishuman(target_mob)) //Will acid be applied to the mob
		var/mob/living/carbon/human/target_human = target_mob
		if(target_human.buckled && istype(target_human.buckled, /obj/structure/bed/nest))
			return
		if(target_human.stat == DEAD)
			return

	for(var/datum/effects/acid/acid_effect in target_mob.effects_list)
		qdel(acid_effect)
		break

	new /datum/effects/acid(target_mob, bound_xeno, initial(bound_xeno.caste_type))
	if(isxeno_human(target_mob)) //Will the runner get acid stacks
		var/obj/item/alien_embryo/embryo = locate(/obj/item/alien_embryo) in target_mob.contents
		if(embryo?.stage >= 4) //very late stage hugged in case the runner unnests them
			return

		if(target_mob.body_position == LYING_DOWN)
			modify_acid(acid_slash_regen_lying)
			return
		modify_acid(acid_slash_regen_standing)

		addtimer(CALLBACK(src, PROC_REF(combat_gen_end)), combat_gen_timer, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE) //this calls for the proc to turn combat acid gen off after a set time passes
		combat_gen_active = TRUE //turns combat acid regen on
		drool_overlay_active = TRUE //turns the overlay on

/datum/behavior_delegate/runner_acider/on_life()
	if(acid_amount < acid_gen_cap)
		modify_acid(acid_passive_regen)
	if(combat_gen_active)
		modify_acid(combat_acid_regen)
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
		if(caboom_loop > length(caboom_sound))
			caboom_loop = 1
	if(caboom_left <= 0)
		caboom_trigger = FALSE
		do_caboom()
		return

	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	var/percentage_acid = round((acid_amount / max_acid) * 100, 10)
	var/percentage_acid_cap = round((acid_gen_cap /max_acid) * 100, 10)
	if(percentage_acid)
		holder.overlays += image('icons/mob/hud/hud.dmi', "xenoenergy[percentage_acid]")
	if(acid_amount >= acid_gen_cap)
		holder.overlays += image('icons/mob/hud/hud.dmi', "cap[percentage_acid_cap]")

/datum/behavior_delegate/runner_acider/handle_death(mob/M)
	var/image/holder = bound_xeno.hud_list[PLASMA_HUD]
	holder.overlays.Cut()
	STOP_PROCESSING(SSfasteffects, src)

/datum/behavior_delegate/runner_acider/proc/do_caboom()
	if(!bound_xeno)
		return
	var/acid_range = acid_amount / caboom_acid_ratio
	var/max_burn_damage = acid_amount / caboom_burn_damage_ratio
	var/burn_range = acid_amount / caboom_burn_range_ratio

	for(var/barricades in dview(acid_range, bound_xeno))
		if(istype(barricades, /obj/structure/barricade))
			new caboom_struct_acid_type(get_turf(barricades), barricades)
			continue
		if(istype(barricades, /mob))
			new /datum/effects/acid(barricades, bound_xeno, initial(bound_xeno.caste_type))
			continue
	var/x = bound_xeno.x
	var/y = bound_xeno.y
	FOR_DVIEW(var/mob/living/target_living, burn_range, bound_xeno, HIDE_INVISIBLE_OBSERVER)
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
		var/damage = floor((burn_range - dist) * max_burn_damage / burn_range)
		if(isxeno(target_living))
			damage *= XVX_ACID_DAMAGEMULT

		target_living.apply_damage(damage, BURN)
	FOR_DVIEW_END
	FOR_DVIEW(var/turf/T, acid_range, bound_xeno, HIDE_INVISIBLE_OBSERVER)
		new /obj/effect/particle_effect/smoke/acid_runner_harmless(T)
	FOR_DVIEW_END
	playsound(bound_xeno, 'sound/effects/blobattack.ogg', 75)
	if(bound_xeno.client && bound_xeno.hive)
		var/datum/hive_status/hive_status = bound_xeno.hive
		var/turf/spawning_turf = get_turf(bound_xeno)
		if(!hive_status.hive_location)
			addtimer(CALLBACK(bound_xeno.hive, TYPE_PROC_REF(/datum/hive_status, respawn_on_turf), bound_xeno.client, spawning_turf), 0.5 SECONDS)
		else
			addtimer(CALLBACK(bound_xeno.hive, TYPE_PROC_REF(/datum/hive_status, free_respawn), bound_xeno.client), 5 SECONDS)
	bound_xeno.gib()

/mob/living/carbon/xenomorph/runner/ventcrawl_carry()
	var/datum/behavior_delegate/runner_acider/behavior_delegates = behavior_delegate
	if(istype(behavior_delegates) && behavior_delegates.caboom_trigger)
		to_chat(src, SPAN_XENOWARNING("You cannot ventcrawl when you are about to explode!"))
		return FALSE
	return ..()

/mob/living/carbon/xenomorph/runner/get_examine_text(mob/user)
	. = ..()
	var/datum/behavior_delegate/runner_acider/behavior = behavior_delegate
	if(istype(behavior) && isxeno(user))
		. += "it has [SPAN_GREEN(behavior.acid_amount)] acid!"

/datum/behavior_delegate/runner_acider/proc/combat_gen_end() //This proc is triggerd once the combat acid timer runs out.
	combat_gen_active = FALSE //turns combat acid off

	drool_overlay_active = FALSE //turns the drool overlay off
	bound_xeno.update_icons()

/datum/behavior_delegate/runner_acider/on_update_icons()
	bound_xeno.overlays -= drool_applied_icon
	drool_applied_icon.overlays.Cut()

	if(!drool_overlay_active)
		return

	if(bound_xeno.stat == DEAD)
		drool_applied_icon.icon_state = "Acider Runner Dead"
	else if(bound_xeno.body_position == LYING_DOWN)
		if(!HAS_TRAIT(bound_xeno, TRAIT_INCAPACITATED) && !HAS_TRAIT(bound_xeno, TRAIT_FLOORED))
			drool_applied_icon.icon_state = "Acider Runner Sleeping"
		else
			drool_applied_icon.icon_state = "Acider Runner Knocked Down"
	else
		drool_applied_icon.icon_state = "Acider Runner Walking"

	bound_xeno.overlays += drool_applied_icon
