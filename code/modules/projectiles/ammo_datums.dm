/datum/ammo
	var/name 		= "generic bullet"
	var/headshot_state	= null //Icon state when a human is permanently killed with it by execution/suicide.
	var/icon 		= 'icons/obj/items/weapons/projectiles.dmi'
	var/icon_state 	= "bullet"
	var/ping 		= "ping_b" //The icon that is displayed when the bullet bounces off something.
	var/sound_hit //When it deals damage.
	var/sound_armor //When it's blocked by human armor.
	var/sound_miss //When it misses someone.
	var/sound_bounce //When it bounces off something.
	var/sound_shield_hit //When the bullet is absorbed by a xeno_shield

	var/accurate_range_min 			= 0			// Snipers use this to simulate poor accuracy at close ranges
	var/scatter  					= 0 		// How much the ammo scatters when burst fired, added to gun scatter, along with other mods
	var/stamina_damage 				= 0
	var/damage 						= 0 		// This is the base damage of the bullet as it is fired
	var/damage_type 				= BRUTE 	// BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/penetration					= 0 		// How much armor it ignores before calculations take place
	var/shrapnel_chance 			= 0 		// The % chance it will imbed in a human
	var/shrapnel_type				= 0			// The shrapnel type the ammo will embed, if the chance rolls
	var/bonus_projectiles_type 					// Type path of the extra projectiles
	var/bonus_projectiles_amount 	= 0 		// How many extra projectiles it shoots out. Works kind of like firing on burst, but all of the projectiles travel together
	var/debilitate[]				= null 		// Stun,knockdown,knockout,irradiate,stutter,eyeblur,drowsy,agony
	var/pen_armor_punch				= 0.5		// how much armor breaking will be done per point of penetration. This is for weapons that penetrate with their shape (like needle bullets)
	var/damage_armor_punch			= 0.5		// how much armor breaking is done by sheer weapon force. This is for big blunt weapons
	var/sound_override				= null		// if we should play a special sound when firing.
	var/flags_ammo_behavior 		= NO_FLAGS

	var/accuracy 			= HIT_ACCURACY_TIER_1 	// This is added to the bullet's base accuracy.
	var/accuracy_var_low	= PROJECTILE_VARIANCE_TIER_9 	// How much the accuracy varies when fired. // This REDUCES the lower bound of accuracy variance by 2%, to 96%.
	var/accuracy_var_high	= PROJECTILE_VARIANCE_TIER_9	// This INCREASES the upper bound of accuracy variance by 2%, to 107%.
	var/accurate_range 		= 6 	// For most guns, this is where the bullet dramatically looses accuracy. Not for snipers though.
	var/max_range 			= 22 	// This will de-increment a counter on the bullet.
	var/damage_var_low		= PROJECTILE_VARIANCE_TIER_9 	// Same as with accuracy variance.
	var/damage_var_high		= PROJECTILE_VARIANCE_TIER_9	// This INCREASES the upper bound of damage variance by 2%, to 107%.
	var/damage_falloff 		= DAMAGE_FALLOFF_TIER_10 // How much damage the bullet loses per turf traveled after the effective range
	var/damage_buildup 		= DAMAGE_BUILDUP_TIER_1 // How much damage the bullet loses per turf away before the effective range
	var/effective_range_min	= EFFECTIVE_RANGE_OFF	//What minimum range the ammo deals full damage, builds up the closer you get. 0 for no minimum. Added onto gun range as a modifier.
	var/effective_range_max	= EFFECTIVE_RANGE_OFF	//What maximum range the ammo deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum. Added onto gun range as a modifier.
	var/shell_speed 		= AMMO_SPEED_TIER_1 	// How fast the projectile moves.

	var/handful_type 		= /obj/item/ammo_magazine/handful
	var/handful_color
	var/handful_state = "bullet" //custom handful sprite, for shotgun shells or etc.
	var/multiple_handful_name //so handfuls say 'buckshot shells' not 'shell'

	/// Does this apply xenomorph behaviour delegate?
	var/apply_delegate = TRUE

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to a projectile with the current ammo datum
	var/list/list/traits_to_give

	var/flamer_reagent_type = /datum/reagent/napalm/ut

/datum/ammo/New()
	set_bullet_traits()

/// Populate traits_to_give in this proc
/datum/ammo/proc/set_bullet_traits()
	return

/datum/ammo/can_vv_modify()
	return FALSE

/datum/ammo/proc/do_at_half_range(obj/item/projectile/P)
	return

/datum/ammo/proc/on_embed(var/mob/embedded_mob, var/obj/limb/target_organ)
	return

/datum/ammo/proc/do_at_max_range(obj/item/projectile/P)
	return

/datum/ammo/proc/on_shield_block(mob/M, obj/item/projectile/P) //Does it do something special when shield blocked? Ie. a flare or grenade that still blows up.
	return

/datum/ammo/proc/on_hit_turf(turf/T, obj/item/projectile/P) //Special effects when hitting dense turfs.
	return

/datum/ammo/proc/on_hit_mob(mob/M, obj/item/projectile/P, mob/user) //Special effects when hitting mobs.
	return

///Special effects when pointblanking mobs. Ultimately called from /living/attackby(). Return TRUE to end the PB attempt.
/datum/ammo/proc/on_pointblank(mob/living/L, obj/item/projectile/P, mob/living/user, obj/item/weapon/gun/fired_from)
	return

/datum/ammo/proc/on_hit_obj(obj/O, obj/item/projectile/P) //Special effects when hitting objects.
	return

/datum/ammo/proc/on_near_target(turf/T, obj/item/projectile/P) //Special effects when passing near something. Range of things that triggers it is controlled by other ammo flags.
	return 0 //return 0 means it flies even after being near something. Return 1 means it stops

/datum/ammo/proc/knockback(mob/living/L, obj/item/projectile/P, var/max_range = 2)
	if(!L || L == P.firer)
		return
	if(P.distance_travelled > max_range || L.lying)
		return //Two tiles away or more, basically.

	if(L.mob_size >= MOB_SIZE_BIG)
		return //Big xenos are not affected.

	shake_camera(L, 3, 4)

	if(isCarbonSizeXeno(L))
		var/mob/living/carbon/Xenomorph/target = L
		target.apply_effect(0.7, WEAKEN) // 0.9 seconds of stun, per agreement from Balance Team when switched from MC stuns to exact stuns
		target.apply_effect(1, SUPERSLOW)
		target.apply_effect(2, SLOW)
		to_chat(target, SPAN_XENODANGER("You are shaken by the sudden impact!"))
	else
		L.apply_stamina_damage(P.ammo.damage, P.def_zone, ARMOR_BULLET)

	//Either knockback or slam them into an obstacle.
	var/direction = Get_Compass_Dir(P.z ? P : P.firer, L) //More precise than get_dir.
	if(!direction) //Same tile.
		return
	if(!step(L, direction))
		L.animation_attack_on(get_step(L, direction))
		playsound(L.loc, "punch", 25, 1)
		L.visible_message(SPAN_DANGER("[L] slams into an obstacle!"),
			isXeno(L) ? SPAN_XENODANGER("You slam into an obstacle!") : SPAN_HIGHDANGER("You slam into an obstacle!"), null, 4, CHAT_TYPE_TAKING_HIT)
		L.apply_damage(MELEE_FORCE_TIER_2)

/datum/ammo/proc/heavy_knockback(mob/living/L, obj/item/projectile/P, var/max_range = 6) //crazier version of knockback
	if(!L || L == P.firer)
		return
	if(P.distance_travelled > max_range || L.lying)
		return
	if(L.mob_size >= MOB_SIZE_BIG)
		return

	shake_camera(L, 3, 4)
	if(isCarbonSizeXeno(L))
		var/mob/living/carbon/Xenomorph/target = L
		to_chat(target, SPAN_XENODANGER("You are shaken and slowed by the sudden impact!"))
		target.apply_effect(0.5, WEAKEN)
		target.apply_effect(2, SUPERSLOW)
		target.apply_effect(5, SLOW)
	else
		if(!isYautja(L)) //Not predators.
			L.apply_effect(1, SUPERSLOW)
			L.apply_effect(2, SLOW)
			to_chat(L, SPAN_HIGHDANGER("The impact knocks you off-balance!"))
		L.apply_stamina_damage(P.ammo.damage, P.def_zone, ARMOR_BULLET)

	//Either knockback or slam them into an obstacle.
	var/direction = Get_Compass_Dir(P.z ? P : P.firer, L) //More precise than get_dir. If the projectile has no z, it's a PB, and should measure from the shooter.
	if(!direction) //Same tile.
		return
	if(!step(L, direction))
		L.animation_attack_on(get_step(L, direction))
		playsound(L.loc, "punch", 25, 1)
		L.visible_message(SPAN_DANGER("[L] slams into an obstacle!"),
			isXeno(L) ? SPAN_XENODANGER("You slam into an obstacle!") : SPAN_HIGHDANGER("You slam into an obstacle!"), null, 4, CHAT_TYPE_TAKING_HIT)
		L.apply_damage(MELEE_FORCE_TIER_2)

/datum/ammo/proc/pushback(mob/M, obj/item/projectile/P, var/max_range = 2)
	if(!M || M == P.firer || P.distance_travelled > max_range || M.lying)
		return

	if(M.mob_size >= MOB_SIZE_BIG)
		return //too big to push

	to_chat(M, isXeno(M) ? SPAN_XENODANGER("You are pushed back by the sudden impact!") : SPAN_HIGHDANGER("You are pushed back by the sudden impact!"), null, 4, CHAT_TYPE_TAKING_HIT)
	step(M, Get_Compass_Dir(P.z ? P : P.firer, M))

/datum/ammo/proc/burst(atom/target, obj/item/projectile/P, damage_type = BRUTE, range = 1, damage_div = 2, show_message = 1) //damage_div says how much we divide damage
	if(!target || !P) return
	for(var/mob/living/carbon/M in orange(range,target))
		if(P.firer == M)
			continue
		if(show_message)
			var/msg = "You are hit by backlash from \a </b>[P.name]</b>!"
			M.visible_message(SPAN_DANGER("[M] is hit by backlash from \a [P.name]!"),isXeno(M) ? SPAN_XENODANGER("[msg]"):SPAN_HIGHDANGER("[msg]"))
		var/damage = P.damage/damage_div

		var/mob/living/carbon/Xenomorph/XNO = null

		if(isXeno(M))
			XNO = M
			var/total_explosive_resistance = XNO.caste.xeno_explosion_resistance + XNO.armor_explosive_buff
			damage = armor_damage_reduction(GLOB.xeno_explosive, damage, total_explosive_resistance , 60, 0, 0.5, XNO.armor_integrity)
			var/armor_punch = armor_break_calculation(GLOB.xeno_explosive, damage, total_explosive_resistance, 60, 0, 0.5, XNO.armor_integrity)
			XNO.apply_armorbreak(armor_punch)

		M.apply_damage(damage,damage_type)

		if(XNO && XNO.xeno_shields.len)
			P.play_shielded_damage_effect(M)
		else
			P.play_damage_effect(M)

/datum/ammo/proc/fire_bonus_projectiles(obj/item/projectile/original_P)
	set waitfor = 0

	var/turf/curloc = get_turf(original_P.shot_from)
	var/initial_angle = Get_Angle(curloc, original_P.target_turf)

	for(var/i in 1 to bonus_projectiles_amount) //Want to run this for the number of bonus projectiles.
		var/final_angle = initial_angle

		var/obj/item/projectile/P = new /obj/item/projectile(curloc, original_P.weapon_cause_data)
		P.generate_bullet(GLOB.ammo_list[bonus_projectiles_type]) //No bonus damage or anything.
		P.accuracy = round(P.accuracy * original_P.accuracy/initial(original_P.accuracy)) //if the gun changes the accuracy of the main projectile, it also affects the bonus ones.
		original_P.give_bullet_traits(P)

		var/total_scatter_angle = P.scatter
		final_angle += rand(-total_scatter_angle, total_scatter_angle)
		var/turf/new_target = get_angle_target_turf(curloc, final_angle, 30)

		P.fire_at(new_target, original_P.firer, original_P.shot_from, P.ammo.max_range, P.ammo.shell_speed, original_P.original) //Fire!

/datum/ammo/proc/drop_flame(turf/T, datum/cause_data/cause_data) // ~Art updated fire 20JAN17
	if(!istype(T))
		return
	if(locate(/obj/flamer_fire) in T)
		return

	var/datum/reagent/R = new flamer_reagent_type()
	new /obj/flamer_fire(T, cause_data, R)


