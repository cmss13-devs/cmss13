//*************************************
//----------------COMMANDER--------------
//*************************************/

/datum/job/command/commander/whiskey
	title = JOB_WO_CO
	gear_preset = /datum/equipment_preset/wo/commander

/datum/job/command/commander/whiskey/generate_entry_message()
	. = {"Your job is HEAVY ROLE PLAY and requires you to stay IN CHARACTER at all times.
The local population warned you about establishing a base in the jungles of LV-624...
Hold the outpost for one hour until the distress beacon can be broadcast to the remaining Dust Raiders!
Coordinate your team and prepare defenses, whatever wiped out the patrols is en-route!
Count on your Lieutenant Commander, and your Honor Guard Squad Leader to assist you!
Stay alive, and Godspeed, commander!"}

/datum/job/command/commander/whiskey/announce_entry_message(mob/living/carbon/human/H)
	if(..())
		return
	sleep(15)
	if(H?.loc)
		marine_announcement("All forces, Ground Commander [H.real_name] is in command!")



//*************************************
//----------------SYNTHETIC-------------
//*************************************/

/datum/job/civilian/synthetic/whiskey
	title = JOB_WO_SYNTH
	gear_preset = /datum/equipment_preset/synth/uscm/wo

/datum/job/civilian/synthetic/whiskey/generate_entry_message()
	. = {"You are a Synthetic! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal.
You were deployed alongside the Dust Raiders to assist in engineering, medical, and diplomatic duties. Things seem to have taken a turn for the worst.
Assist the humans in sending a signal to the remaining Dust Raiders on board the USS Alistoun, to inform them of the threat.
Destruction in inevitable. At the very least, you can assist in preventing others from sharing the same fate."}


//*************************************
//---------EXECUITIVE OFFICER-----------
//*************************************/
/datum/job/command/executive/whiskey
	title = JOB_WO_XO
	gear_preset = /datum/equipment_preset/wo/xo

/datum/job/command/executive/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You've been with the commander for as long as you can remember. You've always been the bookish nerd to the Honor Guard Squad Leader's jock; as such, you're the commander's right-hand man.
Assist the commander in ensuring that Whiskey Outpost stands long enough for a distress signal to be sent out.
Make the USCM proud!"}


//*************************************
//----------------CMP-------------
//*************************************/

//Chief MP
/datum/job/command/warrant/whiskey
	title = JOB_WO_CHIEF_POLICE
	selection_class = "job_honor_guard_sl"
	gear_preset = /datum/equipment_preset/wo/cmp

/datum/job/command/warrant/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"The Commander is the best hope for this outpost! At least in your eyes. You two have saved each-other's asses enough times to testify to that, and have been together for longer than anyone cares to remember. You're his left-hand man, behind the Lieutenant Commander. You two are men. Manly men.
Your veterans have lived enough years that they are able to command others using the overwatch consoles, but the young ones are still fresh out of boot camp - it's your job to shape 'em up into proper soldiers!
You must lead his Honor guard, his elite unit of marines, to protect the commander, and ensure victory!
"}


//*************************************
//-------------STAFF OFFICER------------
//*************************************/
/datum/job/command/bridge/whiskey
	title = JOB_WO_SO
	gear_preset = /datum/equipment_preset/wo/vhg

/datum/job/command/bridge/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You were assigned to guard the commander in this hostile environment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You've survived through enough battles that you've been entrusted with more training, and can use overwatch consoles, as well as give orders.
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
Glory to the commander. Glory to the USCM."}


//*************************************
//----------------CREWMAN---------------
//*************************************/
/datum/job/command/tank_crew/whiskey
	title = JOB_WO_CREWMAN
	gear_preset = /datum/equipment_preset/wo/hgs

/datum/job/command/tank_crew/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You were assigned to guard the commander in this hostile environment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
You've been through much, and as such, have been given special-weapons training. Use it well.
Glory to the commander. Glory to the USCM."}


//*************************************
//------------MILITARY POLICE----------
//*************************************/
/datum/job/command/police/whiskey
	title = JOB_WO_POLICE
	gear_preset = /datum/equipment_preset/wo/hg

/datum/job/command/police/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You were assigned to guard the commander in this hostile environment; that hasn't changed. Ensure your extra training and equipment isn't wasted!
You're expected to defend not only the commander, but the bunker at large; leave the outside defenses to the marines.
Glory to the commander. Glory to the USCM."}


//*************************************
//----------------PILOT----------------
//*************************************/
/datum/job/command/pilot/whiskey
	title = JOB_WO_PILOT
	gear_preset = /datum/equipment_preset/wo/mortar_crew

/datum/job/command/pilot/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You're entrusted with the maintaining of the mortars for the outpost. You were expecting to bomb some CLF, maybe, but not this...
Listen in on your radio, and pay attention to provide fire support for the marines. Watch out for friendly-fire!"}


//*************************************
//---------REQUISITIONS OFFICER--------
//*************************************/
/datum/job/logistics/requisition/whiskey
	title = JOB_WO_CHIEF_REQUISITION
	gear_preset = /datum/equipment_preset/wo/quartermaster

/datum/job/logistics/requisition/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"This is YOUR Depot - ain't no body, marine or monster, are gonna have their way with it.
Ensure that supplies are rationed out, and not wasted. Other outposts will send you what they can, so make it count!
You can order bunker crew to assist you, in place of proper cargo technicians."}


//*************************************
//--------CHIEF MEDICAL OFFICER--------
//*************************************/
/datum/job/civilian/professor/whiskey
	title = JOB_WO_CMO
	gear_preset = /datum/equipment_preset/wo/head_surgeon

/datum/job/civilian/professor/whiskey/generate_entry_message()
	. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, guide triage, and survive for as long as possible."}


//*************************************
//----------------DOCTOR---------------
//*************************************/
/datum/job/civilian/doctor/whiskey
	title = JOB_WO_DOCTOR
	gear_preset = /datum/equipment_preset/wo/doctor
	job_options = null //Does not inherit regular doctor's variants, uses unique preset instead.

/datum/job/civilian/doctor/whiskey/handle_job_options()
	return

/datum/job/civilian/doctor/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, perform triage, and survive for as long as possible."}


//*************************************
//---------------RESEARCHER-------------
//*************************************/
/datum/job/civilian/researcher/whiskey
	title = JOB_WO_RESEARCHER
	gear_preset = /datum/equipment_preset/wo/chemist

/datum/job/civilian/researcher/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You volunteered to help produce medicine, and perform tests on the local wildlife, to see if it was safe for consumption. That may have been a mistake.
Hey, at least now, you can try out all those chems that are outlawed - not like there's anyone to enforce the law, here, anyways."}


//*************************************
//------------CHIEF ENGINEER-----------
//*************************************/
/datum/job/logistics/engineering/whiskey
	title = JOB_WO_CHIEF_ENGINEER
	gear_preset = /datum/equipment_preset/wo/bcm

/datum/job/logistics/engineering/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"Everything in this bunker is yours. At least, you act like it is. You and your men keep it well maintained. You're not gonna let any filthy aliens take it.
Ensure power is up, and the bunker is well defended. You share your bunker crew with the Quartermaster."}


//*************************************
//---------------MAINT TECH-------------
//*************************************/
/datum/job/logistics/tech/maint/whiskey
	title = JOB_WO_ORDNANCE_TECH
	supervisors = "the bunker crew master and the quartermaster"
	gear_preset = /datum/equipment_preset/wo/bc

/datum/job/logistics/tech/maint/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You've worked here for a while, figuring it was a pretty comfy job. Now you gotta fight for your life. Have fun with that.
Assist both the Bunker Crew Master and the Quartermaster in their duties."}


//*************************************
//--------------CARGO TECH-------------
//*************************************/
/datum/job/logistics/cargo/whiskey
	title = JOB_WO_REQUISITION
	supervisors = "the bunker crew master and the quartermaster"
	selection_class = "job_bunker_crew"
	gear_preset = /datum/equipment_preset/wo/cargo


/datum/job/logistics/cargo/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"You've worked here for a while, figuring it was a pretty comfy job. Now you gotta fight for your life. Have fun with that.
Assist both the Bunker Crew Master and the Quartermaster in their duties."}


//Giving the liaison a role on whiskey outpost! Nothing can go wrong here. N o t h i n g.
//*************************************
//-----------------LIAISON---------------
//*************************************/
/datum/job/civilian/liaison/whiskey
	title = JOB_WO_CORPORATE_LIAISON
	supervisors = "the press"
	gear_preset = /datum/equipment_preset/wo/reporter

/datum/job/civilian/liaison/whiskey/generate_entry_message(mob/living/carbon/human/H)
	. = {"What a scoop! You followed the marines down to LV-624 to see what kinda mischief they'd get into down here, but it seems that trouble has come to them!
This could be the story of the world! 'Brave Marines in brutal combat with unknown hostile alien lifeforms!' It'd surely get Mr. Parkerson to notice you in the office if you brought him a story like this!
You just gotta get out of this jungle to tell the tale!"}

//this calls  self-setting headsets for marines AFTER they are assigned squads
/datum/game_mode/whiskey_outpost/proc/self_set_headset(mob/living/carbon/human/H)
	if(!istype(H))
		return
	var/obj/item/device/radio/headset/almayer/marine/self_setting/headset = H.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine/self_setting)
	if(headset)
		headset.self_set()
