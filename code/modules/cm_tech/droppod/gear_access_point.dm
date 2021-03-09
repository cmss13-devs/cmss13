/obj/structure/techpod_vendor
	name = "ColMarTech Techpod Vendor"
	desc = "A vendor which vends unlocked tech gear."
	icon = 'icons/obj/structures/machinery/vending.dmi'
	icon_state = "intel_gear"
	anchored = TRUE
	wrenchable = FALSE
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

/obj/structure/techpod_vendor/attack_hand(mob/user)
	var/list/list_of_techs = list()
	for(var/i in GLOB.unlocked_droppod_techs)
		var/datum/tech/droppod/droppod_tech = i
		if(!droppod_tech.can_access(user))
			continue

		list_of_techs[droppod_tech.name] = droppod_tech

	if(!length(list_of_techs))
		to_chat(user, SPAN_WARNING("[icon2html(src)] No techs available to take!"))
		return

	var/user_input = tgui_input_list(user, "Choose a tech to retrieve an item from.", name, list_of_techs)
	if(!user_input)
		return

	var/datum/tech/droppod/chosen_tech = list_of_techs[user_input]
	if(!chosen_tech.can_access(user))
		to_chat(user, SPAN_WARNING("[icon2html(src)] You cannot access this tech!"))
		return

	chosen_tech.on_pod_access(user)
