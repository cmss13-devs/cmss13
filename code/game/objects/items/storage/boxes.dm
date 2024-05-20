/*
 * Everything derived from the common cardboard box.
 * Basically everything except the original is a kit (starts full).
 *
 * Contains:
 * Empty box, starter boxes (survival/engineer),
 * Latex glove and sterile mask boxes,
 * Syringe, beaker, dna injector boxes,
 * Blanks, flashbangs, and EMP grenade boxes,
 * Tracking and chemical implant boxes,
 * Prescription glasses and drinking glass boxes,
 * Condiment bottle and silly cup boxes,
 * Donkpocket and monkeycube boxes,
 * ID and security PDA cart boxes,
 * Handcuff, mousetrap, and pillbottle boxes,
 * Snap-pops and matchboxes,
 * Replacement light boxes.
 *
 * For syndicate call-ins see uplink_kits.dm
 *
 *  EDITED BY APOPHIS 09OCT2015 to prevent in-game abuse of boxes.
 */



/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon_state = "box"
	item_state = "syringe_kit"
	foldable = TRUE
	storage_slots = null
	max_w_class = SIZE_SMALL //Changed because of in-game abuse
	w_class = SIZE_LARGE //Changed becuase of in-game abuse
	storage_flags = STORAGE_FLAGS_BOX

/obj/item/storage/box/survival
	w_class = SIZE_MEDIUM

/obj/item/storage/box/survival/fill_preset_inventory()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/tank/emergency_oxygen( src )

/obj/item/storage/box/engineer

/obj/item/storage/box/engineer/fill_preset_inventory()
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/tank/emergency_oxygen/engi( src )


/obj/item/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains white gloves."
	icon_state = "latex"
	can_hold = list(/obj/item/clothing/gloves/latex)
	w_class = SIZE_SMALL


/obj/item/storage/box/gloves/fill_preset_inventory()
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)
	new /obj/item/clothing/gloves/latex(src)

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains masks of sterility."
	icon_state = "sterile"
	can_hold = list(/obj/item/clothing/mask/surgical)
	w_class = SIZE_SMALL

/obj/item/storage/box/masks/fill_preset_inventory()
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)
	new /obj/item/clothing/mask/surgical(src)


/obj/item/storage/box/syringes
	name = "box of syringes"
	desc = "A box full of syringes."
	desc = "A biohazard alert warning is printed on the box"
	can_hold = list(/obj/item/reagent_container/syringe)
	icon_state = "syringe"
	w_class = SIZE_SMALL

/obj/item/storage/box/syringes/fill_preset_inventory()
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)
	new /obj/item/reagent_container/syringe(src)


/obj/item/storage/box/beakers
	name = "box of beakers"
	icon_state = "beaker"
	can_hold = list(/obj/item/reagent_container/glass/beaker)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/beakers/fill_preset_inventory()
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)
	new /obj/item/reagent_container/glass/beaker(src)

/obj/item/storage/box/sprays
	name = "box of empty spray bottles"
	icon_state = "spray"
	can_hold = list(/obj/item/reagent_container/spray)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/sprays/fill_preset_inventory()
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)
	new /obj/item/reagent_container/spray(src)

/obj/item/storage/box/flashbangs
	name = "box of flashbangs (WARNING)"
	desc = "<B>WARNING: These devices are extremely dangerous and can cause blindness or deafness in repeated use.</B>"
	icon_state = "flashbang"
	can_hold = list(/obj/item/explosive/grenade/flashbang)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/flashbangs/fill_preset_inventory()
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	new /obj/item/explosive/grenade/flashbang(src)
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		handle_delete_clash_contents()
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(handle_delete_clash_contents))

/obj/item/storage/box/flashbangs/proc/handle_delete_clash_contents()
	SIGNAL_HANDLER
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		var/grenade_count = 0
		var/grenades_desired = 4
		for(var/grenade in contents)
			if(grenade_count > grenades_desired)
				qdel(grenade)
			grenade_count++
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)

/obj/item/storage/box/emps
	name = "box of emp grenades"
	desc = "A box with 5 emp grenades."
	icon_state = "emp"

/obj/item/storage/box/emps/fill_preset_inventory()
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)
	new /obj/item/explosive/grenade/empgrenade(src)


/obj/item/storage/box/trackimp
	name = "boxed tracking implant kit"
	desc = "Box full of scum-bag tracking utensils."
	icon_state = "implant"

