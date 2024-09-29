/obj/item/device/pipe_painter
	name = "pipe painter"
	icon = 'icons/obj/items/paper.dmi'
	icon_state = "labeler1"
	item_state = "flight"
	var/list/modes
	var/mode

/obj/item/device/pipe_painter/New()
	..()
	modes = new()
	for(var/C in GLOB.pipe_colors)
		modes += "[C]"
	mode = pick(modes)

/obj/item/device/pipe_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if(!istype(A,/obj/structure/pipes/standard/) || istype(A,/obj/structure/pipes/standard/tank) || istype(A,/obj/structure/pipes/standard/simple/insulated) || !in_range(user, A))
		return
	var/obj/structure/pipes/standard/P = A

	var/turf/T = P.loc
	if (P.level < 2 && T.level==1 && isturf(T) && T.intact_tile)
		to_chat(user, SPAN_DANGER("You must remove the plating first."))
		return

	P.change_color(GLOB.pipe_colors[mode])

/obj/item/device/pipe_painter/attack_self(mob/user)
	..()
	mode = tgui_input_list(usr, "Which color do you want to use?", "Pipe painter", modes)

/obj/item/device/pipe_painter/get_examine_text(mob/user)
	. = ..()
	. += "It is in [mode] mode."
