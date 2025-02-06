/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////

/// Chance that cades block the gas. Smoke spread ticks are calculated very quickly so this has to be high to have a noticeable effect.
#define	BOILER_GAS_CADE_BLOCK_CHANCE 35

/obj/effect/particle_effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = TRUE
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER + 0.1 //above mobs and barricades
	var/amount = 2
	var/spread_speed = 1 //time in decisecond for a smoke to spread one tile.
	var/time_to_live = 8
	var/smokeranking = SMOKE_RANK_HARMLESS //Override priority. A higher ranked smoke cloud will displace lower and equal ones on spreading.
	var/datum/cause_data/cause_data = null

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/particle_effect/smoke/Initialize(mapload, oldamount, datum/cause_data/new_cause_data)
	. = ..()
	if(oldamount)
		amount = oldamount - 1
	if(!istype(new_cause_data))
		if(new_cause_data)
			new_cause_data = create_cause_data(new_cause_data)
		else
			new_cause_data = create_cause_data(name)
	cause_data = new_cause_data
	time_to_live += rand(-1,1)
	START_PROCESSING(SSeffects, src)

/obj/effect/particle_effect/smoke/Destroy()
	. = ..()
	if(opacity)
		set_opacity(0)
	STOP_PROCESSING(SSeffects, src)
	cause_data = null

/obj/effect/particle_effect/smoke/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_SMOKE

/obj/effect/particle_effect/smoke/process()
	time_to_live--
	if(time_to_live <= 0)
		qdel(src)
		return
	else if(time_to_live == 1)
		if(alpha > 180)
			alpha = 180
		amount = 0
		set_opacity(0)

	apply_smoke_effect(get_turf(src))

/obj/effect/particle_effect/smoke/ex_act(severity)
	if(prob(severity/EXPLOSION_THRESHOLD_LOW * 100))
		qdel(src)

/obj/effect/particle_effect/smoke/Crossed(atom/movable/moveable)
	..()
	if(istype(moveable, /obj/projectile/beam))
		var/obj/projectile/beam/beam = moveable
		beam.damage /= 2
	if(iscarbon(moveable))
		affect(moveable)

/obj/effect/particle_effect/smoke/proc/apply_smoke_effect(turf/cur_turf)
	for(var/mob/living/affected_mob in cur_turf)
		affect(affected_mob)

/obj/effect/particle_effect/smoke/proc/spread_smoke(direction)
	set waitfor = 0

	sleep(spread_speed)
	if(QDELETED(src))
		return

	var/turf/start_turf = get_turf(src)
	if(!start_turf)
		return
	for(var/i in GLOB.cardinals)
		if(direction && i != direction)
			continue
		var/turf/cur_turf = get_step(start_turf, i)
		if(check_airblock(start_turf, cur_turf)) //smoke can't spread that way
			continue
		var/obj/effect/particle_effect/smoke/foundsmoke = locate() in cur_turf // Check for existing smoke and act accordingly
		if(foundsmoke)
			if(foundsmoke.smokeranking <= src.smokeranking)
				qdel(foundsmoke)
			else
				continue
		var/obj/effect/particle_effect/smoke/smoke = new type(cur_turf, amount, cause_data)
		smoke.setDir(pick(GLOB.cardinals))
		smoke.time_to_live = time_to_live
		if(smoke.amount > 0)
			smoke.spread_smoke()


//proc to check if smoke can expand to another turf
/obj/effect/particle_effect/smoke/proc/check_airblock(turf/start_turf, turf/cur_turf)
	if(!cur_turf)
		return FALSE
	if(cur_turf.density)
		return TRUE
	if(prob(BOILER_GAS_CADE_BLOCK_CHANCE))
		var/move_dir = 0
		for(var/obj/structure/obstacle in cur_turf)
			move_dir = get_dir(src, cur_turf)
			if(obstacle.BlockedPassDirs(src, move_dir))
				return TRUE


/obj/effect/particle_effect/smoke/proc/affect(mob/living/carbon/affected_mob)
	if(!istype(affected_mob))
		return FALSE
	return TRUE

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/bad
	time_to_live = 10
	smokeranking = SMOKE_RANK_LOW

