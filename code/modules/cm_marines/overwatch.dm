#define HIDE_ALMAYER 2
#define HIDE_GROUND 1
#define HIDE_NONE 0

/obj/structure/machinery/computer/overwatch
	name = "Overwatch Console"
	desc = "State of the art machinery for giving orders to a squad."
	icon_state = "dummy"
	req_access = list(ACCESS_MARINE_BRIDGE)
	unacidable = TRUE

	var/mob/living/carbon/human/current_mapviewer = null
	var/datum/squad/current_squad = null
	var/state = 0
	var/obj/structure/machinery/camera/cam = null
	var/list/network = list("Overwatch")
	var/x_supply = 0
	var/y_supply = 0
	var/x_bomb = 0
	var/y_bomb = 0
	var/living_marines_sorting = FALSE
	var/busy = 0 //The overwatch computer is busy launching an OB/SB, lock controls
	var/dead_hidden = FALSE //whether or not we show the dead marines in the squad
	var/z_hidden = 0 //which z level is ignored when showing marines.
	var/marine_filter = list() // individual marine hiding control - list of string references
	var/marine_filter_enabled = TRUE

/obj/structure/machinery/computer/overwatch/attackby(var/obj/I as obj, var/mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/overwatch/bullet_act(var/obj/item/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/overwatch/attack_remote(var/mob/user as mob)
	if(!ismaintdrone(user))
		return attack_hand(user)

/obj/structure/machinery/computer/overwatch/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return

	if(!ishighersilicon(usr) && !skillcheck(user, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT) && SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		to_chat(user, SPAN_WARNING("You don't have the training to use [src]."))
		return

	user.set_interaction(src)
	var/dat = "<body>"

	if(!operator)
		dat += "<BR><B>Operator:</b> <A href='?src=\ref[src];operation=change_operator'>----------</A><BR>"
	else
		dat += "<BR><B>Operator:</b> <A href='?src=\ref[src];operation=change_operator'>[operator.name]</A><BR>"
		dat += "   <A href='?src=\ref[src];operation=logout'>Stop Overwatch</A><BR>"
		dat += "<hr>"

		switch(state)
			if(0) // Base menu
				dat += get_base_menu_text()
			if(1) //Info screen.
				dat += get_info_screen_text()
			if(2)
				dat += get_supply_drop_menu_text()
			if(3)
				dat += get_orbital_bombardment_control_text()

	show_browser(user, dat, "Overwatch Console", "overwatch", "size=550x550")
	onclose(user, "overwatch")
	return

/obj/structure/machinery/computer/overwatch/proc/get_base_menu_text()
	var/dat = ""

	if(!current_squad) //No squad has been set yet. Pick one.
		dat += "Current Squad: <A href='?src=\ref[src];operation=pick_squad'>----------</A><BR>"
		return dat;

	dat += "Current Squad: [current_squad.name] Squad</A>   "
	dat += "<A href='?src=\ref[src];operation=message'>Message Squad</a><br><br>"
	dat += "<A href='?src=\ref[src];operation=mapview'>Toggle Tactical Map</a>"
	dat += "<br><hr>"
	if(current_squad.squad_leader)
		dat += "<B>Squad Leader:</B> <A href='?src=\ref[src];operation=use_cam;cam_target=\ref[current_squad.squad_leader]'>[current_squad.squad_leader.name]</a> "
		dat += "<A href='?src=\ref[src];operation=sl_message'>MSG</a> "
		dat += "<A href='?src=\ref[src];operation=change_lead'>CHANGE SQUAD LEADER</a><BR><BR>"
	else
		dat += "<B>Squad Leader:</B> <font color=red>NONE</font> <A href='?src=\ref[src];operation=change_lead'>ASSIGN SQUAD LEADER</a><BR><BR>"

	dat += "<B>Primary Objective:</B> "
	if(current_squad.primary_objective)
		dat += "<A href='?src=\ref[src];operation=check_primary'>Check</A> <A href='?src=\ref[src];operation=set_primary'>Set</A><BR>"
	else
		dat += "<B><font color=red>NONE!</font></B> <A href='?src=\ref[src];operation=set_primary'>Set</A><BR>"
	dat += "<B>Secondary Objective:</B> "
	if(current_squad.secondary_objective)
		dat += "<A href='?src=\ref[src];operation=check_secondary'>Check</A> <A href='?src=\ref[src];operation=set_secondary'>Set</A><BR>"
	else
		dat += "<B><font color=red>NONE!</font></B> <A href='?src=\ref[src];operation=set_secondary'>Set</A><BR>"
	dat += "<BR>"
	dat += "<A href='?src=\ref[src];operation=insubordination'>Report a marine for insubordination</a><BR>"
	dat += "<A href='?src=\ref[src];operation=squad_transfer'>Transfer a marine to another squad</a><BR><BR>"

	dat += "<A href='?src=\ref[src];operation=supplies'>Supply Drop Control</a><BR>"
	dat += "<A href='?src=\ref[src];operation=bombs'>Orbital Bombardment Control</a><BR>"
	dat += "<A href='?src=\ref[src];operation=monitor'>Squad Monitor</a><br>"
	dat += "<hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a></Body>"

	return dat

/obj/structure/machinery/computer/overwatch/proc/get_info_screen_text()
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
		var/leader_count = 0
		var/spec_text = ""
		var/spec_count = 0
		var/medic_text = ""
		var/medic_count = 0
		var/engi_text = ""
		var/engi_count = 0
		var/smart_text = ""
		var/smart_count = 0
		var/marine_text = ""
		var/marine_count = 0
		var/misc_text = ""
		var/living_count = 0

		var/conscious_text = ""
		var/unconscious_text = ""
		var/dead_text = ""

		var/SL_z //z level of the Squad Leader
		if(current_squad.squad_leader)
			var/turf/SL_turf = get_turf(current_squad.squad_leader)
			SL_z = SL_turf.z


		for(var/X in current_squad.marines_list)
			if(!X)
				continue //just to be safe
			var/mob_name = "unknown"
			var/mob_state = ""
			var/role = "unknown"
			var/act_sl = ""
			var/fteam = ""
			var/dist = "<b>???</b>"
			var/area_name = "<b>???</b>"
			var/mob/living/carbon/human/H

			var/is_filtered = FALSE
			if(X && ("\ref[X]" in marine_filter))
				is_filtered = TRUE

			if(ishuman(X))
				H = X
				mob_name = H.real_name
				var/area/A = get_area(H)
				var/turf/M_turf = get_turf(H)
				if(!M_turf)
					continue
				if(A)
					area_name = sanitize(A.name)

				switch(z_hidden)
					if(HIDE_ALMAYER)
						if(is_mainship_level(M_turf.z))
							continue
					if(HIDE_GROUND)
						if(is_ground_level(M_turf.z))
							continue

				if(H.job)
					role = H.job
				else if(istype(H.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
					var/obj/item/card/id/ID = H.wear_id		//we use their ID to get their role.
					if(ID.rank) role = ID.rank

				if(current_squad.squad_leader)
					if(H == current_squad.squad_leader)
						dist = "<b>N/A</b>"
						if(H.job != JOB_SQUAD_LEADER)
							act_sl = " (acting SL)"
					else if(M_turf && (M_turf.z == SL_z))
						dist = "[get_dist(H, current_squad.squad_leader)] ([dir2text_short(get_dir(current_squad.squad_leader, H))])"

				if(is_filtered && marine_filter_enabled)
					continue

				switch(H.stat)
					if(CONSCIOUS)
						mob_state = "Conscious"
						living_count++
						conscious_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"

					if(UNCONSCIOUS)
						mob_state = "<b>Unconscious</b>"
						living_count++
						unconscious_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"

					if(DEAD)
						if(dead_hidden)
							continue
						mob_state = SET_CLASS("DEAD", INTERFACE_RED)
						dead_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"


				if(!H.key || !H.client)
					if(H.stat != DEAD)
						mob_state += " (SSD)"


				if(H.assigned_fireteam)
					fteam = " [H.assigned_fireteam]"

			else //listed marine was deleted or gibbed, all we have is their name
				if(dead_hidden)
					continue
				if(z_hidden) //gibbed marines are neither on the colony nor on the almayer
					continue
				for(var/datum/data/record/t in GLOB.data_core.general)
					if(t.fields["name"] == X)
						role = t.fields["real_rank"]
						break
				mob_state = SET_CLASS("DEAD", INTERFACE_RED)
				mob_name = X

				dead_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"


			var/marine_infos = "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl][fteam]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"
			switch(role)
				if(JOB_SQUAD_LEADER)
					leader_text += marine_infos
					leader_count++
				if(JOB_SQUAD_SPECIALIST)
					spec_text += marine_infos
					spec_count++
				if(JOB_SQUAD_MEDIC)
					medic_text += marine_infos
					medic_count++
				if(JOB_SQUAD_ENGI)
					engi_text += marine_infos
					engi_count++
				if(JOB_SQUAD_SMARTGUN)
					smart_text += marine_infos
					smart_count++
				if(JOB_SQUAD_MARINE)
					marine_text += marine_infos
					marine_count++
				else
					misc_text += marine_infos

		dat += "<b>[leader_count ? "Squad Leader Deployed" : SET_CLASS("No Squad Leader Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>[spec_count ? "Squad Specialist Deployed" : SET_CLASS("No Specialist Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>[smart_count ? "Squad Smartgunner Deployed" : SET_CLASS("No Smartgunner Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>Squad Medics: [medic_count] Deployed | Squad Engineers: [engi_count] Deployed</b><BR>"
		dat += "<b>Squad Marines: [marine_count] Deployed</b><BR>"
		dat += "<b>Total: [current_squad.marines_list.len] Deployed</b><BR>"
		dat += "<b>Marines alive: [living_count]</b><BR><BR><BR>"
		dat += "<center><b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'></center>"
		dat += "<table id='marine_list' border='2px' style='width: 100%; border-collapse: collapse;' align='center'><tr>"
		dat += "<th>Name</th><th>Role</th><th>State</th><th>Location</th><th>SL Distance</th><th>Filter</th></tr>"
		if(!living_marines_sorting)
			dat += leader_text + spec_text + medic_text + engi_text + smart_text + marine_text + misc_text
		else
			dat += conscious_text + unconscious_text + dead_text
		dat += "</table>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];operation=change_sort'>Change Sorting Method</a><br>"
	dat += "<A href='?src=\ref[src];operation=hide_dead'>[dead_hidden ? "Show Dead Marines" : "Hide Dead Marines" ]</a><br>"
	dat += "<A href='?src=\ref[src];operation=toggle_marine_filter'>[marine_filter_enabled ? "Disable Marine Filter" : "Enable Marine Filter"]</a><br>"
	dat += "<A href='?src=\ref[src];operation=choose_z'>Change Locations Ignored</a><br>"
	dat += "<br><A href='?src=\ref[src];operation=back'>Back</a></body>"
	return dat

/obj/structure/machinery/computer/overwatch/proc/get_supply_drop_menu_text()
	var/dat = "<B>Supply Drop Control</B><BR><BR>"
	if(!current_squad)
		dat += "No squad selected!"
	else
		dat += "<B>Current Supply Drop Status:</B> "
		var/cooldown_left = (current_squad.supply_cooldown + 5000) - world.time
		if(cooldown_left > 0)
			dat += "Launch tubes resetting ([round(cooldown_left/10)] seconds)<br>"
		else
			dat += SET_CLASS("Ready!", INTERFACE_GREEN)
			dat += "<br>"
		dat += "<B>Launch Pad Status:</b> "
		var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc
		if(C)
			dat += SET_CLASS("Supply crate loaded", INTERFACE_GREEN)
			dat += "<BR>"
		else
			dat += "Empty<BR>"
		dat += "<B>Longitude:</B> [x_supply] <A href='?src=\ref[src];operation=supply_x'>Change</a><BR>"
		dat += "<B>Latitude:</B> [y_supply] <A href='?src=\ref[src];operation=supply_y'>Change</a><BR><BR>"
		dat += "<A class='green' href='?src=\ref[src];operation=dropsupply'>LAUNCH!</a>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];operation=back'>Back</a></body>"
	return dat

/obj/structure/machinery/computer/overwatch/proc/get_orbital_bombardment_control_text()
	var/dat = "<B>Orbital Bombardment Control</B><BR><BR>"
	if(!current_squad)
		dat += "No squad selected!"
	else
		dat += "<B>Current Cannon Status:</B> "
		var/cooldown_left = (almayer_orbital_cannon.last_orbital_firing + 5000) - world.time
		if(almayer_orbital_cannon.is_disabled)
			dat += "Cannon is disabled!<br>"
		else if(cooldown_left > 0)
			dat += "Cannon on cooldown ([round(cooldown_left/10)] seconds)<br>"
		else if(!almayer_orbital_cannon.chambered_tray)
			dat += SET_CLASS("No ammo chambered in the cannon.", INTERFACE_RED)
			dat += "<br>"
		else
			dat += SET_CLASS("Ready!", INTERFACE_GREEN)
			dat += "<br>"
		dat += "<B>Longitude:</B> [x_bomb] <A href='?src=\ref[src];operation=bomb_x'>Change</a><BR>"
		dat += "<B>Latitude:</B> [y_bomb] <A href='?src=\ref[src];operation=bomb_y'>Change</a><BR><BR>"
		dat += "<A class='red' href='?src=\ref[src];operation=dropbomb'>FIRE!</a>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];operation=back'>Back</a></body>"
	return dat

/obj/structure/machinery/computer/overwatch/proc/update_mapview(var/close = 0)
	if(close || !current_squad || (current_mapviewer && !Adjacent(current_mapviewer)))
		if(current_mapviewer)
			close_browser(current_mapviewer, "marineminimap")
			current_mapviewer = null
		return
	var/icon/O
	switch(current_squad.color)
		if(1)
			if(!istype(marine_mapview_overlay_1))
				overlay_marine_mapview(current_squad)
			O = marine_mapview_overlay_1
		if(2)
			if(!istype(marine_mapview_overlay_2))
				overlay_marine_mapview(current_squad)
			O = marine_mapview_overlay_2
		if(3)
			if(!istype(marine_mapview_overlay_3))
				overlay_marine_mapview(current_squad)
			O = marine_mapview_overlay_3
		if(4)
			if(!istype(marine_mapview_overlay_4))
				overlay_marine_mapview(current_squad)
			O = marine_mapview_overlay_4
	if(O)
		current_mapviewer << browse_rsc(O, "marine_minimap.png")
		show_browser(current_mapviewer, "<img src=marine_minimap.png>", "Marine Minimap", "marineminimap", "size=[(map_sizes[1][1]*2)+50]x[(map_sizes[1][2]*2)+50]")
		onclose(current_mapviewer, "marineminimap", src)

/obj/structure/machinery/computer/overwatch/Topic(href, href_list)
	if(..())
		return

	if(href_list["close"]) // For closing minimaps
		if(current_mapviewer)
			close_browser(current_mapviewer, "marineminimap")
			current_mapviewer = null
		return

	if(!href_list["operation"])
		return

	if((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (ishighersilicon(usr)))
		usr.set_interaction(src)

	switch(href_list["operation"])
		// main interface
		if("mapview")
			if(current_mapviewer)
				update_mapview(1)
				return
			current_mapviewer = usr
			update_mapview()
			return
		if("back")
			state = 0
		if("monitor")
			state = 1
		if("supplies")
			state = 2
		if("bombs")
			state = 3
		if("change_operator")
			if(operator != usr)
				if(operator && ishighersilicon(operator))
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("AI override in progress. Access denied.")]")
				if(current_squad)
					current_squad.overwatch_officer = usr
				operator = usr
				if(ishighersilicon(usr))
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_BOLDNOTICE("Overwatch system AI override protocol successful.")]")
					send_to_squad("Attention. [operator.name] has engaged overwatch system control override.")
				else
					var/mob/living/carbon/human/H = operator
					var/obj/item/card/id/ID = H.get_idcard()
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Basic overwatch systems initialized. Welcome, [ID ? "[ID.rank] ":""][operator.name]. Please select a squad.")]")
					send_to_squad("Attention. Your Overwatch officer is now [ID ? "[ID.rank] ":""][operator.name].") //This checks for squad, so we don't need to.
		if("logout")
			if(current_squad)
				current_squad.overwatch_officer = null //Reset the squad's officer.
			if(ishighersilicon(usr))
				send_to_squad("Attention. [operator.name] has released overwatch system control. Overwatch functions deactivated.")
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_BOLDNOTICE("Overwatch system control override disengaged.")]")
			else
				var/mob/living/carbon/human/H = operator
				var/obj/item/card/id/ID = H.get_idcard()
				send_to_squad("Attention. [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"] is no longer your Overwatch officer. Overwatch functions deactivated.")
				visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Overwatch systems deactivated. Goodbye, [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"].")]")
			operator = null
			current_squad = null
			if(cam && !ishighersilicon(usr))
				usr.reset_view(null)
			cam = null
			state = 0
		if("pick_squad")
			if(operator == usr)
				if(current_squad)
					to_chat(usr, SPAN_WARNING("[htmlicon(src, usr)] You are already selecting a squad."))
				else
					var/list/squad_list = list()
					for(var/datum/squad/S in RoleAuthority.squads)
						if(S.usable && !S.overwatch_officer)
							squad_list += S.name

					var/name_sel = input("Which squad would you like to claim for Overwatch?") as null|anything in squad_list
					if(!name_sel)
						return
					if(operator != usr)
						return
					if(current_squad)
						to_chat(usr, SPAN_WARNING("[htmlicon(src, usr)] You are already selecting a squad."))
						return
					var/datum/squad/selected = get_squad_by_name(name_sel)
					if(selected)
						selected.overwatch_officer = usr //Link everything together, squad, console, and officer
						current_squad = selected
						send_to_squad("Attention - Your squad has been selected for Overwatch. Check your Status pane for objectives.")
						send_to_squad("Your Overwatch officer is: [operator.name].")
						visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Tactical data for squad '[current_squad]' loaded. All tactical functions initialized.")]")
						attack_hand(usr)
					else
						to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")
		if("message")
			if(current_squad && operator == usr)
				var/input = stripped_input(usr, "Please write a message to announce to the squad:", "Squad Message")
				if(input)
					send_to_squad(input, 1) //message, adds username
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Message sent to all Marines of squad '[current_squad]'.")]")
		if("sl_message")
			if(current_squad && operator == usr)
				var/input = stripped_input(usr, "Please write a message to announce to the squad leader:", "SL Message")
				if(input)
					send_to_squad(input, 1, 1) //message, adds usrname, only to leader
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Message sent to Squad Leader [current_squad.squad_leader] of squad '[current_squad]'.")]")
		if("check_primary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.primary_objective)
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding primary objectives of squad '[current_squad]'.")]")
					to_chat(usr, "[htmlicon(src, usr)] <b>Primary Objective:</b> [current_squad.primary_objective]")
		if("check_secondary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.secondary_objective)
					visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding secondary objectives of squad '[current_squad]'.")]")
					to_chat(usr, "[htmlicon(src, usr)] <b>Secondary Objective:</b> [current_squad.secondary_objective]")
		if("set_primary")
			var/input = stripped_input(usr, "What will be the squad's primary objective?", "Primary Objective")
			if(current_squad && input)
				current_squad.primary_objective = "[input] ([worldtime2text()])"
				send_to_squad("Your primary objective has changed. See Status pane for details.")
				visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Primary objective of squad '[current_squad]' set.")]")
		if("set_secondary")
			var/input = stripped_input(usr, "What will be the squad's secondary objective?", "Secondary Objective")
			if(input)
				current_squad.secondary_objective = input + " ([worldtime2text()])"
				send_to_squad("Your secondary objective has changed. See Status pane for details.")
				visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Secondary objective of squad '[current_squad]' set.")]")
		if("supply_x")
			var/input = input(usr,"What longitude should be targetted? (Increments towards the east)", "X Coordinate", 0) as num
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Longitude is now [input].")]")
			x_supply = input
		if("supply_y")
			var/input = input(usr,"What latitude should be targetted? (Increments towards the north)", "Y Coordinate", 0) as num
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Latitude is now [input].")]")
			y_supply = input
		if("bomb_x")
			var/input = input(usr,"What longitude should be targetted? (Increments towards the east)", "X Coordinate", 0) as num
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Longitude is now [input].")]")
			x_bomb = input
		if("bomb_y")
			var/input = input(usr,"What latitude should be targetted? (Increments towards the north)", "Y Coordinate", 0) as num
			to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Latitude is now [input].")]")
			y_bomb = input
		if("refresh")
			attack_hand(usr)
		if("change_sort")
			living_marines_sorting = !living_marines_sorting
			if(living_marines_sorting)
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Marines are now sorted by health status.")]")
			else
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Marines are now sorted by rank.")]")
		if("hide_dead")
			dead_hidden = !dead_hidden
			if(dead_hidden)
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Dead marines are now not shown.")]")
			else
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Dead marines are now shown again.")]")
		if("choose_z")
			switch(z_hidden)
				if(HIDE_NONE)
					z_hidden = HIDE_ALMAYER
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Marines on the Almayer are now hidden.")]")
				if(HIDE_ALMAYER)
					z_hidden = HIDE_GROUND
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Marines on the ground are now hidden.")]")
				else
					z_hidden = HIDE_NONE
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("No location is ignored anymore.")]")

		if("toggle_marine_filter")
			if(marine_filter_enabled)
				marine_filter_enabled = FALSE
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("All marines will now be shown regardless of filter.")]")
			else
				marine_filter_enabled = TRUE
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Individual Marine Filter is now enabled.")]")
		if("filter_marine")
			if (current_squad)
				var/squaddie = href_list["squaddie"]
				if(!(squaddie in marine_filter))
					marine_filter += squaddie
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Marine now hidden.")]")
				else
					marine_filter -= squaddie
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_NOTICE("Marine will now be shown.")]")
		if("change_lead")
			change_lead()
		if("insubordination")
			mark_insubordination()
		if("squad_transfer")
			transfer_squad()
		if("dropsupply")
			if(current_squad)
				if((current_squad.supply_cooldown + 5000) > world.time)
					to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Supply drop not yet available!")]")
				else
					handle_supplydrop()
		if("dropbomb")
			if(almayer_orbital_cannon.is_disabled)
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Orbital bombardment disabled!")]")
			else if((almayer_orbital_cannon.last_orbital_firing + 5000) > world.time)
				to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Orbital bombardment not yet available!")]")
			else
				handle_bombard(usr)
		if("back")
			state = 0
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
	attack_hand(usr) //The above doesn't ever seem to work.

