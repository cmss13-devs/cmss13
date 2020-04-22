////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/items/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	flags_atom = FPRINT
	flags_equip_slot = SLOT_WAIST
	var/skilllock = 1
	var/obj/item/reagent_container/glass/beaker/vial/mag
	var/locked = TRUE

/obj/item/reagent_container/hypospray/attackby(obj/item/B, mob/living/user)
	if(isscrewdriver(B))
		locked = !locked
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 0, 6)
		if(locked)
			to_chat(user, SPAN_NOTICE("You lock [src]."))
		else
			to_chat(user, SPAN_NOTICE("You unlock [src]."))
		return
	if(mag && istype(B,/obj/item/reagent_container))
		if(B.reagents)
			var/obj/item/reagent_container/C = B
			B.reagents.trans_to(mag, C.amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE("You transfer [C.amount_per_transfer_from_this] units from [B] to [src]."))
			return
	if(locked)
		return
	if(istype(B,/obj/item/reagent_container/glass/beaker/vial))
		if(user.drop_held_item())
			B.forceMove(src)
			mag = B
			to_chat(user, SPAN_NOTICE("You add \the [B] to [src]."))

/obj/item/reagent_container/hypospray/attack_hand(mob/user as mob)
	if(!locked && mag)
		mag.update_icon()
		user.put_in_hands(mag)
		mag = null
		return
	. = ..()

/obj/item/reagent_container/hypospray/attack(mob/M, mob/living/user)
	var/datum/reagents/liquid
	if(istype(src,/obj/item/reagent_container/hypospray/autoinjector))
		liquid = reagents
	else if(mag)
		liquid = mag.reagents
	if(!liquid)
		to_chat(user, SPAN_DANGER("[src] is empty."))
		return
	if((!liquid.total_volume))
		to_chat(user, SPAN_DANGER("[src] is empty."))
		return
	if(!istype(M))
		return

	if(skilllock && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_CHEM))
		user.visible_message(SPAN_WARNING("[user] fumbles with [src]..."), SPAN_WARNING("You fumble with [src]..."))
		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			return
	var/sleeptoxin = 0
	for(var/datum/reagent/R in liquid.reagent_list)
		if(istype(R, /datum/reagent/toxin/chloralhydrate) || istype(R, /datum/reagent/toxin/stoxin) || istype(R, /datum/reagent/suxamorycin))
			sleeptoxin = 1
			break
	if(sleeptoxin)
		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return 0
		if(!M.Adjacent(user))
			return 0
	if(M != user && M.stat != DEAD && M.a_intent != "help" && !M.is_mob_incapacitated() && (skillcheck(M, SKILL_CQC, SKILL_CQC_MP) || isYautja(M))) // preds have null skills
		user.KnockDown(3)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Used CQC skill to stop [key_name(user)] injecting them.</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Was stopped from injecting [key_name(M)] by their cqc skill.</font>")
		msg_admin_attack("[key_name(user)] got robusted by the CQC of [key_name(M)] in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)
		M.visible_message(SPAN_DANGER("[M]'s reflexes kick in and knock [user] to the ground before they could use \the [src]'!"), \
			SPAN_WARNING("You knock [user] to the ground before they inject you!"), null, 5)
		playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 25, 1, 7)
		return 0

	to_chat(user, SPAN_NOTICE(" You inject [M] with [src]."))
	to_chat(M, SPAN_WARNING("You feel a tiny prick!"))
	playsound(loc, 'sound/items/hypospray.ogg', 50, 1)

	liquid.reaction(M, INGEST)
	if(M.reagents)
		var/list/injected = list()
		for(var/datum/reagent/R in liquid.reagent_list)
			injected += R.name
			R.last_source_mob = user
		var/contained = english_list(injected)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [key_name(user)]. Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [key_name(M)]. Reagents: [contained]</font>")
		msg_admin_attack("[key_name(user)] injected [key_name(M)] with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(user.a_intent)]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		var/trans = liquid.trans_to(M, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE(" [trans] units injected. [liquid.total_volume] units remaining in [src]."))

	return 1

/obj/item/reagent_container/hypospray/tricordrazine
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients. Contains tricordrazine."
	volume = 30

/obj/item/reagent_container/hypospray/tricordrazine/New()
	..()
	mag = new /obj/item/reagent_container/glass/beaker/vial/tricordrazine(src)

/obj/item/reagent_container/hypospray/sedative
	name = "Sedative Hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients. Contains sedatives."
	volume = 30

/obj/item/reagent_container/hypospray/sedative/New()
	..()
	mag = new /obj/item/reagent_container/glass/beaker/vial/sedative(src)