/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/items/clothing/hats.dmi'
	flags_armor_protection = BODY_FLAG_HEAD
	flags_equip_slot = SLOT_HEAD
	w_class = SIZE_SMALL
	blood_overlay_type = "helmet"
	var/anti_hug = 0

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()



/obj/item/clothing/head/cmbandana
	name = "bandana"
	desc = "Typically worn by heavy-weapon operators, mercenaries and scouts, the bandana serves as a lightweight and comfortable hat. Comes in two stylish colors."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "band"
	flags_inv_hide = HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmbandana/New()
	select_gamemode_skin(/obj/item/clothing/head/cmbandana)
	..()

/obj/item/clothing/head/cmbandana/tan
	icon_state = "band2"


/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A standard military beanie, often worn by non-combat military personnel and support crews, though it is not uncommon to see combat personnel who no longer care about self-preservation wearing one of these as well. Popular due to being comfortable and snug."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "beanie_cargo"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beanie/green
	icon_state = "beaniegreen"

/obj/item/clothing/head/beanie/gray
	icon_state = "beaniegray"

/obj/item/clothing/head/beanie/tan
	icon_state = "beanietan"

/obj/item/clothing/head/beret/cm
	name = "\improper USCM beret"
	desc = "A hat typically worn by the field-officers of the USCM. Occasionally they find their way down the ranks into the hands of squad-leaders and decorated grunts."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "beret"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beret/cm/New()
	select_gamemode_skin(/obj/item/clothing/head/beret/cm)
	..()

/obj/item/clothing/head/beret/cm/tan
	icon_state = "berettan"

/obj/item/clothing/head/beret/cm/tan/New()
	select_gamemode_skin(/obj/item/clothing/head/beret/cm/tan)
	..()

/obj/item/clothing/head/beret/cm/red
	icon_state = "beretred"
/obj/item/clothing/head/headband
	name = "headband"
	desc = "A rag typically worn by the less-orthodox weapons operators. While it offers no protection, it is certainly comfortable to wear compared to the standard helmet. Comes in two stylish colors."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "headband"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/headband/New()
	select_gamemode_skin(/obj/item/clothing/head/headband)
	..()

/obj/item/clothing/head/headband/red
	icon_state = "headbandred"

/obj/item/clothing/head/headband/tan
	icon_state = "headbandtan"

/obj/item/clothing/head/headband/rebel
	desc = "A headband made from a simple strip of cloth. The words \"DOWN WITH TYRANTS\" are emblazoned on the front."
	icon_state = "rebelband"

/obj/item/clothing/head/headband/rambo
	desc = "It flutters in the face of the wind, defiant and unrestrained, like the man who wears it."
	icon = 'icons/obj/items/clothing/hats.dmi'
	icon_state = "headband_rambo"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_0.dmi'
	)

/obj/item/clothing/head/headset
	name = "\improper USCM headset"
	desc = "A headset typically found in use by radio-operators and officers. This one appears to be malfunctioning."
	icon_state = "headset"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmcap
	name = "patrol cap"
	desc = "A casual cap occasionally worn by Squad-leaders and Combat-Engineers. While it has limited combat functionality, some prefer to wear it instead of the standard issue helmet."
	icon_state = "cap"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	var/helmet_overlays[]
	var/flipped_cap = FALSE
	var/base_cap_icon
	var/flags_marine_helmet = HELMET_GARB_OVERLAY|HELMET_STORE_GARB
	var/obj/item/storage/internal/pockets
	var/list/allowed_hat_items = list(
						/obj/item/storage/fancy/cigarettes/emeraldgreen = "hat_cig_cig",
						/obj/item/storage/fancy/cigarettes/kpack = "hat_cig_kpack",
						/obj/item/storage/fancy/cigarettes/lucky_strikes = "hat_cig_ls",
						/obj/item/storage/fancy/cigarettes/wypacket = "hat_cig_wypack",
						/obj/item/storage/fancy/cigarettes/lady_finger = "hat_cig_lf",
						/obj/item/storage/fancy/cigarettes/blackpack = "hat_cig_blackpack",
						/obj/item/storage/fancy/cigarettes/arcturian_ace = "hat_cig_aapack",
						/obj/item/tool/pen = "hat_pen_black",
						/obj/item/tool/pen/blue = "hat_pen_blue",
						/obj/item/tool/pen/red = "hat_pen_red",
						/obj/item/clothing/glasses/welding = "welding-c",
						/obj/item/clothing/glasses/mgoggles = "goggles-c",
						/obj/item/clothing/glasses/mgoggles/prescription = "goggles-c")
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmcap/New()
	select_gamemode_skin(/obj/item/clothing/head/cmcap)
	base_cap_icon = icon_state
	..()
	helmet_overlays = list("item") //To make things simple.
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = 1
	pockets.max_w_class = 0
	pockets.bypass_w_limit = allowed_hat_items
	pockets.max_storage_space = 1

