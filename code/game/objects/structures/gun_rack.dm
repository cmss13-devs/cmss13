/obj/structure/gun_rack
	name = "gun rack"
	desc = "ARMAT-produced gun rack for storage of long guns. While initial model was supposed to be extremely modifiable, USCM comissioned racks with fixed slots which only fit M41A rifles. Some say they were cheaper, and some say the main reason was marine's ability to easily break anything more complex than a tungsten ball."
	icon = 'icons/obj/structures/gun_racks.dmi'
	icon_state = "m41a"
	density = TRUE
	var/allowed_type
	var/populate_type
	var/max_stored = 5
	var/initial_stored = 5

/obj/structure/gun_rack/Initialize()
	. = ..()
	if(!allowed_type)
		icon_state = "m41a_0"
		return

	var/new_icon_state
	switch(SSmapping.configs[GROUND_MAP].camouflage_type)
		if("classic")
			icon_state = new_icon_state ? new_icon_state : "c_" + icon_state
		if("desert")
			icon_state = new_icon_state ? new_icon_state : "d_" + icon_state
		if("snow")
			icon_state = new_icon_state ? new_icon_state : "s_" + icon_state
		if("urban")
			icon_state = new_icon_state ? new_icon_state : "u_" + icon_state

	if(initial_stored)
		var/i = 0
		while(i < initial_stored)
			contents += new populate_type(src)
			i++
	update_icon()

/obj/structure/gun_rack/attackby(obj/item/O, mob/user)
	if(istype(O, allowed_type) && contents.len < max_stored)
		user.drop_inv_item_to_loc(O, src)
		contents += O
		update_icon()

/obj/structure/gun_rack/attack_hand(mob/living/user)
	if(!contents.len)
		to_chat(user, SPAN_WARNING("[src] is empty."))
		return

	var/obj/stored_obj = contents[contents.len]
	contents -= stored_obj
	user.put_in_hands(stored_obj)
	to_chat(user, SPAN_NOTICE("You grab [stored_obj] from [src]."))
	playsound(src, "gunequip", 25, TRUE)
	update_icon()

/obj/structure/gun_rack/update_icon()
	if(contents.len)
		icon_state = "[initial(icon_state)]_[contents.len]"
	else
		icon_state = "[initial(icon_state)]_0"

/obj/structure/gun_rack/m41a
	name = "M41A MK1 pulse rifle rack"
	allowed_type = /obj/item/weapon/gun/rifle/m41aMK1
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1

/obj/structure/gun_rack/m41a/unloaded
	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/unloaded

/obj/structure/gun_rack/m41a/empty
	initial_stored = 0

/obj/structure/gun_rack/m41a2
	name = "M41A MK2 pulse rifle rack"
	allowed_type = /obj/item/weapon/gun/rifle/m41a
	populate_type = /obj/item/weapon/gun/rifle/m41a

/obj/structure/gun_rack/m41a2/unloaded
	populate_type = /obj/item/weapon/gun/rifle/m41a/unloaded

/obj/structure/gun_rack/m41a2/empty
	initial_stored = 0

/obj/structure/gun_rack/m39
	name = "M39 sub-machinegun rack"
	icon_state = "m39"
	desc = ""
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/smg/m39
	populate_type = /obj/item/weapon/gun/smg/m39

/obj/structure/gun_rack/m39/unloaded
	populate_type = /obj/item/weapon/gun/smg/m39/unloaded

/obj/structure/gun_rack/m37
	name = "M37 pump-action shotgun rack"
	icon_state = "m37"
	desc = ""
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/shotgun/pump
	populate_type = /obj/item/weapon/gun/shotgun/pump

/obj/structure/gun_rack/m37/unloaded
	populate_type = /obj/item/weapon/gun/shotgun/pump/unloaded

/obj/structure/gun_rack/m37a
	name = "M37A2 pump-action shotgun rack"
	icon_state = "m37a"
	desc = ""
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/shotgun/pump/m37a
	populate_type = /obj/item/weapon/gun/shotgun/pump/m37a

/obj/structure/gun_rack/m37a/unloaded
	populate_type = /obj/item/weapon/gun/shotgun/pump/m37a/unloaded

