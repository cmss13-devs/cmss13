/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon = 'icons/obj/items/clothing/backpack/backpacks.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks.dmi'
	)
	icon_state = "backpack"
	w_class = SIZE_LARGE
	flags_equip_slot = SLOT_BACK //ERROOOOO
	max_w_class = SIZE_MEDIUM
	storage_slots = null
	max_storage_space = 21
	cant_hold = list(/obj/item/storage/firstaid, /obj/item/storage/toolkit)
	can_hold_skill = list(
		/obj/item/storage/firstaid = list(SKILL_MEDICAL, SKILL_MEDICAL_MEDIC),
		/obj/item/storage/toolkit = list(SKILL_ENGINEER, SKILL_ENGINEER_TRAINED),
		)
	drop_sound = "armorequip"
	var/worn_accessible = FALSE //whether you can access its content while worn on the back
	var/obj/item/card/id/locking_id = null
	var/is_id_lockable = FALSE
	var/lock_overridable = TRUE
	var/xeno_icon_state = null //the icon_state for xeno's wearing this (using the dmi defined in default_xeno_onmob_icons list)
	var/list/xeno_types = null //what xeno types can equip this backpack

/obj/item/storage/backpack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id/) && is_id_lockable && ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/card/id/card = W
		toggle_lock(card, H)
		return

	if (..() && use_sound)
		playsound(loc, use_sound, 15, TRUE, 6)

/obj/item/storage/backpack/attack(mob/living/target_mob, mob/living/user)
	if(!xeno_icon_state)
		return ..()
	if(target_mob.back)
		return ..()
	if(user.a_intent != INTENT_HELP)
		return ..()
	if(!xeno_types || !(target_mob.type in xeno_types))
		return ..()
	if(!isxeno(target_mob))
		return ..()
	if(HAS_TRAIT(target_mob, TRAIT_XENONID))
		return ..() // We don't have backpack sprites for xenoids (yet?)
	var/mob/living/carbon/xenomorph/xeno = target_mob
	if(target_mob.stat != DEAD) // If the Xeno is alive, fight back
		var/mob/living/carbon/carbon_user = user
		if(!carbon_user || !carbon_user.ally_of_hivenumber(xeno.hivenumber))
			user.KnockDown(rand(xeno.caste.tacklestrength_min, xeno.caste.tacklestrength_max))
			playsound(user.loc, 'sound/weapons/pierce.ogg', 25, TRUE)
			user.visible_message(SPAN_WARNING("\The [user] tried to strap \the [src] onto [target_mob] but instead gets a tail swipe to the head!"))
			return FALSE

	user.visible_message(SPAN_NOTICE("\The [user] starts strapping \the [src] onto [target_mob]."),
	SPAN_NOTICE("You start strapping \the [src] onto [target_mob]."), null, 5, CHAT_TYPE_FLUFF_ACTION)
	if(!do_after(user, HUMAN_STRIP_DELAY * user.get_skill_duration_multiplier(SKILL_CQC), INTERRUPT_ALL, BUSY_ICON_GENERIC, target_mob, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		to_chat(user, SPAN_WARNING("You were interrupted!"))
		return FALSE

	// Ensure conditions still valid
	if(src != user.get_active_hand())
		return FALSE
	if(!user.Adjacent(target_mob))
		return FALSE
	user.drop_inv_item_on_ground(src)
	if(!src || QDELETED(src)) //Might be self-deleted?
		return FALSE

	// Create their vis object if needed
	if(!xeno.backpack_icon_holder)
		xeno.backpack_icon_holder = new(null, xeno)
		xeno.vis_contents += xeno.backpack_icon_holder

	target_mob.put_in_back(src)
	return FALSE

/obj/item/storage/backpack/proc/toggle_lock(obj/item/card/id/card, mob/living/carbon/human/H)
	if(QDELETED(locking_id))
		to_chat(H, SPAN_NOTICE("You lock \the [src]!"))
		locking_id = card
	else
		if(locking_id.registered_name == card.registered_name || (lock_overridable && (ACCESS_MARINE_SENIOR in card.access)))
			to_chat(H, SPAN_NOTICE("You unlock \the [src]!"))
			locking_id = null
		else
			to_chat(H, SPAN_NOTICE("The ID lock rejects your ID"))
	update_icon()

/obj/item/storage/backpack/equipped(mob/user, slot, silent)
	if(slot == WEAR_BACK)
		mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
		if(use_sound && !silent)
			playsound(loc, use_sound, 15, TRUE, 6)
		if(!worn_accessible) //closes it if it's open.
			storage_close(user)
	..()

/obj/item/storage/unequipped(mob/user, slot, silent)
	if(slot == WEAR_BACK)
		if(use_sound && !silent)
			playsound(loc, use_sound, 15, TRUE, 6)
	..()

/obj/item/storage/backpack/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()


/obj/item/storage/backpack/open(mob/user)
	if(!is_accessible_by(user))
		return
	if(locking_id && !compare_id(user))//if id locked we the user's id against the locker's
		to_chat(user, SPAN_NOTICE("[src] is locked by [locking_id.registered_name]'s ID! You decide to leave it alone."))
		return
	..()

/obj/item/storage/backpack/storage_close(mob/user)
	UnregisterSignal(user, COMSIG_MOVABLE_PRE_MOVE)
	..()

/obj/item/storage/backpack/proc/is_accessible_by(mob/user)
	// If the user is already looking inside this backpack.
	if(user.s_active == src)
		return TRUE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!worn_accessible)
			if(H.back == src && !user.action_busy) //Not doing any timed actions?
				to_chat(H, SPAN_NOTICE("You begin to open [src], so you can check its contents."))
				if(!do_after(user, 2 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC)) //Timed opening.
					to_chat(H, SPAN_WARNING("You were interrupted!"))
					return FALSE
				RegisterSignal(user, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(storage_close)) //Continue along the proc and allow opening if not locked; close on movement.
			else if(H.back == src) //On back and doing timed actions?
				return FALSE
	return TRUE

/obj/item/storage/backpack/empty(mob/user, turf/T)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.back == src && !worn_accessible && !content_watchers) //Backpack on back needs to be opened; if it's already opened, it can be emptied immediately.
			if(!is_accessible_by(user))
				return
	if(locking_id && !compare_id(user))//if id locked we the user's id against the locker's
		to_chat(user, SPAN_NOTICE("[src] is locked by [locking_id.registered_name]'s ID! You decide to leave it alone."))
		return
	..()

