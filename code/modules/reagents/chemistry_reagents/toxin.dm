
//*****************************************************************************************************/
//****************************************Poison stuff*************************************************/
//*****************************************************************************************************/

/datum/reagent/toxin
	name = "Generic Toxin"
	id = "toxin"
	description = "General identification for many similar toxins, sometimes created as a byproduct through chemical reactions."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = AMOUNT_PER_TIME(1, 20 SECONDS)
	properties = list(PROPERTY_TOXIC = 1)// Toxins are really weak, but without being treated, last very long.

/datum/reagent/toxin/hptoxin
	name = "Toxin"
	id = "hptoxin"
	description = "A toxic chemical."
	custom_metabolism = AMOUNT_PER_TIME(1, 2 SECONDS)

/datum/reagent/toxin/pttoxin
	name = "Toxin"
	id = "pttoxin"
	description = "A toxic chemical."
	custom_metabolism = AMOUNT_PER_TIME(1, 2 SECONDS)

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
	chemclass = CHEM_CLASS_HYDRO

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
	description = "A special form of metallic plasma that is not found on Earth. While phoron is highly flammable and extremely toxic, its high energy density makes it one of the best solid fuel alternatives. Liquid phoron is often used for research purposes and in the medical industry a catalyst to many advanced chemicals."
	reagent_state = LIQUID
	color = "#E71B00" // rgb: 231, 27, 0
	chemfiresupp = TRUE
	intensitymod = 0.4
	durationmod = -0.8
	radiusmod = 0.05
	burncolor = "#e01e1e"
	burncolormod = 3
	chemclass = CHEM_CLASS_RARE

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
	description = "Cyanide is a naturally occurring toxic chemical, that has been used as a mean of killing for centuries because of its immediate effects. Symptoms include nausea, weakness, and difficulty breathing."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = AMOUNT_PER_TIME(1, 5 SECONDS)
	chemclass = CHEM_CLASS_HYDRO
	properties = list(PROPERTY_HYPOXEMIC = 4, PROPERTY_SEDATIVE = 1)

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	properties = list(PROPERTY_TOXIC = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	properties = list()
	flags = REAGENT_NO_GENERATION

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!. || deleted)
		return
	M.status_flags |= FAKEDEATH
	ADD_TRAIT(M, TRAIT_IMMOBILIZED, FAKEDEATH_TRAIT)
	M.apply_damage(0.5*REM, OXY)
	M.KnockDown(2)
	M.Stun(2)
	M.silent = max(M.silent, 10)

/datum/reagent/toxin/zombiepowder/on_delete()
	. = ..()
	if(!.)
		return

	var/mob/living/holder_mob = .

	holder_mob.status_flags &= ~FAKEDEATH
	REMOVE_TRAIT(holder_mob, TRAIT_IMMOBILIZED, FAKEDEATH_TRAIT)

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

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	description = "A fertilizer that is proficient in every aspect by a mild amount."
	id = "eznutrient"
	properties = list(PROPERTY_TOXIC = 0.5)

/datum/reagent/toxin/fertilizer/eznutrient/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health += 0.05*volume
	processing_tray.yield_mod += 0.01*volume
	processing_tray.nutrilevel += 1*volume

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	description = "A fertilizer that sacrifices most of nutrients in its contents to boost health and to prolong the life expectancy"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/left4zed/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.seed.lifespan += 0.2*volume
	processing_tray.plant_health += 0.1*volume
	processing_tray.nutrilevel += 0.25*volume

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	description = "A fertilizer that sacrifices most of nutrients in its contents to boost product yield the plant gives at the cost of plant health."
	id = "robustharvest"

/datum/reagent/toxin/fertilizer/robustharvest/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health -= 0.01*volume
	processing_tray.yield_mod += 0.1*volume
	processing_tray.nutrilevel += 0.5*volume

/datum/reagent/toxin/dinitroaniline
	name = "Dinitroaniline"
	id = "dinitroaniline"
	description = "Dinitroanilines are a class of chemical compounds used industrially in the production of pesticides and herbicides."
	chemclass = CHEM_CLASS_UNCOMMON


/datum/reagent/toxin/fertilizer/dinitroaniline/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.yield_mod += 0.05*volume
	processing_tray.nutrilevel += 2*volume

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture used to kill plantlife. Very toxic to animals."
	reagent_state = LIQUID
	color = "#49002E" // rgb: 73, 0, 46
	properties = list(PROPERTY_TOXIC = 4)

