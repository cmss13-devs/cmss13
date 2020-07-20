

//Xeno-style acids
//Ideally we'll consolidate all the "effect" objects here
//Also need to change the icons
/obj/effect/xenomorph
	name = "alien thing"
	desc = "You shouldn't be seeing this."
	icon = 'icons/mob/xenos/effects.dmi'
	unacidable = TRUE
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
	var/source_mob
	var/source_name

	var/hivenumber = XENO_HIVE_NORMAL

	var/stun_duration = 1
	var/damage_amount = 25
	var/fire_level_to_extinguish = 13
	
	var/time_to_live = 10

/obj/effect/xenomorph/spray/New(loc, var/new_source_name, var/new_source_mob) //Self-deletes
	..(loc)
	
	// Stats tracking
	if(new_source_mob)
		source_mob = new_source_mob
		if (isXeno(source_mob))
			var/mob/living/carbon/Xenomorph/X = source_mob
			hivenumber = X.hivenumber
	if(new_source_name)
		source_name = new_source_name
	else
		source_name = initial(name)

	// check what's in our turf
	for(var/atom/atm in loc)
		
		// Other acid sprays? delete ourself
		if (atm != src && istype(atm, /obj/effect/xenomorph/spray))
			qdel(src)
			return

		// Flamer fire?
		if(istype(atm, /obj/flamer_fire))
			var/obj/flamer_fire/FF = atm
			if(FF.firelevel > fire_level_to_extinguish)
				FF.firelevel -= fire_level_to_extinguish
				FF.updateicon()
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
			if (ishuman(M) || isXeno(M))
				var/mob/living/carbon/Xenomorph/X = M
				if (istype(X) && X.hivenumber == hivenumber)
					continue
				apply_spray(M)
				M.apply_armoured_damage(damage_amount, ARMOR_BIO, BURN) // Deal extra damage when first placing ourselves down.

			continue
			
	processing_objects.Add(src)
	add_timer(CALLBACK(src, .proc/die), time_to_live)

/obj/effect/xenomorph/spray/initialize_pass_flags()
	..()
	flags_pass = SETUP_LIST_FLAGS(PASS_FLAGS_ACID_SPRAY)

/obj/effect/xenomorph/spray/proc/die()
	processing_objects.Remove(src)
	qdel(src)
	return

/obj/effect/xenomorph/spray/Crossed(AM as mob|obj)
	..()
	if(ishuman(AM))
		apply_spray(AM)
	else if (isXeno(AM))
		var/mob/living/carbon/Xenomorph/X = AM
		if (X.hivenumber != hivenumber)
			apply_spray(AM)

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

		H.last_damage_mob = source_mob
		H.last_damage_source = source_name
		H.UpdateDamageIcon()
		H.updatehealth()
	else
		H.apply_armoured_damage(damage_amount*0.33, ARMOR_BIO, BURN) //This is ticking damage!
		to_chat(H, SPAN_DANGER("You are scalded by the burning acid!"))

/obj/effect/xenomorph/spray/process()
	var/turf/T = loc
	if(!istype(T))
		die()
		return

	for(var/mob/living/carbon/human/H in loc)
		apply_spray(H)

/obj/effect/xenomorph/spray/spitter
	name = "weak splatter"
	desc = "It burns! It burns, but not as much!"
	icon_state = "acid2-weak"

	stun_duration = 1
	damage_amount = 20
	fire_level_to_extinguish = 6
	time_to_live = 6

	var/bonus_damage = 25

/obj/effect/xenomorph/spray/spitter/apply_spray(mob/living/carbon/M)
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
		H.last_damage_mob = source_mob
		H.last_damage_source = source_name
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

	stun_duration = 0

