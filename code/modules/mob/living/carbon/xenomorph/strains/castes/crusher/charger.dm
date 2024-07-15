// Specific momentum based damage defines

#define CHARGER_DESTROY charger_ability.momentum * 40
#define CHARGER_DAMAGE_CADE charger_ability.momentum * 22
#define CHARGER_DAMAGE_SENTRY charger_ability.momentum * 9


// Momentum loss defines. 8 is maximum momentum
#define CCA_MOMENTUM_LOSS_HALF 4
#define CCA_MOMENTUM_LOSS_THIRD 3
#define CCA_MOMENTUM_LOSS_QUARTER 2
#define CCA_MOMENTUM_LOSS_MIN 1


/datum/xeno_strain/charger
	name = CRUSHER_CHARGER
	description = "In exchange for your shield, a little bit of your armor and damage, your slowdown resist from turrets, your influence under frenzy pheromones, your stomp no longer knocking down talls, and your ability to lock your direction, you gain a considerable amount of health, some speed, your stomp does extra damage when stomping over a grounded tall, and your charge is now manually-controlled and momentum-based; the further you go, the more damage and speed you will gain until you achieve maximum momentum, indicated by your roar. In addition, your armor is now directional, being the toughest on the front, weaker on the sides, and weakest from the back. In return, you gain an ability to tumble to pass through enemies and avoid enemy fire, and an ability to forcefully move enemies via ramming into them."
	flavor_description = "Nothing stops this hive. This one will become both the immovable object and the unstoppable force."

	actions_to_remove = list(
		/datum/action/xeno_action/activable/pounce/crusher_charge,
		/datum/action/xeno_action/onclick/crusher_stomp,
		/datum/action/xeno_action/onclick/crusher_shield,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/charger_charge,
		/datum/action/xeno_action/activable/tumble,
		/datum/action/xeno_action/onclick/crusher_stomp/charger,
		/datum/action/xeno_action/activable/fling/charger,
	)

	behavior_delegate_type = /datum/behavior_delegate/crusher_charger

/datum/xeno_strain/charger/apply_strain(mob/living/carbon/xenomorph/crusher/crusher)
	crusher.small_explosives_stun = FALSE
	crusher.health_modifier += XENO_HEALTH_MOD_LARGE
	crusher.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	crusher.armor_modifier -= XENO_ARMOR_MOD_SMALL
	crusher.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	crusher.ignore_aura = "frenzy" // no funny crushers going 7 morbillion kilometers per second
	crusher.phero_modifier = -crusher.caste.aura_strength
	crusher.recalculate_everything()

/datum/behavior_delegate/crusher_charger
	name = "Charger Crusher Behavior Delegate"

	var/frontal_armor = 30
	var/side_armor = 15

/datum/behavior_delegate/crusher_charger/add_to_xeno()
	RegisterSignal(bound_xeno, COMSIG_MOB_SET_FACE_DIR, PROC_REF(cancel_dir_lock))
	RegisterSignal(bound_xeno, COMSIG_XENO_PRE_CALCULATE_ARMOURED_DAMAGE_PROJECTILE, PROC_REF(apply_directional_armor))

/datum/behavior_delegate/crusher_charger/proc/cancel_dir_lock()
	SIGNAL_HANDLER
	return COMPONENT_CANCEL_SET_FACE_DIR

/datum/behavior_delegate/crusher_charger/proc/apply_directional_armor(mob/living/carbon/xenomorph/xeno, list/damagedata)
	SIGNAL_HANDLER
	var/projectile_direction = damagedata["direction"]
	if(xeno.dir & REVERSE_DIR(projectile_direction))
		// During the charge windup, crusher gets an extra 15 directional armor in the direction its charging
		damagedata["armor"] += frontal_armor
	else
		for(var/side_direction in get_perpen_dir(xeno.dir))
			if(projectile_direction == side_direction)
				damagedata["armor"] += side_armor
				return

/datum/behavior_delegate/crusher_charger/on_update_icons()
	if(HAS_TRAIT(bound_xeno, TRAIT_CHARGING) && bound_xeno.body_position == STANDING_UP)
		bound_xeno.icon_state = "[bound_xeno.get_strain_icon()] Crusher Charging"
		return TRUE

// Fallback proc for shit that doesn't have a collision def

/atom/proc/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	charger_ability.stop_momentum()

// Windows

/obj/structure/window/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(unacidable)
		charger_ability.stop_momentum()
		return

	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	health -= CHARGER_DESTROY //Usually knocks it down.
	healthcheck()

	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Grills

/obj/structure/grille/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(unacidable)
		charger_ability.stop_momentum()
		return

	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	health -= CHARGER_DESTROY //Usually knocks it down.
	healthcheck()

	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turf worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Airlock Doors

