/*
//======
					Xeno Spits
//======
*/
/datum/ammo/xeno
	icon_state = "neurotoxin"
	ping = "ping_x"
	damage_type = TOX
	flags_ammo_behavior = AMMO_XENO

	///used to make cooldown of the different spits vary.
	var/added_spit_delay = 0
	var/spit_cost

	/// Should there be a windup for this spit?
	var/spit_windup = FALSE

	/// Should there be an additional warning while winding up? (do not put to true if there is not a windup)
	var/pre_spit_warn = FALSE
	accuracy = HIT_ACCURACY_TIER_8*2
	max_range = 12

/datum/ammo/xeno/toxin
	name = "neurotoxic spit"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_XENO|AMMO_IGNORE_RESIST
	spit_cost = 25
	var/effect_power = XENO_NEURO_TIER_4
	var/drain_power = 2
	var/datum/callback/neuro_callback

	shell_speed = AMMO_SPEED_TIER_3
	max_range = 7

/datum/ammo/xeno/toxin/New()
	..()

	neuro_callback = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(apply_neuro))

/proc/apply_neuro(mob/living/M, power, drain, insta_neuro = FALSE, drain_stims = FALSE, drain_medchems = FALSE)
	if(skillcheck(M, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX) && !insta_neuro)
		M.visible_message(SPAN_DANGER("[M] withstands the neurotoxin!"))
		return //endurance 5 makes you immune to weak neurotoxin
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(drain_stims)
			for(var/datum/reagent/generated/stim in H.reagents.reagent_list)
				H.reagents.remove_reagent(stim.id, drain, TRUE)
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || H.species.flags & NO_NEURO)
			H.visible_message(SPAN_DANGER("[M] shrugs off the neurotoxin!"))
			return //species like zombies or synths are immune to neurotoxin
		if(drain_medchems)
			for(var/datum/reagent/medical/med in H.reagents.reagent_list)
				H.reagents.remove_reagent(med.id, drain, TRUE)

	if(!isxeno(M))
		if(insta_neuro)
			if(M.GetKnockDownDuration() < 3) // Why are you not using KnockDown(3) ? Do you even know 3 is SIX seconds ? So many questions left unanswered.
				M.KnockDown(power)
				M.Stun(power)
				return

		if(ishuman(M))
			M.apply_effect(4, SUPERSLOW)
			M.visible_message(SPAN_DANGER("[M]'s movements are slowed."))

		var/no_clothes_neuro = FALSE

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.wear_suit || H.wear_suit.slowdown == 0)
				no_clothes_neuro = TRUE

		if(no_clothes_neuro)
			if(M.GetKnockDownDuration() < 5) // Nobody actually knows what this means. Supposedly it means less than 10 seconds. Frankly if you get locked into 10s of knockdown to begin with there are bigger issues.
				M.KnockDown(power)
				M.Stun(power)
				M.visible_message(SPAN_DANGER("[M] falls prone."))

/proc/apply_scatter_neuro(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(skillcheck(M, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX))
			M.visible_message(SPAN_DANGER("[M] withstands the neurotoxin!"))
			return //endurance 5 makes you immune to weak neuro
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || H.species.flags & NO_NEURO)
			H.visible_message(SPAN_DANGER("[M] shrugs off the neurotoxin!"))
			return

		M.KnockDown(0.7) // Completely arbitrary values from another time where stun timers incorrectly stacked. Kill as needed.
		M.Stun(0.7)
		M.visible_message(SPAN_DANGER("[M] falls prone."))

/datum/ammo/xeno/toxin/on_hit_mob(mob/M,obj/projectile/P)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.status_flags & XENO_HOST)
			neuro_callback.Invoke(H, effect_power, drain_power, TRUE, TRUE, TRUE)
			return

	neuro_callback.Invoke(M, effect_power, drain_power, FALSE, TRUE, TRUE)

/datum/ammo/xeno/toxin/medium //Spitter
	name = "neurotoxic spatter"
	spit_cost = 50
	effect_power = 1

	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/xeno/toxin/queen
	name = "neurotoxic spit"
	spit_cost = 50
	effect_power = 2
	drain_power = 4

	accuracy = HIT_ACCURACY_TIER_5*2
	max_range = 6 - 1

/datum/ammo/xeno/toxin/queen/on_hit_mob(mob/M,obj/projectile/P)
	neuro_callback.Invoke(M, effect_power, drain_power, TRUE, TRUE, FALSE)

