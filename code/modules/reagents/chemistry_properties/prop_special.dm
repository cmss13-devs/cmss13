/datum/chem_property/special
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS
	value = 8
//IF YOU ADD A NEW LEGENDARY INTENDED FOR RESEARCH NORMAL LOOP, MAKE SURE TO ADD TO LEGENDARY PROPERTY LIST DEFINE
/datum/chem_property/special/boosting
	name = PROPERTY_BOOSTING
	code = "BST"
	description = "Boosts the potency of all other properties in this chemical when inside the body by 0.5 levels for every level that this property has."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_METABOLITE
	value = 5

/datum/chem_property/special/boosting/pre_process(mob/living/affected_mob)
	return list(REAGENT_BOOST = level * 0.5)

/datum/chem_property/special/optimized
	name = PROPERTY_OPTIMIZED
	code = "OPM"
	description = "Chemical molecule is structured differently, resulting in more efficient and easy synthesis process."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_METABOLITE
	value = 3

/datum/chem_property/special/optimized/update_reagent()
	var/datum/chemical_reaction/reaction_chem = GLOB.chemical_reactions_list[holder.id]
	if(reaction_chem)
		reaction_chem.result_amount = 3
	. = ..()

/datum/chem_property/special/hypergenetic
	name = PROPERTY_HYPERGENETIC
	code = "HGN"
	description = "Regenerates all types of cell membranes mending damage in all organs and limbs."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_MEDICINE
	value = 2

/datum/chem_property/special/hypergenetic/process(mob/living/affected_mob, potency = 1)
	affected_mob.heal_limb_damage(potency)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	for(var/datum/internal_organ/humanorgan in humanmob.internal_organs)
		affected_mob.apply_internal_damage(-potency, humanorgan)

/datum/chem_property/special/hypergenetic/process_overdose(mob/living/affected_mob, potency = 1, delta_time)
	affected_mob.adjustCloneLoss(potency * delta_time)

/datum/chem_property/special/hypergenetic/process_critical(mob/living/affected_mob, potency = 1, delta_time)
	affected_mob.take_limb_damage(1.5 * potency * delta_time, 1.5 * potency * delta_time)

/datum/chem_property/special/hypergenetic/reaction_mob(mob/affected_mob, method=TOUCH, volume, potency)
	if(!isxeno_human(affected_mob))
		return
	affected_mob.AddComponent(/datum/component/status_effect/healing_reduction, -potency * volume * POTENCY_MULTIPLIER_LOW) //reduces heal reduction if present
	if(ishuman(affected_mob)) //heals on contact with humans/xenos
		var/mob/living/carbon/human/humanmob = affected_mob
		humanmob.heal_limb_damage(potency * volume * POTENCY_MULTIPLIER_LOW)
	if(isxeno(affected_mob)) //more effective on xenos to account for higher HP
		var/mob/living/carbon/xenomorph/X = affected_mob
		X.gain_health(potency * volume)

/datum/chem_property/special/organhealing
	name = PROPERTY_ORGAN_HEALING
	code = "OHG"
	description = "Regenerates all types of cell membranes mending damage in all organs."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/special/organhealing/process(mob/living/affected_mob, potency = 1, delta_time)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	for(var/datum/internal_organ/humanorgan in humanmob.internal_organs)
		affected_mob.apply_internal_damage(-0.5 * potency * delta_time, humanorgan)

/datum/chem_property/special/organhealing/process_overdose(mob/living/affected_mob, potency = 1)
	affected_mob.adjustCloneLoss(POTENCY_MULTIPLIER_MEDIUM * potency)

/datum/chem_property/special/organhealing/process_critical(mob/living/affected_mob, potency = 1)
	affected_mob.take_limb_damage(POTENCY_MULTIPLIER_HIGH * potency, POTENCY_MULTIPLIER_HIGH * potency)

/datum/chem_property/special/DNA_Disintegrating
	name = PROPERTY_DNA_DISINTEGRATING
	code = "DDI"
	description = "Immediately disintegrates the DNA of all organic cells it comes into contact with. This property is highly valued by WY."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_TOXICANT|PROPERTY_TYPE_ANOMALOUS
	value = 16

/datum/chem_property/special/DNA_Disintegrating/process(mob/living/affected_mob, potency = 1)
	affected_mob.adjustCloneLoss(POTENCY_MULTIPLIER_EXTREME * potency)
	if(ishuman(affected_mob) && affected_mob.cloneloss >= 150)
		var/mob/living/carbon/human/human = affected_mob
		var/obj/limb/moblimb = pick(human.limbs)
		if(moblimb)
			moblimb.fracture(100)
		human.contract_disease(new /datum/disease/xeno_transformation(0),1) //This is the real reason PMCs are being sent to retrieve it.

/datum/chem_property/special/DNA_Disintegrating/trigger()
	SSticker.mode.get_specific_call(/datum/emergency_call/goon/chem_retrieval, TRUE, FALSE, holder.name) // "Weyland-Yutani Goon (Chemical Investigation Squad)"
	GLOB.chemical_data.update_credits(10)
	message_admins("The research department has discovered DNA_Disintegrating in [holder.name] adding 10 bonus tech points.")
	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(10)
	ai_announcement("NOTICE: Encrypted data transmission received from USCSS Royce. Shuttle inbound.")

