//
// Specific momentum based damage defines

#define CHARGER_DESTROY CCA.momentum * 40
#define CHARGER_DAMAGE_CADE CCA.momentum * 22
#define CHARGER_DAMAGE_SENTRY CCA.momentum * 9
#define CHARGER_DAMAGE_MG CCA.momentum * 15


// Momentum loss defines. 8 is maximum momentum
#define CCA_MOMENTUM_LOSS_HALF 		4
#define CCA_MOMENTUM_LOSS_THIRD 	3
#define CCA_MOMENTUM_LOSS_QUARTER 	2
#define CCA_MOMENTUM_LOSS_MIN 		1


/datum/xeno_mutator/charger
	name = "STRAIN: Crusher - Charger"
	description = "Your charge is now momentum based, the further you go, the more damage and speed you will get until you achieve max momentum when you roar. Your armor is now directional, being the toughest on the front, weaker on the sides and weakest at the back. Your shield is also removed. In return you gain more health, gain an ability to tumble to avoid enemies, and gain an ability to forcefully move enemies via ramming. Finally, you trade being able to resist slowdowns from tall autospitters for being unaffected by frenzy pheros."
	flavor_description = "We're just getting started. Nothing stops this train."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_CRUSHER)
	mutator_actions_to_remove = list (
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/onclick/crusher_shield,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/charger_charge,
		/datum/action/xeno_action/activable/tumble,
		/datum/action/xeno_action/onclick/crusher_stomp/charger,
		/datum/action/xeno_action/activable/fling/charger
	)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/crusher_charger

/datum/xeno_mutator/charger/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Crusher/C = MS.xeno
	C.mutation_type = CRUSHER_CHARGER
	C.small_explosives_stun = FALSE
	C.health_modifier += XENO_HEALTH_MOD_LARGE
	C.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	C.armor_modifier -= XENO_ARMOR_MOD_SMALL
	C.ignore_aura = "frenzy" // no funny crushers going 7 morbillion kilometers per second
	C.phero_modifier = -C.caste.aura_strength
	C.recalculate_pheromones()
	mutator_update_actions(C)
	MS.recalculate_actions(description, flavor_description)
	apply_behavior_holder(C)
	C.recalculate_everything()

/datum/behavior_delegate/crusher_charger
	name = "Charger Crusher Behavior Delegate"

	var/frontal_armor = 30
	var/side_armor = 15

/datum/behavior_delegate/crusher_charger/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_MOB_SET_FACE_DIR, .proc/cancel_dir_lock)
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, .proc/apply_directional_armor)

/datum/behavior_delegate/crusher_charger/proc/cancel_dir_lock()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_SET_FACE_DIR

/datum/behavior_delegate/crusher_charger/proc/apply_directional_armor(mob/living/carbon/Xenomorph/X, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(X.dir & REVERSE_DIR(projectile_direction))
		// During the charge windup, crusher gets an extra 15 directional armor in the direction its charging
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(X.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += side_armor
				return

/datum/behavior_delegate/crusher_charger/on_update_icons()
	if(HAS_TRAIT(bound_xeno, TRAIT_CHARGING) && !bound_xeno.lying)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Crusher Charging"
		return TRUE

// Fallback proc for shit that doesn't have a collision def

/atom/proc/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	CCA.stop_momentum()

// Windows

/obj/structure/window/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(unacidable)
		CCA.stop_momentum()
		return

	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	health -= CHARGER_DESTROY //Usually knocks it down.
	healthcheck()

	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Grills

/obj/structure/grille/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(unacidable)
		CCA.stop_momentum()
		return

	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	health -= CHARGER_DESTROY //Usually knocks it down.
	healthcheck()

	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turf worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Airlock Doors

/obj/structure/machinery/door/airlock/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	// Need at least 4 momentum to destroy a full health door
	take_damage(CCA.momentum * damage_cap * 0.25, X)
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Vending machines

/obj/structure/machinery/vending/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum >= 3)
		if(unacidable)
			CCA.stop_momentum()
			return
		X.visible_message(
			SPAN_DANGER("[X] smashes straight into \the [src]!"),
			SPAN_XENODANGER("You smash straight into \the [src]!")
		)
		playsound(loc, "punch", 25, TRUE)
		tip_over()
		step_away(src, X)
		step_away(src, X)
		CCA.lose_momentum(2)
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()


// Barine Vending machines

/obj/structure/machinery/cm_vending/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum >= CCA_MOMENTUM_LOSS_THIRD)
		X.visible_message(
			SPAN_DANGER("[X] smashes straight into \the [src]!"),
			SPAN_XENODANGER("You smash straight into \the [src]!")
		)
		playsound(loc, "punch", 25, TRUE)
		tip_over()
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Legacy doors

