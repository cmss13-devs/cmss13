

//////////////////////////Poison stuff///////////////////////

/datum/reagent/toxin
	name = "Generic Toxin"
	id = "toxin"
	description = "General identification for many similar toxins, sometimes created as a byproduct through chemical reactions."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 0.7 // Toxins are really weak, but without being treated, last very long.
	custom_metabolism = 0.1
	properties = list(PROPERTY_TOXIC = 1)

	on_mob_life(mob/living/M,alien)
		. = ..()
		if(!.) return
		if(alien == IS_YAUTJA) return 0 //immunity to toxin reagents
		if(toxpwr)
			M.adjustToxLoss(toxpwr*REM)
			if(alien) holder.remove_reagent(id, custom_metabolism) //Kind of a catch-all for aliens without kidneys.
			///I don't know what this is supposed to do, since aliens generally have kidneys, but I'm leaving it alone pending rework. /N

/datum/reagent/toxin/hptoxin
	name = "Toxin"
	id = "hptoxin"
	description = "A toxic chemical."
	custom_metabolism = 1
	toxpwr = 1

/datum/reagent/toxin/pttoxin
	name = "Toxin"
	id = "pttoxin"
	description = "A toxic chemical."
	custom_metabolism = 1
	toxpwr = 1

/datum/reagent/toxin/sdtoxin
	name = "Toxin"
	id = "sdtoxin"
	description = "A toxic chemical."
	custom_metabolism = 1
	toxpwr = 0
	on_mob_life(mob/living/M,alien)
		. = ..()
		if(!.) return
		M.adjustOxyLoss(1)


/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = LIQUID
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 1
	chemclass = CHEM_CLASS_RARE

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Mutagenic compound used for in experimental botany. Can cause unpredictable mutations in plants, but very lethal to humans. Keep away from children."
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 4, PROPERTY_CARCINOGENIC = 1)

	on_mob_life(mob/living/carbon/M)
		. = ..()
		if(!.) return
		if(!istype(M))	return
		M.apply_effect(10,IRRADIATE,0)

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
	toxpwr = 3
	chemclass = CHEM_CLASS_RARE

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		holder.remove_reagent("inaprovaline", 2*REM)

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin is an extremely dangerous compound that damages tissue and paralyzes the lungs, effectively stopping respiration. Can be deadly in even small doses. Lexorin is effectively countered by variants of dexalin."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HYPOXEMIC = 8, PROPERTY_BIOCIDIC = 1)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(M.stat == DEAD)
			return
		if(prob(33))
			M.take_limb_damage(1*REM, 0)
		M.adjustOxyLoss(3)
		if(prob(20)) M.emote("gasp")

	on_overdose(mob/living/M)
		M.apply_damages(2, 0, 2) //Overdose starts getting bad

	on_overdose_critical(mob/living/M)
		M.apply_damages(3, 0, 3) //Overdose starts getting bad

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "Cyanide is a naturally occuring toxic chemical, that has been used as a mean of killing for centuries because of its immediate effects. Symptoms include nausea, weakness, and difficulty breathing."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 4
	custom_metabolism = 0.4
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_HYPOXEMIC = 2)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.adjustOxyLoss(4*REM)
		M.sleeping += 1

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) 
			return

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

	on_mob_life(mob/living/carbon/M)
		. = ..()
		if(!.) return
		M.status_flags |= FAKEDEATH
		M.adjustOxyLoss(0.5*REM)
		M.KnockDown(10)
		M.silent = max(M.silent, 10)
		M.tod = worldtime2text()

	Dispose()
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
	toxpwr = 0
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HALLUCINOGENIC = 8)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.hallucination += 10

	on_overdose(mob/living/M, alien)
		if(alien == IS_YAUTJA)  return
		M.apply_damage(1, TOX) //Overdose starts getting bad
		M.make_jittery(5)
		M.knocked_out = max(M.knocked_out, 20)

	on_overdose_critical(mob/living/M, alien)
		if(alien == IS_YAUTJA)  return
		M.apply_damage(4, TOX) //Overdose starts getting bad
		M.make_jittery(10)
		M.knocked_out = max(M.knocked_out, 20)
		M.drowsyness = max(M.drowsyness, 30)

//Reagents used for plant fertilizers.
/datum/reagent/toxin/fertilizer
	name = "fertilizer"
	id = "fertilizer"
	description = "Industrial grade inorganic plant fertilizer."
	reagent_state = LIQUID
	toxpwr = 0.2 //It's not THAT poisonous.
	color = "#664330" // rgb: 102, 67, 48

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
	toxpwr = 1

	reaction_obj(var/obj/O, var/volume)
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

	reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
		src = null
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(!C.wear_mask) // If not wearing a mask
				C.adjustToxLoss(2) // 4 toxic damage per application, doubled for some reason