/datum/chem_property/special/regulating
	name = PROPERTY_REGULATING
	code = "REG"
	description = "The chemical regulates its metabolization and can never cause an overdose."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_METABOLITE
	max_level = 1
	value = 6

/datum/chem_property/special/regulating/reset_reagent()
	holder.flags = initial(holder.flags)
	..()

/datum/chem_property/special/regulating/update_reagent()
	holder.flags |= REAGENT_CANNOT_OVERDOSE
	..()

/datum/chem_property/special/ciphering
	name = PROPERTY_CIPHERING
	code = "CIP"
	description = "This extremely complex chemical structure represents some kind of biological cipher."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS
	value = 16
	max_level = 6

/datum/chem_property/special/ciphering/process(mob/living/affected_mob, potency = 1, delta_time)
	if(!GLOB.hive_datum[level]) // This should probably always be valid
		return

	for(var/content in affected_mob.contents)
		if(!istype(content, /obj/item/alien_embryo))
			continue
		// level is a number rather than a hivenumber, which are strings
		var/hivenumber = GLOB.hive_datum[level]
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		var/obj/item/alien_embryo/embryo = content
		embryo.hivenumber = hivenumber
		embryo.faction = hive.internal_faction

/datum/chem_property/special/encrypted
	name = PROPERTY_ENCRYPTED
	code = "ENC"
	description = "This extremely complex chemical structure contains a cipher that appears to be missing a few parts to complete the process."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS

/datum/chem_property/special/ciphering/predator
	name = PROPERTY_CIPHERING_PREDATOR
	code = "PCI"
	rarity = PROPERTY_DISABLED // this one should always be disabled, even if ciphering is not
	max_level = 6

/datum/chem_property/special/ciphering/predator/reagent_added(atom/embryo, datum/reagent/R, amount)
	. = ..()
	var/obj/item/xeno_egg/egg = embryo
	if(!istype(egg))
		return

	if(amount < 10)
		return

	if((egg.flags_embryo & FLAG_EMBRYO_PREDATOR) && egg.hivenumber == GLOB.hive_datum[level])
		return

	egg.visible_message(SPAN_DANGER("\The [egg] rapidly mutates."))

	playsound(egg, 'sound/effects/attackblob.ogg', 25, TRUE)

	egg.hivenumber = GLOB.hive_datum[level]
	set_hive_data(egg, GLOB.hive_datum[level])
	egg.flags_embryo |= FLAG_EMBRYO_PREDATOR

/datum/chem_property/special/crossmetabolizing
	name = PROPERTY_CROSSMETABOLIZING
	code = "XMB"
	description = "Can be metabolized in certain non-human species."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_METABOLITE|PROPERTY_TYPE_ANOMALOUS|PROPERTY_TYPE_CATALYST
	value = 666
	max_level = 2

/datum/chem_property/special/crossmetabolizing/pre_process(mob/living/affected_mob)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	if(humanmob.species.reagent_tag == IS_YAUTJA)
		return list(REAGENT_FORCE = TRUE)
	else if(level < 2)//needs level two to work on humans too
		return list(REAGENT_CANCEL = TRUE)

/datum/chem_property/special/embryonic
	name = PROPERTY_EMBRYONIC
	code = "MYO"
	description = "The chemical agent carries causes an infection of type REDACTED parasitic embryonic organisaffected_mob."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/embryonic/process(mob/living/affected_mob, potency = 1, delta_time)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	if((locate(/obj/item/alien_embryo) in humanmob.contents) || (humanmob.species.flags & IS_SYNTHETIC) || !humanmob.huggable) //No effect if already infected
		return
	for(var/i=1,i<=max((level % 100)/10,1),i++)//10's determine number of embryos
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(humanmob)
		embryo.hivenumber = min(level % 10,5) //1's determine hivenumber
		embryo.faction = FACTION_LIST_XENOMORPH[embryo.hivenumber]

/datum/chem_property/special/transforming
	name = PROPERTY_TRANSFORMING
	code = "HGN"
	description = "The chemical agent carries REDACTED, altering the host psychologically and physically."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/transforming/process(mob/living/affected_mob, potency = 1, delta_time)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	humanmob.contract_disease(new /datum/disease/xeno_transformation(0),1)

/datum/chem_property/special/ravening
	name = PROPERTY_RAVENING
	code = "RAV"
	description = "The chemical agent carries the X-65 biological organisaffected_mob."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/ravening/process(mob/living/affected_mob, potency = 1, delta_time)
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	humanmob.contract_disease(new /datum/disease/black_goo, 1)

/datum/chem_property/special/curing
	name = PROPERTY_CURING
	code = "CUR"
	description = "Binds to and neutralizes specific microbiological organisms."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE|PROPERTY_TYPE_ANOMALOUS
	value = 666
	max_level = 4

