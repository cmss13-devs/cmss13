/obj/effect/landmark/survivor_spawner
	name = "special survivor spawner"
	icon_state = "surv"
	var/equipment = null
	var/synth_equipment = null
	var/CO_equipment = null
	var/list/intro_text = list()
	var/story_text = ""
	var/roundstart_damage_min = 0
	var/roundstart_damage_max = 0
	var/roundstart_damage_times = 1
	/// Whether or not the spawner is for an inherently hostile survivor subtype.
	var/hostile = FALSE

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
	if(!survivor)
		return FALSE
	if(hostile && !HAS_FLAG(survivor.client?.prefs?.toggles_survivor, PLAY_SURVIVOR_HOSTILE))
		return FALSE
	if(!hostile && !HAS_FLAG(survivor.client?.prefs?.toggles_survivor, PLAY_SURVIVOR_NON_HOSTILE))
		return FALSE
	return TRUE

//LV-624 CLF survivors//

/obj/effect/landmark/survivor_spawner/clf
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf
	synth_equipment = /datum/equipment_preset/synth/survivor/clf
	CO_equipment = /datum/equipment_preset/survivor/clf //to prevent NV CO from spawning as a CO
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/clf_lead
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf/leader
	synth_equipment = /datum/equipment_preset/synth/survivor/clf
	CO_equipment = /datum/equipment_preset/survivor/clf/leader
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants and under your orders, you and your team small boarded a small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of your pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked up at the few remaining survivors of your squad, all limping and trying to tend to their wounds, luckily, none of your men were seriously hurt, and all seem to be responsive to your orders."
	roundstart_damage_min = 2
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/clf_engi
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/clf
	CO_equipment = /datum/equipment_preset/survivor/clf/engineer
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/clf_medic
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/clf
	CO_equipment = /datum/equipment_preset/survivor/clf/medic
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

//Big Red CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You hunkered down with your cell and have begun to prepare for the worst, not knowing what fate awaits you in these caves..."

/obj/effect/landmark/survivor_spawner/clf_lead/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Under your command, your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You ordered the men to hunker down and  to prepare for the worst, not knowing what fate awaits your team in these caves..."

/obj/effect/landmark/survivor_spawner/clf_engi/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You hunkered down with your cell and have begun to prepare for the worst, not knowing what fate awaits you in these caves..."

/obj/effect/landmark/survivor_spawner/clf_medic/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are doctor fighting for the Colonial Liberation Front. Your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You hunkered down with your cell and have begun to prepare for the worst, not knowing what fate awaits you in these caves..."

//Trijent CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted in the ship being abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. The cell leader ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your cell hang by a thread, stuck on an unknown world surrounded by unknown enemies."

/obj/effect/landmark/survivor_spawner/clf_lead/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted you ordering the ship to be abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After ordering some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. You ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your men hang by a thread, stuck on an unknown world surrounded by unknown enemies."

/obj/effect/landmark/survivor_spawner/clf_engi/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted in the ship being abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. The cell leader ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your cell hang by a thread, stuck on an unknown world surrounded by unknown enemies."

/obj/effect/landmark/survivor_spawner/clf_medic/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted in the ship being abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. The cell leader ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your cell hang by a thread, stuck on an unknown world surrounded by unknown enemies."

//Fiorina CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/fiorina
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. The plan was simple: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."

/obj/effect/landmark/survivor_spawner/clf_lead/fiorina
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. Your plan was genius and foolproof: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, in a stroke of terrible luck, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."

/obj/effect/landmark/survivor_spawner/clf_engi/fiorina
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. The plan was simple: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."

/obj/effect/landmark/survivor_spawner/clf_medic/fiorina
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. The plan was simple: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."

//Shiva's CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and the cell lead has ordered everyone to hold here until further orders."

/obj/effect/landmark/survivor_spawner/clf_lead/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and you ordered everyone to hold here until you can come up with a new plan."

/obj/effect/landmark/survivor_spawner/clf_engi/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and the cell lead has ordered everyone to hold here until further orders."

/obj/effect/landmark/survivor_spawner/clf_medic/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and the cell lead has ordered everyone to hold here until further orders."

//Kutjevo's CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. You and the rest of your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you started loading and unloading cargo as usual and setting up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