/obj/structure/mineral_door/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	playsound(loc, "punch", 25, TRUE)
	Dismantle(TRUE)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
	return XENO_CHARGE_TRY_MOVE

// Tables & shelves, etc

/obj/structure/surface/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	Crossed(X)
	return XENO_CHARGE_TRY_MOVE

// Cades

/obj/structure/barricade/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum)
		visible_message(
			SPAN_DANGER("[X] rams into \the [src] and skids to a halt!"),
			SPAN_XENOWARNING("You ram into \the [src] and skid to a halt!")
		)
		take_damage(CCA.momentum * 22)
		playsound(src, barricade_hitsound, 25, TRUE)

	CCA.stop_momentum()

// wFrames

/obj/structure/window_frame/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum)
		playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)
		take_damage(CHARGER_DESTROY*2)
		if(QDELETED(src))
			CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
			return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Doors

/obj/structure/machinery/door/poddoor/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum < CCA_MOMENTUM_LOSS_HALF)
		CCA.stop_momentum()
		return

	if(!indestructible && !unacidable)
		qdel(src)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, TRUE)
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Closets

/obj/structure/closet/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	take_damage(CHARGER_DESTROY)
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Fences
/obj/structure/fence/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	update_health(CHARGER_DAMAGE_CADE)
	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	if(QDELETED(src))
		if(prob(50))
			CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Crates

/obj/structure/largecrate/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	var/turf/T = get_turf(src)
	new /obj/item/stack/sheet/wood(T)
	for(var/obj/O in contents)
		O.forceMove(T)

	qdel(src)
	playsound(src, 'sound/effects/woodhit.ogg', 25, TRUE)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Cargo containers

/obj/structure/cargo_container/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	qdel(src)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_HALF)
	return XENO_CHARGE_TRY_MOVE

// Girders

/obj/structure/girder/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return

	playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)
	take_damage(CHARGER_DESTROY)
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_HALF)
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// General Machinery

/obj/structure/machinery/disposal/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum < CCA_MOMENTUM_LOSS_QUARTER)
		CCA.stop_momentum()
		return
	var/obj/structure/disposalconstruct/C = new(loc)
	C.ptype = 6 //6 = disposal unit
	C.density = TRUE
	C.update()
	step_away(C, X, 2)
	qdel(src)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
	return XENO_CHARGE_TRY_MOVE

// Disposals

/obj/structure/disposalconstruct/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	step_away(src, X, 2)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Humans

/mob/living/carbon/human/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	playsound(loc, "punch", 25, TRUE)
	attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [X] ([X.ckey])</font>")
	X.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src] ([src.ckey])</font>")
	log_attack("[X] ([X.ckey]) xeno charged [src] ([src.ckey])")
	var/momentum_mult = 5
	if(CCA.momentum == CCA.max_momentum)
		momentum_mult = 8
	take_overall_armored_damage(CCA.momentum * momentum_mult, ARMOR_MELEE, BRUTE, 50, 13) // Giving AP because this spreads damage out and then applies armor to them
	apply_armoured_damage(CCA.momentum * momentum_mult/4,ARMOR_MELEE, BRUTE,"chest")
	X.visible_message(
		SPAN_DANGER("[X] rams \the [src]!"),
		SPAN_XENODANGER("You ram \the [src]!")
	)
	var/knockdown = 1
	if(CCA.momentum == CCA.max_momentum)
		knockdown = 2
	KnockDown(knockdown)
	animation_flash_color(src)
	if(client)
		shake_camera(src, 1, 3)
	var/list/ram_dirs = get_perpen_dir(X.dir)
	var/ram_dir = pick(ram_dirs)
	var/cur_turf = get_turf(src)
	var/target_turf = get_step(src, ram_dir)
	if(LinkBlocked(src, cur_turf, target_turf))
		ram_dir = REVERSE_DIR(ram_dir)
	step(src, ram_dir, CCA.momentum * 0.5)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Fellow xenos