/obj/effect/particle_effect/smoke/bad/Move()
	. = ..()
	for(var/mob/living/carbon/affected_mob in get_turf(src))
		affect(affected_mob)

/obj/effect/particle_effect/smoke/bad/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE
	if(affected_mob.internal != null && affected_mob.wear_mask && (affected_mob.wear_mask.flags_inventory & ALLOWINTERNALS))
		return FALSE
	if(issynth(affected_mob))
		return FALSE

	if(prob(20))
		affected_mob.drop_held_item()
	affected_mob.apply_damage(1, OXY)

	if(affected_mob.coughedtime < world.time && !affected_mob.stat)
		affected_mob.coughedtime = world.time + 2 SECONDS
		if(ishuman(affected_mob)) //Humans only to avoid issues
			affected_mob.emote("cough")
	return TRUE

/////////////////////////////////////////////
// Miasma smoke (for LZs)
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/miasma
	name = "CN20-X miasma"
	amount = 1
	time_to_live = INFINITY
	smokeranking = SMOKE_RANK_MAX
	opacity = FALSE
	alpha = 75
	color = "#301934"
	/// How much damage to deal per affect()
	var/burn_damage = 4
	/// Multiplier to burn_damage for xenos and yautja
	var/xeno_yautja_multiplier = 3
	/// Time required for damage to actually apply
	var/active_time

/obj/effect/particle_effect/smoke/miasma/Initialize(mapload, oldamount, datum/cause_data/new_cause_data)
	. = ..()
	// Mimic dispersal without actually doing spread logic
	alpha = 0
	active_time = world.time + 6 SECONDS
	addtimer(VARSET_CALLBACK(src, alpha, initial(alpha)), rand(1, 6) SECONDS)

/obj/effect/particle_effect/smoke/miasma/apply_smoke_effect(turf/cur_turf)
	..()
	// coffins
	for(var/obj/structure/closet/container in cur_turf)
		for(var/mob/living/carbon/mob in container)
			affect(mob)

	// vehicles
	var/obj/vehicle/multitile/car = locate() in cur_turf
	var/datum/interior/car_interior = car?.interior
	if(car_interior)
		var/list/bounds = car_interior.get_bound_turfs()
		for(var/turf/car_turf as anything in block(bounds[1], bounds[2]))
			var/obj/effect/particle_effect/smoke/miasma/smoke = locate() in car_turf
			if(!smoke)
				smoke = new(car_turf)
			smoke.time_to_live = rand(7, 12)

/obj/effect/particle_effect/smoke/miasma/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE
	if(affected_mob.stat == DEAD)
		return FALSE

	var/active = world.time > active_time
	var/damage = active ? burn_damage : 0 // A little buffer time to get out of it
	if(isxeno(affected_mob))
		damage *= xeno_yautja_multiplier
	else if(isyautja(affected_mob))
		if(prob(75))
			return FALSE
		damage *= xeno_yautja_multiplier

	affected_mob.apply_damage(damage, BURN)
	affected_mob.AdjustEyeBlur(0.75)
	affected_mob.last_damage_data = cause_data

	if(affected_mob.coughedtime < world.time && !affected_mob.stat)
		affected_mob.coughedtime = world.time + 2 SECONDS
		if(ishuman(affected_mob)) //Humans only to avoid issues
			if(issynth(affected_mob))
				affected_mob.visible_message(SPAN_DANGER("[affected_mob]'s skin is sloughing off!"),
				SPAN_DANGER("Your skin is sloughing off!"))
			else
				if(prob(50))
					affected_mob.emote("cough")
				else
					affected_mob.emote("gasp")
			if(prob(20))
				affected_mob.drop_held_item()
		to_chat(affected_mob, SPAN_DANGER("Something is not right here..."))
	return TRUE

/obj/effect/particle_effect/smoke/miasma/ex_act(severity)
	return

/obj/effect/particle_effect/smoke/weedkiller
	name = "C10-W Weedkiller"
	amount = 1
	time_to_live = 15
	smokeranking = SMOKE_RANK_HARMLESS
	opacity = FALSE
	color = "#c2aac7"
	alpha = 0

/obj/effect/particle_effect/smoke/weedkiller/Initialize(mapload, oldamount, datum/cause_data/new_cause_data)
	. = ..()

	animate(src, alpha = 75, time = rand(1 SECONDS, 5 SECONDS))

