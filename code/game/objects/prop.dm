/obj/item/prop
	name = "prop"
	desc = "Some kind of prop."

/// A prop that acts as a replacement for another item, mimicking their looks.
/// Mainly used in Reqs Tutorial to provide the full item selections without side effects.
/obj/item/prop/replacer
	/// The type that this object is taking the place of
	var/original_type

/obj/item/prop/replacer/Initialize(mapload, obj/original_type)
	if(!original_type)
		return INITIALIZE_HINT_QDEL
	. = ..()
	src.original_type = original_type
	var/obj/created_type = new original_type // Instancing this for the sake of assigning its appearance to the prop and nothing else
	name = initial(original_type.name)
	icon = initial(original_type.icon)
	icon_state = initial(original_type.icon_state)
	desc = initial(original_type.desc)
	if(ispath(original_type, /obj/item))
		var/obj/item/item_type = original_type
		item_state = initial(item_type.item_state)

	appearance = created_type.appearance
	qdel(created_type)

/obj/item/prop/laz_top
	name = "lazertop"
	desc = "A Rexim RXF-M5 EVA pistol compressed down into a laptop! Also known as the Laz-top. Part of a line of discreet assassination weapons developed for Greater Argentina and the United States covert programs respectively."
	icon_state = "laptop-gun"
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	item_state = ""
	w_class = SIZE_SMALL
	garbage = TRUE

/obj/item/prop/geiger_counter
	name = "geiger counter"
	desc = "A geiger counter measures the radiation it receives. This type automatically records and transfers any information it reads, provided it has a battery, with no user input required beyond being enabled."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "geiger"
	item_state = ""
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_WAIST
	///Whether the geiger counter is on or off
	var/toggled_on = FALSE
	///Iconstate of geiger counter when on
	var/enabled_state = "geiger_on"
	///Iconstate of geiger counter when off
	var/disabled_state = "geiger"
	///New battery it will spawn with
	var/starting_battery = /obj/item/cell/crap
	///Battery inside geiger counter
	var/obj/item/cell/battery //It doesn't drain the battery, but it has a battery for emergency use

/obj/item/prop/geiger_counter/Initialize(mapload, ...)
	. = ..()
	if(!starting_battery)
		return
	battery = new starting_battery(src)

/obj/item/prop/geiger_counter/Destroy()
	. = ..()
	if(battery)
		qdel(battery)

/obj/item/prop/geiger_counter/attack_self(mob/user)
	. = ..()
	toggled_on = !toggled_on
	if(!battery)
		to_chat(user, SPAN_NOTICE("[src] is missing a battery."))
		return
	to_chat(user, SPAN_NOTICE("You [toggled_on ? "enable" : "disable"] [src]."))
	update_icon()

/obj/item/prop/geiger_counter/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(!HAS_TRAIT(attacking_item, TRAIT_TOOL_SCREWDRIVER) && !HAS_TRAIT(attacking_item, TRAIT_TOOL_CROWBAR))
		return

	if(!battery)
		to_chat(user, SPAN_NOTICE("There is no battery for you to remove."))
		return
	to_chat(user, SPAN_NOTICE("You jam [battery] out of [src] with [attacking_item], prying it out irreversibly."))
	user.put_in_hands(battery)
	battery = null
	update_icon()

/obj/item/prop/geiger_counter/update_icon()
	. = ..()

	if(battery && toggled_on)
		icon_state = enabled_state
		return
	icon_state = disabled_state

/obj/item/prop/tableflag
	name = "United Americas table flag"
	desc = "A miniature table flag of the United Americas, representing all of North, South, and Central America."
	icon = 'icons/obj/items/table_decorations.dmi'
	icon_state = "uaflag"
	force = 0.5
	w_class = SIZE_SMALL

/obj/item/prop/tableflag/uscm
	name = "USCM table flag"
	desc = "A miniature table flag of the United States Colonial Marines. 'Semper Fi' is written on the flag's bottom."
	icon_state = "uscmflag"

/obj/item/prop/tableflag/uscm2
	name = "USCM historical table flag"
	desc = "A miniature historical table flag of the United States Colonial Marines, in traditional scarlet and gold. The USCM logo sits in the center; an eagle is perched atop it and an anchor rests behind it."
	icon_state = "uscmflag2"

/obj/item/prop/tableflag/upp
	name = "UPP table flag"
	desc = "A miniature table flag of the Union of Progressive Peoples, consisting of 17 yellow stars, surrounding the bigger one in the middle on scarlet field."
	icon_state = "uppflag"

/obj/item/prop/flower_vase
	name = "flower vase"
	desc = "An empty glass flower vase."
	icon_state = "flowervase"
	icon = 'icons/obj/items/table_decorations.dmi'
	w_class = SIZE_SMALL

/obj/item/prop/flower_vase/bluewhiteflowers
	name = "vase of blue and white flowers"
	desc = "A flower vase filled with blue and white roses."
	icon_state = "bluewhiteflowers"

