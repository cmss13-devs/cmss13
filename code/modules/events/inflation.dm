
/datum/round_event_control/economy_inflation
	name = "economy inflation"
	typepath = /datum/round_event/economy_inflation
	weight = 10
	earliest_start = 5 MINUTES
	min_players = 1
	max_occurences = 1000
	alert_observers = FALSE
	gamemode_blacklist = list("Whiskey Outpost")

/datum/round_event/economy_inflation
	announce_when = 1 SECONDS
	startWhen = 10 SECONDS
	endWhen = 15 SECONDS
	var/product_type = VENDOR_PRODUCT_TYPE_FOOD
	var/inflation_mult
	var/time_to_update

/datum/round_event/economy_inflation/setup()
	. = ..()
	product_type = pick(ALL_VENDOR_PRODUCT_TYPES)
	var/inflation_decimal = (rand(0, 9) * 0.1)
	inflation_mult = rand(2, 5) + inflation_decimal // example result: 3.5
	time_to_update = rand(3, 9)
	startWhen = time_to_update MINUTES

/datum/round_event/economy_inflation/announce()
	/* You may be thinking 'Why the fuck would W-Y directly send a broadcast to a in-operation vessel and reveal their location to any unseemlies nearby?'
	The answer is they don't, it's a signal sent across entire sectors for every UA-affiliated vessel and colony to take note of when it passes by.
	Colony vendors aren't updated because the colony's network has collapsed. */
	marine_announcement("An encrypted broadband signal from Weyland-Yutani has been recieved notifying us of sudden changes in the UA's economy during cryosleep, due to [get_random_story()], and have requested us to increase the prices of [product_type] products by [get_percentage()]%. This change will come into effect in [time_to_update] minutes.", add_PMCs = FALSE)

/datum/round_event/economy_inflation/start()
	for(var/obj/structure/machinery/vending/vending_machine as anything in GLOB.total_vending_machines)
		if(!is_mainship_level(vending_machine.z))
			continue
		O.speak("Prices have been updated!")
		var/list_len = length(vending_machine.prices)
		var/index = 1
		for(var/price in vending_machine.prices)
			price[index] *= inflation_mult
			index++
			if(index > list_len)
				continue

/datum/round_event/economy_inflation/proc/get_random_story()
	var/list/backstories = list(,
		"A tragic series of accidental factory explosions",
		"public leaks of corporate secrets",
		"a high-profile assassination",
		"a CLF take-over of an important industrial colony",
		"discovery of high levels of an unhealthy chemical",
		"a public scandal involving a corporate chairman and a farm animal",
		"large-scale colony riots",
		"suppressed factory riots over riot responses",
		"CLF bombing of vital industrial colonies",
		"a tense stand-off on several mining stations with UPP insurgents",
		"a publicized Xenomorph infestation",
		"a succession of hostile takeovers by the Company",
		"widespread corporate bankruptcy",
		"pirate takeover of an essential cargo fleet",
		"a large sector of colonized space going dark for unknown reasons", //XX-121,
		"withdrawal of government funding in relevant sectors",
		"a vital Seegson industries space station going dark", // A:I,
		"several mining colonies defecting to the UPP",
		"a critical USCM defeat by CLF insurgents in the Tychon's Rift sector",
		"newly imposed sanctions as a result of corporate investigations",
		"*garbled static*",
		"flaring tensions with Arcturus",
		"a Sol-wide solar flare technological blackout"
		"\[REDACTED\]"
		"the release of a competitor's product",
	)
	return pick(backstories)

/datum/round_event/economy_inflation/proc/get_percentage()
	return (inflation_mult -1) * 100 // example result: 3.5 -> 250%