/obj/structure/machinery/computer/overwatch/check_eye(mob/user)
	if(user.is_mob_incapacitated(TRUE) || get_dist(user, src) > 1 || user.blinded) //user can't see - not sure why canmove is here.
		user.unset_interaction()
	else if(!cam || !cam.can_use()) //camera doesn't work, is no longer selected or is gone
		user.unset_interaction()

/obj/structure/machinery/computer/overwatch/on_unset_interaction(mob/user)
	..()
	if(!isRemoteControlling(user))
		cam = null
		user.reset_view(null)

//returns the helmet camera the human is wearing
/obj/structure/machinery/computer/overwatch/proc/get_camera_from_target(mob/living/carbon/human/H)
	if(current_squad)
		if(H && istype(H) && istype(H.head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/helm = H.head
			return helm.camera

//Sends a string to our currently selected squad.
/obj/structure/machinery/computer/overwatch/proc/send_to_squad(var/txt = "", var/plus_name = 0, var/only_leader = 0)
	if(txt == "" || !current_squad || !operator)
		return //Logic

	var/text = strip_html(txt)
	var/nametext = ""
	if(plus_name)
		nametext = "[usr.name] transmits: "
		text = "[FONT_SIZE_LARGE("<b>[text]<b>")]"

	for(var/mob/living/carbon/human/M in current_squad.marines_list)
		if(!M.stat && M.client) //Only living and connected people in our squad
			if(!only_leader)
				if(plus_name)
					M << sound('sound/effects/radiostatic.ogg')
				to_chat(M, "[htmlicon(src, M)] [SPAN_BLUE("<B>Overwatch:</b> [nametext][text]")]")
			else
				if(current_squad.squad_leader == M)
					if(plus_name)
						M << sound('sound/effects/radiostatic.ogg')
					to_chat(M, "[htmlicon(src, M)] [SPAN_BLUE("<B>SL Overwatch:</b> [nametext][text]")]")
					return

/obj/structure/machinery/computer/overwatch/proc/change_lead()
	if(!usr || usr != operator)
		return
	if(!current_squad)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return
	var/sl_candidates = list()
	for(var/mob/living/carbon/human/H in current_squad.marines_list)
		if(istype(H) && H.stat != DEAD && H.mind && !jobban_isbanned(H, JOB_SQUAD_LEADER))
			sl_candidates += H
	var/new_lead = input(usr, "Choose a new Squad Leader") as null|anything in sl_candidates
	if(!new_lead || new_lead == "Cancel")
		return
	var/mob/living/carbon/human/H = new_lead
	if(!istype(H) || !H.mind || H.stat == DEAD) //marines_list replaces mob refs of gibbed marines with just a name string
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[H] is KIA!")]")
		return
	if(H == current_squad.squad_leader)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[H] is already the Squad Leader!")]")
		return
	if(jobban_isbanned(H, JOB_SQUAD_LEADER))
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[H] is unfit to lead!")]")
		return
	if(current_squad.squad_leader)
		send_to_squad("Attention: [current_squad.squad_leader] is [current_squad.squad_leader.stat == DEAD ? "stepping down" : "demoted"]. A new Squad Leader has been set: [H.real_name].")
		visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Squad Leader [current_squad.squad_leader] of squad '[current_squad]' has been [current_squad.squad_leader.stat == DEAD ? "replaced" : "demoted and replaced"] by [H.real_name]! Logging to enlistment files.")]")
		var/old_lead = current_squad.squad_leader
		current_squad.demote_squad_leader(current_squad.squad_leader.stat != DEAD)
		SStracking.start_tracking(current_squad.tracking_id, old_lead)
	else
		send_to_squad("Attention: A new Squad Leader has been set: [H.real_name].")
		visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("[H.real_name] is the new Squad Leader of squad '[current_squad]'! Logging to enlistment file.")]")

	to_chat(H, "[htmlicon(src, H)] <font size='3' color='blue'><B>Overwatch: You've been promoted to \'[H.job == JOB_SQUAD_LEADER ? "SQUAD LEADER" : "ACTING SQUAD LEADER"]\' for [current_squad.name]. Your headset has access to the command channel (:v).</B></font>")
	to_chat(usr, "[htmlicon(src, usr)] [H.real_name] is [current_squad]'s new leader!")

	if(H.assigned_fireteam)
		if(H == current_squad.fireteam_leaders[H.assigned_fireteam])
			current_squad.unassign_ft_leader(H.assigned_fireteam, TRUE, FALSE)
		current_squad.unassign_fireteam(H, FALSE)

	current_squad.squad_leader = H
	current_squad.update_squad_leader()
	current_squad.update_free_mar()
	current_squad.update_squad_ui()

	SStracking.set_leader(current_squad.tracking_id, H)
	SStracking.start_tracking("marine_sl", H)

	if(H.job == JOB_SQUAD_LEADER)//a real SL
		H.comm_title = "SL"
	else //an acting SL
		H.comm_title = "aSL"
	if(H.skills)
		H.skills.set_skill(SKILL_LEADERSHIP, max(SKILL_LEAD_TRAINED, H.skills.get_skill_level(SKILL_LEADERSHIP)))

	if(istype(H.wear_ear, /obj/item/device/radio/headset/almayer/marine))
		var/obj/item/device/radio/headset/almayer/marine/R = H.wear_ear
		if(!R.keyslot1)
			R.keyslot1 = new /obj/item/device/encryptionkey/squadlead (src)
		else if(!R.keyslot2)
			R.keyslot2 = new /obj/item/device/encryptionkey/squadlead (src)
		else if(!R.keyslot3)
			R.keyslot3 = new /obj/item/device/encryptionkey/squadlead (src)
		R.recalculateChannels()
	if(istype(H.wear_id, /obj/item/card/id))
		var/obj/item/card/id/ID = H.wear_id
		ID.access += ACCESS_MARINE_LEADER
	H.hud_set_squad()
	H.update_inv_head() //updating marine helmet leader overlays
	H.update_inv_wear_suit()

