/datum/chem_property/special
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS
	value = 6

/datum/chem_property/special/boosting
	name = PROPERTY_BOOSTING
	code = "BST"
	description = "Boosts the potency of all other properties in this chemical when inside the body."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_METABOLITE

/datum/chem_property/special/boosting/pre_process(mob/living/M)
	return list(REAGENT_BOOST = level)

/datum/chem_property/special/regulating
	name = PROPERTY_REGULATING
	code = "REG"
	description = "The chemical regulates its own metabolization and can thus never cause overdosis."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_METABOLITE
	max_level = 1

/datum/chem_property/special/regulating/reset_reagent()
	holder.flags = initial(holder.flags)
	..()

/datum/chem_property/special/regulating/update_reagent()
	holder.flags |= REAGENT_CANNOT_OVERDOSE
	..()

/datum/chem_property/special/hypergenetic
	name = PROPERTY_HYPERGENETIC
	code = "HGN"
	description = "Regenerates all types of cell membranes mending damage in all organs and limbs."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/special/hypergenetic/process(mob/living/M, var/potency = 1)
	M.heal_limb_damage(potency)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/datum/internal_organ/O in H.internal_organs)
		M.apply_internal_damage(-potency, O)

/datum/chem_property/special/hypergenetic/process_overdose(mob/living/M, var/potency = 1, delta_time)
	M.adjustCloneLoss(potency * delta_time)

/datum/chem_property/special/hypergenetic/process_critical(mob/living/M, var/potency = 1, delta_time)
	M.take_limb_damage(1.5 * potency * delta_time, 1.5 * potency * delta_time)

/datum/chem_property/special/hypergenetic/reaction_mob(var/mob/M, var/method=TOUCH, var/volume, var/potency)
	if(!isXenoOrHuman(M))
		return
	M.AddComponent(/datum/component/healing_reduction, -potency * volume * POTENCY_MULTIPLIER_LOW) //reduces heal reduction if present
	if(ishuman(M)) //heals on contact with humans/xenos
		var/mob/living/carbon/human/H = M
		H.heal_limb_damage(potency * volume * POTENCY_MULTIPLIER_LOW)
	if(isXeno(M)) //more effective on xenos to account for higher HP
		var/mob/living/carbon/Xenomorph/X = M
		X.gain_health(potency * volume)

/datum/chem_property/special/organhealing
	name = PROPERTY_ORGAN_HEALING
	code = "OHG"
	description = "Regenerates all types of cell membranes mending damage in all organs."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/special/organhealing/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/datum/internal_organ/O in H.internal_organs)
		M.apply_internal_damage(-0.5 * potency * delta_time, O)

/datum/chem_property/special/organhealing/process_overdose(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/special/organhealing/process_critical(mob/living/M, var/potency = 1)
	M.take_limb_damage(POTENCY_MULTIPLIER_HIGH * potency, POTENCY_MULTIPLIER_HIGH * potency)

/datum/chem_property/special/DNA_Disintegrating
	name = PROPERTY_DNA_DISINTEGRATING
	code = "DDI"
	description = "Immediately disintegrates the DNA of all organic cells it comes into contact with. This property is highly valued by WY."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_TOXICANT|PROPERTY_TYPE_ANOMALOUS
	value = 16

/datum/chem_property/special/DNA_Disintegrating/process(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(POTENCY_MULTIPLIER_EXTREME * potency)
	if(ishuman(M) && M.cloneloss >= 190)
		var/mob/living/carbon/human/H = M
		H.contract_disease(new /datum/disease/xeno_transformation(0),1) //This is the real reason PMCs are being sent to retrieve it.

/datum/chem_property/special/DNA_Disintegrating/trigger()
	SSticker.mode.get_specific_call("Weyland-Yutani PMC (Chemical Investigation Squad)", TRUE, FALSE, holder.name)
	chemical_data.update_credits(10)
	message_staff("The research department has discovered DNA_Disintegrating in [holder.name] adding 10 bonus tech points.")
	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(10)
	ai_announcement("NOTICE: Encrypted data transmission received from USCSS Royce. Shuttle inbound.")

/datum/chem_property/special/ciphering
	name = PROPERTY_CIPHERING
	code = "CIP"
	description = "This extremely complex chemical structure represents some kind of biological cipher."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS
	value = 16
	max_level = 6

/datum/chem_property/special/ciphering/process(mob/living/M, var/potency = 1, delta_time)
	if(!GLOB.hive_datum[level]) // This should probably always be valid
		return

	for(var/content in M.contents)
		if(!istype(content, /obj/item/alien_embryo))
			continue
		// level is a number rather than a hivenumber, which are strings
		var/hivenumber = GLOB.hive_datum[level]
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		var/obj/item/alien_embryo/A = content
		A.hivenumber = hivenumber
		A.faction = hive.internal_faction

/datum/chem_property/special/ciphering/predator
	name = PROPERTY_CIPHERING_PREDATOR
	code = "PCI"
	rarity = PROPERTY_DISABLED // this one should always be disabled, even if ciphering is not
	max_level = 6

/datum/chem_property/special/ciphering/predator/reagent_added(atom/A, datum/reagent/R, amount)
	. = ..()
	var/obj/item/xeno_egg/E = A
	if(!istype(E))
		return

	if(amount < 10)
		return

	if((E.flags_embryo & FLAG_EMBRYO_PREDATOR) && E.hivenumber == level)
		return

	E.visible_message(SPAN_DANGER("\the [E] rapidly mutates"))

	playsound(E, 'sound/effects/attackblob.ogg', 25, TRUE)

	E.hivenumber = level
	set_hive_data(E, level)
	E.flags_embryo |= FLAG_EMBRYO_PREDATOR

/datum/chem_property/special/crossmetabolizing
	name = PROPERTY_CROSSMETABOLIZING
	code = "XMB"
	description = "Can be metabolized in certain non-human species."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_METABOLITE|PROPERTY_TYPE_ANOMALOUS|PROPERTY_TYPE_CATALYST
	value = 666
	max_level = 2

/datum/chem_property/special/crossmetabolizing/pre_process(mob/living/M)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.species.reagent_tag == IS_YAUTJA)
		return list(REAGENT_FORCE = TRUE)
	else if(level < 2)//needs level two to work on humans too
		return list(REAGENT_CANCEL = TRUE)

/datum/chem_property/special/embryonic
	name = PROPERTY_EMBRYONIC
	code = "MYO"
	description = "The chemical agent carries causes an infection of type REDACTED parasitic embryonic organism."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/embryonic/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC) || !H.huggable) //No effect if already infected
		return
	for(var/i=1,i<=max((level % 100)/10,1),i++)//10's determine number of embryos
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		embryo.hivenumber = min(level % 10,5) //1's determine hivenumber
		embryo.faction = FACTION_LIST_XENOMORPH[embryo.hivenumber]

