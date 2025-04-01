#define HUNTER_BEST_ITEM  pick(\
								75; list(/obj/item/clothing/glasses/night, /obj/item/storage/backpack/holding, /obj/item/storage/belt/grenade/full, /obj/item/weapon/gun/flamer), \
								100; list(/obj/item/weapon/twohanded/yautja/glaive, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/suit/armor/yautja/hunter,/obj/item/clothing/shoes/yautja/hunter), \
								50; list(/obj/item/weapon/yautja/chained/combistick, /obj/item/clothing/mask/gas/yautja/hunter, /obj/item/clothing/suit/armor/yautja/hunter/full,/obj/item/clothing/shoes/yautja/hunter), \
								150; list(/obj/item/stack/medical/advanced/ointment, /obj/item/stack/medical/advanced/bruise_pack, /obj/item/storage/belt/medical/lifesaver/full), \
								50; list(/obj/item/clothing/under/marine/veteran/pmc/commando, /obj/item/clothing/suit/storage/marine/veteran/pmc/commando, /obj/item/clothing/gloves/marine/veteran/pmc/commando, /obj/item/clothing/shoes/veteran/pmc/commando, /obj/item/clothing/head/helmet/marine/veteran/pmc/commando), \
								125; list(/obj/item/weapon/yautja/chain, /obj/item/weapon/yautja/knife, /obj/item/weapon/yautja/scythe, /obj/item/hunting_trap, /obj/item/hunting_trap), \
								75; list(/obj/item/weapon/gun/revolver/mateba/general, /obj/item/ammo_magazine/revolver/mateba, /obj/item/ammo_magazine/revolver/mateba, /obj/item/clothing/mask/balaclava/tactical), \
								50; list(/obj/item/weapon/shield/energy, /obj/item/weapon/energy/axe, /obj/item/clothing/under/chainshirt/hunter, /obj/item/clothing/head/helmet/gladiator, /obj/item/clothing/suit/armor/gladiator) \
								)

#define HUNTER_GOOD_ITEM  pick(\
								50; /obj/item/weapon/shield/riot, \
								100; /obj/item/weapon/sword, \
								100; /obj/item/weapon/sword/katana, \
								100; /obj/item/weapon/harpoon/yautja, \
								150; /obj/item/weapon/sword, \
								200; /obj/item/weapon/sword/machete, \
								125; /obj/item/weapon/twohanded/fireaxe, \
\
								100; /obj/item/device/binoculars, \
\
								50; /obj/item/device/flash, \
								25; /obj/item/explosive/grenade/flashbang, \
								25; /obj/item/hunting_trap, \
								50; /obj/item/explosive/plastic, \
								100; /obj/item/explosive/grenade/high_explosive, \
								100; /obj/item/explosive/grenade/high_explosive/frag, \
								100; /obj/item/explosive/grenade/incendiary, \
\
								170; /obj/item/clothing/suit/armor/vest/security, \
								165; /obj/item/clothing/head/helmet/riot, \
								160; /obj/item/clothing/gloves/marine/veteran/pmc, \
\
								50; /obj/item/storage/firstaid/regular, \
								50; /obj/item/storage/firstaid/fire, \
								75; /obj/item/storage/box/mre/wy, \
\
								100; /obj/item/storage/backpack/commando, \
								100; /obj/item/storage/backpack/yautja, \
								100; /obj/item/storage/belt/knifepouch, \
								100; /obj/item/storage/belt/utility/full, \
								100; /obj/item/clothing/accessory/storage/webbing, \
								)

#define HUNTER_OKAY_ITEM  pick(\
								300; /obj/item/tool/crowbar, \
								200; /obj/item/weapon/baseballbat, \
								100; /obj/item/weapon/baseballbat/metal, \
								100; /obj/item/weapon/butterfly, \
								300; /obj/item/tool/hatchet, \
								100; /obj/item/tool/scythe, \
								100; /obj/item/tool/kitchen/knife/butcher, \
								50; /obj/item/weapon/sword/katana/replica, \
								100; /obj/item/weapon/harpoon, \
								75; /obj/item/attachable/bayonet, \
								200; /obj/item/weapon/throwing_knife, \
								400; /obj/item/weapon/twohanded/spear, \
\
								250; /obj/item/device/flashlight/flare, \
								75; /obj/item/device/flashlight, \
								75; /obj/item/device/flashlight/combat, \
\
								25; /obj/item/bananapeel, \
								25; /obj/item/tool/soap, \
