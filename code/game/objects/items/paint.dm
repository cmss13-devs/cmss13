//NEVER USE THIS IT SUX	-PETETHEGOAT

var/global/list/cached_icons = list()

/obj/item/reagent_container/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "paint_neutral"
	item_state = "paintcan"
	matter = list("metal" = 200)
	w_class = SIZE_MEDIUM
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 70
	flags_atom = FPRINT|OPENCONTAINER
	var/paint_type = ""

/obj/item/reagent_container/glass/paint/afterattack(turf/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target) && reagents.total_volume > 5)
		for(var/mob/O in viewers(user))
			O.show_message(SPAN_DANGER("\The [target] has been splashed with something by [user]!"), 1)
		spawn(5)
			reagents.reaction(target, TOUCH)
			reagents.remove_any(5)
	else
		return ..()

/obj/item/reagent_container/glass/paint/Initialize()
	if(paint_type == "remover")
		name = "paint remover bucket"
	else if(paint_type && length(paint_type) > 0)
		name = "[paint_type] [name]"
	..()
	reagents.add_reagent("paint_[paint_type]", volume)

/obj/item/reagent_container/glass/paint/on_reagent_change() //Until we have a generic "paint", this will give new colours to all paints in the can
	var/mixedcolor = mix_color_from_reagents(reagents.reagent_list)
	for(var/datum/reagent/paint/P in reagents.reagent_list)
		P.color = mixedcolor

/obj/item/reagent_container/glass/paint/red
	icon_state = "paint_red"
	paint_type = "red"

/obj/item/reagent_container/glass/paint/green
	icon_state = "paint_green"
	paint_type = "green"

/obj/item/reagent_container/glass/paint/blue
	icon_state = "paint_blue"
	paint_type = "blue"

/obj/item/reagent_container/glass/paint/yellow
	icon_state = "paint_yellow"
	paint_type = "yellow"

/obj/item/reagent_container/glass/paint/violet
	icon_state = "paint_violet"
	paint_type = "violet"

/obj/item/reagent_container/glass/paint/black
	icon_state = "paint_black"
	paint_type = "black"

/obj/item/reagent_container/glass/paint/white
	icon_state = "paint_white"
	paint_type = "white"

/obj/item/reagent_container/glass/paint/remover
	paint_type = "remover"

/datum/reagent/paint
	name = "Paint"
	id = "paint_"
	reagent_state = 2
	color = "#808080"
	description = "This paint will only adhere to floor tiles."

/datum/reagent/paint/reaction_turf(var/turf/T, var/volume)
	if(!istype(T) || istype(T, /turf/open/space))
		return
	T.color = color

/datum/reagent/paint/reaction_obj(var/obj/O, var/volume)
	..()
	if(istype(O,/obj/item/light_bulb))
		O.color = color

/datum/reagent/paint/red
	name = "Red Paint"
	id = "paint_red"
	color = "#FE191A"

/datum/reagent/paint/green
	name = "Green Paint"
	color = "#18A31A"
	id = "paint_green"

/datum/reagent/paint/blue
	name = "Blue Paint"
	color = "#247CFF"
	id = "paint_blue"

/datum/reagent/paint/yellow
	name = "Yellow Paint"
	color = "#FDFE7D"
	id = "paint_yellow"

/datum/reagent/paint/violet
	name = "Violet Paint"
	color = "#CC0099"
	id = "paint_violet"

/datum/reagent/paint/black
	name = "Black Paint"
	color = "#333333"
	id = "paint_black"

/datum/reagent/paint/white
	name = "White Paint"
	color = "#F0F8FF"
	id = "paint_white"

/datum/reagent/paint_remover
	name = "Paint Remover"
	id = "paint_remover"
	description = "Paint remover is used to remove floor paint from floor tiles."
	reagent_state = 2
	color = "#808080"

/datum/reagent/paint_remover/reaction_turf(var/turf/T, var/volume)
	if(istype(T) && T.icon != initial(T.icon))
		T.icon = initial(T.icon)
	return
