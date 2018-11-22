/obj/effect/landmark/survivor_spawner
	var/equipment = ""
	var/list/intro_text = list()
	var/story_text = ""
	var/roundstart_damage_min = 0
	var/roundstart_damage_max = 0
	var/roundstart_damage_times = 1
	var/make_objective = 1

/obj/effect/landmark/survivor_spawner/New()
	..()
	tag = "landmark*survivor_spawner"
	invisibility = 101
	surv_spawn += src

/obj/effect/landmark/survivor_spawner/lv624_skylight
	intro_text = list("<h2>You are a survivor!</h2>",\
	"\blue You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks...until now.",\
	"\blue You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit.",\
	"\red Your primary objective is to heal up and survive until marines rescue you. If you want to assault the hive - adminhelp.")
	story_text = "You with a small group made a run for the caves after an attack on the colony. Unfortunately during the escape you all got ambushed by one of the xenomorphs. Limping away, you and your friends found a shelter in the caves, in a place with a nice skylight above. You mustered a defence, ignoring wounds that creature dealt to you. It will be a good idea to heal up, before you attempt anything."
	roundstart_damage_min = 20
	roundstart_damage_max = 25
	roundstart_damage_times = 3
	make_objective = 1

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf
	equipment = "CLF Survivor"
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"\blue You are NOT aware of the xenomorph threat.",\
	"\red Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.")
	story_text = "You are a soldier of Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rose up and noticed that one of your limbs is at a weird angle, broken. You looked at other survivors, also limping and trying to fix their broken bones. \red You also notice that sentry turrets on the ramp of your ship beep angrily, it seems their logic circuits got damaged. They will identify you as a foe, but at least they will identify everything as a foe."
	roundstart_damage_min = 30
	roundstart_damage_max = 35
	roundstart_damage_times = 2
	make_objective = 0
