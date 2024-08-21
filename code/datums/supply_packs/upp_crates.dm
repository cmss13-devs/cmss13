/datum/supply_packs/upp //base
	name = "UPP crate"
	contains = null
	containertype = null
	containername = "large crate"
	group = "UPP"

/datum/supply_packs/upp/random_weapon
	name = "Old supplies (Weapon)"
	contains = list(
	)
	cost = 5
	containertype = /obj/structure/closet/crate/weapon/upp_random_weapon
	containername = "Old supplies crate (Weapon)"
	group = "UPP Additional supplies"

/obj/structure/closet/crate/weapon/upp_random_weapon/Initialize()
	. = ..()
	switch(rand(1,4))
		if(1) // Mar 40 crate
			new /obj/item/weapon/gun/rifle/mar40(src)
			new /obj/item/weapon/gun/rifle/mar40(src)
			new /obj/item/weapon/gun/rifle/mar40(src)
			new /obj/item/weapon/gun/rifle/mar40(src)
			new /obj/item/weapon/gun/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
		if(2) // Mar 40 carbine crate
			new /obj/item/weapon/gun/rifle/mar40/carbine(src)
			new /obj/item/weapon/gun/rifle/mar40/carbine(src)
			new /obj/item/weapon/gun/rifle/mar40/carbine(src)
			new /obj/item/weapon/gun/rifle/mar40/carbine(src)
			new /obj/item/weapon/gun/rifle/mar40/carbine(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
			new /obj/item/ammo_magazine/rifle/mar40(src)
		if(3) // boltaction crate
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/weapon/gun/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
			new /obj/item/ammo_magazine/rifle/boltaction(src)
		if(4) // nailgun crate
			new /obj/item/weapon/gun/smg/nailgun(src)
			new /obj/item/weapon/gun/smg/nailgun(src)
			new /obj/item/weapon/gun/smg/nailgun(src)
			new /obj/item/weapon/gun/smg/nailgun(src)
			new /obj/item/weapon/gun/smg/nailgun(src)
			new /obj/item/ammo_magazine/smg/nailgun(src)
			new /obj/item/ammo_magazine/smg/nailgun(src)
			new /obj/item/ammo_magazine/smg/nailgun(src)
			new /obj/item/ammo_magazine/smg/nailgun(src)
			new /obj/item/ammo_magazine/smg/nailgun(src)
