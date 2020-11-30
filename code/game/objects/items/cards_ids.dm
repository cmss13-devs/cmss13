/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/items/card.dmi'
	w_class = SIZE_TINY
	var/associated_account_number = 0

	var/list/files = list(  )

/obj/item/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = OBJ_LAYER
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/card/id
	name = "identification holo-badge"
	desc = "A slice of encoded compressed fiber glass. Used for identification and access control."
	icon_state = "id"
	item_state = "card-id"
	var/access = list()
	var/faction = FACTION_NEUTRAL
	var/faction_group

	var/registered_name = "Unknown" // The name registered_name on the card
	var/registered_gid = 0
	flags_equip_slot = SLOT_ID

	var/blood_type = "\[UNSET\]"

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/paygrade = "E0"  // Marine's paygrade
	var/claimedgear = 1 // For medics and engineers to 'claim' a locker

	var/list/uniform_sets = null
	var/list/vended_items

	var/pinned_on_uniform = TRUE //whether the id's onmob overlay only appear when wearing a uniform


/obj/item/card/id/Destroy()
	. = ..()
	screen_loc = null

/obj/item/card/id/New()
	..()

	spawn(30)
		var/mob/living/carbon/human/H = loc
		if(istype(H))
			blood_type = H.blood_type
		if(istype(H) && isnull(faction_group))
			faction_group = H.faction_group


/obj/item/card/id/attack_self(mob/user as mob)
	user.visible_message("[user] shows you: [htmlicon(src, viewers(user))] [name]: assignment: [assignment]")

	src.add_fingerprint(user)
	return

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/proc/fail_agent_objectives()
	var/mob/living/carbon/human/A
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.gid == registered_gid && H.agent_holder)
			A = H

	if(!A)
		return FALSE

	for(var/datum/agent_objective/O in A.agent_holder.objectives_list)
		O.terminated = TRUE

	return TRUE

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[htmlicon(src, usr)] [name]: The current assignment on the card is [assignment]")
	to_chat(usr, "The blood type on the card is [blood_type].")


/obj/item/card/id/data
	name = "identification holo-badge"
	desc = "A plain, mass produced holo-badge."
	icon_state = "data"

/obj/item/card/id/lanyard
	name = "identification holo-lanyard"
	desc = "A crude holo-lanyard. As cheap as they come."
	icon_state = "lanyard"

/obj/item/card/id/silver
	name = "identification holo-badge"
	desc = "A silver plated holo-badge which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/card/id/silver/clearance_badge
	name = "corporate doctor badge"
	desc = "A corporate holo-badge. It is fingerprint locked with clearance level 3 access. It is commonly held by corporate doctors."
	icon_state = "clearance"
	var/clearance_access = 3

/obj/item/card/id/silver/clearance_badge/scientist
	name = "corporate scientist badge"
	desc = "A corporate holo-badge. It is fingerprint locked with clearance level 4 access. It is commonly held by corporate scientists."
	clearance_access = 4

/obj/item/card/id/silver/clearance_badge/cl
	name = "corporate liason badge"
	desc = "A corporate holo-badge in unique corporate orange and white. It is fingerprint locked with clearance level 5 access. It is commonly held by corporate liasons."
	icon_state = "cl"
	clearance_access = 5

/obj/item/card/id/silver/clearance_badge/manager
	name = "corporate manager badge"
	desc = "A corporate holo-badge in standard corporate orange and white. It has a unique uncapped bottom. It is fingerprint locked with 5-X clearance level. Commonly held by corporate managers."
	icon_state = "pmc"
	clearance_access = 6

/obj/item/card/id/pizza
	name = "pizza guy badge"
	desc = "It reads: 'Pizza-guy local union No. 217','We always deliver!'"
	icon_state = "pizza"
	item_state = "gold_id"

/obj/item/card/id/souto
	name = "Souto Man"
	desc = "It reads: 'The one and only!'"
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/card/id/gold
	name = "identification holo-badge"
	desc = "A gold plated holo-badge which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/card/id/visa
	name = "battered-up visa card"
	desc = "A corporate holo-badge. It's a unique Corporate orange and white."
	icon_state = "visa"

/obj/item/card/id/silver/cl
	name = "corporate holo-badge"
	desc = "A corporate holo-badge. It's a unique Corporate orange and white."
	icon_state = "cl"

/obj/item/card/id/gold/commodore
	name = "identification holo-badge"
	desc = "A real bronze gold Commodore's holo-badge. Commands respect, authority, and it makes an excellent paperweight."
	icon_state = "commodore"

/obj/item/card/id/pmc
	name = "\improper PMC holo-badge"
	desc = "A corporate holo-badge. It has a unique uncapped bottom."
	icon_state = "pmc"
	registered_name = "The Corporation"
	assignment = "Corporate Mercenary"
	New()
		access = get_all_centcom_access()
		..()

/obj/item/card/id/pmc/ds
	name = "\improper Corporate holo-badge"
	desc = "It lists a callsign and a bloodtype. Issued to Whiteout protocol teams only."
	icon_state = "ds"

