//Disease Datum
#define ZOMBIE_INFECTION_STAGE_ONE 1
#define ZOMBIE_INFECTION_STAGE_TWO 2
#define ZOMBIE_INFECTION_STAGE_THREE 3
#define ZOMBIE_INFECTION_STAGE_FOUR 4
#define SLOW_INFECTION_RATE 1
#define FAST_INFECTION_RATE 7
#define STAGE_LEVEL_THRESHOLD 360
#define MESSAGE_COOLDOWN_TIME 1 MINUTES

/datum/disease/black_goo
	name = "Black Goo"
	max_stages = 4
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

	/// boolean value to determine if the mob is currently transforming into a zombie.
	var/zombie_is_transforming = FALSE

	/// variable to keep track of the stage level, used to prevent the stage message from being displayed more than once for any given stage.
	var/stage_counter = 0

//new variables to handle infection progression inside a stage.

	/// variable that contains accumulated virus progression for a host. Iterates to a value above 360 and is then reset.
	var/stage_level = 0

	/// variable that handles passive increase of the virus of a host.
	var/infection_rate = SLOW_INFECTION_RATE

	/// cooldown for the living mob's symptom messages
	COOLDOWN_DECLARE(goo_message_cooldown)

/datum/disease/black_goo/stage_act()
	..()
	if(!ishuman_strict(affected_mob))
		return
	var/mob/living/carbon/human/infected_mob = affected_mob

	if(iszombie(infected_mob))
		return

	// infection rate is faster for dead mobs
	if(infected_mob.stat == DEAD)
		infection_rate = FAST_INFECTION_RATE

	// standard infection rate for living mobs
	if(infected_mob.stat != DEAD)
		infection_rate = SLOW_INFECTION_RATE

	stage_level += infection_rate

	// resets the stage_level once it passes the threshold.
	if(stage_level >= STAGE_LEVEL_THRESHOLD)
		stage++
		stage_level = stage_level % STAGE_LEVEL_THRESHOLD

	switch(stage)
		if(ZOMBIE_INFECTION_STAGE_ONE)
			if(infected_mob.stat == DEAD && stage_counter != stage)
				to_chat(infected_mob, SPAN_CENTERBOLD("Your zombie infection is now at stage one! Zombie transformation begins at stage three."))
				stage_counter = stage

			// dead mobs should not have symptoms, because... they are dead.
			if(infected_mob.stat != DEAD)
				if (!COOLDOWN_FINISHED(src, goo_message_cooldown))
					return
				COOLDOWN_START(src, goo_message_cooldown, MESSAGE_COOLDOWN_TIME)

				switch(rand(0, 100))
					if(0 to 25)
						return
					if(25 to 75)
						to_chat(infected_mob, SPAN_DANGER("You feel warm..."))
						stage_level += 9
					if(75 to 95)
						to_chat(infected_mob, SPAN_DANGER("Your throat is really dry..."))
						stage_level += 18
					if(95 to 100)
						to_chat(infected_mob, SPAN_DANGER("You can't trust them..."))
						stage_level += 36

		if(ZOMBIE_INFECTION_STAGE_TWO)
			if(infected_mob.stat == DEAD && stage_counter != stage)
				to_chat(infected_mob, SPAN_CENTERBOLD("Your zombie infection is now at stage two! Zombie transformation begins at stage three."))
				stage_counter = stage

			if(infected_mob.stat != DEAD)
				if (!COOLDOWN_FINISHED(src, goo_message_cooldown))
					return
				COOLDOWN_START(src, goo_message_cooldown, MESSAGE_COOLDOWN_TIME)

				switch(rand(0, 100))
					if(0 to 25)
						return
					if(25 to 50)
						to_chat(infected_mob, SPAN_DANGER("You can't trust them..."))
						stage_level += 5
					if(50 to 75)
						to_chat(infected_mob, SPAN_DANGER("You feel really warm..."))
						stage_level += 9
					if(75 to 85)
						to_chat(infected_mob, SPAN_DANGER("Your throat is really dry..."))
						stage_level += 18
					if(85 to 95)
						infected_mob.vomit_on_floor()
						stage_level += 36
					if(95 to 100)
						to_chat(infected_mob, SPAN_DANGER("You cough up some black fluid..."))
						stage_level += 42

		if(ZOMBIE_INFECTION_STAGE_THREE)
			// if zombie or transforming we upgrade it to stage four.
			if(iszombie(infected_mob))
				stage++
				return
			// if not a zombie(above check) and isn't transforming then we transform you into a zombie.
			if(!zombie_is_transforming)
				// if your dead we inform you that you're going to turn into a zombie.
				if(infected_mob.stat == DEAD && stage_counter != stage)
					to_chat(infected_mob, SPAN_CENTERBOLD("Your zombie infection is now at stage three! Zombie transformation begin!"))
					stage_counter = stage
				zombie_transform(infected_mob)
				hidden = list(0,0)
				infected_mob.next_move_slowdown = max(infected_mob.next_move_slowdown, 2)

		if(ZOMBIE_INFECTION_STAGE_FOUR)
			return
			// final stage of infection it's to avoid running the above test once you're a zombie for now. maybe more later.

/datum/disease/black_goo/proc/zombie_transform(mob/living/carbon/human/human)
	set waitfor = 0
	zombie_is_transforming = TRUE
	human.vomit_on_floor()
	human.adjust_effect(5, STUN)
	sleep(20)
	human.make_jittery(500)
	sleep(30)
	if(human && human.loc)
		if(human.buckled)
			human.buckled.unbuckle()
		if(human.stat == DEAD)
			human.revive(TRUE)
			human.remove_language(LANGUAGE_ENGLISH) // You lose the ability to understand english. Language processing is handled in the mind not the body.
			var/datum/species/zombie/zombie_species = GLOB.all_species[SPECIES_ZOMBIE]
			zombie_species.handle_alert_ghost(human)
		playsound(human.loc, 'sound/hallucinations/wail.ogg', 25, 1)
		human.jitteriness = 0
		human.set_species(SPECIES_ZOMBIE)
		stage = 4
		human.faction = FACTION_ZOMBIE
		zombie_is_transforming = FALSE


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

#undef ZOMBIE_INFECTION_STAGE_ONE
#undef ZOMBIE_INFECTION_STAGE_TWO
#undef ZOMBIE_INFECTION_STAGE_THREE
#undef ZOMBIE_INFECTION_STAGE_FOUR
#undef STAGE_LEVEL_THRESHOLD
#undef SLOW_INFECTION_RATE
#undef FAST_INFECTION_RATE
#undef MESSAGE_COOLDOWN_TIME
