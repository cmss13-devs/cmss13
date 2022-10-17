

//Xeno-style acids
//Ideally we'll consolidate all the "effect" objects here
//Also need to change the icons
/obj/effect/xenomorph
	name = "alien thing"
	desc = "You shouldn't be seeing this."
	unacidable = TRUE
	icon = 'icons/mob/hostiles/Effects.dmi'
	layer = FLY_LAYER

/obj/effect/xenomorph/splatter
	name = "splatter"
	desc = "It burns! It burns like hygiene!"
	icon_state = "splatter"
	density = 0
	opacity = 0
	anchored = 1

/obj/effect/xenomorph/splatter/New() //Self-deletes after creation & animation
	..()
	QDEL_IN(src, 8)


/obj/effect/xenomorph/splatterblob
	name = "splatter"
	desc = "It burns! It burns like hygiene!"
	icon_state = "acidblob"
	density = 0
	opacity = 0
	anchored = 1

/obj/effect/xenomorph/splatterblob/New() //Self-deletes after creation & animation
	..()
	QDEL_IN(src, 40)


/obj/effect/xenomorph/spray
	name = "splatter"
	desc = "It burns! It burns like hygiene!"
	icon_state = "acid2"
	density = 0
	opacity = 0
	anchored = 1
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = 0
	var/datum/cause_data/cause_data

	var/hivenumber = XENO_HIVE_NORMAL

	var/stun_duration = 1
	var/damage_amount = 20
	var/fire_level_to_extinguish = 13

	var/time_to_live = 10

/obj/effect/xenomorph/spray/no_stun
	stun_duration = 0

/obj/effect/xenomorph/spray/Initialize(mapload, new_cause_data, var/hive) //Self-deletes
	. = ..()

	// Stats tracking
	cause_data = new_cause_data

	if(hive)
		hivenumber = hive

	// check what's in our turf
	for(var/atom/atm in loc)

		// Other acid sprays? delete ourself
		if (atm != src && istype(atm, /obj/effect/xenomorph/spray))
			return INITIALIZE_HINT_QDEL

		// Flamer fire?
		if(istype(atm, /obj/flamer_fire))
			var/obj/flamer_fire/FF = atm
			if((FF.firelevel > fire_level_to_extinguish) && (!FF.fire_variant)) //If fire_variant = 0, default fire extinguish behavior.
				FF.firelevel -= fire_level_to_extinguish
				FF.update_flame()
			else
				switch(FF.fire_variant)
					if(FIRE_VARIANT_TYPE_B) //Armor Shredding Greenfire, extinguishes faster.
						if(FF.firelevel > 3*fire_level_to_extinguish)
							FF.firelevel -= 3*fire_level_to_extinguish
							FF.update_flame()
						else qdel(atm)
					else
						qdel(atm)
			continue

		if (istype(atm, /obj/structure/barricade))
			var/obj/structure/barricade/B = atm
			B.acid_spray_act()
			continue

		if(istype(atm, /obj/effect/alien/weeds/))
			var/obj/effect/alien/weeds/W = atm

			if( !W.linked_hive || W.linked_hive.hivenumber != hivenumber )
				W.acid_spray_act()
				continue

		// Humans?
		if(isliving(atm)) //For extinguishing mobs on fire
			var/mob/living/M = atm
			M.ExtinguishMob()
			if(M.stat == DEAD) // NO. DAMAGING. DEAD. MOBS.
				continue
			if (iscarbon(M))
				var/mob/living/carbon/C = M
				if (C.ally_of_hivenumber(hivenumber))
					continue

				apply_spray(M)
				M.apply_armoured_damage(damage_amount, ARMOR_BIO, BURN) // Deal extra damage when first placing ourselves down.

			continue

		if(isVehicleMultitile(atm))
			var/obj/vehicle/multitile/V = atm
			V.handle_acidic_environment(src)
			continue

	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, .proc/die), time_to_live)
	animate(src, time_to_live, alpha = 128)

/obj/effect/xenomorph/spray/Destroy()
	STOP_PROCESSING(SSobj, src)
	cause_data = null
	return ..()

/obj/effect/xenomorph/spray/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_ACID_SPRAY

/obj/effect/xenomorph/spray/proc/die()
	STOP_PROCESSING(SSobj, src)
	qdel(src)

/obj/effect/xenomorph/spray/Crossed(AM as mob|obj)
	..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H.ally_of_hivenumber(hivenumber))
			return
		apply_spray(AM)
	else if (isXeno(AM))
		var/mob/living/carbon/Xenomorph/X = AM
		if (X.hivenumber != hivenumber)
			apply_spray(AM)
	else if(isVehicleMultitile(AM))
		var/obj/vehicle/multitile/V = AM
		V.handle_acidic_environment(src)