/mob/living/carbon/Xenomorph/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum)
		playsound(loc, "punch", 25, TRUE)
		if(!X.ally_of_hivenumber(hivenumber))
			attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [X] ([X.ckey])</font>")
			X.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src] ([ckey])</font>")
			log_attack("[X] ([X.ckey]) xeno charged [src] ([ckey])")
			apply_damage(CCA.momentum * 10, BRUTE) // half damage to avoid sillyness
		if(anchored) //Ovipositor queen can't be pushed
			CCA.stop_momentum()
			return
		if(HAS_TRAIT(src, TRAIT_CHARGING))
			KnockDown(2)
			X.KnockDown(2)
			src.throw_atom(pick(cardinal),1,3,X,TRUE)
			X.throw_atom(pick(cardinal),1,3,X,TRUE)
			CCA.stop_momentum() // We assume the other crusher's handle_charge_collision() kicks in and stuns us too.
			playsound(get_turf(X), 'sound/effects/bang.ogg', 25, 0)
			return
		var/list/ram_dirs = get_perpen_dir(X.dir)
		var/ram_dir = pick(ram_dirs)
		var/cur_turf = get_turf(src)
		var/target_turf = get_step(src, ram_dir)
		if(LinkBlocked(src, cur_turf, target_turf))
			X.emote("roar")
			X.visible_message(SPAN_DANGER("[X] flings [src] over to the side!"),SPAN_DANGER( "You fling [src] out of the way!"))
			to_chat(src,SPAN_XENOHIGHDANGER("[src] flings you out of its way! Move it!"))
			KnockDown(1) // brief flicker stun
			src.throw_atom(src.loc,1,3,X,TRUE)
		step(src, ram_dir, CCA.momentum * 0.5)
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
		return XENO_CHARGE_TRY_MOVE
	CCA.stop_momentum()

// Other mobs

/mob/living/carbon/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	playsound(loc, "punch", 25, TRUE)
	attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [X] ([X.ckey])</font>")
	X.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src] ([src.ckey])</font>")
	log_attack("[X] ([X.ckey]) xeno charged [src] ([src.ckey])")
	var/momentum_mult = 5
	if(CCA.momentum == CCA.max_momentum)
		momentum_mult = 8
	take_overall_damage(CCA.momentum * momentum_mult)
	X.visible_message(
		SPAN_DANGER("[X] rams \the [src]!"),
		SPAN_XENODANGER("You ram \the [src]!")
	)
	var/knockdown = 1
	if(CCA.momentum == CCA.max_momentum)
		knockdown = 2
	KnockDown(knockdown)
	animation_flash_color(src)
	if(client)
		shake_camera(src, 1, 3)
	var/list/ram_dirs = get_perpen_dir(X.dir)
	var/ram_dir = pick(ram_dirs)
	var/cur_turf = get_turf(src)
	var/target_turf = get_step(src, ram_dir)
	if(LinkBlocked(src, cur_turf, target_turf))
		ram_dir = REVERSE_DIR(ram_dir)
	step(src, ram_dir, CCA.momentum * 0.5)
	CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

/*
notes

new collision procs for:
rollerbeds,	[d]
fences,	[d]
, computers [d] (handled with /obj/machinery )
, filecabinets, [d]
m56 & m2c 	[d] ( find better solution )

buff health a bit [d]

change the proc pushing xenos to something that pushes them in a random direction rather than away [d]

bell immunity [d]

*/

// Walls

/turf/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum)
		if(istype(src, /turf/closed/wall/resin))
			ex_act(CCA.momentum * 5, null, create_cause_data(initial(X.caste_type), X)) // Half damage for xeno walls?
		else
			ex_act(CCA.momentum * 13, null, create_cause_data(initial(X.caste_type), X))

	CCA.stop_momentum()

