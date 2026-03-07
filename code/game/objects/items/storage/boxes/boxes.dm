/* WELCOME TO BOXES.DM
This is the parent file, which contains verbatim and
any other boxes that do not fit a certain category,
or simply do not have much to justify creating a file for it

Rest of the boxes are located around the cm_marines/equipment folder
or scattered elsewhere within the modules
Probably best to include it in this directory but atomization be damned
- Nihi
*/

// THE PARENT //
/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	icon = 'icons/obj/items/storage/boxes.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/storage_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/storage_righthand.dmi',
	)
	item_state = "box"
	foldable = TRUE
	storage_slots = null
	max_w_class = SIZE_LARGE
	w_class = SIZE_MEDIUM
	storage_flags = STORAGE_FLAGS_BOX
	preset_hold_only = TRUE

// END OF PARENT //

/obj/item/storage/box/survival
	name = "box of survival gear"
	desc = "An ordinary box, but you feel like you can store stuff in this without too much restrictions."
	preset_hold_only = FALSE // amuse me with this

/obj/item/storage/box/survival/fill_preset_inventory()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/tank/emergency_oxygen( src )

// wycaps is only here to show you how to fill the preset inventory of a box using a for loop,
// rather than pasting the line over and over again, for maximum readability
// while storage_slots is used here, it can be used just fine on non-storage_slot boxes

/obj/item/storage/box/wycaps
	name = "box of Company baseball caps"
	desc = "This box contains seven Weyland Yutani brand baseball caps. Give them away at your leisure."
	icon_state = "mre1"
	storage_slots = STORAGE_SLOTS_DEFAULT // 7 should be the default for most boxes, its what fits the UI in a singular row without making a column

/obj/item/storage/box/wycaps/fill_preset_inventory()
	for(var/i in 1 to storage_slots) //alternatively, if there are no storage slots, substitute it with 7 instead via its define: STORAGE_SLOTS_DEFAULT, or 14 with STORAGE_SPACE_MAX for tiny items
		new /obj/item/clothing/head/cmcap/wy_cap(src)

// the above method to fill a preset inventory is 100 times better
// than having to reiterate the same line over and over again
// so please, do that
// - nihi




//some legacy shit from apop, kept for records

/* Everything derived from the common cardboard box.
 * Basically everything except the original is a kit (starts full).
 *
 * Contains:
 * Empty box, starter boxes (survival/engineer),
 * Latex glove and sterile mask boxes,
 * Syringe, beaker, dna injector boxes,
 * Blanks, flashbangs, and EMP grenade boxes,
 * Tracking and chemical implant boxes,
 * Prescription glasses and drinking glass boxes,
 * Condiment bottle and silly cup boxes,
 * Donkpocket and monkeycube boxes,
 * ID and security PDA cart boxes,
 * Handcuff, mousetrap, and pillbottle boxes,
 * Snap-pops and matchboxes,
 * Replacement light boxes.
 *
 * For syndicate call-ins see uplink_kits.dm
 *
 *  EDITED BY APOPHIS 09OCT2015 to prevent in-game abuse of boxes.
 */
