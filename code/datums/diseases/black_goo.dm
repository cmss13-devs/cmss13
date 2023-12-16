//Disease Datum
/datum/disease/black_goo
	name = "Black Goo"
	max_stages = 3
	cure = "Anti-Zed"
	cure_id = "antiZed"
	spread = "Bites"
	spread_type = SPECIAL
	affected_species = list("Human")
	cure_chance = 100 //meaning the cure will kill the virus asap
	severity = "Medium"
	agent = "Unknown Biological Organism X-65"
	hidden = list(1,0) //Hidden from med-huds, but not pandemic scanners.  BLOOD TESTS FOR THE WIN
	permeability_mod = 2
	survive_mob_death = TRUE //We want the dead to turn into zombie.
	longevity = 500 //the virus tend to die before the dead is turn into zombie this should fix it.
	stage_prob = 0//no randomness

	/// whether we're currently transforming the host into a zombie.
	var/zombie_transforming = 0
	/// tells a dead infectee their stage, so they can know when-abouts they'll revive
	var/stage_counter = 0

//new variables to handle infection progression inside a stage.

	/// variable that contain accumulated virus progression for an host.
	var/stage_level = 0
	/// variable that handle passive increase of the virus of an host.
	var/infection_rate = 1

	///the number of stage level needed to pass another stage.
	var/stage_level_check = 360

	/// cooldown between each check to see if we display a symptome idea is to get 60s between symptome atleast.
	var/message_cooldown_time = 1 MINUTES
	COOLDOWN_DECLARE(goo_message_cooldown)

/datum/disease/black_goo/stage_act()
	..()
	if(!ishuman(affected_mob)) return
	var/mob/living/carbon/human/H = affected_mob

	// check if your already a zombie or in the process of being transform into one...
	if(iszombie(H))
		return

	// check if dead
	if(H.stat == DEAD)
		infection_rate = 4

	// check if he isn't dead
	if(H.stat != DEAD)
		infection_rate = 1

	// here we add the new infection rate to the stage level.
	stage_level += infection_rate

	// we want to check if we have reach enough stage level to gain a stage 3 stage of 6 min if you get it once.
	if(stage_level >= stage_level_check)
		stage++
		stage_level -= stage_level_check

	switch(stage)
		if(1)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at stage one! Zombie transformation begins at stage three."))
				stage_counter = stage

			if (!COOLDOWN_FINISHED(src, goo_message_cooldown))
				return
			COOLDOWN_START(src, goo_message_cooldown, message_cooldown_time)

			switch(rand(0, 100))
				if(0 to 25)
					return
				if(25 to 75)
					to_chat(affected_mob, SPAN_DANGER("You feel warm..."))
					stage_level += 9
				if(75 to 95)
					to_chat(affected_mob, SPAN_DANGER("Your throat is really dry..."))
					stage_level += 18
				if(95 to 100)
					to_chat(affected_mob, SPAN_DANGER("You can't trust them..."))
					stage_level += 36

		if(2)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at stage two! Zombie transformation begins at stage three."))
				stage_counter = stage

			if (!COOLDOWN_FINISHED(src, goo_message_cooldown))
				return
			COOLDOWN_START(src, goo_message_cooldown, message_cooldown_time)

			switch(rand(0, 100))
				if(0 to 25)
					return
				if(25 to 50)
					to_chat(affected_mob, SPAN_DANGER("You can't trust them..."))
					stage_level += 5
				if(50 to 75)
					to_chat(affected_mob, SPAN_DANGER("You feel really warm..."))
					stage_level += 9
				if(75 to 85)
					to_chat(affected_mob, SPAN_DANGER("Your throat is really dry..."))
					stage_level += 18
				if(85 to 95)
					H.vomit_on_floor()
					stage_level += 36
				if(95 to 100)
					to_chat(affected_mob, SPAN_DANGER("You cough up some black fluid..."))
					stage_level += 42

		if(3)
			//check if your already a zombie just return to avoid weird stuff... if for some weird reason first filter deoesn't work...
			if(iszombie(H))
				return

			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at stage three! Zombie transformation begin!"))
				stage_counter = stage
			hidden = list(0,0)
			if(!zombie_transforming)
				zombie_transform(H)
			H.next_move_slowdown = max(H.next_move_slowdown, 2)

/datum/disease/black_goo/proc/zombie_transform(mob/living/carbon/human/human)
	set waitfor = 0
	zombie_transforming = TRUE
	human.vomit_on_floor()
	human.adjust_effect(5, STUN)
	sleep(20)
	human.make_jittery(500)
	sleep(30)
	if(human && human.loc)
		if(human.stat == DEAD)
			human.revive(TRUE)
			human.remove_language(LANGUAGE_ENGLISH) // You lose the ability to understand english. Language processing is handled in the mind not the body.
			var/datum/species/zombie/zombie_species = GLOB.all_species[SPECIES_ZOMBIE]
			zombie_species.handle_alert_ghost(human)
		playsound(human.loc, 'sound/hallucinations/wail.ogg', 25, 1)
		human.jitteriness = 0
		human.set_species(SPECIES_ZOMBIE)
		stage = 3
		human.faction = FACTION_ZOMBIE
		zombie_transforming = FALSE


/obj/item/weapon/zombie_claws
	gender = PLURAL
	name = "claws"
	icon = 'icons/mob/humans/species/r_zombie.dmi'
	icon_state = "claw_l"
	flags_item = NODROP|DELONDROP|ITEM_ABSTRACT
	force = MELEE_FORCE_TIER_6 //slightly higher than normal
	w_class = SIZE_MASSIVE
	sharp = 1
	attack_verb = list("slashed", "torn", "scraped", "gashed", "ripped")
	pry_capable = IS_PRY_CAPABLE_FORCE