/datum/chem_property/special/curing/process(mob/living/affected_mob, potency = 1, delta_time)
	var/datum/species/zombie/zs = GLOB.all_species[SPECIES_ZOMBIE]

	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	if(humanmob.viruses)
		for(var/datum/disease/D in humanmob.viruses)
			if(potency >= CREATE_MAX_TIER_1)
				D.cure()
				zs.remove_from_revive(humanmob)
			else
				if(D.name == "Unknown Mutagenic Disease" && (potency == 0.5 || potency > 1.5))
					D.cure()
				if(D.name == "Black Goo" && potency >= 1)
					D.cure()
					zs.remove_from_revive(humanmob)

/datum/chem_property/special/omnipotent
	name = PROPERTY_OMNIPOTENT
	code = "OMN"
	description = "Fully revitalizes all bodily functions."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/omnipotent/process(mob/living/affected_mob, potency = 1, delta_time)
	affected_mob.reagents.remove_all_type(/datum/reagent/toxin, 2.5*REM * delta_time, 0, 1)
	affected_mob.setCloneLoss(0)
	affected_mob.setOxyLoss(0)
	affected_mob.heal_limb_damage(POTENCY_MULTIPLIER_VHIGH * potency, POTENCY_MULTIPLIER_VHIGH * potency)
	affected_mob.apply_damage(-POTENCY_MULTIPLIER_VHIGH * potency, TOX)
	affected_mob.hallucination = 0
	affected_mob.setBrainLoss(0)
	affected_mob.disabilities = 0
	affected_mob.sdisabilities = 0
	affected_mob.SetEyeBlur(0)
	affected_mob.SetEyeBlind(0)
	affected_mob.set_effect(0, WEAKEN)
	affected_mob.set_effect(0, STUN)
	affected_mob.set_effect(0, PARALYZE)
	affected_mob.silent = 0
	affected_mob.dizziness = 0
	affected_mob.drowsiness = 0
	affected_mob.stuttering = 0
	affected_mob.confused = 0
	affected_mob.sleeping = 0
	affected_mob.jitteriness = 0
	for(var/datum/disease/D in affected_mob.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()
	if(!ishuman(affected_mob))
		return
	var/mob/living/carbon/human/humanmob = affected_mob
	for(var/datum/internal_organ/I in humanmob.internal_organs)
		affected_mob.apply_internal_damage(-0.5 * potency * delta_time, I)

/datum/chem_property/special/omnipotent/reaction_hydro_tray(obj/structure/machinery/portable_atmospherics/hydroponics/processing_tray, potency, volume)
	. = ..()
	if(!processing_tray.seed)
		return
	processing_tray.nutrilevel += 0.5*(potency*2)*volume
	processing_tray.weedlevel += -2.5*(potency*2)*volume
	processing_tray.pestlevel += -2.5*(potency*2)*volume
	processing_tray.plant_health += 1*(potency*2)*volume
	processing_tray.yield_mod += 1*(potency*2)*volume
	processing_tray.mutation_mod += 1*(potency*2)*volume


/datum/chem_property/special/radius
	name = PROPERTY_RADIUS
	code = "RAD"
	description = "Controls the radius of a fire, using unknown means."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_UNADJUSTABLE
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
	description = "Controls the intensity of a fire, using unknown means."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_UNADJUSTABLE
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
	description = "Controls the duration of a fire, using unknown means."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_REACTANT|PROPERTY_TYPE_UNADJUSTABLE
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

/datum/chem_property/special/encephalophrasive
	name = PROPERTY_ENCEPHALOPHRASIVE
	code = "ESP"
	description = "Drastically increases the amplitude of Gamma and Beta brain waves, allowing the host to broadcast their mind."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_STIMULANT
	value = 8

/datum/chem_property/special/encephalophrasive/on_delete(mob/living/chem_host)
	..()

	chem_host.pain.recalculate_pain()
	remove_action(chem_host, /datum/action/human_action/psychic_whisper)
	to_chat(chem_host, SPAN_NOTICE("The pain in your head subsides, and you are left feeling strangely alone."))

/datum/chem_property/special/encephalophrasive/reaction_mob(mob/chem_host, method=INGEST, volume, potency)
	if(method == TOUCH)
		return
	if(!ishuman_strict(chem_host))
		return

	give_action(chem_host, /datum/action/human_action/psychic_whisper)
	to_chat(chem_host, SPAN_NOTICE("A terrible headache manifests, and suddenly it feels as though your mind is outside of your skull."))

/datum/chem_property/special/encephalophrasive/process(mob/living/chem_host, potency = 1, delta_time)
	chem_host.pain.apply_pain(1 * potency)

/datum/chem_property/special/encephalophrasive/process_overdose(mob/living/chem_host, potency = 1, delta_time)
	chem_host.apply_damage(0.5 * potency * POTENCY_MULTIPLIER_VHIGH * delta_time, BRAIN)

/datum/chem_property/special/encephalophrasive/process_critical(mob/living/chem_host, potency = 1, delta_time)
	chem_host.apply_effect(20, PARALYZE)
