/obj/item/disk/botany
	name = "flora data disk"
	desc = "A small disk used for carrying data on plant genetics."
	icon = 'icons/obj/items/disk.dmi'
	icon_state = "botanydisk"
	item_state = "botanydisk"
	w_class = SIZE_TINY
	ground_offset_x = 5
	ground_offset_y = 5

	var/list/genes = list()
	var/genesource = "unknown"


/obj/item/disk/botany/attack_self(mob/user)
	..()

	if(!length(genes))
		return

	var/choice = alert(user, "Are you sure you want to wipe the disk?", "Xenobotany Data", "No", "Yes")
	if(src && user && genes && choice == "Yes")
		to_chat(user, "You wipe the disk data.")
		name = initial(name)
		desc = initial(name)
		genes = list()
		genesource = "unknown"

/obj/item/storage/box/botanydisk
	name = "flora disk box"
	desc = "A box of flora data disks, apparently."

/obj/item/storage/box/botanydisk/Initialize()
	. = ..()
	for(var/i = 0;i<14;i++)
		new /obj/item/disk/botany(src)
