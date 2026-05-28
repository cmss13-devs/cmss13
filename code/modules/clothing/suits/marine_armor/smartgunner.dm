/obj/item/clothing/suit/storage/marine/smartgunner
	name = "\improper M56 combat harness"
	desc = "A heavy protective vest designed to be worn with the M56 Smartgun System. \nIt has specially designed straps and reinforcement to carry the Smartgun and accessories."
	icon_state = "8"
	item_state = "armor"
	armor_laser = CLOTHING_ARMOR_LOW
	armor_rad = CLOTHING_ARMOR_MEDIUM
	storage_slots = 2
	slowdown = SLOWDOWN_ARMOR_LIGHT
	flags_inventory = BLOCKSHARPOBJ|SMARTGUN_HARNESS
	unacidable = TRUE
	allowed = list(
		/obj/item/tank/emergency_oxygen,
		/obj/item/device/flashlight,
		/obj/item/ammo_magazine,
		/obj/item/explosive/mine,
		/obj/item/attachable/bayonet,
		/obj/item/weapon/gun/smartgun,
		/obj/item/storage/backpack/general_belt,
		/obj/item/device/motiondetector,
		/obj/item/device/walkman,
	)

	//var/gyroscopic_armature = "potato_arm"
	var/armature_icon = "wire_rope"
	var/armature_range = 2

	/// the smartie thats currently connected via tethering
	var/obj/item/weapon/gun/smartgun/connected_gun

/obj/item/clothing/suit/storage/marine/smartgunner/get_examine_text(mob/user)
	. = ..()

	if(connected_gun)
		. += SPAN_HELPFUL("The [src] is connected to [connected_gun] via the gyroscopic armature.")

/obj/item/clothing/suit/storage/marine/smartgunner/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] && name == "M56 combat harness")
		name = "M56 snow combat harness"
	else
		name = "M56 combat harness"

/obj/item/clothing/suit/storage/marine/smartgunner/mob_can_equip(mob/equipping_mob, slot, disable_warning = FALSE)
	. = ..()

	if(equipping_mob.back && !(equipping_mob.back.flags_item & SMARTGUNNER_BACKPACK_OVERRIDE))
		if(!disable_warning)
			to_chat(equipping_mob, SPAN_WARNING("You can't equip [src] while wearing a backpack."))
		return FALSE

/obj/item/clothing/suit/storage/marine/smartgunner/equipped(mob/user, slot, silent)
	. = ..()

	if(slot == WEAR_JACKET)
		RegisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP, PROC_REF(check_equipping))

/obj/item/clothing/suit/storage/marine/smartgunner/proc/check_equipping(mob/living/carbon/human/equipping_human, obj/item/equipping_item, slot)
	SIGNAL_HANDLER

	if(slot != WEAR_BACK)
		return

	if(equipping_item.flags_item & SMARTGUNNER_BACKPACK_OVERRIDE)
		return

	. = COMPONENT_HUMAN_CANCEL_ATTEMPT_EQUIP

	if(equipping_item.flags_equip_slot == SLOT_BACK)
		to_chat(equipping_human, SPAN_WARNING("You can't equip [equipping_item] on your back while wearing [src]."))
		return

/obj/item/clothing/suit/storage/marine/smartgunner/unequipped(mob/user, slot)
	. = ..()

	UnregisterSignal(user, COMSIG_HUMAN_ATTEMPTING_EQUIP)

/obj/item/clothing/suit/storage/marine/smartgunner/reinforced
	name = "\improper M56 reinforced combat harness"
	desc = "A heavy protective vest designed to be worn with the M56 Smartgun System, this one also has a bulky reinforced plate attached to it, hurting agility but providing more armor. \nIt has specially designed straps and reinforcement to carry the Smartgun and accessories."
	icon_state = "sg"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bio = CLOTHING_ARMOR_MEDIUMHIGH
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMHIGH
	slowdown = SLOWDOWN_ARMOR_MEDIUM

/obj/item/clothing/suit/storage/marine/smartgunner/reinforced/Initialize()
	. = ..()
	if(SSmapping.configs[GROUND_MAP].environment_traits[MAP_COLD] && name == "M56 reinforced combat harness")
		name = "M56 reinforced snow combat harness"
	else
		name = "M56 reinforced combat harness"

