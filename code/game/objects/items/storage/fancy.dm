/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 *		Cigar Box
 */

/obj/item/storage/fancy
	icon = 'icons/obj/items/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	var/icon_type = "donut"

/obj/item/storage/fancy/update_icon()
	icon_state = "[icon_type]box[contents.len]"

/obj/item/storage/fancy/remove_from_storage(obj/item/W, atom/new_location)
	. = ..()
	if(.)
		update_icon()


/obj/item/storage/fancy/get_examine_text(mob/user)
	..()
	if(contents.len <= 0)
		. += "There are no [src.icon_type]s left in the box."
	else if(contents.len == 1)
		. += "There is one [src.icon_type] left in the box."
	else
		. += "There are [src.contents.len] [src.icon_type]s in the box."


/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/items/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	max_storage_space = 24
	can_hold = list(/obj/item/reagent_container/food/snacks/egg)

/obj/item/storage/fancy/egg_box/fill_preset_inventory()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/reagent_container/food/snacks/egg(src)
	return

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/items/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	storage_slots = 5
	throwforce = 2
	flags_equip_slot = SLOT_WAIST


/obj/item/storage/fancy/candle_box/fill_preset_inventory()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/tool/candle(src)
	return

/*
 * Crayon Box
 */

/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of every flavor of crayon."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonbox"
	w_class = SIZE_SMALL
	storage_slots = 6
	icon_type = "crayon"
	can_hold = list(/obj/item/toy/crayon)

/obj/item/storage/fancy/crayons/fill_preset_inventory()
	new /obj/item/toy/crayon/red(src)
	new /obj/item/toy/crayon/orange(src)
	new /obj/item/toy/crayon/yellow(src)
	new /obj/item/toy/crayon/green(src)
	new /obj/item/toy/crayon/blue(src)
	new /obj/item/toy/crayon/purple(src)

/obj/item/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/items/crayons.dmi',"crayonbox")
	for(var/obj/item/toy/crayon/crayon in contents)
		overlays += image('icons/obj/items/crayons.dmi',crayon.colourName)

/obj/item/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/toy/crayon))
		switch(W:colourName)
			if("mime")
				to_chat(usr, "This crayon is too sad to be contained in this box.")
				return
			if("rainbow")
				to_chat(usr, "This crayon is too powerful to be contained in this box.")
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	icon = 'icons/obj/items/cigarettes.dmi'
	w_class = SIZE_TINY
	throwforce = 2
	flags_equip_slot = SLOT_WAIST
	max_w_class = SIZE_TINY
	storage_slots = 20
	can_hold = list(
		/obj/item/clothing/mask/cigarette,
		/obj/item/clothing/mask/cigarette/ucigarette,
		/obj/item/clothing/mask/cigarette/bcigarette,
		/obj/item/tool/lighter
	)
	icon_type = "cigarette"
	var/default_cig_type=/obj/item/clothing/mask/cigarette

/obj/item/storage/fancy/cigarettes/fill_preset_inventory()
	flags_atom |= NOREACT
	for(var/i = 1 to storage_slots)
		new default_cig_type(src)
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one

/obj/item/storage/fancy/cigarettes/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_selected == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/cigarette/C = locate() in src
		if(C)
			remove_from_storage(C, get_turf(user))
			user.equip_to_slot_if_possible(C, WEAR_FACE)
			to_chat(user, SPAN_NOTICE("You take a cigarette out of the pack."))
			update_icon()
	else
		..()

/obj/item/storage/fancy/cigarettes/emeraldgreen
	name = "\improper Emerald Green Packet"
	desc = "They remind you of a gross, tar-filled version of Ireland...so regular Ireland."
	icon_state = "cigpacket"
	item_state = "cigpacket"

/obj/item/storage/fancy/cigarettes/wypacket
	name = "\improper Weyland-Yutani Gold packet"
	desc = "Building Better Worlds, and rolling better cigarettes. These fancy cigarettes are Weyland-Yutani's entry into the market. Comes backed by a fierce legal team."
	icon_state = "wypacket"
	item_state = "wypacket"

