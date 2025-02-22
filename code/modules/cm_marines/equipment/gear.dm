//**********************Marine Gear**************************/

//MARINE COMBAT LIGHT

/obj/item/device/flashlight/combat
	name = "combat flashlight"
	desc = "A Flashlight designed to be held in the hand, or attached to a rifle, has better bulb compared to a normal flashlight."
	icon_state = "combat_flashlight"
	item_state = ""
	light_range = 6 //Pretty luminous, but still a flashlight that fits in a pocket

//MARINE SNIPER TARPS

/obj/item/bodybag/tarp
	name = "\improper V1 thermal-dapening tarp (folded)"
	desc = "A tarp carried by USCM Snipers. When laying underneath the tarp, the sniper is almost indistinguishable from the landscape if utilized correctly. The tarp contains a thermal-dampening weave to hide the wearer's heat signatures, optical camouflage, and smell dampening."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "jungletarp_folded"
	w_class = SIZE_MEDIUM
	unfolded_path = /obj/structure/closet/bodybag/tarp
	unacidable = TRUE

/obj/item/bodybag/tarp/snow
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "snowtarp_folded"
	unfolded_path = /obj/structure/closet/bodybag/tarp/snow

/obj/item/bodybag/tarp/reactive
	name = "\improper V2 reactive thermal tarp (folded)"
	desc = "A tarp carried by some USCM infantry. This updated tarp is capable of blending into its environment nearly flawlessly, given that it can properly collate data once deployed. The tarp is able to hide the wearer's heat signature."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "reactivetarp_folded"
	unfolded_path = /obj/structure/closet/bodybag/tarp/reactive

/obj/item/bodybag/tarp/reactive/scout
	name = "\improper V3 reactive thermal tarp (folded)"
	desc = "A more compact and improved version of the V2 thermal tarp, intended primarily for the transportation of deceased or wounded marines. It has improved cloaking technology than earlier models, allowing it to cloak to a greater degree and faster, but can only be used with special training."
	icon_state = "scouttarp_folded"
	w_class = SIZE_SMALL
	unfolded_path = /obj/structure/closet/bodybag/tarp/reactive/scout

/obj/structure/closet/bodybag/tarp
	name = "\improper V1 thermal-dampening tarp"
	bag_name = "\improper V1 thermal-dampening tarp"
	desc = "A tarp carried by USCM Snipers. When laying underneath the tarp, the sniper is almost indistinguishable from the landscape if utilized correctly. The tarp contains a thermal-dampening weave to hide the wearer's heat signatures, optical camouflage, and smell dampening."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "jungletarp_closed"
	icon_closed = "jungletarp_closed"
	icon_opened = "jungletarp_open"
	open_sound = 'sound/effects/vegetation_walk_1.ogg'
	close_sound = 'sound/effects/vegetation_walk_2.ogg'
	item_path = /obj/item/bodybag/tarp
	anchored = FALSE
	var/uncloak_time = 3 //in SECONDS, this is how long it takes for the tarp to become fully visible again once it's opened from an invisible state
	var/cloak_time = 15 //ditto for cloaking
	var/closed_alpha = 60 //how much ALPHA the tarp has once it's fully cloaked.
	var/can_store_dead = FALSE
	var/is_animating = FALSE
	var/first_open = TRUE
	exit_stun = 0
	/// used to implement a delay before tarp can be entered again after opened (anti-exploit)
	COOLDOWN_DECLARE(toggle_delay)

/obj/structure/closet/bodybag/tarp/snow
	icon_state = "snowtarp_closed"
	icon_closed = "snowtarp_closed"
	icon_opened = "snowtarp_open"
	item_path = /obj/item/bodybag/tarp/snow

/obj/structure/closet/bodybag/tarp/reactive
	name = "\improper V2 reactive thermal tarp"
	bag_name = "\improper V2 reactive thermal tarp"
	desc = "A tarp carried by some USCM infantry. This updated tarp is capable of blending into its environment nearly flawlessly, given that it can properly collate data once deployed. The tarp is able to hide the wearer's heat signature."
	icon_state = "reactivetarp_closed"
	icon_closed = "reactivetarp_closed"
	icon_opened = "reactivetarp_open"
	open_sound = 'sound/effects/vegetation_walk_1.ogg'
	close_sound = 'sound/effects/vegetation_walk_2.ogg'

	item_path = /obj/item/bodybag/tarp/reactive
	anchored = FALSE

/obj/structure/closet/bodybag/tarp/reactive/scout
	name = "\improper V3 reactive thermal tarp (folded)"
	bag_name = "\improper V3 reactive thermal tarp"
	desc = "A more compact and improved version of the V2 thermal tarp, intended primarily for the transportation of deceased or wounded marines. It has improved cloaking technology than earlier models, allowing it to cloak to a greater degree and faster, but can only be used with special training.\nUse this item in-hand or click somewhere on the floor adjacent to you to deploy it, then click it again to close it, which automatically cloaks the bag. Click again to open and uncloak it. If you lose it, right click to check tile contents around you to find it."
	icon_state = "scouttarp_closed"
	icon_closed = "scouttarp_closed"
	icon_opened = "scouttarp_open"
	item_path = /obj/item/bodybag/tarp/reactive/scout
	cloak_time = 5
	closed_alpha = 10 //same as scout cloak alpha
	exit_stun = 1
	can_store_dead = TRUE

