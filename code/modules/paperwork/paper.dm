/*
 * Paper
 * also scraps of paper
 */

#define MAX_FIELDS 51

/obj/item/paper
	name = "paper"
	gender = PLURAL
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper"
	item_state = "paper"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/clothing/head/hats.dmi',
		WEAR_AS_GARB = 'icons/mob/humans/onmob/clothing/helmet_garb/misc.dmi',
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/paperwork_righthand.dmi'
	)
	item_state_slots = list(WEAR_HEAD = "paper")
	pickup_sound = 'sound/handling/paper_pickup.ogg'
	drop_sound = 'sound/handling/paper_drop.ogg'
	throwforce = 0
	w_class = SIZE_TINY
	throw_speed = SPEED_FAST
	flags_equip_slot = SLOT_HEAD
	flags_armor_protection = BODY_FLAG_HEAD
	attack_verb = list("bapped")
	ground_offset_x = 9
	ground_offset_y = 8

	var/info //What's actually written on the paper.
	var/info_links //A different version of the paper which includes html links at fields and EOF
	var/stamps //The (text for the) stamps on the paper.
	var/fields //Amount of user created fields
	var/list/stamped
	var/ico[0] //Icons and
	var/offset_x[0] //offsets stored for later
	var/offset_y[0] //usage by the photocopier
	var/rigged = 0
	var/spam_flag = 0

	// any photos that might be attached to the paper
	var/list/photo_list

	var/deffont = "Verdana"
	var/signfont = "Times New Roman"
	var/crayonfont = "Comic Sans MS"

	/// If this paper imports a prefab on instance.
	var/is_prefab = FALSE
	/// Category of the paper.
	var/document_category
	/// Name of the document.
	var/document_title
	var/datum/prefab_document/doc_datum_type

//lipstick wiping is in code/game/obj/items/weapons/cosmetics.dm!

/obj/item/paper/Initialize(mapload, photo_list)
	. = ..()
	stamps = ""
	src.photo_list = photo_list

	if(info != initial(info))
		info = html_encode(info)
		info = replacetext(info, "\n", "<BR>")
		info = parsepencode(info)

	update_icon()
	updateinfolinks()
	if(is_prefab)
		compile_paper()

/obj/item/paper/update_icon()
	switch(icon_state)
		if("paper_talisman", "paper_wy_words", "paper_uscm_words", "paper_flag_words", "fortune")
			return

	if(!info)
		icon_state = "paper"
		return

	switch(icon_state)
		if("paper_wy")
			icon_state = "paper_wy_words"
			return
		if("paper_uscm")
			icon_state = "paper_uscm_words"
			return
		if("paper_flag")
			icon_state = "paper_flag_words"
			item_state = "paper_flag"
			return
		else
			icon_state = "paper_words"
	return

/obj/item/paper/get_examine_text(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		if(!(istype(user, /mob/dead/observer) || istype(user, /mob/living/carbon/human) || isRemoteControlling(user)))
			// Show scrambled paper if they aren't a ghost, human, or silicone.
			read_paper(user,scramble = TRUE)
		else
			read_paper(user)
	else
		. += SPAN_NOTICE("It is too far away.")

/obj/item/paper/proc/read_paper(mob/user, scramble = FALSE)
	var/datum/asset/asset_datum = get_asset_datum(/datum/asset/simple/paper)
	asset_datum.send(user)
	if(photo_list)
		for(var/photo in photo_list)
			user << browse_rsc(photo_list[photo], photo)
	var/paper_info = info
	if(scramble)
		paper_info = stars_decode_html(info)
	show_browser(user, "<BODY class='paper'>[paper_info][stamps]</BODY>", name, name, "size=650x700")
	onclose(user, name)

/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	var/n_name = strip_html(input(usr, "What would you like to label the paper?", "Paper Labelling", null)  as text)
	close_browser(usr, name)
	if((loc == usr && usr.stat == 0))
		name = "[(n_name ? text("[n_name]") : "paper")]"
	add_fingerprint(usr)
	return

/obj/item/paper/attack_self(mob/living/user)
	..()
	read_paper(user)

/obj/item/paper/attack_remote(mob/living/silicon/ai/user as mob)
	var/dist
	dist = get_dist(src, user)
	if(dist < 2)
		read_paper(user)
	else
		//Show scrambled paper
		show_browser(user, "<BODY class='paper'>[stars(info)][stamps]</BODY>", name, name)
		onclose(user, name)
	return

/obj/item/paper/attack(mob/living/carbon/human/M, mob/living/carbon/user)

	if(user.zone_selected == "eyes")
		if(!ishumansynth_strict(M))
			return

		user.visible_message(SPAN_NOTICE("You show the paper to [M]."),
		SPAN_NOTICE("[user] holds up a paper and shows it to [M]."))
		examine(M)

	else if(user.zone_selected == "mouth") // lipstick wiping
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H == user)
				to_chat(user, SPAN_NOTICE("You wipe off the face paint with [src]."))
				H.lip_style = null
				H.update_body()
			else
				user.visible_message(SPAN_WARNING("[user] begins to wipe [H]'s face paint off with \the [src]."),
									SPAN_NOTICE("You begin to wipe off [H]'s face paint."))
				if(do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY) && do_after(H, 10, INTERRUPT_ALL, BUSY_ICON_GENERIC)) //user needs to keep their active hand, H does not.
					user.visible_message(SPAN_NOTICE("[user] wipes [H]'s face paint off with \the [src]."),
										SPAN_NOTICE("You wipe off [H]'s face paint."))
					H.lip_style = null
					H.update_body()

/obj/item/paper/vv_get_dropdown()
	. = ..()
	. += "<option value>-----PAPER-----</option>"
	. += "<option value='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];customise_paper=\ref[src]'>Customise content</option>"

/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	var/spam_protection = 100
	while(1) // I know this can cause infinite loops and fuck up the whole server, but the if(istart==0) should be safe as fuck
		var/istart = 0
		spam_protection--
		if(spam_protection <= 0)
			return

		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart==0)
			return // No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()