\
								75; /obj/item/stack/medical/bruise_pack, \
								75; /obj/item/stack/medical/ointment, \
								75; /obj/item/reagent_container/food/snacks/donkpocket, \
\
								100; /obj/item/cell/high, \
								100; /obj/item/tool/wirecutters, \
								100; /obj/item/tool/weldingtool, \
								100; /obj/item/tool/wrench, \
								100; /obj/item/device/multitool, \
								75; /obj/item/storage/pill_bottle/tramadol, \
								50; /obj/item/explosive/grenade/smokebomb, \
								50; /obj/item/explosive/grenade/empgrenade, \
								100; /obj/item/storage/backpack, \
								100; /obj/item/storage/backpack/cultpack, \
								100; /obj/item/storage/backpack/satchel, \
								75; /obj/item/clothing/gloves/brown, \
								100; /obj/item/clothing/suit/storage/CMB \
								)

//Digging through this is a pain. I'm leaving it mostly alone until a full rework takes place.

/datum/game_mode/huntergames
	name = "Hunter Games"
	config_tag = "Hunter Games"
	required_players = 1
	flags_round_type = MODE_NO_LATEJOIN
	latejoin_larva_drop = 0 //You never know

	var/checkwin_counter = 0
	var/finished = 0
	var/dropoff_timer = 800 //10 minutes.
	var/last_drop = 0
	var/last_tally
	var/contestants[]
	var/supply_votes[]

	var/ticks_passed = 0
	var/drops_disabled = 0

	var/waiting_for_drop_votes = FALSE

	votable = FALSE // borkeds
	taskbar_icon = 'icons/taskbar/gml_hgames.png'

/obj/effect/step_trigger/hell_hound_blocker/Trigger(mob/living/carbon/xenomorph/hellhound/H)
	if(istype(H))
		H.gib() //No mercy.

/datum/game_mode/huntergames/announce()
	return TRUE

/obj/effect/landmark/hunter_primary
	name = "hunter_primary"
	icon_state = "hunter_primary"

/obj/effect/landmark/hunter_primary/Initialize(mapload, ...)
	. = ..()
	GLOB.hunter_primaries += src

/obj/effect/landmark/hunter_primary/Destroy()
	GLOB.hunter_primaries -= src
	return ..()

/obj/effect/landmark/hunter_secondary
	name = "hunter_secondary"
	icon_state = "hunter_secondary"

/obj/effect/landmark/hunter_secondary/Initialize(mapload, ...)
	. = ..()
	GLOB.hunter_secondaries += src

/obj/effect/landmark/hunter_secondary/Destroy()
	GLOB.hunter_secondaries -= src
	return ..()

/obj/effect/landmark/crap_item
	name = "crap_item"
	icon_state = "item_crap"

/obj/effect/landmark/crap_item/Initialize(mapload, ...)
	. = ..()
	GLOB.crap_items += src

/obj/effect/landmark/crap_item/Destroy()
	GLOB.crap_items -= src
	return ..()

/obj/effect/landmark/good_item
	name = "good_item"
	icon_state = "item_good"

/obj/effect/landmark/good_item/Initialize(mapload, ...)
	. = ..()
	GLOB.good_items += src

/obj/effect/landmark/good_item/Destroy()
	GLOB.good_items -= src
	return ..()

/datum/game_mode/huntergames/pre_setup()
	supply_votes = list()

	for(var/i in GLOB.crap_items)
		place_drop(get_turf(i), "crap")

	for(var/i in GLOB.good_items)
		place_drop(get_turf(i), "good")

	QDEL_LIST(GLOB.xeno_tunnels)

	for(var/G in GLOB.gun_list)
		qdel(G) //No guns or ammo allowed.
	for(var/M in GLOB.ammo_magazine_list)
		qdel(M)

	for(var/mob/new_player/player in GLOB.new_player_list)
		if(player && player.ready)
			if(player.mind)
				player.job = "ROLE"
			else
				if(player.client)
					player.mind = new(player.key)
					player.mind_initialize()
	return ..()

/datum/game_mode/huntergames/post_setup()
	contestants = list()
	for(var/i in GLOB.human_mob_list)
		var/mob/M = i
		if(M.client)
			contestants += M
			spawn_contestant(M)

	CONFIG_SET(flag/remove_gun_restrictions, TRUE) //This will allow anyone to use cool guns.

	spawn(10)
		to_world("<B>The current game mode is - HUNTER GAMES!</B>")
		to_world("You have been dropped off on a Weyland-Yutani colony overrun with alien Predators who have turned it into a game preserve.")
		to_world("And you are both the hunter and the hunted!")
		to_world("Be the <B>last survivor</b> and <B>win glory</B>! Fight in any way you can! Team up or be a loner, it's up to you.")
		to_world("Be warned though - if someone hasn't died in 3 minutes, the watching Predators get irritated!")
		world << sound('sound/effects/siren.ogg')

	spawn(1000)
		loop_package()

	return ..()