/obj/effect/landmark/survivor_spawner/clf_lead/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. You and your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you ordered the team to start loading and unloading cargo as usual and to set up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

/obj/effect/landmark/survivor_spawner/clf_engi/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. You and the rest of your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you started loading and unloading cargo as usual and setting up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

/obj/effect/landmark/survivor_spawner/clf_medic/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. You and the rest of your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you started loading and unloading cargo as usual and setting up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

//Soro CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/soro
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Your Cell Lead has requested for an extraction from HQ, hopefully they arrive in time..."

/obj/effect/landmark/survivor_spawner/clf_lead/soro
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Unbeknownst to your men, your request for extraction from HQ has been denied..."

/obj/effect/landmark/survivor_spawner/clf_engi/soro
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Your Cell Lead has requested for an extraction from HQ, hopefully they arrive in time..."

/obj/effect/landmark/survivor_spawner/clf_medic/soro
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Your Cell Lead has requested for an extraction from HQ, hopefully they arrive in time..."

//Varadero CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/varadero
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which you and your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."

/obj/effect/landmark/survivor_spawner/clf_lead/varadero
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."

/obj/effect/landmark/survivor_spawner/clf_engi/varadero
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which you and your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."

/obj/effect/landmark/survivor_spawner/clf_medic/varadero
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which you and your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."

//Prospera CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/hybrisa
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, your cell launched an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."

/obj/effect/landmark/survivor_spawner/clf_lead/hybrisa
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, you ordered your cell to launch an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."

/obj/effect/landmark/survivor_spawner/clf_engi/hybrisa
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, your cell launched an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."

/obj/effect/landmark/survivor_spawner/clf_medic/hybrisa
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, your cell launched an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."

//Weyland-Yutani Survivors//

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_cl
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/corporate/executive
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are the last alive Executive of Lazarus Landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Liaison stationed on LV-624 from Weyland-Yutani. You were tipped off about some very peculiar looking eggs recovered from the alien temple North-East of the colony. Being the smart Executive the Company hired you to be, you decided to prepare your office for the worst when the first 'facehugger' was born in the vats of the Research Dome. Turned out, you were right, everyone who called you crazy and called these the new 'synthetics' is now dead, you along with your Corporate Security detail are the only survivors due to your paranoia. The xenomorph onslaught was relentless, a fuel tank was shot by one of the Officers, leading to the destruction of a part of the dome, along with a lot of the defences being melted. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Officer!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Officer stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from the Marshals Offices to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."

	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon_medic
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Medic!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Medic stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from the Medbay to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon_engi
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Technician!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Technician stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from Engineering to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon_lead
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon/lead
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Lead!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Lead stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to organize the security forces present, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/standard
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.</span>")
	story_text = "You are a PMC from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_medic
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.")
	story_text = "You are a PMC medic from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_engineer
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.")
	story_text = "You are a PMC engineer from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_leader
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/pmc_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.")
	story_text = "You are a PMC team leader from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_cl
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/corporate/manager
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.</span>")
	story_text = "You are an Assistant Manager from Weyland-Yutani. You were being escorted onboard a PMC ship to Solaris Ridge. On the way, the ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, the pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your PMC escorts lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You must get up and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

//Shivas Panic Room Survivors//

