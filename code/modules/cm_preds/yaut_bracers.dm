/obj/item/clothing/gloves/yautja
	name = "clan bracers"
	desc = "An extremely complex, yet simple-to-operate set of armored bracers worn by the Yautja. It has many functions, activate them to use some."
	icon = 'icons/obj/items/weapons/predator.dmi'
	icon_state = "bracer"

	siemens_coefficient = 0
	permeability_coefficient = 0.05
	flags_item = ITEM_PREDATOR
	flags_armor_protection = BODY_FLAG_HANDS
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_min_cold_protection_temperature
	max_heat_protection_temperature = GLOVES_max_heat_protection_temperature
	unacidable = TRUE
	var/obj/item/weapon/gun/energy/plasma_caster/caster
	var/charge = 3000
	var/charge_max = 3000
	var/cloaked = 0
	var/blades_active = 0
	var/caster_active = 0
	var/exploding = 0
	var/inject_timer = 0
	var/disc_timer = 0
	var/cloak_timer = 0
	var/upgrades = 0 //Set to two, so admins can give preds shittier ones for young blood events or whatever. //Changed it back to 0 since it was breaking spawn-equipment and the translator -retrokinesis
	var/explosion_type = 1 //0 is BIG explosion, 1 ONLY gibs the user.
	var/combistick_cooldown = 0 //Let's add a cooldown for Yank Combistick so that it can't be spammed.
	var/notification_sound = TRUE	// Whether the bracer pings when a message comes or not

/obj/item/clothing/gloves/yautja/Initialize(mapload, ...)
	. = ..()
	caster = new(src)

/obj/item/clothing/gloves/yautja/emp_act(severity)
	charge -= (severity * 500)
	if(charge < 0) charge = 0
	if(usr)
		usr.visible_message(SPAN_DANGER("You hear a hiss and crackle!"),SPAN_DANGER("Your bracers hiss and spark!"))
		if(cloaked)
			decloak(usr)

/obj/item/clothing/gloves/yautja/equipped(mob/user, slot)
	. = ..()
	if(slot != WEAR_HANDS)
		return
	flags_item ^= NODROP
	START_PROCESSING(SSobj, src)
	if(isYautja(user))
		to_chat(user, SPAN_WARNING("The bracer clamps securely around your forearm and beeps in a comfortable, familiar way."))
	else
		to_chat(user, SPAN_WARNING("The bracer clamps painfully around your forearm and beeps angrily. It won't come off!"))

//Any projectile can decloak a predator. It does defeat one free bullet though.
/obj/item/clothing/gloves/yautja/proc/bullet_hit(mob/living/carbon/human/H, obj/item/projectile/P)
	SIGNAL_HANDLER
	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if( ammo_flags & (AMMO_ROCKET|AMMO_ENERGY|AMMO_XENO_ACID) ) //<--- These will auto uncloak.
		decloak(H) //Continue on to damage.
	else if(rand(0,100) < 20)
		decloak(H)
		return COMPONENT_BULLET_NO_HIT //Absorb one free bullet.

/obj/item/clothing/gloves/yautja/Destroy()
	QDEL_NULL(caster)
	STOP_PROCESSING(SSobj, src)
	remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/gloves/yautja/dropped(mob/user)
	STOP_PROCESSING(SSobj, src)
	add_to_missing_pred_gear(src)
	flags_item = initial(flags_item)
	..()

/obj/item/clothing/gloves/yautja/pickup(mob/living/user)
	if(isYautja(user))
		remove_from_missing_pred_gear(src)
	..()

/obj/item/clothing/gloves/yautja/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return
	var/mob/living/carbon/human/H = loc
	if(cloak_timer)
		cloak_timer--
	if(cloaked)
		H.alpha = 10
		charge = max(charge - 10, 0)
		if(charge <= 0)
			decloak(loc)
		//Non-Yautja have a chance to get stunned with each power drain
		if(!isYautja(H))
			if(prob(15))
				shock_user(H)
				decloak(loc)
	else
		charge = min(charge + 30, charge_max)
	var/perc_charge = (charge / charge_max * 100)
	H.update_power_display(perc_charge)


