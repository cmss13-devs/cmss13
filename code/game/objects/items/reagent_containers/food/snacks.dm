//Food items that are eaten normally and don't leave anything behind.
/obj/item/reagent_container/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/items/food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/package = 0
	var/made_from_player = ""
	center_of_mass = "x=15;y=15"

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/reagent_container/food/snacks/proc/On_Consume(var/mob/M)
	SEND_SIGNAL(src, COMSIG_SNACK_EATEN, M)
	if(!usr)	return

	if(!reagents.total_volume)
		if(M == usr)
			to_chat(usr, SPAN_NOTICE("You finish eating \the [src]."))
		M.visible_message(SPAN_NOTICE("[M] finishes eating \the [src]."))
		usr.drop_inv_item_on_ground(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/reagent_container/food/snacks/attack_self(mob/user)
	..()

	if (world.time <= user.next_move)
		return
	attack(user, user, "head")//zone does not matter
	user.next_move += attack_speed

/obj/item/reagent_container/food/snacks/attack(mob/M, mob/user)
	if(reagents && !reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
		to_chat(user, SPAN_DANGER("None of [src] left, oh no!"))
		M.drop_inv_item_on_ground(src)	//so icons update :[
		qdel(src)
		return 0

	if(package)
		to_chat(M, SPAN_WARNING("How do you expect to eat this with the package still on?"))
		return 0

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(fullness > 540 && world.time < C.overeat_cooldown)
			to_chat(user, SPAN_WARNING("[user == M ? "You" : "They"] don't feel like eating more right now."))
			return
		if(isSynth(C))
			fullness = 200 //Synths never get full

		if(fullness > 540)
			C.overeat_cooldown = world.time + OVEREAT_TIME

		if(M == user)//If you're eating it yourself
			if (fullness <= 50)
				to_chat(M, SPAN_WARNING("You hungrily chew out a piece of [src] and gobble it!"))
			if (fullness > 50 && fullness <= 150)
				to_chat(M, SPAN_NOTICE(" You hungrily begin to eat [src]."))
			if (fullness > 150 && fullness <= 350)
				to_chat(M, SPAN_NOTICE(" You take a bite of [src]."))
			if (fullness > 350 && fullness <= 540)
				to_chat(M, SPAN_NOTICE(" You unwillingly chew a bit of [src]."))
			if (fullness > 540)
				to_chat(M, SPAN_WARNING("You reluctantly force more of [src] to go down your throat."))
		else
			if (fullness <= 540)
				user.affected_message(M,
					SPAN_HELPFUL("You <b>start feeding</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
					SPAN_HELPFUL("[user] <b>starts feeding</b> you <b>[src]</b>."),
					SPAN_NOTICE("[user] starts feeding [user == M ? "themselves" : "[M]"] [src]."))

			if(!do_after(user, 30, INTERRUPT_ALL, BUSY_ICON_FRIENDLY, M)) return

			var/rgt_list_text = get_reagent_list_text()

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [rgt_list_text]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [rgt_list_text]</font>")
			msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] (REAGENTS: [rgt_list_text]) (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

			user.affected_message(M,
				SPAN_HELPFUL("You <b>fed</b> [user == M ? "yourself" : "[M]"] <b>[src]</b>."),
				SPAN_HELPFUL("[user] <b>fed</b> you <b>[src]</b>."),
				SPAN_NOTICE("[user] fed [user == M ? "themselves" : "[M]"] [src]."))

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', 15, 1)
			if(reagents.total_volume)
				reagents.set_source_mob(user)
				if(reagents.total_volume > bitesize)
					/*
					 * I totally cannot understand what this code supposed to do.
					 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
					var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
					reagents.trans_to(M, temp_bitesize)
					*/
					reagents.trans_to_ingest(M, bitesize)
				else
					reagents.trans_to_ingest(M, reagents.total_volume)
				bitecount++
				On_Consume(M)
			return 1

	return 0

/obj/item/reagent_container/food/snacks/afterattack(obj/target, mob/user, proximity)
	return ..()

/obj/item/reagent_container/food/snacks/get_examine_text(mob/user)
	. = ..()
	if (!(user in range(0)) && user != loc)
		return
	if (!bitecount)
		return
	else if (bitecount==1)
		. += SPAN_NOTICE("\The [src] was bitten by someone!")
	else if (bitecount<=3)
		. += SPAN_NOTICE("\The [src] was bitten [bitecount] times!")
	else
		. += SPAN_NOTICE("\The [src] was bitten multiple times!")

/obj/item/reagent_container/food/snacks/set_name_label(var/new_label)
	name_label = new_label
	name = made_from_player + initial(name)
	if(name_label)
		name += " ([name_label])"

/obj/item/reagent_container/food/snacks/set_origin_name_prefix(var/name_prefix)
	made_from_player = name_prefix

/obj/item/reagent_container/food/snacks/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()
	if(istype(W,/obj/item/storage))
		..() // -> item/attackby()

	if(istype(W,/obj/item/tool/kitchen/utensil))

		var/obj/item/tool/kitchen/utensil/U = W

		if(!U.reagents)
			U.create_reagents(5)

		if (U.reagents.total_volume > 0)
			to_chat(user, SPAN_DANGER("You already have something on your [U]."))
			return

		user.visible_message( \
			"[user] scoops up some [src] with \the [U]!", \
			SPAN_NOTICE("You scoop up some [src] with \the [U]!") \
		)

		src.bitecount++
		U.overlays.Cut()
		U.loaded = "[src]"
		var/image/I = new(U.icon, "loadedfood")
		I.color = src.filling_color
		U.overlays += I

		reagents.trans_to(U,min(reagents.total_volume,5))

		if (reagents.total_volume <= 0)
			qdel(src)
		return

	if((slices_num <= 0 || !slices_num) || !slice_path)
		return 0

	var/inaccurate = 0
	if(W.sharp == IS_SHARP_ITEM_ACCURATE)
	else if(W.sharp == IS_SHARP_ITEM_BIG)
		inaccurate = 1
	else
		return 1
	if ( 	!istype(loc, /obj/structure/surface/table) && \
			(!isturf(src.loc) || \
			!(locate(/obj/structure/surface/table) in src.loc) && \
			!(locate(/obj/structure/machinery/optable) in src.loc) && \
			!(locate(/obj/item/tool/kitchen/tray) in src.loc)) \
		)
		to_chat(user, SPAN_DANGER("You cannot slice [src] here! You need a table or at least a tray to do it."))
		return 1
	var/slices_lost = 0
	if (!inaccurate)
		user.visible_message( \
			SPAN_NOTICE("[user] slices \the [src]!"), \
			SPAN_NOTICE("You slice \the [src]!") \
		)
	else
		user.visible_message( \
			SPAN_NOTICE("[user] crudely slices \the [src] with [W]!"), \
			SPAN_NOTICE("You crudely slice \the [src] with your [W]!") \
		)
		slices_lost = rand(1,min(1,round(slices_num/2)))
	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i=1 to (slices_num-slices_lost))
		var/obj/slice = new slice_path (src.loc)
		reagents.trans_to(slice,reagents_per_slice)
	qdel(src)

	return

/obj/item/reagent_container/food/snacks/attack_animal(var/mob/M)
	if(isanimal(M))
		if(iscorgi(M))
			if(bitecount == 0 || prob(50))
				M.emote("nibbles away at the [src]")
			bitecount++
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where the [src] was")
				if(sattisfaction_text)
					M.emote("[sattisfaction_text]")
				qdel(src)
		if(ismouse(M))
			var/mob/living/simple_animal/mouse/N = M
			to_chat(N, text(SPAN_NOTICE("You nibble away at [src].")))
			if(prob(50))
				N.visible_message("[N] nibbles away at [src].", "")
			//N.emote("nibbles away at the [src]")
			N.health = min(N.health + 1, N.maxHealth)


////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////











//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/reagent_container/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	/Initialize()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.




/obj/item/reagent_container/food/snacks/aesirsalad
	name = "Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"

/obj/item/reagent_container/food/snacks/aesirsalad/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 8)
	reagents.add_reagent("doctorsdelight", 8)
	reagents.add_reagent("tricordrazine", 8)
	bitesize = 3

/obj/item/reagent_container/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/candy/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 1)
	reagents.add_reagent("sugar", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/candy/donor
	name = "Donor Candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy

/obj/item/reagent_container/food/snacks/candy/donor/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	reagents.add_reagent("sugar", 3)
	bitesize = 5

/obj/item/reagent_container/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"

/obj/item/reagent_container/food/snacks/candy_corn/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"

/obj/item/reagent_container/food/snacks/chips/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/wy_chips/pepper
	name = "Weyland-Yutani Pepper Chips"
	desc = "Premium high-quality chips, now with 0% trans fat and added black pepper."
	icon_state = "wy_chips_pepper"
	item_state = "wy_chips_pepper"
	trash = /obj/item/trash/wy_chips_pepper
	filling_color = "#E8C31E"

/obj/item/reagent_container/food/snacks/wy_chips/pepper/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 1
/obj/item/reagent_container/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"

/obj/item/reagent_container/food/snacks/cookie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sugar", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/chocolatebar
	name = "Chocolate Bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"

/obj/item/reagent_container/food/snacks/chocolatebar/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"

/obj/item/reagent_container/food/snacks/chocolateegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 3)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("coco", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/donut
	name = "donut"
	desc = "A donut pastry, which is a common snack on Earth. Goes great with coffee."
	icon_state = "donut1"
	filling_color = "#D9C386"
	var/overlay_state = "donut"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/donut/normal
	name = "donut"
	desc = "A donut. Rare on the frontier, so take care of it."
	icon_state = "donut1"

/obj/item/reagent_container/food/snacks/donut/normal/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	src.bitesize = 3
	if(prob(40))
		icon_state = "donut2"
		overlay_state = "fdonut"
		name = "frosted donut"
		desc = "A pink frosted donut. Even more rare on the frontier."
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/donut/chaos
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ED11E6"

/obj/item/reagent_container/food/snacks/donut/chaos/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sprinkles", 1)
	bitesize = 10
	var/chaosselect = pick(1,2,3,4,5,6,7,8,9)
	switch(chaosselect)
		if(1)
			reagents.add_reagent("nutriment", 3)
		if(2)
			reagents.add_reagent("hotsauce", 3)
		if(3)
			reagents.add_reagent("frostoil", 3)
		if(4)
			reagents.add_reagent("sprinkles", 3)
		if(5)
			reagents.add_reagent("phoron", 3)
		if(6)
			reagents.add_reagent("coco", 3)
		if(7)
			reagents.add_reagent("banana", 3)
		if(8)
			reagents.add_reagent("berryjuice", 3)
		if(9)
			reagents.add_reagent("tricordrazine", 3)
	if(prob(30))
		src.icon_state = "donut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Chaos Donut"
		reagents.add_reagent("sprinkles", 2)


/obj/item/reagent_container/food/snacks/donut/jelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/donut/jelly/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("berryjuice", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/donut/cherryjelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/donut/cherryjelly/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("sprinkles", 1)
	reagents.add_reagent("cherryjelly", 5)
	bitesize = 5
	if(prob(30))
		src.icon_state = "jdonut2"
		src.overlay_state = "box-donut2"
		src.name = "Frosted Jelly Donut"
		reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	var/egg_color

/obj/item/reagent_container/food/snacks/egg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/egg/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(loc)
	if(reagents)
		reagents.reaction(hit_atom, TOUCH)
	visible_message(SPAN_WARNING("[name] has been squashed."),SPAN_WARNING("You hear a smack."))
	qdel(src)

/obj/item/reagent_container/food/snacks/egg/attackby(obj/item/W as obj, mob/user as mob)
	if(istype( W, /obj/item/toy/crayon ))
		var/obj/item/toy/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, SPAN_NOTICE(" The egg refuses to take on this color!"))
			return

		to_chat(usr, SPAN_NOTICE(" You color \the [src] [clr]"))
		icon_state = "egg-[clr]"
		egg_color = clr
	else
		..()

/obj/item/reagent_container/food/snacks/egg/blue
	icon_state = "egg-blue"
	egg_color = "blue"

/obj/item/reagent_container/food/snacks/egg/green
	icon_state = "egg-green"
	egg_color = "green"

/obj/item/reagent_container/food/snacks/egg/mime
	icon_state = "egg-mime"
	egg_color = "mime"

/obj/item/reagent_container/food/snacks/egg/orange
	icon_state = "egg-orange"
	egg_color = "orange"

/obj/item/reagent_container/food/snacks/egg/purple
	icon_state = "egg-purple"
	egg_color = "purple"

/obj/item/reagent_container/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"
	egg_color = "rainbow"

/obj/item/reagent_container/food/snacks/egg/red
	icon_state = "egg-red"
	egg_color = "red"

/obj/item/reagent_container/food/snacks/egg/yellow
	icon_state = "egg-yellow"
	egg_color = "yellow"

/obj/item/reagent_container/food/snacks/friedegg
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"

/obj/item/reagent_container/food/snacks/friedegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/boiledegg
	name = "Boiled egg"
	desc = "A hard-boiled egg."
	icon_state = "egg"
	filling_color = "#FFFFFF"

/obj/item/reagent_container/food/snacks/boiledegg/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)