/obj/item/storage/box/trackimp/fill_preset_inventory()
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implantcase/tracking(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)
	new /obj/item/device/locator(src)

/obj/item/storage/box/chemimp
	name = "boxed chemical implant kit"
	desc = "Box of stuff used to implant chemicals."
	icon_state = "implant"

/obj/item/storage/box/chemimp/fill_preset_inventory()
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implantcase/chem(src)
	new /obj/item/implanter(src)
	new /obj/item/implantpad(src)



/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	icon_state = "glasses"
	can_hold = list(/obj/item/clothing/glasses/regular)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/rxglasses/fill_preset_inventory()
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)
	new /obj/item/clothing/glasses/regular(src)

/obj/item/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."

/obj/item/storage/box/drinkingglasses/fill_preset_inventory()
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)
	new /obj/item/reagent_container/food/drinks/drinkingglass(src)

/obj/item/storage/box/cdeathalarm_kit
	name = "Death Alarm Kit"
	desc = "Box of stuff used to implant death alarms."
	icon_state = "implant"
	item_state = "syringe_kit"

/obj/item/storage/box/cdeathalarm_kit/fill_preset_inventory()
	new /obj/item/implanter(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)
	new /obj/item/implantcase/death_alarm(src)

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."

/obj/item/storage/box/condimentbottles/fill_preset_inventory()
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)
	new /obj/item/reagent_container/food/condiment(src)



/obj/item/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

/obj/item/storage/box/cups/fill_preset_inventory()
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )
	new /obj/item/reagent_container/food/drinks/sillycup( src )


/obj/item/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
	can_hold = list(/obj/item/reagent_container/food/snacks)
	w_class = SIZE_MEDIUM

/obj/item/storage/box/donkpockets/fill_preset_inventory()
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)

/obj/item/storage/box/monkeycubes
	name = "monkey cube box"
	desc = "Drymate brand monkey cubes. Just add water!"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "monkeycubebox"

/obj/item/storage/box/monkeycubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped(src)

/obj/item/storage/box/monkeycubes/farwacubes
	name = "farwa cube box"
	desc = "Drymate brand farwa cubes, shipped from Ahdomai. Just add water!"

/obj/item/storage/box/monkeycubes/farwacubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped/farwacube(src)

/obj/item/storage/box/monkeycubes/stokcubes
	name = "stok cube box"
	desc = "Drymate brand stok cubes, shipped from Moghes. Just add water!"

/obj/item/storage/box/monkeycubes/stokcubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped/stokcube(src)

/obj/item/storage/box/monkeycubes/neaeracubes
	name = "neaera cube box"
	desc = "Drymate brand neaera cubes, shipped from Jargon 4. Just add water!"

/obj/item/storage/box/monkeycubes/neaeracubes/fill_preset_inventory()
	for(var/i = 1; i <= 5; i++)
		new /obj/item/reagent_container/food/snacks/monkeycube/wrapped/neaeracube(src)

/obj/item/storage/box/ids
	name = "box of spare IDs"
	desc = "Has so many empty IDs."
	icon_state = "id"

/obj/item/storage/box/ids/fill_preset_inventory()
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)
	new /obj/item/card/id(src)


/obj/item/storage/box/handcuffs
	name = "box of handcuffs"
	desc = "A box full of handcuffs."
	icon_state = "handcuff"

/obj/item/storage/box/handcuffs/fill_preset_inventory()
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)
	new /obj/item/restraint/handcuffs(src)


/obj/item/storage/box/legcuffs
	name = "box of legcuffs"
	desc = "A box full of legcuffs."
	icon_state = "handcuff"

/obj/item/storage/box/legcuffs/fill_preset_inventory()
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)
	new /obj/item/restraint/legcuffs(src)

/obj/item/storage/box/zipcuffs
	name = "box of zip cuffs"
	desc = "A box full of zip cuffs."
	icon_state = "handcuff"

/obj/item/storage/box/zipcuffs/fill_preset_inventory()
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)

/obj/item/storage/box/zipcuffs/small
	name = "small box of zip cuffs"
	desc = "A small box full of zip cuffs."
	w_class = SIZE_MEDIUM

/obj/item/storage/box/zipcuffs/fill_preset_inventory()
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)
	new /obj/item/restraint/handcuffs/zip(src)

/obj/item/storage/box/tapes
	name = "box of regulation tapes"
	desc = "A box full of magnetic tapes for tape recorders. Contains 10 hours and 40 minutes of recording space!"