//This is the main proc for checking AND draining the bracer energy. It must have M passed as an argument.
//It can take a negative value in amount to restore energy.
//Also instantly updates the yautja power HUD display.
/obj/item/clothing/gloves/yautja/proc/drain_power(var/mob/living/carbon/human/M, var/amount)
	if(!M) return 0
	if(charge < amount)
		to_chat(M, SPAN_WARNING("Your bracers lack the energy. They have only <b>[charge]/[charge_max]</b> remaining and need <B>[amount]</b>."))
		return 0
	charge -= amount
	var/perc = (charge / charge_max * 100)
	M.update_power_display(perc)

	//Non-Yautja have a chance to get stunned with each power drain
	if(!isYautja(M))
		if(prob(15))
			shock_user(M)
	return 1

/obj/item/clothing/gloves/yautja/proc/shock_user(var/mob/living/carbon/human/M)
	if(!isYautja(M))
		//Spark
		playsound(M, 'sound/effects/sparks2.ogg', 60, 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		M.visible_message(SPAN_WARNING("[src] beeps and sends a shock through [M]'s body!"))
		//Stun and knock out, scream in pain
		M.Stun(2)
		M.KnockDown(2)
		if(M.pain.feels_pain)
			M.emote("scream")
		//Apply a bit of burn damage
		M.apply_damage(5, BURN, "l_arm", 0, 0, 0, src)
		M.apply_damage(5, BURN, "r_arm", 0, 0, 0, src)


/obj/item/clothing/gloves/yautja/examine(mob/user)
	..()
	to_chat(user, "They currently have [charge] out of [charge_max] charge.")


//We use this to activate random verbs for non-Yautja
/obj/item/clothing/gloves/yautja/proc/activate_random_verb()
	var/option = rand(1, 11)
	//we have options from 1 to 8, but we're giving the user a higher probability of being punished if they already rolled this bad
	switch(option)
		if(1)
			. = wristblades_internal(TRUE)
		if(2)
			. = track_gear_internal(TRUE)
		if(3)
			. = cloaker_internal(TRUE)
		if(4)
			. = caster_internal(TRUE)
		if(5)
			. = injectors_internal(TRUE)
		if(6)
			. = call_disk_internal(TRUE)
		if(7)
			. = translate_internal(TRUE)
		if(8)
			. = call_combi(TRUE)
		else
			. = delimb_user()

	return

//We use this to determine whether we should activate the given verb, or a random verb
//0 - do nothing, 1 - random function, 2 - this function
/obj/item/clothing/gloves/yautja/proc/should_activate_random_or_this_function()
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return 0

	var/workingProbability = 20
	var/randomProbability = 10
	if (isSynth(user))
		//Synths are smart, they can figure this out pretty well
		workingProbability = 40
		randomProbability = 4
	else
		//Researchers are sort of smart, they can sort of figure this out
		if (isResearcher(user))
			workingProbability = 25
			randomProbability = 7


	to_chat(user, SPAN_NOTICE("You press a few buttons..."))
	//Add a little delay so the user wouldn't be just spamming all the buttons
	user.next_move = world.time + 3
	if(do_after(usr, 3, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 1))
		var/chance = rand(1, 100)
		if(chance <= randomProbability)
			return 1
		chance-=randomProbability
		if(chance <= workingProbability)
			return 2
	return 0


//This is used to punish people that fiddle with technology they don't understand
/obj/item/clothing/gloves/yautja/proc/delimb_user()
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(isYautja(usr)) return

	var/obj/limb/O = user.get_limb(check_zone("r_arm"))
	O.droplimb()
	O = user.get_limb(check_zone("l_arm"))
	O.droplimb()

	to_chat(user, SPAN_NOTICE("The device emits a strange noise and falls off... Along with your arms!"))
	playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)
	return 1

// Toggle the notification sound
/obj/item/clothing/gloves/yautja/verb/toggle_notification_sound()
	set name = "Toggle Bracer Sound"
	set desc = "Toggle your bracer's notification sound."
	set category = "Yautja"

	notification_sound = !notification_sound
	to_chat(usr, SPAN_NOTICE("The bracer's sound is now turned [notification_sound ? "on" : "off"]."))