/obj/effect/xenomorph/spray/praetorian/apply_spray(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		var/found = FALSE
		for (var/datum/effects/prae_acid_stacks/PAS in H.effects_list)
			PAS.increment_stack_count()
			found = TRUE
			break

		if (!found)
			new /datum/effects/prae_acid_stacks(H)

		if(!H.lying)
			to_chat(H, SPAN_DANGER("Your feet scald and burn! Argh!"))
			H.emote("pain")
			H.last_damage_mob = source_mob
			H.last_damage_source = source_name
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

/obj/effect/xenomorph/acid/Dispose()
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
		playsound(src, "acid_hit", 25)

		if(istype(acid_t, /turf))
			if(istype(acid_t, /turf/closed/wall))
				var/turf/closed/wall/W = acid_t
				new /obj/effect/acid_hole (W)
			else
				var/turf/T = acid_t
				T.ChangeTurf(/turf/open/floor/plating)
		else if (istype(acid_t, /obj/structure/girder))
			var/obj/structure/girder/G = acid_t
			G.dismantle()
		else if(istype(acid_t, /obj/structure/window/framed))
			var/obj/structure/window/framed/WF = acid_t
			WF.drop_window_frame()
		else if(istype(acid_t,/obj/item/explosive/plastique))
			acid_t.Dispose()

		else
			if(acid_t.contents.len) //Hopefully won't auto-delete things inside melted stuff..
				for(var/mob/M in acid_t.contents)
					if(acid_t.loc) M.forceMove(acid_t.loc)
				for(var/obj/item/document_objective/O in acid_t.contents)
					if(acid_t.loc) O.forceMove(acid_t.loc)
			qdel(acid_t)
			acid_t = null

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

	add_timer(CALLBACK(src, .proc/damage_mobs), time_before_damage)
	add_timer(CALLBACK(src, .proc/make_smoke), time_before_smoke)

/obj/effect/xenomorph/boiler_bombard/proc/damage_mobs()
	if (!istype(src) || !isturf(loc))
		qdel(src)
		return
	for (var/mob/living/carbon/H in loc)
		if (isXeno(H))
			if(!source_xeno)
				continue

			var/mob/living/carbon/Xenomorph/X = H
			if (X.hivenumber == source_xeno.hivenumber)
				continue

		if (!H.stat)
			H.apply_armoured_damage(damage, ARMOR_BIO, BURN)
			animation_flash_color(H)
			to_chat(H, SPAN_XENODANGER("You are scalded by acid as a massive glob explodes nearby!"))

	icon_state = "boiler_bombard_heavy"

/obj/effect/xenomorph/boiler_bombard/proc/make_smoke()
	var/obj/effect/particle_effect/smoke/S = new smoke_type(loc, 1, source_xeno, source_xeno)
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



/obj/effect/xenomorph/acid_damage_delay
	name = "???"
	desc = ""
	icon_state = "boiler_bombard"
	mouse_opacity = 0

	var/damage = 20
	var/message = null
	var/mob/living/carbon/Xenomorph/linked_xeno = null
	var/hivenumber = XENO_HIVE_NORMAL

/obj/effect/xenomorph/acid_damage_delay/New(loc, damage = 20, delay = 10, message = null, mob/living/carbon/Xenomorph/linked_xeno = null)
	..(loc)
	add_timer(CALLBACK(src, .proc/die), delay)
	src.damage = damage
	src.message = message
	src.linked_xeno = linked_xeno
	if(src.linked_xeno)
		hivenumber = src.linked_xeno.hivenumber

/obj/effect/xenomorph/acid_damage_delay/proc/deal_damage()
	for (var/mob/living/carbon/H in loc)
		if (H.stat == DEAD)
			continue

		if(isXeno(H))
			var/mob/living/carbon/Xenomorph/X = H
			if (X.hivenumber == hivenumber)
				continue

		animation_flash_color(H)

		if(isXeno(H))
			H.apply_armoured_damage(damage * XVX_ACID_DAMAGEMULT, ARMOR_BIO, BURN)
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
	for (var/obj/structure/barricade/B in loc)
		B.take_acid_damage(damage*1.0)

	return ..()

