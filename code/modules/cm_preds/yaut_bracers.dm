/obj/item/clothing/gloves/yautja
	name = "ancient alien bracers"
	desc = "A pair of strange, alien bracers."

	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	icon_state = "bracer"
	item_icons = list(
		WEAR_HANDS = 'icons/mob/humans/onmob/hunter/pred_gear.dmi'
	)

	siemens_coefficient = 0

	flags_item = ITEM_PREDATOR
	flags_inventory = CANTSTRIP
	flags_cold_protection = BODY_FLAG_HANDS
	flags_heat_protection = BODY_FLAG_HANDS
	flags_armor_protection = BODY_FLAG_HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROT
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROT
	unacidable = TRUE

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_MEDIUM
	armor_laser = CLOTHING_ARMOR_MEDIUM
	armor_energy = CLOTHING_ARMOR_MEDIUM
	armor_bomb = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_MEDIUM
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM

	var/notification_sound = TRUE // Whether the bracer pings when a message comes or not
	var/charge = 1500
	var/charge_max = 1500
	/// The amount charged per process
	var/charge_rate = 60
	/// Cooldown on draining power from APC
	var/charge_cooldown = COOLDOWN_BRACER_CHARGE
	var/cloak_timer = 0
	var/cloak_malfunction = 0
	/// Determines the alpha level of the cloaking device.
	var/cloak_alpha = 50
	/// If TRUE will change the mob invisibility level, providing 100% invisibility. Exclusively for events.
	var/true_cloak = FALSE

	var/mob/living/carbon/human/owner //Pred spawned on, or thrall given to.
	var/obj/item/clothing/gloves/yautja/linked_bracer //Bracer linked to this one (thrall or mentor).
	COOLDOWN_DECLARE(bracer_recharge)
	/// What minimap icon this bracer should have
	var/minimap_icon

/obj/item/clothing/gloves/yautja/equipped(mob/user, slot)
	. = ..()
	if(slot == WEAR_HANDS)
		START_PROCESSING(SSobj, src)
		owner = user
		if(isyautja(owner))
			minimap_icon = owner.assigned_equipment_preset?.minimap_icon
		toggle_lock_internal(user, TRUE)
		RegisterSignal(user, list(COMSIG_MOB_STAT_SET_ALIVE, COMSIG_MOB_DEATH), PROC_REF(update_minimap_icon))
		INVOKE_NEXT_TICK(src, PROC_REF(update_minimap_icon), user)

/obj/item/clothing/gloves/yautja/Destroy()
	STOP_PROCESSING(SSobj, src)
	owner = null
	if(linked_bracer)
		linked_bracer.linked_bracer = null
		linked_bracer = null
	return ..()

/obj/item/clothing/gloves/yautja/dropped(mob/user)
	owner = null
	STOP_PROCESSING(SSobj, src)
	flags_item = initial(flags_item)
	UnregisterSignal(user, list(COMSIG_MOB_STAT_SET_ALIVE, COMSIG_MOB_DEATH))
	SSminimaps.remove_marker(user)
	unlock_bracer() // So as to prevent the bracer being stuck with nodrop if the pred gets gibbed/arm removed/etc.
	..()

/obj/item/clothing/gloves/yautja/pickup(mob/living/user)
	..()
	if(!isyautja(user))
		to_chat(user, SPAN_WARNING("The bracer feels cold against your skin, heavy with an unfamiliar, almost alien weight."))

/obj/item/clothing/gloves/yautja/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return
	var/mob/living/carbon/human/human_holder = loc

	if(charge < charge_max)
		var/charge_increase = charge_rate
		if(is_ground_level(human_holder.z))
			charge_increase = charge_rate / 6
		else if(is_mainship_level(human_holder.z))
			charge_increase = charge_rate / 3

		charge = min(charge + charge_increase, charge_max)
		var/perc_charge = (charge / charge_max * 100)
		human_holder.update_power_display(perc_charge)

	//Non-Yautja have a chance to get stunned with each power drain
	if(!HAS_TRAIT(human_holder, TRAIT_CLOAKED))
		return
	if(human_holder.stat == DEAD)
		decloak(human_holder, TRUE)
	if(!HAS_TRAIT(human_holder, TRAIT_YAUTJA_TECH) && !human_holder.hunter_data.thralled && prob(2))
		decloak(human_holder)
		shock_user(human_holder)

/// handles decloaking only on HUNTER gloves
/obj/item/clothing/gloves/yautja/proc/decloak()
	SIGNAL_HANDLER
	return

/// Called to update the minimap icon of the predator
/obj/item/clothing/gloves/yautja/proc/update_minimap_icon()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/turf/wearer_turf = get_turf(owner)
	SSminimaps.remove_marker(owner)
	if(!wearer_turf)
		return

	if(!isyautja(owner))
		var/image/underlay = image('icons/ui_icons/map_blips.dmi', null, "bracer_stolen")
		var/overlay_icon_state
		if(owner.stat >= DEAD)
			if(human_owner.undefibbable)
				overlay_icon_state = "undefibbable"
			else
				overlay_icon_state = "defibbable"
		else
			overlay_icon_state = null
		if(overlay_icon_state)
			var/image/overlay = image('icons/ui_icons/map_blips.dmi', null, overlay_icon_state)
			underlay.overlays += overlay
		SSminimaps.add_marker(owner, MINIMAP_FLAG_YAUTJA, underlay)
	else
		var/image/underlay = image('icons/ui_icons/map_blips.dmi', null, minimap_icon)
		if(owner?.stat >= DEAD)
			var/image/overlay = image('icons/ui_icons/map_blips.dmi', null, "undefibbable")
			underlay.overlays += overlay
		SSminimaps.add_marker(owner, MINIMAP_FLAG_YAUTJA, underlay)
/*
*This is the main proc for checking AND draining the bracer energy. It must have human passed as an argument.
*It can take a negative value in amount to restore energy.
*Also instantly updates the yautja power HUD display.
*/
/obj/item/clothing/gloves/yautja/proc/drain_power(mob/living/carbon/human/human, amount)
	if(!human)
		return FALSE
	if(charge < amount)
		to_chat(human, SPAN_WARNING("Your bracers lack the energy. They have only <b>[charge]/[charge_max]</b> remaining and need <B>[amount]</b>."))
		return FALSE

	charge -= amount
	var/perc = (charge / charge_max * 100)
	human.update_power_display(perc)

	return TRUE

/obj/item/clothing/gloves/yautja/proc/shock_user(mob/living/carbon/human/M)
	if(!HAS_TRAIT(M, TRAIT_YAUTJA_TECH) && !M.hunter_data.thralled)
		//Spark
		playsound(M, 'sound/effects/sparks2.ogg', 60, 1)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(2, 1, src)
		s.start()
		M.visible_message(SPAN_WARNING("[src] beeps and sends a shock through [M]'s body!"))
		//Stun and knock out, scream in pain
		M.apply_effect(2, STUN)
		M.apply_effect(2, WEAKEN)
		if(M.pain.feels_pain)
			M.emote("scream")
		//Apply a bit of burn damage
		M.apply_damage(5, BURN, "l_arm", 0, 0, 0, src)
		M.apply_damage(5, BURN, "r_arm", 0, 0, 0, src)