//Returns true if the user's id matches the lock's
/obj/item/storage/backpack/proc/compare_id(mob/living/carbon/human/H)
	var/obj/item/card/id/card = H.get_idcard()
	if(!card || locking_id.registered_name != card.registered_name)
		return FALSE
	else
		return TRUE

/obj/item/storage/backpack/update_icon()
	overlays.Cut()

	if(content_watchers) //If someone's looking inside it, don't close the flap. Lockables display as temporarily unlocked.
		if(is_id_lockable)
			overlays += "+[icon_state]_unlocked"
		return

	if(locking_id) // if it's locked, we expect the casing to be shut.
		overlays += "+[icon_state]_full"
		overlays += "+[icon_state]_locked"
		return

	var/sum_storage_cost = 0
	for(var/obj/item/I in contents)
		sum_storage_cost += I.get_storage_cost()
	if(sum_storage_cost)
		if(sum_storage_cost <= max_storage_space * 0.5)
			overlays += "+[icon_state]_half"
		else
			overlays += "+[icon_state]_full"

	if(is_id_lockable) // assumption: !locking_id
		overlays += "+[icon_state]_unlocked"

/obj/item/storage/backpack/get_examine_text(mob/user)
	. = ..()
	if(is_id_lockable)
		. += "Features an ID lock. Swipe your ID card to lock or unlock it."
		if(lock_overridable)
			. += "This lock can be overridden with command-level access."

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	icon_state = "holdingpack"
	max_w_class = SIZE_LARGE
	max_storage_space = 28

/obj/item/storage/backpack/holding/attackby(obj/item/W as obj, mob/user as mob)
	if(crit_fail)
		to_chat(user, SPAN_DANGER("The Bluespace generator isn't working."))
		return
	if(istype(W, /obj/item/storage/backpack/holding) && !W.crit_fail)
		to_chat(user, SPAN_DANGER("The Bluespace interfaces of the two devices conflict and malfunction."))
		qdel(W)
		return
	..()

/obj/item/storage/backpack/holding/proc/failcheck(mob/user as mob)
	if (prob(src.reliability)) return 1 //No failure
	if (prob(src.reliability))
		to_chat(user, SPAN_DANGER("The Bluespace portal resists your attempt to add another item.")) //light failure
	else
		to_chat(user, SPAN_DANGER("The Bluespace generator malfunctions!"))
		for (var/obj/thing in contents) //it broke, delete what was in it
			qdel(thing)
		crit_fail = 1
		icon_state = "brokenpack"


//==========================//JOKE PACKS\\================================\\

/obj/item/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag"
	item_state = "giftbag"
	w_class = SIZE_LARGE
	storage_slots = 30
	max_w_class = SIZE_MASSIVE
	worn_accessible = TRUE
	actions_types = list(/datum/action/item_action/specialist/santabag)

/obj/item/storage/backpack/santabag/Initialize()
	. = ..()
	refill_santa_bag()

/obj/item/storage/backpack/santabag/proc/refill_santa_bag(mob/living/user)
	var/current_items = length(contents)
	var/total_to_refill = storage_slots - current_items
	for(var/total_storage_slots in 1 to total_to_refill)
		new /obj/item/m_gift(src)
	if(!user)
		return
	playsound(user, 'sound/items/jingle_long.wav', 25, TRUE)
	to_chat(user, SPAN_GREEN("You use the magic of Christmas to refill your gift bag!"))

/obj/item/storage/backpack/santabag/item_action_slot_check(mob/user, slot)
	if(HAS_TRAIT(user, TRAIT_SANTA)) //Only the Santa himself knows how to use this bag properly.
		return TRUE

/datum/action/item_action/specialist/santabag/New(mob/living/user, obj/item/holder)
	..()
	name = "Refill Gift Bag"
	action_icon_state = holder?.icon_state
	button.name = name
	button.overlays.Cut()
	button.overlays += image(holder?.icon_state, button, action_icon_state)

/datum/action/item_action/specialist/santabag/can_use_action()
	return TRUE

/datum/action/item_action/specialist/santabag/action_activate()
	. = ..()
	var/obj/item/storage/backpack/santabag/santa_bag = holder_item
	santa_bag.refill_santa_bag(owner)
	update_button_icon()

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "This, this thing. It fills you with the dread of a bygone age. A land of grey coveralls and mentally unstable crewmen. Of traitors and hooligans. Thank god you're in the Marines now."
	icon_state = "clownpack"
	black_market_value = 25

//==========================//COLONY/CIVILIAN PACKS\\================================\\

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"

/obj/item/storage/backpack/security //Universal between USCM MPs & Colony, should be split at some point.
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack lookin' backpack used by engineers and the like."
	icon_state = "engiepack"
	item_state = "engiepack"

/obj/item/storage/backpack/toxins
	name = "laboratory backpack"
	desc = "It's a light backpack for use in laboratories and other scientific institutions."
	icon_state = "toxpack"

/obj/item/storage/backpack/hydroponics
	name = "herbalist's backpack"
	desc = "It's a green backpack with many pockets to store plants and tools in."
	icon_state = "hydpack"

/obj/item/storage/backpack/genetics
	name = "geneticist backpack"
	desc = "It's a backpack fitted with slots for diskettes and other workplace tools."
	icon_state = "genpack"

/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack made from pathogen-resistant fabrics."
	icon_state = "viropack"

/obj/item/storage/backpack/chemistry
	name = "chemistry backpack"
	desc = "It's an orange backpack designed to hold beakers, pill bottles, and bottles."
	icon_state = "chempack"

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "leather satchel"
	desc = "A very fancy satchel made of fine leather. Looks pretty pricey."
	icon_state = "satchel"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 15

/obj/item/storage/backpack/satchel/withwallet

/obj/item/storage/backpack/satchel/withwallet/fill_preset_inventory()
	new /obj/item/storage/wallet/random( src )