/obj/item/card/id/admiral
	name = "admirality holo-badge"
	desc = "Top brass of the top brass. Issued to only the most dedicated."
	icon_state = "admiral"
	registered_name = "The USCM"
	assignment = "Admiral"
	New()
		access = get_all_centcom_access()

/obj/item/card/id/syndicate
	name = "agent card"
	access = list(ACCESS_ILLEGAL_PIRATE)
	var/registered_user=null

/obj/item/card/id/syndicate/New(mob/user as mob)
	..()
	if(!QDELETED(user)) // Runtime prevention on laggy starts or where users log out because of lag at round start.
		registered_name = ishuman(user) ? user.real_name : user.name
	else
		registered_name = "Agent Card"
	assignment = "Agent"
	name = "[registered_name]'s ID Card ([assignment])"

/obj/item/card/id/syndicate/afterattack(var/obj/item/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/I = O
		src.access |= I.access
		if(istype(user, /mob/living) && user.mind)
			to_chat(usr, SPAN_NOTICE(" The card's microscanners activate as you pass it over the ID, copying its access."))

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = reject_bad_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name))
		if(!t) //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		src.registered_name = t

		var u = strip_html(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Agent"))
		if(!u)
			alert("Invalid assignment.")
			src.registered_name = ""
			return
		src.assignment = u
		src.name = "[src.registered_name]'s ID Card ([src.assignment])"
		to_chat(user, SPAN_NOTICE(" You successfully forge the ID card."))
		registered_user = user
	else if(!registered_user || registered_user == user)

		if(!registered_user) registered_user = user  //

		switch(alert("Would you like to display the ID, or retitle it?","Choose.","Rename","Show"))
			if("Rename")
				var t = strip_html(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name),26)
				if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
					alert("Invalid name.")
					return
				src.registered_name = t

				var u = strip_html(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant"))
				if(!u)
					alert("Invalid assignment.")
					return
				src.assignment = u
				src.name = "[src.registered_name]'s ID Card ([src.assignment])"
				to_chat(user, SPAN_NOTICE(" You successfully forge the ID card."))
				return
			if("Show")
				..()
	else
		..()



/obj/item/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(ACCESS_ILLEGAL_PIRATE)

/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	New()
		access = get_all_marine_access()
		..()

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
	New()
		access = get_all_centcom_access()
		..()


/obj/item/card/id/equipped(mob/living/carbon/human/H, slot)
	if(istype(H))
		H.update_inv_head() //updating marine helmet squad coloring
		H.update_inv_wear_suit()
	..()

/obj/item/card/id/dropped(mob/user)
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_head() //Don't do a full update yet
		H.update_inv_wear_suit()
	..()



/obj/item/card/id/dogtag
	name = "dog tag"
	desc = "A marine dog tag."
	icon_state = "dogtag"
	item_state = "dogtag"
	pinned_on_uniform = FALSE
	var/dogtag_taken = FALSE


/obj/item/card/id/dogtag/examine(mob/user)
	..()
	if(ishuman(user))
		to_chat(user, SPAN_NOTICE("It reads \"[registered_name] - [assignment] - [blood_type]\""))


/obj/item/dogtag
	name = "information dog tag"
	desc = "A fallen marine's information dog tag."
	icon_state = "dogtag_taken"
	icon = 'icons/obj/items/card.dmi'
	w_class = SIZE_TINY
	var/list/fallen_names
	var/list/fallen_blood_types
	var/list/fallen_assgns

/obj/item/dogtag/Initialize()
	. = ..()

	fallen_names = list()
	fallen_blood_types = list()
	fallen_assgns = list()

/obj/item/dogtag/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		to_chat(user, SPAN_NOTICE("You join the [fallen_names.len>1 ? "tags":"two tags"] together."))
		name = "information dog tags"
		if(D.fallen_names)
			fallen_names += D.fallen_names
			fallen_blood_types += D.fallen_blood_types
			fallen_assgns += D.fallen_assgns
		qdel(D)
		return TRUE
	else
		. = ..()

/obj/item/dogtag/examine(mob/user)
	..()
	if(ishuman(user) && fallen_names && fallen_names.len)
		var/msg = "There [fallen_names.len>1 ? \
			"are [fallen_names.len] tags.<br>They read":\
			"is one ID tag.<br>It reads"]:"
		for (var/i=1 to fallen_names.len)
			msg += "<br>[i]. \"[fallen_names[i]] - [fallen_assgns[i]] - [fallen_blood_types[i]]\""
		to_chat(user, SPAN_NOTICE("[msg]"))

// Used to authenticate to CORSAT machines. Doesn't do anything except have its type variable
/obj/item/card/data/corsat
	name = "CORSAT administration code"
	desc = "A disk of data containing one of the CORSAT administration authentication codes necessary to lift the biohazard lockdown."
	icon_state = "data"
	item_state = "card-id"
	unacidable = 1

/obj/item/card/data/prison
	name = "prison lockdown administration code"
	desc = "A disk of data containing one of the prison station administration authentication codes necessary to lift the security lockdown."
	icon_state = "data"
	item_state = "card-id"
	unacidable = 1
