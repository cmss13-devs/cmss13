/obj/item/ammo_magazine/hardpoint/ltb_cannon
	name = "LTB Cannon Magazine"
	desc = "A primary armament cannon magazine."
	caliber = "86mm" //Making this unique on purpose
	icon = 'icons/obj/items/weapons/guns/ammo_by_faction/USCM/vehicles.dmi'
	icon_state = "ltbcannon_4"
	w_class = SIZE_LARGE //Heavy fucker
	default_ammo = /datum/ammo/rocket/ltb
	max_rounds = 4
	gun_type = /obj/item/hardpoint/primary/cannon

/obj/item/ammo_magazine/hardpoint/ltb_cannon/update_icon()
	icon_state = "ltbcannon_[current_rounds]"

// Single-round alternative magazine, still istype()-matched against the hardpoint's cached ammo_type
/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell
	name = "86x455mm HE Shell"
	desc = "A single high-explosive 86x455mm shell for the LTB Cannon."
	icon_state = "lbtshell_1"
	max_rounds = 1

/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell/update_icon()
	icon_state = "lbtshell_[current_rounds]"