/datum/game_mode/huntergames/proc/spawn_contestant(mob/M)

	var/mob/living/carbon/human/H
	var/turf/picked

	if(length(GLOB.hunter_primaries))
		picked = get_turf(pick_n_take(GLOB.hunter_primaries))
	else
		if(length(GLOB.hunter_secondaries))
			picked = get_turf(pick_n_take(GLOB.hunter_secondaries))
		else
			message_admins("There were no spawn points available for a contestant.")

	if(QDELETED(picked)) //???
		message_admins("Warning, null picked spawn in spawn_contestant")
		return 0

	if(istype(M,/mob/living/carbon/human)) //somehow?
		H = M
		if(length(H.contents))
			for(var/obj/item/I in H.contents)
				qdel(I)
		H.forceMove(picked)
	else
		H = new(picked)

	H.key = M.key
	if(H.client)
		H.client.change_view(GLOB.world_view_size)

	if(!H.mind)
		H.mind = new(H.key)
		H.mind_initialize()

	H.name = H.real_name

	H.skills = null //no restriction on what the contestants can do

	H.KnockDown(15)
	H.Stun(15)
	H.nutrition = NUTRITION_NORMAL

	var/randjob = rand(0,10)
	switch(randjob)
		if(0) //colonial marine
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
		if(1) //MP
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/mp(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
		if(2) //Commander!
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/officer/command(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/dress/commander(H), WEAR_FEET)
		if(3) //CL
			H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
		if(4) //pmc!
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/pmc(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/pmc(H), WEAR_FACE)
		if(5) //Merc!
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/dutch(H), WEAR_BODY)
			if(prob(50))
				H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), WEAR_HANDS)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
			if(prob(75))
				M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), WEAR_FEET)
			else
				M.equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots(M), WEAR_FEET)
		if(6)//BEARS!!
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/veteran/bear(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine(H), WEAR_FEET)
			H.remove_language(LANGUAGE_ENGLISH)
			H.add_language(LANGUAGE_RUSSIAN)
		if(7) //Assassin!
			H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
		if(8) //Corporate guy
			H.equip_to_slot_or_del(new /obj/item/clothing/under/liaison_suit(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/wcoat(H), WEAR_JACKET)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), WEAR_FEET)
		if(9) //Colonial Marshal
			H.equip_to_slot_or_del(new /obj/item/clothing/under/CM_uniform(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), WEAR_FEET)

	H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/general(H), WEAR_R_STORE)

	//Give them some information
	spawn(4)
		to_chat(H, "<h2>There can be only one!!</h2>")
		to_chat(H, "Use the flare in your pocket to light the way!")
	return 1

/datum/game_mode/huntergames/proc/loop_package()
	while(finished == 0)
		if(!drops_disabled)
			to_world(SPAN_ROUNDBODY("Your Predator capturers have decided it is time to bestow a gift upon the scurrying humans."))
			to_world(SPAN_ROUNDBODY("One lucky contestant should prepare for a supply drop in 60 seconds."))
			for(var/mob/dead/D in GLOB.dead_mob_list)
				to_chat(D, SPAN_ROUNDBODY("Now is your chance to vote for a supply drop beneficiary! Go to Ghost tab, Spectator Vote!"))
			world << sound('sound/effects/alert.ogg')
			last_drop = world.time
			waiting_for_drop_votes = 1
			sleep(600)
			if(!length(supply_votes))
				to_world(SPAN_ROUNDBODY("Nobody got anything! .. weird."))
				waiting_for_drop_votes = 0
				supply_votes = list()
			else
				var/mob/living/carbon/human/winner = pick(supply_votes) //Way it works is, more votes = more odds of winning. But not guaranteed.
				if(istype(winner) && !winner.stat)
					to_world(SPAN_ROUNDBODY("The spectator and Predator votes have been tallied, and the supply drop recipient is <B>[winner.real_name]</B>! Congrats!"))
					world << sound('sound/effects/alert.ogg')
					to_world(SPAN_ROUNDBODY("The package will shortly be dropped off at: [get_area(winner.loc)]."))
					var/turf/drop_zone = locate(winner.x + rand(-2,2),winner.y + rand(-2,2),winner.z)
					if(istype(drop_zone))
						playsound(drop_zone,'sound/effects/bamf.ogg', 50, 1)
						place_drop(drop_zone,"god", 1)
				else
					to_world(SPAN_ROUNDBODY("The spectator and Predator votes have been talled, and the supply drop recipient is dead or dying<B>. Bummer.</b>"))
					world << sound('sound/misc/sadtrombone.ogg')
				supply_votes = list()
				waiting_for_drop_votes = 0
		sleep(5000)