/obj/item/reagent_container/food/snacks/flour
	name = "flour"
	desc = "A small bag filled with some flour."
	icon_state = "flour"

/obj/item/reagent_container/food/snacks/flour/Initialize()
	. = ..()
	reagents.add_reagent("dough", 1)

/obj/item/reagent_container/food/snacks/organ

	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/items/organs.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"

/obj/item/reagent_container/food/snacks/organ/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", rand(3,5))
	reagents.add_reagent("toxin", rand(1,3))
	src.bitesize = 3

/obj/item/reagent_container/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofu/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 3)
	src.bitesize = 3

/obj/item/reagent_container/food/snacks/tofurkey
	name = "Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofurkey/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 12)
	reagents.add_reagent("stoxin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/stuffing
	name = "Stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"

/obj/item/reagent_container/food/snacks/stuffing/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("blackpepper",1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"

/obj/item/reagent_container/food/snacks/carpmeat/Initialize()
	. = ..()
	reagents.add_reagent("fish", 3)
	reagents.add_reagent("carpotoxin", 3)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"

/obj/item/reagent_container/food/snacks/fishfingers/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	reagents.add_reagent("carpotoxin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"

/obj/item/reagent_container/food/snacks/hugemushroomslice/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("psilocybin", 3)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/tomatomeat/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 3)
	src.bitesize = 6

/obj/item/reagent_container/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/bearmeat/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 12)
	src.bitesize = 3

/obj/item/reagent_container/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/meatball/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"

/obj/item/reagent_container/food/snacks/sausage/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"
	var/warm = 0

/obj/item/reagent_container/food/snacks/donkpocket/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("bread", 2)

/obj/item/reagent_container/food/snacks/donkpocket/proc/cooltime() //Not working, derp?
	if(warm)
		spawn(4200)
			if(!QDELETED(src)) //not qdel'd
				warm = 0
				reagents.del_reagent("tricordrazine")
				name = "donk-pocket"

/obj/item/reagent_container/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#F2B6EA"

/obj/item/reagent_container/food/snacks/brainburger/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("alkysine", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/ghostburger
	name = "Ghost Burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"

/obj/item/reagent_container/food/snacks/ghostburger/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 2


/obj/item/reagent_container/food/snacks/human
	filling_color = "#D63C3C"

/obj/item/reagent_container/food/snacks/human/burger
	name = "burger"
	desc = "A bloody burger."
	icon_state = "hamburger"

/obj/item/reagent_container/food/snacks/human/burger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "hamburger"

/obj/item/reagent_container/food/snacks/cheeseburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("cheese", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"

/obj/item/reagent_container/food/snacks/monkeyburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#FFDEFE"

/obj/item/reagent_container/food/snacks/fishburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("fish", 3)
	reagents.add_reagent("carpotoxin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofuburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("tofu", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"

/obj/item/reagent_container/food/snacks/roburger/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("iron", 3)
	bitesize = 2

/// Vanilla roburger - the nanites turn people into cyborgs
/obj/item/reagent_container/food/snacks/roburger/unsafe
/obj/item/reagent_container/food/snacks/roburger/unsafe/Initialize(mapload, ...)
	. = ..()
	if(prob(5))
		reagents.add_reagent("nanites", 2)

/obj/item/reagent_container/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100

/obj/item/reagent_container/food/snacks/roburgerbig/Initialize()
	. = ..()
	reagents.add_reagent("nanites", 100)
	bitesize = 0.1

/obj/item/reagent_container/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/xenoburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 3)
	reagents.add_reagent("xenoblood", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#FF00FF"

/obj/item/reagent_container/food/snacks/clownburger/Initialize()
	. = ..()
/*
	var/datum/disease/F = new /datum/disease/pierrot_throat(0)
	var/list/data = list("viruses"= list(F))
	reagents.add_reagent("blood", 4, data)
*/
	reagents.add_reagent("bread", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#FFFFFF"

/obj/item/reagent_container/food/snacks/mimeburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"

	//var/herp = 0
/obj/item/reagent_container/food/snacks/omelette/Initialize()
	. = ..()
	reagents.add_reagent("egg", 4)
	reagents.add_reagent("cheese", 4)
	bitesize = 1

/obj/item/reagent_container/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	filling_color = "#E0CF9B"

/obj/item/reagent_container/food/snacks/muffin/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sugar", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"

/obj/item/reagent_container/food/snacks/pie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("banana",5)
	bitesize = 3

/obj/item/reagent_container/food/snacks/pie/launch_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message(SPAN_DANGER("[src.name] splats."),SPAN_DANGER("You hear a splat."))
	qdel(src)

/obj/item/reagent_container/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate

/obj/item/reagent_container/food/snacks/berryclafoutis/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("berryjuice", 5)
	bitesize = 3

/obj/item/reagent_container/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#E6DEB5"

/obj/item/reagent_container/food/snacks/waffles/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("sugar", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"

/obj/item/reagent_container/food/snacks/eggplantparm/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("cheese", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#B8E6B5"

/obj/item/reagent_container/food/snacks/soylentgreen/Initialize()
	. = ..()
	reagents.add_reagent("bread", 7)
	reagents.add_reagent("meatprotein", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/soylentviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#E6FA61"

/obj/item/reagent_container/food/snacks/soylentviridians/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	bitesize = 2


/obj/item/reagent_container/food/snacks/meatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"

/obj/item/reagent_container/food/snacks/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofupie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("tofu", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"

/obj/item/reagent_container/food/snacks/amanita_pie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("amatoxin", 3)
	reagents.add_reagent("psilocybin", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#B8279B"

/obj/item/reagent_container/food/snacks/plump_pie/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent("bread", 4)
		reagents.add_reagent("mushroom", 4)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 2
	else
		reagents.add_reagent("mushroom", 4)
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/reagent_container/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/xemeatpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("xenoblood", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/wingfangchu/Initialize()
	. = ..()
	reagents.add_reagent("soysauce", 4)
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("xenoblood", 4)
	bitesize = 2


/obj/item/reagent_container/food/snacks/human/kabob
	name = "kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

/obj/item/reagent_container/food/snacks/human/kabob/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

/obj/item/reagent_container/food/snacks/monkeykabob/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"

/obj/item/reagent_container/food/snacks/tofukabob/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"

/obj/item/reagent_container/food/snacks/cubancarp/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	reagents.add_reagent("carpotoxin", 3)
	reagents.add_reagent("hotsauce", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/popcorn
	name = "Popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"

/obj/item/reagent_container/food/snacks/popcorn/Initialize()
	. = ..()
	unpopped = rand(1,10)
	reagents.add_reagent("plantmatter", 2)
	bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0

/obj/item/reagent_container/food/snacks/popcorn/On_Consume()
	if(prob(unpopped))	//lol ...what's the point?
		to_chat(usr, SPAN_DANGER("You bite down on an un-popped kernel!"))
		unpopped = max(0, unpopped-1)
	..()


/obj/item/reagent_container/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"

/obj/item/reagent_container/food/snacks/sosjerky/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"

/obj/item/reagent_container/food/snacks/no_raisin/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 4)
	reagents.add_reagent("grapejuice", 2)

/obj/item/reagent_container/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer than you will."
	filling_color = "#FFE591"

/obj/item/reagent_container/food/snacks/spacetwinkie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth."
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"

/obj/item/reagent_container/food/snacks/cheesiehonkers/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#FF5D05"

	trash = /obj/item/trash/syndi_cakes

/obj/item/reagent_container/food/snacks/syndicake/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("doctorsdelight", 5)
	bitesize = 3

/obj/item/reagent_container/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"

/obj/item/reagent_container/food/snacks/loadedbakedpotato/Initialize()
	. = ..()
	reagents.add_reagent("potato", 2)
	reagents.add_reagent("cheese", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

/obj/item/reagent_container/food/snacks/fries/Initialize()
	. = ..()
	reagents.add_reagent("potato", 2)
	reagents.add_reagent("vegetable", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"

/obj/item/reagent_container/food/snacks/soydope/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/spagetti
	name = "Spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#EDDD00"

/obj/item/reagent_container/food/snacks/spagetti/Initialize()
	. = ..()
	reagents.add_reagent("dough", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

/obj/item/reagent_container/food/snacks/cheesyfries/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("potato", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/badrecipe
	name = "Burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211F02"

/obj/item/reagent_container/food/snacks/badrecipe/Initialize()
	. = ..()
	reagents.add_reagent("toxin", 1)
	reagents.add_reagent("carbon", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"

/obj/item/reagent_container/food/snacks/meatsteak/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("blackpepper", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"

/obj/item/reagent_container/food/snacks/spacylibertyduff/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 6)
	reagents.add_reagent("psilocybin", 6)
	bitesize = 3

/obj/item/reagent_container/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic"
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"

/obj/item/reagent_container/food/snacks/amanitajelly/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 6)
	reagents.add_reagent("amatoxin", 6)
	reagents.add_reagent("psilocybin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/poppypretzel
	name = "Poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"

/obj/item/reagent_container/food/snacks/poppypretzel/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("bread", 4)
	bitesize = 2


/obj/item/reagent_container/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"

/obj/item/reagent_container/food/snacks/meatballsoup/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 8)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/bloodsoup
	name = "Tomato soup"
	desc = "Smells like copper"
	icon_state = "tomatosoup"
	filling_color = "#FF0000"

/obj/item/reagent_container/food/snacks/bloodsoup/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	reagents.add_reagent("blood", 10)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#C4FBFF"

/obj/item/reagent_container/food/snacks/clownstears/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("water", 10)
	bitesize = 5

/obj/item/reagent_container/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "A true vegan meal" //TODO
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

/obj/item/reagent_container/food/snacks/vegetablesoup/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 8)
	reagents.add_reagent("water", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

/obj/item/reagent_container/food/snacks/nettlesoup/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 8)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("tricordrazine", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/mysterysoup
	name = "Mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F082FF"

/obj/item/reagent_container/food/snacks/mysterysoup/Initialize()
	. = ..()
	var/mysteryselect = pick(1,2,3,4,5,6,7,8,9)
	switch(mysteryselect)
		if(1)
			reagents.add_reagent("plantmatter", 6)
			reagents.add_reagent("hotsauce", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(2)
			reagents.add_reagent("plantmatter", 6)
			reagents.add_reagent("frostoil", 3)
			reagents.add_reagent("tomatojuice", 2)
		if(3)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 5)
			reagents.add_reagent("tricordrazine", 5)
		if(4)
			reagents.add_reagent("nutriment", 5)
			reagents.add_reagent("water", 10)
		if(5)
			reagents.add_reagent("fruit", 2)
			reagents.add_reagent("banana", 10)
		if(6)
			reagents.add_reagent("meatprotein", 6)
			reagents.add_reagent("blood", 10)
		if(7)
			reagents.add_reagent("carbon", 10)
			reagents.add_reagent("toxin", 10)
		if(8)
			reagents.add_reagent("vegetable", 5)
			reagents.add_reagent("tomatojuice", 10)
		if(9)
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("tomatojuice", 5)
			reagents.add_reagent("imidazoline", 5)
	bitesize = 5

/obj/item/reagent_container/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"

/obj/item/reagent_container/food/snacks/wishsoup/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)
	bitesize = 5
	if(prob(25))
		src.desc = "A wish come true!"
		reagents.add_reagent("nutriment", 8)

/obj/item/reagent_container/food/snacks/hotchili
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"

/obj/item/reagent_container/food/snacks/hotchili/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("hotsauce", 3)
	reagents.add_reagent("tomatojuice", 2)
	bitesize = 5


/obj/item/reagent_container/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"

	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_container/food/snacks/coldchili/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("frostoil", 3)
	reagents.add_reagent("tomatojuice", 2)
	bitesize = 5

/* No more of this
/obj/item/reagent_container/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/device/radio/beacon/bacon/baconbeacon
	bitesize = 2
	/Initialize()
		..()
		reagents.add_reagent("nutriment", 4)
		baconbeacon = new /obj/item/device/radio/beacon/bacon(src)
	On_Consume()
		if(!reagents.total_volume)
			baconbeacon.forceMove(usr)
			baconbeacon.digest_delay()
*/

/obj/item/reagent_container/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"
	var/monkey_type = /mob/living/carbon/human/monkey

/obj/item/reagent_container/food/snacks/monkeycube/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein",10)

/obj/item/reagent_container/food/snacks/monkeycube/afterattack(obj/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O,/obj/structure/sink) && !package)
		to_chat(user, "You place \the [name] under a stream of water...")
		user.drop_held_item()
		return Expand()
	..()

/obj/item/reagent_container/food/snacks/monkeycube/attack_self(mob/user)
	..()

	if(package)
		icon_state = "monkeycube"
		desc = "Just add water!"
		to_chat(user, "You unwrap the cube.")
		package = 0

/obj/item/reagent_container/food/snacks/monkeycube/On_Consume(var/mob/M)
	to_chat(M, SPAN_WARNING("Something inside of you suddently expands!"))

	if (istype(M, /mob/living/carbon/human))
		//Do not try to understand.
		var/obj/item/surprise = new(M)
		var/mob/ook = monkey_type
		surprise.icon = initial(ook.icon)
		surprise.icon_state = initial(ook.icon_state)
		surprise.name = "malformed [initial(ook.name)]"
		surprise.desc = "Looks like \a very deformed [initial(ook.name)], a little small for its kind. It shows no signs of life."
		surprise.transform *= 0.6
		surprise.add_mob_blood(M)
		var/mob/living/carbon/human/H = M
		var/obj/limb/E = H.get_limb("chest")
		E.fracture(100)
		H.recalculate_move_delay = TRUE
		for (var/datum/internal_organ/I in E.internal_organs)
			I.take_damage(rand(I.min_bruised_damage, I.min_broken_damage+1))
		if (!E.hidden && prob(60)) //set it snuggly
			E.hidden = surprise
		else 		//someone is having a bad day
			E.createwound(CUT, 30)
			E.embed(surprise)
	..()

/obj/item/reagent_container/food/snacks/monkeycube/proc/Expand()
	for(var/mob/M as anything in viewers(src,7))
		to_chat(M, SPAN_WARNING("\The [src] expands!"))
	var/turf/T = get_turf(src)
	if(T)
		new monkey_type(T)
	qdel(src)

/obj/item/reagent_container/food/snacks/monkeycube/extinguish()
	. = ..()
	if(!package)
		Expand()

/obj/item/reagent_container/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	package = 1


/obj/item/reagent_container/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = /mob/living/carbon/human/farwa
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type =/mob/living/carbon/human/farwa


/obj/item/reagent_container/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = /mob/living/carbon/human/stok
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type =/mob/living/carbon/human/stok


/obj/item/reagent_container/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = /mob/living/carbon/human/neaera
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type =/mob/living/carbon/human/neaera

/obj/item/reagent_container/food/snacks/monkeycube/yirencube
	name = "yiren cube"
	monkey_type = /mob/living/carbon/human/yiren
/obj/item/reagent_container/food/snacks/monkeycube/wrapped/yirencube
	name = "yiren cube"
	monkey_type =/mob/living/carbon/human/yiren

/obj/item/reagent_container/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#D505FF"

/obj/item/reagent_container/food/snacks/spellburger/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"

/obj/item/reagent_container/food/snacks/bigbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 7)
	reagents.add_reagent("bread", 7)
	bitesize = 3

/obj/item/reagent_container/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"

/obj/item/reagent_container/food/snacks/enchiladas/Initialize()
	. = ..()
	reagents.add_reagent("vegetable",2)
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("hotsauce", 6)
	bitesize = 4

/obj/item/reagent_container/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"

/obj/item/reagent_container/food/snacks/monkeysdelight/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("banana", 5)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	bitesize = 6

/obj/item/reagent_container/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#E3D796"

/obj/item/reagent_container/food/snacks/baguette/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("blackpepper", 1)
	reagents.add_reagent("sodiumchloride", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#E3D796"

/obj/item/reagent_container/food/snacks/fishandchips/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	reagents.add_reagent("carpotoxin", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

/obj/item/reagent_container/food/snacks/sandwich/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cheese", 2)
	reagents.add_reagent("meatprotein", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

/obj/item/reagent_container/food/snacks/toastedsandwich/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("carbon", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/grilledcheese
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

/obj/item/reagent_container/food/snacks/grilledcheese/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("cheese", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"

/obj/item/reagent_container/food/snacks/tomatosoup/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#FF00F7"

/obj/item/reagent_container/food/snacks/rofflewaffles/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("psilocybin", 8)
	bitesize = 4

/obj/item/reagent_container/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9E673A"

/obj/item/reagent_container/food/snacks/stew/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("meatprotein", 3)
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("imidazoline", 5)
	reagents.add_reagent("water", 5)
	bitesize = 10

/obj/item/reagent_container/food/snacks/jelliedtoast
	name = "Jellied Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"

/obj/item/reagent_container/food/snacks/jelliedtoast/Initialize()
	. = ..()
	reagents.add_reagent("bread", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/jelliedtoast/cherry

/obj/item/reagent_container/food/snacks/jelliedtoast/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_container/food/snacks/jellyburger
	name = "Jelly Burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#B572AB"

/obj/item/reagent_container/food/snacks/jellyburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	bitesize = 2

/obj/item/reagent_container/food/snacks/jellyburger/cherry

/obj/item/reagent_container/food/snacks/jellyburger/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_container/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl

/obj/item/reagent_container/food/snacks/milosoup/Initialize()
	. = ..()
	reagents.add_reagent("tofu", 8)
	reagents.add_reagent("water", 5)
	bitesize = 4

/obj/item/reagent_container/food/snacks/stewedsoymeat
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate

/obj/item/reagent_container/food/snacks/stewedsoymeat/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/boiledspagetti
	name = "Boiled Spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"

/obj/item/reagent_container/food/snacks/boiledspagetti/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/boiledrice
	name = "Boiled Rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

/obj/item/reagent_container/food/snacks/boiledrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 2)
	bitesize = 2

/obj/item/reagent_container/food/snacks/ricepudding
	name = "Rice Pudding"
	desc = "Where's the Jam!"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

/obj/item/reagent_container/food/snacks/ricepudding/Initialize()
	. = ..()
	reagents.add_reagent("rice", 3)
	reagents.add_reagent("milk", 1)
	bitesize = 2

/obj/item/reagent_container/food/snacks/pastatomato
	name = "Spaghetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

/obj/item/reagent_container/food/snacks/pastatomato/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 4

/obj/item/reagent_container/food/snacks/meatballspagetti
	name = "Spaghetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

/obj/item/reagent_container/food/snacks/meatballspagetti/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 4)
	reagents.add_reagent("meatprotein", 4)
	bitesize = 2

/obj/item/reagent_container/food/snacks/spesslaw
	name = "Spesslaw"
	desc = "A lawyer's favourite"
	icon_state = "spesslaw"
	filling_color = "#DE4545"

/obj/item/reagent_container/food/snacks/spesslaw/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("meatprotein", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"

/obj/item/reagent_container/food/snacks/carrotfries/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("imidazoline", 3)
	bitesize = 2

/obj/item/reagent_container/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"

/obj/item/reagent_container/food/snacks/superbiteburger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 20)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("egg", 5)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 3)
	reagents.add_reagent("cheese", 10)
	reagents.add_reagent("tomatojuice", 10)
	bitesize = 10

/obj/item/reagent_container/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#F21873"

/obj/item/reagent_container/food/snacks/candiedapple/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/applepie
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"

/obj/item/reagent_container/food/snacks/applepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)
	bitesize = 3


/obj/item/reagent_container/food/snacks/cherrypie
	name = "Cherry Pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"

/obj/item/reagent_container/food/snacks/cherrypie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("cherryjelly", 3)
	reagents.add_reagent("sugar", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#DBCC9A"

/obj/item/reagent_container/food/snacks/twobread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("wine", 3)
	bitesize = 3

/obj/item/reagent_container/food/snacks/jellysandwich
	name = "Jelly Sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"

/obj/item/reagent_container/food/snacks/jellysandwich/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	bitesize = 3

/obj/item/reagent_container/food/snacks/jellysandwich/cherry

/obj/item/reagent_container/food/snacks/jellysandwich/cherry/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 5)

/obj/item/reagent_container/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"

/obj/item/reagent_container/food/snacks/mint/Initialize()
	. = ..()
	reagents.add_reagent("minttoxin", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"

/obj/item/reagent_container/food/snacks/mushroomsoup/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 6)
	reagents.add_reagent("milk", 2)
	bitesize = 3

/obj/item/reagent_container/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"

/obj/item/reagent_container/food/snacks/plumphelmetbiscuit/Initialize()
	. = ..()
	if(prob(10))
		name = "exceptional plump helmet biscuit"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
		reagents.add_reagent("bread", 4)
		reagents.add_reagent("mushroom", 4)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 2
	else
		reagents.add_reagent("bread", 3)
		reagents.add_reagent("mushroom", 2)
		bitesize = 2

/obj/item/reagent_container/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"

/obj/item/reagent_container/food/snacks/chawanmushi/Initialize()
	. = ..()
	reagents.add_reagent("egg", 2)
	reagents.add_reagent("mushroom", 2)
	reagents.add_reagent("soysauce", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FAC9FF"

/obj/item/reagent_container/food/snacks/beetsoup/Initialize()
	. = ..()
	switch(rand(1,6))
		if(1)
			name = "borsch"
		if(2)
			name = "bortsch"
		if(3)
			name = "borstch"
		if(4)
			name = "borsh"
		if(5)
			name = "borshch"
		if(6)
			name = "borscht"
	reagents.add_reagent("vegetable", 8)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

/obj/item/reagent_container/food/snacks/tossedsalad/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 4)
	reagents.add_reagent("vegetable", 4)
	bitesize = 3

/obj/item/reagent_container/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

/obj/item/reagent_container/food/snacks/validsalad/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 4)
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("potato", 1)
	bitesize = 3

/obj/item/reagent_container/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"

/obj/item/reagent_container/food/snacks/appletart/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 8)
	reagents.add_reagent("gold", 5)
	bitesize = 3

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/reagent_container/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/reagent_container/food/snacks/meatbreadslice
	slices_num = 5
	filling_color = "#FF7575"

/obj/item/reagent_container/food/snacks/sliceable/meatbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/reagent_container/food/snacks/xenomeatbreadslice
	slices_num = 5
	filling_color = "#8AFF75"

/obj/item/reagent_container/food/snacks/sliceable/xenomeatbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("cheese", 10)
	reagents.add_reagent("xenoblood", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/reagent_container/food/snacks/bananabreadslice
	slices_num = 5
	filling_color = "#EDE5AD"

/obj/item/reagent_container/food/snacks/sliceable/bananabread/Initialize()
	. = ..()
	reagents.add_reagent("banana", 15)
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("sugar", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/reagent_container/food/snacks/tofubreadslice
	slices_num = 5
	filling_color = "#F7FFE0"

/obj/item/reagent_container/food/snacks/sliceable/tofubread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("tofu", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2


/obj/item/reagent_container/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/reagent_container/food/snacks/carrotcakeslice
	slices_num = 5
	filling_color = "#FFD675"

/obj/item/reagent_container/food/snacks/sliceable/carrotcake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("sugar", 5)
	reagents.add_reagent("imidazoline", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carroty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/braincake
	name = "Brain Cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/reagent_container/food/snacks/braincakeslice
	slices_num = 5
	filling_color = "#E6AEDB"

/obj/item/reagent_container/food/snacks/sliceable/braincake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("alkysine", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/braincakeslice
	name = "Brain Cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/reagent_container/food/snacks/cheesecakeslice
	slices_num = 5
	filling_color = "#FAF7AF"

/obj/item/reagent_container/food/snacks/sliceable/cheesecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 15)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/reagent_container/food/snacks/plaincakeslice
	slices_num = 5
	filling_color = "#F7EDD5"

/obj/item/reagent_container/food/snacks/sliceable/plaincake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("sugar", 15)

/obj/item/reagent_container/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/orangecake
	name = "Orange Cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/reagent_container/food/snacks/orangecakeslice
	slices_num = 5
	filling_color = "#FADA8E"

/obj/item/reagent_container/food/snacks/sliceable/orangecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 5)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("orangejuice", 10)

/obj/item/reagent_container/food/snacks/orangecakeslice
	name = "Orange Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/limecake
	name = "Lime Cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/reagent_container/food/snacks/limecakeslice
	slices_num = 5
	filling_color = "#CBFA8E"

/obj/item/reagent_container/food/snacks/sliceable/limecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 5)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("limejuice", 10)

/obj/item/reagent_container/food/snacks/limecakeslice
	name = "Lime Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/lemoncake
	name = "Lemon Cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/reagent_container/food/snacks/lemoncakeslice
	slices_num = 5
	filling_color = "#FAFA8E"

/obj/item/reagent_container/food/snacks/sliceable/lemoncake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 5)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("lemonjuice", 10)

/obj/item/reagent_container/food/snacks/lemoncakeslice
	name = "Lemon Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/chocolatecake
	name = "Chocolate Cake"
	desc = "A cake with added chocolate"
	icon_state = "chocolatecake"
	slice_path = /obj/item/reagent_container/food/snacks/chocolatecakeslice
	slices_num = 5
	filling_color = "#805930"

/obj/item/reagent_container/food/snacks/sliceable/chocolatecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("sugar", 5)
	reagents.add_reagent("coco", 10)

/obj/item/reagent_container/food/snacks/chocolatecakeslice
	name = "Chocolate Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delicious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#FFF700"

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 20)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/immature
	name = "immature cheese wheel"
	desc = "A big wheel of supposedly delicious Cheddar, but it hasn't been aged enough and as such tastes rather crap."
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/immature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/immature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 15)
	reagents.add_reagent("milk", 5)
	bitesize = 4

/obj/item/reagent_container/food/snacks/cheesewedge/immature
	name = "immature cheese wedge"
	desc = "A wedge of immature Cheddar, without any noticeable good taste. The cheese wheel it was cut from can't have gone far. It's so weak you can basically eat it all in one bite."
	bitesize = 4

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/mature
	name = "mature cheese wheel"
	desc = "A big wheel of delicious Cheddar, sufficiently aged."
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/mature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/mature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 20)
	reagents.add_reagent("sodiumchloride", 5)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge/mature
	name = "mature cheese wedge"
	desc = "A wedge of mature Cheddar, tastes pretty nice. The cheese wheel it was cut from can't have gone far."
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/verymature
	name = "aged cheese wheel"
	desc = "A big wheel of delicious Cheddar, it has been aged for a long time and is pretty strong."
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/verymature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/verymature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 25)
	bitesize = 2

/obj/item/reagent_container/food/snacks/cheesewedge/verymature
	name = "aged cheese wedge"
	desc = "A wedge of very mature Cheddar. This one's been aged for a while. The cheese wheel it was cut from can't have gone far."
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/extramature
	name = "primordial cheese wheel"
	desc = "A big wheel of delicious Cheddar, it has been aged for practically aeons. Merely seeing this cheese causes you to break into a cold sweat. Due to its strength, you can't eat in big bites."
	slice_path = /obj/item/reagent_container/food/snacks/cheesewedge/extramature

/obj/item/reagent_container/food/snacks/sliceable/cheesewheel/extramature/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 25)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("universal enzyme", 1)
	bitesize = 1

/obj/item/reagent_container/food/snacks/cheesewedge/extramature
	name = "primordial cheese wedge"
	desc = "A wedge of extra mature Cheddar. So strong you can barely put more than a few grammes in your mouth at a time. The cheese wheel it was cut from can't have gone far."
	bitesize = 1

/obj/item/reagent_container/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/reagent_container/food/snacks/birthdaycakeslice
	slices_num = 5
	filling_color = "#FFD6D6"

/obj/item/reagent_container/food/snacks/sliceable/birthdaycake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("sugar", 10)
	reagents.add_reagent("sprinkles", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/birthdaycakeslice
	name = "Birthday Cake slice"
	desc = "A slice of your birthday"
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/reagent_container/food/snacks/breadslice
	slices_num = 5
	filling_color = "#FFE396"

/obj/item/reagent_container/food/snacks/sliceable/bread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/breadslice
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2


/obj/item/reagent_container/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/reagent_container/food/snacks/creamcheesebreadslice
	slices_num = 5
	filling_color = "#FFF896"

/obj/item/reagent_container/food/snacks/sliceable/creamcheesebread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 10)
	bitesize = 2

/obj/item/reagent_container/food/snacks/creamcheesebreadslice
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2


/obj/item/reagent_container/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2


/obj/item/reagent_container/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with Apple"
	icon_state = "applecake"
	slice_path = /obj/item/reagent_container/food/snacks/applecakeslice
	slices_num = 5
	filling_color = "#EBF5B8"

/obj/item/reagent_container/food/snacks/sliceable/applecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("fruit", 10)
	reagents.add_reagent("sugar", 10)

/obj/item/reagent_container/food/snacks/applecakeslice
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pumpkinpie
	name = "Pumpkin Pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/reagent_container/food/snacks/pumpkinpieslice
	slices_num = 5
	filling_color = "#F5B951"

/obj/item/reagent_container/food/snacks/sliceable/pumpkinpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("sugar", 10)

/obj/item/reagent_container/food/snacks/pumpkinpieslice
	name = "Pumpkin Pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2

/obj/item/reagent_container/food/snacks/cracker
	name = "Cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#F5DEB8"

/obj/item/reagent_container/food/snacks/cracker/Initialize()
	. = ..()
	reagents.add_reagent("bread", 1)
	reagents.add_reagent("sodiumchloride", 1)



/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_container/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_container/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_container/food/snacks/margheritaslice
	slices_num = 6

/obj/item/reagent_container/food/snacks/sliceable/pizza/margherita/Initialize()
	. = ..()
	reagents.add_reagent("bread", 20)
	reagents.add_reagent("cheese", 20)
	reagents.add_reagent("tomatojuice", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_container/food/snacks/meatpizzaslice
	slices_num = 6

/obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 20)
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("tomatojuice", 6)
	bitesize = 2

/obj/item/reagent_container/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza"
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_container/food/snacks/mushroompizzaslice
	slices_num = 6

/obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("mushroom", 20)
	bitesize = 2

/obj/item/reagent_container/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_container/food/snacks/vegetablepizzaslice
	slices_num = 6

/obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 15)
	reagents.add_reagent("vegetable", 15)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("imidazoline", 12)
	bitesize = 2

/obj/item/reagent_container/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients "
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/items/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/reagent_container/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()

	overlays = list()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image("food.dmi", icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			overlays += pizzaimg

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			overlays += tagimg

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		to_chat(user, SPAN_DANGER("You take the [src.pizza] out of the [src]."))
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		to_chat(user, SPAN_DANGER("You remove the topmost [src] from your hand."))
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self(mob/user)
	..()

	if(length(boxes) > 0)
		return

	open = !open
	if(open && pizza)
		ismessy = TRUE

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_inv_item_to_loc(box, src)
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				to_chat(user, SPAN_DANGER("You put the [box] ontop of the [src]!"))
			else
				to_chat(user, SPAN_DANGER("The stack is too high!"))
		else
			to_chat(user, SPAN_DANGER("Close the [box] first!"))

		return

	if( istype(I, /obj/item/reagent_container/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if(open)
			user.drop_inv_item_to_loc(I, src)
			pizza = I

			update_icon()

			to_chat(user, SPAN_DANGER("You put the [I] in the [src]!"))
		else
			to_chat(user, SPAN_DANGER("You try to push the [I] through the lid but it doesn't work!"))
		return

	if( istype(I, /obj/item/tool/pen/) )

		if( src.open )
			return

		var/t = stripped_input(user,"Enter what you want to add to the tag:", "Write", "", 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = "[boxtotagto.boxtag][t]"

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/Initialize()
	. = ..()
	pizza = new /obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"

///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

// Flour + egg = dough
/obj/item/reagent_container/food/snacks/flour/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_container/food/snacks/egg))
		new /obj/item/reagent_container/food/snacks/dough(get_turf(src))
		to_chat(user, "You make some dough.")
		qdel(W)
		qdel(src)

// Egg + flour = dough
/obj/item/reagent_container/food/snacks/egg/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/reagent_container/food/snacks/flour))
		new /obj/item/reagent_container/food/snacks/dough(get_turf(src))
		to_chat(user, "You make some dough.")
		qdel(W)
		qdel(src)

/obj/item/reagent_container/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2

/obj/item/reagent_container/food/snacks/dough/Initialize()
	. = ..()
	reagents.add_reagent("dough", 3)

// Dough + rolling pin = flat dough
/obj/item/reagent_container/food/snacks/dough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tool/kitchen/rollingpin))
		new /obj/item/reagent_container/food/snacks/sliceable/flatdough(get_turf(src))
		to_chat(user, "You flatten the dough.")
		qdel(src)

// slicable into 3xdoughslices
/obj/item/reagent_container/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/reagent_container/food/snacks/doughslice
	slices_num = 3

/obj/item/reagent_container/food/snacks/sliceable/flatdough/Initialize()
	. = ..()
	reagents.add_reagent("dough", 3)

/obj/item/reagent_container/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "doughslice"
	bitesize = 2

/obj/item/reagent_container/food/snacks/doughslice/Initialize()
	. = ..()
	reagents.add_reagent("dough", 1)

/obj/item/reagent_container/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2

/obj/item/reagent_container/food/snacks/bun/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)

/obj/item/reagent_container/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/reagent_container/food/snacks/meatball))
		new /obj/item/reagent_container/food/snacks/monkeyburger(get_turf(src))
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/reagent_container/food/snacks/cutlet))
		new /obj/item/reagent_container/food/snacks/monkeyburger(get_turf(src))
		to_chat(user, "You make a burger.")
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/reagent_container/food/snacks/sausage))
		new /obj/item/reagent_container/food/snacks/hotdog(get_turf(src))
		to_chat(user, "You make a hotdog.")
		qdel(W)
		qdel(src)

