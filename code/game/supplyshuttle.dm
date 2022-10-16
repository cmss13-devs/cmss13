//Config stuff
#define SUPPLY_STATION_AREATYPE /area/supply/station //Type of the supply shuttle area for station
#define SUPPLY_STATION_AREATYPE_VEHICLE /area/supply/station/vehicle
#define SUPPLY_DOCK_AREATYPE /area/supply/dock	//Type of the supply shuttle area for dock
#define SUPPLY_DOCK_AREATYPE_VEHICLE /area/supply/dock/vehicle
#define SUPPLY_COST_MULTIPLIER 1.08
#define ASRS_COST_MULTIPLIER 1.2

var/datum/controller/supply/supply_controller = new()

/area/supply/station //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER

/area/supply/dock //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "Supply Shuttle"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

/area/supply/station_vehicle //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "Vehicle ASRS"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

/area/supply/dock_vehicle //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	name = "Vehicle ASRS"
	icon_state = "shuttle3"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0

//SUPPLY PACKS MOVED TO /code/defines/obj/supplypacks.dm

/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "Completely impassable - or are they?"
	icon = 'icons/obj/structures/props/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = 0
	anchored = 1
	layer = MOB_LAYER
	var/collide_message_busy	// Timer to stop collision spam

/obj/structure/plasticflaps/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = PASS_UNDER|PASS_THROUGH

/obj/structure/plasticflaps/BlockedPassDirs(atom/movable/mover, target_dir)
	if((mover.pass_flags.flags_pass & pass_flags.flags_can_pass_all) || !iscarbon(mover))
		return NO_BLOCKED_MOVEMENT

	return BLOCKED_MOVEMENT

/obj/structure/plasticflaps/Collided(atom/movable/AM)
	var/mob/living/carbon/C = AM
	if (!istype(C))
		return
	if (isHumanStrict(C))
		return
	if(collide_message_busy > world.time)
		return

	collide_message_busy = world.time + 3 SECONDS
	C.visible_message(SPAN_NOTICE("[C] tries to go through \the [src]."), \
	SPAN_NOTICE("You try to go through \the [src]."))

	if(do_after(C, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		C.forceMove(get_turf(src))

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(5))
				qdel(src)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "\improper Airtight plastic flaps"
	desc = "Heavy-duty, airtight, plastic flaps."


/obj/structure/machinery/computer/supplycomp
	name = "ASRS console"
	desc = "A console for the Automated Storage Retrieval System"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	density = TRUE
	req_access = list(ACCESS_MARINE_CARGO)
	circuit = /obj/item/circuitboard/computer/supplycomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/hacked = 0
	var/can_order_contraband = 0
	var/last_viewed_group = "categories"

/obj/structure/machinery/computer/ordercomp
	name = "Supply ordering console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "request"
	density = TRUE
	circuit = /obj/item/circuitboard/computer/ordercomp
	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/last_viewed_group = "categories"

/obj/structure/machinery/computer/supply_drop_console
	name = "Supply Drop Console"
	desc = "An old-fashioned computer hooked into the nearby Supply Drop system."
	icon_state = "security_cam"
	circuit = /obj/item/circuitboard/computer/supply_drop_console
	req_access = list(ACCESS_MARINE_CARGO)
	var/x_supply = 0
	var/y_supply = 0
	var/datum/squad/current_squad = null
	var/busy = FALSE //The computer is busy launching a drop, lock controls
	var/drop_cooldown = 1 MINUTES
	var/can_pick_squad = TRUE
	var/faction = FACTION_MARINE
	var/obj/structure/closet/crate/loaded_crate
	COOLDOWN_DECLARE(next_fire)

/obj/structure/machinery/computer/supply_drop_console/ui_status(mob/user)
	. = ..()
	if(inoperable(MAINT))
		return UI_CLOSE

/obj/structure/machinery/computer/supply_drop_console/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_state

/obj/structure/machinery/computer/supply_drop_console/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SupplyDropConsole", name)
		ui.open()

/obj/structure/machinery/computer/supply_drop_console/ui_static_data(mob/user)
	var/list/data = list()

	var/list/squad_list = list()
	for(var/datum/squad/S in RoleAuthority.squads)
		if(S.active && S.faction == faction && S.color)
			squad_list += list(list(
				"squad_name" = S.name,
				"squad_color" = squad_colors[S.color]
				))

	data["can_pick_squad"] = can_pick_squad
	data["squad_list"] = squad_list

	return data

/obj/structure/machinery/computer/supply_drop_console/ui_data(mob/user)
	var/list/data = list()

	check_pad()
	data["current_squad"] = current_squad
	data["launch_cooldown"] = drop_cooldown
	data["nextfiretime"] = next_fire
	data["worldtime"] = world.time
	data["x_offset"] = x_supply
	data["y_offset"] = y_supply
	data["active"] = busy
	data["loaded"] = loaded_crate
	if(loaded_crate)
		data["crate_name"] = loaded_crate.name
	else
		data["crate_name"] = null

	return data

/obj/structure/machinery/computer/supply_drop_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_x")
			var/new_x = text2num(params["set_x"])
			if(!new_x)
				return
			x_supply = new_x
			. = TRUE

		if("set_y")
			var/new_y = text2num(params["set_y"])
			if(!new_y)
				return
			y_supply = new_y
			. = TRUE

		if("pick_squad")
			if(can_pick_squad)
				var/datum/squad/selected = get_squad_by_name(params["squad_name"])
				if(selected)
					current_squad = selected
					attack_hand(usr)
					. = TRUE
				else
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")
					. = TRUE

		if("send_beacon")
			if(current_squad)
				if(!COOLDOWN_FINISHED(src, next_fire))
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Supply drop not yet available! Please wait [COOLDOWN_TIMELEFT(src, next_fire)/10] seconds!")]")
					return
				else
					handle_supplydrop()
					. = TRUE

		if("refresh_pad")
			check_pad()
			. = TRUE