//We use this to determine whether we should activate the given verb, or a random verb
//0 - do nothing, 1 - random function, 2 - this function
/obj/item/clothing/gloves/yautja/hunter/proc/check_random_function(mob/living/carbon/human/user, forced = FALSE, always_delimb = FALSE)
	if(!istype(user))
		return TRUE

	if(forced || HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		return FALSE

	if(user.is_mob_incapacitated()) //let's do this here to avoid to_chats to dead guys
		return TRUE

	var/workingProbability = 20
	var/randomProbability = 10
	if(issynth(user)) // Synths are smart, they can figure this out pretty well
		workingProbability = 40
		randomProbability = 4
	else if(isresearcher(user)) // Researchers are sort of smart, they can sort of figure this out
		workingProbability = 25
		randomProbability = 7

	to_chat(user, SPAN_NOTICE("You press a few buttons..."))
	//Add a little delay so the user wouldn't be just spamming all the buttons
	user.next_move = world.time + 3
	if(do_after(usr, 3, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, numticks = 1))
		if(prob(randomProbability))
			return activate_random_verb(user)
		if(!prob(workingProbability))
			to_chat(user, SPAN_WARNING("You fiddle with the buttons but nothing happens..."))
			return TRUE

	if(always_delimb)
		return delimb_user(user)

	return FALSE

/obj/item/clothing/gloves/yautja/get_examine_text(mob/user)
	. = ..()
	. += SPAN_NOTICE("They currently have <b>[charge]/[charge_max]</b> charge.")

// Toggle the notification sound
/obj/item/clothing/gloves/yautja/verb/toggle_notification_sound()
	set name = "Toggle Bracer Sound"
	set desc = "Toggle your bracer's notification sound."
	set src in usr

	notification_sound = !notification_sound
	to_chat(usr, SPAN_NOTICE("The bracer's sound is now turned [notification_sound ? "on" : "off"]."))

/obj/item/clothing/gloves/yautja/thrall/update_minimap_icon()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/image/underlay = image('icons/ui_icons/map_blips.dmi', null, minimap_icon)
	var/overlay_icon_state
	if(owner.stat >= DEAD)
		if(human_owner.undefibbable)
			overlay_icon_state = "undefibbable"
		else
			overlay_icon_state = "defibbable"
		var/image/overlay = image('icons/ui_icons/map_blips.dmi', null, overlay_icon_state)
		underlay.overlays += overlay
		SSminimaps.add_marker(owner, MINIMAP_FLAG_YAUTJA, underlay)
	else
		SSminimaps.add_marker(owner, MINIMAP_FLAG_YAUTJA, underlay)

/obj/item/clothing/gloves/yautja/hunter
	name = "clan bracers"
	desc = "An extremely complex, yet simple-to-operate set of armored bracers worn by the Yautja. It has many functions, activate them to use some."

	armor_melee = CLOTHING_ARMOR_MEDIUM
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_MEDIUMHIGH
	armor_energy = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bomb = CLOTHING_ARMOR_HIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_rad = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH

	charge = 3000
	charge_max = 3000

	cloak_alpha = 10

	var/exploding = 0
	var/disc_timer = 0
	var/explosion_type = 1 //0 is BIG explosion, 1 ONLY gibs the user.
	var/name_active = TRUE
	var/translator_type = PRED_TECH_MODERN
	var/invisibility_sound = PRED_TECH_MODERN
	var/caster_material = "ebony"

	var/obj/item/card/id/bracer_chip/embedded_id
	var/owner_rank = CLAN_RANK_UNBLOODED_INT

	var/caster_deployed = FALSE
	var/obj/item/weapon/gun/energy/yautja/plasma_caster/caster

	var/bracer_attachment_deployed = FALSE
	var/obj/item/bracer_attachments/left_bracer_attachment
	var/obj/item/bracer_attachments/right_bracer_attachment

	///A list of all intrinsic bracer actions
	var/list/bracer_actions = list(/datum/action/predator_action/bracer/wristblade, /datum/action/predator_action/bracer/caster, /datum/action/predator_action/bracer/cloak, /datum/action/predator_action/bracer/thwei, /datum/action/predator_action/bracer/capsule, /datum/action/predator_action/bracer/translator, /datum/action/predator_action/bracer/self_destruct, /datum/action/predator_action/bracer/smartdisc)

/obj/item/clothing/gloves/yautja/hunter/get_examine_text(mob/user)
	. = ..()
	if(left_bracer_attachment)
		. += SPAN_NOTICE("The left bracer attachment is [left_bracer_attachment.attached_weapon].")
	if(right_bracer_attachment)
		. += SPAN_NOTICE("The right bracer attachment is [right_bracer_attachment.attached_weapon].")

/obj/item/clothing/gloves/yautja/hunter/Initialize(mapload, new_translator_type, new_invis_sound, new_caster_material, new_owner_rank)
	. = ..()
	if(new_owner_rank)
		owner_rank = new_owner_rank
	embedded_id = new(src)
	if(new_translator_type)
		translator_type = new_translator_type
	if(new_invis_sound)
		invisibility_sound = new_invis_sound
	if(new_caster_material)
		caster_material = new_caster_material
	caster = new(src, FALSE, caster_material)

/obj/item/clothing/gloves/yautja/hunter/emp_act(severity)
	. = ..()
	charge = max(charge - (1000/severity), 0) //someone made weaker emp have higer severity so we divide
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		if(wearer.gloves == src)
			wearer.visible_message(SPAN_DANGER("You hear a hiss and crackle!"), SPAN_DANGER("Your bracers hiss and spark!"), SPAN_DANGER("You hear a hiss and crackle!"))
			if(HAS_TRAIT(wearer, TRAIT_CLOAKED))
				decloak(wearer, TRUE, DECLOAK_EMP)
		else
			var/turf/our_turf = get_turf(src)
			our_turf.visible_message(SPAN_DANGER("You hear a hiss and crackle!"), SPAN_DANGER("You hear a hiss and crackle!"))

/obj/item/clothing/gloves/yautja/hunter/equipped(mob/user, slot)
	. = ..()
	if(slot != WEAR_HANDS)
		move_chip_to_bracer()
	else
		if(embedded_id.registered_name)
			embedded_id.set_user_data(user)

	for(var/datum/action/action as anything in bracer_actions)
		give_action(user, action)


//Any projectile can decloak a predator. It does defeat one free bullet though.
/obj/item/clothing/gloves/yautja/hunter/proc/bullet_hit(mob/living/carbon/human/H, obj/projectile/P)
	SIGNAL_HANDLER

	var/ammo_flags = P.ammo.flags_ammo_behavior | P.projectile_override_flags
	if(ammo_flags & (AMMO_ROCKET|AMMO_ENERGY|AMMO_ACIDIC)) //<--- These will auto uncloak.
		decloak(H) //Continue on to damage.
	else if(prob(20))
		decloak(H)
		return COMPONENT_CANCEL_BULLET_ACT //Absorb one free bullet.

/obj/item/clothing/gloves/yautja/hunter/toggle_notification_sound()
	set category = "Yautja.Misc"
	..()

/obj/item/clothing/gloves/yautja/hunter/Destroy()
	QDEL_NULL(caster)
	QDEL_NULL(embedded_id)
	QDEL_NULL(left_bracer_attachment)
	QDEL_NULL(right_bracer_attachment)
	return ..()

/obj/item/clothing/gloves/yautja/hunter/process()
	if(!ishuman(loc))
		STOP_PROCESSING(SSobj, src)
		return

	var/mob/living/carbon/human/human = loc

	//Non-Yautja have a chance to get stunned with each power drain
	if((!HAS_TRAIT(human, TRAIT_YAUTJA_TECH) && !human.hunter_data.thralled) && prob(4))
		if(HAS_TRAIT(human, TRAIT_CLOAKED))
			decloak(human, TRUE, DECLOAK_SPECIES)
		shock_user(human)

	return ..()

/obj/item/clothing/gloves/yautja/hunter/dropped(mob/user)
	move_chip_to_bracer()
	if(HAS_TRAIT(user, TRAIT_CLOAKED))
		decloak(user, TRUE)

	for(var/datum/action/action as anything in bracer_actions)
		remove_action(user, action)

	..()

/obj/item/clothing/gloves/yautja/hunter/on_enter_storage(obj/item/storage/S)
	if(ishuman(loc))
		var/mob/living/carbon/human/human = loc
		if(HAS_TRAIT(human, TRAIT_CLOAKED))
			decloak(human, TRUE)
	. = ..()

//We use this to activate random verbs for non-Yautja
/obj/item/clothing/gloves/yautja/hunter/proc/activate_random_verb(mob/caller)
	var/option = rand(1, 10)
	//we have options from 1 to 7, but we're giving the user a higher probability of being punished if they already rolled this bad
	switch(option)
		if(1)
			. = attachment_internal(caller, TRUE)
		if(2)
			. = track_gear_internal(caller, TRUE)
		if(3)
			. = cloaker_internal(caller, TRUE)
		if(4)
			. = caster_internal(caller, TRUE)
		if(5)
			. = injectors_internal(caller, TRUE)
		if(6)
			. = call_disc_internal(caller, TRUE)
		if(7)
			. = translate_internal(caller, TRUE)
		if(8)
			. =	remove_attachment_internal(caller, TRUE)
		else
			. = delimb_user(caller)

//This is used to punish people that fiddle with technology they don't understand
/obj/item/clothing/gloves/yautja/hunter/proc/delimb_user(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(isyautja(user))
		return

	var/obj/limb/O = user.get_limb(check_zone("r_arm"))
	O.droplimb()
	O = user.get_limb(check_zone("l_arm"))
	O.droplimb()

	to_chat(user, SPAN_NOTICE("The device emits a strange noise and falls off... Along with your arms!"))
	playsound(user,'sound/weapons/wristblades_on.ogg', 15, 1)
	return TRUE

//bracer attachments
/obj/item/bracer_attachments
	name = "wristblade bracer attachment"
	desc = "Report this if you see this."
	icon = 'icons/obj/items/hunter/pred_gear.dmi'
	///Typepath of the weapon attached to the bracer
	var/obj/item/attached_weapon_type
	///Reference to the weapon attached to the bracer
	var/obj/item/attached_weapon
	///Attachment deployment sound
	var/deployment_sound
	///Attachment rectraction sound
	var/retract_sound

/obj/item/bracer_attachments/Initialize(mapload, ...)
	. = ..()
	if(attached_weapon_type)
		attached_weapon = new attached_weapon_type(src)

/obj/item/bracer_attachments/Destroy()
	QDEL_NULL(attached_weapon)
	. = ..()

/obj/item/bracer_attachments/wristblades
	name = "wristblade bracer attachment"
	desc = "A pair of huge, serrated blades"
	icon_state = "wrist"
	item_state = "wristblade"
	attached_weapon_type = /obj/item/weapon/bracer_attachment/wristblades
	deployment_sound = 'sound/weapons/wristblades_on.ogg'
	retract_sound = 'sound/weapons/wristblades_off.ogg'

/obj/item/bracer_attachments/scimitars
	name = "scimitar bracer attachment"
	desc = "A pair of huge, serrated blades"
	icon_state = "scim"
	item_state = "scim"
	attached_weapon_type = /obj/item/weapon/bracer_attachment/scimitar
	deployment_sound = 'sound/weapons/scims_on.ogg'
	retract_sound = 'sound/weapons/scims_off.ogg'

/obj/item/bracer_attachments/scimitars_alt
	name = "scimitar bracer attachment"
	desc = "A pair of huge, serrated blades"
	icon_state = "scim_alt"
	item_state = "scim_alt"
	attached_weapon_type = /obj/item/weapon/bracer_attachment/scimitar/alt
	deployment_sound = 'sound/weapons/scims_alt_on.ogg'
	retract_sound = 'sound/weapons/scims_alt_off.ogg'

/obj/item/clothing/gloves/yautja/hunter/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/bracer_attachments))
		return ..()

	if(!HAS_TRAIT(user, TRAIT_YAUTJA_TECH))
		to_chat(user, SPAN_WARNING("You do not know how to attach the [attacking_item] to the [src]."))
		return

	var/obj/item/bracer_attachments/bracer_attachment = attacking_item
	if(!bracer_attachment.attached_weapon_type)
		CRASH("[key_name(user)] attempted to attach the [bracer_attachment] to the [src], with no valid attached_weapon.")

	if(left_bracer_attachment && right_bracer_attachment)
		to_chat(user, SPAN_WARNING("You already have the maximum amount of bracer attachments on [src]."))
		return

	var/attach_to_left = TRUE
	if(!left_bracer_attachment && !right_bracer_attachment)
		var/selected = tgui_alert(user, "Do you want to attach [bracer_attachment] to the left or right hand?", "[src]", list("Right", "Left"), 15 SECONDS)
		if(!selected)
			return

		if(selected == "Right") //its right, left because in-game itll show up as left, right
			attach_to_left = FALSE

	if(attacking_item.loc != user)
		to_chat(user, SPAN_WARNING("You cannot attach [attacking_item] without holding it."))
		return

	var/bracer_attached = FALSE
	if(attach_to_left && !left_bracer_attachment)
		left_bracer_attachment = bracer_attachment
		user.drop_inv_item_to_loc(bracer_attachment, src)
		bracer_attached = TRUE
	if(!bracer_attached && !right_bracer_attachment)
		right_bracer_attachment = bracer_attachment
		user.drop_inv_item_to_loc(bracer_attachment, src)

	to_chat(user, SPAN_NOTICE("You attach [bracer_attachment] to [src]."))
	playsound(loc, 'sound/weapons/pred_attach.ogg')
	return ..()