/*
//======
					Default Ammo
//======
*/
//Only when things screw up do we use this as a placeholder.
/datum/ammo/bullet
	name = "default bullet"
	icon_state = "bullet"
	headshot_state	= HEADSHOT_OVERLAY_LIGHT
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit 	 = "ballistic_hit"
	sound_armor  = "ballistic_armor"
	sound_miss	 = "ballistic_miss"
	sound_bounce = "ballistic_bounce"
	sound_shield_hit = "ballistic_shield_hit"

	accurate_range_min = 0
	damage = 10
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_1
	shrapnel_type = /obj/item/shard/shrapnel
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/on_pointblank(mob/living/L, obj/item/projectile/P, mob/living/user, obj/item/weapon/gun/fired_from)
	if(!(flags_ammo_behavior & AMMO_HIGHIMPACT))
		return . = ..()

	if(!user)
		return FALSE

	if(L == user || user.zone_selected != "head" || user.a_intent != INTENT_HARM || !isHumanStrict(L))
		return ..()

	var/mob/living/carbon/human/execution_target = L
	if(!skillcheck(user, SKILL_EXECUTION, SKILL_EXECUTION_TRAINED))
		to_chat(user, SPAN_DANGER("You don't know how to execute someone correctly."))
		return FALSE

	if(execution_target.status_flags & PERMANENTLY_DEAD)
		to_chat(user, SPAN_DANGER("[execution_target] has already been executed!"))
		fired_from.delete_bullet(P, TRUE)
		return TRUE

	user.affected_message(execution_target,
		SPAN_HIGHDANGER("You aim \the [fired_from] at [execution_target]'s head!"),
		SPAN_HIGHDANGER("[user] aims \the [fired_from] directly at your head!"),
		SPAN_DANGER("[user] aims \the [fired_from] at [execution_target]'s head!"))

	user.next_move += 1.1 SECONDS //PB has no click delay; readding it here to prevent people accidentally queuing up multiple executions.

	if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) || !user.Adjacent(execution_target))
		fired_from.delete_bullet(P, TRUE)
		return TRUE

	execution_target.apply_damage(damage * 3, BRUTE, "head", no_limb_loss = TRUE, permanent_kill = TRUE) //Apply gobs of damage and make sure they can't be revived later...
	execution_target.apply_damage(200, OXY) //...fill out the rest of their health bar with oxyloss...
	execution_target.death(create_cause_data("execution", user)) //...make certain they're properly dead...
	shake_camera(execution_target, 3, 4)
	execution_target.update_headshot_overlay(headshot_state) //...and add a gory headshot overlay.

	execution_target.visible_message(SPAN_HIGHDANGER(uppertext("[L] WAS EXECUTED!")), \
		SPAN_HIGHDANGER("You WERE EXECUTED!"))

	user.count_niche_stat(STATISTICS_NICHE_EXECUTION, 1, P.weapon_cause_data?.cause_name)

	var/area/execution_area = get_area(execution_target)

	msg_admin_attack(FONT_SIZE_HUGE("[key_name(usr)] has battlefield executed [key_name(execution_target)] in [get_area(usr)] ([usr.loc.x],[usr.loc.y],[usr.loc.z])."), usr.loc.x, usr.loc.y, usr.loc.z)
	log_attack("[key_name(usr)] battlefield executed [key_name(execution_target)] at [execution_area.name].")

	if(flags_ammo_behavior & AMMO_EXPLOSIVE)
		execution_target.gib()
	return ..()

/*
//======
					Pistol Ammo
//======
*/

// Used by M4A3, M4A3 Custom and B92FS
/datum/ammo/bullet/pistol
	name = "pistol bullet"

	damage = 35
	accuracy = HIT_ACCURACY_TIER_2
	effective_range_max = 4
	damage_falloff = DAMAGE_FALLOFF_TIER_4 //should be useful in close-range mostly

/datum/ammo/bullet/pistol/tiny
	name = "light pistol bullet"

/datum/ammo/bullet/pistol/tranq
	name = "tranquilizer bullet"
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST
	stamina_damage = 30

//2020 rebalance: is supposed to counter runners and lurkers, dealing high damage to the only castes with no armor.
//Limited by its lack of versatility and lower supply, so marines finally have an answer for flanker castes that isn't just buckshot.

/datum/ammo/bullet/pistol/hollow
	name = "hollowpoint pistol bullet"

	damage = 55 //hollowpoint is strong
	penetration = 0 //hollowpoint can't pierce armor!
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_3 //hollowpoint causes shrapnel

// Used by M4A3 AP, Highpower and mod88
/datum/ammo/bullet/pistol/ap
	name = "armor-piercing pistol bullet"

	damage = 25
	accuracy = HIT_ACCURACY_TIER_2
	penetration= ARMOR_PENETRATION_TIER_8
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/bullet/pistol/ap/penetrating
	name = "wall-piercing pistol bullet"
	shrapnel_chance = 0

	damage = 30
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/pistol/ap/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/pistol/ap/cluster
	name = "cluster pistol bullet"
	shrapnel_chance = 0
	var/cluster_addon = 1.5

/datum/ammo/bullet/pistol/ap/cluster/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/ap/toxin
	name = "toxic pistol bullet"
	var/acid_per_hit = 10
	var/organic_damage_mult = 3

