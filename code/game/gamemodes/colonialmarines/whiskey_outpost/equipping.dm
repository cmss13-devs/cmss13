/*************************************
----------------COMMANDER--------------
*************************************/

/datum/job/command/commander/whiskey
	title = "Ground Commander"
	gear_preset = "WO Ground Commander"

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
		if(H && H.loc && flags_startup_parameters & ROLE_ADD_TO_MODE) marine_announcement("All forces, Ground Commander [H.real_name] is in command!")


/*************************************
----------------SYNTHETIC-------------
*************************************/

/datum/job/civilian/synthetic/whiskey
	title = "Support Synthetic"
	gear_preset = "WO Support Synthetic"

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
	gear_preset = "WO Lieutendant Commander"

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
	selection_class = "job_honor_guard_sl"
	gear_preset = "WO Honor Guard Squad Leader"

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
	gear_preset = "WO Veteran Honor Guard"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You were assigned to guard the commander in this hostile enviroment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You've survived through enough battles that you've been entrusted with more training, and can use overwatch consoles, as well as give orders.
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
Glory to the commander. Glory to the USCM."}


/*************************************
----------------CREWMAN---------------
*************************************/
/datum/job/command/tank_crew/whiskey
	title = "Honor Guard Specialist"
	gear_preset = "WO Honor Guard Specialist"

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
	gear_preset = "WO Honor Guard"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You were assigned to guard the commander in this hostile enviroment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
Glory to the commander. Glory to the USCM."}


/*************************************
----------------PILOT----------------
*************************************/
/datum/job/command/pilot/whiskey
	title = "Mortar Crew"
	gear_preset = "WO Mortar Crew"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You're entrusted with the maintaining of the mortars for the outpost. You were expecting to bomb some CLF, maybe, but not this...
Listen in on your radio, and pay attention to provide fire support for the marines. Watch out for friendly-fire!"}


/*************************************
---------REQUISITIONS OFFICER--------
*************************************/
/datum/job/logistics/requisition/whiskey
	title = "Quartermaster"
	gear_preset = "WO Quartermaster"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"This is YOUR Depot - ain't no body, marine or monster, are gonna have their way with it.
Ensure that supplies are rationed out, and not wasted. Other outposts will send you what they can, so make it count!
You can order bunker crew to assist you, in place of proper cargo technicians."}


/*************************************
--------CHIEF MEDICAL OFFICER--------
*************************************/
/datum/job/civilian/professor/whiskey
	title = "Head Surgeon"
	gear_preset = "WO Head Surgeon"

	generate_entry_message()
		. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, guide triage, and survive for as long as possible."}


/*************************************
----------------DOCTOR---------------
*************************************/
/datum/job/civilian/doctor/whiskey
	title = "Field Doctor"
	gear_preset = "WO Field Doctor"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, perform triage, and survive for as long as possible."}


/*************************************
---------------RESEARCHER-------------
*************************************/
/datum/job/civilian/researcher/whiskey
	title = "Chemist"
	gear_preset = "WO Chemist"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You volunteered to help produce medicine, and perform tests on the local wildlife, to see if it was safe for consumption. That may have been a mistake.
Hey, at least now, you can try out all those chems that are outlawed - not like there's anyone to enforce the law, here, anyways."}


/*************************************
------------CHIEF ENGINEER-----------
*************************************/
/datum/job/logistics/engineering/whiskey
	title = "Bunker Crew Master"
	gear_preset = "WO Bunker Crew Master"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"Everything in this bunker is yours. At least, you act like it is. You and your men keep it well maintained. You're not gonna let any filthy aliens take it.
Ensure power is up, and the bunker is well defended. You share your bunker crew with the Quartermaster."}


