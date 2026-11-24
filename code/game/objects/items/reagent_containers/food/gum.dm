#define GUM_SIZE_TINY 1
#define GUM_SIZE_MINI 1.5
#define GUM_SIZE_SMALL 2
#define GUM_SIZE_MEDIUM 3
#define GUM_SIZE_LARGE 5
#define GUM_SIZE_HUGE 8


/obj/item/paper/wrapper
	name = "gum wrapper"
	desc = "Clear evidence someones enjoyed a chewy treat!"
	icon = 'icons/obj/items/food/gum.dmi'
	icon_state = "gum_wrapper"
	item_state = "gum_wrapper"
	item_state_slots = list(WEAR_HEAD = "gum_wrapper")
	pickup_sound = 'sound/handling/gum_wrapper.ogg'
	drop_sound = 'sound/handling/gum_wrapper.ogg'

/obj/item/paper/wrapper/update_icon()
	return


/obj/bubblegum_bubble
	name = "YOU SHOULD NOT SEE THIS"
	desc = "notify a maintainer if you can see this, should only exist attached to humans"
	icon = 'icons/mob/humans/onmob/mask.dmi'
	icon_state = "bubblegum"
	layer = FLOAT_LAYER
	vis_flags = VIS_INHERIT_DIR|VIS_INHERIT_PLANE|VIS_INHERIT_ID
	appearance_flags = KEEP_APART|RESET_COLOR|RESET_ALPHA
	var/popped = FALSE


/obj/item/reagent_container/food/gum
	name = "\improper stick of chewing gum"
	desc = "Its like food but without the satisfaction of texture, lasting flavours, and filling up you stomach."
	icon = 'icons/obj/items/food/gum.dmi'
	icon_state = "stick_wrapped"
	has_special_table_placement = TRUE
	flags_equip_slot = SLOT_FACE
	w_class = SIZE_TINY
	item_icons = list(
		WEAR_FACE = 'icons/mob/humans/onmob/mask.dmi',
	)
	var/base_icon_state = "stick"
	var/gum_color = "#e58a9a"
	var/wrapped = TRUE
	var/chewed = FALSE
	var/obj/item/paper/wrapper/wrapper = /obj/item/paper/wrapper
	var/gum_size = GUM_SIZE_TINY
	var/mob/living/carbon/human/bubble_blower
	var/action_timer
	var/chew_timer
	var/obj/bubblegum_bubble/bubble
	var/bubble_streak = 0
	var/continuously_blowing_bubbles = FALSE
	var/atom/movable/stuck_on


/obj/item/reagent_container/food/gum/update_icon()
	. = ..()

	if(chewed)
		icon_state = "wad_[gum_size < GUM_SIZE_MEDIUM ? "s" : (gum_size < GUM_SIZE_LARGE ? "m" : (gum_size < GUM_SIZE_HUGE ? "l" : "h"))]"
		if(wrapped)
			icon_state += "_wrapped"
	else
		icon_state = "[base_icon_state][wrapped?"_wrapped":""]"

	color = wrapped ? null : gum_color
	if(bubble)
		bubble.color = color


/obj/item/reagent_container/food/gum/get_icon_state(mob/user_mob, slot)
	if(slot == WEAR_FACE)
		return icon_state

	return ..()

/obj/item/reagent_container/food/gum/get_examine_text(mob/user)
	. = ..()
	if(chewed)
		. += SPAN_WARNING("This one seems to have been chewed. ")
	if(is_stuck())
		. += SPAN_BOLDWARNING("Someone stuck it here, Gross!")


