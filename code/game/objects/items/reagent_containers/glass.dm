////////////////////////////////////////////////////////////////////////////////
/// (Mixing) Glass
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_container/glass
	name = " "
	var/base_name = " "
	desc = " "
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	flags_atom = FPRINT|OPENCONTAINER

	var/label_text = ""

	var/list/can_be_placed_into = list(
		/obj/structure/machinery/chem_master/,
		/obj/structure/machinery/chem_dispenser/,
		/obj/structure/machinery/reagentgrinder,
		/obj/structure/surface/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/item/clothing,
		/obj/structure/machinery/cryo_cell,
		/obj/item/explosive,
		/obj/item/mortar_shell/custom,
		/obj/item/ammo_magazine/rocket/custom,
		/obj/structure/machinery/bot/medbot,
		/obj/structure/machinery/computer/pandemic,
		/obj/item/storage/secure/safe,
		/obj/structure/machinery/iv_drip,
		/obj/structure/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/structure/machinery/sleeper,
		/obj/structure/machinery/smartfridge/,
		/obj/structure/machinery/biogenerator,
		/obj/structure/machinery/reagent_analyzer,
		/obj/structure/machinery/centrifuge,
		/obj/structure/machinery/autodispenser,
		/obj/item/reagent_container/hypospray,
		/obj/structure/machinery/constructable_frame)

/obj/item/reagent_container/glass/Initialize()
		..()
		base_name = name

/obj/item/reagent_container/glass/examine(mob/user)
	..()
	if(get_dist(user, src) > 2 && user != loc) return
	if(reagents && reagents.reagent_list.len)
		to_chat(user, SPAN_INFO("It contains [reagents.total_volume] units of liquid."))
	else
		to_chat(user, SPAN_INFO("It is empty."))
	if(!is_open_container())
		to_chat(user, SPAN_INFO("An airtight lid seals it completely."))

/obj/item/reagent_container/glass/attack_self()
	..()
	if(is_open_container())
		to_chat(usr, SPAN_NOTICE("You put the lid on \the [src]."))
		flags_atom ^= OPENCONTAINER
	else
		to_chat(usr, SPAN_NOTICE("You take the lid off \the [src]."))
		flags_atom |= OPENCONTAINER
	update_icon()

/obj/item/reagent_container/glass/afterattack(obj/target, mob/user , flag)

	if(!is_open_container() || !flag)
		return

	for(var/type in src.can_be_placed_into)
		if(istype(target, type))
			return

	if(ismob(target) && target.reagents && reagents.total_volume && user.a_intent == INTENT_HARM)
		to_chat(user, SPAN_NOTICE("You splash the solution onto [target]."))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)

		var/mob/living/M = target
		var/list/injected = list()
		for(var/datum/reagent/R in src.reagents.reagent_list)
			injected += R.name
		var/contained = english_list(injected)
		M.last_damage_source = initial(name)
		M.last_damage_mob = user
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been splashed with [src.name] by [user.name] ([user.ckey]). Reagents: [contained]</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to splash [M.name] ([M.key]). Reagents: [contained]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name] (REAGENTS: [contained]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

		visible_message(SPAN_WARNING("[target] has been splashed with something by [user]!"))
		reagents.reaction(target, TOUCH)
		if(!disposed)
			reagents.clear_reagents()
		return
	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		var/obj/structure/reagent_dispensers/D = target
		D.add_fingerprint(user)
		if(D.dispensing)
			if(!target.reagents.total_volume && target.reagents)
				to_chat(user, SPAN_WARNING("[target] is empty."))
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("[src] is full."))
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)

			if(!trans)
				to_chat(user, SPAN_DANGER("You fail to remove reagents from [target]."))
				return

			to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
		else
			if(reagents && !reagents.total_volume)
				to_chat(user, SPAN_WARNING("[src] is empty."))
				return

			if(D.reagents.total_volume >= D.reagents.maximum_volume)
				to_chat(user, SPAN_WARNING("[D] is full."))
				return

			var/trans = reagents.trans_to(D, D:amount_per_transfer_from_this)

			if(!trans)
				to_chat(user, SPAN_DANGER("You fail to add reagents to [target]."))
				return

			to_chat(user, SPAN_NOTICE("You fill [D] with [trans] units of the contents of [src]."))

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.

		if(!reagents.total_volume)
			to_chat(user, SPAN_WARNING("[src] is empty."))
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[target] is full."))
			return

		var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)

		if(!trans)
			to_chat(user, SPAN_DANGER("You fail to add reagents to [target]."))
			return

		to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to [target]."))

	else if(istype(target, /obj/structure/machinery/smartfridge))
		return

	else if((reagents.total_volume) && (user.a_intent == INTENT_HARM))
		to_chat(user, SPAN_NOTICE("You splash the solution onto [target]."))
		playsound(target, 'sound/effects/slosh.ogg', 25, 1)
		reagents.reaction(target, TOUCH)
		if(!disposed)
			reagents.clear_reagents()
		return