/obj/item/clothing/head/cmcap/attack_hand(mob/user)
	if(loc != user)
		..(user)
		return
	if(pockets.handle_attack_hand(user))
		..()

/obj/item/clothing/head/cmcap/MouseDrop(over_object, src_location, over_location)
	if(pockets.handle_mousedrop(usr, over_object))
		..()

/obj/item/clothing/head/cmcap/attackby(obj/item/W, mob/user)
	..()
	return pockets.attackby(W, user)

/obj/item/clothing/head/cmcap/on_pocket_insertion()
	update_icon()

/obj/item/clothing/head/cmcap/on_pocket_removal()
	update_icon()

/obj/item/clothing/head/cmcap/update_icon()
    if(ismob(loc))
        var/mob/M = loc
        M.update_inv_head()

/obj/item/clothing/head/cmcap/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(slot == WEAR_HEAD)
		if(length(pockets.contents) && (flags_marine_helmet & HELMET_GARB_OVERLAY))
			var/obj/O = pockets.contents[1]
			if(O.type in allowed_hat_items)
				var/image/I = overlay_image('icons/mob/humans/onmob/helmet_garb.dmi', "[allowed_hat_items[O.type]]", color, RESET_COLOR)
				ret.overlays += I

	return ret

/obj/item/clothing/head/cmcap/verb/fliphat()
	set name = "Flip hat"
	set category = "Object"
	set src in usr
	if(!isliving(usr)) return
	if(usr.is_mob_incapacitated()) return

	flipped_cap = !flipped_cap
	if(flipped_cap)
		to_chat(usr, "You spin the hat backwards! You look like a tool.")
		icon_state = base_cap_icon + "_b"
	else
		to_chat(usr, "You spin the hat back forwards. That's better.")
		icon_state = base_cap_icon

	update_clothing_icon()

/obj/item/clothing/head/cmcap/co
	name = "\improper USCM captain cap"
	icon_state = "cocap"
	desc = "A hat usually worn by senior officers in the USCM. While it has limited combat functionality, some prefer to wear it instead of the standard issue helmet."

/obj/item/clothing/head/cmcap/co/formal/white
	name = "\improper USCM formal captain's white cap"
	icon_state = "co_formalhat_white"
	desc = "A formal cover worn by Commanding Officers of the USCM."

/obj/item/clothing/head/cmcap/co/formal/black
	name = "\improper USCM formal captain's black cap"
	icon_state = "co_formalhat_black"
	desc = "A formal cover worn by Commanding Officers of the USCM."

/obj/item/clothing/head/cmcap/ro
	name = "\improper USCM officer cap"
	desc = "A hat usually worn by officers in the USCM. While it has limited combat functionality, some prefer to wear it instead of the standard issue helmet."
	icon_state = "rocap"

/obj/item/clothing/head/cmcap/ro/New()
	select_gamemode_skin(/obj/item/clothing/head/cmcap/ro)
	..()

/obj/item/clothing/head/cmcap/req
	name = "\improper USCM requisition cap"
	desc = "It's a fancy hat for a not-so-fancy military supply clerk."
	icon_state = "cargocap"

/obj/item/clothing/head/cmflapcap
	name = "\improper USCM expedition cap"
	desc = "It's a cap, with flaps. ALMAYER reads across a patch stitched to the front."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "flapcap"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/cmflapcap/New()
	select_gamemode_skin(/obj/item/clothing/head/cmflapcap)
	..()

/obj/item/clothing/head/cmo
	name = "\improper Chief Medical Officer's Peaked Cap"
	desc = "A peaked cap given to high ranking civilian medical officers. Looks just a touch silly."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "cmohat"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/mppeaked
	name = "\improper Military Police Peaked Cap"
	desc = "A peaked cap worn by the USCM's Military Police. Something about it reminds you of an event you once read about in a history book."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "mppeaked"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/mpcap
	name = "\improper Military Police cap"
	desc = "A ball-cap worn by the more casual of the USCM's Military Police."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "mpcap"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

//============================//BERETS\\=================================\\
//=======================================================================\\
//Berets have armor, so they have their own category. PMC caps are helmets, so they're in helmets.dm.
/obj/item/clothing/head/beret/marine
	name = "marine officer beret"
	desc = "A beret with the USCM insignia emblazoned on it. It radiates respect and authority."
	icon_state = "beret_badge"
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_NONE
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_inventory = BLOCKSHARPOBJ

