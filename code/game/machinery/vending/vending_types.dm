/*
 * Vending machine types
 */

/*

/obj/structure/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 1.5 SECONDS
	products = list()
	contraband = list()
	premium = list()

*/

/obj/structure/machinery/vending/coffee
	name = "\improper Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	//product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 3.4 SECONDS
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(
		/obj/item/reagent_container/food/drinks/coffee/marine = 25,
		/obj/item/reagent_container/food/drinks/tea = 25,
		/obj/item/reagent_container/food/drinks/h_chocolate = 25,
	)
	contraband = list(/obj/item/reagent_container/food/drinks/ice = 10)
	prices = list(
		/obj/item/reagent_container/food/drinks/coffee/marine = 1.5,
		/obj/item/reagent_container/food/drinks/tea = 3,
		/obj/item/reagent_container/food/drinks/h_chocolate = 15,
		)
	product_type = VENDOR_PRODUCT_TYPE_BEVERAGES

/obj/structure/machinery/vending/coffee/simple
	name = "\improper Hot Coffee Machine"
	product_ads = ""
	products = list(/obj/item/reagent_container/food/drinks/coffee = 40)
	contraband = list(/obj/item/reagent_container/food/drinks/h_chocolate = 25)

/obj/structure/machinery/vending/snack
	name = "\improper Hot Foods Machine"
	desc = "A vending machine full of ready to cook meals, mhmmmm taste the nutritional goodness!"
	product_slogans = "Kepler Crisps! Try a snack that's out of this world!;Eat an EAT!;Eat a Weyland-Yutani brand packaged hamburger.;Eat a Weyland-Yutani brand packaged hot dog.;Eat a Weyland-Yutani brand packaged burrito.;"
	product_ads = "Kepler Crisps! Try a snack that's out of this world!;Eat an EAT!"
	icon_state = "snack"
	products = list(
		/obj/item/reagent_container/food/snacks/packaged_burger = 12,
		/obj/item/reagent_container/food/snacks/packaged_burrito = 12,
		/obj/item/reagent_container/food/snacks/packaged_hdogs =12,
		/obj/item/reagent_container/food/snacks/kepler_crisps = 12,
		/obj/item/reagent_container/food/snacks/kepler_crisps/flamehot = 12,
		/obj/item/reagent_container/food/snacks/wy_chips/pepper = 12,
		/obj/item/reagent_container/food/snacks/eat_bar = 12,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars = 6,
		/obj/item/reagent_container/food/snacks/wrapped/chunk = 6,
		/obj/item/reagent_container/food/snacks/wrapped/barcardine = 6,
	)

	prices = list(
		/obj/item/reagent_container/food/snacks/packaged_burger = 5,
		/obj/item/reagent_container/food/snacks/packaged_burrito = 5,
		/obj/item/reagent_container/food/snacks/packaged_hdogs = 5,
		/obj/item/reagent_container/food/snacks/kepler_crisps = 3,
		/obj/item/reagent_container/food/snacks/kepler_crisps/flamehot = 5,
		/obj/item/reagent_container/food/snacks/wy_chips/pepper = 3,
		/obj/item/reagent_container/food/snacks/eat_bar = 4,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars = 4,
		/obj/item/reagent_container/food/snacks/wrapped/chunk = 4,
		/obj/item/reagent_container/food/snacks/wrapped/barcardine = 4,
	)
	product_type = VENDOR_PRODUCT_TYPE_FOOD

/obj/structure/machinery/vending/snack/packaged
	product_slogans = ""
	product_ads = ""
	products = list(
		/obj/item/reagent_container/food/snacks/packaged_burger = 40,
		/obj/item/reagent_container/food/snacks/packaged_burrito = 40,
		/obj/item/reagent_container/food/snacks/packaged_hdogs = 40,
	)

