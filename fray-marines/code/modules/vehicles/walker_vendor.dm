GLOBAL_LIST_INIT(cm_vending_walker, list(
	list("WEAPONS (choose 2)", 0, null, null, null),
	list("M56 Double-Barrel Mounted Smartgun", 0, /obj/item/walker_gun/smartgun, MECH_GUN, VENDOR_ITEM_REGULAR),
	list("M30 Machine Gun", 0, /obj/item/walker_gun/hmg, MECH_GUN, VENDOR_ITEM_REGULAR),
	list("F40 \"Hellfire\" Flamethower", 0, /obj/item/walker_gun/flamer, MECH_GUN, VENDOR_ITEM_REGULAR),

	list("AMMUNITION", 0, null, null, null),
	list("M56 Magazine", 1, /obj/item/ammo_magazine/walker/smartgun, null, VENDOR_ITEM_REGULAR),
	list("M30 Magazine", 2, /obj/item/ammo_magazine/walker/hmg, null, VENDOR_ITEM_REGULAR),
	list("F40 UT-Napthal Canister", 2, /obj/item/ammo_magazine/walker/flamer, null, VENDOR_ITEM_REGULAR),
	list("F40 UT-Napthal EX-type Canister", 3, /obj/item/ammo_magazine/walker/flamer/ex, null, VENDOR_ITEM_REGULAR),
	list("F40 UT-Napthal B-type Canister", 3, /obj/item/ammo_magazine/walker/flamer/btype, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/walker
	name = "ColMarTech Automated Mech Vendor"
	desc = "This vendor is connected to main ship storage, allows to fetch one hardpoint module per category for free."
	icon_state = "engi"

	req_access = list(ACCESS_MARINE_WALKER)
	vendor_role = list(JOB_WALKER) //everyone else, mind your business
	var/available_categories = MECH_ALL_AVAIBALE

	unslashable = TRUE

	vend_delay = 4 SECONDS
	vend_sound = 'sound/machines/medevac_extend.ogg'

	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_TO_HAND|VEND_USE_VENDOR_FLAGS

/obj/structure/machinery/cm_vending/gear/walker/tip_over() //we don't do this here
	return

/obj/structure/machinery/cm_vending/gear/walker/flip_back()
	return

/obj/structure/machinery/cm_vending/gear/walker/get_listed_products(mob/user)
	var/list/display_list = list()

	display_list = GLOB.cm_vending_walker

	return display_list

/obj/structure/machinery/cm_vending/gear/walker/ui_data(mob/user)
	. = list()
	. += ui_static_data(user)

	.["current_m_points"] = supply_controller.mech_points

	var/list/ui_listed_products = get_listed_products(user)
	var/list/stock_values = list()
	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/avail_flag = myprod[4]
		if(supply_controller.mech_points >= p_cost && (!avail_flag || ((avail_flag in available_categories) && (available_categories[avail_flag]))))
			prod_available = TRUE
		stock_values += list(prod_available)

	.["stock_listing"] = stock_values

/obj/structure/machinery/cm_vending/gear/walker/handle_points(mob/living/carbon/human/H, list/L)
	. = TRUE
	if(L[4] != null)
		if(!(L[4] in available_categories))
			return FALSE
		if(!(available_categories[L[4]]))
			return FALSE
		if(supply_controller.mech_points < L[2])
			return FALSE
		else
			available_categories[L[4]] -= 1
			supply_controller.mech_points -= L[2]
	else
		if(supply_controller.mech_points < L[2])
			return FALSE
		else
			supply_controller.mech_points -= L[2]
