/*
Ideas for the subtle effects of hallucination:

Light up oxygen/phoron indicators (done)
Cause health to look critical/dead, even when standing (done)
Characters silently watching you
Brief flashes of fire/space/bombs/c4/dangerous shit (done)
Items that are rare/traitorous/don't exist appearing in your inventory slots (done)
Strange audio (should be rare) (done)
Gunshots/explosions/opening doors/less rare audio (done)

*/

/mob/living/carbon
	var/image/halimage
	var/image/halbody
	var/obj/halitem
	var/hal_screwyhud = 0 //1 - critical, 2 - dead, 3 - oxygen indicator, 4 - toxin indicator
	var/handling_hal = FALSE
	var/hal_crit = FALSE
	COOLDOWN_DECLARE(give_item_cooldown)

/mob/living/carbon/proc/handle_hallucinations()
	if(handling_hal)
		return
	handling_hal = TRUE
	addtimer(CALLBACK(src, PROC_REF(do_hallucination)), rand(20 SECONDS,50 SECONDS)/(hallucination/25))

/mob/living/carbon/proc/do_hallucination()
	if(!hallucination)
		handling_hal = FALSE
		return
	var/halpick = rand(1,100)
	if(!client || !hud_used?.ui_datum)
		handling_hal = FALSE
		return
	switch(halpick)
		if(0 to 15)
			//Screwy HUD
			//to_chat(src, "Screwy HUD.")
			hal_screwyhud = pick(1,2,3,3,4,4)
			addtimer(VARSET_CALLBACK(src,hal_screwyhud, 0), rand(10 SECONDS, 25 SECONDS))
		if(16 to 25)
			//Strange items
			//to_chat(src, "Traitor Items.")
			if(!halitem)
				halitem = new
				var/datum/custom_hud/ui_datum = hud_used.ui_datum
				var/list/slots_free = list(ui_datum.ui_lhand, ui_datum.ui_rhand)
				if(l_hand)
					slots_free -= ui_datum.ui_lhand
				if(r_hand)
					slots_free -= ui_datum.ui_rhand
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					if(!H.belt)
						slots_free += ui_datum.ui_belt
					if(!H.l_store)
						slots_free += ui_datum.ui_storage1
					if(!H.r_store)
						slots_free += ui_datum.ui_storage2
				if(length(slots_free))
					halitem.screen_loc = pick(slots_free)
					halitem.layer = 50
					switch(rand(1,6))
						if(1) //revolver
							halitem.icon = 'icons/obj/items/weapons/guns/guns_by_faction/USCM/revolvers.dmi'
							halitem.icon_state = "m44r"
							halitem.name = "Revolver"
						if(2) //c4
							halitem.icon = 'icons/obj/items/assemblies.dmi'
							halitem.icon_state = "plastic-explosive0"
							halitem.name = "Mysterious Package"
							if(prob(25))
								halitem.icon_state = "c4small_1"
						if(3) //sword
							halitem.icon = 'icons/obj/items/weapons/melee/swords.dmi'
							halitem.icon_state = "sword1"
							halitem.name = "Sword"
						if(4) //stun baton
							halitem.icon = 'icons/obj/items/weapons/melee/non_lethal.dmi'
							halitem.icon_state = "stunbaton"
							halitem.name = "Stun Baton"
						if(5) //emag
							halitem.icon = 'icons/obj/items/card.dmi'
							halitem.icon_state = "emag"
							halitem.name = "Cryptographic Sequencer"
						if(6) //flashbang
							halitem.icon = 'icons/obj/items/weapons/grenade.dmi'
							halitem.icon_state = "flashbang1"
							halitem.name = "Flashbang"
					if(client)
						client.add_to_screen(halitem)
					var/time_to_wait = rand(1 SECONDS, 5 SECONDS) //Only seen for a brief moment.
					// We use timers here because then being deleted will cancel them and avoid causing harddels.
					addtimer(CALLBACK(client, TYPE_PROC_REF(/client, remove_from_screen), halitem), time_to_wait)
					addtimer(VARSET_CALLBACK(src, halitem, null), time_to_wait)
					QDEL_IN(halitem, time_to_wait) // it's an object and so needs to be deleted
		if(26 to 40)
			//Flashes of danger
			//to_chat(src, "Danger Flash")
			if(!halimage)
				var/list/possible_points = list()
				for(var/turf/open/floor/F in view(src,GLOB.world_view_size))
					possible_points += F
				if(length(possible_points))
					var/turf/open/floor/target = pick(possible_points)

					switch(rand(1,3))
						if(1)
							//to_chat(src, "Space")
							halimage = image('icons/turf/floors/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
						if(2)
							//to_chat(src, "Fire")
							halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
						if(3)
							//to_chat(src, "C4")
							halimage = image('icons/obj/items/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)

					if(client)
						client.images += halimage
					var/time_to_wait = rand(1 SECONDS, 5 SECONDS) //Only seen for a brief moment.
					// We use timers here because then being deleted will cancel them and avoid causing harddels.
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_client), halimage, client), time_to_wait)
					addtimer(VARSET_CALLBACK(src, halimage, null), time_to_wait)
		if(41 to 65)
			//Strange audio
			//to_chat(src, "Strange Audio.")
			switch(rand(1,12))
				if(1)
					src << 'sound/machines/airlock.ogg'
				if(2)
					src << pick('sound/effects/Explosion1.ogg', 'sound/effects/Explosion2.ogg')
				if(3)
					src << 'sound/effects/explosionfar.ogg'
				if(4)
					src << 'sound/effects/Glassbr1.ogg'
				if(5)
					src << 'sound/effects/Glassbr2.ogg'
				if(6)
					src << 'sound/effects/Glassbr3.ogg'
				if(7)
					src << 'sound/machines/twobeep.ogg'
				if(8)
					src << 'sound/machines/windowdoor.ogg'
				if(9)
					//To make it more realistic, I added two gunshots (enough to kill)
					src << 'sound/weapons/Gunshot.ogg'
					spawn(rand(1 SECONDS,3 SECONDS))
						src << 'sound/weapons/Gunshot.ogg'
				if(10)
					src << 'sound/weapons/smash.ogg'
				if(11)
					//Same as above, but with tasers.
					src << 'sound/weapons/Taser.ogg'
					spawn(rand(1 SECONDS,3 SECONDS))
						src << 'sound/weapons/Taser.ogg'
			//Rare audio
				if(12)
