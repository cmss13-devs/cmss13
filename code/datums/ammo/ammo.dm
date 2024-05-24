/datum/ammo
	var/name = "generic bullet"
	//Icon state when a human is permanently killed with it by execution/suicide.
	var/headshot_state = null
	var/icon = 'icons/obj/items/weapons/projectiles.dmi'
	var/icon_state = "bullet"
	/// The icon that is displayed when the bullet bounces off something.
	var/ping = "ping_b"
	/// When it deals damage.
	var/sound_hit
	/// When it's blocked by human armor.
	var/sound_armor
	/// When it misses someone.
	var/sound_miss
	/// When it bounces off something.
	var/sound_bounce
	/// When the bullet is absorbed by a xeno_shield
	var/sound_shield_hit
	/// Snipers use this to simulate poor accuracy at close ranges
	var/accurate_range_min = 0
	/// How much the ammo scatters when burst fired, added to gun scatter, along with other mods
	var/scatter = 0
	var/stamina_damage = 0
	/// This is the base damage of the bullet as it is fired
	var/damage = 0
	/// BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/damage_type = BRUTE
	/// How much armor it ignores before calculations take place
	var/penetration = 0
	/// The % chance it will imbed in a human
	var/shrapnel_chance = 0
	/// The shrapnel type the ammo will embed, if the chance rolls
	var/shrapnel_type = 0
	/// Type path of the extra projectiles
	var/bonus_projectiles_type
	/// How many extra projectiles it shoots out. Works kind of like firing on burst, but all of the projectiles travel together
	var/bonus_projectiles_amount = 0
	/// Stun,knockdown,knockout,irradiate,stutter,eyeblur,drowsy,agony
	var/debilitate[] = null
	/// how much armor breaking will be done per point of penetration. This is for weapons that penetrate with their shape (like needle bullets)
	var/pen_armor_punch = 0.5
	/// how much armor breaking is done by sheer weapon force. This is for big blunt weapons
	var/damage_armor_punch = 0.5
	/// if we should play a special sound when firing.
	var/sound_override = null
	var/flags_ammo_behavior = NO_FLAGS

	/// This is added to the bullet's base accuracy.
	var/accuracy = HIT_ACCURACY_TIER_1
	/// How much the accuracy varies when fired. // This REDUCES the lower bound of accuracy variance by 2%, to 96%.
	var/accuracy_var_low = PROJECTILE_VARIANCE_TIER_9
	/// This INCREASES the upper bound of accuracy variance by 2%, to 107%.
	var/accuracy_var_high = PROJECTILE_VARIANCE_TIER_9
	/// For most guns, this is where the bullet dramatically looses accuracy. Not for snipers though.
	var/accurate_range = 6
	/// This will de-increment a counter on the bullet.
	var/max_range = 22
	/// Same as with accuracy variance.
	var/damage_var_low = PROJECTILE_VARIANCE_TIER_9
	/// This INCREASES the upper bound of damage variance by 2%, to 107%.
	var/damage_var_high = PROJECTILE_VARIANCE_TIER_9
	/// How much damage the bullet loses per turf traveled after the effective range
	var/damage_falloff = DAMAGE_FALLOFF_TIER_10
	/// How much damage the bullet loses per turf away before the effective range
	var/damage_buildup = DAMAGE_BUILDUP_TIER_1
	/// What minimum range the ammo deals full damage, builds up the closer you get. 0 for no minimum. Added onto gun range as a modifier.
	var/effective_range_min = EFFECTIVE_RANGE_OFF
	/// What maximum range the ammo deals full damage, tapers off using damage_falloff after hitting this value. 0 for no maximum. Added onto gun range as a modifier.
	var/effective_range_max = EFFECTIVE_RANGE_OFF
	/// How fast the projectile moves.
	var/shell_speed = AMMO_SPEED_TIER_1

	var/handful_type = /obj/item/ammo_magazine/handful
	var/handful_color
	/// custom handful sprite, for shotgun shells or etc.
	var/handful_state = "bullet"
	/// so handfuls say 'buckshot shells' not 'shell'
	var/multiple_handful_name

	/// Does this apply xenomorph behaviour delegate?
	var/apply_delegate = TRUE

	/// An assoc list in the format list(/datum/element/bullet_trait_to_give = list(...args))
	/// that will be given to a projectile with the current ammo datum
	var/list/list/traits_to_give

	var/flamer_reagent_id = "utnapthal"

	/// The flicker that plays when a bullet hits a target. Usually red. Can be nulled so it doesn't show up at all.
	var/hit_effect_color = "#FF0000"