/obj/structure/machinery/computer/overwatch/proc/mark_insubordination()
	if(!usr || usr != operator)
		return
	if(!current_squad)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return
	var/mob/living/carbon/human/wanted_marine = input(usr, "Report a marine for insubordination") as null|anything in current_squad.marines_list
	if(!wanted_marine)
		return
	if(!istype(wanted_marine))//gibbed/deleted, all we have is a name.
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[wanted_marine] is missing in action.")]")
		return

	for(var/datum/data/record/E in GLOB.data_core.general)
		if(E.fields["name"] == wanted_marine.real_name)
			for(var/datum/data/record/R in GLOB.data_core.security)
				if(R.fields["id"] == E.fields["id"])
					if(!findtext(R.fields["ma_crim"],"Insubordination."))
						R.fields["criminal"] = "*Arrest*"
						if(R.fields["ma_crim"] == "None")
							R.fields["ma_crim"]	= "Insubordination."
						else
							R.fields["ma_crim"] += "Insubordination."

						var/insub = "[htmlicon(src, usr)] [SPAN_BOLDNOTICE("[wanted_marine] has been reported for insubordination. Logging to enlistment file.")]"
						if(isRemoteControlling(usr))
							usr << insub
						else
							visible_message(insub)
						to_chat(wanted_marine, "[htmlicon(src, wanted_marine)] <font size='3' color='blue'><B>Overwatch:</b> You've been reported for insubordination by your overwatch officer.</font>")
						wanted_marine.sec_hud_set_security_status()
					return