// Burger + cheese wedge = cheeseburger
/obj/item/reagent_container/food/snacks/monkeyburger/attackby(obj/item/reagent_container/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/reagent_container/food/snacks/cheesewedge))
		new /obj/item/reagent_container/food/snacks/cheeseburger(get_turf(src))
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/reagent_container/food/snacks/human/burger/attackby(obj/item/reagent_container/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/reagent_container/food/snacks/cheeseburger(get_turf(src))
		to_chat(user, "You make a cheeseburger.")
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/reagent_container/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3

/obj/item/reagent_container/food/snacks/taco/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 7)

/obj/item/reagent_container/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1

/obj/item/reagent_container/food/snacks/rawcutlet/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 1)

/obj/item/reagent_container/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2

/obj/item/reagent_container/food/snacks/cutlet/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 2)

/obj/item/reagent_container/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2

/obj/item/reagent_container/food/snacks/rawmeatball/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 2)

/obj/item/reagent_container/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "open-hotdog"
	bitesize = 2

/obj/item/reagent_container/food/snacks/hotdog/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)
	reagents.add_reagent("meatprotein", 3)

/obj/item/reagent_container/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2

/obj/item/reagent_container/food/snacks/flatbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 3)

// potato + knife = raw sticks
/obj/item/reagent_container/food/snacks/grown/potato/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tool/kitchen/utensil/knife))
		new /obj/item/reagent_container/food/snacks/rawsticks(get_turf(src))
		to_chat(user, "You cut the potato.")
		qdel(src)
	else
		..()