/obj/item/storage/backpack/satchel/lockable
	name = "secure leather satchel"
	desc = "A very fancy satchel made of fine leather. It's got a lock on it."
	is_id_lockable = TRUE

/obj/item/storage/backpack/satchel/lockable/liaison
	lock_overridable = FALSE

/obj/item/storage/backpack/satchel/blue
	icon_state = "satchel_blue"

/obj/item/storage/backpack/satchel/black
	icon_state = "satchel_black"

/obj/item/storage/backpack/satchel/norm
	name = "satchel"
	desc = "A trendy-looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colors."
	icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colors."
	icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colors."
	icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/storage/backpack/satchel/sec //Universal between USCM MPs & Colony, should be split at some point.
	name = "security satchel"
	desc = "A robust satchel composed of two drop pouches and a large internal pocket. Made of a stiff fabric, it isn't very comfy to wear."
	icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant-related work."
	icon_state = "satchel_hyd"

//==========================// MARINE BACKPACKS\\================================\\
//=======================================================================\\

/obj/item/storage/backpack/marine
	name = "\improper lightweight IMP backpack"
	desc = "The standard-issue pack of the USCM forces. Designed to lug gear into the battlefield."
	icon_state = "marinepack"
	item_state = "marinepack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
	flags_atom = FPRINT // has gamemode skin
	xeno_icon_state = "marinepack"
	xeno_types = list(/mob/living/carbon/xenomorph/runner, /mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/defender, /mob/living/carbon/xenomorph/sentinel, /mob/living/carbon/xenomorph/spitter)
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/jungle.dmi'
	)


/obj/item/storage/backpack/marine/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	if(flags_atom & MAP_COLOR_INDEX)
		return
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/classic.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/desert.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/snow.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/urban.dmi'
			item_icons[WEAR_BACK] = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/urban.dmi'

/obj/item/storage/backpack/marine/ammo_rack
	name = "\improper IMP ammo rack"
	desc = "A bare IMP frame with buckles designed to hold multiple ammo cans, but can fit any cumbersome box thanks to Marine ingenuity. Helps you lug around extra rounds or supplies."
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	storage_slots = 3
	icon_state = "ammo_pack_0"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	can_hold = list(/obj/item/ammo_box, /obj/item/stack/folding_barricade)
	max_w_class = SIZE_MASSIVE
	throw_range = 0
	xeno_types = null
	var/base_icon_state = "ammo_pack"
	var/move_delay_mult = 0.4

/obj/item/storage/backpack/marine/ammo_rack/update_icon()
	. = ..()
	icon_state = "[base_icon_state]_[length(contents)]"

/obj/item/storage/backpack/marine/ammo_rack/pickup(mob/user, silent)
	. = ..()
	RegisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY, PROC_REF(handle_movedelay))

/obj/item/storage/backpack/marine/ammo_rack/proc/handle_movedelay(mob/user, list/movedata)
	SIGNAL_HANDLER
	if(locate(/obj/item/storage/backpack/marine/ammo_rack) in user.contents)
		movedata["move_delay"] += move_delay_mult

/obj/item/storage/backpack/marine/ammo_rack/dropped(mob/user, silent)
	. = ..()
	UnregisterSignal(user, COMSIG_HUMAN_POST_MOVE_DELAY)

/obj/item/storage/backpack/marine/medic
	name = "\improper USCM corpsman backpack"
	desc = "A standard-issue backpack worn by USCM medics."
	icon_state = "marinepack_medic"
	item_state = "marinepack_medic"
	xeno_icon_state = "medicpack"
	xeno_types = list(/mob/living/carbon/xenomorph/runner, /mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/defender, /mob/living/carbon/xenomorph/sentinel, /mob/living/carbon/xenomorph/spitter)

/obj/item/storage/backpack/marine/k9_synth
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	icon_override = 'icons/mob/humans/species/synth_k9/onmob/synth_k9_overlays.dmi'
	icon_state = null
	uniform_restricted = list(/obj/item/clothing/under/rank/synthetic/synth_k9) //K9 Synth only
	force_overlays_on = TRUE
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes

/obj/item/storage/backpack/marine/k9_synth/cargopack
	name = "\improper M209 portable K9 backpack"
	desc = "Form fitted for the K9 Rescue Unit line of synthetics. Designed to lug gear into the battlefield."
	icon_state = "marinepack_k9"

/obj/item/storage/backpack/marine/k9_synth/medicalpack
	name = "\improper M210 portable K9 medical backpack"
	desc = "Form fitted for the K9 Rescue Unit line of synthetics. For carrying medical supplies."
	icon_state = "marinepack_medic_k9"

/obj/item/storage/backpack/marine/k9_synth/mppack
	name = "\improper M553 portable K9 police backpack"
	desc = "Form fitted for the K9 Rescue Unit line of synthetics. For carrying MP Equipment."
	icon_state = "mppack_k9"

/obj/item/storage/backpack/marine/medic/upp
	name = "\improper UPP corpsman backpack"
	desc = "Uncommon issue backpack worn by UPP medics from isolated sectors. You can swear you can see a faded USCM symbol."

/obj/item/storage/backpack/marine/tech
	name = "\improper USCM technician backpack"
	desc = "A standard-issue backpack worn by USCM technicians."
	icon_state = "marinepack_techi"
	item_state = "marinepack_techi"
	xeno_icon_state = "marinepack"
	xeno_types = list(/mob/living/carbon/xenomorph/runner, /mob/living/carbon/xenomorph/praetorian, /mob/living/carbon/xenomorph/drone, /mob/living/carbon/xenomorph/warrior, /mob/living/carbon/xenomorph/defender, /mob/living/carbon/xenomorph/sentinel, /mob/living/carbon/xenomorph/spitter)

/obj/item/storage/backpack/marine/satchel/intel
	name = "\improper USCM lightweight expedition pack"
	desc = "A heavy-duty IMP based backpack that can be slung around the front or to the side, and can quickly be accessed with only one hand. Usually issued to USCM intelligence officers."
	icon_state = "marinebigsatch"
	max_storage_space = 20

/obj/item/storage/backpack/marine/satchel/intel/chestrig
	name = "\improper USCM expedition chestrig"
	desc = "A heavy-duty IMP based chestrig, can quickly be accessed with only one hand. Usually issued to USCM intelligence officers."
	icon_state = "intel_chestrig"
	max_storage_space = 20

