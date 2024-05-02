/datum/xeno_strain/sniper
	name = SPITTER_SNIPER
	description = "You streamline the internal track to specialize long range attacks. You lose all abilities and gain 3 varient long range attacks."
	flavor_description = "You become an specialized long range defender of the hive."

	actions_to_remove = list(
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/activable/tail_stab/spitter,
		/datum/action/xeno_action/activable/spray_acid/spitter,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit,
	)
	actions_to_add = list(
		/datum/action/xeno_action/onclick/charge_power_spit, // First macro
		/datum/action/xeno_action/onclick/toggle_long_range/sniper, // Second macro
		/datum/action/xeno_action/activable/sniper/long_spit, // third macro
		/datum/action/xeno_action/activable/sniper/buster_spit, // fourth macro
		/datum/action/xeno_action/activable/sniper/pain_packer, // fifth macro
	)

	behavior_delegate_type = /datum/behavior_delegate

	var/power_spit_active = FALSE

/datum/xeno_strain/sniper/apply_strain(mob/living/carbon/xenomorph/spitter/spitter)
	. = ..()
	spitter.plasmapool_modifier = 1.4 // +40% plasma pool
	spitter.health_modifier -= XENO_HEALTH_MOD_VERY_LARGE
	spitter.armor_modifier -= XENO_ARMOR_MOD_VERY_SMALL
	spitter.attack_speed_modifier += 2

	spitter.recalculate_everything()

/datum/action/xeno_action/onclick/charge_power_spit
	name = "Charge Power Spit"
	action_icon_state = "charge_spit"
	ability_name = "charge power spit"
	macro_path = /datum/action/xeno_action/verb/verb_charge_spit
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 90
	xeno_cooldown = 35 SECONDS

	// Config
	var/duration = 35
	var/speed_debuff_amount = XENO_SPEED_SLOWMOD_TIER_6
	var/armor_debuff_amount = -XENO_ARMOR_MOD_MED