/datum/ammo/xeno/toxin/shotgun
	name = "neurotoxic droplet"
	flags_ammo_behavior = AMMO_XENO|AMMO_IGNORE_RESIST
	bonus_projectiles_type = /datum/ammo/xeno/toxin/shotgun/additional

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 5
	max_range = 5
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_4

/datum/ammo/xeno/toxin/shotgun/New()
	..()

	neuro_callback = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(apply_scatter_neuro))

/datum/ammo/xeno/toxin/shotgun/additional
	name = "additional neurotoxic droplets"

	scatter = SCATTER_AMOUNT_NEURO
	bonus_projectiles_amount = 0

/datum/ammo/xeno/acid
	name = "acid spit"
	icon_state = "xeno_acid_weak"
	sound_hit  = "acid_hit"
	sound_bounce = "acid_bounce"
	damage_type = BURN
	spit_cost = 25
	flags_ammo_behavior = AMMO_ACIDIC|AMMO_XENO
	accuracy = HIT_ACCURACY_TIER_5
	damage = 20
	max_range = 8 // 7 will disappear on diagonals. i love shitcode
	penetration = ARMOR_PENETRATION_TIER_2
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/xeno/acid/on_shield_block(mob/M, obj/projectile/P)
	burst(M,P,damage_type)

/datum/ammo/xeno/acid/on_hit_mob(mob/M, obj/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.status_flags & XENO_HOST && HAS_TRAIT(C, TRAIT_NESTED) || C.stat == DEAD || HAS_TRAIT(C, TRAIT_HAULED))
			return FALSE
	..()

/datum/ammo/xeno/acid/spatter
	name = "acid spatter"
	icon_state = "xeno_acid_strong"
	damage = 30
	max_range = 6

/datum/ammo/xeno/acid/spatter/on_hit_mob(mob/M, obj/projectile/P)
	. = ..()
	if(. == FALSE)
		return

	new /datum/effects/acid(M, P.firer)

/datum/ammo/xeno/acid/praetorian
	name = "acid splash"
	icon_state = "xeno_acid_strong"
	accuracy = HIT_ACCURACY_TIER_10 + HIT_ACCURACY_TIER_5
	max_range = 8
	damage = 30
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/xeno/acid/dot
	name = "acid spit"

/datum/ammo/xeno/acid/prae_nade // Used by base prae's acid nade
	name = "acid scatter"
	icon_state = "xeno_acid_normal"
	flags_ammo_behavior = AMMO_ACIDIC|AMMO_XENO|AMMO_STOPPED_BY_COVER
	accuracy = HIT_ACCURACY_TIER_5
	accurate_range = 32
	max_range = 4
	damage = 25
	shell_speed = AMMO_SPEED_TIER_1
	scatter = SCATTER_AMOUNT_TIER_6

	apply_delegate = FALSE

/datum/ammo/xeno/acid/prae_nade/on_hit_mob(mob/M, obj/projectile/P)
	if (!ishuman(M))
		return

	var/mob/living/carbon/human/H = M

	var/datum/effects/prae_acid_stacks/PAS = null
	for (var/datum/effects/prae_acid_stacks/prae_acid_stacks in H.effects_list)
		PAS = prae_acid_stacks
		break

	if (PAS == null)
		PAS = new /datum/effects/prae_acid_stacks(H)
	else
		PAS.increment_stack_count()

/datum/ammo/xeno/boiler_gas
	name = "glob of neuro gas"
	icon_state = "neuro_glob"
	ping = "ping_x"
	debilitate = list(2,2,0,1,11,12,1,10) // Stun,knockdown,knockout,irradiate,stutter,eyeblur,drowsy,agony
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE|AMMO_IGNORE_RESIST|AMMO_HITS_TARGET_TURF|AMMO_ACIDIC
	var/datum/effect_system/smoke_spread/smoke_system
	spit_cost = 200
	pre_spit_warn = TRUE
	spit_windup = 5 SECONDS
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_4
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_4
	accuracy = HIT_ACCURACY_TIER_2
	scatter = SCATTER_AMOUNT_TIER_4
	shell_speed = 0.75
	max_range = 16
	/// range on the smoke in tiles from center
	var/smokerange = 4
	var/lifetime_mult = 1.0

/datum/ammo/xeno/boiler_gas/New()
	..()
	set_xeno_smoke()

/datum/ammo/xeno/boiler_gas/Destroy()
	qdel(smoke_system)
	smoke_system = null
	. = ..()