/obj/structure/machinery/computer/supply_drop_console/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return TRUE
	tgui_interact(user)
	return

/obj/structure/machinery/computer/supply_drop_console/proc/check_pad()
	if(!current_squad.drop_pad)
		loaded_crate = null
		return FALSE
	var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc
	if(C)
		loaded_crate = C
		return C
	else
		loaded_crate = null
		return FALSE

/obj/structure/machinery/computer/supply_drop_console/proc/handle_supplydrop()
	if(busy)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("\The [name] is busy processing another action!")]")
		return

	var/obj/structure/closet/crate/C = check_pad()
	if(!C)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No crate was detected on the drop pad. Get Requisitions on the line!")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)
	if(!T)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Error, invalid coordinates.")]")
		return

	var/area/A = get_area(T)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone is underground. The supply drop cannot reach here.")]")
		return

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone appears to be obstructed or out of bounds. Package would be lost on drop.")]")
		return

	busy = TRUE

	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("'[C.name]' supply drop is now loading into the launch tube! Stand by!")]")
	C.visible_message(SPAN_WARNING("\The [C] begins to load into a launch tube. Stand clear!"))
	C.anchored = TRUE //To avoid accidental pushes
	send_to_squad("'[C.name]' supply drop incoming. Heads up!")
	var/datum/squad/S = current_squad //in case the operator changes the overwatched squad mid-drop
	spawn(100)
		if(!C || C.loc != S.drop_pad.loc) //Crate no longer on pad somehow, abort.
			if(C)
				C.anchored = FALSE
			to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Launch aborted! No crate detected on the drop pad.")]")
			return
		COOLDOWN_START(src, next_fire, drop_cooldown)
		if(ismob(usr))
			var/mob/M = usr
			M.count_niche_stat(STATISTICS_NICHE_CRATES)

		playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
		C.anchored = FALSE
		C.forceMove(T)
		var/turf/TC = get_turf(C)
		TC.ceiling_debris_check(3)
		playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehhhhhhhhh.
		C.visible_message("[icon2html(C, viewers(src))] [SPAN_BOLDNOTICE("The '[C.name]' supply drop falls from the sky!")]")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("'[C.name]' supply drop launched! Another launch will be available in five minutes.")]")
		busy = FALSE