/obj/structure/machinery/vending/cola
	name = "\improper Souto Softdrinks"
	desc = "A softdrink vendor provided by Souto Soda Company, Havana."
	icon_state = "Cola_Machine"
	product_slogans = "Souto Soda: Have a Souto and be taken away to a tropical paradise!;Souto Classic. You can't beat that tangerine goodness!;Souto Cherry. The sweet flavor of a cool winter morning!;Souto Lime. For that sweet and sour flavor that you know and love!;Souto Grape. There's nothing better than a grape soda.;Weyland-Yutani Fruit Beer. Nothing came from that lawsuit!"
	product_ads = "Souto Classic. You can't beat that tangerine goodness!;Souto Cherry. The sweet flavor of a cool winter morning!;Souto Lime. For that sweet and sour flavor that you know and love!;Souto Grape. There's nothing better than a grape soda.;Weyland-Yutani Fruit Beer. Nothing came from that lawsuit!"
	products = list(
		/obj/item/reagent_container/food/drinks/cans/souto/classic = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cherry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/lime = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/grape = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/blue = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/peach = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cranberry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/vanilla = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/pineapple = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/classic = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/lime = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/grape = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/blue = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/peach = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple = 10,
		/obj/item/reagent_container/food/drinks/cans/cola = 10,
	)

	prices = list(
		/obj/item/reagent_container/food/drinks/cans/souto/classic = 8,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/classic = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/cherry = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cherry = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/lime = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/lime = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/grape = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/grape = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/blue = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/blue = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/peach = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/peach = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/cranberry = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/vanilla = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/vanilla = 12,
		/obj/item/reagent_container/food/drinks/cans/souto/pineapple = 9,
		/obj/item/reagent_container/food/drinks/cans/souto/diet/pineapple = 12,
		/obj/item/reagent_container/food/drinks/cans/cola = 20,
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_type = VENDOR_PRODUCT_TYPE_SOUTO

/obj/structure/machinery/vending/cola/research
	desc = "A softdrink vendor provided by Souto Soda Company, Havana. This one is bound to the Research Budget card and doesn't require swiping"
	products = list(
		/obj/item/reagent_container/food/drinks/cans/souto/classic = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cherry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/lime = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/grape = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/blue = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/peach = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/cranberry = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/vanilla = 10,
		/obj/item/reagent_container/food/drinks/cans/souto/pineapple = 10,
	)

	prices = list()

/obj/structure/machinery/vending/cigarette
	name = "cigarette machine" //old, should be replaced with WY or Koorlander machines. Just the template for vars
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = ""
	product_ads = ""
	vend_delay = 1.4 SECONDS
	icon_state = "cigs"
	products = list(
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 50,
		/obj/item/storage/fancy/cigar/tarbacktube = 20,
		/obj/item/storage/box/matches = 15,
		/obj/item/tool/lighter/random = 25,
		/obj/item/tool/lighter/zippo = 10,
	)
	premium = list()
	prices = list()
	product_type = VENDOR_PRODUCT_TYPE_NICOTINE

/obj/structure/machinery/vending/cigarette/free //used to just be a vendor that gave luckies for free. I didn't like the idea, so I've replaced all the map uses with koorlanders, and have turned this into an admin "all cigs" vendor
	product_slogans = ""
	product_ads = ""
	products = list(
		/obj/item/storage/fancy/cigarettes/kpack = 99,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 99,
		/obj/item/storage/fancy/cigarettes/trading_card = 99,
		/obj/item/storage/fancy/cigarettes/lady_finger = 99,
		/obj/item/storage/fancy/cigarettes/wypacket = 99,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 99,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 99,
		/obj/item/storage/fancy/cigarettes/trading_card = 99,
		/obj/item/storage/fancy/cigarettes/blackpack = 99,
		/obj/item/storage/fancy/cigar = 99,
		/obj/item/storage/fancy/cigar/tarbacktube = 99,
		/obj/item/storage/fancy/cigar/tarbacks = 99,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 99,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 99,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 99,
		/obj/item/storage/fancy/cigar/matchbook/brown = 99,
		/obj/item/storage/box/matches = 99,
		/obj/item/tool/lighter/random = 99,
		/obj/item/tool/lighter/zippo = 99,
	)
	premium = list()
	prices = list()

/obj/structure/machinery/vending/cigarette/koorlander //koorlander machine, contains luckies since they either bought Lucky Strikes as a company, or are working together to survive.
	name = "Koorlander brand cigarette machine"
	desc = "A Koorlander brand cigarette vending machine. Comes with Lucky Strikes, Lady Fingers, Koorlander Golds of course, and a few smaller brands you've barely heard of."
	icon_state = "koorcigs"
	product_slogans = list(
		"Koorlander Gold, for the refined palate.",
		"Lady Fingers, for the dainty smoker.",
		"Lady Fingers, treat your palete with pink!",
		"The big blue K means a cool fresh day!",
		"For the taste that cools your mood, look for the big blue K!",
		"Refined smokers go for Gold!",
		"Lady Fingers are preferred by women who appreciate a cool smoke.",
		"Lady Fingers are the number one cigarette this side of Gateway!",
		"The tobacco connoisseur prefers Koorlander Gold.",
		"For the cool, filtered feel, Lady Finger Cigarettes provide the smoothest draw of any cigarette on the market.",
		"For the man who knows his place is at the top, Koorlander Gold shows the world that you're the best and no-one can say otherwise.",
		"L.S./M.F.T.! Lucky Strikes Means Fine Tobacco.",
		"For a classic style that lights up every time, there's always Zippo!",
		"On a budget? Buy a Bic.",
		"Bic, making school supplies since 1945.",
		"Real men smoke Lucky Strikes!",
		"Serving the US Armed Forces for over two-hundred years!",
		"Life's short, smoke a Lucky!",
		"Lucky Strike is first again!",
		"You just can't beat a Lucky Strike!",
		"The preferred cigarette of Carlos Hathcock!",
		"First again with tobacco-men!",
		"Real. Simple. Different. American Spirit.",
		"Tobacco Ingredients: Tobacco & Water. American Spirit.",
		"The Interstellar Commerce Commission would like to remind you that smoking kills.",
		"The Food and Drug Administration would like to remind you that tobacco products cause cancer and increased fatigue.",
	)

	product_ads = list(
		"For the taste that cools your mood, look for the big blue K!",
		"Refined smokers go for Gold!",
		"Lady Fingers are preferred by women who appreciate a cool smoke.",
		"Lady Fingers are the number one cigarette this side of Gateway!",
		"The tobacco connoisseur prefers Koorlander Gold.",
		"For the cool, filtered feel, Lady Finger Cigarettes provide the smoothest draw of any cigarette on the market.",
		"For the man who knows his place is at the top, Koorlander Gold shows the world that you're the best and no-one can say otherwise.",
		"Real men smoke Lucky Strikes!;Serving the US Armed Forces for over two-hundred years!",
		"Life's short, smoke a Lucky!",
		"L.S./M.F.T.!,",
		"Lucky Strike is first again!",
		"You just can't beat a Lucky Strike!",
		"The preferred cigarette of Carlos Hathcock!",
		"First again with tobacco-men!",
		"Real. Simple. Different. American Spirit.",
		"Tobacco Ingredients: Tobacco & Water. American Spirit.",
		"The Interstellar Commerce Commission would like to remind you that smoking kills.",
		"The Food and Drug Administration would like to remind you that tobacco products cause cancer and increased fatigue.",
	)

	products = list(
		/obj/item/storage/fancy/cigarettes/kpack = 20,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 20,
		/obj/item/storage/fancy/cigarettes/lady_finger = 20,
		/obj/item/storage/fancy/cigarettes/spirit = 10,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 10,
		/obj/item/storage/fancy/cigar/tarbacktube = 10,

		/obj/item/storage/box/matches = 5,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 5,
		/obj/item/storage/fancy/cigar/matchbook/brown = 10,
		/obj/item/tool/lighter/random = 20,
		/obj/item/tool/lighter/zippo = 10,
		/obj/item/tool/lighter/zippo/blue = 5,
	)

	prices = list(
		/obj/item/storage/fancy/cigarettes/kpack = 14,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 8,
		/obj/item/storage/fancy/cigarettes/lady_finger = 11,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 12,
		/obj/item/storage/fancy/cigarettes/spirit = 12,
		/obj/item/storage/fancy/cigar/tarbacktube = 20,
		/obj/item/storage/box/matches = 3,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 2,
		/obj/item/storage/fancy/cigar/matchbook/brown = 1,
		/obj/item/tool/lighter/random = 5,
		/obj/item/tool/lighter/zippo = 20,
		/obj/item/tool/lighter/zippo/blue = 30,
	)

/obj/structure/machinery/vending/cigarette/koorlander/free
		prices = list(
		/obj/item/storage/fancy/cigarettes/kpack = 0,
		/obj/item/storage/fancy/cigarettes/lucky_strikes = 0,
		/obj/item/storage/fancy/cigarettes/lady_finger = 0,
		/obj/item/storage/fancy/cigarettes/spirit/yellow = 0,
		/obj/item/storage/fancy/cigarettes/spirit = 0,
		/obj/item/storage/fancy/cigar/tarbacktube = 0,
		/obj/item/storage/box/matches = 0,
		/obj/item/storage/fancy/cigar/matchbook/koorlander = 0,
		/obj/item/storage/fancy/cigar/matchbook/brown = 0,
		/obj/item/tool/lighter/random = 0,
		/obj/item/tool/lighter/zippo = 0,
		/obj/item/tool/lighter/zippo/blue = 0,
	)

/obj/structure/machinery/vending/cigarette/wy //WY machine
	name = "Weyland Yutani brand cigarette machine"
	desc = "A Weyland Yutani Brand cigarette vending machine, looks like a Wey-Yu Gold pack. Comes with Emerald Greens, Wey-Yu Golds of course, Arcturian Aces, and some Three World Empire brand you've barely heard of. Executive Selects are still out of stock due to shipping issues..."
	icon_state = "wycigs"
	product_slogans = list(
		"Weyland Yutani Gold, for those high up the chain.",
		"Arcturian Ace, for those who can't stand bad taste!",
		"Arcturian Ace, good for the lungs! On account of exotic Arctura flora.", //it's cocaine
		"Tastes how a cigarette should, smoke Wey-Yu Golds!",
		"Refined smokers go for Gold!",
		"Arcturian Aces, minty fresh.",
		"Aces, keeps your breah as fresh as an Arcturian waterfall!",
		"Emerald Greens are the number one cigarette this side of New Eden!",
		"The tobacco aficionado prefers Executive Selects.",
		"For the minty freshness of another world, try Arcturian Aces!",
		"For the Executive on top of the world, smoke Exec Selects.",
		"Arcturian Aces, good for first timers!",
		"For a classic style that lights up every time, there's always Zippo!",
		"On a budget? Buy a Bic.",
		"Bic, making school supplies since 1945.",
		"Emerald Greens, green as the fields of New Eden.",
		"Emerald Greens, favored by doctors!",
		"You just can't beat the green!",
		"The preferred brand of Richard Nixon!", //:smug:
		"First again with doctors!",
		"Balaji Imperials, for King and Country!",
		"Life's short, smoke a 'laji!",
		"The Interstellar Commerce Commission would like to remind you that smoking kills.",
		"The Food and Drug Administration would like to remind you that tobacco products cause cancer and increased fatigue.",
	)

	product_ads = list(
		"Weyland Yutani Gold, for those high up the chain.",
		"Arcturian Ace, for those who don't like bad taste.",
		"Arcturian Ace, good for the lungs! On account of local Arctura flora.",
		"Tastes how a cigarette should, Weyland Yutani Gold!",
		"Refined smokers go for Gold!",
		"Arcturian Aces, minty fresh.",
		"Emerald Greens are the number one cigarette this side of New Eden!",
		"The tobacco aficionado prefers Executives.",
		"For the minty freshness of another world, try Arcturian Aces!",
		"For the Executive on top of the world, smoke Exec Selects.",
		"Arcturian Aces, good for first timers!",
		"Emerald Greens, favorited by doctors!",
		"You just can't beat the green!",
		"The preferred cigarette of Richard Nixon!",
		"First again with doctors!",
		"Balaji Imperials, for King and Country!",
		"Life's short, smoke a 'laji!",
		"The Interstellar Commerce Commission would like to remind you that smoking kills.",
		"The Food and Drug Administration would like to remind you that tobacco products cause cancer and increased fatigue.",
	)

	premium = list(/obj/item/storage/fancy/cigar = 5)
	products = list(
		/obj/item/storage/fancy/cigarettes/wypacket = 15,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 30,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 10,
		/obj/item/storage/fancy/cigarettes/balaji = 10,
		/obj/item/storage/fancy/cigarettes/blackpack = 0,

		/obj/item/storage/box/matches = 5,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 10,
		/obj/item/storage/fancy/cigar/matchbook/balaji_imperial = 10,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 10,
		/obj/item/tool/lighter/random = 20,
		/obj/item/tool/lighter/zippo/black = 5,
		/obj/item/tool/lighter/zippo/executive = 1,

	)

	prices = list(
		/obj/item/storage/fancy/cigarettes/wypacket = 15,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 5,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 8,
		/obj/item/storage/fancy/cigarettes/balaji = 15,
		/obj/item/storage/fancy/cigarettes/blackpack = 40,

		/obj/item/storage/box/matches = 2,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 7,
		/obj/item/storage/fancy/cigar/matchbook/balaji_imperial = 6,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 5,
		/obj/item/tool/lighter/random = 3,
		/obj/item/tool/lighter/zippo/black = 15,
		/obj/item/tool/lighter/zippo/executive = 50,
	)

/obj/structure/machinery/vending/cigarette/wy/Initialize(mapload, ...)
	var/exec_number = rand(0, 2)
	products[/obj/item/storage/fancy/cigarettes/blackpack] = exec_number
	return ..()

/obj/structure/machinery/vending/cigarette/wy/free
	prices = list(
		/obj/item/storage/fancy/cigarettes/wypacket = 0,
		/obj/item/storage/fancy/cigarettes/emeraldgreen = 0,
		/obj/item/storage/fancy/cigarettes/arcturian_ace = 0,
		/obj/item/storage/fancy/cigarettes/balaji = 0,
		/obj/item/storage/fancy/cigarettes/blackpack = 0,

		/obj/item/storage/box/matches = 5,
		/obj/item/storage/fancy/cigar/matchbook/exec_select = 0,
		/obj/item/storage/fancy/cigar/matchbook/wy_gold = 0,
		/obj/item/tool/lighter/random = 0,
		/obj/item/tool/lighter/zippo/black = 0,
		/obj/item/tool/lighter/zippo/executive = 0,
	)


/obj/structure/machinery/vending/security
	name = "\improper SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	product_slogans = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(ACCESS_MARINE_BRIG)
	products = list(
		/obj/item/restraint/handcuffs = 8,
		/obj/item/restraint/handcuffs/zip = 10,
		/obj/item/restraint/legcuffs = 3,
		/obj/item/explosive/grenade/flashbang = 4,
		/obj/item/weapon/gun/energy/taser = 4,
		/obj/item/reagent_container/spray/pepper = 4,
		/obj/item/reagent_container/spray/investigation = 4,
		/obj/item/weapon/baton = 4,
		/obj/item/device/flashlight = 4,
		/obj/item/device/flash = 5,
		/obj/item/reagent_container/food/snacks/donut/normal = 12,
		/obj/item/storage/box/evidence = 6,
		/obj/item/clothing/head/helmet/marine/MP = 6,
		/obj/item/clothing/head/beret/marine/mp/mppeaked = 6,
		/obj/item/clothing/head/beret/marine/mp/mpcap = 6,
		/obj/item/clothing/under/marine/mp = 2,
		/obj/item/storage/belt/security/MP = 6,
		/obj/item/clothing/head/beret/marine/mp = 6,
		/obj/item/clothing/glasses/sunglasses/sechud = 3,
		/obj/item/device/radio/headset = 6,
		/obj/item/tape/regulation = 5,
		/obj/item/device/taperecorder = 3,
		/obj/item/device/clue_scanner = 3,
		/obj/item/device/camera = 8,
		/obj/item/device/camera_film = 8,
	)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2,/obj/item/storage/donut_box = 2)

