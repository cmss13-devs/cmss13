//returns TRUE if this mob has sufficient access to use this object
//returns FALSE otherwise
/obj/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access() || isRemoteControlling(M))
		return TRUE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.wear_id))
			return TRUE
		return check_yautja_access(H)
	if(istype(M, /mob/living/carbon/xenomorph))
		var/mob/living/carbon/C = M
		if(check_access(C.get_active_hand()))
			return TRUE
		return FALSE

/obj/proc/check_yautja_access(mob/living/carbon/human/yautja)
	if(!istype(yautja))
		return FALSE
	var/obj/item/clothing/gloves/yautja/hunter/bracer = yautja.gloves
	if(!istype(bracer) || !bracer.embedded_id || !check_access(bracer.embedded_id))
		return FALSE
	return TRUE

/obj/item/proc/GetAccess() return list()

/obj/item/proc/GetID() return

/obj/proc/text2access(access_text)
	. = list()
	if(!access_text)
		return
	var/list/split = splittext(access_text,";")
	for(var/x in split)
		var/n = text2num(x)
		if(n)
			. += n

/obj/proc/gen_access()
	if(req_access_txt)
		req_access = list()
		for(var/a in text2access(req_access_txt))
			req_access += a
		req_access_txt = null
	if(!req_access)
		req_access = list()

	if(req_one_access_txt)
		req_one_access = list()
		for(var/a in text2access(req_one_access_txt))
			req_one_access += a
		req_one_access_txt = null
	if(!req_one_access)
		req_one_access = list()

/obj/proc/check_access(obj/item/I)
	//These generations have been moved out of /obj/New() because they were slowing down the creation of objects that never even used the access system.
	gen_access()
	if(!islist(req_access))
		return 1//something's very wrong
	var/L[] = req_access
	if(!length(L) && !LAZYLEN(req_one_access))
		return 1//no requirements
	if(!I)
		return

	var/list/A = I.GetAccess()
	for(var/i in req_access)
		if(!(i in A))
			return FALSE//doesn't have this access

	if(LAZYLEN(req_one_access))
		for(var/i in req_one_access)
			if(i in A)
				return TRUE//has an access from the single access list
		return FALSE
	return TRUE

/obj/proc/check_access_list(L[])
	gen_access()
	if(!req_access  && !req_one_access)
		return 1
	if(!islist(req_access))
		return 1
	if(!length(req_access) && !islist(req_one_access))
		return TRUE
	if(!length(req_access) && !LAZYLEN(req_one_access))
		return 1
	if(!islist(L))
		return
	var/i
	for(i in req_access)
		if(!(i in L))
			return //doesn't have this access
	if(LAZYLEN(req_one_access))
		for(i in req_one_access)
			if(i in L)
				return 1//has an access from the single access list
		return
	return 1