/obj/item/storage/box/tapes/fill_preset_inventory()
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)
	new /obj/item/tape/regulation(src)

/obj/item/storage/box/mousetraps
	name = "box of Pest-B-Gon mousetraps"
	desc = "<B><FONT color='red'>WARNING:</FONT></B> <I>Keep out of reach of children</I>."
	icon_state = "mousetraps"

/obj/item/storage/box/mousetraps/fill_preset_inventory()
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )
	new /obj/item/device/assembly/mousetrap( src )

/obj/item/storage/box/pillbottles
	name = "box of pill bottles"
	desc = "It has pictures of pill bottles on its front."
	icon_state = "pillbox"

/obj/item/storage/box/pillbottles/fill_preset_inventory()
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )
	new /obj/item/storage/pill_bottle( src )


/obj/item/storage/box/snappops
	name = "snap pop box"
	desc = "Eight wrappers of fun! Ages 8 and up. Not suitable for children."
	icon = 'icons/obj/items/toy.dmi'
	icon_state = "spbox"
	max_storage_space = 8

/obj/item/storage/box/snappops/fill_preset_inventory()
	for(var/i=1; i <= 8; i++)
		new /obj/item/toy/snappop(src)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = "A small box of 'Space-Proof' premium matches."
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = SIZE_TINY
	flags_equip_slot = SLOT_WAIST
	can_hold = list(/obj/item/tool/match)

/obj/item/storage/box/matches/fill_preset_inventory()
	for(var/i=1; i <= 14; i++)
		new /obj/item/tool/match(src)

/obj/item/storage/box/matches/attackby(obj/item/tool/match/W as obj, mob/user as mob)
	if(istype(W) && !W.heat_source && !W.burnt)
		W.light_match()

/obj/item/storage/box/lights
	name = "box of replacement bulbs"
	icon = 'icons/obj/items/storage.dmi'
	icon_state = "light"
	desc = "This box is shaped on the inside so that only light tubes and bulbs fit."
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard //BubbleWrap
	can_hold = list(
		/obj/item/light_bulb/tube,
		/obj/item/light_bulb/bulb,
	)
	max_storage_space = 42 //holds 21 items of w_class 2
	storage_flags = STORAGE_FLAGS_BOX|STORAGE_CLICK_GATHER

/obj/item/storage/box/lights/bulbs/fill_preset_inventory()
	for(var/i = 0; i < 21; i++)
		new /obj/item/light_bulb/bulb(src)

/obj/item/storage/box/lights/tubes
	name = "box of replacement tubes"
	icon_state = "lighttube"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/lights/tubes/fill_preset_inventory()
	for(var/i = 0; i < 21; i++)
		new /obj/item/light_bulb/tube/large(src)

/obj/item/storage/box/lights/mixed
	name = "box of replacement lights"
	icon_state = "lightmixed"

/obj/item/storage/box/lights/mixed/fill_preset_inventory()
	for(var/i = 0; i < 14; i++)
		new /obj/item/light_bulb/tube/large(src)
	for(var/i = 0; i < 7; i++)
		new /obj/item/light_bulb/bulb(src)


/obj/item/storage/box/autoinjectors
	name = "box of autoinjectors"
	icon_state = "syringe"

/obj/item/storage/box/autoinjectors/fill_preset_inventory()
	for(var/i = 0; i < 7; i++)
		new /obj/item/reagent_container/hypospray/autoinjector/empty(src)


/obj/item/storage/box/twobore
	name = "box of 2 bore shells"
	icon_state = "twobore"
	desc = "A box filled with enormous slug shells, for hunting only the most dangerous game. 2 Bore."
	storage_slots = 5
	can_hold = list(/obj/item/ammo_magazine/handful/shotgun/twobore)

/obj/item/storage/box/twobore/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/ammo_magazine/handful/shotgun/twobore(src)

////////// MARINES BOXES //////////////////////////


/obj/item/storage/box/explosive_mines
	name = "\improper M20 mine box"
	desc = "A secure box holding five M20 anti-personnel proximity mines."
	icon_state = "minebox"
	w_class = SIZE_MEDIUM
	max_storage_space = 10
	can_hold = list(/obj/item/explosive/mine)

/obj/item/storage/box/explosive_mines/fill_preset_inventory()
	for(var/i in 1 to 5)
		new /obj/item/explosive/mine(src)

/obj/item/storage/box/explosive_mines/pmc
	name = "\improper M20P mine box"

