/* Cards
 * Contains:
 * DATA CARD
 * ID CARD
 * FINGERPRINT CARD HOLDER
 * FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/items/card.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/ids_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/ids_righthand.dmi',
	)
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
	black_market_value = 50

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
	var/id_type = "ID Card"
	var/list/faction_group
	/// For custom minimap icons
	var/minimap_icon_override = null

	/// The name registered_name on the card
	var/registered_name = "Unknown"
	var/datum/weakref/registered_ref = null
	var/registered_gid = 0
	flags_equip_slot = SLOT_ID

	var/blood_type = "\[UNSET\]"

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system

	/// can be alt title or the actual job
	var/assignment = null
	/// actual job
	var/rank = null
	/// Marine's paygrade
	var/paygrade = PAY_SHORT_CIV
	/// For medics and engineers to 'claim' a locker
	var/claimedgear = 1

	var/list/uniform_sets = null
	var/list/vended_items

	/// whether the id's onmob overlay only appear when wearing a uniform
	var/pinned_on_uniform = TRUE

	var/modification_log = list()


/obj/item/card/id/Destroy()
	. = ..()
	screen_loc = null

/obj/item/card/id/proc/GetJobName() //Used in secHUD icon generation

	var/job_icons = get_all_job_icons()
	var/centcom = get_all_centcom_jobs()

	if(assignment in job_icons)
		return assignment//Check if the job has a hud icon
	if(rank in job_icons)
		return rank
	if(assignment in centcom)
		return "Centcom"//Return with the NT logo if it is a Centcom job
	if(rank in centcom)
		return "Centcom"
	return "Unknown" //Return unknown if none of the above apply

/obj/item/card/id/attack_self(mob/user as mob)
	..()
	user.visible_message("[user] shows you: [icon2html(src, viewers(user))] [name]: assignment: [assignment]")
	src.add_fingerprint(user)

/obj/item/card/id/proc/set_user_data(mob/living/carbon/human/H)
	if(!istype(H))
		return

	registered_name = H.real_name
	registered_ref = WEAKREF(H)
	registered_gid = H.gid
	blood_type = H.blood_type

/obj/item/card/id/proc/set_assignment(new_assignment)
	assignment = new_assignment
	name = "[registered_name]'s [id_type] ([assignment])"

/obj/item/card/id/GetAccess()
	return access

/obj/item/card/id/GetID()
	return src

/obj/item/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[icon2html(src, usr)] [name]: The current assignment on the card is [assignment]")
	to_chat(usr, "The blood type on the card is [blood_type].")

/obj/item/card/id/proc/check_biometrics(mob/living/carbon/human/target)
	if(registered_ref && (registered_ref != WEAKREF(target)))
		return FALSE
	if(target.real_name != registered_name)
		return FALSE
	return TRUE

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
	var/credits_to_give = 15 //gives the equivalent clearance access in credits

/obj/item/card/id/silver/clearance_badge/scientist
	name = "corporate scientist badge"
	desc = "A corporate holo-badge. It is fingerprint locked with clearance level 4 access. It is commonly held by corporate scientists."
	credits_to_give = 27

/obj/item/card/id/silver/clearance_badge/cl
	name = "corporate liaison badge"
	desc = "A corporate holo-badge in unique corporate orange and white. It is fingerprint locked with clearance level 5 access. It is commonly held by corporate liaisons."
	icon_state = "cl"
	credits_to_give = 42

/obj/item/card/id/silver/clearance_badge/manager
	name = "corporate manager badge"
	desc = "A corporate holo-badge in standard corporate orange and white. It has a unique uncapped bottom. It is fingerprint locked with 5-X clearance level. Commonly held by corporate managers."
	icon_state = "pmc"
	credits_to_give = 47

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
	id_type = "Document"
	icon_state = "visa"

/obj/item/card/id/silver/cl
	name = "corporate holo-badge"
	desc = "A corporate holo-badge. It's a unique Corporate orange and white."
	icon_state = "cl"

/obj/item/card/id/gold/council
	name = "identification holo-badge"
	desc = "A real bronze gold Colonel's holo-badge. Commands respect, authority, and it makes an excellent paperweight."
	icon_state = "commodore"

/obj/item/card/id/pmc
	name = "\improper PMC holo-badge"
	desc = "A corporate holo-badge. It has a unique uncapped bottom."
	icon_state = "pmc"
	registered_name = "The Corporation"
	assignment = "Corporate Mercenary"

/obj/item/card/id/pmc/New()
	access = get_access(ACCESS_LIST_WY_ALL)
	..()

/obj/item/card/id/pmc/commando
	name = "\improper W-Y Commando holo-badge"
	assignment = "Corporate Commando"
	icon_state = "commando"

/obj/item/card/id/pmc/ds
	name = "\improper Corporate holo-badge"
	desc = "It lists a callsign and a series number. Issued to Whiteout protocol teams only."
	icon_state = "ds"

/obj/item/card/id/marshal
	name = "\improper CMB marshal gold badge"
	desc = "A coveted gold badge signifying that the wearer is one of the few CMB Marshals patroling the outer rim. It is a sign of justice, authority, and protection. Protecting those who can't. This badge represents a commitment to a sworn oath always kept."
	icon_state = "cmbmar"
	id_type = "Badge"
	item_state = "cmbmar"
	paygrade = PAY_SHORT_CMBM

/obj/item/card/id/deputy
	name = "\improper CMB deputy silver badge"
	desc = "The silver badge which represents that the wearer is a CMB Deputy. It is a sign of justice, authority, and protection. Protecting those who can't. This badge represents a commitment to a sworn oath always kept."
	icon_state = "cmbdep"
	id_type = "Badge"
	item_state = "cmbdep"
	paygrade = PAY_SHORT_CMBD

/obj/item/card/id/deputy/riot
	name = "\improper CMB riot officer silver badge"
	desc = "The silver badge which represents that the wearer is a CMB Riot Control Officer. It is a sign of justice, authority, and protection. Protecting those who can't. This badge represents a commitment to a sworn oath always kept."
	paygrade = PAY_SHORT_CMBR

/obj/item/card/id/nspa_silver
	name = "\improper NSPA silver badge"
	desc = "The silver badge which represents that the wearer is a NSPA Constable. It is a sign of justice, authority, and protection. Protecting those who can't. This badge represents a commitment to a sworn oath always kept."
	icon_state = "nspa_silver"
	item_state = "silver_id"
	paygrade = PAY_SHORT_CST

/obj/item/card/id/nspa_silver_gold
	name = "\improper NSPA silver & gold badge"
	desc = "The silver with gold accents badge which represents that the wearer is a NSPA Senior Constable to Sergeant. It is a sign of justice, authority, and protection. Protecting those who can't. This badge represents a commitment to a sworn oath always kept."
	icon_state = "nspa_silverandgold"
	item_state = "silver_id"
	paygrade = PAY_SHORT_SGT

/obj/item/card/id/nspa_gold
	name = "\improper NSPA gold badge"
	desc = "A gold badge signifying that the wearer is one of the higher ranks of the NSPA, usually Inspectors and above. It is a sign of justice, authority, and protection. Protecting those who can't. This badge represents a commitment to a sworn oath always kept."
	icon_state = "nspa_gold"
	item_state = "gold_id"
	paygrade = PAY_SHORT_CINSP

/obj/item/card/id/general
	name = "general officer holo-badge"
	desc = "Top brass of the top brass. Issued to only the most dedicated."
	icon_state = "general"
	registered_name = "The USCM"
	assignment = "General"

/obj/item/card/id/general/New()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/obj/item/card/id/provost
	name = "provost holo-badge"
	desc = "Issued to members of the Provost Office."
	icon_state = "provost"
	registered_name = "Provost Office"
	assignment = "Provost"

/obj/item/card/id/provost/New()
	access = get_access(ACCESS_LIST_MARINE_ALL)

/obj/item/card/id/adaptive
	name = "agent card"
	access = list(ACCESS_ILLEGAL_PIRATE)

/obj/item/card/id/adaptive/New(mob/user as mob)
	..()
	if(!QDELETED(user)) // Runtime prevention on laggy starts or where users log out because of lag at round start.
		registered_name = ishuman(user) ? user.real_name : "Unknown"
	assignment = "Agent"
	name = "[registered_name]'s [id_type] ([assignment])"

/obj/item/card/id/adaptive/afterattack(obj/item/O as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/target_id = O
		access |= target_id.access
		if(ishuman(user))
			to_chat(user, SPAN_NOTICE("The card's microscanners activate as you pass it over the ID, copying its access."))

/obj/item/card/id/adaptive/attack_self(mob/user as mob)
	switch(alert("Would you like to display the ID, or retitle it?","Choose.","Rename","Show"))
		if("Rename")
			var/new_name = strip_html(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name),26)
			if(!new_name || new_name == "Unknown" || new_name == "floor" || new_name == "wall" || new_name == "r-wall") //Same as mob/new_player/prefrences.dm
				to_chat(user, SPAN_WARNING("Invalid Name."))
				return

			var/new_job = strip_html(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Assistant"))
			if(!new_job)
				to_chat(user, SPAN_WARNING("Invalid Assignment."))
				return

			var/new_rank = strip_html(input(user, "What paygrade do would you like to put on this card?\nNote: This must be the shorthand version of the grade, I.E CIV for Civillian or ME1 for Marine Private", "Agent card paygrade assignment", PAY_SHORT_CIV))
			if(!new_rank || !(new_rank in GLOB.paygrades))
				to_chat(user, SPAN_WARNING("Invalid Paygrade."))
				return

			registered_name = new_name
			assignment = new_job
			name = "[registered_name]'s [id_type] ([assignment])"
			paygrade = new_rank
			to_chat(user, SPAN_NOTICE("You successfully forge the ID card."))
			return
	..()

/obj/item/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"

/obj/item/card/id/captains_spare/New()
	access = get_access(ACCESS_LIST_MARINE_ALL)
	..()

/obj/item/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/card/id/centcom/New()
	access = get_access(ACCESS_LIST_WY_ALL)
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
	name = "dog tags"
	desc = "A marine dog tags."
	icon_state = "dogtag"
	item_state = "dogtag"
	id_type = "Dogtags"
	pinned_on_uniform = FALSE
	var/tags_taken_icon = "dogtag_taken"
	var/infotag_type = /obj/item/dogtag
	var/dogtag_taken = FALSE


/obj/item/card/id/dogtag/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_NOTICE("It reads \"[registered_name] - [assignment] - [blood_type]\"")

/obj/item/card/id/dogtag/upp
	name = "UPP dog tag"
	desc = "A soldier dog tag."
	icon_state = "dogtag_upp"
	tags_taken_icon = "dogtag_upp_taken"

/obj/item/dogtag
	name = "information dog tag"
	desc = "A fallen marine's information dog tag."
	icon_state = "dogtag_taken"
	icon = 'icons/obj/items/card.dmi'
	w_class = SIZE_TINY
	var/list/fallen_references
	var/list/fallen_names
	var/list/fallen_blood_types
	var/list/fallen_assgns

/obj/item/dogtag/Initialize()
	. = ..()

	fallen_references = list()
	fallen_names = list()
	fallen_blood_types = list()
	fallen_assgns = list()

/obj/item/dogtag/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dogtag))
		var/obj/item/dogtag/D = I
		to_chat(user, SPAN_NOTICE("You join the [length(fallen_names)>1 ? "tags":"two tags"] together."))
		name = "information dog tags"
		if(D.fallen_names)
			fallen_references += D.fallen_references
			fallen_names += D.fallen_names
			fallen_blood_types += D.fallen_blood_types
			fallen_assgns += D.fallen_assgns
		qdel(D)
		return TRUE
	else
		. = ..()

/obj/item/dogtag/get_examine_text(mob/user)
	. = ..()
	if(ishuman(user) && LAZYLEN(fallen_names))
		var/msg = "There [length(fallen_names)>1 ? \
			"are [length(fallen_names)] tags.<br>They read":\
			"is one ID tag.<br>It reads"]:"
		for (var/i=1 to length(fallen_names))
			msg += "<br>[i]. \"[fallen_names[i]] - [fallen_assgns[i]] - [fallen_blood_types[i]]\""
		. += SPAN_NOTICE("[msg]")

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
