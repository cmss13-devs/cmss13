
/////////////////////////Food Reagents////////////////////////////
// Part of the food code. Nutriment is used instead of the old "heal_amt" code. Also is where all the food
// 	condiments, additives, and such go.

/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 6)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(prob(50)) M.heal_limb_damage(1,0)
		M.nutrition += nutriment_factor	// For hunger and fatness
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.blood_volume < BLOOD_VOLUME_NORMAL)
				C.blood_volume += 0.4


/datum/reagent/lipozine
	name = "Lipozine" // The anti-nutriment.
	id = "lipozine"
	description = "Lowers satiation and reduces body weight by increasing ketosis and the rate of which fat is metabolized. Use to treat obesity. Large doses can cause extreme weight loss."
	reagent_state = LIQUID
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#BBEDA4" // rgb: 187, 237, 164
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_NUTRITIOUS = -4)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition = max(M.nutrition - nutriment_factor, 0)
		M.overeatduration = 0
		if(M.nutrition < 0)//Prevent from going into negatives.
			M.nutrition = 0

	on_overdose(mob/living/M)
		M.apply_damages(1, 1) //Causes chemical burns and structural damage

	on_overdose_critical(mob/living/M)
		M.apply_damages(4, 4) //Causes massive burns and structural damage

/datum/reagent/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0
	chemclass = CHEM_CLASS_RARE

/datum/reagent/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup is a sweet and tangy sauce typically made from tomatoes, sugar, and vinegar, with assorted seasonings and spices."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8
	chemclass = CHEM_CLASS_RARE

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "Capsaicin is a chili pepper extract with analgesic properties. Capsaicin is a neuropeptide releasing agent selective for primary sensory peripheral neurons."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 1)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!M)
			M = holder.my_atom
		if(!data)
			data = 1
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.species && !(H.species.flags & (NO_PAIN|IS_SYNTHETIC)) )
				switch(data)
					if(1 to 2)
						to_chat(H, SPAN_DANGER("<b>Your insides feel uncomfortably hot !</b>"))
					if(2 to 20)
						if(prob(5))
							to_chat(H, SPAN_DANGER("<b>Your insides feel uncomfortably hot !</b>"))
					if(20 to INFINITY)
						H.apply_effect(2,AGONY,0)
						if(prob(5))
							H.visible_message(SPAN_WARNING("[H] [pick("dry heaves!","coughs!","splutters!")]"))
							to_chat(H, SPAN_DANGER("<b>You feel like your insides are burning !</b>"))
		holder.remove_reagent("frostoil", 5)
		holder.remove_reagent(src.id, FOOD_METABOLISM)
		data++

/datum/reagent/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 2)
	spray_warning = TRUE

/datum/reagent/condensedcapsaicin/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if(!istype(M, /mob/living) || has_species(M,"Horror"))
		return

	if(method == TOUCH)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = M
			var/trained_human = FALSE
			if(skillcheck(victim, SKILL_POLICE, SKILL_POLICE_MP))
				trained_human = TRUE

			if(trained_human)
				victim.eye_blurry = max(M.eye_blurry, 5)
				to_chat(victim, SPAN_WARNING("Your training protects you from the pepperspray!"))
				return

			if(!(victim.species && (victim.species.flags & NO_PAIN)))
				victim.emote("scream")
				to_chat(victim, SPAN_WARNING("You're sprayed directly in the eyes with pepperspray!"))
				victim.eye_blurry = max(M.eye_blurry, 25)
				victim.eye_blind = max(M.eye_blind, 10)
				victim.Stun(3)
				victim.KnockDown(3)

/datum/reagent/condensedcapsaicin/on_mob_life(mob/living/M)
	. = ..()
	if(!.) 
		return
	if(!M)
		M = holder.my_atom
	if(!data)
		data = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && !(H.species.flags & (NO_PAIN|IS_SYNTHETIC)) )
			switch(data)
				if(1)
					to_chat(H, SPAN_DANGER("<b>You feel like your insides are burning !</b>"))
				if(2 to INFINITY)
					H.apply_effect(4,AGONY,0)
					if(prob(5))
						H.visible_message(SPAN_WARNING("[H] [pick("dry heaves!","coughs!","splutters!")]"))
						to_chat(H, SPAN_DANGER("<b>You feel like your insides are burning !</b>"))
	holder.remove_reagent("frostoil", 5)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	data++

