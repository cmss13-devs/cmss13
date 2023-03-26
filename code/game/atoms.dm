
/atom
	var/desc_lore = null

	plane = GAME_PLANE
	layer = TURF_LAYER
	var/level = 2
	var/flags_atom = FPRINT

	var/list/fingerprintshidden
	var/fingerprintslast = null

	var/unacidable = FALSE
	var/last_bumped = 0

	// The cached datum for the permanent pass flags for any given atom
	var/datum/pass_flags_container/pass_flags

	// Temporary lags for what an atom can pass through
	var/list/flags_pass_temp
	var/list/temp_flag_counter

	// Temporary flags for what can pass through an atom
	var/list/flags_can_pass_all_temp
	var/list/flags_can_pass_front_temp
	var/list/flags_can_pass_behind_temp

	var/flags_barrier = NO_FLAGS
	var/throwpass = 0

	//Effects
	var/list/effects_list

	var/list/filter_data //For handling persistent filters

	// Base transform matrix
	var/matrix/base_transform = null

	///Chemistry.
	var/datum/reagents/reagents = null

	//Z-Level Transitions
	var/atom/movable/clone/clone = null

	// Bitflag of which test cases this atom is exempt from
	// See #define/tests.dm
	var/test_exemptions = 0

	// Whether the atom is an obstacle that should be considered for passing
	var/can_block_movement = FALSE

	var/datum/component/orbiter/orbiters

	///Reference to atom being orbited
	var/atom/orbit_target

	///Default pixel x shifting for the atom's icon.
	var/base_pixel_x = 0
	///Default pixel y shifting for the atom's icon.
	var/base_pixel_y = 0

	///The color this atom will be if we choose to draw it on the minimap
	var/minimap_color = MINIMAP_SOLID

/atom/New(loc, ...)
	var/do_initialize = SSatoms.initialized
	if(do_initialize != INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, FALSE, args))
			//we were deleted
			return

/*
We actually care what this returns, since it can return different directives.
Not specifically here, but in other variations of this. As a general safety,
Make sure the return value equals the return value of the parent so that the
directive is properly returned.
*/
//===========================================================================
/atom/Destroy()
	orbiters = null // The component is attached to us normally and will be deleted elsewhere
	QDEL_NULL(reagents)
	QDEL_NULL(light)
	fingerprintshidden = null
	. = ..()

//===========================================================================



//atmos procs

//returns the atmos info relevant to the object (gas type, temperature, and pressure)
/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null


/atom/proc/return_pressure()
	if(loc)
		return loc.return_pressure()

/atom/proc/return_temperature()
	if(loc)
		return loc.return_temperature()

//returns the gas mix type
/atom/proc/return_gas()
	if(loc)
		return loc.return_gas()

// Updates the atom's transform
/atom/proc/apply_transform(matrix/M)
	if(!base_transform)
		transform = M
		return

	var/matrix/base_copy = matrix(base_transform)
	// Compose the base and applied transform in that order
	transform = base_copy.Multiply(M)

/atom/proc/on_reagent_change()
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags_atom & OPENCONTAINER

/atom/proc/is_open_container_or_can_be_dispensed_into()
	return flags_atom & OPENCONTAINER || flags_atom & CAN_BE_DISPENSED_INTO

/atom/proc/can_be_syringed()
	return flags_atom & CAN_BE_SYRINGED

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

/atom/proc/allow_drop()
	return 1


/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(severity)
	return

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 * atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *    list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found

/atom/proc/examine(mob/user)
	var/list/examine_strings = get_examine_text(user)
	if(!examine_strings)
		log_debug("Attempted to create an examine block with no strings! Atom : [src], user : [user]")
		return
	to_chat(user, examine_block(examine_strings.Join("\n")))
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, examine_strings)