// Powerloaders

/obj/vehicle/powerloader/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	explode()
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Sentry

/obj/structure/machinery/defenses/sentry/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	var/datum/effect_system/spark_spread/s = new
	s.set_up(5, 1, loc)
	X.visible_message(
		SPAN_DANGER("[X] rams \the [src]!"),
		SPAN_XENODANGER("You ram \the [src]!")
	)
	if(health <= CHARGER_DAMAGE_SENTRY)
		new /obj/effect/spawner/gibspawner/robot(src.loc) // if we goin down ,we going down with a show.
	update_health(CHARGER_DAMAGE_SENTRY)
	s.start()
	playsound(src, "sound/effects/metalhit.ogg", 25, TRUE)

	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Marine MGs

/obj/structure/machinery/m56d_hmg/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(CCA.momentum > CCA_MOMENTUM_LOSS_MIN)
		CrusherImpact()
		var/datum/effect_system/spark_spread/s = new
		update_health(CCA.momentum * 15)
		if(operator)	operator.emote("pain")
		s.set_up(1, 1, loc)
		s.start()
		X.visible_message(
			SPAN_DANGER("[X] rams \the [src]!"),
			SPAN_XENODANGER("You ram \the [src]!")
		)
		playsound(src, "sound/effects/metal_crash.ogg", 25, TRUE)
		if(istype(src,/obj/structure/machinery/m56d_hmg/auto)) // we don't want to charge it to the point of downgrading it (:
			var/obj/item/device/m2c_gun/HMG = new(src.loc)
			HMG = new(src.loc)
			HMG.health = src.health
			HMG.set_name_label(name_label)
			HMG.rounds = src.rounds //Inherent the amount of ammo we had.
			HMG.update_icon()
			qdel(src)
		else
			var/obj/item/device/m56d_gun/HMG = new(src.loc) // note: find a better way than a copy pasted else statement
			HMG = new(src.loc)
			HMG.health = src.health
			HMG.set_name_label(name_label)
			HMG.rounds = src.rounds //Inherent the amount of ammo we had.
			HMG.has_mount = TRUE
			HMG.update_icon()
			qdel(src) //Now we clean up the constructed gun.
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE
	CCA.stop_momentum()

// Prison Windows

/obj/structure/window/framed/prison/reinforced/hull/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	if(CCA.momentum > CCA_MOMENTUM_LOSS_QUARTER)
		Destroy()
		CCA.stop_momentum()
	CCA.stop_momentum()
	// snowflake check for prison windows because they are funny and crooshers can croosh to space in the brief moment where the shutters are closing

// Rollerbeds

/obj/structure/bed/roller/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	Destroy()
	playsound(src, "sound/effects/metal_crash.ogg", 25, TRUE)
	return XENO_CHARGE_TRY_MOVE // bulldoze that shitty bed and keep going, should run over the buckled mob aswell unless crusher turns last second for some reason

// Filing Cabinets

/obj/structure/filingcabinet/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	X.visible_message(
		SPAN_DANGER("[X] rams \the [src]!"),
		SPAN_XENODANGER("You ram \the [src]!")
	)
	playsound(src, "sound/effects/metalhit.ogg", 25, TRUE)
	Destroy()
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()

// Legacy Tank dispenser
// Todo: Give this and other shitty fucking indestructible legacy items proper destruction mechanics. This includes being vunerable to bullets,explosions, etc and not just the charger.
// For now this is fine since priority is charger, and I'm not willing to spend all day looking for bumfuck legacy item #382321 thats used a total of three times in the entireity of CM and adding health and everything to it.

/obj/structure/dispenser/handle_charge_collision(mob/living/carbon/Xenomorph/X, datum/action/xeno_action/onclick/charger_charge/CCA)
	if(!CCA.momentum)
		CCA.stop_momentum()
		return
	X.visible_message(
		SPAN_DANGER("[X] rams \the [src]!"),
		SPAN_XENODANGER("You ram \the [src]!")
	)
	playsound(src, "sound/effects/metalhit.ogg", 25, TRUE)
	qdel(src)
	if(QDELETED(src))
		CCA.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	CCA.stop_momentum()
