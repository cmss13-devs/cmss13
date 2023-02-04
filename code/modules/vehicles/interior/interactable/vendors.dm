
//----------------------MEDVENDORS--------------------

//Vehicle version of NanoMed
/obj/structure/machinery/cm_vending/sorted/medical/wall_med/vehicle
	name = "Vehicle NanoMed"
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "nanomed"
	desc = "A wall-mounted vendor containing medical supplies vital to survival."

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	hackable = FALSE

	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,
	)
	stack_refill = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
	)

//MED APC version of WY Med, provides resupply for basic stuff. Provides a decent amount of cryobags for evacuating hugged marines.
/obj/structure/machinery/cm_vending/sorted/medical/vehicle
	name = "\improper Wey-Med Resupply Station"
	desc = "A more compact vehicle version of the widely known Wey-Med Plus Medical Pharmaceutical dispenser. Designed to be a field resupply station for medical personnel. Provided by Wey-Yu Pharmaceuticals Division(TM)."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "med"

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	wrenchable = FALSE
	hackable = FALSE
	density = FALSE

	req_access = list()

	healthscan = TRUE
	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/bicaridine,
		/obj/item/reagent_container/hypospray/autoinjector/dexalinp,
		/obj/item/reagent_container/hypospray/autoinjector/adrenaline,,
		/obj/item/reagent_container/hypospray/autoinjector/inaprovaline,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane,
		/obj/item/reagent_container/hypospray/autoinjector/oxycodone,
		/obj/item/reagent_container/hypospray/autoinjector/quickclot,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol,
		/obj/item/reagent_container/hypospray/autoinjector/tricord,
		/obj/item/reagent_container/hypospray/autoinjector/emergency,
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,

		/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless,
		)

	stack_refill = list(
		/obj/item/stack/medical/advanced/ointment,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint,
	)