/atom/proc/get_examine_text(mob/user)
	. = list()
	. += "[icon2html(src, user)] That's \a [src]." //changed to "That's" from "This is" because "This is some metal sheets" sounds dumb compared to "That's some metal sheets" ~Carn
	if(desc)
		. += desc
	if(desc_lore)
		. += SPAN_NOTICE("This has an <a href='byond://?src=\ref[src];desc_lore=1'>extended lore description</a>.")

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

/atom/proc/contents_explosion(severity)
	for(var/atom/A in contents)
		A.ex_act(severity)

/atom/proc/ex_act(severity)
	contents_explosion(severity)

/atom/proc/fire_act()
	return

/atom/proc/hitby(atom/movable/AM)
	SEND_SIGNAL(src, COMSIG_ATOM_HITBY, AM)
	return

/atom/proc/add_hiddenprint(mob/living/M)
	if(!M || QDELETED(M) || !M.key || !(flags_atom  & FPRINT) || fingerprintslast == M.key)
		return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (H.gloves)
			fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
		else
			fingerprintshidden += "\[[time_stamp()]\] Real name: [H.real_name], Key: [H.key]"
	else
		fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
	fingerprintslast = M.key


/atom/proc/add_fingerprint(mob/living/M)
	if(!M || QDELETED(M) || !M.key || !(flags_atom & FPRINT) || fingerprintslast == M.key)
		return
	if(!fingerprintshidden)
		fingerprintshidden = list()
	fingerprintslast = M.key

	if (ishuman(M))
		var/mob/living/carbon/human/H = M

		//Fibers~
		blood_touch(H)

		fingerprintslast = M.key

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			fingerprintshidden += "\[[time_stamp()]\](Wearing gloves). Real name: [H.real_name], Key: [H.key]"
		else
			fingerprintshidden += "\[[time_stamp()]\]Real name: [H.real_name], Key: [H.key]"
	else
		fingerprintshidden +=  "\[[time_stamp()]\]Real name: [M.real_name], Key: [M.key]"



//put blood on stuff we touched
/atom/proc/blood_touch(mob/living/carbon/human/M)
	if(M.gloves)
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.gloves_blood_amt && add_blood(G.blood_color)) //only reduces the bloodiness of our gloves if the item wasn't already bloody
			G.gloves_blood_amt--
	else if(M.hands_blood_amt && add_blood(M.hands_blood_color))
		M.hands_blood_amt--




/atom/proc/transfer_fingerprints_to(atom/A)

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()




/atom/proc/add_vomit_floor(mob/living/carbon/M, toxvomit = 0)
	return

/turf/add_vomit_floor(mob/living/carbon/M, toxvomit = 0)
	var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

	// Make toxins vomit look different
	if(toxvomit)
		this.icon_state = "vomittox_[pick(1,4)]"


//Generalized Fire Proc.
/atom/proc/flamer_fire_act(dam = BURN_LEVEL_TIER_1, datum/cause_data/flame_cause_data)
	return

/atom/proc/acid_spray_act()
	return


//things that object need to do when a movable atom inside it is deleted
/atom/proc/on_stored_atom_del(atom/movable/AM)
	return

/atom/proc/handle_barrier_chance()
	return FALSE