/obj/structure/closet/bodybag/tarp/reactive/scout/close(mob/user)
	if(!skillcheck(usr, SKILL_SPEC_WEAPONS, SKILL_SPEC_ALL) && usr.skills.get_skill_level(SKILL_SPEC_WEAPONS) != SKILL_SPEC_SCOUT)
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	. = ..()

/obj/structure/closet/bodybag/tarp/store_mobs(stored_units)//same as stasis bag proc
	var/list/mobs_can_store = list()
	for(var/mob/living/carbon/human/H in loc)
		if(H.buckled)
			continue
		if(H.stat == DEAD && !can_store_dead) // dead, nope
			continue
		mobs_can_store += H
	var/mob/living/carbon/human/mob_to_store
	if(length(mobs_can_store))
		mob_to_store = pick(mobs_can_store)
		mob_to_store.forceMove(src)
		mob_to_store.unset_interaction()
		stored_units += mob_size
	return stored_units

/obj/structure/closet/bodybag/tarp/proc/handle_cloaking()
	if(opened) //if we are OPENING the bag. It checks for opened because the handle_cloaking proc triggers AFTER the parent open() is called
		if(first_open) //if this is the first time we are opening it (ie not animated because the open proc is being triggered by putting it on the ground)
			alpha = 255
			first_open = FALSE
			return
		if(is_animating) //if it's not fully cloaked we don't want to do the whole animation from a fully cloaked state.
			alpha = 255
			is_animating = FALSE
			return
		else //not animating and not the first time we're opening it, therefore play the full animation from a fully cloaked state
			is_animating = TRUE
			animate(src, alpha = 255, time = uncloak_time SECONDS, easing = QUAD_EASING)
			spawn(uncloak_time SECONDS)
				is_animating = FALSE
				return
	else //if we are CLOSING the bag, animate as usual.
		is_animating = TRUE
		animate(src, alpha = closed_alpha, time = cloak_time SECONDS, easing = QUAD_EASING)
		spawn(cloak_time SECONDS)
			is_animating = FALSE //animation finished
			return

/obj/structure/closet/bodybag/tarp/open()
	COOLDOWN_START(src, toggle_delay, 3 SECONDS) //3 seconds must pass before tarp can be closed
	. = ..()
	handle_cloaking()

/obj/structure/closet/bodybag/tarp/close(mob/user)
	if(!COOLDOWN_FINISHED(src, toggle_delay))
		to_chat(user, SPAN_WARNING("It is too soon to close [src]!"))
		return FALSE
	. = ..()
	handle_cloaking()

/obj/structure/broken_apc
	name = "\improper M577 armored personnel carrier"
	desc = "A large, armored behemoth capable of ferrying marines around. \nThis one is sitting nonfunctional."
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	icon = 'icons/obj/apc.dmi'
	icon_state = "apc"

/obj/item/reagent_container/food/snacks/protein_pack
	name = "stale USCM protein bar"
	desc = "The most fake-looking protein bar you have ever laid eyes on, covered in a substitution chocolate. The powder used to make these is a substitute of a substitute of whey substitute."
	icon_state = "yummers"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	filling_color = "#ED1169"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/protein_pack/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	bitesize = 4


/obj/item/reagent_container/food/snacks/mre_pack
	name = "\improper generic MRE pack"
	//trash = /obj/item/trash/USCMtray
	icon = 'icons/obj/items/food/trays.dmi'
	trash = null
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/snacks/mre_pack/meal1
	name = "\improper USCM Prepared Meal (cornbread)"
	desc = "A tray of standard USCM food. Stale cornbread, tomato paste and some green goop fill this tray."
	icon_state = "MREa"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/mre_pack/meal1/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal2
	name = "\improper USCM Prepared Meal (pork)"
	desc = "A tray of standard USCM food. Partially raw pork, goopy corn and some watery mashed potatoes fill this tray."
	icon_state = "MREb"

/obj/item/reagent_container/food/snacks/mre_pack/meal2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 2

/obj/item/reagent_container/food/snacks/mre_pack/meal3
	name = "\improper USCM Prepared Meal (pasta)"
	desc = "A tray of standard USCM food. Overcooked spaghetti, waterlogged carrots and two french fries fill this tray."
	icon_state = "MREc"

/obj/item/reagent_container/food/snacks/mre_pack/meal3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal4
	name = "\improper USCM Prepared Meal (pizza)"
	desc = "A tray of standard USCM food. Cold pizza, wet green beans and a shitty egg fill this tray. Get something other than pizza, lardass."
	icon_state = "MREd"

/obj/item/reagent_container/food/snacks/mre_pack/meal4/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	bitesize = 1

/obj/item/reagent_container/food/snacks/mre_pack/meal5
	name = "\improper USCM Prepared Meal (chicken)"
	desc = "A tray of standard USCM food. Moist chicken, dry rice and a mildly depressed piece of broccoli fill this tray."
	icon_state = "MREe"