// SMARTGUN RETRIEVAL START (or whats essentially just a copy and paste of drop_retrieval.dm)

/datum/element/drop_retrieval/smartgun
	parent_type = /datum/element/drop_retrieval/gun
	id_arg_index = 3
	compatible_types = list(/obj/item/weapon/gun/smartgun)
	var/obj/item/weapon/gun/smartgun/gun
	var/obj/item/clothing/suit/storage/harness
	var/datum/effects/tethering/active_tether
	var/armature_icon
	var/armature_range

/datum/element/drop_retrieval/smartgun/Attach(datum/target, slot, obj/item/clothing/suit/storage/new_harness, icon, range)
	. = ..(target, slot)
	if(.)
		return
	gun = target
	harness = new_harness
	armature_icon = icon
	armature_range = range
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(check_tether))
	RegisterSignal(harness, COMSIG_MOVABLE_MOVED, PROC_REF(harness_moved))
	RegisterSignal(harness, COMSIG_DROP_RETRIEVAL_CHECK, PROC_REF(dr_check))

/datum/element/drop_retrieval/smartgun/Detach(datum/source, force)
	if(active_tether)
		UnregisterSignal(active_tether, COMSIG_PARENT_QDELETING)
		QDEL_NULL(active_tether)
	UnregisterSignal(source, list(COMSIG_MOVABLE_MOVED, COMSIG_ITEM_HOLSTER))
	if(harness)
		UnregisterSignal(harness, list(COMSIG_MOVABLE_MOVED, COMSIG_DROP_RETRIEVAL_CHECK))
	gun = null
	harness = null
	return ..()

/datum/element/drop_retrieval/smartgun/dropped(obj/item/weapon/gun/smartgun/smartie, mob/user)
	. = ..()
	maintain_tether()

/datum/element/drop_retrieval/smartgun/proc/check_tether(atom/movable/source)
	SIGNAL_HANDLER

	if(active_tether)
		if(source.loc == harness)
			QDEL_NULL(active_tether)
			return
		var/atom/current_target = active_tether.tethered?.affected_atom
		var/atom/desired_target = get_tether_target()
		if(current_target != desired_target)
			qdel(active_tether)

	maintain_tether()

/datum/element/drop_retrieval/smartgun/proc/harness_moved(datum/source)
	SIGNAL_HANDLER

	if(active_tether)
		var/atom/current_anchor = active_tether.affected_atom
		var/atom/desired_anchor = get_anchor()
		if(current_anchor != desired_anchor)
			qdel(active_tether)

	maintain_tether()

/datum/element/drop_retrieval/smartgun/proc/tether_deleted(datum/source)
	SIGNAL_HANDLER

	if(active_tether == source)
		active_tether = null

	maintain_tether()

/datum/element/drop_retrieval/smartgun/proc/maintain_tether()
	if(active_tether)
		return

	if(!gun || gun.loc == harness)
		return

	var/atom/anchor = get_anchor()
	var/atom/target = get_tether_target()

	if(anchor == target)
		return

	if(get_dist(anchor, target) > armature_range)
		step_towards(target, anchor)
		return

	var/list/tether_data = apply_tether(anchor, target, range = armature_range, icon = armature_icon)
	active_tether = tether_data["tetherer_tether"]
	RegisterSignal(active_tether, COMSIG_PARENT_QDELETING, PROC_REF(tether_deleted))

/datum/element/drop_retrieval/smartgun/proc/get_anchor()
	var/atom/object = harness
	var/i = 0
	while(object && !ismob(object) && i < 10)
		if(isturf(object.loc))
			return object
		object = object.loc
		i++
	if(ismob(object))
		return object
	return harness

/datum/element/drop_retrieval/smartgun/proc/get_tether_target()
	var/atom/item = gun
	var/i = 0
	while(item && !ismob(item) && i < 10)
		if(isturf(item.loc))
			return item
		item = item.loc
		i++
	if(ismob(item))
		return item
	return gun

// SMARTGUN RETRIEVAL END