/obj/structure/gun_rack/m4ra
	name = "M4RA battle rifle Rack"
	icon_state = "m4ra"
	desc = ""
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/m4ra
	populate_type = /obj/item/weapon/gun/rifle/m4ra

/obj/structure/gun_rack/m4ra/unloaded
	populate_type = /obj/item/weapon/gun/rifle/m4ra/unloaded

/obj/structure/gun_rack/l42
	name = "L42A Mark 1 battle rifle Rack"
	icon_state = "l42"
	desc = ""
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/l42a
	populate_type = /obj/item/weapon/gun/rifle/l42a

/obj/structure/gun_rack/m4ra/unloaded
	populate_type = /obj/item/weapon/gun/rifle/l42a/unloaded

/obj/structure/gun_rack/type71/empty
	initial_stored = 0

/obj/structure/gun_rack/type71
	icon_state = "type71"
	desc = "Some off-branded gun rack. Per SOF and UPPA regulations, weapons should be stored in secure safes and only given out when necessary. Of course, most (but not all!) units overlook this regulation, only storing their firearms in safes when inspection arrives."
	max_stored = 6
	initial_stored = 6
	allowed_type = /obj/item/weapon/gun/rifle/type71
	populate_type = /obj/item/weapon/gun/rifle/type71

/obj/structure/gun_rack/type71/unloaded
	populate_type = /obj/item/weapon/gun/rifle/type71/unloaded

/obj/structure/gun_rack/type71/empty
	initial_stored = 0

/obj/structure/gun_rack/apc
	name = "APC ammo compartment"
	icon_state = "frontal"
	desc = "Uhoh. You shouldn't be seeing this."

/obj/structure/gun_rack/apc/frontal
	name = "frontal cannon ammo storage compartment"
	icon_state = "frontal"
	desc = "A small compartment that stores ammunition for the APC's 'Bleihagel RE-RE700 Frontal Cannon'."
	max_stored = 2
	initial_stored = 0
	allowed_type = /obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon

/obj/structure/gun_rack/apc/boyars
	name = "dual cannon ammo storage compartment"
	icon_state = "boyars"
	desc = "A small compartment that stores ammunition for the APC's 'PARS-159 Boyars Dualcannon'."
	max_stored = 2
	initial_stored = 0
	allowed_type = /obj/item/ammo_magazine/hardpoint/boyars_dualcannon

// /obj/structure/gun_rack/apc/frontal/aa
//	name = "vertical-launch-system ammo storage compartment"
//	icon_state = "boyars"
//	desc = "A small compartment that stores ammunition for the vehicle's VLS-array."
//	max_stored = 2
//	initial_stored = 0
//	allowed_type = /obj/item/ammo_magazine/hardpoint/towlauncher/aa

// /obj/structure/gun_rack/apc/boyars/aa
//	name = "anti-air cannon ammo storage compartment"
//	icon_state = "frontal"
//	desc = "A small compartment that stores ammunition for the vehicle's 'Bleihagel RE-RE965 Aerial-Defence System'."
//	max_stored = 2
//	initial_stored = 0
//	allowed_type = /obj/item/ammo_magazine/hardpoint/m56_cupola/quad_cannon

// /obj/structure/gun_rack/m41/recon
//	icon_state = "m41arecon"
//	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/forecon

// /obj/structure/gun_rack/m41/recon/unloaded
//	populate_type = /obj/item/weapon/gun/rifle/m41aMK1/forecon/unloaded

/obj/structure/gun_rack/flamer
	name = "M240A1 incinerator rack"
	icon_state = "m240"
	desc = "ARMAT-produced gun rack for storage of long guns. While initial model was supposed to be extremely modifiable, USCM comissioned racks with fixed slots which only fit M240A1 incinerators. Some say they were cheaper, and some say the main reason was marine's ability to easily break anything more complex than a tungsten ball."
	max_stored = 2
	initial_stored = 2
	allowed_type = /obj/item/weapon/gun/flamer/m240
	populate_type = /obj/item/weapon/gun/flamer/m240

/obj/structure/gun_rack/flamer/unloaded
	populate_type = /obj/item/weapon/gun/flamer/m240/unloaded

/obj/structure/gun_rack/flamer/empty
	initial_stored = 0

