// It is a gizmo that flashes a small area

/obj/structure/machinery/flasher
	name = "Mounted flash"
	desc = "A wall-mounted flashbulb device."
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "mflash1"
	var/id = null
	var/range = 2 //this is roughly the size of brig cell
	var/disable = 0
	var/last_flash = 0 //Don't want it getting spammed like regular flashes
	var/strength = 10 //How knocked down targets are when flashed.
	var/base_state = "mflash"
	anchored = 1

/obj/structure/machinery/flasher/portable //Portable version of the flasher. Only flashes when anchored
	name = "portable flasher"
	desc = "A portable flashing device. Wrench to activate and deactivate. Cannot detect slow movements."
	icon_state = "pflash1"
	strength = 8
	anchored = 0
	base_state = "pflash"
	density = 1

/obj/structure/machinery/flasher/power_change()
	..()
	if ( !(stat & NOPOWER) )
		icon_state = "[base_state]1"
//		src.sd_SetLuminosity(2)
	else
		icon_state = "[base_state]1-p"
//		src.sd_SetLuminosity(0)

//Don't want to render prison breaks impossible
/obj/structure/machinery/flasher/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/tool/wirecutters))
		add_fingerprint(user)
		src.disable = !src.disable
		if (src.disable)
			user.visible_message(SPAN_DANGER("[user] has disconnected the [src]'s flashbulb!"), SPAN_DANGER("You disconnect the [src]'s flashbulb!"))
		if (!src.disable)
			user.visible_message(SPAN_DANGER("[user] has connected the [src]'s flashbulb!"), SPAN_DANGER("You connect the [src]'s flashbulb!"))

//Let the AI trigger them directly.
/obj/structure/machinery/flasher/attack_remote()
	if (src.anchored)
		return src.flash()
	else
		return

/obj/structure/machinery/flasher/proc/flash()
	if (!(powered()))
		return

	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	playsound(src.loc, 'sound/weapons/flash.ogg', 25, 1)
	flick("[base_state]_flash", src)
	src.last_flash = world.time
	use_power(1500)

	for (var/mob/O in viewers(src, null))
		if (get_dist(src, O) > src.range)
			continue

		if (istype(O, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O
			if(H.get_eye_protection() > 0)
				continue

		if (istype(O, /mob/living/carbon/Xenomorph))//So aliens don't get flashed (they have no external eyes)/N
			continue

		O.KnockDown(strength)
		if (istype(O, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O
			var/datum/internal_organ/eyes/E = H.internal_organs_by_name["eyes"]
			if (E && (E.damage > E.min_bruised_damage && prob(E.damage + 50)))
				H.flash_eyes()
				E.damage += rand(1, 5)
		else
			O.flash_eyes()


/obj/structure/machinery/flasher/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	if(prob(75/severity))
		flash()
	..(severity)

/obj/structure/machinery/flasher/portable/HasProximity(atom/movable/AM as mob|obj)
	if ((src.disable) || (src.last_flash && world.time < src.last_flash + 150))
		return

	if(istype(AM, /mob/living/carbon))
		if (src.anchored)
			src.flash()

/obj/structure/machinery/flasher/portable/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/tool/wrench))
		add_fingerprint(user)
		src.anchored = !src.anchored

		if (!src.anchored)
			user.show_message(text(SPAN_DANGER("[src] can now be moved.")))
			src.overlays.Cut()

		else if (src.anchored)
			user.show_message(text(SPAN_DANGER("[src] is now secured.")))
			src.overlays += "[base_state]-s"

/obj/structure/machinery/flasher_button/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/flasher_button/attackby(obj/item/W, mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/flasher_button/attack_hand(mob/user as mob)

	if(inoperable())
		return
	if(active)
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access Denied."))
		return

	use_power(5)

	active = 1
	icon_state = "launcheract"

	for(var/obj/structure/machinery/flasher/M in machines)
		if(M.id == src.id)
			INVOKE_ASYNC(M, /obj/structure/machinery/flasher.proc/flash)

	sleep(50)

	icon_state = "launcherbtt"
	active = 0

	msg_admin_attack("[key_name(user)] used the [src.name] to flash everyone in [get_area(src)] ([src.loc.x],[src.loc.y],[src.loc.z]).", src.loc.x, src.loc.y, src.loc.z)

	return
