#define INIT_ORDER_MODPACKS 84

SUBSYSTEM_DEF(modpacks)
	name = "Modpacks"
	init_order = INIT_ORDER_MODPACKS
	flags = SS_NO_FIRE
	var/list/loaded_modpacks = list()
	var/list/tgui_data = list()

/datum/controller/subsystem/modpacks/Initialize()
	var/list/all_modpacks = list()
	for(var/modpack in subtypesof(/datum/modpack/))
		all_modpacks.Add(new modpack)
	// Pre-init and register all compiled modpacks.
	for(var/datum/modpack/package as anything in all_modpacks)
		var/fail_msg = package.pre_initialize()
		if(QDELETED(package))
			CRASH("Modpack of type [package.type] is null or queued for deletion.")
		if(fail_msg)
			CRASH("Modpack [package.name] failed to pre-initialize: [fail_msg].")
		if(loaded_modpacks[package.name])
			CRASH("Attempted to register duplicate modpack name [package.name].")
		loaded_modpacks.Add(package)

	// Handle init and post-init (two stages in case a modpack needs to implement behavior based on the presence of other packs).
	for(var/datum/modpack/package as anything in all_modpacks)
		var/fail_msg = package.initialize()
		if(fail_msg)
			CRASH("Modpack [(istype(package) && package.name) || "Unknown"] failed to initialize: [fail_msg]")
	for(var/datum/modpack/package as anything in all_modpacks)
		var/fail_msg = package.post_initialize()
		if(fail_msg)
			CRASH("Modpack [(istype(package) && package.name) || "Unknown"] failed to post-initialize: [fail_msg]")

	return SS_INIT_SUCCESS

/mob/verb/modpacks_list()
	set name = "Modpacks List"
	set category = "OOC"

	if(!client || !SSmodpacks.initialized)
		return

	if(!length(SSmodpacks.loaded_modpacks))
		to_chat(src, "Этот сервер не использует какие-либо модификации.")
		return

	SSmodpacks.tgui_interact(src)

/datum/controller/subsystem/modpacks/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ModpacksList", name)
		ui.open()
	ui.set_autoupdate(FALSE)

/datum/controller/subsystem/modpacks/ui_state(mob/user)
	return GLOB.always_state

/datum/controller/subsystem/modpacks/ui_static_data(mob/user)
	var/list/data = list()

	if(!length(tgui_data))
		tgui_data = generate_modpacks_data()
	data["modpacks"] = tgui_data

	return data

/datum/controller/subsystem/modpacks/proc/generate_modpacks_data()
	var/list/modpacks = list()
	for(var/datum/modpack/modpack as anything in loaded_modpacks)
		if(modpack.name)
			modpacks += list(list(
				"name" = modpack.name,
				"desc" = modpack.desc,
				"author" = modpack.author
			))
	return modpacks
