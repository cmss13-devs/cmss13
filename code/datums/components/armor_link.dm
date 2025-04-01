/**
 * Allows a piece of clothing to have their armor values change based on the values of another piece of clothing
 * Ex: Marine boots have their armor values change based on what type of armor you're wearing on your chest
*/

/datum/component/armor_link
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/linked_slot
	var/check_values //If true, only takes the armor values that are higher than the ones already set
	var/obj/item/clothing/linked
	var/mob/equipped_mob

/datum/component/armor_link/Initialize(linked_slot, check_values)
	. = ..()
	src.linked_slot = linked_slot
	src.check_values = check_values

/datum/component/armor_link/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))

/datum/component/armor_link/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	if(!isnull(equipped_mob))
		UnregisterSignal(equipped_mob, COMSIG_HUMAN_EQUIPPED_ITEM)
		equipped_mob = null
	if(!isnull(linked))
		UnregisterSignal(linked, COMSIG_ITEM_DROPPED)
		linked = null

/datum/component/armor_link/proc/on_equipped(obj/item/equipped, mob/M, slot)
	SIGNAL_HANDLER
	if(!equipped.is_valid_slot(slot, TRUE))
		return
	var/obj/item/clothing/to_link = M.get_item_by_slot(linked_slot)
	equipped_mob = M
	if(istype(to_link))
		link_armor(to_link)
	else
		RegisterSignal(M, COMSIG_HUMAN_EQUIPPED_ITEM, PROC_REF(on_human_equipped_item))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_unequipped))

/datum/component/armor_link/proc/on_human_equipped_item(equipper, item, slot)
	SIGNAL_HANDLER
	if(!istype(item, /obj/item/clothing) || (slot != linked_slot))
		return
	UnregisterSignal(equipped_mob, COMSIG_HUMAN_EQUIPPED_ITEM)
	link_armor(item)

/datum/component/armor_link/proc/link_armor(obj/item/clothing/to_link)
	var/obj/item/clothing/C = parent
	if(check_values)
		C.armor_melee = max(C.armor_melee, to_link.armor_melee)
		C.armor_bullet = max(C.armor_bullet, to_link.armor_bullet)
		C.armor_laser = max(C.armor_laser, to_link.armor_laser)
		C.armor_energy = max(C.armor_energy, to_link.armor_energy)
		C.armor_bomb = max(C.armor_bomb, to_link.armor_bomb)
		C.armor_bio = max(C.armor_bio, to_link.armor_bio)
		C.armor_rad = max(C.armor_rad, to_link.armor_rad)
		C.armor_internaldamage = max(C.armor_internaldamage, to_link.armor_internaldamage)
	else
		C.armor_melee = to_link.armor_melee
		C.armor_bullet = to_link.armor_bullet
		C.armor_laser = to_link.armor_laser
		C.armor_energy = to_link.armor_energy
		C.armor_bomb = to_link.armor_bomb
		C.armor_bio = to_link.armor_bio
		C.armor_rad = to_link.armor_rad
		C.armor_internaldamage = to_link.armor_internaldamage

	linked = to_link
	RegisterSignal(linked, COMSIG_ITEM_DROPPED, PROC_REF(break_link))

/datum/component/armor_link/proc/break_link()
	SIGNAL_HANDLER

	UnregisterSignal(linked, COMSIG_ITEM_DROPPED)
	linked = null

	var/obj/item/clothing/C = parent
	C.reset_armor_melee_value()
	C.reset_armor_bullet_value()
	C.reset_armor_laser_value()
	C.reset_armor_energy_value()
	C.reset_armor_bomb_value()
	C.reset_armor_bio_value()
	C.reset_armor_rad_value()
	C.reset_armor_internaldamage_value()

	RegisterSignal(equipped_mob, COMSIG_HUMAN_EQUIPPED_ITEM, PROC_REF(on_human_equipped_item))

/datum/component/armor_link/proc/on_unequipped(parent, unequipper)
	SIGNAL_HANDLER
	UnregisterSignal(equipped_mob, COMSIG_HUMAN_EQUIPPED_ITEM)
	equipped_mob = null
	if(linked)
		break_link()
	UnregisterSignal(parent, COMSIG_ITEM_DROPPED)
