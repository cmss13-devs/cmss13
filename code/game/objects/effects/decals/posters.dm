/obj/item/poster
	name = "rolled-up poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	icon = 'icons/obj/structures/props/posters.dmi'
	icon_state = "rolled_poster"
	force = 0
	w_class = SIZE_SMALL
	var/serial_number = 0


/obj/item/poster/New(turf/loc, given_serial = 0)
	if(given_serial == 0)
		serial_number = rand(1, length(GLOB.poster_designs))
	else
		serial_number = given_serial
	name += " - No. [serial_number]"
	..(loc)

//############################## THE ACTUAL DECALS ###########################

/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of cheap printed paper."
	icon = 'icons/obj/structures/props/posters.dmi'
	anchored = TRUE
	var/serial_number //determines the design of the poster
	var/ruined = 0


/obj/structure/sign/poster/Initialize(mapload, serial)
	. = ..()
	if(serial)
		serial_number = serial

	if(!isnum(serial_number))
		serial_number = rand(1, length(GLOB.poster_designs))

	var/designtype = GLOB.poster_designs[serial_number]
	var/datum/poster/design=new designtype
	name += " - [design.name]"
	desc += " [design.desc]"
	icon_state = design.icon_state

/obj/structure/sign/poster/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_WIRECUTTERS))
		playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
		if(ruined)
			to_chat(user, SPAN_NOTICE("You remove the remnants of the poster."))
			qdel(src)
		else
			to_chat(user, SPAN_NOTICE("You carefully remove the poster from the wall."))
			roll_and_drop(user.loc)
		return

/obj/structure/sign/poster/attack_hand(mob/user as mob)
	if(ruined)
		return
	var/temp_loc = user.loc
	switch(alert("Do I want to rip the poster from the wall?","You think...","Yes","No"))
		if("Yes")
			if(user.loc != temp_loc)
				return
			visible_message(SPAN_WARNING("[user] rips [src] in a single, decisive motion!") )
			playsound(src.loc, 'sound/items/poster_ripped.ogg', 25, 1)
			ruined = 1
			icon_state = "poster_ripped"
			name = "ripped poster"
			desc = "You can't make out anything from the poster's original print. It's ruined."
			add_fingerprint(user)
		if("No")
			return

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/poster/P = new(src, serial_number)
	P.forceMove(newloc)
	src.forceMove(P)
	qdel(src)


//separated to reduce code duplication. Moved here for ease of reference and to unclutter r_wall/attackby()
/turf/closed/wall/proc/place_poster(obj/item/poster/P, mob/user)

	if(!istype(src,/turf/closed/wall))
		to_chat(user, SPAN_DANGER("You can't place this here!"))
		return

	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a poster on it or too much stuff
		if(istype(O,/obj/structure/sign/poster))
			to_chat(user, SPAN_NOTICE("The wall is far too cluttered to place a poster!"))
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, SPAN_NOTICE("The wall is far too cluttered to place a poster!"))
			return

	to_chat(user, SPAN_NOTICE("You start placing the poster on the wall...")) //Looks like it's uncluttered enough. Place the poster.

	//declaring D because otherwise if P gets 'deconstructed' we lose our reference to P.resulting_poster
	var/obj/structure/sign/poster/D = new(null, P.serial_number)

	var/temp_loc = user.loc
	flick("poster_being_set",D)
	D.forceMove(src)
	qdel(P) //delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/poster_being_created.ogg', 25, 1)

	if(!do_after(user, 17, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		D.roll_and_drop(temp_loc)
		return

	to_chat(user, SPAN_NOTICE("You place the poster!"))

	SSclues.create_print(get_turf(user), user, "The fingerprint contains paper pieces.")
	SEND_SIGNAL(P, COMSIG_POSTER_PLACED, user)

/datum/poster
	// Name suffix. Poster - [name]
	var/name=""
	// Description suffix
	var/desc=""
	var/icon_state=""

/obj/structure/sign/poster/ad
	icon_state = "poster7"

/obj/structure/sign/poster/ad/Initialize()
	serial_number = pick(7,8,9,10,11,13,18,22,35,36,37)
	.=..()

/obj/structure/sign/poster/art
	icon_state = "poster6"

/obj/structure/sign/poster/art/Initialize()
	serial_number = pick(6,23,24)
	.=..()

/obj/structure/sign/poster/blacklight
	icon_state = "poster1"

/obj/structure/sign/poster/blacklight/Initialize()
	serial_number = pick(1,2)
	.=..()

/obj/structure/sign/poster/clf
	icon_state = "poster19"

/obj/structure/sign/poster/clf/Initialize()
	serial_number = pick(19)
	.=..()

/obj/structure/sign/poster/hunk
	icon_state = "poster32"

/obj/structure/sign/poster/hunk/Initialize()
	serial_number = pick(32,33,34)
	.=..()

/obj/structure/sign/poster/music
	icon_state = "poster3"

/obj/structure/sign/poster/music/Initialize()
	serial_number = pick(3,5,25,26,38,39)
	.=..()

/obj/structure/sign/poster/pinup
	icon_state = "poster12"

/obj/structure/sign/poster/pinup/Initialize()
	serial_number = pick(12,16,17,29)
	.=..()

/obj/structure/sign/poster/propaganda
	icon_state = "poster4"

/obj/structure/sign/poster/propaganda/Initialize()
	serial_number = pick(4,14,15,20,21,40,41)
	.=..()

/obj/structure/sign/poster/safety
	icon_state = "poster27"

/obj/structure/sign/poster/safety/Initialize()
	serial_number = pick(27,28,30,31)
	.=..()

/obj/structure/sign/poster/io
	icon_state = "poster14"

/obj/structure/sign/poster/io/Initialize()
	serial_number = 14
	. = ..()
////////////////
//Hero Posters//
////////////////

/obj/structure/sign/poster/hero/voteno
	icon_state = "poster40"

/obj/structure/sign/poster/hero/voteno/Initialize()
	serial_number = 40
	.=..()