//These sounds are (mostly) taken from Hidden: Source
					var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
						'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
						'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
						'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
						'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
					src << pick(creepyasssounds)
		if(66 to 70)
			//Flashes of danger
			//to_chat(src, "Danger Flash")
			if(!halbody)
				var/list/possible_points = list()
				for(var/turf/open/floor/F in view(src,GLOB.world_view_size))
					possible_points += F
				if(length(possible_points))
					var/turf/open/floor/target = pick(possible_points)
					switch(rand(1,3))
						if(1)
							halbody = image('icons/mob/humans/human.dmi',target,"husk_l",TURF_LAYER)
						if(2,3)
							halbody = image('icons/mob/humans/human.dmi',target,"husk_s",TURF_LAYER)
					if(client)
						client.images += halbody
					var/time_to_wait = rand(5 SECONDS, 8 SECONDS) //Only seen for a brief moment.
					// We use timers here because then being deleted will cancel them and avoid causing harddels.
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_client), halbody, client), time_to_wait)
					addtimer(VARSET_CALLBACK(src, halbody, null), time_to_wait)
		if(71 to 72)
			//Fake death
			sleeping = 2 SECONDS
			hal_crit = TRUE
			hal_screwyhud = TRUE
			var/time_to_wait = rand(5 SECONDS, 10 SECONDS)
			addtimer(VARSET_CALLBACK(src,hal_screwyhud, 0), time_to_wait)
			addtimer(VARSET_CALLBACK(src,hal_crit, 0), time_to_wait)
			addtimer(VARSET_CALLBACK(src,sleeping, 0), time_to_wait)
	handling_hal = FALSE

/obj/effect/fake_attacker
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	opacity = FALSE
	health = 100
	var/datum/weakref/weak_target = null
	var/weapon_name = null
	var/list/copied_attack_verbs
	var/image/currentimage = null
	var/image/left
	var/image/right
	var/image/up
	var/image/down
	var/collapse
	var/skipped_last_turn = FALSE
	// seconds per tile, to convert to pixels per second do world.icon_size/move_delay
	var/move_delay = 2

/obj/effect/fake_attacker/attackby(obj/item/P as obj, mob/user as mob)
	if(user.weak_reference != weak_target)
		return
	step_away(src,user,2,world.icon_size/move_delay)
	for(var/mob/M in oviewers(GLOB.world_view_size,user))
		to_chat(M, SPAN_WARNING("<B>[user] flails around wildly.</B>"))
	user << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
	user.show_message(SPAN_DANGER("<B>[src] has been attacked by [user] </B>"), SHOW_MESSAGE_VISIBLE) //Lazy.
	src.health -= P.force

/obj/effect/fake_attacker/Crossed(mob/M, somenumber)
	if(M.weak_reference != weak_target)
		return
	step_away(src,M,2,world.icon_size/move_delay)
	if(prob(30))
		for(var/mob/O in oviewers(GLOB.world_view_size, M))
			to_chat(O, SPAN_DANGER("<B>[M] stumbles around.</B>"))

/obj/effect/fake_attacker/Initialize(mapload, mob/target_to_use, mob/living/carbon/human/clone, clone_weapon_name, attack_verbs_to_copy)
	. = ..()
	if(!target_to_use || !clone)
		return INITIALIZE_HINT_QDEL
	QDEL_IN(src, 30 SECONDS)
	weak_target = WEAKREF(target_to_use)
	name = clone.name
	weapon_name = clone_weapon_name
	copied_attack_verbs = attack_verbs_to_copy
	move_delay = clone.move_delay
	// target must be set before we call updateimage
	left = image(clone, dir = WEST)
	right = image(clone, dir = EAST)
	up = image(clone, dir = NORTH)
	down = image(clone, dir = SOUTH)
	updateimage()
	step_away(src, target_to_use, 2,world.icon_size/move_delay)
	START_PROCESSING(SSfastobj, src)

