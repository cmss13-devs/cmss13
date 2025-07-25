/datum/supply_packs/upp // Abstract type (null name)
	contains = null
	containertype = null
	containername = "large crate"
	group = "UPP"

/datum/supply_packs/upp/random_weapon
	name = "UPP Old supplies (Weapon)"
	cost = 5
	containertype = /obj/structure/closet/crate/weapon
	containername = "Old supplies crate (Weapon)"
	group = "UPP Additional supplies"

/datum/supply_packs/upp/random_weapon/get_contains()
	var/list/contains_to_return = list()
	switch(rand(1,4))
		if(1) // Mar 40 crate
			contains_to_return = list(
				/obj/item/weapon/gun/rifle/mar40,
				/obj/item/weapon/gun/rifle/mar40,
				/obj/item/weapon/gun/rifle/mar40,
				/obj/item/weapon/gun/rifle/mar40,
				/obj/item/weapon/gun/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
			)
		if(2) // Mar 40 carbine crate
			contains_to_return = list(
				/obj/item/weapon/gun/rifle/mar40/carbine,
				/obj/item/weapon/gun/rifle/mar40/carbine,
				/obj/item/weapon/gun/rifle/mar40/carbine,
				/obj/item/weapon/gun/rifle/mar40/carbine,
				/obj/item/weapon/gun/rifle/mar40/carbine,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
				/obj/item/ammo_magazine/rifle/mar40,
			)
		if(3) // boltaction crate
			contains_to_return = list(
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/weapon/gun/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
				/obj/item/ammo_magazine/rifle/boltaction,
			)
		if(4) // nailgun crate
			contains_to_return = list(
				/obj/item/weapon/gun/smg/nailgun,
				/obj/item/weapon/gun/smg/nailgun,
				/obj/item/weapon/gun/smg/nailgun,
				/obj/item/weapon/gun/smg/nailgun,
				/obj/item/weapon/gun/smg/nailgun,
				/obj/item/ammo_magazine/smg/nailgun,
				/obj/item/ammo_magazine/smg/nailgun,
				/obj/item/ammo_magazine/smg/nailgun,
				/obj/item/ammo_magazine/smg/nailgun,
				/obj/item/ammo_magazine/smg/nailgun,
			)
	return contains_to_return
