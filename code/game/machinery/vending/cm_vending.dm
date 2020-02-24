/////////////////////////////////////////////////////////////


#define MARINE_CAN_BUY_UNIFORM 		1
#define MARINE_CAN_BUY_SHOES	 	2
#define MARINE_CAN_BUY_HELMET 		4
#define MARINE_CAN_BUY_ARMOR	 	8
#define MARINE_CAN_BUY_GLOVES 		16
#define MARINE_CAN_BUY_EAR	 		32
#define MARINE_CAN_BUY_BACKPACK 	64
#define MARINE_CAN_BUY_R_POUCH 		128
#define MARINE_CAN_BUY_L_POUCH 		256
#define MARINE_CAN_BUY_BELT 		512
#define MARINE_CAN_BUY_GLASSES		1024
#define MARINE_CAN_BUY_MASK			2048
#define MARINE_CAN_BUY_ESSENTIALS	4096
#define MARINE_CAN_BUY_ATTACHMENT	8192
#define MARINE_CAN_BUY_MRE			16384
#define MARINE_CAN_BUY_ACCESSORY	32768

#define MARINE_CAN_BUY_ALL			65535

#define MARINE_TOTAL_BUY_POINTS			45

//TODO: initialise it on a per-role basis and make it random.
//Few marines should have enough points to buy a single item
//unless we make the snowflake gear lore-friendly, in which case - one lore friendly item per marine, with a chance to have enough for a non-lore friendly
//Higher up roles should get a few more points
//Whitelisted roles should get full 60 since we can punish them for LRP
//And probably donors should get full points as well to replace their system one day maybe?
#define MARINE_TOTAL_SNOWFLAKE_POINTS	120

/obj/item/card/id/var/marine_points = MARINE_TOTAL_BUY_POINTS
/obj/item/card/id/var/marine_snowflake_points = MARINE_TOTAL_SNOWFLAKE_POINTS
/obj/item/card/id/var/marine_buy_flags = MARINE_CAN_BUY_ALL



/obj/structure/machinery/cm_vending
	name = "\improper Theoretical Marine selector"
	desc = ""
	icon = 'icons/obj/structures/machinery/vending.dmi'
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	req_access = null
	req_one_access = null
	unacidable = TRUE
	unslashable = TRUE

	var/gloves_type
	var/headset_type
	var/gives_webbing = FALSE
	var/auto_equip = FALSE
	var/vendor_role = "" //to be compared with assigned_role to only allow those to use that machine.
	var/squad_tag = ""	//same to restrict vendor to specified squad
	var/use_points = FALSE
	var/use_snowflake_points = FALSE

	var/list/listed_products = list()



