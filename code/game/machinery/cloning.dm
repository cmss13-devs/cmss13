//The return of data disks?? Just for transferring between genetics machine/cloning machine.
//TO-DO: Make the genetics machine accept them.
/obj/item/disk/data
	name = "Cloning Data Disk"
	icon_state = "datadisk0" //Gosh I hope syndies don't mistake them for the nuke disk.
	item_state = "card-id"
	w_class = SIZE_TINY
	var/read_only = 0 //Well,it's still a floppy disk


//Disk stuff.
/obj/item/disk/data/Initialize()
	. = ..()
	var/diskcolor = pick(0,1,2)
	src.icon_state = "datadisk[diskcolor]"

/obj/item/disk/data/attack_self(mob/user as mob)
	..()
	src.read_only = !src.read_only
	to_chat(user, "You flip the write-protect tab to [src.read_only ? "protected" : "unprotected"].")

/obj/item/disk/data/get_examine_text(mob/user)
	. = ..()
	. += "The write-protect tab is set to [read_only ? "protected" : "unprotected"]."

//Health Tracker Implant

/obj/item/implant/health
	name = "health implant"
	var/healthstring = ""

/obj/item/implant/health/proc/sensehealth()
	if (!src.implanted)
		return "ERROR"
	else
		if(isliving(src.implanted))
			var/mob/living/L = src.implanted
			src.healthstring = "[floor(L.getOxyLoss())] - [floor(L.getFireLoss())] - [floor(L.getToxLoss())] - [floor(L.getBruteLoss())]"
		if (!src.healthstring)
			src.healthstring = "ERROR"
		return src.healthstring

/*
 * Diskette Box
 */


/obj/item/storage/box/disks
	name = "Diskette Box"
	icon_state = "disk_kit"

/obj/item/storage/box/disks/Initialize()
	. = ..()
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)
	new /obj/item/disk/data(src)