/obj/structure/machinery/vending/security/riot
	name = "\improper RiotTech"
	desc = "A security riot equipment vendor."
	hacking_safety = TRUE
	wrenchable = FALSE
	products = list(
		/obj/item/restraint/handcuffs/zip = 40,
		/obj/item/explosive/grenade/flashbang = 20,
		/obj/item/explosive/grenade/custom/teargas = 40,
		/obj/item/ammo_magazine/smg/m39/rubber = 40,
		/obj/item/ammo_magazine/pistol/rubber = 40,
		/obj/item/ammo_magazine/pistol/mod88/rubber = 40,
		/obj/item/ammo_magazine/rifle/rubber = 40,
		/obj/item/ammo_magazine/rifle/m4ra/rubber = 40,
		/obj/item/clothing/head/helmet/marine/MP = 8,
		/obj/item/explosive/plastic/breaching_charge/rubber = 6,
	)

/obj/structure/machinery/vending/sea
	name = "\improper SEATech"
	desc = "An equipment vendor designed to save lives."
	product_ads = "Semper Fi!;First to Fight!;Ooh Rah.;Leathernecks!;The Few. The Proud.;Esprit de Corps;Jarhead.;Devil Dogs."
	icon_state = "sec"
	icon_deny = "sec-deny"
	hacking_safety = TRUE
	wrenchable = FALSE
	req_access = list(ACCESS_MARINE_SEA)
	products = list(
		/obj/item/ammo_magazine/smg/m39/rubber = 20,
		/obj/item/ammo_magazine/pistol/rubber = 20,
		/obj/item/ammo_magazine/pistol/mod88/rubber = 20,
		/obj/item/ammo_magazine/rifle/rubber = 20,
		/obj/item/ammo_magazine/rifle/m4ra/rubber = 20,
		/obj/item/ammo_magazine/shotgun/beanbag = 20,
		/obj/item/storage/firstaid/regular = 2,
		/obj/item/storage/firstaid/fire = 2,
		/obj/item/storage/firstaid/rad = 1,
		/obj/item/device/radio/headset = 6,
		/obj/item/device/flashlight = 4,
		/obj/item/tool/crew_monitor = 1,
	)
	contraband = list(/obj/item/storage/fancy/cigar = 2,/obj/item/tool/lighter/zippo = 2)