/obj/structure/machinery/cm_vending/sorted/medical/vehicle/populate_product_list(scale)
	listed_products = list(
		list("FIELD SUPPLIES", -1, null, null),
		list("Advanced Burn Kit", round(scale * 4), /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("Advanced Trauma Kit", round(scale * 4), /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", round(scale * 5), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", round(scale * 5), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", round(scale * 5), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", -1, null, null),
		list("Autoinjector (Bicaridine)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/bicaridine, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/dexalinp, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/adrenaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/kelotane, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/oxycodone, VENDOR_ITEM_REGULAR),
		list("Autoinjector (QuickClot)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/quickclot, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/tramadol, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", round(scale * 3), /obj/item/reagent_container/hypospray/autoinjector/tricord, VENDOR_ITEM_REGULAR),

		list("MEDICAL UTILITIES", -1, null, null),
		list("Surgical Line", round(scale * 2), /obj/item/tool/surgery/surgical_line, VENDOR_ITEM_REGULAR),
		list("Synth-Graft", round(scale * 2), /obj/item/tool/surgery/synthgraft, VENDOR_ITEM_REGULAR),
		list("Health Analyzer", round(scale * 4), /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", round(scale * 6), /obj/item/bodybag/cryobag, VENDOR_ITEM_REGULAR),
		list("Syringe", round(scale * 3), /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

//MED APC version of Blood Dispenser
/obj/structure/machinery/cm_vending/sorted/medical/blood/vehicle
	name = "\improper MM Blood Dispenser"
	desc = "A Marine Med brand Blood Pack Dispenser for vehicles."
	icon = 'icons/obj/vehicles/interiors/general.dmi'

	req_access = list()

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	wrenchable = FALSE
	hackable = FALSE
	density = FALSE

//----------------------SUPPLY VENDORS--------------------

//Combined vehicle version of req guns and ammo vendors. Starts, basically, empty, but can become a resupply point if marines bother to stock it with ammo and weapons.
/obj/structure/machinery/cm_vending/sorted/vehicle_supply
	name = "\improper ColMarTech Automated Supply Vendor"
	desc = "An automated supply rack hooked up to a vehicle storage of various firearms, explosives and ammunition types. Used for storing and transporting supplies between forward operating bases and the frontline."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "supply"
	vendor_theme = VENDOR_THEME_USCM

	req_access = list()

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE
	wrenchable = FALSE
	hackable = FALSE
	density = FALSE
	var/being_restocked = FALSE

	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_LOAD_AMMO_BOXES

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/vend_fail()
	return

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/get_examine_text(mob/living/carbon/human/user)
	. = ..()
	if(ishuman(user))
		. += SPAN_INFO("[SPAN_HELPFUL("CTRL + Click")] \the [src] to start re-stocking it with supplies near vendor.")

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/clicked(mob/user, list/mods)
	if(mods["ctrl"])
		if(!CAN_PICKUP(user, src))
			return ..()
		initiate_autorestock(user)
		return TRUE
	. = ..()

/obj/structure/machinery/cm_vending/sorted/vehicle_supply/proc/initiate_autorestock(mob/living/carbon/human/user)
	if(!ishuman(user))
		return

	if(being_restocked)
		to_chat(user, SPAN_WARNING("\The [src] is already being restocked, you will get in the way!"))
		return

	being_restocked = TRUE

	user.visible_message(SPAN_NOTICE("[user] starts stocking a bunch of supplies into \the [src]."),
	SPAN_NOTICE("You start stocking a bunch of supplies into \the [src]."))

	//done this way because for obj in range creates a list and goes through list even if items themselves being picked up or moved.
	while(being_restocked)
		if(!do_after(user, 1 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src))
			user.visible_message(SPAN_NOTICE("[user] stopped stocking \the [src] with supplies."),
			SPAN_NOTICE("You stop stocking \the [src] with supplies."))
			being_restocked = FALSE
			return

		being_restocked = FALSE
		for(var/obj/item/I in range(1, src))
			if(stock(I))
				being_restocked = TRUE
				break

	user.visible_message(SPAN_NOTICE("[user] finishes stocking \the [src] with supplies."),
	SPAN_NOTICE("You finish stocking \the [src] with supplies."))
	return

//combined from req guns and ammo vendors
/obj/structure/machinery/cm_vending/sorted/vehicle_supply/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M37A2 Pump Shotgun", round(scale * 3), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachinegun", round(scale * 2.5), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", round(scale * 4), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),
		list("L42A Battle Rifle", round(scale * 2), /obj/item/weapon/gun/rifle/l42a, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 2), /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", round(scale * 1.5), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", round(scale * 2.5), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", -1, null, null),
		list("M15 Fragmentation Grenade", 0, /obj/item/explosive/grenade/high_explosive/m15, VENDOR_ITEM_REGULAR),
		list("M20 Claymore Anti-Personnel Mine", 0, /obj/item/explosive/mine, VENDOR_ITEM_REGULAR),
		list("M40 HEDP Grenade", 0, /obj/item/explosive/grenade/high_explosive, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Grenade", 0, /obj/item/explosive/grenade/incendiary, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Smoke Grenade", 0, /obj/item/explosive/grenade/phosphorus, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Grenade", round(scale * 1), /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Grenade", 0, /obj/item/explosive/grenade/high_explosive/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Grenade", 0, /obj/item/explosive/grenade/incendiary/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Grenade", 0, /obj/item/explosive/grenade/smokebomb/airburst, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Star Shell", 2, /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Shell", 0, /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		list("M40 HIRR Baton Slug", round(scale * 2), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", 0, /obj/item/explosive/grenade/metal_foam, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 0, /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),
		list("Plastic Explosives", 2, /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),

		list("REGULAR AMMUNITION", -1, null, null),
		list("Box Of Buckshot Shells", round(scale * 3), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box Of Flechette Shells", round(scale * 2), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box Of Shotgun Slugs", round(scale * 4), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("L42A Magazine (10x24mm)", round(scale * 5), /obj/item/ammo_magazine/rifle/l42a, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Magazine (10x24mm)", round(scale * 10), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", round(scale * 6), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M44 Speed Loader (.44)", round(scale * 4), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", round(scale * 10), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),

		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("88 Mod 4 AP Magazine (9mm)", round(scale * 8), /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("L42A AP Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/l42a/ap, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 0, /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A MK2 AP Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine (9mm)", 0, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),

		list("EXTENDED AMMUNITION", -1, null, null),
		list("M39 Extended Magazine (10x20mm)", 0, /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Extended Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("SPECIALIST AMMUNITION", -1, null, null),
		list("A19 High Velocity Impact Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m4ra/impact, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Incendiary Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m4ra/incendiary, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M42A Flak Magazine (10x28mm)", 0, /obj/item/ammo_magazine/sniper/flak, VENDOR_ITEM_REGULAR),
		list("M42A Incendiary Magazine (10x28mm)", 0, /obj/item/ammo_magazine/sniper/incendiary, VENDOR_ITEM_REGULAR),
		list("M42A Marksman Magazine (10x28mm Caseless)", 0, /obj/item/ammo_magazine/sniper, VENDOR_ITEM_REGULAR),
		list("84mm Anti-Armor Rocket", 0, /obj/item/ammo_magazine/rocket/ap, VENDOR_ITEM_REGULAR),
		list("84mm High-Explosive Rocket", 0, /obj/item/ammo_magazine/rocket, VENDOR_ITEM_REGULAR),
		list("84mm White-Phosphorus Rocket", 0, /obj/item/ammo_magazine/rocket/wp, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank", 0, /obj/item/ammo_magazine/flamer_tank/large, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (B) (Green Flame)", 0, /obj/item/ammo_magazine/flamer_tank/large/B, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (X) (Blue Flame)", 0, /obj/item/ammo_magazine/flamer_tank/large/X, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("M2C Box Magazine", 0, /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", 1, /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41AE2 Box Magazine (10x24mm)", 0, /obj/item/ammo_magazine/rifle/lmg, VENDOR_ITEM_REGULAR),
		list("M41AE2 Holo Target Rounds (10x24mm)", 0, /obj/item/ammo_magazine/rifle/lmg/holo_target, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 0, /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 0, /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine (9mm)", 0, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("M56 Powerpack", 0, /obj/item/smartgun_powerpack, VENDOR_ITEM_REGULAR),
		list("M56 Smartgun Drum", 0, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M56D Drum Magazine",0, /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", round(scale * 2), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine", round(scale * 1.5), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("BUILDING MATERIALS", -1, null, null),
		list("Cardboard x10", 1, /obj/item/stack/sheet/cardboard/small_stack, VENDOR_ITEM_REGULAR),
		list("Barbed Wire x10", 0, /obj/item/stack/barbed_wire/small_stack, VENDOR_ITEM_REGULAR),
		list("Metal x10", 0, /obj/item/stack/sheet/metal/small_stack, VENDOR_ITEM_REGULAR),
		list("Plasteel x10", 0, /obj/item/stack/sheet/plasteel/small_stack, VENDOR_ITEM_REGULAR),
		list("Sandbags (empty) x10", 1, /obj/item/stack/sandbags_empty/small_stack, VENDOR_ITEM_REGULAR),
		list("Sandbags (full) x5", 0, /obj/item/stack/sandbags/small_stack, VENDOR_ITEM_REGULAR),

		list("AMMUNITION BOXES", -1, null, null),
		list("Shotgun Shell Box (Buckshot x 100)", 0, /obj/item/ammo_box/magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Flechette x 100)", 0, /obj/item/ammo_box/magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Slugs x 100)", 0, /obj/item/ammo_box/magazine/shotgun, VENDOR_ITEM_REGULAR),
		list("Rifle Ammunition Box (10x24mm)", 0, /obj/item/ammo_box/rounds, VENDOR_ITEM_REGULAR),
		list("Rifle Ammunition Box (10x24mm AP)", 0, /obj/item/ammo_box/rounds/ap, VENDOR_ITEM_REGULAR),
		list("SMG Ammunition Box (10x20mm HV)", 0, /obj/item/ammo_box/rounds/smg, VENDOR_ITEM_REGULAR),
		list("SMG Ammunition Box (10x20mm AP)", 0, /obj/item/ammo_box/rounds/smg/ap, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Box Of MREs", round(scale * 1.5), /obj/item/ammo_box/magazine/misc/mre, VENDOR_ITEM_REGULAR),
		list("Box Of M94 Marking Flare Packs", round(scale * 2), /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", round(scale * 2), /obj/item/tool/shovel/etool, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", round(scale * 5), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", 0, /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", round(scale * 1), /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", round(scale * 1), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("MB-6 Folding Barricades (x3)", 0, /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 0, /obj/item/device/motiondetector, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 2, /obj/item/roller, VENDOR_ITEM_REGULAR),

		list("ARMOR AND CLOTHING", -1, null, null),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Marine Helmet", round(scale * 3), /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Marine Armor", round(scale * 1), /obj/item/clothing/suit/storage/marine, VENDOR_ITEM_REGULAR),
		list("M3-EOD Pattern Heavy Armor", round(scale * 1), /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", round(scale * 1), /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),
		)

//combined from req guns and ammo vendors
/obj/structure/machinery/cm_vending/sorted/vehicle_supply/stock(obj/item/item_to_stock, mob/user)
	if(being_restocked && user)
		to_chat(user, SPAN_WARNING("\The [src] is already being restocked, you will get in the way!"))
		return FALSE

	//storage items except few are exempted because checks would be huge and not worth it
	if(istype(item_to_stock, /obj/item/storage) && !istype(item_to_stock, /obj/item/storage/box/m94) && !istype(item_to_stock, /obj/item/storage/large_holster/machete))
		if(user)
			to_chat(user, SPAN_WARNING("Can't restock \the [item_to_stock]."))
		return FALSE
	var/list/R

	//this below is in case we have subtype of an object, that SHOULD be treated as parent object (like /empty ammo box)
	var/corrected_path = return_corresponding_type(item_to_stock.type)
	var/stack_restock = 0 //used for making restocking stacked stuff much better.

	for(R in (listed_products))
		if(item_to_stock.type == R[3] || corrected_path && corrected_path == R[3])
			if(!check_if_item_is_good_to_restock(item_to_stock, user))
				return

			//various stacks handling
			if(istype(item_to_stock, /obj/item/stack))
				var/obj/item/stack/S = item_to_stock
				if(istype(item_to_stock, /obj/item/stack/folding_barricade))
					if(S.amount != 3)
						if(user)
							to_chat(user, SPAN_WARNING("\The [S] are being stored in [SPAN_HELPFUL("stacks of 3")] for convenience. Add to \the [S] stack to make it a stack of 3 before restocking."))
						return FALSE
				else if(istype(item_to_stock, /obj/item/stack/sandbags))
					if(S.amount < 5)
						if(user)
							to_chat(user, SPAN_WARNING("\The [S] are being stored in [SPAN_HELPFUL("stacks of 5")] for convenience. You need \the [S] stack of at least 5 to restock it."))
						return FALSE
					else
						stack_restock = Floor(S.amount / 5)
				//for the ease of finding enough materials to stack, it will be stored in stacks of 10 sheets just like they come in engie vendor
				else
					if(S.amount < 10)
						if(user)
							to_chat(user, SPAN_WARNING("\The [S] are being stored in [SPAN_HELPFUL("stacks of 10")] for convenience. You need \the [S] stack of at least 10 to restock it."))
						return FALSE
					else
						stack_restock = Floor(S.amount / 10)

			//item we are restocking is a stack and we need to conveniently restock it
			//instead of demanding user to split it into stacks of appropriate amount
			//if there are any left overs in stack after we restock, we do not move it anywhere nor delete
			if(stack_restock)
				var/modifier = 10
				var/obj/item/stack/ST = item_to_stock
				if(istype(item_to_stock, /obj/item/stack/sandbags))
					modifier = 5
				if(ST.amount > stack_restock * modifier)
					ST.amount -= stack_restock * modifier
					ST.update_icon()
					item_to_stock = null //we have left overs, so we don't delete stack

				R[2] += stack_restock
				if(vend_flags & VEND_LOAD_AMMO_BOXES)
					update_derived_ammo_and_boxes_on_add(R)
			else
				R[2]++
				if(vend_flags & VEND_LOAD_AMMO_BOXES)
					update_derived_ammo_and_boxes_on_add(R)

			if(item_to_stock)
				if(user)
					if(item_to_stock.loc == user) //Inside the mob's inventory
						if(item_to_stock.flags_item & WIELDED)
							item_to_stock.unwield(user)
						user.temp_drop_inv_item(item_to_stock)

				if(isstorage(item_to_stock.loc)) //inside a storage item
					var/obj/item/storage/S = item_to_stock.loc
					S.remove_from_storage(item_to_stock, user.loc)

				qdel(item_to_stock)

			if(user)
				user.visible_message(SPAN_NOTICE("[user] stocks \the [src] with \a [R[1]]."),
				SPAN_NOTICE("You stock \the [src] with \a [R[1]]."))

			updateUsrDialog()
			return TRUE//We found our item, no reason to go on.