/datum/ammo/bullet/pistol/ap/toxin/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/pistol/ap/toxin/on_hit_turf(turf/T, obj/item/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/ap/toxin/on_hit_obj(obj/O, obj/item/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/le
	name = "armor-shredding pistol bullet"

	damage = 15
	penetration = ARMOR_PENETRATION_TIER_4
	pen_armor_punch = 3

/datum/ammo/bullet/pistol/rubber
	name = "rubber pistol bullet"
	sound_override = 'sound/weapons/gun_c99.ogg'

	damage = 0
	stamina_damage = 25
	shrapnel_chance = 0

// Used by M1911, Deagle and KT-42
/datum/ammo/bullet/pistol/heavy
	name = "heavy pistol bullet"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM
	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	damage = 40
	penetration= ARMOR_PENETRATION_TIER_2
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/datum/ammo/bullet/pistol/heavy/cluster
	name = "heavy cluster pistol bullet"
	var/cluster_addon = 1.5

/datum/ammo/bullet/pistol/heavy/cluster/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/heavy/super //Commander's variant
	name = ".50 heavy pistol bullet"
	damage = 50
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/pistol/heavy/super/highimpact
	name = ".50 high-impact pistol bullet"
	penetration = ARMOR_PENETRATION_TIER_2
	debilitate = list(0,2,0,0,0,1,0,0)
	flags_ammo_behavior = AMMO_HIGHIMPACT|AMMO_BALLISTIC

/datum/ammo/bullet/pistol/heavy/super/highimpact/on_hit_mob(mob/M, obj/item/projectile/P)
	knockback(M, P, 4)

/datum/ammo/bullet/pistol/incendiary
	name = "incendiary pistol bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = HIT_ACCURACY_TIER_3
	damage = 20

/datum/ammo/bullet/pistol/incendiary/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

// Used by VP78 and Auto 9
/datum/ammo/bullet/pistol/squash
	name = "squash-head pistol bullet"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM
	debilitate = list(0,0,0,0,0,0,0,2)

	accuracy = HIT_ACCURACY_TIER_4
	damage = 45
	penetration= ARMOR_PENETRATION_TIER_6
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2
	damage_falloff = DAMAGE_FALLOFF_TIER_6 //"VP78 - the only pistol viable as a primary."-Vampmare, probably.

/datum/ammo/bullet/pistol/squash/toxin
	name = "toxic squash-head pistol bullet"
	var/acid_per_hit = 10
	var/organic_damage_mult = 3

/datum/ammo/bullet/pistol/squash/toxin/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/pistol/squash/toxin/on_hit_turf(turf/T, obj/item/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/squash/toxin/on_hit_obj(obj/O, obj/item/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/pistol/squash/penetrating
	name = "wall-piercing squash-head pistol bullet"
	shrapnel_chance = 0
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/pistol/squash/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/pistol/squash/cluster
	name = "cluster squash-head pistol bullet"
	shrapnel_chance = 0
	var/cluster_addon = 2

/datum/ammo/bullet/pistol/squash/cluster/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/pistol/squash/incendiary
	name = "incendiary squash-head pistol bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accuracy = HIT_ACCURACY_TIER_3
	damage = 35

/datum/ammo/bullet/pistol/squash/incendiary/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))


/datum/ammo/bullet/pistol/mankey
	name = "live monkey"
	icon_state = "monkey1"
	ping = null //no bounce off.
	damage_type = BURN
	debilitate = list(4,4,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_IGNORE_ARMOR

	damage = 15
	damage_var_high = PROJECTILE_VARIANCE_TIER_5
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/bullet/pistol/mankey/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/pistol/mankey/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P && P.loc && !M.stat && !istype(M,/mob/living/carbon/human/monkey))
		P.visible_message(SPAN_DANGER("The [src] chimpers furiously!"))
		new /mob/living/carbon/human/monkey(P.loc)

/datum/ammo/bullet/pistol/smart
	name = "smartpistol bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = HIT_ACCURACY_TIER_8
	damage = 25
	penetration= ARMOR_PENETRATION_TIER_5
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/*
//======
					Revolver Ammo
//======
*/

/datum/ammo/bullet/revolver
	name = "revolver bullet"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM

	damage = 55
	penetration = ARMOR_PENETRATION_TIER_1
	accuracy = HIT_ACCURACY_TIER_1

/datum/ammo/bullet/revolver/marksman
	name = "marksman revolver bullet"

	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	penetration = ARMOR_PENETRATION_TIER_7

/datum/ammo/bullet/revolver/heavy
	name = "heavy revolver bullet"

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_4
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/revolver/heavy/on_hit_mob(mob/M, obj/item/projectile/P)
	knockback(M, P, 4)

/datum/ammo/bullet/revolver/incendiary
	name = "incendiary revolver bullet"
	damage = 40

/datum/ammo/bullet/revolver/incendiary/set_bullet_traits()
	..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/revolver/marksman/toxin
	name = "toxic revolver bullet"
	var/acid_per_hit = 10
	var/organic_damage_mult = 3

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_turf(turf/T, obj/item/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/revolver/marksman/toxin/on_hit_obj(obj/O, obj/item/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/revolver/penetrating
	name = "wall-piercing revolver bullet"
	shrapnel_chance = 0

	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/revolver/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/revolver/cluster
	name = "cluster revolver bullet"
	shrapnel_chance = 0
	var/cluster_addon = 4
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/revolver/cluster/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/revolver/nagant
	name = "nagant revolver bullet"
	headshot_state	= HEADSHOT_OVERLAY_LIGHT //Smaller bullet.
	damage = 40


/datum/ammo/bullet/revolver/nagant/shrapnel
	name = "shrapnel shot"
	headshot_state	= HEADSHOT_OVERLAY_HEAVY //Gol-dang shotgun blow your fething head off.
	debilitate = list(0,0,0,0,0,0,0,0)
	icon_state = "shrapnelshot"
	bonus_projectiles_type = /datum/ammo/bullet/revolver/nagant/shrapnel_bits

	max_range = 6
	damage = 25 // + TIER_4 * 3
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	penetration	= ARMOR_PENETRATION_TIER_6
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	shrapnel_chance = 100
	shrapnel_type = /obj/item/shard/shrapnel/nagant
	//roughly 35 or so damage

/datum/ammo/bullet/revolver/nagant/shrapnel/on_hit_mob(mob/M, obj/item/projectile/P)
	pushback(M, P, 1)

/datum/ammo/bullet/revolver/nagant/shrapnel_bits
	name = "small shrapnel"
	icon_state = "shrapnelshot_bit"

	max_range = 6
	damage = 20
	penetration	= ARMOR_PENETRATION_TIER_1
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0
	shrapnel_type = /obj/item/shard/shrapnel/nagant/bits

/datum/ammo/bullet/revolver/small
	name = "small revolver bullet"
	headshot_state	= HEADSHOT_OVERLAY_LIGHT

	damage = 30

/datum/ammo/bullet/revolver/mateba
	name = ".454 heavy revolver bullet"
	debilitate = list(0,2,0,0,0,1,0,0)

	damage = 60
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/revolver/mateba/highimpact
	name = ".454 heavy high-impact revolver bullet"
	debilitate = list(0,2,0,0,0,1,0,0)
	penetration = ARMOR_PENETRATION_TIER_2
	flags_ammo_behavior = AMMO_HIGHIMPACT|AMMO_BALLISTIC

/datum/ammo/bullet/revolver/mateba/highimpact/on_hit_mob(mob/M, obj/item/projectile/P)
	knockback(M, P, 4)

/datum/ammo/bullet/revolver/mateba/highimpact/explosive //if you ever put this in normal gameplay, i am going to scream
	name = ".454 heavy explosive revolver bullet"
	damage = 100
	damage_var_low = PROJECTILE_VARIANCE_TIER_10
	damage_var_high = PROJECTILE_VARIANCE_TIER_1
	penetration = ARMOR_PENETRATION_TIER_10
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_HIGHIMPACT|AMMO_BALLISTIC

/datum/ammo/bullet/revolver/mateba/highimpact/explosive/on_hit_mob(mob/M, obj/item/projectile/P)
	..()
	cell_explosion(get_turf(M), 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/revolver/mateba/highimpact/explosive/on_hit_obj(obj/O, obj/item/projectile/P)
	..()
	cell_explosion(get_turf(O), 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/revolver/mateba/highimpact/explosive/on_hit_turf(turf/T, obj/item/projectile/P)
	..()
	cell_explosion(T, 120, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/revolver/webley //Mateba round without the knockdown.
	name = ".455 Webley bullet"
	damage = 60
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_2

/*
//======
					SMG Ammo
//======
*/
 //2020 SMG/ammo rebalance. default ammo actually has penetration so it can be useful, by 4khan: should be meh against t3s, better under 15 armor. Perfectly does this right now (oct 2020)
 //has reduced falloff compared to the m39. this means it is best for kiting castes (mostly t2s and below admittedly)
 //while the m39 ap is better for shredding them at close range, but has reduced velocity, so it's better for just running in and erasing armor-centric castes (defender, crusher)
 // which i think is really interesting and good balance, giving both ammo types a reason to exist even against ravagers.
 //i feel it is necessary to reflavor the default bullet, because otherwise, people won't be able to notice it has less falloff and faster bullet speed. even with a changelog,
 //way too many people don't read the changelog, and after one or two months the changelog entry is all but archive, so there needs to be an ingame description of what the ammo does
 //in comparison to armor-piercing rounds.

/datum/ammo/bullet/smg
	name = "submachinegun bullet"
	damage = 34
	accurate_range = 4
	effective_range_max = 4
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = DAMAGE_FALLOFF_TIER_5
	scatter = SCATTER_AMOUNT_TIER_6
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/smg/m39
	name = "high-velocity submachinegun bullet" //i don't want all smgs to inherit 'high velocity'

/datum/ammo/bullet/smg/ap
	name = "armor-piercing submachinegun bullet"

	damage = 26
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_4

/datum/ammo/bullet/smg/ap/toxin
	name = "toxic submachinegun bullet"
	var/acid_per_hit = 5
	var/organic_damage_mult = 3

/datum/ammo/bullet/smg/ap/toxin/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/smg/ap/toxin/on_hit_turf(turf/T, obj/item/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/smg/ap/toxin/on_hit_obj(obj/O, obj/item/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/smg/nail
	name = "7x45mm plasteel nail"
	icon_state = "nail-projectile"

	damage = 25
	penetration = ARMOR_PENETRATION_TIER_8
	damage_falloff = DAMAGE_FALLOFF_TIER_6
	accurate_range = 5
	shell_speed = AMMO_SPEED_TIER_4


/datum/ammo/bullet/smg/nail/on_pointblank(mob/living/L, obj/item/projectile/P, mob/living/user, obj/item/weapon/gun/fired_from)
	if(!L || L == P.firer || L.lying)
		return

	if(isCarbonSizeXeno(L))
		var/mob/living/carbon/Xenomorph/X = L
		if(X.tier != 1) // 0 is queen!
			return
	else if(HAS_TRAIT(L, TRAIT_SUPER_STRONG))
		return

	if(L.frozen)
		to_chat(user, SPAN_DANGER("[L] struggles and avoids being nailed further!"))
		return

	//Check for presence of solid surface behind
	var/atom/movable/thick_surface = LinkBlocked(L, get_turf(L), get_step(L, get_dir(user, L)))
	if(!thick_surface || ismob(thick_surface) && !thick_surface.anchored)
		return

	L.frozen = TRUE
	user.visible_message(SPAN_DANGER("[user] punches [L] with the nailgun and nails their limb to [thick_surface]!"),
		SPAN_DANGER("You punch [L] with the nailgun and nail their limb to [thick_surface]!"))
	L.update_canmove()
	addtimer(CALLBACK(L, /mob.proc/unfreeze), 3 SECONDS)

/datum/ammo/bullet/smg/nail/on_hit_mob(mob/living/L, obj/item/projectile/P)
	if(!L || L == P.firer || L.lying)
		return

	L.AdjustSlowed(1) //Slow on hit.
	L.recalculate_move_delay = TRUE
	var/super_slowdown_duration = 3
	//If there's an obstacle on the far side, superslow and do extra damage.
	if(isCarbonSizeXeno(L)) //Unless they're a strong xeno, in which case the slowdown is drastically reduced
		var/mob/living/carbon/Xenomorph/X = L
		if(X.tier != 1) // 0 is queen!
			super_slowdown_duration = 0.5
	else if(HAS_TRAIT(L, TRAIT_SUPER_STRONG))
		super_slowdown_duration = 0.5

	var/atom/movable/thick_surface = LinkBlocked(L, get_turf(L), get_step(L, get_dir(P.loc ? P : P.firer, L)))
	if(!thick_surface || ismob(thick_surface) && !thick_surface.anchored)
		return

	L.apply_armoured_damage(damage*0.5, ARMOR_BULLET, BRUTE, null, penetration)
	L.AdjustSuperslowed(super_slowdown_duration)

/datum/ammo/bullet/smg/incendiary
	name = "incendiary submachinegun bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 25
	accuracy = -HIT_ACCURACY_TIER_2

/datum/ammo/bullet/smg/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/smg/ap/penetrating
	name = "wall-piercing submachinegun bullet"
	shrapnel_chance = 0

	damage = 30
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/smg/ap/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/smg/ap/cluster
	name = "cluster submachinegun bullet"
	shrapnel_chance = 0
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_10
	var/cluster_addon = 0.8

/datum/ammo/bullet/smg/ap/cluster/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/smg/le
	name = "armor-shredding submachinegun bullet"

	scatter = SCATTER_AMOUNT_TIER_10
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_4
	shell_speed = AMMO_SPEED_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_10
	pen_armor_punch = 4

/datum/ammo/bullet/smg/rubber
	name = "rubber submachinegun bullet"
	sound_override = 'sound/weapons/gun_c99.ogg'

	damage = 0
	stamina_damage = 10
	shrapnel_chance = 0

/*
//======
					Rifle Ammo
//======
*/

/datum/ammo/bullet/rifle
	name = "rifle bullet"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM

	damage = 40
	penetration = ARMOR_PENETRATION_TIER_1
	accurate_range = 16
	accuracy = HIT_ACCURACY_TIER_4
	scatter = SCATTER_AMOUNT_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_7
	max_range = 24 //So S8 users don't have their bullets magically disappaer at 22 tiles (S8 can see 24 tiles)

/datum/ammo/bullet/rifle/holo_target
	name = "holo-targeting rifle bullet"
	damage = 30

/datum/ammo/bullet/rifle/holo_target/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/bonus_damage_stack, 10, world.time)

/datum/ammo/bullet/rifle/explosive
	name = "explosive rifle bullet"

	damage = 25
	accurate_range = 22
	accuracy = 0
	shell_speed = AMMO_SPEED_TIER_4
	damage_falloff = DAMAGE_FALLOFF_TIER_9

/datum/ammo/bullet/rifle/explosive/on_hit_mob(mob/M, obj/item/projectile/P)
	cell_explosion(get_turf(M), 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rifle/explosive/on_hit_obj(obj/O, obj/item/projectile/P)
	cell_explosion(get_turf(O), 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rifle/explosive/on_hit_turf(turf/T, obj/item/projectile/P)
	if(T.density)
		cell_explosion(T, 80, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, P.dir, P.weapon_cause_data)

/datum/ammo/bullet/rifle/ap
	name = "armor-piercing rifle bullet"

	damage = 30
	penetration = ARMOR_PENETRATION_TIER_8

// Basically AP but better. Focused at taking out armour temporarily
/datum/ammo/bullet/rifle/ap/toxin
	name = "toxic rifle bullet"
	var/acid_per_hit = 7
	var/organic_damage_mult = 3

/datum/ammo/bullet/rifle/ap/toxin/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/toxic_buildup, acid_per_hit)

/datum/ammo/bullet/rifle/ap/toxin/on_hit_turf(turf/T, obj/item/projectile/P)
	. = ..()
	if(T.flags_turf & TURF_ORGANIC)
		P.damage *= organic_damage_mult

/datum/ammo/bullet/rifle/ap/toxin/on_hit_obj(obj/O, obj/item/projectile/P)
	. = ..()
	if(O.flags_obj & OBJ_ORGANIC)
		P.damage *= organic_damage_mult


/datum/ammo/bullet/rifle/ap/penetrating
	name = "wall-piercing rifle bullet"
	shrapnel_chance = 0

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_10

/datum/ammo/bullet/rifle/ap/penetrating/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/rifle/ap/cluster
	name = "cluster rifle bullet"
	shrapnel_chance = 0

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_10
	var/cluster_addon = 1

/datum/ammo/bullet/rifle/ap/cluster/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/cluster_stack, cluster_addon, damage, world.time)

/datum/ammo/bullet/rifle/le
	name = "armor-shredding rifle bullet"

	damage = 20
	penetration = ARMOR_PENETRATION_TIER_4
	pen_armor_punch = 5

/datum/ammo/bullet/rifle/rubber
	name = "rubber rifle bullet"
	sound_override = 'sound/weapons/gun_c99.ogg'

	damage = 0
	stamina_damage = 15
	shrapnel_chance = 0

/datum/ammo/bullet/rifle/incendiary
	name = "incendiary rifle bullet"
	damage_type = BURN
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 30
	shell_speed = AMMO_SPEED_TIER_4
	accuracy = -HIT_ACCURACY_TIER_2
	damage_falloff = DAMAGE_FALLOFF_TIER_10

/datum/ammo/bullet/rifle/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/rifle/m4ra
	name = "A19 high velocity bullet"
	shrapnel_chance = 0
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accurate_range_min = 4

	damage = 55
	scatter = -SCATTER_AMOUNT_TIER_8
	penetration= ARMOR_PENETRATION_TIER_7
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/rifle/m4ra/incendiary
	name = "A19 high velocity incendiary bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 40
	accuracy = HIT_ACCURACY_TIER_4
	scatter = -SCATTER_AMOUNT_TIER_8
	penetration= ARMOR_PENETRATION_TIER_5
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/rifle/m4ra/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/rifle/m4ra/impact
	name = "A19 high velocity impact bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	damage = 40
	accuracy = -HIT_ACCURACY_TIER_2
	scatter = -SCATTER_AMOUNT_TIER_8
	penetration = ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/rifle/m4ra/impact/on_hit_mob(mob/M, obj/item/projectile/P)
	heavy_knockback(M, P, 32)	// Can knockback basically at max range

/datum/ammo/bullet/rifle/mar40
	name = "heavy rifle bullet"

	damage = 55

/datum/ammo/bullet/rifle/type71
	name = "heavy rifle bullet"

	damage = 35
	penetration = ARMOR_PENETRATION_TIER_2

/datum/ammo/bullet/rifle/type71/ap
	name = "heavy armor-piercing rifle bullet"

	damage = 20
	penetration = ARMOR_PENETRATION_TIER_10

/*
//======
					Shotgun Ammo
//======
*/

/datum/ammo/bullet/shotgun
	headshot_state	= HEADSHOT_OVERLAY_HEAVY

/datum/ammo/bullet/shotgun/slug
	name = "shotgun slug"
	handful_state = "slug_shell"

	accurate_range = 6
	max_range = 8
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_4
	damage_armor_punch = 2
	handful_state = "slug_shell"

/datum/ammo/bullet/shotgun/slug/on_hit_mob(mob/M,obj/item/projectile/P)
	heavy_knockback(M, P, 6)

/datum/ammo/bullet/shotgun/beanbag
	name = "beanbag slug"
	headshot_state	= HEADSHOT_OVERLAY_LIGHT //It's not meant to kill people... but if you put it in your mouth, it will.
	handful_state = "beanbag_slug"
	icon_state = "beanbag"
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST
	sound_override = 'sound/weapons/gun_shotgun_riot.ogg'

	max_range = 12
	shrapnel_chance = 0
	damage = 0
	stamina_damage = 45
	accuracy = HIT_ACCURACY_TIER_3
	shell_speed = AMMO_SPEED_TIER_3
	handful_state = "beanbag_slug"

/datum/ammo/bullet/shotgun/beanbag/on_hit_mob(mob/M, obj/item/projectile/P)
	if(!M || M == P.firer) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		shake_camera(H, 2, 1)


/datum/ammo/bullet/shotgun/incendiary
	name = "incendiary slug"
	handful_state = "incendiary_slug"
	damage_type = BURN
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = -HIT_ACCURACY_TIER_2
	max_range = 12
	damage = 55
	penetration= ARMOR_PENETRATION_TIER_1
	handful_state = "incendiary_slug"

/datum/ammo/bullet/shotgun/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shotgun/incendiary/on_hit_mob(mob/M,obj/item/projectile/P)
	burst(get_turf(M),P,damage_type)
	knockback(M,P)

/datum/ammo/bullet/shotgun/incendiary/on_hit_obj(obj/O,obj/item/projectile/P)
	burst(get_turf(P),P,damage_type)

/datum/ammo/bullet/shotgun/incendiary/on_hit_turf(turf/T,obj/item/projectile/P)
	burst(get_turf(T),P,damage_type)


/datum/ammo/bullet/shotgun/flechette
	name = "flechette shell"
	icon_state = "flechette"
	handful_state = "flechette_shell"
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/flechette_spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	max_range = 12
	damage = 30
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_7
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	handful_state = "flechette_shell"
	multiple_handful_name = TRUE

/datum/ammo/bullet/shotgun/flechette_spread
	name = "additional flechette"
	icon_state = "flechette"

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	max_range = 12
	damage = 30
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_7
	scatter = SCATTER_AMOUNT_TIER_5

/datum/ammo/bullet/shotgun/buckshot
	name = "buckshot shell"
	icon_state = "buckshot"
	handful_state = "buckshot_shell"
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_5
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_5
	accurate_range = 4
	max_range = 4
	damage = 65
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_1
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	shell_speed = AMMO_SPEED_TIER_2
	damage_armor_punch = 0
	pen_armor_punch = 0
	handful_state = "buckshot_shell"
	multiple_handful_name = TRUE

/datum/ammo/bullet/shotgun/buckshot/incendiary
	name = "incendiary buckshot shell"
	handful_state = "incen_buckshot"
	handful_type = /obj/item/ammo_magazine/handful/shotgun/buckshot/incendiary

/datum/ammo/bullet/shotgun/buckshot/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shotgun/buckshot/on_hit_mob(mob/M,obj/item/projectile/P)
	knockback(M,P)

//buckshot variant only used by the masterkey shotgun attachment.
/datum/ammo/bullet/shotgun/buckshot/masterkey
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread/masterkey

	damage = 55

/datum/ammo/bullet/shotgun/spread
	name = "additional buckshot"
	icon_state = "buckshot"

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 4
	max_range = 6
	damage = 65
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_2
	scatter = SCATTER_AMOUNT_TIER_1
	damage_armor_punch = 0
	pen_armor_punch = 0

/datum/ammo/bullet/shotgun/spread/masterkey
	damage = 20

/*
					8 GAUGE SHOTGUN AMMO
*/

/datum/ammo/bullet/shotgun/heavy/buckshot
	name = "heavy buckshot shell"
	icon_state = "buckshot"
	handful_state = "heavy_buckshot"
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/buckshot/spread
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_3
	accurate_range = 3
	max_range = 3
	damage = 75
	penetration	= 0
	shell_speed = AMMO_SPEED_TIER_2
	damage_armor_punch = 0
	pen_armor_punch = 0

/datum/ammo/bullet/shotgun/heavy/buckshot/on_hit_mob(mob/M,obj/item/projectile/P)
	knockback(M,P)

/datum/ammo/bullet/shotgun/heavy/buckshot/spread
	name = "additional heavy buckshot"
	max_range = 4
	scatter = SCATTER_AMOUNT_TIER_1
	bonus_projectiles_amount = 0

//basically the same
/datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath
	name = "dragon's breath shell"
	handful_state = "heavy_dragonsbreath"
	multiple_handful_name = TRUE
	damage_type = BURN
	damage = 60
	accurate_range = 3
	max_range = 4
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath/spread

/datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shotgun/heavy/buckshot/dragonsbreath/spread
	name = "additional dragon's breath"
	bonus_projectiles_amount = 0
	accurate_range = 4
	max_range = 5 //make use of the ablaze property


/datum/ammo/bullet/shotgun/heavy/slug
	name = "heavy shotgun slug"
	handful_state = "heavy_slug"

	accurate_range = 7
	max_range = 8
	damage = 90 //ouch.
	penetration = ARMOR_PENETRATION_TIER_6
	damage_armor_punch = 2

/datum/ammo/bullet/shotgun/heavy/slug/on_hit_mob(mob/M,obj/item/projectile/P)
	heavy_knockback(M, P, 7)

/datum/ammo/bullet/shotgun/heavy/beanbag
	name = "heavy beanbag slug"
	icon_state = "beanbag"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM
	handful_state = "heavy_beanbag"
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST
	sound_override = 'sound/weapons/gun_shotgun_riot.ogg'

	max_range = 7
	shrapnel_chance = 0
	damage = 0
	stamina_damage = 100
	accuracy = HIT_ACCURACY_TIER_2
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/bullet/shotgun/heavy/beanbag/on_hit_mob(mob/M, obj/item/projectile/P)
	if(!M || M == P.firer)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		shake_camera(H, 2, 1)

/datum/ammo/bullet/shotgun/heavy/flechette
	name = "heavy flechette shell"
	icon_state = "flechette"
	handful_state = "heavy_flechette"
	multiple_handful_name = TRUE
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/heavy/flechette_spread

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_3
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_3
	max_range = 12
	damage = 45
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_10
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_2

/datum/ammo/bullet/shotgun/heavy/flechette_spread
	name = "additional heavy flechette"
	icon_state = "flechette"
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	max_range = 12
	damage = 45
	damage_var_low = PROJECTILE_VARIANCE_TIER_8
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_10
	scatter = SCATTER_AMOUNT_TIER_4

//Enormous shell for Van Bandolier's superheavy double-barreled hunting gun.
/datum/ammo/bullet/shotgun/twobore
	name = "two bore bullet"
	icon_state 	= "autocannon"
	handful_state = "twobore"

	accurate_range = 8 //Big low-velocity projectile; this is for blasting dangerous game at close range.
	max_range = 14 //At this range, it's lost all its damage anyway.
	damage = 300 //Hits like a buckshot PB.
	penetration = ARMOR_PENETRATION_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_1 * 3 //It has a lot of energy, but the 26mm bullet drops off fast.
	effective_range_max	= EFFECTIVE_RANGE_MAX_TIER_2 //Full damage up to this distance, then falloff for each tile beyond.
	var/hit_messages = list()

/datum/ammo/bullet/shotgun/twobore/on_hit_mob(mob/living/M, obj/item/projectile/P)
	var/mob/shooter = P.firer
	if(shooter && ismob(shooter) && HAS_TRAIT(shooter, TRAIT_TWOBORE_TRAINING) && M.stat != DEAD && prob(40)) //Death is handled by periodic life() checks so this should have a chance to fire on a killshot.
		if(!length(hit_messages)) //Pick and remove lines, refill on exhaustion.
			hit_messages = list("Got you!", "Aha!", "Bullseye!", "It's curtains for you, Sonny Jim!", "Your head will look fantastic on my wall!", "I have you now!", "You miserable coward! Come and fight me like a man!", "Tally ho!")
		var/message = pick_n_take(hit_messages)
		shooter.say(message)

	if(P.distance_travelled > 8)
		heavy_knockback(M, P, 12)

	else if(!M || M == P.firer || M.lying) //These checks are included in heavy_knockback and would be redundant above.
		return

	shake_camera(M, 3, 4)
	M.apply_effect(2, WEAKEN)
	M.apply_effect(4, SLOW)
	if(isCarbonSizeXeno(M))
		to_chat(M, SPAN_XENODANGER("The impact knocks you off your feet!"))
	else //This will hammer a Yautja as hard as a human.
		to_chat(M, SPAN_HIGHDANGER("The impact knocks you off your feet!"))

	step(M, get_dir(P.firer, M))

/datum/ammo/bullet/lever_action
	name = "lever-action bullet"

	damage = 80
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "lever_action_bullet"

//unused and not working. need to refactor MD code. Unobtainable.
//intended mechanic is to have xenos hit with it show up very frequently on any MDs around
/datum/ammo/bullet/lever_action/tracker
	name = "tracking lever-action bullet"
	icon_state = "redbullet"
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_3
	accuracy = HIT_ACCURACY_TIER_1
	handful_state = "tracking_lever_action_bullet"

/datum/ammo/bullet/lever_action/tracker/on_hit_mob(mob/M, obj/item/projectile/P, mob/user)
	//SEND_SIGNAL(user, COMSIG_BULLET_TRACKING, user, M)
	M.visible_message(SPAN_DANGER("You hear a faint beep under [M]'s [M.mob_size > MOB_SIZE_HUMAN ? "chitin" : "skin"]."))

/datum/ammo/bullet/lever_action/training
	name = "lever-action blank"
	icon_state = "blank"
	damage = 70  //blanks CAN hurt you if shot very close
	penetration = 0
	accuracy = HIT_ACCURACY_TIER_1
	damage_falloff = DAMAGE_FALLOFF_BLANK //not much, though (comparatively)
	shell_speed = AMMO_SPEED_TIER_5
	handful_state = "training_lever_action_bullet"

//unused, and unobtainable... for now
/datum/ammo/bullet/lever_action/marksman
	name = "marksman lever-action bullet"
	shrapnel_chance = 0
	damage_falloff = 0
	accurate_range = 12
	damage = 70
	penetration = ARMOR_PENETRATION_TIER_6
	shell_speed = AMMO_SPEED_TIER_6
	handful_state = "marksman_lever_action_bullet"

/datum/ammo/bullet/lever_action/xm88
	name = ".458 SOCOM round"

	damage = 80
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_1
	shell_speed = AMMO_SPEED_TIER_6
	accurate_range = 14
	handful_state = "boomslang_bullet"

/datum/ammo/bullet/lever_action/xm88/pen20
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/lever_action/xm88/pen30
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/lever_action/xm88/pen40
	penetration = ARMOR_PENETRATION_TIER_8

/datum/ammo/bullet/lever_action/xm88/pen50
	penetration = ARMOR_PENETRATION_TIER_10

/*
//======
					Sniper Ammo
//======
*/

/datum/ammo/bullet/sniper
	name = "sniper bullet"
	headshot_state	= HEADSHOT_OVERLAY_HEAVY
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 32
	max_range = 32
	scatter = 0
	damage = 70
	penetration= ARMOR_PENETRATION_TIER_10
	shell_speed = AMMO_SPEED_TIER_6
	damage_falloff = 0

/datum/ammo/bullet/sniper/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P.homing_target && M == P.homing_target)
		var/mob/living/L = M
		L.apply_armoured_damage(damage*2, ARMOR_BULLET, BRUTE, null, penetration)
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/datum/ammo/bullet/sniper/incendiary
	name = "incendiary sniper bullet"
	damage_type = BRUTE
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER

	//Removed accuracy = 0, accuracy_var_high = Variance Tier 6, and scatter = 0. -Kaga
	damage = 60
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/sniper/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/sniper/incendiary/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P.homing_target && M == P.homing_target)
		var/mob/living/L = M
		var/blind_duration = 5
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_BIG)
				blind_duration = 2
		L.AdjustEyeBlur(blind_duration)
		L.adjust_fire_stacks(10)
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/datum/ammo/bullet/sniper/flak
	name = "flak sniper bullet"
	damage_type = BRUTE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SNIPER|AMMO_IGNORE_COVER

	accuracy = HIT_ACCURACY_TIER_8
	scatter = SCATTER_AMOUNT_TIER_8
	damage = 55
	damage_var_high = PROJECTILE_VARIANCE_TIER_8 //Documenting old code: This converts to a variance of 96-109% damage. -Kaga
	penetration = 0

/datum/ammo/bullet/sniper/flak/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P.homing_target && M == P.homing_target)
		var/slow_duration = 7
		var/mob/living/L = M
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_BIG)
				slow_duration = 4
		M.AdjustSuperslowed(slow_duration)
		L.apply_armoured_damage(damage, ARMOR_BULLET, BRUTE, null, penetration)
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))
	else
		burst(get_turf(M),P,damage_type, 2 , 2)
		burst(get_turf(M),P,damage_type, 1 , 2 , 0)

/datum/ammo/bullet/sniper/flak/on_near_target(turf/T, obj/item/projectile/P)
	burst(T,P,damage_type, 2 , 2)
	burst(T,P,damage_type, 1 , 2, 0)
	return 1

/datum/ammo/bullet/tank/flak
	name = "flak autocannon bullet"
	icon_state 	= "autocannon"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC
	accurate_range_min = 4

	accuracy = HIT_ACCURACY_TIER_8
	scatter = 0
	damage = 60
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_6
	accurate_range = 32
	max_range = 32
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/tank/flak/on_hit_mob(mob/M,obj/item/projectile/P)
	burst(get_turf(M),P,damage_type, 2 , 3)
	burst(get_turf(M),P,damage_type, 1 , 3 , 0)

/datum/ammo/bullet/tank/flak/on_near_target(turf/T, obj/item/projectile/P)
	burst(get_turf(T),P,damage_type, 2 , 3)
	burst(get_turf(T),P,damage_type, 1 , 3, 0)
	return 1

/datum/ammo/bullet/tank/flak/on_hit_obj(obj/O,obj/item/projectile/P)
	burst(get_turf(P),P,damage_type, 2 , 3)
	burst(get_turf(P),P,damage_type, 1 , 3 , 0)

/datum/ammo/bullet/tank/flak/on_hit_turf(turf/T,obj/item/projectile/P)
	burst(get_turf(T),P,damage_type, 2 , 3)
	burst(get_turf(T),P,damage_type, 1 , 3 , 0)

/datum/ammo/bullet/tank/dualcannon
	name = "dualcannon bullet"
	icon_state 	= "autocannon"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_BALLISTIC

	accuracy = HIT_ACCURACY_TIER_8
	scatter = 0
	damage = 50
	damage_var_high = PROJECTILE_VARIANCE_TIER_8
	penetration	= ARMOR_PENETRATION_TIER_3
	accurate_range = 10
	max_range = 12
	shell_speed = AMMO_SPEED_TIER_5

/datum/ammo/bullet/tank/dualcannon/on_hit_mob(mob/M,obj/item/projectile/P)
	for(var/mob/living/carbon/L in get_turf(M))
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)

