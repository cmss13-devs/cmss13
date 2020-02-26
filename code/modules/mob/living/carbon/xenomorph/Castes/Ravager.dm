/datum/caste_datum/ravager
	caste_name = "Ravager"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_MEDIUMLOW
	melee_damage_upper = XENO_DAMAGE_MEDIUM
	max_health = XENO_HEALTH_VERYHIGH
	plasma_gain = XENO_PLASMA_GAIN_VERYHIGH
	plasma_max = XENO_PLASMA_LOW
	xeno_explosion_resistance = XENO_LOWULTRA_EXPLOSIVE_ARMOR
	armor_deflection = XENO_MEDIUM_ARMOR + XENO_ARMOR_MOD_VERYSMALL
	armor_hardiness_mult = XENO_ARMOR_FACTOR_MEDIUM
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_MEDIUM
	speed_mod = XENO_SPEED_MOD_MED

	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	evolution_allowed = FALSE
	deevolves_to = "Lurker"
	caste_desc = "A brutal, devastating front-line attacker."
	charge_type = 3 //Claw at end of charge
	fire_immune = 1
	attack_delay = -2
	pounce_delay = 120
	charge_distance = 4 //shorter than regular charges

	// Strain variables

	// Vanilla
	var/empower_cooldown = 300

	// Spike shed variables
	var/spike_shed_cooldown = 100 

	// Spin slash variables
	var/spin_cooldown = 250;
	var/spin_damage_offset = 15;	   // Bonus damage considered by armor
	var/spin_damage_ignore_armor = 10; // Bonus damage that ignores armor 

/datum/caste_datum/ravager/mature
	upgrade_name = "Mature"
	caste_desc = "A brutal, devastating front-line attacker. It looks a little more dangerous."
	upgrade = 1

	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45

/datum/caste_datum/ravager/elder
	upgrade_name = "Elder"
	caste_desc = "A brutal, devastating front-line attacker. It looks pretty strong."
	upgrade = 2

	tacklemin = 5
	tacklemax = 6
	tackle_chance = 58

/datum/caste_datum/ravager/ancient
	upgrade_name = "Ancient"
	caste_desc = "As I walk through the valley of the shadow of death"
	upgrade = 3

	tacklemin = 6
	tacklemax = 7
	tackle_chance = 60

/datum/caste_datum/ravager/primordial
	upgrade_name = "Primordial"
	caste_desc = "This thing's scythes are bigger than a fucking building!"
	upgrade = 4

	tacklemin = 6
	tacklemax = 7
	tackle_chance = 55

/mob/living/carbon/Xenomorph/Ravager
	caste_name = "Ravager"
	name = "Ravager"
	desc = "A huge, nasty red alien with enormous scythed claws."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
	icon_size = 64
	icon_state = "Ravager Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	var/used_charge = 0
	var/tail_stab_ready = 0
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	pixel_x = -16
	old_x = -16
	mutation_type = RAVAGER_NORMAL

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/empower
		)

/mob/living/carbon/Xenomorph/Ravager/New()
	..()
	ammo = ammo_list[/datum/ammo/xeno/bone_chips]

//Chance of insta limb amputation after a melee attack.
/mob/living/carbon/Xenomorph/Ravager/proc/delimb(var/mob/living/carbon/human/H, var/obj/limb/O)
	if(!iszombie(H) && prob(isYautja(H)?20:40)) // lets halve this for preds
		O = H.get_limb(check_zone(zone_selected))
		if(O.body_part != BODY_FLAG_CHEST && O.body_part != BODY_FLAG_GROIN && O.body_part != BODY_FLAG_HEAD && O.brute_dam >= 5) //Only limbs.
			visible_message(SPAN_DANGER("The limb is sliced clean off!"),SPAN_DANGER("You slice off a limb!"))
			O.droplimb(0, 0, initial(name))
			return TRUE
	return FALSE

/mob/living/carbon/Xenomorph/Ravager/proc/shrapnel_embed(var/mob/living/carbon/human/H, var/obj/limb/organ)
	if(isHumanStrict(H))
		if(!istype(organ))
			return
			
		var/chance = 100
		var/attacked_armor = H.getarmor(zone_selected, ARMOR_MELEE)
		if(attacked_armor > 29) // Medium armor
			chance = 50
		if(attacked_armor > 34) // Heavy armor
			chance = 30
			
		if(!prob(chance))
			return

		var/obj/item/shard/shrapnel/shrap = new /obj/item/shard/shrapnel/bone_chips()
		shrap.on_embed(H, organ)

		if(!stat && !(H.species && H.species.flags & NO_PAIN))
			to_chat(H, SPAN_DANGER("Bits of bone and shrapnel embed themselves in the wound! It hurts like hell!"))

/mob/living/carbon/Xenomorph/Ravager/proc/tail_stab(var/mob/living/carbon/human/H, var/damage)
	if(tail_stab_ready)
		return FALSE

	var/tail_stab_cooldown = 70 // 7 seconds
	tail_stab_ready = TRUE

	tail_attack(H, damage)

	spawn(tail_stab_cooldown)
		tail_stab_ready = FALSE
		to_chat(src, SPAN_WARNING("You feel you tail is ready to strike again!"))
	return TRUE

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
	visible_message(SPAN_XENOWARNING("\The [src] sprays out a stream of flame from its mouth!"), \
	SPAN_XENOWARNING("You unleash a spray of fire on your enemies!"))
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
		new/obj/flamer_fire(T, initial(name), src)
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
			if(istype(H.wear_suit, /obj/item/clothing/suit/fire))
				continue

		M.adjustFireLoss(rand(20, 50)) //Fwoom!
		var/msg = "Augh! You are roasted by the flames!"
		to_chat(M, "[isXeno(M) ? SPAN_XENODANGER(msg) : SPAN_DANGER(msg)]")