/obj/item/storage/backpack/marine/satchel
	name = "\improper USCM satchel"
	desc = "A heavy-duty satchel carried by some USCM soldiers and support personnel."
	icon_state = "marinesatch"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 15
	xeno_types = null

/obj/item/storage/backpack/marine/satchel/big //wacky squad marine loadout item, its the IO backpack.
	name = "\improper USCM logistics IMP backpack"
	desc = "A standard-issue backpack worn by logistics personnel. It is occasionally issued to combat personnel for longer term expeditions and deep space incursions."
	icon_state = "marinebigsatch"
	worn_accessible = TRUE
	storage_slots = null
	max_storage_space = 21 //backpack size

/obj/item/storage/backpack/marine/satchel/medic
	name = "\improper USCM corpsman satchel"
	desc = "A heavy-duty satchel used by USCM medics. It sacrifices capacity for usability. A small patch is sewn to the top flap."
	icon_state = "marinesatch_medic"

/obj/item/storage/backpack/marine/satchel/tech
	name = "\improper USCM technician chestrig"
	desc = "A heavy-duty chestrig used by some USCM technicians."
	icon_state = "marinesatch_techi"

/obj/item/storage/backpack/marine/satchel/chestrig
	name = "\improper USCM chestrig"
	desc = "A chestrig used by some USCM personnel."
	icon_state = "chestrig"

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

/obj/item/storage/backpack/marine/satchel/rto/small
	name = "\improper USCM Small Radio Telephone Pack"
	max_storage_space = 10


/obj/item/storage/backpack/marine/satchel/rto/small/upp_net
	name = "\improper UPP Radio Telephone Pack"
	networks_receive = list(FACTION_UPP)
	networks_transmit = list(FACTION_UPP)
	phone_category = PHONE_UPP_SOLDIER

/obj/item/storage/backpack/marine/satchel/rto/io
	uniform_restricted = list(/obj/item/clothing/under/marine/officer/intel)
	phone_category = PHONE_IO

/obj/item/storage/backpack/marine/smock
	name = "\improper M3 sniper's smock"
	desc = "A specially-designed smock with pockets for all your sniper needs."
	icon_state = "smock"
	worn_accessible = TRUE
	xeno_types = null

/obj/item/storage/backpack/marine/smock/select_gamemode_skin()
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("urban")
			name = "\improper M60 Sniper Cloak"
			desc = "A specially-designed cloak with thermal dampering waterproof coating, designed for urban environments. Doesn't have the optical camouflage electronics that more advanced M68 cloak has."

/obj/item/storage/backpack/marine/marsoc
	name = "\improper USCM SOF IMP tactical rucksack"
	desc = "With a backpack like this, you'll forget you're on a hell march designed to kill you."
	icon_state = "tacrucksack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	worn_accessible = TRUE
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	xeno_types = null

/obj/item/storage/backpack/marine/rocketpack
	name = "\improper USCM IMP M22 rocket bags"
	desc = "A specially-designed backpack that fits to the IMP mounting frame on standard USCM pattern M3 armors. It's made of two waterproofed reinforced tubes and one smaller satchel slung at the bottom. The two silos are for rockets, but no one is stopping you from cramming other things in there."
	icon_state = "rocketpack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	worn_accessible = TRUE
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	xeno_types = null

/obj/item/storage/backpack/marine/grenadepack
	name = "\improper USCM IMP M63A1 grenade satchel"
	desc = "A secure satchel with dedicated grenade pouches meant to minimize risks of secondary ignition."
	icon_state = "grenadierpack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	overlays = list("+grenadierpack_unlocked")
	worn_accessible = TRUE
	max_storage_space = 36 //12 grenades
	storage_slots = 12
	can_hold = list(/obj/item/explosive/grenade)
	is_id_lockable = TRUE
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	xeno_types = null

/obj/item/storage/backpack/marine/grenadepack/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/box/nade_box) || istype(W, /obj/item/storage/backpack/marine/grenadepack) || istype(W, /obj/item/storage/belt/grenade))
		dump_into(W,user)
	else
		return ..()

/obj/item/storage/backpack/marine/mortarpack
	name = "\improper USCM mortar shell backpack"
	desc = "A backpack specifically designed to hold ammunition for the M402 mortar."
	icon_state = "mortarpack"
	max_w_class = SIZE_HUGE
	storage_slots = 8
	can_hold = list(/obj/item/mortar_shell)
	xeno_types = null

/// G-8-a general pouch belt
/obj/item/storage/backpack/general_belt
	name = "\improper G8-A general utility pouch"
	desc = "A small, lightweight pouch that can be clipped onto Armat Systems M3 Pattern armor to provide additional storage. The newer G8-A model, while uncomfortable, can also be clipped around the waist."
	max_storage_space = 10
	w_class = SIZE_LARGE
	max_w_class = SIZE_MEDIUM
	flags_equip_slot = SLOT_WAIST
	icon_state = "g8pouch"
	item_state = "g8pouch"
	icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/belts_by_map/jungle.dmi'
	)
	flags_atom = FPRINT // has gamemode skin
	can_hold_skill = list()
	item_state_slots = list(
		WEAR_L_HAND = "marinebelt",
		WEAR_R_HAND = "marinebelt",
	)