/obj/item/storage/fancy/cigarettes/lucky_strikes
	name = "\improper Lucky Strikes Packet"
	desc = "Lucky Strikes Means Fine Tobacco! 9/10 doctors agree on Lucky Strikes...as the leading cause of marine lung cancer."
	icon_state = "lspacket"
	item_state = "lspacket"
	default_cig_type = /obj/item/clothing/mask/cigarette/ucigarette

/obj/item/storage/fancy/cigarettes/blackpack
	name = "\improper Executive Select packet"
	desc = "These cigarettes are the height of luxury. They're smooth, they're cool, and they smell like victory...and cigarette smoke."
	icon_state = "blackpacket"
	item_state = "blackpacket"
	default_cig_type = /obj/item/clothing/mask/cigarette/bcigarette

/obj/item/storage/fancy/cigarettes/kpack
	name = "\improper Koorlander Gold packet"
	desc = "Lovingly machine-rolled for YOUR pleasure. For when you want to look cool and the risk of a slow horrible death isn't really a factor."
	icon_state = "kpacket"
	item_state = "kpacket"

/obj/item/storage/fancy/cigarettes/arcturian_ace
	name = "\improper Arcturian Ace packet"
	desc = "An entry level brand of cigarettes with a bright blue packaging. You're guessing these aren't really good for you, but it doesn't matter when it's Arcturian baby!"
	icon_state = "aapacket"
	item_state = "aapacket"

/obj/item/storage/fancy/cigarettes/lady_finger
	name = "\improper Lady Fingers packet"
	desc = "These intensely strong unfiltered menthol cigarettes don't seem very ladylike. They don't seem very fingerlike for that matter, either. Smoking may kill, but poor branding is almost as bad."
	icon_state = "lfpacket"
	item_state = "lfpacket"
	default_cig_type = /obj/item/clothing/mask/cigarette/ucigarette

/obj/item/storage/fancy/cigarettes/lucky_strikes_4
	name = "\improper Lucky Strikes Mini Packet"
	desc = "These four-packs of Luckies come in every MRE. They're not as good as the Habana Reals that come in the LACN MREs, but at least they're free."
	icon_state = "ls4packet"
	item_state = "lspacket"
	default_cig_type = /obj/item/clothing/mask/cigarette/ucigarette
	storage_slots = 4

/////////////
//CIGAR BOX//
/////////////

/obj/item/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/items/cigarettes.dmi'
	throwforce = 2
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_WAIST
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/cigarette/cigar)
	icon_type = "cigar"
	var/default_cigar_type = /obj/item/clothing/mask/cigarette/cigar

/obj/item/storage/fancy/cigar/fill_preset_inventory()
	flags_atom |= NOREACT
	for(var/i = 1 to storage_slots)
		new default_cigar_type(src)
	create_reagents(15 * storage_slots)

/obj/item/storage/fancy/cigar/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)]"

/obj/item/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/storage/fancy/cigar/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return

	if(M == user && user.zone_selected == "mouth" && contents.len > 0 && !user.wear_mask)
		var/obj/item/clothing/mask/cigarette/cigar/C = locate() in src
		if(C)
			remove_from_storage(C, get_turf(user))
			user.equip_to_slot_if_possible(C, WEAR_FACE)
			to_chat(user, SPAN_NOTICE("You remove a cigar."))
			update_icon()
	else
		..()

/obj/item/storage/fancy/cigar/tarbacks
	name = "\improper Tarbacks case"
	desc = "Don't let the fancy box and piece of paper spouting nonsense about tradition and quality fool you. These stogies are bottom of the barrel. Rolled in Columbia."
	icon_state = "tarbackbox"
	item_state = "tarbackbox"
	storage_slots = 5
	default_cigar_type = /obj/item/clothing/mask/cigarette/cigar/tarbacks

/obj/item/storage/fancy/cigar/tarbacktube
	name = "\improper Tarback tube"
	desc = "A single Tarback cigar in a protective metal tube. About as low-end as you can get. Rolled in Columbia."
	icon_state = "tarbacktube"
	item_state = "tarbacktube"
	storage_slots = 1
	default_cigar_type = /obj/item/clothing/mask/cigarette/cigar/tarbacks

