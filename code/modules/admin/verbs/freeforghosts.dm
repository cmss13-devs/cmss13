/client/proc/free_mob_for_ghosts(mob/living/M in GLOB.living_mob_list)
	set category = null
	set name = "Free for Ghosts"

	if(!src.admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(src, "Only staff members may use this.")
		return

	free_for_ghosts(M, notify = TRUE)

	message_admins("[key_name_admin(usr)] freed [key_name(M)] for ghosts to take.")

/client/proc/free_for_ghosts(mob/living/M in GLOB.living_mob_list, notify)
	if(!ismob(M))
		return

	M.free_for_ghosts(notify)

/mob/proc/free_for_ghosts(notify)
	if(mind || client)
		ghostize(FALSE)

	GLOB.freed_mob_list |= src

	if(!notify)
		return

	notify_ghosts(header = "Freed Mob", message = "A mob is now available for ghosts. Name: [real_name], Job: [job ? job : ""]", enter_link = "claim_freed=[REF(src)]", source = src, action = NOTIFY_ORBIT)

/client/proc/free_all_mobs_in_view()
	set name = "Free All Mobs"
	set category = "Admin.InView"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(src, "Only administrators may use this command.")
		return

	if(alert("This will free ALL mobs within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	for(var/mob/living/M in view(src))
		free_for_ghosts(M, notify = FALSE)

	message_admins(WRAP_STAFF_LOG(usr, "freed all mobs in [get_area(usr)] ([usr.x],[usr.y],[usr.z])"), usr.x, usr.y, usr.z)