/obj/structure/machinery/cm_vending/attack_hand(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	var/obj/item/card/id/I = H.wear_id
	if(!istype(I)) //not wearing an ID
		to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
		return

	if(I.registered_name != H.real_name)
		to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
		return

	if(vendor_role && I.rank != vendor_role)
		to_chat(H, SPAN_WARNING("This machine isn't for you."))
		return


	user.set_interaction(src)
	ui_interact(user)



/obj/structure/machinery/cm_vending/attackby(obj/item/W, mob/user)
	// Repairing process
	if(isscrewdriver(W))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		else if(stat & BROKEN)
			to_chat(user, SPAN_NOTICE("You start to unscrew \the [src]'s broken panel."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop unscrewing \the [src]'s broken panel."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You unscrew \the [src]'s broken panel and remove it, exposing many broken wires."))
			stat &= ~BROKEN
			stat |= REPAIR_STEP_ONE
			return TRUE
		else if(stat & REPAIR_STEP_FOUR)
			to_chat(user, SPAN_NOTICE("You start to fasten \the [src]'s new panel."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop fastening \the [src]'s new panel."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You fasten \the [src]'s new panel, fully repairing the vendor."))
			stat &= ~REPAIR_STEP_FOUR
			stat |= FULLY_REPAIRED
			update_icon()
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return FALSE
	else if(iswirecutter(W))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		else if(stat & REPAIR_STEP_ONE)
			to_chat(user, SPAN_NOTICE("You start to remove \the [src]'s broken wires."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop removing \the [src]'s broken wires."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You remove \the [src]'s broken broken wires."))
			stat &= ~REPAIR_STEP_ONE
			stat |= REPAIR_STEP_TWO
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return FALSE
	else if(iswire(W))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		var/obj/item/stack/cable_coil/CC = W
		if(stat & REPAIR_STEP_TWO)
			if(CC.amount < 5)
				to_chat(user, SPAN_WARNING("You need more cable coil to replace the removed wires."))
			to_chat(user, SPAN_NOTICE("You start to replace \the [src]'s removed wires."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop replacing \the [src]'s removed wires."))
				return FALSE
			if(!CC || !CC.use(5))
				to_chat(user, SPAN_WARNING("You need more cable coil to replace the removed wires."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You remove \the [src]'s broken broken wires."))
			stat &= ~REPAIR_STEP_TWO
			stat |= REPAIR_STEP_THREE
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return
	else if(istype(W, /obj/item/stack/sheet/metal))
		if(!skillcheck(user, SKILL_ENGINEER, SKILL_ENGINEER_ENGI))
			to_chat(user, SPAN_WARNING("You do not understand how to repair the broken [src]."))
			return FALSE
		var/obj/item/stack/sheet/metal/M = W
		if(stat & REPAIR_STEP_THREE)
			to_chat(user, SPAN_NOTICE("You start to construct a new panel for \the [src]."))
			if(!do_after(user, 3 SECONDS, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, numticks = 3))
				to_chat(user, SPAN_WARNING("You stop constructing a new panel for \the [src]."))
				return FALSE
			if(!M || !M.use(1))
				to_chat(user, SPAN_WARNING("You a sheet of metal to construct a new panel."))
				return FALSE
			to_chat(user, SPAN_NOTICE("You construct a new panel for \the [src]."))
			stat &= ~REPAIR_STEP_THREE
			stat |= REPAIR_STEP_FOUR
			return TRUE
		else
			var/msg = get_repair_move_text()
			to_chat(user, SPAN_WARNING("[msg]"))
			return

	..()



/obj/structure/machinery/cm_vending/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user)) return
	var/mob/living/carbon/human/H = user

	var/list/display_list = list()

	var/m_points = 0
	var/buy_flags = NO_FLAGS
	var/obj/item/card/id/I = H.wear_id
	if(istype(I)) //wearing an ID
		if(use_snowflake_points)
			m_points = I.marine_snowflake_points
		else
			m_points = I.marine_points
		buy_flags = I.marine_buy_flags

	if(listed_products.len)
		for(var/i in 1 to listed_products.len)
			var/list/myprod = listed_products[i]
			var/p_name = myprod[1]
			var/p_cost = myprod[2]
			if(p_cost > 0)
				p_name += " ([p_cost] points)"

			var/prod_available = FALSE
			var/avail_flag = myprod[4]
			if(m_points >= p_cost && (!avail_flag || buy_flags & avail_flag))
				prod_available = TRUE

			//place in main list, name, cost, available or not, color.
			display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_available" = prod_available, "prod_color" = myprod[5]))

	var/list/data = list(
		"vendor_name" = name,
		"show_points" = use_points,
		"current_m_points" = m_points,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "cm_vending.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/structure/machinery/cm_vending/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.is_mob_incapacitated())
		return

	if (in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if (href_list["vend"])

			if(!allowed(usr))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return

			var/idx=text2num(href_list["vend"])

			var/list/L = listed_products[idx]
			var/mob/living/carbon/human/H = usr
			var/cost = L[2]

			var/obj/item/card/id/I = H.wear_id
			if(!istype(I)) //not wearing an ID
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				return

			if(I.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				return

			if(vendor_role && I.rank != vendor_role)
				to_chat(H, SPAN_WARNING("This machine isn't for you."))
				return

			if(use_points)
				if((!use_snowflake_points && I.marine_points < cost) || (use_snowflake_points && I.marine_snowflake_points < cost))
					to_chat(H, SPAN_WARNING("Not enough points."))
					return


			if((!H.assigned_squad && squad_tag) || (squad_tag && H.assigned_squad.name != squad_tag))
				to_chat(H, SPAN_WARNING("This machine isn't for you."))
				return


			var/turf/T = loc
			if(T.contents.len > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				return

			var/bitf = L[4]
			if(bitf)
				if(bitf == MARINE_CAN_BUY_ESSENTIALS && vendor_role == JOB_SQUAD_SPECIALIST)
					if(H.job != JOB_SQUAD_SPECIALIST)
						to_chat(H, SPAN_WARNING("Only specialists can take specialist sets."))
						return
					else if(!H.skills || H.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_TRAINED)
						to_chat(H, SPAN_WARNING("You already have a specialist specialization."))
						return
					var/p_name = L[1]
					if(!available_specialist_sets.Find(p_name))
						to_chat(H, SPAN_WARNING("That set is already taken."))
						return

				if(vendor_role == JOB_CREWMAN)
					var/p_name = L[1]
					var/obj/structure/machinery/cm_vending/tank/t = src
					if(!t.integral_list.Find(p_name) && !t.primary_list.Find(p_name) && !t.secondary_list.Find(p_name) && !t.support_list.Find(p_name) && !t.armor_list.Find(p_name) &&!t.treads_list.Find(p_name))
						to_chat(H, SPAN_WARNING("That equipment is already taken."))
						return

				if(I.marine_buy_flags & bitf)
					if(bitf == (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH))
						if(I.marine_buy_flags & MARINE_CAN_BUY_R_POUCH)
							I.marine_buy_flags &= ~MARINE_CAN_BUY_R_POUCH
						else
							I.marine_buy_flags &= ~MARINE_CAN_BUY_L_POUCH
					else
						I.marine_buy_flags &= ~bitf
				else
					to_chat(H, SPAN_WARNING("You can't buy things from this category anymore."))
					return



			var/type_p = L[3]

			if(type_p == /obj/item/device/radio/headset/almayer/marine)
				type_p = headset_type

			else if(type_p == /obj/item/clothing/gloves/marine)
				type_p = gloves_type

			var/obj/item/IT = new type_p(loc)
			IT.add_fingerprint(usr)

			if(bitf == MARINE_CAN_BUY_UNIFORM)
				var/obj/item/clothing/under/U = IT
				//Gives ranks to the ranked
				if(H.wear_id && H.wear_id.paygrade)
					var/rankpath = get_rank_pins(H.wear_id.paygrade)
					if(rankpath)
						var/obj/item/clothing/accessory/ranks/R = new rankpath()
						U.attach_accessory(H, R)
				if(gives_webbing)
					var/obj/item/clothing/accessory/storage/webbing/W = new()
					U.attach_accessory(usr, W)
				//if(istype(ticker.mode, /datum/game_mode/ice_colony))//drop a coif with the uniform on ice colony
				if(map_tag in MAPS_COLD_TEMP)
					new /obj/item/clothing/mask/rebreather/scarf(loc)


			if(bitf == MARINE_CAN_BUY_ESSENTIALS)
				if(vendor_role == JOB_SQUAD_SPECIALIST && H.job == JOB_SQUAD_SPECIALIST)
					var/p_name = L[1]
					switch(p_name)
						if("Scout Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SCOUT)
						if("Sniper Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_SNIPER)
						if("Demolitionist Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_ROCKET)
						if("Heavy Grenadier Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_GRENADIER)
						if("Pyro Set")
							H.skills.set_skill(SKILL_SPEC_WEAPONS, SKILL_SPEC_PYRO)
						else
							to_chat(H, SPAN_WARNING("<b>Something bad occured with [src], tell a Dev.</b>"))
							return
					available_specialist_sets -= p_name
			if(vendor_role == JOB_CREWMAN)
				if(H.job == JOB_CREWMAN)
					if(istype(src, /obj/structure/machinery/cm_vending/tank))
						var/obj/structure/machinery/cm_vending/tank/t = src
						var/t_name = L[1]
						if(!t.primary_list.Find(t_name) && !t.secondary_list.Find(t_name) && !t.support_list.Find(t_name) && !t.armor_list.Find(t_name) &&!t.treads_list.Find(t_name))
							to_chat(H, SPAN_WARNING("That equipment is already taken."))
							return
						if(t.primary_list.Find(t_name))
							t.primary_list.Cut()
						if(t.secondary_list.Find(t_name))
							t.secondary_list.Cut()
						if(t.support_list.Find(t_name))
							t.support_list.Cut()
						if(t.armor_list.Find(t_name))
							t.armor_list.Cut()
						if(t.treads_list.Find(t_name))
							t.treads_list.Cut()
			if(use_points)
				if(use_snowflake_points)
					I.marine_snowflake_points -= cost
				else
					I.marine_points -= cost

			if(auto_equip && istype(IT, /obj/item))
				if(IT.flags_equip_slot != NO_FLAGS)
					if(IT.flags_equip_slot == SLOT_ACCESSORY)
						if(H.w_uniform)
							var/obj/item/clothing/C = H.w_uniform
							if(C.can_attach_accessory(IT))
								C.attach_accessory(H, IT)
					else
						H.equip_to_appropriate_slot(IT)

		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window

/obj/structure/machinery/cm_vending/ex_act(severity)
	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if (prob(25))
				stat |= BROKEN
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if (prob(50))
				stat |= BROKEN
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)
			return
	return

/obj/structure/machinery/cm_vending/get_repair_move_text(var/include_name = TRUE)
	if(!stat)
		return

	var/possessive = include_name ? "[src]'s" : "Its"
	var/nominative = include_name ? "[src]" : "It"

	if(stat & BROKEN)
		return "[possessive] broken panel still needs to be <b>unscrewed</b> and removed."
	else if(stat & REPAIR_STEP_ONE)
		return "[possessive] broken wires still need to be <b>cut</b> and removed from the vendor."
	else if(stat & REPAIR_STEP_TWO)
		return "[nominative] needs to have <b>new wiring</b> installed."
	else if(stat & REPAIR_STEP_THREE)
		return "[nominative] needs to have a <b>metal</b> panel installed."
	else if(stat & REPAIR_STEP_FOUR)
		return "[possessive] new panel needs to be <b>fastened</b> to it."
	else
		return "[nominative] is being affected by some power-related issue."

/obj/structure/machinery/cm_vending/clothing
	name = "ColMarTech Automated Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue uniform and armor."
	icon_state = "uniform_marine"
	use_points = TRUE
	auto_equip = TRUE

	vendor_role = JOB_SQUAD_MARINE

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine, MARINE_CAN_BUY_HELMET, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),


		list("ARMOR (choose 1)", 0, null, null, null),
		list("Light armor", 0, /obj/item/clothing/suit/storage/marine/class/light, MARINE_CAN_BUY_ARMOR, "white"),
		list("Medium armor", 0, /obj/item/clothing/suit/storage/marine, MARINE_CAN_BUY_ARMOR, "white"),
		list("Heavy armor", 0, /obj/item/clothing/suit/storage/marine/class/heavy, MARINE_CAN_BUY_ARMOR, "white"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, "orange"),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Shotgun scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Standard ammo belt", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, "orange"),
		list("Shotgun ammo belt", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, "black"),
		list("M39 holster belt", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, "black"),
		list("Knives belt", 0, /obj/item/storage/belt/knifepouch, MARINE_CAN_BUY_BELT, "black"),
		list("Pistol belt", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, "black"),
		list("Revolver belt", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, "black"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Bayonet sheath", 0, /obj/item/storage/pouch/bayonet, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Document pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Medium general pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("MASKS", 0, null, null, null),
		list("Gas mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, "black"),

		list("KITS", 0, null, null, null),
		list("Combat Technician Support Kit", 30, /obj/item/storage/box/kit/mini_engineer, null, "black"),
		list("First Responder Medical Support Kit", 45, /obj/item/storage/box/kit/mini_medic, null, "black"),
		list("Frontline M40 Grenadier Kit", 45, /obj/item/storage/box/kit/mini_grenadier, null, "black"),
		list("L42A Sniper Kit", 30, /obj/item/storage/box/kit/mini_sniper, null, "black"),
		list("M240 Pyrotechnician Support Kit", 45, /obj/item/storage/box/kit/mini_pyro, null, "black"),
		list("Personal Self Defense Kit", 45, /obj/item/storage/box/kit/self_defense, null, "black"),
		list("Veteran Enlisted Kit", 30, /obj/item/storage/box/kit/veteran_enlist, null, "black"),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled grip", 15, /obj/item/attachable/angledgrip, null, "black"),
		list("Extended barrel", 15, /obj/item/attachable/extended_barrel, null, "black"),
		list("Gyroscopic stabilizer", 15, /obj/item/attachable/gyro, null, "black"),
		list("Laser sight", 15, /obj/item/attachable/lasersight, null, "black"),
		list("Masterkey shotgun", 15, /obj/item/attachable/attached_gun/shotgun, null, "black"),
		list("M37 wooden stock", 15, /obj/item/attachable/stock/shotgun, null, "black"),
		list("M41A skeleton stock", 15, /obj/item/attachable/stock/rifle, null, "black"),
		list("Quickfire adapter", 15, /obj/item/attachable/quickfire, null, "black"),
		list("Recoil compensator", 15, /obj/item/attachable/compensator, null, "black"),
		list("Red-dot sight", 15, /obj/item/attachable/reddot, null, "black"),
		list("Reflex sight", 15, /obj/item/attachable/reflex, null, "black"),
		list("Submachinegun stock", 15, /obj/item/attachable/stock/smg, null, "black"),
		list("Suppressor", 15, /obj/item/attachable/suppressor, null, "black"),
		list("Vertical grip", 15, /obj/item/attachable/verticalgrip, null, "black"),

		list("AMMUNITION", 0, null, null, null),
		list("M39 AP magazine (10x20mm)", 15, /obj/item/ammo_magazine/smg/m39/ap , null, "black"),
		list("M39 extended magazine (10x20mm)", 15, /obj/item/ammo_magazine/smg/m39/extended , null, "black"),
		list("M40 HEDP grenade", 10, /obj/item/explosive/grenade/HE, null, "black"),
		list("M40 HEFA grenade", 10, /obj/item/explosive/grenade/HE/frag , null, "black"),
		list("M41A AP magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/ap , null, "black"),
		list("M41A extended magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/extended , null, "black"),
		list("L42A AP magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/l42a/ap, null, "black"),
		list("M44 Heavy Speed Loader (.44)", 15, /obj/item/ammo_magazine/revolver/heavy, null, "black"),

		list("EXTRAS", 0, null, null, null),
		list("Webbing", 15, /obj/item/clothing/accessory/storage/webbing, null, "black"),
		list("Shoulder holster", 15, /obj/item/clothing/accessory/holster, null, "black"),
		list("Machete scabbard", 15, /obj/item/storage/large_holster/machete/full, null, "black"),
		list("Fire extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, null, "black"),
		list("Large general pouch", 15, /obj/item/storage/pouch/general/large, null, "black"),
		list("Fuel tank strap pouch", 15, /obj/item/storage/pouch/flamertank, null, "black"),
		list("Motion detector", 15, /obj/item/device/motiondetector, null, "black")

	)

/obj/structure/machinery/cm_vending/clothing/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

/obj/structure/machinery/cm_vending/clothing/engi
	req_access = list(ACCESS_MARINE_ENGPREP)
	vendor_role = JOB_SQUAD_ENGI

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine/engineer, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/tech, MARINE_CAN_BUY_HELMET, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("Welding glasses", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),


		list("ARMOR (choose 1)", 0, null, null, null),
		list("Light armor", 0, /obj/item/clothing/suit/storage/marine/class/light, MARINE_CAN_BUY_ARMOR, "white"),
		list("Medium armor", 0, /obj/item/clothing/suit/storage/marine, MARINE_CAN_BUY_ARMOR, "white"),
		list("Heavy armor", 0, /obj/item/clothing/suit/storage/marine/class/heavy, MARINE_CAN_BUY_ARMOR, "white"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, "orange"),
		list("Backpack", 0, /obj/item/storage/backpack/marine/tech, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Machete scabbard", 0, /obj/item/storage/large_holster/machete/full, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Shotgun scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Tool belt", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, "orange"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Construction pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Electronics pouch", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Explosive pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Magazine pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Medium general pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Tools pouch", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("MASKS", 0, null, null, null),
		list("Gas mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, "black"),
	)


/obj/structure/machinery/cm_vending/clothing/engi/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/engi

/obj/structure/machinery/cm_vending/clothing/engi/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/engi

/obj/structure/machinery/cm_vending/clothing/engi/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/engi

/obj/structure/machinery/cm_vending/clothing/engi/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/engi



/obj/structure/machinery/cm_vending/clothing/medic
	req_access = list(ACCESS_MARINE_MEDPREP)
	vendor_role = JOB_SQUAD_MEDIC

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine/medic, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/medic, MARINE_CAN_BUY_HELMET, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),

		list("ARMOR (choose 1)", 0, null, null, null),
		list("Light armor", 0, /obj/item/clothing/suit/storage/marine/class/light, MARINE_CAN_BUY_ARMOR, "white"),
		list("Medium armor", 0, /obj/item/clothing/suit/storage/marine, MARINE_CAN_BUY_ARMOR, "white"),
		list("Heavy armor", 0, /obj/item/clothing/suit/storage/marine/class/heavy, MARINE_CAN_BUY_ARMOR, "white"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/medic, MARINE_CAN_BUY_BACKPACK, "orange"),
		list("Backpack", 0, /obj/item/storage/backpack/marine/medic, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Lifesaver belt", 0, /obj/item/storage/belt/medical/combatLifesaver, MARINE_CAN_BUY_BELT, "orange"),
		list("Medical belt", 0, /obj/item/storage/belt/medical, MARINE_CAN_BUY_BELT, "black"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Medical pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Medkit pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Autoinjector pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Magazine pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large general pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("MASKS", 0, null, null, null),
		list("Gas mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, "black"),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, "black"),
	)



/obj/structure/machinery/cm_vending/clothing/medic/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/med

/obj/structure/machinery/cm_vending/clothing/medic/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/med

/obj/structure/machinery/cm_vending/clothing/medic/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/med

/obj/structure/machinery/cm_vending/clothing/medic/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/med

/obj/structure/machinery/cm_vending/clothing/smartgun
	req_access = list(ACCESS_MARINE_SMARTPREP)
	vendor_role = JOB_SQUAD_SMARTGUN

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine, MARINE_CAN_BUY_HELMET, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),

		list("BELT", 0, null, null, null),
		list("Smartgunner ammo belt", 0, /obj/item/storage/belt/gun/smartgunner/full, MARINE_CAN_BUY_BELT, "white"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "orange"),
		list("Large pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Magazine pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Medium general pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("MASKS", 0, null, null, null),
		list("Gas mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, "black"),
)

/obj/structure/machinery/cm_vending/clothing/smartgun/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/smartgun/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/smartgun/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/smartgun/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta



/obj/structure/machinery/cm_vending/clothing/specialist
	req_access = list(ACCESS_MARINE_SPECPREP)
	vendor_role = JOB_SQUAD_SPECIALIST

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Shotgun scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Knives belt", 0, /obj/item/storage/belt/knifepouch, MARINE_CAN_BUY_BELT, "black"),
		list("M39 holster belt", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, "black"),
		list("Pistol belt", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, "black"),
		list("Revolver belt", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, "black"),
		list("G8-A general utility pouch", 0, /obj/item/storage/sparepouch, MARINE_CAN_BUY_BELT, "black"),
		list("Shotgun ammo belt", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, "black"),
		list("Standard ammo belt", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, "black"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large magazine pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Medium general pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("MASKS", 0, null, null, null),
		list("Gas mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, "black"),
	)

/obj/structure/machinery/cm_vending/clothing/specialist/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/specialist/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/specialist/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/specialist/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

/obj/structure/machinery/cm_vending/clothing/leader
	req_access = list(ACCESS_MARINE_LEADER)
	vendor_role = JOB_SQUAD_LEADER

	listed_products = list(
		list("STANDARD EQUIPMENT (take all)", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, "white"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "white"),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/leader, MARINE_CAN_BUY_HELMET, "white"),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/leader, MARINE_CAN_BUY_ARMOR, "white"),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, "white"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, "white"),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, "white"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Machete scabbard", 0, /obj/item/storage/large_holster/machete/full, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Shotgun scabbard", 0, /obj/item/storage/large_holster/m37, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Knives belt", 0, /obj/item/storage/belt/knifepouch, MARINE_CAN_BUY_BELT, "black"),
		list("M39 holster belt", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, "black"),
		list("Pistol belt", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, "black"),
		list("Revolver belt", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, "black"),
		list("Shotgun ammo belt", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, "black"),
		list("Standard ammo belt", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, "black"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Autoinjector pouch", 0, /obj/item/storage/pouch/autoinjector/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "white"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large general pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large magazine pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large pistol magazine pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Pistol pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("MASKS", 0, null, null, null),
		list("Gas mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, "black"),
	)

/obj/structure/machinery/cm_vending/clothing/leader/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/lead

/obj/structure/machinery/cm_vending/clothing/leader/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/lead

/obj/structure/machinery/cm_vending/clothing/leader/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/lead

/obj/structure/machinery/cm_vending/clothing/leader/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/lead


/obj/structure/machinery/cm_vending/clothing/synth
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = JOB_SYNTH

	listed_products = list(
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, "orange"),

		list("UNIFORM (choose 1)", 0, null, null, null),
		list("Medical scrubs, green", 0, /obj/item/clothing/under/rank/medical/green, MARINE_CAN_BUY_UNIFORM, "black"),
		list("Uniform, outdated Synth", 0, /obj/item/clothing/under/rank/synthetic/old, MARINE_CAN_BUY_UNIFORM, "black"),
		list("Uniform, standard Synth", 0, /obj/item/clothing/under/rank/synthetic, MARINE_CAN_BUY_UNIFORM, "orange"),
		list("USCM standard uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, "black"),
		list("Working Joe uniform", 0, /obj/item/clothing/under/rank/synthetic/joe, MARINE_CAN_BUY_UNIFORM, "black"),

		list("WEBBING (choose 1)", 0, null, null, null),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("SHOES (choose 1)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine, MARINE_CAN_BUY_SHOES, "black"),
		list("Shoes, white", 0, /obj/item/clothing/shoes/white, MARINE_CAN_BUY_SHOES, "orange"),

		list("HELMET (choose 1)", 0, null, null, null),
		list("Expedition cap", 0, /obj/item/clothing/head/cmflapcap, MARINE_CAN_BUY_HELMET, "black"),
		list("Hard hat, orange", 0, /obj/item/clothing/head/hardhat/orange, MARINE_CAN_BUY_HELMET, "black"),
		list("Surgical cap, green", 0, /obj/item/clothing/head/surgery/green, MARINE_CAN_BUY_HELMET, "black"),
		list("Welding helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, "black"),

		list("SUIT (choose 1)", 0, null, null, null),
		list("Hazard vest", 0, /obj/item/clothing/suit/storage/hazardvest, MARINE_CAN_BUY_ARMOR, "orange"),
		list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_ARMOR, "black"),
		list("Labcoat, researcher", 0, /obj/item/clothing/suit/storage/labcoat/researcher, MARINE_CAN_BUY_ARMOR, "black"),

		list("GLOVES (choose 1)", 0, null, null, null),
		list("Insulated gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, "orange"),
		list("Latex gloves", 0, /obj/item/clothing/gloves/latex, MARINE_CAN_BUY_GLOVES, "black"),

		list("BACKPACK (choose 1)", 0, null, null, null),
		list("Smartpack, blue", 0, /obj/item/storage/backpack/marine/smartpack, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Smartpack, green", 0, /obj/item/storage/backpack/marine/smartpack/green, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Smartpack, tan", 0, /obj/item/storage/backpack/marine/smartpack/tan, MARINE_CAN_BUY_BACKPACK, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("Tool belt", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, "orange"),
		list("Lifesaver belt", 0, /obj/item/storage/belt/medical/combatLifesaver, MARINE_CAN_BUY_BELT, "black"),
		list("Medical belt", 0, /obj/item/storage/belt/medical, MARINE_CAN_BUY_BELT, "black"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Autoinjector pouch", 0, /obj/item/storage/pouch/autoinjector, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Construction pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Document pouch", 0, /obj/item/storage/pouch/document/small, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Electronics pouch", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Firstaid pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Flare pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Large general pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Medical pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Medkit pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Tools pouch", 0, /obj/item/storage/pouch/tools, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),

		list("MASKS", 0, null, null, null),
		list("Sterile mask", 0, /obj/item/clothing/mask/surgical, MARINE_CAN_BUY_MASK, "black"),
	)

/obj/structure/machinery/cm_vending/clothing/intelligence_officer
	name = "Intelligence Officer Equipment Rack"
	req_access = list(ACCESS_MARINE_BRIDGE)
	vendor_role = JOB_INTEL

	listed_products = list(
		list("INTELLIGENCE SET (Mandatory)", 0, null, null, null),
		list("Essential Intelligence Set", 0, /obj/effect/essentials_set/intelligence_officer, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Uniform", 0, /obj/item/clothing/under/marine/officer/intel, MARINE_CAN_BUY_UNIFORM, "black"),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, "black"),
		list("Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, "black"),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/intel, MARINE_CAN_BUY_ARMOR, "black"),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom, MARINE_CAN_BUY_EAR, "black"),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel/intel, MARINE_CAN_BUY_BACKPACK, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ATTACHMENT, "black"),

		list("BELT (choose 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/sparepouch, MARINE_CAN_BUY_BELT, "white"),
		list("M276 pattern toolbelt rig", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, "white"),
		list("M4A3 holster rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, "black"),

		list("POUCHES (choose 2)", 0, null, null, null),
		list("Document pouch", 0, /obj/item/storage/pouch/document, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("First-Aid Pouch", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "white"),
		list("Flare Pouch", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "white"),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "black"),
		list("Tools Pouch", 0, /obj/item/storage/pouch/tools, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), "white"),

		list("ACCESSORIES", 0, null, null, null),
		list("Shoulder holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Brown webbing vest", 0, /obj/item/clothing/accessory/storage/brown_vest, MARINE_CAN_BUY_ACCESSORY, "black"),
		list("Black webbing vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, "black"),

		list("HELMET (choose 1)", 0, null, null, null),
		list("XM12 pattern intelligence helmet", 0, /obj/item/clothing/head/helmet/marine/intel, MARINE_CAN_BUY_HELMET, "black"),
		list("Beret, standard", 0, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_HELMET, "black"),
		list("Beret, tan", 0, /obj/item/clothing/head/beret/cm/tan, MARINE_CAN_BUY_HELMET, "black"),
		list("USCM officer cap", 0, /obj/item/clothing/head/cmcap/ro, MARINE_CAN_BUY_HELMET, "black"),
	)


////////////////////// Gear ///////////////////////////////////////////////////////



/obj/structure/machinery/cm_vending/gear
	name = "ColMarTech Automated Equipment Rack"
	desc = "An automated equipment rack hooked up to a colossal storage of standard-issue equipments."
	icon_state = "sec"
	use_points = TRUE


/obj/structure/machinery/cm_vending/gear/medic
	vendor_role = JOB_SQUAD_MEDIC
	req_access = list(ACCESS_MARINE_MEDPREP)

	listed_products = list(
		list("MEDICAL SET (Mandatory)", 0, null, null, null),
		list("Essential Medic Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv burn kit", 2, /obj/item/stack/medical/advanced/ointment, null, "orange"),
		list("Adv trauma kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, "orange"),
		list("Advanced firstaid kit", 12, /obj/item/storage/firstaid/adv, null, "orange"),
		list("Medical splints", 1, /obj/item/stack/medical/splint, null, "orange"),
		list("Roller Bed", 4, /obj/item/roller, null, "orange"),
		list("Stasis bag", 6, /obj/item/bodybag/cryobag, null, "orange"),
		list("Firstaid kit", 6, /obj/item/storage/firstaid/regular, null, "black"),

		list("Pillbottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, "orange"),
		list("Pillbottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, "black"),
		list("Pillbottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, "black"),
		list("Pillbottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, "black"),
		list("Pillbottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, "orange"),
		list("Pillbottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, "black"),
		list("Pillbottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, "black"),
		list("Pillbottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, "orange"),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, "black"),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, "black"),
		list("Injector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, "black"),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, "black"),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, "black"),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, "black"),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, "black"),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, "black"),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, "black"),

		list("Health analyzer", 4, /obj/item/device/healthanalyzer, null, "black"),
		list("Medical HUD glasses", 4, /obj/item/clothing/glasses/hud/health, null, "black"),

		list("AMMUNITION", 0, null, null, null),
		list("M39 AP magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/ap , null, "black"),
		list("M39 extended magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/extended , null, "black"),
		list("M40 HEDP grenade", 9, /obj/item/explosive/grenade/HE, null, "black"),
		list("M40 HEFA grenade", 9, /obj/item/explosive/grenade/HE/frag , null, "black"),
		list("M41A AP magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/ap , null, "black"),
		list("M41A extended magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/extended , null, "black"),
		list("L42A AP magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/l42a/ap, null, "black"),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled grip", 10, /obj/item/attachable/angledgrip, null, "black"),
		list("Extended barrel", 10, /obj/item/attachable/extended_barrel, null, "black"),
		list("Gyroscopic stabilizer", 10, /obj/item/attachable/gyro, null, "black"),
		list("L42A synthetic stock", 10, /obj/item/attachable/stock/carbine, null, "black"),
		list("Laser sight", 10, /obj/item/attachable/lasersight, null, "black"),
		list("Masterkey shotgun", 10, /obj/item/attachable/attached_gun/shotgun, null, "black"),
		list("M37 wooden stock", 10, /obj/item/attachable/stock/shotgun, null, "black"),
		list("M41A skeleton stock", 10, /obj/item/attachable/stock/rifle, null, "black"),
		list("Quickfire adapter", 10, /obj/item/attachable/quickfire, null, "black"),
		list("Recoil compensator", 10, /obj/item/attachable/compensator, null, "black"),
		list("Red-dot sight", 10, /obj/item/attachable/reddot, null, "black"),
		list("Submachinegun stock", 10, /obj/item/attachable/stock/smg, null, "black"),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, "black"),
		list("Vertical grip", 10, /obj/item/attachable/verticalgrip, null, "black"),

		list("MISCELLANEOUS", 0, null, null, null),
		list("Fire extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, null, "black"),
	)



/obj/structure/machinery/cm_vending/gear/engi
	vendor_role = JOB_SQUAD_ENGI
	req_access = list(ACCESS_MARINE_ENGPREP)

	listed_products = list(
		list("ENGINEER SET (Mandatory)", 0, null, null, null),
		list("Essential Engineer Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("ENGINEER SUPPLIES", 0, null, null, null),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, "orange"),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, "orange"),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, "orange"),
		list("Airlock electronics", 2, /obj/item/circuitboard/airlock, null, "black"),
		list("Entrenching tool", 2, /obj/item/tool/shovel/etool, null, "black"),
		list("Fire extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, null, "black"),
		list("High capacity powercell", 3, /obj/item/cell/high, null, "black"),
		list("Incendiary grenade", 6, /obj/item/explosive/grenade/incendiary, null, "black"),
		list("M20 mine box", 18, /obj/item/storage/box/explosive_mines, null, "black"),
		list("Multitool", 4, /obj/item/device/multitool, null, "black"),
		list("Plastique explosive", 5, /obj/item/explosive/plastique, null, "black"),
		list("Power control module", 2, /obj/item/circuitboard/apc, null, "black"),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, "black"),

		list("AMMUNITION", 0, null, null, null),
		list("M39 AP magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/ap , null, "black"),
		list("M39 extended magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/extended , null, "black"),
		list("M40 HEDP grenade", 9, /obj/item/explosive/grenade/HE, null, "black"),
		list("M40 HEFA grenade", 9, /obj/item/explosive/grenade/HE/frag , null, "black"),
		list("M41A AP magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/ap , null, "black"),
		list("M41A extended magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/extended , null, "black"),
		list("L42A AP magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/l42a/ap, null, "black"),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled grip", 6, /obj/item/attachable/angledgrip, null, "black"),
		list("Extended barrel", 6, /obj/item/attachable/extended_barrel, null, "black"),
		list("Gyroscopic stabilizer", 6, /obj/item/attachable/gyro, null, "black"),
		list("L42A synthetic stock", 6, /obj/item/attachable/stock/carbine, null, "black"),
		list("Laser sight", 6, /obj/item/attachable/lasersight, null, "black"),
		list("Masterkey shotgun", 6, /obj/item/attachable/attached_gun/shotgun, null, "black"),
		list("M37 wooden stock", 6, /obj/item/attachable/stock/shotgun, null, "black"),
		list("M41A skeleton stock", 6, /obj/item/attachable/stock/rifle, null, "black"),
		list("Quickfire adapter", 6, /obj/item/attachable/quickfire, null, "black"),
		list("Recoil compensator", 6, /obj/item/attachable/compensator, null, "black"),
		list("Red-dot sight", 6, /obj/item/attachable/reddot, null, "black"),
		list("Reflex sight", 6, /obj/item/attachable/reflex, null, "black"),
		list("Submachinegun stock", 6, /obj/item/attachable/stock/smg, null, "black"),
		list("Suppressor", 6, /obj/item/attachable/suppressor, null, "black"),
		list("Vertical grip", 6, /obj/item/attachable/verticalgrip, null, "black"),

	)





/obj/structure/machinery/cm_vending/gear/smartgun
	vendor_role = JOB_SQUAD_SMARTGUN
	req_access = list(ACCESS_MARINE_SMARTPREP)

	listed_products = list(
		list("SMARTGUN SET (Mandatory)", 0, null, null, null),
		list("Essential Smartgunner Set", 0, /obj/item/storage/box/m56_system, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("SMARTGUN AMMUNITION", 0, null, null, null),
		list("M56 ammunition drum", 15, /obj/item/ammo_magazine/smartgun, null, "white"),

		list("SMARTGUN ATTACHMENTS", 0, null, null, null),
		list("Barrel Charger", 45, /obj/item/attachable/heavy_barrel, null, "black"),
		list("Burst Fire Assembly", 15, /obj/item/attachable/burstfire_assembly, null, "black"),

		list("GUN ATTACHMENTS (Choose 1)", 0, null, null, null),
		list("Quickfire adapter", 0, /obj/item/attachable/quickfire, MARINE_CAN_BUY_ATTACHMENT, "black"),
		list("Red-dot sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, "black"),
		list("Reflex sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, "black"),

		list("MISCELLANEOUS AND SPECIAL", 0, null, null, null),
		list("High-capacity power cell", 5, /obj/item/cell/high, null, "black"),
	)





//the global list of specialist sets that haven't been claimed yet.
var/list/available_specialist_sets = list("Scout Set", "Sniper Set", "Demolitionist Set", "Heavy Grenadier Set", "Pyro Set")


/obj/structure/machinery/cm_vending/gear/spec
	vendor_role = JOB_SQUAD_SPECIALIST
	req_access = list(ACCESS_MARINE_SPECPREP)

	listed_products = list(
		list("SPECIALIST SETS (Choose one)", 0, null, null, null),
		list("Scout Set", 0, /obj/item/storage/box/spec/scout, MARINE_CAN_BUY_ESSENTIALS, "white"),
		list("Sniper Set", 0, /obj/item/storage/box/spec/sniper, MARINE_CAN_BUY_ESSENTIALS, "white"),
		list("Demolitionist Set", 0, /obj/item/storage/box/spec/demolitionist, MARINE_CAN_BUY_ESSENTIALS, "white"),
		list("Heavy Grenadier Set", 0, /obj/item/storage/box/spec/heavy_grenadier, MARINE_CAN_BUY_ESSENTIALS, "white"),
		list("Pyro Set", 0, /obj/item/storage/box/spec/pyro, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("EXTRA SCOUT AMMUNITION", 0, null, null, null),
		list("A19 high velocity magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/m4ra, null, "black"),
		list("A19 high velocity incendiary magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/m4ra/incendiary, null, "black"),
		list("A19 high velocity impact magazine (10x24mm)", 15, /obj/item/ammo_magazine/rifle/m4ra/impact, null, "black"),

		list("EXTRA SNIPER AMMUNITION", 0, null, null, null),
		list("M42A marksman magazine (10x28mm Caseless)", 15, /obj/item/ammo_magazine/sniper, null, "black"),
		list("M42A incendiary magazine (10x28mm)", 15, /obj/item/ammo_magazine/sniper/incendiary, null, "black"),
		list("M42A flak magazine (10x28mm)", 15, /obj/item/ammo_magazine/sniper/flak, null, "black"),

		list("EXTRA DEMOLITIONIST AMMUNITION", 0, null, null, null),
		list("84mm high-explosive rocket", 15, /obj/item/ammo_magazine/rocket, null, "black"),
		list("84mm anti-armor rocket", 15, /obj/item/ammo_magazine/rocket/ap, null, "black"),
		list("84mm white-phosphorus rocket", 15, /obj/item/ammo_magazine/rocket/wp, null, "black"),

		list("EXTRA GRENADES", 0, null, null, null),
		list("M40 HEDP grenade x6", 15, /obj/effect/essentials_set/hedp_6_pack, null, "black"),
		list("M40 HEFA grenade x6", 15, /obj/effect/essentials_set/hefa_6_pack, null, "black"),
		list("M40 HIDP incendiary grenade x6", 15, /obj/effect/essentials_set/hidp_6_pack, null, "black"),

		list("EXTRA FLAMETHROWER TANKS", 0, null, null, null),
		list("Large incinerator tank", 15, /obj/item/ammo_magazine/flamer_tank/large, null, "black"),
		list("Large incinerator tank (B) (Green flame)", 30, /obj/item/ammo_magazine/flamer_tank/large/B, null, "black"),
		list("Large incinerator tank (X) (Blue flame)", 30, /obj/item/ammo_magazine/flamer_tank/large/X, null, "black"),

		list("AMMUNITION", 0, null, null, null),
		list("VP78 magazine", 10, /obj/item/ammo_magazine/pistol/vp78, null, "black"),
		list("AP M41A magazine", 15, /obj/item/ammo_magazine/rifle/ap, null, "black"),
		list("Extended M41A magazine", 15, /obj/item/ammo_magazine/rifle/extended, null, "black"),
		list("AP M39 magazine", 13, /obj/item/ammo_magazine/smg/m39/ap, null, "black"),
		list("Extended M39 magazine", 13, /obj/item/ammo_magazine/smg/m39/extended, null, "black"),
		list("AP L42A magazine", 13, /obj/item/ammo_magazine/rifle/l42a/ap, null, "black"),
		list("M44 Heavy Speed Loader (.44)", 15, /obj/item/ammo_magazine/revolver/heavy, null, "black"),

		list("ATTACHMENTS", 0, null, null, null),
		list("Recoil compensator", 6, /obj/item/attachable/compensator, null, "black"),
		list("Angled grip", 6, /obj/item/attachable/angledgrip, null, "black"),
		list("Extended barrel", 6, /obj/item/attachable/extended_barrel, null, "black"),
		list("Gyroscopic stabilizer", 6, /obj/item/attachable/gyro, null, "black"),
		list("L42A synthetic stock", 6, /obj/item/attachable/stock/carbine, null, "black"),
		list("Laser sight", 6, /obj/item/attachable/lasersight, null, "black"),
		list("Magnetic Harness", 6, /obj/item/attachable/magnetic_harness, null, "black"),
		list("Masterkey shotgun", 6, /obj/item/attachable/attached_gun/shotgun, null, "black"),
		list("M41A skeleton stock", 6, /obj/item/attachable/stock/rifle, null, "black"),
		list("Folding submachinegun stock", 6, /obj/item/attachable/stock/smg/collapsible, null, "black"),
		list("Quickfire adapter", 6, /obj/item/attachable/quickfire, null, "black"),
		list("Recoil compensator", 6, /obj/item/attachable/compensator, null, "black"),
		list("Red-dot sight", 6, /obj/item/attachable/reddot, null, "black"),
		list("Reflex sight", 6, /obj/item/attachable/reflex, null, "black"),
		list("S4 telescoping sight", 6, /obj/item/attachable/scope/mini, null, "black"),
		list("M37 wooden stock", 6, /obj/item/attachable/stock/shotgun, null, "black"),
		list("Suppressor", 6, /obj/item/attachable/suppressor, null, "black"),
		list("Vertical grip", 6, /obj/item/attachable/verticalgrip, null, "black"),
	)



/obj/structure/machinery/cm_vending/gear/leader
	vendor_role = JOB_SQUAD_LEADER
	req_access = list(ACCESS_MARINE_LEADER)

	listed_products = list(
		list("SQUAD LEADER SET (Mandatory)", 0, null, null, null),
		list("Essential SL Set", 0, /obj/effect/essentials_set/leader, MARINE_CAN_BUY_ESSENTIALS, "white"),

		list("LEADER SUPPLIES", 0, null, null, null),
		list("Advanced firstaid kit", 10, /obj/item/storage/firstaid/adv, null, "orange"),
		list("Flamethrower tank", 3, /obj/item/ammo_magazine/flamer_tank, null, "black"),
		list("Flamethrower", 12, /obj/item/weapon/gun/flamer, null, "black"),
		list("Incendiary grenade", 8, /obj/item/explosive/grenade/incendiary, null, "black"),
		list("Motion detector", 5, /obj/item/device/motiondetector, null, "black"),
		list("Plastique explosive", 5, /obj/item/explosive/plastique, null, "black"),
		list("Sandbags x25", 15, /obj/item/stack/sandbags_empty/half, null, "black"),
		list("Smoke grenade", 2, /obj/item/explosive/grenade/smokebomb, null, "black"),
		list("Whistle", 5, /obj/item/device/whistle, null, "black"),
		list("Sensor Medical HUD", 5, /obj/item/clothing/glasses/hud/sensor, null, "black"),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("AP M41A magazine", 6, /obj/item/ammo_magazine/rifle/ap, null, "black"),
		list("Extended M41A magazine", 6, /obj/item/ammo_magazine/rifle/extended, null, "black"),
		list("AP M39 magazine", 5, /obj/item/ammo_magazine/smg/m39/ap, null, "black"),
		list("AP L42A Magazine (10x24mm)", 4, /obj/item/ammo_magazine/rifle/l42a/ap, null, "black"),
		list("Extended M39 magazine", 5, /obj/item/ammo_magazine/smg/m39/extended, null, "black"),
		list("Signal Flare Pack", 15, /obj/item/storage/box/m94/signal, null, "black"),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled grip", 6, /obj/item/attachable/angledgrip, null, "black"),
		list("Extended barrel", 6, /obj/item/attachable/extended_barrel, null, "black"),
		list("Gyroscopic stabilizer", 6, /obj/item/attachable/gyro, null, "black"),
		list("L42A synthetic stock", 6, /obj/item/attachable/stock/carbine, null, "black"),
		list("Laser sight", 6, /obj/item/attachable/lasersight, null, "black"),
		list("Masterkey shotgun", 6, /obj/item/attachable/attached_gun/shotgun, null, "black"),
		list("M37 wooden stock", 6, /obj/item/attachable/stock/shotgun, null, "black"),
		list("M41A skeleton stock", 6, /obj/item/attachable/stock/rifle, null, "black"),
		list("Quickfire adapter", 6, /obj/item/attachable/quickfire, null, "black"),
		list("Recoil compensator", 6, /obj/item/attachable/compensator, null, "black"),
		list("Red-dot sight", 6, /obj/item/attachable/reddot, null, "black"),
		list("Reflex sight", 6, /obj/item/attachable/reflex, null, "black"),
		list("Submachinegun stock", 6, /obj/item/attachable/stock/smg, null, "black"),
		list("Suppressor", 6, /obj/item/attachable/suppressor, null, "black"),
		list("Vertical grip", 6, /obj/item/attachable/verticalgrip, null, "black"),
	)



/obj/structure/machinery/cm_vending/gear/synth
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = JOB_SYNTH

	listed_products = list(
		list("ENGINEER SUPPLIES", 0, null, null, null),
		list("Airlock electronics", 2, /obj/item/circuitboard/airlock, null, "black"),
		list("Entrenching tool", 2, /obj/item/tool/shovel/etool, null, "black"),
		list("High capacity powercell", 3, /obj/item/cell/high, null, "black"),
		list("Light Replacer", 2, /obj/item/device/lightreplacer, null, "black"),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, "black"),
		list("Multitool", 4, /obj/item/device/multitool, null, "black"),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, "black"),
		list("Power control module", 2, /obj/item/circuitboard/apc, null, "black"),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, "black"),
		list("Welding glasses", 4, /obj/item/clothing/glasses/welding, null, "black"),
		list("Industrial blowtorch", 4, /obj/item/tool/weldingtool/largetank, null, "black"),

		list("MEDICAL SUPPLIES", 0, null, null, null),
		list("Adv burn kit", 2, /obj/item/stack/medical/advanced/ointment, null, "black"),
		list("Adv trauma kit", 2, /obj/item/stack/medical/advanced/bruise_pack, null, "black"),
		list("Advanced firstaid kit", 12, /obj/item/storage/firstaid/adv, null, "black"),
		list("Firstaid kit", 6, /obj/item/storage/firstaid/regular, null, "black"),
		list("Medevac Bed", 6, /obj/item/roller/medevac, null, "black"),
		list("Medical splints", 1, /obj/item/stack/medical/splint, null, "black"),
		list("Roller Bed", 4, /obj/item/roller, null, "black"),
		list("Stasis bag", 6, /obj/item/bodybag/cryobag, null, "black"),

		list("Pillbottle (Bicaridine)", 5, /obj/item/storage/pill_bottle/bicaridine, null, "orange"),
		list("Pillbottle (Dexalin)", 5, /obj/item/storage/pill_bottle/dexalin, null, "black"),
		list("Pillbottle (Dylovene)", 5, /obj/item/storage/pill_bottle/antitox, null, "black"),
		list("Pillbottle (Inaprovaline)", 5, /obj/item/storage/pill_bottle/inaprovaline, null, "black"),
		list("Pillbottle (Kelotane)", 5, /obj/item/storage/pill_bottle/kelotane, null, "orange"),
		list("Pillbottle (Peridaxon)", 5, /obj/item/storage/pill_bottle/peridaxon, null, "black"),
		list("Pillbottle (QuickClot)", 5, /obj/item/storage/pill_bottle/quickclot, null, "black"),
		list("Pillbottle (Tramadol)", 5, /obj/item/storage/pill_bottle/tramadol, null, "orange"),

		list("Injector (Bicaridine)", 1, /obj/item/reagent_container/hypospray/autoinjector/bicaridine, null, "black"),
		list("Injector (Dexalin+)", 1, /obj/item/reagent_container/hypospray/autoinjector/dexalinp, null, "black"),
		list("Injector (Epinephrine)", 2, /obj/item/reagent_container/hypospray/autoinjector/adrenaline, null, "black"),
		list("Injector (Inaprovaline)", 1, /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, null, "black"),
		list("Injector (Kelotane)", 1, /obj/item/reagent_container/hypospray/autoinjector/kelotane, null, "black"),
		list("Injector (Oxycodone)", 2, /obj/item/reagent_container/hypospray/autoinjector/oxycodone, null, "black"),
		list("Injector (QuickClot)", 1, /obj/item/reagent_container/hypospray/autoinjector/quickclot, null, "black"),
		list("Injector (Tramadol)", 1, /obj/item/reagent_container/hypospray/autoinjector/tramadol, null, "black"),
		list("Injector (Tricord)", 1, /obj/item/reagent_container/hypospray/autoinjector/tricord, null, "black"),

		list("Emergency defibrillator", 4, /obj/item/device/defibrillator, null, "white"),
		list("Health analyzer", 4, /obj/item/device/healthanalyzer, null, "black"),
		list("Medical HUD glasses", 4, /obj/item/clothing/glasses/hud/health, null, "black"),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Flashlight", 1, /obj/item/device/flashlight, null, "black"),
		list("Motion detector", 5, /obj/item/device/motiondetector, null, "black"),
		list("Whistle", 5, /obj/item/device/whistle, null, "black"),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, "black"),
	)

//Five global lists - one for each slot - so that two tankers can't each get five items

//
/obj/structure/machinery/cm_vending/tank
	name = "ColMarTech Vehicle Equipment storage"
	desc = "An automated weapons storage unit hooked up to the underbelly of the ship, allowing the crewmen to choose one set of free equipment for their vehicle."
	icon_state = "armory"
	vendor_role = JOB_CREWMAN
	var/list/integral_list = list(
		"M34A2-A Multipurpose Turret"
	)
	var/list/primary_list = list(
		"DRG-N Offensive Flamer Unit",
		"LTAA-AP Minigun",
		"AC3-E Autocannon",
		"PARS-159 Boyars Dualcannon"
	)
	var/list/secondary_list = list(
		"Grenade Launcher",
		"M56 Cupola",
		"Secondary Flamer Unit",
		"TOW Launcher",
		"RE-RE700 Frontal Cannon"
	)
	var/list/support_list = list(
		"Artillery Module",
		"Integrated Weapons Sensor Array",
		"Overdrive Enhancer",
		"Smoke Launcher",
		"Flare Launcher"
	)
	var/list/armor_list = list(
		"Ballistic Armor",
		"Caustic Armor",
		"Concussive Armor",
		"Paladin Armor"
	)
	var/list/treads_list = list(
		"Treads",
		"Robus-Treads",
		"APC wheels"
	)

	listed_products = list(
		list("Equipment is unavailable at this time", 0, null, null, null)
	)

/obj/structure/machinery/cm_vending/tank/New()
	..()

	registerListener(GLOBAL_EVENT, EVENT_VEHICLE_ORDERED, "vehicle_vendor_populate", CALLBACK(src, .proc/populate_products))
	
	if(map_tag in MAPS_COLD_TEMP)
		armor_list += "Snowplow"

/obj/structure/machinery/cm_vending/tank/proc/populate_products(var/obj/vehicle/multitile/V)
	unregisterListener(GLOBAL_EVENT, EVENT_VEHICLE_ORDERED, "vehicle_vendor_populate")

	if(istype(V, /obj/vehicle/multitile/tank))
		listed_products = list(
			list("INTEGRAL PARTS", 0, null, null, null),
			list("M34A2-A Multipurpose Turret", 0, /obj/item/hardpoint/holder/tank_turret, MARINE_CAN_BUY_ESSENTIALS, "black"),

			list("PRIMARY WEAPON", 0, null, null, null),
			list("LTAA-AP Minigun", 0, /obj/effect/essentials_set/tank/gatling, MARINE_CAN_BUY_EAR, "black"),
			list("DRG-N Offensive Flamer Unit", 0, /obj/effect/essentials_set/tank/dragonflamer, MARINE_CAN_BUY_EAR, "black"),
			list("AC3-E Autocannon", 0, /obj/effect/essentials_set/tank/autocannon, MARINE_CAN_BUY_EAR, "black"),

			list("SECONDARY WEAPON", 0, null, null, null),
			list("Grenade Launcher", 0, /obj/effect/essentials_set/tank/tankgl, MARINE_CAN_BUY_GLOVES, "black"),
			list("M56 Cupola", 0, /obj/effect/essentials_set/tank/tank56, MARINE_CAN_BUY_GLOVES, "black"),
			list("Secondary Flamer Unit", 0, /obj/effect/essentials_set/tank/tankflamer, MARINE_CAN_BUY_GLOVES, "black"),

			list("SUPPORT MODULE", 0, null, null, null),
			list("Integrated Weapons Sensor Array", 0, /obj/item/hardpoint/buff/support/weapons_sensor, MARINE_CAN_BUY_ATTACHMENT, "black"),
			list("Smoke Launcher", 0, /obj/item/hardpoint/gun/smoke_launcher, MARINE_CAN_BUY_ATTACHMENT, "black"),
			list("Overdrive Enhancer", 0, /obj/item/hardpoint/buff/support/overdrive_enhancer, MARINE_CAN_BUY_ATTACHMENT, "black"),
			list("Artillery Module", 0, /obj/item/hardpoint/artillery_module, MARINE_CAN_BUY_ATTACHMENT, "black"),

			list("ARMOR", 0, null, null, null),
			list("Ballistic Armor", 0, /obj/item/hardpoint/buff/armor/ballistic, MARINE_CAN_BUY_ARMOR, "black"),
			list("Caustic Armor", 0, /obj/item/hardpoint/buff/armor/caustic, MARINE_CAN_BUY_ARMOR, "black"),
			list("Concussive Armor", 0, /obj/item/hardpoint/buff/armor/concussive, MARINE_CAN_BUY_ARMOR, "black"),
			list("Paladin Armor", 0, /obj/item/hardpoint/buff/armor/paladin, MARINE_CAN_BUY_ARMOR, "black"),
			list("Snowplow", 0, /obj/item/hardpoint/buff/armor/snowplow, MARINE_CAN_BUY_ARMOR, "black"),

			list("TREADS", 0, null, null, null),
			list("Treads", 0, /obj/item/hardpoint/locomotion/treads, MARINE_CAN_BUY_SHOES, "black"),
			list("Robus-Treads", 0, /obj/item/hardpoint/locomotion/treads/robust, MARINE_CAN_BUY_SHOES, "black"),
		)
	else if(istype(V, /obj/vehicle/multitile/apc))
		listed_products = list(
			list("PRIMARY WEAPON", 0, null, null, null),
			list("PARS-159 Boyars Dualcannon", 0, /obj/effect/essentials_set/apc/dualcannon, MARINE_CAN_BUY_EAR, "black"),

			list("SECONDARY WEAPON", 0, null, null, null),
			list("RE-RE700 Frontal Cannon", 0, /obj/effect/essentials_set/apc/frontalcannon, MARINE_CAN_BUY_GLOVES, "black"),

			list("SUPPORT MODULE", 0, null, null, null),
			list("Flare Launcher", 0, /obj/effect/essentials_set/apc/flarelauncher, MARINE_CAN_BUY_ATTACHMENT, "black"),

			list("WHEELS", 0, null, null, null),
			list("APC wheels", 0, /obj/item/hardpoint/locomotion/apc_wheels, MARINE_CAN_BUY_SHOES, "black"),
		)

/obj/effect/essentials_set
	var/list/spawned_gear_list

/obj/effect/essentials_set/New(loc)
	..()
	for(var/typepath in spawned_gear_list)
		if(spawned_gear_list[typepath])
			new typepath(loc, spawned_gear_list[typepath])
		else
			new typepath(loc)
	qdel(src)



/obj/effect/essentials_set/medic
	spawned_gear_list = list(
		/obj/item/bodybag/cryobag,
		/obj/item/device/defibrillator,
		/obj/item/storage/firstaid/adv,
		/obj/item/device/healthanalyzer,
		/obj/item/roller/medevac,
		/obj/item/roller,
	)

/obj/effect/essentials_set/engi
	spawned_gear_list = list(
		/obj/item/explosive/plastique,
		/obj/item/stack/sandbags_empty = 25,
		/obj/item/cell/high,
		/obj/item/tool/shovel/etool,
		/obj/item/device/lightreplacer,
	)


/obj/effect/essentials_set/leader
	spawned_gear_list = list(
		/obj/item/explosive/plastique,
		/obj/item/device/binoculars/range/designator,
		/obj/item/map/current_map,
		/obj/item/weapon/gun/flamer,
		/obj/item/tool/extinguisher/mini,
		/obj/item/storage/box/zipcuffs,
	)


//Not essentials sets but fuck it the code's here
/obj/effect/essentials_set/tank/ltb
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon
	)

/obj/effect/essentials_set/tank/gatling
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	)

/obj/effect/essentials_set/tank/dragonflamer
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer
	)

/obj/effect/essentials_set/tank/autocannon
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon
	)

/obj/effect/essentials_set/tank/tankflamer
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/small_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer
	)

/obj/effect/essentials_set/tank/tow
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher
	)

/obj/effect/essentials_set/tank/tank56
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/m56cupola,
		/obj/item/ammo_magazine/hardpoint/m56_cupola
	)

/obj/effect/essentials_set/tank/tankgl
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/grenade_launcher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher
	)

/obj/effect/essentials_set/apc/dualcannon
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon
	)

/obj/effect/essentials_set/apc/frontalcannon
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/frontalcannon,
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon
	)

/obj/effect/essentials_set/apc/flarelauncher
	spawned_gear_list = list(
		/obj/item/hardpoint/gun/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher
	)

/obj/effect/essentials_set/hedp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/HE,
		/obj/item/explosive/grenade/HE,
		/obj/item/explosive/grenade/HE,
		/obj/item/explosive/grenade/HE,
		/obj/item/explosive/grenade/HE,
		/obj/item/explosive/grenade/HE,
	)

/obj/effect/essentials_set/hefa_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/HE/frag,
		/obj/item/explosive/grenade/HE/frag,
		/obj/item/explosive/grenade/HE/frag,
		/obj/item/explosive/grenade/HE/frag,
		/obj/item/explosive/grenade/HE/frag,
		/obj/item/explosive/grenade/HE/frag,
	)

/obj/effect/essentials_set/hidp_6_pack
	spawned_gear_list = list(
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
		/obj/item/explosive/grenade/incendiary,
	)

/obj/effect/essentials_set/intelligence_officer
	spawned_gear_list = list(
		/obj/item/tool/crowbar,
		/obj/item/stack/fulton,
		/obj/item/device/motiondetector/intel
	)



//22.06.2019 Modified ex-"marine_selector" system that doesn't use points by Jeser. In theory, should replace all vendors.
//Hacking can be added if we need it. Do we need it, tho?


/obj/structure/machinery/cm_vending/sorted
	name = "\improper ColMarTech generic sorted vendor"
	desc = "This is pure vendor without points system."
	icon_state = "armory"

/obj/structure/machinery/cm_vending/sorted/proc/populate_product_list(var/scale)
	return

/obj/structure/machinery/cm_vending/sorted/attack_hand(mob/user)

	if(stat & (BROKEN|NOPOWER))
		return

	if(!ishuman(user))
		return

	user.set_interaction(src)
	ui_interact(user)

/obj/structure/machinery/cm_vending/sorted/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 0)

	if(!ishuman(user)) return

	var/list/display_list = list()

	if(listed_products.len)						//runtimed for vendors without goods in them
		for(var/i in 1 to listed_products.len)
			var/list/myprod = listed_products[i]	//we take one list from listed_products

			var/p_name = myprod[1]					//taking it's name
			var/p_amount = myprod[2]				//amount left
			var/prod_available = FALSE				//checking if it's available
			if(p_amount > 0)						//checking availability
				p_name += ": [p_amount]"			//and adding amount to product name so it will appear in "button" in UI
				prod_available = TRUE
			else if(p_amount == 0)
				p_name += ": SOLD OUT"				//Negative  numbers (-1) used for categories.

			//forming new list with index, name, amount, available or not, color and add it to display_list
			display_list += list(list("prod_index" = i, "prod_name" = p_name, "prod_amount" = p_amount, "prod_available" = prod_available, "prod_color" = myprod[4]))


	var/list/data = list(
		"vendor_name" = name,
		"displayed_records" = display_list,
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "cm_vending_sorted.tmpl", name , 600, 700)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


//get which turf the vendor will dispense its products on.
/obj/structure/machinery/cm_vending/sorted/proc/get_appropriate_vend_turf(mob/living/carbon/human/H)
	return loc

/obj/structure/machinery/cm_vending/sorted/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.is_mob_incapacitated())
		return

	if (in_range(src, usr) && isturf(loc) && ishuman(usr))
		usr.set_interaction(src)
		if (href_list["vend"])

			if(!allowed(usr))
				to_chat(usr, SPAN_WARNING("Access denied."))
				return

			var/idx=text2num(href_list["vend"])

			var/list/L = listed_products[idx]
			var/mob/living/carbon/human/H = usr

			var/obj/item/card/id/I = H.wear_id
			if(!istype(I)) //not wearing an ID
				to_chat(H, SPAN_WARNING("Access denied. No ID card detected"))
				return

			if(I.registered_name != H.real_name)
				to_chat(H, SPAN_WARNING("Wrong ID card owner detected."))
				return

			if(vendor_role && I.rank != vendor_role)
				to_chat(H, SPAN_WARNING("This machine isn't for you."))
				return

			var/turf/T = get_appropriate_vend_turf(H)

			if(T.contents.len > 25)
				to_chat(H, SPAN_WARNING("The floor is too cluttered, make some space."))
				return

			if(L[2] <= 0)	//to avoid dropping more than one product when there's
				return		// one left and the player spam click during a lagspike.

			var/type_p = L[3]

			var/obj/item/IT
			if(ispath(type_p,/obj/item/weapon/gun))
				IT = new type_p(T, TRUE)
			else
				IT = new type_p(T)

			L[2]--								//taking 1 from amount of products in vendor
			IT.add_fingerprint(usr)

			if(auto_equip && istype(IT, /obj/item))
				if(IT.flags_equip_slot != NO_FLAGS)
					if(IT.flags_equip_slot == SLOT_ACCESSORY)
						if(H.w_uniform)
							var/obj/item/clothing/C = H.w_uniform
							if(C.can_attach_accessory(IT))
								C.attach_accessory(H, IT)
					else
						H.equip_to_appropriate_slot(IT)

		add_fingerprint(usr)
		ui_interact(usr) //updates the nanoUI window


/obj/structure/machinery/cm_vending/sorted/MouseDrop_T(var/atom/movable/A, mob/user)

	if(stat & (BROKEN|NOPOWER))
		return

	if(user.stat || user.is_mob_restrained() || user.lying)
		return

	if(get_dist(user, src) > 1 || get_dist(src, A) > 1)
		return

	if(istype(A, /obj/item))
		var/obj/item/I = A
		stock(I, user)

/obj/structure/machinery/cm_vending/sorted/proc/stock(obj/item/item_to_stock, mob/user)
	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3] && !istype(item_to_stock,/obj/item/storage))
			if(istype(item_to_stock, /obj/item/weapon/gun))
				var/obj/item/weapon/gun/G = item_to_stock
				if(G.in_chamber || (G.current_mag && !istype(G.current_mag, /obj/item/ammo_magazine/internal)) || (istype(G.current_mag, /obj/item/ammo_magazine/internal) && G.current_mag.current_rounds > 0) )
					to_chat(user, SPAN_WARNING("[G] is still loaded. Unload it before you can restock it."))
					return
				for(var/obj/item/attachable/A in G.contents) //Search for attachments on the gun. This is the easier method
					if((A.flags_attach_features & ATTACH_REMOVABLE) && !(is_type_in_list(A, G.starting_attachment_types))) //There are attachments that are default and others that can't be removed
						to_chat(user, SPAN_WARNING("[G] has non-standard attachments equipped. Detach them before you can restock it."))
						return
			if(istype(item_to_stock, /obj/item/ammo_magazine))
				var/obj/item/ammo_magazine/A = item_to_stock
				if(A.current_rounds < A.max_rounds)
					to_chat(user, SPAN_WARNING("[A] isn't full. Fill it before you can restock it."))
					return
			if(istype(item_to_stock, /obj/item/ammo_box/magazine))
				var/obj/item/ammo_box/magazine/A = item_to_stock
				if(A.contents.len < A.num_of_magazines)
					to_chat(user, SPAN_WARNING("[A] is not full."))
					return
				for(var/obj/item/ammo_magazine/M in A.contents)
					if(M.current_rounds != M.max_rounds)
						to_chat(user, SPAN_WARNING("Not all magazines in [A] are full."))
						return
			if(istype(item_to_stock, /obj/item/ammo_box/rounds))
				var/obj/item/ammo_box/rounds/A = item_to_stock
				if(A.bullet_amount < A.max_bullet_amount)
					to_chat(user, SPAN_WARNING("[A] is not full."))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(istype(item_to_stock.loc, /obj/item/storage)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks [src] with \a [R[1]]."),
			SPAN_NOTICE("You stock [src] with \a [R[1]]."))
			R[2]++
			updateUsrDialog()
			return //We found our item, no reason to go on.

//--------------------------REQ VENDORS AND THEIR SQUAD VARIANTS------------------

//ARMAMENTS VENDOR
/obj/structure/machinery/cm_vending/sorted/cargo_guns
	name = "\improper ColMarTech Automated Armaments Vendor"
	desc = "An automated rack hooked up to a small supply of various firearms and explosives."
	req_access = list(ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/New()
	..()
	cm_vending_vendors.Add(src)						//this is needed for cm_initialize and needs changing

/obj/structure/machinery/cm_vending/sorted/cargo_guns/populate_product_list(var/scale)
	listed_products = list(
		list("Backpacks", -1, null, null),
		list("Lightweight IMP Backpack", round(scale * 15), /obj/item/storage/backpack/marine, "black"),
		list("USCM Pyrotechnician G4-1 Fueltank", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit, "black"),
		list("USCM Technician Welderpack", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack, "black"),

		list("Belts", -1, null, null),
		list("G8-A General Utility Pouch", round(scale * 2), /obj/item/storage/sparepouch, "black"),
		list("M276 Pattern Ammo Load Rig", round(scale * 15), /obj/item/storage/belt/marine, "black"),
		list("M276 Pattern M39 Holster Rig", round(scale * 5), /obj/item/storage/large_holster/m39, "black"),
		list("M276 Pattern M44 Holster Rig", round(scale * 5), /obj/item/storage/belt/gun/m44, "black"),
		list("M276 Pattern General Pistol Holster Rig", round(scale * 10), /obj/item/storage/belt/gun/m4a3, "black"),
		list("M276 Pattern Shotgun Shell Loading Rig", round(scale * 10), /obj/item/storage/belt/shotgun, "black"),

		list("Webbings", -1, null, null),
		list("Black Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/black_vest, "black"),
		list("Brown Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/brown_vest, "black"),
		list("Webbing", round(scale * 5), /obj/item/clothing/accessory/storage/webbing, "black"),

		list("Pouches", -1, null, null),
		list("Construction Pouch", round(scale * 2), /obj/item/storage/pouch/construction, "black"),
		list("Document Pouch", round(scale * 2), /obj/item/storage/pouch/document/small, "black"),
		list("Explosive Pouch", round(scale * 2), /obj/item/storage/pouch/explosive, "black"),
		list("First-Aid Pouch", round(scale * 5), /obj/item/storage/pouch/firstaid/full, "black"),
		list("Flare Pouch", round(scale * 5), /obj/item/storage/pouch/flare/full, "black"),
		list("Fuel Tank Strap Pouch", round(scale * 4), /obj/item/storage/pouch/flamertank, "black"),
		list("Large Pistol Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine/pistol/large, "black"),
		list("Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine, "black"),
		list("Medical Pouch", round(scale * 2), /obj/item/storage/pouch/medical, "black"),
		list("Medium General Pouch", round(scale * 2), /obj/item/storage/pouch/general/medium, "black"),
		list("Medkit Pouch", round(scale * 2), /obj/item/storage/pouch/medkit, "black"),
		list("Sidearm Pouch", round(scale * 15), /obj/item/storage/pouch/pistol, "black"),
		list("Syringe Pouch", round(scale * 2), /obj/item/storage/pouch/syringe, "black"),
		list("Tools Pouch", round(scale * 2), /obj/item/storage/pouch/tools, "black"),

		list("Firearms", -1, null, null),
		list("M4A3 Service Pistol", round(scale * 20), /obj/item/weapon/gun/pistol/m4a3, "black"),
		list("88 Mod 4 Combat Pistol", round(scale * 15), /obj/item/weapon/gun/pistol/mod88, "black"),
		list("M44 Combat Revolver", round(scale * 10), /obj/item/weapon/gun/revolver/m44, "black"),
		list("M39 Submachinegun", round(scale * 15), /obj/item/weapon/gun/smg/m39, "black"),
		list("L42 Pulse Carbine MK1", round(scale * 20), /obj/item/weapon/gun/rifle/l42a, "black"),
		list("M41A Pulse Rifle MK2", round(scale * 20), /obj/item/weapon/gun/rifle/m41a, "black"),
		list("M37A2 Pump Shotgun", round(scale * 10), /obj/item/weapon/gun/shotgun/pump, "black"),

		list("Kits", -1, null, null),
		list("Experimental Trooper Kit", round(scale * 4), /obj/item/storage/box/kit/exp_trooper, "black"),
		list("JTAC Radio Kit", round(scale * 4), /obj/item/storage/box/kit/mini_jtac, "black"),
		list("Forward HPR Shield Kit", round(scale * 4), /obj/item/storage/box/kit/heavy_support, "black"),
		list("Field Intelligence Support Kit", round(scale * 4), /obj/item/storage/box/kit/mini_intel, "black"),
		list("M39 Point Man Kit", round(scale * 4), /obj/item/storage/box/kit/pursuit, "black"),
		list("M-OU53 Field Test Kit", round(scale * 3), /obj/item/storage/box/kit/mou53_sapper, "black"),

		list("Explosives", -1, null, null),
		list("M15 Fragmentation Grenade", round(scale * 2), /obj/item/explosive/grenade/HE/m15, "black"),
		list("M20 Claymore Anti-Personnel Mine", round(scale * 2), /obj/item/explosive/mine, "black"),
		list("M40 HEDP Grenade Box", round(scale * 2), /obj/item/storage/box/nade_box, "black"),
		list("M40 HEFA Grenade Box", round(scale * 2), /obj/item/storage/box/nade_box/frag, "black"),
		list("M40 HIDP Incendiary Grenade", round(scale * 2), /obj/item/explosive/grenade/incendiary, "black"),
		list("M40 HSDP Smoke Grenade", round(scale * 5), /obj/item/explosive/grenade/smokebomb, "black"),

		list("Miscellaneous", -1, null, null),
		list("Combat Flashlight", round(scale * 5), /obj/item/device/flashlight/combat, "black"),
		list("Entrenching Tool", round(scale * 4), /obj/item/tool/shovel/etool, "black"),
		list("Gas Mask", round(scale * 10), /obj/item/clothing/mask/gas, "black"),
		list("H5 Pattern M2132 Machete Scabbard", round(scale * 10), /obj/item/storage/large_holster/machete/full, "black"),
		list("M89-S Signal Flare Pack", round(scale * 2), /obj/item/storage/box/m94/signal, "black"),
		list("M94 Marking Flare Pack", round(scale * 10), /obj/item/storage/box/m94, "black"),
		list("MB-6 Folding Barricade", round(scale * 4), /obj/item/folding_barricade, "black"),
		)


/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad
	name = "\improper ColMarTech Automated Armaments Squad Vendor"
	desc = "An automated rack hooked up to a small supply of various firearms and explosives."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/populate_product_list(var/scale)
	listed_products = list(
		list("Backpacks", -1, null, null),
		list("Lightweight IMP Backpack", round(scale * 15), /obj/item/storage/backpack/marine, "black"),
		list("USCM Technician Welderpack", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack, "black"),

		list("Belts", -1, null, null),
		list("G8-A General Utility Pouch", round(scale * 2), /obj/item/storage/sparepouch, "black"),
		list("M276 Pattern M39 Holster Rig", round(scale * 2), /obj/item/storage/large_holster/m39, "black"),
		list("M276 Pattern M44 Holster Rig", round(scale * 5), /obj/item/storage/belt/gun/m44, "black"),
		list("M276 Pattern General Pistol Holster Rig", round(scale * 10), /obj/item/storage/belt/gun/m4a3, "black"),

		list("Webbings", -1, null, null),
		list("Brown Webbing Vest", round(scale * 2), /obj/item/clothing/accessory/storage/brown_vest, "black"),
		list("Webbing", round(scale * 3), /obj/item/clothing/accessory/storage/webbing, "black"),

		list("Pouches", -1, null, null),
		list("Construction Pouch", round(scale * 2), /obj/item/storage/pouch/construction, "black"),
		list("Document Pouch", round(scale * 2), /obj/item/storage/pouch/document/small, "black"),
		list("Explosive Pouch", round(scale * 2), /obj/item/storage/pouch/explosive, "black"),
		list("First-Aid Pouch", round(scale * 5), /obj/item/storage/pouch/firstaid/full, "black"),
		list("Flare Pouch", round(scale * 5), /obj/item/storage/pouch/flare/full, "black"),
		list("Large Pistol Magazine Pouch", round(scale * 3), /obj/item/storage/pouch/magazine/pistol/large, "black"),
		list("Magazine Pouch", round(scale * 5), /obj/item/storage/pouch/magazine, "black"),
		list("Medical Pouch", round(scale * 2), /obj/item/storage/pouch/medical, "black"),
		list("Medium General Pouch", round(scale * 2), /obj/item/storage/pouch/general/medium, "black"),
		list("Medkit Pouch", round(scale * 2), /obj/item/storage/pouch/medkit, "black"),
		list("Sidearm Pouch", round(scale * 15), /obj/item/storage/pouch/pistol, "black"),
		list("Syringe Pouch", round(scale * 2), /obj/item/storage/pouch/syringe, "black"),
		list("Tools Pouch", round(scale * 2), /obj/item/storage/pouch/tools, "black"),

		list("Kits", -1, null, null),
		list("Experimental Trooper Kit", round(scale * 1), /obj/item/storage/box/kit/exp_trooper, "black"),
		list("JTAC Radio Kit", round(scale * 1), /obj/item/storage/box/kit/mini_jtac, "black"),
		list("Forward HPR Shield Kit", round(scale * 1), /obj/item/storage/box/kit/heavy_support, "black"),
		list("Field Intelligence Support Kit", round(scale * 1), /obj/item/storage/box/kit/mini_intel, "black"),
		list("M39 Point Man Kit", round(scale * 1), /obj/item/storage/box/kit/pursuit, "black"),
		list("M-OU53 Field Test Kit", round(scale / 3), /obj/item/storage/box/kit/mou53_sapper, "black"),

		list("Explosives", -1, null, null),
		list("M15 Fragmentation Grenade", round(scale * 2), /obj/item/explosive/grenade/HE/m15, "black"),
		list("M20 Claymore Anti-Personnel Mine", round(scale * 1), /obj/item/explosive/mine, "black"),
		list("M40 HIDP Incendiary Grenade", round(scale * 1), /obj/item/explosive/grenade/incendiary, "black"),
		list("M40 HSDP Smoke Grenade", round(scale * 2), /obj/item/explosive/grenade/smokebomb, "black"),

		list("Miscellaneous", -1, null, null),
		list("Combat Flashlight", round(scale * 5), /obj/item/device/flashlight/combat, "black"),
		list("Entrenching Tool", round(scale * 2), /obj/item/tool/shovel/etool, "black"),
		list("H5 Pattern M2132 Machete Scabbard", round(scale * 5), /obj/item/storage/large_holster/machete/full, "black"),
		list("M89-S Signal Flare Pack", round(scale * 1), /obj/item/storage/box/m94/signal, "black"),
		list("MB-6 Folding Barricade", round(scale * 2), /obj/item/folding_barricade, "black"),
		)

//AMMUNITION VENDOR
/obj/structure/machinery/cm_vending/sorted/cargo_ammo
	name = "\improper ColMarTech Automated Munition Vendor"
	desc = "An automated rack hooked up to a small supply of ammo magazines."
	req_access = list(ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/New()
	..()
	cm_vending_vendors.Add(src)						//this is needed for cm_initialize and needs changing

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/populate_product_list(var/scale)
	listed_products = list(
		list("Regular Ammunition", -1, null, null),
		list("M4A3 Magazine (9mm)", round(scale * 6.1), /obj/item/ammo_magazine/pistol, "black"),
		list("M44 Speed Loader (.44)", round(scale * 5.3), /obj/item/ammo_magazine/revolver, "black"),
		list("M39 Magazine (10x20mm)", round(scale * 7.5), /obj/item/ammo_magazine/smg/m39, "black"),
		list("L42A magazine (10x24mm)", round(scale * 8), /obj/item/ammo_magazine/rifle/l42a, "black"),
		list("M41A Magazine (10x24mm)", round(scale * 7.8), /obj/item/ammo_magazine/rifle, "black"),
		list("Box Of Buckshot Shells", round(scale * 2), /obj/item/ammo_magazine/shotgun/buckshot, "black"),
		list("Box Of Flechette Shells", round(scale * 2), /obj/item/ammo_magazine/shotgun/flechette, "black"),
		list("Box Of Shotgun Slugs", round(scale * 2), /obj/item/ammo_magazine/shotgun/slugs, "black"),

		list("Armor-Piercing Ammunition", -1, null, null),
		list("88 Mod 4 AP Magazine (9mm)", round(scale * 5.5), /obj/item/ammo_magazine/pistol/mod88, "black"),
		list("M39 AP Magazine (10x20mm)", round(scale * 3.5), /obj/item/ammo_magazine/smg/m39/ap, "black"),
		list("L42A AP Magazine (10x24mm)", round(scale * 4.5), /obj/item/ammo_magazine/rifle/l42a/ap, "black"),
		list("M41A AP Magazine (10x24mm)", round(scale * 3.5), /obj/item/ammo_magazine/rifle/ap, "black"),

		list("Extended Ammunition", -1, null, null),
		list("M39 Extended Magazine (10x20mm)", round(scale * 2.5) + 3, /obj/item/ammo_magazine/smg/m39/extended, "black"),
		list("M41A Extended Magazine (10x24mm)", round(scale * 2.5), /obj/item/ammo_magazine/rifle/extended, "black"),

		list("Special Ammunition", -1, null, null),
		list("M44 Heavy Speed Loader (.44)", round(scale * 2.5), /obj/item/ammo_magazine/revolver/heavy, "black"),
		list("M44 Marksman Speed Loader (.44)", round(scale * 2.5), /obj/item/ammo_magazine/revolver/marksman, "black"),
		list("SU-6 Smartpistol Magazine (.45)", round(scale * 6), /obj/item/ammo_magazine/pistol/smart, "black"),
		list("VP78 Magazine", round(scale * 6), /obj/item/ammo_magazine/pistol/vp78, "black"),
		list("M56 Smartgun Drum", 4, /obj/item/ammo_magazine/smartgun, "black"),
		list("M56 Powerpack", 2, /obj/item/smartgun_powerpack, "black"),
		list("Incinerator Tank", round(scale * 2.5), /obj/item/ammo_magazine/flamer_tank, "black"),

		list("Ammunition Boxes", -1, null, null),
		list("SMG ammunition box (10x20mm)", round(scale * 0.9), /obj/item/ammo_box/rounds/smg, "black"),
		list("SMG ammunition box (10x20mm AP)", round(scale * 0.75), /obj/item/ammo_box/rounds/smg/ap, "black"),
		list("Rifle ammunition box (10x24mm)", round(scale * 0.9), /obj/item/ammo_box/rounds, "black"),
		list("Rifle ammunition box (10x24mm AP)", round(scale * 0.75), /obj/item/ammo_box/rounds/ap, "black"),

		list("Magazine Boxes", -1, null, null),
		list("Magazine Box (M4A3 x 16)", round(scale * 0.9), /obj/item/ammo_box/magazine/m4a3, "black"),
		list("Magazine Box (88 Mod 4 AP x 16)", round(scale * 0.7), /obj/item/ammo_box/magazine/mod88, "black"),
		list("Magazine Box (SU-6 x 16)", round(scale * 0.3), /obj/item/ammo_box/magazine/su6, "black"),
		list("Magazine Box (VP78 x 16)", round(scale * 0.2), /obj/item/ammo_box/magazine/vp78, "black"),
		list("Magazine Box (L42A x 16)", round(scale * 0.8), /obj/item/ammo_box/magazine/l42a, "black"),
		list("Magazine Box (AP L42A x 16)", round(scale * 0.7), /obj/item/ammo_box/magazine/l42a/ap, "black"),
		list("Magazine Box (M39 x 12)", round(scale * 0.8), /obj/item/ammo_box/magazine/m39, "black"),
		list("Magazine Box (AP M39 x 12)", round(scale * 0.7), /obj/item/ammo_box/magazine/m39/ap, "black"),
		list("Magazine Box (Ext m39 x 10)", round(scale * 0.7), /obj/item/ammo_box/magazine/m39/ext, "black"),
		list("Magazine Box (M41A x 10)", round(scale * 0.8), /obj/item/ammo_box/magazine, "black"),
		list("Magazine Box (AP M41A x 10)", round(scale * 0.7), /obj/item/ammo_box/magazine/ap, "black"),
		list("Magazine Box (Ext M41A x 8)", round(scale * 0.7), /obj/item/ammo_box/magazine/ext, "black"),
		list("Speed Loaders Box (M44 x 16)", round(scale * 0.8), /obj/item/ammo_box/magazine/m44, "black"),
		list("Speed Loaders Box (Marksman M44 x 16)", round(scale * 0.2), /obj/item/ammo_box/magazine/m44/marksman, "black"),
		list("Speed Loaders Box (Heavy M44 x 16)", round(scale * 0.5), /obj/item/ammo_box/magazine/m44/heavy, "black"),
		list("Shotgun Shell Box (Buckshot x 100)", round(scale * 1), /obj/item/ammo_box/magazine/shotgun/buckshot, "black"),
		list("Shotgun Shell Box (Slugs x 100)", round(scale * 1), /obj/item/ammo_box/magazine/shotgun, "black"),
		list("Shotgun Shell Box (Flechette x 100)", round(scale * 1), /obj/item/ammo_box/magazine/shotgun/flechette, "black")
		)


/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad
	name = "\improper ColMarTech Automated Munition Squad Vendor"
	desc = "An automated rack hooked up to a small supply of ammo magazines."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/populate_product_list(var/scale)
	listed_products = list(

		list("Armor-Piercing Ammunition", -1, null, null),
		list("M39 AP Magazine (10x20mm)", round(scale * 3), /obj/item/ammo_magazine/smg/m39/ap, "black"),
		list("L42A AP Magazine (10x24mm)", round(scale * 3.5), /obj/item/ammo_magazine/rifle/l42a/ap, "black"),
		list("M41A AP Magazine (10x24mm)", round(scale * 3), /obj/item/ammo_magazine/rifle/ap, "black"),

		list("Extended Ammunition", -1, null, null),
		list("M39 Extended Magazine (10x20mm)", round(scale * 1.8), /obj/item/ammo_magazine/smg/m39/extended, "black"),
		list("M41A Extended Magazine (10x24mm)", round(scale * 1.9), /obj/item/ammo_magazine/rifle/extended, "black"),

		list("Special Ammunition", -1, null, null),
		list("M44 Heavy Speed Loader (.44)", round(scale * 2), /obj/item/ammo_magazine/revolver/heavy, "black"),
		list("M44 Marksman Speed Loader (.44)", round(scale * 2), /obj/item/ammo_magazine/revolver/marksman, "black"),
		list("SU-6 Smartpistol Magazine (.45)", round(scale * 3), /obj/item/ammo_magazine/pistol/smart, "black"),
		list("VP78 Magazine", round(scale * 3), /obj/item/ammo_magazine/pistol/vp78, "black"),
		list("M56 Smartgun Drum", 1, /obj/item/ammo_magazine/smartgun, "black"),
		list("Incinerator Tank", round(scale * 1.5), /obj/item/ammo_magazine/flamer_tank, "black"),
		)

//ATTACHMENTS VENDOR
/obj/structure/machinery/cm_vending/sorted/attachments
	name = "\improper Armat Systems Attachments Vendor"
	desc = "A subsidiary-owned vendor of weapon attachments. This can only be accessed by the Requisitions Officer and Cargo Techs."
	req_access = list(ACCESS_MARINE_CARGO)
	icon_state = "attach_vend"

/obj/structure/machinery/cm_vending/sorted/attachments/New()
	..()
	cm_vending_vendors.Add(src)						//this is needed for cm_initialize and needs changing

/obj/structure/machinery/cm_vending/sorted/attachments/populate_product_list(var/scale)
	listed_products = list(
		list("Muzzle", -1, null, null),
		list("M5 Bayonet", round(scale * 10.5), /obj/item/attachable/bayonet, "black"),
		list("Barrel Charger", round(scale * 2.5), /obj/item/attachable/heavy_barrel, "black"),
		list("Extended Barrel", round(scale * 6.5), /obj/item/attachable/extended_barrel, "black"),
		list("Recoil Compensator", round(scale * 6.5), /obj/item/attachable/compensator, "black"),
		list("Suppressor", round(scale * 6.5), /obj/item/attachable/suppressor, "black"),

		list("Rail", -1, null, null),
		list("B8 Smart-Scope", round(scale * 3.5), /obj/item/attachable/scope/mini_iff, "black"),
		list("Magnetic Harness", round(scale * 6.5), /obj/item/attachable/magnetic_harness, "black"),
		list("Quickfire Adapter", round(scale * 4.5), /obj/item/attachable/quickfire, "black"),
		list("Rail Flashlight", round(scale * 10.5), /obj/item/attachable/flashlight, "black"),
		list("S4 2x Telescopic Mini-Scope", round(scale * 4.5), /obj/item/attachable/scope/mini, "black"),
		list("S5 Red-Dot Sight", round(scale * 9.5), /obj/item/attachable/reddot, "black"),
		list("S6 Reflex Sight", round(scale * 9.5), /obj/item/attachable/reflex, "black"),
		list("S8 4x Telescopic Scope", round(scale * 4.5), /obj/item/attachable/scope, "black"),

		list("Underbarrel", -1, null, null),
		list("Angled Grip", round(scale * 6.5), /obj/item/attachable/angledgrip, "black"),
		list("Bipod", round(scale * 6.5), /obj/item/attachable/bipod, "black"),
		list("Burst Fire Assembly", round(scale * 4.5), /obj/item/attachable/burstfire_assembly, "black"),
		list("Gyroscopic Stabilizer", round(scale * 4.5), /obj/item/attachable/gyro, "black"),
		list("Laser Sight", round(scale * 9.5), /obj/item/attachable/lasersight, "black"),
		list("Mini Flamethrower", round(scale * 4.5), /obj/item/attachable/attached_gun/flamer, "black"),
		list("U7 Underbarrel Shotgun", round(scale * 4.5), /obj/item/attachable/attached_gun/shotgun, "black"),
		list("Underslung Grenade Launcher", round(scale * 9.5), /obj/item/attachable/attached_gun/grenade, "black"),
		list("Underbarrel Flashlight Grip", round(scale * 9.5), /obj/item/attachable/flashlight/grip, "black"),
		list("Vertical Grip", round(scale * 9.5), /obj/item/attachable/verticalgrip, "black"),

		list("Stock", -1, null, null),
		list("L42 Synthetic Stock", round(scale * 4.5), /obj/item/attachable/stock/carbine, "black"),
		list("M37 Wooden Stock", round(scale * 4.5), /obj/item/attachable/stock/shotgun, "black"),
		list("M41A Skeleton Stock", round(scale * 4.5), /obj/item/attachable/stock/rifle, "black"),
		list("M44 Magnum Sharpshooter Stock", round(scale * 4.5), /obj/item/attachable/stock/revolver, "black"),
		list("Submachinegun Arm Brace", round(scale * 4.5), /obj/item/attachable/stock/smg/brace, "black"),
		list("Submachinegun Folding Stock", round(scale * 4.5), /obj/item/attachable/stock/smg/collapsible, "black"),
		list("Submachinegun Stock", round(scale * 4.5), /obj/item/attachable/stock/smg, "black"),
		)

/obj/structure/machinery/cm_vending/sorted/attachments/get_appropriate_vend_turf(mob/living/carbon/human/H)
	var/turf/T = get_turf(get_step(src, NORTHEAST))
	if(H.loc == T)
		T = get_turf(get_step(src, NORTH))
	else
		T = get_turf(get_step(src, SOUTHEAST))
		if(H.loc == T)
			T = get_turf(get_step(src, SOUTH))
		else
			T = get_turf(src)
	return T



/obj/structure/machinery/cm_vending/sorted/attachments/squad
	name = "\improper Armat Systems Squad Attachments Vendor"
	desc = "An attachment vendor made specifically for squads. Can be accessed by Squad Leaders and Squad Specialists."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	icon_state = "attach_vend"

/obj/structure/machinery/cm_vending/sorted/attachments/squad/populate_product_list(var/scale)
	listed_products = list(
		list("Muzzle", -1, null, null),
		list("Barrel Charger", round(scale * 0.9), /obj/item/attachable/heavy_barrel, "black"),
		list("Extended Barrel", round(scale * 2.5), /obj/item/attachable/extended_barrel, "black"),
		list("Recoil Compensator", round(scale * 2.5), /obj/item/attachable/compensator, "black"),
		list("Suppressor", round(scale * 2.5), /obj/item/attachable/suppressor, "black"),

		list("Rail", -1, null, null),
		list("B8 Smart-Scope", round(scale * 1.5), /obj/item/attachable/scope/mini_iff, "black"),
		list("Magnetic Harness", round(scale * 3), /obj/item/attachable/magnetic_harness, "black"),
		list("Quickfire Adapter", round(scale * 2.5), /obj/item/attachable/quickfire, "black"),
		list("S4 2x Telescopic Mini-Scope", round(scale * 2), /obj/item/attachable/scope/mini, "black"),
		list("S5 Red-Dot Sight", round(scale * 3), /obj/item/attachable/reddot, "black"),
		list("S6 Reflex Sight", round(scale * 3), /obj/item/attachable/reflex, "black"),
		list("S8 4x Telescopic Scope", round(scale * 2), /obj/item/attachable/scope, "black"),

		list("Underbarrel", -1, null, null),
		list("Angled Grip", round(scale * 2.5), /obj/item/attachable/angledgrip, "black"),
		list("Bipod", round(scale * 2.5), /obj/item/attachable/bipod, "black"),
		list("Burst Fire Assembly", round(scale * 1.5), /obj/item/attachable/burstfire_assembly, "black"),
		list("Gyroscopic Stabilizer", round(scale * 1.5), /obj/item/attachable/gyro, "black"),
		list("Laser Sight", round(scale * 3), /obj/item/attachable/lasersight, "black"),
		list("Mini Flamethrower", round(scale * 1.5), /obj/item/attachable/attached_gun/flamer, "black"),
		list("U7 Underbarrel Shotgun", round(scale * 1.5), /obj/item/attachable/attached_gun/shotgun, "black"),
		list("Vertical Grip", round(scale * 3), /obj/item/attachable/verticalgrip, "black"),

		list("Stock", -1, null, null),
		list("L42 Synthetic Stock", round(scale * 1.5), /obj/item/attachable/stock/carbine, "black"),
		list("M37 Wooden Stock", round(scale * 1.5), /obj/item/attachable/stock/shotgun, "black"),
		list("M41A Skeleton Stock", round(scale * 1.5), /obj/item/attachable/stock/rifle, "black"),
		list("M44 Magnum Sharpshooter Stock", round(scale * 1.5), /obj/item/attachable/stock/revolver, "black"),
		list("Submachinegun Arm Brace", round(scale * 1.5), /obj/item/attachable/stock/smg/brace, "black"),
		list("Submachinegun Stock", round(scale * 1.5), /obj/item/attachable/stock/smg, "black"),
		)

/obj/structure/machinery/cm_vending/sorted/attachments/squad/get_appropriate_vend_turf(mob/living/carbon/human/H)
	return get_step(src, NORTH)


//UNIFORM VENDOR
obj/structure/machinery/cm_vending/sorted/uniform_supply
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a colossal storage of uniforms. This can only be accessed by the Requisitions Officer and Cargo Techs."
	icon_state = "uniform_marine"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_CARGO)
	auto_equip = TRUE

	listed_products = list(
		list("Miscellaneous", -1, null, null),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, "black"),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, "black"),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, "black"),
		list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, "black"),
		list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, "black"),
		list("Lightweight IMP Backpack", 20, /obj/item/storage/backpack/marine, "black"),
		list("USCM Satchel", 20, /obj/item/storage/backpack/marine/satchel, "black"),
		list("Armor", -1, null, null),
		list("M3 Pattern Padded Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padded, "black"),
		list("M3 Pattern Padless Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless, "black"),
		list("M3 Pattern Ridged Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless_lines, "black"),
		list("M3 Pattern Carrier Marine Armor", 20, /obj/item/clothing/suit/storage/marine/carrier, "black"),
		list("M3 Pattern Skull Marine Armor", 20, /obj/item/clothing/suit/storage/marine/skull, "black"),
		list("M3-H Pattern Heavy Armor", 10, /obj/item/clothing/suit/storage/marine/class/heavy, "black"),
		list("M3-L Pattern Light Armor", 10, /obj/item/clothing/suit/storage/marine/class/light, "black"),
		list("M10 Pattern Marine Helmet", 20, /obj/item/clothing/head/helmet/marine, "black"),
		list("Gloves", -1, null, null),
		list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, "black"),
		list("Alpha Squad Gloves", 10, /obj/item/clothing/gloves/marine/alpha, "black"),
		list("Bravo Squad Gloves", 10, /obj/item/clothing/gloves/marine/bravo, "black"),
		list("Charlie Squad Gloves", 10, /obj/item/clothing/gloves/marine/charlie, "black"),
		list("Delta Squad Gloves", 10, /obj/item/clothing/gloves/marine/delta, "black"),
		list("Radio", -1, null, null),
		list("Marine Radio Headset", 5, /obj/item/device/radio/headset/almayer, "black"),
		list("Alpha Squad radio encryption key", 5, /obj/item/device/encryptionkey/alpha, "black"),
		list("Bravo Squad radio encryption key", 5, /obj/item/device/encryptionkey/bravo, "black"),
		list("Charlie Squad radio encryption key", 5, /obj/item/device/encryptionkey/charlie, "black"),
		list("Delta Squad radio encryption key", 5, /obj/item/device/encryptionkey/delta, "black"),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, "black"),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, "black"),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, "black")
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/populate_product_list(var/scale)
	return


/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a colossal storage of uniforms."
	req_access = list()
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_CARGO)

	listed_products = list()

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad/New()
	..()
	listed_products = list(
		list("Uniform", -1, null, null),
		list("USCM Uniform", 20, /obj/item/clothing/under/marine, "black"),
		list("Marine Combat Boots", 20, /obj/item/clothing/shoes/marine, "black")
	)

	if(req_access.len)
		switch(req_access[1])
			if(ACCESS_MARINE_ALPHA)
				listed_products += list(list("Alpha Squad Gloves", 10, /obj/item/clothing/gloves/marine/alpha, "black"),
										list("Marine Alpha Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/alpha, "black"))
			if(ACCESS_MARINE_BRAVO)
				listed_products += list(list("Bravo Squad Gloves", 10, /obj/item/clothing/gloves/marine/bravo, "black"),
										list("Marine Bravo Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/bravo, "black"))
			if(ACCESS_MARINE_CHARLIE)
				listed_products += list(list("Charlie Squad Gloves", 10, /obj/item/clothing/gloves/marine/charlie, "black"),
										list("Marine Charlie Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/charlie, "black"))
			if(ACCESS_MARINE_DELTA)
				listed_products += list(list("Delta Squad Gloves", 10, /obj/item/clothing/gloves/marine/delta, "black"),
										list("Marine Delta Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/delta, "black"))
	else
		listed_products += list(list("Marine Combat Gloves", 10, /obj/item/clothing/gloves/marine, "black"),
								list("Marine Radio Headset", 10, /obj/item/device/radio/headset/almayer, "black"))


	listed_products += list(list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, "black"),
							list("M276 Pattern Ammo Load Rig", 10, /obj/item/storage/belt/marine, "black"),
							list("M276 Pattern Shotgun Shell Loading Rig", 10, /obj/item/storage/belt/shotgun, "black"),
							list("M276 Pattern M39 Holster Rig", 10, /obj/item/storage/large_holster/m39, "black"),
							list("M276 Pattern M44 Holster Rig", 10, /obj/item/storage/belt/gun/m44, "black"),
							list("M276 Pattern General Pistol Holster Rig", 10, /obj/item/storage/belt/gun/m4a3, "black"),
							list("Lightweight IMP Backpack", 10, /obj/item/storage/backpack/marine, "black"),
							list("USCM Satchel", 10, /obj/item/storage/backpack/marine/satchel, "black"),
							list("Armor", -1, null, null),
							list("M3 Pattern Padded Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padded, "black"),
							list("M3 Pattern Padless Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless, "black"),
							list("M3 Pattern Ridged Marine Armor", 20, /obj/item/clothing/suit/storage/marine/padless_lines, "black"),
							list("M3 Pattern Carrier Marine Armor", 20, /obj/item/clothing/suit/storage/marine/carrier, "black"),
							list("M3 Pattern Skull Marine Armor", 20, /obj/item/clothing/suit/storage/marine/skull, "black"),
							list("M3 Pattern Smooth Marine Armor", 20, /obj/item/clothing/suit/storage/marine/smooth, "black"),
							list("M3-H Pattern Heavy Armor", 10, /obj/item/clothing/suit/storage/marine/class/heavy, "black"),
							list("M3-L Pattern Light Armor", 10, /obj/item/clothing/suit/storage/marine/class/light, "black"),
							list("M10 Pattern Marine Helmet", 20, /obj/item/clothing/head/helmet/marine, "black"),
							list("Gas Mask", 20, /obj/item/clothing/mask/gas, "black")
							)

//SQUAD PREP WEAPON RACKS.
/obj/structure/machinery/cm_vending/sorted/marine_prep
	name = "\improper ColMarTech Automated Weapons Rack"
	desc = "A automated weapon rack hooked up to a colossal storage of standard-issue weapons."
	icon_state = "armory"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_LOGISTICS, ACCESS_MARINE_PREP, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/marine_prep/New()
	..()
	cm_vending_vendors.Add(src)//this is needed for cm_initialize and needs changing

/obj/structure/machinery/cm_vending/sorted/marine_prep/populate_product_list(var/scale)
	listed_products = list(
		list("Firearms", -1, null, null),
		list("M41A Pulse Rifle MK2", round(scale * 30), /obj/item/weapon/gun/rifle/m41a, "black"),
		list("L42A Battle Rifle", round(scale * 10), /obj/item/weapon/gun/rifle/l42a, "black"),
		list("M39 Submachine Gun", round(scale * 30), /obj/item/weapon/gun/smg/m39, "black"),
		list("M37A2 Pump Shotgun", round(scale * 15), /obj/item/weapon/gun/shotgun/pump, "black"),

		list("Primary Ammunition", -1, null, null),
		list("M41A Magazine (10x24mm)", round(scale * 25), /obj/item/ammo_magazine/rifle, "black"),
		list("L42A Magazine (10x24mm)", round(scale * 15), /obj/item/ammo_magazine/rifle/l42a, "black"),
		list("M39 Magazine (10x20mm)", round(scale * 25), /obj/item/ammo_magazine/smg/m39, "black"),
		list("Box of shotgun slugs (12g)", round(scale * 10), /obj/item/ammo_magazine/shotgun/slugs, "black"),
		list("Box of buckshot shells (12g)", round(scale * 10), /obj/item/ammo_magazine/shotgun/buckshot, "black"),
		list("Box of flechette shells (12g)", round(scale * 4), /obj/item/ammo_magazine/shotgun/flechette, "black"),

		list("Sidearms", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/mod88, "black"),
		list("M44 Combat Revolver", round(scale * 25), /obj/item/weapon/gun/revolver/m44, "black"),
		list("M4A3 Service Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/m4a3, "black"),

		list("Sidearm Ammunition", -1, null, null),
		list("88M4 AP Magazine (9mm)", round(scale * 25), /obj/item/ammo_magazine/pistol/mod88, "black"),
		list("M44 Speedloader (.44)", round(scale * 20), /obj/item/ammo_magazine/revolver, "black"),
		list("M4A3 Magazine (9mm)", round(scale * 25), /obj/item/ammo_magazine/pistol, "black"),

		list("Attachments", -1, null, null),
		list("Rail Flashlight", round(scale * 25), /obj/item/attachable/flashlight, "black"),
		list("Underbarrel Flashlight Grip", round(scale * 10), /obj/item/attachable/flashlight/grip, "black"),
		list("Underslung Grenade Launcher", round(scale * 25), /obj/item/attachable/attached_gun/grenade, "black"), //They already get these as on-spawns, might as well formalize some spares.
		list("M39 Folding Stock", round(scale * 10), /obj/item/attachable/stock/smg/collapsible, "black"),
		list("L42 Synthetic Stock", round(scale * 10), /obj/item/attachable/stock/carbine, "black"),

		list("Utilities", -1, null, null),
		list("M5 Bayonet", round(scale * 25), /obj/item/attachable/bayonet, "black"),
		list("M11 Throwing Knife", round(scale * 10), /obj/item/weapon/throwing_knife, "black"),
		list("M94 Marking Flare Pack", round(scale * 10), /obj/item/storage/box/m94, "black"),
	)


//SMALL PREP WEAPON RACKS.
//For IOs, possibly for POs and other groundside officers later
/obj/structure/machinery/cm_vending/sorted/marine_prep/small
	name = "\improper ColMarTech Small Automated Weapons Rack"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_CARGO, ACCESS_MARINE_BRIDGE)

/obj/structure/machinery/cm_vending/sorted/marine_prep/small/populate_product_list(var/scale)
	listed_products = list(
		list("Firearms", -1, null, null),
		list("M41A Pulse Rifle MK2", round(scale * 15), /obj/item/weapon/gun/rifle/m41a, "black"),
		list("L42A Battle Rifle", round(scale * 5), /obj/item/weapon/gun/rifle/l42a, "black"),
		list("M39 Submachine Gun", round(scale * 15), /obj/item/weapon/gun/smg/m39, "black"),
		list("M37A2 Pump Shotgun", round(scale * 7), /obj/item/weapon/gun/shotgun/pump, "black"),

		list("Primary Ammunition", -1, null, null),
		list("M41A Magazine (10x24mm)", round(scale * 12), /obj/item/ammo_magazine/rifle, "black"),
		list("L42A Magazine (10x24mm)", round(scale * 7), /obj/item/ammo_magazine/rifle/l42a, "black"),
		list("M39 Magazine (10x20mm)", round(scale * 12), /obj/item/ammo_magazine/smg/m39, "black"),
		list("Box of shotgun slugs (12g)", round(scale * 5), /obj/item/ammo_magazine/shotgun/slugs, "black"),
		list("Box of buckshot shells (12g)", round(scale * 5), /obj/item/ammo_magazine/shotgun/buckshot, "black"),
		list("Box of flechette shells (12g)", round(scale * 2), /obj/item/ammo_magazine/shotgun/flechette, "black"),

		list("Sidearms", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 12), /obj/item/weapon/gun/pistol/mod88, "black"),
		list("M44 Combat Revolver", round(scale * 12), /obj/item/weapon/gun/revolver/m44, "black"),
		list("M4A3 Service Pistol", round(scale * 12), /obj/item/weapon/gun/pistol/m4a3, "black"),

		list("Sidearm Ammunition", -1, null, null),
		list("88M4 AP Magazine (9mm)", round(scale * 12), /obj/item/ammo_magazine/pistol/mod88, "black"),
		list("M44 Speedloader (.44)", round(scale * 10), /obj/item/ammo_magazine/revolver, "black"),
		list("M4A3 Magazine (9mm)", round(scale * 12), /obj/item/ammo_magazine/pistol, "black"),

		list("Attachments", -1, null, null),
		list("Rail Flashlight", round(scale * 12), /obj/item/attachable/flashlight, "black"),
		list("Underbarrel Flashlight Grip", round(scale * 5), /obj/item/attachable/flashlight/grip, "black"),
		list("Underslung Grenade Launcher", round(scale * 12), /obj/item/attachable/attached_gun/grenade, "black"), //They already get these as on-spawns, might as well formalize some spares.
		list("M39 Folding Stock", round(scale * 5), /obj/item/attachable/stock/smg/collapsible, "black"),
		list("L42 Synthetic Stock", round(scale * 5), /obj/item/attachable/stock/carbine, "black"),

		list("Utilities", -1, null, null),
		list("M5 Bayonet", round(scale * 12), /obj/item/attachable/bayonet, "black"),
		list("M11 Throwing Knife", round(scale * 5), /obj/item/weapon/throwing_knife, "black"),
		list("M94 Marking Flare pack", round(scale * 5), /obj/item/storage/box/m94, "black")
	)


// Medical vendors
/obj/structure/machinery/cm_vending/sorted/medical
	name = "\improper WestonMed Plus"
	desc = "Medical Pharmaceutical dispenser. Provided by Weston-Yamada Pharmaceuticals Division(TM)."
	icon_state = "med"
	req_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_CHEMISTRY)
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/medical/New()
	..()
	cm_vending_vendors.Add(src)//this is needed for cm_initialize and needs changing

/obj/structure/machinery/cm_vending/sorted/medical/populate_product_list(var/scale)
	listed_products = list(
		list("Autoinjectors", -1, null, null),
		list("Bicaridine autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/bicaridine, "black"),
		list("Dexalin Plus autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/dexalinp, "black"),
		list("Epinephrine autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/adrenaline, "black"),
		list("Inaprovaline autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, "black"),
		list("Kelotane autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/kelotane, "black"),
		list("Oxycodone autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/oxycodone, "black"),
		list("Quick Clot autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/quickclot, "black"),
		list("Suxamorycin autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/suxamorycin, "black"),
		list("Tramadol autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/tramadol, "black"),
		list("Tricordrazine autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/tricordrazine, "black"),

		list("Bottles", -1, null, null),
		list("Bicaridine bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/bicaridine, "black"),
		list("Dylovene bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/antitoxin, "black"),
		list("Dexalin bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/dexalin, "black"),
		list("Inaprovaline bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/inaprovaline, "black"),
		list("Kelotane bottle", round(scale * 5), 	/obj/item/reagent_container/glass/bottle/kelotane, "black"),
		list("Oxycodone bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/oxycodone, "black"),
		list("Peridaxon bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/peridaxon, "black"),
		list("Suxamorycin bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/suxamorycin, "black"),
		list("Tramadol bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/tramadol, "black"),

		list("Devices", -1, null, null),
		list("Emergency defibrillator", round(scale * 3), /obj/item/device/defibrillator, "black"),
		list("Health Analyzer", round(scale * 5), /obj/item/device/healthanalyzer, "black"),

		list("Equipment", -1, null, null),
		list("M276 pattern medical storage rig", round(scale * 2), /obj/item/storage/belt/medical, "black"),
		list("Medical HUD Glasses", round(scale * 3), /obj/item/clothing/glasses/hud/health, "black"),
	
		list("Field Supplies", -1, null, null),
		list("Advanced burn kit", round(scale * 7), /obj/item/stack/medical/advanced/ointment, "black"),
		list("Advanced trauma kit", round(scale * 7), /obj/item/stack/medical/advanced/bruise_pack, "black"),
		list("Hypospray", round(scale * 2), /obj/item/reagent_container/hypospray, "black"),
		list("Ointment", round(scale * 7), /obj/item/stack/medical/ointment, "black"),
		list("Roll of gauze", round(scale * 7), /obj/item/stack/medical/bruise_pack, "black"),
		list("Splints", round(scale * 7), /obj/item/stack/medical/splint, "black"),
		list("Stasis bag", round(scale * 2), /obj/item/bodybag/cryobag, "black"),
		list("Syringe", round(scale * 7), /obj/item/reagent_container/syringe, "black")
	)

/obj/structure/machinery/cm_vending/sorted/medical/chemistry
	name = "\improper WestonChem Plus"
	desc = "Medical chemistry dispenser. Provided by Weston-Yamada Pharmaceuticals Division(TM)."

/obj/structure/machinery/cm_vending/sorted/medical/chemistry/populate_product_list(var/scale)
	listed_products = list(
		list("Bottles", -1, null, null),
		list("Bicaridine bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/bicaridine, "black"),
		list("Dylovene bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/antitoxin, "black"),
		list("Dexalin bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/dexalin, "black"),
		list("Inaprovaline bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/inaprovaline, "black"),
		list("Kelotane bottle", round(scale * 5), 	/obj/item/reagent_container/glass/bottle/kelotane, "black"),
		list("Oxycodone bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/oxycodone, "black"),
		list("Peridaxon bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/peridaxon, "black"),
		list("Suxamorycin bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/suxamorycin, "black"),
		list("Tramadol bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/tramadol, "black"),

		list("Field Supplies", -1, null, null),
		list("Beaker (60 units)", round(scale * 3), /obj/item/reagent_container/glass/beaker, "black"),
		list("Beaker, Large (120 units)", round(scale * 3), /obj/item/reagent_container/glass/beaker/large, "black"),
		list("Box of pill bottles", round(scale * 2), /obj/item/storage/box/pillbottles, "black"),
		list("Dropper", round(scale * 3), /obj/item/reagent_container/dropper, "black"),
		list("Syringe", round(scale * 7), /obj/item/reagent_container/syringe, "black")
	)

/obj/structure/machinery/cm_vending/sorted/medical/antag
	name = "Medical Equipment Vendor"
	desc = "A vending machine dispensing various pieces of medical equipment."
	req_access = list(ACCESS_ILLEGAL_PIRATE)

/obj/structure/machinery/cm_vending/sorted/medical/marinemed
	name = "\improper MarineMed"
	icon_state = "marinemed"
	req_access = list()

/obj/structure/machinery/cm_vending/sorted/medical/marinemed/populate_product_list(var/scale)
	listed_products = list(
		list("Autoinjectors", -1, null, null),
		list("First-aid autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/skillless, "black"),
		list("Pain-stop autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, "black"),
		
		list("Devices", -1, null, null),
		list("Health Analyzer", round(scale * 3), /obj/item/device/healthanalyzer, "black"),
	
		list("Field Supplies", -1, null, null),
		list("Fire extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, "black"),
		list("Ointment", round(scale * 7), /obj/item/stack/medical/ointment, "black"),
		list("Roll of gauze", round(scale * 7), /obj/item/stack/medical/bruise_pack, "black"),
		list("Splints", round(scale * 7), /obj/item/stack/medical/splint, "black")
	)

/obj/structure/machinery/cm_vending/sorted/medical/marinemed/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)

/obj/structure/machinery/cm_vending/sorted/medical/blood
	name = "\improper MM Blood Dispenser"
	desc = "Marine Med brand Blood Pack Dispensery"
	icon_state = "bloodvendor"
	wrenchable = FALSE

/obj/structure/machinery/cm_vending/sorted/medical/blood/populate_product_list(var/scale)
	listed_products = list(
		list("Blood types", -1, null, null),
		list("A+ blood pack", 5, /obj/item/reagent_container/blood/APlus, "black"),
		list("A- blood pack", 5, /obj/item/reagent_container/blood/AMinus, "black"),
		list("B+ blood pack", 5, /obj/item/reagent_container/blood/BPlus, "black"),
		list("B- blood pack", 5, /obj/item/reagent_container/blood/BMinus, "black"),
		list("O+ blood pack", 5, /obj/item/reagent_container/blood/OPlus, "black"),
		list("O- blood pack", 5, /obj/item/reagent_container/blood/OMinus, "black"),

		list("Miscellaneous", -1, null, null),
		list("Empty blood pack", 5, /obj/item/reagent_container/blood, "black")
	)

#undef MARINE_CAN_BUY_UNIFORM
#undef MARINE_CAN_BUY_SHOES
#undef MARINE_CAN_BUY_HELMET
#undef MARINE_CAN_BUY_ARMOR
#undef MARINE_CAN_BUY_GLOVES
#undef MARINE_CAN_BUY_EAR
#undef MARINE_CAN_BUY_BACKPACK
#undef MARINE_CAN_BUY_R_POUCH
#undef MARINE_CAN_BUY_L_POUCH
#undef MARINE_CAN_BUY_BELT
#undef MARINE_CAN_BUY_GLASSES
#undef MARINE_CAN_BUY_MASK
#undef MARINE_CAN_BUY_ESSENTIALS
#undef MARINE_CAN_BUY_MRE
#undef MARINE_CAN_BUY_ACCESSORY

#undef MARINE_CAN_BUY_ALL
#undef MARINE_TOTAL_BUY_POINTS
