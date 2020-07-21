//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/operating
	name = "Operating Computer"
	density = 1
	anchored = 1.0
	icon_state = "operating"
	circuit = "/obj/item/circuitboard/computer/operating"
	var/mob/living/carbon/human/victim = null
	var/obj/structure/machinery/optable/table = null
	processing = TRUE

/obj/structure/machinery/computer/operating/New()
	..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/structure/machinery/optable, get_step(src, dir))
		if (table)
			table.computer = src
			break

/obj/structure/machinery/computer/operating/attack_remote(mob/user)
	add_fingerprint(user)
	if(inoperable())
		return
	interact(user)


/obj/structure/machinery/computer/operating/attack_hand(mob/user)
	add_fingerprint(user)
	if(inoperable())
		return
	interact(user)


/obj/structure/machinery/computer/operating/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (inoperable()) )
		if (!isremotecontrolling(user))
			user.unset_interaction()
			close_browser(user, "op")
			return

	user.set_interaction(src)
	var/dat = "<HEAD><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A HREF='?src=\ref[user];mach_close=op'>Close</A><br><br>" //| <A HREF='?src=\ref[user];update=1'>Update</A>"
	if(src.table && src.table.buckled_mob)
		src.victim = src.table.buckled_mob
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>Name:</B> [src.victim.real_name]<BR>
<B>Age:</B> [src.victim.age]<BR>
<B>Blood Type:</B> [src.victim.b_type]<BR>
<BR>
<B>Health:</B> [src.victim.health]<BR>
<B>Brute Damage:</B> [src.victim.getBruteLoss()]<BR>
<B>Toxins Damage:</B> [src.victim.getToxLoss()]<BR>
<B>Fire Damage:</B> [src.victim.getFireLoss()]<BR>
<B>Suffocation Damage:</B> [src.victim.getOxyLoss()]<BR>
<B>Patient Status:</B> [src.victim.stat ? "Non-Responsive" : "Stable"]<BR>
<B>Heartbeat rate:</B> [victim.get_pulse(GETPULSE_TOOL)]<BR>
"}
	else
		src.victim = null
		dat += {"
<B>Patient Information:</B><BR>
<BR>
<B>No Patient Detected</B>
"}
	show_browser(user, dat, "Operating Computer", "op")


/obj/structure/machinery/computer/operating/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (isremotecontrolling(usr)))
		usr.set_interaction(src)
	return


/obj/structure/machinery/computer/operating/process()
	if(..())
		src.updateDialog()
