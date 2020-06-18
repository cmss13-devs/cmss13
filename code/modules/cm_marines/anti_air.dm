var/obj/structure/anti_air_cannon/almayer_aa_cannon

/obj/structure/anti_air_cannon
	name = "\improper IX-50 MGAD Cannon"
	desc = "The IX-50 is a state-of-the-art Micro-Gravity and Air Defense system capable of independently tracking and neutralizing threats with rockets strapped onto them."
	icon = 'icons/effects/128x128.dmi'
	icon_state = "anti_air_cannon"
	density = 1
	anchored = 1
	layer = LADDER_LAYER
	bound_width = 128
	bound_height = 64
	bound_y = 64
	unslashable = TRUE
	unacidable = TRUE

	// Which ship section is being protected by the AA gun
	var/protecting_section = ""
	var/is_disabled = FALSE

/obj/structure/anti_air_cannon/New()
	. = ..()
	if(!almayer_aa_cannon)
		almayer_aa_cannon = src

/obj/structure/anti_air_cannon/ex_act()
	return

/obj/structure/anti_air_cannon/bullet_act()
	return

/obj/structure/machinery/computer/aa_console
	name = "\improper MGAD System Console"
	desc = "The console controlling anti air tracking systems."
	icon_state = "ob_console"
	dir = WEST
	flags_can_pass_all = PASS_ALL
	flags_atom = ON_BORDER|CONDUCT|FPRINT

/obj/structure/machinery/computer/aa_console/ex_act()
	return

/obj/structure/machinery/computer/aa_console/bullet_act()
	return

// based on big copypasta from the orbital console
// the obvious improvement here is to port to nanoui but i'm too lazy to do that from the get go
/obj/structure/machinery/computer/aa_console/attack_hand(mob/user)
	if(..())
		return

	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(user, SPAN_WARNING("You have no idea how to use that console."))
		return 1

	user.set_interaction(src)

	var/dat
	if(!almayer_aa_cannon)
		dat += "No MGAD System Detected!<br/>"
	else
		var/tracking_desc = almayer_aa_cannon.protecting_section ? almayer_aa_cannon.protecting_section : "SYSTEM INACTIVE"
		dat += "<h2>MGA defense system</h2>"
		dat += "<p>Currently tracking: [tracking_desc]</p>"
		dat += "<hr/>"

		if(almayer_aa_cannon.is_disabled)
			dat += "<h2>AutoTrak system unresponsive</h2>"
		else
			dat += "<h2>AutoTrak section focus select</h2>"

			for(var/section in almayer_ship_sections)
				if(section == almayer_aa_cannon.protecting_section)
					dat += "[section]<br>"
				else
					dat += "<a href='?src=\ref[src];protect=[section]'>[section]</a><br>"

	dat += "<hr><br/><a href='?src=\ref[src];close=1'><font size=3>Close</font></a><br/>"

	show_browser(user, dat, "MGAD System Control Console", "aa_console", "size=500x350")


/obj/structure/machinery/computer/aa_console/Topic(href, href_list)
	if(..())
		return

	if(!almayer_aa_cannon)
		return

	if(href_list["protect"] && !almayer_aa_cannon.is_disabled)
		almayer_aa_cannon.protecting_section = href_list["protect"]
		attack_hand(usr)
	else if(href_list["close"])
		close_browser(usr, "aa_console")
		usr.unset_interaction()

	add_fingerprint(usr)
