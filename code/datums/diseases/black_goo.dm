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
	var/zombie_transforming = 0 //whether we're currently transforming the host into a zombie.
	var/goo_message_cooldown = 0 //to make sure we don't spam messages too often.
	var/stage_counter = 0 // tells a dead infectee their stage, so they can know when-abouts they'll revive

	// set of new var to handle stage progress and
	var/stage_level = 0 // we start at zero when dead everything go twice as fast each stage take 6 min so it need 360 and if your dead it require 180 so 3 min
	var/infection_rate = 1

/datum/disease/black_goo/stage_act()
	..()
	if(!ishuman(affected_mob)) return
	var/mob/living/carbon/human/H = affected_mob

	// check if your already a zombie or in the process of being transform into one...
	if(H.species.name == SPECIES_ZOMBIE || zombie_transforming == TRUE)
		return

	//check if dead
	if(H.stat == DEAD)
		infection_rate = 2

	//check if he isn't dead
	if(H.stat != DEAD)
		infection_rate = 1

	// here we add the new infection rate to the stage level.
	stage_level = stage_level + infection_rate

	//we want to check if we have reach enough stage level to gain a stage
	// change to 60 for testing should be at 360 normaly
	if(stage_level >= 120)
		stage ++
		stage_level = stage_level - 120

	switch(stage)
		//stage 1 : Viatiate "afflicted"
		// goign to keep you feel warm and maybe add you can experience paranoia don't know how?
		if(1)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage One! Zombie transformation begins at Stage Three."))
				stage_counter = stage
			if(goo_message_cooldown < world.time )
				if(prob(5))
					to_chat(affected_mob, SPAN_DANGER("You feel warm..."))//small hint that your infected
					goo_message_cooldown = world.time + 100
				else if(prob(3))
					to_chat(affected_mob, SPAN_DANGER("You can't trust them..."))//try at making you feel paranoic
					goo_message_cooldown = world.time + 100

		//stage 2 : Ague "Febrile"
		//pain fever and the eye will darken ? some veine become dark as the tissue start to necrose
		//maybe febrile seizure due to fever basicly. pain is from necrosis...(witch is not ingame)
		// screaming, seizure from fever fever symptome, pain
		if(2)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Two! Zombie transformation begins at Stage Three."))
				stage_counter = stage
			if(goo_message_cooldown < world.time)
				if (prob(3)) to_chat(affected_mob, SPAN_DANGER("Your throat is really dry..."))
				else if (prob(6)) to_chat(affected_mob, SPAN_DANGER("You feel really warm..."))
				else if (prob(2)) to_chat(affected_mob, SPAN_DANGER("You cough up some black fluid..."))
				else if (prob(2))to_chat(affected_mob, SPAN_DANGER("Your throat is really dry..."))
				else if (prob(2)) H.vomit_on_floor()
				goo_message_cooldown = world.time + 100

		//stage 3 : Lusus "Freak" you turn into a zombie (should be pretty dramatic scream etc... convulsion coma etc...?)
		//you become animalistic husk you will attack everyone on sight some can retain some inteligence (using tools ) maybe just make it justify
		// for them to avoid running to certain death and allow them to be "smart" will staying withing RP///
		// at the end of stage 3 you will be turned into a "zombie"
		if(3)
			//check if your already a zombie just return to avoid weird stuff... if for some weird reason first filter deoesn't work...
			if(H.species.name == SPECIES_ZOMBIE || zombie_transforming == TRUE)
				return

			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Three! Zombie transformation begin!"))
				stage_counter = stage
			//hidden = list(0,0)//why?
			if(!zombie_transforming)
				zombie_transform(H)
			H.next_move_slowdown = max(H.next_move_slowdown, 2)//what is this?
/*shouldn't need this going to test it without it...
		//stage 4 : Lusus "Freak" this part will be to force people to turn in case stage 3 fail
		// safety stage will be remove if nobody reach it in my tests..
		if(4)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Four! Zombie transformation begin!"))
				stage_counter = stage
			if(H.stat == DEAD && stage_counter != stage)
					stage_counter = stage
					if(H.species.name != SPECIES_ZOMBIE && !zombie_transforming)
						to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Five! Your transformation should have happened already, but will be forced now."))
						zombie_transform(H)
			if(!zombie_transforming && prob(50))
				if(H.stat != DEAD)
					var/healamt = 2
					if(H.health < H.maxHealth)
						H.apply_damage(-healamt, BURN)
						H.apply_damage(-healamt, BRUTE)
						H.apply_damage(-healamt, TOX)
						H.apply_damage(-healamt, OXY)
				H.nutrition = NUTRITION_MAX //never hungry
*/
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
		stage = 5
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
