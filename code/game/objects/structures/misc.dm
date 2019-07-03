/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	health = 250

/obj/structure/showcase/bullet_act(var/obj/item/projectile/P)
	var/damage = P.damage
	health -= damage
	..()
	healthcheck()
	return 1

/obj/structure/showcase/proc/explode()
	src.visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), 1)
	var/turf/Tsec = get_turf(src)

	new /obj/item/stack/sheet/metal(Tsec)
	new /obj/item/stack/rods(Tsec)
	new /obj/item/stack/rods(Tsec)

	new /obj/effect/spawner/gibspawner/robot(Tsec)

	qdel(src)

/obj/structure/showcase/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/showcase/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				qdel(src)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			qdel(src)

/obj/structure/monorail
	name = "monorail track"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "monorail"
	density = 0
	anchored = 1
	layer = ATMOS_PIPE_LAYER + 0.01

/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	anchored = 0
	flags_atom = FPRINT|OPENCONTAINER
	var/amount_per_transfer_from_this = 5 //Shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

/obj/structure/mopbucket/New()
	..()
	create_reagents(100)

/obj/structure/mopbucket/examine(mob/user)
	..()
	to_chat(user, "It contains [reagents.total_volume] unit\s of water!")

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("[src] is out of water!"))
		else
			reagents.trans_to(I, 5)
			to_chat(user, SPAN_NOTICE("You wet [I] in [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)












//ICE COLONY RESEARCH DECORATION-----------------------//
//Most of icons made by ~Morrinn
obj/structure/xenoautopsy
	name = "Research thingies"
	icon = 'icons/obj/alien_autopsy.dmi'
	icon_state = "jarshelf_9"

obj/structure/xenoautopsy/jar_shelf
	name = "jar shelf"
	icon_state = "jarshelf_0"
	var/randomise = 1 //Random icon

	New()
		if(randomise)
			icon_state = "jarshelf_[rand(0,9)]"

obj/structure/xenoautopsy/tank
	name = "cryo tank"
	icon_state = "tank_empty"
	desc = "It is empty."

obj/structure/xenoautopsy/tank/broken
	name = "cryo tank"
	icon_state = "tank_broken"
	desc = "Something broke it..."

obj/structure/xenoautopsy/tank/alien
	name = "cryo tank"
	icon_state = "tank_alien"
	desc = "There is something big inside..."

obj/structure/xenoautopsy/tank/hugger
	name = "cryo tank"
	icon_state = "tank_hugger"
	desc = "There is something spider-like inside..."

obj/structure/xenoautopsy/tank/larva
	name = "cryo tank"
	icon_state = "tank_larva"
	desc = "There is something worm-like inside..."

obj/item/alienjar
	name = "sample jar"
	icon = 'icons/obj/alien_autopsy.dmi'
	icon_state = "jar_sample"
	desc = "Used to store organic samples inside for preservation."

	New()
		var/image/I
		I = image('icons/obj/alien_autopsy.dmi', "sample_[rand(0,11)]")
		I.layer = src.layer - 0.1
		overlays += I
		pixel_x += rand(-3,3)
		pixel_y += rand(-3,3)




//stairs

/obj/structure/stairs
	name = "Stairs"
	icon = 'icons/obj/structures/structures.dmi'
	desc = "Stairs.  You walk up and down them."
	icon_state = "rampbottom"
	unacidable = 1
	layer = 2
	density = 0
	opacity = 0