/datum/reagent/toxin/stoxin
	name = "Soporific"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia. Concentrated soporific is used as a surgical anesthetic."
	reagent_state = LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	toxpwr = 0
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	scannable = 1
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_RELAXING = 1)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!data) data = 1
		switch(data)
			if(1 to 12)
				if(prob(5))	M.emote("yawn")
			if(12 to 15)
				M.eye_blurry = max(M.eye_blurry, 10)
			if(15 to 49)
				if(prob(50))
					M.KnockDown(2)
				M.drowsyness  = max(M.drowsyness, 20)
			if(50 to INFINITY)
				M.KnockDown(20)
				M.drowsyness  = max(M.drowsyness, 30)
		data++

		M.reagent_pain_modifier += PAIN_REDUCTION_FULL

	on_overdose(mob/living/M)
		M.apply_damages(0, 0, 1, 2) //Overdose starts getting bad

	on_overdose_critical(mob/living/M)
		M.apply_damages(0, 0, 2, 3) //Overdose starts getting bad

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "Chloral hydrate was the first synthetically produced sedative-hypnotic drug. It is a powerful sedative which causes near instant sleepiness, but can be deadly in large quantities. Often used together with other anesthetics for surgical procedures."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 1
	custom_metabolism = 0.1 //Default 0.2
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_RELAXING = 6)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!data) data = 1
		data++
		switch(data)
			if(1)
				M.confused += 2
				M.drowsyness += 2
			if(2 to 199)
				M.KnockDown(30)
			if(200 to INFINITY)
				M.sleeping += 1

	on_overdose(mob/living/M)
		M.apply_damages(0, 0, 2, 3) //Overdose starts getting bad

	on_overdose_critical(mob/living/M)
		M.apply_damages(0, 0, 3, 2) //Overdose starts getting bad

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A bitter tasting salt that can be used as a spice, but can cause cardiac arrest in larger quantities. It has for this reason been used as a component in lethal injections for many years."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = "#800080"
	toxpwr = 0
	overdose = 30
	chemclass = CHEM_CLASS_UNCOMMON

	on_mob_life(mob/living/carbon/M)
		. = ..()
		if(!.) return
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(volume >= overdose)
				if(H.losebreath >= 10)
					H.losebreath = max(10, H.losebreath-10)
				H.adjustOxyLoss(2)
				H.KnockDown(10)

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride used to stop the heart for surgery. Causes instant cardiac arrest. Not safe to eat!"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 2
	overdose = 20
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_RELAXING = 8, PROPERTY_HYPOXEMIC = 4)

	on_mob_life(mob/living/carbon/M)
		. = ..()
		if(!.) return
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.stat != 1)
				if(H.losebreath >= 10)
					H.losebreath = max(10, M.losebreath-10)
				H.adjustOxyLoss(2)
				H.KnockDown(10)

/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	custom_metabolism = 0.15 // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		if(!data) data = 1
		switch(data)
			if(1)
				M.confused += 2
				M.drowsyness += 2
			if(2 to 50)
				M.sleeping += 1
			if(51 to INFINITY)
				M.sleeping += 1
				M.adjustToxLoss((data - 50)*REM)
		data++

	on_overdose(mob/living/M)
		M.apply_damages(0, 0, 2, 3) //Overdose starts getting bad

	on_overdose_critical(mob/living/M)
		M.apply_damages(0, 0, 3, 2) //Overdose starts getting bad

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A common and very corrosive mineral acid used for many industrial purposes."
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/meltprob = 10
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CORROSIVE = 1)

	on_mob_life(mob/living/M)
		. = ..()
		if(!.) return
		M.take_limb_damage(0, 1*REM)

	reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//magic numbers everywhere
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
						if(affecting.take_damage(4*toxpwr, 2*toxpwr))
							H.UpdateDamageIcon()
						if(prob(meltprob)) //Applies disfigurement
							if(!(H.species && (H.species.flags & NO_PAIN)))
								H.emote("scream")
							H.status_flags |= DISFIGURED
							H.name = H.get_visible_name()
				else
					M.take_limb_damage(min(6*toxpwr, volume * toxpwr)) // uses min() and volume to make sure they aren't being sprayed in trace amounts (1 unit != insta rape) -- Doohl
		else
			if(!M.unacidable)
				M.take_limb_damage(min(6*toxpwr, volume * toxpwr))

	reaction_obj(var/obj/O, var/volume)
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
	toxpwr = 2
	meltprob = 30
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CORROSIVE = 2)

/datum/reagent/toxin/formaldehyde
	name = "Formaldehyde"
	id = "formaldehyde"
	description = "Formaldehyde is a toxic organic gas that is mostly used in making resins, polymers and explosives. It is known to be a natural carcinogen."
	color = "#808080" // rgb: 128, 128, 128
	toxpwr = 1
	reagent_state = GAS
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CARCINOGENIC = 1)

/datum/reagent/toxin/formaldehyde/on_mob_life(mob/living/M,alien)
	. = ..()
	if(!.)
		return
	M.adjustCloneLoss(0.2)
	if(prob(10))
		M.emote(pick("blink","cough"))

/datum/reagent/toxin/paraformaldehyde
	name = "Paraformaldehyde"
	id = "paraformaldehyde"
	description = "A polymerized form of formaldehyde, that is slowly formed in a cold aqueous solution."
	color = "#E0E0E0"
	toxpwr = 1
	reagent_state = SOLID
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1)