/obj/item/reagent_container/food/gum/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(wrapped && !chewed)
		unwrap(human_user)
	else
		if(isnull(human_user.wear_mask))
			human_user.equip_to_slot_if_possible(src, WEAR_FACE)
		else if(istype(human_user.wear_mask, /obj/item/reagent_container/food/gum))
			var/obj/item/reagent_container/food/gum/worn_gum = human_user.wear_mask
			if(chewed)
				if(wrapped)
					to_chat(user, SPAN_NOTICE("You cram a ") + SPAN_BOLDWARNING("wrapped up") + SPAN_NOTICE(" [src] into the gum you're already chewing, it was already chewed.. gross."))
					worn_gum.wrapped = TRUE
					worn_gum.reagents.add_reagent("gum_paper", 4)
				else
					to_chat(user, SPAN_NOTICE("You cram a [src] into the gum you're already chewing, it was already chewed.. gross. Although, you could probably blow larger bubbles now!"))
			else
				if(wrapped)
					to_chat(user, SPAN_NOTICE("You cram a ") + SPAN_BOLDWARNING("still wrapped") + SPAN_NOTICE(" [src] into the gum you're already chewing, adding flavor and paper!"))
					worn_gum.wrapped = TRUE
					worn_gum.reagents.add_reagent("gum_paper", 4)
				else
					to_chat(user, SPAN_NOTICE("You cram a [src] into the gum you're already chewing, refreshing the taste! You could probably blow larger bubbles now!"))
			worn_gum.gum_color = BlendRGB(worn_gum.gum_color, gum_color, gum_size / (worn_gum.gum_size + gum_size))
			worn_gum.gum_size += gum_size
			worn_gum.wrapped = wrapped
			worn_gum.update_icon()
			reagents.trans_to(worn_gum, reagents.total_volume)
			qdel(src)
		else
			to_chat(human_user, SPAN_WARNING("You're wearing [human_user.wear_mask]! You can't chew gum with it on!"))


/obj/item/reagent_container/food/gum/attack_hand(mob/user)
	if(is_stuck())
		to_chat(user, SPAN_WARNING("The [src] is stuck!"))
		return
	return ..()


/obj/item/reagent_container/food/gum/attackby(obj/item/item_attacker, mob/user)
	. = ..()

	if(istype(item_attacker, /obj/item/reagent_container/food/gum) && chewed && bubble_blower)
		var/obj/item/reagent_container/food/gum/gum_attacker = item_attacker
		gum_size += gum_attacker.gum_size
		if(gum_attacker.chewed)
			if(gum_attacker.wrapped)
				to_chat(user, SPAN_NOTICE("You cram a ") + SPAN_BOLDWARNING("wrapped up") + SPAN_NOTICE(" [gum_attacker] into the gum you're already chewing, it was already chewed.. gross."))
				wrapped = TRUE
				reagents.add_reagent("gum_paper", 4)
			else
				to_chat(user, SPAN_NOTICE("You cram a [gum_attacker] into the gum you're already chewing, it was already chewed.. gross. You could probably blow larger bubbles now!"))
		else
			if(gum_attacker.wrapped)
				to_chat(user, SPAN_NOTICE("You cram a ") + SPAN_BOLDWARNING("still wrapped") + SPAN_NOTICE(" [gum_attacker] into the gum you're already chewing, adding flavor and paper!"))
				wrapped = TRUE
				reagents.add_reagent("gum_paper", 4)
			else
				to_chat(user, SPAN_NOTICE("You cram a [gum_attacker] into the gum you're already chewing, refreshing the taste! You could probably blow larger bubbles now!"))
		gum_color = BlendRGB(gum_color, gum_attacker.gum_color, gum_attacker.gum_size / (gum_size + gum_attacker.gum_size))
		gum_size += gum_attacker.gum_size
		gum_attacker.reagents.trans_to(src, reagents.total_volume)
		update_icon()
		qdel(gum_attacker)
		update_icon()
	else if(istype(item_attacker, /obj/item/paper))
		if(bubble_blower && bubble_blower.wear_mask == src)
			to_chat(user, SPAN_NOTICE("You spit out the gum into the [item_attacker] and wrap it around it."))
		else
			to_chat(user, SPAN_NOTICE("You crumple up the [item_attacker] around the [src], how decent of you."))
		qdel(item_attacker)
		wrapped = TRUE
		reagents.add_reagent("gum_paper", 4)
		anchored = FALSE
		if(!isnull(stuck_on))
			UnregisterSignal(stuck_on, COMSIG_MOVABLE_MOVED)
		update_icon()
		user.put_in_active_hand(src)


