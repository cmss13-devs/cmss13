GLOBAL_LIST_EMPTY_TYPED(radio_packs, /obj/item/storage/backpack/marine/satchel/rto)

/obj/item/storage/backpack/marine/satchel/rto
	name = "\improper USCM Radio Telephone Pack"
	desc = "A heavy-duty pack, used for telecommunications between central command. Commonly carried by RTOs."
	icon_state = "rto_backpack"
	item_state = "rto_backpack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	actions_types = list(/datum/action/item_action/rto_pack/use_phone)

	flags_item = ITEM_OVERRIDE_NORTHFACE

	var/obj/structure/transmitter/internal/internal_transmitter

	var/phone_category = PHONE_MARINE
	var/list/networks_receive = list(FACTION_MARINE)
	var/list/networks_transmit = list(FACTION_MARINE)
	var/base_icon
	var/deployed_icon = "rto_backpack_deployed";
	var/assemble_time = 2;
	var/disassemble_time = 3;

/obj/item/storage/backpack/marine/satchel/rto/attack_self(mob/user)
	if(!(user.a_intent & INTENT_HELP || user.a_intent &INTENT_HARM))
		deploy_rto(user)
		return
	..()

/obj/item/storage/backpack/marine/satchel/rto/verb/deploy_rto_verb()
	set name = "Deploy"
	set category = "Object"
	set src in usr
	var/mob/user_mob = usr


	deploy_rto(user_mob)