/obj/item/reagent_container/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/items/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2

/obj/item/reagent_container/food/snacks/rawsticks/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("potato", 3)

/obj/item/reagent_container/food/snacks/packaged_burrito
	name = "Packaged Burrito"
	desc = "A hard microwavable burrito. There's no time given for how long to cook it. Packaged by the Weyland-Yutani Corporation."
	icon_state = "packaged-burrito"
	bitesize = 2
	package = 1

/obj/item/reagent_container/food/snacks/packaged_burrito/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("meatprotein", 5)

/obj/item/reagent_container/food/snacks/packaged_burrito/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("You pull off the wrapping from the squishy burrito!"))
		package = 0
		icon_state = "open-burrito"

/obj/item/reagent_container/food/snacks/packaged_burger
	name = "Packaged Cheeseburger"
	desc = "A soggy microwavable burger. There's no time given for how long to cook it. Packaged by the Weyland-Yutani Corporation."
	icon_state = "burger"
	bitesize = 3
	package = 1

/obj/item/reagent_container/food/snacks/packaged_burger/Initialize()
	. = ..()
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("sodiumchloride", 2)


/obj/item/reagent_container/food/snacks/packaged_burger/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("You pull off the wrapping from the squishy hamburger!"))
		package = 0
		icon_state = "hburger"
		item_state = "burger"

