/mob/proc/on_mob_jump()
	return

/mob/dead/observer/on_mob_jump()
	following = null

/client/proc/jump_to_area(area/A in return_sorted_areas())
	set name = "Jump to Area"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!src.mob)
		return

	var/list/area_turfs = get_area_turfs(A)

	if(!length(area_turfs))
		to_chat(src, "There aren't any turfs in this area!")
		return

	if(!isobserver(mob))
		src.admin_ghost()

	src.mob.on_mob_jump()
	src.mob.forceMove(pick(area_turfs))

	message_admins(WRAP_STAFF_LOG(usr, "jumped to area [get_area(usr)] ([usr.loc.x],[usr.loc.y],[usr.loc.z])."), usr.loc.x, usr.loc.y, usr.loc.z)

/client/proc/jump_to_turf(turf/T in GLOB.turfs)
	set name = "Jump to Turf"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!src.mob)
		return

	if(!isobserver(mob))
		src.admin_ghost()

	message_admins(WRAP_STAFF_LOG(usr, "jumped to a turf in [T.loc] ([T.x],[T.y],[T.z])."), T.x, T.y, T.z)

	src.mob.on_mob_jump()
	src.mob.forceMove(T)
	return

/client/proc/jump_to_object(obj/O as obj in world)
	set name = "Jump to Object"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/turf/object_location = get_turf(O)
	if(!isturf(object_location))
		to_chat(usr, "This object is not located in the game world.")
		return

	if(src.mob)
		if(!isobserver(mob))
			src.admin_ghost()

		var/mob/A = src.mob
		A.on_mob_jump()
		A.forceMove(object_location)
		message_admins(WRAP_STAFF_LOG(usr, "jumped to [O] in [get_area(O)] ([O.x],[O.y],[O.z])."), O.x, O.y, O.z)

/client/proc/jumptomob(mob/M in GLOB.mob_list)
	set name = "Jump to Mob"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(src.mob)
		if(!isobserver(mob))
			src.admin_ghost()

		var/mob/A = src.mob
		var/turf/T = get_turf(M)
		if(T && isturf(T))
			A.on_mob_jump()
			A.forceMove(T)
			message_admins(WRAP_STAFF_LOG(usr, "jumped to [key_name(M)] in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z])."), M.loc.x, M.loc.y, M.loc.z)
		else
			to_chat(A, "This mob is not located in the game world.")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set name = "Jump to Coordinate"
	set category = null

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(src.mob)
		if(!isobserver(mob))
			src.admin_ghost()

		var/mob/A = src.mob
		A.on_mob_jump()
		A.forceMove(locate(tx,ty,tz))

		var/turf/T = get_turf(A)
		if(!T)
			return
		message_admins(WRAP_STAFF_LOG(usr, "jumped to [get_area(usr)] ([T.x],[T.y],[T.z])."), T.x, T.y, T.z)

/client/proc/jumptooffsetcoord(tx as num, ty as num)
	set name = "Jump to Offset Coordinate"
	set category = null

	if(!CLIENT_IS_STAFF(src))
		to_chat(src, "Only administrators may use this command.")
		return

	if(src.mob)
		if(!isobserver(mob))
			src.admin_ghost()

		var/mob/A = src.mob
		A.on_mob_jump()
		var/ground_level = 1
		var/list/ground_z_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
		if(length(ground_z_levels))
			ground_level = ground_z_levels[1]

		var/turf/T = locate(deobfuscate_x(tx), deobfuscate_y(ty), ground_level)
		if(!T)
			to_chat(src, SPAN_WARNING("That coordinate is invalid!"))
			return
		A.forceMove(T)
		message_admins(WRAP_STAFF_LOG(src, "jumped to [get_area(mob)] (Coords:[tx]|[ty]) ([T.x],[T.y],[T.z])."), T.x, T.y, T.z)

/client/proc/jumptokey()
	set name = "Jump to Ckey"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = tgui_input_list(usr, "Please, select a player!", "Admin Jumping", sortKey(keys))
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection.mob

	if(!mob || !istype(M) || !M.loc)
		return

	if(!isobserver(mob))
		admin_ghost()

	mob.on_mob_jump()
	mob.forceMove(M.loc)
	message_admins("[usr.ckey] jumped to ckey [key_name(M)] in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z]).", M.loc.x, M.loc.y, M.loc.z)

/client/proc/Getmob(mob/M)
	set name = "Get Mob"
	set desc = "Mob to teleport"
	set category = null
	set hidden = TRUE

	if(!src.admin_holder)
		to_chat(src, "Only administrators may use this command.")
		return

	M.on_mob_jump()
	M.forceMove(get_turf(usr))
	message_admins(WRAP_STAFF_LOG(usr, "teleported [key_name(M)] to themselves in [get_area(usr)] ([usr.x],[usr.y],[usr.z])."), usr.x, usr.y, usr.z)

/client/proc/Getkey()
	set name = "Get Ckey"
	set category = null
	set desc = "Key to teleport"

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/selection = tgui_input_list(usr, "Please, select a player!", "Admin Jumping", sortKey(keys))
	if(!selection)
		return
	var/mob/M = selection:mob
	if(!M)
		return

	M.on_mob_jump()
	M.forceMove(get_turf(usr))
	message_admins(WRAP_STAFF_LOG(usr, "teleported [key_name(M)] to themselves in [get_area(usr)] ([usr.x],[usr.y],[usr.z])."), usr.x, usr.y, usr.z)

/client/proc/sendmob(mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	set hidden = TRUE

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/area/A = tgui_input_list(usr, "Pick an area.", "Pick an area", return_sorted_areas())
	if(A)
		M.on_mob_jump()
		M.forceMove(pick(get_area_turfs(A)))
		message_admins(WRAP_STAFF_LOG(usr, "teleported [key_name(M)] to [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)
