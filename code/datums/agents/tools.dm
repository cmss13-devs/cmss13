/obj/item/device/portable_vendor/antag
	name = "Suspicious Automated Storage Briefcase"
	desc = "A suitcase-sized automated storage and retrieval system. Designed to efficiently store and selectively dispense small items."

	w_class = SIZE_MEDIUM

	req_access = list()
	req_role = null
	listed_products = list(
		list("WEAPONS", 0, null, null, null),
		list("Configured Stunbaton", 25, /obj/item/weapon/baton/antag, "white", "A stun baton with more charge, tuned to work only for agents."),
		list("Tranquilizer Gun", 25, /obj/item/weapon/gun/pistol/tranquilizer, "white", "A tranquilizer gun. Comes with 5 darts. Deals no damage, knockout guaranteed."),
		list("Chloroform Cloth", 18, /obj/item/weapon/chloroform, "white", "A cloth dosed with chloroform. Has 8 effective uses and can only be used whilst behind a target. You must be in disarm intent to use."),

		list("ONE-USE TOOLS", 0, null, null, null),
		list("Experimental Stimulant Pills", 20, /obj/item/storage/pill_bottle/ultrazine/antag, "white", "Useful stimulants that allow you to resist stamina damage. Lasts for approximately 2 minutes. Take only 1 pill. Use with care."),
		list("Decoy", 14, /obj/item/explosive/grenade/decoy, "white", "A decoy grenade. Emits a loud explosion that can be heard from very far away, keep away from ears. Can be used 3 times."),

		list("UTILITY", 0, null, null, null),
		list("Security Access Tuner v2", 25, /obj/item/device/multitool/antag, "white", "An upgraded access tuner, able to rapidly hack various machinery. Disguised as a regular multitool"),
		list("OoI Tracker", 20, /obj/item/device/tracker, "white", "A tracker that tracks different objects of interest in a nearby range."),

		list("KITS", 0, null, null, null),
		list("Badass Kit", 12, /obj/item/storage/box/badass_kit, "white", "Contains MP private comms encryption key, for snooping into enemy communications and sunglasses that protect you from flashbangs"),
		list("Tools Kit", 15, /obj/item/storage/toolbox/antag, "white", "A toolbox containing general tools and an engineering pamphlet to help you break into places of interest."),
		list("Hacking Kit", 15, /obj/item/storage/box/antag_signaller, "white", "A box containing a screwdriver, a multi-tool and an engineering pamphlet, as well as 5 signallers to help you hack doors."),

		list("TRANSFER POINTS", 0, null, null, null),
		list("1 point", 1, /obj/item/stack/points/p1, "white", "A method of transferring points between agents."),
		list("5 points", 5, /obj/item/stack/points/p5, "white", "A method of transferring points between agents."),
		list("20 points", 20, /obj/item/stack/points/p20, "white", "A method of transferring points between agents."),
	)

	points = 40
	max_points = 100

	var/faction_belonging = "WY"

	var/list/types_to_convert = list(
		/obj/item/ammo_magazine/smg/m39 = /obj/item/ammo_magazine/smg/m39/rubber,
		/obj/item/ammo_magazine/rifle = /obj/item/ammo_magazine/rifle/rubber,
		/obj/item/ammo_magazine/rifle/l42a = /obj/item/ammo_magazine/rifle/l42a/rubber,
		/obj/item/ammo_magazine/pistol =  /obj/item/ammo_magazine/pistol/rubber
	)

/obj/item/device/portable_vendor/antag/allowed(mob/M)
	if(!ishuman(M))
		return FALSE

	return TRUE

/obj/item/device/portable_vendor/antag/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!allowed(user) || user.action_busy)
		return .

	var/mob/living/carbon/human/H = user
	var/obj/item/ammo_magazine/target_mag = target

	if(!istype(target_mag))
		return .

	if(target.type in types_to_convert)
		var/type_to_set = types_to_convert[target.type]

		if(target_mag.current_rounds < target_mag.max_rounds)
			to_chat(H, SPAN_WARNING("[target_mag] needs to be full to convert these into rubber rounds!"))
			return .

		to_chat(H, SPAN_NOTICE("You start converting [target_mag] into a rubber magazine."))
		playsound(user.loc, "sound/machines/fax.ogg", 5)

		if(!do_after(H, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target_mag, INTERRUPT_ALL))
			return .

		to_chat(H, SPAN_NOTICE("You convert [target] into a rubber magazine."))
		var/obj/item/ammo_magazine/mag = new type_to_set(get_turf(user.loc))
		qdel(target)

		H.put_in_any_hand_if_possible(mag)


/obj/item/device/portable_vendor/antag/process()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/portable_vendor/antag/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/points))
		var/obj/item/stack/points/P = W

		if(points >= max_points)
			return . = ..()

		var/amount_to_add = min(P.amount, max_points - points)

		to_chat(user, SPAN_NOTICE("You insert [P] into [src]."))

		if(P.use(amount_to_add))
			points += amount_to_add
	else
		. = ..()

/obj/item/stack/points
	name = "credits"
	singular_name = "credit"
	icon_state = "point"
	icon = 'icons/obj/items/economy.dmi'
	gender = PLURAL

	stack_id = "antag points"

	amount = 0
	max_amount = 40

/obj/item/stack/points/Initialize(mapload, ...)
	. = ..()
	update_name()

/obj/item/stack/points/add(extra)
	. = ..()
	update_name()