//Sends a string to our currently selected squad.
/obj/structure/machinery/computer/supply_drop_console/proc/send_to_squad(var/txt = "", var/plus_name = 0, var/only_leader = 0)
	if(txt == "" || !current_squad) return //Logic

	var/text = strip_html(txt)
	var/nametext = ""
	if(plus_name)
		nametext = "[usr.name] transmits: "
		text = "<font size='3'><b>[text]<b></font>"

	for(var/mob/living/carbon/human/M in current_squad.marines_list)
		if(!M.stat && M.client) //Only living and connected people in our squad
			if(!only_leader)
				if(plus_name)
					M << sound('sound/effects/radiostatic.ogg')
				to_chat(M, "[icon2html(src, M)] [SPAN_BLUE("<B>\[Overwatch\]:</b> [nametext][text]")]")
			else
				if(current_squad.squad_leader == M)
					if(plus_name)
						M << sound('sound/effects/radiostatic.ogg')
					to_chat(M, "[icon2html(src, M)] [SPAN_BLUE("<B>\[SL Overwatch\]:</b> [nametext][text]</font>")]")
					return

//A limited version of the above console
//Can't pick squads, drops less often
//Uses Echo squad as a placeholder to access its own drop pad
/obj/structure/machinery/computer/supply_drop_console/limited
	circuit = /obj/item/circuitboard/computer/supply_drop_console/limited
	drop_cooldown = 5 MINUTES //higher cooldown than usual
	can_pick_squad = FALSE//Can't pick squads

/obj/structure/machinery/computer/supply_drop_console/limited/New()
	..()
	current_squad = get_squad_by_name("Echo") //Hardwired into Echo

/obj/structure/machinery/computer/supply_drop_console/limited/attack_hand(mob/user)
	if(!current_squad)
		current_squad = get_squad_by_name("Echo") //Hardwired into Echo
	. = ..()

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/old_stuff/mark.dmi'
	name = "X"
	invisibility = 101
	anchored = 1
	opacity = 0
*/

/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/approvedby = null

/datum/controller/supply
	var/processing = 1
	var/processing_interval = 300
	var/iteration = 0
	//supply points
	var/points = 120
	var/points_per_process = 1.5
	var/points_per_slip = 1
	var/points_per_crate = 2

	var/base_random_crate_interval = 10 //Every how many processing intervals do we get a random crates.

	var/crate_iteration = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	var/list/random_supply_packs = list()
	//shuttle movement
	var/datum/shuttle/ferry/supply/shuttle

	//dropship part fabricator's points, so we can reference them globally (mostly for DEFCON)
	var/dropship_points = 10000 //gains roughly 18 points per minute | Original points of 5k doubled due to removal of prespawned ammo.
	var/tank_points = 0

	New()
		ordernum = rand(1,9000)

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
/datum/controller/supply/process()
	for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs - /datum/supply_packs/asrs))
		var/datum/supply_packs/P = new typepath()
		supply_packs[P.name] = P
	for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs - /datum/supply_packs/asrs))
		var/datum/supply_packs/P = new typepath()
		if(P.cost > 1 && P.buyable == 0)
			random_supply_packs[P.name] = P
	spawn(0)
		set background = 1
		while(1)
			if(processing)
				iteration++
				points += points_per_process
				if(iteration >= 20 && iteration % base_random_crate_interval == 0 && supply_controller.shoppinglist.len <= 20)
					add_random_crates()
					crate_iteration++
			sleep(processing_interval)

//This adds function adds the amount of crates that calculate_crate_amount returns
/datum/controller/supply/proc/add_random_crates()
	for(var/I=0, I<calculate_crate_amount(), I++)
		add_random_crate()

//Here we calculate the amount of crates to spawn.
//Marines get one crate for each the amount of marines on the surface devided by the amount of marines per crate.
//They always get the mincrates amount.
/datum/controller/supply/proc/calculate_crate_amount()

	// Sqrt(NUM_XENOS/4)
	var/crate_amount = Floor(max(0, sqrt(SSticker.mode.count_xenos(SSmapping.levels_by_trait(ZTRAIT_GROUND))/3)))

	if(crate_iteration <= 5)
		crate_amount = 4

	return crate_amount

