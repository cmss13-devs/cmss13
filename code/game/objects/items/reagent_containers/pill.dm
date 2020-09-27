////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////

//randomizing pill icons
var/global/list/randomized_pill_icons


/obj/item/reagent_container/pill
	name = "pill"
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = SIZE_TINY
	volume = 60
	var/pill_desc = "An unknown pill." //the real description of the pill, shown when examined by a medically trained person

/obj/item/reagent_container/pill/Initialize()
	. = ..()
	if(!randomized_pill_icons)
		var/allowed_numbers = list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)
		randomized_pill_icons = list()
		for(var/i = 1 to 21)
			randomized_pill_icons += "pill[pick_n_take(allowed_numbers)]"
	if(!icon_state)
		icon_state = "pill[rand(1,21)]"


/obj/item/reagent_container/pill/examine(mob/user)
	..()
	if(pill_desc)
		display_contents(user)

/obj/item/reagent_container/pill/attack_self(mob/user as mob)
	return

/obj/item/reagent_container/pill/attack(mob/M, mob/user, def_zone)
	if(M == user)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				to_chat(H, SPAN_DANGER("You can't eat pills."))
				return

		M.visible_message(SPAN_NOTICE("[user] swallows [src]."),
			SPAN_HELPFUL("You swallow [src]."))
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
			SPAN_HELPFUL("You <b>start feeding</b> [user == M ? "yourself" : "[M]"] a pill."),
			SPAN_HELPFUL("[user] <b>starts feeding</b> you a pill."),
			SPAN_NOTICE("[user] starts feeding [user == M ? "themselves" : "[M]"] a pill."))

		var/ingestion_time = 30
		if(user.skills)
			ingestion_time = max(10, 30 - 10*user.skills.get_skill_level(SKILL_MEDICAL))

		if(!do_after(user, ingestion_time, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL)) return

		user.drop_inv_item_on_ground(src) //icon update
		
		user.affected_message(M,
			SPAN_HELPFUL("You [user == M ? "<b>swallowed</b>" : "<b>fed</b> [M]"] a pill."),
			SPAN_HELPFUL("[user] <b>fed</b> you a pill."),
			SPAN_NOTICE("[user] [user == M ? "swallowed" : "fed [M]"] a pill."))
		user.count_niche_stat(STATISTICS_NICHE_PILLS)

		var/rgt_list_text = get_reagent_list_text()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [key_name(user)] Reagents: [rgt_list_text]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [M.name] by [key_name(M)] Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		if(reagents && reagents.total_volume)
			reagents.set_source_mob(user)
			reagents.trans_to_ingest(M, reagents.total_volume)
			qdel(src)
		else
			qdel(src)

		return 1

	return 0

