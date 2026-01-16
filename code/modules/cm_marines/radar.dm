///generic parent that handles most of the process
/datum/radar
	/// the thing which has this datum attached to it. REQUIRED!!! IF HOLDER DOES NOT EXIST, WE DO NOT EXIST. QDEL.
	var/atom/holder
	///List of trackable entities. Updated by the scan() proc.
	var/list/objects
	///Ref of the last trackable object selected by the user in the tgui window. Updated in the ui_act() proc.
	var/atom/selected
	///Used to store when the next scan is available. Updated by the scan() proc.
	var/next_scan = 0
	///Used to keep track of the last value program_icon_state was set to, to prevent constant unnecessary update_appearance() calls
	var/last_icon_state = ""
	///Used by the tgui interface, themed NT or Syndicate.
	var/arrowstyle = "ntosradarpointer.png"
	///Used by the tgui interface, themed for NT or Syndicate colors.
	var/pointercolor = "green"
	///cooldown between scans
	var/scan_cooldown = 2 SECONDS

/datum/radar/New(atom/holder)
	src.holder = holder

/datum/radar/Destroy(force, ...)
	SStgui.close_uis(src)
	return . = ..()

/datum/radar/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/radar/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Radar", "[holder.name]")
		ui.open()

/datum/radar/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/radar_assets),
	)

/datum/radar/ui_data(mob/user)
	if(!holder)
		qdel(src) // qdel yourself... NOW!!!
		return

	var/list/data = list()
	data["selected"] = selected
	data["objects"] = list()
	data["scanning"] = (world.time < next_scan)
	for(var/list/i in objects)
		var/list/objectdata = list(
			ref = i["ref"],
			name = i["name"],
		)
		data["object"] += list(objectdata)

	data["target"] = list()
	var/list/trackinfo = track()
	if(trackinfo)
		data["target"] = trackinfo
	return data

/datum/radar/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("selecttarget")
			selected = params["ref"]
		if("scan")
			scan()

/**
 *Updates tracking information of the selected target.
 *
 *The track() proc updates the entire set of information about the location
 *of the target, including whether the Ntos window should use a pinpointer
 *crosshair over the up/down arrows, or none in favor of a rotating arrow
 *for far away targets. This information is returned in the form of a list.
 *
*/
/datum/radar/proc/track()
	var/atom/movable/signal = find_atom()
	if(!trackable(signal))
		return

	var/turf/here_turf = (get_turf(holder))
	var/turf/target_turf = (get_turf(signal))
	var/userot = FALSE
	var/rot = 0
	var/pointer="crosshairs"
	var/locx = (target_turf.x - here_turf.x) + 24
	var/locy = (here_turf.y - target_turf.y) + 24

	if(get_dist_euclidian(here_turf, target_turf) > 24)
		userot = TRUE
		rot = floor(Get_Angle(here_turf, target_turf))
	else
		if(target_turf.z > here_turf.z)
			pointer="caret-up"
		else if(target_turf.z < here_turf.z)
			pointer="caret-down"

	var/list/trackinfo = list(
		"locx" = locx,
		"locy" = locy,
		"userot" = userot,
		"rot" = rot,
		"arrowstyle" = arrowstyle,
		"color" = pointercolor,
		"pointer" = pointer,
		)
	return trackinfo

/**
 *
 *Checks the trackability of the selected target.
 *
 *If the target is on the computer's Z level, or both are on station Z
 *levels, and the target isn't untrackable, return TRUE.
 *Arguments:
 **arg1 is the atom being evaluated.
*/
/datum/radar/proc/trackable(atom/movable/signal)
	if(!signal || !holder)
		return FALSE
	var/turf/here = get_turf(holder)
	var/turf/there = get_turf(signal)
	if(!here || !there)
		return FALSE //I was still getting a runtime even after the above check while scanning, so fuck it
	return (there.z == here.z) || (is_mainship_level(here.z) && is_mainship_level(there.z))

/**
 *
 *Runs a scan of all the trackable atoms.
 *
 *Checks each entry in the GLOB of the specific trackable atoms against
 *the track() proc, and fill the objects list with lists containing the
 *atoms' names and REFs. The objects list is handed to the tgui screen
 *for displaying to, and being selected by, the user. A two second
 *sleep is used to delay the scan, both for thematical reasons as well
 *as to limit the load players may place on the server using these
 *somewhat costly loops.
*/
/datum/radar/proc/scan()
	if(world.time < next_scan)
		return
	next_scan = world.time + scan_cooldown
	return