/datum/reagent/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPOTHERMIC = 6)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!M)
			M = holder.my_atom
		M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
		M.recalculate_move_delay = TRUE
		if(prob(1))
			M.emote("shiver")
		holder.remove_reagent("capsaicin", 5)
		holder.remove_reagent(src.id, FOOD_METABOLISM)

/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = "#ffff00"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON

	on_overdose(mob/living/M)
		M.confused = max(M.confused, 20)
		if(prob(10))
			M.emote(pick("sigh","grumble","frown"))

	on_overdose_critical(mob/living/M)
		M.make_jittery(5) //Turn super salty
		M.knocked_out = max(M.knocked_out, 20)
		if(prob(10))
			M.emote(pick("cry","moan","pain"))

/datum/reagent/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "Black pepper is the world's most traded spice, and is one of the most common spices added to cuisines around the world. Its spiciness is due to the chemical compound piperine, which is a different kind of spicy from the capsaicin characteristic of chili peppers."
	reagent_state = SOLID
	chemclass = CHEM_CLASS_RARE
	// no color (ie, black)

/datum/reagent/coco
	name = "Coco Powder"
	id = "coco"
	description = "The cocoa bean or simply cocoa, which is also called the cacao bean or cacao, is the dried and fully fermented seed of Theobroma cacao, from which cocoa solids and cocoa butter can be extracted. "
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "Psilocybin is a naturally occurring psychedelic prodrug compound produced by more than 200 species of mushrooms, collectively known as psilocybin mushrooms or Magic Mushrooms."
	color = "#E700E7" // rgb: 231, 0, 231
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.druggy = max(M.druggy, 30)
		if(!data) data = 1
		switch(data)
			if(1 to 5)
				if(!M.stuttering) M.stuttering = 1
				M.make_dizzy(5)
				if(prob(10)) M.emote(pick("twitch","giggle"))
			if(5 to 10)
				if(!M.stuttering) M.stuttering = 1
				M.make_jittery(10)
				M.make_dizzy(10)
				M.druggy = max(M.druggy, 35)
				if(prob(20)) M.emote(pick("twitch","giggle"))
			if(10 to INFINITY)
				if(!M.stuttering) M.stuttering = 1
				M.make_jittery(20)
				M.make_dizzy(20)
				M.druggy = max(M.druggy, 40)
				if(prob(30)) M.emote(pick("twitch","giggle"))
		holder.remove_reagent(src.id, 0.2)
		data++

	on_overdose(mob/living/M)
		M.apply_damage(1, TOX) //Overdose starts getting bad
		M.knocked_out = max(M.knocked_out, 20)

	on_overdose_critical(mob/living/M)
		M.apply_damage(4, TOX) //Overdose starts getting bad
		M.knocked_out = max(M.knocked_out, 20)
		M.drowsyness = max(M.drowsyness, 30)

/datum/reagent/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FF00FF" // rgb: 255, 0, 255

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor

/datum/reagent/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	reagent_state = LIQUID
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor

	reaction_turf(var/turf/T, var/volume)
		if(!istype(T)) return
		src = null
		if(volume >= 3)
			T.wet_floor(FLOOR_WET_WATER)

/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	reagent_state = LIQUID
	color = "#365E30" // rgb: 54, 94, 48
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE

	on_overdose(mob/living/M)
		M.apply_damage(1, BURN) //Causes chemical burns

	on_overdose_critical(mob/living/M)
		M.apply_damages(5, BURN) //Causes massive burns

/datum/reagent/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor

/datum/reagent/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor
		if(M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
			M.bodytemperature = min(310, M.bodytemperature + (10 * TEMPERATURE_DAMAGE_COEFFICIENT))
			M.recalculate_move_delay = TRUE

/datum/reagent/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor
		M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
		M.recalculate_move_delay = TRUE

/datum/reagent/rice
	name = "Rice"
	id = "rice"
	description = "The most widely consumed staple food on Earth. Rice is the most important grain with regard to human nutrition and caloric intake."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor

/datum/reagent/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Sweet jelly made from the cherry fruit."
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#801E28" // rgb: 128, 30, 40

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.nutrition += nutriment_factor

/datum/reagent/honey
	name = "Honey"
	id = "honey"
	description = "Honey is a natural sweet, viscous food substance composed of mainly fructose and glucose."
	color = "#FFFF00"
	chemclass = CHEM_CLASS_RARE