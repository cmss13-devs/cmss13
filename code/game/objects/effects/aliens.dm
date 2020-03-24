

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
	flags_pass = PASS_FLAGS_ACID_SPRAY
	var/acid_strength = 1
	var/source_mob
	var/source_name

/obj/effect/xenomorph/spray/New(loc, var/acid_level = 1, var/new_source_name, var/new_source_mob) //Self-deletes
	..(loc)
	if(new_source_mob)
		source_mob = new_source_mob
	if(new_source_name)
		source_name = new_source_name
	else
		source_name = initial(name)
	for(var/atom/atm in loc)
		if(istype(atm, /obj/flamer_fire))
			var/obj/flamer_fire/FF = atm
			if(FF.firelevel > 13)
				FF.firelevel -= 13
				FF.updateicon()
			else
				qdel(atm)
			continue
		if(isliving(atm)) //For extinguishing mobs on fire
			var/mob/living/M = atm
			M.ExtinguishMob()
			for(var/obj/item/clothing/mask/cigarette/C in M.contents)
				if(C.item_state == C.icon_on)
					C.die()
	acid_strength = acid_level
	processing_objects.Add(src)
	spawn(30 + rand(0, 20))
		processing_objects.Remove(src)
		qdel(src)
		return

/obj/effect/xenomorph/spray/Crossed(AM as mob|obj)
	..()
	if(ishuman(AM))
		apply_spray(AM)

//damages human that comes in contact
/obj/effect/xenomorph/spray/proc/apply_spray(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!H.lying)
		to_chat(H, SPAN_DANGER("Your feet scald and burn! Argh!"))
		H.emote("pain")
		H.KnockDown(1)
		H.last_damage_mob = source_mob
		H.last_damage_source = source_name
		var/obj/limb/affecting = H.get_limb("l_foot")
		if(istype(affecting) && affecting.take_damage(0, acid_strength*rand(5, 10)))
			H.UpdateDamageIcon()
		affecting = H.get_limb("r_foot")
		if(istype(affecting) && affecting.take_damage(0, acid_strength*rand(5, 10)))
			H.UpdateDamageIcon()
		H.updatehealth()
	else
		H.adjustFireLoss(acid_strength*rand(2, 5)) //This is ticking damage!
		to_chat(H, SPAN_DANGER("You are scalded by the burning acid!"))

/obj/effect/xenomorph/spray/process()
	var/turf/T = loc
	if(!istype(T))
		processing_objects.Remove(src)
		qdel(src)
		return

	for(var/mob/living/carbon/human/H in loc)
		apply_spray(H)

/obj/effect/xenomorph/spray/weak //Weaker spitter acid spray.
	name = "weak splatter"
	desc = "It burns! It burns, but not as much!"
	icon_state = "acid2-weak"
	density = 0
	opacity = 0
	anchored = 1
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = 0

/obj/effect/xenomorph/spray/weak/New(loc, var/acid_level = 1, var/new_source_name, var/new_source_mob) //Self-deletes
	..(loc)
	if(new_source_mob)
		source_mob = new_source_mob
	if(new_source_name)
		source_name = new_source_name
	else
		source_name = initial(name)
	for(var/atom/atm in loc)
		if(istype(atm, /obj/flamer_fire))
			var/obj/flamer_fire/FF = atm
			if(FF.firelevel > 6)
				FF.firelevel -= 6
				FF.updateicon()
			else
				qdel(atm)
			continue
		if(isliving(atm)) //For extinguishing mobs on fire
			var/mob/living/M = atm
			M.ExtinguishMob()
			for(var/obj/item/clothing/mask/cigarette/C in M.contents)
				if(C.item_state == C.icon_on)
					C.die()
	acid_strength = acid_level
	processing_objects.Add(src)
	spawn(25 + rand(0, 10))
		processing_objects.Remove(src)
		qdel(src)
		return

/obj/effect/xenomorph/spray/weak/Crossed(AM as mob|obj)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(!H.lying)
			to_chat(H, SPAN_DANGER("Your feet scald and burn!"))
			H.emote("pain")
			H.KnockDown(0.1)
			var/obj/limb/affecting = H.get_limb("l_foot")
			H.last_damage_mob = source_mob
			H.last_damage_source = source_name
			if(istype(affecting) && affecting.take_damage(0, acid_strength*rand(2, 7)))
				H.UpdateDamageIcon()
			affecting = H.get_limb("r_foot")
			if(istype(affecting) && affecting.take_damage(0, acid_strength*rand(2, 7)))
				H.UpdateDamageIcon()
			H.updatehealth()
		else
			H.adjustFireLoss(acid_strength*rand(2, 5)) //This is ticking damage!
			to_chat(H, SPAN_DANGER("You are scalded by the hot acid!"))

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

//Sentinel weakest acid
/obj/effect/xenomorph/acid/weak
	name = "weak acid"
	acid_strength = 2.5 //250% normal speed
	icon_state = "acid_weak"

//Superacid
/obj/effect/xenomorph/acid/strong
	name = "strong acid"
	acid_strength = 0.4 //20% normal speed
	icon_state = "acid_strong"

/obj/effect/xenomorph/acid/New(loc, target)
	..(loc)
	acid_t = target
	var/strength_t = isturf(acid_t) ? 8:4 // Turf take twice as long to take down.
	tick(strength_t)

/obj/effect/xenomorph/acid/Dispose()
	acid_t = null
	. = ..()

/obj/effect/xenomorph/acid/proc/tick(strength_t)
	set waitfor = 0
	if(!acid_t || !acid_t.loc)
		qdel(src)
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