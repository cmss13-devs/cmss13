/obj/structure/barricade/sandbags
	name = "sandbag barricade"
	desc = "A bunch of bags filled with sand, stacked into a small wall. Surprisingly sturdy, albeit labour intensive to set up. Trusted to do the job since 1914."
	icon_state = "sandbag1"
	barricade_resistance = 15
	health = BARRICADE_SANDBAG_TRESHOLD_1
	maxhealth = BARRICADE_SANDBAG_TRESHOLD_1
	stack_type = /obj/item/stack/sandbags
	debris = list(/obj/item/stack/sandbags)
	barricade_hitsound = "sound/weapons/Genhit.ogg"
	barricade_type = "sandbag"
	can_wire = FALSE
	stack_amount = 1
	var/build_stage = BARRICADE_SANDBAG_1

/obj/structure/barricade/sandbags/New(loc, mob/user, direction, var/amount = 1)
	if(direction)
		dir = direction

	if(dir == SOUTH)
		pixel_y = -7
	else if(dir == NORTH)
		pixel_y = 7

	..(loc, user)

	for(var/i = 1 to amount-1)
		increment_build_stage()

/obj/structure/barricade/sandbags/update_icon()
	..()

	icon_state = "sandbag[build_stage]"

/obj/structure/barricade/sandbags/update_damage_state()
	if(health <= BARRICADE_SANDBAG_TRESHOLD_4 && build_stage != BARRICADE_SANDBAG_4)
		build_stage = BARRICADE_SANDBAG_4
		maxhealth = BARRICADE_SANDBAG_TRESHOLD_4
		if(is_wired)
			is_wired = FALSE
			climbable = TRUE
			flags_can_pass_front |= PASS_OVER_THROW_MOB
			flags_can_pass_behind |= PASS_OVER_THROW_MOB
			new/obj/item/stack/barbed_wire(src.loc)
		can_wire = FALSE
		stack_amount = 4
	if(health <= BARRICADE_SANDBAG_TRESHOLD_3 && build_stage != BARRICADE_SANDBAG_3)
		build_stage = BARRICADE_SANDBAG_3
		maxhealth = BARRICADE_SANDBAG_TRESHOLD_3
		stack_amount = 3
	if(health <= BARRICADE_SANDBAG_TRESHOLD_2 && build_stage != BARRICADE_SANDBAG_2)
		build_stage = BARRICADE_SANDBAG_2
		maxhealth = BARRICADE_SANDBAG_TRESHOLD_2
		stack_amount = 2
	if(health <= BARRICADE_SANDBAG_TRESHOLD_1 && build_stage != BARRICADE_SANDBAG_1)
		build_stage = BARRICADE_SANDBAG_1
		maxhealth = BARRICADE_SANDBAG_TRESHOLD_1
		stack_amount = 1
		
/obj/structure/barricade/sandbags/attackby(obj/item/W, mob/user)
	for(var/obj/effect/xenomorph/acid/A in src.loc)
		if(A.acid_t == src)
			to_chat(user, "You can't get near that, it's melting!")
			return

	if(istype(W, /obj/item/tool/shovel) && user.a_intent != "hurt")
		var/obj/item/tool/shovel/ET = W
		if(!ET.folded)
			user.visible_message(SPAN_NOTICE("[user] starts disassembling [src]."), \
			SPAN_NOTICE("You start disassembling [src]."))
			if(do_after(user, ET.shovelspeed, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD, src))
				user.visible_message(SPAN_NOTICE("[user] disassembles [src]."),
				SPAN_NOTICE("You disassemble [src]."))
				destroy(TRUE)
		return TRUE

	if(istype(W, stack_type))
		var/obj/item/stack/sandbags/SB = W
		if(user.action_busy)
			return
		if(build_stage == BARRICADE_SANDBAG_5)
			to_chat(user, SPAN_WARNING("You can't stack more on [src]."))
			return

		user.visible_message(SPAN_NOTICE("[user] starts adding more [SB] to [src]."), \
			SPAN_NOTICE("You start adding sandbags to [src]."))
		if(!do_after(user, 5, INTERRUPT_NO_NEEDHAND, BUSY_ICON_FRIENDLY, src))
			return
		
		user.visible_message(SPAN_NOTICE("[user] finishes stacking [SB] onto [src]."), \
			SPAN_NOTICE("You stack [SB] onto [src]."))
		SB.use(1)
		increment_build_stage()
		update_icon()
		return
	else
		. = ..()

/obj/structure/barricade/sandbags/proc/increment_build_stage()
	switch(build_stage)
		if(BARRICADE_SANDBAG_1)
			health = BARRICADE_SANDBAG_TRESHOLD_2
			maxhealth = BARRICADE_SANDBAG_TRESHOLD_2
			stack_amount = 2
		if(BARRICADE_SANDBAG_2)
			health = BARRICADE_SANDBAG_TRESHOLD_3
			maxhealth = BARRICADE_SANDBAG_TRESHOLD_3
			stack_amount = 3
		if(BARRICADE_SANDBAG_3)
			health = BARRICADE_SANDBAG_TRESHOLD_4
			maxhealth = BARRICADE_SANDBAG_TRESHOLD_4
			stack_amount = 4
		if(BARRICADE_SANDBAG_4)
			health = BARRICADE_SANDBAG_TRESHOLD_5
			maxhealth = BARRICADE_SANDBAG_TRESHOLD_5
			stack_amount = 5
			can_wire = TRUE
	build_stage++


/obj/structure/barricade/sandbags/wired/New()
	health = BARRICADE_SANDBAG_TRESHOLD_5
	maxhealth = BARRICADE_SANDBAG_TRESHOLD_5
	maxhealth += 50
	update_health(-50)
	stack_amount = 5
	can_wire = FALSE
	is_wired = TRUE
	flags_can_pass_front &= ~(PASS_OVER_THROW_MOB)
	flags_can_pass_behind &= ~(PASS_OVER_THROW_MOB)
	build_stage = BARRICADE_SANDBAG_5
	update_icon()
	climbable = FALSE
	. = ..()