//Should put a cool menu here, like ninjas.
/obj/item/clothing/gloves/yautja/verb/wristblades()
	set name = "Use Wrist Blades"
	set desc = "Extend your wrist blades. They cannot be dropped, but can be retracted."
	set category = "Yautja"
	. = wristblades_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/wristblades_internal(var/forced = FALSE)
	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/user = usr
	if(!istype(user)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	var/obj/item/weapon/wristblades/R = user.get_active_hand()
	var/obj/item/weapon/wristblades/L = user.get_inactive_hand()
	var/is_lefthand_full = FALSE
	if(R && istype(R)) //Turn it off.
		to_chat(user, SPAN_NOTICE("You retract your wrist blades."))
		playsound(user.loc,'sound/weapons/wristblades_off.ogg', 15, 1)
		blades_active = 0
		qdel(R)
		if(L && istype(L)) //If they have one in the off hand as well turn it off.
			qdel(L)
		return
	else
		if(!drain_power(user,50)) return

		if(R)
			to_chat(user, SPAN_WARNING("Your hand must be free to activate your wristblade!"))
			return
		if(L)
			to_chat(user, SPAN_WARNING("Your other hand must be free to activate your off-hand wristblade!"))
			is_lefthand_full = TRUE
		var/obj/limb/hand = user.get_limb(user.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("You can't hold that!"))
			return
		var/obj/item/weapon/wristblades/N = new()
		user.put_in_active_hand(N)
		if(!is_lefthand_full)
			var/obj/item/weapon/wristblades/W = new()
			user.put_in_inactive_hand(W)
		blades_active = 1
		to_chat(user, SPAN_NOTICE("You activate your wrist blades."))
		playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)

	return 1

/obj/item/clothing/gloves/yautja/verb/track_gear()
	set name = "Track Yautja Gear"
	set desc = "Find Yauja Gear."
	set category = "Yautja"
	. = track_gear_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/track_gear_internal(var/forced = FALSE)
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	var/dead_on_planet = 0
	var/dead_on_almayer = 0
	var/dead_low_orbit = 0
	var/gear_on_planet = 0
	var/gear_on_almayer = 0
	var/gear_low_orbit = 0
	var/closest = 10000
	var/direction = -1
	var/atom/areaLoc = null
	for(var/obj/item/I in yautja_gear)
		var/atom/loc = get_true_location(I)
		if (isYautja(loc))
			//it's actually yautja holding the item, ignore!
			continue
		if(is_loworbit_level(loc.z))
			gear_low_orbit++
		else if(is_mainship_level(loc.z))
			gear_on_almayer++
		else if(is_ground_level(loc.z))
			gear_on_planet++
		if(M.z == loc.z)
			var/dist = get_dist(M,loc)
			if(dist < closest)
				closest = dist
				direction = get_dir(M,loc)
				areaLoc = loc
	for(var/mob/living/carbon/human/Y in GLOB.yautja_mob_list)
		if(Y.stat != DEAD) continue
		if(is_loworbit_level(Y.z))
			dead_low_orbit++
		else if(is_mainship_level(Y.z))
			dead_on_almayer++
		else if(is_ground_level(Y.z))
			dead_on_planet++
		if(M.z == Y.z)
			var/dist = get_dist(M,Y)
			if(dist < closest)
				closest = dist
				direction = get_dir(M,Y)
				areaLoc = loc

	var/output = 0
	if(dead_on_planet || dead_on_almayer || dead_low_orbit)
		output = 1
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of deceased Yautja bio signatures, [dead_on_planet] in the hunting grounds, [dead_on_almayer] in orbit, [dead_low_orbit] in low orbit."))
	if(gear_on_planet || gear_on_almayer || gear_low_orbit)
		output = 1
		to_chat(M, SPAN_NOTICE("Your bracer shows a readout of Yautja technology signatures, [gear_on_planet] in the hunting grounds, [gear_on_almayer] in orbit, [gear_low_orbit] in low orbit."))
	if(closest < 900)
		var/areaName = get_area(areaLoc).name
		to_chat(M, SPAN_NOTICE("The closest signature is approximately [round(closest,10)] paces [dir2text(direction)] in [areaName]."))
	if(!output)
		to_chat(M, SPAN_NOTICE("There are no signatures that require your attention."))
	return 1


