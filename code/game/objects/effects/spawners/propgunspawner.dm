/obj/effect/spawner/prop_gun //Makes a prop that looks similar to the original gun, for use such as broken guns
	name = "prop gun spawner"
	icon = 'icons/landmarks.dmi'
	icon_state = "prop_gun"
	var/obj/item/weapon/gun/prop_gun_type = /obj/item/weapon/gun
	var/custom_prop_name
	var/custom_prop_desc

/obj/effect/spawner/prop_gun/New(loc, ...)
	. = ..()
	if(!ispath(prop_gun_type, /obj/item/weapon/gun))
		stack_trace("[src] using incorrect typepath, \"[prop_gun_type]\".")
		qdel(src)
		return
	var/obj/item/weapon/gun/prop_gun = new /obj/item/prop/prop_gun(loc)
	var/obj/item/weapon/gun/source_gun = new prop_gun_type(src)
	if(custom_prop_name)
		prop_gun.name = custom_prop_name
	else
		prop_gun.name = source_gun.name
	if(custom_prop_desc)
		prop_gun.desc = custom_prop_desc
	else
		prop_gun.desc = source_gun.desc
	prop_gun.icon = source_gun.icon
	prop_gun.icon_state = source_gun.icon_state
	prop_gun.item_state = source_gun.item_state
	prop_gun.w_class = source_gun.w_class
	qdel(src)

/obj/item/prop/prop_gun
	name = "prop gun"
	desc = "A non-functional gun prop. You should not be able to see this."
	icon = 'icons/landmarks.dmi'
	icon_state = "prop_gun"
