/datum/caste_datum/boiler
	caste_name = "Boiler"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 25
	plasma_gain = 0.0375
	plasma_max = 800
	evolution_allowed = FALSE
	deevolves_to = "Spitter"
	spit_delay = 40
	caste_desc = "Gross!"
	armor_deflection = 20
	max_health = 180
	speed = 0.7
	bomb_strength = 1
	xeno_explosion_resistance = 60
	acid_level = 3

/datum/caste_datum/boiler/mature
	upgrade_name = "Mature"
	upgrade = 1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	plasma_gain = 0.039
	plasma_max = 900
	spit_delay = 35
	caste_desc = "Some sort of abomination. It looks a little more dangerous."
	armor_deflection = 25
	max_health = 200
	speed = 0.6
	bomb_strength = 1.5

/datum/caste_datum/boiler/elder
	upgrade_name = "Elder"
	caste_desc = "Some sort of abomination. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 30
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	plasma_gain = 0.040
	plasma_max = 900
	armor_deflection = 30
	spit_delay = 35
	max_health = 220
	speed = 0.6
	bomb_strength = 2

/datum/caste_datum/boiler/ancient
	upgrade_name = "Ancient"
	caste_desc = "A devestating piece of alien artillery."
	upgrade = 3
	melee_damage_lower = 25
	melee_damage_upper = 30
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	plasma_gain = 0.040
	plasma_max = 900
	armor_deflection = 30
	spit_delay = 35
	max_health = 220
	speed = 0.6
	bomb_strength = 2

/mob/living/carbon/Xenomorph/Boiler
	caste_name = "Boiler"
	name = "Boiler"
	desc = "A huge, grotesque xenomorph covered in glowing, oozing acid slime."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Boiler Walking"

	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	tier = 3
	gib_chance = 100
	drag_delay = 6 //pulling a big dead xeno is hard

	var/is_bombarding = 0
	var/obj/item/explosive/grenade/grenade_type = "/obj/item/explosive/grenade/xeno"
	var/bomb_cooldown = 0
	var/bomb_delay = 200 //20 seconds per glob at Young, -2.5 per upgrade down to 10 seconds
	var/bombard_speed = 50 //50 for normal boiler, 25 for Railgun boiler
	var/railgun = FALSE //No proj spread for railgun boilers.

	var/datum/effect_system/smoke_spread/xeno_acid/smoke
	var/turf/bomb_turf = null

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/corrosive_acid/Boiler,
		/datum/action/xeno_action/bombard,
		/datum/action/xeno_action/toggle_long_range,
		/datum/action/xeno_action/toggle_bomb,
		/datum/action/xeno_action/activable/spray_acid,
		)

	New()
		..()
		SetLuminosity(3)
		smoke = new /datum/effect_system/smoke_spread/xeno_acid
		smoke.attach(src)
		see_in_dark = 20
		ammo = ammo_list[/datum/ammo/xeno/boiler_gas]

	Dispose()
		SetLuminosity(0)
		if(smoke)
			qdel(smoke)
			smoke = null
		. = ..()







/mob/living/carbon/Xenomorph/Boiler/proc/bomb_turf(var/turf/T)
	if(!istype(T) || T.z != src.z || T == get_turf(src))
		to_chat(src, "<span class='warning'>This is not a valid target.</span>")
		return

	if(!isturf(loc)) //In a locker
		return

	var/turf/U = get_turf(src)

	if(bomb_turf && bomb_turf != U)
		is_bombarding = 0
		if(client)
			client.mouse_pointer_icon = initial(client.mouse_pointer_icon) //Reset the mouse pointer.
		return

	if(!check_state())
		return

	if(!is_bombarding)
		to_chat(src, "<span class='warning'>You must dig yourself in before you can do this.</span>")
		return

	if(bomb_cooldown)
		to_chat(src, "<span class='warning'>You are still preparing another spit. Be patient!</span>")
		return

	if(get_dist(T, U) <= 5) //Magic number
		to_chat(src, "<span class='warning'>You are too close! You must be at least 7 meters from the target due to the trajectory arc.</span>")
		return

	if(!check_plasma(200))
		return

	var/offset_x = 0
	var/offset_y = 0

	if(!railgun)
		offset_x = rand(-1, 1)
		offset_y = rand(-1, 1)

		if(prob(30))
			offset_x = 0
		if(prob(30))
			offset_y = 0

	var/turf/target = locate(T.x + offset_x, T.y + offset_y, T.z)

	if(!istype(target))
		return

	to_chat(src, "<span class='xenonotice'>You begin building up acid.</span>")
	if(client)
		client.mouse_pointer_icon = initial(client.mouse_pointer_icon) //Reset the mouse pointer.
	bomb_cooldown = 1
	is_bombarding = 0
	use_plasma(200)

	if(do_after(src, bombard_speed, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		if(!check_state())
			bomb_cooldown = 0
			return
		bomb_turf = null
		visible_message("<span class='xenowarning'>\The [src] launches a huge glob of acid hurling into the distance!</span>", \
		"<span class='xenowarning'>You launch a huge glob of acid hurling into the distance!</span>", null, 5)

		var/obj/item/projectile/P = new /obj/item/projectile(loc)
		P.generate_bullet(ammo)
		P.fire_at(target, src, null, ammo.max_range, ammo.shell_speed)
		playsound(src, 'sound/effects/blobattack.ogg', 25, 1)
		if(ammo.type == /datum/ammo/xeno/boiler_gas/corrosive)
			round_statistics.boiler_acid_smokes++
		else
			round_statistics.boiler_neuro_smokes++


		spawn(bomb_delay) //20 seconds cooldown. Halved if the boiler is a Railgun boiler.
			bomb_cooldown = 0
			to_chat(src, "<span class='notice'>You feel your toxin glands swell. You are able to bombard an area again.</span>")
			for(var/X in actions)
				var/datum/action/A = X
				A.update_button_icon()
		return
	else
		bomb_cooldown = 0
		to_chat(src, "<span class='warning'>You decide not to launch any acid.</span>")
	return