/obj/item/prop/flower_vase/redwhiteflowers
	name = "vase of red and white flowers"
	desc = "A flower vase filled with red and white roses."
	icon_state = "redwhiteflowers"

/obj/item/prop/colony/usedbandage
	name = "dirty bandages"
	desc = "Some used gauze."
	icon_state = "bandages_prop"
	icon = 'icons/obj/structures/props/furniture/misc.dmi'

/obj/item/prop/colony/used_flare
	name = "flare"
	desc = "A used USCM issued flare. There are instructions on the side, it reads 'pull cord, make light'."
	icon_state = "flare-empty"
	icon = 'icons/obj/items/lighting.dmi'

/obj/item/prop/colony/canister
	name = "fuel can"
	desc = "A jerry can. In space! Or maybe a colony."
	icon_state = "canister"
	icon = 'icons/obj/items/tank.dmi'

/obj/item/prop/colony/proptag
	name = "information dog tag"
	desc = "A fallen marine's information dog tag. It reads,(BLANK)"
	icon_state = "dogtag_taken"
	icon = 'icons/obj/items/card.dmi'

/obj/item/prop/colony/game
	name = "portable game kit"
	desc = "A ThinkPad Systems Game-Bro Handheld (TSGBH, shortened). It can play chess, checkers, tri-d chess, and it also runs Byond! Except this one is out of batteries."
	icon_state = "game_kit"
	icon = 'icons/obj/items/toy.dmi'

/obj/item/prop/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool for synthetic assets."
	icon_state = "gripper"
	icon = 'icons/obj/items/devices.dmi'

/obj/item/prop/matter_decompiler
	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon_state = "decompiler"
	icon = 'icons/obj/items/devices.dmi'

/// Xeno-specific props

/obj/item/prop/alien/hugger
	name = "????"
	desc = "It has some sort of a tube at the end of its tail. What the hell is this thing?"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "facehugger_impregnated"

//-----USS Almayer Props -----//
//Put any props that don't function properly, they could function in the future but for now are for looks. This system could be expanded for other maps too. ~Art

/obj/item/prop/almayer
	name = "GENERIC USS ALMAYER PROP"
	desc = "THIS SHOULDN'T BE VISIBLE, IF YOU SEE THIS THERE IS A PROBLEM IN THE PROP.DM FILE MAKE A BUG REPORT "
	icon = 'icons/obj/structures/props/almayer/almayer_props.dmi'
	icon_state = "hangarbox"

/obj/item/prop/almayer/box
	name = "metal crate"
	desc = "A metal crate used often for storing small electronics that go into dropships"
	icon_state = "hangarbox"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/flight_recorder
	name = "\improper FR-112 flight recorder"
	desc = "A small red box that contains flight data from a dropship while it's on mission. Usually referred to as the black box, although this one comes in bloody red."
	icon_state = "flight_recorder"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/flight_recorder/colony
	name = "\improper CIR-60 colony information recorder"
	desc = "A small red box that records colony announcements, colonist flatlines and other key readouts. Usually refered to the black box, although this one comes in bloody red."
	icon_state = "flight_recorder"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/flare_launcher
	name = "\improper MJU-77/C case"
	desc = "A flare launcher that usually gets mounted onto dropships to help survivability against infrared tracking missiles."
	icon_state = "flare_launcher"
	w_class = SIZE_SMALL

/obj/item/prop/almayer/chaff_launcher
	name = "\improper RR-247 Chaff case"
	desc = "A chaff launcher that usually gets mounted onto dropships to help survivability against radar tracking missiles."
	icon_state = "chaff_launcher"
	w_class = SIZE_MEDIUM

/obj/item/prop/almayer/handheld1
	name = "small handheld"
	desc = "A small piece of electronic doodads"
	icon_state = "handheld1"
	w_class = SIZE_SMALL

/obj/item/prop/almayer/comp_closed
	name = "dropship maintenance computer"
	desc = "A closed dropship maintenance computer that technicians and pilots use to find out what's wrong with a dropship. It has various outlets for different systems."
	icon_state = "hangar_comp"
	w_class = SIZE_LARGE

/obj/item/prop/almayer/comp_open
	name = "dropship maintenance computer"
	desc = "An opened dropship maintenance computer, it seems to be off however. It's used by technicians and pilots to find damaged or broken systems on a dropship. It has various outlets for different systems."
	icon_state = "hangar_comp_open"
	w_class = SIZE_LARGE

//lore fluff books and magazines

/obj/item/prop/magazine
	name = "generic prop magazine"
	desc = "A Magazine with a picture of a pretty girl on it..wait isn't that my mom?"
	icon = 'icons/obj/structures/props/wall_decorations/posters.dmi'
	icon_state = "poster15"
	throw_speed = SPEED_FAST
	throw_range = 5
	w_class = SIZE_MEDIUM
	attack_verb = list("bashed", "whacked", "educated")
	pickup_sound = "sound/handling/book_pickup.ogg"
	drop_sound = "sound/handling/book_pickup.ogg"
	black_market_value = 15

