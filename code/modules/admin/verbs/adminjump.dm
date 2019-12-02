/mob/proc/on_mob_jump()
	return

/mob/dead/observer/on_mob_jump()
	following = null

/client/proc/jump_to_area(var/area/A in return_sorted_areas())
	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	usr.on_mob_jump()
	usr.forceMove(pick(get_area_turfs(A)))

	log_admin("[key_name(usr)] jumped to [A]")
	message_admins("[key_name_admin(usr)] jumped to [A] (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[usr]'>JMP</A>)", 1)


/client/proc/jump_to_turf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"
	set hidden = 1

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
		
	log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
	message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
	usr.on_mob_jump()
	usr.forceMove(T)
	return

/client/proc/jump_to_object(var/obj/O in object_list)
	set name = "Jump to Object"
	set category = "Admin"
	set hidden = 1

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] jumped to [O]")
	message_admins("[key_name_admin(usr)] jumped to [O] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[O.loc.x];Y=[O.loc.y];Z=[O.loc.z]'>JMP</A>)")
	
	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = get_turf(O)
		if(T && isturf(T))
			A.on_mob_jump()
			A.forceMove(T)
		else
			to_chat(A, "This object is not located in the game world.")

/client/proc/jumptomob(var/mob/M in mob_list)
	set name = "Jump to Mob"
	set category = "Admin"
	set hidden = 1

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)] (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[M]'>JMP</A>)")
	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = get_turf(M)
		if(T && isturf(T))
			A.on_mob_jump()
			A.forceMove(T)
		else
			to_chat(A, "This mob is not located in the game world.")

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set name = "Jump to Coordinate"
	set category = "Admin"
	set hidden = 1

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(src.mob)
		var/mob/A = src.mob
		A.on_mob_jump()
		A.x = tx
		A.y = ty
		A.z = tz
		//This is a bit hacky but ensures it works properly
		A.forceMove(A.loc)
			 
	message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz] (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[tx];Y=[ty];Z=[tz]'>JMP</a>)")

/client/proc/jumptokey()
	set name = "Jump to Key"
	set category = "Admin"
	set hidden = 1

	if(!src.admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/keys = list()
	for(var/mob/M in player_list)
		keys += M.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection:mob
	log_admin("[key_name(usr)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)] (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[M]'>JMP</A>)", 1)
	usr.on_mob_jump()
	usr.loc = M.loc

/client/proc/Getmob(var/mob/M in mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	set hidden = 1

	if(!src.admin_holder)
		to_chat(src, "Only administrators may use this command.")
		return

	log_admin("[key_name(usr)] teleported [key_name(M)]")
	message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)]", 1)
	M.on_mob_jump()
	M.loc = get_turf(usr)

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"
	set hidden = 1

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

	log_admin("[key_name(usr)] teleported [key_name(M)]")
	message_admins("[key_name_admin(usr)] teleported [key_name(M)]", 1)

	M.on_mob_jump()
	M.loc = get_turf(usr)

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

		log_admin("[key_name(usr)] teleported [key_name(M)] to [A]")
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)] to [A] <A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[M]'>JMP</A>", 1)