/obj/item/reagent_container/food/snacks/mre_pack/meal5/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal6
	name = "\improper USCM Prepared Meal (tofu)"
	desc = "The USCM doesn't serve tofu you grass sucking hippie. The flag signifies your defeat."
	icon_state = "MREf"

/obj/item/reagent_container/food/snacks/mre_pack/meal6/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 1

/obj/item/reagent_container/food/snacks/mre_pack/xmas1
	name = "\improper USCM M25 'X-MAS' Meal: Sugar Cookies"
	desc = "The USCM M25 Sugar Cookies Meal was designed to give marines a feeling of Christmas joy. But to the bemusement of superior officers, the costs-savings measure of simply fabricating protein bars in the shape of cookies with chocolate substitute chips and the replacement of the expected milk with artificially colored water did not go over well with most marines."
	icon_state = "mreCookies"
	black_market_value = 10

/obj/item/reagent_container/food/snacks/mre_pack/xmas1/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/xmas2
	name = "\improper USCM M25 'X-MAS' Meal: Gingerbread Cookies"
	desc = "The USCM M25 Gingerbread Cookies Meal was designed to give marines convenient and cheap access to gingerbread cookies as a replacement for annual gingerbread making classes due to rising expenses and comically low success rates for the Basic Holidays Festivities Course. However, due to cost saving measures, these cookies seldom inspire happiness, nor holiday spirit."
	icon_state = "mreGingerbread"
	black_market_value = 10

/obj/item/reagent_container/food/snacks/mre_pack/xmas2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/xmas3
	name = "\improper USCM M25 'X-MAS' Meal: Fruitcake"
	desc = "The USCM M25 Fruitcake Meal was the third meal designed by an officers' committee as part of the M25 Project; this shows through the terrible hardness and tartness of the bread and raisined fruits. It can be logically deduced that the people who vended this option are worse than the Grinch and the Miser combined, along with the people who designed and prepared this fruitcake."
	icon_state = "mreFruitcake"
	black_market_value = 10

/obj/item/reagent_container/food/snacks/mre_pack/xmas3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/storage/box/pizza
	name = "food delivery box"
	desc = "A space-age food storage device, capable of keeping food extra fresh. Actually, it's just a box."

/obj/item/storage/box/pizza/Initialize()
	. = ..()
	pixel_y = rand(-3,3)
	pixel_x = rand(-3,3)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	var/randsnack
	for(var/i = 1 to 3)
		randsnack = rand(0,5)
		switch(randsnack)
			if(0)
				new /obj/item/reagent_container/food/snacks/fries(src)
			if(1)
				new /obj/item/reagent_container/food/snacks/cheesyfries(src)
			if(2)
				new /obj/item/reagent_container/food/snacks/bigbiteburger(src)
			if(4)
				new /obj/item/reagent_container/food/snacks/taco(src)
			if(5)
				new /obj/item/reagent_container/food/snacks/hotdog(src)

/obj/item/paper/janitor
	name = "crumbled paper"
	icon_state = "pamphlet"
	info = "In loving memory of Cub Johnson."

/obj/item/device/overwatch_camera
	name = "M5 Camera Gear"
	desc = "A camera and associated headgear designed to allow marine commanders to see what their troops can see. A more robust version of this equipment is integrated into all standard USCM combat helmets."
	icon = 'icons/obj/items/clothing/glasses/misc.dmi'
	icon_state = "cam_gear_off"
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/clothing/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/clothing/ears.dmi',
	)
	item_state_slots = list(
		WEAR_L_EAR = "cam_gear",
		WEAR_R_EAR = "cam_gear",
	)
	flags_equip_slot = SLOT_EAR
	var/obj/structure/machinery/camera/camera

/obj/item/device/overwatch_camera/Initialize(mapload, ...)
	. = ..()
	camera = new /obj/structure/machinery/camera/overwatch(src)
	AddComponent(/datum/component/overwatch_console_control)

/obj/item/device/overwatch_camera/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/device/overwatch_camera/equipped(mob/living/carbon/human/mob, slot)
	if(camera)
		camera.c_tag = mob.name
		camera.status = TRUE
		icon_state = "cam_gear_on"
		update_icon()
	..()

/obj/item/device/overwatch_camera/unequipped(mob/user, slot)
	. = ..()
	if(camera)
		camera.status = FALSE
		icon_state = "cam_gear_off"
		update_icon()

/obj/item/device/overwatch_camera/dropped(mob/user)
	if(camera)
		camera.c_tag = "Unknown"
	..()

/obj/item/device/overwatch_camera/hear_talk(mob/living/sourcemob, message, verb, datum/language/language, italics)
	SEND_SIGNAL(src, COMSIG_BROADCAST_HEAR_TALK, sourcemob, message, verb, language, italics, loc == sourcemob)

/obj/item/device/overwatch_camera/see_emote(mob/living/sourcemob, emote, audible)
	SEND_SIGNAL(src, COMSIG_BROADCAST_SEE_EMOTE, sourcemob, emote, audible, loc == sourcemob && audible)