/obj/item/storage/backpack/marine/satchel/rto/proc/deploy_rto(mob/living/user)
	if(user.action_busy)
		return

	if (user.get_active_hand() != src)
		return

	if(internal_transmitter.outbound_call != null || internal_transmitter.inbound_call != null)
		return

	if(SSinterior.in_interior(user))
		to_chat(usr, SPAN_WARNING("There's no way to deploy [src] in here!"))
		return

	var/turf/turf_to_plant = get_step(user, user.dir)
	if(istype(turf_to_plant, /turf/open))
		var/turf/open/floor = turf_to_plant
		if(!floor.allow_construction || istype(floor, /turf/open/space))
			to_chat(user, SPAN_WARNING("You cannot deploy [src] here, find a more secure surface!"))
			return
	else
		to_chat(user, SPAN_WARNING("[turf_to_plant] is blocking you from deploying [src]!"))
		return

	for(var/obj/object in turf_to_plant)
		if(object.density)
			to_chat(usr, SPAN_WARNING("You need a clear area to deploy [src], something is blocking the way in front of you!"))
			return

	user.visible_message(SPAN_NOTICE("[user] starts deploying [src] on the ground..."), SPAN_NOTICE("You start deploying [src] on the ground..."))
	playsound(user, use_sound, 30)
	if(!do_after(user, assemble_time SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		return

	user.visible_message(SPAN_NOTICE("[user] deployed [src] on the ground!"), SPAN_NOTICE("You deployed [src] on the ground!"))

	playsound(user.loc, drop_sound, 30)

	var/new_name = "Deployed radio " + internal_transmitter.phone_id
	var/phone_list = internal_transmitter.get_transmitters()

	for(var/obj/structure/transmitter/phone in phone_list)
		if(phone.last_caller == internal_transmitter.phone_id)
			phone.last_caller = new_name

	internal_transmitter.can_be_renamed = TRUE
	SStgui.close_uis(internal_transmitter)
	anchored = TRUE
	user.u_equip(src, turf_to_plant)
	internal_transmitter.phone_id = new_name
	internal_transmitter.phone_category = PHONE_DEPLOYED
	internal_transmitter.enabled = TRUE
	icon_state = "rto_backpack_deployed"
	item_state = "rto_backpack_deployed"

/obj/item/storage/backpack/marine/satchel/rto/attack_hand(mob/user)
	if(anchored)
		if(!(user.a_intent & INTENT_HELP || user.a_intent & INTENT_HARM) && !internal_transmitter.inbound_call)
			disassemble(user)
		else
			use_phone(user)
		return

	. = ..()

/datum/action/item_action/rto_pack/use_phone/New(mob/living/user, obj/item/holder)
	..()
	name = "Use Phone"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/structures/phone.dmi', button, "rpb_phone")
	button.overlays += IMG

/datum/action/item_action/rto_pack/use_phone/action_activate()
	. = ..()
	for(var/obj/item/storage/backpack/marine/satchel/rto/radio_backpack in owner)
		radio_backpack.use_phone(owner)
		return

/obj/item/storage/backpack/marine/satchel/rto/proc/disassemble(mob/user)
	if(user.action_busy)
		return

	if(!ishuman(user))
		return

	if(internal_transmitter.outbound_call != null || internal_transmitter.inbound_call != null)
		return

	user.visible_message(SPAN_NOTICE("[user] starts picking up the [src]..."), SPAN_NOTICE("You start picking up the [src]..."))

	playsound(loc, drop_sound, 30)
	if(!do_after(user, disassemble_time SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC) || QDELETED(src))
		return

	playsound(loc, use_sound, 30)
	SStgui.close_uis(internal_transmitter)
	anchored = FALSE
	user.visible_message(SPAN_NOTICE("[user] picked up the [src]"), SPAN_NOTICE("You picked up the [src]"))
	internal_transmitter.can_be_renamed = FALSE
	user.put_in_hands(src)
	internal_transmitter.phone_category = phone_category
	icon_state = "rto_backpack"
	item_state = "rto_backpack"

/obj/item/storage/backpack/marine/satchel/rto/post_skin_selection()
	base_icon = icon_state

/obj/item/storage/backpack/marine/satchel/rto/Initialize()
	. = ..()
	internal_transmitter = new(src)
	internal_transmitter.relay_obj = src
	internal_transmitter.phone_category = phone_category
	internal_transmitter.enabled = FALSE
	internal_transmitter.networks_receive = networks_receive
	internal_transmitter.networks_transmit = networks_transmit
	RegisterSignal(internal_transmitter, COMSIG_TRANSMITTER_UPDATE_ICON, PROC_REF(check_for_ringing))
	GLOB.radio_packs += src

/obj/item/storage/backpack/marine/satchel/rto/proc/check_for_ringing()
	SIGNAL_HANDLER
	update_icon()

/obj/item/storage/backpack/marine/satchel/rto/proc/update_rto_icon(icon_to_set)
	if(!internal_transmitter.attached_to \
		|| internal_transmitter.attached_to.loc != internal_transmitter)
		icon_state = "[icon_to_set]_ear"
		return

	if(internal_transmitter.inbound_call)
		icon_state = "[icon_to_set]_ring"
		item_state = "[icon_to_set]_ring"
	else
		icon_state = icon_to_set
		item_state = icon_to_set

/obj/item/storage/backpack/marine/satchel/rto/update_icon()
	. = ..()
	if(!internal_transmitter)
		return

	if(anchored)
		update_rto_icon(deployed_icon)
		return

	update_rto_icon(base_icon)

/obj/item/storage/backpack/marine/satchel/rto/forceMove(atom/dest)
	. = ..()
	if(isturf(dest))
		internal_transmitter.set_tether_holder(src)
	else
		internal_transmitter.set_tether_holder(loc)

/obj/item/storage/backpack/marine/satchel/rto/Destroy()
	GLOB.radio_packs -= src
	qdel(internal_transmitter)
	return ..()

/obj/item/storage/backpack/marine/satchel/rto/pickup(mob/user)
	. = ..()
	autoset_phone_id(user)

/obj/item/storage/backpack/marine/satchel/rto/equipped(mob/user, slot)
	. = ..()
	autoset_phone_id(user)

/// Automatically sets the phone_id based on the current or updated user
/obj/item/storage/backpack/marine/satchel/rto/proc/autoset_phone_id(mob/user)
	if(!user)
		internal_transmitter.phone_id = "[src]"
		internal_transmitter.enabled = FALSE
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.comm_title)
			internal_transmitter.phone_id = "[H.comm_title] [H]"
		else if(H.job)
			internal_transmitter.phone_id = "[H.job] [H]"
		else
			internal_transmitter.phone_id = "[H]"

		if(H.assigned_squad)
			internal_transmitter.phone_id += " ([H.assigned_squad.name])"
	else
		internal_transmitter.phone_id = "[user]"
	internal_transmitter.enabled = TRUE

/obj/item/storage/backpack/marine/satchel/rto/dropped(mob/user)
	. = ..()
	autoset_phone_id(null) // Disable phone when dropped

/obj/item/storage/backpack/marine/satchel/rto/proc/use_phone(mob/user)
	internal_transmitter.attack_hand(user)

/obj/item/storage/backpack/marine/satchel/rto/attackby(obj/item/W, mob/user)
	if(internal_transmitter && internal_transmitter.attached_to == W)
		internal_transmitter.attackby(W, user)
	else
		. = ..()

/obj/item/storage/backpack/marine/satchel/rto/upp_net
	name = "\improper UPP Radio Telephone Pack"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)

/obj/item/storage/backpack/marine/satchel/rto/small/upp_net
	name = "\improper UPP Radio Telephone Pack"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)
	phone_category = PHONE_UPP_SOLDIER

/obj/item/storage/backpack/marine/satchel/rto/small
	name = "\improper USCM Small Radio Telephone Pack"
	max_storage_space = 10

/obj/item/storage/backpack/marine/satchel/rto/io
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/intel)
	phone_category = PHONE_IO

/obj/item/storage/backpack/pmc/backpack/rto_broken
	name = "\improper Broken WY Radio Telephone Pack"
	desc = "A heavy-duty extended-pack, used for telecommunications between central command. Commonly carried by RTOs. This one bears the logo of Weyland Yutani and internal systems seem to completely fried and broken."
	icon_state = "pmc_broken_rto"
	item_state = "pmc_broken_rto"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/WY.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/WY.dmi'
	)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes

	flags_item = ITEM_OVERRIDE_NORTHFACE
