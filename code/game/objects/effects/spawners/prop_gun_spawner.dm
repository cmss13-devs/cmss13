/obj/effect/spawner/prop_gun //Makes a prop that looks similar to the original gun, for use such as broken guns
	name = "prop gun spawner"
	icon = 'icons/landmarks.dmi'
	icon_state = "prop_gun"
	///The typepath of the gun the prop will copy
	var/obj/item/weapon/gun/prop_gun_type = /obj/item/weapon/gun
	///if the prop will have a custom name
	var/custom_gun_name
	///if the prob will have a custom desc
	var/custom_gun_desc
	///The probability of the prop gun spawning
	var/spawn_prob = 100

/obj/effect/spawner/prop_gun/Initialize(mapload, ...)
	. = ..()
	if(!ispath(prop_gun_type, /obj/item/weapon/gun))
		stack_trace("[src] using incorrect typepath, \"[prop_gun_type]\".") //Can't make a prop gun of something not a gun
		qdel(src)
		return
	if(!prob(spawn_prob))
		qdel(src)
		return
	if(!mapload)
		prepare_gun_skin()
		return
	return INITIALIZE_HINT_ROUNDSTART

/obj/effect/spawner/prop_gun/LateInitialize()
	prepare_gun_skin()

///Spawns the items and modifies source to set skin on prop
/obj/effect/spawner/prop_gun/proc/prepare_gun_skin()
	///The source, which the skin will be copied from
	var/obj/item/weapon/gun/source_gun = new prop_gun_type(src)
	if(custom_gun_name)
		source_gun.name = custom_gun_name
	if(custom_gun_desc)
		source_gun.desc = custom_gun_desc
	source_gun.pixel_x = pixel_x
	source_gun.pixel_y = pixel_y
	source_gun.layer = layer

	///The prop itself, which the skin will be copied to
	var/obj/item/prop/prop_gun/prop_gun = new /obj/item/prop/prop_gun(loc)
	prop_gun.set_gun_skin(source_gun)
	qdel(src)

/obj/item/prop/prop_gun
	name = "prop gun"
	desc = "A non-functional gun prop. You should not be able to see this."
	icon = 'icons/landmarks.dmi'
	icon_state = "prop_gun"
	flags_item = TWOHANDED
	pickup_sound = "gunequip"
	drop_sound = "gunrustle"
	pickupvol = 7
	dropvol = 15

///Makes the gun look similar to the source, using the source as an atom reference
/obj/item/prop/prop_gun/proc/set_gun_skin(obj/item/weapon/gun/source_gun)
	if(!source_gun)
		return
	name = source_gun.name
	desc = source_gun.desc
	icon = source_gun.icon
	item_icons = source_gun.item_icons
	icon_state = source_gun.icon_state
	item_state = source_gun.item_state
	w_class = source_gun.w_class
	flags_equip_slot = source_gun.flags_equip_slot
	pixel_x = source_gun.pixel_x
	pixel_y = source_gun.pixel_y
	layer = source_gun.layer
	overlays = source_gun.overlays

/obj/item/prop/prop_gun/attack_self(mob/user) //Mimic wielding of real guns
	. = ..()
	if(!(flags_item & TWOHANDED))
		return
	if(flags_item & WIELDED)
		unwield(user)
	else
		wield(user)

/obj/item/prop/prop_gun/dropped(mob/user)
	..()
	unwield(user)

/obj/effect/spawner/prop_gun/m41aMK1
	prop_gun_type = /obj/item/weapon/gun/rifle/m41aMK1
	custom_gun_name = "\improper Broken M41A pulse rifle"
	custom_gun_desc = "An older design of the Pulse Rifle commonly used by Colonial Marines. This one has seen better days. The trigger is missing, the barrel is bent, and it no longer appropriately feeds magazines."