/datum/ammo/bullet/tank/dualcannon/on_near_target(turf/T, obj/item/projectile/P)
	for(var/mob/living/carbon/L in T)
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)
	return 1

/datum/ammo/bullet/tank/dualcannon/on_hit_obj(obj/O,obj/item/projectile/P)
	for(var/mob/living/carbon/L in get_turf(O))
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)

/datum/ammo/bullet/tank/dualcannon/on_hit_turf(turf/T,obj/item/projectile/P)
	for(var/mob/living/carbon/L in T)
		if(L.stat == CONSCIOUS && L.mob_size <= MOB_SIZE_XENO)
			shake_camera(L, 1, 1)

/datum/ammo/bullet/sniper/svd
	name = "crude sniper bullet"

/datum/ammo/bullet/sniper/anti_materiel
	name = "anti-materiel sniper bullet"

	shrapnel_chance = 0 // This isn't leaving any shrapnel.
	accuracy = HIT_ACCURACY_TIER_8
	damage = 125
	shell_speed = AMMO_SPEED_TIER_6

/datum/ammo/bullet/sniper/anti_materiel/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P.homing_target && M == P.homing_target)
		var/mob/living/L = M
		var/size_damage_mod = 0.8
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_XENO)
				size_damage_mod += 0.6
			if(target.mob_size >= MOB_SIZE_BIG)
				size_damage_mod += 0.6
		L.apply_armoured_damage(damage*size_damage_mod, ARMOR_BULLET, BRUTE, null, penetration)
		// 180% damage to all targets (225), 240% (300) against non-Runner xenos, and 300% against Big xenos (375). -Kaga
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/datum/ammo/bullet/sniper/elite
	name = "supersonic sniper bullet"

	shrapnel_chance = 0 // This isn't leaving any shrapnel.
	accuracy = HIT_ACCURACY_TIER_8
	damage = 150
	shell_speed = AMMO_SPEED_TIER_6 + AMMO_SPEED_TIER_2