/obj/item/storage/backpack/general_belt/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("jungle")
			icon = 'icons/obj/items/clothing/belts/belts_by_map/jungle.dmi'
			item_icons[WEAR_WAIST] = 'icons/mob/humans/onmob/clothing/belts/belts_by_map/jungle.dmi'
			item_icons[WEAR_J_STORE] = 'icons/mob/humans/onmob/clothing/suit_storage/suit_storage_by_map/jungle.dmi'
		if("classic")
			icon = 'icons/obj/items/clothing/belts/belts_by_map/classic.dmi'
			item_icons[WEAR_WAIST] = 'icons/mob/humans/onmob/clothing/belts/belts_by_map/classic.dmi'
			item_icons[WEAR_J_STORE] = 'icons/mob/humans/onmob/clothing/suit_storage/suit_storage_by_map/classic.dmi'
		if("desert")
			icon = 'icons/obj/items/clothing/belts/belts_by_map/desert.dmi'
			item_icons[WEAR_WAIST] = 'icons/mob/humans/onmob/clothing/belts/belts_by_map/desert.dmi'
			item_icons[WEAR_J_STORE] = 'icons/mob/humans/onmob/clothing/suit_storage/suit_storage_by_map/desert.dmi'
		if("snow")
			icon = 'icons/obj/items/clothing/belts/belts_by_map/snow.dmi'
			item_icons[WEAR_WAIST] = 'icons/mob/humans/onmob/clothing/belts/belts_by_map/snow.dmi'
			item_icons[WEAR_J_STORE] = 'icons/mob/humans/onmob/clothing/suit_storage/suit_storage_by_map/snow.dmi'
		if("urban")
			icon = 'icons/obj/items/clothing/belts/belts_by_map/urban.dmi'
			item_icons[WEAR_WAIST] = 'icons/mob/humans/onmob/clothing/belts/belts_by_map/urban.dmi'
			item_icons[WEAR_J_STORE] = 'icons/mob/humans/onmob/clothing/suit_storage/suit_storage_by_map/urban.dmi'

/obj/item/storage/backpack/general_belt/equipped(mob/user, slot)
	switch(slot)
		if(WEAR_WAIST, WEAR_J_STORE) //The G8 can be worn on several armors.
			mouse_opacity = MOUSE_OPACITY_OPAQUE //so it's easier to click when properly equipped.
	..()

/obj/item/storage/backpack/general_belt/dropped(mob/user)
	mouse_opacity = initial(mouse_opacity)
	..()

// Scout Cloak
/obj/item/storage/backpack/marine/satchel/scout_cloak
	name = "\improper M68 Thermal Cloak"
	desc = "The lightweight thermal dampeners and optical camouflage provided by this cloak are weaker than those found in standard USCM ghillie suits. In exchange, the cloak can be worn over combat armor and offers the wearer high maneuverability and adaptability to many environments."
	icon_state = "scout_cloak"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	unacidable = TRUE
	explo_proof = TRUE
	uniform_restricted = list(/obj/item/clothing/suit/storage/marine/M3S) //Need to wear Scout armor and helmet to equip this.
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	var/camo_active = FALSE
	var/camo_alpha = 10
	var/allow_gun_usage = FALSE
	var/cloak_cooldown

	actions_types = list(/datum/action/item_action/specialist/toggle_cloak)

/obj/item/storage/backpack/marine/satchel/scout_cloak/select_gamemode_skin(expected_type, list/override_icon_state, list/override_protection)
	. = ..()
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("urban")
			icon_state = "u_scout_cloak"
		else
			icon_state = "scout_cloak"

/obj/item/storage/backpack/marine/satchel/scout_cloak/dropped(mob/user)
	if(ishuman(user) && !issynth(user))
		deactivate_camouflage(user, FALSE)

	. = ..()

/obj/item/storage/backpack/marine/satchel/scout_cloak/attack_self(mob/user)
	..()
	camouflage()

/obj/item/storage/backpack/marine/satchel/scout_cloak/verb/camouflage()
	set name = "Activate Cloak"
	set desc = "Activate your cloak's camouflage."
	set category = "Scout"
	set src in usr
	if(!usr || usr.is_mob_incapacitated(TRUE))
		return

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!skillcheck(H, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SCOUT)
		to_chat(H, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return

	if(H.back != src)
		to_chat(H, SPAN_WARNING("You must be wearing the cloak to activate it!"))
		return

	if(camo_active)
		deactivate_camouflage(H)
		return

	if(cloak_cooldown && cloak_cooldown > world.time)
		to_chat(H, SPAN_WARNING("Your cloak is malfunctioning and can't be enabled right now!"))
		return

	RegisterSignal(H, COMSIG_GRENADE_PRE_PRIME, PROC_REF(cloak_grenade_callback))
	RegisterSignal(H, COMSIG_HUMAN_EXTINGUISH, PROC_REF(wrapper_fizzle_camouflage))
	RegisterSignal(H, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(deactivate_camouflage))

	camo_active = TRUE
	ADD_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
	H.visible_message(SPAN_DANGER("[H] vanishes into thin air!"), SPAN_NOTICE("You activate your cloak's camouflage."), max_distance = 4)
	playsound(H.loc, 'sound/effects/cloak_scout_on.ogg', 15, TRUE)
	H.unset_interaction()

	H.alpha = camo_alpha
	H.FF_hit_evade = 1000
	H.allow_gun_usage = allow_gun_usage

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.remove_from_hud(H)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.remove_from_hud(H)

	anim(H.loc, H, 'icons/mob/mob.dmi', null, "cloak", null, H.dir)
	return TRUE

/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/wrapper_fizzle_camouflage()
	SIGNAL_HANDLER
	var/mob/wearer = src.loc
	wearer.visible_message(SPAN_DANGER("[wearer]'s cloak fizzles out!"), SPAN_DANGER("Your cloak fizzles out!"))
	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(5, 4, src)
	sparks.start()
	deactivate_camouflage(wearer, TRUE, TRUE)

/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/deactivate_camouflage(mob/living/carbon/human/H, anim = TRUE, forced)
	SIGNAL_HANDLER
	if(!istype(H))
		return FALSE

	UnregisterSignal(H, list(
	COMSIG_GRENADE_PRE_PRIME,
	COMSIG_HUMAN_EXTINGUISH,
	COMSIG_MOB_EFFECT_CLOAK_CANCEL,
	))

	if(forced)
		cloak_cooldown = world.time + 10 SECONDS

	camo_active = FALSE
	REMOVE_TRAIT(H, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_BACK))
	H.visible_message(SPAN_DANGER("[H] shimmers into existence!"), SPAN_WARNING("Your cloak's camouflage has deactivated!"), max_distance = 4)
	playsound(H.loc, 'sound/effects/cloak_scout_off.ogg', 15, TRUE)

	H.alpha = initial(H.alpha)
	H.FF_hit_evade = initial(H.FF_hit_evade)

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(H)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(H)

	if(anim)
		anim(H.loc, H,'icons/mob/mob.dmi', null, "uncloak", null, H.dir)

	addtimer(CALLBACK(src, PROC_REF(allow_shooting), H), 1.5 SECONDS)