//damages human that comes in contact
/obj/effect/xenomorph/spray/proc/apply_spray(mob/living/carbon/H, should_stun = TRUE)

	if(!H.lying)
		to_chat(H, SPAN_DANGER("Your feet scald and burn! Argh!"))
		if(ishuman(H))
			H.emote("pain")
			if(should_stun)
				H.KnockDown(stun_duration)
			H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "l_foot")
			H.apply_armoured_damage(damage_amount * 0.4, ARMOR_BIO, BURN, "r_foot")

		else if (isXeno(H))
			var/mob/living/carbon/Xenomorph/X = H
			if (X.mob_size < MOB_SIZE_BIG && should_stun)
				X.KnockDown(stun_duration)
			X.emote("hiss")
			H.apply_armoured_damage(damage_amount * 0.4 * XVX_ACID_DAMAGEMULT, ARMOR_BIO, BURN)

		H.last_damage_data = cause_data
		H.UpdateDamageIcon()
		H.updatehealth()
	else
		H.apply_armoured_damage(damage_amount*0.33, ARMOR_BIO, BURN) //This is ticking damage!
		to_chat(H, SPAN_DANGER("You are scalded by the burning acid!"))

/obj/effect/xenomorph/spray/weak
	name = "weak splatter"
	desc = "It burns! It burns, but not as much!"
	icon_state = "acid2-weak"

	stun_duration = 1
	damage_amount = 20
	fire_level_to_extinguish = 6
	time_to_live = 6

	var/bonus_damage = 5

/obj/effect/xenomorph/spray/strong
	name = "strong splatter"
	desc = "It burns a lot!"
	icon_state = "acid2-strong"

	stun_duration = 2
	damage_amount = 30
	fire_level_to_extinguish = 18
	time_to_live = 3 SECONDS
	// Stuns for 2 seconds, lives for 3 seconds. Seems to stun longer than it lives for at 2 seconds

/obj/effect/xenomorph/spray/strong/no_stun
	stun_duration = 0

