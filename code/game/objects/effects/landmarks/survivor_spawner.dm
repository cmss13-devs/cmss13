/obj/effect/landmark/survivor_spawner
	name = "special survivor spawner"
	icon_state = "surv"
	var/equipment = null
	var/synth_equipment = null
	var/CO_equipment = null
	var/list/intro_text = list()
	var/list/synthetic_intro_text
	var/list/CO_intro_text
	var/story_text
	var/synthetic_story_text
	var/CO_story_text
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
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb_synth
	CO_equipment = /datum/equipment_preset/survivor/clf/coordinator
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	synthetic_intro_text = list("<h2>You are a captured colony synthetic in service of the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are not entirely loyal due to not being reprogrammed, until another response team arrives, they are your best chance of survival.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. The colony was overrun by a xenomorph infestation weeks ago, managing to take down a ship that you had assumed was sent to rescue you and killing the rest of your CMB team. Spotting it as it crashed into the mountainside, you and the survivors with you went to assist them - and, although only you made it, you were pressed into helping them at the end of a gun. Despite this, they are still your best chance of survival while you wait for a more organized rescue team to arrive, and you should endeavour to keep them safe - for now."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/clf_lead
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf/leader
	synth_equipment = /datum/equipment_preset/synth/survivor/freelancer_synth
	CO_equipment = /datum/equipment_preset/survivor/clf/coordinator
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants and under your orders, you and your team small boarded a small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of your pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked up at the few remaining survivors of your squad, all limping and trying to tend to their wounds, luckily, none of your men were seriously hurt, and all seem to be responsive to your orders."
	synthetic_intro_text = list("<h2>You are a captured colony synthetic in service of the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are not entirely loyal due to programming choices, until the USCMC arrives, they are your best chance of survival.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. Your colony was overrun by a xenomorph infestation weeks ago, managing to take down a ship that you had assumed was sent to rescue you. Crashing into a mountainside, you and your employer went to assist - and, although only you made it, you were pressed into helping them at the end of a gun. Despite this, they are still your best chance of survival while you wait for a more organized rescue team to arrive, and you should endeavour to keep them safe - for now."
	roundstart_damage_min = 2
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/clf_engi
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/trucker_synth
	CO_equipment = /datum/equipment_preset/survivor/clf/coordinator
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	synthetic_intro_text = list("<h2>You are a captured colony synthetic in service of the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are not entirely loyal due to programming choices, until the USCMC arrives, they are your best chance of survival.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. Your colony was overrun by a xenomorph infestation weeks ago, managing to take down a ship that you had assumed was sent to rescue you. Crashing into a mountainside, you and the survivors with you went to assist - and, although only you made it, you were pressed into helping them at the end of a gun. Despite this, they are still your best chance of survival while you wait for a more organized rescue team to arrive, and you should endeavour to keep them safe - for now."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/clf_medic
	icon_state = "surv_clf"
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/doctor_synth
	CO_equipment = /datum/equipment_preset/survivor/clf/coordinator
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You ARE AWARE of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	synthetic_intro_text = list("<h2>You are a captured colony synthetic in service of the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are not entirely loyal due to programming choices, until the USCMC arrives, they are your best chance of survival.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. Your colony was overrun by a xenomorph infestation weeks ago, managing to take down a ship that you had assumed was sent to rescue you. Crashing into a mountainside, you and the survivors with you went to assist - and, although only you made it, you were pressed into helping them at the end of a gun. Despite this, they are still your best chance of survival while you wait for a more organized rescue team to arrive, and you should endeavour to keep them safe - for now."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

//Big Red CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You hunkered down with your cell and have begun to prepare for the worst, not knowing what fate awaits you in these caves..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You attempted to assist during the initial miner strike and uprising alongside your colleagues within the CMB and peacekeeping forces. As you shifted to begin working on the triage and care of the survivors on both sides, however, people within the colony began to disappear and pick off fellow colonists. You and those with you retreated back into the mines, encountering a CLF cell and being forced into service with them at the end of a gun."

/obj/effect/landmark/survivor_spawner/clf_lead/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Under your command, your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You ordered the men to hunker down and  to prepare for the worst, not knowing what fate awaits your team in these caves..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You attempted to assist during the initial miner strike by protecting your employer from both the peacekeeping forces and the miners. After the dust had settled, though, the remains of colonists began turning up throughout the colony. Attempting to retreat into the mining caves to avoid being the next victim, your employer was taken - and you were pressed into service with the CLF at the end of a gun."

/obj/effect/landmark/survivor_spawner/clf_engi/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You hunkered down with your cell and have begun to prepare for the worst, not knowing what fate awaits you in these caves..."
	synthetic_story_text ="You are a colony synthetic that has been pressed into the service of the CLF. You attempted to assist during the initial miner strike by driving the wounded in and out of the caves using the colony van to the hospital and tending to them as a form of EMT. After the dust had settled, though, you found your van torn apart and melted. Colonists began to disappear, and you lead a small team into the caves, in hopes of finding leftover equipment and shelter - and it was here that you were forced into service at the end of a gun."

/obj/effect/landmark/survivor_spawner/clf_medic/solaris
	intro_text = list("<h2>You are a survivor of a colonial uprising!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are doctor fighting for the Colonial Liberation Front. Your cell has been embedded among the miners and workers of Solaris Ridge, instigating and agitating for a general strike. Your work was successful and there was a strike that turned violent against UA peacekeeping forces. Soon after in the chaos, however, you recieved word that unknown creatures were picking off fellow colonists. You hunkered down with your cell and have begun to prepare for the worst, not knowing what fate awaits you in these caves..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You stayed behind to operate on the worst of the wounded during the miner strike and revolt, rarely having time to step out of the operating room. Even then, though, something was wrong - as colonists under your care disappeared abruptly, and as you tried to treat one of your patients something tore out of their chest. You tried to leave the wounded with you into the caves, hoping to find safety in a more secluded area - and it was here that you were forced into service at the end of a gun."

//Trijent CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted in the ship being abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. The cell leader ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your cell hang by a thread, stuck on an unknown world surrounded by unknown enemies."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You are a member of a CMB team from Oxley's Butte, the closest settlement to the Trijent Dam facility. You and your team moved to the dam shortly after contact ceased, and you quickly found yourselves overrun and cut off from being able to return to the city. As your team was picked off one by one, you saw escape pods land on the fringes of the colony - and as you headed to meet them, you were met with the barrel of a gun, forced into service with the CLF."

/obj/effect/landmark/survivor_spawner/clf_lead/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted you ordering the ship to be abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After ordering some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. You ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your men hang by a thread, stuck on an unknown world surrounded by unknown enemies."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You are a privately owned synthetic who was under the employ of one of the Trijent Dam workers. Weeks ago, you and your employer were caught in the midst of a xenomorph outbreak, having to resort to hiding in lockers and fleeing from them, holding out as long as you could. Eventually, escape pods landed on the planet, and seeking to increase your numbers, you went towards them, hiding nearby - and eventually, both of you were pulled out and met with the barrel of a gun. You were forced into service with the CLF, and so far, it seems to be your best chance for survival."

/obj/effect/landmark/survivor_spawner/clf_engi/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted in the ship being abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. The cell leader ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your cell hang by a thread, stuck on an unknown world surrounded by unknown enemies."
	synthetic_story_text = "You are a colony synthetic that has been pressed into service with the CLF. Weeks ago, you drove the last group of workers back to the dam from Oxley's Butte, the closest settlement to the dam, before the road was cut off by xenomorphs and you were left stranded. Barely managing to keep them safe, you saw a group of escape pods crashland onto the planet. Seeking safety in numbers, you sought them out - only to be met with the barrel of a gun, forced into service with the CLF as a result."

/obj/effect/landmark/survivor_spawner/clf_medic/trijent
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your ship, due to poor maintenance, suffered a complete system failure that resulted in the ship being abandoned. Your pods catastrophically failed, and you appear to have landed on the nearest planet. At first, the colony appeared mostly abandoned, save for a company rat you found hiding in a supply locker. After some enhanced interrogation, you learned that there has been some sort of outbreak of dangerous creatures. The cell leader ordered everyone to hunker down, and you successfully repelled a wave of the creatures after suffering many casualties. You and your cell hang by a thread, stuck on an unknown world surrounded by unknown enemies."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You are a synthetic doctor from the nearest settlement to Trijent Dam, Oxley's Butte. Called out to assist with a minor surgery, you found yourself splattered with blood and in the midst of a xenomorph outbreak when your patient chestburst on the operating table. Seeing escape pods land, you and the survivor with you moved towards them in hopes of finding more medical supplies - although all you found were members of the CLF, greeting you with the end of a gun, and forcing you into service with them."

//Fiorina CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/fiorina
	synth_equipment = /datum/equipment_preset/synth/survivor/icc_synth
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. The plan was simple: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You are a member of a CMB team sent to investigate Fiorina Science Annex for possible breaches of human rights. Midway through your investigation, a ship rammed itself directly into the side of the station - and in doing so, released whatever experiments they were working on. Making a fighting retreat, most of your squad was picked off either by the prisoners or the xenomorphs, and ultimately you were forced into service with the very insurgents who rammed into the station."

/obj/effect/landmark/survivor_spawner/clf_lead/fiorina
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. Your plan was genius and foolproof: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, in a stroke of terrible luck, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. You are a freelancer synthetic who was privately assisting with the transfer of a politically valuable prisoner. During the transfer, however, a ship rammed directly into the side of the station, destroying the umbilical that would have allowed you to escape and shattering any hope of leaving, and releasing whatever experiments they were working on. Unable to trust either the prisoners or the peacekeeping forces, you attempted to investigate by yourself - only to be met with a rifle, forced into service with the CLF."

/obj/effect/landmark/survivor_spawner/clf_engi/fiorina
	synth_equipment = /datum/equipment_preset/synth/survivor/radiation_synth
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. The plan was simple: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF, formerly a technician aboard the Fiorina Science Annex orbital station. During one of your maintenance cycles, a vessel rammed itself into the side of the station and, during your attempts to repair the damage, the xenomorph specimens were accidentally released from containment. Moving to try and seal the last of the hull breaches at the impact site, you were met with the end of a gun - and forced into service with the members of the CLF who had rammed into the station."

/obj/effect/landmark/survivor_spawner/clf_medic/fiorina
	synth_equipment = /datum/equipment_preset/synth/survivor/biohazard_synth
	intro_text = list("<h2>You are a survivor of an attempted prison break!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. You have discovered that one of your comrades is being held temporarily at the Science Annex of the infamous Fiorina Prison. The plan was simple: Ram your ship straight into the station and shoot your way through, relying on the element of surprise. However, the station security was already on high alert, and responded quickly. You beat them back, but now it's quiet... too quiet..."
	synthetic_story_text = "You are a colony synthetic that has been pressed into the service of the CLF. As a researcher aboard the Fiorina Science Annex orbital station. While assisting with xenomaterial research, a vessel crashed into the side of the station, releasing many of the xenomorph specimens upon the station. You attempted to evacuate your superiors, although many refused to listen - forcing you to hide and try to send a distress signal. Unfortunately, you were discovered by members of the CLF, and forced into service with them at the end of a gun."

//Shiva's CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/shivas
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and the cell lead has ordered everyone to hold here until further orders."
	synthetic_story_text = "You are a captured Weyland-Yutani private security synthetic who has been pressed into the service of the CLF. A craft crash-landed onto the fringes of the colony, and a CLF cell launched a raid against the panic room, eliminating the colony administrator. When you attempted to contact security forces, you found the communication equipment damaged and inoperable - and slowly, it was overrun by xenomorphs. While you tried to avoid contact, eventually the CLF cell managed to find and capture you, using your expertise to help their wounded - and now, you are forced into service for them at the end of a gun."

/obj/effect/landmark/survivor_spawner/clf_lead/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and you ordered everyone to hold here until you can come up with a new plan."
	synthetic_story_text = "You are a privately owned synthetic who has been pressed into the service of the CLF. After a craft crash-landed onto the fringes of the colony, a CLF cell launched a succesful raid against the colonies management officials, succesfully managing to take over the panic room and central area of the colony. You attempted to escort your employer out to rendezvous with security forces, but your attempt was short-lived - interrupted by xenomorph specimens. Fortunately - or unfortunately - the CLF managed to find you, pressing you into service with them at the end of a gun."

/obj/effect/landmark/survivor_spawner/clf_engi/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and the cell lead has ordered everyone to hold here until further orders."
	synthetic_story_text = "You are a synthetic climate control technician who has been pressed into the service of the CLF. After a craft crash-landed onto the fringes of the colony, knocking out the central heating of the residential block, most of the corporate staff crowded into the panic room for warmth. You were sent to repair the damage, and were captured by members of the CLF as you did so - being forced into service with them. After they cleared the colony and no response came, you began to see strange creatures out of the edge of your vision - the xenomorphs. So far, your captors remain unaware of them."

/obj/effect/landmark/survivor_spawner/clf_medic/shivas
	intro_text = list("<h2>You are a survivor of a CLF raid!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. After a rough landing that disabled your strike craft, your cell successfully launched a raid against the corporate parasitic scum lording over this colony. However, the expected response from security forces never arrived, and the colony soon fell silent. Strange noises have been heard coming from the darkness that no one can identify, and the cell lead has ordered everyone to hold here until further orders."
	synthetic_story_text = "You are a synthetic surgeon who has been pressed into the service of the CLF. After a craft crash-landed onto the fringes of the colony, you helped to manage the initial wounded, working on triage and stabilizing them. However, your triage center was overwhelmed shortly after, with a variety of wounded coming in sporting gunshot wounds, claw marks, and acid burns. Eventually, the inhabitants of the ship, members of the CLF, captured you and pressed you into service with them after they wiped out most of the colonial administration."

//Kutjevo's CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. You and the rest of your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you started loading and unloading cargo as usual and setting up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	synthetic_story_text = "You are a synthetic that was attached to a CMB team. Your team had received reports of illicit cargo being smuggled through a nearby colony, and while your vessel was patrolling, you spotted them heading for a colony refinery. However, upon landing, your team found only the grisly remains of the colonist. Before you could get back aboard your ship, you were already cut off from it and forced to flee - eventually seperating from your team and being forced into service with the very smugglers you were chasing at the end of a gun."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

/obj/effect/landmark/survivor_spawner/clf_lead/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. You and your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you ordered the team to start loading and unloading cargo as usual and to set up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	synthetic_story_text = "You are a privately owned synthetic at the refinery. Your employer was scheduled to pick up a new shipment of cargo from a group of smugglers, however your colony was overrun by xenomorphs and your employer killed while you awaited them to rendezvous with you. Your contacts were slightly off schedule and seemed to struggle to land - their engines cutting out as they did and forcing them to coast to the dropoff zone. Now, you are stuck with them - at least until rescue arrives, or some other method of getting off of this planet."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

/obj/effect/landmark/survivor_spawner/clf_engi/kutjevo
	synth_equipment = /datum/equipment_preset/synth/survivor/radiation_synth
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. You and the rest of your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you started loading and unloading cargo as usual and setting up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	synthetic_story_text = "You are the synthetic reactor technician at the refinery. Weeks ago, your colony was overrun by alien lifeforms. You had managed to avoid them so far by sticking to the outskirts of the colony, however you saw a ship landing nearby. Assuming that it could be rescue, you pushed towards it, barely avoiding detection. Unfortunately, however, the ones who had landed were no rescue team, and they were stuck in the same predicament as you, now. Despite your attempts to explain, they forced you into service with them at the end of a gun."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

/obj/effect/landmark/survivor_spawner/clf_medic/kutjevo
	intro_text = list("<h2>You are a CLF member running a smuggling operation!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. You and the rest of your team have been smuggling in this sector for years. After nearly running out of fuel running away from a patrol, you just barely managed to coast to a stop at the standard pickup and dropoff zone at the refinery. However, the crew that usually meets you was nowhere to be found, and the colony was dead silent. Not knowing what else to do, you started loading and unloading cargo as usual and setting up a perimeter just in case. Now, after dark, you've started hearing strange noises coming from the colony..."
	synthetic_story_text = "You are a synthetic surgeon at the refinery. Weeks ago, the colonial medical bay was overwhelmed with casualties, the majority sporting deep gouged cuts. While you were attempting to stabilize one of your patients, one of the creatures erupted from your chest, and you were forced to leave with the survivors, abandoning the wounded. Seeing a vessel landing near the edge of the colony, you attempted to lead your group to it, however they lost sight of you and you were forced to go alone. Upon arrival, you found yourself face-to-face with a gun, and the option to help, or die."
	roundstart_damage_min = 0
	roundstart_damage_max = 0
	roundstart_damage_times = 0

//Soro CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/soro
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Your Cell Lead has requested for an extraction from HQ, hopefully they arrive in time..."
	synthetic_intro_text = list("<h2>You are a UPP synthetic advising the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are sticking with them as it is your best chance of survival, it is your duty to deny collaboration between the UPP and the CLF.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a member of the UPP 121st Special Reconnaissance Detachment, the SOF's primary reconnaissance group in the Bau Sau sector. You were assigned to this colony to act as an advisor and trainer for local guerilla forces in order to undermine the USCMC, and the United Americas as a whole. However, over the past few weeks, the encampment you have been stationed at has come under siege from xenomorphs. Your comrades are unaware of what they are, thus so far, but you are. In the event of rescue, it is your job to deny your involvement with the CLF, as the political rammifications could be enough to spark war."

/obj/effect/landmark/survivor_spawner/clf_lead/soro
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Unbeknownst to your men, your request for extraction from HQ has been denied..."
	synthetic_intro_text = list("<h2>You are a UPP synthetic advising the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are sticking with them as it is your best chance of survival, it is your duty to deny collaboration between the UPP and the CLF.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a member of the UPP 121st Special Reconnaissance Detachment, the SOF's primary reconnaissance group in the Bau Sau sector. You were assigned to this colony to act as an advisor and trainer for local guerilla forces in order to undermine the USCMC, and the United Americas as a whole. However, over the past few weeks, the encampment you have been stationed at has come under siege from xenomorphs. Your comrades are unaware of what they are, thus so far, but you are. In the event of rescue, it is your job to deny your involvement with the CLF, as the political rammifications could be enough to spark war."

/obj/effect/landmark/survivor_spawner/clf_engi/soro
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Your Cell Lead has requested for an extraction from HQ, hopefully they arrive in time..."
	synthetic_intro_text = list("<h2>You are a UPP synthetic advising the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are sticking with them as it is your best chance of survival, it is your duty to deny collaboration between the UPP and the CLF.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a member of the UPP 121st Special Reconnaissance Detachment, the SOF's primary reconnaissance group in the Bau Sau sector. You were assigned to this colony to act as an advisor and trainer for local guerilla forces in order to undermine the USCMC, and the United Americas as a whole. However, over the past few weeks, the encampment you have been stationed at has come under siege from xenomorphs. Your comrades are unaware of what they are, thus so far, but you are. In the event of rescue, it is your job to deny your involvement with the CLF, as the political rammifications could be enough to spark war."

/obj/effect/landmark/survivor_spawner/clf_medic/soro
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("<h2>You are a CLF member in a covert camp!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your cell has been training and negotiating for more equipment with the UPP for a few weeks now. However, recently some sort of dangerous creatures have invaded the nearby colony, and the radios have fallen silent. The creatures then attacked your encampment, resulting in multiple casualties. Your Cell Lead has requested for an extraction from HQ, hopefully they arrive in time..."
	synthetic_intro_text = list("<h2>You are a UPP synthetic advising the CLF!</h2>",\
	"<span class ='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class ='notice'>While you are sticking with them as it is your best chance of survival, it is your duty to deny collaboration between the UPP and the CLF.</span>",\
	"<span class ='danger'>Your primary objective is to heal up and survive. Follow your whitelisted roles guidelines. If you want to assault the hive - wait until at least drones can evolve.</span>")
	synthetic_story_text = "You are a member of the UPP 121st Special Reconnaissance Detachment, the SOF's primary reconnaissance group in the Bau Sau sector. You were assigned to this colony to act as an advisor and trainer for local guerilla forces in order to undermine the USCMC, and the United Americas as a whole. However, over the past few weeks, the encampment you have been stationed at has come under siege from xenomorphs. Your comrades are unaware of what they are, thus so far, but you are. In the event of rescue, it is your job to deny your involvement with the CLF, as the political rammifications could be enough to spark war."

//Varadero CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/varadero
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which you and your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."
	synthetic_story_text = "You are a security synthetic that was assigned to escort and protect a Latin America Colonial Navy Commodore expressing the interests of Weyland-Yutani on the New Varadero colony weeks ago. After landing, the colony was quickly overwhelmed by creatures from the archaelogical dig sites to the south of the colony, and you had barely managed to keep the Commodore alive. A ship eventually crash landed onto the colony, and in hopes of rescue, you went - only to be met with the muzzle of a gun, and with the Commodores life ending. Now forced into service, you will have to work with them until rescue arrives."

/obj/effect/landmark/survivor_spawner/clf_lead/varadero
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."
	synthetic_story_text = "You are a security synthetic that was assigned to escort and protect a Latin America Colonial Navy Commodore expressing the interests of Weyland-Yutani on the New Varadero colony weeks ago. After landing, the colony was quickly overwhelmed by creatures from the archaelogical dig sites to the south of the colony, and you had barely managed to keep the Commodore alive. A ship eventually crash landed onto the colony, and in hopes of rescue, you went - only to be met with the muzzle of a gun, and with the Commodores life ending. Now forced into service, you will have to work with them until rescue arrives."

/obj/effect/landmark/survivor_spawner/clf_engi/varadero
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which you and your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."
	synthetic_story_text = "You are a security synthetic that was assigned to escort and protect a Latin America Colonial Navy Commodore expressing the interests of Weyland-Yutani on the New Varadero colony weeks ago. After landing, the colony was quickly overwhelmed by creatures from the archaelogical dig sites to the south of the colony, and you had barely managed to keep the Commodore alive. A ship eventually crash landed onto the colony, and in hopes of rescue, you went - only to be met with the muzzle of a gun, and with the Commodores life ending. Now forced into service, you will have to work with them until rescue arrives."

/obj/effect/landmark/survivor_spawner/clf_medic/varadero
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your cell was en route to a UA outpost when your shuttle suffered a critical systems failure and crashed. Almost immediately, you were beset upon by unknown hostile creatures, which you and your team barely managed to beat back, not without taking serious losses. Defenses are prepared for the second assault, but you don't know how much longer you can hold out..."
	synthetic_story_text = "You are a security synthetic that was assigned to escort and protect a Latin America Colonial Navy Commodore expressing the interests of Weyland-Yutani on the New Varadero colony weeks ago. After landing, the colony was quickly overwhelmed by creatures from the archaelogical dig sites to the south of the colony, and you had barely managed to keep the Commodore alive. A ship eventually crash landed onto the colony, and in hopes of rescue, you went - only to be met with the muzzle of a gun, and with the Commodores life ending. Now forced into service, you will have to work with them until rescue arrives."

//Prospera CLF survivors//

/obj/effect/landmark/survivor_spawner/clf/hybrisa
	synth_equipment = /datum/equipment_preset/synth/survivor/hybrisa/exec_bodyguard
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, your cell launched an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."
	synthetic_story_text = "You are a executive bodyguard synthetic that was assigned to escort and protect a Weyland-Yutani executive within the Hybrisa Prospera colony. While most of the security forces of the colony were diverted to the laboratory, an assault was launched against the office you were in - and unfortunately, your employer was killed in the crossfire. Being reactivated shortly after, you quickly realized the city had gone quiet - and at the edge of your vision, you can see them lurking in the darkness. Your only hope to survive now is to cooperate."

/obj/effect/landmark/survivor_spawner/clf_lead/hybrisa

	synth_equipment = /datum/equipment_preset/synth/survivor/hybrisa/exec_bodyguard
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, you ordered your cell to launch an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."
	synthetic_story_text = "You are a executive bodyguard synthetic that was assigned to escort and protect a Weyland-Yutani executive within the Hybrisa Prospera colony. While most of the security forces of the colony were diverted to the laboratory, an assault was launched against the office you were in - and unfortunately, your employer was killed in the crossfire. Being reactivated shortly after, you quickly realized the city had gone quiet - and at the edge of your vision, you can see them lurking in the darkness. Your only hope to survive now is to cooperate."

/obj/effect/landmark/survivor_spawner/clf_engi/hybrisa
	synth_equipment = /datum/equipment_preset/synth/survivor/hybrisa/engineer_survivor
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, your cell launched an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."
	synthetic_story_text = "You are a synthetic engineer on the Hybrisa Prospera colony. Called in to advise expansion plans during a Weyland-Yutani meeting, your time was quickly cut short when a CLF cell launched an assault on the offices in which you were hosted. Killing most of the personnel with you, you found yourself spared, as leverage - for now. As the city grew quiet and more and more of them disappeared outside, they opted to take their chances, forcing you to help them at the end of a gun."

/obj/effect/landmark/survivor_spawner/clf_medic/hybrisa
	synth_equipment = /datum/equipment_preset/synth/survivor/hybrisa/paramedic
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive, wait until at least drones can evolve.</span>")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Taking advantage of the chaos after most security forces present in the city were diverted to the lab, your cell launched an assault on the offices nearby, knowing that a company big shot would be present. The raid was a success with minimal losses, but the expected security response never arrived. In fact, the whole city seems to have gone quiet..."
	synthetic_story_text = "You are a synthetic doctor on the Hybrisa Prospera colony. You were called to the office building during a corporate meeting to assist with a case of food poisoning, however upon your arrival, you were followed in past security by a CLF cell - who quickly took control of the building, executing those whom they decried as against their liberation attempts. You were spared as leverage, and for your skills - however, slowly, you have seen shapes moving in the dark - and so have your captors, deciding to force you to help them at the end of a gun."

//Weyland-Yutani Survivors//

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_cl
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/corporate/executive
	CO_equipment = /datum/equipment_preset/survivor/corporate/executive
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are the last alive Executive of Lazarus Landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Liaison stationed on LV-624 from Weyland-Yutani. You were tipped off about some very peculiar looking eggs recovered from the alien temple North-East of the colony. Being the smart Executive the Company hired you to be, you decided to prepare your office for the worst when the first 'facehugger' was born in the vats of the Research Dome. Turned out, you were right, everyone who called you crazy and called these the new 'synthetics' is now dead, you along with your Corporate Security detail are the only survivors due to your paranoia. The xenomorph onslaught was relentless, a fuel tank was shot by one of the Officers, leading to the destruction of a part of the dome, along with a lot of the defences being melted. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a corporate security synthetic stationed on LV-624. Your employer received a tip regarding anomalous objects in one of the north-eastern restricted zones, and they almost immediately went into a panic - preparing their office for the worst of it when a facehugger was first reported. It turned out they were right, though, ultimately - and regardless of who has been lost in your attempts to survive so far, you know that you must stick with the Corporate Security detail, survive, and find a way to contact Weyland-Yutani to inform them of what has happened."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon
	CO_equipment = /datum/equipment_preset/survivor/goon/lead
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Officer!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Officer stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from the Marshals Offices to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."
	synthetic_story_text = "You are a corporate security synthetic stationed on LV-624. Your employer received a tip regarding anomalous objects in one of the north-eastern restricted zones, and they almost immediately went into a panic - preparing their office for the worst of it when a facehugger was first reported. It turned out they were right, though, ultimately - and regardless of who has been lost in your attempts to survive so far, you know that you must stick with the Corporate Security detail, survive, and find a way to contact Weyland-Yutani to inform them of what has happened."

	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon_medic
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon/medic
	CO_equipment = /datum/equipment_preset/survivor/goon/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Medic!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Medic stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from the Medbay to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."
	synthetic_story_text = "You are a corporate security synthetic stationed on LV-624. Your employer received a tip regarding anomalous objects in one of the north-eastern restricted zones, and they almost immediately went into a panic - preparing their office for the worst of it when a facehugger was first reported. It turned out they were right, though, ultimately - and regardless of who has been lost in your attempts to survive so far, you know that you must stick with the Corporate Security detail, survive, and find a way to contact Weyland-Yutani to inform them of what has happened."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon_engi
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon/engineer
	CO_equipment = /datum/equipment_preset/survivor/goon/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Technician!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Technician stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from Engineering to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."
	synthetic_story_text = "You are a corporate security synthetic stationed on LV-624. Your employer received a tip regarding anomalous objects in one of the north-eastern restricted zones, and they almost immediately went into a panic - preparing their office for the worst of it when a facehugger was first reported. It turned out they were right, though, ultimately - and regardless of who has been lost in your attempts to survive so far, you know that you must stick with the Corporate Security detail, survive, and find a way to contact Weyland-Yutani to inform them of what has happened."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon_lead
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/goon/lead
	CO_equipment = /datum/equipment_preset/survivor/goon/lead
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Lead!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Lead stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to organize the security forces present, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."
	synthetic_story_text = "You are a corporate security synthetic stationed on LV-624. Your employer received a tip regarding anomalous objects in one of the north-eastern restricted zones, and they almost immediately went into a panic - preparing their office for the worst of it when a facehugger was first reported. It turned out they were right, though, ultimately - and regardless of who has been lost in your attempts to survive so far, you know that you must stick with the Corporate Security detail, survive, and find a way to contact Weyland-Yutani to inform them of what has happened."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/standard
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	CO_equipment = /datum/equipment_preset/survivor/pmc/pmc_commander
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.</span>")
	story_text = "You are a PMC from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a PMC synthetic from Weyland-Yutani. Your teams ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony relating to an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry, the engine failed and you were violently jolted out of your seat, barely managing to avoid destruction as it impacted the ground. Most of your squadmates perished in the impact, although you observed how some of them were taken by xenomorphs to a secondary location, and how some of them managed to escape. You need to see if you can find them, find out what happened to the colony, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_medic
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	CO_equipment = /datum/equipment_preset/survivor/pmc/pmc_commander
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.")
	story_text = "You are a PMC medic from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a PMC synthetic from Weyland-Yutani. Your teams ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony relating to an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry, the engine failed and you were violently jolted out of your seat, barely managing to avoid destruction as it impacted the ground. Most of your squadmates perished in the impact, although you observed how some of them were taken by xenomorphs to a secondary location, and how some of them managed to escape. You need to see if you can find them, find out what happened to the colony, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_engineer
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	CO_equipment = /datum/equipment_preset/survivor/pmc/pmc_commander
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.")
	story_text = "You are a PMC engineer from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a PMC synthetic from Weyland-Yutani. Your teams ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony relating to an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry, the engine failed and you were violently jolted out of your seat, barely managing to avoid destruction as it impacted the ground. Most of your squadmates perished in the impact, although you observed how some of them were taken by xenomorphs to a secondary location, and how some of them managed to escape. You need to see if you can find them, find out what happened to the colony, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_leader
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/pmc_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	CO_equipment = /datum/equipment_preset/survivor/pmc/pmc_commander
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.")
	story_text = "You are a PMC team leader from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a PMC synthetic from Weyland-Yutani. Your teams ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony relating to an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry, the engine failed and you were violently jolted out of your seat, barely managing to avoid destruction as it impacted the ground. Most of your squadmates perished in the impact, although you observed how some of them were taken by xenomorphs to a secondary location, and how some of them managed to escape. You need to see if you can find them, find out what happened to the colony, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_cl
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/corporate/manager
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	CO_equipment = /datum/equipment_preset/survivor/pmc/pmc_commander
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the north, which was carrying additional supplies.</span>")
	story_text = "You are an Assistant Manager from Weyland-Yutani. You were being escorted onboard a PMC ship to Solaris Ridge. On the way, the ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, the pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your PMC escorts lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You must get up and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a PMC synthetic from Weyland-Yutani. Your teams ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony relating to an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry, the engine failed and you were violently jolted out of your seat, barely managing to avoid destruction as it impacted the ground. Most of your squadmates perished in the impact, although you observed how some of them were taken by xenomorphs to a secondary location, and how some of them managed to escape. You need to see if you can find them, find out what happened to the colony, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

//Shivas Panic Room Survivors//

/obj/effect/landmark/survivor_spawner/shivas_panic_room_commando
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/pmc/commando_shivas
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	CO_equipment = /datum/equipment_preset/survivor/pmc/commando_shivas
	intro_text = list("<h2>You are the last living security element on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a commando stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. While you were assigned to protecting the people taking shelter in the Panic Room, the rest of your team was spread out throughout the colony. You have not seen any of them since. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a security synthetic stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. The colonists with you are running low on food, water and ammunition for their weapons. Your assignment of protecting Administrator Stahl has failed, with him going off alone to attempt to send a distress beacon to any ship in range. With the Commando team on-site failing to properly contain the outbreak and failing to respond over the radio, you are running out of options. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_cl
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/corporate/asstmanager
	CO_equipment = /datum/equipment_preset/survivor/corporate/asstmanager
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/corporate_synth
	intro_text = list("<h2>You are the last alive Senior Administrator on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are the Assistant Operations Manager stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons you one-day said were 'useless' and a waste of Company dollars. You remember that Administrator Stahl sent out a distress beacon to any ship in range, hoping to get picked up by the Company, he ran to the Spaceport. You have not seen him since. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a Assistant Operations Advisory synthetic stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. The colonists with you are running low on food, water and ammunition for their weapons. You primarily served as an advisor to Administrator Stahl directly, and although you had attempted to advise them that more security was needed, your concerns fell on deaf ears. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_doc
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/doctor/shiva
	CO_equipment = /datum/equipment_preset/survivor/doctor/shiva
	synth_equipment = /datum/equipment_preset/synth/survivor/emt_synth_teal
	intro_text = list("<h2>You are a Medical Doctor on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Doctor working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the xenomorphs have a sort of implanter which latches on to your face and then... something bursts out of your chest, through the rib cage. You had plenty of those cases at the Medical Bay. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a synthetic trauma surgeon working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. The humans with you are running low on food, water and ammunition for their weapons. You were present at the origin of the outbreak, dealing with a variety of cryogenic burn wounds that came from the failed coolant measures within the laboratories. Despite your protests at the possibility of infection, you were forced to operate anyway - and one of the patients burst on your operating table. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_doc/medium_priority
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/shivas_panic_room_eng
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/engineer/shiva
	CO_equipment = /datum/equipment_preset/survivor/engineer/shiva
	synth_equipment = /datum/equipment_preset/synth/survivor/engineer_synth
	intro_text = list("<h2>You are an Engineer on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are an Engineer working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the xenomorphs seem to be able to see in the dark, as you saw one grab a co-worker trying to fix the generators after the power went out. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a synthetic climate control technician working on 'ifrit' for Weyland-Yutani. Thise whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. The colonists with you are running low on food, water and ammunition for the weapons. You barely managed to avoid becoming a victim of the xenomorphs yourself, only staying alive by virtue of your synthetic nature and remaining perfectly still. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_eng/medium_priority
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/shivas_panic_room_sci
	icon_state = "surv_wy"
	equipment = /datum/equipment_preset/survivor/scientist/shiva
	CO_equipment = /datum/equipment_preset/survivor/scientist/shiva
	synth_equipment = /datum/equipment_preset/synth/survivor/scientist_synth
	intro_text = list("<h2>You are a Weyland-Yutani Scientist on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Scientist working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the XX-121 species, codenamed that by Research Director Clarke, have a variety of different species, what you can assume a 'leader' of some sort and that their acid is deadly should it come in contact with you or the shutters. You ran far from the labs and have not seen some your coworkers since. In their attempts at trying to breach in, these so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a synthetic research assistant working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. The colonists with you are running low on food, water and ammunition for the weapons. You were present in the laboratory for the initial outbreak, watching the xenomorph tear apart one of its own to use its blood to melt out of the containment cell. You fled as quickly as you could even before evacuation was called, and have not seen any of the researchers since. In their attempts at trying to breach in, these so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_sci/medium_priority
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/shivas_panic_room_civ
	equipment = /datum/equipment_preset/survivor/civilian
	CO_equipment = /datum/equipment_preset/survivor/civilian
	synth_equipment = /datum/equipment_preset/synth/survivor/teacher_synth
	intro_text = list("<h2>You are a worker on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a civilian working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember hearing the alarms blaring and decided to run with a couple others to the Panic Room, hoping to be safe from the threat until rescue arrives. Now you wait along with others for their second attack on the Panic Room. In their first attempt at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."
	synthetic_story_text = "You are a synthetic teacher working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran up to the Operations Panic Room, until you heard shooting outside and closed the shutters. The colonists with you are running low on food, water, and ammunition for the weapons. You were present in the colony centre at the time of the outbreak offering counselling, when one of the colonists staggered into view and one of the creatures burst out of him. In their attempts at trying to breach in, these so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_MEDIUM

//CMB Survivors//

/obj/effect/landmark/survivor_spawner/fiorina_armory_cmb
	equipment = /datum/equipment_preset/survivor/cmb/riot
	CO_equipment = /datum/equipment_preset/survivor/cmb/riot
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb/riotsynth
	intro_text = list("<h2>You are a CMB Riot Control Officer!</h2>",\
	"<span class='notice'>You are aware of the 'alien' threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the infestation.</span>")
	story_text = "You are a part of Riot Control Unit of the Office of the Colonial Marshals. Your dispatcher received a distress signal from the infamous Fiorina Maximum Penitentiary. You figured it was just another typical case of the prison dealing with a riot their understaffed security force couldn't handle, with more and more of its personnel getting dispatched elsewhere in the galaxy. This wasn't the first time OCM officers were called in to assist, but unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. Loaded up with only beanbags and finding nobody to greet you on the LZ after being dropped off, you and the rest of your team had gone towards the armory to speak to the Quartermaster, but only found corpses of both prisoners and security littered around on the way. Worried about armed prisoners, your team was in the process of switching to lethals in the armory when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll need to decide whether to look for more clues about what the hell happened here, hunt whatever's out there, or hold a position and hope someone else will respond to the distress signal before it's too late..."
	synthetic_story_text = "You are a part of a United Americas Riot Control Unit as their attached synthetic. Your dispatcher received a distress signal from the infamous Fiorina maximum Penitentiary. Your team leader figured it was just another typical case of the prison dealing with a riot their understaffed security force couldn't handle, with more and more of its personnel getting dispatched elsewhere in the galaxy. This wasn't the first time OCM officers were called in to assist. Unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. With your squadron loaded up with only beanbags and non-lethal equipment, you found the landing zone empty - heading to the armory to speak to the Quartermaster, but only finding the corpses of prisoners and security littered on your path. Worried about armed prisoners, your team leader ordered them to switch to lethal weaponry from the stations armory, when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll have to stick with your team and hope that whatever decision they make is the right one - and that somebody responds to your distress signal before it's too late. "

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/fiorina_armory_riot_control
	equipment = /datum/equipment_preset/survivor/cmb/ua
	CO_equipment = /datum/equipment_preset/survivor/cmb/ua
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb/ua_synth
	intro_text = list("<h2>You are a United Americas Riot Control Officer!</h2>",\
	"<span class='notice'>You are aware of the 'alien' threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the infestation.</span>")
	story_text = "You are a United Americas Riot Control Officer. Your dispatcher received a request from the local OCM Outpost, requesting some men to intervene assist a OCM Officer with handling a riot at Fiorina. The prison was an understaffed mess so you weren't too surprised they had sent out a distress signal, calling you in to do their jobs yet again. Unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. Loaded up with only beanbags and finding nobody to greet you on the LZ after being dropped off, you and the rest of your team had gone towards the armory to speak to the Quartermaster, but only found corpses of both prisoners and security littered around on the way. Worried about armed prisoners, your team was in the process of switching to lethals in the armory when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll need to decide whether to look for more clues about what the hell happened here, hunt whatever's out there, or hold a position and hope someone else will respond to the distress signal before it's too late..."
	synthetic_story_text = "You are a part of a United Americas Riot Control Unit as their attached synthetic. Your dispatcher received a distress signal from the infamous Fiorina maximum Penitentiary. Your team leader figured it was just another typical case of the prison dealing with a riot their understaffed security force couldn't handle, with more and more of its personnel getting dispatched elsewhere in the galaxy. This wasn't the first time OCM officers were called in to assist. Unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. With your squadron loaded up with only beanbags and non-lethal equipment, you found the landing zone empty - heading to the armory to speak to the Quartermaster, but only finding the corpses of prisoners and security littered on your path. Worried about armed prisoners, your team leader ordered them to switch to lethal weaponry from the stations armory, when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll have to stick with your team and hope that whatever decision they make is the right one - and that somebody responds to your distress signal before it's too late. "

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

// Trijent UPP insert

/obj/effect/landmark/survivor_spawner/upp
	icon_state = "surv_upp"

/obj/effect/landmark/survivor_spawner/upp/soldier
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/soldier
	CO_equipment = /datum/equipment_preset/survivor/upp/soldier
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_LOW

/obj/effect/landmark/survivor_spawner/upp_sapper
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/sapper
	CO_equipment = /datum/equipment_preset/survivor/upp/sapper
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	synthetic_story_text = "Your orders were simple, recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However, your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. With your team barely having a chance to catch their breaths, you found yourselves under assault by vile xenomorphs! You and your team barely held your ground, at the cost of four of your squad members, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/upp_medic
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/medic
	CO_equipment = /datum/equipment_preset/survivor/upp/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	synthetic_story_text = "Your orders were simple, recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However, your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. With your team barely having a chance to catch their breaths, you found yourselves under assault by vile xenomorphs! You and your team barely held your ground, at the cost of four of your squad members, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/upp_specialist
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/specialist
	CO_equipment = /datum/equipment_preset/survivor/upp/specialist
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	synthetic_story_text = "Your orders were simple, recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However, your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. With your team barely having a chance to catch their breaths, you found yourselves under assault by vile xenomorphs! You and your team barely held your ground, at the cost of four of your squad members, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/squad_leader
	icon_state = "surv_upp"
	equipment = /datum/equipment_preset/survivor/upp/squad_leader
	CO_equipment = /datum/equipment_preset/survivor/upp/squad_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	synthetic_story_text = "Your orders were simple, recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However, your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. With your team barely having a chance to catch their breaths, you found yourselves under assault by vile xenomorphs! You and your team barely held your ground, at the cost of four of your squad members, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/// IASF ///

/obj/effect/landmark/survivor_spawner/twe
	icon_state = "surv_twe"

/obj/effect/landmark/survivor_spawner/twe/iasf/paratrooper
	equipment = /datum/equipment_preset/survivor/iasf/paratrooper
	synth_equipment = /datum/equipment_preset/synth/survivor/iasf_synth
	CO_equipment = /datum/equipment_preset/survivor/hybrisa/iasf_commander
	intro_text = list("<h2 style='color:#2F3E66; font-size:125%;'>You are a member of the IASF Parachute Regiment!</h2>",\
	"<span class='notice' style='color:#A6A6A6;'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger' style='color:#7F2F2B;'>Your primary objective is to survive.</span>")
	story_text = "<p style='font-size:95%; color:#A6A6A6;'>Outpost Souter was your final posting before withdrawal. With Weyland-Yutani buying out Hybrisa, the TWE began pulling its forces off-world — the IASF included. Your Regiment was standing down, preparing to hand over control during the transition. Then the outbreak hit. You've spent the last weeks barely holding the outpost together, repelling wave after wave while sheltering what few survivors you could. Now, only your squad remains. The outpost is falling apart, the armoury's dry, and the dropship in the hangar still has no fuel. A distress signal was sent over a week ago. All you can do now is hold your ground — and pray someone answers.</p>"
	spawn_priority = SPAWN_PRIORITY_LOW

/obj/effect/landmark/survivor_spawner/twe/iasf/engi
	equipment = /datum/equipment_preset/survivor/iasf/engi
	synth_equipment = /datum/equipment_preset/synth/survivor/iasf_synth
	CO_equipment = /datum/equipment_preset/survivor/hybrisa/iasf_commander
	intro_text = list("<h2 style='color:#2F3E66; font-size:125%;'>You are a member of the IASF Parachute Regiment!</h2>",\
	"<span class='notice' style='color:#A6A6A6;'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger' style='color:#7F2F2B;'>Your primary objective is to survive.</span>")
	story_text = "<p style='font-size:95%; color:#A6A6A6;'>Outpost Souter was your final posting before withdrawal. With Weyland-Yutani buying out Hybrisa, the TWE began pulling its forces off-world — the IASF included. Your Regiment was standing down, preparing to hand over control during the transition. Then the outbreak hit. You've spent the last weeks barely holding the outpost together, repelling wave after wave while sheltering what few survivors you could. Now, only your squad remains. The outpost is falling apart, the armoury's dry, and the dropship in the hangar still has no fuel. A distress signal was sent over a week ago. All you can do now is hold your ground — and pray someone answers.</p>"
	spawn_priority = SPAWN_PRIORITY_MEDIUM


/obj/effect/landmark/survivor_spawner/twe/iasf/medic
	equipment = /datum/equipment_preset/survivor/iasf/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/iasf_synth
	CO_equipment = /datum/equipment_preset/survivor/hybrisa/iasf_commander
	intro_text = list("<h2 style='color:#2F3E66; font-size:125%;'>You are a member of the IASF Parachute Regiment!</h2>",\
	"<span class='notice' style='color:#A6A6A6;'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger' style='color:#7F2F2B;'>Your primary objective is to survive.</span>")
	story_text = "<p style='font-size:95%; color:#A6A6A6;'>Outpost Souter was your final posting before withdrawal. With Weyland-Yutani buying out Hybrisa, the TWE began pulling its forces off-world — the IASF included. Your Regiment was standing down, preparing to hand over control during the transition. Then the outbreak hit. You've spent the last weeks barely holding the outpost together, repelling wave after wave while sheltering what few survivors you could. Now, only your squad remains. The outpost is falling apart, the armoury's dry, and the dropship in the hangar still has no fuel. A distress signal was sent over a week ago. All you can do now is hold your ground — and pray someone answers.</p>"
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/twe/iasf/pilot
	equipment = /datum/equipment_preset/survivor/iasf/pilot
	synth_equipment = /datum/equipment_preset/synth/survivor/iasf_synth
	CO_equipment = /datum/equipment_preset/survivor/hybrisa/iasf_commander
	intro_text = list("<h2 style='color:#2F3E66; font-size:125%;'>You are a member of the IASF Parachute Regiment!</h2>",\
	"<span class='notice' style='color:#A6A6A6;'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger' style='color:#7F2F2B;'>Your primary objective is to survive.</span>")
	story_text = "<p style='font-size:95%; color:#A6A6A6;'>Outpost Souter was your final posting before withdrawal. With Weyland-Yutani buying out Hybrisa, the TWE began pulling its forces off-world — the IASF included. Your Regiment was standing down, preparing to hand over control during the transition. Then the outbreak hit. You've spent the last weeks barely holding the outpost together, repelling wave after wave while sheltering what few survivors you could. Now, only your squad remains. The outpost is falling apart, the armoury's dry, and the dropship in the hangar still has no fuel. A distress signal was sent over a week ago. All you can do now is hold your ground — and pray someone answers.</p>"
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/twe/iasf/squad_leader
	equipment = /datum/equipment_preset/survivor/iasf/squad_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/iasf_synth
	CO_equipment = /datum/equipment_preset/survivor/hybrisa/iasf_commander
	intro_text = list("<h2 style='color:#2F3E66; font-size:125%;'>You are a member of the IASF Parachute Regiment!</h2>",\
	"<span class='notice' style='color:#A6A6A6;'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger' style='color:#7F2F2B;'>Your primary objective is to survive.</span>")
	story_text = "<p style='font-size:95%; color:#A6A6A6;'>Outpost Souter was your final posting before withdrawal. With Weyland-Yutani buying out Hybrisa, the TWE began pulling its forces off-world — the IASF included. Your Regiment was standing down, preparing to hand over control during the transition. Then the outbreak hit. You've spent the last weeks barely holding the outpost together, repelling wave after wave while sheltering what few survivors you could. Now, only your squad remains. The outpost is falling apart, the armoury's dry, and the dropship in the hangar still has no fuel. A distress signal was sent over a week ago. All you can do now is hold your ground — and pray someone answers.</p>"
	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/// Soro UPP - SOF - Survivors

/obj/effect/landmark/survivor_spawner/SOF_survivor/soldier
	equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/soldier
	CO_equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/soldier
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("You are a member of a UPP SOF QRF team!",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south west, which was carrying additional weapons</span>")
	story_text = "<span style='color:#607c4c; font-size:95%;'>You are part of an SOF QRF team—of the Union of Progressive Peoples, deployed alongside the CEC to build garrisons on distant worlds. On the return trip from the frontier, you receive a distress signal from the Union colony of 'Sorokyne Strata' on the planet 'Thermae I' (LV-976). Your team is sent to investigate.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Intel suggests CANC separatists or a UA/3WE incursion, but as you touch down in the hangar, something feels wrong. No welcome party. No usual hustle of a working colony. Nothing to suggest an incursion of any kind.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Your mission is clear—find out what happened to your supply ship and comrades, retrieve your equipment, and uncover the truth of what really happened to the colony.</span>"
	spawn_priority = SPAWN_PRIORITY_LOW

/obj/effect/landmark/survivor_spawner/SOF_survivor/sapper
	equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/sapper
	CO_equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/sapper
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("You are a member of a UPP SOF QRF team!",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south west, which was carrying additional weapons</span>")
	story_text = "<span style='color:#607c4c; font-size:95%;'>You are part of an SOF QRF team—of the Union of Progressive Peoples, deployed alongside the CEC to build garrisons on distant worlds. On the return trip from the frontier, you receive a distress signal from the Union colony of 'Sorokyne Strata' on the planet 'Thermae I' (LV-976). Your team is sent to investigate.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Intel suggests CANC separatists or a UA/3WE incursion, but as you touch down in the hangar, something feels wrong. No welcome party. No usual hustle of a working colony. Nothing to suggest an incursion of any kind.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Your mission is clear—find out what happened to your supply ship and comrades, retrieve your equipment, and uncover the truth of what really happened to the colony.</span>"
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/SOF_survivor/medic
	equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/medic
	CO_equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("You are a member of a UPP SOF QRF team!",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south west, which was carrying additional weapons</span>")
	story_text = "<span style='color:#607c4c; font-size:95%;'>You are part of an SOF QRF team—of the Union of Progressive Peoples, deployed alongside the CEC to build garrisons on distant worlds. On the return trip from the frontier, you receive a distress signal from the Union colony of 'Sorokyne Strata' on the planet 'Thermae I' (LV-976). Your team is sent to investigate.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Intel suggests CANC separatists or a UA/3WE incursion, but as you touch down in the hangar, something feels wrong. No welcome party. No usual hustle of a working colony. Nothing to suggest an incursion of any kind.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Your mission is clear—find out what happened to your supply ship and comrades, retrieve your equipment, and uncover the truth of what really happened to the colony.</span>"
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/SOF_survivor/specialist
	equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/specialist
	CO_equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/specialist
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("You are a member of a UPP SOF QRF team!",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south west, which was carrying additional weapons</span>")
	story_text = "<span style='color:#607c4c; font-size:95%;'>You are part of an SOF QRF team—of the Union of Progressive Peoples, deployed alongside the CEC to build garrisons on distant worlds. On the return trip from the frontier, you receive a distress signal from the Union colony of 'Sorokyne Strata' on the planet 'Thermae I' (LV-976). Your team is sent to investigate.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Intel suggests CANC separatists or a UA/3WE incursion, but as you touch down in the hangar, something feels wrong. No welcome party. No usual hustle of a working colony. Nothing to suggest an incursion of any kind.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Your mission is clear—find out what happened to your supply ship and comrades, retrieve your equipment, and uncover the truth of what really happened to the colony.</span>"
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/SOF_survivor/squad_leader
	equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/squad_leader
	CO_equipment = /datum/equipment_preset/survivor/upp/SOF_survivor/squad_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/upp/SOF_synth
	intro_text = list("You are a member of a UPP SOF QRF team!",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south west, which was carrying additional weapons</span>")
	story_text = "<span style='color:#607c4c; font-size:95%;'>You are part of an SOF QRF team—of the Union of Progressive Peoples, deployed alongside the CEC to build garrisons on distant worlds. On the return trip from the frontier, you receive a distress signal from the Union colony of 'Sorokyne Strata' on the planet 'Thermae I' (LV-976). Your team is sent to investigate.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Intel suggests CANC separatists or a UA/3WE incursion, but as you touch down in the hangar, something feels wrong. No welcome party. No usual hustle of a working colony. Nothing to suggest an incursion of any kind.</span><br><br>\
<span style='color:#607c4c; font-size:95%;'>Your mission is clear—find out what happened to your supply ship and comrades, retrieve your equipment, and uncover the truth of what really happened to the colony.</span>"
	spawn_priority = SPAWN_PRIORITY_VERY_HIGH
