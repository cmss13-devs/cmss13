
//Burrower Abilities
/mob/living/carbon/xenomorph/proc/burrow()
	if(!check_state())
		return

	if(used_burrow || tunnel || is_ventcrawling || action_busy)
		return

	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		return

	var/area/current_area = get_area(current_turf)
	if(current_area.flags_area & AREA_NOTUNNEL)
		to_chat(src, SPAN_XENOWARNING("There's no way to burrow here."))
		return

	if(istype(current_turf, /turf/open/floor/almayer/research/containment) || istype(current_turf, /turf/closed/wall/almayer/research/containment))
		to_chat(src, SPAN_XENOWARNING("We can't escape this cell!"))
		return

	if(clone) //Prevents burrowing on stairs
		to_chat(src, SPAN_XENOWARNING("We can't burrow here!"))
		return

	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]

	used_burrow = TRUE

	to_chat(src, SPAN_XENOWARNING("We begin burrowing ourselves into the ground."))
	if(!do_after(src, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
		return
	// TODO Make immune to all damage here.
	to_chat(src, SPAN_XENOWARNING("We burrow ourselves into the ground."))
	invisibility = 101
	anchored = TRUE
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		RegisterSignal(src, COMSIG_LIVING_PREIGNITION, PROC_REF(fire_immune))
		RegisterSignal(src, list(
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED,
		), PROC_REF(flamer_crossed_immune))
	add_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	playsound(src.loc, 'sound/effects/burrowing_b.ogg', 25)
	update_icons()
	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	burrow_timer = world.time + 90 // How long we can be burrowed
	process_burrow()

/mob/living/carbon/xenomorph/proc/process_burrow()
	if(!HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return
	if(world.time > burrow_timer && !tunnel)
		burrow_off()
	if(observed_xeno)
		overwatch(observed_xeno, TRUE)
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		addtimer(CALLBACK(src, PROC_REF(process_burrow)), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/burrow_off()
	if(caste_type && GLOB.xeno_datum_list[caste_type])
		caste = GLOB.xeno_datum_list[caste_type]
	to_chat(src, SPAN_NOTICE("You resurface."))
	if(caste.fire_immunity == FIRE_IMMUNITY_NONE)
		UnregisterSignal(src, list(
				COMSIG_LIVING_PREIGNITION,
				COMSIG_LIVING_FLAMER_CROSSED,
				COMSIG_LIVING_FLAMER_FLAMED,
		))
	remove_traits(list(TRAIT_ABILITY_BURROWED, TRAIT_UNDENSE, TRAIT_IMMOBILIZED), TRAIT_SOURCE_ABILITY("Burrow"))
	invisibility = FALSE
	anchored = FALSE
	playsound(loc, 'sound/effects/burrowoff.ogg', 25)
	for(var/mob/living/carbon/mob in loc)
		if(!can_not_harm(mob))
			mob.apply_effect(2, WEAKEN)

	addtimer(CALLBACK(src, PROC_REF(do_burrow_cooldown)), (caste ? caste.burrow_cooldown : 5 SECONDS))
	update_icons()

/mob/living/carbon/xenomorph/proc/do_burrow_cooldown()
	used_burrow = FALSE
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_NOTICE("We can now surface."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()


/mob/living/carbon/xenomorph/proc/tunnel(turf/T)
	if(!check_state())
		return

	if(!HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		to_chat(src, SPAN_NOTICE("We must be burrowed to do this."))
		return

	if(tunnel)
		tunnel = FALSE
		to_chat(src, SPAN_NOTICE("We stop tunneling."))
		used_tunnel = TRUE
		addtimer(CALLBACK(src, PROC_REF(do_tunnel_cooldown)), (caste ? caste.tunnel_cooldown : 5 SECONDS))
		return

	if(used_tunnel)
		to_chat(src, SPAN_NOTICE("We must wait some time to do this."))
		return

	if(!T)
		to_chat(src, SPAN_NOTICE("We can't tunnel there!"))
		return

	if(T.density)
		to_chat(src, SPAN_XENOWARNING("We can't tunnel into a solid wall!"))
		return

	if(istype(T, /turf/open/space))
		to_chat(src, SPAN_XENOWARNING("We make tunnels, not wormholes!"))
		return

	if(clone) //Prevents tunnels in Z transition areas
		to_chat(src, SPAN_XENOWARNING("We make tunnels, not wormholes!"))
		return

	var/area/A = get_area(T)
	if(A.flags_area & AREA_NOTUNNEL || get_dist(src, T) > 15)
		to_chat(src, SPAN_XENOWARNING("There's no way to tunnel over there."))
		return

	for(var/obj/O in T.contents)
		if(O.density)
			if(O.flags_atom & ON_BORDER)
				continue
			to_chat(src, SPAN_WARNING("There's something solid there to stop us from emerging."))
			return

	if(!T || T.density)
		to_chat(src, SPAN_NOTICE("We cannot tunnel to there!"))
	tunnel = TRUE
	to_chat(src, SPAN_NOTICE("We start tunneling!"))
	tunnel_timer = (get_dist(src, T)*10) + world.time
	process_tunnel(T)


/mob/living/carbon/xenomorph/proc/process_tunnel(turf/T)
	if(!tunnel)
		return

	if(world.time > tunnel_timer)
		tunnel = FALSE
		do_tunnel(T)
	if(tunnel && T)
		addtimer(CALLBACK(src, PROC_REF(process_tunnel), T), 1 SECONDS)

/mob/living/carbon/xenomorph/proc/do_tunnel(turf/T)
	to_chat(src, SPAN_NOTICE("We tunnel to the destination."))
	anchored = FALSE
	forceMove(T)
	burrow_off()

/mob/living/carbon/xenomorph/proc/do_tunnel_cooldown()
	used_tunnel = FALSE
	to_chat(src, SPAN_NOTICE("We can now tunnel while burrowed."))
	for(var/X in actions)
		var/datum/action/act = X
		act.update_button_icon()

/mob/living/carbon/xenomorph/proc/rename_tunnel(obj/structure/tunnel/T in oview(1))
	set name = "Rename Tunnel"
	set desc = "Rename the tunnel."
	set category = null

	if(!istype(T))
		return

	var/new_name = strip_html(input("Change the description of the tunnel:", "Tunnel Description") as text|null)
	new_name = replace_non_alphanumeric_plus(new_name)
	if(new_name)
		new_name = "[new_name] ([get_area_name(T)])"
		log_admin("[key_name(src)] has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		msg_admin_niche("[src]/([key_name(src)]) has renamed the tunnel \"[T.tunnel_desc]\" as \"[new_name]\".")
		T.tunnel_desc = "[new_name]"
	return

/datum/action/xeno_action/onclick/tremor/action_cooldown_check()
	var/mob/living/carbon/xenomorph/xeno = owner
	return !xeno.used_tremor

/mob/living/carbon/xenomorph/proc/tremor() //More support focused version of crusher earthquakes.
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED) || is_ventcrawling)
		to_chat(src, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(!check_state())
		return

	if(used_tremor)
		to_chat(src, SPAN_XENOWARNING("We aren't ready to cause more tremors yet!"))
		return

	if(!check_plasma(100)) return

	use_plasma(100)
	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message(SPAN_XENODANGER("[src] digs itself into the ground and shakes the earth itself, causing violent tremors!"), \
	SPAN_XENODANGER("We dig into the ground and shake it around, causing violent tremors!"))
	create_stomp() //Adds the visual effect. Wom wom wom
	used_tremor = 1

	for(var/mob/living/carbon/carbon_target in range(7, loc))
		to_chat(carbon_target, SPAN_WARNING("You struggle to remain on your feet as the ground shakes beneath your feet!"))
		shake_camera(carbon_target, 2, 3)
		if(get_dist(loc, carbon_target) <= 3 && !src.can_not_harm(carbon_target))
			if(carbon_target.mob_size >= MOB_SIZE_BIG)
				carbon_target.apply_effect(1, SLOW)
			else
				carbon_target.apply_effect(1, WEAKEN)
			to_chat(carbon_target, SPAN_WARNING("The violent tremors make you lose your footing!"))

	spawn(caste.tremor_cooldown)
		used_tremor = 0
		to_chat(src, SPAN_NOTICE("We gather enough strength to cause tremors again."))
		for(var/X in actions)
			var/datum/action/act = X
			act.update_button_icon()

// Sapper Powers
/datum/action/xeno_action/onclick/demolish/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/sapper = owner

	if(!action_cooldown_check())
		return

	if(!sapper.check_state())
		return

	var/datum/behavior_delegate/burrower_sapper/behavior_del = sapper.behavior_delegate
	if(!istype(behavior_del))
		return
	if(behavior_del.tension < behavior_del.demolish_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("We're not angry enough!"))
		return

	if(!check_and_use_plasma_owner())
		return

	behavior_del.modify_tension(-behavior_del.demolish_cost)

	sapper.visible_message(SPAN_XENOWARNING("[sapper] bulks up and enters a destructive frenzy!"), SPAN_XENOHIGHDANGER("We bulk our muscles and enter a destructive frenzy!"))
	sapper.add_filter("sapper_demolish", 1, list("type" = "outline", "color" = "#ff6600", "size" = 1))
	sapper.emote("roar")
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, PROC_REF(no_demolish)), 15 SECONDS)

	sapper.claw_type = CLAW_TYPE_VERY_SHARP
	sapper.attack_speed_modifier -= 3

	return ..()

/datum/action/xeno_action/onclick/demolish/proc/no_demolish()
	var/mob/living/carbon/xenomorph/sapper = owner

	to_chat(sapper, SPAN_XENONOTICE("We calm down as our muscles shrink back to normal."))
	sapper.remove_filter("sapper_demolish")
	button.icon_state = "template"

	sapper.claw_type = CLAW_TYPE_SHARP
	sapper.attack_speed_modifier += 3

	apply_cooldown()

/datum/action/xeno_action/activable/sapper_punch/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!action_cooldown_check())
		return

	if(!isxeno_human(affected_atom) || xeno.can_not_harm(affected_atom))
		return

	if(!xeno.check_state())
		return

	var/distance = get_dist(xeno, affected_atom)

	if(distance > 2)
		return

	var/mob/living/carbon/carbon = affected_atom

	if(!xeno.Adjacent(carbon))
		return

	if(carbon.stat == DEAD)
		return
	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	var/obj/limb/target_limb = carbon.get_limb(check_zone(xeno.zone_selected))

	if(ishuman(carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = carbon.get_limb("chest")

	if(!check_and_use_plasma_owner())
		return

	carbon.last_damage_data = create_cause_data(initial(xeno.caste_type), xeno)

	xeno.visible_message(SPAN_XENOWARNING("[xeno] hits [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a powerful punch!"), \
	SPAN_XENOWARNING("We hit [carbon] in the [target_limb ? target_limb.display_name : "chest"] with a powerful punch!"))
	var/sound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon, sound, 50, 1)
	do_sapper_punch(carbon, target_limb)
	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/sapper_punch/proc/do_sapper_punch(mob/living/carbon/carbon, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/behavior_delegate/burrower_sapper/behavior_del = xeno.behavior_delegate
	var/damage = rand(base_damage, base_damage + behavior_del.tension / 2 * 0.1 * 0.4)

	if(ishuman(carbon))
		if(carbon.buckled && istype(carbon.buckled, /obj/structure/bed/nest))
			return
		if(carbon.stat == DEAD)
			return
		if((target_limb.status & LIMB_SPLINTED) && !(target_limb.status & LIMB_SPLINTED_INDESTRUCTIBLE))
			target_limb.status &= ~LIMB_SPLINTED
			playsound(get_turf(carbon), 'sound/items/splintbreaks.ogg', 20)
			to_chat(carbon, SPAN_DANGER("The splint on your [target_limb.display_name] comes apart!"))
			carbon.pain.apply_pain(PAIN_BONE_BREAK_SPLINTED)

	carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE, target_limb ? target_limb.name : "chest")

	xeno.face_atom(carbon)
	xeno.animation_attack_on(carbon)
	xeno.flick_attack_overlay(carbon, "punch")
	shake_camera(carbon, 2, 1)

/datum/action/xeno_action/onclick/earthquake/use_ability()
	var/mob/living/carbon/xenomorph/sapper = owner

	if(!action_cooldown_check())
		return

	if(!sapper.check_state())
		return

	var/datum/behavior_delegate/burrower_sapper/behavior_del = sapper.behavior_delegate
	if(!istype(behavior_del))
		return
	if(behavior_del.tension < behavior_del.earthquake_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("We're not angry enough!"))
		return

	sapper.visible_message(SPAN_XENOWARNING("[sapper] rears up on it's hind legs!"), SPAN_XENOHIGHDANGER("We rear up on our hind legs, ready to leap!"))
	if(!do_after(sapper, 1 SECONDS, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		return

	if(!check_and_use_plasma_owner())
		return

	behavior_del.modify_tension(-behavior_del.earthquake_cost)

	sapper.quake()
	apply_cooldown()
	return ..()

/mob/living/carbon/xenomorph/proc/quake()

	playsound(loc, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
	visible_message(SPAN_XENODANGER("[src] leaps forward into the air and slams the ground, causing an incredibly violent quake!"), \
	SPAN_XENODANGER("We leap forward into the air and slam the ground with all our might, causing an incredibly violent quake!"))
	create_stomp()

	for(var/mob/living/carbon/carbon_target in range(6, loc))
		to_chat(carbon_target, SPAN_WARNING("You struggle to remain on your feet as the ground shakes violently beneath your feet!"))
		shake_camera(carbon_target, 2, 3)
		carbon_target.apply_effect(1, SLOW)
		if(get_dist(loc, carbon_target) <= 4 && !src.can_not_harm(carbon_target))
			if(carbon_target.mob_size >= MOB_SIZE_BIG)
				carbon_target.apply_effect(1, SLOW)
				to_chat(carbon_target, SPAN_WARNING("The violent quake causes the ground beneath you to shift, making it hard to remain upright!"))
			else
				step_away(carbon_target, src, rand(1, 3))
				carbon_target.apply_effect(1, WEAKEN)
				to_chat(carbon_target, SPAN_WARNING("The violent quake knocks you over and the shifting ground throws you about!"))

/datum/action/xeno_action/activable/boulder_toss/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/sapper = owner
	var/rock_target = aim_turf ? get_turf(atom) : atom
	if(!istype(sapper))
		return

	if(!sapper.check_state())
		return

	if(!action_cooldown_check())
		return

	var/datum/behavior_delegate/burrower_sapper/behavior_del = sapper.behavior_delegate
	if(behavior_del.tension < behavior_del.boulder_cost)
		to_chat(src, SPAN_XENOHIGHDANGER("We're not angry enough!"))
		return

	var/turf/current_turf = get_turf(sapper)
	if(!current_turf)
		return

	sapper.face_atom(rock_target)
	sapper.visible_message(SPAN_XENOWARNING("[sapper] starts vomiting resin and tearing the ground up!"), SPAN_XENOHIGHDANGER("We vomit special resin and tear up the ground to create a boulder!"))
	if(!do_after(sapper, 5 SECONDS, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		return

	if (!check_and_use_plasma_owner())
		return

	behavior_del.modify_tension(-behavior_del.boulder_cost)

	sapper.visible_message(SPAN_XENOWARNING("[sapper] heaves a newly made boulder above it and hurls it at [atom]!"), SPAN_XENOWARNING("We heave our finished boulder above us and hurl it at [atom]!"))
	sapper.emote("roar")

	var/datum/ammo/ammo_datum = GLOB.ammo_list[ammo_type]
	var/obj/projectile/proj = new (current_turf, create_cause_data(initial(sapper.caste_type), sapper))
	proj.generate_bullet(ammo_datum)
	proj.permutated += sapper
	proj.def_zone = sapper.get_limbzone_target()
	proj.fire_at(rock_target, sapper, sapper, ammo_datum.max_range, ammo_datum.shell_speed)

	apply_cooldown()
	return ..()
