
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


/obj/structure/table/holotable/attack_paw(mob/user as mob)
	return attack_hand(user)

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
				user << "<span class='warning'>You need a better grip to do that!</span>"
				return
			M.forceMove(loc)
			M.KnockDown(5)
			user.visible_message("<span class='danger'>[user] puts [M] on the table.</span>")
		return

	if (istype(W, /obj/item/tool/wrench))
		user << "It's a holotable!  There are no bolts!"
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
	icon = 'icons/obj/structures/windows.dmi'
	icon_state = "rwindow"
	desc = "A window."
	density = 1
	layer = WINDOW_LAYER
	anchored = 1.0
	flags_atom = ON_BORDER




//BASKETBALL OBJECTS

/obj/item/toy/beach_ball/holoball
	name = "basketball"
	icon_state = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = 4 //Stops people from hiding it in their bags/pockets

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/structures/misc.dmi'
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
				user << "<span class='warning'>You need a better grip to do that!</span>"
				return
			M.forceMove(loc)
			M.KnockDown(5)
			for(var/obj/machinery/scoreboard/X in machines)
				if(X.id == id)
					X.score(side, 3)// 3 points for dunking a mob
					// no break, to update multiple scoreboards
			visible_message("<span class='danger'>[user] dunks [M] into the [src]!</span>")
		return
	else if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_inv_item_to_loc(W, loc)
		for(var/obj/machinery/scoreboard/X in machines)
			if(X.id == id)
				X.score(side)
				// no break, to update multiple scoreboards
		visible_message("<span class='notice'>[user] dunks [W] into the [src]!</span>")
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target)
	if(istype(mover,/obj/item) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.loc = src.loc
			for(var/obj/machinery/scoreboard/X in machines)
				if(X.id == id)
					X.score(side)
					// no break, to update multiple scoreboards
			visible_message("\blue Swish! \the [I] lands in \the [src].", 3)
		else
			visible_message("\red \the [I] bounces off of \the [src]'s rim!", 3)
		return 0
	else
		return ..()