/obj/item/reagent_container/pill/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(target.is_open_container() != 0 && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_DANGER("[target] is empty. Cant dissolve pill."))
			return
		to_chat(user, SPAN_NOTICE("You dissolve the pill in [target]"))

		var/rgt_list_text = get_reagent_list_text()

		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a pill. Reagents: [rgt_list_text]</font>")
		msg_admin_attack("[key_name(user)] spiked \a [target] with a pill (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		reagents.trans_to(target, reagents.total_volume)
		for(var/mob/O in viewers(2, user))
			O.show_message(SPAN_DANGER("[user] puts something in \the [target]."), 1)

		QDEL_IN(src, 5)

	return

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_container/pill/antitox
	pill_desc = "An anti-toxins pill. It neutralizes many common toxins."

/obj/item/reagent_container/pill/antitox/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[1]
	reagents.add_reagent("anti_toxin", 15)

/obj/item/reagent_container/pill/tox
	pill_desc = "A toxins pill. It's highly toxic."

/obj/item/reagent_container/pill/tox/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[2]
	reagents.add_reagent("toxin", 50)

/obj/item/reagent_container/pill/cyanide
	desc = "A cyanide pill. Don't swallow this!"
	pill_desc = null//so even non medics can see what this pill is.

/obj/item/reagent_container/pill/cyanide/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[2]
	reagents.add_reagent("cyanide", 50)

/obj/item/reagent_container/pill/adminordrazine
	pill_desc = "An Adminordrazine pill. It's magic. We don't have to explain it."

/obj/item/reagent_container/pill/adminordrazine/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[3]
	reagents.add_reagent("adminordrazine", 50)

/obj/item/reagent_container/pill/stox
	pill_desc = "A sleeping pill commonly used to treat insomnia."

/obj/item/reagent_container/pill/stox/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[4]
	reagents.add_reagent("stoxin", 15)

/obj/item/reagent_container/pill/kelotane
	pill_desc = "A Kelotane pill. Used to treat burns."

/obj/item/reagent_container/pill/kelotane/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[5]
	reagents.add_reagent("kelotane", 15)

/obj/item/reagent_container/pill/paracetamol
	pill_desc = "A Paracetamol pill. Painkiller for the ages."

/obj/item/reagent_container/pill/paracetamol/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[6]
	reagents.add_reagent("paracetamol", 15)

/obj/item/reagent_container/pill/tramadol
	pill_desc = "A Tramadol pill. A simple painkiller."

/obj/item/reagent_container/pill/tramadol/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[7]
	reagents.add_reagent("tramadol", 15)


/obj/item/reagent_container/pill/methylphenidate
	pill_desc = "A Methylphenidate pill. This improves the ability to concentrate."

/obj/item/reagent_container/pill/methylphenidate/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[8]
	reagents.add_reagent("methylphenidate", 15)

/obj/item/reagent_container/pill/citalopram
	pill_desc = "A Citalopram pill. A mild anti-depressant."

/obj/item/reagent_container/pill/citalopram/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[9]
	reagents.add_reagent("citalopram", 15)


/obj/item/reagent_container/pill/inaprovaline
	pill_desc = "An Inaprovaline pill. Used to stabilize patients."

/obj/item/reagent_container/pill/inaprovaline/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[10]
	reagents.add_reagent("inaprovaline", 30)

/obj/item/reagent_container/pill/dexalin
	pill_desc = "A Dexalin pill. Used to treat oxygen deprivation."

/obj/item/reagent_container/pill/dexalin/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[11]
	reagents.add_reagent("dexalin", 15)

/obj/item/reagent_container/pill/spaceacillin
	pill_desc = "A Spaceacillin pill. Used to slow down viral infections."

/obj/item/reagent_container/pill/spaceacillin/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[12]
	reagents.add_reagent("spaceacillin", 10)

/obj/item/reagent_container/pill/happy
	pill_desc = "A Happy Pill! Happy happy joy joy!"

/obj/item/reagent_container/pill/happy/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[13]
	reagents.add_reagent("space_drugs", 15)
	reagents.add_reagent("sugar", 15)

/obj/item/reagent_container/pill/zoom
	pill_desc = "A Zoom pill! Gotta go fast!"

/obj/item/reagent_container/pill/zoom/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[14]
	reagents.add_reagent("impedrezene", 10)
	reagents.add_reagent("synaptizine", 5)
	reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_container/pill/russianRed
	pill_desc = "A Russian Red pill. A very dangerous radiation-countering substance."

/obj/item/reagent_container/pill/russianRed/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[15]
	reagents.add_reagent("russianred", 10)


/obj/item/reagent_container/pill/peridaxon
	pill_desc = "A Peridaxon pill. Heals internal organ damage."

/obj/item/reagent_container/pill/peridaxon/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[16]
	reagents.add_reagent("peridaxon", 7)


/obj/item/reagent_container/pill/imidazoline
	pill_desc = "An Imidazoline pill. Heals eye damage."

/obj/item/reagent_container/pill/imidazoline/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[17]
	reagents.add_reagent("imidazoline", 10)


/obj/item/reagent_container/pill/alkysine
	pill_desc = "An Alkysine pill. Heals brain damage."

/obj/item/reagent_container/pill/alkysine/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[18]
	reagents.add_reagent("alkysine", 10)


/obj/item/reagent_container/pill/bicaridine
	pill_desc = "A Bicaridine pill. Heals brute damage."

/obj/item/reagent_container/pill/bicaridine/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[19]
	reagents.add_reagent("bicaridine", 15)

/obj/item/reagent_container/pill/quickclot
	pill_desc = "A Quickclot pill. Stabilizes internal bleeding temporarily."

/obj/item/reagent_container/pill/quickclot/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[20]
	reagents.add_reagent("quickclot", 7)

/obj/item/reagent_container/pill/ultrazine
	//pill_desc = "An Ultrazine pill. A highly-potent, long-lasting combination CNS and muscle stimulant. Extremely addictive."

/obj/item/reagent_container/pill/ultrazine/Initialize()
	. = ..()
	icon_state = randomized_pill_icons[21]
	reagents.add_reagent("ultrazine", 5)