/obj/structure/machinery/door/airlock/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	// Need at least 4 momentum to destroy a full health door
	take_damage(charger_ability.momentum * damage_cap * 0.25, xeno)
	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Vending machines

/obj/structure/machinery/vending/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum >= 3)
		if(unacidable)
			charger_ability.stop_momentum()
			return
		xeno.visible_message(
			SPAN_DANGER("[xeno] smashes straight into \the [src]!"),
			SPAN_XENODANGER("You smash straight into \the [src]!")
		)
		playsound(loc, "punch", 25, TRUE)
		tip_over()
		step_away(src, xeno)
		step_away(src, xeno)
		charger_ability.lose_momentum(2)
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()


// Barine Vending machines

/obj/structure/machinery/cm_vending/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum >= CCA_MOMENTUM_LOSS_THIRD)
		xeno.visible_message(
			SPAN_DANGER("[xeno] smashes straight into \the [src]!"),
			SPAN_XENODANGER("You smash straight into \the [src]!")
		)
		playsound(loc, "punch", 25, TRUE)
		tip_over()
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Legacy doors

/obj/structure/mineral_door/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	playsound(loc, "punch", 25, TRUE)
	Dismantle(TRUE)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
	return XENO_CHARGE_TRY_MOVE

// Tables & shelves, etc

/obj/structure/surface/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	Crossed(xeno)
	return XENO_CHARGE_TRY_MOVE

// Cades

/obj/structure/barricade/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum)
		visible_message(
			SPAN_DANGER("[xeno] rams into \the [src] and skids to a halt!"),
			SPAN_XENOWARNING("You ram into \the [src] and skid to a halt!")
		)
		take_damage(charger_ability.momentum * 22)
		playsound(src, barricade_hitsound, 25, TRUE)

	charger_ability.stop_momentum()

// wFrames

/obj/structure/window_frame/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum)
		playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)
		take_damage(CHARGER_DESTROY*2)
		if(QDELETED(src))
			charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
			return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Doors

/obj/structure/machinery/door/poddoor/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum < CCA_MOMENTUM_LOSS_HALF)
		charger_ability.stop_momentum()
		return

	if(!indestructible && !unacidable)
		qdel(src)
		playsound(src, 'sound/effects/metal_crash.ogg', 25, TRUE)
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Closets

/obj/structure/closet/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	take_damage(CHARGER_DESTROY)
	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Fences
/obj/structure/fence/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	update_health(CHARGER_DAMAGE_CADE)
	playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)
	if(QDELETED(src))
		if(prob(50))
			charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Crates

/obj/structure/largecrate/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	var/turf/T = get_turf(src)
	new /obj/item/stack/sheet/wood(T)
	for(var/obj/O in contents)
		O.forceMove(T)

	qdel(src)
	playsound(src, 'sound/effects/woodhit.ogg', 25, TRUE)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Cargo containers

/obj/structure/cargo_container/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	qdel(src)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_HALF)
	return XENO_CHARGE_TRY_MOVE

// Girders

/obj/structure/girder/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	playsound(src, 'sound/effects/metalhit.ogg', 25, TRUE)
	take_damage(CHARGER_DESTROY)
	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_HALF)
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// General Machinery

/obj/structure/machinery/disposal/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum < CCA_MOMENTUM_LOSS_QUARTER)
		charger_ability.stop_momentum()
		return
	var/obj/structure/disposalconstruct/crusher = new(loc)
	crusher.ptype = 6 //6 = disposal unit
	crusher.density = TRUE
	crusher.update()
	step_away(crusher, xeno, 2)
	qdel(src)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER)
	return XENO_CHARGE_TRY_MOVE

// Disposals

/obj/structure/disposalconstruct/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	step_away(src, xeno, 2)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Humans

/mob/living/carbon/human/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	playsound(loc, "punch", 25, TRUE)
	attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [xeno] ([xeno.ckey])</font>")
	xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src] ([src.ckey])</font>")
	log_attack("[xeno] ([xeno.ckey]) xeno charged [src] ([src.ckey])")
	var/momentum_mult = 5
	if(charger_ability.momentum == charger_ability.max_momentum)
		momentum_mult = 8
	take_overall_armored_damage(charger_ability.momentum * momentum_mult, ARMOR_MELEE, BRUTE, 60, 13) // Giving AP because this spreads damage out and then applies armor to them
	apply_armoured_damage(charger_ability.momentum * momentum_mult/4, ARMOR_MELEE, BRUTE,"chest")
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	var/knockdown = 1
	if(charger_ability.momentum == charger_ability.max_momentum)
		knockdown = 2
	apply_effect(knockdown, WEAKEN)
	animation_flash_color(src)
	if(client)
		shake_camera(src, 1, 3)
	var/list/ram_dirs = get_perpen_dir(xeno.dir)
	var/ram_dir = pick(ram_dirs)
	var/cur_turf = get_turf(src)
	var/target_turf = get_step(src, ram_dir)
	if(LinkBlocked(src, cur_turf, target_turf))
		ram_dir = REVERSE_DIR(ram_dir)
	step(src, ram_dir, charger_ability.momentum * 0.5)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Fellow xenos

