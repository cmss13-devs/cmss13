////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////

/// Returns a list mapping pill icon classes to icon states
/proc/map_pill_icons()
	var/list/picks
	var/list/mappings = list()
	for(var/icon_class in PILL_ICON_CLASSES)
		if(!picks)
			picks = init_list_range(PILL_ICON_CHOICES, 1)
		mappings[icon_class] = "pill[pick_n_take(picks)]"
	// Keep extra as padding for random pills
	picks += init_list_range(PILL_ICON_CHOICES, 1)
	mappings["random"] = picks
	return mappings

/obj/item/reagent_container/pill
	name = "pill"
	icon = 'icons/obj/items/chemistry.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/medical_righthand.dmi',
	)
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = SIZE_TINY
	volume = 60
	reagent_desc_override = TRUE //it has a special examining mechanic
	ground_offset_x = 7
	ground_offset_y = 7
	var/identificable = TRUE //can medically trained people tell what's in it?
	var/pill_desc = "An unknown pill." // The real description of the pill, shown when examined by a medically trained person
	var/pill_icon_class = "random" // Pills with the same icon class share icons
	var/list/pill_initial_reagents // Default reagents if any
	var/fluff_text = "pill" //what this object is logically, used for actions descriptions like force feeding

/obj/item/reagent_container/pill/Initialize(mapload, ...)
	. = ..()
	if(pill_initial_reagents)
		for(var/reagent in pill_initial_reagents)
			reagents.add_reagent(reagent, pill_initial_reagents[reagent])
	update_icon()

/obj/item/reagent_container/pill/update_icon()
	. = ..()
	if(!icon_state)
		icon_state = GLOB.pill_icon_mappings[pill_icon_class]

/obj/item/reagent_container/pill/get_examine_text(mob/user)
	. = ..()
	if(pill_desc)
		var/pill_info = display_contents(user)
		if(pill_info)
			. += pill_info