/datum/reagent/toxin/plantbgone/reaction_hydro_tray_reagent(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.plant_health -= 4*volume

/datum/reagent/toxin/stoxin
	name = "Soporific"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia. Concentrated soporific is used as a surgical anesthetic."
	reagent_state = LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	custom_metabolism = AMOUNT_PER_TIME(1, 20 SECONDS)
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_COMMON
	properties = list(PROPERTY_SEDATIVE = 2, PROPERTY_PAINKILLING = 5)
	flags = REAGENT_SCANNABLE

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "Chloral hydrate was the first synthetically produced sedative-hypnotic drug. It is a powerful sedative which causes near instant sleepiness, but can be deadly in large quantities. Often used together with other anesthetics for surgical procedures."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	custom_metabolism = AMOUNT_PER_TIME(1, 20 SECONDS) //Default 0.2
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_SEDATIVE = 6, PROPERTY_TOXIC = 1)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A bitter tasting salt that can be used as a spice, but can cause cardiac arrest in larger quantities. It has for this reason been used as a component in lethal injections for many years."
	reagent_state = SOLID
	color = COLOR_WHITE
	chemfiresupp = TRUE
	intensitymod = 0.1
	burncolor = COLOR_PURPLE
	burncolormod = 5
	overdose = 30
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_HYPOXEMIC = 2, PROPERTY_RELAXING = 4)

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride used to stop the heart for surgery. Causes instant cardiac arrest. Not safe to eat!"
	reagent_state = SOLID
	color = COLOR_WHITE
	overdose = 20
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_RELAXING = 8, PROPERTY_HYPOXEMIC = 4, PROPERTY_TOXIC = 2)

/datum/reagent/toxin/potassium_phorosulfate
	name = "Potassium Phorosulfate"
	id = "potassium_phorosulfate"
	description = "A chemical made from a violent reaction using sulphuric acid. Has specific industrial uses in sterelizing surfaces from biological contamination in non human accessible ares. Not used in other areas due to its long lasting corrosive effects unless treated."
	reagent_state = SOLID
	color = COLOR_WHITE
	overdose = 10
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_RELAXING = 10, PROPERTY_HYPOXEMIC = 4, PROPERTY_BIOCIDIC = 5)


/datum/reagent/toxin/beer2 //disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	custom_metabolism = AMOUNT_PER_TIME(3, 40 SECONDS) // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE/2
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL/2
	properties = list(PROPERTY_ALCOHOLIC = 2, PROPERTY_TOXIC = 6)

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sulphuric acid"
	description = "A common and very corrosive mineral acid used for many industrial purposes."
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#DB5008" // rgb: 219, 80, 8
	var/meltprob = 10
	chemclass = CHEM_CLASS_BASIC
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CORROSIVE = 3)

/datum/reagent/toxin/iron_sulfate
	name = "Iron Sulfate"
	id = "iron_sulfate"
	description = "A reactive sulfide material often used as an intermediate or starting component in various chemical processes"
	reagent_state = LIQUID
	color = "#303030"
	chemclass = CHEM_CLASS_UNCOMMON
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/toxin/iron_phoride_sulfate
	name = "Iron Phoride Sulfate"
	id = "iron_phoride_sulfate"
	description = "Iron Sulfate combined with Phoron to form a robust and durable substance, usually proposed as an additive to armor plates. Saw little actual use due to its flammability."
	reagent_state = LIQUID
	color = "#4b1f5e"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_CORROSIVE = 5, PROPERTY_OXIDIZING = 3, )

/datum/reagent/toxin/copper_sulfate
	name = "Copper Sulfate"
	id = "copper_sulfate"
	description = "A common fungicide that is widely used to treat wood and other organic materials to prevent rot, decay, and fungal growth."
	reagent_state = LIQUID
	spray_warning = TRUE
	color = "#1d39db"
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_CORROSIVE = 5)

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
	color = COLOR_GRAY
	reagent_state = GAS
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_TOXIC = 1, PROPERTY_CARCINOGENIC = 1)


/datum/reagent/toxin/phenolformaldehyde_resin
	name = "Phenol-Formaldehyde Resin"
	id = "phenol_formaldehyde"
	description = "Phenol-Formaldehyde Resin is a common molding polymer used in production of many small parts. It has great stress capacity and proven itself over many decades."
	reagent_state = SOLID
	chemclass = CHEM_CLASS_RARE
	color = "#909648"
	properties = list(PROPERTY_TOXIC = 3)

/datum/reagent/toxin/paraformaldehyde
	name = "Paraformaldehyde"
	id = "paraformaldehyde"
	description = "A polymerized form of formaldehyde, that is slowly formed in a cold aqueous solution."
	color = "#E0E0E0"
	reagent_state = SOLID
	chemclass = CHEM_CLASS_RARE
	properties = list(PROPERTY_TOXIC = 1)