//random magazines
/obj/item/prop/magazine/dirty
	name = "Dirty Magazine"
	desc = "Wawaweewa."
	icon_state = "poster17"

/obj/item/prop/magazine/dirty/torn
	name = "\improper torn magazine page"
	desc = "Hubba hubba."

/obj/item/prop/magazine/dirty/torn/alt
	icon_state = "poster3"


//books
/obj/item/prop/magazine/book
	name = "generic prop book"
	desc = "some generic hardcover book, probably sucked"
	icon = 'icons/obj/items/books.dmi'
	icon_state = "bookSpaceLaw"
	item_state = "book_red"

/obj/item/prop/magazine/book/spacebeast
	name = "\improper Space Beast, by Robert Morse"
	desc = "An autobiography focusing on the events of 'Fury 161' in August 2179 following the arrival of 'Ellen Ripley' and an unknown alien creature known as 'The Dragon' the books writing is extremely crude and was book banned shorty after publication."

/obj/item/prop/magazine/book/borntokill
	name = "\improper Born to Kill"
	desc = "An autobiography penned by Derik A.W. Tomahawk it recounts his service in the USCM. The book was harshly criticised for its bland and uncreative writing and wasn't well received by the general public or members of the UA military. However, artificial soldiers typically value the information contained within."

/obj/item/prop/magazine/book/bladerunner
	name = "\improper Bladerunner: A True Detectives Story"
	desc = "In the dark undercity of Luna 2119, blade runner Richard Ford is called out of retirement to terminate a cult of replicants who have escaped Earth seeking the meaning of their existence."

/obj/item/prop/magazine/book/starshiptroopers
	name = "Starship Troopers"
	desc = "Written by Robert A. Heinlein, this book really missed the mark when it comes to the individual equipment it depicts 'troopers' having, but it's still issued to every marine in basic so it must have some value."

/obj/item/prop/magazine/book/theartofwar
	name = "The Art of War"
	desc = "A treatise on war written by Sun Tzu a great general, strategist, and philosopher from ancient Earth. This book is on the Commandant of the United States Colonial Marine Corps reading list and most officers can be found in possession of a copy. Most officers who've read it claim to know a little bit more about fighting than most enlisted but results may vary. "

//boots magazine
/obj/item/prop/magazine/boots
	name = "generic Boots! magazine"
	desc = "The only official USCM magazine!"

/obj/item/prop/magazine/boots/n117
	name = "Boots!: Issue No.117"
	desc = "The only official USCM magazine, the headline reads 'STOP CANNING' the short paragraph further explains the dangers of marines throwing CN-20 Nerve gas into bathrooms as a prank."

/obj/item/prop/magazine/boots/n150
	name = "Boots!: Issue No.150"
	desc = "The only official USCM magazine, the headline reads 'UPP Rations, The truth.' the short paragraph further explains UPP field rations aren't standardized and are produced at a local level. Because of this, captured and confiscated UPP rations have included some odd choices such as duck liver, century eggs, lutefisk, pickled pig snout, canned tripe, and dehydrated candied radish snacks."

/obj/item/prop/magazine/boots/n160
	name = "Boots!: Issue No.160"
	desc = "The only official USCM magazine, the headline reads 'Corporate Liaison 'emotionally exhausted' from screwing so many people over.'"

/obj/item/prop/magazine/boots/n054
	name = "Boots!: Issue No.54"
	desc = "The only official USCM magazine, the headline reads 'ARMAT strikes back against litigants in M41A-MK2 self cleaning case'"

/obj/item/prop/magazine/boots/n055
	name = "Boots!: Issue No.55"
	desc = "The only official USCM magazine, the headline reads 'TEN tips to keep your UD4 cockpit both safer and more relaxing.'"

// Massive Digger by dimdimich1996

/obj/structure/prop/invuln/dense/excavator
	name = "Model 30 Light Excavator"
	desc = "Weyland-Yutani Corporation's Model 30 Light Excavator. Despite looking like a massive beast, the Model 30 is fairly light when compared to other W-Y terraforming excavators. It's designed to be able to be disassembled for transport and re-assembled on site. This one is a nice orange color."
	icon = 'icons/obj/structures/props/digger.dmi'
	icon_state = "digger_orange"
	layer = BIG_XENO_LAYER

/obj/structure/prop/invuln/dense/excavator/gray
	desc = "Weyland-Yutani Corporation's Model 30 Light Excavator. Despite looking like a massive beast, the Model 30 is fairly light when compared to other W-Y terraforming excavators. It's designed to be able to be disassembled for transport and re-assembled on site. This one is a nice gray color."
	icon_state = "digger_gray"

/obj/structure/prop/invuln/dense/excavator/Initialize()
	. = ..()
	if(dir & (SOUTH|NORTH))
		bound_height = 192
		bound_width = 96
	else
		bound_height = 96
		bound_width = 192