/obj/item/storage/box/explosive_mines/pmc/fill_preset_inventory()
	for(var/i in 1 to 5)
		new /obj/item/explosive/mine/pmc(src)

/obj/item/storage/box/m94
	name = "\improper M94 marking flare pack"
	desc = "A packet of eight M94 Marking Flares. Carried by USCM soldiers to light dark areas that cannot be reached with the usual TNR Shoulder Lamp."
	icon_state = "m94"
	w_class = SIZE_MEDIUM
	storage_slots = 8
	max_storage_space = 8
	can_hold = list(/obj/item/device/flashlight/flare,/obj/item/device/flashlight/flare/signal)

/obj/item/storage/box/m94/fill_preset_inventory()
	for(var/i = 1 to max_storage_space)
		new /obj/item/device/flashlight/flare(src)

/obj/item/storage/box/m94/update_icon()
	if(!length(contents))
		icon_state = "m94_e"
	else
		icon_state = "m94"


/obj/item/storage/box/m94/signal
	name = "\improper M89-S signal flare pack"
	desc = "A packet of eight M89-S Signal Marking Flares."
	icon_state = "m89"

/obj/item/storage/box/m94/signal/fill_preset_inventory()
	for(var/i = 1 to max_storage_space)
		new /obj/item/device/flashlight/flare/signal(src)

/obj/item/storage/box/m94/signal/update_icon()
	if(!length(contents))
		icon_state = "m89_e"
	else
		icon_state = "m89"


/obj/item/storage/box/nade_box
	name = "\improper M40 HEDP grenade box"
	desc = "A secure box holding 25 M40 High-Explosive Dual-Purpose grenades. High explosive, don't store near the flamer fuel."
	icon_state = "nade_placeholder"
	w_class = SIZE_LARGE
	storage_slots = 25
	max_storage_space = 50
	can_hold = list(/obj/item/explosive/grenade/high_explosive)
	var/base_icon
	var/grenade_type = /obj/item/explosive/grenade/high_explosive
	has_gamemode_skin = TRUE

/obj/item/storage/box/nade_box/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(try_forced_folding))

/obj/item/storage/box/nade_box/proc/try_forced_folding(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!isturf(loc))
		return

	if(length(contents))
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	storage_close(user)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	qdel(src)

/obj/item/storage/box/nade_box/post_skin_selection()
	base_icon = icon_state

/obj/item/storage/box/nade_box/fill_preset_inventory()
	for(var/i = 1 to storage_slots)
		new grenade_type(src)

/obj/item/storage/box/nade_box/update_icon()
	if(!length(contents))
		icon_state = "[base_icon]_e"
	else
		icon_state = base_icon


/obj/item/storage/box/nade_box/frag
	name = "\improper M40 HEFA grenade box"
	desc = "A secure box holding 25 M40 High-Explosive Fragmenting-Antipersonnel grenades. High explosive, don't store near the flamer fuel."
	icon_state = "frag_nade_placeholder"
	w_class = SIZE_LARGE
	storage_slots = 25
	max_storage_space = 50
	can_hold = list(/obj/item/explosive/grenade/high_explosive/frag)
	grenade_type = /obj/item/explosive/grenade/high_explosive/frag
	has_gamemode_skin = FALSE

/obj/item/storage/box/nade_box/phophorus
	name = "\improper M40 HPDP grenade box"
	desc = "A secure box holding 25 M40 HPDP white phosphorus grenade. High explosive, don't store near the flamer fuel."
	icon_state = "phos_nade_placeholder"
	w_class = SIZE_LARGE
	storage_slots = 25
	max_storage_space = 50
	can_hold = list(/obj/item/explosive/grenade/phosphorus)
	grenade_type = /obj/item/explosive/grenade/phosphorus
	has_gamemode_skin = FALSE

/obj/item/storage/box/nade_box/airburst
	name = "\improper M74 AGM-F grenade box"
	desc = "A secure box holding 25 M74 AGM Fragmentation grenades. Explosive, don't store near the flamer fuel."
	icon_state = "airburst_nade_placeholder"
	w_class = SIZE_LARGE
	storage_slots = 25
	max_storage_space = 50
	can_hold = list(/obj/item/explosive/grenade/high_explosive/airburst)
	grenade_type = /obj/item/explosive/grenade/high_explosive/airburst
	has_gamemode_skin = FALSE

