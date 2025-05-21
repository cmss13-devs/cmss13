

//*****************************************************************************************************/
//****************************************Food Reagents************************************************/
//*****************************************************************************************************/
// Part of the food code. Nutriment is used instead of the old "heal_amt" code. Also is where all the food
// condiments, additives, and such go.

/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NEOGENETIC = 1, PROPERTY_NUTRITIOUS = 2, PROPERTY_HEMOGENIC = 1)
	flags = REAGENT_SCANNABLE

/datum/reagent/nutriment/egg
	name = "Egg"
	id = "egg"
	description = "The contents of an egg. Salmonella not included."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/tofu
	name = "Tofu"
	id = "tofu"
	description = "Meat substitute."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/cheese
	name = "Cheese"
	id = "cheese"
	description = "This used to be milk."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/meat
	name = "Meat Protein"
	id = "meatprotein"
	description = "Proteins found in various types of meat."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/meat/fish
	name = "Fish Meat"
	id = "fish"
	description = "It used to swim."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown
	name = "Plant Matter"
	id = "plantmatter"
	description = "Some sort of plant."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown/vegetable
	name = "Vegetable"
	id = "vegetable"
	description = "Some sort of vegetable."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown/fruit
	name = "Fruit"
	id = "fruit"
	description = "Some sort of fruit."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/grown/mushroom
	name = "Mushroom"
	id = "mushroom"
	description = "Some sort of fungus."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/dough
	name = "Dough"
	id = "dough"
	description = "Wet flour."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/dough/bread
	name = "Bread"
	id = "bread"
	description = "Cooked bread."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/dough/noodles
	name = "Noodles"
	id = "noodles"
	description = "Cooked noodles."
	flags = REAGENT_NO_GENERATION

/datum/reagent/nutriment/nuts
	name = "Nuts"
	id = "nuts"
	description = "Some sort of grinded nut, smells like almonds."
	flags = REAGENT_NO_GENERATION


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
	properties = list(PROPERTY_KETOGENIC = 4)

/datum/reagent/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup is a sweet and tangy sauce typically made from tomatoes, sugar, and vinegar, with assorted seasonings and spices."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/vegemite
	name = "Vegemite"
	id = "vegemite"
	description = "A thick yeast extract food spread, salty, slightly bitter, malty, and has an umami flavour similar to beef bouillon, with a hint of radiation."
	reagent_state = LIQUID
	nutriment_factor = 7 * REAGENTS_METABOLISM
	color = "#312007" // rgb: 115, 16, 8
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NUTRITIOUS = 3)
	flags = REAGENT_NO_GENERATION

/datum/reagent/vegemite/reaction_mob(mob/target_mob, method=TOUCH, volume, permeable)
	if(target_mob.faction != FACTION_TWE)
		to_chat(target_mob, (SPAN_ALERTWARNING("God... it's disgusting... eating that was not a good idea.")))

/datum/reagent/vegemite/on_mob_life(mob/living/carbon/target_mob, potency = 1, delta_time)
	. = ..()
	if(!.)
		return
	if(prob(4) && ishuman(target_mob) && target_mob.faction != FACTION_TWE)
		var/mob/living/carbon/human/target_human = target_mob
		target_mob.make_dizzy(10)
		target_human.vomit()

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "Capsaicin is a chili pepper extract with analgesic properties. Capsaicin is a neuropeptide releasing agent selective for primary sensory peripheral neurons."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 1)

/datum/reagent/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 4)
	spray_warning = TRUE

/datum/reagent/hotsauce
	name = "Hot Sauce"
	id = "hotsauce"
	description = "Hot sauce is a pungent condiment sauce made from hot peppers."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPERTHERMIC = 1)

/datum/reagent/condensedcapsaicin/reaction_mob(mob/living/M, method=TOUCH, volume, permeable)
	if(!istype(M, /mob/living) || has_species(M,"Horror"))
		return

	if(method == TOUCH)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = M
			if(skillcheck(victim, SKILL_POLICE, SKILL_POLICE_SKILLED))
				victim.AdjustEyeBlur(5)
				to_chat(victim, SPAN_WARNING("Your training protects you from the pepperspray!"))
				return

			if(victim.pain.feels_pain)
				victim.emote("scream")
				to_chat(victim, SPAN_WARNING("You're sprayed directly in the eyes with pepperspray!"))
				victim.AdjustEyeBlur(25)
				victim.AdjustEyeBlind(10)
				victim.apply_effect(3, STUN)
				victim.apply_effect(3, WEAKEN)