/obj/item/reagent_container/food/snacks/packaged_hdogs
	name = "Packaged Hotdog"
	desc = "A singular squishy, room temperature, hot dog. There's no time given for how long to cook it, so you assume its probably good to go. Packaged by the Weyland-Yutani Corporation."
	icon_state = "packaged-hotdog"
	bitesize = 2
	package = 1

/obj/item/reagent_container/food/snacks/packaged_hdogs/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("meatprotein", 1)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/packaged_hdogs/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, 1)
		to_chat(user, SPAN_NOTICE("You pull off the wrapping from the squishy hotdog!"))
		package = 0
		icon_state = "open-hotdog"

/obj/item/reagent_container/food/snacks/upp
	name = "\improper UPP ration"
	desc = "A sealed, freeze-dried, compressed package containing a single item of food. Commonplace in the UPP military, especially those units stationed on far-flung colonies. This one is stamped for consumption by the UPP's 'Smoldering Sons' battalion and was packaged in 2179."
	icon_state = "upp_ration"
	bitesize = 4

/obj/item/reagent_container/food/snacks/upp/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)

/obj/item/reagent_container/food/snacks/upp/attack_self(mob/user)
	..()

	if(package)
		playsound(src.loc,'sound/effects/pageturn2.ogg', 15, TRUE)
		to_chat(user, SPAN_NOTICE("You tear off the ration seal and pull out the contents!"))
		package = FALSE
		var/variation = rand(1,2)
		desc = "An extremely dried item of food, with little flavoring or coloration. Looks to be prepped for long term storage, but will expire without the packaging. Best to eat it now to avoid waste. At least things are equal."
		switch(variation)
			if(1)
				name = "rationed fish"
				icon_state = "upp_1"
			if(2)
				name = "rationed rice"
				icon_state = "upp_2"


