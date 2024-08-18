//------------ CL CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_dress_corporate_liaison, list(
	list("SUITS AND UNDERSHIRTS", 0, null, null, null),
	list("Black Suit Pants", 0, /obj/item/clothing/under/liaison_suit/black, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
	list("Blue Suit Pants", 0, /obj/item/clothing/under/liaison_suit/blue, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Brown Suit Pants", 0, /obj/item/clothing/under/liaison_suit/brown, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("White Suit Pants", 0, /obj/item/clothing/under/liaison_suit/corporate_formal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Tan Suit", 0, /obj/item/clothing/under/liaison_suit, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Charcoal Suit", 0, /obj/item/clothing/under/liaison_suit/charcoal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's White Suit", 0, /obj/item/clothing/under/liaison_suit/formal, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Blue Blazer", 0, /obj/item/clothing/under/liaison_suit/blazer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Suspenders", 0, /obj/item/clothing/under/liaison_suit/suspenders, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Liaison's Skirt", 0, /obj/item/clothing/under/blackskirt, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Trainee's Uniform", 0, /obj/item/clothing/under/suit_jacket/trainee, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Country Club Outfit", 0, /obj/item/clothing/under/liaison_suit/ivy, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Orange Outfit", 0, /obj/item/clothing/under/liaison_suit/orange, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Corporate Casual", 0, /obj/item/clothing/under/liaison_suit/field, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Grey Workwear", 0, /obj/item/clothing/under/colonist/workwear, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Khaki Workwear", 0, /obj/item/clothing/under/colonist/workwear/khaki, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Pink Workwear", 0, /obj/item/clothing/under/colonist/workwear/pink, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
	list("Green Workwear", 0, /obj/item/clothing/under/colonist/workwear/green, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

	list("SUIT", 0, null, null, null),
	list("Black Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
	list("Khaki Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Brown Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Blue Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Formal Suit Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/corporate/formal, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Grey Bomber Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber/grey, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Red Bomber Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber/red, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Khaki Bomber Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/bomber, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Brown Bomber Jacket", 0, /obj/item/clothing/suit/storage/bomber, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Black Bomber Jacket", 0, /obj/item/clothing/suit/storage/bomber/alt, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Liaison's Winter Coat", 0, /obj/item/clothing/suit/storage/snow_suit/liaison, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Labcoat", 0, /obj/item/clothing/suit/storage/labcoat, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Grey Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Brown Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/vest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
	list("Tan Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

	list("TIES", 0, null, null, null),
	list("Black Tie", 0, /obj/item/clothing/accessory/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
	list("Red Tie", 0, /obj/item/clothing/accessory/red, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Purple Tie", 0, /obj/item/clothing/accessory/purple, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Blue Tie", 0, /obj/item/clothing/accessory/blue, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Green Tie", 0, /obj/item/clothing/accessory/green, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Gold Tie", 0, /obj/item/clothing/accessory/gold, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Special Tie", 0, /obj/item/clothing/accessory/horrible, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	list("GLASSES", 0, null, null, null),
	list("BiMex Shades", 0, /obj/item/clothing/glasses/sunglasses/big, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
	list("Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Sunglasses", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Prescription Sunglasses", 0, /obj/item/clothing/glasses/sunglasses/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
	list("Prescription Glasses", 0, /obj/item/clothing/glasses/regular/hipster, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

	list("GLOVES", 0, null, null, null),
	list("Black Gloves", 0, /obj/item/clothing/gloves/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_RECOMMENDED),
	list("Dress Gloves", 0, /obj/item/clothing/gloves/marine/dress, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

	list("SHOES", 0, null, null, null),
	list("Laceup Shoes, Black", 0, /obj/item/clothing/shoes/laceup, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_RECOMMENDED),
	list("Laceup Shoes, Brown", 0, /obj/item/clothing/shoes/laceup/brown, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
	list("Sneakers, Black", 0, /obj/item/clothing/shoes/black, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),
	list("Corporate Boots", 0, /obj/item/clothing/shoes/marine/corporate, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_REGULAR),

	list("HATS", 0, null, null, null),
	list("Black Beret", 0, /obj/item/clothing/head/beret/cm/black/civilian, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("White Beret", 0, /obj/item/clothing/head/beret/cm/white/civilian, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("Fedora", 0, /obj/item/clothing/head/fedora, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

))

/obj/structure/machinery/cm_vending/clothing/dress/corporate_liaison
	name = "\improper Corporate Liaison's Personal Wardrobe"
	desc = "A wardrobe containing all the clothes an executive would ever need."
	icon_state = "wardrobe_vendor"
	vendor_theme = VENDOR_THEME_USCM
	show_points = FALSE
	req_access = list()
	vendor_role = list(JOB_CORPORATE_LIAISON, JOB_SURVIVOR, JOB_TRAINEE, JOB_JUNIOR_EXECUTIVE, JOB_EXECUTIVE, JOB_SENIOR_EXECUTIVE, JOB_EXECUTIVE_SPECIALIST, JOB_EXECUTIVE_SUPERVISOR, JOB_ASSISTANT_MANAGER, JOB_DIVISION_MANAGER, JOB_CHIEF_EXECUTIVE, JOB_DIRECTOR, JOB_WY_GOON_RESEARCHER)

/obj/structure/machinery/cm_vending/clothing/dress/corporate_liaison/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_dress_corporate_liaison