/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/sleepy
	smokeranking = SMOKE_RANK_MED

/obj/effect/particle_effect/smoke/sleepy/Move()
	. = ..()
	for(var/mob/living/carbon/affected_mob in get_turf(src))
		affect(affected_mob)

/obj/effect/particle_effect/smoke/sleepy/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE
	if(affected_mob.stat == DEAD)
		return FALSE
	if(issynth(affected_mob))
		return FALSE

	affected_mob.drop_held_item()
	affected_mob.sleeping++

	if(affected_mob.coughedtime < world.time && !affected_mob.stat)
		affected_mob.coughedtime = world.time + 2 SECONDS
		if(ishuman(affected_mob)) //Humans only to avoid issues
			affected_mob.emote("cough")
	return TRUE

/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/mustard
	name = "mustard gas"
	icon = 'icons/effects/effects.dmi'
	icon_state = "mustard"
	smokeranking = SMOKE_RANK_HIGH

/obj/effect/particle_effect/smoke/mustard/Move()
	. = ..()
	for(var/mob/living/carbon/human/creature in get_turf(src))
		affect(creature)

/obj/effect/particle_effect/smoke/mustard/affect(mob/living/carbon/human/creature)
	. = ..()
	if(!.)
		return FALSE
	if(issynth(creature))
		return FALSE

	if(creature.burn_skin(0.75))
		creature.last_damage_data = cause_data

	if(creature.coughedtime < world.time && !creature.stat)
		creature.coughedtime = world.time + 2 SECONDS
		if(ishuman(creature)) //Humans only to avoid issues
			creature.emote("gasp")
	return TRUE

/////////////////////////////////////////////
// Phosphorus Gas
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/phosphorus
	time_to_live = 3
	smokeranking = SMOKE_RANK_MED
	var/next_cough = 2 SECONDS
	var/burn_damage = 40
	var/applied_fire_stacks = 5
	var/xeno_yautja_reduction = 0.75

/obj/effect/particle_effect/smoke/phosphorus/Initialize(mapload, oldamount, datum/cause_data/new_cause_data, intensity, max_intensity)
	burn_damage = min(burn_damage, max_intensity - intensity) // Applies reaction limits

	. = ..()

/obj/effect/particle_effect/smoke/phosphorus/weak
	time_to_live = 2
	smokeranking = SMOKE_RANK_MED
	burn_damage = 30
	xeno_yautja_reduction = 0.5

/obj/effect/particle_effect/smoke/phosphorus/Move()
	. = ..()
	for(var/mob/living/carbon/affected_mob in get_turf(src))
		affect(affected_mob)

/obj/effect/particle_effect/smoke/phosphorus/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE

	var/damage = burn_damage
	if(ishuman(affected_mob))
		if(affected_mob.internal != null && affected_mob.wear_mask && (affected_mob.wear_mask.flags_inventory & ALLOWINTERNALS))
			return FALSE

		if(prob(20))
			affected_mob.drop_held_item()
		affected_mob.apply_damage(1, OXY)

		if(affected_mob.coughedtime < world.time && !affected_mob.stat)
			affected_mob.coughedtime = world.time + next_cough
			if(issynth(affected_mob))
				affected_mob.visible_message(SPAN_DANGER("[affected_mob]'s skin is sloughing off!"),
				SPAN_DANGER("Your skin is sloughing off!"))
			else
				affected_mob.emote("cough")

	if(isyautja(affected_mob) || isxeno(affected_mob))
		damage *= xeno_yautja_reduction

	var/reagent = new /datum/reagent/napalm/ut()
	affected_mob.burn_skin(damage)
	affected_mob.adjust_fire_stacks(applied_fire_stacks, reagent)
	affected_mob.IgniteMob()
	affected_mob.updatehealth()
	affected_mob.last_damage_data = cause_data
	return TRUE

/////////////////////////////////////////////
// CN20 Nerve Gas
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/cn20
	name = "CN20 nerve gas"
	smokeranking = SMOKE_RANK_HIGH
	color = "#80c7e4"
	var/xeno_affecting = FALSE
	opacity = FALSE
	alpha = 75

