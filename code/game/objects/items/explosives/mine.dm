///***MINES***///
//Mines have an invisible "tripwire" atom that explodes when crossed
//Stepping directly on the mine will also blow it up
/obj/item/explosive/mine
	name = "\improper M20 Claymore anti-personnel mine"
	desc = "The M20 Claymore is a directional proximity-triggered anti-personnel mine designed by Armat Systems for use by the United States Colonial Marines. The mine is triggered by movement both on the mine itself, and on the space immediately in front of it. Detonation sprays shrapnel forwards in a 120-degree cone. The words \"FRONT TOWARD ENEMY\" are embossed on the front."
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "m20"
	force = 5
	w_class = SIZE_SMALL
	layer = BELOW_MOB_LAYER - 0.1 //You can't just randomly hide claymores under boxes. Booby-trapping bodies is fine though
	throwforce = 5
	health = 60
	throw_range = 6
	throw_speed = SPEED_VERY_FAST
	unacidable = TRUE
	flags_atom = FPRINT|CONDUCT
	antigrief_protection = TRUE
	allowed_sensors = list(/obj/item/device/assembly/prox_sensor)
	max_container_volume = 120
	reaction_limits = list( "max_ex_power" = 100, "base_ex_falloff" = 80, "max_ex_shards" = 40,
							"max_fire_rad" = 4, "max_fire_int" = 20, "max_fire_dur" = 18,
							"min_fire_rad" = 2, "min_fire_int" = 3, "min_fire_dur" = 3
	)
	angle = 60
	use_dir = TRUE
	/// How much shrapnel is distributed when it explodes
	var/shrapnel_count = 12
	/// How big of a boom that happens when this detonates?
	var/explosive_power = 60
	var/iff_signal = FACTION_MARINE
	var/triggered = FALSE
	var/hard_iff_lock = FALSE
	var/obj/effect/mine_tripwire/tripwire
	/// Whether or not tripwires are enabled
	var/use_tripwire = TRUE
	/// If the mine needs to be buried.
	var/needs_digging = FALSE
	/// Is it buried?
	var/buried = FALSE
	/// Whether or not the mine is prespawned
	var/map_prespawn = FALSE
	/// After being deployed, how long does the mine take to be armed and ready? Leave false to disable. Use defines
	var/arming_time = FALSE
	/// If the trigger discriminates on "heavy" targets such as t3s
	var/heavy_trigger = FALSE
	/// How long should it take to deploy
	var/deploy_time = 4 SECONDS

/obj/item/explosive/mine/get_examine_text(mob/user)
	. = ..()
	if(buried)
		. +=  "It is buried."
	if(heavy_trigger)
		. +=  "It has a heavy trigger."

/obj/item/explosive/mine/Initialize()
	. = ..()
	if(map_prespawn)
		deploy_mine(null)

/obj/item/explosive/mine/Destroy()
	QDEL_NULL(tripwire)
	. = ..()

// Mines are NOT bullet proof
/obj/item/explosive/mine/bullet_act(obj/projectile/bullet)
	..()
	health -= bullet.damage
	healthcheck()
	return TRUE
/**
 * Simply checks the health of the mine, if its zero or below, prime it.
 */
/obj/item/explosive/mine/proc/healthcheck()
	if(health <= 0)
		prime()

/obj/item/explosive/mine/ex_act()
	prime() //We don't care about how strong the explosion was.

/obj/item/explosive/mine/emp_act()
	. = ..()
	prime() //Same here. Don't care about the effect strength.


//checks for things that would prevent us from placing the mine.
/obj/item/explosive/mine/proc/check_for_obstacles(mob/living/user)
	if(locate(/obj/item/explosive/mine) in get_turf(src))
		to_chat(user, SPAN_WARNING("There already is a mine at this position!"))
		return TRUE
	if(user.loc && (user.loc.density || locate(/obj/structure/fence) in user.loc))
		to_chat(user, SPAN_WARNING("You can't plant a mine here."))
		return TRUE
	if(SSinterior.in_interior(user))
		to_chat(user, SPAN_WARNING("It's too cramped in here to deploy \a [src]."))
		return TRUE