/obj/item/reagent_container/food/snacks/eat_bar
	name = "MEAT Bar"
	desc = "It is a vacuum sealed tube of suspicious meat. Artificially packed full of nutrients you can't pronounce. The M is printed on the side, so it just reads EAT. Guess that's where the slogan comes from."
	icon_state = "eat_bar"
	bitesize = 2
	w_class = SIZE_TINY
	trash = /obj/item/trash/eat

/obj/item/reagent_container/food/snacks/eat_bar/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("meatprotein", 4)


/obj/item/reagent_container/food/snacks/kepler_crisps
	name = "Kepler Crisps"
	desc = "'They're disturbingly good!' Now with 0% trans fat and added genuine sea salts."
	icon_state = "kepler"
	bitesize = 2
	trash = /obj/item/trash/kepler

/obj/item/reagent_container/food/snacks/kepler_crisps/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 12)

//Wrapped candy bars

/obj/item/reagent_container/food/snacks/wrapped
	package = 1
	bitesize = 3
	var/obj/item/trash/wrapper = null //Why this and not trash? Because it pulls the wrapper off when you unwrap it as a trash item.

/obj/item/reagent_container/food/snacks/wrapped/attack_self(mob/user)
	..()

	if(package)
		to_chat(user, SPAN_NOTICE("You pull open the package of [src]!"))
		playsound(loc,'sound/effects/pageturn2.ogg', 15, 1)

		new wrapper (user.loc)
		icon_state = "[initial(icon_state)]-o"
		package = 0