/datum/ammo/bullet/sniper/elite/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
	    BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_penetrating)
	))

/datum/ammo/bullet/sniper/elite/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P.homing_target && M == P.homing_target)
		var/mob/living/L = M
		var/size_damage_mod = 0.5
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/target = M
			if(target.mob_size >= MOB_SIZE_XENO)
				size_damage_mod += 0.5
			if(target.mob_size >= MOB_SIZE_BIG)
				size_damage_mod += 1
			L.apply_armoured_damage(damage*size_damage_mod, ARMOR_BULLET, BRUTE, null, penetration)
		else
			L.apply_armoured_damage(damage, ARMOR_BULLET, BRUTE, null, penetration)
		// 150% damage to runners (225), 300% against Big xenos (450), and 200% against all others (300). -Kaga
		to_chat(P.firer, SPAN_WARNING("Bullseye!"))

/*
//======
					Special Ammo
//======
*/

/datum/ammo/bullet/smartgun
	name = "smartgun bullet"
	icon_state = "redbullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	max_range = 12
	accuracy = HIT_ACCURACY_TIER_4
	damage = 30
	penetration = 0

/datum/ammo/bullet/smartgun/armor_piercing
	name = "armor-piercing smartgun bullet"
	icon_state = "bullet"

	accurate_range = 12
	accuracy = HIT_ACCURACY_TIER_2
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_8
	damage_armor_punch = 1

/datum/ammo/bullet/smartgun/dirty
	name = "irradiated smartgun bullet"
	debilitate = list(0,0,0,3,0,0,0,1)

	shrapnel_chance = SHRAPNEL_CHANCE_TIER_7
	accurate_range = 32
	accuracy = HIT_ACCURACY_TIER_3
	damage = 40
	penetration = 0

/datum/ammo/bullet/smartgun/dirty/armor_piercing
	debilitate = list(0,0,0,3,0,0,0,1)

	accurate_range = 22
	accuracy = HIT_ACCURACY_TIER_3
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_7
	damage_armor_punch = 3

/datum/ammo/bullet/smartgun/m56_fpw
	name = "m56 FPW bullet"
	icon_state = "redbullet"
	flags_ammo_behavior = AMMO_BALLISTIC

	max_range = 7
	accuracy = HIT_ACCURACY_TIER_7
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_1

/datum/ammo/bullet/turret
	name = "autocannon bullet"
	icon_state 	= "redbullet" //Red bullets to indicate friendly fire restriction
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_COVER

	accurate_range = 22
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_8
	max_range = 22
	damage = 30
	penetration = ARMOR_PENETRATION_TIER_7
	damage_armor_punch = 0
	pen_armor_punch = 0
	shell_speed = 2*AMMO_SPEED_TIER_6
	accuracy = HIT_ACCURACY_TIER_5

/datum/ammo/bullet/turret/dumb
	icon_state 	= "bullet"
	flags_ammo_behavior = AMMO_BALLISTIC

/datum/ammo/bullet/machinegun //Adding this for the MG Nests (~Art)
	name = "machinegun bullet"
	icon_state 	= "bullet" // Keeping it bog standard with the turret but allows it to be changed

	accurate_range = 12
	damage = 35
	penetration= ARMOR_PENETRATION_TIER_10 //Bumped the penetration to serve a different role from sentries, MGs are a bit more offensive
	accuracy = HIT_ACCURACY_TIER_3

/datum/ammo/bullet/machinegun/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff)
	))

/datum/ammo/bullet/machinegun/auto // for M2C, automatic variant for M56D, stats for bullet should always be moderately overtuned to fulfill its ultra-offense + flank-push purpose
	name = "heavy machinegun bullet"

	accurate_range = 10
	damage =  50
	penetration = ARMOR_PENETRATION_TIER_6
	accuracy = HIT_ACCURACY_TIER_9 + HIT_ACCURACY_TIER_5 // 75 accuracy
	shell_speed = AMMO_SPEED_TIER_2
	max_range = 15
	effective_range_max = 7
	damage_falloff = DAMAGE_FALLOFF_TIER_8

/datum/ammo/bullet/machinegun/auto/set_bullet_traits()
	return

/datum/ammo/bullet/minigun
	name = "minigun bullet"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM

	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 12
	damage = 35
	penetration = ARMOR_PENETRATION_TIER_6

/datum/ammo/bullet/minigun/New()
	..()
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		damage = 15
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, .proc/setup_hvh_damage)

/datum/ammo/bullet/minigun/proc/setup_hvh_damage()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		damage = 15

/datum/ammo/bullet/minigun/tank
	accuracy = -HIT_ACCURACY_TIER_1
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_8
	accurate_range = 12

/datum/ammo/bullet/m60
	name = "M60 bullet"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM

	accuracy = -HIT_ACCURACY_TIER_3
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_8
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 12
	damage = 25
	penetration= ARMOR_PENETRATION_TIER_6
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2

/*
//======
					Rocket Ammo
//======
*/

/datum/ammo/rocket
	name = "high explosive rocket"
	icon_state = "missile"
	ping = null //no bounce off.
	sound_bounce	= "rocket_bounce"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET|AMMO_STRIKES_SURFACE
	var/datum/effect_system/smoke_spread/smoke

	accuracy = HIT_ACCURACY_TIER_2
	accurate_range = 7
	max_range = 7
	damage = 15
	shell_speed = AMMO_SPEED_TIER_1

/datum/ammo/rocket/New()
	..()
	smoke = new()

/datum/ammo/rocket/Destroy()
	qdel(smoke)
	smoke = null
	. = ..()

/datum/ammo/rocket/on_hit_mob(mob/M, obj/item/projectile/P)
	cell_explosion(get_turf(M), 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, get_turf(M))
	if(isHumanStrict(M)) // No yautya or synths. Makes humans gib on direct hit.
		M.ex_act(350, P.dir, P.weapon_cause_data, 100)
	smoke.start()

/datum/ammo/rocket/on_hit_obj(obj/O, obj/item/projectile/P)
	cell_explosion(get_turf(O), 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, get_turf(O))
	smoke.start()

