/*************************************
----------------COMMANDER--------------
*************************************/

/datum/job/command/commander/whiskey
	title = "Ground Commander"
	comm_title = "CDR"
	idtype = /obj/item/card/id/dogtag

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/command,
				WEAR_FEET = /obj/item/clothing/shoes/marinechief/commander,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/techofficer/commander,
				WEAR_WAIST = /obj/item/storage/belt/gun/mateba/full,
				WEAR_HEAD = /obj/item/clothing/head/beret/cm/tan,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_JACKET = /obj/item/clothing/suit/storage/marine/MP/RO,
				WEAR_R_STORE = /obj/item/storage/pouch/general/large
				)
	generate_stored_equipment()
		. = list(
				WEAR_L_HAND = /obj/item/device/binoculars,
				WEAR_J_STORE = /obj/item/weapon/claymore/mercsword/commander
				)

	generate_entry_message()
		. = {"Your job is HEAVY ROLE PLAY and requires you to stay IN CHARACTER at all times.
The local population warned you about establishing a base in the jungles of LV-624...
Hold the outpost for one hour until the distress beacon can be broadcast to the remaining Dust Raiders!
Coordinate your team and prepare defenses, whatever wiped out the patrols is en-route!
Count on your Gunnery Seargent, and your Honor Guard Squad Leader to assist you!
Stay alive, and Godspeed, commander!"}

	announce_entry_message(mob/living/carbon/human/H)
		if(..())
			return
		sleep(15)
		if(H && H.loc && flags_startup_parameters & ROLE_ADD_TO_MODE) captain_announcement.Announce("All forces, Ground Commander [H.real_name] is in command!")


/*************************************
----------------SYNTHETIC-------------
*************************************/

/datum/job/civilian/synthetic/whiskey
	title = "Support Synthetic"
	comm_title = "Syn"

	generate_wearable_equipment()
		. = list(
				WEAR_HEAD = /obj/item/clothing/head/beret/cm,
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/rank/synthetic,
				WEAR_JACKET = /obj/item/clothing/suit/storage/RO,
				WEAR_FEET = /obj/item/clothing/shoes/brown,
				WEAR_WAIST = /obj/item/storage/belt/utility/full,
				WEAR_HANDS = /obj/item/clothing/gloves/yellow,
				WEAR_ACCESSORY = /obj/item/clothing/tie/storage/brown_vest,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel/medic,
				WEAR_R_STORE = /obj/item/storage/pouch/construction/full,
				WEAR_L_STORE = /obj/item/storage/pouch/general/medium
				)


	generate_entry_message()
		. = {"You are a Synthetic! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal.
You were deployed alongside the Dust Raiders to assist in engineering, medical, and diplomatic duties. Things seem to have taken a turn for the worst.
Assist the humans in sending a signal to the remaining Dust Raiders on board the USS Alistoun, to inform them of the threat.
Destruction in inevitable. At the very least, you can assist in preventing others from sharing the same fate."}


/*************************************
---------EXECUITIVE OFFICER-----------
*************************************/
/datum/job/command/executive/whiskey
	title = "Lieutendant Commander"
	comm_title = "LCDR"
	paygrade = "LCDR"
	idtype = /obj/item/card/id/dogtag


	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/exec,
				WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
				WEAR_WAIST = /obj/item/storage/belt/gun/m4a3/vp70,
				WEAR_HEAD = /obj/item/clothing/head/cmcap,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_R_STORE = /obj/item/storage/pouch/general/large
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You've been with the commander for as long as you can remember. You've always been the bookish nerd to the Honor Guard Squad Leader's jock; as such, you're the commander's right-hand man.
Assist the commander in ensuring that Whiskey Outpost stands long enough for a distress signal to be sent out.
Make the USCM proud!"}


/*************************************
----------------CMP-------------
*************************************/

//Chief MP
/datum/job/command/warrant/whiskey
	title = "Honor Guard Squad Leader"
	comm_title = "HGSL"
	paygrade = "E9"
	selection_color = "#ffaaaa"
	idtype = /obj/item/card/id/dogtag
	skills_type = /datum/skills/honor_guard/lead
	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/bridge,
				WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/veteran/PMC,
				WEAR_WAIST = /obj/item/storage/large_holster/m39/full,
				WEAR_JACKET = /obj/item/clothing/suit/storage/marine/smartgunner,
				WEAR_HEAD = /obj/item/clothing/head/beret/marine/chiefofficer,
				WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
				WEAR_L_HAND = /obj/item/smartgun_powerpack,
				WEAR_R_STORE = /obj/item/storage/pouch/bayonet/full,
				WEAR_L_STORE = /obj/item/storage/pouch/magazine/large/pmc_m39
				)

	generate_stored_equipment()
		. = list(
				WEAR_J_STORE = /obj/item/weapon/gun/smartgun,
				WEAR_IN_BACK = /obj/item/clothing/glasses/night/m56_goggles
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"The Commander is the best hope for this outpost! At least in your eyes. You two have saved each-other's asses enough times to testify to that, and have been together for longer than anyone cares to remember. You're his left-hand man, behind the Gunnery Sergeant. You two are men. Manly men.
Your veterans have lived enough years that they are able to command others using the overwatch consoles, but the young ones are still fresh out of boot camp - it's your job to shape 'em up into proper soldiers!
You must lead his Honor guard, his elite unit of marines, to protect the commander, and ensure victory!
"}


/*************************************
-------------STAFF OFFICER------------
*************************************/
/datum/job/command/bridge/whiskey
	title = "Veteran Honor Guard"
	disp_title = "Veteran Honor Guard"
	comm_title = "VHG"
	paygrade = "E8"
	idtype = /obj/item/card/id/dogtag
	skills_type = /datum/skills/honor_guard/vet

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/bridge,
				WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/officer,
				WEAR_WAIST = /obj/item/storage/belt/marine/m41amk1,
				WEAR_JACKET = /obj/item/clothing/suit/storage/marine/leader,
				WEAR_EYES = /obj/item/clothing/glasses/sunglasses/aviator,
				WEAR_HEAD = /obj/item/clothing/head/beret/sec/alt,
				WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
				WEAR_R_STORE = /obj/item/storage/pouch/bayonet/full,
				WEAR_R_STORE = /obj/item/storage/pouch/general/medium
				)

	generate_stored_equipment()
		. = list(
				WEAR_J_STORE = /obj/item/weapon/gun/rifle/m41aMK1,
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You were assigned to guard the commander in this hostile enviroment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You've survived through enough battles that you've been entrusted with more training, and can use overwatch consoles, as well as give orders.
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
Glory to the commander. Glory to the USCM."}


/*************************************
------------TANK CREWMAN----------
*************************************/
/datum/job/command/tank_crew/whiskey
	title = "Honor Guard Specialist"
	comm_title = "HGS"
	paygrade = "E8E"
	idtype = /obj/item/card/id/dogtag
	skills_type = /datum/skills/honor_guard/spec

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/bridge,
				WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
				WEAR_WAIST = /obj/item/storage/large_holster/m39/full,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/officer,
				WEAR_EYES = /obj/item/clothing/glasses/sunglasses/aviator,
				WEAR_HEAD = /obj/item/clothing/head/beret/marine/logisticsofficer,
				WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
				WEAR_R_STORE = /obj/item/storage/pouch/general/medium,
				WEAR_L_STORE = /obj/item/storage/pouch/magazine/large/pmc_m39,
				)
	generate_stored_equipment()
		. = list(
				WEAR_R_HAND = /obj/item/spec_kit
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You were assigned to guard the commander in this hostile enviroment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
You've been through much, and as such, have been given special-weapons training. Use it well.
Glory to the commander. Glory to the USCM."}


/*************************************
------------MILITARY POLICE----------
*************************************/
/datum/job/command/police/whiskey
	title = "Honor Guard"
	comm_title = "HG"
	paygrade = "E7"
	idtype = /obj/item/card/id/dogtag
	skills_type = /datum/skills/honor_guard

	generate_wearable_equipment()
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/bridge,
				WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/officer,
				WEAR_WAIST = /obj/item/storage/belt/shotgun/full,
				WEAR_JACKET = /obj/item/clothing/suit/storage/marine/leader,
				WEAR_EYES = /obj/item/clothing/glasses/sunglasses/aviator,
				WEAR_HEAD = /obj/item/clothing/head/beret/marine/logisticsofficer,
				WEAR_BACK = /obj/item/storage/backpack/satchel/sec,
				WEAR_R_STORE = /obj/item/storage/pouch/bayonet/full,
				WEAR_L_STORE = /obj/item/storage/pouch/general/medium
				)
	generate_stored_equipment()
		. = list(
				WEAR_J_STORE = /obj/item/weapon/gun/shotgun/combat,
				WEAR_IN_BACK = /obj/item/storage/firstaid/regular
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You were assigned to guard the commander in this hostile enviroment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
Glory to the commander. Glory to the USCM."}


/*************************************
----------------PILOT----------------
*************************************/
/datum/job/command/pilot/whiskey
	title = "Mortar Crew"
	comm_title = "MC"
	paygrade = "E3"
	skills_type = /datum/skills/mortar_crew
	idtype = /obj/item/card/id/dogtag

	generate_wearable_equipment()
		. = list(
				WEAR_HEAD = /obj/item/clothing/head/beret/eng,
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mt,
				WEAR_BODY = /obj/item/clothing/under/marine/engineer,
				WEAR_FEET = /obj/item/clothing/shoes/marine/knife,
				WEAR_HANDS = /obj/item/clothing/gloves/black,
				WEAR_WAIST = /obj/item/storage/belt/gun/m4a3/vp70,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_R_STORE = /obj/item/storage/pouch/general/large,
				WEAR_L_STORE = /obj/item/device/binoculars/tactical/range
				)

	generate_stored_equipment()
		. = list(
				WEAR_L_HAND = /obj/item/clothing/glasses/sunglasses,
				)

	get_wearable_equipment()
		var/L[] = list(
						WEAR_HEAD = /obj/item/clothing/glasses/sunglasses
						)

		return generate_wearable_equipment() + L

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You're entrusted with the maintaining of the mortars for the outpost. You were expecting to bomb some CLF, maybe, but not this...
Listen in on your radio, and pay attention to provide fire support for the marines. Watch out for friendly-fire!"}


/*************************************
---------REQUISITIONS OFFICER--------
*************************************/
/datum/job/logistics/requisition/whiskey
	title = "Quartermaster"
	comm_title = "QM"
	paygrade = "E8"

	generate_wearable_equipment(mob/living/carbon/human/H)
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/marine/officer/logistics,
				WEAR_FEET = /obj/item/clothing/shoes/marine,
				WEAR_HANDS = /obj/item/clothing/gloves/marine/techofficer,
				WEAR_WAIST = /obj/item/storage/belt/gun/m44/full,
				WEAR_HEAD = /obj/item/clothing/head/cmcap/req,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_R_STORE = /obj/item/storage/pouch/general/large
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"This is YOUR Depot - ain't no body, marine or monster, are gonna have their way with it.
Ensure that supplies are rationed out, and not wasted. Other outposts will send you what they can, so make it count!
You can order bunker crew to assist you, in place of proper cargo technicians."}


/*************************************
--------CHIEF MEDICAL OFFICER--------
*************************************/
/datum/job/civilian/professor/whiskey
	title = "Head Surgeon"
	comm_title = "HS"

	generate_entry_message()
		. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, guide triage, and survive for as long as possible."}


/*************************************
----------------DOCTOR---------------
*************************************/
/datum/job/civilian/doctor/whiskey
	title = "Field Doctor"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, perform triage, and survive for as long as possible."}


/*************************************
---------------RESEARCHER-------------
*************************************/
/datum/job/civilian/researcher/whiskey
	title = "Chemist"
	disp_title = "Chemist"
	comm_title = "Chem"

	generate_wearable_equipment(mob/living/carbon/human/H)
		. = list(
				WEAR_EAR = /obj/item/device/radio/headset/almayer/doc,
				WEAR_BODY = /obj/item/clothing/under/rank/medical/purple,
				WEAR_FEET = /obj/item/clothing/shoes/laceup,
				WEAR_HANDS = /obj/item/clothing/gloves/latex,
				WEAR_JACKET = /obj/item/clothing/suit/storage/labcoat/researcher,
				WEAR_EYES = /obj/item/clothing/glasses/hud/health,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel,
				WEAR_R_STORE = /obj/item/storage/pouch/medical,
				WEAR_L_STORE = /obj/item/storage/pouch/syringe
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You volunteered to help produce medicine, and perform tests on the local wildlife, to see if it was safe for consumption. That may have been a mistake.
Hey, at least now, you can try out all those chems that are outlawed - not like there's anyone to enforce the law, here, anyways."}


/*************************************
------------CHIEF ENGINEER-----------
*************************************/
/datum/job/logistics/engineering/whiskey
	title = "Bunker Crew Master"
	comm_title = "BCM"
	paygrade = "E8"
	generate_wearable_equipment(mob/living/carbon/human/H)
		. = list(
				WEAR_HEAD = /obj/item/clothing/head/beret/eng,
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_EYES = /obj/item/clothing/glasses/welding,
				WEAR_BODY = /obj/item/clothing/under/marine/engineer,
				WEAR_FEET = /obj/item/clothing/shoes/marine,
				WEAR_HANDS = /obj/item/clothing/gloves/yellow,
				WEAR_WAIST = /obj/item/storage/belt/utility/full,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel/tech,
				WEAR_R_STORE = /obj/item/storage/pouch/construction/full,
				WEAR_L_STORE = /obj/item/storage/pouch/construction/full
				)

	generate_stored_equipment()
		. = list(
				WEAR_L_HAND = /obj/item/device/binoculars/tactical/range,
				WEAR_IN_BACK = /obj/item/tool/shovel/etool/folded
				)

	generate_stored_equipment()
		. = list()

	generate_entry_message(mob/living/carbon/human/H)
		. = {"Everything in this bunker is yours. At least, you act like it is. You and your men keep it well maintained. You're not gonna let any filthy aliens take it.
Ensure power is up, and the bunker is well defended. You share your bunker crew with the Quartermaster."}


/*************************************
---------------MAINT TECH-------------
*************************************/
/datum/job/logistics/tech/maint/whiskey
	title = "Bunker Crew"
	comm_title = "BC"
	supervisors = "the bunker crew master and the quartermaster"
	paygrade = "E4"

	generate_wearable_equipment(mob/living/carbon/human/H)
		. = list(
				WEAR_HEAD = /obj/item/clothing/head/beret/eng,
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mt,
				WEAR_EYES = /obj/item/clothing/glasses/welding,
				WEAR_BODY = /obj/item/clothing/under/marine/engineer,
				WEAR_FEET = /obj/item/clothing/shoes/marine,
				WEAR_HANDS = /obj/item/clothing/gloves/yellow,
				WEAR_WAIST = /obj/item/storage/belt/utility/full,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel/tech,
				WEAR_R_STORE = /obj/item/storage/pouch/construction/full,
				WEAR_L_STORE = /obj/item/storage/pouch/construction/full
				)

	generate_stored_equipment()
		. = list(
				WEAR_L_HAND = /obj/item/device/binoculars/tactical/range,
				WEAR_IN_BACK = /obj/item/tool/shovel/etool/folded
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You've worked here for a while, figuring it was a pretty comfy job. Now you gotta fight for your life. Have fun with that.
Assist both the Bunker Crew Master and the Quartermaster in their duties."}


/*************************************
--------------CARGO TECH-------------
*************************************/
/datum/job/logistics/tech/cargo/whiskey
	title = "Bunker Crew Logistics"
	comm_title = "BCL"
	supervisors = "the bunker crew master and the quartermaster"
	selection_color = "#BAAFD9"
	access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	minimal_access = list(ACCESS_IFF_MARINE, ACCESS_MARINE_ENGINEERING, ACCESS_CIVILIAN_ENGINEERING)
	skills_type = /datum/skills/CE
	paygrade = "E4"
	generate_wearable_equipment(mob/living/carbon/human/H)
		. = list(
				WEAR_HEAD = /obj/item/clothing/head/beret/eng,
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mt,
				WEAR_EYES = /obj/item/clothing/glasses/welding,
				WEAR_BODY = /obj/item/clothing/under/marine/engineer,
				WEAR_FEET = /obj/item/clothing/shoes/marine,
				WEAR_HANDS = /obj/item/clothing/gloves/yellow,
				WEAR_WAIST = /obj/item/storage/belt/utility/full,
				WEAR_BACK = /obj/item/storage/backpack/marine/satchel/tech,
				WEAR_R_STORE = /obj/item/storage/pouch/construction/full,
				WEAR_L_STORE = /obj/item/storage/pouch/construction/full
				)

	generate_stored_equipment()
		. = list(
				WEAR_L_HAND = /obj/item/device/binoculars/tactical/range,
				WEAR_IN_BACK = /obj/item/tool/shovel/etool/folded
				)

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You've worked here for a while, figuring it was a pretty comfy job. Now you gotta fight for your life. Have fun with that.
Assist both the Bunker Crew Master and the Quartermaster in their duties."}


//Giving the liason a role on whiskey outpost! Nothing can go wrong here. N o t h i n g.
/*************************************
-----------------LIASON---------------
*************************************/
/datum/job/civilian/liaison/whiskey
	title = "Combat Reporter"
	comm_title = "PRESS"
	supervisors = "the press"
	idtype = /obj/item/card/id

	generate_wearable_equipment()
		. = list(
				WEAR_HEAD = /obj/item/clothing/head/fedora,
				WEAR_EAR = /obj/item/device/radio/headset/almayer/mcom,
				WEAR_BODY = /obj/item/clothing/under/liaison_suit/suspenders,
				WEAR_FEET = /obj/item/clothing/shoes/laceup,
				WEAR_BACK = /obj/item/storage/backpack/satchel
				)
	generate_stored_equipment()
		. = list(
				WEAR_L_HAND = /obj/item/device/camera,
				WEAR_IN_BACK = /obj/item/device/camera_film,
				WEAR_IN_BACK = /obj/item/device/binoculars,
				WEAR_IN_BACK = /obj/item/device/taperecorder,
				WEAR_IN_BACK = /obj/item/device/megaphone
				)
	generate_entry_message(mob/living/carbon/human/H)
		. = {"What a scoop! You followed the marines down to LV-624 to see what kinda mischief they'd get into down here, but it seems that trouble has come to them!
This could be the story of the world! 'Brave Marines in brutal combat with unknown hostile alien lifeforms!' It'd surely get Mr. Parkerson to notice you in the office if you brought him a story like this!
You just gotta get out of this jungle to tell the tale!"}
//N O T H I N G.


//Stupid dumb snowflake job code doesn't work well when jobs have the same title, so unlike the neat things we did above,
//We gotta do this BS for squaddies, because equipping checks job titles and nothing else.

/datum/game_mode/whiskey_outpost/proc/spawn_player(var/mob/M)
	set waitfor = 0 //Doing this before hand.
	var/mob/living/carbon/human/H
	var/list/spawns = list()
	if(istype(M,/mob/living/carbon/human)) //If We started on Sulaco as squad marine
		H = M
	for(var/obj/effect/landmark/start/whiskey/W in world)
		if(W.name == "Marine")
			spawns += W
	var/obj/P = pick(spawns)
	H.loc = P.loc
	H.key = M.key
	if(H.client) H.client.change_view(world.view)
	if(!H.mind)
		H.mind = new(H.key)
	H.nutrition = 400
	//Squad ID and backpack are already spawned in job datum
	switch(H.mind.assigned_role)
		if("Squad Leader")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/leader(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/leader(H), WEAR_JACKET)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41amk1(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41aMK1(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/whiskey_supply_beacon(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/map/whiskey_outpost_map(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/binoculars/designator(H), WEAR_IN_BACK)

		//SQUAD SPECIALIST
		if("Squad Specialist")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/tie/storage/webbing(H), WEAR_IN_BACK)

			H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/pistol(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/spec_kit, WEAR_R_HAND)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)

		//SQUAD SMARTGUNNER
		if("Squad Smartgunner")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine/smartgunner(H), WEAR_JACKET)
			H.equip_to_slot_or_del(new /obj/item/smartgun_powerpack(H), WEAR_R_HAND)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/night/m56_goggles(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smartgun(H), WEAR_J_STORE)

			//Backup SMG Weapon
			H.equip_to_slot_or_del(new /obj/item/storage/large_holster/m39/full(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/magazine/large/pmc_m39(H), WEAR_L_STORE)

		//SQUAD ENGINEER
		if("Squad Engineer")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/engineer(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/tech(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
			H.equip_to_slot_or_del(new /obj/item/storage/backpack/marine/engineerpack(H), WEAR_BACK)
			H.equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow(H), WEAR_HANDS)
			H.equip_to_slot_or_del(new /obj/item/device/binoculars/tactical/range(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/tool/shovel/etool/folded(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/full(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/welding(H), WEAR_EYES)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_R_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/construction/full(H), WEAR_L_STORE)
			generate_random_marine_primary(H)
		//SQUAD MEDIC
		if("Squad Medic")
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine/medic(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine/medic(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
			if(prob(50))
				H.equip_to_slot_or_del(new /obj/item/clothing/mask/surgical(H), WEAR_FACE)
			H.equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/storage/firstaid/adv(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/device/defibrillator(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/combatLifesaver(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), WEAR_EYES)
			H.equip_to_slot_or_del(new /obj/item/storage/pouch/medkit/full(H), WEAR_L_STORE)
			generate_random_marine_primary(H)
		else
			H.equip_to_slot_or_del(new /obj/item/clothing/under/marine(H), WEAR_BODY)
			H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/marine(H), WEAR_L_HAND)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/marine(H), WEAR_JACKET)
			generate_random_marine_primary(H)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/flare/full(H), WEAR_R_STORE)
	H.equip_to_slot_or_del(new /obj/item/storage/pouch/firstaid/full(H), WEAR_L_STORE)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/combat(H), WEAR_HANDS)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/self_setting(H), WEAR_EAR)
	H.equip_to_slot_or_del(new /obj/item/storage/box/attachments(H), WEAR_IN_BACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/marine/knife(H), WEAR_FEET)
		//Give them some information
	sleep(40)
	H << "________________________"
	H << "<span class='boldnotice'>You are the [H.mind.assigned_role]!</span>"
	H << "Gear up, prepare defenses, work as a team. Protect your doctors and commander!"
	H << "Motion trackers have detected movement from local creatures, and they are heading towards the outpost!"
	H << "Hold the outpost for one hour until the signal can be established!"
	H << "Ensure the Dust Raiders don't lose their foothold on LV-624 so you can alert the main forces."
	H << "________________________"

	return 1

/datum/game_mode/whiskey_outpost/proc/generate_random_marine_primary(var/mob/living/carbon/human/H, shuffle = rand(0,10))
	switch(shuffle)
		if(0 to 4)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/rifle/m41a(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m41a(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/rifle(H), WEAR_IN_BACK)
		if(5,7)
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/smg/m39(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/marine/m39(H), WEAR_WAIST)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
			H.equip_to_slot_or_del(new /obj/item/ammo_magazine/smg/m39(H), WEAR_IN_BACK)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/gun/shotgun/pump(H), WEAR_J_STORE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/shotgun/full(H), WEAR_WAIST)
	return

//Er, no. I'm not gonna try to find a way to make every marine spawn with the proper headset. This is easier.
/*************************************
-----SELF SETTING MARINE HEADSET-----
*************************************/
/obj/item/device/radio/headset/almayer/marine/self_setting/New()
	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		if(H.assigned_squad)
			switch(H.assigned_squad.name)
				if("Alpha")
					name = "alpha radio headset"
					desc = "This is used by  alpha squad members."
					icon_state = "sec_headset"
					frequency = ALPHA_FREQ
				if("Bravo")
					name = "bravo radio headset"
					desc = "This is used by bravo squad members."
					icon_state = "eng_headset"
					frequency = BRAVO_FREQ
				if("Charlie")
					name = "charlie radio headset"
					desc = "This is used by charlie squad members."
					icon_state = "charlie_headset"
					frequency = CHARLIE_FREQ
				if("Delta")
					name = "delta radio headset"
					desc = "This is used by delta squad members."
					icon_state = "com_headset"
					frequency = DELTA_FREQ
			switch(H.mind.assigned_role)
				if("Squad Leader")
					name = "squad leader" + name
					keyslot2 = new /obj/item/device/encryptionkey/squadlead(src)
				if("Squad Medic")
					name = "squad medic" + name
					keyslot2 = new /obj/item/device/encryptionkey/med(src)
				if("Squad Engineer")
					name = "squad engineer" + name
					keyslot2 = new /obj/item/device/encryptionkey/engi(src)
	..()
