///////////////////// LANDMARK CORPSE ///////


//These are meant for spawning on maps, namely Away Missions.

/obj/effect/landmark/corpsespawner
	name = "Unknown"
	icon_state = "corpse_spawner"
	var/equip_path = null

/obj/effect/landmark/corpsespawner/Initialize(mapload, ...)
	. = ..()
	GLOB.corpse_spawns += src

/obj/effect/landmark/corpsespawner/Destroy()
	GLOB.corpse_spawns -= src
	return ..()

///////////Civilians//////////////////////

/obj/effect/landmark/corpsespawner/prisoner
	name = "Prisoner"
	equip_path = /datum/equipment_preset/corpse/prisoner

/obj/effect/landmark/corpsespawner/chef
	name = "Chef"
	equip_path = /datum/equipment_preset/corpse/chef

/obj/effect/landmark/corpsespawner/doctor
	name = "Doctor"
	equip_path = /datum/equipment_preset/corpse/doctor

/obj/effect/landmark/corpsespawner/engineer
	name = "Engineer"
	equip_path = /datum/equipment_preset/corpse/engineer

/obj/effect/landmark/corpsespawner/scientist
	name = "Scientist"
	equip_path = /datum/equipment_preset/corpse/scientist

/obj/effect/landmark/corpsespawner/miner
	name = "Shaft Miner"
	equip_path = /datum/equipment_preset/corpse/miner

/obj/effect/landmark/corpsespawner/security
	name = "Security Officer"
	equip_path = /datum/equipment_preset/corpse/security

/obj/effect/landmark/corpsespawner/security/marshal
	name = "Colonial Marshal Deputy"
	equip_path = /datum/equipment_preset/corpse/security/cmb

/obj/effect/landmark/corpsespawner/security/marshal/riot
	name = "CMB Riot Control Officer"
	equip_path = /datum/equipment_preset/corpse/security/cmb/riot

/obj/effect/landmark/corpsespawner/security/liaison
	name = "Corporate Liaison"
	equip_path = /datum/equipment_preset/corpse/liaison

/obj/effect/landmark/corpsespawner/prison_security
	name = "Prison Guard"
	equip_path = /datum/equipment_preset/corpse/prison_guard

/////////////////Officers//////////////////////

/obj/effect/landmark/corpsespawner/bridgeofficer
	name = "Colony Division Manager"
	equip_path = /datum/equipment_preset/corpse/manager

/obj/effect/landmark/corpsespawner/administrator
	name = "Colony Administrator"
	equip_path = /datum/equipment_preset/corpse/administrator

/obj/effect/landmark/corpsespawner/administrator/burst
	name = "Burst Colony Administrator"
	equip_path = /datum/equipment_preset/corpse/administrator/burst

/obj/effect/landmark/corpsespawner/wysec
	name = "Weyland-Yutani Corporate Security Guard"
	equip_path = /datum/equipment_preset/corpse/wysec

/obj/effect/landmark/corpsespawner/wygoon
	name = "Weyland-Yutani Corporate Security Officer"
	equip_path = /datum/equipment_preset/corpse/pmc/goon

/obj/effect/landmark/corpsespawner/wygoon/lead
	name = "Weyland-Yutani Corporate Security Lead"
	equip_path = /datum/equipment_preset/corpse/pmc/goon/lead

/obj/effect/landmark/corpsespawner/wygoon/lead/burst
	name = "Burst Weyland-Yutani Corporate Security Lead"
	equip_path = /datum/equipment_preset/corpse/pmc/goon/lead/burst

/obj/effect/landmark/corpsespawner/wygoon/kutjevo
	name = "Weyland-Yutani Kutjevo Corporate Security"
	equip_path = /datum/equipment_preset/corpse/pmc/goon/kutjevo

/obj/effect/landmark/corpsespawner/wygoon/trijent
	name = "Weyland-Yutani Trijent Corporate Security"
	equip_path = /datum/equipment_preset/corpse/pmc/goon/trijent

/obj/effect/landmark/corpsespawner/wygoon/lead/trijent
	name = "Weyland-Yutani Trijent Corporate Security Lead"
	equip_path = /datum/equipment_preset/corpse/pmc/goon/lead/trijent


///CM specific jobs///

/obj/effect/landmark/corpsespawner/colonist //default is a colonist
	name = "Colonist"
	equip_path = /datum/equipment_preset/corpse/colonist

/obj/effect/landmark/corpsespawner/colonist/burst
	name = "Burst Colonist"
	equip_path = /datum/equipment_preset/corpse/colonist/burst

/obj/effect/landmark/corpsespawner/colonist/kutjevo
	name = "Colonist Kutjevo"
	equip_path = /datum/equipment_preset/corpse/colonist/kutjevo