/obj/structure/machinery/vending/hydronutrients
	name = "\improper NutriMax"
	desc = "A plant nutrients vendor."
	//product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	//product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(/obj/item/reagent_container/glass/fertilizer/ez = 35,/obj/item/reagent_container/glass/fertilizer/l4z = 25,/obj/item/reagent_container/glass/fertilizer/rh = 15,/obj/item/tool/plantspray/pests = 20,
					/obj/item/reagent_container/syringe = 5,/obj/item/storage/bag/plants = 5)
	premium = list(/obj/item/reagent_container/glass/bottle/ammonia = 10,/obj/item/reagent_container/glass/bottle/diethylamine = 5)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/structure/machinery/vending/hydronutrients/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	hacking_safety = TRUE

/obj/structure/machinery/vending/hydronutrients/yautja/checking_id()
	return FALSE

/obj/structure/machinery/vending/hydroseeds
	name = "\improper MegaSeed Servitor"
	desc = "When you need seeds fast!"
	//product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	//product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"
	delay_product_spawn = 1

	products = list(/obj/item/seeds/bananaseed = 3,/obj/item/seeds/berryseed = 3,/obj/item/seeds/carrotseed = 3,/obj/item/seeds/chantermycelium = 2,/obj/item/seeds/chiliseed = 3,
					/obj/item/seeds/cornseed = 3, /obj/item/seeds/eggplantseed = 3, /obj/item/seeds/potatoseed = 3,/obj/item/seeds/soyaseed = 3,
					/obj/item/seeds/sunflowerseed = 2,/obj/item/seeds/tomatoseed = 3,/obj/item/seeds/wheatseed = 3,/obj/item/seeds/appleseed = 3,
					/obj/item/seeds/poppyseed = 3,/obj/item/seeds/sugarcaneseed = 3,/obj/item/seeds/peanutseed = 3,/obj/item/seeds/whitebeetseed = 3,/obj/item/seeds/watermelonseed = 3,/obj/item/seeds/limeseed = 3,
					/obj/item/seeds/lemonseed = 3,/obj/item/seeds/orangeseed = 3,/obj/item/seeds/grassseed = 3,/obj/item/seeds/cocoapodseed = 3,/obj/item/seeds/plumpmycelium = 2,
					/obj/item/seeds/cabbageseed = 3,/obj/item/seeds/grapeseed = 3,/obj/item/seeds/pumpkinseed = 3,/obj/item/seeds/cherryseed = 3,/obj/item/seeds/riceseed = 3)
	contraband = list(
		/obj/item/seeds/libertymycelium = 1,
		/obj/item/seeds/mtearseed = 1,
		/obj/item/seeds/ambrosiavulgarisseed = 1,
		/obj/item/seeds/nettleseed = 1,
		/obj/item/seeds/reishimycelium = 1,
	)
	premium = list(/obj/item/toy/waterflower = 1)

