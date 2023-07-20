/obj/effect/landmark/survivor_spawner
	name = "special survivor spawner"
	var/equipment = null
	var/synth_equipment = null
	var/CO_equipment = null
	var/list/intro_text = list()
	var/story_text = ""
	var/roundstart_damage_min = 0
	var/roundstart_damage_max = 0
	var/roundstart_damage_times = 1

	var/spawn_priority = LOWEST_SPAWN_PRIORITY

/obj/effect/landmark/survivor_spawner/Initialize(mapload, ...)
	. = ..()
	LAZYINITLIST(GLOB.survivor_spawns_by_priority["[spawn_priority]"])
	GLOB.survivor_spawns_by_priority["[spawn_priority]"] += src

/obj/effect/landmark/survivor_spawner/Destroy()
	GLOB.survivor_spawns_by_priority["[spawn_priority]"] -= src
	return ..()

/obj/effect/landmark/survivor_spawner/proc/check_can_spawn(mob/living/carbon/human/survivor)
	// prevents stacking survivors on top of eachother
	if(locate(/mob/living/carbon/human) in loc)
		return FALSE
	return TRUE

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf
	equipment = /datum/equipment_preset/survivor/clf
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier of Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rose up and noticed that one of your limbs is at a weird angle, broken. You looked at other survivors, also limping and trying to fix their broken bones."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_engineer
	equipment = /datum/equipment_preset/clf/engineer
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a soldier of Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rose up and noticed that one of your limbs is at a weird angle, broken. You looked at other survivors, also limping and trying to fix their broken bones."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_medic
	equipment = /datum/equipment_preset/clf/medic
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a soldier of Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rose up and noticed that one of your limbs is at a weird angle, broken. You looked at other survivors, also limping and trying to fix their broken bones."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	equipment = /datum/equipment_preset/survivor/pmc
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a PMC from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_medic
	equipment = /datum/equipment_preset/survivor/pmc/medic
	synth_equipment = /datum/equipment_preset/pmc/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a PMC medic from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_engineer
	equipment = /datum/equipment_preset/survivor/pmc/engineer
	synth_equipment = /datum/equipment_preset/pmc/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a PMC engineer from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_cl
	equipment = /datum/equipment_preset/survivor/wy/manager
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an Assistant Manager from Weyland-Yutani. You were being escorted onboard a PMC ship to Solaris Ridge. On the way, the ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, the pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. The shipcrew lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You must get up and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH


//Military Survivors//

/obj/effect/landmark/survivor_spawner/lv522_forecon_tech
	equipment = /datum/equipment_preset/survivor/forecon/tech
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv522_forecon_marksman
	equipment = /datum/equipment_preset/survivor/forecon/marksman
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_smartgunner
	equipment = /datum/equipment_preset/survivor/forecon/smartgunner
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_grenadier
	equipment = /datum/equipment_preset/survivor/forecon/grenadier
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_squad_leader
	equipment = /datum/equipment_preset/survivor/forecon/squad_leader
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/fiorina_ua_peacekeeper
	equipment = /datum/equipment_preset/survivor/ua_peacekeeper
	intro_text = list("<h2>You are a United Americas peacekeeper!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to hold your position and survive, the CMB were sent to assist but you answer to yourselves - adminhelp.</span>")
	story_text = "You are a peacekeeper for the United Americas. You and your allies were stationed on this station to act as riot control personnel for its large prison population. During a mass riot and biological quarantine breach, you and your comrades held the line against the overwhelming hoard of rioting prisoners. After the death of your Captain, you resorted to lethal force to clear the area. You stopped the riot, but perhaps at the cost of a small part of your soul. Your team's distress signal was answered by a nearby CMB ship, which crash landed, their survivors rallied to your location and now you huddle together. You can only pray a more well equipped rescue force is en route, because the real nightmare is about to begin."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/fiorina_cmb_deputy
	equipment = /datum/equipment_preset/survivor/cmb_deputy
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb_synth/fiorina
	intro_text = list("<h2>You are a CMB deputy!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to hold your position and survive, the CMB Marshal is your superior officer! - adminhelp.</span>")
	story_text = "You are a CMB Deputy. Several days ago you and your team received a distress signal from this space station. Under the belief that a mass riot was in progress, you were dispatched as part of a rapid response team to relieve the station's security forces. Upon your arrival, a ring of unexpected orbital debris knocked your shuttle's engines offline, forcing an emergency landing. Only some of you survived. You locate a small group of United American peacekeepers, and after being informed of the dire situation, are resolved to hold your ground until rescue arrives. You can only pray they come soon."
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/fiorina_cmb_marshal
	equipment = /datum/equipment_preset/survivor/cmb_marshal
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb_synth/fiorina
	intro_text = list("<h2>You are the CMB marshal!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to hold your position and survive, you are the ranking officer commanding the deputies! - adminhelp.</span>")
	story_text = "You are a CMB Deputy. Several days ago you and your team received a distress signal from this space station. Under the belief that a mass riot was in progress, you were dispatched as part of a rapid response team to relieve the station's security forces. Upon your arrival, a ring of unexpected orbital debris knocked your shuttle's engines offline, forcing an emergency landing. Only some of you survived. You locate a small group of United American peacekeepers, and after being informed of the dire situation, are resolved to hold your ground until rescue arrives. You can only pray they come soon."
	spawn_priority = SPAWN_PRIORITY_VERY_HIGH
