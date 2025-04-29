/// Which thunderdome the admin currently has spawned in
/datum/admins/var/datum/personal_thunderdome/personal_thunderdome

GLOBAL_LIST_EMPTY_TYPED(personal_thunderdomes, /datum/personal_thunderdome)

/datum/personal_thunderdome

	/// Which type of thunderdome has been selected by the user
	var/datum/lazy_template/dome_type

	/// The currently spawned in thunderdome
	var/datum/turf_reservation/active

	/// The ckey of the user that created this thunderdome
	var/ckey

	/// The reference to the client that spawned in this thunderdome
	var/client/parent

/datum/personal_thunderdome/New(datum/lazy_template/dome_type, datum/turf_reservation/active, client/parent)
	src.dome_type = dome_type
	src.active = active

	if(parent)
		src.parent = parent
		ckey = parent.ckey

/datum/personal_thunderdome/Destroy(force, ...)
	. = ..()

	GLOB.personal_thunderdomes -= ckey
	QDEL_NULL(active)
	parent = null

/datum/personal_thunderdome/proc/get_spawn_turf()
	return active.bottom_left_turfs[1]

/// Returns a list of all the turfs within a thunderdome
/datum/personal_thunderdome/proc/get_all_turfs()
	return block(active.bottom_left_turfs[1], active.top_right_turfs[length(active.top_right_turfs)])

/datum/personal_thunderdome/proc/get_map_name()
	return dome_type::map_name + ".dmm"

/datum/admins/proc/clear_thunderdome()
	QDEL_NULL(personal_thunderdome)

	to_chat(owner, SPAN_NOTICE("Personal thunderdome destroyed."))

	remove_verb(owner, /client/proc/dispel_my_thunderdome)
	add_verb(owner, /client/proc/summon_thunderdome)

/client/proc/summon_thunderdome()
	set name = "Summon Thunderdome"
	set category = "Admin.Thunderdome"

	if(!check_rights(R_EVENT))
		return

	var/static/list/thunderdomes = subtypesof(/datum/lazy_template/thunderdome)
	var/to_use = tgui_input_list(src, "Which thunderdome to use?", "Thunderdome Selection", thunderdomes)

	if(!to_use)
		return

	var/should_announce = tgui_alert(src, "Do you wish to announce the new thunderdome to dead chat?", "Announce Thunderdome", list("Yes", "No"))

	if(isnull(should_announce))
		return
	should_announce = should_announce == "Yes"

	var/datum/turf_reservation/dome = SSmapping.lazy_load_template(to_use, force = TRUE)
	if(!dome)
		to_chat(src, SPAN_WARNING("Thunderdome summoning failed."))
		return

	admin_holder.personal_thunderdome = new(to_use, dome, src)
	GLOB.personal_thunderdomes[ckey] = admin_holder.personal_thunderdome

	to_chat(src, SPAN_NOTICE("Thunderdome summoning complete."))
	var/turf/spawn_turf = admin_holder.personal_thunderdome.get_spawn_turf()
	mob.forceMove(spawn_turf)

	if(should_announce)
		notify_ghosts("A thunderdome has been spawned in!", header = "Thunderdome!", source = mob, extra_large = TRUE)

	message_admins("[key_name_admin(src)] has spawned in their thunderdome.", spawn_turf.x, spawn_turf.y, spawn_turf.z)

	add_verb(src, /client/proc/dispel_my_thunderdome)
	remove_verb(src, /client/proc/summon_thunderdome)

/client/proc/dispel_my_thunderdome()
	set name = "Dispel My Thunderdome"
	set category = "Admin.Thunderdome"

	if(!check_rights(R_EVENT))
		return

	if(!admin_holder.personal_thunderdome)
		to_chat(src, SPAN_WARNING("You do not have a currently summoned thunderdome."))
		return

	var/confirm = tgui_alert(src, "Are you sure you want to dispel your thunderdome?", "Dispel Thunderdome", list("Yes", "No")) == "Yes"
	if(!confirm)
		return

	message_admins("[key_name_admin(src)] has destroyed their thunderdome.")
	admin_holder.clear_thunderdome()

/client/proc/dispel_any_thunderdome()
	set name = "Dispel Any Thunderdome"
	set category = "Admin.Thunderdome"

	if(!check_rights(R_EVENT))
		return

	if(!length(GLOB.personal_thunderdomes))
		to_chat(src, SPAN_WARNING("No thunderdomes are currently summoned."))
		return

	var/to_dispel = tgui_input_list(src, "Which admin's thunderdome should be dispelled?", "Thunderdome Destruction", GLOB.personal_thunderdomes)
	if(!to_dispel)
		return

	message_admins("[key_name_admin(src)] has destroyed [to_dispel]'s thunderdome.")
	GLOB.admin_datums[to_dispel].clear_thunderdome()

/client/proc/clean_thunderdome()
	set name = "Clean Thunderdomes"
	set category = "Admin.Thunderdome"

	if(!check_rights(R_EVENT))
		return

	if(!length(GLOB.personal_thunderdomes))
		to_chat(src, SPAN_WARNING("No thunderdomes are currently summoned."))
		return

	var/datum/personal_thunderdome/affected_thunderdome

	if(admin_holder.personal_thunderdome && length(GLOB.personal_thunderdomes) == 1)
		affected_thunderdome = admin_holder.personal_thunderdome

	if(!affected_thunderdome)
		var/admin_to_use = tgui_input_list(src, "Which admin's thunderdome should be cleaned?", "Thunderdome Reset", GLOB.personal_thunderdomes)
		if(!admin_to_use)
			return

		affected_thunderdome = GLOB.personal_thunderdomes[admin_to_use]

	if(!affected_thunderdome)
		return

	var/delete_mobs = tgui_alert(usr, "WARNING: Deleting large amounts of mobs causes lag. Clear all mobs?", "Thunderdome Reset", list("Yes", "No", "Cancel"))
	if(!delete_mobs || delete_mobs == "Cancel")
		return

	message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] reset [affected_thunderdome.ckey]'s thunderdome to default with delete_mobs marked as [delete_mobs]."))

	SSthunderdome.schedule_cleaning(
		affected_thunderdome,
		delete_mobs == "No",
	)

/datum/lazy_template/thunderdome
	map_dir = parent_type::map_dir + "/thunderdome"

/datum/lazy_template/thunderdome/generic
	map_name = "generic"

/datum/lazy_template/thunderdome/snakey
	map_name = "snakey"