/obj/item/clothing/gloves/yautja/hunter/verb/remove_attachment()
	set name = "Remove Bracer Attachment"
	set desc = "Remove Bracer Attachment From Your Bracer."
	set category = "Yautja.Weapons"
	set src in usr
	return remove_attachment_internal(usr, TRUE)

/obj/item/clothing/gloves/yautja/hunter/proc/remove_attachment_internal(mob/living/carbon/human/user, forced = FALSE)
	if(!user.loc || user.is_mob_incapacitated() || !ishuman(user))
		return

	. = check_random_function(user, forced)
	if(.)
		return

	if(!left_bracer_attachment && !right_bracer_attachment)
		to_chat(user, SPAN_WARNING("[src] has no attached bracers!"))
		return

	if(bracer_attachment_deployed)
		to_chat(user, SPAN_WARNING("Retract your attachments First!"))
		return

	if(left_bracer_attachment)
		if(!user.put_in_any_hand_if_possible(left_bracer_attachment))
			user.drop_inv_item_on_ground(left_bracer_attachment)
		to_chat(user, SPAN_NOTICE("You remove [left_bracer_attachment] from [src]."))
		playsound(src, 'sound/machines/click.ogg', 15, 1)
		left_bracer_attachment = null

	if(right_bracer_attachment)
		if(!user.put_in_any_hand_if_possible(right_bracer_attachment))
			user.drop_inv_item_on_ground(right_bracer_attachment)
		to_chat(user, SPAN_NOTICE("You remove [right_bracer_attachment] from [src]."))
		playsound(src, 'sound/machines/click.ogg', 15, 1)
		right_bracer_attachment = null

	playsound(src, 'sound/machines/click.ogg', 15, 1)

	return FALSE