//Here we pick what crate type to send to the marines.
/datum/controller/supply/proc/add_random_crate()
	var/randpick = rand(1,100)
	switch(randpick)
		if(1 to 40)
			pickcrate("Munition")
		if(41 to 81)
			pickcrate("Utility")
		if(81 to 100)
			pickcrate("Everything")

//Here we pick the exact crate from the crate types to send to the marines.
//This is a weighted pick based upon their cost.
//Their cost will go up if the crate is picked
/datum/controller/supply/proc/pickcrate(var/T = "Everything")
	var/list/pickfrom = list()
	for(var/supply_name in supply_controller.random_supply_packs)
		var/datum/supply_packs/N = supply_controller.random_supply_packs[supply_name]
		if((T == "Everything" || N.group == T)  && !N.buyable)
			pickfrom += N
	var/datum/supply_packs/C = supply_controller.pick_weighted_crate(pickfrom)
	if(C == null)
		return
	C.cost = round(C.cost * ASRS_COST_MULTIPLIER) //We still do this to raise the weight
	//We have to create a supply order to make the system spawn it. Here we transform a crate into an order.
	var/datum/supply_order/O = new /datum/supply_order()
	O.ordernum = supply_controller.ordernum
	O.object = C
	O.orderedby = "ASRS"
	O.approvedby = "ASRS"
	//We add the order to the shopping list
	supply_controller.shoppinglist += O

//Here we weigh the crate based upon it's cost
/datum/controller/supply/proc/pick_weighted_crate(list/cratelist)
	var/weighted_crate_list[]
	for(var/datum/supply_packs/crate in cratelist)
		var/crate_to_add[0]
		var/weight = (round(10000/crate.cost))
		if(iteration > crate.iteration_needed)
			crate_to_add[crate] = weight
			weighted_crate_list += crate_to_add
	return pickweight(weighted_crate_list)

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/controller/supply/proc/forbidden_atoms_check(atom/A)
	if(istype(A,/mob/living))
		return 1
	if(istype(A,/obj/item/disk/nuclear))
		return 1
	if(istype(A,/obj/item/device/radio/beacon))
		return 1
	if(istype(A,/obj/item/stack/sheet/mineral/phoron))
		return 1

	for(var/i=1, i<=A.contents.len, i++)
		var/atom/B = A.contents[i]
		if(.(B))
			return 1

// Called when the elevator is lowered.
/datum/controller/supply/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)
		return

	// Sell crates.
	for(var/obj/structure/closet/crate/C in area_shuttle)
		points += points_per_crate
		qdel(C)

	// Sell manifests.
	for(var/atom/movable/MA in area_shuttle)
		if(istype(MA, /obj/item/paper/manifest))
			var/obj/item/paper/manifest/M = MA
			if(M.stamped && M.stamped.len)
				points += points_per_slip

		// Delete everything else.
		qdel(MA)

//Buyin
/datum/controller/supply/proc/buy()
	var/area/area_shuttle = shuttle?.get_location_area()
	if(!area_shuttle || !shoppinglist.len)
		return

	// Try to find an available turf to place our package
	var/list/turf/clear_turfs = list()
	for(var/turf/T in area_shuttle)
		if(T.density || T.contents?.len)
			continue
		clear_turfs += T

	for(var/datum/supply_order/order in shoppinglist)
		// No space! Forget buying, it's no use.
		if(!clear_turfs.len)
			shoppinglist.Cut()
			return

		// Container generation
		var/turf/target_turf = pick(clear_turfs)
		clear_turfs.Remove(target_turf)
		var/atom/container = target_turf
		var/datum/supply_packs/package = order.object
		if(package.containertype)
			container = new package.containertype(target_turf)
			if(package.containername)
				container.name = package.containername

		// Lock it up if it's something that can be
		if(isobj(container) && package.access)
			var/obj/lockable = container
			lockable.req_access = list(package.access)

		// Contents generation
		var/list/content_names = list()
		var/list/content_types = package.contains
		if(package.randomised_num_contained)
			content_types = list()
			for(var/i in 1 to package.randomised_num_contained)
				content_types += pick(package.contains)
		for(var/typepath in content_types)
			var/atom/item = new typepath(container)
			content_names += item.name

		// Manifest generation
		var/obj/item/paper/manifest/slip
		if(!package.contraband) // I'm sorry boss i misplaced it...
			slip = new /obj/item/paper/manifest(container)
			slip.ordername = package.name
			slip.ordernum = order.ordernum
			slip.orderedby = order.orderedby
			slip.approvedby = order.approvedby
			slip.packages = content_names
			slip.generate_contents()
			slip.update_icon()
	shoppinglist.Cut()