/obj/effect/particle_effect/smoke/cn20/xeno
	name = "CN20-X nerve gas"
	color = "#2da9da"
	xeno_affecting = TRUE

/obj/effect/particle_effect/smoke/cn20/Move()
	. = ..()
	if(!xeno_affecting)
		for(var/mob/living/carbon/human/human in get_turf(src))
			affect(human)
	else
		for(var/mob/living/carbon/creature in get_turf(src))
			affect(creature)

/obj/effect/particle_effect/smoke/cn20/affect(mob/living/carbon/creature)
	. = ..()
	if(!.)
		return FALSE
	if(creature.stat == DEAD)
		return FALSE
	if(issynth(creature))
		return FALSE

	var/mob/living/carbon/xenomorph/xeno_creature
	var/mob/living/carbon/human/human_creature
	if(isxeno(creature))
		xeno_creature = creature
	else if(ishuman(creature))
		human_creature = creature

	if(!xeno_affecting && xeno_creature)
		return FALSE
	if(isyautja(creature) && prob(75))
		return FALSE

	if(creature.wear_mask && (creature.wear_mask.flags_inventory & BLOCKGASEFFECT))
		return FALSE
	if(human_creature && (human_creature.head && (human_creature.head.flags_inventory & BLOCKGASEFFECT)))
		return FALSE

	var/effect_amt = floor(6 + amount*6)

	if(xeno_creature)
		xeno_creature.AddComponent(/datum/component/status_effect/interference, 10, 10)
		xeno_creature.blinded = TRUE
	else
		creature.apply_damage(12, OXY)

	creature.SetEarDeafness(max(creature.ear_deaf, floor(effect_amt*1.5))) //Paralysis of hearing system, aka deafness
	if(!xeno_creature && !creature.eye_blind) //Eye exposure damage
		to_chat(creature, SPAN_DANGER("Your eyes sting. You can't see!"))
		creature.SetEyeBlind(floor(effect_amt/3))

	if(human_creature && creature.coughedtime < world.time && !creature.stat) //Coughing/gasping
		creature.coughedtime = world.time + 1.5 SECONDS
		if(prob(50))
			creature.emote("cough")
		else
			creature.emote("gasp")

	var/stun_chance = 20
	if(xeno_affecting)
		stun_chance = 35
	if(prob(stun_chance))
		creature.KnockDown(2)

	//Topical damage (neurotoxin on exposed skin)
	if(xeno_creature)
		to_chat(xeno_creature, SPAN_XENODANGER("You are struggling to move, it's as if you're paralyzed!"))
	else
		to_chat(creature, SPAN_DANGER("Your body is going numb, almost as if paralyzed!"))
	if(prob(60 + floor(amount*15))) //Highly likely to drop items due to arms/hands seizing up
		creature.drop_held_item()
	if(human_creature)
		human_creature.temporary_slowdown = max(human_creature.temporary_slowdown, 4) //One tick every two second
		human_creature.recalculate_move_delay = TRUE
	return TRUE

//////////////////////////////////////
// FLASHBANG SMOKE
////////////////////////////////////

/obj/effect/particle_effect/smoke/flashbang
	name = "illumination"
	time_to_live = 4
	opacity = FALSE
	icon_state = "sparks"
	icon = 'icons/effects/effects.dmi'
	smokeranking = SMOKE_RANK_MED

/////////////////////////////////////////
// Acid Runner Smoke, Harmless Visuals only
/////////////////////////////////////////
/obj/effect/particle_effect/smoke/acid_runner_harmless
	color = "#86B028"
	time_to_live = 2
	opacity = FALSE
	alpha = 200
	smokeranking = SMOKE_RANK_HARMLESS
	amount = 0

/////////////////////////////////////////
// BOILER SMOKES
/////////////////////////////////////////

//Xeno acid smoke.
/obj/effect/particle_effect/smoke/xeno_burn
	time_to_live = 12
	color = "#86B028" //Mostly green?
	anchored = TRUE
	spread_speed = 6
	smokeranking = SMOKE_RANK_BOILER

	var/hivenumber = XENO_HIVE_NORMAL
	var/gas_damage = 20

