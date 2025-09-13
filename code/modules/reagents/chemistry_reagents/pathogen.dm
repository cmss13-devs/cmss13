/datum/reagent/blood/xeno_blood/blight
	name = "Blight Fluid"
	id = BLOOD_BLIGHT
	description = "What is this...?"
	color = "#ceb8b0"
	overdose = REAGENTS_OVERDOSE
	overdose_critical = REAGENTS_OVERDOSE_CRITICAL
	chemclass = CHEM_CLASS_SPECIAL
	objective_value = OBJECTIVE_EXTREME_VALUE
	properties = list(PROPERTY_PAINING = 2, PROPERTY_FLUXING = 3, PROPERTY_HEMOSITIC = 2)
	flags = REAGENT_NO_GENERATION

/datum/reagent/blood/xeno_blood/blight/on_mob_life(mob/living/M)
	. = ..()
	if(!.)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if((locate(/obj/item/alien_embryo) in H.contents) || (H.species.flags & IS_SYNTHETIC) || !H.huggable)
			volume = 0
			return
		if(volume < overdose_critical)
			return
		//it turns into an actual bloodburster at this point
		volume = 0
		new /obj/item/alien_embryo/bloodburster(H)
		to_chat(H, SPAN_WARNING("Your body tremors as something moves under your skin!"))

/datum/reagent/toxin/mycotoxin
	name = "Mycotoxin"
	id = "mycotoxin"
	description = "A deadly neurotoxin produced by an unknown fungus."
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	properties = list(PROPERTY_TOXIC = 2, PROPERTY_HEMORRAGING = 2, PROPERTY_HEPATOTOXIC = 2, PROPERTY_HEMOLYTIC = 1, PROPERTY_HYPOXEMIC = 1, PROPERTY_MYCOTAINTED = 1)
	flags = REAGENT_NO_GENERATION|REAGENT_SCANNABLE
	overdose = 0.1
	overdose_critical = 0.1

/datum/reagent/toxin/mycotoxin/enhanced
	id = "mycotoxin_e"
	properties = list(PROPERTY_TOXIC = 5, PROPERTY_HEMORRAGING = 5, PROPERTY_HEPATOTOXIC = 5, PROPERTY_HEMOLYTIC = 3, PROPERTY_HYPOXEMIC = 3, PROPERTY_MYCOTAINTED = 1)

/datum/chem_property/special/mycotainted
	name = PROPERTY_MYCOTAINTED
	code = "MYC"
	description = "Tainted by mycelial spores, surely this can't be a good thing."
	category = PROPERTY_TYPE_ANOMALOUS

/datum/chem_property/special/mycotainted/process_dead(mob/living/affected_mob, potency = 1, delta_time)
	if(!ishuman(affected_mob))
		return FALSE
	var/mob/living/carbon/human/dead = affected_mob
	var/revivable = dead.is_revivable(TRUE)//We don't need a heart.
	if(!revivable)
		return FALSE

	dead.revive(TRUE)
	addtimer(CALLBACK(src, PROC_REF(make_walker), dead), 1 SECONDS)
	return TRUE

/datum/chem_property/special/mycotainted/proc/make_walker(mob/living/carbon/human/dead)
	dead.set_species(SPECIES_PATHO_WALKER)
	var/datum/species/pathogen_walker/walker = GLOB.all_species[SPECIES_PATHO_WALKER]
	walker.handle_alert_ghost(dead)
	return TRUE

/datum/chem_property/special/mycotainted/trigger()
	SSticker.mode.get_specific_call(/datum/emergency_call/cbrn/pathogen, TRUE, TRUE, holder.name) // "Weyland-Yutani Goon (Chemical Investigation Squad)"
	GLOB.chemical_data.update_credits(15)
	message_admins("The research department has discovered Mycotainted traits in [holder.name] adding 15 bonus tech points.")
	var/datum/techtree/tree = GET_TREE(TREE_MARINE)
	tree.add_points(15)
	ai_announcement("NOTICE: Encrypted data transmission received from USCSS Royce. Shuttle inbound.")