/obj/item/clothing/head/helmet/beret/marine/mp
	name = "\improper USCM MP beret"
	icon_state = "beretred"
	desc = "A kevlar reinforced beret with the USCM military police insignia emblazoned on it. This durable headwear provides comparable protection to an M10 helmet, but in a much more stylish package."
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_LOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUMLOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/helmet/beret/marine/mp/warden
	name = "\improper USCM warden peaked"
	icon_state = "warden"
	desc = "A kevlar reinforced beret with the USCM military police insignia emblazoned on it. This durable headwear provides comparable protection to an M10 helmet, but in a much more stylish package."

/obj/item/clothing/head/helmet/beret/marine/mp/cmp
	name = "\improper USCM chief MP beret"
	desc = "A kevlar reinforced beret with the USCM military police lieutenant insignia emblazoned on it. This durable headwear provides comparable protection to an M10 helmet, but in a much more stylish package. It shines with the glow of corrupt authority and a smudge of doughnut."
	icon_state = "beretwo"

/obj/item/clothing/head/helmet/beret/marine/mp/provost
	name = "\improper USCM provost beret"
	icon_state = "beretwo"
	desc = "A kevlar reinforced beret with the USCM military police insignia emblazoned on it. This durable headwear provides comparable protection to an M10 helmet, but in a much more stylish package."

/obj/item/clothing/head/helmet/beret/marine/mp/provost/senior
	name = "\improper USCM senior provost beret"
	icon_state = "coblackberet"
	desc = "A kevlar reinforced beret with the USCM military police insignia emblazoned on it. This durable headwear provides comparable protection to an M10 helmet, but in a much more stylish package."


/obj/item/clothing/head/beret/marine/commander
	name = "marine captain beret"
	desc = "A beret with the captain insignia emblazoned on it. Wearer may suffer the heavy weight of responsibility upon his head and shoulders."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "coberet"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beret/marine/commander/dress
	name = "marine captain white beret"
	icon_state = "codressberet"
	desc = "A white beret with the captain insignia emblazoned on it. Its dazzling white color commands power and exudes class."

/obj/item/clothing/head/beret/marine/commander/black
	name = "marine captain black beret"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "coblackberet"
	desc = "A black beret with the captain insignia emblazoned on it. Its sleek black color commands power and exudes class."

/obj/item/clothing/head/beret/marine/commander/cdre
	name = "marine commodore beret"
	desc = "A blue beret with the commodore's insignia emblazoned on it. Its blue color symbolizes loyalty, confidence, and politics - the core components of a true Commodore."
	icon_state = "cdreberet"

/obj/item/clothing/head/beret/marine/commander/cdrechief
	name = "marine commodore-in-chief beret"
	desc = "A dark blue beret signifying the Chief of all Commodores. Rumors about the commodore-in-chief position being simply an alias for an Admiral have been declared as false."
	icon_state = "cdrechiefberet"

/obj/item/clothing/head/marine/peaked
	name = "marine peaked cap"
	desc = "A peaked cap. Wearer may suffer the heavy weight of responsibility upon his head and shoulders."
	icon = 'icons/obj/items/clothing/hats.dmi'
	icon_state = "officercap"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_0.dmi'
	)

/obj/item/clothing/head/marine/peaked/captain
	name = "marine captain peaked cap"
	desc = "A peaked cap with the captain insignia emblazoned on it. Wearer may suffer the heavy weight of responsibility upon his head and shoulders."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	icon_state = "copeaked"
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/beret/marine/chiefofficer
	name = "chief officer beret"
	desc = "A beret with the lieutenant-commander insignia emblazoned on it. It emits a dark aura and may corrupt the soul."
	icon_state = "hosberet"

/obj/item/clothing/head/beret/marine/techofficer
	name = "technical officer beret"
	desc = "A beret with the lieutenant insignia emblazoned on it. There's something inexplicably efficient about it..."
	icon_state = "e_beret_badge"

/obj/item/clothing/head/beret/marine/logisticsofficer
	name = "logistics officer beret"
	desc = "A beret with the lieutenant insignia emblazoned on it. It inspires a feeling of respect."
	icon_state = "beret_badge"

//==========================//PROTECTIVE\\===============================\\
//=======================================================================\\
D
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = "ushankadown"
	item_state = "ushankadown"
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS
	anti_hug = 1

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	..()

	if(src.icon_state == "ushankadown")
		src.icon_state = "ushankaup"
		src.item_state = "ushankaup"
		to_chat(user, "You raise the ear flaps on the ushanka.")
	else
		src.icon_state = "ushankadown"
		src.item_state = "ushankadown"
		to_chat(user, "You lower the ear flaps on the ushanka.")


