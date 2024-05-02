// -- Print disk computer

/obj/structure/machinery/computer/nuke_disk_generator
	name = "nuke disk generator"
	desc = "Used to generate the correct auth discs for the nuke."
	icon = 'fray-marines/icons/obj/structures/machinery/computer.dmi'
	icon_state = "nuke_red"

	density = TRUE
	unacidable = TRUE
	anchored = TRUE
	indestructible = TRUE

	var/generate_time = 2 MINUTES // time for the machine to generate the disc
	var/segment_time = 10 SECONDS // time to start the hack
	var/printing_time = 30 SECONDS // time to print a disk

	var/total_segments = 5 // total number of times the hack is required
	var/completed_segments = 0 // what segment we are on, (once this hits total, disk is printed)
	var/current_timer

	var/reprintable = FALSE // once the disk is printed, reprinting is enabled
	var/printing = FALSE // check if someone is printing already

	var/disk_type
	var/obj/item/disk/nuclear/disk
	var/crashcore = 0

	var/list/technobabble = list(
		"Booting up terminal-  -Terminal running",
		"Establishing link to offsite mainframe- Link established",
		"WARNING, DIRECTORY CORRUPTED, running search algorithms- nuke_fission_timing.exe found",
		"Invalid credentials, upgrading permissions through CM military override- Permissions upgraded, nuke_fission_timing.exe available",
		"Downloading nuke_fission_timing.exe to removable storage- nuke_fission_timing.exe downloaded to floppy disk, have a nice day"
	)

/obj/structure/machinery/computer/nuke_disk_generator/Initialize()
	. = ..()

	update_minimap_icon()

	if(!disk_type)
		WARNING("disk_type is required to be set before init")
		return INITIALIZE_HINT_QDEL
	GLOB.nuke_disk_generators += src
	addtimer(CALLBACK(src, PROC_REF(check_mode)), 300 SECONDS)

/obj/structure/machinery/computer/nuke_disk_generator/proc/update_minimap_icon()
	if(!is_ground_level(z))
		return

	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, MINIMAP_FLAG_ALL, "border", 'icons/ui_icons/map_blips.dmi')

/obj/structure/machinery/computer/nuke_disk_generator/ex_act(severity)
	return

/obj/structure/machinery/computer/nuke_disk_generator/proc/check_mode()
	if(!check_crash())
		qdel(src)

/obj/structure/machinery/computer/nuke_disk_generator/Destroy()
	GLOB.nuke_disk_generators -= src
	. = ..()

/obj/structure/machinery/computer/nuke_disk_generator/process()
	. = ..()
	if(. || !current_timer)
		return

	deltimer(current_timer)
	current_timer = null
	visible_message("<b>[src]</b> shuts down as it loses power. Any running programs will now exit")
	return PROCESS_KILL


/obj/structure/machinery/computer/nuke_disk_generator/attackby(mob/user as mob)
	interact(user)

/obj/structure/machinery/computer/nuke_disk_generator/attack_hand(mob/user as mob)
	..()

	interact(user)

/obj/structure/machinery/computer/nuke_disk_generator/attack_remote(mob/user as mob)
	interact(user)

/obj/structure/machinery/computer/nuke_disk_generator/interact(mob/user)
	. = ..()
	var/dat = ""
	dat += "<div align='center'><a href='?src=[REF(src)];generate=1'>Запустить программу</a></div>"
	dat += "<br/>"
	dat += "<hr/>"
	dat += "<div align='center'><h2>Статус</h2></div>"

	var/message = "Ошибка"
	if(completed_segments >= total_segments)
		message = "Диск сгенерирован. Запустите программу для печати."
	else if(current_timer)
		message = "Программа запущена"
	else if(completed_segments == 0)
		message = "Ожидание"
	else if(completed_segments < total_segments)
		message = "Требуется перезапуск. Пожалуйста перезапустите программу"
	else
		message = "Неизвестно"

	var/progress = round((completed_segments / total_segments) * 100)

	dat += "<br/><span><b>Прогресс</b>: [progress]%</span>"
	dat += "<br/><span><b>Оставшееся время</b>: [current_timer ? round(timeleft(current_timer) * 0.1, 2) : 0.0]</span>"
	dat += "<br/><span><b>Сообщение</b>: [message]</span>"

	var/flair = ""
	for(var/i in 1 to completed_segments)
		flair += "[technobabble[i]]<br />"

	dat += "<br /><br /><span style='font-family: monospace, monospace;'>[flair]</span>"

	var/datum/browser/popup = new(user, "computer", "<div align='center'>Nuke Disk Generator</div>")
	popup.set_content(dat)
	popup.open()

/obj/structure/machinery/computer/nuke_disk_generator/Topic(href, href_list)
	. = ..()
	if(.)
		return

	if(href_list["generate"])
		if(printing || current_timer)
			to_chat(usr, "<span class='warning'>A program is already running.</span>")
			return
		if(reprintable)
			printing = TRUE
			addtimer(VARSET_CALLBACK(src, printing, FALSE), printing_time)

			usr.visible_message("[usr] started a program to regenerate a nuclear disk code.", "You started a program to generate a nuclear disk code.")
			if(!do_after(usr, printing_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, CALLBACK(src, TYPE_PROC_REF(/datum, process))))
				return

			print_disc()
			return

		printing = TRUE
		addtimer(VARSET_CALLBACK(src, printing, FALSE), segment_time)

		usr.visible_message("[usr] started a program to generate a nuclear disk code.", "You started a program to generate a nuclear disk code.")
		if(!do_after(usr, segment_time, INTERRUPT_ALL, BUSY_ICON_HOSTILE, CALLBACK(src, TYPE_PROC_REF(/datum, process))))
			return

		current_timer = addtimer(CALLBACK(src, PROC_REF(complete_segment)), generate_time, TIMER_STOPPABLE)

	updateUsrDialog()


/obj/structure/machinery/computer/nuke_disk_generator/proc/complete_segment()
	playsound(src, 'sound/machines/ping.ogg', 25, 1)
	current_timer = null
	completed_segments = min(completed_segments + 1, total_segments)

	if(completed_segments == total_segments)
		reprintable = TRUE
		visible_message("<span class='notice'>[src] beeps as it ready to print.</span>")
		return

	visible_message("<span class='notice'>[src] beeps as it program requires attention.</span>")


/obj/structure/machinery/computer/nuke_disk_generator/proc/print_disc()
	disk = new disk_type(loc)
	visible_message("<span class='notice'>[src] beeps as it finishes printing the disc.</span>")
	reprintable = TRUE

/obj/structure/machinery/computer/nuke_disk_generator/red
	name = "red nuke disk generator"
	disk_type = /obj/item/disk/nuclear/red

/obj/structure/machinery/computer/nuke_disk_generator/green
	name = "green nuke disk generator"
	icon_state = "nuke_green"
	disk_type = /obj/item/disk/nuclear/green

/obj/structure/machinery/computer/nuke_disk_generator/blue
	name = "blue nuke disk generator"
	icon_state = "nuke_blue"
	disk_type = /obj/item/disk/nuclear/blue

/obj/item/disk/nuclear/red
	name = "red nuclear authentication disk"
	icon_state = "disk_8"

/obj/item/disk/nuclear/green
	name = "green nuclear authentication disk"
	icon_state = "disk_6"

/obj/item/disk/nuclear/blue
	name = "blue nuclear authentication disk"
	icon_state = "disk_13"