/*
Called after New.
Must refer back to this parent or manually set initialized to TRUE.
Parameters are passed from New.
*/
/atom/proc/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(flags_atom & INITIALIZED)
		CRASH("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	pass_flags = pass_flags_cache[type]
	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()
	Decorate(mapload)

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

/atom/process()
	return

//---CLONE---//

/atom/clone
	var/proj_x = 0
	var/proj_y = 0

/atom/proc/create_clone(shift_x, shift_y) //NOTE: Use only for turfs, otherwise use create_clone_movable
	var/turf/T = null
	T = locate(src.x + shift_x, src.y + shift_y, src.z)

	T.appearance = src.appearance
	T.setDir(src.dir)

	clones_t.Add(src)
	src.clone = T

// EFFECTS
/atom/proc/extinguish_acid()
	for(var/datum/effects/acid/A in effects_list)
		if(A.cleanse_acid())
			qdel(A)
			return TRUE
	return FALSE

// Movement
/atom/proc/add_temp_pass_flags(flags_to_add)
	if (isnull(temp_flag_counter))
		temp_flag_counter = list()

	for (var/flag in GLOB.bitflags)
		if(!(flags_to_add & flag))
			continue
		var/flag_str = "[flag]"
		if (temp_flag_counter[flag_str])
			temp_flag_counter[flag_str]++
		else
			temp_flag_counter[flag_str] = 1
			flags_pass_temp |= flag

/atom/proc/remove_temp_pass_flags(flags_to_remove)
	if (isnull(temp_flag_counter))
		return

	for (var/flag in GLOB.bitflags)
		if(!(flags_to_remove & flag))
			continue
		var/flag_str = "[flag]"
		if (temp_flag_counter[flag_str])
			temp_flag_counter[flag_str]--
			if (temp_flag_counter[flag_str] == 0)
				temp_flag_counter -= flag_str
				flags_pass_temp &= ~flag

// This proc is for initializing pass flags (allows for inheriting pass flags and list-based pass flags)
/atom/proc/initialize_pass_flags(datum/pass_flags_container/PF)
	return

/atom/proc/enable_pixel_scaling()
	appearance_flags |= PIXEL_SCALE

/atom/proc/disable_pixel_scaling()
	appearance_flags &= ~PIXEL_SCALE

///Passes Stat Browser Panel clicks to the game and calls client click on an atom
/atom/Topic(href, list/href_list)
	if(!usr?.client)
		return
	var/client/usr_client = usr.client
	var/list/paramslist = list()

	if(href_list["statpanel_item_click"])
		switch(href_list["statpanel_item_click"])
			if("left")
				paramslist[LEFT_CLICK] = "1"
			if("right")
				paramslist[RIGHT_CLICK] = "1"
			if("middle")
				paramslist[MIDDLE_CLICK] = "1"
			else
				return

		if(href_list["statpanel_item_shiftclick"])
			paramslist[SHIFT_CLICK] = "1"
		if(href_list["statpanel_item_ctrlclick"])
			paramslist[CTRL_CLICK] = "1"
		if(href_list["statpanel_item_altclick"])
			paramslist[ALT_CLICK] = "1"

		var/mouseparams = list2params(paramslist)
		usr_client.ignore_next_click = FALSE
		usr_client.Click(src, loc, TRUE, mouseparams)
		return TRUE

	if(href_list["desc_lore"])
		show_browser(usr, "<BODY><TT>[replacetext(desc_lore, "\n", "<BR>")]</TT></BODY>", name, name, "size=500x200")
		onclose(usr, "[name]")

///This proc is called on atoms when they are loaded into a shuttle
/atom/proc/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	return

/**
 * Hook for running code when a dir change occurs
 *
 * Not recommended to override, listen for the [COMSIG_ATOM_DIR_CHANGE] signal instead (sent by this proc)
 */
/atom/proc/setDir(newdir)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, dir, newdir)
	dir = newdir


/atom/proc/add_filter(name,priority,list/params)
	LAZYINITLIST(filter_data)
	var/list/p = params.Copy()
	p["priority"] = priority
	filter_data[name] = p
	update_filters()

/atom/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, GLOBAL_PROC_REF(cmp_filter_data_priority), TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))
	UNSETEMPTY(filter_data)

/atom/proc/transition_filter(name, time, list/new_params, easing, loop)
	var/filter = get_filter(name)
	if(!filter)
		return

	var/list/old_filter_data = filter_data[name]

	var/list/params = old_filter_data.Copy()
	for(var/thing in new_params)
		params[thing] = new_params[thing]

	animate(filter, new_params, time = time, easing = easing, loop = loop)
	for(var/param in params)
		filter_data[name][param] = params[param]

/atom/proc/change_filter_priority(name, new_priority)
	if(!filter_data || !filter_data[name])
		return

	filter_data[name]["priority"] = new_priority
	update_filters()