/mob/living/carbon/xenomorph/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum)
		playsound(loc, "punch", 25, TRUE)
		if(!xeno.ally_of_hivenumber(hivenumber))
			attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [xeno] ([xeno.ckey])</font>")
			xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src] ([ckey])</font>")
			log_attack("[xeno] ([xeno.ckey]) xeno charged [src] ([ckey])")
			apply_damage(charger_ability.momentum * 10, BRUTE) // half damage to avoid sillyness
		if(anchored) //Ovipositor queen can't be pushed
			charger_ability.stop_momentum()
			return
		if(isqueen(src) || IS_XENO_LEADER(src) ||  isboiler(src)) // boilers because they have long c/d and warmups, get griefed hard if stunned
			charger_ability.stop_momentum() // antigrief
			return
		if(HAS_TRAIT(src, TRAIT_CHARGING))
			apply_effect(2, WEAKEN)
			xeno.apply_effect(2, WEAKEN)
			src.throw_atom(pick(GLOB.cardinals),1,3,xeno,TRUE)
			xeno.throw_atom(pick(GLOB.cardinals),1,3,xeno,TRUE)
			charger_ability.stop_momentum() // We assume the other crusher'sparks handle_charge_collision() kicks in and stuns us too.
			playsound(get_turf(xeno), 'sound/effects/bang.ogg', 25, 0)
			return
		var/list/ram_dirs = get_perpen_dir(xeno.dir)
		var/ram_dir = pick(ram_dirs)
		var/cur_turf = get_turf(src)
		var/target_turf = get_step(src, ram_dir)
		if(LinkBlocked(src, cur_turf, target_turf))
			xeno.emote("roar")
			xeno.visible_message(SPAN_DANGER("[xeno] flings [src] over to the side!"),SPAN_DANGER( "You fling [src] out of the way!"))
			to_chat(src, SPAN_XENOHIGHDANGER("[xeno] flings you out of its way! Move it!"))
			apply_effect(1, WEAKEN) // brief flicker stun
			src.throw_atom(src.loc,1,3,xeno,TRUE)
		step(src, ram_dir, charger_ability.momentum * 0.5)
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
		return XENO_CHARGE_TRY_MOVE
	charger_ability.stop_momentum()

// Other mobs

/mob/living/carbon/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	playsound(loc, "punch", 25, TRUE)
	attack_log += text("\[[time_stamp()]\] <font color='orange'>was xeno charged by [xeno] ([xeno.ckey])</font>")
	xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>xeno charged [src] ([src.ckey])</font>")
	log_attack("[xeno] ([xeno.ckey]) xeno charged [src] ([src.ckey])")
	var/momentum_mult = 5
	if(charger_ability.momentum == charger_ability.max_momentum)
		momentum_mult = 8
	take_overall_damage(charger_ability.momentum * momentum_mult)
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	var/knockdown = 1
	if(charger_ability.momentum == charger_ability.max_momentum)
		knockdown = 2
	apply_effect(knockdown, WEAKEN)
	animation_flash_color(src)
	if(client)
		shake_camera(src, 1, 3)
	var/list/ram_dirs = get_perpen_dir(xeno.dir)
	var/ram_dir = pick(ram_dirs)
	var/cur_turf = get_turf(src)
	var/target_turf = get_step(src, ram_dir)
	if(LinkBlocked(src, cur_turf, target_turf))
		ram_dir = REVERSE_DIR(ram_dir)
	step(src, ram_dir, charger_ability.momentum * 0.5)
	charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN)
	return XENO_CHARGE_TRY_MOVE

// Walls

/turf/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum)
		if(istype(src, /turf/closed/wall/resin))
			ex_act(charger_ability.momentum * 5, null, create_cause_data(initial(xeno.caste_type), xeno)) // Half damage for xeno walls?
		else
			ex_act(charger_ability.momentum * 13, null, create_cause_data(initial(xeno.caste_type), xeno))

	charger_ability.stop_momentum()

// Powerloaders

/obj/vehicle/powerloader/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	explode()
	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Sentry

/obj/structure/machinery/defenses/sentry/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(5, 1, loc)
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	if(health <= CHARGER_DAMAGE_SENTRY)
		new /obj/effect/spawner/gibspawner/robot(src.loc) // if we goin down ,we going down with a show.
	update_health(CHARGER_DAMAGE_SENTRY)
	sparks.start()
	playsound(src, "sound/effects/metalhit.ogg", 25, TRUE)

	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Marine MGs

