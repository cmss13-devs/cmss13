/client/proc/free_mob_for_ghosts(var/mob/living/M in GLOB.living_mob_list)
	set category = null
	set name = "Free for Ghosts"

	if(!src.admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(src, "Only staff members may use this.")
		return

	free_for_ghosts(M)

	message_staff("[key_name_admin(usr)] freed [key_name(M)] for ghosts to take.")

/client/proc/free_for_ghosts(var/mob/living/M in GLOB.living_mob_list)
	if(!ismob(M))
		return

	if(M.mind || M.client)
		M.ghostize(FALSE)

	freed_mob_list += M

/client/proc/free_all_mobs_in_view()
	set name = "Free All Mobs"
	set category = "Admin.InView"

	if(!admin_holder || !(admin_holder.rights & R_ADMIN))
		to_chat(src, "Only administrators may use this command.")
		return

	if(alert("This will free ALL mobs within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	for(var/mob/living/M in view())
		free_for_ghosts(M)

	message_staff(WRAP_STAFF_LOG(usr, "freed all mobs in [get_area(usr)] ([usr.x],[usr.y],[usr.z])"), usr.x, usr.y, usr.z)
