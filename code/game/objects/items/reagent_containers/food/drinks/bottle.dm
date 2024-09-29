
///////////////////////////////////////////////Alchohol bottles and juice mixers! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

//Booze bottles have two unqiue functions: They be used to smack someone in the head and turned into a molotov.

/obj/item/reagent_container/food/drinks/bottle
	amount_per_transfer_from_this = 5
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	///This excludes all the juices and dairy in cartons that are also defined in this file.
	var/isGlass = TRUE
	black_market_value = 25

/obj/item/reagent_container/food/drinks/bottle/bullet_act(obj/projectile/P)
	. = ..()
	if(isGlass)
		smash()

///Audio/visual bottle breaking effects start here
/obj/item/reagent_container/food/drinks/bottle/proc/smash(mob/living/target, mob/living/user)
	var/obj/item/weapon/broken_bottle/B
	if(user)
		user.temp_drop_inv_item(src)
		B = new /obj/item/weapon/broken_bottle(user.loc)
		user.put_in_active_hand(B)
	else
		B = new /obj/item/weapon/broken_bottle(src.loc)
	if(prob(33))
		if(target)
			new/obj/item/shard(target.loc) // Create a glass shard at the target's location!
		else
			new/obj/item/shard(src.loc)

	B.icon_state = icon_state

	var/icon/I = new('icons/obj/items/drinks.dmi', icon_state)
	I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
	I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
	B.icon = I

	playsound(src, "windowshatter", 15, 1)
	transfer_fingerprints_to(B)

	qdel(src)

