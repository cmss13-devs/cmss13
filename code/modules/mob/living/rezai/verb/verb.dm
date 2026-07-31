
/* Todo - make it locked to admin only.
CLIENT_VERB(rezai_create_rfn)
	set name = "Create_RFN_BT"
	set category = "Rezzer.BT_AI"
	//create human - create bt, stuff.. bb etc.
	var/atom/initial_spot = usr.loc
	var/turf/initial_turf = get_turf(initial_spot)

	var/mob/living/carbon/human/spawned_human
	spawned_human = new(initial_turf)

	if(!spawned_human.hud_used)
		spawned_human.create_hud()

	arm_equipment(spawned_human, "USCM Cryo Squad Rifleman (Equipped)", TRUE, FALSE)

	// Ensure created humans get proper minimap integration
	var/obj/item/device/radio/headset/headset = spawned_human.wear_l_ear
	if(!headset || !istype(headset, /obj/item/device/radio/headset))
		headset = spawned_human.wear_r_ear
	if(headset && istype(headset, /obj/item/device/radio/headset) && headset.minimap_type)
		headset.add_minimap(spawned_human)

	message_admins("[key_name_admin(usr)] created BT AI xxx humans as 'USCM Cryo Squad Rifleman (Equipped)' at [get_area(initial_spot)]")

	//create behaviour tree
	spawned_human.rezai = new(spawned_human)

*/

