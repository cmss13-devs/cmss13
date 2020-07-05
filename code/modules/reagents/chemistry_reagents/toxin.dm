

//////////////////////////Poison stuff///////////////////////

/datum/reagent/toxin
	name = "Generic Toxin"
	id = "toxin"
	description = "General identification for many similar toxins, sometimes created as a byproduct through chemical reactions."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.1
	properties = list(PROPERTY_TOXIC = 1)// Toxins are really weak, but without being treated, last very long.

/datum/reagent/toxin/hptoxin
	name = "Toxin"
	id = "hptoxin"
	description = "A toxic chemical."
	custom_metabolism = 1

/datum/reagent/toxin/pttoxin
	name = "Toxin"
	id = "pttoxin"
	description = "A toxic chemical."
	custom_metabolism = 1

/datum/reagent/toxin/sdtoxin
	name = "Toxin"
	id = "sdtoxin"
	description = "A toxic chemical."
	properties = list(PROPERTY_HYPOXEMIC = 2)

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = LIQUID
	color = "#792300" // rgb: 121, 35, 0
	chemclass = CHEM_CLASS_RARE

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Mutagenic compound used for in experimental botany. Can cause unpredictable mutations in plants, but very lethal to humans. Keep away from children."
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_CARCINOGENIC = 1)

/datum/reagent/toxin/phoron
	name = "Phoron"
	id = "phoron"
	description = "A special form of metalic plasma that is not found on Earth. While phoron is highly flammable and extremely toxic, its high energy density makes it one of the best solid fuel alternatives. Liquid phoron is often used for research purposes and in the medical industry a catalyst to many advanced chemicals."
	reagent_state = LIQUID
	color = "#E71B00" // rgb: 231, 27, 0
	chemfiresupp = TRUE
	intensitymod = 0.3
	durationmod = -0.75
	radiusmod = 0.05
	burncolor = "#e01e1e"
	burncolormod = 3
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_TOXIC = 3)

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin is an extremely dangerous compound that damages tissue and paralyzes the lungs, effectively stopping respiration. Can be deadly in even small doses. Lexorin is effectively countered by variants of dexalin."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HYPOXEMIC = 8, PROPERTY_BIOCIDIC = 1)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "Cyanide is a naturally occuring toxic chemical, that has been used as a mean of killing for centuries because of its immediate effects. Symptoms include nausea, weakness, and difficulty breathing."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.4
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPOXEMIC = 4, PROPERTY_SEDATIVE = 1)

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	properties = list(PROPERTY_TOXIC = 2)

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!.) return
	M.status_flags |= FAKEDEATH
	M.apply_damage(0.5*REM, OXY)
	M.KnockDown(10)
	M.silent = max(M.silent, 10)
	M.tod = worldtime2text()

/datum/reagent/toxin/zombiepowder/Dispose()
	if(holder && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	. = ..()

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogenic compound that is illegal under space law. Causes extreme hallucinations and is very addictive. Formerly known as LSD."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HALLUCINOGENIC = 8)

//Reagents used for plant fertilizers.
/datum/reagent/toxin/fertilizer
	name = "fertilizer"
	id = "fertilizer"
	description = "Industrial grade inorganic plant fertilizer."
	reagent_state = LIQUID
	color = "#664330" // rgb: 102, 67, 48
	properties = list(PROPERTY_TOXIC = 0.5)

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	id = "eznutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	id = "robustharvest"

/datum/reagent/toxin/dinitroaniline
	name = "Dinitroaniline"
	id = "dinitroaniline"
	description = "Dinitroanilines are a class of chemical compounds used industrially in the production of pesticides and herbicides."
	chemclass = CHEM_CLASS_UNCOMMON

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture used to kill plantlife. Very toxic to animals."
	reagent_state = LIQUID
	color = "#49002E" // rgb: 73, 0, 46

/datum/reagent/toxin/plantbgone/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/effect/alien/weeds/))
		var/obj/effect/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15,35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O,/obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O,/obj/effect/plantsegment))
		if(prob(50)) qdel(O) //Kills kudzu too.
	else if(istype(O,/obj/structure/machinery/portable_atmospherics/hydroponics))
		var/obj/structure/machinery/portable_atmospherics/hydroponics/tray = O

		if(tray.seed)
			tray.health -= rand(30,50)
			if(tray.pestlevel > 0)
				tray.pestlevel -= 2
			if(tray.weedlevel > 0)
				tray.weedlevel -= 3
			tray.toxins += 4
			tray.check_level_sanity()
			tray.update_icon()

