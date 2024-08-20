GLOBAL_DATUM_INIT(supply_controller_upp, /datum/controller/supply/upp, new())

/obj/structure/machinery/computer/supplycomp/upp
	name = "UPP supply console"
	desc = "A console for the General Supply Storage"
	circuit = /obj/item/circuitboard/computer/supplycomp/upp
	faction = FACTION_UPP

/obj/item/paper/manifest/upp
	name = "UPP Supply Manifest"

/obj/item/paper/manifest/upp/generate_contents()
	info = "   \
		<style>    \
			#container { width: 500px; min-height: 500px; margin: 25px auto;  \
					font-family: monospace; padding: 0; font-size: 130% }  \
			#title { font-size: 250%; letter-spacing: 8px; \
					font-weight: bolder; margin: 20px auto }   \
			.header { font-size: 130%; text-align: center; }   \
			.important { font-variant: small-caps; font-size = 130%;   \
						font-weight: bolder; }    \
			.tablelabel { width: 150px; }  \
			.field { font-style: italic; } \
			li { list-style-type: disc; list-style-position: inside; } \
			table { table-layout: fixed }  \
		</style><div id='container'>   \
		<div class='header'>   \
			<p id='title' class='important'><img src = upplogo.png></p>   \
			<p class='important'>General Supply Storage order</p>    \
			<p class='field'>Order #[ordernum]</p> \
		</div><hr><table>  \
		<colgroup> \
			<col class='tablelabel important'> \
			<col class='field'>    \
		</colgroup>    \
		<tr><td>Shipment:</td> \
		<td>[ordername]</td></tr>  \
		<tr><td>Ordered by:</td>   \
		<td>[orderedby]</td></tr>  \
		<tr><td>Approved by:</td>  \
		<td>[approvedby]</td></tr> \
		<tr><td># packages:</td>   \
		<td class='field'>[length(packages)]</td></tr> \
		</table><hr><p class='header important'>Contents</p>   \
		<ul class='field'>"

	for(var/packagename in packages)
		info += "<li>[packagename]</li>"

	info += "  \
		</ul><br/><hr><br/><p class='important header'>    \
			Please stamp below and return to confirm receipt of shipment   \
		<br/> Glory to the UPP!	\
		</p></div>"

	name = "[name] - [ordername]"


/datum/controller/supply/upp
	points = 120
	all_supply_groups = list(
		"UPP Weapons",
		"UPP Ammo",
		"UPP Special Weapon",
		"UPP Special Ammo",
		"UPP Attachments",
		"UPP Medical",
		"UPP Engineering",
		"UPP Food",
		"UPP Gear",
		"UPP Explosives",
		"UPP Clothing",
		"UPP Mortar"
	)
	//No black market under communism
	contraband_supply_groups = list()

//No random crates for UPP
/datum/controller/supply/upp/process(delta_time)
	iteration++
	points += points_per_process
	if(iteration < 20)
		return

/datum/controller/supply/upp/buy()
	var/area/area_shuttle = shuttle?.get_location_area()
	if(!area_shuttle || !length(shoppinglist))
		return

	// Try to find an available turf to place our package
	var/list/turf/clear_turfs = list()
	for(var/turf/T in area_shuttle)
		if(T.density || LAZYLEN(T.contents))
			continue
		clear_turfs += T

	for(var/datum/supply_order/order in shoppinglist)
		// No space! Forget buying, it's no use.
		if(!length(clear_turfs))
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
		var /obj/item/paper/manifest/upp/slip
		slip = new /obj/item/paper/manifest/upp(container)
		slip.ordername = package.name
		slip.ordernum = order.ordernum
		slip.orderedby = order.orderedby
		slip.approvedby = order.approvedby
		slip.packages = content_names
		slip.generate_contents()
		slip.update_icon()
	shoppinglist.Cut()

/obj/structure/machinery/computer/supplycomp/upp/attack_hand(mob/user as mob)
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
		var/datum/shuttle/ferry/supply/shuttle = linked_supply_controller.shuttle
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
						dat += "*General Supply Storage is working on order*"
					dat += "<BR>\n<BR>"
				else
					dat += "Lowered<BR>"
					if (shuttle.can_launch())
						dat += "<A href='?src=\ref[src];send=1'>Raise platform</A>"
					else if (shuttle.can_cancel())
						dat += "<A href='?src=\ref[src];cancel_send=1'>Cancel</A>"
					else
						dat += "*General Supply Storage is working on order*"
					dat += "<BR>\n<BR>"


		dat += {"<HR>\nSupply budget: $[linked_supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>\n<BR>
		\n<A href='?src=\ref[src];order=categories'>Order items</A><BR>\n<BR>
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}


	show_browser(user, dat, "General Supply Storage", "computer", "size=575x450")
	return

/obj/structure/machinery/computer/ordercomp/upp/Topic(href, href_list)
	if(..())
		return

	if( isturf(loc) && (in_range(src, usr) || isSilicon(usr)) )
		usr.set_interaction(src)

	if(href_list["order"])
		if(href_list["order"] == "categories")
			//all_supply_groups
			//Request what?
			last_viewed_group = "categories"
			temp = "<b>Supply budget: $[linked_supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/supply_group_name in linked_supply_controller.all_supply_groups)
				temp += "<A href='?src=\ref[src];order=[supply_group_name]'>[supply_group_name]</A><BR>"
		else
			last_viewed_group = href_list["order"]
			temp = "<b>Supply budget: $[linked_supply_controller.points * SUPPLY_TO_MONEY_MUPLTIPLIER]</b><BR>"
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [last_viewed_group]</b><BR><BR>"
			for(var/supply_type in GLOB.supply_packs_datums)
				var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_type]
				if(supply_pack.contraband || supply_pack.group != last_viewed_group || !supply_pack.buyable)
					continue //Have to send the type instead of a reference to
				temp += "<A href='?src=\ref[src];doorder=[supply_pack.name]'>[supply_pack.name]</A> Cost: $[floor(supply_pack.cost) * SUPPLY_TO_MONEY_MUPLTIPLIER]<BR>" //the obj because it would get caught by the garbage

	else if (href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"", SHOW_MESSAGE_VISIBLE)
			return

		//Find the correct supply_pack datum
		var/supply_pack_type = GLOB.supply_packs_types[href_list["doorder"]]
		if(!supply_pack_type)
			return
		var/datum/supply_packs/supply_pack = GLOB.supply_packs_datums[supply_pack_type]

		if(supply_pack.contraband || !supply_pack.buyable)
			return

		var/timeout = world.time + 600
		var/reason = strip_html(input(usr,"Reason:","Why do you require this item?","") as null|text)
		if(world.time > timeout) return
		if(!reason) return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(isSilicon(usr))
			idname = usr.real_name

		linked_supply_controller.ordernum++
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "Requisition Form - [supply_pack.name]"
		reqform.info += "<h3>General Supply Storage Form</h3><hr>"
		reqform.info += "INDEX: #[linked_supply_controller.ordernum]<br>"
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [supply_pack.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(supply_pack.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += supply_pack.manifest
		reqform.info += "<hr>"
		reqform.info += "GLORY TO THE UPP<br> \
			STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon() //Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/supply_order = new /datum/supply_order()
		supply_order.ordernum = linked_supply_controller.ordernum
		supply_order.object = supply_pack
		supply_order.orderedby = idname
		linked_supply_controller.requestlist += supply_order

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=[last_viewed_group]'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
