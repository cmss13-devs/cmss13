/obj/item/device/agents/floppy_disk
	name = "suspicious floppy disk"
	desc = "a suspicious looking device, this can't be doing any good."
	icon_state = "floppy_disk"
	item_state = "floppy_disk"

	var/insert_time = 100

/obj/item/device/agents/floppy_disk/proc/insert_drive(var/mob/user, var/obj/structure/prop/almayer/computers/C)
	if(!istype(C) || !istype(user))
		return

	to_chat(user, SPAN_NOTICE("You start inserting the [name] into the [C.name]."))
	if(!do_after(user, insert_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		to_chat(user, SPAN_NOTICE("You stop inserting the [name] into the [C.name]."))
		return

	to_chat(user, SPAN_NOTICE("You finish inserting the [name] into the [C.name]."))

	user.drop_held_item(src)
	playsound(src, 'sound/mecha/mechmove01.ogg', 30, 1)

	C.hacked = TRUE
	C.update_icon()

	raiseEvent(GLOBAL_EVENT, EVENT_DISK_INSERTED + "\ref[src]")

	qdel(src)