//CM SNACKS
/obj/item/reagent_container/food/snacks/wrapped/booniebars
	name = "Boonie Bars"
	desc = "Two delicious bars of minty chocolate. <i>\"Sometimes things are just... out of reach.\"</i>"
	icon_state = "boonie"
	bitesize = 1 //Two bars
	wrapper = /obj/item/trash/boonie

/obj/item/reagent_container/food/snacks/wrapped/booniebars/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 6)
	reagents.add_reagent("coco", 4)

/obj/item/reagent_container/food/snacks/wrapped/chunk
	name = "CHUNK box"
	desc = "A bar of \"The <b>CHUNK</b>\" brand chocolate. <i>\"The densest chocolate permitted to exist according to federal law. We are legally required to ask you not to use this blunt object for anything other than nutrition.\"</i>"
	icon_state = "chunk"
	force = 15 //LEGAL LIMIT OF CHOCOLATE
	throwforce = 10
	bitesize = 2
	wrapper = /obj/item/trash/chunk

/obj/item/reagent_container/food/snacks/wrapped/chunk/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 7)
	reagents.add_reagent("coco", 10)

/obj/item/reagent_container/food/snacks/wrapped/barcardine
	name = "Barcardine Bars"
	desc = "A bar of chocolate, it smells like the medical bay. <i>\"Chocolate always helps the pain go away.\"</i>"
	icon_state = "barcardine"
	wrapper = /obj/item/trash/barcardine