/datum/ammo/New()
	set_bullet_traits()

/datum/ammo/proc/on_bullet_generation(obj/projectile/generated_projectile, mob/bullet_generator) //NOT used on New(), applied to the projectiles.
	return

/// Populate traits_to_give in this proc
/datum/ammo/proc/set_bullet_traits()
	return

/datum/ammo/can_vv_modify()
	return FALSE

/datum/ammo/proc/do_at_half_range(obj/projectile/P)
	SHOULD_NOT_SLEEP(TRUE)
	return

/datum/ammo/proc/on_embed(mob/embedded_mob, obj/limb/target_organ, silent = FALSE)
	return

/datum/ammo/proc/do_at_max_range(obj/projectile/P)
	SHOULD_NOT_SLEEP(TRUE)
	return

/datum/ammo/proc/on_shield_block(mob/M, obj/projectile/P) //Does it do something special when shield blocked? Ie. a flare or grenade that still blows up.
	return

/datum/ammo/proc/on_hit_turf(turf/T, obj/projectile/P) //Special effects when hitting dense turfs.
	SHOULD_NOT_SLEEP(TRUE)
	return

/datum/ammo/proc/on_hit_mob(mob/M, obj/projectile/P, mob/user) //Special effects when hitting mobs.
	SHOULD_NOT_SLEEP(TRUE)
	return

///Special effects when pointblanking mobs. Ultimately called from /living/attackby(). Return TRUE to end the PB attempt.
/datum/ammo/proc/on_pointblank(mob/living/L, obj/projectile/P, mob/living/user, obj/item/weapon/gun/fired_from)
	return

/datum/ammo/proc/on_hit_obj(obj/O, obj/projectile/P) //Special effects when hitting objects.
	SHOULD_NOT_SLEEP(TRUE)
	return

/datum/ammo/proc/on_near_target(turf/T, obj/projectile/P) //Special effects when passing near something. Range of things that triggers it is controlled by other ammo flags.
	return 0 //return 0 means it flies even after being near something. Return 1 means it stops

/datum/ammo/proc/knockback(mob/living/living_mob, obj/projectile/fired_projectile, max_range = 2)
	if(!living_mob || living_mob == fired_projectile.firer)
		return
	if(fired_projectile.distance_travelled > max_range || living_mob.body_position == LYING_DOWN)
		return //Two tiles away or more, basically.

	if(living_mob.mob_size >= MOB_SIZE_BIG)
		return //Big xenos are not affected.

	shake_camera(living_mob, 3, 4)
	knockback_effects(living_mob, fired_projectile)
	slam_back(living_mob, fired_projectile)

/datum/ammo/proc/slam_back(mob/living/living_mob, obj/projectile/fired_projectile)
	/// Either knockback or slam them into an obstacle.
	var/direction = Get_Compass_Dir(fired_projectile.z ? fired_projectile : fired_projectile.firer, living_mob) //More precise than get_dir.
	if(!direction) //Same tile.
		return
	if(!step(living_mob, direction))
		living_mob.animation_attack_on(get_step(living_mob, direction))
		playsound(living_mob.loc, "punch", 25, 1)
		living_mob.visible_message(SPAN_DANGER("[living_mob] slams into an obstacle!"),
			isxeno(living_mob) ? SPAN_XENODANGER("You slam into an obstacle!") : SPAN_HIGHDANGER("You slam into an obstacle!"), null, 4, CHAT_TYPE_TAKING_HIT)
		living_mob.apply_damage(MELEE_FORCE_TIER_2)

///The applied effects for knockback(), overwrite to change slow/stun amounts for different ammo datums
/datum/ammo/proc/knockback_effects(mob/living/living_mob, obj/projectile/fired_projectile)
	if(iscarbonsizexeno(living_mob))
		var/mob/living/carbon/xenomorph/target = living_mob
		target.Stun(0.7) // Previous comment said they believed 0.7 was 0.9s and that the balance team approved this. Geez...
		target.KnockDown(0.7)
		target.apply_effect(1, SUPERSLOW)
		target.apply_effect(2, SLOW)
		to_chat(target, SPAN_XENODANGER("You are shaken by the sudden impact!"))
	else
		living_mob.apply_stamina_damage(fired_projectile.ammo.damage, fired_projectile.def_zone, ARMOR_BULLET)

