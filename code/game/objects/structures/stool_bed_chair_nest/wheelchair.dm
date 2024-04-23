/obj/structure/bed/chair/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon_state = "wheelchair"
	anchored = FALSE
	drag_delay = 1 //pulling something on wheels is easy
	picked_up_item = null
	var/bloodiness = 0
	var/move_delay = 6

	var/has_wire = null
	var/obj/item/explosive/plastic/bomb = null
	var/first_ring = TRUE

/obj/structure/bed/chair/wheelchair/handle_rotation()
	overlays.Cut()
	var/image/O = image(icon = 'icons/obj/objects.dmi', icon_state = "w_overlay", layer = FLY_LAYER, dir = src.dir)
	overlays += O
	if(buckled_mob)
		buckled_mob.setDir(dir)

/obj/structure/bed/chair/wheelchair/relaymove(mob/user, direction)
	if(world.time <= l_move_time + move_delay)
		return
	// Redundant check?
	if(user.is_mob_incapacitated())
		return

	if(propelled) //can't manually move it mid-propelling.
		return

	if(ishuman(user))
		var/mob/living/carbon/human/driver = user
		var/obj/limb/left_hand = driver.get_limb("l_hand")
		var/obj/limb/right_hand = driver.get_limb("r_hand")
		var/working_hands = 2
		move_delay = initial(move_delay)
		if(!left_hand || (left_hand.status & LIMB_DESTROYED))
			move_delay += 4 //harder to move a wheelchair with a single hand
			working_hands--
		else if((left_hand.status & LIMB_BROKEN) && !(left_hand.status & LIMB_SPLINTED))
			move_delay++
		if(!right_hand || (right_hand.status & LIMB_DESTROYED))
			move_delay += 4
			working_hands--
		else if((right_hand.status & LIMB_BROKEN) && !(right_hand.status & LIMB_SPLINTED))
			move_delay += 2
		if(!working_hands)
			return // No hands to drive your chair? Tough luck!
		if(driver.pulling && driver.pulling.drag_delay && driver.get_pull_miltiplier()) //Dragging stuff can slow you down a bit.
			var/pull_delay = driver.pulling.get_pull_drag_delay() * driver.get_pull_miltiplier()
			move_delay += max(driver.pull_speed + pull_delay + 3*driver.grab_level, 0) //harder grab makes you slower

		if(isgun(driver.get_active_hand())) //Wheelchair user has a gun out, so obviously can't move
			return

		if(driver.next_move_slowdown)
			move_delay += driver.next_move_slowdown
			driver.next_move_slowdown = 0

		if(driver.temporary_slowdown)
			move_delay += 2 //Temporary slowdown slows hard

	step(src, direction)


/obj/structure/bed/chair/wheelchair/Move()
	. = ..()
	if(. && bloodiness)
		create_track()

/obj/structure/bed/chair/wheelchair/Collide(atom/A)
	..()
	if(!buckled_mob) return

	if(propelled)
		var/mob/living/occupant = buckled_mob
		unbuckle()

		var/def_zone = rand_zone()
		occupant.throw_atom(A, 3, propelled)
		occupant.apply_effect(6, STUN)
		occupant.apply_effect(6, WEAKEN)
		occupant.apply_effect(6, STUTTER)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 25, 1)
		if(ishuman(A) && !isyautja(A))
			var/mob/living/victim = A
			def_zone = rand_zone()
			victim.apply_effect(6, STUN)
			victim.apply_effect(6, WEAKEN)
			victim.apply_effect(6, STUTTER)
			victim.apply_damage(10, BRUTE, def_zone)
		occupant.visible_message(SPAN_DANGER("[occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/wheelchair/proc/create_track()
	var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
	var/newdir = get_dir(get_step(loc, dir), loc)
	if(newdir == dir)
		B.setDir(newdir)
	else
		newdir = newdir|dir
		if(newdir == 3)
			newdir = NORTH
		else if(newdir == 12)
			newdir = EAST
		B.setDir(newdir)
	bloodiness--

/obj/structure/bed/chair/wheelchair/do_buckle(mob/target, mob/user)
	if(ishuman(target) && ishuman(user))
		ADD_TRAIT(target, TRAIT_USING_WHEELCHAIR, TRAIT_SOURCE_BUCKLE)
	. = ..()

/obj/structure/bed/chair/wheelchair/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/stack/cable_coil))
		if(has_wire == TRUE)
			to_chat(user, SPAN_WARNING("[src] is already wired!"))
			return
		else
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
				var/obj/item/stack/cable_coil/wire = item //aaaahh... wire
				if(wire.use(5))
					has_wire = TRUE
					to_chat(user, SPAN_BLUE("You wire [src] with the cable coil."))
					return
				else
					to_chat(user, SPAN_WARNING("You need at least 5 pieces of cable coil to wire [src]!"))
					return

	if(istype(item, /obj/item/explosive/plastic/custom))
		if(bomb)
			to_chat(user, SPAN_WARNING("[src] is already rigged with an explosive!"))
			return
		if(!has_wire)
			to_chat(user, SPAN_WARNING("[src] must be wired for you to rig it with [item]!"))
			return
		else
			if(do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
				var/obj/item/explosive/plastic/custom/explosive = item
				user.drop_held_item()
				src.contents += explosive
				bomb = explosive
				to_chat(user, SPAN_BLUE("You rig [src] with [explosive.name]."))
				msg_admin_niche("[key_name(user, user.client)] rigged [explosive.name] on [src.name] at ([src.x],[src.y],[src.z] [ADMIN_JMP(src)]") //1984
				return

/obj/structure/bed/chair/wheelchair/proc/ring(mob/user)
	if(has_wire)
		playsound(src, 'sound/misc/desk_bell.ogg', 80)
		if(first_ring)
			first_ring = FALSE // so you don't blow up on the first ring
			return
		if(bomb)
			if(prob(15)) // last chance to look at me hector
				bomb.cause_data = create_cause_data("Explosive Wheelchair", user, src)
				if(iscarbon(buckled_mob))
					var/mob/living/carbon/human = buckled_mob
					human.gib(create_cause_data("Explosive Wheelchair", user, src)) //no surviving this
				bomb.forceMove(get_turf(src)) //move to the turf so that the explosive power isn't halved
				bomb.prime(TRUE)