/obj/item/storage/box/nade_box/training
	name = "\improper M07 training grenade box"
	desc = "A secure box holding 25 M07 training grenades. Harmless and reusable."
	icon_state = "train_nade_placeholder"
	grenade_type = /obj/item/explosive/grenade/high_explosive/training
	can_hold = list(/obj/item/explosive/grenade/high_explosive/training)
	has_gamemode_skin = FALSE

/obj/item/storage/box/nade_box/tear_gas
	name = "\improper M66 tear gas grenade box"
	desc = "A secure box holding 25 M66 tear gas grenades. Used for riot control."
	icon_state = "teargas_nade_placeholder"
	can_hold = list(/obj/item/explosive/grenade/custom/teargas)
	grenade_type = /obj/item/explosive/grenade/custom/teargas
	has_gamemode_skin = FALSE

/obj/item/storage/box/nade_box/tear_gas/fill_preset_inventory()
	..()
	if(SSticker.mode && MODE_HAS_FLAG(MODE_FACTION_CLASH))
		handle_delete_clash_contents()
	else if(SSticker.current_state < GAME_STATE_PLAYING)
		RegisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP, PROC_REF(handle_delete_clash_contents))

/obj/item/storage/box/nade_box/tear_gas/proc/handle_delete_clash_contents()
	if(MODE_HAS_FLAG(MODE_FACTION_CLASH))
		var/grenade_count = 0
		var/grenades_desired = 6
		for(var/grenade in contents)
			if(grenade_count > grenades_desired)
				qdel(grenade)
			grenade_count++
	UnregisterSignal(SSdcs, COMSIG_GLOB_MODE_PRESETUP)


//ITEMS-----------------------------------//
/obj/item/storage/box/lightstick
	name = "box of lightsticks"
	desc = "Contains blue lightsticks."
	icon_state = "lightstick"
	can_hold = list(/obj/item/lightstick)

/obj/item/storage/box/lightstick/fill_preset_inventory()
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)
	new /obj/item/lightstick(src)

/obj/item/storage/box/lightstick/red
	desc = "Contains red lightsticks."
	icon_state = "lightstick2"

/obj/item/storage/box/lightstick/red/fill_preset_inventory()
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)
	new /obj/item/lightstick/red(src)

/obj/item/storage/box/MRE
	name = "\improper USCM MRE"
	desc = "A Meal, Ready-to-Eat. A single-meal combat ration designed to provide a soldier with enough nutrients for a day of strenuous work. Its expiration date is at least 20 years ahead of your combat life expectancy."
	icon_state = "mealpack"
	w_class = SIZE_SMALL
	can_hold = list()
	storage_slots = 7
	max_w_class = 0
	use_sound = "rip"
	var/isopened = FALSE

/obj/item/storage/box/MRE/fill_preset_inventory()
	pickflavor()

/obj/item/storage/box/MRE/proc/pickflavor()
	var/main = pick("boneless pork ribs", "grilled chicken", "pizza square", "spaghetti chunks", "chicken tender")
	var/second = pick("cracker", "cheese spread", "rice onigiri", "mashed potatoes", "risotto")
	var/side = pick("biscuit", "meatballs", "pretzels", "peanuts", "sushi")
	var/desert = pick("spiced apples", "chocolate brownie", "sugar cookie", "coco bar", "flan", "honey flan")
	name = "[initial(name)] ([main])"
	//1 in 3 chance of getting a fortune cookie
	var/cookie = rand(1,3)
	var/matches_type = rand(1, 5)
	if(cookie == 1)
		storage_slots = 8
	new /obj/item/reagent_container/food/snacks/packaged_meal(src, main)
	new /obj/item/reagent_container/food/snacks/packaged_meal(src, second)
	new /obj/item/reagent_container/food/snacks/packaged_meal(src, side)
	new /obj/item/reagent_container/food/snacks/packaged_meal(src, desert)
	new /obj/item/reagent_container/food/drinks/cans/waterbottle(src)
	if(cookie == 1)
		new /obj/item/reagent_container/food/snacks/fortunecookie/prefilled(src)
	new /obj/item/storage/fancy/cigarettes/lucky_strikes_4(src)
	switch(matches_type)
		if(1)
			new /obj/item/storage/fancy/cigar/matchbook(src)
		if(2)
			new /obj/item/storage/fancy/cigar/matchbook/koorlander(src)
		if(3)
			new /obj/item/storage/fancy/cigar/matchbook/exec_select(src)
		if(4)
			new /obj/item/storage/fancy/cigar/matchbook/wy_gold(src)
		if(5)
			new /obj/item/storage/fancy/cigar/matchbook/brown(src)

