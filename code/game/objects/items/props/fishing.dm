//fishing poles and what not
/obj/structure/prop/fishing
	name = "fishing pole"
	desc = "For god's sake I just want to fish."
	icon = 'icons/obj/structures/fishing.dmi'
	icon_state = "pole"
	density = 0
	unacidable = TRUE
	unslashable = TRUE
	breakable = FALSE //can't destroy these
	anchored = 1

/obj/structure/prop/fishing/pole_interactive
	var/common_fishable_atoms = list(//to-do, code in actual fish and add better items
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/marine,
	)
	var/uncommon_fishable_atoms = list(
		/obj/item/cell/high,
		/obj/item/device/multitool,
	)
	var/rare_fishable_atoms = list(
		/obj/item/reagent_container/food/snacks/packaged_burrito
	)
	var/ultra_rare_fishable_atoms = list(
		/obj/item/card/data/clown,
		/obj/item/reagent_container/food/snacks/clownburger,
		/obj/item/reagent_container/pill/ultrazine/unmarked,
	)
	var/time_to_fish = 30 SECONDS
	var/fishing_success = 'sound/items/bikehorn.ogg'//to-do get a sound effect
	var/fishing_start = 'sound/items/fulton.ogg'
	var/fishing_failure = 'sound/items/jetpack_beep.ogg'

	var/common_weight = 80//we can instance these on a per object basis to make 'lucky' rods
	var/uncommon_weight = 40
	var/rare_weight = 5
	var/ultra_rare_weight = 1

/*
/obj/structure/prop/fishing/pole_interactive/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/bait))
		to_chat("[W] is not bait. Trying something else.")//to-do, change loot tables depending on the quality of bait used
*/

/obj/structure/prop/fishing/pole_interactive/attack_hand(mob/user)
	time_to_fish = rand(5 SECONDS, 10 SECONDS)
	if(isXeno(user))//xenos can't fish
		to_chat(user, "You stare cluelessly at the strange device.")
	if(ishuman(user))//all humans, including yautja can fish. Behold, the ultimate hunt!
		playsound(src, fishing_start, 50, 1)
		if(do_after(user, time_to_fish, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
			src.spawn_loot(user)

/obj/structure/prop/fishing/pole_interactive/proc/spawn_loot(var/mob/M)
	var/turf/T = get_step(get_step(src, dir), dir)//at least 2 tiles away, also add a temp_visual water splash when those are merged into the codebase
	var/obj/item/P
	var/type_to_spawn
	var/failed = FALSE
	if(prob(common_weight))
		type_to_spawn = pick(common_fishable_atoms)
	else if (prob(uncommon_weight))
		type_to_spawn = pick(uncommon_fishable_atoms)
	else if (prob(rare_weight))
		type_to_spawn = pick(rare_fishable_atoms)
	else if (prob(ultra_rare_weight))
		type_to_spawn = pick(ultra_rare_fishable_atoms)
	else
		failed = TRUE

	if(failed)
		playsound(src, fishing_failure, 50, 1)
		visible_message(SPAN_NOTICE("[M] fails to fish up anything."), SPAN_NOTICE("You don't seem to catch anything..."))
		return
	else
		P = new type_to_spawn(T)
		P.throw_atom(M.loc, 4, 3)
		playsound(src, fishing_success, 50, 1)
		visible_message(SPAN_NOTICE("[M] fishes up [P]!"), SPAN_NOTICE("You fish up [P]!"))

	return

/obj/structure/prop/fishing/line
	name = "fishing line"
	desc = "Super thin wire attached to a fishing pole."
	icon_state = "line_short"
	flags_atom = NOINTERACT

/obj/structure/prop/fishing/line/long
	icon_state = "line_long_1"

/obj/structure/prop/fishing/line/long/part2
	icon_state = "line_long_2"

