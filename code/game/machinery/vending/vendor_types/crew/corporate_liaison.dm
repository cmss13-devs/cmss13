//------------ CL CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_corporate_liaison, list(
	list("SUITS AND UNDERSHIRTS (CHOOSE 5)", 0, null, null, null),
	list("Black Suit Pants", 0, /obj/item/clothing/under/liaison_suit/black, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
	list("Blue Suit Pants", 0, /obj/item/clothing/under/liaison_suit/blue, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Brown Suit Pants", 0, /obj/item/clothing/under/liaison_suit/brown, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("White Suit Pants", 0, /obj/item/clothing/under/liaison_suit/corporate_formal, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Grey Suit Pants", 0, /obj/item/clothing/under/detective/grey, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Worn Suit", 0, /obj/item/clothing/under/detective/neutral, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Tan Suit", 0, /obj/item/clothing/under/liaison_suit, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Charcoal Suit", 0, /obj/item/clothing/under/liaison_suit/charcoal, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's White Suit", 0, /obj/item/clothing/under/liaison_suit/formal, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Blue Blazer", 0, /obj/item/clothing/under/liaison_suit/blazer, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Suspenders", 0, /obj/item/clothing/under/liaison_suit/suspenders, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Skirt", 0, /obj/item/clothing/under/blackskirt, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Trainee's Uniform", 0, /obj/item/clothing/under/suit_jacket/trainee, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Country Club Outfit", 0, /obj/item/clothing/under/liaison_suit/ivy, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Orange Outfit", 0, /obj/item/clothing/under/liaison_suit/orange, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Corporate Casual", 0, /obj/item/clothing/under/liaison_suit/field, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Grey Workwear", 0, /obj/item/clothing/under/colonist/workwear, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Khaki Workwear", 0, /obj/item/clothing/under/colonist/workwear/khaki, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Pink Workwear", 0, /obj/item/clothing/under/colonist/workwear/pink, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Green Workwear", 0, /obj/item/clothing/under/colonist/workwear/green, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Blue Workwear", 0, /obj/item/clothing/under/colonist/workwear/blue, CIVILIAN_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

	list("SUIT (CHOOSE 5)", 0, null, null, null),
	list("Black Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_RECOMMENDED),
	list("Khaki Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Brown Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Blue Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Formal Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/formal, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Grey Bomber Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber/grey, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Red Bomber Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber/red, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Khaki Bomber Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Brown Bomber Jacket", 0, /obj/item/clothing/suit/storage/bomber, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Black Bomber Jacket", 0, /obj/item/clothing/suit/storage/bomber/alt, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Brown Windbreaker", 0, /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Grey Windbreaker", 0, /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Green Windbreaker", 0, /obj/item/clothing/suit/storage/windbreaker/windbreaker_green, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Expedition Windbreaker", 0, /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Liaison's Winter Coat", 0, /obj/item/clothing/suit/storage/snow_suit/liaison, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Beige Trenchcoat", 0, /obj/item/clothing/suit/storage/CMB/trenchcoat, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Brown Trenchcoat", 0, /obj/item/clothing/suit/storage/CMB/trenchcoat/brown, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Grey Trenchcoat", 0, /obj/item/clothing/suit/storage/CMB/trenchcoat/grey, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Grey Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Brown Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/vest, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),
	list("Tan Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, CIVILIAN_CAN_BUY_SUIT, VENDOR_ITEM_REGULAR),

	list("HATS (CHOOSE 5)", 0, null, null, null),
	list("Company Baseball Cap", 0, /obj/item/clothing/head/cmcap/wy_cap, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_RECOMMENDED),
	list("Tan Beret", 0, /obj/item/clothing/head/beret/civilian, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),
	list("Brown Beret", 0, /obj/item/clothing/head/beret/civilian/brown, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),
	list("Black Beret", 0, /obj/item/clothing/head/beret/civilian/black, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),
	list("White Beret", 0, /obj/item/clothing/head/beret/civilian/white, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),
	list("Tan Fedora", 0, /obj/item/clothing/head/fedora, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),
	list("Brown Fedora", 0, /obj/item/clothing/head/fedora/brown, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),
	list("Grey Fedora", 0, /obj/item/clothing/head/fedora/grey, CIVILIAN_CAN_BUY_HAT, VENDOR_ITEM_REGULAR),

	list("GLASSES (CHOOSE 2)", 0, null, null, null),
	list("BiMex Shades", 0, /obj/item/clothing/glasses/sunglasses/big, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
	list("Bronze Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Silver Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator/silver, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Sunglasses", 0, /obj/item/clothing/glasses/sunglasses, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Prescription Sunglasses", 0, /obj/item/clothing/glasses/sunglasses/prescription, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Prescription Glasses", 0, /obj/item/clothing/glasses/regular/hipster, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Fancy Monocle", 0, /obj/item/clothing/glasses/monocle, CIVILIAN_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

	list("SHOES (CHOOSE 2)", 0, null, null, null),
	list("Laceup Shoes, Black", 0, /obj/item/clothing/shoes/laceup, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),
	list("Laceup Shoes, Brown", 0, /obj/item/clothing/shoes/laceup/brown, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
	list("Sneakers, Black", 0, /obj/item/clothing/shoes/black, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
	list("Corporate Boots", 0, /obj/item/clothing/shoes/marine/corporate, CIVILIAN_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

	list("GLOVES (CHOOSE 2)", 0, null, null, null),
	list("Black Gloves", 0, /obj/item/clothing/gloves/black, CIVILIAN_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
	list("Brown Gloves", 0, /obj/item/clothing/gloves/brown, CIVILIAN_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
	list("Dress Gloves", 0, /obj/item/clothing/gloves/marine/dress, CIVILIAN_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

	list("ACCESSORIES (CHOOSE 5)", 0, null, null, null),
	list("Black Tie", 0, /obj/item/clothing/accessory/black, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
	list("Red Tie", 0, /obj/item/clothing/accessory/red, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Purple Tie", 0, /obj/item/clothing/accessory/purple, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Blue Tie", 0, /obj/item/clothing/accessory/blue, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Green Tie", 0, /obj/item/clothing/accessory/green, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Gold Tie", 0, /obj/item/clothing/accessory/gold, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Special Tie", 0, /obj/item/clothing/accessory/horrible, CIVILIAN_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/clothing/corporate_liaison
	name = "\improper Corporate Liaison's Personal Wardrobe"
	desc = "A wardrobe containing all the clothes an executive would ever need."
	icon_state = "wardrobe_vendor"
	vendor_theme = VENDOR_THEME_USCM
	show_points = FALSE
	req_access = list()
	vendor_role = JOB_CORPORATE_ROLES_LIST

/obj/structure/machinery/cm_vending/clothing/corporate_liaison/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_corporate_liaison