/obj/effect/particle_effect/smoke/xeno_burn/Initialize(mapload, amount, datum/cause_data/cause_data)
	if(istype(cause_data))
		var/datum/ui_state/hive_state/cause_data_hive_state = GLOB.hive_state[cause_data.faction]
		var/new_hive_number = cause_data_hive_state?.hivenumber
		if(new_hive_number)
			hivenumber = new_hive_number
			set_hive_data(src, new_hive_number)

	return ..()

/obj/effect/particle_effect/smoke/xeno_burn/apply_smoke_effect(turf/cur_turf)
	..()
	for(var/obj/structure/barricade/barricade in cur_turf)
		barricade.take_acid_damage(XENO_ACID_GAS_BARRICADE_DAMAGE)
		if(prob(75)) // anti sound spam
			playsound(src, pick("acid_sizzle", "acid_hit"), 25)

	for(var/obj/vehicle/multitile/vehicle in cur_turf)
		vehicle.take_damage_type(15, "acid")

	for(var/obj/structure/machinery/m56d_hmg/auto/gun in cur_turf)
		gun.update_health(XENO_ACID_HMG_DAMAGE)

//No effect when merely entering the smoke turf, for balance reasons
/obj/effect/particle_effect/smoke/xeno_burn/Crossed(mob/living/carbon/affected_mob as mob)
	return

/obj/effect/particle_effect/smoke/xeno_burn/affect(mob/living/carbon/affected_mob)
	. = ..()
	if(!.)
		return FALSE
	if(affected_mob.stat == DEAD)
		return FALSE
	if(affected_mob.ally_of_hivenumber(hivenumber))
		return FALSE
	if(isyautja(affected_mob) && prob(75))
		return FALSE
	if(HAS_TRAIT(affected_mob, TRAIT_NESTED) && affected_mob.status_flags & XENO_HOST)
		return FALSE

	affected_mob.last_damage_data = cause_data
	affected_mob.apply_damage(3, OXY) //Basic oxyloss from "can't breathe"

	if(isxeno(affected_mob))
		affected_mob.apply_damage(gas_damage * XVX_ACID_DAMAGEMULT, BURN) //Inhalation damage
	else
		affected_mob.apply_damage(gas_damage, BURN) //Inhalation damage

	if(affected_mob.coughedtime < world.time && !affected_mob.stat && ishuman(affected_mob)) //Coughing/gasping
		affected_mob.coughedtime = world.time + 1.5 SECONDS
		if(issynth(affected_mob))
			affected_mob.visible_message(SPAN_DANGER("[affected_mob]'s skin is sloughing off!"),
			SPAN_DANGER("Your skin is sloughing off!"))
		else
			if(prob(50))
				affected_mob.emote("cough")
			else
				affected_mob.emote("gasp")

	//Topical damage (acid on exposed skin)
	to_chat(affected_mob, SPAN_DANGER("Your skin feels like it is melting away!"))
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/human = affected_mob
		human.apply_armoured_damage(amount*rand(15, 20), ARMOR_BIO, BURN) //Burn damage, randomizes between various parts //Amount corresponds to upgrade level, 1 to 2.5
	else
		affected_mob.burn_skin(5) //Failsafe for non-humans
	affected_mob.last_damage_data = cause_data
	return TRUE

//Xeno neurotox smoke.
/obj/effect/particle_effect/smoke/xeno_weak
	time_to_live = 12
	color = "#ffbf58" //Mustard orange?
	spread_speed = 5
	amount = 1 //Amount depends on Boiler upgrade!
	smokeranking = SMOKE_RANK_BOILER
	/// How much neuro is dosed per tick
	var/neuro_dose = 6
	var/msg = "Your skin tingles as the gas consumes you!" // Message given per tick. Changes depending on which species is hit.

//No effect when merely entering the smoke turf, for balance reasons
/obj/effect/particle_effect/smoke/xeno_weak/Crossed(mob/living/carbon/moob as mob)
	return