/obj/structure/machinery/computer/overwatch/proc/transfer_squad()
	if(!usr || usr != operator)
		return
	if(!current_squad)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return
	var/datum/squad/S = current_squad
	var/mob/living/carbon/human/transfer_marine = input(usr, "Choose marine to transfer") as null|anything in current_squad.marines_list
	if(!transfer_marine || S != current_squad) //don't change overwatched squad, idiot.
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD) //gibbed, decapitated, dead
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[transfer_marine] is KIA.")]")
		return

	if(!istype(transfer_marine.wear_id, /obj/item/card/id))
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Transfer aborted. [transfer_marine] isn't wearing an ID.")]")
		return

	var/datum/squad/new_squad = input(usr, "Choose the marine's new squad") as null|anything in RoleAuthority.squads
	if(!new_squad || S != current_squad)
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[transfer_marine] is KIA.")]")
		return

	if(!istype(transfer_marine.wear_id, /obj/item/card/id))
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Transfer aborted. [transfer_marine] isn't wearing an ID.")]")
		return

	var/datum/squad/old_squad = transfer_marine.assigned_squad
	if(new_squad == old_squad)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("[transfer_marine] is already in [new_squad]!")]")
		return

	var/no_place = FALSE
	switch(transfer_marine.job)
		if(JOB_SQUAD_LEADER)
			if(new_squad.num_leaders == new_squad.max_leaders)
				no_place = TRUE
		if(JOB_SQUAD_SPECIALIST)
			if(new_squad.num_specialists == new_squad.max_specialists)
				no_place = TRUE
		if(JOB_SQUAD_ENGI)
			if(new_squad.num_engineers >= new_squad.max_engineers)
				no_place = TRUE
		if(JOB_SQUAD_MEDIC)
			if(new_squad.num_medics >= new_squad.max_medics)
				no_place = TRUE
		if(JOB_SQUAD_SMARTGUN)
			if(new_squad.num_smartgun == new_squad.max_smartgun)
				no_place = TRUE

	if(no_place)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Transfer aborted. [new_squad] can't have another [transfer_marine.job].")]")
		return

	if(transfer_marine.assigned_fireteam)
		if(old_squad.fireteam_leaders["FT[transfer_marine.assigned_fireteam]"] == transfer_marine)
			old_squad.unassign_ft_leader(transfer_marine.assigned_fireteam, TRUE, FALSE)
		old_squad.unassign_fireteam(transfer_marine, TRUE)	//reset fireteam assignment

	old_squad.remove_marine_from_squad(transfer_marine)
	old_squad.update_free_mar()
	old_squad.update_squad_ui()
	new_squad.put_marine_in_squad(transfer_marine)
	new_squad.update_free_mar()
	new_squad.update_squad_ui()

	for(var/datum/data/record/t in GLOB.data_core.general) //we update the crew manifest
		if(t.fields["name"] == transfer_marine.real_name)
			t.fields["squad"] = new_squad.name
			break

	transfer_marine.hud_set_squad()
	visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("[transfer_marine] has been transfered from squad '[old_squad]' to squad '[new_squad]'. Logging to enlistment file.")]")
	to_chat(transfer_marine, "[htmlicon(src, transfer_marine)] <font size='3' color='blue'><B>\[Overwatch\]:</b> You've been transfered to [new_squad]!</font>")