/datum/ammo/proc/slowdown(mob/living/living_mob, obj/projectile/fired_projectile)
	if(iscarbonsizexeno(living_mob))
		var/mob/living/carbon/xenomorph/target = living_mob
		target.apply_effect(1, SUPERSLOW)
		target.apply_effect(2, SLOW)
		to_chat(target, SPAN_XENODANGER("You are slowed by the sudden impact!"))
	else
		living_mob.apply_stamina_damage(fired_projectile.ammo.damage, fired_projectile.def_zone, ARMOR_BULLET)

/datum/ammo/proc/pushback(mob/living/target_mob, obj/projectile/fired_projectile, max_range = 2)
	if(!target_mob || target_mob == fired_projectile.firer || fired_projectile.distance_travelled > max_range || target_mob.body_position == LYING_DOWN)
		return

	if(target_mob.mob_size >= MOB_SIZE_BIG)
		return //too big to push

	to_chat(target_mob, isxeno(target_mob) ? SPAN_XENODANGER("You are pushed back by the sudden impact!") : SPAN_HIGHDANGER("You are pushed back by the sudden impact!"))
	slam_back(target_mob, fired_projectile, max_range)

/datum/ammo/proc/burst(atom/target, obj/projectile/P, damage_type = BRUTE, range = 1, damage_div = 2, show_message = SHOW_MESSAGE_VISIBLE) //damage_div says how much we divide damage
	if(!target || !P) return
	for(var/mob/living/carbon/M in orange(range,target))
		if(P.firer == M)
			continue
		if(show_message)
			var/msg = "You are hit by backlash from \a </b>[P.name]</b>!"
			M.visible_message(SPAN_DANGER("[M] is hit by backlash from \a [P.name]!"),isxeno(M) ? SPAN_XENODANGER("[msg]"):SPAN_HIGHDANGER("[msg]"))
		var/damage = P.damage/damage_div

		var/mob/living/carbon/xenomorph/XNO = null

		if(isxeno(M))
			XNO = M
			var/total_explosive_resistance = XNO.caste.xeno_explosion_resistance + XNO.armor_explosive_buff
			damage = armor_damage_reduction(GLOB.xeno_explosive, damage, total_explosive_resistance , 60, 0, 0.5, XNO.armor_integrity)
			var/armor_punch = armor_break_calculation(GLOB.xeno_explosive, damage, total_explosive_resistance, 60, 0, 0.5, XNO.armor_integrity)
			XNO.apply_armorbreak(armor_punch)

		M.apply_damage(damage,damage_type)

		if(XNO && XNO.xeno_shields.len)
			P.play_shielded_hit_effect(M)
		else
			P.play_hit_effect(M)

/datum/ammo/proc/fire_bonus_projectiles(obj/projectile/original_P)
	set waitfor = 0

	var/turf/curloc = get_turf(original_P.shot_from)
	var/initial_angle = Get_Angle(curloc, original_P.target_turf)

	for(var/i in 1 to bonus_projectiles_amount) //Want to run this for the number of bonus projectiles.
		var/final_angle = initial_angle

		var/obj/projectile/P = new /obj/projectile(curloc, original_P.weapon_cause_data)
		P.generate_bullet(GLOB.ammo_list[bonus_projectiles_type]) //No bonus damage or anything.
		P.accuracy = floor(P.accuracy * original_P.accuracy/initial(original_P.accuracy)) //if the gun changes the accuracy of the main projectile, it also affects the bonus ones.
		original_P.give_bullet_traits(P)
		P.bonus_projectile_check = 2 //It's a bonus projectile!

		var/total_scatter_angle = P.scatter
		final_angle += rand(-total_scatter_angle, total_scatter_angle)
		var/turf/new_target = get_angle_target_turf(curloc, final_angle, 30)

		P.fire_at(new_target, original_P.firer, original_P.shot_from, P.ammo.max_range, P.ammo.shell_speed, original_P.original) //Fire!

/datum/ammo/proc/drop_flame(turf/turf, datum/cause_data/cause_data) // ~Art updated fire 20JAN17
	if(!istype(turf))
		return
	if(locate(/obj/flamer_fire) in turf)
		return

	var/datum/reagent/chemical = GLOB.chemical_reagents_list[flamer_reagent_id]

	new /obj/flamer_fire(turf, cause_data, chemical)