/obj/structure/machinery/vending/hydroseeds/yautja
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	hacking_safety = TRUE

/obj/structure/machinery/vending/hydroseeds/yautja/checking_id()
	return FALSE

/obj/structure/machinery/vending/dinnerware
	name = "\improper Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(/obj/item/tool/kitchen/tray = 8,/obj/item/tool/kitchen/utensil/fork = 6,/obj/item/tool/kitchen/knife = 3,/obj/item/reagent_container/food/drinks/drinkingglass = 8,/obj/item/clothing/suit/chef/classic = 2,/obj/item/reagent_container/food/condiment/saltshaker = 4,/obj/item/reagent_container/food/condiment/peppermill = 4,/obj/item/reagent_container/food/condiment/enzyme = 1,/obj/item/reagent_container/food/condiment = 8)
	contraband = list(/obj/item/tool/kitchen/utensil/spoon = 2,/obj/item/tool/kitchen/utensil/knife = 2,/obj/item/tool/kitchen/rollingpin = 2, /obj/item/tool/kitchen/knife/butcher = 2)

/obj/structure/machinery/vending/dinnerware/yautja
	name = "dinnerplate dispenser"
	desc = "A kitchen and restaurant equipment vendor."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	hacking_safety = TRUE

/obj/structure/machinery/vending/dinnerware/yautja/checking_id()
	return FALSE