/obj/item/reagent_container/food/gum/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(chewed && !wrapped)
		if(isturf(target) || (isStructure(target) && !istype(target, /obj/structure/surface/table)))
			to_chat(user, SPAN_BOLDWARNING("You stick the gum on [target] like an animal!"))
			user.drop_inv_item_on_ground(src, TRUE, TRUE)
			forceMove(get_turf(target))
			pixel_x = text2num(click_parameters["icon-x"]) -16
			pixel_y = text2num(click_parameters["icon-y"]) -16
			layer = CATWALK_LAYER
			if(isStructure(target))
				stuck_on = target
				layer = stuck_on.layer + 0.01
				RegisterSignal(stuck_on, COMSIG_MOVABLE_MOVED, PROC_REF(stuck_on_thing_moved))


/obj/item/reagent_container/food/gum/proc/stuck_on_thing_moved(atom/movable/source, oldloc, direction, Forced)
	forceMove(get_step(src, direction))


/obj/item/reagent_container/food/gum/MouseDrop(atom/over)
	if(is_stuck())
		return
	return ..()


/obj/item/reagent_container/food/gum/proc/can_be_inserted_into_storage()
	return !is_stuck()


/obj/item/reagent_container/food/gum/set_to_table(obj/structure/surface/target, mob/user)
	. = ..()
	if(istype(target, /obj/structure/surface/table))
		user.visible_message(SPAN_NOTICE("[user] reaches under the [target] briefly."), SPAN_NOTICE("You reach under the [target] and stick the [src] underneath."))
		var/obj/structure/surface/table/table = target
		table.stuck_gums.Add(src)
		stuck_on = table
		layer = ABOVE_TABLE_LAYER
		forceMove(table)


/obj/item/reagent_container/food/gum/equipped(mob/user, slot, silent)
	. = ..()
	if(!ishuman(user))
		return

	if(slot != WEAR_FACE)
		anchored = FALSE
		if(!isnull(bubble))
			qdel(bubble)
		if(bubble_blower)
			bubble_blower.vis_contents -= bubble
			bubble_blower = null
		return

	if(wrapped)
		if(chewed)
			to_chat(user, SPAN_NOTICE("You put the ") + SPAN_BOLDWARNING("wrapped up and already chewed") + SPAN_NOTICE(" [name] in your mouth like an animal, disgusting!."))
		else
			to_chat(user, SPAN_NOTICE("You put the ") + SPAN_BOLDWARNING("still wrapped") + SPAN_NOTICE(" [name] in your mouth like an animal and begin chewing through the paper."))
	else
		if(chewed)
			to_chat(user, SPAN_NOTICE("You put the ") + SPAN_BOLDWARNING("already chewed") + SPAN_NOTICE(" [name] in your mouth and begin chewing, gross!.\n") + SPAN_INFO("Use *blowbubble to blow a bubble, or *blowbubbles to continuously blow bubbles! *stopblowing to stop."))
		else
			to_chat(user, SPAN_NOTICE("You put the [name] in your mouth and begin chewing.\n") + SPAN_INFO("Use *blowbubble to blow a bubble, or *blowbubbles to continuously blow bubbles! *stopblowing to stop."))
	chewed = TRUE
	update_icon()
	bubble_blower = user
	if(isnull(bubble))
		bubble = new(bubble_blower)
	bubble.color = gum_color
	bubble_blower.vis_contents += bubble
	name = "\improper wad of chewed gum"
	chew_tick()


/obj/item/reagent_container/food/gum/unequipped(mob/user, slot)
	. = ..()
	if(bubble_blower)
		bubble_blower.vis_contents -= bubble
		bubble_blower = null
	qdel(bubble)
	if(text2num(action_timer) > 0)
		deltimer(action_timer)
	action_timer = null
	if(isturf(loc))
		make_stuck()