/obj/structure/machinery/computer/overwatch/proc/handle_bombard(mob/user)
	if(!user)
		return

	if(busy)
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("The [name] is busy processing another action!")]")
		return

	if(!current_squad)
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("No squad selected!")]")
		return

	if(!almayer_orbital_cannon.chambered_tray)
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("The orbital cannon has no ammo chambered.")]")
		return

	var/x_coord = deobfuscate_x(x_bomb)
	var/y_coord = deobfuscate_y(y_bomb)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)

	var/area/A = get_area(T)
	if(protected_by_pylon(TURF_PROTECTION_OB, T))
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("The target zone has strong biological protection. The orbital strike cannot reach here.")]")
		return

	if(istype(A) && CEILING_IS_PROTECTED(A.ceiling, CEILING_DEEP_UNDERGROUND))
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("The target zone is deep underground. The orbital strike cannot reach here.")]")
		return

	if(istype(T, /turf/open/space))
		to_chat(user, "[htmlicon(src, user)] [SPAN_WARNING("The target zone appears to be out of bounds. Please check coordinates.")]")
		return

	//All set, let's do this.
	busy = 1
	visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Orbital bombardment request for squad '[current_squad]' accepted. Orbital cannons are now calibrating.")]")
	send_to_squad("Initializing fire coordinates.")
	playsound(T,'sound/effects/alert.ogg', 25, 1)  //Placeholder
	addtimer(CALLBACK(src, /obj/structure/machinery/computer/overwatch/proc/send_to_squad, "Transmitting beacon feed."), SECONDS_2)
	addtimer(CALLBACK(src, /obj/structure/machinery/computer/overwatch/proc/send_to_squad, "Calibrating trajectory window."), SECONDS_4)
	addtimer(CALLBACK(src, /obj/structure/machinery/computer/overwatch/proc/begin_fire), SECONDS_6)
	addtimer(CALLBACK(src, /obj/structure/machinery/computer/overwatch/proc/fire_bombard, user, A, T), SECONDS_6 + 6)