/**
 *
 *Finds the atom in the appropriate list that the `selected` var indicates
 *
 *The `selected` var holds a REF, which is a string. A mob REF may be
 *something like "mob_209". In order to find the actual atom, we need
 *to search the appropriate list for the REF string. This is dependant
 *on the program (Lifeline uses GLOB.human_list, while Fission360 uses
 *GLOB.poi_list), but the result will be the same; evaluate the string and
 *return an atom reference.
*/
/datum/radar/proc/find_atom()
	return

// a version that tracks an advanced PDT/L bracelet
/datum/radar/advanced_pdtl
	var/obj/item/device/pdt_locator_tube/advanced/typed_holder

/datum/radar/advanced_pdtl/New(atom/holder)
	. = ..()
	typed_holder = holder

/datum/radar/advanced_pdtl/find_atom()
	return typed_holder.linked_bracelet

/datum/radar/advanced_pdtl/scan()
	. = ..()
	objects = list()
	var/obj/item/clothing/accessory/wrist/pdt_bracelet/bracelet = typed_holder.linked_bracelet
	if(!bracelet)
		return
	objects += list(list(
		ref = REF(bracelet),
		name = bracelet.name,
	))

///A program that tracks crew members via suit sensors
/datum/radar/lifeline
	var/faction

/datum/radar/lifeline/New(atom/holder, faction)
	. = ..()
	src.faction = faction

/datum/radar/lifeline/find_atom()
	return locate(selected) in GLOB.human_mob_list

/datum/radar/lifeline/scan()
	. = ..()
	objects = list()
	for(var/i in GLOB.human_mob_list)
		var/mob/living/carbon/human/humanoid = i
		if(!trackable(humanoid))
			continue
		var/crewmember_name = "Unknown"
		var/crewmember_rank = "Unknown"
		var/obj/item/card/id/card = humanoid.get_idcard()
		if(card)
			if(card.registered_name)
				crewmember_name = card.registered_name
			if(card.assignment)
				crewmember_rank = card.assignment
		switch(humanoid.stat)
			if(CONSCIOUS)
				crewmember_name = "[crewmember_name] ([crewmember_rank]) (Conscious)"
			if(UNCONSCIOUS)
				crewmember_name = "[crewmember_name] ([crewmember_rank]) (Unconscious)"
			if(DEAD)
				crewmember_name = "[crewmember_name] ([crewmember_rank]) (DEAD)"
		var/list/crewinfo = list(
			ref = REF(humanoid),
			name = crewmember_name,
			)
		objects += list(crewinfo)

/datum/radar/lifeline/trackable(mob/living/carbon/human/humanoid)
	if(!humanoid || !istype(humanoid))
		return FALSE
	if(..())
		if(humanoid.faction != faction)
			return FALSE
		if(istype(humanoid.w_uniform, /obj/item/clothing/under))
			var/obj/item/clothing/under/uniform = humanoid.w_uniform
			if(uniform.has_sensor && uniform.sensor_mode >= SENSOR_MODE_LOCATION) // Suit sensors must be on maximum
				return TRUE
	return FALSE


//Synthetic K9 Scent Tracking, allows K9s to track CLF, UPP, etc as well as Preds... optic camo can't hide the fact you stink!
/datum/radar/scenttracker/find_atom()
	return locate(selected) in GLOB.human_mob_list

/datum/radar/scenttracker/scan()
	. = ..()
	objects = list()
	for(var/mob/living/carbon/human/humanoid as anything in GLOB.human_mob_list)
		var/crewmember_name = "Unknown"
		var/crewmember_rank = "Unknown"
		if(humanoid.get_idcard())
			var/obj/item/card/id/ID = humanoid.get_idcard()
			if(ID?.registered_name)
				crewmember_name = ID.registered_name
			if(ID?.assignment)
				crewmember_rank = ID.assignment
		switch(humanoid.stat)
			if(CONSCIOUS)
				crewmember_name = "[crewmember_name] ([crewmember_rank]) (Conscious)"
			if(UNCONSCIOUS)
				crewmember_name = "[crewmember_name] ([crewmember_rank]) (Unconscious)"
			if(DEAD)
				crewmember_name = "[crewmember_name] ([crewmember_rank]) (DEAD)"
		var/list/crewinfo = list(
			ref = REF(humanoid),
			name = crewmember_name,
			)
		objects += list(crewinfo)
