/obj/item/device/sentry_computer
	name = "Sentry Computer"
	desc = "A laptop loaded with sentry control software."
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "laptop_closed"
	var/open = FALSE
	var/on = FALSE
	var/obj/structure/machinery/defenses/sentry/paired_sentry = null

/obj/item/device/sentry_computer/proc/pair_sentry(var/obj/structure/machinery/defenses/sentry/target)
	paired_sentry = target

/obj/item/device/sentry_computer/attack_self(mob/user as mob)
	open = !open
	if(open)
		icon_state = "laptop_on"
	else
		tgui_interact(user)

/obj/item/device/sentry_computer/proc/attempted_link(mob/linker)
	playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)

/obj/item/device/sentry_computer/ui_static_data(mob/user)
	. = list()
	.["paired"] = FALSE
	if(paired_sentry)
		.["paired"] = TRUE
		.["selection_menu"] = list()
		for(var/i in paired_sentry.choice_categories)
			.["selection_menu"] += list(list("[i]", paired_sentry.choice_categories[i]))

/obj/item/device/sentry_computer/ui_data(mob/user)
	. = list()
	if(paired_sentry)
		.["rounds"] = paired_sentry.ammo.current_rounds
		.["selection_state"] = list()
		for(var/i in paired_sentry.selected_categories)
			.["selection_state"] += list(list("[i]", paired_sentry.selected_categories[i]))

/obj/item/device/sentry_computer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SentryGunUI", name)
		ui.open()

/obj/item/device/sentry_computer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