/*************************************
---------------MAINT TECH-------------
*************************************/
/datum/job/logistics/tech/maint/whiskey
	title = "Bunker Crew"
	supervisors = "the bunker crew master and the quartermaster"
	gear_preset = "WO Bunker Crew"

	generate_entry_message(mob/living/carbon/human/H)
		. = {"You've worked here for a while, figuring it was a pretty comfy job. Now you gotta fight for your life. Have fun with that.
Assist both the Bunker Crew Master and the Quartermaster in their duties."}


/*************************************
--------------CARGO TECH-------------
*************************************/
/datum/job/logistics/tech/cargo/whiskey
	title = "Bunker Crew Logistics"
	supervisors = "the bunker crew master and the quartermaster"
	selection_class = "job_bunker_crew"
	gear_preset = "WO Bunker Crew Logistics"


	generate_entry_message(mob/living/carbon/human/H)
		. = {"You've worked here for a while, figuring it was a pretty comfy job. Now you gotta fight for your life. Have fun with that.
Assist both the Bunker Crew Master and the Quartermaster in their duties."}


//Giving the liaison a role on whiskey outpost! Nothing can go wrong here. N o t h i n g.
/*************************************
-----------------LIAISON---------------
*************************************/
/datum/job/civilian/liaison/whiskey
	title = "Combat Reporter"
	supervisors = "the press"
	gear_preset = "WO Combat Reporter"

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
	H = M
	for(var/obj/effect/landmark/start/whiskey/W in world)
		if(W.name == "Marine")
			spawns += W
	for(var/L in latewhiskey)
		spawns += L
	if(spawns.len > 0)
		var/obj/P = pick(spawns)
		H.loc = P.loc
		H.key = M.key
	if(!H.loc)
		var/T = pick(latewhiskey)
		H.loc = T
	if(H.client) H.client.change_view(world_view_size)
	if(!H.mind)
		H.mind = new(H.key)
		H.mind_initialize()

	//Squad ID and backpack are already spawned in job datum
	switch(H.job)
		if("Squad Leader")
			arm_equipment(H, "WO Dust Raider Squad Leader", FALSE, TRUE)
		//SQUAD SPECIALIST
		if("Squad Specialist")
			arm_equipment(H, "WO Dust Raider Squad Specialist", FALSE, TRUE)
		//SQUAD SMARTGUNNER
		if("Squad Smartgunner")
			arm_equipment(H, "WO Dust Raider Squad Smartgunner", FALSE, TRUE)
		//SQUAD ENGINEER
		if("Squad Engineer")
			arm_equipment(H, "WO Dust Raider Squad Engineer", FALSE, TRUE)
		//SQUAD MEDIC
		if("Squad Medic")
			arm_equipment(H, "WO Dust Raider Squad Medic", FALSE, TRUE)
		else
			arm_equipment(H, "WO Dust Raider Squad Marine (PFC)", FALSE, TRUE)

	//Give them some information
	sleep(40)
	to_chat(H, "________________________")
	to_chat(H, SPAN_BOLDNOTICE("You are the [H.job]!"))
	to_chat(H, "Gear up, prepare defenses, work as a team. Protect your doctors and commander!")
	to_chat(H, "Motion trackers have detected movement from local creatures, and they are heading towards the outpost!")
	to_chat(H, "Hold the outpost for one hour until the signal can be established!")
	to_chat(H, "Ensure the Dust Raiders don't lose their foothold on LV-624 so you can alert the main forces.")
	to_chat(H, "________________________")

	return 1

//Er, no. I'm not gonna try to find a way to make every marine spawn with the proper headset. This is easier.
/*************************************
-----SELF SETTING MARINE HEADSET-----
*************************************/
/obj/item/device/radio/headset/almayer/marine/self_setting/New()
	if(istype(loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		if(H.assigned_squad)
			switch(H.assigned_squad.name)
				if(SQUAD_NAME_1)
					name = "[SQUAD_NAME_1] radio headset"
					desc = "This is used by  [SQUAD_NAME_1] squad members."
					icon_state = "alpha_headset"
					frequency = ALPHA_FREQ
				if(SQUAD_NAME_2)
					name = "[SQUAD_NAME_2] radio headset"
					desc = "This is used by [SQUAD_NAME_2] squad members."
					icon_state = "bravo_headset"
					frequency = BRAVO_FREQ
				if(SQUAD_NAME_3)
					name = "[SQUAD_NAME_3] radio headset"
					desc = "This is used by [SQUAD_NAME_3] squad members."
					icon_state = "charlie_headset"
					frequency = CHARLIE_FREQ
				if(SQUAD_NAME_4)
					name = "[SQUAD_NAME_4] radio headset"
					desc = "This is used by [SQUAD_NAME_4] squad members."
					icon_state = "delta_headset"
					frequency = DELTA_FREQ
			switch(H.job)
				if(JOB_SQUAD_LEADER)
					name = "squad leader " + name
					keyslot2 = new /obj/item/device/encryptionkey/squadlead(src)
				if(JOB_SQUAD_MEDIC)
					name = "squad medic " + name
					keyslot2 = new /obj/item/device/encryptionkey/med(src)
				if(JOB_SQUAD_ENGI)
					name = "squad engineer " + name
					keyslot2 = new /obj/item/device/encryptionkey/engi(src)
	..()