/obj/item/reagent_container/glass/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/tool/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitize(input(user, "Enter a label for [name]","Label", label_text))
		if(length(tmp_label) > MAX_NAME_LEN)
			to_chat(user, SPAN_WARNING("The label can be at most [MAX_NAME_LEN] characters long."))
		else
			user.visible_message(SPAN_NOTICE("[user] labels [src] as \"[tmp_label]\"."), \
								 SPAN_NOTICE("You label [src] as \"[tmp_label]\"."))
			label_text = tmp_label
			update_name_label()

/obj/item/reagent_container/glass/proc/update_name_label()
	if(label_text == "")
		name = base_name
	else
		name = "[base_name] ([label_text])"

/obj/item/reagent_container/glass/beaker
	name = "beaker"
	desc = "A beaker. Can hold up to 60 units."
	icon = 'icons/obj/items/chemistry.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	matter = list("glass" = 500)
	attack_speed = 4

/obj/item/reagent_container/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)			filling.icon_state = "[icon_state]-10"
			if(10 to 24) 		filling.icon_state = "[icon_state]10"
			if(25 to 49)		filling.icon_state = "[icon_state]25"
			if(50 to 74)		filling.icon_state = "[icon_state]50"
			if(75 to 79)		filling.icon_state = "[icon_state]75"
			if(80 to 90)		filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/reagent_container/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker. Can hold up to 120 units."
	icon_state = "beakerlarge"
	matter = list("glass" = 5000)
	volume = 120
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120)

/obj/item/reagent_container/glass/beaker/silver
	name = "large silver beaker"
	desc = "A large silver beaker. Can hold up to 240 units. The beaker itself acts as a silver catalyst."
	icon_state = "beakersilver"
	volume = 240
	matter = list("silver" = 5000)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,240)
	pixel_y = 5

/obj/item/reagent_container/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 60 units."
	icon_state = "beakernoreact"
	matter = list("glass" = 500)
	volume = 60
	amount_per_transfer_from_this = 10
	flags_atom = FPRINT|OPENCONTAINER|NOREACT

/obj/item/reagent_container/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology. Can hold up to 300 units."
	icon_state = "beakerbluespace"
	matter = list("glass" = 10000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)


/obj/item/reagent_container/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial. Can hold up to 30 units."
	icon_state = "vial"
	matter = list("glass" = 250)
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	flags_atom = FPRINT|OPENCONTAINER

/obj/item/reagent_container/glass/beaker/vial/New()
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/item/reagent_container/glass/beaker/vial/tricordrazine
	name = "tricordrazine vial"

