/obj/item/device/sentry_computer
	name = "Sentry Computer"
	desc = "A laptop loaded with sentry control software."
	icon = 'icons/obj/structures/props/sentrycomp.dmi'
	icon_state = "sentrycomp_cl"
	var/setup = FALSE
	var/open = FALSE
	var/on = FALSE
	var/obj/structure/machinery/defenses/sentry/paired_sentry = list()

	var/cell_type = /obj/item/cell/high
	var/obj/item/cell/cell
	var/power_consumption = 1
	w_class = SIZE_SMALL
	var/state = 0
	var/screen_state = 0

/obj/item/device/sentry_computer/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type()
		cell.charge = cell.maxcharge

/obj/item/device/sentry_computer/Destroy()
	. = ..()
	QDEL_NULL(cell)

/obj/item/device/sentry_computer/proc/setup(var/obj/structure/surface/target)
	if (do_after(usr, 2, INTERRUPT_NO_NEEDHAND, BUSY_ICON_GENERIC))
		setup = TRUE
		usr.drop_inv_item_to_loc(src, target.loc)
	else
		to_chat(usr, "You fail to setup the laptop")

/obj/item/device/sentry_computer/MouseDrop(atom/dropping, mob/user)
	setup = FALSE
	open = FALSE
	on = FALSE
	icon_state = "sentrycomp_cl"
	STOP_PROCESSING(SSobj, src)
	usr.put_in_any_hand_if_possible(src, disable_warning = TRUE)

/obj/item/device/sentry_computer/attack_hand(mob/user)
	if(setup)
		if(!on)
			icon_state = "sentrycomp_on"
			on = TRUE
			START_PROCESSING(SSobj, src)
		else
			tgui_interact(user)
	else
		..()

/obj/item/device/sentry_computer/get_examine_text()
	. = ..()
	if(cell)
		. += "A [cell.name] is loaded. It has [cell.charge]/[cell.maxcharge] charge remaining."
	else
		. += "It has no battery inserted."

/obj/item/device/sentry_computer/process()
	if(on)
		if(cell)
			var/energy_cost = length(paired_sentry) * power_consumption * CELLRATE
			if(cell.charge >= (energy_cost))
				cell.use(energy_cost)
			else
				icon_state = "sentrycomp_op"

/obj/item/device/sentry_computer/attackby(var/obj/item/object, mob/user)
	if(istype(object, /obj/item/cell))
		var/obj/item/cell/new_cell = object
		to_chat(user, "The new cell contains: [new_cell.charge] power.")
		cell.forceMove(get_turf(user))
		cell = new_cell
		user.drop_inv_item_to_loc(new_cell, src)
		playsound(src,'sound/machines/click.ogg', 25, 1)
	else
		..()

/obj/item/device/sentry_computer/proc/pair_sentry(var/obj/structure/machinery/defenses/sentry/target)
	paired_sentry +=list(target)
	update_static_data_for_all_viewers()

/obj/item/device/sentry_computer/proc/unpair_sentry(var/obj/structure/machinery/defenses/sentry/target)
	paired_sentry -=list(target)
	update_static_data_for_all_viewers()

/obj/item/device/sentry_computer/proc/attempted_link(mob/linker)
	playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)

/obj/item/device/sentry_computer/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(on == FALSE)
		return UI_CLOSE
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		return UI_UPDATE

/obj/item/device/sentry_computer/ui_static_data(mob/user)
	. = list()
	.["sentry_static"] = list()
	var/index = 1
	for(var/sentry in paired_sentry)
		var/list/sentry_holder = list()
		var/obj/structure/machinery/defenses/sentry/sentrygun = sentry
		sentry_holder["selection_menu"] = list()
		sentry_holder["index"] = index
		sentry_holder["name"] = sentrygun.name
		index += 1

		for(var/i in sentrygun.choice_categories)
			sentry_holder["selection_menu"] += list(list("[i]", sentrygun.choice_categories[i]))
		.["sentry_static"] += list(sentry_holder)

/obj/item/device/sentry_computer/ui_data(mob/user)
	. = list()
	.["sentry"] = list()
	.["electrical"] = list("charge" = 0, "max_charge" = 0)
	if(cell)
		.["electrical"]["charge"] = cell.charge
		.["electrical"]["max_charge"] = cell.maxcharge
	// if screen animation has played
	.["screen_state"] = screen_state

	for(var/sentry in paired_sentry)
		var/list/sentry_holder = list()
		var/obj/structure/machinery/defenses/sentry/sentrygun = sentry
		sentry_holder["rounds"] = sentrygun.ammo.current_rounds
		sentry_holder["area"] = get_area(sentrygun)
		sentry_holder["active"] = sentrygun.turned_on
		sentry_holder["engaged"] = length(sentrygun.targets)
		sentry_holder["nickname"] = sentrygun.nickname
		sentry_holder["selection_state"] = list()
		for(var/i in sentrygun.selected_categories)
			sentry_holder["selection_state"] += list(list("[i]", sentrygun.selected_categories[i]))
		.["sentry"] += list(sentry_holder)

/obj/item/device/sentry_computer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SentryGunUI", name)
		ui.open()

/obj/item/device/sentry_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
		to_chat(usr, SPAN_WARNING("You are not authorised to configure the sentry."))
		return
	if(params["index"])
		// the action represents a sentry
		var/sentry_index = params["index"]
		if(paired_sentry[sentry_index])
			paired_sentry[sentry_index].update_choice(usr, action, params["selection"])
		return
	switch(action)
		if("screen-state")
			screen_state = params["state"]


	// non sentry related stuff