/obj/effect/landmark/survivor_spawner/shivas_panic_room_commando
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/commando_shivas
	intro_text = list("<h2>You are the last living security element on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a commando stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. While you were assigned to protecting the people taking shelter in the Panic Room, the rest of your team was spread out throughout the colony. You have not seen any of them since. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_cl
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/corporate/asstmanager
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/corporate_synth
	intro_text = list("<h2>You are the last alive Senior Administrator on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are the Assistant Operations Manager stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons you one-day said were 'useless' and a waste of Company dollars. You remember that Administrator Stahl sent out a distress beacon to any ship in range, hoping to get picked up by the Company, he ran to the Spaceport. You have not seen him since. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_doc
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/doctor/shiva
	synth_equipment = /datum/equipment_preset/synth/survivor/emt_synth_teal
	intro_text = list("<h2>You are a Medical Doctor on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Doctor working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the xenomorphs have a sort of implanter which latches on to your face and then... something bursts out of your chest, through the rib cage. You had plenty of those cases at the Medical Bay. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_doc/medium_priority
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/shivas_panic_room_eng
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/engineer/shiva
	synth_equipment = /datum/equipment_preset/synth/survivor/engineer_synth
	intro_text = list("<h2>You are an Engineer on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are an Engineer working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the xenomorphs seem to be able to see in the dark, as you saw one grab a co-worker trying to fix the generators after the power went out. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_eng/medium_priority
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/shivas_panic_room_sci
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/scientist/shiva
	synth_equipment = /datum/equipment_preset/synth/survivor/scientist_synth
	intro_text = list("<h2>You are a Weyland-Yutani Scientist on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Scientist working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the XX-121 species, codenamed that by Research Director Clarke, have a variety of different species, what you can assume a 'leader' of some sort and that their acid is deadly should it come in contact with you or the shutters. You ran far from the labs and have not seen some your coworkers since. In their attempts at trying to breach in, these so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_sci/medium_priority
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/shivas_panic_room_civ
	equipment = /datum/equipment_preset/survivor/civilian
	synth_equipment = /datum/equipment_preset/synth/survivor/chef_synth
	intro_text = list("<h2>You are a worker on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a civilian working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember hearing the alarms blaring and decided to run with a couple others to the Panic Room, hoping to be safe from the threat until rescue arrives. Now you wait along with others for their second attack on the Panic Room. In their first attempt at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_MEDIUM

//CMB Survivors//

/obj/effect/landmark/survivor_spawner/fiorina_armory_cmb
	equipment = /datum/equipment_preset/survivor/cmb/riot
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb/riotsynth
	intro_text = list("<h2>You are a CMB Riot Control Officer!</h2>",\
	"<span class='notice'>You are aware of the 'alien' threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the infestation.</span>")
	story_text = "You are a part of Riot Control Unit of the Office of the Colonial Marshals. Your dispatcher received a distress signal from the infamous Fiorina Maximum Penitentiary. You figured it was just another typical case of the prison dealing with a riot their understaffed security force couldn't handle, with more and more of its personnel getting dispatched elsewhere in the galaxy. This wasn't the first time OCM officers were called in to assist, but unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. Loaded up with only beanbags and finding nobody to greet you on the LZ after being dropped off, you and the rest of your team had gone towards the armory to speak to the Quartermaster, but only found corpses of both prisoners and security littered around on the way. Worried about armed prisoners, your team was in the process of switching to lethals in the armory when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll need to decide whether to look for more clues about what the hell happened here, hunt whatever's out there, or hold a position and hope someone else will respond to the distress signal before it's too late..."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/fiorina_armory_riot_control
	equipment = /datum/equipment_preset/survivor/cmb/ua
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb/ua_synth
	intro_text = list("<h2>You are a United Americas Riot Control Officer!</h2>",\
	"<span class='notice'>You are aware of the 'alien' threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the infestation.</span>")
	story_text = "You are a United Americas Riot Control Officer. Your dispatcher received a request from the local OCM Outpost, requesting some men to intervene assist a OCM Officer with handling a riot at Fiorina. The prison was an understaffed mess so you weren't too surprised they had sent out a distress signal, calling you in to do their jobs yet again. Unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. Loaded up with only beanbags and finding nobody to greet you on the LZ after being dropped off, you and the rest of your team had gone towards the armory to speak to the Quartermaster, but only found corpses of both prisoners and security littered around on the way. Worried about armed prisoners, your team was in the process of switching to lethals in the armory when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll need to decide whether to look for more clues about what the hell happened here, hunt whatever's out there, or hold a position and hope someone else will respond to the distress signal before it's too late..."

	spawn_priority = SPAWN_PRIORITY_HIGH

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

/obj/effect/landmark/survivor_spawner/lv522_forecon_sniper
	equipment = /datum/equipment_preset/survivor/forecon/sniper
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv522_forecon_squad_leader
	equipment = /datum/equipment_preset/survivor/forecon/squad_leader
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/upp/soldier
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/soldier
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_LOW

/obj/effect/landmark/survivor_spawner/upp_sapper
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/sapper
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/upp_medic
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/upp_specialist
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/specialist
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/squad_leader
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/squad_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_VERY_HIGH