/obj/structure/machinery/vending/sovietsoda
	name = "\improper BODA"
	desc = "An old sweet water vending machine, how did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(/obj/item/reagent_container/food/drinks/cans/boda = 30)
	contraband = list(/obj/item/reagent_container/food/drinks/cans/bodaplus = 20)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

// All instances of this vendor will share a single inventory for items in the shared list.
// Meaning, if an item is taken from one vendor, it will not be available in any others as well.
/obj/structure/machinery/vending/shared_vending
	var/list/shared = list()
	var/static/list/shared_products = list()

/obj/structure/machinery/vending/shared_vending/New()
	..()

	build_shared_inventory(shared,0,1)

/obj/structure/machinery/vending/shared_vending/proc/build_shared_inventory(list/productlist,hidden=0,req_coin=0)

	if(delay_product_spawn)
		sleep(15) //Make ABSOLUTELY SURE the seed datum is properly populated.

	var/i = 1

	for(var/typepath in productlist)
		var/amount = productlist[typepath]
		var/price = prices[typepath]
		if(isnull(amount))
			amount = 1

		var/obj/item/temp_path = typepath
		var/datum/data/vending_product/R = shared_products[i]

		if(!R.product_path)
			R.product_path = typepath
			R.amount = amount
			R.price = price

			if(ispath(typepath,/obj/item/weapon/gun) || ispath(typepath,/obj/item/ammo_magazine) || ispath(typepath,/obj/item/explosive/grenade) || ispath(typepath,/obj/item/weapon/gun/flamer) || ispath(typepath,/obj/item/storage) )
				R.display_color = "black"
