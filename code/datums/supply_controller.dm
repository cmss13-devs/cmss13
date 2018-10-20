/datum/supply_order
	var/ordernum
	var/datum/supply_packs/object = null
	var/orderedby = null
	var/comment = null

/datum/supply_controller
	var/processing = 1
	var/processing_interval = 300
	var/iteration = 0
	//supply points
	var/points = 120
	var/points_per_process = 2
	var/points_per_slip = 1
	var/points_per_crate = 5
	var/points_per_platinum = 5
	var/points_per_phoron = 0
	//control
	var/ordernum
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/supply_packs = list()
	//shuttle movement
	var/datum/shuttle/ferry/supply/shuttle

/datum/supply_controller/New()
	ordernum = rand(1,9000)

/datum/supply_controller/proc/setup()
	for(var/typepath in (typesof(/datum/supply_packs) - /datum/supply_packs))
		var/datum/supply_packs/P = new typepath()
		supply_packs[P.name] = P

//Supply shuttle ticker - handles supply point regenertion and shuttle travelling between centcomm and the station
/datum/supply_controller/proc/process()
	if(processing)
		iteration++
		points += points_per_process

//To stop things being sent to centcomm which should not be sent to centcomm. Recursively checks for these types.
/datum/supply_controller/proc/forbidden_atoms_check(atom/A)
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

//Sellin
/datum/supply_controller/proc/sell()
	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)	return

	var/phoron_count = 0
	var/plat_count = 0

	for(var/atom/movable/MA in area_shuttle)
		if(MA.anchored)	continue
		if(isturf(MA)) continue

		// Must be in a crate!
		if(istype(MA,/obj/structure/closet/crate))
			callHook("sell_crate", list(MA, area_shuttle))

			points += points_per_crate
			var/find_slip = 1

			for(var/atom in MA)
				// Sell manifests
				var/atom/A = atom
				if(find_slip && istype(A,/obj/item/paper/manifest))
					var/obj/item/paper/slip = A
					if(slip.stamped && slip.stamped.len) //yes, the clown stamp will work. clown is the highest authority on the station, it makes sense
						points += points_per_slip
						find_slip = 0
					continue

				// Sell phoron
			/*	if(istype(A, /obj/item/stack/sheet/mineral/phoron))
					var/obj/item/stack/sheet/mineral/phoron/P = A
					phoron_count += P.get_amount()*/

				// Sell platinum
				if(istype(A, /obj/item/stack/sheet/mineral/platinum))
					var/obj/item/stack/sheet/mineral/platinum/P = A
					plat_count += P.get_amount()

		qdel(MA)

	if(phoron_count)
		points += phoron_count * points_per_phoron

	if(plat_count)
		points += plat_count * points_per_platinum

//Buyin
/datum/supply_controller/proc/buy()
	if(!shoppinglist.len) return

	var/area/area_shuttle = shuttle.get_location_area()
	if(!area_shuttle)	return

	var/list/clear_turfs = list()

	for(var/turf/T in area_shuttle)
		if(T.density)	
			continue
		var/object_in_way = 0
		for(var/atom/A in T.contents)
			if(istype(A, /atom/movable/lighting_overlay))
				continue
			object_in_way = 1
			break
		if(!object_in_way)
			clear_turfs += T

	for(var/S in shoppinglist)
		if(!clear_turfs.len)	
			break
		var/i = rand(1,clear_turfs.len)
		var/turf/pickedloc = clear_turfs[i]
		clear_turfs.Cut(i,i+1)

		var/datum/supply_order/SO = S
		var/datum/supply_packs/SP = SO.object

		var/atom/A = new SP.containertype(pickedloc)
		A.name = "[SP.containername][SO.comment ? " ([SO.comment])" : ""]"

		//supply manifest generation begin

		var/obj/item/paper/manifest/slip = new /obj/item/paper/manifest(A)
		slip.info = "<h3>Automatic Storage Retrieval Manifest</h3><hr><br>"
		slip.info +="Order #[SO.ordernum]<br>"
		slip.info +="[shoppinglist.len] PACKAGES IN THIS SHIPMENT<br>"
		slip.info +="CONTENTS:<br><ul>"

		//spawn the stuff, finish generating the manifest while you're at it
		if(SP.access)
			A:req_access = list()
			A:req_access += text2num(SP.access)

		var/list/contains
		if(SP.randomised_num_contained)
			contains = list()
			if(SP.contains.len)
				for(var/j=1,j<=SP.randomised_num_contained,j++)
					contains += pick(SP.contains)
		else
			contains = SP.contains

		for(var/typepath in contains)
			if(!typepath)	continue
			var/atom/B2 = new typepath(A)
			if(SP.amount && B2:amount) B2:amount = SP.amount
			slip.info += "<li>[B2.name]</li>" //add the item to the manifest
		//manifest finalisation
		slip.info += "</ul><br>"
		slip.info += "CHECK CONTENTS AND STAMP BELOW THE LINE TO CONFIRM RECEIPT OF GOODS<hr>"
		if (SP.contraband) slip.loc = null	//we are out of blanks for Form #44-D Ordering Illicit Drugs.
	shoppinglist.Cut()
	return