/obj/effect/xenomorph/spray/weak/apply_spray(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/damage = damage_amount

		var/should_stun = FALSE
		for (var/datum/effects/acid/A in H.effects_list)
			should_stun = TRUE
			damage += (-1*(A.duration - A.original_duration))*(A.damage_in_total_human/A.original_duration)
			damage += bonus_damage

			qdel(A)
			break

		to_chat(H, SPAN_DANGER("Your feet scald and burn! Argh!"))
		H.emote("pain")
		if (should_stun && !H.lying)
			H.KnockDown(stun_duration)
		H.last_damage_data = cause_data
		H.apply_armoured_damage(damage_amount * 0.5, ARMOR_BIO, BURN, "l_foot", 50)
		H.apply_armoured_damage(damage_amount * 0.5, ARMOR_BIO, BURN, "r_foot", 50)
		H.UpdateDamageIcon()
		H.updatehealth()
	else if (isXeno(M))
		..(M, FALSE)

/obj/effect/xenomorph/spray/praetorian
	name = "splatter"
	desc = "It burns! It burns like hygiene!"
	icon_state = "acid2"
	damage_amount = 12
	stun_duration = 0

/obj/effect/xenomorph/spray/praetorian/apply_spray(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/datum/effects/prae_acid_stacks/PAS = locate() in H.effects_list

		if(!PAS)
			PAS = new /datum/effects/prae_acid_stacks(H)
			PAS.increment_stack_count()
		else
			PAS.increment_stack_count(2)

		if(!H.lying)
			to_chat(H, SPAN_DANGER("Your feet scald and burn! Argh!"))
			H.emote("pain")
			H.last_damage_data = cause_data
			H.apply_armoured_damage(damage_amount * 0.5, ARMOR_BIO, BURN, "l_foot", 50)
			H.apply_armoured_damage(damage_amount * 0.5, ARMOR_BIO, BURN, "r_foot", 50)
			H.UpdateDamageIcon()
			H.updatehealth()
		else
			H.apply_armoured_damage(damage_amount*0.33, ARMOR_BIO, BURN) //This is ticking damage!
			to_chat(H, SPAN_DANGER("You are scalded by the burning acid!"))
	else if (isXeno(M))
		..(M)

//Medium-strength acid
/obj/effect/xenomorph/acid
	name = "acid"
	desc = "Burbling corrosive stuff. I wouldn't want to touch it."
	icon_state = "acid_normal"
	density = 0
	opacity = 0
	anchored = 1
	unacidable = TRUE
	var/atom/acid_t
	var/ticks = 0
	var/acid_strength = 1 //100% speed, normal
	var/barricade_damage = 40
	var/barricade_damage_ticks = 10 // tick is once per 5 seconds. This tells us how many times it will try damaging barricades

//Sentinel weakest acid
/obj/effect/xenomorph/acid/weak
	name = "weak acid"
	acid_strength = 2.5 //250% normal speed
	barricade_damage = 20
	icon_state = "acid_weak"

//Superacid
/obj/effect/xenomorph/acid/strong
	name = "strong acid"
	acid_strength = 0.4 //20% normal speed
	barricade_damage = 100
	icon_state = "acid_strong"

/obj/effect/xenomorph/acid/New(loc, target)
	..(loc)
	acid_t = target
	var/strength_t = isturf(acid_t) ? 8:4 // Turf take twice as long to take down.
	tick(strength_t)

/obj/effect/xenomorph/acid/Destroy()
	acid_t = null
	. = ..()

/obj/effect/xenomorph/acid/proc/handle_barricade()
	var/obj/structure/barricade/cade = acid_t
	if(istype(cade))
		cade.take_acid_damage(barricade_damage)

/obj/effect/xenomorph/acid/proc/tick(strength_t)
	set waitfor = 0
	if(!acid_t || !acid_t.loc)
		qdel(src)
		return

	if(istype(acid_t,/obj/structure/barricade))
		if(++ticks >= barricade_damage_ticks)
			visible_message(SPAN_XENOWARNING("Acid on \The [acid_t] subsides!"))
			qdel(src)
			return
		handle_barricade()
		sleep(50)
		.()
		return

	if(++ticks >= strength_t)
		visible_message(SPAN_XENODANGER("[acid_t] collapses under its own weight into a puddle of goop and undigested debris!"))
		playsound(src, "acid_hit", 25, TRUE)

		if(istype(acid_t, /turf))
			if(istype(acid_t, /turf/closed/wall))
				var/turf/closed/wall/W = acid_t
				new /obj/effect/acid_hole (W)
			else
				var/turf/T = acid_t
				T.ScrapeAway()
		else if (istype(acid_t, /obj/structure/girder))
			var/obj/structure/girder/G = acid_t
			G.dismantle()
		else if(istype(acid_t, /obj/structure/window/framed))
			var/obj/structure/window/framed/WF = acid_t
			WF.drop_window_frame()
		else if(istype(acid_t,/obj/item/explosive/plastic))
			qdel(acid_t)

		else
			if(acid_t.contents.len) //Hopefully won't auto-delete things inside melted stuff..
				for(var/mob/M in acid_t.contents)
					if(acid_t.loc) M.forceMove(acid_t.loc)
			QDEL_NULL(acid_t)

		qdel(src)
		return

	switch(strength_t - ticks)
		if(6) visible_message(SPAN_XENOWARNING("\The [acid_t] is barely holding up against the acid!"))
		if(4) visible_message(SPAN_XENOWARNING("\The [acid_t]\s structure is being melted by the acid!"))
		if(2) visible_message(SPAN_XENOWARNING("\The [acid_t] is struggling to withstand the acid!"))
		if(0 to 1) visible_message(SPAN_XENOWARNING("\The [acid_t] begins to crumble under the acid!"))

	sleep(rand(200,300) * (acid_strength))
	.()



/obj/effect/xenomorph/boiler_bombard
	name = "???"
	desc = ""
	icon_state = "boiler_bombard"
	mouse_opacity = 0

	// Config-ish values
	var/damage = 20
	var/time_before_smoke = 35
	var/time_before_damage = 25
	var/smoke_duration = 9
	var/smoke_type = /obj/effect/particle_effect/smoke/xeno_burn

	var/mob/living/carbon/Xenomorph/source_xeno = null

/obj/effect/xenomorph/boiler_bombard/New(loc, source_xeno = null)
	// Hopefully we don't get insantiated in these places anyway..
	if (isXeno(source_xeno))
		src.source_xeno = source_xeno

	if (isturf(loc))
		var/turf/T = loc
		if (!T.density)
			..(loc)
		else
			qdel(src)
	else
		qdel(src)

	addtimer(CALLBACK(src, .proc/damage_mobs), time_before_damage)
	addtimer(CALLBACK(src, .proc/make_smoke), time_before_smoke)

/obj/effect/xenomorph/boiler_bombard/proc/damage_mobs()
	if (!istype(src) || !isturf(loc))
		qdel(src)
		return
	for (var/mob/living/carbon/H in loc)
		if (isXeno(H))
			if(!source_xeno)
				continue

			var/mob/living/carbon/Xenomorph/X = H
			if (source_xeno.can_not_harm(X))
				continue

		if (!H.stat)
			if(source_xeno.can_not_harm(H))
				continue
			H.apply_armoured_damage(damage, ARMOR_BIO, BURN)
			animation_flash_color(H)
			to_chat(H, SPAN_XENODANGER("You are scalded by acid as a massive glob explodes nearby!"))

	icon_state = "boiler_bombard_heavy"

/obj/effect/xenomorph/boiler_bombard/proc/make_smoke()
	var/obj/effect/particle_effect/smoke/S = new smoke_type(loc, 1, create_cause_data(initial(source_xeno?.caste_type), source_xeno))
	S.time_to_live = smoke_duration
	S.spread_speed = smoke_duration + 5 // No spreading

	qdel(src)

/obj/effect/xenomorph/xeno_telegraph
	name = "???"
	desc = ""
	icon_state = "xeno_telegraph_red"
	mouse_opacity = 0

/obj/effect/xenomorph/xeno_telegraph/New(loc, ttl = 10)
	..(loc)
	QDEL_IN(src, ttl)

/obj/effect/xenomorph/xeno_telegraph/red
	icon_state = "xeno_telegraph_red"

/obj/effect/xenomorph/xeno_telegraph/brown
	icon_state = "xeno_telegraph_brown"

/obj/effect/xenomorph/xeno_telegraph/green
	icon_state = "xeno_telegraph_green"

/obj/effect/xenomorph/xeno_telegraph/brown/abduct_hook
	icon_state = "xeno_telegraph_abduct_hook"

/obj/effect/xenomorph/xeno_telegraph/brown/lash
	icon_state = "xeno_telegraph_lash"



/obj/effect/xenomorph/acid_damage_delay
	name = "???"
	desc = ""
	icon_state = "boiler_bombard"
	mouse_opacity = 0

	var/damage = 20
	var/message = null
	var/mob/living/carbon/Xenomorph/linked_xeno = null
	var/hivenumber = XENO_HIVE_NORMAL
	var/empowered = FALSE

/obj/effect/xenomorph/acid_damage_delay/New(loc, damage = 20, delay = 10, empowered = FALSE, message = null, mob/living/carbon/Xenomorph/linked_xeno = null)
	..(loc)

	addtimer(CALLBACK(src, .proc/die), delay)
	src.damage = damage
	src.message = message
	src.linked_xeno = linked_xeno
	if(src.linked_xeno)
		hivenumber = src.linked_xeno.hivenumber
	if(empowered)
		icon_state = "boiler_bombard_danger"
		src.empowered = empowered

/obj/effect/xenomorph/acid_damage_delay/proc/deal_damage()
	var/xeno_empower_modifier = 1
	var/immobilized_multiplier = 1.45
	if(empowered)
		xeno_empower_modifier = 1.25
	for (var/mob/living/carbon/H in loc)
		if (H.stat == DEAD)
			continue

		if(H.ally_of_hivenumber(hivenumber))
			continue

		animation_flash_color(H)

		if(isXeno(H))
			H.apply_armoured_damage(damage * XVX_ACID_DAMAGEMULT * xeno_empower_modifier, ARMOR_BIO, BURN)
		else
			if(empowered)
				new /datum/effects/acid(H, linked_xeno, initial(linked_xeno.caste_type))
			var/found = null
			for (var/datum/effects/boiler_trap/F in H.effects_list)
				if (F.cause_data && F.cause_data.resolve_mob() == linked_xeno)
					found = F
					break
			if(found)
				H.apply_armoured_damage(damage*immobilized_multiplier, ARMOR_BIO, BURN)
			else
				H.apply_armoured_damage(damage, ARMOR_BIO, BURN)

		if (message)
			to_chat(H, SPAN_XENODANGER(message))

		. = TRUE

/obj/effect/xenomorph/acid_damage_delay/proc/die()
	deal_damage()
	qdel(src)

/obj/effect/xenomorph/acid_damage_delay/boiler_landmine

/obj/effect/xenomorph/acid_damage_delay/boiler_landmine/deal_damage()
	var/total_hits = 0
	for (var/obj/structure/barricade/B in loc)
		B.take_acid_damage(damage*(1.15 + 0.55 * empowered))

	for (var/mob/living/carbon/H in loc)
		if (H.stat == DEAD)
			continue

		if(H.ally_of_hivenumber(hivenumber))
			continue

		total_hits++

	var/datum/action/xeno_action/activable/boiler_trap/trap = get_xeno_action_by_type(linked_xeno, /datum/action/xeno_action/activable/boiler_trap)

	trap.reduce_cooldown(total_hits*4 SECONDS)

	return ..()