/obj/effect/landmark/corpsespawner/colonist/kutjevo/burst
	name = "Burst Colonist Kutjevo"
	equip_path = /datum/equipment_preset/corpse/colonist/kutjevo/burst

/obj/effect/landmark/corpsespawner/colonist/random
	name = "Colonist Random"
	equip_path = /datum/equipment_preset/corpse/colonist/random

/obj/effect/landmark/corpsespawner/colonist/random/burst
	name = "Burst Colonist Random"
	equip_path = /datum/equipment_preset/corpse/colonist/random/burst

/obj/effect/landmark/corpsespawner/ua_riot
	name = "UA Officer"
	equip_path = /datum/equipment_preset/corpse/ua_riot

/obj/effect/landmark/corpsespawner/ua_riot/burst
	name = "Burst UA Officer"
	equip_path = /datum/equipment_preset/corpse/ua_riot/burst

/obj/effect/landmark/corpsespawner/wy/manager
	name = "Corporate Supervisor"
	equip_path = /datum/equipment_preset/corpse/wy/manager

/obj/effect/landmark/corpsespawner/wy/manager/burst
	name = "Burst Corporate Supervisor"
	equip_path = /datum/equipment_preset/corpse/wy/manager/burst


///////////Faction Specific Corpses//////////////////////

/obj/effect/landmark/corpsespawner/clf
	name = "Colonial Liberation Front Soldier"
	equip_path = /datum/equipment_preset/corpse/clf

/obj/effect/landmark/corpsespawner/clf/burst
	name = "Burst Colonial Liberation Front Soldier"
	equip_path = /datum/equipment_preset/corpse/clf/burst

/obj/effect/landmark/corpsespawner/upp
	name = "Union of Progressive Peoples Soldier"
	equip_path = /datum/equipment_preset/corpse/upp

/obj/effect/landmark/corpsespawner/upp/burst
	name = "Burst Union of Progressive Peoples Soldier"
	equip_path = /datum/equipment_preset/corpse/upp/burst

/obj/effect/landmark/corpsespawner/pmc
	name = "Weyland-Yutani PMC (Standard)"
	equip_path = /datum/equipment_preset/corpse/pmc

/obj/effect/landmark/corpsespawner/pmc/burst
	name = "Burst Weyland-Yutani PMC (Standard)"
	equip_path = /datum/equipment_preset/corpse/pmc/burst

/obj/effect/landmark/corpsespawner/freelancer
	name = "Freelancer"
	equip_path = /datum/equipment_preset/corpse/freelancer

/obj/effect/landmark/corpsespawner/freelancer/burst
	name = "Burst Freelancer"
	equip_path = /datum/equipment_preset/corpse/freelancer/burst

// Fun Faction Corpse

/obj/effect/landmark/corpsespawner/realpirate
	name = "Pirate"
	equip_path = /datum/equipment_preset/corpse/realpirate

/obj/effect/landmark/corpsespawner/realpirate/ranged
	name = "Pirate Gunner"
	equip_path = /datum/equipment_preset/corpse/realpirate/ranged

/obj/effect/landmark/corpsespawner/russian
	name = "Russian"
	equip_path = /datum/equipment_preset/corpse/russian

/obj/effect/landmark/corpsespawner/russian/ranged

/obj/effect/landmark/corpsespawner/dutchrifle
	name = "Dutch Dozen Rifleman"
	equip_path = /datum/equipment_preset/corpse/dutchrifle

/obj/effect/landmark/corpsespawner/dutchrifle/burst
	name = "Burst Dutch Dozen Rifleman"
	equip_path = /datum/equipment_preset/corpse/dutchrifle/burst

/obj/effect/landmark/corpsespawner/pizza
	name = "Pizza Deliverer"
	equip_path = /datum/equipment_preset/corpse/pizza

/obj/effect/landmark/corpsespawner/pizza/burst
	name = "Burst Pizza Deliverer"
	equip_path = /datum/equipment_preset/corpse/pizza/burst

/obj/effect/landmark/corpsespawner/gladiator
	name = "Gladiator"
	equip_path = /datum/equipment_preset/corpse/gladiator

/obj/effect/landmark/corpsespawner/gladiator/burst
	name = "Burst Gladiator"
	equip_path = /datum/equipment_preset/corpse/gladiator/burst

//FORECON

/obj/effect/landmark/corpsespawner/forecon_spotter
	name = "USCM Reconnaissance Spotter"
	equip_path = /datum/equipment_preset/corpse/forecon_spotter


///////////////////////
/////// HYBRISA ///////
///////////////////////

// Hybrisa - Goons

/obj/effect/landmark/corpsespawner/hybrisa_goon
	name = "Weyland-Yutani Corporate Security Officer"
	equip_path = /datum/equipment_preset/corpse/pmc/hybrisa_goon

