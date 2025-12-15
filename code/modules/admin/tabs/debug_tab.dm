/client/proc/enable_debug_verbs()
	set category = "Debug"
	set name = "Debug Verbs - Show"

	if(!check_rights(R_DEBUG))
		return

	add_verb(src, GLOB.debug_verbs)
	remove_verb(src, /client/proc/enable_debug_verbs)

/client/proc/hide_debug_verbs()
	set category = "Debug"
	set name = "Debug Verbs - Hide"

	if(!check_rights(R_DEBUG))
		return

	remove_verb(src, GLOB.debug_verbs)
	add_verb(src, /client/proc/enable_debug_verbs)

/client/proc/enter_tree()
	set category = "Debug.TechTree"
	set name = "Enter Tech Tree"

	if(!check_rights(R_DEBUG))
		return

	var/list/trees = list()

	for(var/T in SStechtree.trees)
		trees += list("[T]" = SStechtree.trees[T])

	var/value = SStechtree.trees[1]

	if(length(trees) > 1)
		value = tgui_input_list(src, "Choose which tree to enter", "Enter Tree", trees)

	if(!value)
		to_chat(src, SPAN_WARNING("Something went wrong"))
		return

	var/datum/techtree/tree = trees[value]

	var/should_force = tgui_alert(src, "Do you want to force yourself into the tree?", "Force Enter", list("Yes", "No"))

	tree.enter_mob(src.mob, should_force == "Yes")


/client/proc/set_tree_points()
	set category = "Debug.TechTree"
	set name = "Set Tech Tree Points"

	if(!check_rights(R_DEBUG))
		return

	var/list/trees = list()

	for(var/T in SStechtree.trees)
		trees += list("[T]" = SStechtree.trees[T])

	var/value = SStechtree.trees[1]

	if(length(trees) > 1)
		value = tgui_input_list(src, "Choose which tree to give points to", "Give Points", trees)

	if(!value)
		to_chat(src, SPAN_WARNING("Something went wrong"))
		return

	var/datum/techtree/tree = trees[value]

	var/number_to_set = tgui_input_number(src, "How many points should this tech tree be at?", "", tree.points)

	if(number_to_set == null)
		return

	tree.set_points(number_to_set)

/client/proc/purge_data_tab()
	set category = "Debug"
	set name = "Reset Intel Data Tab"

	if(tgui_alert(src, "Clear the data tab?", "Confirm", list("Yes", "No"), 10 SECONDS) == "Yes")
		for(var/datum/cm_objective/Objective in GLOB.intel_system.oms.disks)
			GLOB.intel_system.oms.disks -= Objective

/client/proc/check_round_statistics()
	set category = "Debug"
	set name = "Round Statistics"
	if(!check_rights(R_ADMIN|R_DEBUG))
		return

	debug_variables(GLOB.round_statistics)

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in world)
	set category = "Debug"
	set name = "Delete"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
		if(isturf(O))
			var/turf/T = O
			T.ScrapeAway()
		else
			qdel(O)

/client/proc/ticklag()
	set category = "Debug.Controllers"
	set name = "Set Ticklag"
	set desc = "Sets a new tick lag. Recommend you don't mess with this too much! Stable, time-tested ticklag value is 0.9"

	if(!check_rights(R_DEBUG))
		return
	if(!ishost(usr) || alert("Are you sure you want to do this?",, "Yes", "No") != "Yes")
		return
	var/newtick = tgui_input_number(src, "Sets a new tick lag. Please don't mess with this too much! The stable, time-tested ticklag value is 0.9","Lag of Tick", world.tick_lag)
	//I've used ticks of 2 before to help with serious singulo lags
	if(newtick && newtick <= 2 && newtick > 0)
		message_admins("[key_name(src)] has modified world.tick_lag to [newtick]")
		world.change_tick_lag(newtick)
	else
		to_chat(src, SPAN_DANGER("Error: ticklag(): Invalid world.ticklag value. No changes made."))

/client/proc/fix_next_move()
	set category = "Debug"
	set name = "Unfreeze Everyone"
	if(alert("Are you sure you want to do this?",, "Yes", "No") != "Yes")
		return
	var/largest_move_time = 0
	var/largest_click_time = 0
	var/mob/largest_move_mob = null
	var/mob/largest_click_mob = null
	for(var/mob/M in GLOB.player_list)
		if(M.next_move >= largest_move_time)
			largest_move_mob = M
			if(M.next_move > world.time)
				largest_move_time = M.next_move - world.time
			else
				largest_move_time = 1
		if(M.next_click >= largest_click_time)
			largest_click_mob = M
			if(M.next_click > world.time)
				largest_click_time = M.next_click - world.time
			else
				largest_click_time = 0
		log_admin("DEBUG: [key_name(M)]  next_move = [M.next_move]  next_click = [M.next_click]  world.time = [world.time]")
		M.next_move = 1
		M.next_click = 0
	message_admins("[key_name_admin(largest_move_mob)] had the largest move delay with [largest_move_time] frames / [largest_move_time/10] seconds!")
	message_admins("[key_name_admin(largest_click_mob)] had the largest click delay with [largest_click_time] frames / [largest_click_time/10] seconds!")
	message_admins("world.time = [world.time]")
	return

/client/proc/reload_admins()
	set name = "Reload Admins"
	set category = "Debug"
	if(alert("Are you sure you want to do this?",, "Yes", "No") != "Yes")
		return
	if(!check_rights(R_SERVER))
		return

	message_admins("[usr.ckey] manually reloaded admins.")
	load_admins()

/client/proc/bulk_fetcher()
	set name = "Bulk Fetch Items"
	set category = "Debug"

	if (admin_holder)
		admin_holder.bulk_fetcher_panel()

/datum/admins/proc/bulk_fetcher_panel()
	if(!check_rights(R_DEBUG,0))
		return

	var/dat = {"
		<B>Fetch Objectives</B><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchdisks'>Disks</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchtechmanuals'>Technical Manuals</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchprogressreports'>Progress Reports</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchpaperscraps'>Paper Scraps</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchfolders'>Folders</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchexpdevices'>Experimental Devices</A><BR>
		<BR>
		<B>Research</B><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchvials'>Vials</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchresearchnotes'>Research Notes</A><BR>
		<BR>
		<B>Bodies</B><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchhumancorpses'>Human corpses</A><BR>
		<A href='byond://?src=\ref[src];debug=bulkfetchxenocorpses'>Xeno corpses</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "Bulk Fetcher Panel", "debug")
	return
