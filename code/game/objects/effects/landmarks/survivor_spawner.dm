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
	return TRUE

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf
	hostile = TRUE
	equipment = /datum/equipment_preset/survivor/clf
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_leader
	hostile = TRUE
	equipment = /datum/equipment_preset/clf/leader
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are the leader of a squad fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants and under your orders, you and your team small boarded a small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of your pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked up at the few remaining survivors of your squad, all limping and trying to tend to their wounds, luckily, none of your men were seriously hurt, and all seem to be responsive to your orders."
	roundstart_damage_min = 2
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_engineer
	hostile = TRUE
	equipment = /datum/equipment_preset/clf/engineer
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are an engineer fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf_medic
	hostile = TRUE
	equipment = /datum/equipment_preset/clf/medic
	synth_equipment = /datum/equipment_preset/clf/synth
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a doctor fighting for the Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rise up and notice that one of your limbs is badly bruised. You looked at other survivors, also limping and trying to tend to their wounds, luckily, none of you were seriously hurt."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

//Weyland-Yutani Survivors//

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_cl
	equipment = /datum/equipment_preset/survivor/wy/executive
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are the last alive Executive of Lazarus Landing!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Liaison stationed on LV-624 from Weyland-Yutani. You were tipped off about some very peculiar looking eggs recovered from the alien temple North-East of the colony. Being the smart Executive the Company hired you to be, you decided to prepare your office for the worst when the first 'facehugger' was born in the vats of the Research Dome. Turned out, you were right, everyone who called you crazy and called these the new 'synthetics' is now dead, you along with your Corporate Security detail are the only survivors due to your paranoia. The xenomorph onslaught was relentless, a fuel tank was shot by one of the Officers, leading to the destruction of a part of the dome, along with alot of the defences being melted. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/lv624_corporate_dome_goon
	equipment = /datum/equipment_preset/survivor/goon
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/security_synth
	intro_text = list("<h2>You are a Corporate Security Officer!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Corporate Security Officer stationed on LV-624 from Weyland-Yutani. Suddenly one day you were pulled aside by the Corporate Liaison and told to bring supplies from both Engineering and the Marshals Offices to their office, and fast. You began fortifying the Corporate Dome and was told by the Executive that something big will ravage the entire colony, excluding you. Turns out, the Liaison was right, these so called 'xenomorphs' broke containment from the Research Dome and began destroying the entire colony. Once they came for the Dome and tried to kill all of you, you barely managed to hold them off even after losing one Officer and alot of the defences. The Liaison said they will soon find a way to contact Weyland-Yutani and to remain steadfast until rescue arrives."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	equipment = /datum/equipment_preset/survivor/pmc
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a PMC from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_medic
	equipment = /datum/equipment_preset/survivor/pmc/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a PMC medic from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc_engineer
	equipment = /datum/equipment_preset/survivor/pmc/engineer
	synth_equipment = /datum/equipment_preset/synth/survivor/pmc
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"You are NOT aware of the xenomorph threat.",\
	"Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a PMC engineer from Weyland-Yutani. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weyland-Yutani."
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
	story_text = "You are an Assistant Manager from Weyland-Yutani. You were being escorted onboard a PMC ship to Solaris Ridge. On the way, the ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, the pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconscious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your PMC escorts lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You must get up and find a way to contact Weyland-Yutani."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_cl
	equipment = /datum/equipment_preset/survivor/wy/asstmanager
	synth_equipment = /datum/equipment_preset/synth/survivor/wy/corporate_synth
	intro_text = list("<h2>You are the last alive Senior Administrator on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are the Assistant Operations Manager stationed on 'Ifrit' by Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons you one-day said were 'useless' and a waste of Company dollars. You remember that Administrator Stahl sent out a distress beacon to any ship in range, hoping to get picked up by the Company, he ran to the Spaceport. You have not seen him since. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_doc
	equipment = /datum/equipment_preset/survivor/doctor
	synth_equipment = /datum/equipment_preset/synth/survivor/emt_synth
	intro_text = list("<h2>You are a Medical Doctor on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Doctor working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the xenomorphs have a sort of implanter which latches on to your face and then... something bursts out of your chest, through the rib cage. You had plenty of those cases at the Medical Bay. In their attempts at trying to breach in, the so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/shivas_panic_room_sci
	equipment = /datum/equipment_preset/survivor/scientist
	synth_equipment = /datum/equipment_preset/synth/survivor/scientist_synth
	intro_text = list("<h2>You are a Weyland-Yutani Scientist on the Colony!</h2>",\
	"<span class='notice'>You are aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the outbreak.</span>")
	story_text = "You are a Scientist working on 'Ifrit' for Weyland-Yutani. This whole outbreak has been a giant mess, you and all other Company personnel ran to the Operations Panic Room, until you heard shooting outside and closed the shutters. You are running low on food, water and ammunition for the weapons. You remember that the XX-121 species, codenamed that by Research Director Clarke, have a variety of different species, what you can assume a 'leader' of some sort and that their acid is deadly should it come in contact with you or the shutters. You ran far from the labs and have not seen some your coworkers since. In their attempts at trying to breach in, these so called 'xenomorphs' have tried attacking the shutters, but to no avail. They will soon try again. You must survive and find a way to contact Weyland-Yutani."

	spawn_priority = SPAWN_PRIORITY_HIGH

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
	equipment = /datum/equipment_preset/survivor/cmb/standard
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb/synth
	intro_text = list("<h2>You are a CMB Deputy!</h2>",\
	"<span class='notice'>You are aware of the 'alien' threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the infestation.</span>")
	story_text = "You are a Deputy of the Office of the Colonial Marshals. Your dispatcher received a distress signal from the infamous Fiorina Maximum Penitentiary. You figured it was just another typical case of the prison dealing with a riot their understaffed security force couldn't handle, with more and more of its personnel getting dispatched elsewhere in the galaxy. This wasn't the first time OCM officers were called in to assist, but unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. Loaded up with only beanbags and finding nobody to greet you on the LZ after being dropped off, you and the rest of your team had gone towards the armory to speak to the Quartermaster, but only found corpses of both prisoners and security littered around on the way. Worried about armed prisoners, your team was in the process of switching to lethals in the armory when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll need to decide whether to look for more clues about what the hell happened here, hunt whatever's out there, or hold a position and hope someone else will respond to the distress signal before it's too late..."

	spawn_priority = SPAWN_PRIORITY_VERY_HIGH

/obj/effect/landmark/survivor_spawner/fiorina_armory_riot_control
	equipment = /datum/equipment_preset/survivor/cmb/ua
	synth_equipment = /datum/equipment_preset/synth/survivor/cmb/ua_synth
	intro_text = list("<h2>You are a United Americas Riot Control Officer!</h2>",\
	"<span class='notice'>You are aware of the 'alien' threat.</span>",\
	"<span class='danger'>Your primary objective is to survive the infestation.</span>")
	story_text = "You are a United Americas Riot Control Officer. Your dispatcher received a request from the local OCM Outpost, requesting some men to intervene assist a Deputy with handling a riot at Fiorina. The prison was an understaffed mess so you weren't too surprised they had sent out a distress signal, calling you in to do their jobs yet again. Unfortunately for you, this time it also wasn't the 'minor riot' you expected it to be. Loaded up with only beanbags and finding nobody to greet you on the LZ after being dropped off, you and the rest of your team had gone towards the armory to speak to the Quartermaster, but only found corpses of both prisoners and security littered around on the way. Worried about armed prisoners, your team was in the process of switching to lethals in the armory when some sort of huge alien jumped out from the shadows and snatched Jerry away while he was off praying. The thing dragged him off too fast to catch and his screams faded away down the halls, poor bastard. Now, you'll need to decide whether to look for more clues about what the hell happened here, hunt whatever's out there, or hold a position and hope someone else will respond to the distress signal before it's too late..."

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
	equipment = /datum/equipment_preset/survivor/upp/soldier
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_LOW

/obj/effect/landmark/survivor_spawner/upp_sapper
	equipment = /datum/equipment_preset/survivor/upp/sapper
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/upp_medic
	equipment = /datum/equipment_preset/survivor/upp/medic
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_MEDIUM

/obj/effect/landmark/survivor_spawner/upp_specialist
	equipment = /datum/equipment_preset/survivor/upp/specialist
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_HIGH

/obj/effect/landmark/survivor_spawner/squad_leader
	equipment = /datum/equipment_preset/survivor/upp/squad_leader
	synth_equipment = /datum/equipment_preset/synth/survivor/upp
	intro_text = list("<h2>You are a member of a UPP recon force!</h2>",\
	"<span class='notice'>You ARE aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to survive. You believe a second dropship crashed somewhere to the south east, which was carrying additional weapons</span>")
	story_text = "Your orders were simple, Recon the site, ascertain if there is a biological weapons program in the area, and if so to secure the colony and retrieve a sample. However your team failed to account for an active anti-air battery near the area. Both your craft and your sister ship crashed. Barely having a chance to catch your breath, you found yourself being assailed by vile xenomorphs! You and your team have barely held your ground, at the cost of four of your own, but more are coming and ammo is low. You believe an American rescue force is en route."
	spawn_priority = SPAWN_PRIORITY_VERY_HIGH