/obj/item/storage/fancy/cigar/matchbook
	name = "\improper Lucky Strikes matchbook"
	desc = "A small book of cheap paper matches. Good luck getting them to light. Made by Lucky Strikes, but you'll be anything but lucky when you burn your hand trying to light a match on this."
	icon_state = "mpacket"
	item_state = "zippo"
	storage_slots = 6
	can_hold = list()
	icon_type = "match"
	default_cigar_type = /obj/item/tool/match/paper
	w_class = SIZE_TINY
	var/light_chance = 70 //how likely you are to light the match on the book
	var/burn_chance = 20 //how likely you are to burn yourself once you light it

/obj/item/storage/fancy/cigar/matchbook/attackby(obj/item/tool/match/W as obj, mob/living/carbon/human/user as mob)
	if(!istype(user))
		return
	if(prob(light_chance))
		if(istype(W) && !W.heat_source && !W.burnt)
			if(prob(burn_chance))
				to_chat(user, SPAN_WARNING("\The [W] lights, but you burn your hand in the process! Ouch!"))
				user.apply_damage(3, BRUTE, pick("r_hand", "l_hand"))
				if((user.pain.feels_pain) && prob(25))
					user.emote("scream")
				W.light_match()
			else
				W.light_match()
				to_chat(user, SPAN_NOTICE("You light \the [W] on \the [src]."))
	else
		to_chat(user, SPAN_NOTICE("\The [W] fails to light."))

/obj/item/storage/fancy/cigar/matchbook/brown
	name = "brown matchbook"
	desc = "A small book of cheap paper matches. Good luck getting them to light. Made with generic brown paper."
	icon_state = "mpacket_br"

/obj/item/storage/fancy/cigar/matchbook/koorlander
	name = "\improper Koorlander matchbook"
	desc = "A small book of cheap paper matches. Good luck getting them to light."
	icon_state = "mpacket_kl"

/obj/item/storage/fancy/cigar/matchbook/exec_select
	name = "\improper Executive Select matchbook"
	desc = "A small book of expensive paper matches. These ones light almost every time!"
	icon_state = "mpacket_es"
	light_chance = 90
	burn_chance = 0

/obj/item/storage/fancy/cigar/matchbook/wy_gold
	name = "\improper Weyland-Yutani Gold matchbook"
	desc = "A small book of expensive paper matches. These ones light almost every time, or so the packaging claims."
	icon_state = "mpacket_wy"
	light_chance = 60
	burn_chance = 40

/*
 * Vial Box
 */

/obj/item/storage/fancy/vials
	icon = 'icons/obj/items/vialbox.dmi'
	icon_state = "vialbox0"
	icon_type = "vial"
	name = "vial storage box"
	is_objective = TRUE
	storage_slots = 6
	storage_flags = STORAGE_FLAGS_DEFAULT|STORAGE_CLICK_GATHER
	can_hold = list(/obj/item/reagent_container/glass/beaker/vial,/obj/item/reagent_container/hypospray/autoinjector)
	matter = list("plastic" = 2000)
	var/start_vials = 6
	var/is_random


/obj/item/storage/fancy/vials/fill_preset_inventory()
	if(is_random)
		var/spawns = rand(1,4)
		for(var/i=1; i <= storage_slots; i++)
			if(i<=spawns)
				new /obj/item/reagent_container/glass/beaker/vial/random(src)
			else
				new /obj/item/reagent_container/glass/beaker/vial(src)
	else
		for(var/i=1; i <= start_vials; i++)
			new /obj/item/reagent_container/glass/beaker/vial(src)

/obj/item/storage/fancy/vials/random
	unacidable = TRUE
	is_random = 1

/obj/item/storage/fancy/vials/empty
	start_vials = 0

/obj/item/storage/fancy/vials/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/storage/pouch/vials))
		var/obj/item/storage/pouch/vials/M = W
		dump_into(M,user)
	else if(istype(W, /obj/item/storage/box/autoinjectors))
		var/obj/item/storage/box/autoinjectors/M = W
		dump_into(M,user)
	else
		return ..()

/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/items/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = SIZE_MEDIUM
	can_hold = list(/obj/item/reagent_container/glass/beaker/vial)
	max_storage_space = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(ACCESS_MARINE_MEDBAY)

/obj/item/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/storage/lockbox/vials/attackby(obj/item/W as obj, mob/user as mob)
	..()
	update_icon()