/obj/item/clothing/gloves/yautja/hunter/verb/bracer_attachment()
	set name = "Use Bracer Attachment"
	set desc = "Extend your bracer attachment. They cannot be dropped, but can be retracted."
	set category = "Yautja.Weapons"
	set src in usr
	return attachment_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/attachment_internal(mob/living/carbon/human/caller, forced = FALSE)
	if(!caller.loc || caller.is_mob_incapacitated() || !ishuman(caller))
		return

	. = check_random_function(caller, forced)
	if(.)
		return

	if(bracer_attachment_deployed)
		retract_bracer_attachments(caller)
	else
		deploy_bracer_attachments(caller)

	var/datum/action/predator_action/bracer/wristblade/wb_action
	for(wb_action as anything in caller.actions)
		if(istypestrict(wb_action, /datum/action/predator_action/bracer/wristblade))
			wb_action.update_button_icon(bracer_attachment_deployed)
			break

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/deploy_bracer_attachments(mob/living/carbon/human/caller) //take the weapons from the attachments in the bracer, and puts them in the callers hand
	if(!drain_power(caller, 50))
		return
	if(!left_bracer_attachment && !right_bracer_attachment)
		to_chat(caller, SPAN_WARNING("[src] has no bracer attachments!"))
		return

	if(left_bracer_attachment)
		var/obj/limb/left_hand = caller.get_limb("l_hand")
		if(!caller.l_hand && left_hand.is_usable())
			if(caller.put_in_l_hand(left_bracer_attachment.attached_weapon))
				to_chat(caller, SPAN_NOTICE("You extend [left_bracer_attachment.attached_weapon]."))
				bracer_attachment_deployed = TRUE
				playsound(loc,left_bracer_attachment.deployment_sound, 25, TRUE)


	if(right_bracer_attachment)
		var/obj/limb/right_hand = caller.get_limb("r_hand")
		if(!caller.r_hand && right_hand.is_usable())
			if(caller.put_in_r_hand(right_bracer_attachment.attached_weapon))
				to_chat(caller, SPAN_NOTICE("You extend [right_bracer_attachment.attached_weapon]."))
				bracer_attachment_deployed = TRUE
				playsound(loc,right_bracer_attachment.deployment_sound, 25, TRUE)

/obj/item/clothing/gloves/yautja/hunter/proc/retract_bracer_attachments(mob/living/carbon/human/caller) //if the attachments weapon is in the callers hands, retract them back into the attachments
	if(left_bracer_attachment && left_bracer_attachment.attached_weapon.loc == caller)
		caller.drop_inv_item_to_loc(left_bracer_attachment.attached_weapon, left_bracer_attachment, FALSE, TRUE)
		to_chat(caller, SPAN_NOTICE("You retract [left_bracer_attachment.attached_weapon]."))
		playsound(loc, left_bracer_attachment.retract_sound, 25, TRUE)

	if(right_bracer_attachment && right_bracer_attachment.attached_weapon.loc == caller)
		caller.drop_inv_item_to_loc(right_bracer_attachment.attached_weapon, right_bracer_attachment, FALSE, TRUE)
		to_chat(caller, SPAN_NOTICE("You retract [right_bracer_attachment.attached_weapon]."))
		playsound(loc, right_bracer_attachment.retract_sound, 25, TRUE)

	bracer_attachment_deployed = FALSE

/obj/item/clothing/gloves/yautja/hunter/verb/track_gear()
	set name = "Track Yautja Gear"
	set desc = "Find Yauja Gear."
	set category = "Yautja.Tracker"
	set src in usr
	. = track_gear_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/track_gear_internal(mob/caller, forced = FALSE)
	. = check_random_function(caller, forced)
	if(.)
		return

	var/mob/living/carbon/human/hunter = caller
	var/atom/hunter_eye = hunter.client.eye

	var/dead_on_planet = 0
	var/dead_on_almayer = 0
	var/dead_low_orbit = 0
	var/gear_on_planet = 0
	var/gear_on_almayer = 0
	var/gear_low_orbit = 0
	var/closest = 10000
	/// The item itself, to be referenced so Yautja know what to look for.
	var/obj/closest_item
	var/direction = -1
	var/atom/areaLoc = null
	for(var/obj/item/tracked_item as anything in GLOB.loose_yautja_gear)
		var/atom/loc = get_true_location(tracked_item)
		if(tracked_item.anchored)
			continue
		if(is_honorable_carrier(recursive_holder_check(tracked_item)))
			continue
		var/area/location = get_area(loc)
		if(location?.flags_area & AREA_YAUTJA_GROUNDS)
			continue
		if(is_reserved_level(loc.z))
			gear_low_orbit++
		else if(is_mainship_level(loc.z))
			gear_on_almayer++
		else if(is_ground_level(loc.z))
			gear_on_planet++
		if(hunter_eye.z == loc.z)
			var/dist = get_dist(hunter_eye, loc)
			if(dist < closest)
				closest = dist
				closest_item = tracked_item
				direction = Get_Compass_Dir(hunter_eye, loc)
				areaLoc = loc
	for(var/mob/living/carbon/human/dead_yautja as anything in GLOB.yautja_mob_list)
		if(dead_yautja.stat != DEAD)
			continue
		var/area/location = get_area(dead_yautja)
		if(location?.flags_area & AREA_YAUTJA_GROUNDS)
			continue
		if(is_reserved_level(dead_yautja.z))
			dead_low_orbit++
		else if(is_mainship_level(dead_yautja.z))
			dead_on_almayer++
		else if(is_ground_level(dead_yautja.z))
			dead_on_planet++
		if(hunter_eye.z == dead_yautja.z)
			var/dist = get_dist(hunter_eye, dead_yautja)
			if(dist < closest)
				closest = dist
				direction = Get_Compass_Dir(hunter_eye, dead_yautja)
				areaLoc = loc

	var/output = FALSE
	if(dead_on_planet || dead_on_almayer || dead_low_orbit)
		output = TRUE
		to_chat(hunter, SPAN_NOTICE("Your bracer shows a readout of deceased Yautja bio signatures[dead_on_planet ? ", <b>[dead_on_planet]</b> in the hunting grounds" : ""][dead_on_almayer ? ", <b>[dead_on_almayer]</b> in orbit" : ""][dead_low_orbit ? ", <b>[dead_low_orbit]</b> in low orbit" : ""]."))
	if(gear_on_planet || gear_on_almayer || gear_low_orbit)
		output = TRUE
		to_chat(hunter, SPAN_NOTICE("Your bracer shows a readout of Yautja technology signatures[gear_on_planet ? ", <b>[gear_on_planet]</b> in the hunting grounds" : ""][gear_on_almayer ? ", <b>[gear_on_almayer]</b> in orbit" : ""][gear_low_orbit ? ", <b>[gear_low_orbit]</b> in low orbit" : ""]."))
	if(closest < 900)
		output = TRUE
		var/areaName = get_area_name(areaLoc)
		if(closest == 0)
			to_chat(hunter, SPAN_NOTICE("You are directly on top of the[closest_item ? " <b>[closest_item.name]</b>'s" : ""] signature."))
		else
			to_chat(hunter, SPAN_NOTICE("The closest signature[closest_item ? ", a <b>[closest_item.name]</b>" : ""], is [closest > 10 ? "approximately <b>[round(closest, 10)]</b>" : "<b>[closest]</b>"] paces <b>[dir2text(direction)]</b> in <b>[areaName]</b>."))
	if(!output)
		to_chat(hunter, SPAN_NOTICE("There are no signatures that require your attention."))
	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/cloaker()
	set name = "Toggle Cloaking Device"
	set desc = "Activate your suit's cloaking device. It will malfunction if the suit takes damage or gets excessively wet."
	set category = "Yautja.Utility"
	set src in usr
	. = cloaker_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/cloaker_internal(mob/caller, forced = FALSE, silent = FALSE, instant = FALSE)
	. = check_random_function(caller, forced)
	if(.)
		return

	var/mob/living/carbon/human/M = caller
	var/new_alpha = cloak_alpha

	if(!istype(M) || M.is_mob_incapacitated())
		return FALSE

	if(HAS_TRAIT(caller, TRAIT_CLOAKED)) //Turn it off.
		if(cloak_timer > world.time)
			to_chat(M, SPAN_WARNING("Your cloaking device is busy! Time left: <B>[max(floor((cloak_timer - world.time) / 10), 1)]</b> seconds."))
			return FALSE
		decloak(caller)
	else //Turn it on!
		if(exploding)
			to_chat(M, SPAN_WARNING("Your bracer is much too busy violently exploding to activate the cloaking device."))
			return FALSE

		if(cloak_malfunction > world.time)
			to_chat(M, SPAN_WARNING("Your cloak is malfunctioning and can't be enabled right now!"))
			return FALSE

		if(cloak_timer > world.time)
			to_chat(M, SPAN_WARNING("Your cloaking device is still recharging! Time left: <B>[max(floor((cloak_timer - world.time) / 10), 1)]</b> seconds."))
			return FALSE

		if(!drain_power(M, 50))
			return FALSE

		ADD_TRAIT(M, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))

		RegisterSignal(M, COMSIG_HUMAN_EXTINGUISH, PROC_REF(wrapper_fizzle_camouflage))
		RegisterSignal(M, COMSIG_HUMAN_PRE_BULLET_ACT, PROC_REF(bullet_hit))
		RegisterSignal(M, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak))

		cloak_timer = world.time + 1.5 SECONDS
		if(true_cloak)
			M.invisibility = INVISIBILITY_LEVEL_ONE
			M.see_invisible = SEE_INVISIBLE_LEVEL_ONE

		log_game("[key_name_admin(usr)] has enabled their cloaking device.")
		if(!silent)
			M.visible_message(SPAN_WARNING("[M] vanishes into thin air!"), SPAN_NOTICE("You are now invisible to normal detection."))
			var/sound_to_use
			if(invisibility_sound == PRED_TECH_MODERN)
				sound_to_use = 'sound/effects/pred_cloakon_modern.ogg'
			else
				sound_to_use = 'sound/effects/pred_cloakon.ogg'
			playsound(M.loc, sound_to_use, 15, 1, 4)

		if(!instant)
			animate(M, alpha = new_alpha, time = 1.5 SECONDS, easing = SINE_EASING|EASE_OUT)
		else
			M.alpha = new_alpha

		var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
		SA.remove_from_hud(M)
		var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
		XI.remove_from_hud(M)
		if(!instant)
			anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

	var/datum/action/predator_action/bracer/cloak/cloak_action
	for(cloak_action as anything in M.actions)
		if(istypestrict(cloak_action, /datum/action/predator_action/bracer/cloak))
			cloak_action.update_button_icon(HAS_TRAIT(caller, TRAIT_CLOAKED))
			break

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/wrapper_fizzle_camouflage()
	SIGNAL_HANDLER

	var/mob/wearer = src.loc
	wearer.visible_message(SPAN_DANGER("[wearer]'s cloak fizzles out!"), SPAN_DANGER("Your cloak fizzles out!"))

	var/datum/effect_system/spark_spread/sparks = new /datum/effect_system/spark_spread
	sparks.set_up(5, 4, src)
	sparks.start()

	decloak(wearer, TRUE, DECLOAK_EXTINGUISHER)

