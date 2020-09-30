/obj/structure/machinery/computer/arcade
	name = "Black Donnovan II: Double Revenge"
	desc = "Two years after the average high school teenager Josh transformed into the powerful ninja 'Black Donnovan' and defeated the evil forces of Colonel Ranchenko and his UPP experiments to save his captured ninja girlfriend Reino, chaos is unleashed again on the world. Josh's Canadian cousin, transforming into the powerful ninja 'Fury Fuhrer', has created a world in Florida no longer exists. Josh once again transforms into 'Black Donnovan' to fight against Fury Fuhrer's legions of goons and restore the hellscape world to its former glory."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "arcade"
	circuit = /obj/item/circuitboard/computer/arcade
	unacidable = FALSE
	density = TRUE
	var/enemy_name = "Fury Fuhrer"
	var/temp = "Sponsored by Weston-Yamada and the United States Colonial Marines" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 50 //Enemy health/attack points
	var/enemy_mp = 25
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	var/list/prizes = list(	/obj/item/storage/box/MRE			    = 3,
							/obj/item/spacecash/c10					= 4,
							/obj/item/ammo_magazine/flamer_tank			    = 1,
							/obj/item/tool/lighter/zippo			= 2,
							/obj/item/tool/weldingtool					= 1,
							/obj/item/storage/box/uscm_mre			= 2,
							/obj/item/device/camera				        	= 2,
							/obj/item/device/camera_film					= 4,
							/obj/item/cell/crap/empty				= 3,
							/obj/item/tool/hand_labeler					= 1
							)

/obj/structure/machinery/computer/arcade
	var/turtle = 0

/obj/structure/machinery/computer/arcade/attack_remote(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/machinery/computer/arcade/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_interaction(src)
	var/dat = "<a href='byond://?src=\ref[src];close=1'>Close</a>"
	dat += "<center><h4>[src.enemy_name]</h4></center>"

	dat += "<br><center><h3>[src.temp]</h3></center>"
	dat += "<br><center>Health: [src.player_hp]|Magic: [src.player_mp]|Enemy Health: [src.enemy_hp]</center>"

	if (src.gameover)
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>New Game</a>"
	else
		dat += "<center><b><a href='byond://?src=\ref[src];attack=1'>Attack</a>|"
		dat += "<a href='byond://?src=\ref[src];heal=1'>Heal</a>|"
		dat += "<a href='byond://?src=\ref[src];charge=1'>Recharge Power</a>"

	dat += "</b></center>"

	show_browser(user, dat, name, "arcade")
	return

/obj/structure/machinery/computer/arcade/Topic(href, href_list)
	if(..())
		return

	if (!src.blocked && !src.gameover)
		if (href_list["attack"])
			src.blocked = 1
			var/attackamt = rand(2,6)
			src.temp = "Your sword strikes for [attackamt] damage!"
			src.updateUsrDialog()
			if(turtle > 0)
				turtle--

			sleep(10)
			src.enemy_hp -= attackamt
			src.arcade_action()

		else if (href_list["heal"])
			src.blocked = 1
			var/pointamt = rand(1,3)
			var/healamt = rand(6,8)
			src.temp = "You use [pointamt] magic to heal for [healamt] damage!"
			src.updateUsrDialog()
			turtle++

			sleep(10)
			src.player_mp -= pointamt
			src.player_hp += healamt
			src.blocked = 1
			src.updateUsrDialog()
			src.arcade_action()

		else if (href_list["charge"])
			src.blocked = 1
			var/chargeamt = rand(4,7)
			src.temp = "You regain [chargeamt] points"
			src.player_mp += chargeamt
			if(turtle > 0)
				turtle--

			src.updateUsrDialog()
			sleep(10)
			src.arcade_action()

	if (href_list["close"])
		usr.unset_interaction()
		close_browser(usr, "arcade")

	else if (href_list["newgame"]) //Reset everything
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return

/obj/structure/machinery/computer/arcade/proc/arcade_action()
	if ((src.enemy_mp <= 0) || (src.enemy_hp <= 0))
		if(!gameover)
			src.gameover = 1
			src.temp = "[src.enemy_name] has fallen! Rejoice!"

			if(!contents.len)
				var/prizeselect = pickweight(prizes)
				new prizeselect(src.loc)

				if(istype(prizeselect, /obj/item/toy/gun)) //Ammo comes with the gun
					new /obj/item/toy/gun_ammo(src.loc)

				else if(istype(prizeselect, /obj/item/clothing/suit/syndicatefake)) //Helmet is part of the suit
					new	/obj/item/clothing/head/syndicatefake(src.loc)

			else
				var/atom/movable/prize = pick(contents)
				prize.loc = src.loc

	else if ((src.enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		src.temp = "[src.enemy_name] steals [stealamt] of your power!"
		src.player_mp -= stealamt
		src.updateUsrDialog()

		if (src.player_mp <= 0)
			src.gameover = 1
			sleep(10)
			src.temp = "You have been drained! GAME OVER"

	else if ((src.enemy_hp <= 10) && (src.enemy_mp > 4))
		src.temp = "[src.enemy_name] heals for 4 health!"
		src.enemy_hp += 4
		src.enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		src.temp = "[src.enemy_name] attacks for [attackamt] damage!"
		src.player_hp -= attackamt

	if ((src.player_mp <= 0) || (src.player_hp <= 0))
		src.gameover = 1
		src.temp = "GAME OVER"

	src.blocked = 0
	return

/obj/structure/machinery/computer/arcade/emp_act(severity)
	if(inoperable())
		..(severity)
		return
	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(0,2)
	for(num_of_prizes; num_of_prizes > 0; num_of_prizes--)
		empprize = pickweight(prizes)
		new empprize(src.loc)

	..(severity)
