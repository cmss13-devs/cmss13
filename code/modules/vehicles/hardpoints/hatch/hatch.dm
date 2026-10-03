/obj/item/hardpoint/hatch
	name = "\improper hatch"
	desc = "Controls access in and out of the vehicle."

	slot = HDPT_HATCH
	hdpt_layer = HDPT_LAYER_SUPPORT

	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "hatch-0"

	health = 400

/obj/item/hardpoint/hatch/armored
	name = "\improper armored hatch"
	desc = "A reinforced hatch fitted to an armored vehicle."

	health = 550
	damage_multiplier = 0.6

/obj/item/hardpoint/hatch/armored/uscm
	name = "\improper M39 hatch"
	desc = "The armored rear hatch of a USCM ground vehicle. Standard issue across the fleet."

/obj/item/hardpoint/hatch/update_icon()
	icon = 'icons/obj/vehicles/hardpoints/shared.dmi'
	icon_state = "hatch-[get_shared_damage_suffix()]"

/obj/item/hardpoint/hatch/on_uninstall(obj/vehicle/multitile/vehicle)
	update_icon()
	. = ..()