/obj/item/paper/manifest
	name = "Supply Manifest"
	var/ordername
	var/ordernum
	var/orderedby
	var/approvedby
	var/list/packages


/obj/item/paper/manifest/read_paper(mob/user)
	// Tossing ref in widow id as this allows us to read multiple manifests at same time
	show_browser(user, "<BODY class='paper'>[info][stamps]</BODY>", null, "manifest\ref[src]", "size=550x650")
	onclose(user, "manifest\ref[src]")

/obj/item/paper/manifest/proc/generate_contents()
	// You don't tell anyone this is inspired from player-made fax layouts,
	// or else, capiche ? Yes this is long, it's 80 col standard
	info = "                                                                  \
        <style>                                                               \
            #container { width: 500px; min-height: 500px; margin: 25px auto;  \
                    font-family: monospace; padding: 0; font-size: 130% }     \
            #title { font-size: 250%; letter-spacing: 8px;                    \
                    font-weight: bolder; margin: 20px auto }                  \
            .header { font-size: 130%; text-align: center; }                  \
            .important { font-variant: small-caps; font-size = 130%;          \
                         font-weight: bolder; }                               \
            .tablelabel { width: 150px; }                                     \
            .field { font-style: italic; }                                    \
            li { list-style-type: disc; list-style-position: inside; }        \
            table { table-layout: fixed }                                     \
        </style><div id='container'>                                          \
        <div class='header'>                                                  \
            <p id='title' class='important'>A.S.R.S.</p>                      \
            <p class='important'>Automatic Storage Retrieval System</p>       \
            <p class='field'>Order #[ordernum]</p>                            \
        </div><hr><table>                                                     \
        <colgroup>                                                            \
            <col class='tablelabel important'>                                \
            <col class='field'>                                               \
        </colgroup>                                                           \
        <tr><td>Shipment:</td>                                                \
        <td>[ordername]</td></tr>                                             \
        <tr><td>Ordered by:</td>                                              \
        <td>[orderedby]</td></tr>                                             \
        <tr><td>Approved by:</td>                                             \
        <td>[approvedby]</td></tr>                                            \
        <tr><td># packages:</td>                                              \
        <td class='field'>[packages.len]</td></tr>                            \
        </table><hr><p class='header important'>Contents</p>                  \
        <ul class='field'>"

	for(var/packagename in packages)
		info += "<li>[packagename]</li>"

	info += "                                                                 \
        </ul><br/><hr><br/><p class='important header'>                       \
            Please stamp below and return to confirm receipt of shipment      \
        </p></div>"

	name = "[name] - [ordername]"

