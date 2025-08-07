
/mob/living/carbon/human/var/opened_gift = 0

/obj/item/m_gift //Marine Gift
	name = "Present"
	desc = "One, standard issue USCM Present"
	icon = 'icons/obj/items/gifts.dmi'
	icon_state = "gift1"
	item_state = "gift1"

/obj/item/m_gift/Initialize()
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	if(w_class > 0 && w_class < 4)
		icon_state = "gift[w_class]"
	else
		icon_state = "gift[pick(1, 2, 3)]"
	return

/obj/item/m_gift/attack_self(mob/M)
	..()

	var/mob/living/carbon/human/H = M
	if(istype(H))
		if(H.opened_gift == 1)
			to_chat(H, SPAN_NOTICE(" This is not your gift, opening it feels wrong."))
		if(H.opened_gift == 2)
			to_chat(H, SPAN_NOTICE(" Santa knows of your treachery, yet you open another present."))
		if(H.opened_gift == 3)
			to_chat(H, SPAN_NOTICE(" Even the Grinch glares with disguist..."))
		if(H.opened_gift == 4)
			to_chat(H, SPAN_NOTICE(" You're ruining the Christmas magic, I hope you're happy."))
		if(H.opened_gift == 5)
			to_chat(H, SPAN_DANGER("Ok, Congratulations, you've ruined Christmas for 5 marines now."))
		if(H.opened_gift > 5)
			to_chat(H, SPAN_DANGER("You've ruined Christmas for [H.opened_gift] marines now..."))

		H.opened_gift++
	/// Check if it has the possibility of being a FANCY present
	var fancy = rand(1,100)
	/// Checks if it might be one of the ULTRA fancy presents.
	var exFancy = rand(1,20)
	/// Default, just in case
	var gift_type = /obj/item/storage/fancy/crayons
	if(fancy > 90)
		if(exFancy == 1)
			to_chat(M, SPAN_NOTICE(" Just what the fuck is it???"))
			gift_type = /obj/item/clothing/mask/facehugger/lamarr
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			qdel(src)
			return
		if(exFancy > 15)
			to_chat(M, SPAN_NOTICE(" Oh, just what I needed... Fucking HEFA's."))
			gift_type = /obj/item/storage/box/nade_box/frag
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			qdel(src)
			return
		else
			gift_type = pick(
			/obj/item/weapon/gun/revolver/mateba,
			/obj/item/weapon/gun/pistol/heavy,
			/obj/item/weapon/sword,
			/obj/item/weapon/energy/sword/green,
			/obj/item/weapon/energy/sword/red,
			/obj/item/attachable/heavy_barrel,
			/obj/item/attachable/extended_barrel,
			/obj/item/attachable/burstfire_assembly,
			)
			to_chat(M, SPAN_NOTICE(" It's a REAL gift!!!"))
			var/obj/item/I = new gift_type(M)
			M.temp_drop_inv_item(src)
			M.put_in_hands(I)
			I.add_fingerprint(M)
			qdel(src)
			return
	else if (fancy <=5)
		to_chat(M, SPAN_NOTICE(" It's fucking EMPTY.  Man, Fuck CM."))
		M.temp_drop_inv_item(src)
		qdel(src)
		return


	gift_type = pick(
		/obj/item/storage/box/snappops,
		/obj/item/storage/fancy/crayons,
		/obj/item/storage/belt/champion,
		/obj/item/tool/soap/deluxe,
		/obj/item/explosive/grenade/smokebomb,
		/obj/item/poster,
		/obj/item/toy/bikehorn,
		/obj/item/toy/beach_ball,
		/obj/item/weapon/banhammer,
		/obj/item/toy/crossbow,
		/obj/item/toy/gun,
		/obj/item/toy/katana,
		/obj/item/toy/prize/deathripley,
		/obj/item/toy/prize/durand,
		/obj/item/toy/prize/fireripley,
		/obj/item/toy/prize/gygax,
		/obj/item/toy/prize/honk,
		/obj/item/toy/prize/marauder,
		/obj/item/toy/prize/mauler,
		/obj/item/toy/prize/odysseus,
		/obj/item/toy/prize/phazon,
		/obj/item/toy/prize/ripley,
		/obj/item/toy/prize/seraph,
		/obj/item/toy/spinningtoy,
		/obj/item/clothing/accessory/horrible,
		/obj/item/clothing/shoes/slippers,
		/obj/item/clothing/shoes/slippers_worn,
		/obj/item/clothing/head/collectable/tophat/super,
		/obj/item/attachable/suppressor,
		/obj/item/attachable/bayonet,
		/obj/item/attachable/reddot,
		/obj/item/attachable/verticalgrip,
		/obj/item/attachable/angledgrip,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/bipod,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/stock/rifle,
		/obj/item/attachable/scope)

	if(!ispath(gift_type,/obj/item))
		return
	to_chat(M, SPAN_NOTICE(" At least it's something..."))
	var/obj/item/I = new gift_type(M)
	M.temp_drop_inv_item(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	qdel(src)
	return
