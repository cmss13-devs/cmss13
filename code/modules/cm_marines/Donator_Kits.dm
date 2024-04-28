/obj/item/storage/box/donator_kit
	name = "donated box"
	desc = "A cardboard box stamped with a dollar sign and filled with trinkets. Appears to have been donated by a wealthy sponsor."
	icon_state = "donator_kit"
	item_state = "giftbag"
	var/list/donor_gear = list()
	var/donor_key = "GENERIC" //Key the kit is assigned to. If GENERIC, not tied to particular donor.
	var/kit_variant
	max_w_class = SIZE_TINY

/obj/item/storage/box/donator_kit/New()
	if(kit_variant)
		name = "[name] ([kit_variant])"
	..()

/obj/item/storage/box/donator_kit/fill_preset_inventory()
	for(var/donor_item in donor_gear)
		new donor_item(src)

/obj/item/storage/box/donator_kit/open(mob/user)
	if((donor_key != "GENERIC") && (donor_key != user.ckey))
		to_chat(user, SPAN_BOLDWARNING("You cannot open a donator kit you do not own!"))
		return FALSE
	..()

/obj/item/storage/box/donator_kit/verb/destroy_kit()
	set name = "Destroy Kit"
	set category = "Object"
	set src in oview(1)

	var/mob/user = usr

	if((donor_key != "GENERIC") && (donor_key != user.ckey))
		to_chat(user, SPAN_BOLDWARNING("You cannot destroy a donator kit you do not own!"))
		return FALSE

	log_admin("[key_name(user)] deleted a donator kit.")
	qdel(src)

/obj/item/storage/box/donator_kit/generic_omega //Generic set given to various donors
	kit_variant = "Team Omega (G)"
	donor_gear = list(
		/obj/item/clothing/under/marine/fluff/standard_jumpsuit,
		/obj/item/clothing/suit/storage/marine/fluff/standard_armor,
		/obj/item/clothing/head/helmet/marine/fluff/standard_helmet,
	)

/*
//Unless specified in comments as otherwise, subtype of box/donator_kit/ is CKEY of the donator (example: /obj/item/storage/box/donator_kit/sasoperative)
/obj/item/storage/box/donator_kit/xdinka
	donor_key = "xdinka"
	donor_gear = list(/obj/item/weapon/donatorkatana)
*/
