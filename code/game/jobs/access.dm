/obj/var/list/req_access = null
/obj/var/list/req_one_access = null

//returns 1 if this mob has sufficient access to use this object
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access()) return 1
	if(issilicon(M)) return 1 //AI can do whatever he wants

	else if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.wear_id)) return 1
	else if(istype(M, /mob/living/carbon/Xenomorph))
		var/mob/living/carbon/C = M
		if(check_access(C.get_active_hand())) return 1

/obj/item/proc/GetAccess() return list()

/obj/item/proc/GetID() return

/obj/proc/check_access(obj/item/I)
	//These generations have been moved out of /obj/New() because they were slowing down the creation of objects that never even used the access system.
	var/i
	if(!req_access)
		req_access = list()

	if(!req_one_access)
		req_one_access = list()

	if(!islist(req_access)) return 1//something's very wrong
	var/L[] = req_access
	if(!L.len && (!req_one_access || !req_one_access.len)) return 1//no requirements
	if(!I) return

	var/A[] = I.GetAccess()
	for(i in req_access)
		if(!(i in A)) return//doesn't have this access

	if(req_one_access && req_one_access.len)
		for(i in req_one_access)
			if(i in A) return 1//has an access from the single access list
		return
	return 1

/obj/proc/check_access_list(L[])
	if(!req_access  && !req_one_access)	return 1
	if(!islist(req_access)) return 1
	if(!req_access.len && (!req_one_access || !req_one_access.len))	return 1
	if(!islist(L))	return
	var/i
	for(i in req_access)
		if(!(i in L)) return //doesn't have this access
	if(req_one_access && req_one_access.len)
		for(i in req_one_access)
			if(i in L) return 1//has an access from the single access list
		return
	return 1

/proc/get_centcom_access(job)
	return get_all_centcom_access()

/proc/get_all_accesses()
	return get_all_marine_access() + get_all_civilian_accesses()

/proc/get_all_civilian_accesses()
	return list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_BRIG)

/proc/get_all_marine_access()
	return list(ACCESS_IFF_MARINE, ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_BRIG, ACCESS_MARINE_ARMORY, ACCESS_MARINE_WO, ACCESS_MARINE_CMO, ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP,ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE, ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CARGO, ACCESS_MARINE_DROPSHIP, ACCESS_MARINE_SEA)

/proc/get_all_centcom_access()
	return list(ACCESS_WY_PMC_GREEN, ACCESS_WY_PMC_ORANGE, ACCESS_WY_PMC_RED, ACCESS_WY_PMC_BLACK, ACCESS_WY_PMC_WHITE, ACCESS_WY_CORPORATE, ACCESS_IFF_PMC)

/proc/get_all_syndicate_access()
	return list(ACCESS_ILLEGAL_PIRATE)

/proc/get_antagonist_access()
	var/L[] = get_all_accesses() + get_all_syndicate_access()
	return L - ACCESS_IFF_MARINE

/proc/get_antagonist_pmc_access()
	return get_antagonist_access() + ACCESS_IFF_PMC

/proc/get_freelancer_access()
	return list(ACCESS_MARINE_BRIDGE, ACCESS_MARINE_CARGO, ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/proc/get_region_accesses(var/code)
	switch(code)
		if(0)
			return get_all_accesses()
		if(1)
			return list(ACCESS_MARINE_WO, ACCESS_MARINE_BRIG) // Security
		if(2)
			return list(ACCESS_MARINE_CMO, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_MORGUE, ACCESS_MARINE_CHEMISTRY) // Medbay
		if(3)
			return list(ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE) // Research
		if(4)
			return list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING) // Engineering
		if(5)
			return list(ACCESS_MARINE_COMMANDER, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_BRIDGE, ACCESS_MARINE_CARGO, ACCESS_MARINE_SEA) // Command
		if(6)
			return list(ACCESS_IFF_MARINE, ACCESS_MARINE_PREP, ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ENGPREP, ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP)//spess mahreens
		if(7)
			return list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA) // Squads
		if(8)
			return list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_LOGISTICS, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_BRIG)//Civilian

