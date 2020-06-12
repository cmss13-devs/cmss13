/obj/structure/machinery/computer/HolodeckControl
	name = "Holodeck Control Computer"
	desc = "A computer used to control a nearby holodeck."
	icon_state = "holocontrol"
	var/area/linkedholodeck = null
	var/area/target = null
	var/active = 0
	var/list/holographic_items = list()
	var/damaged = 0
	var/last_change = 0

// Holographic Items!

/turf/open/floor/holofloor


/turf/open/floor/holofloor/grass
	name = "Lush Grass"
	icon_state = "grass1"
	floor_tile = new/obj/item/stack/tile/grass

	New()
		floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

/turf/open/floor/holofloor/attackby(obj/item/W as obj, mob/user as mob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK










/obj/structure/table/holotable
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon_state = "table"
	density = 1
	anchored = 1.0
	throwpass = 1	//You can throw objects over this, despite it's density.

/obj/structure/table/holotable/attack_animal(mob/living/user as mob) //Removed code for larva since it doesn't work. Previous code is now a larva ability. /N
	return attack_hand(user)

/obj/structure/table/holotable/attack_hand(mob/user as mob)
	return // HOLOTABLE DOES NOT GIVE A FUCK


/obj/structure/table/holotable/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<=1)
		var/obj/item/grab/G = W
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			if(user.grab_level < GRAB_AGGRESSIVE)
				to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
				return
			M.forceMove(loc)
			M.KnockDown(5)
			user.visible_message(SPAN_DANGER("[user] puts [M] on the table."))
		return

	if (istype(W, /obj/item/tool/wrench))
		to_chat(user, "It's a holotable!  There are no bolts!")
		return

	if(isborg(user))
		return

	..()

/obj/structure/table/holotable/wood
	name = "table"
	desc = "A square piece of wood standing on four wooden legs. It can not move."
	icon_state = "woodtable"
	table_prefix = "wood"

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1.0
	flags_atom = FPRINT


/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/holowindow
	name = "reinforced window"
	icon = 'icons/turf/walls/windows.dmi'
	icon_state = "rwindow"
	desc = "A window."
	density = 1
	layer = WINDOW_LAYER
	anchored = 1.0
	flags_can_pass_all = PASS_GLASS
	flags_atom = ON_BORDER




//BASKETBALL OBJECTS

/obj/item/toy/beach_ball/holoball
	name = "basketball"
	icon_state = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = SIZE_LARGE //Stops people from hiding it in their bags/pockets

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/structures/props/misc.dmi'
	icon_state = "hoop"
	anchored = 1
	density = 1
	throwpass = 1
	var/side = ""
	var/id = ""

/obj/structure/holohoop/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/grab) && get_dist(src,user)<=1)
		var/obj/item/grab/G = W
		if(ismob(G.grabbed_thing))
			var/mob/M = G.grabbed_thing
			if(user.grab_level < GRAB_AGGRESSIVE)
				to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
				return
			M.forceMove(loc)
			M.KnockDown(5)
			for(var/obj/structure/machinery/scoreboard/X in machines)
				if(X.id == id)
					X.score(side, 3)// 3 points for dunking a mob
					// no break, to update multiple scoreboards
			visible_message(SPAN_DANGER("[user] dunks [M] into the [src]!"))
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_inv_item_to_loc(W, loc)
		for(var/obj/structure/machinery/scoreboard/X in machines)
			if(X.id == id)
				X.score(side)
				// no break, to update multiple scoreboards
		visible_message(SPAN_NOTICE("[user] dunks [W] into the [src]!"))
		return

/obj/structure/holohoop/BlockedPassDirs(atom/movable/mover, target_dir)
	if(istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return BLOCKED_MOVEMENT
		if(prob(50))
			I.loc = src.loc
			for(var/obj/structure/machinery/scoreboard/X in machines)
				if(X.id == id)
					X.score(side)
					// no break, to update multiple scoreboards
			visible_message(SPAN_NOTICE("Swish! \the [I] lands in \the [src]."), null, null, 3)
		else
			visible_message(SPAN_DANGER("\the [I] bounces off of \the [src]'s rim!"), null, null, 3)
		return NO_BLOCKED_MOVEMENT
	
	return ..()


/obj/structure/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/structures/machinery/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = POWER_CHANNEL_ENVIRON

/obj/structure/machinery/readybutton/attack_ai(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices!")
	return

/obj/structure/machinery/readybutton/New()
	..()


/obj/structure/machinery/readybutton/attackby(obj/item/W as obj, mob/user as mob)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/structure/machinery/readybutton/attack_hand(mob/user as mob)
	if(user.stat || inoperable())
		to_chat(user, "This device is not powered.")
		return

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(usr, "The event has already begun!")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/structure/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/structure/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/structure/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/holowindow/W in currentarea)
		currentarea -= W
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")

//Holorack

/obj/structure/rack/holorack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"

/obj/structure/rack/holorack/attack_hand(mob/user as mob)
	return

/obj/structure/rack/holorack/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/tool/wrench))
		to_chat(user, "It's a holorack!  You can't unwrench it!")
		return