/obj/effect/landmark/corpsespawner/hybrisa_goon/burst
	name = "Burst Weyland-Yutani Corporate Security Officer"
	equip_path = /datum/equipment_preset/corpse/pmc/hybrisa_goon/lead/burst

/obj/effect/landmark/corpsespawner/hybrisa_goon/lead
	name = "Weyland-Yutani Corporate Security Lead"
	equip_path = /datum/equipment_preset/corpse/pmc/hybrisa_goon/lead

/obj/effect/landmark/corpsespawner/hybrisa_goon/lead/burst
	name = "Burst Weyland-Yutani Corporate Security Lead"
	equip_path = /datum/equipment_preset/corpse/pmc/hybrisa_goon/lead/burst

//*****************************************************************************************************/

// Civilian

/obj/effect/landmark/corpsespawner/hybrisa/civilian
	name = "Corpse - Civilian"
	equip_path = /datum/equipment_preset/corpse/hybrisa/civilian

/obj/effect/landmark/corpsespawner/hybrisa/civilian/burst
	name = "Corpse - Burst - Civilian"
	equip_path = /datum/equipment_preset/corpse/hybrisa/civilian/burst

/obj/effect/landmark/corpsespawner/hybrisa/civilian_office
	name = "Corpse - Civilian - Office Worker"
	equip_path = /datum/equipment_preset/corpse/hybrisa/civilian_office

/obj/effect/landmark/corpsespawner/hybrisa/civilian_office/burst
	name = "Corpse - Burst - Civilian - Office Worker"
	equip_path = /datum/equipment_preset/corpse/hybrisa/civilian_office/burst

// Weymart

/obj/effect/landmark/corpsespawner/hybrisa/weymart
	name = "Corpse - Civilian - Weymart Employee"
	equip_path = /datum/equipment_preset/corpse/hybrisa/weymart

/obj/effect/landmark/corpsespawner/hybrisa/weymart/burst
	name = "Corpse - Burst - Civilian - Weymart Employee"
	equip_path = /datum/equipment_preset/corpse/hybrisa/weymart/burst

// Sanitation

/obj/effect/landmark/corpsespawner/hybrisa/sanitation
	name = "Corpse - Civilian - Material Reprocessing Technician"
	equip_path = /datum/equipment_preset/corpse/hybrisa/sanitation

/obj/effect/landmark/corpsespawner/hybrisa/sanitation/burst
	name = "Corpse - Burst - Civilian - Material Reprocessing Technician"
	equip_path = /datum/equipment_preset/corpse/hybrisa/sanitation/burst

// Fire Station

/obj/effect/landmark/corpsespawner/hybrisa/fire_fighter
	name = "Corpse - Civilian - Fire Protection Specialist"
	equip_path = /datum/equipment_preset/corpse/hybrisa/fire_fighter

// Pizza Galaxy

/obj/effect/landmark/corpsespawner/hybrisa/pizza_galaxy
	name = "Corpse - Civilian - Pizza Galaxy Delivery Driver"
	equip_path = /datum/equipment_preset/corpse/hybrisa/pizza_galaxy

/obj/effect/landmark/corpsespawner/hybrisa/pizza_galaxy/burst
	name = "Corpse - Burst - Civilian - Pizza Galaxy Delivery Driver"
	equip_path = /datum/equipment_preset/corpse/hybrisa/pizza_galaxy/burst

//*****************************************************************************************************/

// NSPA

/obj/effect/landmark/corpsespawner/hybrisa/nspa_constable
	name = "Corpse - NSPA Constable"
	equip_path = /datum/equipment_preset/corpse/hybrisa/nspa_constable

/obj/effect/landmark/corpsespawner/hybrisa/nspa_constable/burst
	name = "Corpse - Burst - NSPA Constable"
	equip_path = /datum/equipment_preset/corpse/hybrisa/nspa_constable/burst

/obj/effect/landmark/corpsespawner/trijent/nspa_constable/
	name = "Corpse - Trijent NSPA Constable"
	equip_path = /datum/equipment_preset/corpse/hybrisa/nspa_constable/trijent

/obj/effect/landmark/corpsespawner/trijent/nspa_constable/burst
	name = "Corpse - Burst - Trijent NSPA Constable"
	equip_path = /datum/equipment_preset/corpse/hybrisa/nspa_constable/trijent/burst

//*****************************************************************************************************/

// KMCC Mining

/obj/effect/landmark/corpsespawner/hybrisa/kelland_miner
	name = "Corpse - KMCC - Miner"
	equip_path = /datum/equipment_preset/corpse/hybrisa/kelland_miner

/obj/effect/landmark/corpsespawner/hybrisa/kelland_miner/burst
	name = "Corpse - Burst - KMCC - Miner"
	equip_path = /datum/equipment_preset/corpse/hybrisa/kelland_miner/burst