/obj/item/reagent_container/food/drinks/bottle/attack(mob/living/target as mob, mob/living/user as mob)
	if(!target)
		return

	if(user.a_intent != INTENT_HARM || !isGlass)
		return ..()

	force = 15

	var/obj/limb/affecting = user.zone_selected
	var/drowsy_threshold = 0

	drowsy_threshold = CLOTHING_ARMOR_MEDIUM - target.getarmor(affecting, ARMOR_MELEE)

	target.apply_damage(force, BRUTE, affecting, sharp=0)

	if(affecting == "head" && iscarbon(target) && !isxeno(target))
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(text(SPAN_DANGER("<B>[target] has been hit over the head with a bottle of [name], by [user]!</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[target] hit \himself with a bottle of [name] on the head!</B>")), SHOW_MESSAGE_VISIBLE)
		if(drowsy_threshold > 0)
			target.apply_effect(min(drowsy_threshold, 10) , DROWSY)

	else //Regular attack text
		for(var/mob/O in viewers(user, null))
			if(target != user)
				O.show_message(text(SPAN_DANGER("<B>[target] has been attacked with a bottle of [name], by [user]!</B>")), SHOW_MESSAGE_VISIBLE)
			else
				O.show_message(text(SPAN_DANGER("<B>[target] has attacked \himself with a bottle of [name]!</B>")), SHOW_MESSAGE_VISIBLE)

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has attacked [target.name] ([target.ckey]) with a bottle!</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed with a bottle by [user.name] ([user.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with a bottle (INTENT: [uppertext(intent_text(user.a_intent))]) in [get_area(user)] ([user.loc.x],[user.loc.y],[user.loc.z]).", user.loc.x, user.loc.y, user.loc.z)

	if(reagents)
		for(var/mob/O in viewers(user, null))
			O.show_message(text(SPAN_NOTICE("<B>The contents of \the [src] splashes all over [target]!</B>")), SHOW_MESSAGE_VISIBLE)
		reagents.reaction(target, TOUCH)

	smash(target, user)

	return

/obj/item/reagent_container/food/drinks/bottle/attackby(obj/item/I, mob/living/user)
	if(!isGlass || !istype(I, /obj/item/paper))
		return ..()
	if(!reagents || !length(reagents.reagent_list))
		to_chat(user, SPAN_NOTICE("\The [src] is empty..."))
		return
	var/alcohol_potency = 0
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.intensitymod)
			alcohol_potency += R.intensitymod * R.volume
		else if(istype(R, /datum/reagent/ethanol))
			var/datum/reagent/ethanol/RA = R
			alcohol_potency += RA.boozepwr * (R.volume / 8)

	if(alcohol_potency < BURN_LEVEL_TIER_1)
		to_chat(user, SPAN_NOTICE("There's not enough flammable liquid in \the [src]!"))
		return
	alcohol_potency = clamp(alcohol_potency, BURN_LEVEL_TIER_1, BURN_LEVEL_TIER_7)

	if(!do_after(user, 20, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_BUILD))
		return
	var/turf/T = get_turf(src)
	var/obj/item/explosive/grenade/incendiary/molotov/M = new /obj/item/explosive/grenade/incendiary/molotov(T, alcohol_potency)
	to_chat(user, SPAN_NOTICE("You craft \a [M]!"))
	user.put_in_hands(M)
	qdel(I)
	qdel(src)

///Alcohol bottles and their contents.
/obj/item/reagent_container/food/drinks/bottle/gin
	name = "\improper Griffeater Gin"
	desc = "A bottle of high-quality gin, produced in the New London Space Station."
	icon_state = "ginbottle"
	center_of_mass = "x=16;y=4"

/obj/item/reagent_container/food/drinks/bottle/gin/Initialize()
	. = ..()
	reagents.add_reagent("gin", 100)

/obj/item/reagent_container/food/drinks/bottle/whiskey
	name = "\improper Uncle Git's Special Reserve"
	desc = "A premium single-malt whiskey, gently matured for four years by hillbillies in the backwaters of Alabama."
	icon_state = "whiskeybottle"
	center_of_mass = "x=16;y=3"

/obj/item/reagent_container/food/drinks/bottle/whiskey/Initialize()
	. = ..()
	reagents.add_reagent("whiskey", 100)

/obj/item/reagent_container/food/drinks/bottle/sake
	name = "\improper Weyland-Yutani Sake"
	desc = "Sake made with ancient techniques passed down for thousands of years. Fermented in Iowa by the Weyland-Yutani Corporation."
	icon_state = "sakebottle"
	center_of_mass = "x=17;y=7"

/obj/item/reagent_container/food/drinks/bottle/sake/Initialize()
	. = ..()
	reagents.add_reagent("sake", 100)

/obj/item/reagent_container/food/drinks/bottle/vodka
	name = "\improper Red Star Vodka"
	desc = "Red Star Vodka: A staple of the enemy's diet. Who knew that liquid potato could smell this potent. The bottle reads, 'Ra Ra Red Star Man: Lover of the Finer Things.' Or at least that's what you assume...you can't read Russian."
	icon_state = "red_star_vodka"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_container/food/drinks/bottle/vodka/Initialize()
	. = ..()
	reagents.add_reagent("vodka", 100)

//chess bottles

/obj/item/reagent_container/food/drinks/bottle/vodka/chess
	name = "\improper Red Star Vodka promotional bottle"
	desc = "A promotional chess themed bottle of Red Star Vodka."
	icon_state = "chess"
	black_market_value = 15

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_pawn
	name = "\improper Black Pawn bottle"
	icon_state = "b_pawn"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_pawn
	name = "\improper White Pawn bottle"
	icon_state = "w_pawn"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_bishop
	name = "\improper Black Bishop bottle"
	icon_state = "b_bishop"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_bishop
	name = "\improper White Bishop bottle"
	icon_state = "w_bishop"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_knight
	name = "\improper Black Knight bottle"
	icon_state = "b_knight"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_knight
	name = "\improper White Knight bottle"
	icon_state = "w_knight"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_rook
	name = "\improper Black Rook bottle"
	icon_state = "b_rook"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_rook
	name = "\improper White Rook bottle"
	icon_state = "w_rook"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_king
	name = "\improper Black King bottle"
	icon_state = "b_king"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_king
	name = "\improper White King bottle"
	icon_state = "w_king"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_queen
	name = "\improper Black Queen bottle"
	icon_state = "b_queen"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_queen
	name = "\improper White Queen bottle"
	icon_state = "w_queen"

/obj/item/reagent_container/food/drinks/bottle/vodka/chess/random/Initialize()
	. = ..()
	var/newbottle = pick(subtypesof(/obj/item/reagent_container/food/drinks/bottle/vodka/chess))
	new newbottle(loc)
	qdel(src)


/obj/item/reagent_container/food/drinks/bottle/tequila
	name = "\improper Caccavo Guaranteed Quality tequila"
	desc = "Made from premium petroleum distillates, pure thalidomide and other fine quality ingredients!"
	icon_state = "tequilabottle"
	center_of_mass = "x=16;y=3"

/obj/item/reagent_container/food/drinks/bottle/tequila/Initialize()
	. = ..()
	reagents.add_reagent("tequila", 100)

/obj/item/reagent_container/food/drinks/bottle/davenport
	name = "\improper Davenport Rye Whiskey"
	desc = "An expensive whiskey with a distinct flavor. The bottle proudly proclaims that it's, 'A True Classic.'"
	icon_state = "davenport"
	center_of_mass = "x=16;y=3"

/obj/item/reagent_container/food/drinks/bottle/davenport/Initialize()
	. = ..()
	reagents.add_reagent("specialwhiskey", 50)

/obj/item/reagent_container/food/drinks/bottle/bottleofnothing
	name = "Bottle of Nothing"
	desc = "A bottle filled with nothing"
	icon_state = "bottleofnothing"
	center_of_mass = "x=17;y=5"

/obj/item/reagent_container/food/drinks/bottle/bottleofnothing/Initialize()
	. = ..()
	reagents.add_reagent("nothing", 100)

/obj/item/reagent_container/food/drinks/bottle/patron
	name = "Wrapp Artiste Patron"
	desc = "Silver laced tequila, served in space night clubs across the galaxy."
	icon_state = "patronbottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/patron/Initialize()
	. = ..()
	reagents.add_reagent("patron", 100)

/obj/item/reagent_container/food/drinks/bottle/rum
	name = "Captain Pete's Cuban Spiced Rum"
	desc = "Named after the famed Captain 'Cuban' Pete, this rum is about as volatile as his final mission."
	icon_state = "rumbottle"
	center_of_mass = "x=16;y=8"

/obj/item/reagent_container/food/drinks/bottle/rum/Initialize()
	. = ..()
	reagents.add_reagent("rum", 100)

/obj/item/reagent_container/food/drinks/bottle/holywater
	name = "Flask of Holy Water"
	desc = "A flask of the chaplain's holy water."
	icon_state = "holyflask"
	center_of_mass = "x=17;y=10"

/obj/item/reagent_container/food/drinks/bottle/holywater/Initialize()
	. = ..()
	reagents.add_reagent("holywater", 100)

/obj/item/reagent_container/food/drinks/bottle/vermouth
	name = "Goldeneye Vermouth"
	desc = "Sweet, sweet dryness~"
	icon_state = "vermouthbottle"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_container/food/drinks/bottle/vermouth/Initialize()
	. = ..()
	reagents.add_reagent("vermouth", 100)

/obj/item/reagent_container/food/drinks/bottle/kahlua
	name = "Robert Robust's Coffee Liqueur"
	desc = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936, HONK"
	icon_state = "kahluabottle"
	center_of_mass = "x=17;y=3"

/obj/item/reagent_container/food/drinks/bottle/kahlua/Initialize()
	. = ..()
	reagents.add_reagent("kahlua", 100)

/obj/item/reagent_container/food/drinks/bottle/goldschlager
	name = "College Girl Goldschlager"
	desc = "Because they are the only ones who will drink 100 proof cinnamon schnapps."
	icon_state = "goldschlagerbottle"
	center_of_mass = "x=15;y=3"

/obj/item/reagent_container/food/drinks/bottle/goldschlager/Initialize()
	. = ..()
	reagents.add_reagent("goldschlager", 100)

/obj/item/reagent_container/food/drinks/bottle/cognac
	name = "Chateau De Baton Premium Cognac"
	desc = "A sweet and strongly alcoholic drink, made after numerous distillations and years of maturing. You might as well not scream 'SHITCURITY' this time."
	icon_state = "cognacbottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/cognac/Initialize()
	. = ..()
	reagents.add_reagent("cognac", 100)

/obj/item/reagent_container/food/drinks/bottle/wine
	name = "Doublebeard Bearded Special Wine"
	desc = "A faint aura of unease and asspainery surrounds the bottle."
	icon_state = "winebottle"
	center_of_mass = "x=16;y=4"

/obj/item/reagent_container/food/drinks/bottle/wine/Initialize()
	. = ..()
	reagents.add_reagent("wine", 100)

/obj/item/reagent_container/food/drinks/bottle/absinthe
	name = "Jailbreaker Verte"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon_state = "absinthebottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/absinthe/Initialize()
	. = ..()
	reagents.add_reagent("absinthe", 100)

/obj/item/reagent_container/food/drinks/bottle/blackout //used for testing alcohol code
	name = "Blackout Stout"
	desc = "Renowned through space and time, a bottle of Blackout is enough to knock out almost anyone. A true test for the true drunkard."
	icon_state = "pwineglass"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/blackout/Initialize()
	. = ..()
	reagents.add_reagent("blackout", 100)

/obj/item/reagent_container/food/drinks/bottle/melonliquor
	name = "Emeraldine Melon Liquor"
	desc = "A bottle of 46 proof Emeraldine Melon Liquor. Sweet and light."
	icon_state = "alco-green" //Placeholder.
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/melonliquor/Initialize()
	. = ..()
	reagents.add_reagent("melonliquor", 100)

/obj/item/reagent_container/food/drinks/bottle/bluecuracao
	name = "Miss Blue Curacao"
	desc = "A fruity, exceptionally azure drink. Does not allow the imbiber to use the fifth magic."
	icon_state = "alco-blue" //Placeholder.
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/bluecuracao/Initialize()
	. = ..()
	reagents.add_reagent("bluecuracao", 100)

/obj/item/reagent_container/food/drinks/bottle/grenadine
	name = "Briar Rose Grenadine Syrup"
	desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	icon_state = "grenadinebottle"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_container/food/drinks/bottle/grenadine/Initialize()
	. = ..()
	reagents.add_reagent("grenadine", 100)

/obj/item/reagent_container/food/drinks/bottle/pwine
	name = "Warlock's Velvet"
	desc = "What a delightful packaging for a surely high-quality wine! The vintage must be amazing!"
	icon_state = "pwinebottle"
	center_of_mass = "x=16;y=4"

/obj/item/reagent_container/food/drinks/bottle/pwine/Initialize()
	. = ..()
	reagents.add_reagent("pwine", 100)

////////////////////////// BEERS ///////////////////////

/obj/item/reagent_container/food/drinks/bottle/beer/craft
	name = "Pendleton's Triple Star Lager"
	desc = "A brand of colonial lager prevalent in the Outer Rim but practically unknown in the inner systems, probably because of health concerns. It tastes like absolutely nothing familiar to you, but is oddly refreshing and has a fruity taste. The label on the back reads, 'Brewed with exotic hops in Costaguana.' You're almost certain that's a fake country."
	icon_state = "pendleton"
	center_of_mass = "x=16;y=13"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/Initialize()
	. = ..()
	reagents.add_reagent("beer", 30)

/obj/item/reagent_container/food/drinks/bottle/beer/craft/tuxedo
	name = "Tuxedo Premium"
	desc = "A craft ale originally brewed in England, the Tuxedo Premium brand is widely advertised as a beer for the gentleman; one not enjoyed in a pub, but rather sipped over a formal dinner. It doesn't sell very well, partially because it doesn't taste much different than any other beer and partially because it is three times as expensive. But cherish it! This is the nectar of the rich."
	icon_state = "tuxedo"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/ganucci
	name = "Ganucci's Genuine Light Beer"
	desc = "A light beer with a watery taste and sour undertones. It's not the best, but it's dirt cheap, and brewed in Italy, so it's naturally popular with the masses. Contrary to popular belief, it is real beer, and not in fact druidic dirt water."
	icon_state = "ganucci"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/bluemalt
	name = "Blue Malt"
	desc = "A malt beer with an alcohol content that toes the line of legality. So-called 'blue' because it's the color face you get when you down so many of these that your heart stops working. The surgeon general's warning is printed in huge letters on the back of the bottle. Do guns count as heavy machinery?"
	icon_state = "bluemalt"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/partypopper
	name = "Party Popper Ale"
	desc = "A fun, exotic craft beer from the colonies that mixes in a tiny bit of sugar along with light, fruity ale. The result makes the taste buds in your mouth do a little dance, presumably of confusion, and is said to make people smile after a sip. Best served at parties, worst served at funerals. Smile over your best friend's grave, why don't you."
	icon_state = "partypopper"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/tazhushka
	name = "Tazhushka's Turquoise Beer"
	desc = "A UPP-originating beer made by the eponymous Tazhushka State Brewery. It singes your throat when you drink it, but it makes you also feel ready for anything. For a time, at least, until the hangover the brand is famous for kicks in and wrecks you inside out."
	icon_state = "tazhushka"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/reaper
	name = "Reaper Red"
	desc = "A strong Japanese beer that is marketed as 'daring' and 'adventurous'. Considering the label is quite literally the universal sign for 'HAZARD', it's safe to say drinking enough of this will be enough of a daring adventure to make you move up your next appointment with your doctor regarding your weeping liver."
	icon_state = "reaper"

/obj/item/reagent_container/food/drinks/bottle/beer/craft/mono
	name = "Mono Lager"
	desc = "This black and white beer bottle does not say where it's from, nor does it say what it is supposed to be. All you know is that it is a beer, and it has a rather bland taste. Makes you feel like you're looking through a photo from four centuries ago. Rumor is if you say the name fast enough, it makes you want to say a long-winded, villainous speech."
	icon_state = "mono"

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/reagent_container/food/drinks/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon_state = "orangejuice"
	item_state = "carton"
	center_of_mass = "x=16;y=7"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/orangejuice/Initialize()
	. = ..()
	reagents.add_reagent("orangejuice", 100)
	var/probability = rand(0, 101)
	switch(probability)
		if(0 to 49)
			desc = "Full of vitamins and deliciousness! Contains NO pulp!"
		if(50 to 100)
			desc = "Full of vitamins and deliciousness! Contains pulp!"
		else
			desc = "Full of vitamins and deliciousness! Contains 100% pulp!"

/obj/item/reagent_container/food/drinks/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon_state = "cream"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/cream/Initialize()
	. = ..()
	reagents.add_reagent("cream", 100)

/obj/item/reagent_container/food/drinks/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon_state = "tomatojuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/tomatojuice/Initialize()
	. = ..()
	reagents.add_reagent("tomatojuice", 100)

/obj/item/reagent_container/food/drinks/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon_state = "limejuice"
	item_state = "carton"
	center_of_mass = "x=16;y=8"
	isGlass = 0

/obj/item/reagent_container/food/drinks/bottle/limejuice/Initialize()
	. = ..()
	reagents.add_reagent("limejuice", 100)