/obj/item/reagent_container/glass/beaker/vial/tricordrazine/Initialize()
	. = ..()
	reagents.add_reagent("tricordrazine", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/vial/sedative
	name = "chloral hydrate vial"

/obj/item/reagent_container/glass/beaker/vial/sedative/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/vial/random
	var/tier

/obj/item/reagent_container/glass/beaker/vial/random/Initialize()
	. = ..()
	var/random_chem
	if(tier)
		random_chem = pick(chemical_gen_classes_list[tier])
	else
		random_chem = pick(	prob(3);pick(chemical_gen_classes_list["C1"]),\
							prob(5);pick(chemical_gen_classes_list["C2"]),\
							prob(7);pick(chemical_gen_classes_list["C3"]),\
							prob(10);pick(chemical_gen_classes_list["C4"]),\
							prob(15);pick(chemical_gen_classes_list["C5"]),\
							prob(25);pick(chemical_gen_classes_list["T1"]),\
							prob(15);pick(chemical_gen_classes_list["T2"]),\
							prob(10);pick(chemical_gen_classes_list["T3"]),\
							prob(5);pick(chemical_gen_classes_list["T4"]),\
							prob(15);"")
	if(random_chem)
		reagents.add_reagent(random_chem, 30)
		update_icon()

/obj/item/reagent_container/glass/beaker/vial/random/good/Initialize()
	tier = pick("C5","T4")
	. = ..()

/obj/item/reagent_container/glass/beaker/cryoxadone
	name = "cryoxadone beaker"

/obj/item/reagent_container/glass/beaker/cryoxadone/Initialize()
	. = ..()
	reagents.add_reagent("cryoxadone", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/cryopredmix
	name = "cryomix beaker"

/obj/item/reagent_container/glass/beaker/cryopredmix/Initialize()
	. = ..()
	reagents.add_reagent("cryoxadone", 30)
	reagents.add_reagent("clonexadone", 30)
	update_icon()

/obj/item/reagent_container/glass/beaker/sulphuric
	name = "sulphuric acid beaker"

/obj/item/reagent_container/glass/beaker/sulphuric/Initialize()
	. = ..()
	reagents.add_reagent("sacid", 60)
	update_icon()

/obj/item/reagent_container/glass/beaker/ethanol
	name = "ethanol beaker"

/obj/item/reagent_container/glass/beaker/ethanol/Initialize()
	. = ..()
	reagents.add_reagent("ethanol", 60)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/phosphorus
	name = "phosphorus beaker"

/obj/item/reagent_container/glass/beaker/large/phosphorus/Initialize()
	. = ..()
	reagents.add_reagent("phosphorus", 120)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/lithium
	name = "lithium beaker"

/obj/item/reagent_container/glass/beaker/large/lithium/Initialize()
	. = ..()
	reagents.add_reagent("lithium", 120)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/sodiumchloride
	name = "sodium chloride beaker"

/obj/item/reagent_container/glass/beaker/large/sodiumchloride/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 120)
	update_icon()

/obj/item/reagent_container/glass/beaker/large/potassiumchloride
	name = "potassium chloride beaker"

/obj/item/reagent_container/glass/beaker/large/potassiumchloride/Initialize()
	. = ..()
	reagents.add_reagent("potassium_chloride", 120)
	update_icon()

/obj/item/reagent_container/glass/canister
	name = "Hydrogen canister"
	desc = "A canister containing pressurized hydrogen. Can be used to refill storage tanks."
	icon = 'icons/obj/items/tank.dmi'
	icon_state = "canister_hydrogen"
	item_state = "anesthetic"
	amount_per_transfer_from_this = 100
	possible_transfer_amounts = list(50,100,200,300,400)
	volume = 400
	var/reagent = "hydrogen"

/obj/item/reagent_container/glass/canister/Initialize()
	. = ..()
	reagents.add_reagent(reagent, 400)

/obj/item/reagent_container/glass/canister/afterattack(obj/target, mob/user , flag)
	if(!istype(target, /obj/structure/reagent_dispensers))
		return
	. = ..()

/obj/item/reagent_container/glass/canister/ammonia
	name = "Ammonia canister"
	desc = "A canister containing pressurized ammonia. Can be used to refill storage tanks."
	icon_state = "canister_ammonia"
	reagent = "ammonia"

/obj/item/reagent_container/glass/canister/methane
	name = "Methane canister"
	desc = "A canister containing pressurized methane. Can be used to refill storage tanks."
	icon_state = "canister_methane"
	reagent = "methane"

/obj/item/reagent_container/glass/canister/pacid
	name = "Polytrinic acid canister"
	desc = "A canister containing pressurized polytrinic acid. Can be used to refill storage tanks."
	icon_state = "canister_pacid"
	reagent = "pacid"

/obj/item/reagent_container/glass/canister/oxygen
	name = "Oxygen canister"
	desc = "A canister containing pressurized oxygen. Can be used to refill storage tanks."
	icon_state = "canister_oxygen"
	reagent = "oxygen"

/obj/item/reagent_container/glass/bucket
	desc = "It's a bucket. Holds 120 units."
	name = "bucket"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	matter = list("metal" = 2000)
	w_class = SIZE_MEDIUM
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120)
	volume = 120
	flags_atom = FPRINT|OPENCONTAINER

