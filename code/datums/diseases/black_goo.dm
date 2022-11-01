//Disease Datum
/datum/disease/black_goo
	name = "Black Goo"
	max_stages = 5
	cure = "Anti-Zed"
	cure_id = "antiZed"
	spread = "Bites"
	spread_type = SPECIAL
	affected_species = list("Human")
	curable = 0
	cure_chance = 100
	desc = ""
	severity = "Medium"
	agent = "Unknown Biological Organism X-65"
	hidden = list(1,0) //Hidden from med-huds, but not pandemic scanners.  BLOOD TESTS FOR THE WIN
	permeability_mod = 2
	stage_prob = 4
	stage_minimum_age = 150
	survive_mob_death = TRUE //FALSE //switch to true to make dead infected humans still transform
	var/zombie_transforming = 0 //whether we're currently transforming the host into a zombie.
	var/goo_message_cooldown = 0 //to make sure we don't spam messages too often.
	var/stage_counter = 0 // tells a dead infectee their stage, so they can know when-abouts they'll revive

/datum/disease/black_goo/stage_act()
	..()
	if(!ishuman(affected_mob)) return
	var/mob/living/carbon/human/H = affected_mob

	if(age > 1.5*stage_minimum_age) stage_prob = 100 //if it takes too long we force a stage increase
	else stage_prob = initial(stage_prob)
	if(H.stat == DEAD) stage_minimum_age = 75 //the virus progress faster when the host is dead.
	switch(stage)
		if(1)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage One! Zombie transformation begins at Stage Four."))
				stage_counter = stage
			survive_mob_death = TRUE //changed because infection rate was REALLY horrible.
			if(goo_message_cooldown < world.time )
				if(prob(3))
					to_chat(affected_mob, SPAN_DANGER("You feel really warm..."))
					goo_message_cooldown = world.time + 100
		if(2)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Two! Zombie transformation begins at Stage Four."))
				stage_counter = stage
			if(goo_message_cooldown < world.time)
				if (prob(3)) to_chat(affected_mob, SPAN_DANGER("Your throat is really dry..."))
				else if (prob(6)) to_chat(affected_mob, SPAN_DANGER("You feel really warm..."))
				else if (prob(2)) H.vomit_on_floor()
				goo_message_cooldown = world.time + 100
		if(3)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Three! Zombie transformation begins at Stage Four, which will be soon."))
				stage_counter = stage
			hidden = list(0,0)
			//survive_mob_death = TRUE //even if host dies now, the transformation will occur.
			H.next_move_slowdown = max(H.next_move_slowdown, 1)
			if(goo_message_cooldown < world.time)
				if (prob(3))
					to_chat(affected_mob, SPAN_DANGER("You cough up some black fluid..."))
					goo_message_cooldown = world.time + 100
				else if (prob(6))
					to_chat(affected_mob, SPAN_DANGER("Your throat is really dry..."))
					goo_message_cooldown = world.time + 100
				else if (prob(9))
					to_chat(affected_mob, SPAN_DANGER("You feel really warm..."))
					goo_message_cooldown = world.time + 100
				else if(prob(5))
					goo_message_cooldown = world.time + 100
					H.vomit_on_floor()
		if(4)
			if(H.stat == DEAD && stage_counter != stage)
				to_chat(H, SPAN_CENTERBOLD("Your zombie infection is now at Stage Four! Your transformation will happen any moment now."))
				stage_counter = stage
			H.next_move_slowdown = max(H.next_move_slowdown, 2)
			if(prob(5) || age >= stage_minimum_age-1)
				if(!zombie_transforming)
					zombie_transform(H)
			else if(prob(5))
				H.vomit_on_floor()
		if(5)
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


/datum/disease/black_goo/proc/zombie_transform(mob/living/carbon/human/human)
	set waitfor = 0
	zombie_transforming = TRUE
	human.vomit_on_floor()
	human.AdjustStunned(5)
	sleep(20)
	human.make_jittery(500)
	sleep(30)
	if(human && human.loc)
		if(human.stat == DEAD)
			human.revive(TRUE)
			var/datum/species/zombie/zombie_species = GLOB.all_species[SPECIES_ZOMBIE]
			zombie_species.handle_alert_ghost(human)
		playsound(human.loc, 'sound/hallucinations/wail.ogg', 25, 1)
		human.jitteriness = 0
		human.set_species(SPECIES_ZOMBIE)
		stage = 5
		human.faction = FACTION_ZOMBIE
		zombie_transforming = FALSE


/obj/item/weapon/zombie_claws
	name = "claws"
	icon = 'icons/mob/humans/species/r_zombie.dmi'
	icon_state = "claw_l"
	flags_item = NODROP|DELONDROP|ITEM_ABSTRACT
	force = 40
	w_class = SIZE_MASSIVE
	sharp = 1
	attack_verb = list("slashed", "torn", "scraped", "gashed", "ripped")
	pry_capable = IS_PRY_CAPABLE_FORCE

/obj/item/weapon/zombie_claws/attack(mob/living/target, mob/living/carbon/human/user)
	if(iszombie(target))
		return FALSE

	. = ..()
	if(.)
		playsound(loc, 'sound/weapons/bladeslice.ogg', 25, 1, 5)

	if(isHumanStrict(target))
		var/mob/living/carbon/human/human = target

		if(locate(/datum/disease/black_goo) in human.viruses)
			to_chat(user, SPAN_XENOWARNING("<b>You sense your target is infected.</b>"))
		else
			var/bio_protected = max(CLOTHING_ARMOR_HARDCORE - human.getarmor(user.zone_selected, ARMOR_BIO), 0)
			if(prob(bio_protected))
				target.AddDisease(new /datum/disease/black_goo)
				to_chat(user, SPAN_XENOWARNING("<b>You sense your target is now infected.</b>"))

	if(isSynth(target))
		target.Slow(2)
	else
		target.Superslow(2) // Make them slower

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

/datum/language/zombie
	name = "Zombie"
	desc = "If you select this from the language screen, expect a ban."
	colour = "zombie"

	speech_verb = "groans"
	ask_verb = "groans"
	exclaim_verb = "groans"

	key = "4"
	flags = RESTRICTED


/obj/item/clothing/glasses/zombie_eyes
	name = "zombie eyes"
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
