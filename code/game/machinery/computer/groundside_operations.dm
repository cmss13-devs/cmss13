#define COMMAND_SQUAD "Command"

/obj/structure/machinery/computer/groundside_operations
	name = "groundside operations console"
	desc = "This can be used for various important functions."
	icon_state = "comm"
	req_access = list(ACCESS_MARINE_SENIOR)
	unslashable = TRUE
	unacidable = TRUE

	var/obj/structure/machinery/camera/cam = null
	var/datum/squad/current_squad = null

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	var/is_announcement_active = TRUE
	var/announcement_title = COMMAND_ANNOUNCE
	var/announcement_faction = FACTION_MARINE
	var/add_pmcs = TRUE
	var/lz_selection = TRUE
	var/has_squad_overwatch = TRUE
	var/faction = FACTION_MARINE
	var/show_command_squad = FALSE

/obj/structure/machinery/computer/groundside_operations/Initialize()
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(disable_pmc))
	if(announcement_faction == FACTION_MARINE)
		tacmap = new /datum/tacmap/drawing(src, minimap_type)
	else
		tacmap = new(src, minimap_type) // Non-drawing version

	return ..()

/obj/structure/machinery/computer/groundside_operations/Destroy()
	QDEL_NULL(tacmap)
	QDEL_NULL(cam)
	current_squad = null
	return ..()