/obj/structure/machinery/computer/overwatch/proc/begin_fire()
	for(var/mob/living/carbon/H in GLOB.alive_mob_list)
		if(is_mainship_level(H.z) && !H.stat) //USS Almayer decks.
			to_chat(H, SPAN_WARNING("The deck of the USS Almayer shudders as the orbital cannons open fire on the colony."))
			if(H.client)
				shake_camera(H, 10, 1)
	visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("Orbital bombardment for squad '[current_squad]' has fired! Impact imminent!")]")
	send_to_squad("WARNING! Ballistic trans-atmospheric launch detected! Get outside of Danger Close!")

/obj/structure/machinery/computer/overwatch/proc/fire_bombard(mob/user, area/A, turf/T)
	if(!A || !T)
		return

	message_staff(FONT_SIZE_HUGE("ALERT: [key_name(user)] fired an orbital bombardment in [A.name] for squad '[current_squad]' (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)"))
	log_attack("[key_name(user)] fired an orbital bombardment in [A.name] for squad '[current_squad]'")

	busy = FALSE
	var/turf/target = locate(T.x + rand(-3, 3), T.y + rand(-3, 3), T.z)
	if(target && istype(target))
		almayer_orbital_cannon.fire_ob_cannon(target, user)
		user.count_niche_stat(STATISTICS_NICHE_OB)