// This proc is to cancel priming grenades in /obj/item/explosive/grenade/attack_self()
/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/cloak_grenade_callback(mob/user)
	SIGNAL_HANDLER

	to_chat(user, SPAN_WARNING("Your cloak prevents you from priming the grenade!"))

	return COMPONENT_GRENADE_PRIME_CANCEL

/obj/item/storage/backpack/marine/satchel/scout_cloak/proc/allow_shooting(mob/living/carbon/human/H)
	if(camo_active && !allow_gun_usage)
		return
	H.allow_gun_usage = TRUE

/datum/action/item_action/specialist/toggle_cloak
	ability_primacy = SPEC_PRIMARY_ACTION_1

/datum/action/item_action/specialist/toggle_cloak/New(mob/living/user, obj/item/holder)
	..()
	name = "Toggle Cloak"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi', button, "scout_cloak")
	button.overlays += IMG

/datum/action/item_action/specialist/toggle_cloak/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !H.is_mob_incapacitated() && holder_item == H.back)
		return TRUE

/datum/action/item_action/specialist/toggle_cloak/action_activate()
	. = ..()
	var/obj/item/storage/backpack/marine/satchel/scout_cloak/SC = holder_item
	SC.camouflage()

// Welder Backpacks //

/obj/item/storage/backpack/marine/engineerpack
	name = "\improper USCM technician welderpack"
	desc = "A specialized backpack worn by USCM technicians. It carries a fueltank for quick welder refueling and use."
	icon_state = "welderbackpack"
	item_state = "welderbackpack"
	var/max_fuel = 260
	var/fuel_type = "fuel"
	max_storage_space = 18
	storage_slots = null
	flags_atom = FPRINT // has gamemode skin
	xeno_types = null

/obj/item/storage/backpack/marine/engineerpack/Initialize()
	. = ..()
	create_reagents(max_fuel) //Lotsa refills
	reagents.add_reagent(fuel_type, max_fuel)


/obj/item/storage/backpack/marine/engineerpack/attackby(obj/item/W, mob/living/user)
	if(reagents.total_volume)
		if(iswelder(W))
			var/obj/item/tool/weldingtool/T = W
			if(T.welding)
				to_chat(user, SPAN_WARNING("That was close! However, you realized you had the welder on and prevented disaster."))
				return
			if(!(T.get_fuel()==T.max_fuel) && reagents.total_volume)
				reagents.trans_to(W, T.max_fuel)
				to_chat(user, SPAN_NOTICE("Welder refilled!"))
				playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
				return
		else if(istype(W, /obj/item/ammo_magazine/flamer_tank))
			var/obj/item/ammo_magazine/flamer_tank/FT = W
			if(!FT.current_rounds && reagents.total_volume)
				var/fuel_available = reagents.total_volume < FT.max_rounds ? reagents.total_volume : FT.max_rounds
				reagents.remove_reagent("fuel", fuel_available)
				FT.current_rounds = fuel_available
				playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
				FT.caliber = "Fuel"
				to_chat(user, SPAN_NOTICE("You refill [FT] with [lowertext(FT.caliber)]."))
				FT.update_icon()
				return
		else if(isgun(W))
			var/obj/item/weapon/gun/G = W
			for(var/slot in G.attachments)
				if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
					var/obj/item/attachable/attached_gun/flamer/F = G.attachments[slot]
					if(F.current_rounds < F.max_rounds)
						var/to_transfer = F.max_rounds - F.current_rounds
						if(to_transfer > reagents.total_volume)
							to_transfer = reagents.total_volume
						reagents.remove_reagent("fuel", to_transfer)
						F.current_rounds += to_transfer
						playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
						to_chat(user, SPAN_NOTICE("You refill [F] with fuel."))
					else
						to_chat(user, SPAN_WARNING("[F] is full."))
					return
	. = ..()

/obj/item/storage/backpack/marine/engineerpack/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if(istype(target, /obj/structure/reagent_dispensers))
		if(!(istypestrict(target, /obj/structure/reagent_dispensers/fueltank)))
			to_chat(user, SPAN_NOTICE("This must be filled with a fuel tank."))
			return
		if(reagents.total_volume < max_fuel)
			target.reagents.trans_to(src, max_fuel)
			to_chat(user, SPAN_NOTICE("You crack the cap off the top of the pack and fill it back up again from the tank."))
			playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
			return
		if(reagents.total_volume == max_fuel)
			to_chat(user, SPAN_NOTICE("The pack is already full!"))
			return
	..()

/obj/item/storage/backpack/marine/engineerpack/get_examine_text(mob/user)
	. = ..()
	. += "[reagents.total_volume] units of fuel left!"

/obj/item/storage/backpack/marine/engineerpack/satchel
	name = "\improper USCM technician welder-satchel"
	desc = "A specialized satchel worn by USCM technicians and engineers. It carries two small fuel tanks for quick welder refueling and use."
	icon_state = "satchel_marine_welder"
	item_state = "satchel_marine_welder"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	max_storage_space = 12
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	max_fuel = 100
	worn_accessible = TRUE

/obj/item/storage/backpack/marine/engineerpack/welder_chestrig
	name = "\improper Technician Welder Chestrig"
	desc = "A specialized Chestrig worn by technicians and engineers. It carries one medium fuel tank for quick welder refueling and use."
	icon_state = "welder_chestrig"
	max_storage_space = 12
	max_fuel = 100
	worn_accessible = TRUE

// Pyrotechnician Spec backpack fuel tank
/obj/item/storage/backpack/marine/engineerpack/flamethrower
	name = "\improper USCM Pyrotechnician G6-2 fueltank"
	desc = "A specialized fueltank worn by USCM Pyrotechnicians for use with the M240-T incinerator unit. A small general storage compartment is installed."
	icon_state = "flamethrower_tank"
	max_fuel = 500
	fuel_type = "utnapthal"
	flags_atom = FPRINT // has gamemode skin