/obj/item/clothing/gloves/yautja/hunter/decloak(mob/user, forced, force_multipler = DECLOAK_FORCED)
	if(!user)
		return

	SEND_SIGNAL(src, COMSIG_PRED_BRACER_DECLOAKED)

	UnregisterSignal(user, COMSIG_HUMAN_EXTINGUISH)
	UnregisterSignal(user, COMSIG_HUMAN_PRE_BULLET_ACT)
	UnregisterSignal(user, COMSIG_MOB_EFFECT_CLOAK_CANCEL)

	var/decloak_timer = (DECLOAK_STANDARD * force_multipler)
	if(forced)
		cloak_malfunction = world.time + decloak_timer

	REMOVE_TRAIT(user, TRAIT_CLOAKED, TRAIT_SOURCE_EQUIPMENT(WEAR_HANDS))
	log_game("[key_name_admin(user)] has disabled their cloaking device.")
	user.visible_message(SPAN_WARNING("[user] shimmers into existence!"), SPAN_WARNING("Your cloaking device deactivates."))
	var/sound_to_use
	if(invisibility_sound == PRED_TECH_MODERN)
		sound_to_use = 'sound/effects/pred_cloakoff_modern.ogg'
	else
		sound_to_use = 'sound/effects/pred_cloakoff.ogg'
	playsound(user.loc, sound_to_use, 15, 1, 4)
	user.alpha = initial(user.alpha)
	if(true_cloak)
		user.invisibility = initial(user.invisibility)
		user.see_invisible = initial(user.see_invisible)
	cloak_timer = world.time + (DECLOAK_STANDARD / 2)

	var/datum/mob_hud/security/advanced/SA = GLOB.huds[MOB_HUD_SECURITY_ADVANCED]
	SA.add_to_hud(user)
	var/datum/mob_hud/xeno_infection/XI = GLOB.huds[MOB_HUD_XENO_INFECTION]
	XI.add_to_hud(user)

	anim(user.loc, user, 'icons/mob/mob.dmi', null, "uncloak", null, user.dir)

/obj/item/clothing/gloves/yautja/hunter/verb/caster()
	set name = "Use Plasma Caster"
	set desc = "Activate your plasma caster. If it is dropped it will retract back into your armor."
	set category = "Yautja.Weapons"
	set src in usr
	. = caster_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/caster_internal(mob/living/carbon/human/caller, forced = FALSE)
	if(!caller.loc || caller.is_mob_incapacitated() || !ishuman(caller))
		return

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caster_deployed)
		if(caster.loc == caller)
			caller.drop_inv_item_to_loc(caster, src, FALSE, TRUE)
		caster_deployed = FALSE
	else
		if(!drain_power(caller, 50))
			return
		if(caller.get_active_hand())
			to_chat(caller, SPAN_WARNING("Your hand must be free to activate your plasma caster!"))
			return
		var/obj/limb/hand = caller.get_limb(caller.hand ? "l_hand" : "r_hand")
		if(!istype(hand) || !hand.is_usable())
			to_chat(caller, SPAN_WARNING("You can't hold that!"))
			return
		if(caller.faction == FACTION_YAUTJA_YOUNG)
			to_chat(caller, SPAN_WARNING("You have not earned that right yet!"))
			return
		caller.put_in_active_hand(caster)
		caster_deployed = TRUE
		if(caller.client?.prefs.custom_cursors)
			caller.client?.mouse_pointer_icon = 'icons/effects/mouse_pointer/plasma_caster_mouse.dmi'
		to_chat(caller, SPAN_NOTICE("You activate your plasma caster. It is in [caster.mode] mode."))
		playsound(src, 'sound/weapons/pred_plasmacaster_on.ogg', 15, TRUE)

		var/datum/action/predator_action/bracer/caster/caster_action
		for(caster_action as anything in caller.actions)
			if(istypestrict(caster_action, /datum/action/predator_action/bracer/caster))
				caster_action.update_button_icon(caster_deployed)
				break

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/proc/explode(mob/living/carbon/victim)
	set waitfor = 0

	if(exploding)
		return

	notify_ghosts(header = "Yautja self destruct", message = "[victim.real_name] is self destructing to protect their honor!", source = victim, action = NOTIFY_ORBIT)

	exploding = 1
	var/turf/T = get_turf(victim)
	if(explosion_type == SD_TYPE_BIG && (is_ground_level(T.z) || MODE_HAS_MODIFIER(/datum/gamemode_modifier/yautja_shipside_large_sd)))
		playsound(src, 'sound/voice/pred_deathlaugh.ogg', 100, 0, 17, status = 0)

	playsound(src, 'sound/effects/pred_countdown.ogg', 100, 0, 17, status = 0)
	message_admins(FONT_SIZE_XL("<A href='byond://?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];admincancelpredsd=1;bracer=\ref[src];victim=\ref[victim]'>CLICK TO CANCEL THIS PRED SD</a>"))
	do_after(victim, rand(72, 80), INTERRUPT_NONE, BUSY_ICON_HOSTILE)

	T = get_turf(victim)
	if(istype(T) && exploding)
		victim.apply_damage(50,BRUTE,"chest")
		if(victim)
			victim.gib() // kills the pred
			qdel(victim)
		var/datum/cause_data/cause_data = create_cause_data("yautja self-destruct", victim)
		if(explosion_type == SD_TYPE_BIG && (is_ground_level(T.z) || MODE_HAS_MODIFIER(/datum/gamemode_modifier/yautja_shipside_large_sd)))
			cell_explosion(T, 600, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data) //Dramatically BIG explosion.
		else
			cell_explosion(T, 800, 550, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)