//*****************************************************************************************************/

// Medical

/obj/effect/landmark/corpsespawner/hybrisa/medical_doctor_corpse

	name = "Corpse - Civilian - Medical Doctor"
	equip_path = /datum/equipment_preset/corpse/hybrisa/medical_doctor_corpse

/obj/effect/landmark/corpsespawner/hybrisa/medical_doctor_corpse/burst

	name = "Corpse - Burst - Civilian - Medical Doctor"
	equip_path = /datum/equipment_preset/corpse/hybrisa/medical_doctor_corpse/burst

//*****************************************************************************************************/

// Science

// Xenobiologist

/obj/effect/landmark/corpsespawner/hybrisa/scientist_xenobiologist

	name = "Corpse - Civilian - Xenobiologist"
	equip_path = /datum/equipment_preset/corpse/hybrisa/scientist_xenobiologist

/obj/effect/landmark/corpsespawner/hybrisa/scientist_xenobiologist/burst

	name = "Corpse - Burst - Civilian - Xenobiologist"
	equip_path = /datum/equipment_preset/corpse/hybrisa/scientist_xenobiologist/burst

// Xenoarchaeologist

/obj/effect/landmark/corpsespawner/hybrisa/scientist_xenoarchaeologist

	name = "Corpse - Civilian - Xenoarchaeologist"
	equip_path = /datum/equipment_preset/corpse/hybrisa/scientist_xenoarchaeologist

/obj/effect/landmark/corpsespawner/hybrisa/scientist_xenoarchaeologist/burst

	name = "Corpse - Burst - Civilian - Xenoarchaeologist"
	equip_path = /datum/equipment_preset/corpse/hybrisa/scientist_xenoarchaeologist/burst

//*****************************************************************************************************/

///US Army Corpses///

// Army Trooper //

/obj/effect/landmark/corpsespawner/tyrargo/us_army_trooper
	name = "Corpse - US Army - Trooper"
	equip_path = /datum/equipment_preset/corpse/tyrargo/us_army_trooper

/obj/effect/landmark/corpsespawner/tyrargo/us_army_trooper/burst
	name = "Corpse - Burst - US Army - Trooper"
	equip_path = /datum/equipment_preset/corpse/tyrargo/us_army_trooper/burst

/obj/effect/landmark/corpsespawner/tyrargo/us_army_medic
	name = "Corpse - US Army - Trooper"
	equip_path = /datum/equipment_preset/corpse/tyrargo/us_army_medic

/obj/effect/landmark/corpsespawner/tyrargo/us_army_medic/burst
	name = "Corpse - Burst - US Army - Trooper"
	equip_path = /datum/equipment_preset/corpse/tyrargo/us_army_medic/burst

//*****************************************************************************************************/

///LACN///

// LACN Marine - unarmed //

/obj/effect/landmark/corpsespawner/new_varadero/lacn_marine
	name = "Corpse - LACN - Marine - Unarmed"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_marine

/obj/effect/landmark/corpsespawner/new_varadero/lacn_marine/burst
	name = "Corpse - Burst - LACN - Marine - Unarmed"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_marine/burst

// LACN Marine //

/obj/effect/landmark/corpsespawner/new_varadero/lacn_marine_a
	name = "Corpse - LACN - Marine"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_marine_a

/obj/effect/landmark/corpsespawner/new_varadero/lacn_marine_a/burst
	name = "Corpse - Burst - LACN - Marine"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_marine_a/burst

// LACN Medic //

/obj/effect/landmark/corpsespawner/new_varadero/lacn_medic
	name = "Corpse - LACN - Medic"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_medic

/obj/effect/landmark/corpsespawner/new_varadero/lacn_medic/burst
	name = "Corpse - Burst - LACN - Medic"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_medic/burst

// LACN MP //

/obj/effect/landmark/corpsespawner/new_varadero/lacn_police
	name = "Corpse - LACN - Army Police"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_police

/obj/effect/landmark/corpsespawner/new_varadero/lacn_police/burst
	name = "Corpse - Burst - LACN - Army Police"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_police/burst

// LACN Pilot //

/obj/effect/landmark/corpsespawner/new_varadero/lacn_pilot
	name = "Corpse - LACN - Pilot"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_pilot

// LACN Ground crew //

/obj/effect/landmark/corpsespawner/new_varadero/lacn_groundcrew
	name = "Corpse - LACN - Ground Crew"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_groundcrew

/obj/effect/landmark/corpsespawner/new_varadero/lacn_groundcrew/burst
	name = "Corpse - Burst - LACN - Ground Crew"
	equip_path = /datum/equipment_preset/corpse/new_varadero/lacn_groundcrew/burst