/datum/game_mode/huntergames/process()
	. = ..()
	checkwin_counter++
	ticks_passed++
	if(prob(2))
		dropoff_timer += ticks_passed //Increase the timer the longer the round goes on.

	if(round_started > 0) //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.
		round_started--

	if(checkwin_counter >= 10) //Only check win conditions every 5 ticks.
		if(!finished)
			check_win()
		checkwin_counter = 0
	return 0

/datum/game_mode/huntergames/check_win()
	var/C = count_humans()
	if(C < last_tally)
		if(last_tally - C == 1)
			to_world(SPAN_ROUNDBODY("A contestant has died! There are now [C] contestants remaining!"))
			world << sound('sound/effects/explosionfar.ogg')
		else
			var/diff = last_tally - C
			to_world(SPAN_ROUNDBODY("Multiple contestants have died! [diff] in fact. [C] are left!"))
			spawn(7) world << sound('sound/effects/explosionfar.ogg')

	last_tally = C
	if(last_tally == 1 || ismob(last_tally))
		finished = 1
	else if (last_tally < 1)
		finished = 2
	else
		finished = 0

/datum/game_mode/huntergames/proc/count_humans()
	var/human_count = 0

	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(istype(H) && H.stat == 0 && !istype(get_area(H.loc),/area/centcom) && !istype(get_area(H.loc),/area/tdome))
			if(H.species != "Yautja") // Preds don't count in round end.
				human_count += 1 //Add them to the amount of people who're alive.

	return human_count

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/huntergames/check_finished()
	if(finished != 0)
		return 1

	return 0


//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relevant information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/huntergames/declare_completion()
	if(GLOB.round_statistics)
		GLOB.round_statistics.track_round_end()
	var/mob/living/carbon/winner = null

	for(var/mob/living/carbon/human/Q in GLOB.alive_mob_list)
		if(istype(Q) && Q.stat == 0 && !isyautja(Q) && !istype(get_area(Q.loc),/area/centcom) && !istype(get_area(Q.loc),/area/tdome))
			winner = Q
			break

	if(finished == 1 && !QDELETED(winner) && istype(winner))
		to_world(SPAN_DANGER("<FONT size = 4><B>We have a winner! >> [winner.real_name] ([winner.key]) << defeated all enemies!</B></FONT>"))
		to_world("<FONT size = 3><B>Well done, your tale of survival will live on in legend!</B></FONT>")

	else if(finished == 2)
		to_world(SPAN_DANGER("<FONT size = 4><B>NOBODY WON!?</B></FONT>"))
		to_world("<FONT size = 3><B>'Somehow you stupid humans managed to even fuck up killing yourselves. Well done.'</B></FONT>")
		world << 'sound/misc/sadtrombone.ogg'
	else
		to_world(SPAN_DANGER("<FONT size = 4><B>NOBODY WON!</B></FONT>"))
		to_world("<FONT size = 3><B>There was a winner, but they died before they could receive the prize!! Bummer.</B></FONT>")
		world << 'sound/misc/sadtrombone.ogg'

	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.end_round_player_population = count_humans()

		GLOB.round_statistics.log_round_statistics()
		GLOB.round_statistics.save()

	return 1

/datum/game_mode/proc/auto_declare_completion_huntergames()
	return

/datum/game_mode/huntergames/proc/place_drop(turf/T, OT = "crap", in_crate)
	if(!istype(T))
		return FALSE

	if(OT == "good" && !in_crate && prob(15))
		in_crate = 1 //Place some good drops in crates.

	var/obj_type //Object path.
	var/atom/location = in_crate ? new /obj/structure/closet/crate(T) : T //Where it's going to be placed.

	switch(OT)
		if("god")
			var/L[] = HUNTER_BEST_ITEM
			for(obj_type in L)
				new obj_type(location)
		if("good")
			obj_type = HUNTER_GOOD_ITEM
			new obj_type(location)
		else
			obj_type = HUNTER_OKAY_ITEM
			new obj_type(location)

#undef HUNTER_BEST_ITEM
#undef HUNTER_GOOD_ITEM
#undef HUNTER_OKAY_ITEM