/obj/item/reagent_container/food/gum/Crossed(atom/movable/movable_atom)
	. = ..()
	if(!is_stuck())
		return
	if(!ishuman(movable_atom))
		return
	if(!isnull(stuck_on))
		return

	var/mob/living/carbon/human/crossing_human = movable_atom
	to_chat(crossing_human, SPAN_WARNING("You step in [src], sticking to your foot! Gross."))

	// turn into a cleanable decal
	var/obj/effect/decal/cleanable/blood/gum/gum_decal = new(loc)
	gum_decal.color = gum_color
	gum_decal.pixel_x = pixel_x
	gum_decal.pixel_y = pixel_y
	gum_decal.icon_state = "walked_on_[gum_size < GUM_SIZE_MEDIUM ? "s" : (gum_size < GUM_SIZE_LARGE ? "m" : (gum_size < GUM_SIZE_HUGE ? "l" : "h"))]"
	gum_decal.amount = gum_size < GUM_SIZE_LARGE ? 1 : 2
	gum_decal.Crossed(crossing_human)
	qdel(src)


/obj/item/reagent_container/food/gum/proc/is_stuck()
	// Stuck only when chewed, unwrapped, and not currently held/worn by a mob
	return chewed && !wrapped && !ismob(loc) && !(bubble_blower && bubble_blower.wear_mask == src)


/obj/item/reagent_container/food/gum/proc/make_stuck()
	if(is_stuck())
		anchored = TRUE
	else
		anchored = FALSE


/obj/item/reagent_container/food/gum/proc/unwrap(mob/living/carbon/human/human_user, mouthed=FALSE)
	if(!human_user.get_inactive_hand() && !mouthed)
		var/obj/wrap = new wrapper(human_user.get_inactive_hand())
		human_user.put_in_inactive_hand(wrap)
		to_chat(human_user, SPAN_INFO("You unwrap [name] with your other hand."))
		wrapped = FALSE
		update_icon()
	else
		new wrapper(human_user.loc)
		to_chat(human_user, SPAN_INFO("You unwrap [name] with a single hand, discarding the wrapper to the ground."))
		wrapped = FALSE
		update_icon()


/obj/item/reagent_container/food/gum/proc/blow_bubble(mob/living/carbon/human/human_user)
	if(isnull(human_user) && isnull(bubble_blower))
		return

	if(human_user)
		bubble_blower = human_user

	if(wrapped)
		to_chat(bubble_blower, SPAN_WARNING("The [src] has a wrapper mashed in and torn to bits, blowing bubbles with this is impossible!"))
		return

	to_chat(bubble_blower, SPAN_INFO("You casually blow a [gum_size < GUM_SIZE_MEDIUM ? "small" : (gum_size < GUM_SIZE_LARGE ? "middling" : (gum_size < GUM_SIZE_HUGE ? "large" : "dangerously huge"))] bubble with your gum!"))

	if(isnull(bubble))
		bubble = new(bubble_blower)
		bubble.color = gum_color
		bubble_blower.vis_contents += bubble

	flick("bubblegum_[gum_size < GUM_SIZE_MEDIUM ? "s" : (gum_size < GUM_SIZE_LARGE ? "m" : (gum_size < GUM_SIZE_HUGE ? "l" : "h"))]", bubble)
	var/timer_timing = gum_size < GUM_SIZE_MEDIUM ? 14 : (gum_size < GUM_SIZE_LARGE ? 23 : (gum_size < GUM_SIZE_HUGE ? 56 : 61))	//magic numbers I know sorry, its just the number of frames in the bubble animations until they pop
	if(text2num(action_timer) > 0)
		deltimer(action_timer)
	action_timer = addtimer(CALLBACK(src, PROC_REF(after_blow)), timer_timing, TIMER_UNIQUE|TIMER_OVERRIDE)