/obj/structure/machinery/computer/groundside_operations/proc/disable_pmc()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		add_pmcs = FALSE
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/structure/machinery/computer/groundside_operations/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/groundside_operations/attack_hand(mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	ui_interact(user)

/obj/structure/machinery/computer/groundside_operations/ui_interact(mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Groundside Operations Console</title></head><body>"
	dat += "<BR><A HREF='?src=\ref[src];operation=announce'>[is_announcement_active ? "Make An Announcement" : "*Unavailable*"]</A>"
	dat += "<BR><A href='?src=\ref[src];operation=mapview'>Tactical Map</A>"
	dat += "<BR><hr>"
	var/datum/squad/marine/echo/echo_squad = locate() in GLOB.RoleAuthority.squads
	if(!echo_squad.active && faction == FACTION_MARINE)
		dat += "<BR><A href='?src=\ref[src];operation=activate_echo'>Designate Echo Squad</A>"
		dat += "<BR><hr>"

	if(lz_selection && SSticker.mode && (isnull(SSticker.mode.active_lz) || isnull(SSticker.mode.active_lz.loc)))
		dat += "<BR><A href='?src=\ref[src];operation=selectlz'>Designate Primary LZ</A><BR>"
		dat += "<BR><hr>"

	if(has_squad_overwatch)
		if(show_command_squad)
			dat += "Current Squad: <A href='?src=\ref[src];operation=pick_squad'>Command</A><BR>"
		else
			dat += "Current Squad: <A href='?src=\ref[src];operation=pick_squad'>[!isnull(current_squad) ? "[current_squad.name]" : "----------"]</A><BR>"
		if(current_squad || show_command_squad)
			dat += get_overwatch_info()

	dat += "<BR><A HREF='?src=\ref[user];mach_close=groundside_operations'>Close</A>"
	show_browser(user, dat, name, "groundside_operations", "size=600x700")
	onclose(user, "groundside_operations")

/obj/structure/machinery/computer/groundside_operations/proc/get_overwatch_info()
	var/dat = ""
	dat += {"
	<script type="text/javascript">
		function updateSearch() {
			var filter_text = document.getElementById("filter");
			var filter = filter_text.value.toLowerCase();

			var marine_list = document.getElementById("marine_list");
			var ltr = marine_list.getElementsByTagName("tr");

			for(var i = 0; i < ltr.length; ++i) {
				try {
					var tr = ltr\[i\];
					tr.style.display = '';
					var ltd = tr.getElementsByTagName("td")
					var name = ltd\[0\].innerText.toLowerCase();
					var role = ltd\[1\].innerText.toLowerCase()
					if(name.indexOf(filter) == -1 && role.indexOf(filter) == -1) {
						tr.style.display = 'none';
					}
				} catch(err) {}
			}
		}
	</script>
	"}

	if(show_command_squad)
		dat += format_list_of_marines(list(GLOB.marine_leaders[JOB_CO], GLOB.marine_leaders[JOB_XO]) + GLOB.marine_leaders[JOB_SO], list(JOB_CO, JOB_XO, JOB_SO))
	else if(current_squad)
		dat += format_list_of_marines(current_squad.marines_list, list(JOB_SQUAD_LEADER, JOB_SQUAD_SPECIALIST, JOB_SQUAD_MEDIC, JOB_SQUAD_ENGI, JOB_SQUAD_SMARTGUN, JOB_SQUAD_MARINE))
	else
		dat += "No Squad selected!<BR>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	return dat

/obj/structure/machinery/computer/groundside_operations/proc/format_list_of_marines(list/mob/living/carbon/human/marine_list, list/jobs_in_order)
	var/dat = ""
	var/list/job_order = list()

	for(var/job in jobs_in_order)
		job_order[job] = ""

	var/misc_text = ""

	var/living_count = 0
	var/almayer_count = 0
	var/SSD_count = 0
	var/helmetless_count = 0
	var/total_count = 0

	for(var/X in marine_list)
		if(!X)
			continue //just to be safe
		total_count++
		var/mob_name = "unknown"
		var/mob_state = ""
		var/role = "unknown"
		var/area_name = "<b>???</b>"
		var/mob/living/carbon/human/H
		var/act_sl = ""
		if(ishuman(X))
			H = X
			mob_name = H.real_name
			var/area/A = get_area(H)
			var/turf/M_turf = get_turf(H)
			if(A)
				area_name = sanitize_area(A.name)

			var/obj/item/card/id/card = H.get_idcard()
			if(H.job)
				role = H.job
			else if(card?.rank) //decapitated marine is mindless,
				role = card.rank

			switch(H.stat)
				if(CONSCIOUS)
					mob_state = "Conscious"
					living_count++
				if(UNCONSCIOUS)
					mob_state = "<b>Unconscious</b>"
					living_count++
				else
					continue

			if(!is_ground_level(M_turf.z))
				almayer_count++
				continue

			if(!istype(H.head, /obj/item/clothing/head/helmet/marine))
				helmetless_count++
				continue

			if(!H.key || !H.client)
				SSD_count++
				continue
			if(current_squad)
				if(H == current_squad.squad_leader && role != JOB_SQUAD_LEADER)
					act_sl = " (ASL)"
		var/marine_infos = "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td></tr>"
		if(role in job_order)
			job_order[role] += marine_infos
		else
			misc_text += marine_infos
	dat += "<b>Total: [total_count] Deployed</b><BR>"
	dat += "<b>Marines detected: [living_count] ([helmetless_count] no helmet, [SSD_count] SSD, [almayer_count] on Almayer)</b><BR>"
	dat += "<center><b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'></center>"
	dat += "<table id='marine_list' border='2px' style='width: 100%; border-collapse: collapse;' align='center'><tr>"
	dat += "<th>Name</th><th>Role</th><th>State</th><th>Location</th></tr>"
	for(var/job in job_order)
		dat += job_order[job]
	dat += misc_text
	dat += "</table>"
	return dat

/obj/structure/machinery/computer/groundside_operations/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)
	switch(href_list["operation"])

		if("mapview")
			tacmap.tgui_interact(usr)
			return

		if("announce")
			var/mob/living/carbon/human/human_user = usr
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			var/bio_fail = FALSE
			if(!istype(idcard))
				idcard = human_user.get_idcard()
			if(!idcard)
				bio_fail = TRUE
			else if(!idcard.check_biometrics(human_user))
				bio_fail = TRUE
			if(bio_fail)
				to_chat(human_user, SPAN_WARNING("Biometrics failure! You require an authenticated ID card to perform this action!"))
				return FALSE

			if(usr.client.prefs.muted & MUTE_IC)
				to_chat(usr, SPAN_DANGER("You cannot send Announcements (muted)."))
				return

			if(!is_announcement_active)
				to_chat(usr, SPAN_WARNING("Please allow at least [COOLDOWN_COMM_MESSAGE*0.1] second\s to pass between announcements."))
				return FALSE
			if(announcement_faction != FACTION_MARINE && usr.faction != announcement_faction)
				to_chat(usr, SPAN_WARNING("Access denied."))
				return
			var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "")
			if(!input || !is_announcement_active || !(usr in dview(1, src)))
				return FALSE

			is_announcement_active = FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.get_idcard()
				if(id)
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, announcement_title, faction_to_display = announcement_faction, add_PMCs = add_pmcs, signature = signed)
			addtimer(CALLBACK(src, PROC_REF(reactivate_announcement), usr), COOLDOWN_COMM_MESSAGE)
			message_admins("[key_name(usr)] has made a command announcement.")
			log_announcement("[key_name(usr)] has announced the following: [input]")

		if("award")
			open_medal_panel(usr, src)

		if("selectlz")
			if(SSticker.mode.active_lz)
				return
			var/lz_choices = list("lz1", "lz2")
			var/new_lz = tgui_input_list(usr, "Select primary LZ", "LZ Select", lz_choices)
			if(!new_lz)
				return
			if(new_lz == "lz1")
				SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz1))
			else
				SSticker.mode.select_lz(locate(/obj/structure/machinery/computer/shuttle/dropship/flight/lz2))

		if("pick_squad")
			var/list/squad_list = list()
			for(var/datum/squad/S in GLOB.RoleAuthority.squads)
				if(S.active && S.faction == faction)
					squad_list += S.name
			squad_list += COMMAND_SQUAD

			var/name_sel = tgui_input_list(usr, "Which squad would you like to look at?", "Pick Squad", squad_list)
			if(!name_sel)
				return

			if(name_sel == COMMAND_SQUAD)
				show_command_squad = TRUE
				current_squad = null

			else
				show_command_squad = FALSE

				var/datum/squad/selected = get_squad_by_name(name_sel)
				if(selected)
					current_squad = selected
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")

		if("use_cam")
			if(isRemoteControlling(usr))
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Unable to override console camera viewer. Track with camera instead. ")]")
				return

			if(current_squad || show_command_squad)
				var/mob/cam_target = locate(href_list["cam_target"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Searching for helmet cam. No helmet cam found for this marine! Tell your squad to put their helmets on!")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Stopping helmet cam view of [cam_target].")]")
					usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = null
					usr.reset_view(null)
				else if(usr.client.view != GLOB.world_view_size)
					to_chat(usr, SPAN_WARNING("You're too busy peering through binoculars."))
				else
					if(cam)
						usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = new_cam
					usr.reset_view(cam)
					usr.RegisterSignal(cam, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, reset_observer_view_on_deletion))

		if("activate_echo")
			var/mob/living/carbon/human/human_user = usr
			var/obj/item/card/id/idcard = human_user.get_active_hand()
			var/bio_fail = FALSE
			if(!istype(idcard))
				idcard = human_user.get_idcard()
			if(!idcard)
				bio_fail = TRUE
			else if(!idcard.check_biometrics(human_user))
				bio_fail = TRUE
			if(bio_fail)
				to_chat(human_user, SPAN_WARNING("Biometrics failure! You require an authenticated ID card to perform this action!"))
				return FALSE

			var/reason = strip_html(input(usr, "What is the purpose of Echo Squad?", "Activation Reason"))
			if(!reason)
				return
			if(alert(usr, "Confirm activation of Echo Squad for [reason]", "Confirm Activation", "Yes", "No") != "Yes") return
			var/datum/squad/marine/echo/echo_squad = locate() in GLOB.RoleAuthority.squads
			if(!echo_squad)
				visible_message(SPAN_BOLDNOTICE("ERROR: Unable to locate Echo Squad database."))
				return
			echo_squad.engage_squad(TRUE)
			message_admins("[key_name(usr)] activated Echo Squad for '[reason]'.")

		if("refresh")
			attack_hand(usr)

	updateUsrDialog()

