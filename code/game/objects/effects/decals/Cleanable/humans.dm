#define DRYING_TIME 5 * 60* 10

/obj/effect/decal/cleanable/blood
	name = "blood"
	desc = "It's thick and gooey. This probably isn't a safe place to be."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
	dirt_type = DIRT_SPLATTER
	var/base_icon = 'icons/effects/blood.dmi'
	var/list/viruses = list()
	var/basecolor= "#830303" // Color when wet.
	var/amount = 5
	var/drying_blood = TRUE //whether the blood will dry

/obj/effect/decal/cleanable/blood/Destroy()
	for(var/datum/disease/D in viruses)
		D.cure(0)
	viruses = null
	..()
	return QDEL_HINT_IWILLGC

/obj/effect/decal/cleanable/blood/Initialize(mapload, b_color)
	if(b_color)
		basecolor = b_color
	update_icon()

	. = ..()

	if(src.type == /obj/effect/decal/cleanable/blood)
		if(src.loc && isturf(src.loc))
			for(var/obj/effect/decal/cleanable/blood/B in src.loc)
				if(B != src)
					qdel(B)

	if(drying_blood)
		addtimer(CALLBACK(src, .proc/dry), DRYING_TIME * (amount+1))

/obj/effect/decal/cleanable/blood/update_icon()
	if(basecolor == "rainbow")
		basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

/obj/effect/decal/cleanable/blood/proc/dry()
	name = "dried [src.name]"
	desc = "It's dry and crusty. Someone is not doing their job."
	color = adjust_brightness(color, -50)
	amount = 0





/obj/effect/decal/cleanable/blood/splatter
    random_icon_states = list("mgibbl1", "mgibbl2", "mgibbl3", "mgibbl4", "mgibbl5")
    amount = 2



/obj/effect/decal/cleanable/blood/drip
    name = "drips of blood"
    desc = "Some small drips of blood."
    gender = PLURAL
    icon = 'icons/effects/drip.dmi'
    icon_state = "1"
    random_icon_states = list("1","2","3","4","5")
    amount = 0
    var/drips



/obj/effect/decal/cleanable/blood/writing
	icon_state = "tracks"
	desc = "It looks like a writing in blood."
	gender = NEUTER
	random_icon_states = list("writing1","writing2","writing3","writing4","writing5")
	amount = 0
	var/message

/obj/effect/decal/cleanable/blood/writing/New()
	..()
	if(random_icon_states.len)
		for(var/obj/effect/decal/cleanable/blood/writing/W in loc)
			random_icon_states.Remove(W.icon_state)
		icon_state = pick(random_icon_states)
	else
		icon_state = "writing1"

/obj/effect/decal/cleanable/blood/writing/examine(mob/user)
	..()
	to_chat(user, "It reads: <font color='[basecolor]'>\"[message]\"<font>")




/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = 0
	anchored = 1
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	drying_blood = FALSE
	dirt_type = DIRT_JUNK
	var/fleshcolor = "#830303"

/obj/effect/decal/cleanable/blood/gibs/update_icon()
	var/image/giblets = new(base_icon, "[icon_state]_flesh", dir)
	if(!fleshcolor || fleshcolor == "rainbow")
		fleshcolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	giblets.color = fleshcolor

	if(basecolor == "rainbow") basecolor = "#[pick(list("FF0000","FF7F00","FFFF00","00FF00","0000FF","4B0082","8F00FF"))]"
	color = basecolor

	overlays += giblets

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions)
        spawn (0)
                var/direction = pick(directions)
                for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
                        sleep(3)
                        if (i > 0)
                                var/obj/effect/decal/cleanable/blood/b = new /obj/effect/decal/cleanable/blood/splatter(src.loc)
                                b.basecolor = src.basecolor
                                b.update_icon()
                                for(var/datum/disease/D in src.viruses)
                                        var/datum/disease/ND = D.Copy(1)
                                        b.viruses += ND
                                        ND.holder = b

                        if (step_to(src, get_step(src, direction), 0))
                                break





//used on maps
/obj/effect/decal/cleanable/blood/splatter/animated
