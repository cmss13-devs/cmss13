// the power monitoring computer
// for the moment, just report the status of all APCs in the same powernet
/obj/structure/machinery/power/monitor
	name = "power monitoring computer"
	desc = "It monitors power levels across the station."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "power"

	//computer stuff
	density = 1
	anchored = 1.0
	var/circuit = /obj/item/circuitboard/computer/powermonitor
	use_power = 1
	idle_power_usage = 300
	active_power_usage = 300

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
	var/t = "<TT>"

	t += "<BR><HR><A href='?src=\ref[src];update=1'>Refresh</A>"
	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A>"

	if(!powernet)
		t += SPAN_DANGER("No connection")
	else

		var/list/L = list()
		for(var/obj/structure/machinery/power/terminal/term in powernet.nodes)
			if(istype(term.master, /obj/structure/machinery/power/apc))
				var/obj/structure/machinery/power/apc/A = term.master
				L += A

		t += "<PRE>Total power: [powernet.avail] W<BR>Total load:  [num2text(powernet.viewload,10)] W<BR>"

		t += "<FONT SIZE=-1>"

		if(L.len > 0)
			var/total_demand = 0
			t += "Area                           Eqp./Lgt./Env.  Load   Cell<HR>"

			var/list/S = list(" Off","AOff","  On", " AOn")
			var/list/chg = list("N","C","F")

			for(var/obj/structure/machinery/power/apc/A in L)

				t += copytext(add_tspace("\The [A.area]", 30), 1, 30)
				t += " [S[A.equipment+1]] [S[A.lighting+1]] [S[A.environ+1]] [add_lspace(A.lastused_total, 6)]  [A.cell ? "[add_lspace(round(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "  N/C"]<BR>"
				total_demand += A.lastused_total

			t += "<HR>Total demand: [total_demand] W</FONT>"
		t += "</PRE></TT>"

	show_browser(user, t, "Power Monitoring", "powcomp", "size=420x900")


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
/obj/structure/machinery/power/monitor/attackby(obj/item/I, user as mob)
	if(HAS_TRAIT(I, TRAIT_TOOL_SCREWDRIVER) && circuit)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, 1)
		if(do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
			var/obj/structure/computerframe/A = new( src.loc )
			var/obj/item/circuitboard/computer/M = new circuit( A )
			A.circuit = M
			A.anchored = 1
			for (var/obj/C in src)
				C.forceMove(src.loc)
			if (src.stat & BROKEN)
				to_chat(user, SPAN_NOTICE(" The broken glass falls out."))
				new /obj/item/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				to_chat(user, SPAN_NOTICE(" You disconnect the monitor."))
				A.state = 4
				A.icon_state = "4"
			M.deconstruct(src)
			qdel(src)
	else
		src.attack_hand(user)
	return