/obj/item/storage/backpack/marine/engineerpack/flamethrower/verb/remove_reagents()
	set name = "Empty canister"
	set category = "Object"

	set src in usr

	if(usr.get_active_hand() != src)
		return

	if(alert(usr, "Do you really want to empty out [src]?", "Empty canister", "Yes", "No") != "Yes")
		return

	reagents.clear_reagents()

	playsound(loc, 'sound/effects/refill.ogg', 25, 1, 3)
	to_chat(usr, SPAN_NOTICE("You empty out [src]"))
	update_icon()

//this is to revert change for the backpack that are for flametrower usage.
// so that they can use custom mix to refill those backpack
/obj/item/storage/backpack/marine/engineerpack/flamethrower/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return
	if (!(istype(target, /obj/structure/reagent_dispensers/fueltank)))
		return

	if (reagents.total_volume >= max_fuel)
		to_chat(user, SPAN_NOTICE("The pack is already full!"))
		return

	if(reagents.total_volume < max_fuel)
		target.reagents.trans_to(src, max_fuel)
		to_chat(user, SPAN_NOTICE("You crack the cap off the top of the pack and fill it back up again from the tank."))
		playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
		return

/obj/item/storage/backpack/marine/engineerpack/flamethrower/attackby(obj/item/W, mob/living/user)
	if (istype(W, /obj/item/ammo_magazine/flamer_tank))
		var/obj/item/ammo_magazine/flamer_tank/FTL = W
		var/missing_volume = FTL.max_rounds - FTL.current_rounds

		//Fuel has to be standard napalm OR tank needs to be empty. We need to have a non-full tank and our backpack be dry
		if (((FTL.caliber == "UT-Napthal Fuel") || (!FTL.current_rounds)) && missing_volume && reagents.total_volume)
			var/fuel_available = reagents.total_volume < missing_volume ? reagents.total_volume : missing_volume
			reagents.remove_reagent("fuel", fuel_available)
			FTL.current_rounds = FTL.current_rounds + fuel_available
			playsound(loc, 'sound/effects/refill.ogg', 25, TRUE, 3)
			FTL.caliber = "UT-Napthal Fuel"
			to_chat(user, SPAN_NOTICE("You refill [FTL] with [FTL.caliber]."))
			FTL.update_icon()
	. = ..()

/obj/item/storage/backpack/marine/engineerpack/flamethrower/kit
	name = "\improper USCM Pyrotechnician G4-1 fueltank"
	desc = "A much older-generation back rig that holds fuel in two tanks. A small regulator sits between them. Has a few straps for holding up to three of the actual flamer tanks you'll be refilling."
	icon_state = "flamethrower_backpack"
	item_state = "flamethrower_backpack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UA.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/clothing/backpacks_righthand.dmi',
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UA.dmi'
	)
	max_fuel = 350
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	max_storage_space = 15
	storage_slots = 3
	worn_accessible = TRUE
	can_hold = list(/obj/item/ammo_magazine/flamer_tank, /obj/item/tool/extinguisher)
	storage_flags = STORAGE_FLAGS_POUCH

//----------OTHER FACTIONS AND ERTS----------

/obj/item/storage/backpack/lightpack
	name = "\improper lightweight combat pack"
	desc = "A small, lightweight pack for expeditions and short-range operations."
	icon_state = "ERT_satchel"
	worn_accessible = TRUE

/obj/item/storage/backpack/lightpack/five_slot
	max_storage_space = 15

/obj/item/storage/backpack/marine/engineerpack/ert
	name = "\improper lightweight technician welderpack"
	desc = "A small, lightweight pack for expeditions and short-range operations. Features a small fueltank for quick blowtorch refueling."
	icon_state = "ERT_satchel_welder"
	icon = 'icons/obj/items/clothing/backpack/backpacks.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks.dmi'
	)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	worn_accessible = TRUE
	max_fuel = 180

/obj/item/storage/backpack/marine/engineerpack/ert/four_slot
	max_fuel = 100
	max_storage_space = 12

/obj/item/storage/backpack/molle
	name = "\improper T13 MOLLE Satchel"
	desc = "Tactical satchel manufactured by one of the Alphatech subsidiaries. Very lightweight beltbag variant that utilizes UA standard MOLLE fastening systems. Can be often found in hands of colonial security and various private military groups."
	icon_state = "MOLLEbeltbag"
	item_state = "MOLLEbeltbag"
	worn_accessible = TRUE
	max_storage_space = 15

/obj/item/storage/backpack/molle/backpack
	name = "\improper T16 MOLLE Backpack"
	desc = "Tactical backpack manufactured by one of the Alphatech subsidiaries. Very lightweight backpack that utilizes UA standard MOLLE fastening systems, which allows easy access and optimal weight distribution. Can be often found in hands of colonial security and various private military groups."
	icon_state = "MOLLEbackpack"
	item_state = "MOLLEbackpack"
	max_storage_space = 21

/obj/item/storage/backpack/molle/backpack/surv
	worn_accessible = FALSE

/obj/item/storage/backpack/commando
	name = "commando bag"
	desc = "A heavy-duty bag carried by Weyland-Yutani commandos."
	icon_state = "commandopack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/WY.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/WY.dmi'
	)
	worn_accessible = TRUE

/obj/item/storage/backpack/mcommander
	name = "marine commanding officer backpack"
	desc = "The contents of this backpack are top secret."
	icon_state = "marinepack"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_map/jungle.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_map/jungle.dmi'
	)
	storage_slots = null
	max_storage_space = 30

/obj/item/storage/backpack/ivan
	name = "The Armory"
	desc = "From the formless void, there springs an entity more primordial than the elements themselves. In its wake, there will follow a storm."
	icon_state = "ivan_bag"
	storage_slots = 28
	worn_accessible = TRUE
	max_w_class = SIZE_MASSIVE
	can_hold = list(
		/obj/item/weapon,
	)