/*/obj/item/update_filters()
	. = ..()
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()*/

/atom/proc/get_filter(name)
	if(filter_data && filter_data[name])
		return filters[filter_data.Find(name)]

/atom/proc/remove_filter(name_or_names)
	if(!filter_data)
		return

	var/found = FALSE
	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(filter_data[name])
			filter_data -= name
			found = TRUE

	if(found)
		update_filters()

/atom/proc/clear_filters()
	filter_data = null
	filters = null


//Shamelessly stolen from TG
/atom/proc/Shake(pixelshiftx = 15, pixelshifty = 15, duration = 250)
	var/initialpixelx = pixel_x
	var/initialpixely = pixel_y
	var/shiftx = rand(-pixelshiftx,pixelshiftx)
	var/shifty = rand(-pixelshifty,pixelshifty)
	animate(src, pixel_x = pixel_x + shiftx, pixel_y = pixel_y + shifty, time = 0.2, loop = duration)
	pixel_x = initialpixelx
	pixel_y = initialpixely

/**
 * Recursive getter method to return a list of all ghosts orbitting this atom
 *
 * This will work fine without manually passing arguments.
 */
/atom/proc/get_all_orbiters(list/processed, source = TRUE)
	var/list/output = list()
	if (!processed)
		processed = list()
	if (src in processed)
		return output
	if (!source)
		output += src
	processed += src
	for(var/atom/atom_orbiter as anything in orbiters?.orbiters)
		output += atom_orbiter.get_all_orbiters(processed, source = FALSE)
	return output

// returns a modifier for how much the tail stab should be cooldowned by
// returning a 0 makes it do nothing
/atom/proc/handle_tail_stab(mob/living/carbon/xenomorph/xeno)
	return TAILSTAB_COOLDOWN_NONE

/atom/proc/handle_flamer_fire(obj/flamer_fire/fire, damage, delta_time)
	return

/atom/proc/handle_flamer_fire_crossed(obj/flamer_fire/fire)
	return

/atom/proc/get_orbit_size()
	var/icon/I = icon(icon, icon_state, dir)
	return (I.Width() + I.Height()) * 0.5

/**
 * Return the markup to for the dropdown list for the VV panel for this atom
 *
 * Override in subtypes to add custom VV handling in the VV panel
 */