/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i=1,  i<=min(fields, MAX_FIELDS), i++)
		addtofield(i, "<font face=\"[deffont]\"><A href='byond://?src=\ref[src];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[deffont]\"><A href='byond://?src=\ref[src];write=end'>write</A></font>"


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	stamped = list()
	overlays.Cut()
	updateinfolinks()
	update_icon()


/obj/item/paper/proc/parsepencode(paper_text, obj/item/tool/pen/P, mob/user as mob, iscrayon = 0)
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)

	paper_text = replacetext(paper_text, "\[center\]", "<center>")
	paper_text = replacetext(paper_text, "\[/center\]", "</center>")
	paper_text = replacetext(paper_text, "\[br\]", "<BR>")
	paper_text = replacetext(paper_text, "\[b\]", "<B>")
	paper_text = replacetext(paper_text, "\[/b\]", "</B>")
	paper_text = replacetext(paper_text, "\[i\]", "<I>")
	paper_text = replacetext(paper_text, "\[/i\]", "</I>")
	paper_text = replacetext(paper_text, "\[u\]", "<U>")
	paper_text = replacetext(paper_text, "\[/u\]", "</U>")
	paper_text = replacetext(paper_text, "\[large\]", "<font size=\"4\">")
	paper_text = replacetext(paper_text, "\[/large\]", "</font>")
	paper_text = replacetext(paper_text, "\[sign\]", "<font face=\"[signfont]\"><i>[user ? user.real_name : "Anonymous"]</i></font>")
	paper_text = replacetext(paper_text, "\[date\]", "<font face=\"[signfont]\"><i>[time2text(REALTIMEOFDAY, "Day DD Month [GLOB.game_year]")]</i></font>")
	paper_text = replacetext(paper_text, "\[shortdate\]", "<font face=\"[signfont]\"><i>[time2text(REALTIMEOFDAY, "DD/MM/[GLOB.game_year]")]</i></font>")
	paper_text = replacetext(paper_text, "\[time\]", "<font face=\"[signfont]\"><i>[worldtime2text("hh:mm")]</i></font>")
	paper_text = replacetext(paper_text, "\[date+time\]", "<font face=\"[signfont]\"><i>[worldtime2text("hh:mm")], [time2text(REALTIMEOFDAY, "Day DD Month [GLOB.game_year]")]</i></font>")
	paper_text = replacetext(paper_text, "\[field\]", "<span class=\"paper_field\"></span>")

	paper_text = replacetext(paper_text, "\[h1\]", "<H1>")
	paper_text = replacetext(paper_text, "\[/h1\]", "</H1>")
	paper_text = replacetext(paper_text, "\[h2\]", "<H2>")
	paper_text = replacetext(paper_text, "\[/h2\]", "</H2>")
	paper_text = replacetext(paper_text, "\[h3\]", "<H3>")
	paper_text = replacetext(paper_text, "\[/h3\]", "</H3>")

	if(!iscrayon)
		paper_text = replacetext(paper_text, "\[*\]", "<li>")
		paper_text = replacetext(paper_text, "\[hr\]", "<HR>")
		paper_text = replacetext(paper_text, "\[small\]", "<font size = \"1\">")
		paper_text = replacetext(paper_text, "\[/small\]", "</font>")
		paper_text = replacetext(paper_text, "\[list\]", "<ul>")
		paper_text = replacetext(paper_text, "\[/list\]", "</ul>")
		paper_text = replacetext(paper_text, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
		paper_text = replacetext(paper_text, "\[/table\]", "</td></tr></table>")
		paper_text = replacetext(paper_text, "\[grid\]", "<table>")
		paper_text = replacetext(paper_text, "\[/grid\]", "</td></tr></table>")
		paper_text = replacetext(paper_text, "\[row\]", "</td><tr>")
		paper_text = replacetext(paper_text, "\[cell\]", "<td>")
		paper_text = replacetext(paper_text, "\[wy\]", "<img src = [asset.get_url_mappings()["logo_wy.png"]]>")
		paper_text = replacetext(paper_text, "\[wy_inv\]", "<img src = [asset.get_url_mappings()["logo_wy_inv.png"]]>")
		paper_text = replacetext(paper_text, "\[uscm\]", "<img src = [asset.get_url_mappings()["logo_uscm.png"]]>")
		paper_text = replacetext(paper_text, "\[upp\]", "<img src = [asset.get_url_mappings()["logo_upp.png"]]>")
		paper_text = replacetext(paper_text, "\[cmb\]", "<img src = [asset.get_url_mappings()["logo_cmb.png"]]>")

		paper_text = "<font face=\"[deffont]\" color=[P ? P.pen_color : "black"]>[paper_text]</font>"
	else // If it is a crayon, and he still tries to use these, make them empty!
		paper_text = replacetext(paper_text, "\[*\]", "")
		paper_text = replacetext(paper_text, "\[hr\]", "")
		paper_text = replacetext(paper_text, "\[small\]", "")
		paper_text = replacetext(paper_text, "\[/small\]", "")
		paper_text = replacetext(paper_text, "\[list\]", "")
		paper_text = replacetext(paper_text, "\[/list\]", "")
		paper_text = replacetext(paper_text, "\[table\]", "")
		paper_text = replacetext(paper_text, "\[/table\]", "")
		paper_text = replacetext(paper_text, "\[row\]", "")
		paper_text = replacetext(paper_text, "\[cell\]", "")
		paper_text = replacetext(paper_text, "\[wy\]", "")
		paper_text = replacetext(paper_text, "\[wy_inv\]", "")
		paper_text = replacetext(paper_text, "\[uscm\]", "")
		paper_text = replacetext(paper_text, "\[upp\]", "")
		paper_text = replacetext(paper_text, "\[cmb\]", "")

		paper_text = "<font face=\"[crayonfont]\" color=[P ? P.pen_color : "black"]><b>[paper_text]</b></font>"


	//Count the fields
	calculate_fields(paper_text)
	return paper_text

/obj/item/paper/proc/calculate_fields(message)
	var/check_text = message ? message : info
	var/laststart = 1
	while(1)
		var/i = findtext(check_text, "<span class=\"paper_field\">", laststart)
		if(i==0)
			break
		laststart = i+1
		fields = min(fields+1, MAX_FIELDS)
		//NOTE: The max here will include the auto-created field when hitting a paper with a pen. So it should be [your_desired_number]+1.

/obj/item/paper/proc/openhelp(mob/user as mob)
	var/dat = {"<HTML>
	<BODY>
		<b><center>Crayon&Pen commands</center></b><br>
		<br>
		\[br\] : Creates a linebreak.<br>
		\[center\] - \[/center\] : Centers the text.<br>
		\[h1\] - \[/h1\] : Makes the text a first level heading<br>
		\[h2\] - \[/h2\] : Makes the text a second level heading<br>
		\[h3\] - \[/h3\] : Makes the text a third level heading<br>
		\[b\] - \[/b\] : Makes the text <b>bold</b>.<br>
		\[i\] - \[/i\] : Makes the text <i>italic</i>.<br>
		\[u\] - \[/u\] : Makes the text <u>underlined</u>.<br>
		\[large\] - \[/large\] : Increases the <font size = \"4\">size</font> of the text.<br>
		\[sign\] : Inserts a signature of your name in a foolproof way.<br>
		\[field\] : Inserts an invisible field which lets you start type from there. Useful for forms.<br>
		<br>
		<b><center>Pen exclusive commands</center></b><br>
		\[small\] - \[/small\] : Decreases the <font size = \"1\">size</font> of the text.<br>
		\[list\] - \[/list\] : A list.<br>
		\[*\] : A dot used for lists.<br>
		\[hr\] : Adds a horizontal rule.
	</BODY></HTML>"}
	show_browser(user, dat, "Pen Help", "paper_help")

/obj/item/paper/proc/burnpaper(obj/item/P, mob/user)
	var/class = "<span class='warning'>"

	if(P.heat_source >= 400 && !user.is_mob_restrained())
		if(istype(P, /obj/item/tool/lighter/zippo))
			class = "<span class='rose'>"

		user.visible_message("[class][user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!",
		"[class]You hold \the [P] up to \the [src], burning it slowly.")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.heat_source)
				user.visible_message("[class][user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.",
				"[class]You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.")

				if(user.get_inactive_hand() == src)
					user.drop_inv_item_on_ground(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, SPAN_DANGER("You must hold \the [P] steady to burn \the [src]."))

/obj/item/paper/verb/seal_paper()
	set name = "Seal paper"
	set category = "Object"
	set src in usr

	if(tgui_alert(usr, "Are you sure you wish to seal this document? Note: This will prevent the edit of any fields on the paper, excluding the end of the page.", "Confirm", list("Yes", "No"), 20 SECONDS) != "Yes")
		return FALSE
	info = replacetext(info, "<span class=\"paper_field\">", "<span class=\"sealed_paper_field\">")
	calculate_fields()
	updateinfolinks()
	return TRUE

/obj/item/paper/proc/compile_paper()
	if(!is_prefab)
		return FALSE
	if(!document_category || !doc_datum_type)
		return FALSE

	var/datum/prefab_document/prefab = new doc_datum_type
	info = prefab.contents
	qdel(prefab)

	calculate_fields()
	updateinfolinks()
	update_icon()
	return TRUE

/obj/item/paper/Topic(href, href_list)
	..()
	if(!usr || (usr.stat || usr.is_mob_restrained()))
		return

	if(usr.client.prefs.muted & MUTE_IC)
		to_chat(usr, SPAN_DANGER("You cannot write on paper (muted)."))
		return

	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  stripped_multiline_input(usr, "Enter what you want to write:", "Write", "", MAX_MESSAGE_LEN)
		var/shortened_t = copytext(t,1,100)
		msg_admin_niche("PAPER: [key_name(usr)] tried to write something. First 100 characters: [shortened_t]")

		var/obj/item/i = usr.get_active_hand() // Check to see if he still got that darn pen, also check if he's using a crayon or pen.
		var/iscrayon = 0
		if(!HAS_TRAIT(i, TRAIT_TOOL_PEN))
			if(!istype(i, /obj/item/toy/crayon))
				return
			iscrayon = 1


		// if paper is not in usr, then it must be near them, or in a clipboard, noticeboard or folder, which must be in or near usr
		if(src.loc != usr && !src.Adjacent(usr) && !((istype(src.loc, /obj/item/clipboard) || istype(src.loc, /obj/structure/noticeboard) || istype(src.loc, /obj/item/folder)) && (src.loc.loc == usr || src.loc.Adjacent(usr)) ) )
			return

		t = replacetext(t, "\n", "<BR>")
		t = parsepencode(t, i, usr, iscrayon) // Encode everything from pencode to html

		if(id!="end")
			addtofield(text2num(id), t) // He wants to edit a field, let him.
		else
			info += t // Oh, he wants to edit to the end of the file, let him.
			updateinfolinks()

		show_browser(usr, "<BODY class='paper'>[info_links][stamps]</BODY>", name, name) // Update the window

		update_icon()
		playsound(src, "paper_writing", 15, TRUE)

/obj/item/paper/attackby(obj/item/P, mob/user)
	..()

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/photo))
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, SPAN_NOTICE("Take off the carbon copy first."))
				add_fingerprint(user)
				return
		if(loc != user)
			return
		var/obj/item/paper_bundle/B = new(get_turf(user))
		if (name != "paper")
			B.name = name
		else if (P.name != "paper" && P.name != "photo")
			B.name = P.name
		user.drop_inv_item_on_ground(P)
		user.drop_inv_item_on_ground(src)
		to_chat(user, SPAN_NOTICE("You clip the [P.name] to [(src.name == "paper") ? "the paper" : src.name]."))
		B.attach_doc(src, user, TRUE)
		B.attach_doc(P, user, TRUE)
		user.put_in_hands(B)

	else if(HAS_TRAIT(P, TRAIT_TOOL_PEN) || istype(P, /obj/item/toy/crayon))
		if(HAS_TRAIT(P, TRAIT_TOOL_PEN))
			var/obj/item/tool/pen/p = P
			if(!p.on)
				to_chat(user, SPAN_NOTICE("Your pen is not on!"))
				return
		show_browser(user, "<BODY class='paper'>[info_links][stamps]</BODY>", name, name) // Update the window
		//openhelp(user)
		return

	else if(istype(P, /obj/item/tool/stamp))
		if((!in_range(src, usr) && loc != user && !( istype(loc, /obj/item/clipboard) ) && loc.loc != user && user.get_active_hand() != P))
			return

		stamps += (stamps=="" ? "<HR>" : "<BR>") + "<i>This paper has been stamped with the [P.name].</i>"
		playsound(src, 'sound/effects/alien_footstep_medium3.ogg', 20, TRUE, 6)

		var/image/stampoverlay = image('icons/obj/items/paper.dmi')
		var/x
		var/y
		if(istype(P, /obj/item/tool/stamp/captain) || istype(P, /obj/item/tool/stamp/weyyu))
			x = rand(-2, 0)
			y = rand(-1, 2)
		else
			x = rand(-2, 2)
			y = rand(-3, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y

		if(!ico)
			ico = new
		ico += "paper_[P.icon_state]"
		stampoverlay.icon_state = "paper_[P.icon_state]"

		if(!stamped)
			stamped = new
		stamped += P.type
		overlays += stampoverlay

		to_chat(user, SPAN_NOTICE("You stamp the paper with your rubber stamp."))

	else if(P.heat_source >= 400)
		burnpaper(P, user)

	add_fingerprint(user)
	return

/obj/item/paper/proc/convert_to_chem_report()
	if(istype(src, /obj/item/paper/research_report))
		return src
	var/obj/item/paper/research_report/CR = new /obj/item/paper/research_report
	if(istype(src, /obj/item/paper/research_notes))
		var/obj/item/paper/research_notes/N = src
		if(N.note_type == "synthesis")
			CR.data = N.data
			if(N.full_report)
				CR.completed = TRUE
	CR.info = info
	CR.info_links = info_links
	CR.stamps = stamps
	CR.fields = fields
	CR.name = name
	CR.forceMove(loc)
	qdel(src)
	return CR

/*
 * Premade paper
 */
/obj/item/paper/Court
	name = "Judgement"
	info = "For crimes against the station, the offender is sentenced to:<BR>\n<BR>\n"

/obj/item/paper/almayer_storage
	name = "Almayer Emergency Storage Note"
	info = "<i>Hey Garry, I got the boys to move most of the emergency supplies down into the ASRS hold just like ya' asked. <BR>Next time you're around Chinook I'll buy you a beer ok?</i>"
/obj/item/paper/Toxin
	name = "Chemical Information"
	info = "Known Onboard Toxins:<BR>\n\tGrade A Semi-Liquid Phoron:<BR>\n\t\tHighly poisonous. You cannot sustain concentrations above 15 units.<BR>\n\t\tA gas mask fails to filter phoron after 50 units.<BR>\n\t\tWill attempt to diffuse like a gas.<BR>\n\t\tFiltered by scrubbers.<BR>\n\t\tThere is a bottled version which is very different<BR>\n\t\t\tfrom the version found in canisters!<BR>\n<BR>\n\t\tWARNING: Highly Flammable. Keep away from heat sources<BR>\n\t\texcept in a enclosed fire area!<BR>\n\t\tWARNING: It is a crime to use this without authorization.<BR>\nKnown Onboard Anti-Toxin:<BR>\n\tAnti-Toxin Type 01P: Works against Grade A Phoron.<BR>\n\t\tBest if injected directly into bloodstream.<BR>\n\t\tA full injection is in every regular Med-Kit.<BR>\n\t\tSpecial toxin Kits hold around 7.<BR>\n<BR>\nKnown Onboard Chemicals (other):<BR>\n\tRejuvenation T#001:<BR>\n\t\tEven 1 unit injected directly into the bloodstream<BR>\n\t\t\twill cure paralysis and sleep phoron.<BR>\n\t\tIf administered to a dying patient it will prevent<BR>\n\t\t\tfurther damage for about units*3 seconds.<BR>\n\t\t\tit will not cure them or allow them to be cured.<BR>\n\t\tIt can be administeredd to a non-dying patient<BR>\n\t\t\tbut the chemicals disappear just as fast.<BR>\n\tSoporific T#054:<BR>\n\t\t5 units wilkl induce precisely 1 minute of sleep.<BR>\n\t\t\tThe effect are cumulative.<BR>\n\t\tWARNING: It is a crime to use this without authorization"

/obj/item/paper/courtroom
	name = "A Crash Course in Legal SOP on SS13"
	info = "<B>Roles:</B><BR>\nThe Detective is basically the investigator and prosecutor.<BR>\nThe Staff Assistant can perform these functions with written authority from the Detective.<BR>\nThe Captain/HoP/Warden is ct as the judicial authority.<BR>\nThe Security Officers are responsible for executing warrants, security during trial, and prisoner transport.<BR>\n<BR>\n<B>Investigative Phase:</B><BR>\nAfter the crime has been committed the Detective's job is to gather evidence and try to ascertain not only who did it but what happened. He must take special care to catalogue everything and don't leave anything out. Write out all the evidence on paper. Make sure you take an appropriate number of fingerprints. IF he must ask someone questions he has permission to confront them. If the person refuses he can ask a judicial authority to write a subpoena for questioning. If again he fails to respond then that person is to be jailed as insubordinate and obstructing justice. Said person will be released after he cooperates.<BR>\n<BR>\nONCE the FT has a clear idea as to who the criminal is he is to write an arrest warrant on the piece of paper. IT MUST LIST THE CHARGES. The FT is to then go to the judicial authority and explain a small version of his case. If the case is moderately acceptable the authority should sign it. Security must then execute said warrant.<BR>\n<BR>\n<B>Pre-Pre-Trial Phase:</B><BR>\nNow a legal representative must be presented to the defendant if said defendant requests one. That person and the defendant are then to be given time to meet (in the jail IS ACCEPTABLE). The defendant and his lawyer are then to be given a copy of all the evidence that will be presented at trial (rewriting it all on paper is fine). THIS IS CALLED THE DISCOVERY PACK. With a few exceptions, THIS IS THE ONLY EVIDENCE BOTH SIDES MAY USE AT TRIAL. IF the prosecution will be seeking the death penalty it MUST be stated at this time. ALSO if the defense will be seeking not guilty by mental defect it must state this at this time to allow ample time for examination.<BR>\nNow at this time each side is to compile a list of witnesses. By default, the defendant is on both lists regardless of anything else. Also the defense and prosecution can compile more evidence beforehand BUT in order for it to be used the evidence MUST also be given to the other side.\nThe defense has time to compile motions against some evidence here.<BR>\n<B>Possible Motions:</B><BR>\n1. <U>Invalidate Evidence-</U> Something with the evidence is wrong and the evidence is to be thrown out. This includes irrelevance or corrupt security.<BR>\n2. <U>Free Movement-</U> Basically the defendant is to be kept uncuffed before and during the trial.<BR>\n3. <U>Subpoena Witness-</U> If the defense presents god reasons for needing a witness but said person fails to cooperate then a subpoena is issued.<BR>\n4. <U>Drop the Charges-</U> Not enough evidence is there for a trial so the charges are to be dropped. The FT CAN RETRY but the judicial authority must carefully reexamine the new evidence.<BR>\n5. <U>Declare Incompetent-</U> Basically the defendant is insane. Once this is granted a medical official is to examine the patient. If he is indeed insane he is to be placed under care of the medical staff until he is deemed competent to stand trial.<BR>\n<BR>\nALL SIDES MOVE TO A COURTROOM<BR>\n<B>Pre-Trial Hearings:</B><BR>\nA judicial authority and the 2 sides are to meet in the trial room. NO ONE ELSE BESIDES A SECURITY DETAIL IS TO BE PRESENT. The defense submits a plea. If the plea is guilty then proceed directly to sentencing phase. Now the sides each present their motions to the judicial authority. He rules on them. Each side can debate each motion. Then the judicial authority gets a list of crew members. He first gets a chance to look at them all and pick out acceptable and available jurors. Those jurors are then called over. Each side can ask a few questions and dismiss jurors they find too biased. HOWEVER before dismissal the judicial authority MUST agree to the reasoning.<BR>\n<BR>\n<B>The Trial:</B><BR>\nThe trial has three phases.<BR>\n1. <B>Opening Arguments</B>- Each side can give a short speech. They may not present ANY evidence.<BR>\n2. <B>Witness Calling/Evidence Presentation</B>- The prosecution goes first and is able to call the witnesses on his approved list in any order. He can recall them if necessary. During the questioning the lawyer may use the evidence in the questions to help prove a point. After every witness the other side has a chance to cross-examine. After both sides are done questioning a witness the prosecution can present another or recall one (even the EXACT same one again!). After prosecution is done the defense can call witnesses. After the initial cases are presented both sides are free to call witnesses on either list.<BR>\nFINALLY once both sides are done calling witnesses we move onto the next phase.<BR>\n3. <B>Closing Arguments</B>- Same as opening.<BR>\nThe jury then deliberates IN PRIVATE. THEY MUST ALL AGREE on a verdict. REMEMBER: They mix between some charges being guilty and others not guilty (IE if you supposedly killed someone with a gun and you unfortunately picked up a gun without authorization then you CAN be found not guilty of murder BUT guilty of possession of illegal weaponry.). Once they have agreed they present their verdict. If unable to reach a verdict and feel they will never they call a deadlocked jury and we restart at Pre-Trial phase with an entirely new set of jurors.<BR>\n<BR>\n<B>Sentencing Phase:</B><BR>\nIf the death penalty was sought (you MUST have gone through a trial for death penalty) then skip to the second part. <BR>\nI. Each side can present more evidence/witnesses in any order. There is NO ban on emotional aspects or anything. The prosecution is to submit a suggested penalty. After all the sides are done then the judicial authority is to give a sentence.<BR>\nII. The jury stays and does the same thing as I. Their sole job is to determine if the death penalty is applicable. If NOT then the judge selects a sentence.<BR>\n<BR>\nTADA you're done. Security then executes the sentence and adds the applicable convictions to the person's record.<BR>\n"

/obj/item/paper/hydroponics
	name = "Greetings from Billy Bob"
	info = "<B>Hey fellow botanist!</B><BR>\n<BR>\nI didn't trust the station folk so I left<BR>\na couple of weeks ago. But here's some<BR>\ninstructions on how to operate things here.<BR>\nYou can grow plants and each iteration they become<BR>\nstronger, more potent and have better yield, if you<BR>\nknow which ones to pick. Use your botanist's analyzer<BR>\nfor that. You can turn harvested plants into seeds<BR>\nat the seed extractor, and replant them for better stuff!<BR>\nSometimes if the weed level gets high in the tray<BR>\nmutations into different mushroom or weed species have<BR>\nbeen witnessed. On the rare occassion even weeds mutate!<BR>\n<BR>\nEither way, have fun!<BR>\n<BR>\nBest regards,<BR>\nBilly Bob Johnson.<BR>\n<BR>\nPS.<BR>\nHere's a few tips:<BR>\nIn nettles, potency = damage<BR>\nIn amanitas, potency = deadliness + side effect<BR>\nIn Liberty caps, potency = drug power + effect<BR>\nIn chilis, potency = heat<BR>\n<B>Nutrients keep mushrooms alive!</B><BR>\n<B>Water keeps weeds such as nettles alive!</B><BR>\n<B>All other plants need both.</B>"

/obj/item/paper/djstation
	name = "DJ Listening Outpost"
	info = "<B>Welcome new owner!</B><BR><BR>You have purchased the latest in listening equipment. The telecommunication setup we created is the best in listening to common and private radio fequencies. Here is a step by step guide to start listening in on those saucy radio channels:<br><ol><li>Equip yourself with a multi-tool</li><li>Use the multitool on each machine, that is the broadcaster, receiver and the relay.</li><li>Turn all the machines on, it has already been configured for you to listen on.</li></ol> Simple as that. Now to listen to the private channels, you'll have to configure the intercoms, located on the front desk. Here is a list of frequencies for you to listen on.<br><ul><li>145.7 - Common Channel</li><li>144.7 - Private AI Channel</li><li>135.9 - Security Channel</li><li>135.7 - Engineering Channel</li><li>135.5 - Medical Channel</li><li>135.3 - Command Channel</li><li>135.1 - Science Channel</li><li>134.9 - Mining Channel</li><li>134.7 - Cargo Channel</li>"

/obj/item/paper/flag
	name = "paper flag"
	desc = "Somebody crudely glued a piece of paper to a stick. You feel like waving it around like an idiot."
	icon_state = "paper_flag"
	item_state = "paper_flag"

	anchored = TRUE

/obj/item/paper/jobs
	name = "Job Information"
	info = "Information on all formal jobs that can be assigned on Space Station 13 can be found on this document.<BR>\nThe data will be in the following form.<BR>\nGenerally lower ranking positions come first in this list.<BR>\n<BR>\n<B>Job Name</B>   general access>lab access-engine access-systems access (atmosphere control)<BR>\n\tJob Description<BR>\nJob Duties (in no particular order)<BR>\nTips (where applicable)<BR>\n<BR>\n<B>Research Assistant</B> 1>1-0-0<BR>\n\tThis is probably the lowest level position. Anyone who enters the space station after the initial job\nassignment will automatically receive this position. Access with this is restricted. Head of Personnel should\nappropriate the correct level of assistance.<BR>\n1. Assist the researchers.<BR>\n2. Clean up the labs.<BR>\n3. Prepare materials.<BR>\n<BR>\n<B>Staff Assistant</B> 2>0-0-0<BR>\n\tThis position assists the security officer in his duties. The staff assisstants should primarily br\npatrolling the ship waiting until they are needed to maintain ship safety.\n(Addendum: Updated/Elevated Security Protocols admit issuing of low level weapons to security personnel)<BR>\n1. Patrol ship/Guard key areas<BR>\n2. Assist security officer<BR>\n3. Perform other security duties.<BR>\n<BR>\n<B>Technical Assistant</B> 1>0-0-1<BR>\n\tThis is yet another low level position. The technical assistant helps the engineer and the statian\ntechnician with the upkeep and maintenance of the station. This job is very important because it usually\ngets to be a heavy workload on station technician and these helpers will alleviate that.<BR>\n1. Assist Station technician and Engineers.<BR>\n2. Perform general maintenance of station.<BR>\n3. Prepare materials.<BR>\n<BR>\n<B>Medical Assistant</B> 1>1-0-0<BR>\n\tThis is the fourth position yet it is slightly less common. This position doesn't have much power\noutside of the med bay. Consider this position like a nurse who helps to upkeep medical records and the\nmaterials (filling syringes and checking vitals)<BR>\n1. Assist the medical personnel.<BR>\n2. Update medical files.<BR>\n3. Prepare materials for medical operations.<BR>\n<BR>\n<B>Research Technician</B> 2>3-0-0<BR>\n\tThis job is primarily a step up from research assistant. These people generally do not get their own lab\nbut are more hands on in the experimentation process. At this level they are permitted to work as consultants to\nthe others formally.<BR>\n1. Inform superiors of research.<BR>\n2. Perform research alongside of official researchers.<BR>\n<BR>\n<B>Detective</B> 3>2-0-0<BR>\n\tThis job is in most cases slightly boring at best. Their sole duty is to\nperform investigations of crine scenes and analysis of the crime scene. This\nalleviates SOME of the burden from the security officer. This person's duty\nis to draw conclusions as to what happened and testify in court. Said person\nalso should stroe the evidence ly.<BR>\n1. Perform crime-scene investigations/draw conclusions.<BR>\n2. Store and catalogue evidence properly.<BR>\n3. Testify to superiors/inquieries on findings.<BR>\n<BR>\n<B>Station Technician</B> 2>0-2-3<BR>\n\tPeople assigned to this position must work to make sure all the systems aboard Space Station 13 are operable.\nThey should primarily work in the computer lab and repairing faulty equipment. They should work with the\natmospheric technician.<BR>\n1. Maintain SS13 systems.<BR>\n2. Repair equipment.<BR>\n<BR>\n<B>Atmospheric Technician</B> 3>0-0-4<BR>\n\tThese people should primarily work in the atmospheric control center and lab. They have the very important\njob of maintaining the delicate atmosphere on SS13.<BR>\n1. Maintain atmosphere on SS13<BR>\n2. Research atmospheres on the space station. (safely please!)<BR>\n<BR>\n<B>Engineer</B> 2>1-3-0<BR>\n\tPeople working as this should generally have detailed knowledge as to how the propulsion systems on SS13\nwork. They are one of the few classes that have unrestricted access to the engine area.<BR>\n1. Upkeep the engine.<BR>\n2. Prevent fires in the engine.<BR>\n3. Maintain a safe orbit.<BR>\n<BR>\n<B>Medical Researcher</B> 2>5-0-0<BR>\n\tThis position may need a little clarification. Their duty is to make sure that all experiments are safe and\nto conduct experiments that may help to improve the station. They will be generally idle until a new laboratory\nis constructed.<BR>\n1. Make sure the station is kept safe.<BR>\n2. Research medical properties of materials studied of Space Station 13.<BR>\n<BR>\n<B>Scientist</B> 2>5-0-0<BR>\n\tThese people study the properties, particularly the toxic properties, of materials handled on SS13.\nTechnically they can also be called Phoron Technicians as phoron is the material they routinly handle.<BR>\n1. Research phoron<BR>\n2. Make sure all phoron is properly handled.<BR>\n<BR>\n<B>Medical Doctor (Officer)</B> 2>0-0-0<BR>\n\tPeople working this job should primarily stay in the medical area. They should make sure everyone goes to\nthe medical bay for treatment and examination. Also they should make sure that medical supplies are kept in\norder.<BR>\n1. Heal wounded people.<BR>\n2. Perform examinations of all personnel.<BR>\n3. Moniter usage of medical equipment.<BR>\n<BR>\n<B>Security Officer</B> 3>0-0-0<BR>\n\tThese people should attempt to keep the peace inside the station and make sure the station is kept safe. One\nside duty is to assist in repairing the station. They also work like general maintenance personnel. They are not\ngiven a weapon and must use their own resources.<BR>\n(Addendum: Updated/Elevated Security Protocols admit issuing of weapons to security personnel)<BR>\n1. Maintain order.<BR>\n2. Assist others.<BR>\n3. Repair structural problems.<BR>\n<BR>\n<B>Head of Security</B> 4>5-2-2<BR>\n\tPeople assigned as Head of Security should issue orders to the security staff. They should\nalso carefully moderate the usage of all security equipment. All security matters should be reported to this person.<BR>\n1. Oversee security.<BR>\n2. Assign patrol duties.<BR>\n3. Protect the station and staff.<BR>\n<BR>\n<B>Head of Personnel</B> 4>4-2-2<BR>\n\tPeople assigned as head of personnel will find themselves moderating all actions done by personnel. \nAlso they have the ability to assign jobs and access levels.<BR>\n1. Assign duties.<BR>\n2. Moderate personnel.<BR>\n3. Moderate research. <BR>\n<BR>\n<B>Captain</B> 5>5-5-5 (unrestricted station wide access)<BR>\n\tThis is the highest position youi can aquire on Space Station 13. They are allowed anywhere inside the\nspace station and therefore should protect their ID card. They also have the ability to assign positions\nand access levels. They should not abuse their power.<BR>\n1. Assign all positions on SS13<BR>\n2. Inspect the station for any problems.<BR>\n3. Perform administrative duties.<BR>\n"

/obj/item/paper/photograph
	name = "photo"
	icon_state = "photo"
	var/photo_id = 0
	item_state = "paper"

/obj/item/paper/sop
	name = "paper- 'Standard Operating Procedure'"
	info = "Alert Levels:<BR>\nBlue- Emergency<BR>\n\t1. Caused by fire<BR>\n\t2. Caused by manual interaction<BR>\n\tAction:<BR>\n\t\tClose all fire doors. These can only be opened by reseting the alarm<BR>\nRed- Ejection/Self-Destruct<BR>\n\t1. Caused by module operating computer.<BR>\n\tAction:<BR>\n\t\tAfter the specified time the module will eject completely.<BR>\n<BR>\nEngine Maintenance Instructions:<BR>\n\tShut off ignition systems:<BR>\n\tActivate internal power<BR>\n\tActivate orbital balance matrix<BR>\n\tRemove volatile liquids from area<BR>\n\tWear a fire suit<BR>\n<BR>\n\tAfter<BR>\n\t\tDecontaminate<BR>\n\t\tVisit medical examiner<BR>\n<BR>\nToxin Laboratory Procedure:<BR>\n\tWear a gas mask regardless<BR>\n\tGet an oxygen tank.<BR>\n\tActivate internal atmosphere<BR>\n<BR>\n\tAfter<BR>\n\t\tDecontaminate<BR>\n\t\tVisit medical examiner<BR>\n<BR>\nDisaster Procedure:<BR>\n\tFire:<BR>\n\t\tActivate sector fire alarm.<BR>\n\t\tMove to a safe area.<BR>\n\t\tGet a fire suit<BR>\n\t\tAfter:<BR>\n\t\t\tAssess Damage<BR>\n\t\t\tRepair damages<BR>\n\t\t\tIf needed, Evacuate<BR>\n\tMeteor Shower:<BR>\n\t\tActivate fire alarm<BR>\n\t\tMove to the back of ship<BR>\n\t\tAfter<BR>\n\t\t\tRepair damage<BR>\n\t\t\tIf needed, Evacuate<BR>\n\tAccidental Reentry:<BR>\n\t\tActivate fire alarms in front of ship.<BR>\n\t\tMove volatile matter to a fire proof area!<BR>\n\t\tGet a fire suit.<BR>\n\t\tStay secure until an emergency ship arrives.<BR>\n<BR>\n\t\tIf ship does not arrive-<BR>\n\t\t\tEvacuate to a nearby safe area!"

/obj/item/paper/prison_station/test_log
	name = "paper- 'Test Log'"
	info = "<p style=\"text-align: center;\"><sub>TEST LOG</sub></p><p>SPECIMEN: Bioweapon candidate Kappa. Individual 3</p><BR>\n<p>-</p><p>PROCEDURE: Observation</p><p>RESULTS: Specimen paces around cell. Appears agitated. Vocalisations.</p><p>-</p><p>PROCEDURE: Simian test subject</p><p>RESULTS: Devoured by specimen. No significant difference from last simian test.</p><p><em>Note: Time to amp it up</em></p><p>-</p><p>PROCEDURE: Human test subject (D-1). Instructed to \"pet it like a dog\"</p><p>RESULTS: Specimen and D-1 stare at each other for approximately two seconds. D-1 screams and begins pounding on observation window, begging to be released. Specimen pounces on D-1. Specimen kills D-1 with multiple slashes from its foreclaws.</p><p><em>Note: Promising!</em></p><p>-</p><p>PROCEDURE: Two human test subjects (D-2, D-3). Instructed to subdue specimen</p><p>RESULTS: D-2 and D-3 slowly approach specimen. D-3 punches specimen on forehead to no noticeable effect. Specimen pounces on D-3, then kills him with multiple slashes from its foreclaws. D-2 screams and begins pounding on observation window. Specimen pounces on D-2, then kills him with multiple slashes from its foreclaws.</p><p>Specimen begins slashing at observation access doors. Exhibiting an unexpected amount of strength, it is able to d~</p>"

/obj/item/paper/prison_station/interrogation_log
	name = "paper- 'Test Log'"
	desc = "This paper seems to have been crumpled up in dried blood, turning it nearly unreadable.";
	info = "<p style=\"text-align: center;\"><sub>INTERROGATION  LOG</sub></p><p>Person: (Withheld) 'Verdan' (Withheld)</p><BR>\n<p</p><p>PROCEDURE: Wringer Technique</p><p>RESULTS: Verdan bashes head around. Appears agitated and cries, perhaps angry. Heavy Vocalisations.</p><p>-</p><p>PROCEDURE: Shocking.</p><p>RESULTS: Cries and screams in anger. No significant difference from last procedure.</p><p><em>Note: Pain Tolerant, must increase pain.</em></p><p>-</p><p>PROCEDURE: Handy Man. Instructed to \"look.\" while saw performs its work.</p><p>RESULTS: Verdan stares for approximately three seconds. Verdan screams and begins trying to break the restraints while begging to be released. The saw finally completes its work. Verdan seems to be a blabbering mess.</p><p><em>Note: Promising!</em></p><p>-</p><p>PROCEDURE: Information Gathering.</p><p>RESULTS: Verdan starts giving out information about the other cells. </p><p>Verdan starts whispering from fatigue, have to sit closer. Verdan leans in closer to me, he~</p><em>(The remaining paper is splattered in blood and unreadable.)</em>";

/obj/item/paper/prison_station/monkey_note
	name = "paper- 'Note on simian test subjects'"
	info = "Keep an eye on the monkeys, and keep track of the numbers. We just found out that they can crawl through air vents and into the atmospheric system.<BR>\n<BR>\nI'd rather not have to explain to the Warden how the prisoners managed to acquire a new \"pet\". Again."

/obj/item/paper/prison_station/warden_note
	name = "paper- 'Final note'"
	info = "<p>Not much time left. Note to whoever may respond to the distress signal</p><p>Initially, there was a collision into the south high-security cellblock. We thought it was a pirate attack</p><p>It was, but something happened in the civilian residences. We were too tied up with the pirates to respond</p><p>Half the guards are dead. Most of the remainder not accounted for</p><p>Many likely trapped in yard when central lockdown activated.</p><p>Central lockdown will automatically lift at 12:50</p><p>Yard lockdown will not autom</p><p>something comes</p>"

/obj/item/paper/prison_station/chapel_program
	name = "paper= 'Chapel service program'"
	info = "\"And when he had opened the fourth seal, I heard the voice of the fourth beast say, Come and see.<BR>\n<BR>\nAnd I looked, and behold a pale horse: and his name that sat on him was Death, and Hell followed with him. And power was given unto them over the fourth part of the earth, to kill with sword, and with hunger, and with death, and with the beasts of the earth.\"<BR>\n<BR>\n<BR>\n<BR>\n\"Chaplain:  Lord, have mercy.   All:  Lord, have mercy.<BR>\nChaplain:  Christ, have mercy.  All:  Christ, have mercy.<BR>\nChaplain:  Lord, have mercy.   All:  Lord, have mercy.\"<BR>\n<BR>\n<BR>\n<BR>\n<em>These are the only two readable sections. The rest is covered in smears of blood.</em>"

/obj/item/paper/prison_station/inmate_handbook
	name = "paper= 'Inmate Rights, Privileges and Responsibilities'"
	info = "<p style=\"text-align: center;\"><sub>FIORINA ORBITAL PENITENTIARY</sub></p><p style=\"text-align: center;\"><sub>INMATE RIGHTS, PRIVILEGES AND RESPONSIBILITIES</sub></p><p>RIGHTS</p><p>As per the Corrections Act 2087, you have the right to the following:</p><p>1. You have the right to be treated impartially and fairly by all personnel.<BR>\n2. You have the right to be informed of the rules, procedures, and schedules.<BR>\n3. You have the right to freedom of religious affiliation and voluntary religious worship.<BR>\n4. You have the right to health care which includes meals, proper bedding and clothing and a laundry schedule for cleanliness of the same, an opportunity to shower regularly, proper ventilation for warmth and fresh air, a regular exercise period, toilet articles, medical, and dental treatment.</p><p>PRIVILEGES</p><p>You do NOT have the right to the following; these are privileges granted by the institution, and may be revoked at ANY time for ANY reason:</p><p>1. You may be granted the privilege to visitation and correspondence with family members and friends.<BR>\n2. You may be granted the privilege to reading materials for educational purposes and for your own enjoyment.<BR>\n3. You may be granted the privilege to limited personal money to purchase items from the prison store.</p><p>RESPONSIBILITIES</p><p>Inmates must fufill the following responsibilities:</p><p>1. You have the responsibility to know and abide by all rules, procedures, and schedules.<BR>\n2. You have the responsibility to obey any and all commands from personnel.<BR>\n3. You have the responsibility to recognize and respect the rights of other inmates.<BR>\n4. You have the responsibility to not waste food, to follow the laundry and shower schedule, maintain neat and clean living quarters, keep your area free of contraband, and seek medical and dental care as you may need it.<BR>\n5. You have the responsibility to conduct yourself properly during visits, not accept or pass contraband, and not violate the law or institution rules or institution guidelines through your correspondence.<BR>\n6. You have the responsibility to meet your financial obligations including, but not limited to, court imposed assessments, fines, and restitution.<BR>\n<B>7. You have the responsibility to coorporate with the Fiorina Orbital Penitentiary's Medical Research Department in any and all research studies.</B></p>"

/obj/item/paper/prison_station/pirate_note
	name = "paper= 'Captain's log'"
	info = "<p>We found him.</p><p>His location, anyway. Figures that he'd end up in the Fop, given our reputation.</p><p>As good an escape artist he is, he ain't getting out by himself. Too many security measures, and no way off without a ship. They're prepared for anything coming from inside.</p><p>They AREN'T prepared for a \"tramp freighter\" ramming straight through their hull.</p><p>Hang tight, Jack. We're coming for you."

/obj/item/paper/prison_station/pirate_note/clfship
	info = "<p>We're hit!</p><p>MAYDAY! MAYDAY! We have been hit by the -... .</p><p>We're on a planet somewhere, seems there is a colony to our south. Might head on over there and see if there is any USCM presence. Our ship is fucking busted beyond normal means of repair, still waiting for a damage assessment tho.</p><p>Coby and Ryan died today from their wounds... \"Fucking USCM.\" I'll have my revenge someday...</p><p>And the colonies will be freed one day from the oppressive regime of Wey-Yu and USCM henchmen."

/obj/item/paper/prison_station/nursery_rhyme
	info = "<p>Mary had a little lamb,<BR>\nits fleece was white as snow;<BR>\nAnd everywhere that Mary went,<BR>\nthe lamb was sure to go.</p><p>It followed her to school one day,<BR>\nwhich was against the rule;<BR>\nIt made the children laugh and play,<BR>\nto see a lamb at school.</p><p>And so the teacher turned it out,<BR>\nbut still it lingered near,<BR>\nAnd waited patiently about,<BR>\ntill Mary did appear.</p><p>\"Why does the lamb love Mary so?\"<BR>\nthe eager children cry;<BR>\n\"Why, Mary loves the lamb, you know\",<BR>\nthe teacher did reply."

/obj/item/paper/lv_624/cheese
	name = "paper= 'Note on the contents of the armory'"
	info = "<p>Seems the administrator had an extra shipment of cheese delivered in our last supply drop from Earth. We've got no space to store it in the main kitchen, and he wants it to \"age\" or something.</p><p>It's being kept in the armory for now, seems it has the right conditions. Anyway, apologies about the smell.</p><p> - Marshal Johnson"

/obj/item/paper/bigred/walls
	name = "crumpled note"
	info = "<b>there is cotten candy in the walls</b>"

/obj/item/paper/bigred/lambda
	name = "ripped diary entry"
	info = "Director Smith's Diary\nEntry Date: 15 December 2181\nToday, I've felt true progress! The XX-121 reproduction program is in full effect, and Administrator Cooper have given us the all clear to continue producing specimens. To think that all this is coming from just that first specimen, a single 'Queen' form... It's grown to almost 5 meters tall and shows no signs of ceasing egg production! These creatures will be the next Synthetic of our time, we'll show those Seegson bastards."

/obj/item/paper/bigred/union
	name = "Shaft miners union"
	info = "Today we have had enough of being underpaid and treated like shit for not reaching the higher up's unreasonable quotas of ore. They say this place has a \"sea of valuable ores,\" yet we have been mining for years and are yet to find a single diamond. We have had it, enough is enough. They think they can control everything we do, they thought wrong! We, the oppressed workers, shall rise up against the capitalist dogs in a mutiny and take back our pay by force. \n If they send their dogs here to bust us, we will kill each and every single one of them."

/obj/item/paper/bigred/finance
	name = "Important Finance Letter"
	info = "TO: JOSEPH BARNES, HEAD OF COLONY FINANCE \n FROM: AIDEN MENG, HEAD OF COLONY MINING \n When will we get additional funds to fix the mining robot. That robot could do a month's worth of work in a matter of hours! Yet we still have the same quotas that we had before it was broken. In fact, when will we get more funding at all? Most of my people are now going on 10 months without a single dollar from this work, and the few dollars we do have can barely keep this facility on its knees. \n When will research stop taking half of the colony's funds? Yes, I know they have some super secret W-Y corporate project, but in all honesty not a single word about that project has come out of the labs. Do you really want to trust a project you don’t even know about? \n Let me know ASAP if and when we may be getting funding. I am afraid I cannot keep their hopes up much longer... \n - Meng"

/obj/item/paper/bigred/smuggling
	name = "Folded note"
	info = "Alright Jeff, I know you still owe me after standing up for you when you got caught with a whole pill bottle of mindbreaker. Remember how I got you out of 15 years in the slammer? \n Anyways, I have a special task for you that you can do to repay me. \n <p> Whenever you unload a cargo container look for any crate with a blue hexagon on it. </p>  <p>Upon finding one, DO NOT OPEN it under ANY circumstances, and keep it away from anyone else. You then bring it to virology, specifically the back of the lobby where there is a hole into the caves. </p> \n <p> Then, leave it at the nearest crevice to the right and my men will take it. Should there be any backup, just stack it on top.</p> \n<p> Easy, right? Just moving cargo. If anyone asks what’s in it, it’s just power tools. </p> \n <p> Good luck, I'll slide you a few blunts of space weed that we have as a tip if you work well. </p>"
	color = "grey"

/obj/item/paper/bigred/witness
	name = "Journal of the witness"
	info = "Throughout history, humans have been fighting evil. Whether that be communists, slackers, liberals, assholes, or your boss, those evils are all eventually dealt with one way or another. <p> However, there is one that I have seen with my own eyes when I snuck into Lambda caves, an organism that reeks of so much evil that it immediately fills you with rage and terror. \n After I saw it, I realized the sheer insanity of this administration to even allow this monstrosity in our colony. \n Into... my colony ... my HOME for fucks sakes, and I have to LIVE with these chucklefuck bastards who are too blind by their idiocy and corporate percentages to even realise the evil that they have brought here."
	color = "green"
/obj/item/paper/bigred/them
	name = "THEM"
	color = "green"
	info = "<p>I can't fucking take it, I am fully convinced with ZERO doubt that the entire colony administration is controlled by THEM. Those fucking THINGs that are so outrageously evil that calling them monsters would be an insult to monsters.</p> <p> I get why they are hiding them now, because they are their actual masters. Controlling the will of the colony and threatening the entire human race.</p> \n <p> Those... things are not the experiments being experimented on by our scientists, but rather we are the experiments for THEM! </p> \n And they don't want anyone not controlled by them to know about it. I bet if everyone knew about it, the lambda secret labs would be burned to the ground within hours... if only there was a way we could do that..."

/obj/item/paper/bigred/crazy
	name = "THEY ARE COMING FOR ME"
	info = "Fuck man, I have tried and tried to tell people, from my co-workers and friends to anyone who would listen to me. Each and every single time I have been called crazy. <p> Then recently THEY took notice, and started sending their minions against me, almost everywhere i go outside of the caves, there is constantly a marshal on my ass, stalking me at least 30 feet away. They KNOW and they want me silenced or dead. </p> \n Then one day the head of security himself, Jim FUCKING Hamilton instructed me to stop \" spreading rumors \" or face consequences. <p> <b> No, I will not follow what a mere puppet wants me to do, a lap dog being controlled by THEM!</b>  </p> \n \n There is some hope, however. There is word going around of a mutiny at my workplace. The miners will rise up and forcibly take control of the administration, and their leader has agreed with me to investigate lambda and expose it once and for all!. <p> However, I can’t just leave them exposed with their twisted secrets uncovered. They’re too dangerous to be left alive and they are going to find some way to escape justice. When the mutiny happens, I will shoot my way through the security to find the thermobaric explosives that were mistakenly sent here, transport them amidst the chaos to the secret lab, and save the colony and ALL of humanity by obliterating it.  </p>"
	color = "green"

/obj/item/paper/bigred/final
	name = "Final entry"
	color = "green"
	info =  "<p> I could not do it, the fucking marshals, the minions of THEM, have gotten a whiff of my co-workers plans and started raiding us pre-emptively. We managed to get word of it and erected a few barricades to slow them down, but it is too late. Our plan, my plan to save humanity has turned to dust. </p> As I lay and write this, they are gassing the entire area with tear gas, while gunshots echo around the caves. \n  They have gotten to my mind already, their voices are... laughing, saying that, \" it's over \" and that \n “we have risen\". Their voices are mocking me as I could do nothing to prevent their rise \n Just as I am about to finish my final entry, I overhear a few panicked radio calls from a dead officer's radio, about a code red lambda breach, and \" X-RAYS OUT OF CONTAINMENT\". \n However, not a single one of their cries has been met with a response as their fellow officers are too preoccupied with beating up poor miners... \n <b> They have won.... they have PLANNED THIS all along.... </b> \n only God may save us now..."

/obj/item/paper/bigred/upp
	name = "UPP Orders"

/obj/item/paper/bigred/upp/Initialize(mapload, photo_list)
	. = ..()

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = "<center> <img src = [asset.get_url_mappings()["logo_upp.png"]]> <br> <b><small>Union Of Progressive People's Fourth Fleet</b></small> <br> <b><large>Orders For 173rd Airborne Reconnaissance: 2nd Platoon</large></b> <br> <small>No.52</small></center> <hr> <b>Order of Military Officer of the UPP</b><br><b>Kolonel <redacted> Ganbaatar </b><br><b>Commander of MV-35</b> <br> Date: 2182 <br> <b><large>On Special Mission<large></b>  <hr>  The actions of the hostile Weyland-Yutani corporation on the fringes of the Neroid sector have grown increasingly intolerable. However, evidence suggesting they are researching into the creation and deployment of some form of biological weapons program represent an unacceptable risk to the security of UPP interests in this sector. The risk of these items falling into UA/USCM hands is unacceptable. <br><br> Orders for the Boris squad of the 173rd Airborne Recon are as follows. Initiate airborne reconnaissance of WY colony Oxley's Buttle, Trijent Dam, location on planet Raijin  (UA Code: LV-670). Ascertain veracity of onsight biological weapons program. If positive confirmation of the weapons program is identified, authorization for rapid assault and recovery is granted. Avoid all contact with UA/USCM military forces, abort missions if UA/USCM forces are encountered. <hr><center><b>Authorizing Officer: Gaanbatar</b><br>Name and Rank: Kolonel </center>  <hr><small><i>FOR SANCTIONED USE ONLY</i></small>"

/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"

/obj/item/paper/crumpled/update_icon()
	return

/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"

/obj/item/paper/crumpled/bloody/csheet
	info = "<b>Character Sheet</b>\n\nKorbath the Barbarian\nLevel 6 Barbarian\nHitpoints: 47/93\nSTR: 18\nDEX: 14\nCON: 16\nINT: 8\nWIS: 11\nCHA: 15\n\n<B>Inventory:</b>\nGreatsword +3 \nChain M--\n\n\nThe rest of the page is covered in smears of blood."

/obj/item/paper/wy
	icon_state = "paper_wy"

/obj/item/paper/wy/Initialize(mapload, photo_list)
	. = ..()

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = "<center><img src = [asset.get_url_mappings()["logo_wy.png"]]></center><BR>\n<span class=\"paper_field\"></span>"

/obj/item/paper/uscm
	icon_state = "paper_uscm"

/obj/item/paper/uscm/Initialize(mapload, photo_list)
	. = ..()

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = "<center><img src = [asset.get_url_mappings()["logo_uscm.png"]]></center><BR>\n<span class=\"paper_field\"></span>"

/obj/item/paper/research_notes
	icon_state = "paper_wy_words"
	unacidable = TRUE
	var/datum/reagent/data
	var/tier
	var/note_type
	var/full_report
	var/grant

/obj/item/paper/research_notes/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/paper/research_notes/LateInitialize()
	. = ..()
	generate()

/obj/item/paper/research_notes/proc/generate()
	is_objective = TRUE
	if(!note_type)
		note_type = pick(prob(50);"synthesis",prob(35);"grant",prob(15);"test")
	var/datum/reagent/generated/C = data
	if(!C)
		var/random_chem
		if(tier)
			random_chem = pick(GLOB.chemical_gen_classes_list[tier])
		else
			if(note_type == "test")
				random_chem = pick(GLOB.chemical_gen_classes_list["T4"])
			else
				random_chem = pick( prob(55);pick(GLOB.chemical_gen_classes_list["T2"]),
									prob(30);pick(GLOB.chemical_gen_classes_list["T3"]),
									prob(15);pick(GLOB.chemical_gen_classes_list["T4"]))
		if(!random_chem)
			random_chem = pick(GLOB.chemical_gen_classes_list["T1"])
		C = GLOB.chemical_reagents_list["[random_chem]"]
	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	var/txt = "<center><img src = [asset.get_url_mappings()["logo_wy.png"]]><HR><I><B>Official Weyland-Yutani Document</B><BR>Experiment Notes</I><HR><H2>"
	switch(note_type)
		if("synthesis")
			var/datum/chemical_reaction/G = GLOB.chemical_reactions_list[C.id]
			name = "Synthesis of [C.name]"
			icon_state = "paper_wy_partial_report"
			txt += "[name] </H2></center>"
			txt += "During experiment <I>[pick("C","Q","V","W","X","Y","Z")][rand(100,999)][pick("a","b","c")]</I> the theorized compound identified as [C.name], was successfully synthesized using the following formula:<BR>\n<BR>\n"
			for(var/I in G.required_reagents)
				var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
				var/U = G.required_reagents[I]
				txt += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
			if(LAZYLEN(G.required_catalysts))
				txt += "<BR>\nWhile using the following catalysts: <BR>\n<BR>\n"
				for(var/I in G.required_catalysts)
					var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
					var/U = G.required_catalysts[I]
					txt += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
			if(full_report)
				txt += "<BR>The following properties have been discovered during tests:<BR><font size = \"2.5\">[C.description]\n"
				txt += "<BR>Overdoses at: [C.overdose] units</font><BR>\n"
				icon_state = "paper_wy_full_report"
			else
				txt += "<BR>\nTesting for chemical properties is currently pending.<BR>\n"
			var/is_volatile = FALSE
			if(C.chemfiresupp)
				is_volatile = TRUE
			else
				for(var/datum/chem_property/P in C.properties)
					if(P.volatile)
						is_volatile = TRUE
						break
			if(is_volatile)
				txt += "<BR><B>\nWARNING: UNSTABLE REAGENT. MIX CAREFULLY.</B><BR>\n"
			txt += "<BR>\n<HR> - <I>Weyland-Yutani</I>"
		if("test")
			name = "Experiment [pick("C","Q","V","W","X","Y","Z")][rand(100,999)][pick("a","b","c")]"
			icon_state = "paper_wy_synthesis"
			txt += "Note for [name]</H2></center>"
			txt += "Subject <I>[rand(10000,99999)]</I> experienced [pick(C.properties)] effects during testing of [C.name]. <BR>\nTesting for additional chemical properties is currently pending. <BR>\n"
			txt += "<BR>\n<HR> - <I>Weyland-Yutani</I>"
		if("grant")
			if(!grant)
				grant = rand(2,4)
			icon_state = "paper_wy_grant"
			name = "Research Grant"
			txt += "Weyland-Yutani Research Grant</H2></center>"
			txt += "Dear valued researcher. Weyland-Yutani has taken high interest of your recent scientific progress. To further support your work we have sent you this research grant of [grant] credits. Please scan at your local Weyland-Yutani research data terminal to receive the benefits.<BR>\n"
			txt += "<BR>\n<HR> - <I>Weyland-Yutani</I>"
	info = txt

/obj/item/paper/research_notes/bad
	note_type = "synthesis"
	tier = "T1"

/obj/item/paper/research_notes/decent
	note_type = "synthesis"
	tier = "T2"
	full_report = TRUE

/obj/item/paper/research_notes/good
	note_type = "synthesis"
	full_report = TRUE

/obj/item/paper/research_notes/good/Initialize()
	var/list/L = list("T3", "T4")
	tier = pick(L)
	. = ..()

/obj/item/paper/research_notes/unique
	note_type = "synthesis"
	full_report = TRUE
	var/gen_tier

/obj/item/paper/research_notes/unique/tier_one
	gen_tier = 1

/obj/item/paper/research_notes/unique/tier_two
	gen_tier = 2

/obj/item/paper/research_notes/unique/tier_three
	gen_tier = 3

/obj/item/paper/research_notes/unique/tier_four
	gen_tier = 4

/obj/item/paper/research_notes/unique/tier_five
	gen_tier = 5

/obj/item/paper/research_notes/unique/Initialize()
	//Each one of these get a new unique chem
	var/datum/reagent/generated/C = new /datum/reagent/generated
	C.id = "tau-[length(GLOB.chemical_gen_classes_list["tau"])]"
	C.generate_name()
	C.chemclass = CHEM_CLASS_RARE
	if(gen_tier)
		C.gen_tier = gen_tier
	else
		C.gen_tier = GLOB.chemical_data.clearance_level
	C.generate_stats()
	GLOB.chemical_gen_classes_list["tau"] += C.id //Because each unique_vended should be unique, we do not save the chemclass anywhere but in the tau list
	GLOB.chemical_reagents_list[C.id] = C
	C.generate_assoc_recipe()
	data = C
	msg_admin_niche("New reagent with id [C.id], name [C.name], level [C.gen_tier], generated and printed at [loc] [ADMIN_JMP(loc)].")
	. = ..()

/obj/item/paper/research_notes/grant
	note_type = "grant"

/obj/item/paper/research_notes/grant/high
	note_type = "grant"
	grant = 4

/obj/item/paper/research_report
	icon_state = "paper_wy_words"
	var/datum/reagent/data
	var/completed = FALSE

/obj/item/paper/research_report/proc/generate(datum/reagent/S, info_only = FALSE)
	if(!S)
		return
	info += "<B>ID:</B> <I>[S.name]</I><BR><BR>\n"
	info += "<B>Database Details:</B><BR>\n"
	if(S.chemclass >= CHEM_CLASS_ULTRA)
		if(GLOB.chemical_data.clearance_level >= S.gen_tier || info_only)
			info += "<I>The following information relating to [S.name] is restricted with a level [S.gen_tier] clearance classification.</I><BR>"
			info += "<font size = \"2.5\">[S.description]\n"
			info += "<BR>Overdoses at: [S.overdose] units\n"
			info += "<BR>Standard duration multiplier of [REAGENTS_METABOLISM/S.custom_metabolism]x</font><BR>\n"
			completed = TRUE
			icon_state = "paper_wy_full_report"
		else
			info += "CLASSIFIED:<I> Clearance level [S.gen_tier] required to read the database entry.</I><BR>\n"
			icon_state = "paper_wy_partial_report"
	else if(S.chemclass == CHEM_CLASS_SPECIAL && !GLOB.chemical_data.clearance_x_access && !info_only)
		info += "CLASSIFIED:<I> Clearance level <B>X</B> required to read the database entry.</I><BR>\n"
		icon_state = "paper_wy_partial_report"
	else if(S.description)
		info += "<font size = \"2.5\">[S.description]\n"
		info += "<BR>Overdoses at: [S.overdose] units\n"
		info += "<BR>Standard duration multiplier: [REAGENTS_METABOLISM/S.custom_metabolism]x</font><BR>\n"
		completed = TRUE
		icon_state = "paper_wy_full_report"
	else
		info += "<I>No details on this reagent could be found in the database.</I><BR>\n"
		icon_state = "paper_wy_synthesis"
	if(S.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[S.id] && !info_only)
		info += "<BR><I>Saved emission spectrum of [S.name] to the database.</I><BR>\n"
	info += "<BR><B>Composition Details:</B><BR>\n"
	if(GLOB.chemical_reactions_list[S.id])
		var/datum/chemical_reaction/C = GLOB.chemical_reactions_list[S.id]
		for(var/I in C.required_reagents)
			var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
			if(R.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[R.id] && !info_only)
				info += "<font size = \"2\"><I> - Unknown emission spectrum</I></font><BR>\n"
				completed = FALSE
			else
				var/U = C.required_reagents[I]
				info += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
		if(LAZYLEN(C.required_catalysts))
			info += "<BR>Reaction would require the following catalysts:<BR>\n"
			for(var/I in C.required_catalysts)
				var/datum/reagent/R = GLOB.chemical_reagents_list["[I]"]
				if(R.chemclass >= CHEM_CLASS_SPECIAL && !GLOB.chemical_data.chemical_identified_list[R.id] && !info_only)
					info += "<font size = \"2\"><I> - Unknown emission spectrum</I></font><BR>\n"
					completed = FALSE
				else
					var/U = C.required_catalysts[I]
					info += "<font size = \"2\"><I> - [U] [R.name]</I></font><BR>\n"
	else if(GLOB.chemical_gen_classes_list["C1"].Find(S.id))
		info += "<font size = \"2\"><I> - [S.name]</I></font><BR>\n"
	else
		info += "<I>ERROR: Unable to analyze emission spectrum of sample.</I>" //A reaction to make this doesn't exist, so this is our IC excuse
		completed = FALSE

	if(info_only)
		completed = TRUE
	else
		if(!S.properties) //Safety for empty reagents
			completed = FALSE
		if(S.chemclass == CHEM_CLASS_SPECIAL && GLOB.chemical_data.clearance_x_access)
			completed = TRUE

	data = S

/obj/item/paper/incident
	name = "incident report"
	icon_state = "paper_uscm_words"
	var/datum/crime_incident/incident

/obj/item/paper/incident/Initialize()
	. = ..()
	var/template = {"\[center\]\[uscm\]\[/center\]
		\[center\]\[b\]\[i\]Encoded USCM Incident Report\[/b\]\[/i\]\[hr\]
		\[small\]FOR USE BY MP'S ONLY\[/small\]\[br\]
		\[barcode\]\[/center\]"}
	info = parsepencode(template, null, null, FALSE)
	update_icon()

/obj/item/paper/incident/Destroy()
	incident = null

	. = ..()


/obj/item/paper/fingerprint
	name = "fingerprint report"
	icon_state = "paper_uscm_words"

//Passing second parameter and using default constructor can cause blockade on paper initialization until resource is deleted
/obj/item/paper/fingerprint/Initialize(mapload, list/prints)
	// To not block initialization construct object like below
	. = ..(mapload)
	var/template = {"\[center\]\[uscm\]\[/center\]"}

	var/i = 0
	for(var/obj/effect/decal/prints/print_set in prints)
		i++
		template += {"\[center\]\[b\]\[i\]Fingerprint Sample #[i]\[/b\]\[/i\]\[hr\]
		\[small\]
		Name: [print_set.criminal_name]\[br\]
		Rank: [print_set.criminal_rank]\[br\]
		Squad: [print_set.criminal_squad]\[br\]
		Description: [print_set.description]\[br\]
		\[/small\]
		\[/center\]
		\[br\]"}

	info = parsepencode(template, null, null, FALSE)
	update_icon()


/obj/item/paper/personalrecord
	name = "personal record"
	icon_state = "paper_uscm_words"

//Passing second parameter and using default constructor can cause blockade on paper initialization until resource is deleted
/obj/item/paper/personalrecord/Initialize(mapload, datum/data/record/general_record, datum/data/record/security_record)
	// To not block initialization construct object like below
	. = ..(mapload)
	var/template = {"\[center\]\[uscm\]\[/center\]"}

	template += {"\[center\]\[b\]Personal Record\[/b\]\[/center\]"}

	if(general_record)
		template += {"
		Name: [general_record.fields["name"]]\[br\] `
		ID: [general_record.fields["id"]]\[br\]
		Sex: [general_record.fields["sex"]]\[br\]
		Age: [general_record.fields["age"]]\[br\]
		Rank: [general_record.fields["rank"]]\[br\]
		Physical Status: [general_record.fields["p_stat"]]\[br\]
		Mental Status: [general_record.fields["m_stat"]]\[br\]
		Criminal Status: [general_record.fields["criminal"]]\[br\]
		"}

		if (security_record)
			template += {"\[center\]\[b\]Security Data\[/b\]\[/center\]"}
			template += {"Incidents: [security_record.fields["incident"]]\[br\]"}
			template += {"\[center\]\[b\]Comments and Logs\[/b\]\[/center\]"}

			if(islist(security_record.fields["comments"]) || length(security_record.fields["comments"]) > 0)
				for(var/com_i in security_record.fields["comments"])
					var/comment = security_record.fields["comments"][com_i]
					// What a wacky and jolly creation
					// its derived from //? text("<b>[] / [] ([])</b><br />", comment["created_at"], comment["created_by"]["name"], comment["created_by"]["rank"])
					var/comment_markup = "\[b\][comment["created_at"]] / [comment["created_by"]["name"]] \[/b\] ([comment["created_by"]["rank"]])\[br\]"
					if (isnull(comment["deleted_by"]))
						comment_markup += "[comment["entry"]]"
					else
						comment_markup += "\[i\]Comment deleted by [comment["deleted_by"]] at [comment["deleted_at"]]\[/i\]"
					template += {"[comment_markup]\[br\]\[br\]"}
			else
				template += {"\[b\]No comments\[/b\]\[br\]"}
		else
			template += {"\[b\]Security Record Lost!\[/b\]\[br\]"}

	info = parsepencode(template, null, null, FALSE)
	update_icon()

#undef MAX_FIELDS

/obj/item/paper/colonial_grunts
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "paper_stack_words"
	name = "Colonial Space Grunts"
	desc = "A tabletop game based around the USCM, easy to get into, simple to play, and most inportantly fun for the whole squad."

/obj/item/paper/colonial_grunts/Initialize(mapload, photo_list)
	..()
	return INITIALIZE_HINT_ROUNDSTART

/obj/item/paper/colonial_grunts/LateInitialize()
	. = ..()
	info = "<div> <img style='align:middle' src='[SSassets.transport.get_asset_url("colonialspacegruntsEZ.png")]'>"

/obj/item/paper/colonial_grunts/update_icon()
	return // Keep original icon_state

/obj/item/paper/liaison_brief
	name = "Liaison Colony Briefing"
	desc = "A brief from the Company about the colony the ship is responding to."
	icon_state = "paper_wy_words"

	var/placeholder = "maps/map_briefings/cl_brief_placeholder.html"

/obj/item/paper/liaison_brief/Initialize(mapload, ...)
	. = ..()
	if(SSmapping.configs[GROUND_MAP].liaison_briefing)
		info = file2text(SSmapping.configs[GROUND_MAP].liaison_briefing)
	else
		info = file2text(placeholder)

	var/datum/asset/asset = get_asset_datum(/datum/asset/simple/paper)
	info = replacetext(info, "%%WYLOGO%%", asset.get_url_mappings()["logo_wy.png"])