/datum/ammo/rocket/on_hit_turf(turf/T, obj/item/projectile/P)
	cell_explosion(T, 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/do_at_max_range(obj/item/projectile/P)
	cell_explosion(get_turf(P), 150, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, get_turf(P))
	smoke.start()

/datum/ammo/rocket/ap
	name = "anti-armor rocket"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET

	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	accurate_range = 6
	max_range = 6
	damage = 10
	penetration= ARMOR_PENETRATION_TIER_10

/datum/ammo/rocket/ap/on_hit_mob(mob/M, obj/item/projectile/P)
	var/turf/T = get_turf(M)
	M.ex_act(150, P.dir, P.weapon_cause_data, 100)
	M.KnockDown(2)
	M.KnockOut(2)
	if(isHumanStrict(M)) // No yautya or synths. Makes humans gib on direct hit.
		M.ex_act(300, P.dir, P.weapon_cause_data, 100)
	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/on_hit_obj(obj/O, obj/item/projectile/P)
	var/turf/T = get_turf(O)
	O.ex_act(150, P.dir, P.weapon_cause_data, 100)
	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/on_hit_turf(turf/T, obj/item/projectile/P)
	var/hit_something = 0
	for(var/mob/M in T)
		M.ex_act(150, P.dir, P.weapon_cause_data, 100)
		M.KnockDown(4)
		M.KnockOut(4)
		hit_something = 1
		continue
	if(!hit_something)
		for(var/obj/O in T)
			if(O.density)
				O.ex_act(150, P.dir, P.weapon_cause_data, 100)
				hit_something = 1
				continue
	if(!hit_something)
		T.ex_act(150, P.dir, P.weapon_cause_data, 200)

	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/do_at_max_range(obj/item/projectile/P)
	var/turf/T = get_turf(P)
	var/hit_something = 0
	for(var/mob/M in T)
		M.ex_act(250, P.dir, P.weapon_cause_data, 100)
		M.KnockDown(2)
		M.KnockOut(2)
		hit_something = 1
		continue
	if(!hit_something)
		for(var/obj/O in T)
			if(O.density)
				O.ex_act(250, P.dir, P.weapon_cause_data, 100)
				hit_something = 1
				continue
	if(!hit_something)
		T.ex_act(250, P.dir, P.weapon_cause_data)
	cell_explosion(T, 100, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	smoke.set_up(1, T)
	smoke.start()

/datum/ammo/rocket/ap/anti_tank
	name = "anti-tank rocket"
	damage = 100
	var/vehicle_slowdown_time = 5 SECONDS
	shrapnel_chance = 5
	shrapnel_type = /obj/item/large_shrapnel/at_rocket_dud

/datum/ammo/rocket/ap/anti_tank/on_hit_obj(obj/O, obj/item/projectile/P)
	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/M = O
		M.next_move = world.time + vehicle_slowdown_time
		playsound(M, 'sound/effects/meteorimpact.ogg', 35)
		M.at_munition_interior_explosion_effect(cause_data = create_cause_data("Anti-Tank Rocket"))
		M.interior_crash_effect()
		var/turf/T = get_turf(M.loc)
		M.ex_act(150, P.dir, P.weapon_cause_data, 100)
		smoke.set_up(1, T)
		smoke.start()
		return
	return ..()


/datum/ammo/rocket/ltb
	name = "cannon round"
	icon_state = "ltb"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_ROCKET|AMMO_STRIKES_SURFACE

	accuracy = HIT_ACCURACY_TIER_3
	accurate_range = 32
	max_range = 32
	damage = 25
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/rocket/ltb/on_hit_mob(mob/M, obj/item/projectile/P)
	cell_explosion(get_turf(M), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(M), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/ltb/on_hit_obj(obj/O, obj/item/projectile/P)
	cell_explosion(get_turf(O), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(O), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/ltb/on_hit_turf(turf/T, obj/item/projectile/P)
	cell_explosion(get_turf(T), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(T), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/ltb/do_at_max_range(obj/item/projectile/P)
	cell_explosion(get_turf(P), 220, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	cell_explosion(get_turf(P), 200, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/rocket/wp
	name = "white phosphorous rocket"
	flags_ammo_behavior = AMMO_ROCKET|AMMO_EXPLOSIVE|AMMO_STRIKES_SURFACE
	damage_type = BURN

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 8
	damage = 90
	max_range = 8

/datum/ammo/rocket/wp/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/rocket/wp/drop_flame(turf/T, datum/cause_data/cause_data)
	playsound(T, 'sound/weapons/gun_flamethrower3.ogg', 75, 1, 7)
	if(!istype(T)) return
	smoke.set_up(1, T)
	smoke.start()
	var/datum/reagent/napalm/blue/R = new()
	new /obj/flamer_fire(T, cause_data, R, 3)

	var/datum/effect_system/smoke_spread/phosphorus/landingSmoke = new /datum/effect_system/smoke_spread/phosphorus
	landingSmoke.set_up(3, 0, T, null, 6, cause_data)
	landingSmoke.start()
	landingSmoke = null

/datum/ammo/rocket/wp/on_hit_mob(mob/M, obj/item/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)

/datum/ammo/rocket/wp/on_hit_obj(obj/O, obj/item/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)

/datum/ammo/rocket/wp/on_hit_turf(turf/T, obj/item/projectile/P)
	drop_flame(T, P.weapon_cause_data)

/datum/ammo/rocket/wp/do_at_max_range(obj/item/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)

/datum/ammo/rocket/wp/quad
	name = "thermobaric rocket"
	flags_ammo_behavior = AMMO_ROCKET|AMMO_STRIKES_SURFACE

	damage = 100
	max_range = 32

/datum/ammo/rocket/wp/quad/on_hit_mob(mob/M, obj/item/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/wp/quad/on_hit_obj(obj/O, obj/item/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/wp/quad/on_hit_turf(turf/T, obj/item/projectile/P)
	drop_flame(T, P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/wp/quad/do_at_max_range(obj/item/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)
	explosion(P.loc,  -1, 2, 4, 5, , , ,P.weapon_cause_data)

/datum/ammo/rocket/custom
	name = "custom rocket"

/datum/ammo/rocket/custom/proc/prime(atom/A, obj/item/projectile/P)
	var/obj/item/weapon/gun/launcher/rocket/launcher = P.shot_from
	var/obj/item/ammo_magazine/rocket/custom/rocket = launcher.current_mag
	if(rocket.locked && rocket.warhead && rocket.warhead.detonator)
		if(rocket.fuel && rocket.fuel.reagents.get_reagent_amount(rocket.fuel_type) >= rocket.fuel_requirement)
			rocket.forceMove(P.loc)
		rocket.warhead.cause_data = P.weapon_cause_data
		rocket.warhead.prime()
		qdel(rocket)
	smoke.set_up(1, get_turf(A))
	smoke.start()

/datum/ammo/rocket/custom/on_hit_mob(mob/M, obj/item/projectile/P)
	prime(M, P)

/datum/ammo/rocket/custom/on_hit_obj(obj/O, obj/item/projectile/P)
	prime(O, P)

/datum/ammo/rocket/custom/on_hit_turf(turf/T, obj/item/projectile/P)
	prime(T, P)

/datum/ammo/rocket/custom/do_at_max_range(obj/item/projectile/P)
	prime(null, P)

/*
//======
					Energy Ammo
//======
*/

/datum/ammo/energy
	ping = null //no bounce off. We can have one later.
	sound_hit 	 	= "energy_hit"
	sound_miss		= "energy_miss"
	sound_bounce	= "energy_bounce"

	damage_type = BURN
	flags_ammo_behavior = AMMO_ENERGY

	accuracy = HIT_ACCURACY_TIER_4

/datum/ammo/energy/emitter //Damage is determined in emitter.dm
	name = "emitter bolt"
	icon_state = "emitter"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_ARMOR

	accurate_range 	= 6
	max_range 		= 6

/datum/ammo/energy/taser
	name = "taser bolt"
	icon_state = "stun"
	damage_type = OXY
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST|AMMO_ALWAYS_FF //Not that ignoring will do much right now.

	stamina_damage = 45
	accuracy = HIT_ACCURACY_TIER_8
	shell_speed = AMMO_SPEED_TIER_1 // Slightly faster

/datum/ammo/energy/taser/on_hit_mob(mob/M, obj/item/projectile/P)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.disable_special_items() // Disables scout cloak

/datum/ammo/energy/taser/precise
	name = "precise taser bolt"
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST|AMMO_MP

/datum/ammo/energy/rxfm_eva
	name = "focused energy bolt"
	icon_state = "cm_laser"
	flags_ammo_behavior = AMMO_ENERGY
	accurate_range = 7
	max_range = 14
	damage = 25
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/energy/laz_uzi
	name = "laser bolt"
	icon_state = "laser_new"
	flags_ammo_behavior = AMMO_ENERGY
	damage = 40
	accurate_range = 5
	effective_range_max = 7
	max_range = 10
	shell_speed = AMMO_SPEED_TIER_4
	scatter = SCATTER_AMOUNT_TIER_6
	accuracy = HIT_ACCURACY_TIER_3
	damage_falloff = DAMAGE_FALLOFF_TIER_8

/datum/ammo/energy/yautja/
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM
	accurate_range = 12
	shell_speed = AMMO_SPEED_TIER_3
	damage_type = BURN
	flags_ammo_behavior = AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/pistol
	name = "plasma pistol bolt"
	icon_state = "ion"

	damage = 40
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/energy/yautja/pistol/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/energy/yautja/caster
	name = "root caster bolt"
	icon_state = "ion"

/datum/ammo/energy/yautja/caster/stun
	name = "low power stun bolt"
	debilitate = list(2,2,0,0,0,1,0,0)

	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/caster/bolt
	name = "plasma bolt"
	icon_state = "pulse1"
	flags_ammo_behavior = AMMO_IGNORE_RESIST
	shell_speed = AMMO_SPEED_TIER_6
	damage = 35

/datum/ammo/energy/yautja/caster/bolt/stun
	name = "high power stun bolt"
	var/stun_time = 2

	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST

/datum/ammo/energy/yautja/caster/bolt/stun/on_hit_mob(mob/M, obj/item/projectile/P)
	var/mob/living/carbon/C = M
	var/stun_time = src.stun_time
	if(istype(C))
		if(isYautja(C) || isXenoPredalien(C))
			return
		to_chat(C, SPAN_DANGER("An electric shock ripples through your body, freezing you in place!"))
		log_attack("[key_name(C)] was stunned by a high power stun bolt from [key_name(P.firer)] at [get_area(P)]")

		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			stun_time++
			H.KnockDown(stun_time)
		else
			M.KnockDown(stun_time, 1)

		C.Stun(stun_time)
	..()

/datum/ammo/energy/yautja/caster/sphere
	name = "plasma eradicator"
	icon_state = "bluespace"
	flags_ammo_behavior = AMMO_EXPLOSIVE|AMMO_HITS_TARGET_TURF
	shell_speed = AMMO_SPEED_TIER_4
	accuracy = HIT_ACCURACY_TIER_8

	damage = 55

	accurate_range = 8
	max_range = 8

	var/vehicle_slowdown_time = 5 SECONDS

/datum/ammo/energy/yautja/caster/sphere/on_hit_mob(mob/M, obj/item/projectile/P)
	cell_explosion(P, 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/energy/yautja/caster/sphere/on_hit_turf(turf/T, obj/item/projectile/P)
	cell_explosion(P, 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/energy/yautja/caster/sphere/on_hit_obj(obj/O, obj/item/projectile/P)
	if(istype(O, /obj/vehicle/multitile))
		var/obj/vehicle/multitile/multitile_vehicle = O
		multitile_vehicle.next_move = world.time + vehicle_slowdown_time
		playsound(multitile_vehicle, 'sound/effects/meteorimpact.ogg', 35)
		multitile_vehicle.at_munition_interior_explosion_effect(cause_data = create_cause_data("Plasma Eradicator", P.firer))
		multitile_vehicle.interior_crash_effect()
		multitile_vehicle.ex_act(150, P.dir, P.weapon_cause_data, 100)
	cell_explosion(get_turf(P), 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)

/datum/ammo/energy/yautja/caster/sphere/do_at_max_range(obj/item/projectile/P)
	cell_explosion(get_turf(P), 170, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)


/datum/ammo/energy/yautja/caster/sphere/stun
	name = "plasma immobilizer"
	damage = 0
	flags_ammo_behavior = AMMO_ENERGY|AMMO_IGNORE_RESIST
	accurate_range = 20
	max_range = 20

	var/stun_range = 4 // Big
	var/stun_time = 6

/datum/ammo/energy/yautja/caster/sphere/stun/on_hit_mob(mob/M, obj/item/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/on_hit_turf(turf/T,obj/item/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/on_hit_obj(obj/O,obj/item/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/do_at_max_range(obj/item/projectile/P)
	do_area_stun(P)

/datum/ammo/energy/yautja/caster/sphere/stun/proc/do_area_stun(obj/item/projectile/P)
	playsound(P, 'sound/weapons/wave.ogg', 75, 1, 25)
	for (var/mob/living/carbon/M in view(src.stun_range, get_turf(P)))
		var/stun_time = src.stun_time
		log_attack("[key_name(M)] was stunned by a plasma immobilizer from [key_name(P.firer)] at [get_area(P)]")
		if (isYautja(M))
			stun_time -= 2
		if(isXenoPredalien(M))
			continue
		to_chat(M, SPAN_DANGER("A powerful electric shock ripples through your body, freezing you in place!"))
		M.Stun(stun_time)

		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			H.KnockDown(stun_time)
		else
			M.KnockDown(stun_time, 1)




/datum/ammo/energy/yautja/rifle/bolt
	name = "plasma rifle bolt"
	icon_state = "ion"
	damage_type = BURN
	debilitate = list(0,2,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_IGNORE_RESIST

	damage = 55

/datum/ammo/energy/yautja/rifle/blast
	name = "plasma shatterer"
	icon_state = "bluespace"
	damage_type = BURN

	shell_speed = AMMO_SPEED_TIER_4
	damage = 40

/datum/ammo/energy/yautja/rifle/blast/on_hit_mob(mob/M, obj/item/projectile/P)
	var/L = get_turf(M)
	cell_explosion(L, 90, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	..()

/datum/ammo/energy/yautja/rifle/blast/on_hit_turf(turf/T, obj/item/projectile/P)
	cell_explosion(T, 90, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	..()

/datum/ammo/energy/yautja/rifle/blast/on_hit_obj(obj/O, obj/item/projectile/P)
	cell_explosion(get_turf(O), 100, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	..()

/datum/ammo/energy/yautja/rifle/blast/do_at_max_range(obj/item/projectile/P)
	cell_explosion(get_turf(P), 100, 30, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, P.weapon_cause_data)
	..()


/*
//======
					Xeno Spits
//======
*/
/datum/ammo/xeno
	icon_state = "neurotoxin"
	ping = "ping_x"
	damage_type = TOX
	flags_ammo_behavior = AMMO_XENO_ACID
	var/added_spit_delay = 0 //used to make cooldown of the different spits vary.
	var/spit_cost

	accuracy = HIT_ACCURACY_TIER_8*2
	max_range = 12

/datum/ammo/xeno/toxin
	name = "neurotoxic spit"
	damage_falloff = 0
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_IGNORE_RESIST
	spit_cost = 25
	var/effect_power = XENO_NEURO_TIER_4
	var/datum/callback/neuro_callback

	shell_speed = AMMO_SPEED_TIER_3
	max_range = 7

/datum/ammo/xeno/toxin/New()
	..()

	neuro_callback = CALLBACK(GLOBAL_PROC, .proc/apply_neuro)

/proc/apply_neuro(mob/M, power, insta_neuro)
	if(skillcheck(M, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX) && !insta_neuro)
		M.visible_message(SPAN_DANGER("[M] withstands the neurotoxin!"))
		return //endurance 5 makes you immune to weak neurotoxin
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || H.species.flags & NO_NEURO)
			H.visible_message(SPAN_DANGER("[M] shrugs off the neurotoxin!"))
			return //species like zombies or synths are immune to neurotoxin

	if(!isXeno(M))
		if(insta_neuro)
			if(M.knocked_down < 3)
				M.AdjustKnockeddown(1 * power)
			return

		if(ishuman(M))
			M.Superslow(2.5)
			M.visible_message(SPAN_DANGER("[M]'s movements are slowed."))

		var/no_clothes_neuro = FALSE

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.wear_suit || H.wear_suit.slowdown == 0)
				no_clothes_neuro = TRUE

		if(no_clothes_neuro)
			if(M.knocked_down < 5)
				M.AdjustKnockeddown(1 * power) // KD them a bit more
				M.visible_message(SPAN_DANGER("[M] falls prone."))

/proc/apply_scatter_neuro(mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(skillcheck(M, SKILL_ENDURANCE, SKILL_ENDURANCE_MAX))
			M.visible_message(SPAN_DANGER("[M] withstands the neurotoxin!"))
			return //endurance 5 makes you immune to weak neuro
		if(H.chem_effect_flags & CHEM_EFFECT_RESIST_NEURO || H.species.flags & NO_NEURO)
			H.visible_message(SPAN_DANGER("[M] shrugs off the neurotoxin!"))
			return

		if(M.knocked_down < 0.7) // apply knockdown only if current knockdown is less than 0.7 second
			M.KnockDown(0.7)
			M.visible_message(SPAN_DANGER("[M] falls prone."))

/datum/ammo/xeno/toxin/on_hit_mob(mob/M,obj/item/projectile/P)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.status_flags & XENO_HOST)
			neuro_callback.Invoke(H, effect_power, TRUE)
			return

	neuro_callback.Invoke(M, effect_power, FALSE)

/datum/ammo/xeno/toxin/medium //Spitter
	name = "neurotoxic spatter"
	spit_cost = 50
	effect_power = 1

	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/xeno/toxin/queen
	name = "neurotoxic spit"
	spit_cost = 50
	effect_power = 2

	accuracy = HIT_ACCURACY_TIER_5*2
	max_range = 6 - 1

/datum/ammo/xeno/toxin/queen/on_hit_mob(mob/M,obj/item/projectile/P)
	neuro_callback.Invoke(M, effect_power, TRUE)

/datum/ammo/xeno/toxin/shotgun
	name = "neurotoxic droplet"
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_IGNORE_RESIST
	bonus_projectiles_type = /datum/ammo/xeno/toxin/shotgun/additional

	accuracy_var_low = PROJECTILE_VARIANCE_TIER_6
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_6
	accurate_range = 5
	max_range = 5
	scatter = SCATTER_AMOUNT_NEURO
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_4

/datum/ammo/xeno/toxin/shotgun/New()
	..()

	neuro_callback = CALLBACK(GLOBAL_PROC, .proc/apply_scatter_neuro)

/datum/ammo/xeno/toxin/shotgun/additional
	name = "additional neurotoxic droplets"

	bonus_projectiles_amount = 0

/*proc/neuro_flak(turf/T, obj/item/projectile/P, datum/callback/CB, power, insta_neuro, radius)
	if(!T) return FALSE
	var/firer = P.firer
	var/hit_someone = FALSE
	for(var/mob/living/carbon/M in orange(radius,T))
		if(isXeno(M) && isXeno(firer) && M:hivenumber == firer:hivenumber)
			continue

		if(HAS_TRAIT(M, TRAIT_NESTED))
			continue

		hit_someone = TRUE
		CB.Invoke(M, power, insta_neuro)

		P.play_damage_effect(M)

	return hit_someone

/datum/ammo/xeno/toxin/burst //sentinel burst
	name = "neurotoxic air splash"
	effect_power = XENO_NEURO_TIER_1
	spit_cost = 50
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_IGNORE_RESIST

/datum/ammo/xeno/toxin/burst/on_hit_mob(mob/M, obj/item/projectile/P)
	if(isXeno(M) && isXeno(P.firer) && M:hivenumber == P.firer:hivenumber)
		neuro_callback.Invoke(M, effect_power*1.5, TRUE)

	neuro_flak(get_turf(M), P, neuro_callback, effect_power, FALSE, 1)

/datum/ammo/xeno/toxin/burst/on_near_target(turf/T, obj/item/projectile/P)
	return neuro_flak(T, P, neuro_callback, effect_power, FALSE, 1)

/datum/ammo/xeno/sticky
	name = "sticky resin spit"
	icon_state = "sticky"
	ping = null
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE
	added_spit_delay = 5
	spit_cost = 40

	shell_speed = AMMO_SPEED_TIER_3
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_4
	max_range = 32

/datum/ammo/xeno/sticky/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_resin(T)

/datum/ammo/xeno/sticky/do_at_max_range(obj/item/projectile/P)
	drop_resin(get_turf(P))

/datum/ammo/xeno/sticky/proc/drop_resin(turf/T)
	if(T.density)
		return

	for(var/obj/O in T.contents)
		if(istype(O, /obj/item/clothing/mask/facehugger))
			return
		if(istype(O, /obj/effect/alien/egg))
			return
		if(istype(O, /obj/structure/mineral_door) || istype(O, /obj/effect/alien/resin) || istype(O, /obj/structure/bed))
			return
		if(O.density && !(O.flags_atom & ON_BORDER))
			return

	new /obj/effect/alien/resin/sticky/thin(T) */

/datum/ammo/xeno/acid
	name = "acid spit"
	icon_state = "xeno_acid"
	sound_hit 	 = "acid_hit"
	sound_bounce	= "acid_bounce"
	damage_type = BURN
	added_spit_delay = 10
	spit_cost = 25

	accuracy = HIT_ACCURACY_TIER_3
	damage = 25
	penetration = ARMOR_PENETRATION_TIER_2
	shell_speed = AMMO_SPEED_TIER_2

/datum/ammo/xeno/acid/on_shield_block(mob/M, obj/item/projectile/P)
	burst(M,P,damage_type)

/datum/ammo/xeno/acid/on_hit_mob(mob/M, obj/item/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.status_flags & XENO_HOST && HAS_TRAIT(C, TRAIT_NESTED) || C.stat == DEAD)
			return
	..()

/datum/ammo/xeno/acid/medium
	name = "acid spatter"

	damage = 25
	shell_speed = AMMO_SPEED_TIER_3
	accuracy = HIT_ACCURACY_TIER_5*3
	max_range = 6

/datum/ammo/xeno/acid/praetorian
	name = "acid splash"

	accuracy = HIT_ACCURACY_TIER_10 + HIT_ACCURACY_TIER_5
	max_range = 8
	damage = 30
	shell_speed = AMMO_SPEED_TIER_2
	added_spit_delay = 0

/datum/ammo/xeno/acid/dot
	name = "acid spit"

/datum/ammo/xeno/acid/prae_nade // Used by base prae's acid nade
	name = "acid spatter"

	flags_ammo_behavior = AMMO_STOPPED_BY_COVER
	accuracy = HIT_ACCURACY_TIER_5
	accurate_range = 32
	max_range = 4
	damage = 25
	shell_speed = AMMO_SPEED_TIER_1
	scatter = SCATTER_AMOUNT_TIER_6

	apply_delegate = FALSE

/datum/ammo/xeno/acid/prae_nade/on_hit_mob(mob/M, obj/item/projectile/P)
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

/*datum/ammo/xeno/prae_skillshot
	name = "blob of acid"
	icon_state = "boiler_gas2"
	ping = "ping_x"
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE|AMMO_IGNORE_RESIST

	accuracy = HIT_ACCURACY_TIER_5
	accurate_range = 32
	max_range = 8
	damage = 20
	damage_falloff = DAMAGE_FALLOFF_TIER_10
	shell_speed = AMMO_SPEED_TIER_1
	scatter = SCATTER_AMOUNT_TIER_10

/datum/ammo/xeno/prae_skillshot/on_hit_mob(mob/M, obj/item/projectile/P)
	acid_stacks_aoe(get_turf(P))

/datum/ammo/xeno/prae_skillshot/on_hit_obj(obj/O, obj/item/projectile/P)
	acid_stacks_aoe(get_turf(P))

/datum/ammo/xeno/prae_skillshot/on_hit_turf(turf/T, obj/item/projectile/P)
	acid_stacks_aoe(get_turf(P))

/datum/ammo/xeno/prae_skillshot/do_at_max_range(obj/item/projectile/P)
	acid_stacks_aoe(get_turf(P))

/datum/ammo/xeno/prae_skillshot/proc/acid_stacks_aoe(var/turf/T)

	if (!istype(T))
		return

	for (var/mob/living/carbon/human/H in orange(1, T))
		to_chat(H, SPAN_XENODANGER("You are spattered with acid!"))
		animation_flash_color(H)
		var/datum/effects/prae_acid_stacks/PAS = null
		for (var/datum/effects/prae_acid_stacks/prae_acid_stacks in H.effects_list)
			PAS = prae_acid_stacks
			break

		if (PAS == null)
			PAS = new /datum/effects/prae_acid_stacks(H)
			PAS.increment_stack_count()
		else
			PAS.increment_stack_count()
			PAS.increment_stack_count() */

/datum/ammo/xeno/boiler_gas
	name = "glob of gas"
	icon_state = "boiler_gas2"
	ping = "ping_x"
	debilitate = list(19,21,0,0,11,12,0,0)
	flags_ammo_behavior = AMMO_XENO_TOX|AMMO_SKIPS_ALIENS|AMMO_EXPLOSIVE|AMMO_IGNORE_RESIST
	var/datum/effect_system/smoke_spread/smoke_system

	accuracy_var_high = PROJECTILE_VARIANCE_TIER_4
	max_range = 32

/datum/ammo/xeno/boiler_gas/New()
	..()
	set_xeno_smoke()

/datum/ammo/xeno/boiler_gas/Destroy()
	qdel(smoke_system)
	smoke_system = null
	. = ..()

/datum/ammo/xeno/boiler_gas/on_hit_mob(mob/M, obj/item/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.status_flags & XENO_HOST && HAS_TRAIT(C, TRAIT_NESTED) || C.stat == DEAD)
			return
	drop_nade(get_turf(P), P)

/datum/ammo/xeno/boiler_gas/on_hit_obj(obj/O, obj/item/projectile/P)
	drop_nade(get_turf(P), P)

/datum/ammo/xeno/boiler_gas/on_hit_turf(turf/T, obj/item/projectile/P)
	if(T.density && isturf(P.loc))
		drop_nade(P.loc, P) //we don't want the gas globs to land on dense turfs, they block smoke expansion.
	else
		drop_nade(T, P)

/datum/ammo/xeno/boiler_gas/do_at_max_range(obj/item/projectile/P)
	drop_nade(get_turf(P), P)

/datum/ammo/xeno/boiler_gas/proc/set_xeno_smoke(obj/item/projectile/P)
	smoke_system = new /datum/effect_system/smoke_spread/xeno_weaken()

/datum/ammo/xeno/boiler_gas/proc/drop_nade(turf/T, obj/item/projectile/P)
	var/amount = 4
	var/lifetime_mult = 1.0
	if(isXenoBoiler(P.firer))
		smoke_system.cause_data = P.weapon_cause_data
	smoke_system.set_up(amount, 0, T)
	smoke_system.lifetime = 12 * lifetime_mult
	smoke_system.start()
	T.visible_message(SPAN_DANGER("A glob of acid lands with a splat and explodes into noxious fumes!"))


/datum/ammo/xeno/bone_chips
	name = "bone chips"
	icon_state = "shrapnel_light"
	ping = null
	flags_ammo_behavior = AMMO_XENO_BONE|AMMO_SKIPS_ALIENS|AMMO_STOPPED_BY_COVER|AMMO_IGNORE_ARMOR
	damage_type = BRUTE
	bonus_projectiles_type = /datum/ammo/xeno/bone_chips/spread

	damage = 5
	max_range = 5
	accuracy = HIT_ACCURACY_TIER_8
	accuracy_var_low = PROJECTILE_VARIANCE_TIER_7
	accuracy_var_high = PROJECTILE_VARIANCE_TIER_7
	bonus_projectiles_amount = EXTRA_PROJECTILES_TIER_7
	shrapnel_type = /obj/item/shard/shrapnel/bone_chips
	shrapnel_chance = 60

/datum/ammo/xeno/bone_chips/on_hit_mob(mob/M, obj/item/projectile/P)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if((HAS_FLAG(C.status_flags, XENO_HOST) && HAS_TRAIT(C, TRAIT_NESTED)) || C.stat == DEAD)
			return
	if(isHumanStrict(M) || isXeno(M))
		playsound(M, 'sound/effects/spike_hit.ogg', 25, 1, 1)
		if(M.slowed < 8)
			M.Slow(8)

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

/datum/ammo/xeno/bone_chips/spread/runner/on_hit_mob(mob/M, obj/item/projectile/P)
    if(iscarbon(M))
        var/mob/living/carbon/C = M
        if((HAS_FLAG(C.status_flags, XENO_HOST) && HAS_TRAIT(C, TRAIT_NESTED)) || C.stat == DEAD)
            return
    if(isHumanStrict(M) || isXeno(M))
        playsound(M, 'sound/effects/spike_hit.ogg', 25, 1, 1)
        if(M.slowed < 6)
            M.Slow(6)

/*
//======
					Shrapnel
//======
*/
/datum/ammo/bullet/shrapnel
	name = "shrapnel"
	icon_state = "buckshot"
	accurate_range_min = 5
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_STOPPED_BY_COVER

	accuracy = HIT_ACCURACY_TIER_3
	accurate_range = 32
	max_range = 8
	damage = 25
	damage_var_low = -PROJECTILE_VARIANCE_TIER_6
	damage_var_high = PROJECTILE_VARIANCE_TIER_6
	penetration = ARMOR_PENETRATION_TIER_4
	shell_speed = AMMO_SPEED_TIER_2
	shrapnel_chance = 5

/datum/ammo/bullet/shrapnel/on_hit_obj(obj/O, obj/item/projectile/P)
	if(istype(O, /obj/structure/barricade))
		var/obj/structure/barricade/B = O
		B.health -= rand(2, 5)
		B.update_health(1)

/datum/ammo/bullet/shrapnel/rubber
	name = "rubber pellets"
	icon_state = "rubber_pellets"
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER

	damage = 0
	stamina_damage = 25
	shrapnel_chance = 0


/datum/ammo/bullet/shrapnel/hornet_rounds
	name = ".22 hornet round"
	icon_state = "hornet_round"
	flags_ammo_behavior = AMMO_BALLISTIC
	damage = 20
	shrapnel_chance = 0
	shell_speed = AMMO_SPEED_TIER_3//she fast af boi
	penetration = ARMOR_PENETRATION_TIER_5

/datum/ammo/bullet/shrapnel/hornet_rounds/on_hit_mob(mob/M, obj/item/projectile/P)
	. = ..()
	M.AddComponent(/datum/component/bonus_damage_stack, 10, world.time)

/datum/ammo/bullet/shrapnel/incendiary
	name = "flaming shrapnel"
	icon_state = "beanbag" // looks suprisingly a lot like flaming shrapnel chunks
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER

	shell_speed = AMMO_SPEED_TIER_1
	damage = 20
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/shrapnel/incendiary/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/bullet/shrapnel/metal
	name = "metal shrapnel"
	icon_state = "shrapnelshot_bit"
	flags_ammo_behavior = AMMO_STOPPED_BY_COVER|AMMO_BALLISTIC
	shell_speed = AMMO_SPEED_TIER_1
	damage = 30
	shrapnel_chance = 15
	accuracy = HIT_ACCURACY_TIER_8
	penetration = ARMOR_PENETRATION_TIER_4

/datum/ammo/bullet/shrapnel/light // weak shrapnel
	name = "light shrapnel"
	icon_state = "shrapnel_light"

	damage = 10
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_1
	shrapnel_chance = 0

/datum/ammo/bullet/shrapnel/light/human
	name = "human bone fragments"
	icon_state = "shrapnel_human"

	shrapnel_chance = 50
	shrapnel_type = /obj/item/shard/shrapnel/bone_chips/human

/datum/ammo/bullet/shrapnel/light/human/var1 // sprite variants
	icon_state = "shrapnel_human1"

/datum/ammo/bullet/shrapnel/light/human/var2 // sprite variants
	icon_state = "shrapnel_human2"

/datum/ammo/bullet/shrapnel/light/xeno
	name = "alien bone fragments"
	icon_state = "shrapnel_xeno"

	shrapnel_chance = 50
	shrapnel_type = /obj/item/shard/shrapnel/bone_chips/xeno

/datum/ammo/bullet/shrapnel/spall // weak shrapnel
	name = "spall"
	icon_state = "shrapnel_light"

	damage = 10
	penetration = ARMOR_PENETRATION_TIER_1
	shell_speed = AMMO_SPEED_TIER_1
	shrapnel_chance = 0

/datum/ammo/bullet/shrapnel/light/glass
	name = "glass shrapnel"
	icon_state = "shrapnel_glass"

/datum/ammo/bullet/shrapnel/light/effect/ // no damage, but looks bright and neat
	name = "sparks"

	damage = 1 // Tickle tickle

/datum/ammo/bullet/shrapnel/light/effect/ver1
	icon_state = "shrapnel_bright1"

/datum/ammo/bullet/shrapnel/light/effect/ver2
	icon_state = "shrapnel_bright2"

/datum/ammo/bullet/shrapnel/jagged
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_2
	accuracy = HIT_ACCURACY_TIER_MAX

/datum/ammo/bullet/shrapnel/jagged/on_hit_mob(mob/M, obj/item/projectile/P)
	if(isXeno(M))
		M.Slow(0.4)

/*
//========
					CAS 30mm impacters
//========
*/
/datum/ammo/bullet/shrapnel/gau  //for the GAU to have a impact bullet instead of firecrackers
	name = "30mm Multi-Purpose shell"

	damage = 115 //More damaging, but 2x less shells and low AP
	penetration = ARMOR_PENETRATION_TIER_2
	accuracy = HIT_ACCURACY_TIER_MAX
	max_range = 0
	shrapnel_chance = 100 //the least of your problems

/datum/ammo/bullet/shrapnel/gau/at
	name = "30mm Anti-Tank shell"

	damage = 80 //Standard AP vs standard. (more AP for less damage)
	penetration = ARMOR_PENETRATION_TIER_8
	accuracy = HIT_ACCURACY_TIER_MAX
/*
//======
					Misc Ammo
//======
*/

/datum/ammo/alloy_spike
	name = "alloy spike"
	headshot_state	= HEADSHOT_OVERLAY_MEDIUM
	ping = "ping_s"
	icon_state = "MSpearFlight"
	sound_hit 	 	= "alloy_hit"
	sound_armor	 	= "alloy_armor"
	sound_bounce	= "alloy_bounce"

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 12
	max_range = 12
	damage = 30
	penetration= ARMOR_PENETRATION_TIER_10
	shrapnel_chance = SHRAPNEL_CHANCE_TIER_7
	shrapnel_type = /obj/item/shard/shrapnel

/datum/ammo/flamethrower
	name = "flame"
	icon_state = "pulse0"
	damage_type = BURN
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_HITS_TARGET_TURF

	max_range = 6
	damage = 35

/datum/ammo/flamethrower/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/flamethrower/on_hit_mob(mob/M, obj/item/projectile/P)
	drop_flame(get_turf(M), P.weapon_cause_data)

/datum/ammo/flamethrower/on_hit_obj(obj/O, obj/item/projectile/P)
	drop_flame(get_turf(O), P.weapon_cause_data)

/datum/ammo/flamethrower/on_hit_turf(turf/T, obj/item/projectile/P)
	drop_flame(T, P.weapon_cause_data)

/datum/ammo/flamethrower/do_at_max_range(obj/item/projectile/P)
	drop_flame(get_turf(P), P.weapon_cause_data)

/datum/ammo/flamethrower/tank_flamer
	flamer_reagent_type = /datum/reagent/napalm/blue

/datum/ammo/flamethrower/sentry_flamer
	flags_ammo_behavior = AMMO_IGNORE_ARMOR|AMMO_IGNORE_COVER
	flamer_reagent_type = /datum/reagent/napalm/blue

	accuracy = HIT_ACCURACY_TIER_8
	accurate_range = 6
	max_range = 12
	shell_speed = AMMO_SPEED_TIER_3

/datum/ammo/flamethrower/sentry_flamer/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/flamethrower/sentry_flamer/glob
	max_range = 14
	accurate_range = 10
	var/datum/effect_system/smoke_spread/phosphorus/smoke

/datum/ammo/flamethrower/sentry_flamer/glob/New()
	. = ..()
	smoke = new()

/datum/ammo/flamethrower/sentry_flamer/glob/drop_flame(turf/T, datum/cause_data/cause_data)
	if(!istype(T))
		return
	smoke.set_up(1, 0, T, new_cause_data = cause_data)
	smoke.start()

/datum/ammo/flamethrower/sentry_flamer/glob/Destroy()
	qdel(smoke)
	return ..()

/datum/ammo/flamethrower/sentry_flamer/mini
	name = "normal fire"

/datum/ammo/flamethrower/sentry_flamer/mini/drop_flame(turf/T, datum/cause_data/cause_data)
	if(!istype(T))
		return
	var/datum/reagent/napalm/R = new()
	R.durationfire = BURN_TIME_INSTANT
	new /obj/flamer_fire(T, cause_data, R, 0)

/datum/ammo/flare
	name = "flare"
	ping = null //no bounce off.
	damage_type = BURN
	flags_ammo_behavior = AMMO_HITS_TARGET_TURF
	icon_state = "flare"

	damage = 15
	accuracy = HIT_ACCURACY_TIER_3
	max_range = 14
	shell_speed = AMMO_SPEED_TIER_3

	var/flare_type = /obj/item/device/flashlight/flare/on/gun
	handful_type = /obj/item/device/flashlight/flare

/datum/ammo/flare/set_bullet_traits()
	. = ..()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_incendiary)
	))

/datum/ammo/flare/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_flare(get_turf(P), P, P.firer)

/datum/ammo/flare/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_flare(get_turf(P), P, P.firer)

/datum/ammo/flare/on_hit_turf(turf/T, obj/item/projectile/P)
	if(T.density && isturf(P.loc))
		drop_flare(P.loc, P, P.firer)
	else
		drop_flare(T, P, P.firer)

/datum/ammo/flare/do_at_max_range(obj/item/projectile/P, var/mob/firer)
	drop_flare(get_turf(P), P, P.firer)

/datum/ammo/flare/proc/drop_flare(var/turf/T, obj/item/projectile/fired_projectile, var/mob/firer)
	var/obj/item/device/flashlight/flare/G = new flare_type(T)
	G.visible_message(SPAN_WARNING("\A [G] bursts into brilliant light nearby!"))
	return G

/datum/ammo/flare/signal
	name = "signal flare"
	icon_state = "flare_signal"
	flare_type = /obj/item/device/flashlight/flare/signal/gun
	handful_type = /obj/item/device/flashlight/flare/signal

/datum/ammo/flare/signal/drop_flare(turf/T, obj/item/projectile/fired_projectile, mob/firer)
	var/obj/item/device/flashlight/flare/signal/gun/signal_flare = ..()
	signal_flare.activate_signal(firer)
	if(istype(fired_projectile.shot_from, /obj/item/weapon/gun/flare))
		var/obj/item/weapon/gun/flare/flare_gun_fired_from = fired_projectile.shot_from
		flare_gun_fired_from.last_signal_flare_name = signal_flare.name

/datum/ammo/flare/starshell
	name = "starshell ash"
	icon_state = "starshell_bullet"
	max_range = 5
	flare_type = /obj/item/device/flashlight/flare/on/starshell_ash

/datum/ammo/flare/starshell/set_bullet_traits()
	LAZYADD(traits_to_give, list(
		BULLET_TRAIT_ENTRY(/datum/element/bullet_trait_iff, /datum/element/bullet_trait_incendiary)
	))

/datum/ammo/souto
	name = "Souto Can"
	ping = null //no bounce off.
	damage_type = BRUTE
	shrapnel_type = /obj/item/reagent_container/food/drinks/cans/souto/classic
	flags_ammo_behavior = AMMO_SKIPS_ALIENS|AMMO_IGNORE_ARMOR|AMMO_IGNORE_RESIST|AMMO_BALLISTIC|AMMO_STOPPED_BY_COVER|AMMO_SPECIAL_EMBED
	var/obj/item/reagent_container/food/drinks/cans/souto/can_type
	icon = 'icons/obj/items/drinks.dmi'
	icon_state = "souto_classic"

	max_range = 12
	shrapnel_chance = 10
	accuracy = HIT_ACCURACY_TIER_8 + HIT_ACCURACY_TIER_8
	accurate_range = 12
	shell_speed = AMMO_SPEED_TIER_1

/datum/ammo/souto/on_embed(var/mob/embedded_mob, var/obj/limb/target_organ)
	if(ishuman(embedded_mob) && !isYautja(embedded_mob))
		if(istype(target_organ))
			target_organ.embed(new can_type)

/datum/ammo/souto/on_hit_mob(mob/M, obj/item/projectile/P)
	if(!M || M == P.firer) return
	if(M.throw_mode && !M.get_active_hand())	//empty active hand and we're in throw mode. If so we catch the can.
		if(!M.is_mob_incapacitated()) // People who are not able to catch cannot catch.
			if(P.contents.len == 1)
				for(var/obj/item/reagent_container/food/drinks/cans/souto/S in P.contents)
					M.put_in_active_hand(S)
					for(var/mob/O in viewers(world_view_size, P)) //find all people in view.
						O.show_message(SPAN_DANGER("[M] catches the [S]!"), 1) //Tell them the can was caught.
					return //Can was caught.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Human") //no effect on synths or preds.
			H.apply_effect(6, STUN)
			H.apply_effect(8, WEAKEN)
			H.apply_effect(15, DAZE)
			H.apply_effect(15, SLOW)
		shake_camera(H, 2, 1)
		if(P.contents.len)
			drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/on_hit_turf(turf/T, obj/item/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/do_at_max_range(obj/item/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/on_shield_block(mob/M, obj/item/projectile/P)
	drop_can(P.loc, P) //We make a can at the location.

/datum/ammo/souto/proc/drop_can(var/loc, obj/item/projectile/P)
	if(P.contents.len)
		for(var/obj/item/I in P.contents)
			I.forceMove(loc)
	randomize_projectile(P)

/datum/ammo/souto/proc/randomize_projectile(obj/item/projectile/P)
	shrapnel_type = pick(typesof(/obj/item/reagent_container/food/drinks/cans/souto)-/obj/item/reagent_container/food/drinks/cans/souto)

/datum/ammo/grenade_container
	name = "grenade shell"
	ping = null
	damage_type = BRUTE
	var/nade_type = /obj/item/explosive/grenade/HE
	icon_state = "grenade"
	flags_ammo_behavior = AMMO_IGNORE_COVER|AMMO_SKIPS_ALIENS

	damage = 15
	accuracy = HIT_ACCURACY_TIER_3
	max_range = 6

/datum/ammo/grenade_container/on_hit_mob(mob/M,obj/item/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/on_hit_obj(obj/O,obj/item/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/on_hit_turf(turf/T,obj/item/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/do_at_max_range(obj/item/projectile/P)
	drop_nade(P)

/datum/ammo/grenade_container/proc/drop_nade(var/obj/item/projectile/P)
	var/turf/T = get_turf(P)
	var/obj/item/explosive/grenade/G = new nade_type(T)
	G.visible_message(SPAN_WARNING("\A [G] lands on [T]!"))
	G.det_time = 10
	G.cause_data = P.weapon_cause_data
	G.activate()

/datum/ammo/grenade_container/rifle
	flags_ammo_behavior = NO_FLAGS

/datum/ammo/grenade_container/smoke
	name = "smoke grenade shell"
	nade_type = /obj/item/explosive/grenade/smokebomb
	icon_state = "smoke_shell"

/datum/ammo/hugger_container
	name = "hugger shell"
	ping = null
	damage_type = BRUTE
	var/hugger_hive = XENO_HIVE_NORMAL
	icon_state = "smoke_shell"

	damage = 15
	accuracy = HIT_ACCURACY_TIER_3
	max_range = 6

/datum/ammo/hugger_container/on_hit_mob(mob/M,obj/item/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/on_hit_obj(obj/O,obj/item/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/on_hit_turf(turf/T,obj/item/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/do_at_max_range(obj/item/projectile/P)
	spawn_hugger(get_turf(P))

/datum/ammo/hugger_container/proc/spawn_hugger(var/turf/T)
	var/obj/item/clothing/mask/facehugger/child = new(T)
	child.hivenumber = hugger_hive
	child.leap_at_nearest_target()