/obj/item/clothing/gloves/yautja/hunter/verb/change_explosion_type()
	set name = "Change Explosion Type"
	set desc = "Changes your bracer explosion to either only gib you or be a big explosion."
	set category = "Yautja.Misc"
	set src in usr

	if(explosion_type == SD_TYPE_SMALL && exploding)
		to_chat(usr, SPAN_WARNING("Why would you want to do this?"))
		return

	if(alert("Which explosion type do you want?","Explosive Bracers", "Small", "Big") == "Big")
		explosion_type = SD_TYPE_BIG
		log_attack("[key_name_admin(usr)] has changed their Self-Destruct to Large")
	else
		explosion_type = SD_TYPE_SMALL
		log_attack("[key_name_admin(usr)] has changed their Self-Destruct to Small")
		return

/obj/item/clothing/gloves/yautja/hunter/verb/activate_suicide()
	set name = "Final Countdown (!)"
	set desc = "Activate the explosive device implanted into your bracers. You have failed! Show some honor!"
	set category = "Yautja.Misc"
	set src in usr
	. = activate_suicide_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/activate_suicide_internal(mob/caller, forced = FALSE)
	. = check_random_function(caller, forced, TRUE)
	if(.)
		return

	var/mob/living/carbon/human/boomer = caller
	var/area/grounds = get_area(boomer)

	if(HAS_TRAIT(boomer, TRAIT_CLOAKED))
		to_chat(boomer, SPAN_WARNING("Not while you're cloaked. It might disrupt the sequence."))
		return
	if(boomer.stat == DEAD)
		to_chat(boomer, SPAN_WARNING("Little too late for that now!"))
		return
	if(boomer.health < HEALTH_THRESHOLD_CRIT)
		to_chat(boomer, SPAN_WARNING("As you fall into unconsciousness you fail to activate your self-destruct device before you collapse."))
		return
	if(boomer.stat)
		to_chat(boomer, SPAN_WARNING("Not while you're unconscious..."))
		return
	if(grounds?.flags_area & AREA_YAUTJA_HUNTING_GROUNDS) // Hunted need mask to escape
		to_chat(boomer, SPAN_WARNING("Your bracer will not allow you to activate a self-destruction sequence in order to protect the hunting preserve."))
		return
	if(caller.faction == FACTION_YAUTJA_YOUNG)
		to_chat(boomer, SPAN_WARNING("You don't yet understand how to use this.")) // No SDing for youngbloods
		return

	var/obj/item/grab/G = boomer.get_active_hand()
	if(istype(G))
		var/mob/living/carbon/human/victim = G.grabbed_thing
		if(victim.stat == DEAD)
			var/obj/item/clothing/gloves/yautja/hunter/bracer = victim.gloves
			var/message = "Are you sure you want to detonate this [victim.species]'s bracer?"
			if(isspeciesyautja(victim))
				message = "Are you sure you want to send this [victim.species] into the great hunting grounds?"
			if(istype(bracer))
				if(forced || alert(message,"Explosive Bracers", "Yes", "No") == "Yes")
					if(boomer.get_active_hand() == G && victim && victim.gloves == bracer && !bracer.exploding)
						var/area/A = get_area(boomer)
						var/turf/T = get_turf(boomer)
						if(A)
							message_admins(FONT_SIZE_HUGE("ALERT: [boomer] ([boomer.key]) triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name] [ADMIN_JMP(T)]</font>"))
							log_attack("[key_name(boomer)] triggered the predator self-destruct sequence of [victim] ([victim.key]) in [A.name]")
						if (!bracer.exploding)
							bracer.explode(victim)
						boomer.visible_message(SPAN_WARNING("[boomer] presses a few buttons on [victim]'s wrist bracer."),SPAN_DANGER("You activate the timer. May [victim]'s final hunt be swift."))
						message_all_yautja("[boomer.real_name] has triggered [victim.real_name]'s bracer's self-destruction sequence.")
			else
				to_chat(boomer, SPAN_WARNING("<b>This [victim.species] does not have a bracer attached.</b>"))
			return

	if(boomer.gloves != src && !forced)
		return

	if(exploding)
		if(forced || alert("Are you sure you want to stop the countdown?","Bracers", "Yes", "No") == "Yes")
			if(boomer.gloves != src)
				return
			if(boomer.stat == DEAD)
				to_chat(boomer, SPAN_WARNING("Little too late for that now!"))
				return
			if(boomer.stat)
				to_chat(boomer, SPAN_WARNING("Not while you're unconscious..."))
				return
			exploding = FALSE
			to_chat(boomer, SPAN_NOTICE("Your bracers stop beeping."))
			message_all_yautja("[boomer.real_name] has cancelled their bracer's self-destruction sequence.")
			message_admins("[key_name(boomer)] has deactivated their Self-Destruct.")

			var/datum/action/predator_action/bracer/self_destruct/sd_action
			for(sd_action as anything in boomer.actions)
				if(istypestrict(sd_action, /datum/action/predator_action/bracer/self_destruct))
					sd_action.update_button_icon(exploding)
					break

		return

	if(istype(boomer.wear_mask,/obj/item/clothing/mask/facehugger) || (boomer.status_flags & XENO_HOST))
		to_chat(boomer, SPAN_WARNING("Strange...something seems to be interfering with your bracer functions..."))
		return

	if(forced || alert("Detonate the bracers? Are you sure?\n\nNote: If you activate SD for any non-accidental reason during or after a fight, you commit to the SD. By initially activating the SD, you have accepted your impending death to preserve any lost honor.","Explosive Bracers", "Yes", "No") == "Yes")
		if(boomer.gloves != src)
			return
		if(boomer.stat == DEAD)
			to_chat(boomer, SPAN_WARNING("Little too late for that now!"))
			return
		if(boomer.stat)
			to_chat(boomer, SPAN_WARNING("Not while you're unconscious..."))
			return
		if(grounds?.flags_area & AREA_YAUTJA_HUNTING_GROUNDS) //Hunted need mask to escape
			to_chat(boomer, SPAN_WARNING("Your bracer will not allow you to activate a self-destruction sequence in order to protect the hunting preserve."))
			return
		if(exploding)
			return
		to_chat(boomer, SPAN_DANGER("You set the timer. May your journey to the great hunting grounds be swift."))
		var/area/A = get_area(boomer)
		var/turf/T = get_turf(boomer)
		message_admins(FONT_SIZE_HUGE("ALERT: [boomer] ([boomer.key]) triggered their predator self-destruct sequence [A ? "in [A.name]":""] [ADMIN_JMP(T)]"))
		log_attack("[key_name(boomer)] triggered their predator self-destruct sequence in [A ? "in [A.name]":""]")
		message_all_yautja("[boomer.real_name] has triggered their bracer's self-destruction sequence.")
		explode(boomer)

		var/datum/action/predator_action/bracer/self_destruct/sd_action
		for(sd_action as anything in boomer.actions)
			if(istypestrict(sd_action, /datum/action/predator_action/bracer/self_destruct))
				sd_action.update_button_icon(exploding)
				break

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/remote_kill()
	set name = "Remotely Kill Youngblood"
	set desc = "Remotley kill a youngblood for breaking the honour code."
	set category = "Yautja.Misc"
	set src in usr
	. = remote_kill_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/remote_kill_internal(mob/living/carbon/human/caller, forced = FALSE)
	if(!caller.loc || caller.is_mob_incapacitated() || !ishuman(caller))
		return

	if(caller.faction == FACTION_YAUTJA_YOUNG)
		to_chat(caller, SPAN_WARNING("This button is not for you."))
		return

	if(!HAS_TRAIT(caller, TRAIT_YAUTJA_TECH))
		to_chat(caller, SPAN_WARNING("A large list appears but you cannot understand what it means."))
		return

	var/list/target_list = list()
	for(var/mob/living/carbon/human/target_youngbloods as anything in GLOB.yautja_mob_list)
		if(target_youngbloods.faction == FACTION_YAUTJA_YOUNG && target_youngbloods.stat != DEAD)
			target_list[target_youngbloods.real_name] = target_youngbloods

	if(!length(target_list))
		to_chat(caller, SPAN_NOTICE("No youngbloods are currently alive."))
		return

	var/choice = tgui_input_list(caller, "Choose a young hunter to terminate:", "Kill Youngblood", target_list)

	if(!choice)
		return

	var/mob/living/target_youngblood = target_list[choice]

	var/reason = tgui_input_text(caller, "Youngblood Terminator", "Provide a reason for terminating [target_youngblood.real_name].")
	if(!reason)
		to_chat(caller, SPAN_WARNING("You must provide a reason for terminating [target_youngblood.real_name]."))
		return

	var/area/location = get_area(target_youngblood)
	var/turf/floor = get_turf(target_youngblood)
	target_youngblood.death(create_cause_data("Youngblood Termination"), TRUE)
	message_all_yautja("[caller.real_name] has terminated [target_youngblood.real_name] for: '[reason]'.")
	message_admins(FONT_SIZE_LARGE("ALERT: [caller.real_name] ([caller.key]) Terminated [target_youngblood.real_name] ([target_youngblood.key]) in [location.name] for: '[reason]' [ADMIN_JMP(floor)]</font>"))