/datum/reagent/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPOTHERMIC = 6)

/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = COLOR_WHITE
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = "#ffff00"
	burncolormod = 2
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON

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
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/coco_drink_hazelnut
	name = "Chocolate Hazelnut Drink"
	id = "coco_drink_hazelnut"
	description = "Smooth and creamy chocolate drink, with a hint of hazelnut flavor."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#865e2a" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/coco_drink
	name = "Chocolate Drink"
	id = "coco_drink"
	description = "Smooth and creamy chocolate drink."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#61450e" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "Psilocybin is a naturally occurring psychedelic prodrug compound produced by more than 200 species of mushrooms, collectively known as psilocybin mushrooms or Magic Mushrooms."
	color = "#E700E7" // rgb: 231, 0, 231
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HALLUCINOGENIC = 3)

/datum/reagent/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = COLOR_MAGENTA
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	reagent_state = LIQUID
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	reagent_state = LIQUID
	color = "#365E30" // rgb: 54, 94, 48
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_UNKNOWN = 2)

/datum/reagent/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	properties = list(PROPERTY_NUTRITIOUS = 2, PROPERTY_HYPERTHERMIC = 1)
	flags = REAGENT_NO_GENERATION

/datum/reagent/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0
	properties = list(PROPERTY_NUTRITIOUS = 2, PROPERTY_HYPERTHERMIC = 4)
	flags = REAGENT_NO_GENERATION

/datum/reagent/rice
	name = "Rice"
	id = "rice"
	description = "The most widely consumed staple food on Earth. Rice is the most important grain with regard to human nutrition and caloric intake."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = COLOR_WHITE
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/buckwheat
	name = "Buckwheat"
	id = "buckwheat"
	description = "A grain porridge made out of buckwheat."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = COLOR_BROWN
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Sweet jelly made from the cherry fruit."
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#801E28" // rgb: 128, 30, 40
	properties = list(PROPERTY_NUTRITIOUS = 2)

/datum/reagent/honey
	name = "Honey"
	id = "honey"
	description = "Honey is a natural sweet, viscous food substance composed of mainly fructose and glucose."
	color = COLOR_YELLOW
	chemclass = CHEM_CLASS_RARE
	flags = REAGENT_NO_GENERATION

/datum/reagent/electrolyte_grape_beverage
	name = "Grape Beverage"
	id = "dehydrated_grape_beverage"
	description = "Powderized electrolyte beverage with a grape flavor, ready to be mixed with water."
	reagent_state = SOLID
	color = "#74206f" // rgb: 116, 32, 111
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/electrolyte_orange_beverage
	name = "Orange Beverage"
	id = "electrolyte_orange_beverage"
	description = "Powderized electrolyte beverage with an orange flavor, ready to be mixed with water. Smells of, surprise surprise, oranges."
	reagent_state = SOLID
	color = "#FFA500" // rgb: 255, 165, 0
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/electrolyte_lemonlime_beverage
	name = "Lemon-Lime Beverage"
	id = "electrolyte_lemonlime_beverage"
	description = "Powderized electrolyte beverage with a lemon-lime flavor, ready to be mixed with water. Smells of, surprise surprise, lemons and limes."
	reagent_state = SOLID
	color = "#35b435" // rgb: 53, 180, 53
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/hazelnut_beverage
	name = "Chocolate Hazelnut Protein Beverage"
	id = "hazelnut_beverage"
	description = "Powderized chocolate and hazelnut protein drink beverage, ready to be mixed with water."
	reagent_state = SOLID
	color = "#ac4729" // rgb: 172, 71, 41
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/coco_beverage
	name = "Chocolate Protein Beverage"
	id = "chocolate_beverage"
	description = "Powderized chocolate drink beverage, ready to be mixed with water."
	reagent_state = SOLID
	color = "#46271e" // rgb: 70, 39, 30
	chemclass = CHEM_CLASS_SPECIAL
	properties = list(PROPERTY_NUTRITIOUS = 2)
	flags = REAGENT_NO_GENERATION
