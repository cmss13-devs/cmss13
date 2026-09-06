#define DOWNLOAD_COOLDOWN 30 SECONDS

/**
 * A savefile implementation that handles all data using an alist.
 * Also can export it using JSON too, fancy.
 * If you pass in a null path, it simply acts as a memory tree instead, and cannot be saved.
 */
/datum/byond_save_tree
	var/path = ""
	var/alist/tree
	/// Cooldown that tracks the time between attempts to download the savefile.
	COOLDOWN_DECLARE(download_cooldown)

GENERAL_PROTECT_DATUM(/datum/byond_save_tree)

/datum/byond_save_tree/New(path)
	src.path = path
	tree = alist()
	if(path && fexists(path))
		load()

/**
 * Gets an entry from the tree, with an optional default value.
 */
/datum/byond_save_tree/proc/get_entry(key, default_value)
	return (key in tree) ? tree[key] : default_value

/// Returns whether the key is in the tree
/datum/byond_save_tree/proc/has_entry(key)
	return (key in tree)

/// Sets an entry in the tree to the given value
/datum/byond_save_tree/proc/set_entry(key, value)
	tree[key] = value

/// Removes the given key from the tree
/datum/byond_save_tree/proc/remove_entry(key)
	tree -= key

/// Wipes the entire tree
/datum/byond_save_tree/proc/wipe()
	tree?.Cut()

/datum/byond_save_tree/proc/load()
	if(!path || !fexists(path))
		return FALSE
	try
		var/savefile/data = new(path)
		data["tree"] >> tree
		return TRUE
	catch(var/exception/err)
		stack_trace("failed to load savefile at '[path]': [err]")
		return FALSE

/datum/byond_save_tree/proc/save()
	if(path)
		var/savefile/data = new(path)
		data["tree"] << tree

/// Traverses the entire dir tree of the given savefile and dynamically assembles the tree from it
/datum/byond_save_tree/proc/import_byond_savefile(savefile/savefile)
	tree.Cut()
	var/list/dirs_to_go = list("/" = tree)
	while(length(dirs_to_go))
		var/dir = dirs_to_go[1]
		var/list/region = dirs_to_go[dir]
		dirs_to_go.Cut(1, 2)
		savefile.cd = dir
		for(var/entry in savefile.dir)
			var/entry_value
			savefile.cd = "[dir]/[entry]"
			//eof refers to the path you are cd'ed into, not the savefile as a whole. being false right after cding into an entry means this entry has no buffer, which only happens with nested save file directories
			if (savefile.eof)
				region[entry] = list()
				dirs_to_go["[dir]/[entry]"] = region[entry]
				continue
			READ_FILE(savefile, entry_value) //we are cd'ed to the entry, so we don't need to specify a path to read from
			region[entry] = entry_value

/// Proc that handles generating a JSON file (prettified if 515 and over!) of a user's preferences and showing it to them.
/// Requester is passed in to the ftp() and tgui_alert() procs, and account_name is just used to generate the filename.
/// We don't _need_ to pass in account_name since this is reliant on the byond_save_tree datum already knowing what we correspond to, but it's here to help people keep track of their stuff.
/datum/byond_save_tree/proc/export_json_to_client(mob/requester, account_name)
	if(!istype(requester) || !path)
		return

	if(!json_export_checks(requester))
		return

	COOLDOWN_START(src, download_cooldown, DOWNLOAD_COOLDOWN)
	var/file_name = "[account_name ? "[account_name]_" : ""]preferences_[time2text(world.timeofday, "MMM_DD_YYYY_hh-mm-ss", TIMEZONE_UTC)].json"
	var/temporary_file_storage = "data/preferences_export_working_directory/[file_name]"

	if(!text2file(json_encode(tree, JSON_PRETTY_PRINT), temporary_file_storage))
		tgui_alert(requester, "Failed to export preferences to JSON! You might need to try again later.", "Export Preferences JSON")
		return

	var/exportable_json = file(temporary_file_storage)

	DIRECT_OUTPUT(requester, ftp(exportable_json, file_name))
	fdel(temporary_file_storage)

/// Proc that just handles all of the checks for exporting a preferences file, returns TRUE if all checks are passed, FALSE otherwise.
/// Just done like this to make the code in the export_json_to_client() proc a bit cleaner.
/datum/byond_save_tree/proc/json_export_checks(mob/requester)
	if(!COOLDOWN_FINISHED(src, download_cooldown))
		tgui_alert(requester, "You must wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, download_cooldown))] before exporting your preferences again!", "Export Preferences JSON")
		return FALSE

	if(tgui_alert(requester, "Are you sure you want to export your preferences as a JSON file? This will save to a file on your computer.", "Export Preferences JSON", list("Yes", "Cancel")) == "Yes")
		return TRUE

	return FALSE

/client/verb/export_preferences()
	set name = "Export Preferences"
	set desc = "Export your current preferences to a file."
	set category = "Preferences"

	ASSERT(prefs, "User attempted to export preferences while preferences were null!") // what the fuck

	prefs.savefile.export_json_to_client(usr, ckey)

/// Copies the entire tree to another savefile datum, overwriting whatever was in the other datum before.
/datum/byond_save_tree/proc/copy_to_savefile(datum/byond_save_tree/other_savefile)
	other_savefile.tree = tree.Copy()

#undef DOWNLOAD_COOLDOWN
