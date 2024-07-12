/obj/item/ammo_magazine/shotgun/light/breaching/sparkshots
	name = "box of sparkshot shells"
	desc = "A box filled with breaching sparkshot shotgun shells. 16 Gauge."
	icon = 'core_ru/icons/obj/items/weapons/guns/ammo_by_faction/uscm.dmi'
	icon_state = "sparkshots"
	item_state = "sparkshots"
	max_rounds = 24 //4 handfuls of 6 shells, 12 rounds in a XM52 mag
	transfer_handful_amount = 6
	default_ammo = /datum/ammo/bullet/shotgun/light/breaching/sparkshots
	handful_state = "sparkshot_shell"
	gun_type = /obj/item/weapon/gun/rifle/xm52
	caliber = "Sparkshots"

/obj/item/ammo_magazine/handful/shotgun/light/breaching/sparkshots
	name = "handful of sparkshot shells (16g)"
	icon = 'core_ru/icons/obj/items/weapons/guns/handful.dmi'
	icon_state = "sparkshot_shell_6"
	handful_state = "sparkshot_shell"
	max_rounds = 6 //XM52 magazines are 12 rounds total, two handfuls should be enough to reload a mag
	current_rounds = 6
	transfer_handful_amount = 6
	default_ammo = /datum/ammo/bullet/shotgun/light/breaching/sparkshots
	caliber = "Sparkshots"
	gun_type = /obj/item/weapon/gun/rifle/xm52
