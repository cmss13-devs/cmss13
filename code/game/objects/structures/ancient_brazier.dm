#define STATE_COMPLETE 0
#define STATE_FUEL 1
#define STATE_IGNITE 2

/// Ancient Temple Brazier & Torch
/obj/structure/prop/brazier_ancient
	name = "brazier"
	desc = "The fire inside the brazier emits a relatively dim glow to flashlights and flares, but nothing can replace the feeling of sitting next to a fireplace with your friends."
	icon = 'icons/obj/structures/props/hunter/ancientbrazier.dmi'
	icon_state = "brazier"
	icon_state = "brazier"
	density = TRUE
	health = 150
	light_range = 6
	light_on = TRUE
	pixel_y = 5
	light_color =  "#c75fcb"
	/// What obj this becomes when it gets to its next stage of construction / ignition
	var/frame_type
	/// What is used to progress to the next stage
	var/state = STATE_COMPLETE

/obj/structure/prop/brazier_ancient/Initialize()
	. = ..()

	if(light_on)
		set_light(light_range, light_power)
	else
		set_light(0)

/obj/structure/prop/brazier_ancient/get_examine_text(mob/user)
	. = ..()
	switch(state)
		if(STATE_FUEL)
			. += "[src] requires wood to be fueled."
		if(STATE_IGNITE)
			. += "[src] needs to be lit."

/obj/structure/prop/brazier_ancient/attackby(obj/item/hit_item, mob/user)
	switch(state)
		if(STATE_COMPLETE)
			return ..()
		if(STATE_FUEL)
			if(!istype(hit_item, /obj/item/stack/sheet/wood))
				return ..()
			var/obj/item/stack/sheet/wood/wooden_boards = hit_item
			if(!wooden_boards.use(5))
				to_chat(user, SPAN_WARNING("Not enough wood!"))
				return
			user.visible_message(SPAN_NOTICE("[user] fills [src] with [hit_item]."))
		if(STATE_IGNITE)
			if(!hit_item.heat_source)
				return ..()
			if(!do_after(user, 3 SECONDS, INTERRUPT_MOVED, BUSY_ICON_BUILD))
				return
			user.visible_message(SPAN_NOTICE("[user] ignites [src] with [hit_item]."))

	new frame_type(loc)
	qdel(src)

/obj/structure/prop/brazier_ancient/alt
	icon_state = "brazier_alt"
	icon_state = "brazier_alt"
	pixel_y = 3

/obj/structure/prop/brazier_ancient/frame
	name = "empty brazier"
	desc = "An empty brazier."
	icon_state = "brazier_frame"
	light_on = FALSE
	frame_type = /obj/structure/prop/brazier_ancient/frame/full
	state = STATE_FUEL

/obj/structure/prop/brazier_ancient/alt/frame
	icon_state = "brazier_alt_frame"

/obj/structure/prop/brazier_ancient/frame/full
	name = "empty full brazier"
	desc = "An empty brazier. Yet it's also full. What???  Use something hot to ignite it, like a welding tool."
	icon_state = "brazier_frame_filled"
	frame_type = /obj/structure/prop/brazier_ancient
	state = STATE_IGNITE

/obj/structure/prop/brazier_ancient/alt/frame/full
	icon_state = "brazier_alt_frame_filled"

/obj/structure/prop/brazier_ancient/tall
	icon_state = "tall_small_brazier"
	icon_state = "tall_small_brazier"
	layer = BIG_XENO_LAYER

/obj/structure/prop/brazier_ancient/tall/frame
	icon_state = "tall_small_brazier_frame"

/obj/structure/prop/brazier_ancient/tall/frame/full
	icon_state = "tall_small_brazier_frame_filled"
	frame_type = /obj/structure/prop/brazier_ancient/tall
	state = STATE_IGNITE

/obj/structure/prop/brazier/torch/ancient
	name = "torch"
	desc = "It's a torch."
	icon = 'icons/obj/structures/props/hunter/ancientbrazier.dmi'
	icon_state = "torch"
	density = FALSE
	light_range = 5
	light_color =  "#c75fcb"

/obj/structure/prop/brazier/torch/ancient/Initialize()
	. = ..()

	if(light_on)
		set_light(light_range, light_power)
	else
		set_light(0)

/obj/structure/prop/brazier/frame/full/torch/ancient
	name = "unlit torch"
	desc = "It's a torch, but it's not lit.  Use something hot to ignite it, like a welding tool."
	icon_state = "torch_frame"
	frame_type = /obj/structure/prop/brazier/torch/ancient

/obj/item/prop/torch_frame/ancient
	name = "unlit torch"
	icon = 'icons/obj/structures/props/hunter/ancientbrazier.dmi'
	desc = "It's a torch, but it's not lit or placed down. Click on a wall to place it."

#undef STATE_COMPLETE
#undef STATE_FUEL
#undef STATE_IGNITE