/obj/item/reagent_container/food/snacks/wrapped/barcardine/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("tramadol", 1) //May be powergamed but it's a single unit.
//MREs

/obj/item/reagent_container/food/snacks/packaged_meal
	name = "\improper MRE component"
	desc = "A package from a Meal Ready-to-Eat, property of the US Colonial Marines. Contains a part of a meal, prepared for field consumption."
	package = 1
	bitesize = 5
	icon_state = "entree"
	var/flavor = "boneless pork ribs"//default value

/obj/item/reagent_container/food/snacks/packaged_meal/Initialize(mapload, newflavor)
	. = ..()
	determinetype(newflavor)

/obj/item/reagent_container/food/snacks/packaged_meal/attack_self(mob/user as mob)
	if(package)
		to_chat(user, SPAN_NOTICE("You pull open the package of the meal!"))
		playsound(loc,"rip", 15, 1)

		name = "\improper" + flavor
		desc = "The contents of a USCM Standard issue MRE. This one is [flavor]."
		icon_state = flavor
		package = 0
		return
	..()
/obj/item/reagent_container/food/snacks/packaged_meal/proc/determinetype(newflavor)
	name = "\improper MRE component ([newflavor])"
	flavor = newflavor

	switch(newflavor)
		if("boneless pork ribs", "grilled chicken", "pizza square", "spaghetti chunks", "chicken tender")
			icon_state = "entree"
			desc = "An MRE entree component. Contains the main course for nutrients. This one is [flavor]."
			reagents.add_reagent("nutriment", 14)
			reagents.add_reagent("sodiumchloride", 6)
		if("cracker", "cheese spread", "rice onigiri", "mashed potatoes", "risotto")
			icon_state = "side"
			desc = "An MRE side component. Contains a side, to be eaten alongside the main. This one is [flavor]."
			reagents.add_reagent("nutriment", 6)
			reagents.add_reagent("sodiumchloride", 2)
		if("biscuit", "meatballs", "pretzels", "peanuts", "sushi")
			icon_state = "snack"
			desc = "An MRE snack component. Contains a light snack in case you weren't feeling terribly hungry. This one is [flavor]."
			reagents.add_reagent("nutriment", 4)
			reagents.add_reagent("sodiumchloride", 2)
		if("spiced apples", "chocolate brownie", "sugar cookie", "coco bar", "flan", "honey flan")
			icon_state = "dessert"
			desc = "An MRE side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious). This one is [flavor]."
			reagents.add_reagent("nutriment", 2)
			reagents.add_reagent("sugar", 2)
			reagents.add_reagent("coco", 1)