/obj/item/clothing/gloves/yautja/verb/cloaker()
	set name = "Toggle Cloaking Device"
	set desc = "Activate your suit's cloaking device. It will malfunction if the suit takes damage or gets excessively wet."
	set category = "Yautja"
	. = cloaker_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/cloaker_internal(var/forced = FALSE)
	if(!usr || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			if(cloaked) //Turn it off.
				//We're going to be nice here and say you can turn off the cloak without an issue
				//Otherwise, humans wouldn't have any use for the cloak without being shocked every time they turn it on
				//Since they couldn't turn it off in time afterwards with consistency
				decloak(usr)
				return 1
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(cloaked) //Turn it off.
		decloak(usr)
	else //Turn it on!
		if(exploding)
			to_chat(M, SPAN_WARNING("Your bracer is much too busy violently exploding to activate the cloaking device."))
			return 0
		if(cloak_timer)
			if(prob(50))
				to_chat(M, SPAN_WARNING("Your cloaking device is still recharging! Time left: <B>[cloak_timer]</b> ticks."))
			return 0
		if(!drain_power(M,50)) return
		cloaked = 1
		RegisterSignal(M, COMSIG_HUMAN_BULLET_ACT, .proc/bullet_hit)
		to_chat(M, SPAN_NOTICE("You are now invisible to normal detection."))
		for(var/mob/O in oviewers(M))
			O.show_message("[M] vanishes into thin air!",1)
		playsound(M.loc,'sound/effects/pred_cloakon.ogg', 15, 1)
		M.alpha = 25

		var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
		SA.remove_from_hud(M)
		var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
		XI.remove_from_hud(M)
		spawn(1)
			anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

	return 1

/obj/item/clothing/gloves/yautja/proc/decloak(var/mob/user)
	if(!user) return
	UnregisterSignal(user, COMSIG_HUMAN_BULLET_ACT)
	to_chat(user, "Your cloaking device deactivates.")
	cloaked = 0
	for(var/mob/O in oviewers(user))
		O.show_message("[user.name] shimmers into existence!",1)
	playsound(user.loc,'sound/effects/pred_cloakoff.ogg', 15, 1)
	user.alpha = initial(user.alpha)
	cloak_timer = 5

	var/datum/mob_hud/security/advanced/SA = huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(user)
	var/datum/mob_hud/xeno_infection/XI = huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(user)

	spawn(1)
		if(user)
			anim(user.loc,user,'icons/mob/mob.dmi',,"uncloak",,user.dir)


/obj/item/clothing/gloves/yautja/verb/caster()
	set name = "Use Plasma Caster"
	set desc = "Activate your plasma caster. If it is dropped it will retract back into your armor."
	set category = "Yautja"
	. = caster_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/caster_internal(var/forced = FALSE)
	if(!usr.loc || !usr.canmove || usr.stat) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	var/obj/item/weapon/gun/energy/plasma_caster/R = usr.r_hand
	var/obj/item/weapon/gun/energy/plasma_caster/L = usr.l_hand
	if(!istype(R) && !istype(L))
		caster_active = 0
	if(caster_active) //Turn it off.
		var/found = 0
		if(R && istype(R))
			found = 1
			usr.r_hand = null
			if(R)
				M.temp_drop_inv_item(R)
				R.forceMove(src)
			M.update_inv_r_hand()
		if(L && istype(L))
			found = 1
			usr.l_hand = null
			if(L)
				M.temp_drop_inv_item(L)
				L.forceMove(src)
			M.update_inv_l_hand()
		if(found)
			to_chat(usr, SPAN_NOTICE("You deactivate your plasma caster."))
			playsound(src,'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
			caster_active = 0
		return
	else //Turn it on!
		if(usr.get_active_hand())
			to_chat(usr, SPAN_WARNING("Your hand must be free to activate your caster!"))
			return
		if(!drain_power(usr,50)) return

		var/obj/item/weapon/gun/energy/plasma_caster/W = caster
		if(!istype(W))
			W = new(usr)
		usr.put_in_active_hand(W)
		W.source = src
		caster_active = 1
		to_chat(usr, SPAN_NOTICE("You activate your plasma caster."))
		playsound(src,'sound/weapons/pred_plasmacaster_on.ogg', 15, 1)
	return 1


/obj/item/clothing/gloves/yautja/proc/explodey(var/mob/living/carbon/victim)
	set waitfor = 0

	if (exploding)
		return

	exploding = 1

	playsound(src, 'sound/effects/pred_countdown.ogg', 100, 0, 17, status = 0)
	message_staff(FONT_SIZE_XL("<A HREF='?_src_=admin_holder;admincancelpredsd=1;bracer=\ref[src];victim=\ref[victim]'>CLICK TO CANCEL THIS PRED SD</a>"))
	do_after(victim, rand(72, 80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	var/turf/T = get_turf(victim)
	if(istype(T) && exploding)
		victim.apply_damage(50,BRUTE,"chest")
		if(victim) victim.gib() //Let's make sure they actually gib.
		if(explosion_type == 0 && is_ground_level(z))
			cell_explosion(T, 600, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, "yautja self destruct", victim) //Dramatically BIG explosion.
		else
			cell_explosion(T, 800, 550, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, "yautja self destruct", victim)

/obj/item/clothing/gloves/yautja/verb/activate_suicide()
	set name = "Final Countdown (!)"
	set desc = "Activate the explosive device implanted into your bracers. You have failed! Show some honor!"
	set category = "Yautja"
	. = activate_suicide_internal(FALSE)

/obj/item/clothing/gloves/yautja/verb/change_explosion_type()
	set name = "Change Explosion Type"
	set desc = "Changes your bracer explosion to either only gib you or be a big explosion."
	set category = "Yautja"
	if(alert("Which explosion type do you want?","Explosive Bracers", "Small", "Big") == "Big")
		explosion_type = 0
	else explosion_type = 1


/obj/item/clothing/gloves/yautja/proc/activate_suicide_internal(var/forced = FALSE)
	if(!usr) return
	var/mob/living/carbon/human/M = usr
	if(!istype(M)) return
	if(cloaked)
		to_chat(M, SPAN_WARNING("Not while you're cloaked. It might disrupt the sequence."))
		return
	if(!M.stat == CONSCIOUS)
		to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
		return
	if(M.stat == DEAD)
		to_chat(M, SPAN_WARNING("Little too late for that now!"))
		return
	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

		//Council did not want the humans to trigger SD EVER
		. = delimb_user()
		return

	var/obj/item/grab/G = M.get_active_hand()
	if(istype(G))
		var/mob/living/carbon/human/comrade = G.grabbed_thing
		if(isYautja(comrade) && comrade.stat == DEAD)
			var/obj/item/clothing/gloves/yautja/bracer = comrade.gloves
			if(istype(bracer))
				if(forced || alert("Are you sure you want to send this Yautja into the great hunting grounds?","Explosive Bracers", "Yes", "No") == "Yes")
					if(M.get_active_hand() == G && comrade && comrade.gloves == bracer && !bracer.exploding)
						var/area/A = get_area(M)
						var/turf/T = get_turf(M)
						if(A)
							message_staff(FONT_SIZE_HUGE("ALERT: [usr] ([usr.key]) triggered the predator self-destruct sequence of [comrade] ([comrade.key]) in [A.name] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)</font>"))
							log_attack("[key_name(usr)] triggered the predator self-destruct sequence of [comrade] ([comrade.key]) in [A.name]")
						if (!bracer.exploding)
							bracer.explodey(comrade)
						M.visible_message(SPAN_WARNING("[M] presses a few buttons on [comrade]'s wrist bracer."),SPAN_DANGER("You activate the timer. May [comrade]'s final hunt be swift."))
						message_all_yautja("[M] has triggered [comrade]'s bracer's self-destruction sequence.")
			else
				to_chat(M, SPAN_WARNING("Your fallen comrade does not have a bracer. <b>Report this to your elder so that it's fixed.</b>"))
			return

	if(M.gloves != src && !forced)
		return

	if(exploding)
		if(forced || alert("Are you sure you want to stop the countdown?","Bracers", "Yes", "No") == "Yes")
			if(M.gloves != src)
				return
			if(M.stat == DEAD)
				to_chat(M, SPAN_WARNING("Little too late for that now!"))
				return
			if(!M.stat == CONSCIOUS)
				to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
				return
			exploding = 0
			to_chat(M, SPAN_NOTICE("Your bracers stop beeping."))
		return
	if((M.wear_mask && istype(M.wear_mask,/obj/item/clothing/mask/facehugger)) || M.status_flags & XENO_HOST)
		to_chat(M, SPAN_WARNING("Strange...something seems to be interfering with your bracer functions..."))
		return
	if(forced || alert("Detonate the bracers? Are you sure?","Explosive Bracers", "Yes", "No") == "Yes")
		if(M.gloves != src)
			return
		if(M.stat == DEAD)
			to_chat(M, SPAN_WARNING("Little too late for that now!"))
			return
		if(!M.stat == CONSCIOUS)
			to_chat(M, SPAN_WARNING("Not while you're unconcious..."))
			return
		if(exploding)
			return
		to_chat(M, SPAN_DANGER("You set the timer. May your journey to the great hunting grounds be swift."))
		var/area/A = get_area(M)
		var/turf/T = get_turf(M)
		message_staff(FONT_SIZE_HUGE("ALERT: [usr] ([usr.key]) triggered their predator self-destruct sequence [A ? "in [A.name]":""] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)"))
		log_attack("[key_name(usr)] triggered their predator self-destruct sequence in [A ? "in [A.name]":""]")

		explodey(M)
	return 1



/obj/item/clothing/gloves/yautja/verb/injectors()
	set name = "Create Self-Heal Crystal"
	set category = "Yautja"
	set desc = "Create a focus crystal to energize your natural healing processes."
	. = injectors_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/injectors_internal(var/forced = FALSE)
	if(!usr.canmove || usr.stat || usr.is_mob_restrained())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(usr.get_active_hand())
		to_chat(usr, SPAN_WARNING("Your active hand must be empty!"))
		return 0

	if(inject_timer)
		to_chat(usr, SPAN_WARNING("You recently activated the healing crystal. Be patient."))
		return

	if(!drain_power(usr,1000)) return

	inject_timer = TRUE
	addtimer(CALLBACK(src, .proc/injectors_ready), 2 MINUTES)

	to_chat(usr, SPAN_NOTICE(" You feel a faint hiss and a crystalline injector drops into your hand."))
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(usr)
	usr.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return 1

/obj/item/clothing/gloves/yautja/proc/injectors_ready()
	if(ismob(loc))
		to_chat(loc, SPAN_NOTICE(" Your bracers beep faintly and inform you that a new healing crystal is ready to be created."))
	inject_timer = FALSE

/obj/item/clothing/gloves/yautja/verb/call_disk()
	set name = "Call Smart-Disc"
	set category = "Yautja"
	set desc = "Call back your smart-disc, if it's in range. If not you'll have to go retrieve it."
	. = call_disk_internal(FALSE)


/obj/item/clothing/gloves/yautja/proc/call_disk_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(disc_timer)
		to_chat(usr, SPAN_WARNING("Your bracers need some time to recuperate first."))
		return 0

	if(!drain_power(usr,70)) return
	disc_timer = 1
	addtimer(VARSET_CALLBACK(src, disc_timer, FALSE), 10 SECONDS)

	for(var/mob/living/simple_animal/hostile/smartdisc/S in range(7))
		to_chat(usr, SPAN_WARNING("The [S] skips back towards you!"))
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(S.loc)
		qdel(S)

	for(var/obj/item/explosive/grenade/spawnergrenade/smartdisc/D in range(10))
		var/datum/launch_metadata/LM = new()
		LM.target = usr
		LM.range = 10
		LM.speed = SPEED_FAST
		LM.thrower = usr
		D.launch_towards(LM)
	return 1

/obj/item/clothing/gloves/yautja/verb/remove_tracked_item()
	set name = "Remove item from tracker"
	set category = "Yautja"
	set desc = "Removes an item from all yautja tracking."
	. = remove_tracked_item_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/remove_tracked_item_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(!yautja_gear.len)
		return
	var/obj/item/pickeditem = input("item to remove") as null|anything in yautja_gear
	if(pickeditem && !(pickeditem in untracked_yautja_gear))
		untracked_yautja_gear += pickeditem
		remove_from_missing_pred_gear(pickeditem)


/obj/item/clothing/gloves/yautja/verb/add_tracked_item()
	set name = "Add item to tracker"
	set category = "Yautja"
	set desc = "Adds an item to all yautja tracking."
	. = add_tracked_item_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/add_tracked_item_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return
	if(!untracked_yautja_gear.len)
		return
	var/obj/item/pickeditem = input("item to add") as null|anything in untracked_yautja_gear
	if(pickeditem && !(pickeditem in yautja_gear))
		untracked_yautja_gear -= pickeditem
		add_to_missing_pred_gear(pickeditem)

/obj/item/clothing/gloves/yautja/verb/call_combi()
	set name = "Yank Combi-stick"
	set category = "Yautja"
	set desc = "Yank on your combi-stick's chain, if it's in range. Otherwise... recover it yourself."
	. = call_combi_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/call_combi_internal(var/forced = FALSE)
	if(usr.is_mob_incapacitated())
		return 0

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	if(combistick_cooldown)
		to_chat(usr, SPAN_WARNING("Wait a bit before yanking the chain again!"))
		return



	for(var/obj/item/weapon/melee/combistick/C in range(7))
		if(usr.get_active_hand() == C || usr.get_inactive_hand() == C) //Check if THIS combistick is in our hands already.
			continue
		else if(usr.put_in_active_hand(C))//Try putting it in our active hand, or, if it's full...
			if(!drain_power(usr,70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return
			usr.visible_message(SPAN_WARNING("<b>[usr] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
			combistick_cooldown = 1
		else if(usr.put_in_inactive_hand(C))///...Try putting it in our inactive hand.
			if(!drain_power(usr,70)) //We should only drain power if we actually yank the chain back. Failed attempts can quickly drain the charge away.
				return
			usr.visible_message(SPAN_WARNING("<b>[usr] yanks [C]'s chain back!</b>"), SPAN_WARNING("<b>You yank [C]'s chain back!</b>"))
			combistick_cooldown = 1
		else //If neither hand can hold it, you must not have a free hand.
			to_chat(usr, SPAN_WARNING("You need a free hand to do this!</b>"))

	if(combistick_cooldown)
		addtimer(VARSET_CALLBACK(src, combistick_cooldown, FALSE), 3 SECONDS)

/obj/item/clothing/gloves/yautja/proc/translate()
	set name = "Translator"
	set desc = "Emit a message from your bracer to those nearby."
	set category = "Yautja"
	. = translate_internal(FALSE)

/obj/item/clothing/gloves/yautja/proc/translate_internal(var/forced = FALSE)
	if(!usr || usr.stat) return

	if(!forced && !isYautja(usr))
		var/option = should_activate_random_or_this_function()
		if (option == 0)
			to_chat(usr, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return
		if (option == 1)
			. = activate_random_verb()
			return

	var/msg = input(usr,"Your bracer beeps and waits patiently for you to input your message.","Translator","") as text
	if(!msg || !usr.client) return

	msg = sanitize(msg)
	msg = replacetext(msg, "a", "@")
	msg = replacetext(msg, "e", "3")
	msg = replacetext(msg, "i", "1")
	msg = replacetext(msg, "o", "0")
	//msg = replacetext(msg, "u", "^")
	//msg = replacetext(msg, "y", "7")
	//msg = replacetext(msg, "r", "9")
	msg = replacetext(msg, "s", "5")
	//msg = replacetext(msg, "t", "7")
	msg = replacetext(msg, "l", "1")
	//msg = replacetext(msg, "n", "*")
	   //Preds now speak in bastardized 1337speak BECAUSE. -because abby is retarded -spookydonut

	spawn(10)
		if(!drain_power(usr,50))
			return //At this point they've upgraded.

		log_say("Yautja Translator/[usr.client.ckey] : [msg]")

		for(var/mob/Q in hearers(usr))
			if(Q.stat && !isobserver(Q))
				continue //Unconscious
			to_chat(Q, "[SPAN_INFO("A strange voice says")] <span class='prefix'>'[msg]'</span>.")
