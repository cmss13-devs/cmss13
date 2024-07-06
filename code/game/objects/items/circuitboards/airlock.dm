
/obj/item/circuitboard/airlock
	name = "airlock electronics"
	gender = PLURAL
	icon_state = "door_electronics"
	w_class = SIZE_SMALL
	matter = list("metal" = 50,"glass" = 50)
	req_access = list(ACCESS_CIVILIAN_ENGINEERING)
	var/list/conf_access = null
	/// if set to 1, door would receive req_one_access instead of req_access
	var/one_access = 0
	var/last_configurator = null
	var/locked = 1
	var/fried = FALSE

/obj/item/circuitboard/airlock/update_icon()
	. = ..()
	if(fried)
		icon_state = "door_electronics_smoked"

/obj/item/circuitboard/airlock/attack_self(mob/user as mob)
	if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
		return ..(user)

	var/mob/living/carbon/human/H = user
	if(H.getBrainLoss() >= 60)
		return

	var/t1


	if (last_configurator)
		t1 += "Operator: [last_configurator]<br>"

	if (locked)
		t1 += "<a href='?src=\ref[src];login=1'>Swipe ID</a><hr>"
	else
		t1 += "<a href='?src=\ref[src];logout=1'>Block</a><hr>"

		t1 += "Access requirement is set to "
		t1 += one_access ? "<a style='color: green' href='?src=\ref[src];one_access=1'>ONE</a><hr>" : "<a style='color: red' href='?src=\ref[src];one_access=1'>ALL</a><hr>"

		t1 += conf_access == null ? "<font color=red>All</font><br>" : "<a href='?src=\ref[src];access=all'>All</a><br>"

		t1 += "<br>"

		var/list/accesses = get_access(ACCESS_LIST_MARINE_ALL)
		for (var/acc in accesses)
			var/aname = get_access_desc(acc)

			if (!LAZYLEN(conf_access) || !(acc in conf_access))
				t1 += "<a href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else if(one_access)
				t1 += "<a style='color: green' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
			else
				t1 += "<a style='color: red' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"

	t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)

	show_browser(user, t1, "Access Control", "airlock_electronics")
	onclose(user, "airlock_electronics")


/obj/item/circuitboard/airlock/Topic(href, href_list)
	..()
	if (usr.stat || usr.is_mob_restrained() || (!ishuman(usr) && !istype(usr,/mob/living/silicon)))
		return
	if (href_list["close"])
		close_browser(usr, "airlock")
		return

	if (href_list["login"])
		if(istype(usr,/mob/living/silicon))
			src.locked = 0
			src.last_configurator = usr.name
		else
			var/obj/item/I = usr.get_active_hand()
			if (I && src.check_access(I))
				src.locked = 0
				src.last_configurator = I:registered_name

	if (locked)
		return

	if (href_list["logout"])
		locked = 1

	if (href_list["one_access"])
		one_access = !one_access

	if (href_list["access"])
		toggle_access(href_list["access"])

	attack_self(usr)


/obj/item/circuitboard/airlock/proc/toggle_access(acc)
	if (acc == "all")
		conf_access = null
	else
		var/req = text2num(acc)

		if (conf_access == null)
			conf_access = list()

		if (!(req in conf_access))
			conf_access += req
		else
			conf_access -= req
			if (!length(conf_access))
				conf_access = null


/obj/item/circuitboard/airlock/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
