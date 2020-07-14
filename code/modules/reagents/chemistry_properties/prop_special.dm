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

/datum/chem_property/special/boosting/pre_process(mob/living/M)
	return list(REAGENT_BOOST = level)

/datum/chem_property/special/hypergenetic
	name = PROPERTY_HYPERGENETIC
	code = "HGN"
	description = "Regenerates all types of cell membranes mending damage in all organs and limbs."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_MEDICINE

/datum/chem_property/special/hypergenetic/process(mob/living/M, var/potency = 1)
	M.heal_limb_damage(0.2+potency)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	for(var/datum/internal_organ/O in H.internal_organs)
		M.apply_internal_damage(-potency, O)

/datum/chem_property/special/hypergenetic/process_overdose(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(2*potency)

/datum/chem_property/special/hypergenetic/process_critical(mob/living/M, var/potency = 1)
	M.take_limb_damage(3*potency,3*potency)

/datum/chem_property/special/DNA_Disintegrating
	name = PROPERTY_DNA_DISINTEGRATING
	code = "DDI"
	description = "Immediately disintegrates the DNA of all organic cells it comes into contact with. This property is highly valued by WY."
	rarity = PROPERTY_LEGENDARY
	category = PROPERTY_TYPE_TOXICANT|PROPERTY_TYPE_ANOMALOUS
	value = 16

/datum/chem_property/special/DNA_Disintegrating/process(mob/living/M, var/potency = 1)
	M.adjustCloneLoss(10*potency)
	if(ishuman(M) && M.cloneloss >= 190)
		var/mob/living/carbon/human/H = M
		H.contract_disease(new /datum/disease/xeno_transformation(0),1) //This is the real reason PMCs are being sent to retrieve it.

/datum/chem_property/special/DNA_Disintegrating/trigger()
	ticker.mode.get_specific_call("Weston-Yamada PMC (Chemical Investigation Squad)", TRUE, FALSE, holder.name)
	chemical_research_data.update_credits(10)
	message_admins(SPAN_NOTICE("The research department has discovered DNA_Disintegrating in [holder.name] adding [OBJECTIVE_ABSOLUTE_VALUE * 2] bonus DEFCON points."), 1)
	objectives_controller.add_admin_points(OBJECTIVE_ABSOLUTE_VALUE * 2)
	ai_announcement("NOTICE: $20000 received from USCSS Royce. Shuttle inbound.")

/datum/chem_property/special/ciphering
	name = PROPERTY_CIPHERING
	code = "CIP"
	description = "This extremely complex chemical structure represents some kind of biological cipher."
	rarity = PROPERTY_DISABLED
	category = PROPERTY_TYPE_ANOMALOUS
	value = 16

/datum/chem_property/special/ciphering/process(mob/living/M, var/potency = 1)
	if(!hive_datum[level]) // This should probably always be valid
		return

	for(var/content in M.contents)
		if(!istype(content, /obj/item/alien_embryo))
			continue
		var/obj/item/alien_embryo/A = content
		A.hivenumber = level
		A.faction = hive_datum[level].name

/datum/chem_property/special/ciphering/predator
	name = PROPERTY_CIPHERING_PREDATOR
	code = "PCI"
	rarity = PROPERTY_DISABLED // this one should always be disabled, even if ciphering is not

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

/datum/chem_property/special/embryonic/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC)) //No effect if already infected
		return
	for(var/i=1,i<=max((potency % 100)/10,1),i++)//10's determine number of embryos
		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		embryo.hivenumber = min(potency % 10,5) //1's determine hivenumber
		embryo.faction = FACTION_LIST_XENOMORPH[embryo.hivenumber]

/datum/chem_property/special/transforming
	name = PROPERTY_TRANSFORMING
	code = "HGN"
	description = "The chemical agent carries REDACTED, altering the host psychologically and physically."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/transforming/process(mob/living/M, var/potency = 1)
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

/datum/chem_property/special/ravening/process(mob/living/M, var/potency = 1)
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

/datum/chem_property/special/curing/process(mob/living/M, var/potency = 1)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.viruses)
		for(var/datum/disease/D in H.viruses)
			if(potency >= 2)
				D.cure()
				H.regenZ = 0
			else
				if(D.name == "Unknown Mutagenic Disease" && (potency == 0.5 || potency > 1.5))
					D.cure()
				if(D.name == "Black Goo" && potency >= 1)
					D.cure()
					H.regenZ = 0

/datum/chem_property/special/omnipotent
	name = PROPERTY_OMNIPOTENT
	code = "OMN"
	description = "Fully revitalizes all bodily functions."
	rarity = PROPERTY_ADMIN
	category = PROPERTY_TYPE_MEDICINE|PROPERTY_TYPE_ANOMALOUS
	value = 666

/datum/chem_property/special/omnipotent/process(mob/living/M, var/potency = 1)
	M.reagents.remove_all_type(/datum/reagent/toxin, 5*REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.heal_limb_damage(5*potency,5*potency)
	M.apply_damage(-5*potency, TOX)
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
		M.apply_internal_damage(1, I)