/datum/ammo/xeno/boiler_gas/on_hit_mob(mob/moob, obj/projectile/proj)
	if(iscarbon(moob))
		var/mob/living/carbon/carbon = moob
		if(carbon.status_flags & XENO_HOST && HAS_TRAIT(carbon, TRAIT_NESTED) || carbon.stat == DEAD || HAS_TRAIT(carbon, TRAIT_HAULED))
			return
	var/datum/effects/neurotoxin/neuro_effect = locate() in moob.effects_list
	if(!neuro_effect)
		neuro_effect = new /datum/effects/neurotoxin(moob, proj.firer)
	neuro_effect.duration += 5
	moob.apply_effect(3, DAZE)
	to_chat(moob, SPAN_HIGHDANGER("Neurotoxic liquid spreads all over you and immediately soaks into your pores and orifices! Oh fuck!")) // Fucked up but have a chance to escape rather than being game-ended
	drop_nade(get_turf(proj), proj,TRUE)

/datum/ammo/xeno/boiler_gas/on_hit_obj(obj/outbacksteakhouse, obj/projectile/proj)
	drop_nade(get_turf(proj), proj)

/datum/ammo/xeno/boiler_gas/on_hit_turf(turf/Turf, obj/projectile/proj)
	if(Turf.density && isturf(proj.loc))
		drop_nade(proj.loc, proj) //we don't want the gas globs to land on dense turfs, they block smoke expansion.
	else
		drop_nade(Turf, proj)

/datum/ammo/xeno/boiler_gas/do_at_max_range(obj/projectile/proj)
	drop_nade(get_turf(proj), proj)

/datum/ammo/xeno/boiler_gas/proc/set_xeno_smoke(obj/projectile/proj)
	smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()

/datum/ammo/xeno/boiler_gas/proc/drop_nade(turf/turf, obj/projectile/proj)
	var/lifetime_mult = 1.0
	var/datum/cause_data
	if(isboiler(proj.firer))
		cause_data = proj.weapon_cause_data
	smoke_system.set_up(smokerange, 0, turf, new_cause_data = cause_data)
	smoke_system.lifetime = 12 * lifetime_mult
	smoke_system.start()
	turf.visible_message(SPAN_DANGER("A glob of acid lands with a splat and explodes into noxious fumes!"))


/datum/ammo/xeno/boiler_gas/acid
	name = "glob of acid gas"
	icon_state = "acid_glob"
	ping = "ping_x"
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_4
	smokerange = 3


/datum/ammo/xeno/boiler_gas/acid/set_xeno_smoke(obj/projectile/proj)
	smoke_system = new /datum/effect_system/smoke_spread/xeno_acid()

/datum/ammo/xeno/boiler_gas/acid/on_hit_mob(mob/moob, obj/projectile/proj)
	if(iscarbon(moob))
		var/mob/living/carbon/carbon = moob
		if(carbon.status_flags & XENO_HOST && HAS_TRAIT(carbon, TRAIT_NESTED) || carbon.stat == DEAD || HAS_TRAIT(carbon, TRAIT_HAULED))
			return
	to_chat(moob,SPAN_HIGHDANGER("Acid covers your body! Oh fuck!"))
	playsound(moob,"acid_strike",75,1)
	INVOKE_ASYNC(moob, TYPE_PROC_REF(/mob, emote), "pain") // why do I need this bullshit
	new /datum/effects/acid(moob, proj.firer)
	drop_nade(get_turf(proj), proj,TRUE)

/datum/ammo/xeno/bone_chips
	name = "bone chips"
	icon_state = "shrapnel_light"
	ping = null
	flags_ammo_behavior = AMMO_XENO|AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR
	damage_type = BRUTE
	bonus_projectiles_type = /datum/ammo/xeno/bone_chips/spread

	damage = 8
	max_range = 6
	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_7
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_7
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_7
	shrapnel_type = /obj/item/shard/shrapnel/bone_chips
	shrapnel_chance = 60

