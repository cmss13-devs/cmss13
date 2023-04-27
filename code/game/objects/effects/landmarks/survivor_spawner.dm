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
	story_text = "You are a soldier of Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rose up and noticed that one of your limbs is at a weird angle, broken. You looked at other survivors, also limping and trying to fix their broken bones. \red You also notice that sentry turrets on the ramp of your ship beep angrily, it seems their logic circuits got damaged. They will identify you as a foe, but at least they will identify everything as a foe."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	equipment = /datum/equipment_preset/survivor/pmc
	synth_equipment = /datum/equipment_preset/pmc/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a PMC from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_cl
	equipment = /datum/equipment_preset/survivor/wy/manager
	synth_equipment = /datum/equipment_preset/pmc/synth
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
