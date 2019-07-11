
/obj/machinery/cm_vending/snowflake
	name = "Snowflake Vendor"
	desc = "A vendor with a large snowflake on it."
	icon_state = "snowflakemachine"
	use_points = TRUE
	use_snowflake_points = TRUE

/obj/machinery/cm_vending/snowflake/New()
	..()
	spawn(4)
		power_change()

/obj/machinery/cm_vending/snowflake/power_change()
	..()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if( !(stat & NOPOWER) )
			icon_state = initial(icon_state)
		else
			spawn(rand(0, 15))
				src.icon_state = "[initial(icon_state)]-off"

/obj/machinery/cm_vending/snowflake/synth
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = "Synthetic"

	listed_products = list(
		list("UNIFORM", 0, null, null, null),
		list("Bartender", 12, /obj/item/clothing/under/rank/bartender, null, "black"),
		list("Chaplain", 12, /obj/item/clothing/under/rank/chaplain, null, "black"),
		list("Dispatcher's uniform", 12, /obj/item/clothing/under/rank/dispatch, null, "black"),
		list("Librarian", 12, /obj/item/clothing/under/librarian, null, "black"),
		list("Black skirt", 12, /obj/item/clothing/under/blackskirt, null, "black"),
		list("Medical scrubs, blue", 12, /obj/item/clothing/under/rank/medical/blue, null, "black"),
		list("Medical scrubs, green", 12, /obj/item/clothing/under/rank/medical/green, null, "black"),
		list("Medical scrubs, purple", 12, /obj/item/clothing/under/rank/medical/purple, null, "black"),
		list("Medical scrubs, white", 12, /obj/item/clothing/under/rank/medical, null, "black"),
		list("Security uniform, black", 12, /obj/item/clothing/under/rank/security/corp, null, "black"),
		list("Security uniform, navyblue", 12, /obj/item/clothing/under/rank/security/navyblue, null, "black"),
		list("Security uniform, red", 12, /obj/item/clothing/under/rank/security, null, "black"),
		list("Security uniform, white", 12, /obj/item/clothing/under/rank/security, null, "black"),

		list("WEBBING", 0, null, null, null),
		list("Black webbing vest", 12, /obj/item/clothing/tie/storage/black_vest, null, "black"),

		list("SHOES", 0, null, null, null),
		list("Boots", 12, /obj/item/clothing/shoes/marine, null, "black"),
		list("Shoes, black", 12, /obj/item/clothing/shoes/black, null, "black"),
		list("Shoes, brown", 12, /obj/item/clothing/shoes/brown, null, "black"),
		list("Shoes, blue", 12, /obj/item/clothing/shoes/blue, null, "black"),
		list("Shoes, green", 12, /obj/item/clothing/shoes/green, null, "black"),
		list("Shoes, yellow", 12, /obj/item/clothing/shoes/yellow, null, "black"),
		list("Shoes, purple", 12, /obj/item/clothing/shoes/purple, null, "black"),
		list("Shoes, red", 12, /obj/item/clothing/shoes/red, null, "black"),
		list("Shoes, white", 12, /obj/item/clothing/shoes/white, null, "black"),

		list("HELMET", 0, null, null, null),
		list("Beanie", 12, /obj/item/clothing/head/beanie, null, "black"),
		list("Beaver hat", 12, /obj/item/clothing/head/beaverhat, null, "black"),
		list("Beret, standard", 12, /obj/item/clothing/head/beret/cm, null, "black"),
		list("Beret, tan", 12, /obj/item/clothing/head/beret/cm/tan, null, "black"),
		list("Beret, purple", 12, /obj/item/clothing/head/beret/jan, null, "black"),
		list("Beret, red", 12, /obj/item/clothing/head/beret/cm/red, null, "black"),
		list("Bowler hat", 12, /obj/item/clothing/head/bowlerhat, null, "black"),
		list("Cap", 12, /obj/item/clothing/head/cmcap, null, "black"),
		list("Chef's hat", 12, /obj/item/clothing/head/chefhat, null, "black"),
		list("Fez", 12, /obj/item/clothing/head/fez, null, "black"),
		list("Hard hat, blue", 12, /obj/item/clothing/head/hardhat/dblue, null, "black"),
		list("Hard hat, orange", 12, /obj/item/clothing/head/hardhat/orange, null, "black"),
		list("Hard hat, red", 12, /obj/item/clothing/head/hardhat/red, null, "black"),
		list("Nurse's cap", 12, /obj/item/clothing/head/nursehat, null, "black"),
		list("Corporate security cap", 12, /obj/item/clothing/head/soft/sec/corp, null, "black"),
		list("Surgical cap, blue", 12, /obj/item/clothing/head/surgery/blue, null, "black"),
		list("Surgical cap, blue", 12, /obj/item/clothing/head/surgery/purple, null, "black"),
		list("Surgical cap, green", 12, /obj/item/clothing/head/surgery/green, null, "black"),
		list("Top hat", 12, /obj/item/clothing/head/that, null, "black"),

		list("SUIT", 0, null, null, null),
		list("Hazard vest", 12, /obj/item/clothing/suit/storage/hazardvest, null, "black"),
		list("Overalls", 12, /obj/item/clothing/suit/apron/overalls, null, "black"),
		list("Chef's outfit", 12, /obj/item/clothing/suit/chef, null, "black"),
		list("Chef's Apron", 12, /obj/item/clothing/suit/chef/classic, null, "black"),
		list("Coat, brown", 12, /obj/item/clothing/suit/storage/det_suit, null, "black"),
		list("Coat, black", 12, /obj/item/clothing/suit/storage/det_suit/black, null, "black"),
		list("Jacket, Colonial Marshal", 12, /obj/item/clothing/suit/storage/CMB, null, "black"),
	)