/atom/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "-----ATOM-----")
	if(!ismovable(src))
		var/turf/curturf = get_turf(src)
		if(curturf)
			. += "<option value='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[curturf.x];Y=[curturf.y];Z=[curturf.z]'>Jump To</option>"
	VV_DROPDOWN_OPTION(VV_HK_MODIFY_TRANSFORM, "Modify Transform")
	VV_DROPDOWN_OPTION(VV_HK_ADD_REAGENT, "Add Reagent")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EMP, "EMP Pulse")
	VV_DROPDOWN_OPTION(VV_HK_TRIGGER_EXPLOSION, "Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_FILTERS, "Edit Filters")
	VV_DROPDOWN_OPTION(VV_HK_EDIT_COLOR_MATRIX, "Edit Color as Matrix")
	VV_DROPDOWN_OPTION(VV_HK_ENABLEPIXELSCALING, "Enable Pixel Scaling")

/atom/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_ADD_REAGENT] && check_rights(R_VAREDIT))
		if(!reagents)
			var/amount = input(usr, "Specify the reagent size of [src]", "Set Reagent Size", 50) as num|null
			if(amount)
				create_reagents(amount)

		if(reagents)
			var/chosen_id
			switch(tgui_alert(usr, "Choose a method.", "Add Reagents", list("Search", "Choose from a list", "I'm feeling lucky")))
				if("Search")
					var/valid_id
					while(!valid_id)
						chosen_id = input(usr, "Enter the ID of the reagent you want to add.", "Search reagents") as null|text
						if(isnull(chosen_id)) //Get me out of here!
							break
						if (!ispath(text2path(chosen_id)))
							chosen_id = pick_closest_path(chosen_id, make_types_fancy(subtypesof(/datum/reagent)))
							if (ispath(chosen_id))
								valid_id = TRUE
						else
							valid_id = TRUE
						if(!valid_id)
							to_chat(usr, SPAN_WARNING("A reagent with that ID doesn't exist!"))
				if("Choose from a list")
					chosen_id = input(usr, "Choose a reagent to add.", "Choose a reagent.") as null|anything in sort_list(subtypesof(/datum/reagent), GLOBAL_PROC_REF(cmp_typepaths_asc))
				if("I'm feeling lucky")
					chosen_id = pick(subtypesof(/datum/reagent))
			if(chosen_id)
				var/amount = input(usr, "Choose the amount to add.", "Choose the amount.", reagents.maximum_volume) as num|null
				if(amount)
					reagents.add_reagent(chosen_id, amount)
					log_admin("[key_name(usr)] has added [amount] units of [chosen_id] to [src]")
					message_admins(SPAN_NOTICE("[key_name(usr)] has added [amount] units of [chosen_id] to [src]"))

	if(href_list[VV_HK_TRIGGER_EXPLOSION] && check_rights(R_EVENT))
		usr.client.handle_bomb_drop(src)

	if(href_list[VV_HK_TRIGGER_EMP] && check_rights(R_EVENT))
		usr.client.cmd_admin_emp(src)

	if(href_list[VV_HK_MODIFY_TRANSFORM] && check_rights(R_VAREDIT))
		var/result = tgui_input_list(usr, "Choose the transformation to apply","Transform Mod", list("Scale","Translate","Rotate"))
		if(!result)
			return
		var/matrix/M = transform
		if(!result)
			return
		switch(result)
			if("Scale")
				var/x = tgui_input_real_number(usr, "Choose x mod","Transform Mod")
				var/y = tgui_input_real_number(usr, "Choose y mod","Transform Mod")
				if(isnull(x) || isnull(y))
					return
				transform = M.Scale(x,y)
			if("Translate")
				var/x = tgui_input_real_number(usr, "Choose x mod (negative = left, positive = right)","Transform Mod")
				var/y = tgui_input_real_number(usr, "Choose y mod (negative = down, positive = up)","Transform Mod")
				if(isnull(x) || isnull(y))
					return
				transform = M.Translate(x,y)
			if("Rotate")
				var/angle = tgui_input_real_number(usr, "Choose angle to rotate","Transform Mod")
				if(isnull(angle))
					return
				transform = M.Turn(angle)

		SEND_SIGNAL(src, COMSIG_ATOM_VV_MODIFY_TRANSFORM)

	if(href_list[VV_HK_AUTO_RENAME] && check_rights(R_VAREDIT))
		var/newname = tgui_input_text(usr, "What do you want to rename this to?", "Automatic Rename", name)
		if(newname)
			name = newname

	if(href_list[VV_HK_EDIT_FILTERS] && check_rights(R_VAREDIT))
		var/client/C = usr.client
		C?.open_filter_editor(src)

	if(href_list[VV_HK_EDIT_COLOR_MATRIX] && check_rights(R_VAREDIT))
		var/client/C = usr.client
		C?.open_color_matrix_editor(src)

	if(href_list[VV_HK_ENABLEPIXELSCALING])
		if(!check_rights(R_DEBUG|R_VAREDIT))
			return

		enable_pixel_scaling()

/atom/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += "[VV_HREF_TARGETREF(refid, VV_HK_AUTO_RENAME, "<b id='name'>[src]</b>")]"
	. += "<br><font size='1'><a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=left'><<</a> <a href='?_src_=vars;[HrefToken()];datumedit=[refid];varnameedit=dir' id='dir'>[dir2text(dir) || dir]</a> <a href='?_src_=vars;[HrefToken()];rotatedatum=[refid];rotatedir=right'>>></a></font>"