/obj/structure/machinery/computer/ordercomp/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/supplycomp/attack_remote(var/mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/ordercomp/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat
	if(temp)
		dat = temp
	else
		var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
		if (shuttle)
			dat += {"Location: [shuttle.has_arrive_time() ? "Raising platform":shuttle.at_station() ? "Raised":"Lowered"]<BR>
			<HR>Supply budget: $[supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>
		<BR>\n<A href='?src=\ref[src];order=categories'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	show_browser(user, dat, "Automated Storage and Retrieval System", "computer", "size=575x450")
	return

/obj/structure/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return

	if( isturf(loc) && (in_range(src, usr) || ishighersilicon(usr)) )
		usr.set_interaction(src)

	if(href_list["order"])
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply budget: $[supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/supply_group_name in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<b>Supply budget: $[supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_name in supply_controller.supply_packs )
				var/datum/supply_packs/N = supply_controller.supply_packs[supply_name]
				if(N.hidden || N.contraband || N.group != last_viewed_group || !N.buyable) continue								//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: $[round(N.cost) * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>"		//the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_controller.supply_packs[href_list["doorder"]]
		if(!istype(P))	return

		if(P.hidden || P.contraband || !P.buyable)
			return

		var/timeout = world.time + 600
		var/reason = strip_html(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(world.time > timeout)	return
		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(ishighersilicon(usr))
			idname = usr.real_name

		supply_controller.ordernum++
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_controller.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(P.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		O.object = P
		O.orderedby = idname
		supply_controller.requestlist += O

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_controller.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.approvedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in supply_controller.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(!is_mainship_level(z)) return
	if(!allowed(user))
		to_chat(user, SPAN_DANGER("Access Denied."))
		return

	if(..())
		return
	user.set_interaction(src)
	post_signal("supply")
	var/dat
	if (temp)
		dat = temp
	else
		var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
		if (shuttle)
			dat += "\nPlatform position: "
			if (shuttle.has_arrive_time())
				dat += "Moving<BR>"
			else
				if (shuttle.at_station())
					if (shuttle.docking_controller)
						switch(shuttle.docking_controller.get_docking_status())
							if ("docked") dat += "Raised<BR>"
							if ("undocked") dat += "Lowered<BR>"
							if ("docking") dat += "Raising [shuttle.can_force()? SPAN_WARNING("<A href='?src=\ref[src];force_send=1'>Force</A>") : ""]<BR>"
							if ("undocking") dat += "Lowering [shuttle.can_force()? SPAN_WARNING("<A href='?src=\ref[src];force_send=1'>Force</A>") : ""]<BR>"
					else
						dat += "Raised<BR>"

					if (shuttle.can_launch())
						dat += "<A href='?src=\ref[src];send=1'>Lower platform</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='?src=\ref[src];cancel_send=1'>Cancel</A>"
					else
						dat += "*ASRS is busy*"
					dat += "<BR>\n<BR>"
				else
					dat += "Lowered<BR>"
					if (shuttle.can_launch())
						dat += "<A href='?src=\ref[src];send=1'>Raise platform</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='?src=\ref[src];cancel_send=1'>Cancel</A>"
					else
						dat += "*ASRS is busy*"
					dat += "<BR>\n<BR>"


		dat += {"<HR>\nSupply budget: $[supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>\n<BR>
		\n<A href='?src=\ref[src];order=categories'>Order items</A><BR>\n<BR>
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}


	show_browser(user, dat, "Automated Storage and Retrieval System", "computer", "size=575x450")
	return

/obj/structure/machinery/computer/supplycomp/Topic(href, href_list)
	if(!is_mainship_level(z)) return
	if(!supply_controller)
		world.log << "## ERROR: Eek. The supply_controller controller datum is missing somehow."
		return
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
	if (!shuttle)
		world.log << "## ERROR: Eek. The supply/shuttle datum is missing somehow."
		return
	if(..())
		return

	if(ismaintdrone(usr))
		return

	if(isturf(loc) && ( in_range(src, usr) || ishighersilicon(usr) ) )
		usr.set_interaction(src)

	//Calling the shuttle
	if(href_list["send"])
		if(shuttle.at_station())
			if (shuttle.forbidden_atoms_check())
				temp = "For safety reasons, the Automated Storage and Retrieval System cannot store live organisms, classified nuclear weaponry or homing beacons.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			else
				shuttle.launch(src)
				temp = "Lowering platform. \[[SPAN_WARNING("<A href='?src=\ref[src];force_send=1'>Force</A>")]\]<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		else
			shuttle.launch(src)
			temp = "Raising platform.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			post_signal("supply")

	if (href_list["force_send"])
		shuttle.force_launch(src)

	if (href_list["cancel_send"])
		shuttle.cancel_launch(src)

	else if (href_list["order"])
		//if(!shuttle.idle()) return	//this shouldn't be necessary it seems
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply budget: $[supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/supply_group_name in all_supply_groups )
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<b>Supply budget: $[supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_name in supply_controller.supply_packs )
				var/datum/supply_packs/N = supply_controller.supply_packs[supply_name]
				if((N.hidden && !hacked) || (N.contraband && !can_order_contraband) || N.group != last_viewed_group || !N.buyable) continue								//Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: $[round(N.cost) * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>"		//the obj because it would get caught by the garbage

		/*temp = "Supply points: [supply_controller.points]<BR><HR><BR>Request what?<BR><BR>"

		for(var/supply_name in supply_controller.supply_packs )
			var/datum/supply_packs/N = supply_controller.supply_packs[supply_name]
			if(N.hidden && !hacked) continue
			if(N.contraband && !can_order_contraband) continue
			temp += "<A href='?src=\ref[src];doorder=[supply_name]'>[supply_name]</A> Cost: [N.cost]<BR>"    //the obj because it would get caught by the garbage
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"*/

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/datum/supply_packs/P = supply_controller.supply_packs[href_list["doorder"]]

		if(!istype(P))	return

		if((P.hidden && !hacked) || (P.contraband && !can_order_contraband) || !P.buyable)
			return

		var/timeout = world.time + 600
		//var/reason = copytext(sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text),1,MAX_MESSAGE_LEN)
		var/reason = "*None Provided*"
		if(world.time > timeout)	return
		if(!reason)	return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(isSilicon(usr))
			idname = usr.real_name

		supply_controller.ordernum++
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[supply_controller.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(P.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		O.object = P
		O.orderedby = idname
		supply_controller.requestlist += O

		temp = "Order request placed.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A>|<A href='?src=\ref[src];mainmenu=1'>Main Menu</A>|<A href='?src=\ref[src];confirmorder=[O.ordernum]'>Authorize Order</A>"

	else if(href_list["confirmorder"])
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list["confirmorder"])
		var/datum/supply_order/O
		var/datum/supply_packs/P
		temp = "Invalid Request"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A>|<A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

		if(supply_controller.shoppinglist.len > 20)
			to_chat(usr, SPAN_DANGER("Current retrieval load has reached maximum capacity."))
			return

		for(var/i=1, i<=supply_controller.requestlist.len, i++)
			var/datum/supply_order/SO = supply_controller.requestlist[i]
			if(SO.ordernum == ordernum)
				O = SO
				P = O.object
				if(supply_controller.points >= round(P.cost))
					supply_controller.requestlist.Cut(i,i+1)
					supply_controller.points -= round(P.cost)
					supply_controller.shoppinglist += O
					P.cost = P.cost * SUPPLY_COST_MULTIPLIER
					temp = "Thank you for your order.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
					O.approvedby = usr.name
					msg_admin_niche("[usr] confirmed supply order of [P.name].")
				else
					temp = "Not enough money left.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				break

	else if (href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in supply_controller.shoppinglist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] approved by [SO.approvedby]<BR>"// <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
/*
	else if (href_list["cancelorder"])
		var/datum/supply_order/remove_supply = href_list["cancelorder"]
		supply_shuttle_shoppinglist -= remove_supply
		supply_shuttle_points += remove_supply.object.cost
		temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
*/
	else if (href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in supply_controller.requestlist)
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby] <A href='?src=\ref[src];confirmorder=[SO.ordernum]'>Approve</A> <A href='?src=\ref[src];rreq=[SO.ordernum]'>Remove</A><BR>"

		temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["rreq"])
		var/ordernum = text2num(href_list["rreq"])
		temp = "Invalid Request.<BR>"
		for(var/i=1, i<=supply_controller.requestlist.len, i++)
			var/datum/supply_order/SO = supply_controller.requestlist[i]
			if(SO.ordernum == ordernum)
				supply_controller.requestlist.Cut(i,i+1)
				temp = "Request removed.<BR>"
				break
		temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if (href_list["clearreq"])
		supply_controller.requestlist.Cut()
		temp = "List cleared.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if (href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/structure/machinery/computer/supplycomp/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)

/obj/structure/machinery/computer/supplycomp/vehicle
	name = "vehicle ASRS console"
	desc = "A console for an Automated Storage and Retrieval System. This one is tied to a deep storage unit for vehicles."
	req_access = list(ACCESS_MARINE_CREWMAN)
	circuit = /obj/item/circuitboard/computer/supplycomp/vehicle
	// Can only retrieve one vehicle per round
	var/spent = FALSE
	var/tank_unlocked = FALSE
	var/list/allowed_roles = list(JOB_CREWMAN)

	var/list/vehicles

/datum/vehicle_order
	var/name = "vehicle order"

	var/obj/vehicle/ordered_vehicle
	var/unlocked = TRUE
	var/failure_message = "<font color=\"red\"><b>Not enough resources were allocated to repair this vehicle during this operation.</b></font><br>"

/datum/vehicle_order/proc/has_vehicle_lock()
	return FALSE

/datum/vehicle_order/proc/on_created(var/obj/vehicle/V)
	return

/datum/vehicle_order/tank
	name = "M34A2 Longstreet Light Tank"
	ordered_vehicle = /obj/effect/vehicle_spawner/tank/decrepit

/datum/vehicle_order/tank/has_vehicle_lock()
	return

/datum/vehicle_order/apc
	name = "M577 Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc/decrepit

/datum/vehicle_order/apc/med
	name = "M577-MED Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_med/decrepit

/datum/vehicle_order/apc/cmd
	name = "M577-CMD Armored Personnel Carrier"
	ordered_vehicle = /obj/effect/vehicle_spawner/apc_cmd/decrepit

/obj/structure/machinery/computer/supplycomp/vehicle/Initialize()
	. = ..()

	vehicles = list(
		new/datum/vehicle_order/apc(),
		new/datum/vehicle_order/apc/med(),
		new/datum/vehicle_order/apc/cmd()
	)

	if(!VehicleElevatorConsole)
		VehicleElevatorConsole = src

/obj/structure/machinery/computer/supplycomp/vehicle/attack_hand(var/mob/living/carbon/human/H as mob)
	if(inoperable())
		return

	if(LAZYLEN(allowed_roles) && !allowed_roles.Find(H.job))		//replaced Z-level restriction with role restriction.
		to_chat(H, SPAN_WARNING("This console isn't for you."))
		return

	if(!allowed(H))
		to_chat(H, SPAN_DANGER("Access Denied."))
		return

	H.set_interaction(src)
	post_signal("supply_vehicle")

	var/dat = ""

	if(!SSshuttle.vehicle_elevator)
		return

	dat += "Platform position: "
	if (SSshuttle.vehicle_elevator.timeLeft())
		dat += "Moving"
	else
		if(is_mainship_level(SSshuttle.vehicle_elevator.z))
			dat += "Raised"
		else
			dat += "Lowered"
	dat += "<br><hr>"

	if(spent)
		dat += "No vehicles are available for retrieval."
	else
		dat += "Available vehicles:<br>"

		for(var/d in vehicles)
			var/datum/vehicle_order/VO = d

			if(VO.has_vehicle_lock())
				dat += VO.failure_message
			else
				dat += "<a href='?src=\ref[src];get_vehicle=\ref[VO]'>[VO.name]</a><br>"

	show_browser(H, dat, "Automated Storage and Retrieval System", "computer", "size=575x450")

/obj/structure/machinery/computer/supplycomp/vehicle/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!is_mainship_level(z))
		return
	if(spent)
		return
	if(!supply_controller)
		world.log << "## ERROR: Eek. The supply_controller controller datum is missing somehow."
		return

	if (!SSshuttle.vehicle_elevator)
		world.log << "## ERROR: Eek. The supply/elevator datum is missing somehow."
		return

	if(!is_admin_level(SSshuttle.vehicle_elevator.z))
		return

	if(ismaintdrone(usr))
		return

	if(isturf(loc) && ( in_range(src, usr) || ishighersilicon(usr) ) )
		usr.set_interaction(src)

	if(href_list["get_vehicle"])
		if(is_mainship_level(SSshuttle.vehicle_elevator.z))
			return
		// dunno why the +1 is needed but the vehicles spawn off-center
		var/turf/middle_turf = get_turf(SSshuttle.vehicle_elevator)

		var/obj/vehicle/multitile/ordered_vehicle

		var/datum/vehicle_order/VO = locate(href_list["get_vehicle"])

		if(!VO) return
		if(VO.has_vehicle_lock()) return

		spent = TRUE
		ordered_vehicle = new VO.ordered_vehicle(middle_turf)
		SSshuttle.vehicle_elevator.request(SSshuttle.getDock("almayer vehicle"))

		VO.on_created(ordered_vehicle)

		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_VEHICLE_ORDERED, ordered_vehicle)

	add_fingerprint(usr)
	updateUsrDialog()
