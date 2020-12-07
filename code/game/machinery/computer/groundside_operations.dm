#define COOLDOWN_COMM_MESSAGE MINUTES_1

/obj/structure/machinery/computer/groundside_operations
	name = "groundside operations console"
	desc = "This can be used for various important functions."
	icon_state = "comm"
	req_access = list(ACCESS_MARINE_COMMANDER)
	unslashable = TRUE
	unacidable = TRUE

	var/mob/living/carbon/human/current_mapviewer

	var/obj/structure/machinery/camera/cam = null
	var/datum/squad/current_squad = null

	var/is_announcement_active = TRUE

/obj/structure/machinery/computer/groundside_operations/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/groundside_operations/attack_hand(var/mob/user as mob)
	if(..() || !allowed(user) || inoperable())
		return

	ui_interact(user)

/obj/structure/machinery/computer/groundside_operations/ui_interact(var/mob/user as mob)
	user.set_interaction(src)

	var/dat = "<head><title>Groundside Operations Console</title></head><body>"
	dat += "<BR><A HREF='?src=\ref[src];operation=announce'>[is_announcement_active ? "Make an announcement" : "*Unavaliable*"]</A>"
	dat += "<BR><A href='?src=\ref[src];operation=mapview'>Tactical Map</A>"
	dat += "<BR><hr>"

	if(SSticker.mode && (isnull(SSticker.mode.active_lz) || isnull(SSticker.mode.active_lz.loc)))
		dat += "<BR>Primary LZ <BR><A HREF='?src=\ref[src];operation=selectlz'>Select primary LZ</A>"
		dat += "<BR><hr>"

	dat += "Current Squad: <A href='?src=\ref[src];operation=pick_squad'>[!isnull(current_squad) ? "[current_squad.name]" : "----------"]</A><BR>"
	if(current_squad)
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

	if(!current_squad)
		dat += "No Squad selected!<BR>"
	else
		var/leader_text = ""
		var/spec_text = ""
		var/medic_text = ""
		var/engi_text = ""
		var/smart_text = ""
		var/marine_text = ""
		var/misc_text = ""
		var/living_count = 0
		var/almayer_count = 0
		var/SSD_count = 0
		var/helmetless_count = 0

		for(var/X in current_squad.marines_list)
			if(!X)
				continue //just to be safe
			var/mob_name = "unknown"
			var/mob_state = ""
			var/role = "unknown"
			var/act_sl = ""
			var/area_name = "<b>???</b>"
			var/mob/living/carbon/human/H
			if(ishuman(X))
				H = X
				mob_name = H.real_name
				var/area/A = get_area(H)
				var/turf/M_turf = get_turf(H)
				if(A)
					area_name = sanitize(A.name)

				if(H.job)
					role = H.job
				else if(istype(H.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
					var/obj/item/card/id/ID = H.wear_id		//we use their ID to get their role.
					if(ID.rank)
						role = ID.rank

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

			var/marine_infos = "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td></tr>"
			switch(role)
				if(JOB_SQUAD_LEADER)
					leader_text += marine_infos
				if(JOB_SQUAD_SPECIALIST)
					spec_text += marine_infos
				if(JOB_SQUAD_MEDIC)
					medic_text += marine_infos
				if(JOB_SQUAD_ENGI)
					engi_text += marine_infos
				if(JOB_SQUAD_SMARTGUN)
					smart_text += marine_infos
				if(JOB_SQUAD_MARINE)
					marine_text += marine_infos
				else
					misc_text += marine_infos

		dat += "<b>Total: [current_squad.marines_list.len] Deployed</b><BR>"
		dat += "<b>Marines detected: [living_count] ([helmetless_count] no helmet, [SSD_count] SSD, [almayer_count] on Almayer)</b><BR>"
		dat += "<center><b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'></center>"
		dat += "<table id='marine_list' border='2px' style='width: 100%; border-collapse: collapse;' align='center'><tr>"
		dat += "<th>Name</th><th>Role</th><th>State</th><th>Location</th></tr>"
		dat += leader_text + spec_text + medic_text + engi_text + smart_text + marine_text + misc_text
		dat += "</table>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	return dat

/obj/structure/machinery/computer/groundside_operations/proc/update_mapview(var/close = 0)
	if (current_mapviewer && !Adjacent(current_mapviewer) || close)
		close_browser(current_mapviewer, "marineminimap")
		current_mapviewer = null
		return

	if(!istype(marine_mapview_overlay_5))
		overlay_marine_mapview()

	current_mapviewer << browse_rsc(marine_mapview_overlay_5, "marine_minimap.png")

	show_browser(current_mapviewer, "<img src=marine_minimap.png>", "Marine Minimap", "marineminimap", "size=[(map_sizes[1][1]*2)+50]x[(map_sizes[1][2]*2)+50]")
	onclose(current_mapviewer, "marineminimap", src)

/obj/structure/machinery/computer/groundside_operations/Topic(href, href_list)
	if(..())
		return FALSE

	usr.set_interaction(src)

	if (href_list["close"] && current_mapviewer)
		close_browser(current_mapviewer, "marineminimap")
		current_mapviewer = null
		return

	switch(href_list["operation"])
		if("mapview")
			if(current_mapviewer)
				update_mapview(TRUE)
				return
			current_mapviewer = usr
			update_mapview()
			return

		if("announce")
			if(!is_announcement_active)
				to_chat(usr, SPAN_WARNING("Please allow at least [COOLDOWN_COMM_MESSAGE*0.1] second\s to pass between announcements."))
				return FALSE
			var/input = stripped_multiline_input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "")
			if(!input || !is_announcement_active || !(usr in view(1,src)))
				return FALSE

			is_announcement_active = FALSE

			var/signed = null
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				var/obj/item/card/id/id = H.wear_id
				if(istype(id))
					var/paygrade = get_paygrades(id.paygrade, FALSE, H.gender)
					signed = "[paygrade] [id.registered_name]"

			marine_announcement(input, signature = signed)
			addtimer(CALLBACK(GLOBAL_PROC, .proc/message_staff, "[key_name(usr)] has announced the following: [input]"), 20)
			addtimer(CALLBACK(src, .proc/reactivate_announcement, usr), COOLDOWN_COMM_MESSAGE)
			log_announcement("[key_name(usr)] has announced the following: [input]")

		if("award")
			if(usr.job != "Commanding Officer")
				to_chat(usr, SPAN_WARNING("Only the Commanding Officer can award medals."))
				return

			if(give_medal_award(loc))
				visible_message(SPAN_NOTICE("[src] prints a medal."))

		if("selectlz")
			if(SSticker.mode.active_lz)
				return
			var/lz_choices = list()
			for(var/obj/structure/machinery/computer/shuttle_control/console in machines)
				if(is_ground_level(console.z) && !console.onboard && console.shuttle_type == SHUTTLE_DROPSHIP)
					lz_choices += console
			var/new_lz = input(usr, "Choose the primary LZ for this operation", "Operation Staging")  as null|anything in lz_choices
			if(new_lz)
				SSticker.mode.select_lz(new_lz)

		if("pick_squad")
			var/list/squad_list = list()
			for(var/datum/squad/S in RoleAuthority.squads)
				if(S.usable)
					squad_list += S.name

			var/name_sel = input("Which squad would you like to look at?") as null|anything in squad_list
			if(!name_sel)
				return

			var/datum/squad/selected = get_squad_by_name(name_sel)
			if(selected)
				current_squad = selected
			else
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")

		if("use_cam")
			if(isRemoteControlling(usr))
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Unable to override console camera viewer. Track with camera instead. ")]")
				return

			if(current_squad)
				var/mob/cam_target = locate(href_list["cam_target"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Searching for helmet cam. No helmet cam found for this marine! Tell your squad to put their helmets on!")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Stopping helmet cam view of [cam_target].")]")
					cam = null
					usr.reset_view(null)
				else if(usr.client.view != world_view_size)
					to_chat(usr, SPAN_WARNING("You're too busy peering through binoculars."))
				else
					cam = new_cam
					usr.reset_view(cam)

		if("refresh")
			attack_hand(usr)

	updateUsrDialog()

/obj/structure/machinery/computer/groundside_operations/proc/reactivate_announcement(var/mob/user)
	is_announcement_active = TRUE
	updateUsrDialog()

/obj/structure/machinery/computer/groundside_operations/on_unset_interaction(mob/user)
	..()

	if(!isRemoteControlling(user))
		cam = null
		user.reset_view(null)

//returns the helmet camera the human is wearing
/obj/structure/machinery/computer/groundside_operations/proc/get_camera_from_target(mob/living/carbon/human/H)
	if(current_squad)
		if(H && istype(H) && istype(H.head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/helm = H.head
			return helm.camera

#undef COOLDOWN_COMM_MESSAGE