// /obj/structure/gun_rack/uppflamer This flamer doesn't appear to exist in PVP CM-SS13 (At least not yet)
//	name = "LPO80 incinerator rack"
//	icon_state = "lpo80"
//	desc = "A rack designed to hold two LPO80 incinerator units."
//	max_stored = 2
//	initial_stored = 2
//	allowed_type = /obj/item/weapon/gun/flamer/upp
//	populate_type = /obj/item/weapon/gun/flamer/upp

// /obj/structure/gun_rack/uppflamer/unloaded
//	populate_type = /obj/item/weapon/gun/flamer/upp/unloaded

// /obj/structure/gun_rack/flamer/empty
//	initial_stored = 0

/obj/structure/gun_rack/mk221
	name = "MK211 semi-automatic shotgun rack"
	icon_state = "mk221"
	desc = "ARMAT-produced gun rack for storage of long guns. While initial model was supposed to be extremely modifiable, USCM comissioned racks with fixed slots which only fit MK221 tactical shotguns. Some say they were cheaper, and some say the main reason was marine's ability to easily break anything more complex than a tungsten ball."
	max_stored = 2
	initial_stored = 2
	allowed_type = /obj/item/weapon/gun/shotgun/combat
	populate_type = /obj/item/weapon/gun/shotgun/combat

/obj/structure/gun_rack/mk221/empty
	initial_stored = 0

/obj/structure/gun_rack/mk221/unloaded
	initial_stored = 2
	populate_type = /obj/item/weapon/gun/shotgun/combat/unloaded

// /obj/structure/gun_rack/m20a  This rifle doesn't appear to exist in PVP CM-SS13 (At least not yet)
//	name = "M20A pulse rifle rack"
//	icon_state = "m20a"
//	max_stored = 5
//	initial_stored = 5
//	allowed_type = /obj/item/weapon/gun/rifle/m20a
//	populate_type = /obj/item/weapon/gun/rifle/m20a

// /obj/structure/gun_rack/m20a/empty
//	initial_stored = 0

// /obj/structure/gun_rack/m20a/unloaded
//	initial_stored = 5
//	populate_type = /obj/item/weapon/gun/rifle/m20a/unloaded

/obj/structure/gun_rack/m41/elite
	name = "M41A/2 pulse rifle rack"
	icon_state = "m41a_elite"
	max_stored = 5
	initial_stored = 5
	allowed_type = /obj/item/weapon/gun/rifle/m41a/elite
	populate_type = /obj/item/weapon/gun/rifle/m41a/elite

/obj/structure/gun_rack/m41/elite/empty
	initial_stored = 0

/obj/structure/gun_rack/m41/elite/unloaded
	initial_stored = 5
	populate_type = /obj/item/weapon/gun/rifle/m41a/elite/unloaded

// /obj/structure/gun_rack/ag80 This rifle doesn't appear to exist in PVP CM-SS13 (At least not yet)
//	icon_state = "ag80"
//	desc = "Some off-branded gun rack. Per SOF and UPPA regulations, weapons should be stored in secure safes and only given out when necessary. Of course, most (but not all!) units overlook this regulation, only storing their firearms in safes when inspection arrives."
//	max_stored = 5
//	initial_stored = 5
//	allowed_type = /obj/item/weapon/gun/rifle/ag80
//	populate_type = /obj/item/weapon/gun/rifle/ag80

// /obj/structure/gun_rack/ag80/unloaded
//	populate_type = /obj/item/weapon/gun/rifle/ag80/unloaded

// /obj/structure/gun_rack/ag80/empty
//	initial_stored = 0

// /obj/structure/gun_rack/nsg
//	name = "NSG L23A1 pulse rifle rack"
//	icon_state = "nsg"
//	desc = "ARMAT-produced gun rack for storage of long guns. This one is configured to hold up to five L23A1 pulse rifles."
//	max_stored = 5
//	initial_stored = 5
//	allowed_type = /obj/item/weapon/gun/rifle/nsg23/rmc
//	populate_type = /obj/item/weapon/gun/rifle/nsg23/rmc

// /obj/structure/gun_rack/nsg/unloaded
//	populate_type = /obj/item/weapon/gun/rifle/nsg23/rmc/unloaded

/obj/structure/gun_rack/nsg/Empty
	initial_stored = 0
