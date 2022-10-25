/datum/buildmode_mode/outfit
	key = "outfit"
	help = "Right Mouse Button on buildmode button = Select outfit to equip.\n\
		Left Mouse Button on mob/living/carbon/human = Equip the selected outfit.\n\
		Right Mouse Button on mob/living/carbon/human = Strip and delete current outfit."
	var/datum/equipment_preset/dresscode

/datum/buildmode_mode/outfit/Destroy()
	dresscode = null
	return ..()

/datum/buildmode_mode/outfit/Reset()
	. = ..()
	dresscode = null

/datum/buildmode_mode/outfit/change_settings(client/c)
	dresscode = tgui_input_list(c?.mob, "Pick a Preset", "Equipment", GLOB.gear_name_presets_list)

/datum/buildmode_mode/outfit/when_clicked(client/c, params, object)
	var/list/modifiers = params2list(params)

	if(!ismob(object))
		return
	var/mob/living/carbon/human/selected = object

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isnull(dresscode))
			to_chat(c, SPAN_WARNING("Pick an outfit first."))
			return

		for(var/obj/item/I in selected)
			if(istype(I, /obj/item/implant))
				continue
			qdel(I)

		if(!ishuman(selected))
			selected = selected.change_mob_type(/mob/living/carbon/human, null, null, TRUE, "Human")
			if(!ishuman(selected))
				return

		if(!selected.hud_used)
			selected.create_hud()

		arm_equipment(selected, dresscode, FALSE, FALSE)
		message_staff("[key_name_admin(usr)] changed the equipment of [key_name_admin(selected)] to [dresscode].")

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		for(var/item in selected.get_equipped_items(TRUE))
			qdel(item)