/obj/effect/particle_effect/smoke/xeno_weak/affect(mob/living/carbon/moob) // This applies every tick someone is in the smoke
	. = ..()
	if(!.)
		return FALSE
	if(moob.stat == DEAD)
		return FALSE
	if(isxeno(moob))
		return FALSE
	if(isyautja(moob))
		return FALSE
	if(HAS_TRAIT(moob, TRAIT_NESTED) && moob.status_flags & XENO_HOST)
		return FALSE

	var/mob/living/carbon/human/human_moob
	if(ishuman(moob))
		human_moob = moob
		if(human_moob.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO)
			return FALSE

	var/effect_amt = floor(6 + amount*6)
	moob.eye_blurry = max(moob.eye_blurry, effect_amt)
	moob.EyeBlur(max(moob.eye_blurry, effect_amt))
	moob.apply_damage(5, OXY) //  Base "I can't breath oxyloss" Slightly more longer lasting then stamina damage
	// reworked code below
	if(!issynth(moob))
		var/datum/effects/neurotoxin/neuro_effect = locate() in moob.effects_list
		if(!neuro_effect)
			neuro_effect = new(moob, cause_data.resolve_mob())
			neuro_effect.strength = effect_amt
		neuro_effect.duration += neuro_dose
		if(human_moob && moob.coughedtime < world.time && !moob.stat) //Coughing/gasping
			moob.coughedtime = world.time + 1.5 SECONDS
			if(prob(50))
				moob.Slow(1)
				moob.emote("cough")
			else
				moob.emote("gasp")
	else
		msg = "You are consumed by the harmless gas, it is hard to navigate in!"
		moob.Slow(1)
	to_chat(moob, SPAN_DANGER(msg))
	return TRUE

/obj/effect/particle_effect/smoke/xeno_weak_fire
	time_to_live = 16
	color = "#b33e1e"
	spread_speed = 7
	amount = 1
	smokeranking = SMOKE_RANK_BOILER

//No effect when merely entering the smoke turf, for balance reasons
/obj/effect/particle_effect/smoke/xeno_weak_fire/Crossed(mob/living/carbon/moob as mob)
	if(!istype(moob))
		return

	moob.ExtinguishMob()
	. = ..()

/obj/effect/particle_effect/smoke/xeno_weak_fire/affect(mob/living/carbon/moob)
	. = ..()
	if(!.)
		return FALSE
	if(moob.stat == DEAD)
		return FALSE
	if(isxeno(moob))
		return FALSE
	if(isyautja(moob) && prob(75))
		return FALSE
	if(HAS_TRAIT(moob, TRAIT_NESTED) && moob.status_flags & XENO_HOST)
		return FALSE

	var/mob/living/carbon/human/human_moob
	if(ishuman(moob))
		human_moob = moob

	var/effect_amt = floor(6 + amount*6)

	moob.apply_damage(9, OXY) // MUCH harsher
	moob.SetEarDeafness(max(moob.ear_deaf, floor(effect_amt*1.5))) //Paralysis of hearing system, aka deafness
	if(!moob.eye_blind) //Eye exposure damage
		to_chat(moob, SPAN_DANGER("Your eyes sting. You can't see!"))
	moob.SetEyeBlind(floor(effect_amt/3))

	if(human_moob && moob.coughedtime < world.time && !moob.stat) //Coughing/gasping
		moob.coughedtime = world.time + 1.5 SECONDS
		if(!issynth(moob))
			if(prob(50))
				moob.emote("cough")
			else
				moob.emote("gasp")

	if(prob(20))
		moob.KnockDown(1)

	//Topical damage (neurotoxin on exposed skin)
	to_chat(moob, SPAN_DANGER("Your body is going numb, almost as if paralyzed!"))
	if(prob(40 + floor(amount*15))) //Highly likely to drop items due to arms/hands seizing up
		moob.drop_held_item()
	if(human_moob)
		human_moob.temporary_slowdown = max(human_moob.temporary_slowdown, 4) //One tick every two second
		human_moob.recalculate_move_delay = TRUE
	return TRUE

