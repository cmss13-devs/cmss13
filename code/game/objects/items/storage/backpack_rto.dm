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
	actions_types = list(/datum/action/item_action/rto_pack/use_phone, /datum/action/item_action/rto_pack/deploy_pack)

	flags_item = ITEM_OVERRIDE_NORTHFACE

	var/obj/structure/transmitter/internal/internal_transmitter

	var/phone_category = PHONE_MARINE
	var/list/networks_receive = list(FACTION_MARINE)
	var/list/networks_transmit = list(FACTION_MARINE)
	var/base_icon
	var/assemble_time = 2;
	var/static_rto_pack = /obj/structure/transmitter/rto_pack

/obj/item/storage/backpack/marine/satchel/rto/verb/deploy_rto_verb()
	set category = "Object"
	set name = "Deploy radio pack."
	set desc = "Deploy radio pack."
	set src in usr
	deploy_rto(usr)

/obj/item/storage/backpack/marine/satchel/rto/proc/deploy_rto(mob/living/user)
	if(user.action_busy)
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
	var/obj/structure/transmitter/rto_pack/planted_pack = new static_rto_pack(turf_to_plant)

	playsound(user.loc, drop_sound, 30)
	for (var/obj/item/item in contents)
		if (item.type == /obj/item/phone)
			qdel(item)
			continue
		LAZYADD(planted_pack.contents, item)
		forced_item_removal(item)

	var/new_name = "Deployed radio " + internal_transmitter.phone_id
	var/phone_list = internal_transmitter.get_transmitters()

	for(var/obj/structure/transmitter/phone in phone_list)
		if(phone.last_caller == internal_transmitter.phone_id)
			phone.last_caller = new_name

	planted_pack.phone_id = new_name
	qdel(src)

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

/datum/action/item_action/rto_pack/deploy_pack/New(mob/living/user, obj/item/holder)
	..()
	name = "Deploy Radio Pack"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi', button, "rto_backpack")
	button.overlays += IMG

/datum/action/item_action/rto_pack/deploy_pack/action_activate()
	..()
	var/mob/living/user = owner
	var/obj/item/storage/backpack/marine/satchel/rto/rto_backpack = holder_item
	rto_backpack.deploy_rto(user)



/obj/structure/transmitter/rto_pack
	can_change_name = TRUE
	phone_category = PHONE_MARINE
	name = "\improper Deployed USCM Radio Telephone Pack"
	desc = "A heavy-duty pack, used for telecommunications between central command. Commonly carried by RTOs"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	icon_state =  "rto_backpack"
	layer = ABOVE_OBJ_LAYER
	health = 100
	unacidable = FALSE
	var/rto_pack_type = /obj/item/storage/backpack/marine/satchel/rto
	var/disassemble_time = 3;
	var/use_sound = "rustle"
	var/drop_sound = "armorequip"

/obj/structure/transmitter/rto_pack/attack_hand(mob/user)
	if(user.a_intent & (INTENT_GRAB))
		disassemble(user)
		return
	..()

/obj/structure/transmitter/rto_pack/proc/disassemble(mob/user)
	if(user.action_busy)
		return

	if(outbound_call != null || inbound_call != null)
		return

	user.visible_message(SPAN_NOTICE("[user] starts picking up the [src]..."), SPAN_NOTICE("You start picking up the [src]..."))

	playsound(loc, drop_sound, 30)
	if(!do_after(user, disassemble_time SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC) || QDELETED(src))
		return

	playsound(loc, use_sound, 30)
	user.visible_message(SPAN_NOTICE("[user] picked up the [src]"), SPAN_NOTICE("You picked up the [src]"))
	var/obj/item/storage/backpack/marine/satchel/rto/rto_pack = new rto_pack_type(loc)
	user.put_in_hands(rto_pack)

	for (var/obj/item/item in contents)
		if (item.type == /obj/item/phone)
			continue
		LAZYADD(rto_pack.contents, item)

	qdel(src)

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

/obj/item/storage/backpack/marine/satchel/rto/update_icon()
	. = ..()
	if(!internal_transmitter)
		return

	if(!internal_transmitter.attached_to \
		|| internal_transmitter.attached_to.loc != internal_transmitter)
		icon_state = "[base_icon]_ear"
		return

	if(internal_transmitter.inbound_call)
		icon_state = "[base_icon]_ring"
		item_state = "rto_backpack_ring"
	else
		icon_state = base_icon
		item_state = "rto_backpack"

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
	static_rto_pack = /obj/structure/transmitter/rto_pack/upp

/obj/structure/transmitter/rto_pack/upp
	name = "\improper Deployed UPP Radio Telephone Pack"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)
	rto_pack_type = /obj/item/storage/backpack/marine/satchel/rto/upp_net

/obj/item/storage/backpack/marine/satchel/rto/small
	name = "\improper USCM Small Radio Telephone Pack"
	max_storage_space = 10
	static_rto_pack = /obj/structure/transmitter/rto_pack/small

/obj/structure/transmitter/rto_pack/small
	name = "\improper Deployed USCM Small Radio Telephone Pack"
	rto_pack_type = /obj/item/storage/backpack/marine/satchel/rto/small

/obj/item/storage/backpack/marine/satchel/rto/small/upp_net
	name = "\improper UPP Small Radio Telephone Pack"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)
	phone_category = PHONE_UPP_SOLDIER

/obj/structure/transmitter/rto_pack/small/upp
	name = "\improper Deployed UPP Small Radio Telephone Pack"
	rto_pack_type = /obj/item/storage/backpack/marine/satchel/rto/small
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)
	phone_category = PHONE_UPP_SOLDIER

/obj/item/storage/backpack/marine/satchel/rto/io
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/intel)
	phone_category = PHONE_IO
	static_rto_pack = /obj/structure/transmitter/rto_pack/io

/obj/structure/transmitter/rto_pack/io
	phone_category = PHONE_IO
	rto_pack_type = /obj/item/storage/backpack/marine/satchel/rto/io

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
