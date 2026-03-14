/obj/item/clothing/gloves/yautja/hunter/soldier
	name = "militarized bracers"
	desc = "A set of high-tech bracers that are relatively simple when compared to those used in hunting, forgoing most advanced functions in exchange for an auto-self destruct system that activates on death."
	icon_state = "bracer_ebony"
	caster_enabled = FALSE // no fancy-pants tools for you!
	cloak_enabled = FALSE
	smartdisc_enabled = FALSE
	embedded_id = /obj/item/card/id/bracer_chip/military
	bracer_actions = list(/datum/action/predator_action/bracer/wristblade, /datum/action/predator_action/bracer/thwei, /datum/action/predator_action/bracer/capsule, /datum/action/predator_action/bracer/translator, /datum/action/predator_action/bracer/self_destruct)

/obj/item/clothing/gloves/yautja/hunter/soldier/process()
	. = ..()
	var/mob/living/carbon/human/human_holder = loc
	if(human_holder.stat == DEAD)
		explode(human_holder) // auto-SD on death

/obj/item/card/id/bracer_chip/military
	name = "bracer ID chip"
	desc = "A complex cypher chip embedded within a set of clan bracers."
	icon = 'icons/obj/items/radio.dmi'
	icon_state = "upp_key"
	access = list(ACCESS_YAUTJA_SECURE, ACCESS_YAUTJA_ELITE, ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT) // dsquad gets (pred) all-access
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_ID
	flags_item = ITEM_PREDATOR|DELONDROP|NODROP
	paygrade = null

/obj/item/card/id/bracer_chip/military/set_user_data(mob/living/carbon/human/human_user)
	if(!istype(human_user))
		return

	registered_name = human_user.real_name
	registered_ref = WEAKREF(human_user)
	registered_gid = human_user.gid
	blood_type = human_user.blood_type

/obj/item/clothing/suit/armor/yautja/hunter/full/powered
	name = "\improper Nracha-Dte power armor"
	desc = "Produced only by artisans overseen directly by the Council of Ancients, the Nracha-Dte-Type is a powered suit of armor built for war rather than hunting. It is heavy, and absurdly protective."
	icon = 'icons/obj/items/hunter/mcaste_gear.dmi'
	icon_state = "fullarmor_soldier"
	item_icons = list(
		WEAR_JACKET = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi'
	)
	slowdown = SLOWDOWN_ARMOR_LOWHEAVY
	movement_compensation = SLOWDOWN_ARMOR_VERY_HEAVY
	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_inventory = BLOCKSHARPOBJ|BLOCK_KNOCKDOWN
	flags_armor_protection = BODY_FLAG_CHEST|BODY_FLAG_GROIN|BODY_FLAG_ARMS
	time_to_unequip = 10
	time_to_equip = 10
	uniform_restricted = list(/obj/item/clothing/under/chainshirt/hunter)

/obj/item/clothing/suit/armor/yautja/hunter/full/powered/Initialize(mapload)
	. = ..(mapload, 0)
	icon_state = "fullarmor_soldier"
	LAZYSET(item_state_slots, WEAR_JACKET, "fullarmor_soldier")
	AddElement(/datum/element/corp_label/dltalt)

/obj/item/clothing/suit/armor/yautja/hunter/full/powered/enforcer
	name = "\improper Nracha-Dte command power armor"
	desc = "Produced only by artisans overseen directly by the Council of Ancients, the Nracha-Dte-type is a powered suit of armor built for war rather than hunting. It is heavy, and absurdly protective. This one features a ceremonial pauldron labeling the wearer as an Enforcer."
	icon = 'icons/obj/items/hunter/mcaste_gear.dmi'
	icon_state = "fullarmor_soldier_lead"

/obj/item/clothing/suit/armor/yautja/hunter/full/powered/enforcer/Initialize(mapload)
	. = ..(mapload, 0)
	icon_state = "fullarmor_soldier_lead"
	LAZYSET(item_state_slots, WEAR_JACKET, "fullarmor_soldier_lead")

/obj/item/clothing/shoes/yautja/hunter/knife/powered
	name = "\improper Nracha-Dte armored greaves"
	desc = "The lower half of the M'talt-Type powered armor suit, used exclusively in battle against the most disdainful of dishonorable targets. Like the upper suit, there is very little damage it cannot shrug off."
	icon = 'icons/obj/items/hunter/mcaste_gear.dmi'
	icon_state = "y-boots_powered"
	item_state = "y-boots_powered"
	item_icons = list(
		WEAR_FEET = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi'
	)
	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_armor_protection = BODY_FLAG_LEGS|BODY_FLAG_FEET
	time_to_unequip = 10
	time_to_equip = 10
	uniform_restricted = list(/obj/item/clothing/under/chainshirt/hunter)
	flags_inventory = BLOCKSHARPOBJ|NOSLIPPING