/datum/reagent/toxin/molecular_acid
	name = "Diluted Molecular Acid"
	id = "molecularacid"
	description = "An acid of unknown composition, this sample doesn't seem to be as dangerous those found within Xenomorph bloodstreams."
	color = "#669900"
	reagent_state = LIQUID
	chemclass = CHEM_CLASS_NONE
	properties = list(PROPERTY_CORROSIVE = 2, PROPERTY_TOXIC = 1, PROPERTY_CROSSMETABOLIZING = 3)

/datum/reagent/toxin/xeno/neurotoxin
	name = "Neurotoxin"
	id = REAGENT_XENO_NEUROTOXIN
	description = "A paralytic cocktail secreted by xenomorph castes. Rapidly overwhelms the nervous system when metabolized."
	reagent_state = LIQUID
	color = "#cfa32a"
	flags = REAGENT_NO_GENERATION | REAGENT_SCANNABLE
	custom_metabolism = AMOUNT_PER_TIME(1, 10 SECONDS)

	var/default_msg = "Your whole body is feeling numb as you quickly tire out!"
	var/stamina_damage = 7
	var/stim_drain = 2

	var/tmp/current_strength = 0
	var/tmp/chat_cd_counter = 0
	var/tmp/next_stumble_time = 0
	var/tmp/next_hallucination_time = 0

/datum/reagent/toxin/xeno/neurotoxin/on_mob_life(mob/living/M, alien, delta_time)
	var/pre_volume = volume

	// Adjust metabolism rate based on mob state (like the old effect)
	var/original_metabolism = custom_metabolism

	. = ..()
	custom_metabolism = original_metabolism  // Reset to original rate

	if(!. || deleted)
		return
	if(!iscarbon(M))
		return

	var/mob/living/carbon/affected_mob = M
	if(affected_mob.stat == DEAD)
		return
	if(issynth(affected_mob))
		return

	affected_mob.last_damage_data = create_cause_data("xenomorph neurotoxin", last_source_mob?.resolve())

	var/stam_amount = stamina_damage * delta_time
	if(stam_amount > 0)
		affected_mob.apply_stamina_damage(stam_amount)

	affected_mob.make_dizzy(max(1, round(8 * delta_time)))
	if(affected_mob.reagents)
		for(var/datum/reagent/generated/stim in affected_mob.reagents.reagent_list)
			affected_mob.reagents.remove_reagent(stim.id, stim_drain * delta_time, TRUE)

	// Use current volume to determine effect intensity (like other reagents)
	var/intensity = volume  // Use actual volume with decimals for more precise scaling
	var/bloodcough_prob = 0
	var/stumble_prob = 0
	var/msg = default_msg

	// Effect levels (shit that doesn't stack)

	switch(intensity)
		if(0 to 0.9)
			msg = default_msg
		if(1 to 1.4)
			msg = SPAN_DANGER("You body starts feeling numb, you can't feel your fingers!")
			bloodcough_prob = 10
		if(1.5 to 1.9)
			msg = pick(SPAN_BOLDNOTICE("Why am I here?"), SPAN_HIGHDANGER("Your entire body feels numb!"), SPAN_HIGHDANGER("You notice your movement is erratic!"), SPAN_HIGHDANGER("You panic as numbness takes over your body!"))
			bloodcough_prob = 20
			stumble_prob = 5
		if(2 to 2.4)
			msg = SPAN_DANGER("Your eyes sting, you can't see!")
			bloodcough_prob = 25
			stumble_prob = 25
		if(2.5 to INFINITY)
			msg = pick(SPAN_BOLDNOTICE("What am I doing?"), SPAN_DANGER("Your hearing fades away, you can't hear anything!"), SPAN_HIGHDANGER("A sharp pain eminates from your abdomen!"), SPAN_HIGHDANGER("EVERYTHING IS HURTING!! AGH!!!"), SPAN_HIGHDANGER("Your entire body is numb, you can't feel anything!"), SPAN_HIGHDANGER("You can't feel your limbs at all!"), SPAN_HIGHDANGER("Your mind goes blank, you can't think of anything!"))
			stumble_prob = 40
			bloodcough_prob = 30

	var/strength = current_strength

	// Stacking effects below

	if(intensity >= 1)
		affected_mob.apply_effect(10, pick(SLUR, STUTTER))
		affected_mob.apply_effect(max(affected_mob.eye_blurry, strength), EYE_BLUR)

	if(intensity >= 1.4)
		affected_mob.apply_effect(5, AGONY)
		affected_mob.make_jittery(15)
		if(affected_mob.client && ishuman(affected_mob) && world.time >= next_hallucination_time)
			var/mob/living/carbon/human/human_target = affected_mob
			process_hallucination(human_target)
			next_hallucination_time = world.time + rand(4 SECONDS, 10 SECONDS)

	if(intensity >= 1.9)
		affected_mob.eye_blind = max(affected_mob.eye_blind, floor(strength / 4))

	if(intensity >= 2.7)
		affected_mob.apply_effect(1, DAZE)
		affected_mob.apply_damage(2 * delta_time, TOX)
		affected_mob.SetEarDeafness(max(affected_mob.ear_deaf, floor(strength * 1.5)))

	if(intensity >= 5)
		affected_mob.apply_internal_damage(10 * delta_time, "liver")
		affected_mob.apply_damage(150, OXY)

	if(stumble_prob && prob(stumble_prob) && world.time >= next_stumble_time)
		if(!affected_mob.is_mob_incapacitated())
			affected_mob.visible_message(SPAN_DANGER("[affected_mob] misteps in their confusion!"), SPAN_HIGHDANGER("You stumble!"))
			step(affected_mob, pick(CARDINAL_ALL_DIRS))
			affected_mob.apply_effect(5, DAZE)
			affected_mob.make_jittery(25)
			affected_mob.make_dizzy(55)
			affected_mob.emote("pain")
			next_stumble_time = world.time + 3 SECONDS
			if(holder)
				holder.add_reagent(id, custom_metabolism * delta_time, null, TRUE)

	if(bloodcough_prob && prob(bloodcough_prob))
		affected_mob.emote("cough")
		affected_mob.Slow(1)
		affected_mob.apply_damage(5, BRUTE, "chest")

	if(chat_cd_counter <= 0)
		chat_cd_counter = 1
	else
		chat_cd_counter = max(chat_cd_counter - 1, 0)