/datum/reagent/toxin/plantbgone/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	src = null
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			C.apply_damage(2, TOX) // 4 toxic damage per application, doubled for some reason

/datum/reagent/toxin/stoxin
	name = "Soporific"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia. Concentrated soporific is used as a surgical anesthetic."
	reagent_state = LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_SEDATIVE = 2, PROPERTY_PAINKILLING = 10)

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "Chloral hydrate was the first synthetically produced sedative-hypnotic drug. It is a powerful sedative which causes near instant sleepiness, but can be deadly in large quantities. Often used together with other anesthetics for surgical procedures."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	custom_metabolism = 0.1 //Default 0.2
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_SEDATIVE = 6, PROPERTY_TOXIC = 1)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A bitter tasting salt that can be used as a spice, but can cause cardiac arrest in larger quantities. It has for this reason been used as a component in lethal injections for many years."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = "#800080"
	burncolormod = 5
	overdose = 30
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HYPOXEMIC = 2, PROPERTY_RELAXING = 4)

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride used to stop the heart for surgery. Causes instant cardiac arrest. Not safe to eat!"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	overdose = 20
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_RELAXING = 8, PROPERTY_HYPOXEMIC = 4, PROPERTY_TOXIC = 2)

/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	custom_metabolism = 0.15 // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_TOXIC = 6)

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A common and very corrosive mineral acid used for many industrial purposes."
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#DB5008" // rgb: 219, 80, 8
	var/meltprob = 10
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CORROSIVE = 1)

/datum/reagent/toxin/acid/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//magic numbers everywhere
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.head)
				if(prob(meltprob) && !H.head.unacidable)
					to_chat(H, SPAN_DANGER("Your headgear melts away but protects you from the acid!"))
					qdel(H.head)
					H.update_inv_head(0)
					H.update_hair(0)
				else
					to_chat(H, SPAN_WARNING("Your headgear protects you from the acid."))
				return

			if(H.wear_mask)
				if(prob(meltprob) && !H.wear_mask.unacidable)
					to_chat(H, SPAN_DANGER("Your mask melts away but protects you from the acid!"))
					qdel(H.wear_mask)
					H.update_inv_wear_mask(0)
					H.update_hair(0)
				else
					to_chat(H, SPAN_WARNING("Your mask protects you from the acid."))
				return

			if(H.glasses) //Doesn't protect you from the acid but can melt anyways!
				if(prob(meltprob) && !H.glasses.unacidable)
					to_chat(H, SPAN_DANGER("Your glasses melts away!"))
					qdel(H.glasses)
					H.update_inv_glasses(0)

		if(!M.unacidable)
			if(istype(M, /mob/living/carbon/human) && volume >= 10)
				var/mob/living/carbon/human/H = M
				var/obj/limb/affecting = H.get_limb("head")
				if(affecting)
					if(affecting.take_damage(4, 2))
						H.UpdateDamageIcon()
					if(prob(meltprob)) //Applies disfigurement
						if(H.pain.feels_pain)
							H.emote("scream")
						H.status_flags |= DISFIGURED
						H.name = H.get_visible_name()
			else
				M.take_limb_damage(min(6, volume)) // uses min() and volume to make sure they aren't being sprayed in trace amounts (1 unit != insta rape) -- Doohl
	else
		if(!M.unacidable)
			M.take_limb_damage(min(6, volume))

/datum/reagent/toxin/acid/reaction_obj(var/obj/O, var/volume)
	if((istype(O,/obj/item) || istype(O,/obj/effect/glowshroom)) && prob(meltprob * 3))
		if(!O.unacidable)
			var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
			I.desc = "Looks like this was \an [O] some time ago."
			for(var/mob/M in viewers(5, O))
				to_chat(M, SPAN_WARNING("\the [O] melts."))
			qdel(O)

/datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "An extremely corrosive acid that's capable of disolving a broad range of materials very quickly."
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#8E18A9" // rgb: 142, 24, 169
	meltprob = 30
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 2, PROPERTY_CORROSIVE = 3)

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	description = "Formaldehyde is a toxic organic gas that is mostly used in making resins, polymers and explosives. It is known to be a natural carcinogen."
	color = "#808080" // rgb: 128, 128, 128
	reagent_state = GAS
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CARCINOGENIC = 1)

/datum/reagent/toxin/paraformaldehyde
	name = "Paraformaldehyde"
	id = "paraformaldehyde"
	description = "A polymerized form of formaldehyde, that is slowly formed in a cold aqueous solution."
	color = "#E0E0E0"
	reagent_state = SOLID
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1)