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
	possible_transfer_amounts = list(5,10,15,30)
	flags_atom = FPRINT|OPENCONTAINER
	flags_equip_slot = SLOT_WAIST
	matter = list("plastic" = 1250, "glass" = 250)
	var/skilllock = SKILL_MEDICAL_TRAINED
	var/magfed = TRUE
	var/obj/item/reagent_container/glass/beaker/vial/mag
	var/injectSFX = 'sound/items/hypospray.ogg'
	var/injectVOL = 60//was 50

//Transfer amount switch//
/obj/item/reagent_container/hypospray/clicked(var/mob/user, var/list/mods)
	if(isnull(possible_transfer_amounts) || !(mods["alt"] && user.Adjacent(src)))//Autoinjectors aren't supposed to have toggleable transfer amounts
		return ..()
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, possible_transfer_amounts)
	playsound(loc, 'sound/items/Screwdriver2.ogg', 20, 1, 3)
	to_chat(user, SPAN_NOTICE("You set [src]'s dose to [amount_per_transfer_from_this] units."))
	return TRUE

//Unloads the vial, transfers reagents back to it, but doesn't move the vial anywhere itself//
/obj/item/reagent_container/hypospray/proc/hypounload(var/obj/item/reagent_container/glass/beaker/vial/VU)
	flags_atom ^= OPENCONTAINER//So that reagents can't be added to the now-empty hypo.
	if(reagents.total_volume)
		reagents.trans_to(VU, reagents.total_volume)//Might bug if a vial was varedited to hold more than 30u or a hypo edited to have a larger volume. Should still function but some reagents would vanish.
	mag.update_icon()
	mag = null
	update_icon()

//Loads the vial, transfers reagents to hypo, but does not move the vial anywhere itself.
/obj/item/reagent_container/hypospray/proc/hypoload(var/obj/item/reagent_container/glass/beaker/vial/VL)
	flags_atom |= OPENCONTAINER
	playsound(loc, 'sound/weapons/handling/safety_toggle.ogg', 25, 1, 6)
	if(VL.reagents.total_volume)
		VL.reagents.trans_to(src, VL.reagents.total_volume)//Might bug if a vial was varedited to hold more than 30u or a hypo edited to have a larger volume. Should still function but some reagents would vanish.
	mag = VL
	update_icon()