#define YAUTJA_CREATE_CRYSTAL_COOLDOWN "yautja_create_crystal_cooldown"

/obj/item/clothing/gloves/yautja/hunter/verb/injectors()
	set name = "Create Stabilising Crystal"
	set category = "Yautja.Utility"
	set desc = "Create a focus crystal to energize your natural healing processes."
	set src in usr
	. = injectors_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/injectors_internal(mob/caller, forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caller.get_active_hand())
		to_chat(caller, SPAN_WARNING("Your active hand must be empty!"))
		return FALSE

	if(TIMER_COOLDOWN_CHECK(src, YAUTJA_CREATE_CRYSTAL_COOLDOWN))
		var/remaining_time = DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(src, YAUTJA_CREATE_CRYSTAL_COOLDOWN))
		to_chat(caller, SPAN_WARNING("You recently synthesized a stabilising crystal. A new crystal will be available in [remaining_time]."))
		return FALSE

	if(!drain_power(caller, 400))
		return FALSE

	S_TIMER_COOLDOWN_START(src, YAUTJA_CREATE_CRYSTAL_COOLDOWN, 2 MINUTES)

	to_chat(caller, SPAN_NOTICE("You feel a faint hiss and a crystalline injector drops into your hand."))
	var/obj/item/reagent_container/hypospray/autoinjector/yautja/O = new(caller)
	caller.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return TRUE
#undef YAUTJA_CREATE_CRYSTAL_COOLDOWN

/obj/item/clothing/gloves/yautja/hunter/verb/healing_capsule()
	set name = "Create Healing Capsule"
	set category = "Yautja.Utility"
	set desc = "Create a healing capsule for your healing gun."
	set src in usr
	. = healing_capsule_internal(usr, FALSE)

#define YAUTJA_CREATE_CAPSULE_COOLDOWN "yautja_create_capsule_cooldown"
/obj/item/clothing/gloves/yautja/hunter/proc/healing_capsule_internal(mob/caller, forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caller.get_active_hand())
		to_chat(caller, SPAN_WARNING("Your active hand must be empty!"))
		return FALSE

	if(TIMER_COOLDOWN_CHECK(src, YAUTJA_CREATE_CAPSULE_COOLDOWN))
		var/remaining_time = DisplayTimeText(S_TIMER_COOLDOWN_TIMELEFT(src, YAUTJA_CREATE_CAPSULE_COOLDOWN))
		to_chat(caller, SPAN_WARNING("You recently synthesized a healing capsule. A new capsule will be available in [remaining_time]."))
		return FALSE

	if(!drain_power(caller, 600))
		return FALSE

	S_TIMER_COOLDOWN_START(src, YAUTJA_CREATE_CAPSULE_COOLDOWN, 4 MINUTES)

	to_chat(caller, SPAN_NOTICE("You feel your bracer churn as it pops out a healing capsule."))
	var/obj/item/tool/surgery/healing_gel/O = new(caller)
	caller.put_in_active_hand(O)
	playsound(src, 'sound/machines/click.ogg', 15, 1)
	return TRUE

#undef YAUTJA_CREATE_CAPSULE_COOLDOWN

/obj/item/clothing/gloves/yautja/hunter/verb/call_disc()
	set name = "Call Smart-Disc"
	set category = "Yautja.Weapons"
	set desc = "Call back your smart-disc, if it's in range. If not you'll have to go retrieve it."
	set src in usr
	. = call_disc_internal(usr, FALSE)


