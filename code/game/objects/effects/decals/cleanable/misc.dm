/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "shards"

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = "Ashes to ashes, dust to dust, and into space."
	gender = PLURAL
	icon = 'icons/effects/effects.dmi'
	icon_state = "ash"
	anchored = TRUE

/obj/effect/decal/cleanable/ash/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("[src] sifts through your fingers."))
	qdel(src)

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = "Someone should clean that up."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "dirt"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/dirt/greenglow
	name = "glowing goo"
	acid_damage = 1
	icon_state = "greenglow"
	light_range = 1
	light_color = COLOR_LIGHT_GREEN
/obj/effect/decal/cleanable/flour
	name = "flour"
	desc = "It's still good. Four second rule!"
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "flour"

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = "Jeez. I hope that's not for lunch."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	light_range = 1
	light_color = COLOR_LIGHT_GREEN
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenglow"

/obj/effect/decal/cleanable/greenglow/Initialize(mapload, ...)
	if(mapload)
		return INITIALIZE_HINT_QDEL
	. = ..()
	QDEL_IN(WEAKREF(src), 2 MINUTES)

/obj/effect/decal/cleanable/cobweb
	name = "cobweb"
	desc = "Somebody should remove that."
	density = FALSE
	anchored = TRUE
	layer = FLY_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb1"

/obj/effect/decal/cleanable/molten_item
	name = "gooey grey mass"
	desc = "It looks like a melted... something."
	density = FALSE
	anchored = TRUE
	layer = OBJ_LAYER
	gender = PLURAL
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "molten"

/obj/effect/decal/cleanable/cobweb2
	name = "cobweb"
	desc = "Somebody should remove that."
	density = FALSE
	anchored = TRUE
	layer = OBJ_LAYER
	icon = 'icons/effects/effects.dmi'
	icon_state = "cobweb2"

/// Variant used for halloween - need to pass info in constructor as its turned in an overlay
/obj/effect/decal/cleanable/cobweb2/dynamic
	alpha = 80
	appearance_flags = RESET_ALPHA | TILE_BOUND | PIXEL_SCALE
	garbage = FALSE

/obj/effect/decal/cleanable/cobweb2/dynamic/Initialize(mapload, targetdir, webscale = 1.0)
	alpha += floor(webscale * 120)
	var/angle = dir2angle(targetdir)
	var/matrix/TM = new
	TM *= webscale
	TM = TM.Translate(16 * (1 - webscale))
	angle -= 225 // Flip and adjust, base sprite is top right
	TM = TM.Turn(angle)
	transform = TM
	return ..()

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = "Gosh, how unpleasant."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	cleanable_type = CLEANABLE_SPLATTER

/obj/effect/decal/cleanable/vomit/ex_act()
	return

/obj/effect/decal/cleanable/tomato_smudge
	name = "tomato smudge"
	desc = "It's red."
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	random_icon_states = list("tomato_floor1", "tomato_floor2", "tomato_floor3")

/obj/effect/decal/cleanable/egg_smudge
	name = "smashed egg"
	desc = "Seems like this one won't hatch."
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	random_icon_states = list("smashed_egg1", "smashed_egg2", "smashed_egg3")

/obj/effect/decal/cleanable/pie_smudge //honk
	name = "smashed pie"
	desc = "It's pie cream from a cream pie."
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/effects.dmi'
	random_icon_states = list("smashed_pie")

/obj/effect/decal/cleanable/blackgoo
	name = "black goo"
	desc = "It's thick and gooey."
	gender = PLURAL
	anchored = TRUE
	icon = 'icons/effects/effects.dmi'
	icon_state = "blackgoo"

/obj/effect/decal/cleanable/blackgoo/Crossed(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.species.name == "Human")
		if(!H.shoes && prob(50))
			H.contract_disease(new /datum/disease/black_goo)




/obj/effect/decal/cleanable/mucus
	name = "mucus"
	desc = "Disgusting mucus."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	random_icon_states = list("mucus")