/datum/reagent/toxin/xeno/neurotoxin/proc/register_exposure(strength)
	if(isnum(strength) && strength > 0)
		current_strength = strength

/datum/reagent/toxin/xeno/neurotoxin/proc/process_hallucination(mob/living/carbon/human/victim)
	switch(rand(0, 100))
		if(0 to 5)
			playsound_client(victim?.client, pick('sound/voice/alien_pounce.ogg','sound/voice/alien_pounce.ogg'))
			victim.KnockDown(3)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "alien_claw_flesh"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "bonebreak"), 1 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "alien_claw_flesh"), 1.5 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "alien_claw_flesh"), 2 SECONDS)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "bonebreak"), 2.5 SECONDS)
			victim.apply_effect(AGONY, 10)
			victim.emote("pain")
		if(6 to 10)
			playsound_client(victim.client, 'sound/effects/ob_alert.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/weapons/gun_orbital_travel.ogg'), 2 SECONDS)
		if(11 to 16)
			playsound_client(victim.client, 'sound/voice/alien_queen_screech.ogg')
			victim.KnockDown(1)
		if(17 to 24)
			hallucination_fakecas_sequence(victim)
		if(25 to 42)
			to_chat(victim, SPAN_HIGHDANGER("A SHELL IS ABOUT TO IMPACT [pick(SPAN_UNDERLINE("TOWARDS THE [pick("WEST","EAST","SOUTH","NORTH")]") , SPAN_UNDERLINE("RIGHT ONTOP OF YOU!"))]!"))
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/weapons/gun_mortar_travel.ogg'), 1 SECONDS)
		if(43 to 69)
			victim.emote(pick("twitch","drool","moan","giggle"))
			victim.hallucination = 3
			victim.druggy = 3
		if(70 to 100)
			playsound_client(client = victim.client, soundin = pick('sound/voice/alien_distantroar_3.ogg','sound/voice/xenos_roaring.ogg','sound/voice/alien_queen_breath1.ogg', 'sound/voice/4_xeno_roars.ogg','sound/misc/notice2.ogg',"bone_break","gun_pulse","metalbang","pry","shatter"), vol = 65)

/datum/reagent/toxin/xeno/neurotoxin/proc/hallucination_fakecas_sequence(mob/living/carbon/human/victim)
	playsound_client(victim.client, 'sound/weapons/dropship_sonic_boom.ogg', vol = 5)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), victim, "A DROPSHIP FIRES [pick(SPAN_UNDERLINE("TOWARDS THE [pick("WEST","EAST","SOUTH","NORTH")]") , SPAN_UNDERLINE("RIGHT ONTOP OF YOU!"))]!"), 3.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/rocketpod_fire.ogg', null, 5), 4 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gau.ogg', null, 5), 5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/rocketpod_fire.ogg', null, 5), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 5.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "explosion", null, 5), 6.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 6.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/rocketpod_fire.ogg', null, 5), 7.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 7.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "explosion", null, 5), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 8.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "bigboom", null, 5), 9 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 9 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/rocketpod_fire.ogg', null, 5), 9.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 10 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "explosion", null, 5), 10 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 10.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, "explosion", null, 5), 11 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), victim.client, 'sound/effects/gauimpact.ogg', null, 5), 11 SECONDS)
	victim.emote("pain")