/proc/get_region_accesses_name(code)
	switch(code)
		if(0)
			return "All"
		if(1)
			return "[MAIN_SHIP_NAME] Security" // Security
		if(2)
			return "[MAIN_SHIP_NAME] Medbay" // Medbay
		if(3)
			return "[MAIN_SHIP_NAME] Research" // Research
		if(4)
			return "[MAIN_SHIP_NAME] Engineering" // Engineering
		if(5)
			return "[MAIN_SHIP_NAME] Command" // Command
		if(6)
			return "Marines" // Marine prep
		if(7)
			return "Squads" // Squads
		if(8)
			return "Civilian" // Civilian


/proc/get_access_desc(A)
	switch(A)
		if(ACCESS_MARINE_WO)			return "WO's Office"
		if(ACCESS_MARINE_BRIG) 			return "Brig"
		if(ACCESS_MARINE_CMO) 			return "CMO's Office"
		if(ACCESS_MARINE_MEDBAY)		return "[MAIN_SHIP_NAME] Medbay"
		if(ACCESS_MARINE_RESEARCH) 		return "[MAIN_SHIP_NAME] Research"
		if(ACCESS_MARINE_CHEMISTRY) 	return "[MAIN_SHIP_NAME] Chemistry"
		if(ACCESS_MARINE_MORGUE) 		return "[MAIN_SHIP_NAME] Morgue"
		if(ACCESS_MARINE_CE)		 	return "CE's Office"
		if(ACCESS_MARINE_ENGINEERING) 	return "[MAIN_SHIP_NAME] Engineering"
		if(ACCESS_MARINE_COMMANDER) 	return "Commander's Quarters"
		if(ACCESS_MARINE_LOGISTICS) 	return "[MAIN_SHIP_NAME] Logistics"
		if(ACCESS_MARINE_BRIDGE) 		return "[MAIN_SHIP_NAME] Bridge"
		if(ACCESS_MARINE_PREP) 			return "Marine Prep"
		if(ACCESS_MARINE_ENGPREP) 		return "Marine Squad Engineering"
		if(ACCESS_MARINE_MEDPREP) 		return "Marine Squad Medical"
		if(ACCESS_MARINE_SPECPREP) 		return "Marine Specialist"
		if(ACCESS_MARINE_SMARTPREP)		return "Marine Smartgunner"
		if(ACCESS_MARINE_LEADER) 		return "Marine Leader"
		if(ACCESS_MARINE_ALPHA) 		return "Alpha Squad"
		if(ACCESS_MARINE_BRAVO) 		return "Bravo Squad"
		if(ACCESS_MARINE_CHARLIE) 		return "Charlie Squad"
		if(ACCESS_MARINE_DELTA) 		return "Delta Squad"
		if(ACCESS_MARINE_CARGO) 		return "Requisitions"
		if(ACCESS_MARINE_DROPSHIP) 		return "Dropship Piloting"
		if(ACCESS_MARINE_PILOT) 		return "Pilot Gear"
		if(ACCESS_CIVILIAN_RESEARCH) 	return "Civilian Research"
		if(ACCESS_CIVILIAN_LOGISTICS) 	return "Civilian Command"
		if(ACCESS_CIVILIAN_ENGINEERING) return "Civilian Engineering"
		if(ACCESS_CIVILIAN_BRIG)		return "Civilian Brig"
		if(ACCESS_CIVILIAN_PUBLIC) 		return "Civilian"
		if(ACCESS_IFF_MARINE) 			return "[MAIN_SHIP_NAME] Identification"
		if(ACCESS_MARINE_SEA)			return "SEA's Office"

/proc/get_centcom_access_desc(A)
	switch(A)
		if(ACCESS_WY_PMC_GREEN)			return "W-Y PMC Green"
		if(ACCESS_WY_PMC_ORANGE)		return "W-Y PMC Orange"
		if(ACCESS_WY_PMC_RED)			return "W-Y PMC Red"
		if(ACCESS_WY_PMC_BLACK)			return "W-Y PMC Black"
		if(ACCESS_WY_PMC_WHITE)			return "W-Y PMC White"
		if(ACCESS_WY_CORPORATE)			return "W-Y Executive"
		if(ACCESS_IFF_PMC) 				return "W-Y Identification"