/obj/structure/machinery/m56d_hmg/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum <= CCA_MOMENTUM_LOSS_MIN)
		charger_ability.stop_momentum()
		return

	CrusherImpact()
	update_health(charger_ability.momentum * 15)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(1, 1, loc)
	sparks.start()
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	playsound(src, "sound/effects/metal_crash.ogg", 25, TRUE)

	if(QDELETED(src))
		// The crash destroyed it
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	// Undeploy
	if(istype(src, /obj/structure/machinery/m56d_hmg/auto)) // we don't want to charge it to the point of downgrading it (:
		var/obj/item/device/m2c_gun/HMG = new(loc)
		HMG.health = health
		transfer_label_component(HMG)
		HMG.rounds = rounds
		HMG.update_icon()
		qdel(src)
	else
		var/obj/item/device/m56d_gun/HMG = new(loc)
		HMG.health = health
		transfer_label_component(HMG)
		HMG.rounds = rounds
		HMG.has_mount = TRUE
		HMG.update_icon()
		qdel(src) //Now we clean up the constructed gun.

/obj/structure/machinery/m56d_post/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(charger_ability.momentum <= CCA_MOMENTUM_LOSS_MIN)
		charger_ability.stop_momentum()
		return

	update_health(charger_ability.momentum * 15)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(1, 1, loc)
	sparks.start()
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	playsound(src, "sound/effects/metal_crash.ogg", 25, TRUE)

	if(QDELETED(src))
		// The crash destroyed it
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	// Undeploy
	if(gun_mounted)
		var/obj/item/device/m56d_gun/HMG = new(loc)
		transfer_label_component(HMG)
		HMG.rounds = gun_rounds
		HMG.has_mount = TRUE
		if(gun_health)
			HMG.health = gun_health
		HMG.update_icon()
		qdel(src)
	else
		var/obj/item/device/m56d_post/post = new(loc)
		post.health = health
		transfer_label_component(post)
		qdel(src)

// Prison Windows

/obj/structure/window/framed/prison/reinforced/hull/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	if(charger_ability.momentum > CCA_MOMENTUM_LOSS_QUARTER)
		qdel(src)
		charger_ability.stop_momentum()
	charger_ability.stop_momentum()
	// snowflake check for prison windows because they are funny and crooshers can croosh to space in the brief moment where the shutters are closing

// Rollerbeds

/obj/structure/bed/roller/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	qdel(src)
	playsound(src, "sound/effects/metal_crash.ogg", 25, TRUE)
	return XENO_CHARGE_TRY_MOVE // bulldoze that shitty bed and keep going, should run over the buckled mob aswell unless crusher turns last second for some reason

// Filing Cabinets

/obj/structure/filingcabinet/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	playsound(src, "sound/effects/metalhit.ogg", 25, TRUE)
	qdel(src)
	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// Legacy Tank dispenser
// Todo: Give this and other shitty fucking indestructible legacy items proper destruction mechanics. This includes being vunerable to bullets,explosions, etc and not just the charger.
// For now this is fine since priority is charger, and I'm not willing to spend all day looking for bumfuck legacy item #382321 thats used a total of three times in the entireity of CM and adding health and everything to it.

/obj/structure/dispenser/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return
	xeno.visible_message(
		SPAN_DANGER("[xeno] rams [src]!"),
		SPAN_XENODANGER("You ram [src]!")
	)
	playsound(src, "sound/effects/metalhit.ogg", 25, TRUE)
	qdel(src)
	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_MIN) //Lose one turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()

// ye olde weldertanke

/obj/structure/reagent_dispensers/fueltank/handle_charge_collision(mob/living/carbon/xenomorph/xeno, datum/action/xeno_action/onclick/charger_charge/charger_ability)
	if(!charger_ability.momentum)
		charger_ability.stop_momentum()
		return

	exploding = TRUE
	explode()

	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	health -= CHARGER_DESTROY //Usually knocks it down.
	healthcheck()

	if(QDELETED(src))
		charger_ability.lose_momentum(CCA_MOMENTUM_LOSS_QUARTER) //Lose two turfs worth of speed
		return XENO_CHARGE_TRY_MOVE

	charger_ability.stop_momentum()


#undef CHARGER_DESTROY
#undef CHARGER_DAMAGE_CADE
#undef CHARGER_DAMAGE_SENTRY
#undef CCA_MOMENTUM_LOSS_HALF
#undef CCA_MOMENTUM_LOSS_THIRD
#undef CCA_MOMENTUM_LOSS_QUARTER
#undef CCA_MOMENTUM_LOSS_MIN