/obj/item/reagent_container/food/gum/proc/blow_bubbles(mob/living/carbon/human/human_user, timing = 10)
	if(isnull(human_user))
		return


	if(wrapped)
		to_chat(human_user, SPAN_WARNING("The [src] has a wrapper mashed in and torn to bits, blowing bubbles with this is impossible!"))
		return

	bubble_blower = human_user
	continuously_blowing_bubbles = timing
	to_chat(human_user, SPAN_INFO("You decide to start blowing bubbles with your gum continuously."))
	blow_bubble(human_user)


/obj/item/reagent_container/food/gum/proc/after_blow()
	if(gum_size >= GUM_SIZE_HUGE)
		playsound(bubble_blower, "sound/effects/gumpop_huge.ogg", 8)
		var/pop_chance = 75 * (gum_size - 5) / (gum_size + 2)	// higher and higher chances for a pop
		if(prob(pop_chance))
			bubble.popped = TRUE
			bubble.icon_state = "bubblegum_burst"
			bubble = null	//it stays in the vis_contents of the human, unlucky
			to_chat(bubble_blower, SPAN_BOLDANNOUNCE("The giant bubble you were blowing pops catastrophically across your face!"))
			qdel(src)
			return
		else
			handle_bubble_streak()
	else
		playsound(bubble_blower, "gumpop", 8)

	if(continuously_blowing_bubbles)
		if(text2num(action_timer) > 0)
			deltimer(action_timer)
		if(bubble_blower && (bubble_blower.stat != CONSCIOUS || bubble_blower.napping_level))
			return
		action_timer = addtimer(CALLBACK(src, PROC_REF(blow_bubble)), (continuously_blowing_bubbles + rand(-3,3)) SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE)


/obj/item/reagent_container/food/gum/proc/handle_bubble_streak()
	bubble_streak++
	var/pop_chance = 75 * (gum_size - 5) / (gum_size + 2)
	var/survival_chance = 100 * (1 - pop_chance / 100) ** bubble_streak
	to_chat(bubble_blower, SPAN_NOTICE("Wow you've blown [bubble_streak] giant bubbles in a row! That bubble had a [round(pop_chance, 0.1)]% chance of bursting, and had only [round(survival_chance, 0.1)]% chance of continuing your streak. Good job!"))


/obj/item/reagent_container/food/gum/proc/stop_blowsing()
	to_chat(bubble_blower, SPAN_INFO("You decide to stop blowing bubbles with your gum."))
	if(text2num(action_timer) > 0)
		deltimer(action_timer)
	action_timer = null
	continuously_blowing_bubbles = FALSE


/obj/item/reagent_container/food/gum/clean_blood(cleaning_reagent)
	. = ..()
	if(isturf(loc))
		if(cleaning_reagent == "cleaner" || cleaning_reagent == "soap")
			qdel(src)

/obj/item/reagent_container/food/gum/proc/chew_tick()
	if(QDELETED(src) || QDELETED(bubble_blower))
		return

	if(bubble_blower.wear_mask != src)
		return

	if(reagents.total_volume <= 0)
		to_chat(bubble_blower, SPAN_NOTICE("This gum has run out of flavor, the exercise of chewing has lost its reward."))

	reagents.trans_to_ingest(bubble_blower, 1)

	chew_timer = addtimer(CALLBACK(src, PROC_REF(chew_tick)), rand(15,40) SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE)


////////////////////// SUB TYPES ///////////////////////.
/obj/item/reagent_container/food/gum/chew
	name = "\improper bunch of gum strips"
	base_icon_state = "chew"
	gum_size = GUM_SIZE_SMALL
	wrapped = FALSE


/obj/item/reagent_container/food/gum/chew/Initialize()
	. = ..()
	update_icon()	// base is wrapped... update icon on init to add color


/obj/item/reagent_container/food/gum/cube
	name = "\improper gum cube"
	base_icon_state = "cube"
	wrapped = FALSE
	gum_size = GUM_SIZE_MINI


/obj/item/reagent_container/food/gum/cube/Initialize()
	. = ..()
	update_icon()	// base is wrapped... update icon on init to add color