/proc/get_access(access_list = ACCESS_LIST_GLOBAL)
	switch(access_list)
		if(ACCESS_LIST_GLOBAL)
			return list(ACCESS_ILLEGAL_PIRATE) + get_access(ACCESS_LIST_MARINE_ALL) + get_access(ACCESS_LIST_WY_ALL) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_CLF_ALL) + get_access(ACCESS_LIST_UPP_ALL)
		if(ACCESS_LIST_MARINE_MAIN)
			return list(
				ACCESS_MARINE_SENIOR,
				ACCESS_MARINE_DATABASE,
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_CMP,
				ACCESS_MARINE_BRIG,
				ACCESS_MARINE_ARMORY,
				ACCESS_MARINE_CMO,
				ACCESS_MARINE_MEDBAY,
				ACCESS_MARINE_CHEMISTRY,
				ACCESS_MARINE_MORGUE,
				ACCESS_MARINE_RESEARCH,
				ACCESS_MARINE_CE,
				ACCESS_MARINE_ENGINEERING,
				ACCESS_MARINE_MAINT,
				ACCESS_MARINE_OT,
				ACCESS_MARINE_RO,
				ACCESS_MARINE_CARGO,
				ACCESS_MARINE_PREP,
				ACCESS_MARINE_MEDPREP,
				ACCESS_MARINE_ENGPREP,
				ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER,
				ACCESS_MARINE_SPECPREP,
				ACCESS_MARINE_TL_PREP,
				ACCESS_MARINE_ALPHA,
				ACCESS_MARINE_BRAVO,
				ACCESS_MARINE_CHARLIE,
				ACCESS_MARINE_DELTA,
				ACCESS_MARINE_PILOT,
				ACCESS_MARINE_DROPSHIP,
				ACCESS_MARINE_SEA,
				ACCESS_MARINE_KITCHEN,
				ACCESS_MARINE_SYNTH,
				ACCESS_MARINE_ASO,
				ACCESS_MARINE_CHAPLAIN,
				ACCESS_MARINE_FIELD_DOC,
				ACCESS_PRESS,
			)

		if(ACCESS_LIST_MARINE_ALL)
			return list(
				ACCESS_MARINE_CO,
				ACCESS_MARINE_AI,
				ACCESS_MARINE_AI_TEMP,
			) + get_access(ACCESS_LIST_MARINE_MAIN)

		if(ACCESS_LIST_EMERGENCY_RESPONSE)
			return list(
				ACCESS_MARINE_MAINT,
				ACCESS_MARINE_MEDBAY,
				ACCESS_MARINE_KITCHEN,
				ACCESS_PRESS,
			)

		if(ACCESS_LIST_UA)
			return get_access(ACCESS_LIST_MARINE_MAIN) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_MARINE_LIAISON)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_FLIGHT,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_RESEARCH,
				ACCESS_MARINE_MEDBAY,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_COLONIAL_ALL)
			return list(
				ACCESS_CIVILIAN_PUBLIC,
				ACCESS_CIVILIAN_RESEARCH,
				ACCESS_CIVILIAN_ENGINEERING,
				ACCESS_CIVILIAN_LOGISTICS,
				ACCESS_CIVILIAN_BRIG,
				ACCESS_CIVILIAN_MEDBAY,
				ACCESS_CIVILIAN_COMMAND,
			)

		if(ACCESS_LIST_CIVIL_LIAISON)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_DELIVERY)
			return list(
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_CARGO,
				ACCESS_CIVILIAN_PUBLIC,
				ACCESS_CIVILIAN_RESEARCH,
				ACCESS_CIVILIAN_ENGINEERING,
				ACCESS_CIVILIAN_LOGISTICS,
			)


		if(ACCESS_LIST_WY_ALL)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
				ACCESS_WY_SECURITY,
				ACCESS_WY_ENGINEERING,
				ACCESS_WY_FLIGHT,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
				ACCESS_WY_PMC,
				ACCESS_WY_PMC_TL,
				ACCESS_WY_ARMORY,
				ACCESS_WY_SECRETS,
				ACCESS_WY_DATABASE,
				ACCESS_WY_LEADERSHIP,
				ACCESS_WY_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_WY_BASE)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
			)

		if(ACCESS_LIST_WY_SENIOR)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
				ACCESS_WY_SECURITY,
				ACCESS_WY_ENGINEERING,
				ACCESS_WY_FLIGHT,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_EXEC,
				ACCESS_WY_PMC,
				ACCESS_WY_PMC_TL,
				ACCESS_WY_ARMORY,
				ACCESS_WY_DATABASE,
				ACCESS_WY_LEADERSHIP,
				ACCESS_WY_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_COLONIAL_ALL)

		if(ACCESS_LIST_WY_GOON)
			return list(
				ACCESS_WY_GENERAL,
				ACCESS_WY_COLONIAL,
				ACCESS_WY_MEDICAL,
				ACCESS_WY_SECURITY,
				ACCESS_WY_RESEARCH,
				ACCESS_WY_ARMORY,
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

		if(ACCESS_LIST_WY_PMC)
			return list(
				ACCESS_WY_PMC,
				ACCESS_WY_ENGINEERING,
				ACCESS_WY_FLIGHT,
			) + get_access(ACCESS_LIST_WY_GOON)

		if(ACCESS_LIST_CLF_ALL)
			return list(
				ACCESS_CLF_SECURITY,
				ACCESS_CLF_ARMORY,
				ACCESS_CLF_LEADERSHIP,
				ACCESS_CLF_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_CLF_BASE)

		if(ACCESS_LIST_CLF_BASE)
			return list(
				ACCESS_CLF_GENERAL,
				ACCESS_CLF_MEDICAL,
				ACCESS_CLF_ENGINEERING,
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

		if(ACCESS_LIST_UPP_ALL)
			return list(
				ACCESS_UPP_GENERAL,
				ACCESS_UPP_MEDICAL,
				ACCESS_UPP_ENGINEERING,
				ACCESS_UPP_SECURITY,
				ACCESS_UPP_ARMORY,
				ACCESS_UPP_FLIGHT,
				ACCESS_UPP_RESEARCH,
				ACCESS_UPP_COMMANDO,
				ACCESS_UPP_LEADERSHIP,
				ACCESS_UPP_SENIOR_LEAD,
			) + get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_EMERGENCY_RESPONSE)

/proc/get_region_accesses(code)
	switch(code)
		if(0)//Everything
			return get_access(ACCESS_LIST_COLONIAL_ALL) + get_access(ACCESS_LIST_MARINE_MAIN)
		if(1)//Security
			return list(ACCESS_MARINE_CMP, ACCESS_MARINE_BRIG, ACCESS_MARINE_ARMORY)
		if(2)//Medbay
			return list(ACCESS_MARINE_CMO, ACCESS_MARINE_FIELD_DOC, ACCESS_MARINE_MEDBAY, ACCESS_MARINE_MORGUE, ACCESS_MARINE_CHEMISTRY)
		if(3)//Research
			return list(ACCESS_MARINE_RESEARCH, ACCESS_MARINE_CHEMISTRY, ACCESS_MARINE_MORGUE)
		if(4)//Engineering
			return list(ACCESS_MARINE_CE, ACCESS_MARINE_ENGINEERING, ACCESS_MARINE_OT, ACCESS_MARINE_MAINT)
		if(5)//Command
			return list(
				ACCESS_MARINE_SENIOR,
				ACCESS_MARINE_DATABASE,
				ACCESS_MARINE_COMMAND,
				ACCESS_MARINE_RO,
				ACCESS_MARINE_CARGO,
				ACCESS_MARINE_SEA,
				ACCESS_MARINE_SYNTH,
			)
		if(6)//Marines
			return list(
				ACCESS_MARINE_PREP,
				ACCESS_MARINE_MEDPREP,
				ACCESS_MARINE_ENGPREP,
				ACCESS_MARINE_SMARTPREP,
				ACCESS_MARINE_LEADER,
				ACCESS_MARINE_SPECPREP,
				ACCESS_MARINE_TL_PREP,
				ACCESS_MARINE_KITCHEN,
			)
		if(7)//Squads
			return list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
		if(8)//Civilian
			return list(
				ACCESS_CIVILIAN_PUBLIC,
				ACCESS_CIVILIAN_RESEARCH,
				ACCESS_CIVILIAN_ENGINEERING,
				ACCESS_CIVILIAN_LOGISTICS,
				ACCESS_CIVILIAN_BRIG,
				ACCESS_CIVILIAN_MEDBAY,
				ACCESS_CIVILIAN_COMMAND,
			)

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
		if(ACCESS_MARINE_CMP)
			return "CMP's Office"
		if(ACCESS_MARINE_BRIG)
			return "Brig"
		if(ACCESS_MARINE_ARMORY)
			return "Armory"
		if(ACCESS_MARINE_CMO)
			return "CMO's Office"
		if(ACCESS_MARINE_FIELD_DOC)
			return "Field Doctor Supplies"
		if(ACCESS_MARINE_MEDBAY)
			return "[MAIN_SHIP_NAME] Medbay"
		if(ACCESS_MARINE_RESEARCH)
			return "[MAIN_SHIP_NAME] Research"
		if(ACCESS_MARINE_CHEMISTRY)
			return "[MAIN_SHIP_NAME] Chemistry"
		if(ACCESS_MARINE_MORGUE)
			return "[MAIN_SHIP_NAME] Morgue"
		if(ACCESS_MARINE_CE)
			return "CE's Office"
		if(ACCESS_MARINE_RO)
			return "RO's Office"
		if(ACCESS_MARINE_ENGINEERING)
			return "[MAIN_SHIP_NAME] Engineering"
		if(ACCESS_MARINE_OT)
			return "[MAIN_SHIP_NAME] Ordnance Workshop"
		if(ACCESS_MARINE_SENIOR)
			return "[MAIN_SHIP_NAME] Senior Command"
		if(ACCESS_MARINE_CO)
			return "Commander's Quarters"
		if(ACCESS_MARINE_DATABASE)
			return "[MAIN_SHIP_NAME]'s Database"
		if(ACCESS_MARINE_COMMAND)
			return "[MAIN_SHIP_NAME] Command"
		if(ACCESS_MARINE_CREWMAN)
			return "Vehicle Crewman"
		if(ACCESS_MARINE_PREP)
			return "Marine Prep"
		if(ACCESS_MARINE_ENGPREP)
			return "Marine Squad Engineering"
		if(ACCESS_MARINE_MEDPREP)
			return "Marine Squad Medical"
		if(ACCESS_MARINE_SPECPREP)
			return "Marine Weapons Specialist"
		if(ACCESS_MARINE_SMARTPREP)
			return "Marine Smartgunner"
		if(ACCESS_MARINE_TL_PREP)
			return "Marine Team Leader"
		if(ACCESS_MARINE_LEADER)
			return "Marine Leader"
		if(ACCESS_MARINE_ALPHA)
			return "Alpha Squad"
		if(ACCESS_MARINE_BRAVO)
			return "Bravo Squad"
		if(ACCESS_MARINE_CHARLIE)
			return "Charlie Squad"
		if(ACCESS_MARINE_DELTA)
			return "Delta Squad"
		if(ACCESS_MARINE_CARGO)
			return "Requisitions"
		if(ACCESS_MARINE_DROPSHIP)
			return "Dropship Piloting"
		if(ACCESS_MARINE_PILOT)
			return "Pilot Gear"
		if(ACCESS_MARINE_MAINT)
			return "[MAIN_SHIP_NAME] Maintenance"
		if(ACCESS_CIVILIAN_RESEARCH)
			return "Civilian Research"
		if(ACCESS_CIVILIAN_COMMAND)
			return "Civilian Command"
		if(ACCESS_CIVILIAN_MEDBAY)
			return "Civilian Medbay"
		if(ACCESS_CIVILIAN_LOGISTICS)
			return "Civilian Logistics"
		if(ACCESS_CIVILIAN_ENGINEERING)
			return "Civilian Engineering"
		if(ACCESS_CIVILIAN_BRIG)
			return "Civilian Brig"
		if(ACCESS_CIVILIAN_PUBLIC)
			return "Civilian"
		if(ACCESS_MARINE_SEA)
			return "SEA's Office"
		if(ACCESS_MARINE_KITCHEN)
			return "Kitchen"
		if(ACCESS_MARINE_SYNTH)
			return "Synthetic Storage"
		if(ACCESS_MARINE_AI)
			return "AI Core"
		if(ACCESS_MARINE_AI_TEMP)
			return "AI Access"
		if(ACCESS_ARES_DEBUG)
			return "AI Debug"

/proc/get_region_accesses_wy(code)
	switch(code)
		if(0)//Everything
			return get_access(ACCESS_LIST_WY_ALL)
		if(1)//Corporate General
			return list(ACCESS_WY_GENERAL, ACCESS_WY_COLONIAL, ACCESS_WY_EXEC)
		if(2)//Corporate Security
			return list(ACCESS_WY_SECURITY, ACCESS_WY_ARMORY)
		if(3)//Corporate Departments
			return list(ACCESS_WY_MEDICAL, ACCESS_WY_ENGINEERING, ACCESS_WY_FLIGHT, ACCESS_WY_RESEARCH)
		if(4)//Corporate Leadership
			return list(ACCESS_WY_LEADERSHIP, ACCESS_WY_SENIOR_LEAD, ACCESS_WY_SECRETS, ACCESS_WY_DATABASE)
		if(5)//PMCs
			return list(ACCESS_WY_PMC, ACCESS_WY_PMC_TL, ACCESS_WY_ARMORY)
		if(6)//Civilian
			return get_access(ACCESS_LIST_COLONIAL_ALL)

/proc/get_region_accesses_name_wy(code)
	switch(code)
		if(0)
			return "All"
		if(1)
			return "Corporate" // Security
		if(2)
			return "Corporate Security" // Medbay
		if(3)
			return "Corporate Departments" // Research
		if(4)
			return "Corporate Leadership" // Engineering
		if(5)
			return "Corporate PMCs" // Command
		if(6)
			return "Civilian" // Civilian

/proc/get_weyland_access_desc(A)
	switch(A)
		if(ACCESS_WY_GENERAL)
			return "Wey-Yu General"
		if(ACCESS_WY_COLONIAL)
			return "Wey-Yu Colony"
		if(ACCESS_WY_MEDICAL)
			return "Wey-Yu Medical"
		if(ACCESS_WY_SECURITY)
			return "Wey-Yu Security"
		if(ACCESS_WY_ENGINEERING)
			return "Wey-Yu Engineering"
		if(ACCESS_WY_FLIGHT)
			return "Wey-Yu Flight Control"
		if(ACCESS_WY_RESEARCH)
			return "Wey-Yu Research"
		if(ACCESS_WY_EXEC)
			return "Wey-Yu Executive"
		if(ACCESS_WY_PMC)
			return "Wey-Yu PMC"
		if(ACCESS_WY_PMC_TL)
			return "Wey-Yu PMC Lead"
		if(ACCESS_WY_ARMORY)
			return "Wey-Yu Armory"
		if(ACCESS_WY_SECRETS)
			return "Wey-Yu HighSec"
		if(ACCESS_WY_DATABASE)
			return "Wey-Yu Database"
		if(ACCESS_WY_LEADERSHIP)
			return "Wey-Yu Leadership"
		if(ACCESS_WY_SENIOR_LEAD)
			return "Wey-Yu Senior Leadership"
		if(ACCESS_CIVILIAN_RESEARCH)
			return "Civilian Research"
		if(ACCESS_CIVILIAN_COMMAND)
			return "Civilian Command"
		if(ACCESS_CIVILIAN_MEDBAY)
			return "Civilian Medbay"
		if(ACCESS_CIVILIAN_LOGISTICS)
			return "Civilian Logistics"
		if(ACCESS_CIVILIAN_ENGINEERING)
			return "Civilian Engineering"
		if(ACCESS_CIVILIAN_BRIG)
			return "Civilian Brig"
		if(ACCESS_CIVILIAN_PUBLIC)
			return "Civilian"