// else if(ispath(typepath,/obj/item/clothing) || ispath(typepath,/obj/item/storage))
// R.display_color = "green"
// else if(ispath(typepath,/obj/item/reagent_container) || ispath(typepath,/obj/item/stack/medical))
// R.display_color = "blue"
			else
				R.display_color = "white"

		if(hidden)
			R.category=CAT_HIDDEN
			hidden_records += R
		else if(req_coin)
			R.category=CAT_COIN
			coin_records += R
		else
			product_records += R
			R.category = CAT_NORMAL

		if(delay_product_spawn)
			sleep(5) //sleep(1) did not seem to cut it, so here we are.

		R.product_name = initial(temp_path.name)

		i++;
	return

/obj/structure/machinery/vending/walkman
	name = "\improper Rec-Vend"
	desc = "Contains Weyland-Yutani approved recreational items, like Walkmans and Cards."
	icon_state = "walkman"
	product_ads = "The only place to have fun in the entire Marine Corps!;You'll find no better music from here to Arcturus!;Instructions not included with decks of cards!;No volume controls - you don't need them!;All products responsibly made by people having just as much fun as you will be!;Say goodbye to the lucky strike military tobacco monopoly, with the new Weyland Yutani Military Trading Card Gold cigarette pack!"
	vend_delay = 0.5 SECONDS
	idle_power_usage = 200

	products = list(
		/obj/item/device/cassette_tape/pop1 = 10,
		/obj/item/device/cassette_tape/hiphop = 10,
		/obj/item/device/cassette_tape/nam = 10,
		/obj/item/device/cassette_tape/ocean = 10,
		/obj/item/device/cassette_tape/pop3 = 10,
		/obj/item/device/cassette_tape/pop4 = 10,
		/obj/item/device/cassette_tape/pop2 = 10,
		/obj/item/device/cassette_tape/heavymetal = 10,
		/obj/item/device/cassette_tape/hairmetal = 10,
		/obj/item/device/cassette_tape/indie = 10,
		/obj/item/device/walkman = 50,
		/obj/item/storage/pouch/cassette = 15,
		/obj/item/toy/deck = 5,
		/obj/item/toy/deck/uno = 5,
		/obj/item/device/camera = 5,
		/obj/item/device/camera_film = 10,
		/obj/item/notepad = 5,
		/obj/item/device/toner = 5,
		/obj/item/paper/colonial_grunts = 15,
		/obj/item/toy/dice/d20 = 10,
		/obj/item/tool/pen = 10,
		/obj/item/tool/pen/blue = 10,
		/obj/item/tool/pen/red = 10,
		/obj/item/tool/pen/multicolor/fountain = 3,
		/obj/item/storage/fancy/cigarettes/trading_card = 20,
		/obj/item/storage/fancy/trading_card = 20,
		/obj/item/toy/trading_card = 50,

	)

	contraband = list(/obj/item/toy/sword = 2)

	prices = list(
		/obj/item/device/cassette_tape/pop1 = 5,
		/obj/item/device/cassette_tape/hiphop = 5,
		/obj/item/device/cassette_tape/nam = 5,
		/obj/item/device/cassette_tape/ocean = 6,
		/obj/item/device/cassette_tape/pop3 = 5,
		/obj/item/device/cassette_tape/pop4 = 5,
		/obj/item/device/cassette_tape/pop2 = 5,
		/obj/item/device/cassette_tape/heavymetal = 5,
		/obj/item/device/cassette_tape/hairmetal = 5,
		/obj/item/device/cassette_tape/indie = 5,
		/obj/item/device/walkman = 15,
		/obj/item/storage/pouch/cassette = 10,
		/obj/item/toy/deck = 20,
		/obj/item/toy/deck/uno = 15,
		/obj/item/device/camera = 30,
		/obj/item/device/toner = 15,
		/obj/item/paper/colonial_grunts = 5,
		/obj/item/toy/dice/d20 = 1,
		/obj/item/tool/pen = 2,
		/obj/item/tool/pen/blue = 2,
		/obj/item/tool/pen/red = 2,
		/obj/item/tool/pen/multicolor/fountain = 30,
		/obj/item/storage/fancy/cigarettes/trading_card = 30,
		/obj/item/storage/fancy/trading_card = 20,
		/obj/item/toy/trading_card = 5,

	)
	product_type = VENDOR_PRODUCT_TYPE_RECREATIONAL