/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon_state = "bearpelt"
	siemens_coefficient = 2.0
	anti_hug = 4
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST|BODY_FLAG_ARMS
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST|BODY_FLAG_ARMS
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR

/obj/item/clothing/head/ivanberet
	name = "\improper Black Beret"
	desc = "Worn by officers of special units."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "ivan_beret"
	item_state = "ivan_beret"
	siemens_coefficient = 2.0
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMLOW
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUMLOW
	armor_rad = CLOTHING_ARMOR_NONE
	armor_internaldamage = CLOTHING_ARMOR_MEDIUMLOW
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = COVEREYES|COVERMOUTH|BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/freelancer
	name = "\improper armored Freelancer cap"
	desc = "A sturdy freelancer's cap. More protective than it seems."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "freelancer_cap"
	siemens_coefficient = 2.0
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMHIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/freelancer/beret
	name = "\improper armored Freelancer beret"
	icon_state = "freelancer_beret"

/obj/item/clothing/head/militia
	name = "\improper armored militia cowl"
	desc = "A large hood in service with some militias, meant for obscurity on the frontier. Offers some head protection due to the study fibers utilized in production."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)
	icon_state = "rebel_hood"
	siemens_coefficient = 2.0
	flags_armor_protection = BODY_FLAG_HEAD|BODY_FLAG_CHEST
	armor_melee = CLOTHING_ARMOR_MEDIUMHIGH
	armor_bullet = CLOTHING_ARMOR_MEDIUMLOW
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_LOW
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_MEDIUM
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS|HIDETOPHAIR

/obj/item/clothing/head/militia/bucket
	name = "bucket"
	desc = "This metal bucket appears to have been modified with padding and chin-straps, plus an eye-slit carved into the \"front\". Presumably, it is intended to be worn on the head, possibly for protection."
	icon_state = "bucket"

/obj/item/clothing/head/admiral
	name = "\improper armored Admiral cap"
	desc = "A sturdy admiral's cap. More protective than it seems. Please don't ditch this for a helmet like a punk."
	icon_state = "admiral_helmet"
	siemens_coefficient = 2.0
	flags_armor_protection = BODY_FLAG_HEAD
	armor_melee = CLOTHING_ARMOR_HIGH
	armor_bullet = CLOTHING_ARMOR_HIGH
	armor_laser = CLOTHING_ARMOR_LOW
	armor_energy = CLOTHING_ARMOR_LOW
	armor_bomb = CLOTHING_ARMOR_MEDIUM
	armor_bio = CLOTHING_ARMOR_MEDIUM
	armor_rad = CLOTHING_ARMOR_LOW
	armor_internaldamage = CLOTHING_ARMOR_HIGH
	flags_cold_protection = BODY_FLAG_HEAD
	min_cold_protection_temperature = ICE_PLANET_min_cold_protection_temperature
	flags_inventory = BLOCKSHARPOBJ
	flags_inv_hide = HIDEEARS

/obj/item/clothing/head/booniehat
	name = "\improper USCM boonie hat"
	desc = "A casual cap occasionally worn by crazy marines. While it has limited combat functionality, some prefer to wear it instead of the standard issue helmet."
	icon_state = "booniehat"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/booniehat/tan
	icon_state = "booniehattan"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'

/obj/item/clothing/head/booniehat/New()
	select_gamemode_skin(/obj/item/clothing/head/booniehat)
	..()

/obj/item/clothing/head/durag
	name = "durag"
	desc = "An improvised head wrap made out of a standard issue neckercheif. Great for keeping the sweat out of your eyes and protecting your hair."
	icon_state = "durag"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	flags_inv_hide = HIDETOPHAIR
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/durag/black
	icon_state = "duragblack"
	desc = "An improvised head wrap made out of a black neckercheif. Great for keeping the sweat out of your eyes and protecting your hair."
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	flags_atom = NO_SNOW_TYPE

/obj/item/clothing/head/durag/New()
	select_gamemode_skin(/obj/item/clothing/head/durag)
	..()

/obj/item/clothing/head/drillhat
	name = "\improper USCM drill hat"
	desc = "A formal hat worn by drill sergeants. Police that moustache."
	icon_state = "drillhat"
	icon = 'icons/obj/items/clothing/cm_hats.dmi'
	item_icons = list(
		WEAR_HEAD = 'icons/mob/humans/onmob/head_1.dmi'
	)

/obj/item/clothing/head/drillhat/New()
	select_gamemode_skin(/obj/item/clothing/head/drillhat)
	..()
