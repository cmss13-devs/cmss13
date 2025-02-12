/obj/item/reagent_container/food/snacks/fishable
	name = "\improper fishable snack"
	desc = "From the deep it has come. To the deep you shall return. Mother Ocean consumes all."
	icon = 'icons/obj/items/fishing_atoms.dmi'
	icon_state = null
	bitesize = 4
	trash = null
	var/min_length = 1
	var/max_length = 5
	var/total_length = ""
	var/guttable = TRUE
	var/gutted = FALSE
	var/gut_icon_state = null
	var/gut_time = 3
	var/initial_desc = ""
	var/list/guttable_atoms = list(/obj/item/reagent_container/food/snacks/meat, /obj/item/reagent_container/food/snacks/meat/synthmeat)//placeholders, for now
	var/base_gut_meat = /obj/item/reagent_container/food/snacks/meat
	//slice_path = null//
	//slices_num
	//package = 0//did someone say shell critters?

/obj/item/reagent_container/food/snacks/fishable/Initialize()
	. = ..()
	total_length = rand(min_length, max_length)//used for fish fact at the round end
	initial_desc = initial(desc)
	gut_icon_state = icon_state + "_gutted"
	update_desc()


/obj/item/reagent_container/food/snacks/fishable/proc/update_desc()
	var/gut_desc
	if(guttable)
		desc = initial_desc + "\n\nIt can still be gutted and cleaned."
	if(gutted)
		desc = initial_desc + "\n\nIt has already been gutted!"
	if(!guttable)
		desc = initial_desc + "\n\nIt cannot be gutted."
	gut_desc = desc

	desc = gut_desc + "\n\nIt is [total_length]in."
	return

/obj/item/reagent_container/food/snacks/fishable/update_icon()
	if(gutted && (gut_icon_state != null))
		icon_state = gut_icon_state
		return
	return

/obj/item/reagent_container/food/snacks/fishable/attackby(obj/item/W, mob/user)
	if(gutted)
		to_chat(user, SPAN_WARNING("[src] has already been gutted!"))
		return
	if(!guttable)
		to_chat(user, SPAN_WARNING("[src] cannot be gutted."))
		return
	if(W.sharp == IS_SHARP_ITEM_ACCURATE || W.sharp == IS_SHARP_ITEM_BIG)
		user.visible_message("[user] starts to cut [W] open and clean it.", "You start to gut [src].")
		playsound(loc, 'sound/effects/blobattack.ogg', 25, 1)
		if(do_after(user, gut_time SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, src, INTERRUPT_ALL))
			var/gut_loot = roll(total_length/2 - min_length)
			if(gut_loot <= 0)
				gut_loot = 1

			gibs(user.loc)
			new base_gut_meat(user.loc)//always spawn at least one meat per gut
			playsound(loc, 'sound/effects/splat.ogg', 25, 1)//replace
			for(var/i = 1, i < gut_loot, i++)
				var/T = pick(guttable_atoms)
				new T(user.loc)
			gutted = TRUE
			update_desc()
			update_icon()
			return

/obj/item/reagent_container/food/snacks/fishable/crab
	name = "\improper spindle crab"
	desc = "Looks like a little crab"
	icon_state = "crab"
	gut_icon_state = "crab_gutted"
	guttable = TRUE
	min_length = 4
	max_length = 8
	base_gut_meat = /obj/item/reagent_container/food/snacks/meat/fish/crab
	guttable_atoms = list(/obj/item/reagent_container/food/snacks/meat/fish/crab)
	bitesize = 6
	trash = null//todo, crab shell

/obj/item/reagent_container/food/snacks/fishable/crab/Initialize()
	. = ..()
	reagents.add_reagent("fish", 5)
	bitesize = 3

//----------------//
//SQUIDS
/obj/item/reagent_container/food/snacks/fishable/squid
	name = "generic squid"
	desc = "They have beaks."
	icon_state = "squid"
	bitesize = 8

/obj/item/reagent_container/food/snacks/fishable/squid/whorl
	name = "whorl squid"
	desc = "A squat little fella in a whorl shaped shell, hence the name."
	icon_state = "squid_whorl"
	gut_icon_state = "squid_whorl_gutted"
	guttable = TRUE
	min_length = 4
	max_length = 14
	base_gut_meat = /obj/item/reagent_container/food/snacks/meat/fish/squid
	guttable_atoms = list(/obj/item/reagent_container/food/snacks/meat/fish/squid)