/obj/effect/fake_attacker/Destroy()
	var/mob/living/carbon/human/my_target = weak_target.resolve()
	if(my_target)
		remove_image_from_client(currentimage, my_target.client)
		my_target.hallucinations -= src
	currentimage = null
	left = null
	right = null
	up = null
	down = null
	return ..()

/obj/effect/fake_attacker/proc/updateimage()
	var/mob/living/carbon/human/my_target = weak_target.resolve()
	if(!my_target)
		qdel(src)
		return
	my_target.client?.images -= currentimage
	switch(dir)
		if(NORTH)
			currentimage = new /image(up,src)
		if(SOUTH)
			currentimage = new /image(down,src)
		if(EAST)
			currentimage = new /image(right,src)
		if(WEST)
			currentimage = new /image(left,src)
	if(collapse)
		currentimage.transform = currentimage.transform.Turn(90)
	my_target << currentimage

/obj/effect/fake_attacker/process()
	var/mob/living/carbon/human/my_target = weak_target.resolve()
	if(!my_target) // they vanished on us!
		qdel(src)
		return PROCESS_KILL
	if(health < 0)
		collapse()
		animate(src, alpha = 0, time = 1 SECONDS)
		QDEL_IN_CLIENT_TIME(src, 1 SECONDS)
		return PROCESS_KILL // dead!
	if(!skipped_last_turn && prob(50)) // The old one would wait either 0.5 or 1 second, we always wait 0.5, so we skip sometimes.
		skipped_last_turn = TRUE
		return
	skipped_last_turn = FALSE
	if(get_dist(src,my_target) > 1)
		var/true_direction = get_dir(src,my_target) // can be diagonal
		var/cardinal_direction = true_direction & -(true_direction) // gets the first-set bit
		setDir(cardinal_direction)
		step_towards(src,my_target,world.icon_size/move_delay)
		updateimage()
		return

	if(prob(15))
		var/hit_zone = rand_zone()
		if(weapon_name)
			my_target << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
			var/verb_to_use = "attacked"
			if(LAZYLEN(copied_attack_verbs))
				verb_to_use = pick(copied_attack_verbs)
			my_target.show_message(SPAN_DANGER("<B>[my_target] has been [verb_to_use] with [weapon_name] in the [parse_zone(hit_zone)] by [src.name].</B>"), SHOW_MESSAGE_VISIBLE)
			my_target.halloss += 8
			if(prob(20))
				my_target.AdjustEyeBlur(3)
			if(prob(33))
				if(!locate(/obj/effect/overlay) in my_target.loc)
					fake_blood(my_target)
		else
			my_target << sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
			my_target.show_message(SPAN_DANGER("<B>[src.name] has punched [my_target]!</B>"), SHOW_MESSAGE_VISIBLE)
			my_target.halloss += 4
			if(prob(33))
				if(!locate(/obj/effect/overlay) in my_target.loc)
					fake_blood(my_target)

	if(prob(15)) // if we're adjacent we have a chance to move away
		step_away(src,my_target,2,world.icon_size/move_delay)

/obj/effect/fake_attacker/proc/collapse()
	collapse = TRUE
	updateimage()

// not actually visible, has a per-client override
/obj/effect/overlay/fake_blood
	name = "blood"
	// not visible to anyone, it's just overridden by the object

/proc/fake_blood(mob/target)
	var/obj/effect/overlay/fake_blood/O = new/obj/effect/overlay/fake_blood(target.loc)
	var/image/I = image('icons/effects/blood.dmi',O,"mfloor[rand(1,7)]", dir = O.dir, layer = ABOVE_WEED_LAYER)
	I.color = /obj/effect/decal/cleanable/blood::basecolor // it's greyscale now
	I.override = TRUE
	target << I
	QDEL_IN(O, 30 SECONDS)

GLOBAL_LIST_INIT(non_fakeattack_weapons, list(/obj/item/device/aicard,\
	/obj/item/clothing/shoes/magboots, /obj/item/disk/nuclear,\
	/obj/item/clothing/suit/space/uscm, /obj/item/tank))

/proc/fake_attack(mob/living/target)
	var/list/possible_clones = new/list()
	var/mob/living/carbon/human/clone = null
	var/clone_weapon = null

	for(var/mob/living/carbon/human/H in GLOB.alive_human_list)
		if(H.stat)
			continue
		possible_clones += H

	if(!length(possible_clones))
		return
	clone = pick(possible_clones)
	if(!clone)
		return

	var/list/attack_verbs_to_copy
	if(clone.l_hand && !is_type_in_list(clone.l_hand, GLOB.non_fakeattack_weapons))
		clone_weapon = clone.l_hand.name
		attack_verbs_to_copy = clone.l_hand.attack_verb
	else if(clone.r_hand && !is_type_in_list(clone.r_hand, GLOB.non_fakeattack_weapons))
		clone_weapon = clone.r_hand.name
		attack_verbs_to_copy = clone.r_hand.attack_verb
	new /obj/effect/fake_attacker(target.loc, target, clone, clone_weapon, attack_verbs_to_copy)
