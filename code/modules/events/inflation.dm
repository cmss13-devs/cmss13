/datum/round_event_control/economy_inflation
	name = "Economy Inflation"
	typepath = /datum/round_event/economy_inflation
	weight = 10 // probably could use some defines in the future - EVENT_UNLIKELY, EVENT_COMMON, etc.
	earliest_start = 5 MINUTES
	min_players = 1
	max_occurrences = 1 // we can increase the number once there's more random events around - 3 is a good number
	alert_observers = FALSE
	gamemode_blacklist = list(GAMEMODE_WHISKEY_OUTPOST, GAMEMODE_HIVE_WARS)

/datum/round_event/economy_inflation
	announce_when = 1
	startWhen = 10
	endWhen = 15
	/// The event will modify all vendors of this specific product type.
	var/product_type = VENDOR_PRODUCT_TYPE_FOOD
	/// The multiplier for increasing prices of the above.
	var/inflation_mult
	/// Used in the announcement and in setup to indicate when it will start.
	var/time_to_update

/datum/round_event/economy_inflation/setup()
	. = ..()
	product_type = pick(ALL_VENDOR_PRODUCT_TYPES)
	var/inflation_decimal = (rand(0, 9) * 0.1)
	inflation_mult = rand(1, 3) + inflation_decimal // example result: 3.5
	time_to_update = rand(2, 4) // minutes
	startWhen = time_to_update * 60 // MINUTES - these already are seconds so it'd multiply by 600
	endWhen = time_to_update * 60 + 10 // SECONDS

/datum/round_event/economy_inflation/announce()
	/* You may be thinking 'Why the fuck would W-Y directly send a broadcast to a in-operation vessel and reveal their location to any hostiles nearby?'
	The answer is they don't, it's a signal sent across entire sectors for every UA-affiliated vessel and colony to take note of when it passes by.
	Colony vendors aren't updated because the colony's network has collapsed. */
	if(GLOB.security_level >= SEC_LEVEL_RED)
		return
	shipwide_ai_announcement("An encrypted broadband signal from Weyland-Yutani has been received notifying the sector of sudden changes in the UA's economy during cryosleep, due to [get_random_story()], and have requested UA vessels to increase the prices of [product_type] products by [get_percentage()]%. This change will come into effect in [time_to_update] minutes.", quiet = TRUE)

/datum/round_event/economy_inflation/start()
	for(var/obj/structure/machinery/vending/vending_machine as anything in GLOB.total_vending_machines)
		if(!is_mainship_level(vending_machine.z) || vending_machine.product_type != product_type)
			continue
		vending_machine.speak("Prices have been updated!")
		playsound(vending_machine, 'sound/machines/twobeep.ogg', 25, TRUE)
		var/display_records = vending_machine.product_records + vending_machine.hidden_records + vending_machine.coin_records
		for(var/datum/data/vending_product/product in display_records)
			product.price *= inflation_mult

/**
 *  Returns a random backstory 'incident' as the cause for the sudden price hike.
 */
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
		"a succession of hostile takeovers by major corporate entities",
		"widespread corporate bankruptcy",
		"pirate takeover of an essential cargo fleet",
		"a large sector of colonized space going dark for unknown reasons", //XX-121,
		"withdrawal of government funding in relevant sectors",
		"a vital Seegson industries space station going dark", // A:I,
		"several mining colonies defecting to the UPP",
		"a critical USCM defeat by CLF insurgents in the Tychon's Rift sector",
		"newly imposed sanctions as a result of corporate investigations",
		"flaring tensions with Arcturus",
		"a Sol-wide solar flare technological blackout",
		"\[REDACTED\]",
		"the release of a competitor's product",
	)
	return pick(backstories)

/datum/round_event/economy_inflation/proc/get_percentage()
	return (inflation_mult - 1) * 100 // example result: 3.5 -> 250%