/obj/item/weapon/zombie_claws/attack(mob/living/target, mob/living/carbon/human/user)
	if(iszombie(target))
		return FALSE

	. = ..()
	if(!.)
		return FALSE
	playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

	if(ishuman_strict(target))
		var/mob/living/carbon/human/human = target

		if(locate(/datum/disease/black_goo) in human.viruses)
			to_chat(user, SPAN_XENOWARNING("<b>You sense your target is infected.</b>"))
		else
			var/bio_protected = max(CLOTHING_ARMOR_HARDCORE - human.getarmor(user.zone_selected, ARMOR_BIO), 0)
			if(prob(bio_protected))
				target.AddDisease(new /datum/disease/black_goo)
				to_chat(user, SPAN_XENOWARNING("<b>You sense your target is now infected.</b>"))

	target.apply_effect(2, SLOW)

/obj/item/weapon/zombie_claws/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(get_dist(src, O) > 1)
		return
	if(istype(O, /obj/structure/machinery/door/airlock))
		var/obj/structure/machinery/door/airlock/D = O
		if(!D.density)
			return
		if(D.heavy)
			to_chat(usr, SPAN_DANGER("[D] is too heavy to be forced open."))
			return FALSE
		if(user.action_busy || user.a_intent == INTENT_HARM)
			return

		user.visible_message(SPAN_DANGER("[user] jams their [name] into [O] and strains to rip it open."),
		SPAN_DANGER("You jam your [name] into [O] and strain to rip it open."))
		playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, 1)
		if(do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			if(!D.density)
				return

			user.visible_message(SPAN_DANGER("[user] forces [O] open with their [name]."),
			SPAN_DANGER("You force [O] open with your [name]."))
			D.open(1)

	else if(istype(O, /obj/structure/mineral_door/resin))
		var/obj/structure/mineral_door/resin/D = O
		if(D.isSwitchingStates) return
		if(!D.density || user.action_busy || user.a_intent == INTENT_HARM)
			return
		user.visible_message(SPAN_DANGER("[user] jams their [name] into [D] and strains to rip it open."),
		SPAN_DANGER("You jam your [name] into [D] and strain to rip it open."))
		playsound(user, 'sound/weapons/wristblades_hit.ogg', 15, TRUE)
		if(do_after(user, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE) && D.density)
			user.visible_message(SPAN_DANGER("[user] forces [D] open with their [name]."),
			SPAN_DANGER("You force [D] open with your [name]."))
			D.Open()

/obj/item/reagent_container/food/drinks/bottle/black_goo
	name = "strange bottle"
	desc = "A strange bottle of unknown origin."
	icon = 'icons/obj/items/black_goo_stuff.dmi'
	icon_state = "blackgoo"
	garbage = FALSE

/obj/item/reagent_container/food/drinks/bottle/black_goo/Initialize()
	. = ..()
	reagents.add_reagent("blackgoo", 30)


/obj/item/reagent_container/food/drinks/bottle/black_goo_cure
	name = "even stranger bottle"
	desc = "A bottle of black labeled CURE..."
	icon = 'icons/obj/items/black_goo_stuff.dmi'
	icon_state = "blackgoo"

/obj/item/reagent_container/food/drinks/bottle/black_goo_cure/Initialize()
	. = ..()
	reagents.add_reagent("antiZed", 30)

/obj/item/reagent_container/glass/bottle/labeled_black_goo_cure
	name = "\"Pathogen\" cure bottle"
	desc = "The bottle has a biohazard symbol on the front, and has a label, designating its use against Agent A0-3959X.91–15, colloquially known as the \"Black Goo\"."
	icon_state = "bottle20"

/obj/item/reagent_container/glass/bottle/labeled_black_goo_cure/Initialize()
	. = ..()
	reagents.add_reagent("antiZed", 60)

/datum/language/zombie
	name = "Zombie"
	desc = "A growling, guttural method of communication, only Zombies seem to be capable of producing these sounds."
	speech_verb = "growls"
	ask_verb = "grumbles"
	exclaim_verb = "snarls"
	color = "monkey"
	key = "h"
	flags = RESTRICTED

/datum/language/zombie/scramble(input)
	return pick("Urrghh...", "Rrraaahhh...", "Aaaarghhh...", "Mmmrrrgggghhh...", "Huuuuhhhh...", "Sssssgrrrr...")

/obj/item/clothing/glasses/zombie_eyes
	name = "zombie eyes"
	gender = PLURAL
	icon_state = "stub"
	item_state = "BLANK"
	w_class = SIZE_SMALL
	vision_flags = SEE_MOBS
	darkness_view = 7
	flags_item = NODROP|DELONDROP|ITEM_ABSTRACT
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE


/obj/item/storage/fancy/blackgoo
	icon = 'icons/obj/items/black_goo_stuff.dmi'
	icon_state = "goobox"
	icon_type = "goo"
	name = "strange canister"
	desc = "A strange looking metal container."
	storage_slots = 3
	can_hold = list(/obj/item/reagent_container/food/drinks/bottle/black_goo)

/obj/item/storage/fancy/blackgoo/get_examine_text(mob/user)
	. = ..()
	. += "A strange looking metal container..."
	if(contents.len <= 0)
		. += "There are no bottles left inside it."
	else if(contents.len == 1)
		. += "There is one bottle left inside it."
	else
		. += "There are [src.contents.len] bottles inside the container."


/obj/item/storage/fancy/blackgoo/Initialize()
	. = ..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/reagent_container/food/drinks/bottle/black_goo(src)
	return
