/mob/proc/on_mob_jump()
	return

/mob/dead/observer/on_mob_jump()
	following = null

/client/proc/jump_to_area(var/area/A in return_sorted_areas())
	set name = "Jump to Area"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!src.mob)
		return

	if(!isobserver(mob))
		src.admin_ghost()

	src.mob.on_mob_jump()
	src.mob.forceMove(pick(get_area_turfs(A)))

	message_staff(WRAP_STAFF_LOG(usr, "jumped to area [get_area(usr)] ([usr.loc.x],[usr.loc.y],[usr.loc.z])."), usr.loc.x, usr.loc.y, usr.loc.z)

/client/proc/jump_to_turf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(!src.mob)
		return
	
	if(!isobserver(mob))
		src.admin_ghost()

	message_staff(WRAP_STAFF_LOG(usr, "jumped to a turf in [T.loc] ([T.x],[T.y],[T.z])."), T.x, T.y, T.z)

	src.mob.on_mob_jump()
	src.mob.forceMove(T)
	return

/client/proc/jump_to_object(var/obj/O in object_list)
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
		message_staff(WRAP_STAFF_LOG(usr, "jumped to [O] in [get_area(O)] ([O.x],[O.y],[O.z])."), O.x, O.y, O.z)

/client/proc/jumptomob(var/mob/M in mob_list)
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
			message_staff(WRAP_STAFF_LOG(usr, "jumped to [key_name(M)] in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z])."), M.loc.x, M.loc.y, M.loc.z)
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
		A.x = tx
		A.y = ty
		A.z = tz
		//This is a bit hacky but ensures it works properly
		A.forceMove(A.loc)

		var/turf/T = get_turf(A)
		if(!T)
			return
		message_staff(WRAP_STAFF_LOG(usr, "jumped to [get_area(usr)] ([T.x],[T.y],[T.z])."), T.x, T.y, T.z)

/client/proc/jumptokey()
	set name = "Jump to Ckey"
	set category = null

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in player_list)
		keys += M.client
	var/client/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection.mob

	if(!mob || !istype(M) || !M.loc)
		return

	if(!isobserver(mob))
		admin_ghost()

	mob.on_mob_jump()
	mob.loc = M.loc
	message_staff("[usr.ckey] jumped to ckey [key_name(M)] in [get_area(M)] ([M.loc.x],[M.loc.y],[M.loc.z]).", M.loc.x, M.loc.y, M.loc.z)

/client/proc/Getmob(var/mob/M)
	set name = "Get Mob"
	set desc = "Mob to teleport"
	set category = null
	set hidden = 1

	if(!src.admin_holder)
		to_chat(src, "Only administrators may use this command.")
		return

	M.on_mob_jump()
	M.loc = get_turf(usr)
	message_staff(WRAP_STAFF_LOG(usr, "teleported [key_name(M)] to themselves in [get_area(usr)] ([usr.x],[usr.y],[usr.z])."), usr.x, usr.y, usr.z)

/client/proc/Getkey()
	set name = "Get Ckey"
	set category = null
	set desc = "Key to teleport"

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in player_list)
		keys += M.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection:mob
	if(!M)
		return

	M.on_mob_jump()
	M.loc = get_turf(usr)
	message_staff(WRAP_STAFF_LOG(usr, "teleported [key_name(M)] to themselves in [get_area(usr)] ([usr.x],[usr.y],[usr.z])."), usr.x, usr.y, usr.z)

/client/proc/sendmob(var/mob/M in sortmobs())
	set category = "Admin"
	set name = "Send Mob"
	set hidden = 1

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/area/A = input(usr, "Pick an area.", "Pick an area") as null|anything in return_sorted_areas()
	if(A)
		M.on_mob_jump()
		M.loc = pick(get_area_turfs(A))
		message_staff(WRAP_STAFF_LOG(usr, "teleported [key_name(M)] to [get_area(M)] ([M.x],[M.y],[M.z])."), M.x, M.y, M.z)