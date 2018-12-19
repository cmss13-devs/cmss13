/datum/caste_datum/ravager
	caste_name = "Ravager"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0
	melee_damage_lower = 30
	melee_damage_upper = 40
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	max_health = 200
	plasma_gain = 0.08
	plasma_max = 100
	upgrade_threshold = 800
	evolution_allowed = FALSE
	deevolves_to = "Lurker"
	caste_desc = "A brutal, devastating front-line attacker."
	speed = -0.7 //Not as fast as runners, but faster than other xenos.
	charge_type = 3 //Claw at end of charge
	fire_immune = 1
	armor_deflection = 35
	xeno_explosion_resistance = 60
	attack_delay = -2

/datum/caste_datum/ravager/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 40
	melee_damage_upper = 50
	max_health = 225
	plasma_gain = 0.067
	plasma_max = 150
	upgrade_threshold = 1600
	caste_desc = "A brutal, devastating front-line attacker. It looks a little more dangerous."
	speed = -0.8
	armor_deflection = 40
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45

/datum/caste_datum/ravager/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 50
	melee_damage_upper = 60
	max_health = 250
	plasma_gain = 0.075
	plasma_max = 200
	upgrade_threshold = 3200
	caste_desc = "A brutal, devastating front-line attacker. It looks pretty strong."
	speed = -0.9
	armor_deflection = 45
	tacklemin = 5
	tacklemax = 6
	tackle_chance = 50

/datum/caste_datum/ravager/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 60
	melee_damage_upper = 70
	max_health = 275
	caste_desc = "As I walk through the valley of the shadow of death."
	speed = -1.0
	armor_deflection = 50
	tacklemin = 6
	tacklemax = 7
	tackle_chance = 55

/mob/living/carbon/Xenomorph/Ravager
	caste_name = "Ravager"
	name = "Ravager"
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/Xeno/xenomorph_64x64.dmi'
	icon_state = "Ravager Walking"
	var/usedcharge = 0 //What's the deal with the all caps?? They're not constants :|
	var/CHARGESPEED = 2
	var/CHARGESTRENGTH = 2
	var/CHARGEDISTANCE = 4
	var/CHARGECOOLDOWN = 120
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	pixel_x = -16
	old_x = -16

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/charge,
		)


/mob/living/carbon/Xenomorph/Ravager/proc/charge(atom/T)
	if(!T) return

	if(!check_state())
		return

	if(usedPounce)
		return

	if(!check_plasma(20))
		return

	if(legcuffed)
		src << "<span class='xenodanger'>You can't charge with that thing on your leg!</span>"
		return

	visible_message("<span class='danger'>[src] charges towards \the [T]!</span>", \
	"<span class='danger'>You charge towards \the [T]!</span>" )
	emote("roar") //heheh
	usedPounce = 1 //This has to come before throw_at, which checks impact. So we don't do end-charge specials when thrown
	use_plasma(20)
	throw_at(T, CHARGEDISTANCE, CHARGESPEED, src)
	spawn(CHARGECOOLDOWN)
		usedPounce = 0
		src << "<span class='notice'>Your exoskeleton quivers as you get ready to charge again.</span>"
		for(var/X in actions)
			var/datum/action/A = X
			A.update_button_icon()


//Chance of insta limb amputation after a melee attack.
/mob/living/carbon/Xenomorph/Ravager/proc/delimb(var/mob/living/carbon/human/H, var/datum/limb/O)
	if (!iszombie(H) && prob(isYautja(H)?10:20)) // lets halve this for preds
		O = H.get_limb(check_zone(zone_selected))
		if (O.body_part != UPPER_TORSO && O.body_part != LOWER_TORSO && O.body_part != HEAD) //Only limbs.
			visible_message("<span class='danger'>The limb is sliced clean off!</span>","<span class='danger'>You slice off a limb!</span>")
			O.droplimb()
			return 1

	return 0

/datum/caste_datum/ravager/ravenger
	caste_name = "Ravenger"
	is_intelligent = 1
	melee_damage_lower = 70
	melee_damage_upper = 90
	tacklemin = 3
	tacklemax = 6
	tackle_chance = 85
	max_health = 600
	plasma_gain = 15
	plasma_max = 200
	upgrade = 3
	can_be_queen_healed = 0

//Super hacky firebreathing Halloween rav.
/mob/living/carbon/Xenomorph/Ravager/ravenger
	name = "Ravenger"
	caste_name = "Ravenger"
	desc = "It's a goddamn dragon! Run! RUUUUN!"
	hardcore = 1
	health = 600
	maxHealth = 600
	plasma_stored = 200
	upgrade = 3
	var/used_fire_breath = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/activable/breathe_fire,
		)

	New()
		..()
		verbs -= /mob/living/carbon/Xenomorph/verb/hive_status
		spawn(15) name = "Ravenger"

/mob/living/carbon/Xenomorph/Ravager/ravenger/update_icons()
	if(stat == DEAD)
		icon_state = "Ravager Dead"
	else if(lying)
		if((resting || sleeping) && (!knocked_down && !knocked_out && health > 0))
			icon_state = "Ravager Sleeping"
		else
			icon_state = "Ravager Knocked Down"
	else
		if(m_intent == MOVE_INTENT_RUN)
			icon_state = "Ravager Running"
		else
			icon_state = "Ravager Walking"

	update_fire() //the fire overlay depends on the xeno's stance, so we must update it.

/mob/living/carbon/Xenomorph/Ravager/ravenger/proc/breathe_fire(atom/A)
	set waitfor = 0
	if(world.time <= used_fire_breath + 75)
		return
	var/list/turf/turfs = getline2(src, A)
	var/distance = 0
	var/obj/structure/window/W
	var/turf/T
	playsound(src, 'sound/weapons/gun_flamethrower2.ogg', 50, 1)
	visible_message("<span class='xenowarning'>\The [src] sprays out a stream of flame from its mouth!</span>", \
	"<span class='xenowarning'>You unleash a spray of fire on your enemies!</span>")
	used_fire_breath = world.time
	for(T in turfs)
		if(T == loc)
			continue
		if(distance >= 5)
			break
		if(DirBlocked(T, dir))
			break
		else if(DirBlocked(T, turn(dir, 180)))
			break
		if(locate(/turf/closed/wall/resin, T) || locate(/obj/structure/mineral_door/resin, T))
			break
		W = locate() in T
		if(W)
			if(W.is_full_window())
				break
			if(W.dir == dir)
				break
		flame_turf(T)
		distance++
		sleep(1)

/mob/living/carbon/Xenomorph/Ravager/ravenger/proc/flame_turf(turf/T)
	if(!istype(T))
		return
	if(!locate(/obj/flamer_fire) in T) // No stacking flames!
		new/obj/flamer_fire(T)
	else
		return

	for(var/mob/living/carbon/M in T) //Deal bonus damage if someone's caught directly in initial stream
		if(M.stat == DEAD)
			continue
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.caste.fire_immune)
				continue
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire) || istype(H.wear_suit, /obj/item/clothing/suit/space/rig/atmos))
				continue

		M.adjustFireLoss(rand(20, 50)) //Fwoom!
		M << "[isXeno(M) ? "<span class='xenodanger'>":"<span class='highdanger'>"]Augh! You are roasted by the flames!</span>"