/obj/structure/machinery/computer/groundside_operations/proc/reactivate_announcement(mob/user)
	is_announcement_active = TRUE
	updateUsrDialog()

/obj/structure/machinery/computer/groundside_operations/on_unset_interaction(mob/user)
	..()

	if(!isRemoteControlling(user))
		if(cam)
			user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
		cam = null
		user.reset_view(null)

//returns the helmet camera the human is wearing
/obj/structure/machinery/computer/groundside_operations/proc/get_camera_from_target(mob/living/carbon/human/H)
	if(current_squad || show_command_squad)
		if(H && istype(H) && istype(H.head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/helm = H.head
			return helm.camera

/obj/structure/machinery/computer/groundside_operations/upp
	announcement_title = UPP_COMMAND_ANNOUNCE
	announcement_faction = FACTION_UPP
	add_pmcs = FALSE
	lz_selection = FALSE
	has_squad_overwatch = FALSE
	minimap_type = MINIMAP_FLAG_UPP

/obj/structure/machinery/computer/groundside_operations/clf
	announcement_title = CLF_COMMAND_ANNOUNCE
	announcement_faction = FACTION_CLF
	add_pmcs = FALSE
	lz_selection = FALSE
	has_squad_overwatch = FALSE
	minimap_type = MINIMAP_FLAG_CLF

/obj/structure/machinery/computer/groundside_operations/pmc
	announcement_title = PMC_COMMAND_ANNOUNCE
	announcement_faction = FACTION_PMC
	lz_selection = FALSE
	has_squad_overwatch = FALSE
	minimap_type = MINIMAP_FLAG_PMC

/obj/structure/machinery/computer/groundside_operations/arc
	icon = 'icons/obj/vehicles/interiors/arc.dmi'
	icon_state = "groundsideop_computer"

#undef COMMAND_SQUAD