//vendor of ingredients for kitchen
/obj/structure/machinery/vending/ingredients
	name = "\improper Galley Auxiliary Storage Requisition System"
	desc = "A vending machine meant to be use for cooks."
	product_ads = "If your out of ingredients i am here for you;all my organic produce are fresh;don't let my potatoes go stale time for you to cook some fries"
	icon_state = "snack"
	hacking_safety = TRUE
	products = list(
		/obj/item/storage/fancy/egg_box = 12,
		/obj/item/storage/box/fish = 12,
		/obj/item/storage/box/meat = 12,
		/obj/item/storage/box/milk = 12,
		/obj/item/storage/box/soymilk = 12,
		/obj/item/storage/box/enzyme = 12,
		/obj/item/storage/box/flour = 12,
		/obj/item/storage/box/sugar = 12,
		/obj/item/storage/box/saltshaker = 12,
		/obj/item/storage/box/peppermill = 12,
		/obj/item/storage/box/mint = 12,
		/obj/item/storage/box/apple = 12,
		/obj/item/storage/box/banana = 12,
		/obj/item/storage/box/chanterelle = 12,
		/obj/item/storage/box/cherries = 12,
		/obj/item/storage/box/chili = 12,
		/obj/item/storage/box/cabbage = 12,
		/obj/item/storage/box/carrot = 12,
		/obj/item/storage/box/corn = 12,
		/obj/item/storage/box/eggplant = 12,
		/obj/item/storage/box/lemon = 12,
		/obj/item/storage/box/lime = 12,
		/obj/item/storage/box/orange = 12,
		/obj/item/storage/box/potato = 12,
		/obj/item/storage/box/tomato = 12,
		/obj/item/storage/box/whitebeet = 12,
	)

	prices = list(
		/obj/item/storage/fancy/egg_box = 1,
		/obj/item/storage/box/fish = 1,
		/obj/item/storage/box/meat = 1,
		/obj/item/storage/box/milk =1,
		/obj/item/storage/box/soymilk = 1,
		/obj/item/storage/box/enzyme = 1,
		/obj/item/storage/box/flour = 1,
		/obj/item/storage/box/sugar = 1,
		/obj/item/storage/box/saltshaker = 1,
		/obj/item/storage/box/peppermill = 1,
		/obj/item/storage/box/mint = 1,
		/obj/item/storage/box/apple = 1,
		/obj/item/storage/box/banana = 2,
		/obj/item/storage/box/chanterelle = 2,
		/obj/item/storage/box/cherries = 2,
		/obj/item/storage/box/chili = 2,
		/obj/item/storage/box/cabbage = 2,
		/obj/item/storage/box/carrot = 2,
		/obj/item/storage/box/corn = 2,
		/obj/item/storage/box/eggplant = 2,
		/obj/item/storage/box/lemon = 2,
		/obj/item/storage/box/lime = 2,
		/obj/item/storage/box/orange = 2,
		/obj/item/storage/box/potato = 2,
		/obj/item/storage/box/tomato = 2,
		/obj/item/storage/box/whitebeet = 2,
	)
	product_type = VENDOR_PRODUCT_TYPE_FOOD

/obj/structure/machinery/vending/upp_co
	name = "\improper UnionAraratCorp Automated Commander Uniform Closet"
	desc = "An automated closet hooked up to a colossal storage of standard-issue dress uniform variants."
	icon_state = "dress"
	icon_deny = "dress"
	wrenchable = FALSE
	req_access = list(ACCESS_UPP_LEADERSHIP)
	products = list(
		/obj/item/clothing/under/marine/veteran/UPP/officer = 1,
		/obj/item/clothing/under/marine/veteran/UPP = 1,
		/obj/item/clothing/suit/storage/marine/faction/UPP/kapitan = 1,
		/obj/item/clothing/head/uppcap/beret = 1,
		/obj/item/clothing/head/uppcap/peaked = 1,
		/obj/item/clothing/head/uppcap/ushanka = 1,
		/obj/item/storage/large_holster/ceremonial_sword/full = 1,
	)
