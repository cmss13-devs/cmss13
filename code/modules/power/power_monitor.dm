// the power monitoring computer
// for the moment, just report the status of all APCs in the same powernet
/obj/structure/machinery/power/monitor
	name = "power monitoring computer"
	desc = "It monitors power levels across the station."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "power"

	//computer stuff
	density = TRUE
	anchored = TRUE
	var/circuit = /obj/item/circuitboard/computer/powermonitor
	use_power = USE_POWER_IDLE
	idle_power_usage = 300
	active_power_usage = 300

/obj/structure/machinery/power/monitor/Initialize(mapload, ...)
	. = ..()
	if(!mapload)
		connect_to_network()

/obj/structure/machinery/power/monitor/attack_remote(mob/user)
	add_fingerprint(user)

	if(inoperable())
		return
	interact(user)

/obj/structure/machinery/power/monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(inoperable())
		return
	interact(user)

/obj/structure/machinery/power/monitor/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (inoperable()) )
		if (!isRemoteControlling(user))
			user.unset_interaction()
			close_browser(user, "powcomp")
			return

	user.set_interaction(src)

	var/data = "<TT>"
	data += "<HR><A href='byond://?src=\ref[src];update=1'>Refresh</A> "
	data += "<A href='byond://?src=\ref[src];close=1'>Close</A><HR>"

	if(!powernet)
		data += SPAN_DANGER("No connection.")
	else
		data += "<PRE>"
		data += "Total power: [display_power(powernet.avail)]<BR>"
		data += "Approx load: [display_power(ceil(powernet.viewload))]<BR>"

		data += "<TABLE border=0><FONT SIZE=-1>"

		data += "<tr><td><b>Area</b></td><td><b>Eqp.</b></td><td><b>Lgt.</b></td><td><b>Env.</b></td><td><b>Load</b></td><td><b>Cell</b></td></tr>"
		data += "<tr><td colspan=6><HR></td></tr>"

		var/total_demand = 0
		var/total_actual_usage = 0
		var/list/status = list(" Off","AOff"," On ", " AOn")
		var/list/charge_status = list("N","C","F")

		for(var/obj/structure/machinery/power/apc/current_apc in powernet.nodes)
			data += "<tr>"
			data += "<td>[copytext(add_tspace("[current_apc.area]", 30), 1, 30)]</td>"
			data += "<td>[status[current_apc.equipment + 1]]</td>"
			data += "<td>[status[current_apc.lighting + 1]]</td>"
			data += "<td>[status[current_apc.environ + 1]]</td>"
			data += "<td>[add_lspace(current_apc.lastused_total, 6)]W</td>"
			data += "<td>[current_apc.cell ? "[add_lspace(floor(current_apc.cell.percent()), 3)]% [charge_status[current_apc.charging+1]]" : "  N/C"]</td>"
			data += "</tr>"
			total_demand += current_apc.lastused_total
			total_actual_usage += current_apc.lastused_total_actual

		data += "</FONT></TABLE><HR>"
		data += "Total usage (demand): [display_power(total_actual_usage)] ([display_power(total_demand)])<BR>"
		data += "</PRE>"

	data += "</TT>"

	show_browser(user, data, "Power Monitoring", "powcomp", width = 420, height = 900)


/obj/structure/machinery/power/monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		close_browser(usr, "powcomp")
		usr.unset_interaction()
		return
	if( href_list["update"] )
		src.updateDialog()
		return


/obj/structure/machinery/power/monitor/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "broken"
	else
		if (stat & NOPOWER)
			spawn(rand(0, 15))
				src.icon_state = "power0"
		else
			icon_state = initial(icon_state)


//copied from computer.dm
/obj/structure/machinery/power/monitor/attackby(obj/item/attacking_item, mob/living/user, list/mods)
	if(HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER) && circuit)
		if(user.action_busy)
			return
		playsound(loc, 'sound/items/Screwdriver.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
			var/obj/structure/computerframe/frame = new(loc)
			var/obj/item/circuitboard/computer/board = new circuit(frame)
			frame.circuit = board
			frame.anchored = TRUE
			for(var/obj/current in src)
				current.forceMove(loc)
			if(stat & BROKEN)
				to_chat(user, SPAN_NOTICE("The broken glass falls out."))
				new /obj/item/shard(loc)
				frame.build_state = COMPUTERFRAME_STATE_NO_GLASS
				frame.icon_state = "3"
			else
				to_chat(user, SPAN_NOTICE("You disconnect the monitor."))
				frame.build_state = COMPUTERFRAME_STATE_COMPLETE
				frame.icon_state = "4"
			board.deconstruct(src)
			qdel(src)
		return

	attack_hand(user)
