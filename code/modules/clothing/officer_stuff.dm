 // Reference: http://www.teuse.net/personal/harrington/hh_bible.htm
 // http://www.trmn.org/portal/images/uniforms/rmn/rmn_officer_srv_dress_lrg.png

/obj/item/clothing/head/beret/centcom/officer
	name = "officers beret"
	desc = "A black beret adorned with a silver kite shield and an engraved sword of the Wey-Yu security forces, announcing to the world that the wearer is a defender of Wey-Yu."
	icon_state = "centcomofficerberet"

/obj/item/clothing/head/beret/centcom/captain
	name = "captains beret"
	desc = "A white beret adorned with a cobalt kite shield with an engraved sword of the Wey-Yu security forces, worn only by those captaining a vessel of the Wey-Yu Navy."
	icon_state = "centcomcaptain"

/obj/item/clothing/shoes/centcom
	name = "dress shoes"
	desc = "They appear impeccably polished."
	icon_state = "laceups"

/obj/item/clothing/under/rank/centcom/representative
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Ensign\" and bears \"N.C.V. Fearless CV-286\" on the left shoulder."
	name = "\improper Wey-Yu Navy Uniform"
	icon_state = "officer"
	item_state = "g_suit"
	displays_id = 0

/obj/item/clothing/under/rank/centcom/officer
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Lieutenant Commander\" and bears \"N.C.V. Fearless CV-286\" on the left shoulder."
	name = "\improper Wey-Yu Officer Uniform"
	icon_state = "officer"
	item_state = "g_suit"
	displays_id = 0
	item_state_slots = list(WEAR_BODY = "officer")

/obj/item/clothing/under/rank/centcom/captain
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral\" and bears \"N.C.V. Fearless CV-286\" on the left shoulder."
	name = "\improper Wey-Yu Admiral Uniform"
	icon_state = "centcom"
	item_state = "dg_suit"
	displays_id = 0