/datum/chem_property/special/transforming
	name = PROPERTY_TRANSFORMING
	code = "HGN"
	description = "The chemical agent carries REDACTED, altering the host psychologically and physically."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/transforming/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.contract_disease(new /datum/disease/xeno_transformation(0),1)

/datum/chem_property/special/ravening
	name = PROPERTY_RAVENING
	code = "RAV"
	description = "The chemical agent carries the X-65 biological organism."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/ravening/process(mob/living/M, var/potency = 1, delta_time)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	H.contract_disease(new /datum/disease/black_goo, 1)

/datum/chem_property/special/curing
	name = PROPERTY_CURING
	code = "CUR"
	description = "Binds to and neutralizes specific microbiological organisms."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE|PROPERTY_TYPE_ANOMALOUS
	value = 666
	max_level = 4

/datum/chem_property/special/curing/process(mob/living/M, var/potency = 1, delta_time)
	var/datum/species/zombie/zs = GLOB.all_species["Zombie"]

	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.viruses)
		for(var/datum/disease/D in H.viruses)
			if(potency >= CREATE_MAX_TIER_1)
				D.cure()
				zs.remove_from_revive(H)
			else
				if(D.name == "Unknown Mutagenic Disease" && (potency == 0.5 || potency > 1.5))
					D.cure()
				if(D.name == "Black Goo" && potency >= 1)
					D.cure()
					zs.remove_from_revive(H)

/datum/chem_property/special/omnipotent
	name = PROPERTY_OMNIPOTENT
	code = "OMN"
	description = "Fully revitalizes all bodily functions."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/omnipotent/process(mob/living/M, var/potency = 1, delta_time)
	M.reagents.remove_all_type(/datum/reagent/toxin, 2.5*REM * delta_time, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.heal_limb_damage(POTENCY_MULTIPLIER_VHIGH * potency, POTENCY_MULTIPLIER_VHIGH * potency)
	M.apply_damage(-POTENCY_MULTIPLIER_VHIGH * potency, TOX)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetKnockeddown(0)
	M.SetStunned(0)
	M.SetKnockedout(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/datum/internal_organ/I in H.internal_organs)
		M.apply_internal_damage(-0.5 * potency * delta_time, I)

/datum/chem_property/special/radius
	name = PROPERTY_RADIUS
	code = "RAD"
	description = "Controls the radius of a fire, using unknown means"
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/radius/reset_reagent()
	holder.chemfiresupp = initial(holder.chemfiresupp)

	holder.rangefire = initial(holder.rangefire)
	holder.radiusmod = initial(holder.radiusmod)
	..()

/datum/chem_property/special/radius/update_reagent()
	holder.chemfiresupp = TRUE

	holder.rangefire = max(holder.rangefire, 0) // Initial starts at -1 for some (aka infinite range), need to reset that to 0 so that calc doesn't fuck up

	holder.rangefire += 1 * level
	holder.radiusmod += 0.1 * level
	..()

/datum/chem_property/special/intensity
	name = PROPERTY_INTENSITY
	code = "INT"
	description = "Controls the intensity of a fire, using unknown means"
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/intensity/reset_reagent()
	holder.chemfiresupp = initial(holder.chemfiresupp)

	holder.intensityfire = initial(holder.intensityfire)
	holder.intensitymod = initial(holder.intensitymod)
	..()

/datum/chem_property/special/intensity/update_reagent()
	holder.chemfiresupp = TRUE

	holder.intensityfire += 1 * level
	holder.intensitymod += 0.1 * level
	..()

/datum/chem_property/special/duration
	name = PROPERTY_DURATION
	code = "DUR"
	description = "Controls the duration of a fire, using unknown means"
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/duration/reset_reagent()
	holder.chemfiresupp = initial(holder.chemfiresupp)

	holder.durationfire = initial(holder.durationfire)
	holder.durationmod = initial(holder.durationmod)
	..()

/datum/chem_property/special/duration/update_reagent()
	holder.chemfiresupp = TRUE

	holder.durationfire += 1 * level
	holder.durationmod += 0.1 * level
	..()

/datum/chem_property/special/firepenetrating
	name = PROPERTY_FIRE_PENETRATING
	code = "PTR"
	description = "Gives the chemical a unique, anomalous combustion chemistry, causing the flame to react with flame-resistant material and obliterate through it."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_REACTANT
	value = 8
	max_level = 1

/datum/chem_property/special/firepenetrating/reset_reagent()
	holder.fire_penetrating = initial(holder.fire_penetrating)
	..()

/datum/chem_property/special/firepenetrating/update_reagent()
	holder.fire_penetrating = TRUE
	..()