/datum/action/xeno_action/onclick/charge_power_spit/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!istype(xeno) || !xeno.check_state())
		return

	var/datum/xeno_strain/sniper/strain = xeno.strain
	if (strain.power_spit_active)
		to_chat(xeno, SPAN_XENOHIGHDANGER("We cannot stack this!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(xeno, SPAN_XENOHIGHDANGER("We filter quality acid in your glands. Our next spit will be stronger but exoskin opens to disappate heat and waste."))
	xeno.create_custom_empower(icolor = "#93ec78", ialpha = 200, small_xeno = TRUE)
	xeno.balloon_alert(xeno, "our next spit will be stronger", text_color = "#93ec78")
	strain.power_spit_active = TRUE
	xeno.speed_modifier += speed_debuff_amount
	xeno.armor_modifier += armor_debuff_amount
	xeno.recalculate_speed()
	xeno.recalculate_armor()

	RegisterSignal(xeno, COMSIG_XENO_POST_SPIT, PROC_REF(disable_power_spit))
	addtimer(CALLBACK(src, PROC_REF(disable_power_spit)), duration)
	apply_cooldown()
	return ..()


/datum/action/xeno_action/onclick/charge_power_spit/proc/disable_power_spit()
	SIGNAL_HANDLER
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/xeno_strain/sniper/strain = xeno.strain
	if(strain.power_spit_active)
		remove_effects()
		to_chat(xeno, SPAN_XENOWARNING("Our spitting glands clear out and return back to normal."))

/datum/action/xeno_action/onclick/charge_power_spit/proc/remove_effects()
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	var/datum/xeno_strain/sniper/strain = xeno.strain
	strain.power_spit_active = FALSE

	xeno.speed_modifier -= speed_debuff_amount
	xeno.armor_modifier -= armor_debuff_amount
	xeno.recalculate_speed()
	xeno.recalculate_armor()
	xeno.balloon_alert(xeno, "our spits are back to normal", text_color = "#93ec78")
	to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our exoskin close again, and our legs regain strength!"))

	UnregisterSignal(xeno, COMSIG_XENO_POST_SPIT)

/datum/action/xeno_action/activable/sniper/long_spit
	name = "Long Spit"
	action_icon_state = "long_spit"
	ability_name = "Long spit"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 3.5 SECONDS
	plasma_cost = 30

/datum/action/xeno_action/activable/sniper/long_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/xeno_strain/sniper/strain = xeno.strain
	if(strain.power_spit_active)
		spit(target, /datum/ammo/xeno/acid/sniper/charged)
	else
		spit(target, /datum/ammo/xeno/acid/sniper)
	return ..()

/datum/action/xeno_action/activable/sniper/buster_spit
	name = "Buster Spit"
	action_icon_state = "buster_spit"
	ability_name = "Buster spit"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 5.5 SECONDS
	plasma_cost = 45

/datum/action/xeno_action/activable/sniper/buster_spit/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/xeno_strain/sniper/strain = xeno.strain
	if(strain.power_spit_active)
		spit(target, /datum/ammo/xeno/acid/buster/charged)
	else
		spit(target, /datum/ammo/xeno/acid/buster)
	return ..()

/datum/action/xeno_action/activable/sniper/pain_packer
	name = "Pain Packer Spit"
	action_icon_state = "pain_packer_spit"
	ability_name = "Pain Packer spit"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5
	xeno_cooldown = 6.5 SECONDS
	plasma_cost = 35

/datum/action/xeno_action/activable/sniper/pain_packer/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/xeno_strain/sniper/strain = xeno.strain
	if(strain.power_spit_active)
		spit(target, /datum/ammo/xeno/acid/pain_packer/charged)
	else
		spit(target, /datum/ammo/xeno/acid/pain_packer)
	return ..()

/datum/action/xeno_action/activable/sniper/proc/spit(atom/target, ammo_type)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno.check_state())
		return

	if(!action_cooldown_check())
		to_chat(src, SPAN_WARNING("We must wait for your spit glands to refill."))
		return

	var/turf/current_turf = get_turf(xeno)

	if(!current_turf)
		return

	if (!check_and_use_plasma_owner())
		return

	xeno.visible_message(SPAN_XENOWARNING("[xeno] spits at [target]!"), \
	SPAN_XENOWARNING("You spit at [target]!") )
	var/sound_to_play = pick(1, 2) == 1 ? 'sound/voice/alien_spitacid.ogg' : 'sound/voice/alien_spitacid2.ogg'
	playsound(xeno.loc, sound_to_play, 25, 1)

	xeno.ammo = GLOB.ammo_list[ammo_type]
	var/datum/xeno_strain/sniper/strain = xeno.strain
	if(strain.power_spit_active)
		xeno.ammo = GLOB.ammo_list[ammo_type]
	var/obj/projectile/projectile = new /obj/projectile(current_turf, create_cause_data(initial(xeno.caste_type), xeno))
	projectile.generate_bullet(xeno.ammo)
	projectile.permutated += xeno
	projectile.def_zone = xeno.get_limbzone_target()
	projectile.fire_at(target, xeno, xeno, xeno.ammo.max_range, xeno.ammo.shell_speed)

	SEND_SIGNAL(xeno, COMSIG_XENO_POST_SPIT)
	apply_cooldown()

/datum/action/xeno_action/onclick/toggle_long_range/sniper
	name = "Toggle Scopped Sight"
	action_icon_state = "toggle_long_range"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_2
	should_delay = FALSE
	delay = 15
	/// if we can move while zoomed, how slowed will we be when zoomed in? Use speed modifier defines.
	movement_slowdown = XENO_SPEED_SLOWMOD_TIER_2

/datum/action/xeno_action/onclick/toggle_long_range/sniper/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!xeno.check_state())
		return

	if(xeno.observed_xeno)
		return

	if(xeno.is_zoomed)
		xeno.client.change_view(GLOB.world_view_size, src)
		xeno.zoom_out() // will call on_zoom_out()
		return
	xeno.visible_message(SPAN_NOTICE("[xeno] starts looking off into the distance."), \
		SPAN_NOTICE("We start focusing our sight to look off into the distance."), null, 5)
	if(!do_after(xeno, delay, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		return
	if(movement_slowdown)
		xeno.speed_modifier += movement_slowdown
		xeno.recalculate_speed()

	var/tileoffset = 11
	var/viewsize = 12
	if(xeno.client)
		xeno.client.change_view(viewsize, src)

		//var/zoom_initial_mob_dir = xeno.dir

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(xeno.dir)
			if(NORTH)
				xeno.client.pixel_x = 0
				xeno.client.pixel_y = viewoffset
			if(SOUTH)
				xeno.client.pixel_x = 0
				xeno.client.pixel_y = -viewoffset
			if(EAST)
				xeno.client.pixel_x = viewoffset
				xeno.client.pixel_y = 0
			if(WEST)
				xeno.client.pixel_x = -viewoffset
				xeno.client.pixel_y = 0
	xeno.is_zoomed = TRUE