/obj/item/stack/points/use(used)
	. = ..()
	update_name()

/obj/item/stack/points/proc/update_name()
	if(amount == 1)
		name = "[amount] [initial(singular_name)]"
	else
		name = "[amount] [initial(name)]"

/obj/item/stack/points/p1
	amount = 1

/obj/item/stack/points/p5
	amount = 5

/obj/item/stack/points/p20
	amount = 20

/obj/item/device/portable_vendor/antag/cia
	name = "Automated Storage Briefcase"
	desc = "A briefcase able to dispense items at the user's discretion. This one appears to be tightly locked, and impenetrable."
	points = 200
	max_points = 300
	delay = 0.5
	force = MELEE_FORCE_STRONG
	req_access = list()

	listed_products = list(
		list("STATIONERY", 0, null, null, null),
		list("pen", 1, /obj/item/tool/pen/clicky, "white", "A pen, for writing on the go."),
		list("Paper", 1, /obj/item/paper, "white", "A fresh piece of paper, for writing on."),
		list("Carbon Paper", 1, /obj/item/paper/carbon, "white", "A piece of carbon paper, to double the writing output."),
		list("Clipboard", 1, /obj/item/clipboard, "white", "A clipboard, for storing all that writing."),

		list("WEAPONS", 0, null, null, null),
		list("Configured Stunbaton", 25, /obj/item/weapon/baton/antag, "white", "A stun baton with more charge."),
		list("Tranquilizer Gun", 25, /obj/item/weapon/gun/pistol/tranquilizer, "white", "A tranquilizer gun. Comes with 5 darts. Deals no damage, knockout guaranteed."),
		list("Chloroform Cloth", 18, /obj/item/weapon/chloroform, "white", "A cloth dosed with chloroform. Has 8 effective uses and can only be used whilst behind a target. You must be in disarm intent to use."),
		list("Sedative Pen", 15, /obj/item/tool/pen/sleepypen, "white", "A sedative syringe disguised as a pen. Can be used to stealthily knock out targets."),
		list("Handcuffs", 2, /obj/item/restraint/handcuffs, "white", "A set of handcuffs."),

		list("AMMUNITION", 0, null, null, null),
		list("M1911 Magazine", 5, /obj/item/ammo_magazine/pistol/m1911, "white", "A magazine for an M1911 pistol."),
		list("Tranquilizer Magazine", 5, /obj/item/ammo_magazine/pistol/tranq, "white", "A magazine for an tranquilizer pistol."),

		list("UTILITY", 0, null, null, null),
		list("Security Access Tuner v2", 25, /obj/item/device/multitool/antag, "white", "An upgraded access tuner, able to rapidly hack various machinery. Disguised as a regular multitool."),
		list("Listening Device", 20, /obj/item/device/radio/listening_bug/radio_linked/cia, "white", "A listening device. Can be disguised as anything by right-clicking on it."),
		list("USCM Codebook", 20, /obj/item/book/codebook, "white", "A copy of a USCM codebook used to verify credentials with the commanding officer."),
		list("Tools Kit", 15, /obj/item/storage/toolbox/mechanical, "white", "A toolbox containing general tools."),
		list("CIA Challenge Coin", 15, /obj/item/coin/silver/cia, "white", "A challenge coin emblazoned with an eagle. Use to identify other CIA operatives on the field at a glance."),

		list("MARINE CLOTHING", 0, null, null, null),
		list("Marine Helmet", 5, /obj/item/clothing/head/helmet/marine, "white", "A USCM standard military helmet."),
		list("Marine Fatigues", 8, /obj/item/clothing/under/marine, "white", "A USCM standard military battle dress uniform."),
		list("M3 Pattern Marine Armor", 20, /obj/item/clothing/suit/storage/marine, "white", "A USCM standard armor rig for combat situations."),
		list("M3 Pattern Marine Armor", 15, /obj/item/clothing/suit/storage/marine/light, "white", "A USCM light armor rig for combat situations."),
		list("M3-VL Ballistics Vest", 12, /obj/item/clothing/suit/storage/marine/light/vest, "white", "A USCM light ballistic vest for combat situations."),

		list("RADIO KEYS", 0, null, null, null),
		list("Radio Key: CIA", 10, /obj/item/device/encryptionkey/cia, "white", "Radio Key for CIA communications."),
		list("Radio Key: Colonial Marshals", 20, /obj/item/device/encryptionkey/cmb, "white", "Radio Key for the CMB."),
		list("Radio Key: Colonial Liberation Front", 20, /obj/item/device/encryptionkey/clf, "white", "Radio Key for known local CLF frequencies."),
		list("Radio Key: Union of Progressive Peoples", 20, /obj/item/device/encryptionkey/upp, "white", "Radio Key for known UPP listening frequencies."),

		list("TRANSFER POINTS", 0, null, null, null),
		list("1 point", 1, /obj/item/stack/points/p1, "white", "A method of transferring points between agents."),
		list("5 points", 5, /obj/item/stack/points/p5, "white", "A method of transferring points between agents."),
		list("20 points", 20, /obj/item/stack/points/p20, "white", "A method of transferring points between agents."),
	)

/obj/item/device/portable_vendor/antag/cia/covert
	name = "briefcase"
	icon_state = "briefcase"
	desc = "It's made of AUTHENTIC faux-leather and has a price-tag still attached. Its owner must be a real professional."
	covert = TRUE