/obj/item/storage/box/MRE/Initialize()
	. = ..()
	isopened = FALSE
	icon_state = "mealpack"
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(try_forced_folding))

/obj/item/storage/box/MRE/proc/try_forced_folding(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!isturf(loc))
		return

	if(locate(/obj/item/reagent_container/food/snacks/packaged_meal) in src)
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	storage_close(user)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	qdel(src)

/obj/item/storage/box/MRE/update_icon()
	if(!isopened)
		isopened = TRUE
		icon_state = "mealpackopened"

//food boxes for storage in bulk

//meat
/obj/item/storage/box/meat
	name = "box of meat"

/obj/item/storage/box/meat/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/meat/monkey(src)

//fish
/obj/item/storage/box/fish
	name = "box of fish"

/obj/item/storage/box/fish/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/carpmeat(src)

//grocery

//milk
/obj/item/storage/box/milk
	name = "box of milk"

/obj/item/storage/box/milk/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/drinks/milk(src)

//soymilk
/obj/item/storage/box/soymilk
	name = "box of soymilk"

/obj/item/storage/box/soymilk/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/drinks/soymilk(src)

//enzyme
/obj/item/storage/box/enzyme
	name = "box of enzyme"

/obj/item/storage/box/enzyme/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/enzyme(src)

//dry storage

//flour
/obj/item/storage/box/flour
	name = "box of flour"

/obj/item/storage/box/flour/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/flour(src)

//sugar
/obj/item/storage/box/sugar
	name = "box of sugar"

/obj/item/storage/box/sugar/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/sugar(src)

//saltshaker
/obj/item/storage/box/saltshaker
	name = "box of saltshakers"

/obj/item/storage/box/saltshaker/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/saltshaker(src)

//peppermill
/obj/item/storage/box/peppermill
	name = "box of peppermills"

/obj/item/storage/box/peppermill/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/condiment/peppermill(src)

//mint
/obj/item/storage/box/mint
	name = "box of mints"

/obj/item/storage/box/mint/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/mint(src)

// ORGANICS

//apple
/obj/item/storage/box/apple
	name = "box of apples"

/obj/item/storage/box/apple/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/apple(src)

//banana
/obj/item/storage/box/banana
	name = "box of bananas"

/obj/item/storage/box/banana/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/banana(src)

//chanterelle
/obj/item/storage/box/chanterelles
	name = "box of chanterelle"

/obj/item/storage/box/chanterelle/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/mushroom/chanterelle(src)

//cherries
/obj/item/storage/box/cherries
	name = "box of cherries"

/obj/item/storage/box/cherries/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/cherries(src)

//chili
/obj/item/storage/box/chili
	name = "box of chili"

/obj/item/storage/box/chili/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/chili(src)

//cabbage
/obj/item/storage/box/cabbage
	name = "box of cabbages"

/obj/item/storage/box/cabbage/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/cabbage(src)

//carrot
/obj/item/storage/box/carrot
	name = "box of carrots"

/obj/item/storage/box/carrot/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/carrot(src)

//corn
/obj/item/storage/box/corn
	name = "box of corn"

/obj/item/storage/box/corn/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/corn(src)

//eggplant
/obj/item/storage/box/eggplant
	name = "box of eggplants"

/obj/item/storage/box/eggplant/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/eggplant(src)

//lemon
/obj/item/storage/box/lemon
	name = "box of lemons"

/obj/item/storage/box/lemon/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/lemon(src)

//lime
/obj/item/storage/box/lime
	name = "box of limes"

/obj/item/storage/box/lime/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/lime(src)

//orange
/obj/item/storage/box/orange
	name = "box of oranges"

/obj/item/storage/box/orange/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/orange(src)

//potato
/obj/item/storage/box/potato
	name = "box of potatoes"

/obj/item/storage/box/potato/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/potato(src)

//tomato
/obj/item/storage/box/tomato
	name = "box of tomatoes"

/obj/item/storage/box/tomato/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/tomato(src)

//whitebeet
/obj/item/storage/box/whitebeet
	name = "box of whitebeet"

/obj/item/storage/box/whitebeet/fill_preset_inventory()
	for(var/i in 1 to 7)
		new /obj/item/reagent_container/food/snacks/grown/whitebeet(src)
