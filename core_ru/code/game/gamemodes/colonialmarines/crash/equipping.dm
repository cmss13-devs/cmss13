//*************************************
//----------------COMMANDER--------------
//*************************************/

/datum/job/command/commander/crash
	title = JOB_CRASH_CO
	gear_preset = /datum/equipment_preset/crash/commander
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED

/datum/job/command/commander/crash/generate_entry_message()
	. = {"Your job is HEAVY ROLE PLAY and requires you to stay IN CHARACTER at all times.
Hold the ship, get all disks and purrifier device!
Coordinate your team and prepare defenses, whatever wiped out the patrols is en-route!
Stay alive, and Godspeed, commander!"}

/datum/job/command/commander/crash/announce_entry_message(mob/living/carbon/human/H)
	if(..())
		return
	sleep(15)
	if(H && H.loc)
		marine_announcement("All forces, Commander [H.real_name] is in command!")

//*************************************
//----------------SYNTHETIC-------------
//*************************************/

/datum/job/civilian/synthetic/crash
	title = JOB_CRASH_SYNTH
	gear_preset = /datum/equipment_preset/synth/uscm/crash
	flags_startup_parameters = ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN

/datum/job/civilian/synthetic/crash/generate_entry_message()
	. = {"You are a Synthetic! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal.
You were deployed alongside to assist in engineering, medical, and diplomatic duties. Things seem to have taken a turn for the worst.
Destruction in inevitable. At the very least, you can assist in preventing others from sharing the same fate."}

//*************************************
//--------CHIEF MEDICAL OFFICER--------
//*************************************/

/datum/job/civilian/professor/crash
	title = JOB_CRASH_CMO
	gear_preset = /datum/equipment_preset/crash/head_surgeron
	flags_startup_parameters = ROLE_ADMIN_NOTIFY

/datum/job/civilian/professor/crash/generate_entry_message()
	. = {"You volunteered to assist ground-side with medical duties. That may have been a mistake.
Treat the wounded, guide triage, and survive for as long as possible."}

//*************************************
//------------CHIEF ENGINEER-----------
//*************************************/

/datum/job/logistics/engineering/crash
	title = JOB_CRASH_CHIEF_ENGINEER
	gear_preset = /datum/equipment_preset/crash/bcm
	flags_startup_parameters = ROLE_ADMIN_NOTIFY

/datum/job/logistics/engineering/crash/generate_entry_message(mob/living/carbon/human/H)
	. = {"Everything in this ship is yours. At least, you act like it is. You and your men keep it well maintained. You're not gonna let any filthy aliens take it.
Ensure power is up, and the ship is well defended. You share your ship crew."}


//*************************************
//---------------MARINES---------------
//*************************************/

/datum/job/marine/standard/crash
	title = JOB_CRASH_SQUAD_MARINE
	total_positions = 16
	spawn_positions = 16
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine

/datum/job/marine/specialist/crash
	title = JOB_CRASH_SQUAD_SPECIALIST
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/spec

/datum/job/marine/smartgunner/crash
	title = JOB_CRASH_SQUAD_SMARTGUNNER
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/sg

/datum/job/marine/medic/crash
	title = JOB_CRASH_SQUAD_MEDIC
	total_positions = 3
	spawn_positions = 3
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/medic

/datum/job/marine/leader/crash
	title = JOB_CRASH_SQUAD_LEADER
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/sl

/datum/job/marine/engineer/crash
	title = JOB_CRASH_SQUAD_ENGINEER
	total_positions = 3
	spawn_positions = 3
	flags_startup_parameters = ROLE_ADD_TO_SQUAD
	gear_preset = /datum/equipment_preset/crash/marine/engineer