/obj/item/reagent_container/pill/display_contents(mob/user)
	if(isxeno(user))
		return
	if(!identificable)
		return
	. = ""
	if(skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		. += "[pill_desc]\n"
	. += ..()

/obj/item/reagent_container/pill/attack(mob/M, mob/user)
	if(M == user)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				to_chat(H, SPAN_DANGER("You can't eat [fluff_text]s."))
				return

		M.visible_message(SPAN_NOTICE("[user] swallows [src]."),
		SPAN_HELPFUL("You swallow [src]."))
		var/list/reagents_in_pill = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			reagents_in_pill += R.name
		var/contained = english_list(reagents_in_pill)
		msg_admin_niche("[key_name(user)] swallowed [src] (REAGENTS: [contained]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		M.drop_inv_item_on_ground(src) //icon update
		if(reagents && reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, reagents.total_volume)

		qdel(src)
		return 1

	else if(istype(M, /mob/living/carbon/human) )
		var/mob/living/carbon/human/H = M
		if(H.species.flags & IS_SYNTHETIC)
			to_chat(H, SPAN_DANGER("They have a monitor for a head, where do you think you're going to put that?"))
			return

		user.affected_message(M,
			SPAN_HELPFUL("You <b>start feeding</b> [M] a [fluff_text]."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you a [fluff_text]."),
			SPAN_NOTICE("[user] starts feeding [M] a [fluff_text]."))

		var/ingestion_time = 30
		if(user.skills)
			ingestion_time = max(10, 30 - 10*user.skills.get_skill_level(SKILL_MEDICAL))

		if(!do_after(user, ingestion_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			return
		if(QDELETED(src))
			return

		user.drop_inv_item_on_ground(src) //icon update

		user.affected_message(M,
			SPAN_HELPFUL("You <b>fed</b> [M] a [fluff_text]."),
			SPAN_HELPFUL("[user] <b>fed</b> you a [fluff_text]."),
			SPAN_NOTICE("[user] fed [M] a [fluff_text]."))
		user.count_niche_stat(STATISTICS_NICHE_PILLS)

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [key_name(user)] Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [key_name(M)] Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		if(reagents && reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, reagents.total_volume)
		qdel(src)

		return 1

	return 0

/obj/item/reagent_container/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(target.is_open_container() != 0 && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target] is empty. Can't dissolve [fluff_text]."))
			return
		to_chat(user, SPAN_NOTICE("You dissolve the [fluff_text] in [target]"))

		var/rgt_list_text = get_reagent_list_text()

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a [fluff_text]. Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] spiked \a [target] with a [fluff_text] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message(SPAN_DANGER("[user] puts something in \the [target]."), SHOW_MESSAGE_VISIBLE)

		QDEL_IN(src, 5)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_container/pill/antitox
	pill_desc = "An anti-toxin pill. It neutralizes many common toxins, as well as treating toxin damage"
	pill_initial_reagents = list("anti_toxin" = 15)
	pill_icon_class = "atox"

/obj/item/reagent_container/pill/tox
	pill_desc = "A toxins pill. It's highly toxic."
	pill_initial_reagents = list("toxin" = 50)
	pill_icon_class = "tox"

/obj/item/reagent_container/pill/cyanide
	desc = "A cyanide pill. Don't swallow this!"
	pill_desc = null//so even non medics can see what this pill is.
	pill_initial_reagents = list("cyanide" = 50)
	pill_icon_class = "tox"

/obj/item/reagent_container/pill/stox
	pill_desc = "A sleeping pill commonly used to treat insomnia."
	pill_initial_reagents = list("stoxin" = 15)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/kelotane
	pill_desc = "A Kelotane pill. Used to treat burns."
	pill_initial_reagents = list("kelotane" = 15)
	pill_icon_class = "kelo"

/obj/item/reagent_container/pill/oxycodone
	pill_desc = "A Oxycodone pill. A powerful painkiller."
	pill_initial_reagents = list("oxycodone" = 15)
	pill_icon_class = "oxy"

/obj/item/reagent_container/pill/paracetamol
	pill_desc = "A Paracetamol pill. Painkiller for the ages."
	pill_initial_reagents = list("paracetamol" = 15)
	pill_icon_class = "para"

/obj/item/reagent_container/pill/tramadol
	pill_desc = "A Tramadol pill. A simple painkiller."
	pill_initial_reagents = list("tramadol" = 15)
	pill_icon_class = "tram"

/obj/item/reagent_container/pill/methylphenidate
	pill_desc = "A Methylphenidate pill. This improves the ability to concentrate."
	pill_initial_reagents = list("methylphenidate" = 15)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/citalopram
	pill_desc = "A Citalopram pill. A mild anti-depressant."
	pill_initial_reagents = list("citalopram" = 15)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/inaprovaline
	pill_desc = "An Inaprovaline pill. Used to stabilize patients."
	pill_initial_reagents = list("inaprovaline" = 30)
	pill_icon_class = "inap"

/obj/item/reagent_container/pill/dexalin
	pill_desc = "A Dexalin pill. Used to treat oxygen deprivation."
	pill_initial_reagents = list("dexalin" = 15)
	pill_icon_class = "dex"

/obj/item/reagent_container/pill/spaceacillin
	pill_desc = "A Spaceacillin pill. Used to slow down viral infections."
	pill_initial_reagents = list("spaceacillin" = 10)
	pill_icon_class = "spac"

/obj/item/reagent_container/pill/happy
	pill_desc = "A Happy Pill! Happy happy joy joy!"
	pill_initial_reagents = list("space_drugs" = 15, "sugar" = 15)
	pill_icon_class = "drug"

/obj/item/reagent_container/pill/zombie_powder
	desc = "A strange pill that smells like death itself."
	pill_desc = "A strange pill that smells like death itself."
	pill_initial_reagents = list("zombiepowder" = 8, "copper" = 2) //roughly two minutes of death
	pill_icon_class = "drug"

/obj/item/reagent_container/pill/russianRed
	pill_desc = "A Russian Red pill. A very dangerous radiation-countering substance."
	pill_initial_reagents = list("russianred" = 10)
	pill_icon_class = "spac"
/obj/item/reagent_container/pill/peridaxon
	pill_desc = "A Peridaxon pill. Temporarily halts the effects of internal organ damage."
	pill_initial_reagents = list("peridaxon" = 7)
	pill_icon_class = "peri"

/obj/item/reagent_container/pill/imidazoline
	pill_desc = "An Imidazoline pill. Heals eye damage."
	pill_initial_reagents = list("imidazoline" = 10)
	pill_icon_class = "imi"

/obj/item/reagent_container/pill/alkysine
	pill_desc = "An Alkysine pill. Heals brain damage."
	pill_initial_reagents = list("alkysine" = 10)
	pill_icon_class = "alky"

/obj/item/reagent_container/pill/bicaridine
	pill_desc = "A Bicaridine pill. Heals brute damage."
	pill_initial_reagents = list("bicaridine" = 15)
	pill_icon_class = "bica"

/obj/item/reagent_container/pill/ultrazine
	pill_desc = "An Ultrazine pill. A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive."
	pill_initial_reagents = list("ultrazine" = 5)
	pill_icon_class = "psych"

/obj/item/reagent_container/pill/ultrazine/unmarked
	pill_desc = "An unknown pill." // Or is it ?

/obj/item/reagent_container/pill/tricordrazine
	pill_desc = "A Tricordrazine pill. A weak general use medicine for treating damage."
	pill_initial_reagents = list("tricordrazine" = 15)
	pill_icon_class = "tric"

/obj/item/reagent_container/pill/stimulant
	pill_initial_reagents = list("antag_stimulant" = 10)
	pill_icon_class = "stim"