/obj/item/storage/backpack/ivan/Initialize()
	. = ..()
	var/list/template_guns = list(/obj/item/weapon/gun/pistol, /obj/item/weapon/gun/revolver, /obj/item/weapon/gun/shotgun, /obj/item/weapon/gun/rifle, /obj/item/weapon/gun/smg, /obj/item/weapon/gun/energy, /obj/item/weapon/gun/launcher, /obj/item/weapon/gun/launcher/grenade, /obj/item/weapon/gun/rifle/sniper)
	var/list/bad_guns = typesof(/obj/item/weapon/gun/pill) + /obj/item/weapon/gun/souto + /obj/item/weapon/gun/smg/nailgun/compact //guns that don't work for some reason
	var/list/emplacements = list(/obj/item/device/m2c_gun , /obj/item/device/m56d_gun/mounted)
	var/list/yautja_guns = typesof(/obj/item/weapon/gun/energy/yautja) + /obj/item/weapon/gun/launcher/spike
	var/list/smartguns = typesof(/obj/item/weapon/gun/smartgun)
	var/list/training_guns = list(
		/obj/item/weapon/gun/rifle/m41a/training,
		/obj/item/weapon/gun/rifle/m4ra/training,
		/obj/item/weapon/gun/smg/m39/training,
		/obj/item/weapon/gun/pistol/m4a3/training,
		/obj/item/weapon/gun/pistol/mod88/training) //Ivan doesn't carry toys.

	var/list/picklist = subtypesof(/obj/item/weapon/gun) - (template_guns + bad_guns + emplacements + yautja_guns + smartguns + training_guns)
	var/random_gun = pick(picklist)
	for(var/total_storage_slots in 1 to storage_slots) //minus templates
		new random_gun(src)
		random_gun = pick(picklist)

/obj/item/storage/backpack/souto
	name = "\improper back mounted Souto vending machine"
	max_storage_space = 30
	desc = "The loading mechanism for the Souto Slinger Supremo and a portable Souto vendor!"
	icon_state = "supremo_pack"
	storage_slots = null
	flags_inventory = CANTSTRIP
	unacidable = TRUE
	var/internal_mag = new /obj/item/ammo_magazine/internal/souto
	worn_accessible = TRUE


//----------UPP SECTION----------

/obj/item/storage/backpack/lightpack/upp
	name = "\improper UCP3 combat pack"
	desc = "A UPP military standard-issue Union Combat Pack MK3."
	icon_state = "satchel_upp"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UPP.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UPP.dmi'
	)
	worn_accessible = TRUE
	max_storage_space = 15

//UPP engineer welderpack
/obj/item/storage/backpack/marine/engineerpack/upp
	name = "\improper UCP3-E technician welderpack"
	desc = "A special version of the Union Combat Pack MK3 featuring a small fueltank for quick blowtorch refueling. Used by UPP Sappers."
	icon_state = "satchel_upp_welder"
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/UPP.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/UPP.dmi'
	)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	worn_accessible = TRUE
	max_fuel = 180
	max_storage_space = 12

/obj/item/storage/backpack/marine/satchel/scout_cloak/upp
	name = "\improper V86 Thermal Cloak"
	desc = "A thermo-optic camouflage cloak commonly used by UPP commando units."
	uniform_restricted = list(/obj/item/clothing/suit/storage/marine/faction/UPP/commando) //Need to wear UPP commando armor to equip this.

	max_storage_space = 21
	camo_alpha = 10

/obj/item/storage/backpack/marine/satchel/scout_cloak/upp/weak
	desc = "A thermo-optic camouflage cloak commonly used by UPP commando units. This one is less effective than normal."
	actions_types = null

//----------TWE SECTION----------
/obj/item/storage/backpack/rmc
	icon_state = ""
	icon = 'icons/obj/items/clothing/backpack/backpacks_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/clothing/back/backpacks_by_faction/TWE.dmi'
	)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes

/obj/item/storage/backpack/rmc/heavy
	name = "heavyweight RMC backpack"
	desc = "The heavy-carry pack of the RMC forces. Designed to lug the most amount of gear into the battlefield."
	icon_state = "backpack_large"
	item_state = "backpack_large"
	max_storage_space = 27

/obj/item/storage/backpack/rmc/medium
	name = "standard RMC backpack"
	desc = "A TWE military standard-carry RMC combat pack MK3."
	icon_state = "backpack_medium"
	item_state = "backpack_medium"
	worn_accessible = TRUE
	max_storage_space = 24

/obj/item/storage/backpack/rmc/medium/medic
	name = "standard RMC backpack"
	desc = "A TWE military standard-carry RMC combat pack MK3 with a green cross denoting that it's a medic's backpack." //Surely CLF won't shoot the doc, right?
	icon_state = "backpack_medium_medic"
	item_state = "backpack_medium_medic"

/obj/item/storage/backpack/rmc/light
	name = "lightweight RMC backpack"
	desc = "A TWE military light-carry RMC combat pack MK3."
	icon_state = "backpack_small"
	item_state = "backpack_small"
	worn_accessible = TRUE
	max_storage_space = 21

/obj/item/storage/backpack/rmc/frame //One sorry sod should have to lug this about spawns in their shuttle currently (making it a more useless backpack was devious. Reworks it to hold ammo and medkits, as well as nades.)
	name = "\improper RMC carry-frame"
	desc = "A backpack specifically designed to hold equipment for commandos."
	icon_state = "backpack_frame_0"
	item_state = "backpack_frame"
	max_w_class = SIZE_HUGE
	storage_slots = 5
	can_hold = list(
		/obj/item/storage/firstaid,
		/obj/item/device/defibrillator,
		/obj/item/storage/box/packet,
		/obj/item/ammo_box,
	)
	var/base_icon_state = "backpack_frame"

/obj/item/storage/backpack/rmc/frame/update_icon()
	. = ..()
	icon_state = "[base_icon_state]_[length(contents)]"

/obj/item/storage/backpack/general_belt/rmc //the breachers belt
	name = "\improper RMC general utility belt"
	desc = "A small, lightweight pouch that can be clipped onto armor to provide additional storage. This new RMC model, while uncomfortable, can also be clipped around the waist."
	icon_state = "rmc_general"
	item_state = "rmc_general"
	icon = 'icons/obj/items/clothing/belts/belts_by_faction/TWE.dmi'
	item_icons = list(
		WEAR_WAIST = 'icons/mob/humans/onmob/clothing/belts/belts_by_faction/TWE.dmi'
	)
	flags_atom = FPRINT|NO_GAMEMODE_SKIN // same sprite for all gamemodes
	max_storage_space = 15