/obj/item/clothing/shoes/yautja/hunter/knife/powered/Initialize(mapload)
	. = ..(mapload, 0)
	icon_state = "y-boots_powered"
	LAZYSET(item_state_slots, WEAR_FEET, "y-boots_powered")
	AddElement(/datum/element/corp_label/dltalt)

#define VISION_MODE_OFF 0
#define VISION_MODE_NVG 1

/obj/item/clothing/head/helmet/yautja
	name = "\improper Nracha-Dte enclosed helmet"
	desc = "A fully-enclosed combat helmet that is fitted around the entire head, rather than acting as a facemask. It nonetheless features the same heads-up display as most clan masks."
	icon_state = "helmet_powered"
	item_state = "helmet_powered"
	icon = 'icons/obj/items/hunter/mcaste_gear.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi'
	)
	var/current_goggles = VISION_MODE_OFF
	armor_melee = CLOTHING_ARMOR_HIGHPLUS
	armor_bullet = CLOTHING_ARMOR_ULTRAHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_VERYHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_HIGHPLUS
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	eye_protection = EYE_PROTECTION_WELDING
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_FACE|BODY_FLAG_EYES
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ|BLOCKGASEFFECT|FULL_DECAP_PROTECTION
	flags_inv_hide = HIDEEARS|HIDEEYES|HIDEFACE|HIDEMASK|HIDEALLHAIR // actual helmet that hides yautja dreads
	flags_item = ITEM_PREDATOR
	clothing_traits = list(TRAIT_EAR_PROTECTION)
	unacidable = TRUE
	time_to_unequip = 10 // you gotta fit your dreads in that helmet, dude, cmon
	time_to_equip = 10
	unequip_sounds = list('sound/items/air_release.ogg') // like a mask, kinda. but cooler.
	anti_hug = 100

	var/list/helmet_huds = list(MOB_HUD_XENO_STATUS, MOB_HUD_HUNTER, MOB_HUD_HUNTER_CLAN, MOB_HUD_MEDICAL_OBSERVER)
	// features the same zoom and visor functions as a normal pred mask, defined seperately because it's a helmet not a mask :)
	var/list/helmet_actions = list(/datum/action/predator_action/helmet/zoom, /datum/action/predator_action/helmet/visor)

/obj/item/clothing/head/helmet/yautja/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/corp_label/dltalt)

/obj/item/clothing/head/helmet/yautja/pickup(mob/living/user)
	. = ..()
	if(isyautja(user))
		remove_from_missing_pred_gear(src)

/obj/item/clothing/head/helmet/yautja/Destroy()
	remove_from_missing_pred_gear(src)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/head/helmet/yautja/proc/drain_power(mob/living/carbon/human/human_holder, drain_amount)
	var/obj/item/clothing/gloves/yautja/bracer = human_holder.gloves
	if(!bracer || !istype(bracer))
		return FALSE
	if(!(bracer.drain_power(human_holder, drain_amount)))
		return FALSE
	return TRUE

/obj/item/clothing/head/helmet/yautja/process()
	if(!ishuman(loc))
		return PROCESS_KILL
	var/mob/living/carbon/human/human_holder = loc

	if(current_goggles && !drain_power(human_holder, 3))
		to_chat(human_holder, SPAN_WARNING("Your bracers lack sufficient power to operate the visor."))
		current_goggles = VISION_MODE_OFF
		var/obj/item/visor = human_holder.glasses
		if(istype(visor, /obj/item/clothing/glasses/night/yautja))
			human_holder.temp_drop_inv_item(visor)
			qdel(visor)
			human_holder.update_sight()
			add_vision(human_holder)

/obj/item/clothing/head/helmet/yautja/verb/toggle_zoom()
	set name = "Toggle Helmet Zoom"
	set desc = "Toggle your helmet's zoom function."
	set src in usr
	if(!usr || usr.stat)
		return

	zoom(usr, 11, 12)
	update_zoom_action(src, usr)
	if(zoom)
		RegisterSignal(src, COMSIG_ITEM_UNZOOM, PROC_REF(update_zoom_action))
		playsound(src, 'sound/effects/pred_zoom_on.ogg', 50, FALSE, 2)
		return
	else
		playsound(src, 'sound/effects/pred_zoom_off.ogg', 50, FALSE, 2)

