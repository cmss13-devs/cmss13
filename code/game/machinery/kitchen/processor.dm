/obj/structure/machinery/processor
	name = "Food Processor"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "processor"
	layer = ABOVE_TABLE_LAYER
	density = TRUE
	anchored = TRUE
	wrenchable = TRUE
	var/broken = 0
	var/processing = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 50

/datum/food_processor_process
	var/input
	var/output
	var/time = 40
	proc/process(loc, what)
		if (src.output && loc)
			new src.output(loc)
		if (what)
			qdel(what)

	/* objs */
	meat
		input = /obj/item/reagent_container/food/snacks/meat
		output = /obj/item/reagent_container/food/snacks/meatball

	potato
		input = /obj/item/reagent_container/food/snacks/grown/potato
		output = /obj/item/reagent_container/food/snacks/rawsticks

	carrot
		input = /obj/item/reagent_container/food/snacks/grown/carrot
		output = /obj/item/reagent_container/food/snacks/carrotfries

	soybeans
		input = /obj/item/reagent_container/food/snacks/grown/soybeans
		output = /obj/item/reagent_container/food/snacks/soydope

	wheat
		input = /obj/item/reagent_container/food/snacks/grown/wheat
		output = /obj/item/reagent_container/food/snacks/flour

	spaghetti
		input = /obj/item/reagent_container/food/snacks/flour
		output = /obj/item/reagent_container/food/snacks/spagetti

	/* mobs */
	mob
		process(loc, what)
			..()

/obj/structure/machinery/processor/initialize_pass_flags(var/datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_can_pass_all = SETUP_LIST_FLAGS(PASS_HIGH_OVER_ONLY, PASS_AROUND, PASS_OVER_THROW_ITEM)

/obj/structure/machinery/processor/proc/select_recipe(var/X)
	for (var/Type in typesof(/datum/food_processor_process) - /datum/food_processor_process - /datum/food_processor_process/mob)
		var/datum/food_processor_process/P = new Type()
		if (!istype(X, P.input))
			continue
		return P
	return 0

/obj/structure/machinery/processor/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(processing)
		to_chat(user, SPAN_DANGER("The processor is in the process of processing."))
		return 1
	if(contents.len > 0) //TODO: several items at once? several different items?
		to_chat(user, SPAN_DANGER("Something is already in the processing chamber."))
		return 1
	if(iswrench(O))
		. = ..()
		return
	var/obj/what = O
	if (istype(O, /obj/item/grab))
		var/obj/item/grab/G = O
		what = G.grabbed_thing

	var/datum/food_processor_process/P = select_recipe(what)
	if (!P)
		to_chat(user, SPAN_DANGER("That probably won't blend."))
		return 1
	user.visible_message("[user] put [what] into [src].", \
		"You put the [what] into [src].")
	user.drop_held_item()
	what.forceMove(src)

/obj/structure/machinery/processor/attack_hand(var/mob/user as mob)
	if (src.stat != 0) //NOPOWER etc
		return
	if(src.processing)
		to_chat(user, SPAN_DANGER("The processor is in the process of processing."))
		return 1
	if(src.contents.len == 0)
		to_chat(user, SPAN_DANGER("The processor is empty."))
		return 1
	for(var/O in src.contents)
		var/datum/food_processor_process/P = select_recipe(O)
		if (!P)
			log_admin("DEBUG: [O] in processor havent suitable recipe. How do you put it in?") //-rastaf0
			continue
		src.processing = 1
		user.visible_message(SPAN_NOTICE("[user] turns on [src]."), \
			"You turn on [src].", \
			"You hear a food processor.")
		playsound(src.loc, 'sound/machines/blender.ogg', 25, 1)
		use_power(500)
		sleep(P.time)
		P.process(src.loc, O)
		src.processing = 0
	src.visible_message(SPAN_NOTICE("\the [src] finished processing."), \
		"You hear the food processor stopping/")