//Arming
/obj/item/explosive/mine/attack_self(mob/living/user)
	if(!..())
		return

	if(needs_digging && is_mainship_level(user.z))
		to_chat(user, SPAN_WARNING("This mine needs to be buried in suitable terrain!"))
		return
	if(check_for_obstacles(user))
		return

	if(active || user.action_busy)
		return

	if(antigrief_protection && user.faction == FACTION_MARINE && explosive_antigrief_check(src, user))
		to_chat(user, SPAN_WARNING("\The [name]'s safe-area accident inhibitor prevents you from planting!"))
		msg_admin_niche("[key_name(user)] attempted to plant \a [name] in [get_area(src)] [ADMIN_JMP(src.loc)]")
		return

	user.visible_message(SPAN_NOTICE("[user] starts deploying [src]."),
		SPAN_NOTICE("You start deploying [src]."))
	if(!do_after(user, 40, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		user.visible_message(SPAN_NOTICE("[user] stops deploying [src]."), \
			SPAN_NOTICE("You stop deploying \the [src]."))
		return

	if(active)
		return

	if(check_for_obstacles(user))
		return

	if(needs_digging)
		playsound(loc, 'sound/weapons/flipblade.ogg', 25, 1)
		user.visible_message(SPAN_NOTICE("[user] pulls the pin on [src]."), \
			SPAN_NOTICE("You pull the activation pin and prepare it to be buried."))
		user.drop_inv_item_on_ground(src)
		anchored = TRUE
		return
	else
		user.visible_message(SPAN_NOTICE("[user] finishes deploying [src]."), \
		SPAN_NOTICE("You finish deploying [src]."))
		if(user)
			user.drop_inv_item_on_ground(src)
			setDir(user ? user.dir : dir) //The direction it is planted in is the direction the user faces at that time
	deploy_mine(user)

/obj/item/explosive/mine/proc/deploy_mine(mob/user)
	if(!hard_iff_lock && user)
		iff_signal = user.faction

	cause_data = create_cause_data(initial(name), user)
	anchored = TRUE
	playsound(loc, 'sound/weapons/mine_armed.ogg', 25, 1)
	activate_sensors()
	update_icon()



/obj/item/explosive/mine/attackby(obj/item/thing, mob/user)
	if(needs_digging && HAS_TRAIT(thing,  TRAIT_TOOL_SHOVEL) && !active && anchored && !buried)
		user.visible_message(SPAN_NOTICE("[user] starts burying [src]."), \
			SPAN_NOTICE("You start burying [src]."))
		playsound(user.loc, 'sound/effects/thud.ogg', 40, 1, 6)
		if(!do_after(user, 3 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_BUILD))
			user.visible_message(SPAN_WARNING("[user] stops burying [src]."), \
			SPAN_WARNING("You stop burying [src]."))
			return
		user.visible_message(SPAN_NOTICE("[user] finished burying [src]."), \
		SPAN_NOTICE("You finish burying [src]."))
		buried = TRUE
		addtimer(CALLBACK(src, PROC_REF(deploy_mine), user), arming_time)
	//Disarming
	if(HAS_TRAIT(thing, TRAIT_TOOL_MULTITOOL))
		if(active)
			if(user.action_busy)
				return
			if(user.faction == iff_signal)
				user.visible_message(SPAN_NOTICE("[user] starts disarming [src]."), \
				SPAN_NOTICE("You start disarming [src]."))
			else
				user.visible_message(SPAN_NOTICE("[user] starts fiddling with \the [src], trying to disarm it."), \
				SPAN_NOTICE("You start disarming [src], but you don't know its IFF data. This might end badly..."))
			if(!do_after(user, 30, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
				user.visible_message(SPAN_WARNING("[user] stops disarming [src]."), \
					SPAN_WARNING("You stop disarming [src]."))
				return
			if(user.faction != iff_signal) //ow!
				if(prob(75))
					triggered = TRUE
					if(tripwire)
						var/direction = GLOB.reverse_dir[src.dir]
						var/step_direction = get_step(src, direction)
						tripwire.forceMove(step_direction)
					prime()
			if(!active)//someone beat us to it
				return
			user.visible_message(SPAN_NOTICE("[user] finishes disarming [src]."), \
			SPAN_NOTICE("You finish disarming [src]."))
			disarm()

	else
		return ..()

/obj/item/explosive/mine/proc/disarm()
	if(customizable)
		activate_sensors()
	anchored = FALSE
	active = FALSE
	triggered = FALSE
	buried = FALSE
	update_icon()
	QDEL_NULL(tripwire)

/obj/item/explosive/mine/activate_sensors()
	if(active)
		return

	if(!customizable)
		set_tripwire()
		return;

	if(!detonator)
		active = TRUE
		return

	if(customizable && assembly_stage == ASSEMBLY_LOCKED)
		if(isigniter(detonator.a_right) && isigniter(detonator.a_left))
			set_tripwire()
			use_dir = TRUE
			return
		else
			..()
			use_dir = FALSE // Claymore defaults to radial in these case. Poor man C4
			triggered = TRUE // Delegating the tripwire/crossed function to the sensor.


/obj/item/explosive/mine/proc/set_tripwire()
	if(!active && !tripwire)
		var/tripwire_loc = get_turf(get_step(loc, dir))
		tripwire = new(tripwire_loc)
		tripwire.linked_claymore = src
		active = TRUE


//Mine can also be triggered if you "cross right in front of it" (same tile)
/obj/item/explosive/mine/Crossed(atom/atoom)
	..()
	if(isliving(atoom))
		var/mob/living/creature = atoom
		if(!creature.stat == DEAD)//so dragged corpses don't trigger mines.
			return
		else
			try_to_prime(atoom)

/obj/item/explosive/mine/Collided(atom/movable/vehicle)
	try_to_prime(vehicle)

/**
 * Proc that notifies a heavy trigger failing to detonate
 */
/obj/item/explosive/mine/proc/heavy_trigger_notify(mob/living/unfortunate_soul)
	unfortunate_soul.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] [name] clicks as [unfortunate_soul] moves on top of it."), \
	SPAN_DANGER("[icon2html(src, unfortunate_soul)] [name] clicks as you move on top of it."), \
	SPAN_DANGER("You hear a click."))

/**
 * Proc that runs checks before priming occurs
 */
/obj/item/explosive/mine/proc/try_to_prime(mob/living/unfortunate_soul)
	if(!active || triggered || (customizable && !detonator))
		return
	if(!istype(unfortunate_soul))
		return
	if(unfortunate_soul.stat == DEAD)
		return
	if(unfortunate_soul.get_target_lock(iff_signal) || issynth(unfortunate_soul))
		return
	if(HAS_TRAIT(unfortunate_soul, TRAIT_ABILITY_BURROWED))
		return
	if(heavy_trigger && buried)
		playsound(loc, 'sound/weapons/flipblade.ogg', 35, 1)
		if(isxeno(unfortunate_soul))
			var/mob/living/carbon/xenomorph/xeno = unfortunate_soul
			if(xeno.mob_size < MOB_SIZE_BIG)
				heavy_trigger_notify(unfortunate_soul)
				return
		if(prob(75) && ishuman(unfortunate_soul))
			var/mob/living/carbon/human/human = unfortunate_soul
			if(!human.wear_suit)
				heavy_trigger_notify(unfortunate_soul)
				return
			if(human.wear_suit.slowdown > SLOWDOWN_ARMOR_HEAVY) // "Nice hustle, 'tons-a-fun'! Next time, eat a salad!"
				heavy_trigger_notify(unfortunate_soul)
				return


	unfortunate_soul.visible_message(SPAN_DANGER("[icon2html(src, viewers(src))] [name] clicks as [unfortunate_soul] moves on top of it."), \
	SPAN_DANGER("[icon2html(src, unfortunate_soul)] [name] clicks as you move on top of it."), \
	SPAN_DANGER("You hear a click."))

	triggered = TRUE
	playsound(loc, 'sound/weapons/mine_tripped.ogg', 25, 1)
	prime()

//Note : May not be actual explosion depending on linked method
/obj/item/explosive/mine/prime()
	set waitfor = 0

	if(!customizable)
		create_shrapnel(loc, 12, dir, angle, , cause_data)
		cell_explosion(loc, 60, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, dir, cause_data)
		qdel(src)
	else
		. = ..()
		if(!QDELETED(src))
			disarm()


/obj/item/explosive/mine/attack_alien(mob/living/carbon/xenomorph/beno)
	if(triggered) //Mine is already set to go off
		return XENO_NO_DELAY_ACTION

	if(beno.a_intent == INTENT_HELP)
		if(buried)
			to_chat(beno, SPAN_XENONOTICE("This is buried, you need to dig it out to damage it!"))
		else
			to_chat(beno, SPAN_XENONOTICE("If you hit this hard enough, it would probably explode."))
		return XENO_NO_DELAY_ACTION
	if(buried)
		beno.animation_attack_on(src)
		beno.visible_message(SPAN_NOTICE("[beno] starts digging up [src]."), \
		SPAN_NOTICE("You start digging up [src]. This might end badly..."))
		if(!do_after(beno, deploy_time * 1.5, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY))
			beno.visible_message(SPAN_WARNING("[beno] stops disarming [src]."), \
			SPAN_WARNING("You stop disarming [src]."))
			return
	else
		beno.animation_attack_on(src)
		beno.visible_message(SPAN_DANGER("[beno] has slashed [src]!"), \
		SPAN_DANGER("You slash [src]!"))
		playsound(loc, 'sound/weapons/slice.ogg', 25, 1)

	//We move the tripwire randomly in either of the four cardinal directions
	triggered = TRUE
	if(tripwire)
		var/direction = pick(GLOB.cardinals)
		var/step_direction = get_step(src, direction)
		tripwire.forceMove(step_direction)
	prime()
	if(!QDELETED(src))
		disarm()
	return XENO_ATTACK_ACTION

/obj/item/explosive/mine/flamer_fire_act(damage, flame_cause_data) //adding mine explosions
	cause_data = flame_cause_data
	prime()
	if(!QDELETED(src))
		disarm()


/obj/effect/mine_tripwire
	name = "claymore tripwire"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	invisibility = 101
	unacidable = TRUE //You never know
	var/obj/item/explosive/mine/linked_claymore

/obj/effect/mine_tripwire/Destroy()
	if(linked_claymore)
		if(linked_claymore.tripwire == src)
			linked_claymore.tripwire = null
		linked_claymore = null
	. = ..()

//immune to explosions.
/obj/effect/mine_tripwire/ex_act(severity)
	return

/obj/effect/mine_tripwire/Crossed(atom/movable/vehicle)
	if(!linked_claymore)
		qdel(src)
		return

	if(linked_claymore.triggered) //Mine is already set to go off
		return

	if(linked_claymore)
		linked_claymore.try_to_prime(vehicle)

/obj/item/explosive/mine/active
	icon_state = "m20_active"
	base_icon_state = "m20"
	map_prespawn = TRUE

/obj/item/explosive/mine/no_iff
	iff_signal = null

/obj/item/explosive/mine/active/no_iff
	iff_signal = null

// Subtype from this to create buried mines.
/obj/item/explosive/mine/bury
	use_tripwire = FALSE
	needs_digging = TRUE
	map_prespawn = FALSE
	buried = FALSE
	arming_time = 3 SECONDS
	use_dir = FALSE
	unacidable = TRUE
	var/datum/effect_system/spark_spread/sparks = new

/obj/item/explosive/mine/bury/examine(mob/user)
	. = ..()
	if(!buried)
		. +=  "\n A small label on the bottom reads: 'To deploy: simply pull the pin to activate it and dig it in with your standard issue e-tool. This munition will automatically arm in [arming_time] seconds after being buried.' "
	else
		. +=  SPAN_DANGER("\n This unit is armed and ready")

/obj/item/explosive/mine/bury/Destroy()
	. = ..()
	QDEL_NULL(sparks)

/obj/item/explosive/mine/bury/Initialize(mapload, ...)
	. = ..()
	sparks.set_up(5, 0, src)
	sparks.attach(src)

/obj/item/explosive/mine/bury/disarm()
	. = ..()
	QDEL_NULL(sparks)


/obj/item/explosive/mine/bury/prime()
	. = ..()
	QDEL_NULL(sparks)

/obj/item/explosive/mine/bury/antitank
	name = "\improper M19 Anti-Tank Mine"
	desc = "A pressure-fuse, anti tank mine. Might take out a track or two, maybe even disable a light vehicle, if you're lucky."
	desc_lore = "This older anti tank mine design from the 21st century was rolled back into service simply due to the currently-used M307 EMP anti tank mines being unable to trigger against the minimally armored vehicles commonly used by CLF. Featuring a 250 pound minimum detonation threshold, it can be employed against all but the lightest of vehicles. Despite being outdated, it can still pack a punch against APCs and lighter vehicles, while its plastic construction prevents detection by simple methods."
	icon_state = "antitank_mine"
	w_class = SIZE_LARGE
	layer = LYING_BETWEEN_MOB_LAYER //You can't just randomly hide claymores under boxes. Booby-trapping bodies is fine though
	explosive_power = 150
	heavy_trigger = TRUE

/obj/item/explosive/mine/bury/antitank/prime()
	set waitfor = 0
	cell_explosion(loc, explosive_power, 25, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF, dir, cause_data)
	for(var/mob/living/carbon/creature in oview(1, src))
		creature.AdjustStun(4)
		creature.KnockDown(4)
		to_chat(creature, SPAN_HIGHDANGER("Molten copper rips through your lower body!"))
		creature.apply_damage(200,BURN)
		if(ishuman(creature))
			sparks.start()
			var/mob/living/carbon/human/fleshbag = creature
			var/obj/limb/left = fleshbag.get_limb("l_leg")
			var/obj/limb/right = fleshbag.get_limb("r_leg")
			right.droplimb()
			left.droplimb()
			playsound(creature.loc, "bone_break", 45, TRUE)
			playsound(creature.loc, "bone_break", 45, TRUE)
	for(var/mob/living/living_mob in viewers(7, src))
		if(living_mob.client)
			shake_camera(living_mob, 10, 1)
	qdel(src)
	if(!QDELETED(src))
		disarm()

/obj/item/explosive/mine/pmc
	name = "\improper M20P Claymore anti-personnel mine"
	desc = "The M20P Claymore is a directional proximity triggered anti-personnel mine designed by Armat Systems for use by the United States Colonial Marines. It has been modified for use by the Wey-Yu PMC forces."
	icon_state = "m20p"
	iff_signal = FACTION_PMC
	hard_iff_lock = TRUE

/obj/item/explosive/mine/pmc/active
	icon_state = "m20p_active"
	base_icon_state = "m20p"
	map_prespawn = TRUE

/obj/item/explosive/mine/custom
	name = "custom mine"
	desc = "A custom chemical mine built from an M20 casing."
	icon_state = "m20_custom"
	customizable = TRUE
	matter = list("metal" = 3750)
	has_blast_wave_dampener = TRUE

/obj/item/explosive/mine/sebb
	name = "\improper G2 Electroshock grenade"
	icon_state = "grenade_sebb_planted"
	desc = "A G2 electroshock grenade planted as a landmine."
	pixel_y = -5
	anchored = TRUE // this is supposed to be planeted already when spawned

/obj/item/explosive/mine/sebb/disarm()
	. = ..()
	new /obj/item/explosive/grenade/sebb(get_turf(src))
	qdel(src)

/obj/item/explosive/mine/sebb/prime()
	new /obj/item/explosive/grenade/sebb/primed(get_turf(src))
	qdel(src)