/obj/item/reagent_container/glass/bucket/attackby(obj/item/I, mob/user)
	if(isprox(I))
		to_chat(user, "You add [I] to [src].")
		qdel(I)
		user.put_in_hands(new /obj/item/frame/bucket_sensor)
		user.drop_inv_item_on_ground(src)
		qdel(src)
	else if(istype(I, /obj/item/tool/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("[src] is out of water!"))
		else
			reagents.trans_to(I, 5)
			to_chat(user, SPAN_NOTICE("You wet [I] in [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return
	else
		..()

/obj/item/reagent_container/glass/bucket/on_reagent_change()
	update_icon()

/obj/item/reagent_container/glass/bucket/pickup(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bucket/dropped(mob/user)
	..()
	update_icon()

/obj/item/reagent_container/glass/bucket/attack_hand()
	..()
	update_icon()

/obj/item/reagent_container/glass/bucket/update_icon()
	overlays.Cut()

	if(reagents && reagents.total_volume)
		var/image/filling = image('icons/obj/items/reagentfillings.dmi', src, "[icon_state]-00-65")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 33) 		filling.icon_state = "[icon_state]-00-33"
			if(34 to 65) 		filling.icon_state = "[icon_state]-34-65"
			if(66 to INFINITY)	filling.icon_state = "[icon_state]-66-100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/reagent_container/glass/bucket/mopbucket
	name = "mop bucket"
	desc = "A larger bucket, typically used with a mop. Holds 240 units"
	icon_state = "mopbucket"
	matter = list("metal" = 4000)
	w_class = SIZE_LARGE
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,60,120,240)
	volume = 240
	flags_atom = FPRINT|OPENCONTAINER

/obj/item/reagent_container/glass/bucket/janibucket
	name = "janitorial bucket"
	desc = "It's a large bucket that fits in a janitorial cart. Holds 500 units."
	icon_state = "janibucket"
	volume = 500


/obj/item/reagent_container/glass/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = SIZE_TINY
	icon = 'icons/obj/items/items.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 5
	can_be_placed_into = null
	flags_atom = FPRINT|OPENCONTAINER
	flags_item = NOBLUDGEON

/obj/item/reagent_container/glass/rag/attack_self(mob/user as mob)
	return

/obj/item/reagent_container/glass/rag/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(ismob(target) && target.reagents && reagents.total_volume)
		user.visible_message(SPAN_DANGER("\The [target] has been smothered with \the [src] by \the [user]!"), SPAN_DANGER("You smother \the [target] with \the [src]!"), "You hear some struggling and muffled cries of surprise")
		src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		return
	else
		..()

/obj/item/reagent_container/glass/rag/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)
		return
	if(istype(AM) && (src in user))
		user.visible_message("[user] starts to wipe down [AM] with [src]!")
		if(do_after(user,30, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			user.visible_message("[user] finishes wiping off the [AM]!")
			AM.clean_blood()


/obj/item/reagent_container/glass/rag/examine(mob/user)
	to_chat(user, "That's \a [src].")
	to_chat(usr, desc)