/obj/structure/machinery/computer/overwatch/proc/handle_supplydrop()
	if(!usr || usr != operator)
		return

	if(busy)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("The [name] is busy processing another action!")]")
		return

	var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc //This thing should ALWAYS exist.
	if(!istype(C))
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("No crate was detected on the drop pad. Get Requisitions on the line!")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)
	if(!T)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Error, invalid coordinates.")]")
		return

	var/area/A = get_area(T)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("The landing zone is underground. The supply drop cannot reach here.")]")
		return

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("The landing zone appears to be obstructed or out of bounds. Package would be lost on drop.")]")
		return

	busy = 1

	visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("'[C.name]' supply drop is now loading into the launch tube! Stand by!")]")
	C.visible_message(SPAN_WARNING("\The [C] begins to load into a launch tube. Stand clear!"))
	C.anchored = TRUE //To avoid accidental pushes
	send_to_squad("'[C.name]' supply drop incoming. Heads up!")
	var/datum/squad/S = current_squad //in case the operator changes the overwatched squad mid-drop
	addtimer(CALLBACK(src, /obj/structure/machinery/computer/overwatch/proc/finish_supplydrop, C, S, T), SECONDS_10)

/obj/structure/machinery/computer/overwatch/proc/finish_supplydrop(obj/structure/closet/crate/C, datum/squad/S, turf/T)
	if(!C || C.loc != S.drop_pad.loc) //Crate no longer on pad somehow, abort.
		if(C) C.anchored = FALSE
		to_chat(usr, "[htmlicon(src, usr)] [SPAN_WARNING("Launch aborted! No crate detected on the drop pad.")]")
		return
	S.supply_cooldown = world.time
	if(ismob(usr))
		var/mob/M = usr
		M.count_niche_stat(STATISTICS_NICHE_CRATES)

	playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
	C.anchored = FALSE
	C.forceMove(T)
	var/turf/TC = get_turf(C)
	TC.ceiling_debris_check(3)
	playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehhhhhhhhh.
	C.visible_message("[htmlicon(C)] [SPAN_BOLDNOTICE("The '[C.name]' supply drop falls from the sky!")]")
	visible_message("[htmlicon(src, viewers(src))] [SPAN_BOLDNOTICE("'[C.name]' supply drop launched! Another launch will be available in five minutes.")]")
	busy = FALSE