//Unloads vial, if any, to a hand or the floor, waits, loads in a defined new one. Early-aborts if user has no medical skills.
/obj/item/reagent_container/hypospray/proc/hypotacreload(var/obj/item/reagent_container/glass/beaker/vial/VR, var/mob/living/carbon/human/HM)
	if(!skillcheck(HM, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		to_chat(HM, SPAN_WARNING("You aren't experienced enough to load this any faster."))
		return
	if(mag)
		if(src == HM.get_active_hand())
			HM.swap_hand()
		HM.put_in_hands(mag)
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 1, 6)
		hypounload(mag)
		to_chat(HM, SPAN_NOTICE("You begin swapping vials."))
	if(do_after(HM, 1.25 SECONDS, INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && !mag && get_dist(VR, src) <= 1)
		HM.drop_inv_item_to_loc(VR, src)
		hypoload(VR)

/obj/item/reagent_container/hypospray/attackby(obj/item/B, mob/living/user)
	if(istype(B,/obj/item/storage)) // If we're hit by a storage-level item, defer to the storage.
		..(B, user)
		return
	if(magfed && !mag)//Is there a vial?
		if(istype(B,/obj/item/reagent_container/glass/beaker/vial) && src == user.get_inactive_hand())//Is this a new vial being inserted into a hypospray held in the other hand?
			to_chat(user, SPAN_NOTICE("You add \the [B] to [src]."))
			user.drop_inv_item_to_loc(B, src)
			hypoload(B)
		else
			to_chat(user, SPAN_DANGER("[src] has no vial."))//Can't fill a hypo with no storage.
		return TRUE

/obj/item/reagent_container/hypospray/attack_hand(mob/user as mob)
	if(mag && src == user.get_inactive_hand())
		user.put_in_hands(mag)
		playsound(loc, 'sound/items/Screwdriver2.ogg', 25, 1, 6)
		hypounload(mag)
		return
	. = ..()

/obj/item/reagent_container/hypospray/on_reagent_change()
	update_icon()

/obj/item/reagent_container/hypospray/update_icon()
	var/icon_name = "hypo"
	overlays.Cut()
	if(!mag)
		icon_name += "_e"
	icon_state = icon_name
	if(reagents.total_volume)
		var/rounded_vol = round(reagents.total_volume,5)
		var/image/magfill = image('icons/obj/items/reagentfillings.dmi', src, "hypo-5")
		magfill.icon_state = "hypo-[rounded_vol]"
		magfill.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += magfill

/obj/item/reagent_container/hypospray/attack_self(mob/user as mob)
	if (world.time <= user.next_move)
		return
	attack(user, user)
	user.next_move += attack_speed
	return

/obj/item/reagent_container/hypospray/afterattack(obj/target, mob/user, proximity)
	if(!magfed || !proximity)//Autoinjectors aren't supposed to be self-fillable or use vials.
		return
	if(istype(target,/obj/structure/reagent_dispensers))//Stolen from beaker code, receive only - highly doubt anyone would intentionally use a hypo to fill a reagent tank.
		if(!mag)
			to_chat(user, SPAN_DANGER("[src] has no vial."))
		else
			var/obj/structure/reagent_dispensers/B = target
			if(B.dispensing)
				if(!B.reagents || !B.reagents.total_volume)
					to_chat(user, SPAN_WARNING("[B] is empty."))
					return
				var/amount_transferred = B.reagents.trans_to(src, B.amount_per_transfer_from_this)
				if(!amount_transferred)
					to_chat(user, SPAN_WARNING("[src] is already full."))
				else
					to_chat(user, SPAN_NOTICE("You fill [src] with [amount_transferred] units from [B]."))
		return

//Tac reload, hypo initiating
	if(istype(target,/obj/item/reagent_container/glass/beaker/vial))
		hypotacreload(target,user)

//Tac reload, click-drag from vial initiating
/obj/item/reagent_container/hypospray/MouseDrop_T(atom/dropping, mob/living/carbon/human/user)
	if(!magfed || !istype(dropping, /obj/item/reagent_container/glass/beaker/vial))//Autoinjectors don't use vials.
		..()
		return
	if(!user.Adjacent(dropping) || !istype(user) || user.is_mob_incapacitated(TRUE))
		return
	if(src != user.r_hand && src != user.l_hand)
		to_chat(user, SPAN_WARNING("[src] must be in your hand to do that."))
		return
	hypotacreload(dropping,user)

/obj/item/reagent_container/hypospray/examine(mob/user)
	..()
	if(magfed)
		if(mag)
			to_chat(user, SPAN_NOTICE("It is loaded with \a [mag], containing [reagents.total_volume] units."))
		else
			to_chat(user, SPAN_NOTICE("It is unloaded."))
		to_chat(user, SPAN_NOTICE("It is set to administer [amount_per_transfer_from_this] units per dose."))

/obj/item/reagent_container/hypospray/attack(mob/M, mob/living/user)
	if(!mag && magfed)
		to_chat(user, SPAN_DANGER("[src] has no vial!"))
		return
	if(!reagents || !reagents.total_volume)
		to_chat(user, SPAN_DANGER("[src] is empty."))
		return

	if(!istype(M))
		return

	if(skilllock == SKILL_MEDICAL_TRAINED && !skillcheck(user, SKILL_MEDICAL, SKILL_MEDICAL_TRAINED))
		user.visible_message(SPAN_WARNING("[user] fumbles with [src]..."), SPAN_WARNING("You fumble with [src]..."))
		if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			return
	else if(!skillcheck(user, SKILL_MEDICAL, skilllock))
		to_chat(user, SPAN_WARNING("The [src] beeps and refuses to inject: Insufficient training or clearance!"))
		return
	var/toxin = 0
	for(var/datum/reagent/R in reagents.reagent_list)
		if(istype(R, /datum/reagent/toxin) || istype(R, /datum/reagent/ethanol))
			toxin = 1
			break
	if(toxin)
		if(!do_after(user, 20, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			return 0
		if(!M.Adjacent(user))
			return 0
	if(M != user && M.stat != DEAD && M.a_intent != INTENT_HELP && !M.is_mob_incapacitated() && (skillcheck(M, SKILL_CQC, SKILL_CQC_MP) || isYautja(M))) // preds have null skills
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
	playsound(loc, injectSFX, injectVOL, 1)

	reagents.reaction(M, INGEST)
	if(M.reagents)
		var/list/injected = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			injected += R.name
			R.last_source_mob = user
		var/contained = english_list(injected)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [src.name] by [key_name(user)]. Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to inject [key_name(M)]. Reagents: [contained]</font>")
		msg_admin_attack("[key_name(user)] injected [key_name(M)] with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
		if(mag)
			to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in [src]'s [mag.name]."))
		else
			to_chat(user, SPAN_NOTICE("[trans] units injected. [reagents.total_volume] units remaining in [src]."))
	return 1

/obj/item/reagent_container/hypospray/Initialize()
	. = ..()
	if(magfed)//Autoinjectors don't need vials.
		mag = new /obj/item/reagent_container/glass/beaker/vial(src)//No reagent transfer, vial's empty.
		update_icon()

/obj/item/reagent_container/hypospray/tricordrazine

/obj/item/reagent_container/hypospray/tricordrazine/Initialize()
	. = ..()
	mag = new /obj/item/reagent_container/glass/beaker/vial/tricordrazine(src)
	if(mag.reagents.total_volume)
		mag.reagents.trans_to(src, mag.reagents.total_volume)

/obj/item/reagent_container/hypospray/sedative
	name = "Sedative Hypospray"

/obj/item/reagent_container/hypospray/sedative/Initialize()
	. = ..()
	mag = new /obj/item/reagent_container/glass/beaker/vial/sedative(src)
	if(mag.reagents.total_volume)
		mag.reagents.trans_to(src, mag.reagents.total_volume)
