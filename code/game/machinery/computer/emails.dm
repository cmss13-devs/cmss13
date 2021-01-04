
//computer that displays random emails from the Almayer crew, purely for backstory.

/obj/structure/machinery/computer/emails
	name = "Personal Computer"
	desc = "A personal computer used to view emails"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "terminal1"
	var/screen = 0
	var/email_type = /datum/fluff_email/almayer //the type of emails this computer will show. e.g. USCM emails for the personal computers on the Almayer
	var/list/email_list
	var/selected_mail


/obj/structure/machinery/computer/emails/Initialize()
	. = ..()
	email_list = list()
	var/list/L = typesof(email_type) - email_type
	var/email_amt = rand(2,4)
	for(var/i=1 to email_amt)
		var/path = pick_n_take(L)
		email_list += new path()

/obj/structure/machinery/computer/emails/Destroy()
	email_list = null
	. = ..()


/obj/structure/machinery/computer/emails/attack_hand(mob/user)
	if(..())
		return

	var/dat

	switch(screen)
		if(0)
			dat += "<A href='?src=\ref[src];open_inbox=1'><font size=4>Inbox</font></A><HR>"
		if(1)
			dat += "<font size=4>Inbox</font> | <A href='?src=\ref[src];close_inbox=1'>Close</A><HR>"
			if(selected_mail)
				var/datum/fluff_email/E = email_list[selected_mail]
				dat += "<b>SUBJECT: [E.title]</b><HR>"
				dat += "<b>FROM:</b> NAME EXPUNGED<BR>"
				dat += "<b>TO:</b> NAME EXPUNGED<BR><BR>"
				dat += "[E.entry_text]<HR>"
				dat += "<A href='?src=\ref[src];back=1'>Back</A>"
			else
				var/i = 0
				for(var/mail in email_list)
					i++
					var/datum/fluff_email/FE = mail
					dat += "<A href='?src=\ref[src];selectmail=[i]'>[FE.title]</A><BR>"

	show_browser(user, dat, "Personal Computer", "email", "size=600x520")


/obj/structure/machinery/computer/emails/Topic(href, href_list)
	if(..())
		return

	if(href_list["open_inbox"])
		screen = 1

	else if(href_list["close_inbox"])
		screen = 0

	else if(href_list["selectmail"])
		selected_mail = text2num(href_list["selectmail"])

	else if(href_list["back"])
		selected_mail = null

	add_fingerprint(usr)
//	updateUsrDialog()
	attack_hand(usr)