/obj/item/clothing/head/helmet/yautja/proc/update_zoom_action(source, mob/living/user)
	UnregisterSignal(src, COMSIG_ITEM_UNZOOM)
	var/datum/action/predator_action/helmet/zoom/zoom_action
	for(zoom_action as anything in user.actions)
		if(istypestrict(zoom_action, /datum/action/predator_action/helmet/zoom))
			zoom_action.update_button_icon(zoom)
			break

/obj/item/clothing/head/helmet/yautja/verb/togglesight()
	set name = "Toggle Helmet Visors"
	set desc = "Toggle your helmet visor sights. You must only be wearing a type of Yautja visor for this to work."
	set src in usr
	if(!usr || usr.stat)
		return
	var/mob/living/carbon/human/user = usr
	if(!istype(user))
		return
	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH) && !user.hunter_data.thralled)
		to_chat(user, SPAN_WARNING("You have no idea how to work this thing!"))
		return
	if(src != user.head) //sanity
		to_chat(user, SPAN_WARNING("You must wear \the [src]!"))
		return
	var/obj/item/clothing/gloves/yautja/bracer = user.gloves
	if(!bracer || !istype(bracer))
		to_chat(user, SPAN_WARNING("You must be wearing your bracers, as they have the power source."))
		return
	var/obj/item/visor = user.glasses
	if(visor)
		if(!istype(visor, /obj/item/clothing/glasses/night/yautja))
			to_chat(user, SPAN_WARNING("You need to remove your glasses first. Why are you even wearing these?"))
			return
		user.temp_drop_inv_item(visor)
		qdel(visor)
		user.update_inv_glasses()
		user.update_sight()
	switch_vision_mode()
	add_vision(user)

/obj/item/clothing/head/helmet/yautja/proc/switch_vision_mode()
	switch(current_goggles)
		if(VISION_MODE_OFF)
			current_goggles = VISION_MODE_NVG
		if(VISION_MODE_NVG)
			current_goggles = VISION_MODE_OFF

/obj/item/clothing/head/helmet/yautja/proc/add_vision(mob/living/carbon/human/user)
	switch(current_goggles)
		if(VISION_MODE_NVG)
			user.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/yautja(user), WEAR_EYES)
			to_chat(user, SPAN_NOTICE("Low-light vision module: activated."))
		if(VISION_MODE_OFF)
			to_chat(user, SPAN_NOTICE("You deactivate your visor."))

	playsound(src, 'sound/effects/pred_vision.ogg', 15, 1)
	user.update_inv_glasses()

	var/datum/action/predator_action/helmet/visor/visor_action
	for(visor_action as anything in user.actions)
		if(istypestrict(visor_action, /datum/action/predator_action/helmet/visor))
			visor_action.update_button_icon(current_goggles)
			break

