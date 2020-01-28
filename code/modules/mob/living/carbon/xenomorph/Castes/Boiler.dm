/datum/caste_datum/boiler
	caste_name = "Boiler"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_LOWPLUS
	max_health = XENO_HEALTH_HIGH
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_HIGHMEDIUM
	xeno_explosion_resistance = XENO_MEDIUM_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_SLOW
	speed_mod = XENO_SPEED_MOD_SMALL

	evolution_allowed = FALSE
	deevolves_to = "Spitter"
	spit_delay = 40
	caste_desc = "Gross!"
	bomb_strength = 1
	acid_level = 3
	caste_luminosity = 3

/datum/caste_datum/boiler/mature
	upgrade_name = "Mature"
	upgrade = 1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	spit_delay = 35
	caste_desc = "Some sort of abomination. It looks a little more dangerous."
	bomb_strength = 1.5

/datum/caste_datum/boiler/elder
	upgrade_name = "Elder"
	caste_desc = "Some sort of abomination. It looks pretty strong."
	upgrade = 2
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	spit_delay = 35
	bomb_strength = 2

/datum/caste_datum/boiler/ancient
	upgrade_name = "Ancient"
	caste_desc = "A devestating piece of alien artillery."
	upgrade = 3
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	spit_delay = 35
	bomb_strength = 2

/mob/living/carbon/Xenomorph/Boiler
	caste_name = "Boiler"
	name = "Boiler"
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
	icon_size = 64
	icon_state = "Boiler Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 3
	gib_chance = 100
	drag_delay = 6 //pulling a big dead xeno is hard
	mutation_type = BOILER_NORMAL
	acid_spray_activation_time = 3

	var/is_bombarding = 0
	var/obj/item/explosive/grenade/grenade_type = "/obj/item/explosive/grenade/xeno"
	var/bomb_cooldown = 0
	var/bomb_delay = 200 //20 seconds per glob at Young, -2.5 per upgrade down to 10 seconds
	var/bombard_speed = 50 //50 for normal boiler, 25 for Railgun boiler

	tileoffset = 5
	viewsize = 12

	var/datum/effect_system/smoke_spread/xeno_acid/smoke
	var/turf/bomb_turf = null

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/Boiler,
		/datum/action/xeno_action/bombard,
		/datum/action/xeno_action/toggle_long_range,
		/datum/action/xeno_action/toggle_bomb,
		/datum/action/xeno_action/activable/spray_acid,
		)

/mob/living/carbon/Xenomorph/Boiler/New()
	..()
	SetLuminosity(3)
	smoke = new /datum/effect_system/smoke_spread/xeno_acid
	smoke.attach(src)
	see_in_dark = 20
	ammo = ammo_list[/datum/ammo/xeno/boiler_gas]

/mob/living/carbon/Xenomorph/Boiler/Dispose()
	SetLuminosity(0)
	if(smoke)
		qdel(smoke)
		smoke = null
	. = ..()

/mob/living/carbon/Xenomorph/Boiler/proc/bomb_turf(var/turf/T)
	if(!istype(T) || T.z != src.z || T == get_turf(src))
		to_chat(src, SPAN_WARNING("This is not a valid target."))
		return

	if(!isturf(loc)) //In a locker
		return

	if(!ammo)
		ammo = ammo_list[/datum/ammo/xeno/boiler_gas]

	var/turf/U = get_turf(src)

	if(bomb_turf && bomb_turf != U)
		is_bombarding = 0
		if(client)
			client.mouse_pointer_icon = initial(client.mouse_pointer_icon) //Reset the mouse pointer.
		return

	if(!check_state())
		return

	if(!is_bombarding)
		to_chat(src, SPAN_WARNING("You must dig yourself in before you can do this."))
		return

	if(bomb_cooldown)
		to_chat(src, SPAN_WARNING("You are still preparing another spit. Be patient!"))
		return

	if(get_dist(T, U) <= min_bombard_dist)
		to_chat(src, SPAN_WARNING("You are too close! You must be at least [round(min_bombard_dist*7/5)] meters from the target due to the trajectory arc."))
		return

	if(!check_plasma(200))
		return

	var/offset_x = 0
	var/offset_y = 0

	if(mutation_type != BOILER_RAILGUN)
		offset_x = rand(-1, 1)
		offset_y = rand(-1, 1)

		if(prob(30))
			offset_x = 0
		if(prob(30))
			offset_y = 0

	var/turf/target = locate(T.x + offset_x, T.y + offset_y, T.z)

	if(!istype(target))
		return

	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon) //Reset the mouse pointer.
	bomb_cooldown = 1
	is_bombarding = 0

	// Some oddness with show_remaining_time allows you to still fire even if you move on the very last tick
	var/cur_loc = get_turf(src)
	var/time_remaining = do_after(src, bombard_speed, INTERRUPT_NO_NEEDHAND|INTERRUPT_LCLICK, BUSY_ICON_HOSTILE, show_remaining_time = TRUE)
	var/temp_damage = ammo.damage // stores the damage so that it can be reverted

	if((time_remaining || get_turf(src) != cur_loc) && (mutation_type != BOILER_RAILGUN))
		bomb_cooldown = 0
		to_chat(src, SPAN_WARNING("You decide not to launch any acid."))
		return
	else
		ammo.damage -= (0.75 * ammo.damage * time_remaining)

	if(!check_state())
		bomb_cooldown = 0
		return

	use_plasma(200)
	bomb_turf = null
	visible_message(SPAN_WARNING("\The [src] launches a huge glob of acid hurling into the distance!"), \
	SPAN_WARNING("You launch a huge glob of acid hurling into the distance!"), null, 5)

	var/obj/item/projectile/P = new /obj/item/projectile(initial(caste_name), src, loc)
	P.generate_bullet(ammo)
	P.fire_at(target, src, null, ammo.max_range, ammo.shell_speed)
	playsound(src, 'sound/effects/blobattack.ogg', 25, 1)

	ammo.damage = temp_damage // Restore damage to its original value

	spawn(bomb_delay)
		bomb_cooldown = 0
		to_chat(src, SPAN_NOTICE("You feel your toxin glands swell. You are able to bombard an area again."))
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()
	return