/obj/structure/machinery/computer/overwatch/almayer
	density = 0
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"

/obj/structure/supply_drop
	name = "Supply Drop Pad"
	desc = "Place a crate on here to allow bridge Overwatch officers to drop them on people's heads."
	icon = 'icons/effects/warning_stripes.dmi'
	anchored = 1
	density = 0
	unslashable = TRUE
	unacidable = TRUE
	layer = 2.1 //It's the floor, man
	var/squad = SQUAD_NAME_1
	var/sending_package = 0

/obj/structure/supply_drop/Initialize(mapload, ...)
	. = ..()
	GLOB.supply_drop_list += src

/obj/structure/supply_drop/Destroy()
	GLOB.supply_drop_list -= src
	return ..()

/obj/structure/supply_drop/alpha
	icon_state = "alphadrop"
	squad = SQUAD_NAME_1

/obj/structure/supply_drop/bravo
	icon_state = "bravodrop"
	squad = SQUAD_NAME_2

/obj/structure/supply_drop/charlie
	icon_state = "charliedrop"
	squad = SQUAD_NAME_3

/obj/structure/supply_drop/delta
	icon_state = "deltadrop"
	squad = SQUAD_NAME_4

/obj/structure/supply_drop/echo //extra supply drop pad
	icon_state = "echodrop"
	squad = SQUAD_NAME_5

#undef HIDE_ALMAYER
#undef HIDE_GROUND
#undef HIDE_NONE