/obj/item/clothing/head/helmet/yautja/dropped(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	if(istype(user) && user.head == src)
		for(var/datum/action/action as anything in helmet_actions)
			remove_action(user, action)

		for(var/listed_hud in helmet_huds)
			var/datum/mob_hud/H = GLOB.huds[listed_hud]
			H.remove_hud_from(user, src)
		var/obj/item/visor = user.glasses
		if(visor)
			if(istype(visor, /obj/item/clothing/glasses/night/yautja))
				user.temp_drop_inv_item(visor)
				qdel(visor)
				user.update_inv_glasses()
				user.update_sight()
	..()

/obj/item/clothing/head/helmet/yautja/equipped(mob/living/carbon/human/user, slot)
	if(slot == WEAR_HEAD)
		for(var/datum/action/action as anything in helmet_actions)
			give_action(user, action)

		START_PROCESSING(SSobj, src)
		for(var/listed_hud in helmet_huds)
			var/datum/mob_hud/H = GLOB.huds[listed_hud]
			H.add_hud_to(user, src)
		if(current_goggles)
			var/obj/item/clothing/gloves/yautja/bracer = user.gloves
			if(!bracer || !istype(bracer))
				return FALSE
			add_vision(user)
	..()

#undef VISION_MODE_OFF
#undef VISION_MODE_NVG

/obj/item/device/radio/headset/yautja/military
	name = "\improper Military Communicator"
	frequency = YAUT_SPEC_FREQ
	volume_settings = list(RADIO_VOLUME_QUIET_STR, RADIO_VOLUME_RAISED_STR)
	initial_keys = list(/obj/item/device/encryptionkey/yautja/military)

/obj/item/device/encryptionkey/yautja/military
	name = "\improper Yautja encryption key"
	desc = "A complicated encryption device."
	icon_state = "cypherkey"
	channels = list(RADIO_CHANNEL_YAUTJA_SPECOPS = TRUE)

/obj/item/yautja_cannon_pack
	name = "plasma cannon pack"
	desc = "A heavy back-mounted powerpack for supporting a set of dual plasma cannons. The pack's entire volume is taken up by capacitors and electronics used in operating the cannons, remotely linked to a bracer for operation."
	icon = 'icons/obj/items/hunter/mcaste_gear.dmi'
	icon_state = "cannonpack"
	item_state = "cannonpack_w"
	item_icons = list(
		WEAR_BACK = 'icons/mob/humans/onmob/hunter/mcaste_gear.dmi'
	)
	flags_equip_slot = SLOT_BACK
	time_to_unequip = 10
	time_to_equip = 10

	var/charge = 2000 // current charge
	var/charge_max = 2000 // max charge
	var/charge_rate = 200

	var/cannons_deployed = FALSE
	var/obj/item/weapon/gun/energy/yautja/cannon/cannon

	var/list/backpack_actions = list(/datum/action/predator_action/pack/cannons)

/obj/item/yautja_cannon_pack/Initialize(mapload)
	. = ..()
	cannon = new(src, FALSE)
	AddElement(/datum/element/corp_label/dltalt)

/obj/item/yautja_cannon_pack/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/carbon/human/human_holder = loc

	if(charge < charge_max)
		var/charge_increase = charge_rate
		if(is_ground_level(human_holder.z))
			charge_increase = charge_rate / 6
		else if(is_mainship_level(human_holder.z)) // similar to the bracers, we auto-recharge slower on the ground level or almayer than we do on the predship
			charge_increase = charge_rate / 3

		charge = min(charge + charge_increase, charge_max)

/obj/item/yautja_cannon_pack/Destroy()
	QDEL_NULL(cannon)
	return ..()

/obj/item/yautja_cannon_pack/equipped(mob/user, slot)
	. = ..()
	for(var/datum/action/action as anything in backpack_actions)
		give_action(user, action)

	START_PROCESSING(SSobj, src)

/obj/item/yautja_cannon_pack/proc/drain_power(mob/living/carbon/human/human, amount)
	if(!human)
		return FALSE
	if(charge < amount)
		to_chat(human, SPAN_WARNING("Your pack lacks the energy. It only has <b>[charge]/[charge_max]</b> remaining and needs <B>[amount]</b>."))
		return FALSE

	charge -= amount
	var/perc = (charge / charge_max * 100)
	human.update_power_display(perc)

	return TRUE

/obj/item/yautja_cannon_pack/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("It currently has <b>[charge]/[charge_max]</b> charge.")

/obj/item/yautja_cannon_pack/verb/cannons()
	set name = "Use Plasma Cannons"
	set desc = "Activate your plasma cannons. If they are dropped, they will retract back into your pack."
	set category = "Yautja.Weapons"
	set src in usr
	. = cannon_internal(usr)

/obj/item/yautja_cannon_pack/proc/cannon_internal(mob/living/carbon/human/user)
	if(!user.loc || user.is_mob_incapacitated() || !ishuman(user))
		return
	if(cannons_deployed)
		if(cannon.loc == user)
			user.drop_inv_item_to_loc(cannon, src, FALSE, TRUE)
		cannons_deployed = FALSE
	else
		if(!drain_power(user, 50))
			return
		if(user.get_active_hand())
			to_chat(user, SPAN_WARNING("Your hand must be free to activate your plasma cannons!"))
			return
		var/obj/limb/hand = user.get_limb(user.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(user, SPAN_WARNING("You can't hold that!"))
			return
		if(user.faction == FACTION_YAUTJA_YOUNG || isthrall(user))
			to_chat(user, SPAN_WARNING("Even you have no idea how to use this!"))
			return
		user.put_in_active_hand(cannon)
		cannons_deployed = TRUE
		if(user.client?.prefs.custom_cursors)
			user.client?.mouse_pointer_icon = 'icons/effects/mouse_pointer/plasma_caster_mouse.dmi'
		to_chat(user, SPAN_NOTICE("You activate your plasma cannons."))
		playsound(src, 'sound/weapons/pred_plasmacaster_on.ogg', 15, TRUE)

		var/datum/action/predator_action/pack/cannons/cannon_action
		for(cannon_action as anything in user.actions)
			if(istypestrict(cannon_action, /datum/action/predator_action/pack/cannons))
				cannon_action.update_button_icon(cannons_deployed)
				break

	return TRUE