/obj/effect/particle_effect/smoke/xeno_weak_fire/spread_smoke(direction)
	set waitfor = 0
	sleep(spread_speed)
	if(QDELETED(src))
		return
	var/turf/start_turf = get_turf(src)
	if(!start_turf)
		return
	for(var/i in GLOB.cardinals)
		if(direction && i != direction)
			continue
		var/turf/cur_turf = get_step(start_turf, i)
		if(check_airblock(start_turf, cur_turf)) //smoke can't spread that way
			continue
		var/obj/effect/particle_effect/smoke/foundsmoke = locate() in cur_turf // Check for existing smoke and act accordingly
		if(foundsmoke)
			if(foundsmoke.smokeranking <= smokeranking)
				qdel(foundsmoke)
			else
				continue
		var/obj/effect/particle_effect/smoke/smoke = new type(cur_turf, amount, cause_data)

		for (var/atom/cur_atom in cur_turf)
			if (istype(cur_atom, /mob/living))
				var/mob/living/affected_mob = cur_atom
				affected_mob.ExtinguishMob()
			if(istype(cur_atom, /obj/flamer_fire))
				qdel(cur_atom)

		smoke.setDir(pick(GLOB.cardinals))
		smoke.time_to_live = time_to_live
		if(smoke.amount > 0)
			smoke.spread_smoke()


/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect_system/smoke_spread
	var/amount = 3
	var/smoke_type = /obj/effect/particle_effect/smoke
	var/direction
	var/lifetime
	var/datum/cause_data/cause_data = null

/datum/effect_system/smoke_spread/Destroy()
	cause_data = null
	. = ..()

/datum/effect_system/smoke_spread/set_up(radius = 2, c = 0, loca, direct, smoke_time, datum/cause_data/new_cause_data)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct
	if(smoke_time)
		lifetime = smoke_time
	radius = min(radius, 10)
	amount = radius
	cause_data = istype(new_cause_data) ? new_cause_data : create_cause_data(new_cause_data)

/datum/effect_system/smoke_spread/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/smoke = new smoke_type(location, amount+1, cause_data)
	if(lifetime)
		smoke.time_to_live = lifetime
	if(smoke.amount > 0)
		smoke.spread_smoke(direction)

/datum/effect_system/smoke_spread/bad
	smoke_type = /obj/effect/particle_effect/smoke/bad

/datum/effect_system/smoke_spread/sleepy
	smoke_type = /obj/effect/particle_effect/smoke/sleepy

/datum/effect_system/smoke_spread/mustard
	smoke_type = /obj/effect/particle_effect/smoke/mustard

/datum/effect_system/smoke_spread/phosphorus
	smoke_type = /obj/effect/particle_effect/smoke/phosphorus

/datum/effect_system/smoke_spread/phosphorus/start(intensity, max_intensity)
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/phosphorus/smoke = new smoke_type(location, amount+1, cause_data, intensity, max_intensity)
	if(lifetime)
		smoke.time_to_live = lifetime
	if(smoke.amount > 0)
		smoke.spread_smoke(direction)

/datum/effect_system/smoke_spread/phosphorus/weak
	smoke_type = /obj/effect/particle_effect/smoke/phosphorus/weak

/datum/effect_system/smoke_spread/cn20
	smoke_type = /obj/effect/particle_effect/smoke/cn20

/datum/effect_system/smoke_spread/cn20/xeno
	smoke_type = /obj/effect/particle_effect/smoke/cn20/xeno

// XENO SMOKES

/obj/effect/particle_effect/smoke/king
	opacity = FALSE
	color = "#000000"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER
	time_to_live = 5
	spread_speed = 1
	pixel_x = 0
	pixel_y = 0

/datum/effect_system/smoke_spread/king_doom
	smoke_type = /obj/effect/particle_effect/smoke/king

/datum/effect_system/smoke_spread/xeno_acid
	smoke_type = /obj/effect/particle_effect/smoke/xeno_burn

/datum/effect_system/smoke_spread/xeno_weaken
	smoke_type = /obj/effect/particle_effect/smoke/xeno_weak

/datum/effect_system/smoke_spread/xeno_extinguish_fire
	smoke_type = /obj/effect/particle_effect/smoke/xeno_weak_fire

/datum/effect_system/smoke_spread/xeno_extinguish_fire/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/smoke = new smoke_type(location, amount+1, cause_data)

	for (var/atom/cur_atom in location)
		if (istype(cur_atom, /mob/living))
			var/mob/living/affected_mob = cur_atom
			affected_mob.ExtinguishMob()
		if(istype(cur_atom, /obj/flamer_fire))
			qdel(cur_atom)

	if(lifetime)
		smoke.time_to_live = lifetime
	if(smoke.amount > 0)
		smoke.spread_smoke(direction)
