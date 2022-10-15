/datum/buildmode_mode/outfit
	key = "outfit"
	var/datum/equipment_preset/dressuptime

/datum/buildmode_mode/outfit/Destroy()
	dressuptime = null
	return ..()

/datum/buildmode_mode/outfit/show_help(client/c)
	to_chat(c, "<span class='notice'>***********************************************************\n\
		Right Mouse Button on buildmode button = Select outfit to equip.\n\
		Left Mouse Button on mob/living/carbon/human = Equip the selected outfit.\n\
		Right Mouse Button on mob/living/carbon/human = Strip and delete current outfit.\n\
		***********************************************************</span>")

/datum/buildmode_mode/outfit/Reset()
	. = ..()
	dressuptime = null

/datum/buildmode_mode/outfit/change_settings(client/c)
	dressuptime = tgui_input_list(c?.mob, "Pick a Preset", "Equipment", GLOB.gear_path_presets_list)

/datum/buildmode_mode/outfit/when_clicked(client/c, params, object)
	var/list/modifiers = params2list(params)

	if(!ishuman(object))
		return
	var/mob/living/carbon/human/dollie = object

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isnull(dressuptime))
			to_chat(c, SPAN_WARNING("Pick an outfit first."))
			return

		for (var/item in dollie.get_equipped_items(TRUE))
			qdel(item)
		if(dressuptime)
			arm_equipment(dollie, dressuptime)

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		for (var/item in dollie.get_equipped_items(TRUE))
			qdel(item)