/obj/item/reagent_container/food/snacks/fishable/squid/sock
	name = "sock squid"
	desc = "Small shelled squids are a common occurance on New Varadero. While using the term 'squid' to describe this form of creature would make a biologist fuming mad, the name has stuck given their relative apperance. Sock squids are renowned for their robust taste."
	icon_state = "squid_sock"
	gut_icon_state = "squid_sock_gutted"
	guttable = TRUE
	min_length = 1
	max_length = 5
	base_gut_meat = /obj/item/reagent_container/food/snacks/meat/fish/squid/alt
	guttable_atoms = list(/obj/item/reagent_container/food/snacks/meat/fish/squid/alt)

/obj/item/reagent_container/food/snacks/fishable/squid/sock/Initialize()
	. = ..()
	reagents.add_reagent("fish", 1)
	bitesize = 1

//----------------//
//WORMS
/obj/item/reagent_container/food/snacks/fishable/worm
	name = "sea worm"
	desc = "Could be useful as bait?"
	icon_state = "worm_redring"
	guttable = TRUE
	gut_icon_state = "worm_redring_gutted"
	base_gut_meat = /obj/item/fish_bait

/obj/item/reagent_container/food/snacks/fishable/worm/Initialize()
	. = ..()
	reagents.add_reagent("enzyme", 1)
	bitesize = 1
	//todo, attackby with a knife so you can make bait objects for fishing with
/obj/item/reagent_container/food/snacks/fishable/quadtopus
	name = "quadtopus"
	desc = "Like an octopus, but a whole lot meaner, dumber, and smaller. So basically a marine Marine."
	icon_state = "quadtopus"
	bitesize = 2
//--------------------//
// SHELLED CRITTERS, you have to pry them open with a SHARP object to get the guts out. Maybe should be bool hasshell = TRUE and overrite gutting proc?
/obj/item/reagent_container/food/snacks/fishable/shell/clam
	name = "clam"
	desc = "A sea critter contained inside of a shell."
	icon_state = "shell_clam"
	guttable = TRUE
	base_gut_meat = /obj/item/ore/pearl

/obj/item/reagent_container/food/snacks/fishable/shell/clam/Initialize()
	. = ..()
	reagents.add_reagent("fish", 1)
	bitesize = 1

//--------------------//
// Pan Fish, Regular fish you can gut and clean (additional fish past this point)
/obj/item/reagent_container/food/snacks/fishable/fish/bluegill
	name = "bluegill"
	desc = "A small spiny fish, yeouch!"
	gut_icon_state = "bluegill_gutted"
	guttable = TRUE
	min_length = 5
	max_length = 16
	base_gut_meat = /obj/item/reagent_container/food/snacks/meat/fish/bluegill
	guttable_atoms = list(/obj/item/reagent_container/food/snacks/meat/fish/bluegill)
	icon_state = "bluegill"
	bitesize = 3

/obj/item/reagent_container/food/snacks/fishable/fish/bluegill/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fishable/fish/bass
	name = "bass"
	desc = "A staple classic in fish cuisine!"
	guttable = TRUE
	base_gut_meat = /obj/item/reagent_container/food/snacks/meat/fish/bass
	guttable_atoms = list(/obj/item/reagent_container/food/snacks/meat/fish/bass)
	icon_state = "bass"
	gut_icon_state = "bass_gutted"
	min_length = 8
	max_length = 32
	bitesize = 6

/obj/item/reagent_container/food/snacks/fishable/fish/bass/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	bitesize = 3

/obj/item/reagent_container/food/snacks/fishable/fish/catfish
	name = "catfish"
	desc = "Quite large though not good for eating since it's a bottom feeder."
	guttable = FALSE
	icon_state = "catfish"
	min_length = 10
	max_length = 108

/obj/item/reagent_container/food/snacks/fishable/fish/catfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	bitesize = 6

//--------------------//
//Urchins, spikey bottom-feeding creatures
/obj/item/reagent_container/food/snacks/fishable/urchin/purple
	name = "purple urchin"
	desc = "Glad I didn't step on it!"
	icon_state = "urchin_purple"
	guttable = FALSE
	min_length = 2
	max_length = 9

/obj/item/reagent_container/food/snacks/fishable/urchin/red
	name = "red urchin"
	desc = "Glad I didn't step on it, it looks angry!"
	guttable = FALSE
	icon_state = "urchin_red"
	min_length = 2
	max_length = 9
//finished code on worm and clam fish and items, added 3 new fish types (catfish being non-guttable is on purpose), worm now drops bait when gutted