/obj/item/clothing/gloves/yautja/hunter/proc/call_disc_internal(mob/caller, forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	if(disc_timer)
		to_chat(caller, SPAN_WARNING("Your bracers need some time to recuperate first."))
		return FALSE

	if(!drain_power(caller, 70))
		return FALSE

	disc_timer = TRUE
	addtimer(VARSET_CALLBACK(src, disc_timer, FALSE), 10 SECONDS)

	for(var/mob/living/simple_animal/hostile/smartdisc/S in range(7))
		to_chat(caller, SPAN_WARNING("[S] skips back towards you!"))
		new /obj/item/explosive/grenade/spawnergrenade/smartdisc(S.loc)
		qdel(S)

	for(var/obj/item/explosive/grenade/spawnergrenade/smartdisc/D in range(10))
		if(isturf(D.loc))
			D.boomerang(caller)

	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/remove_tracked_item()
	set name = "Remove Item from Tracker"
	set desc = "Remove an item from the Yautja tracker."
	set category = "Yautja.Tracker"
	set src in usr
	. = remove_tracked_item_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/remove_tracked_item_internal(mob/caller, forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	var/obj/item/tracked_item = caller.get_active_hand()
	if(!tracked_item)
		to_chat(caller, SPAN_WARNING("You need the item in your active hand to remove it from the tracker!"))
		return FALSE
	if(!(tracked_item in GLOB.tracked_yautja_gear))
		to_chat(caller, SPAN_WARNING("\The [tracked_item] isn't on the tracking system."))
		return FALSE
	tracked_item.RemoveElement(/datum/element/yautja_tracked_item)
	to_chat(caller, SPAN_NOTICE("You remove \the <b>[tracked_item]</b> from the tracking system."))
	return TRUE


/obj/item/clothing/gloves/yautja/hunter/verb/add_tracked_item()
	set name = "Add Item to Tracker"
	set desc = "Add an item to the Yautja tracker."
	set category = "Yautja.Tracker"
	set src in usr
	. = add_tracked_item_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/add_tracked_item_internal(mob/caller, forced = FALSE)
	if(caller.is_mob_incapacitated())
		return FALSE

	. = check_random_function(caller, forced)
	if(.)
		return

	var/obj/item/untracked_item = caller.get_active_hand()
	if(!untracked_item)
		to_chat(caller, SPAN_WARNING("You need the item in your active hand to remove it from the tracker!"))
		return FALSE
	if(untracked_item in GLOB.tracked_yautja_gear)
		to_chat(caller, SPAN_WARNING("\The [untracked_item] is already being tracked."))
		return FALSE
	untracked_item.AddElement(/datum/element/yautja_tracked_item)
	to_chat(caller, SPAN_NOTICE("You add \the <b>[untracked_item]</b> to the tracking system."))
	return TRUE

/obj/item/clothing/gloves/yautja/hunter/verb/translate()
	set name = "Translator"
	set desc = "Emit a message from your bracer to those nearby."
	set category = "Yautja.Utility"
	set src in usr
	. = translate_internal(usr, FALSE)

/obj/item/clothing/gloves/yautja/hunter/proc/translate_internal(mob/caller, forced = FALSE)
	if(!caller || caller.stat)
		return

	. = check_random_function(caller, forced)
	if(.)
		return

	if(caller.client.prefs.muted & MUTE_IC)
		to_chat(caller, SPAN_DANGER("You cannot translate (muted)."))
		return

	caller.create_typing_indicator()
	var/msg = sanitize(input(caller, "Your bracer beeps and waits patiently for you to input your message.", "Translator", "") as text)
	caller.remove_typing_indicator()
	if(!msg || !caller.client)
		return

	if(!drain_power(caller, 50))
		return

	log_say("[caller.name != "Unknown" ? caller.name : "([caller.real_name])"] \[Yautja Translator\]: [msg] (CKEY: [caller.key]) (JOB: [caller.job]) (AREA: [get_area_name(caller)])")

	var/list/heard = get_mobs_in_view(7, caller)
	for(var/mob/M in heard)
		if(M.ear_deaf)
			heard -= M

	var/overhead_color = "#ff0505"
	var/span_class = "yautja_translator"
	if(translator_type != PRED_TECH_MODERN)
		if(translator_type == PRED_TECH_RETRO)
			overhead_color = "#FFFFFF"
			span_class = "retro_translator"
		msg = replacetext(msg, "a", "@")
		msg = replacetext(msg, "e", "3")
		msg = replacetext(msg, "i", "1")
		msg = replacetext(msg, "o", "0")
		msg = replacetext(msg, "s", "5")
		msg = replacetext(msg, "l", "1")

	caller.langchat_speech(msg, heard, GLOB.all_languages, overhead_color, TRUE)

	var/voice_name = "A strange voice"
	if(caller.name == caller.real_name && caller.alpha == initial(caller.alpha))
		voice_name = "<b>[caller.name]</b>"
	for(var/mob/Q as anything in heard)
		if(Q.stat && !isobserver(Q))
			continue //Unconscious
		to_chat(Q, "[SPAN_INFO("[voice_name] says,")] <span class='[span_class]'>'[msg]'</span>")

/obj/item/clothing/gloves/yautja/hunter/verb/bracername()
	set name = "Toggle Bracer Name"
	set desc = "Toggle whether fellow Yautja that examine you will be able to see your name."
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	name_active = !name_active
	to_chat(usr, SPAN_NOTICE("\The [src] will [name_active ? "now" : "no longer"] show your name when fellow Yautja examine you."))

/obj/item/clothing/gloves/yautja/hunter/verb/idchip()
	set name = "Toggle ID Chip"
	set desc = "Reveal/Hide your embedded bracer ID chip."
	set category = "Yautja.Misc"
	set src in usr

	if(usr.is_mob_incapacitated())
		return

	var/mob/living/carbon/human/H = usr
	if(!istype(H) || !HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("You do not know how to use this."))
		return

	if(H.wear_id == embedded_id)
		to_chat(H, SPAN_NOTICE("You retract your ID chip."))
		move_chip_to_bracer()
	else if(H.wear_id)
		to_chat(H, SPAN_WARNING("Something is obstructing the deployment of your ID chip!"))
	else
		to_chat(H, SPAN_NOTICE("You expose your ID chip."))
		if(!H.equip_to_slot_if_possible(embedded_id, WEAR_ID))
			to_chat(H, SPAN_WARNING("Something went wrong during your chip's deployment! (Make a Bug Report about this)"))
			move_chip_to_bracer()

/obj/item/clothing/gloves/yautja/hunter/proc/move_chip_to_bracer()
	if(!embedded_id || !embedded_id.loc)
		return

	if(embedded_id.loc == src)
		return

	if(ismob(embedded_id.loc))
		var/mob/M = embedded_id.loc
		M.u_equip(embedded_id, src, FALSE, TRUE)
	else
		embedded_id.forceMove(src)

/// Verb to let Yautja attempt the unlocking.
/obj/item/clothing/gloves/yautja/hunter/verb/toggle_lock()
	set name = "Toggle Bracer Lock"
	set desc = "Toggle the lock on your bracers, allowing them to be removed."
	set category = "Yautja.Misc"
	set src in usr

	if(usr.stat)
		to_chat(usr, SPAN_WARNING("You can't do that right now..."))
		return FALSE
	if(!HAS_TRAIT(usr, TRAIT_YAUTJA_TECH))
		to_chat(usr, SPAN_WARNING("You have no idea how to use this..."))
		return FALSE

	attempt_toggle_lock(usr, FALSE)
	return TRUE

/// Handles all the locking and unlocking of bracers.
/obj/item/clothing/gloves/yautja/proc/attempt_toggle_lock(mob/user, force_lock)
	if(!user)
		return FALSE

	var/obj/item/grab/held_mob = user.get_active_hand()
	if(!istype(held_mob))
		log_attack("[key_name_admin(usr)] has unlocked their own bracer.")
		toggle_lock_internal(user)
		return TRUE

	var/mob/living/carbon/human/victim = held_mob.grabbed_thing
	var/obj/item/clothing/gloves/yautja/bracer = victim.gloves
	if(isspeciesyautja(victim) && !(victim.stat == DEAD))
		to_chat(user, SPAN_WARNING("You cannot unlock the bracer of a living hunter!"))
		return FALSE

	if(!istype(bracer))
		to_chat(user, SPAN_WARNING("<b>This [victim.species] does not have a bracer attached.</b>"))
		return FALSE

	if(alert("Are you sure you want to unlock this [victim.species]'s bracer?", "Unlock Bracers", "Yes", "No") != "Yes")
		return FALSE

	if(user.get_active_hand() == held_mob && victim && victim.gloves == bracer)
		log_interact(user, victim, "[key_name(user)] unlocked the [bracer.name] of [key_name(victim)].")
		user.visible_message(SPAN_WARNING("[user] presses a few buttons on [victim]'s wrist bracer."),SPAN_DANGER("You unlock the bracer."))
		bracer.toggle_lock_internal(victim)
		return TRUE

/// The actual unlock/lock function.
/obj/item/clothing/gloves/yautja/proc/toggle_lock_internal(mob/wearer, force_lock)
	if(((flags_item & NODROP) || (flags_inventory & CANTSTRIP)) && !force_lock)
		return unlock_bracer()

	return lock_bracer()

/obj/item/clothing/gloves/yautja/proc/lock_bracer(mob/wearer)
	flags_item |= NODROP
	flags_inventory |= CANTSTRIP
	if(wearer)
		if(isyautja(wearer))
			to_chat(wearer, SPAN_WARNING("The bracer clamps securely around your forearm and beeps in a comfortable, familiar way."))
		else
			to_chat(wearer, SPAN_WARNING("The bracer clamps painfully around your forearm and beeps angrily. It won't come off!"))
	return TRUE

/obj/item/clothing/gloves/yautja/proc/unlock_bracer(mob/wearer)
	flags_item &= ~NODROP
	flags_inventory &= ~CANTSTRIP
	if(wearer)
		if(!isyautja(wearer))
			to_chat(wearer, SPAN_WARNING("The bracer beeps pleasantly, releasing its grip on your forearm."))
		else
			to_chat(wearer, SPAN_WARNING("With an angry blare, the bracer releases your forearm."))
	return TRUE