/datum/ammo/xeno/bone_chips/on_hit_mob(mob/living/M, obj/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if((HAS_FLAG(C.status_flags, XENO_HOST) && HAS_TRAIT(C, TRAIT_NESTED)) || C.stat == DEAD || HAS_TRAIT(C, TRAIT_HAULED))
			return
	if(ishuman_strict(M) || isxeno(M))
		playsound(M, 'sound/effects/spike_hit.ogg', 25, 1, 1)
		if(M.slowed < 3)
			M.apply_effect(3, SLOW)

/datum/ammo/xeno/bone_chips/spread
	name = "small bone chips"

	scatter = 30 // We want a wild scatter angle
	max_range = 5
	bonus_projectiles_amount = 0

/datum/ammo/xeno/bone_chips/spread/short_range
	name = "small bone chips"

	max_range = 3 // Very short range

/datum/ammo/xeno/bone_chips/spread/runner_skillshot
	name = "bone chips"

	scatter = 0
	max_range = 5
	damage = 10
	shrapnel_chance = 0

/datum/ammo/xeno/bone_chips/spread/runner/on_hit_mob(mob/living/M, obj/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if((HAS_FLAG(C.status_flags, XENO_HOST) && HAS_TRAIT(C, TRAIT_NESTED)) || C.stat == DEAD || HAS_TRAIT(C, TRAIT_HAULED))
			return
	if(ishuman_strict(M) || isxeno(M))
		playsound(M, 'sound/effects/spike_hit.ogg', 25, 1, 1)
		if(M.slowed < 6)
			M.apply_effect(6, SLOW)

/datum/ammo/xeno/oppressor_tail
	name = "tail hook"
	icon_state = "none"
	ping = null
	flags_ammo_behavior = AMMO_XENO|AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER
	damage_type = BRUTE

	damage = XENO_DAMAGE_TIER_5
	max_range = 4
	accuracy = HIT_ACCURACY_TIER_MAX

/datum/ammo/xeno/oppressor_tail/on_bullet_generation(obj/projectile/generated_projectile, mob/bullet_generator)
	//The projectile has no icon, so the overlay shows up in FRONT of the projectile, and the beam connects to it in the middle.
	var/image/hook_overlay = new(icon = 'icons/effects/beam.dmi', icon_state = "oppressor_tail_hook", layer = BELOW_MOB_LAYER)
	generated_projectile.overlays += hook_overlay

/datum/ammo/xeno/oppressor_tail/on_hit_mob(mob/target, obj/projectile/fired_proj)
	var/mob/living/carbon/xenomorph/xeno_firer = fired_proj.firer
	if(xeno_firer.can_not_harm(target))
		return

	shake_camera(target, 5, 0.1 SECONDS)
	var/obj/effect/beam/tail_beam = fired_proj.firer.beam(target, "oppressor_tail", 'icons/effects/beam.dmi', 0.5 SECONDS, 5)
	var/image/tail_image = image('icons/effects/status_effects.dmi', "hooked")
	target.overlays += tail_image

	new /datum/effects/xeno_slow(target, fired_proj.firer, ttl = 0.5 SECONDS)

	target.apply_effect(0.5, ROOT)
	INVOKE_ASYNC(target, TYPE_PROC_REF(/atom/movable, throw_atom), fired_proj.firer, get_dist(fired_proj.firer, target)-1, SPEED_VERY_FAST)

	qdel(tail_beam)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/ammo/xeno/oppressor_tail, remove_tail_overlay), target, tail_image), 0.5 SECONDS) //needed so it can actually be seen as it gets deleted too quickly otherwise.

/datum/ammo/xeno/oppressor_tail/proc/remove_tail_overlay(mob/overlayed_mob, image/tail_image)
	overlayed_mob.overlays -= tail_image



/datum/ammo/yautja/gauntlet_hook
	name = "chain hook"
	icon_state = "none"
	ping = null
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER
	damage_type = BRUTE

	damage = XENO_DAMAGE_TIER_5
	max_range = 4
	accuracy = HIT_ACCURACY_TIER_MAX

/datum/ammo/yautja/gauntlet_hook/on_bullet_generation(obj/projectile/generated_projectile, mob/bullet_generator)
	//The projectile has no icon, so the overlay shows up in FRONT of the projectile, and the beam connects to it in the middle.
	var/image/hook_overlay = new(icon = 'icons/effects/beam.dmi', icon_state = "chain", layer = BELOW_MOB_LAYER)
	generated_projectile.overlays += hook_overlay

/datum/ammo/yautja/gauntlet_hook/on_hit_mob(mob/target, obj/projectile/fired_proj)
	shake_camera(target, 5, 0.1 SECONDS)
	var/obj/effect/beam/chain_beam = fired_proj.firer.beam(target, "chain", 'icons/effects/beam.dmi', 10 SECONDS, 10)

	var/image/chain_image = image('icons/effects/status_effects.dmi', "chain")
	target.overlays += chain_image

	new /datum/effects/xeno_slow(target, fired_proj.firer, ttl = 0.5 SECONDS)

	target.apply_effect(0.5, ROOT)

	INVOKE_ASYNC(target, TYPE_PROC_REF(/atom/movable, throw_atom), fired_proj.firer, get_dist(fired_proj.firer, target)-1, SPEED_VERY_FAST)

	qdel(chain_beam)

/datum/ammo/yautja/gauntlet_hook/proc/remove_tail_overlay(mob/overlayed_mob, image/chain_image)
	overlayed_mob.overlays -= chain_image
