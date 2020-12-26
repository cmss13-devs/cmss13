/obj/effect/landmark/survivor_spawner
	name = "special survivor spawner"
	var/equipment = ""
	var/list/intro_text = list()
	var/story_text = ""
	var/roundstart_damage_min = 0
	var/roundstart_damage_max = 0
	var/roundstart_damage_times = 1
	var/make_objective = 1

/obj/effect/landmark/survivor_spawner/Initialize(mapload, ...)
	. = ..()
	GLOB.survivor_spawns += src

/obj/effect/landmark/survivor_spawner/Destroy()
	GLOB.survivor_spawns -= src
	return ..()
/obj/effect/landmark/survivor_spawner/lv624_skylight
	intro_text = list("<h2>You are a survivor!</h2>",\
	"<span class='notice'>You are a survivor of the attack on the colony. You worked or lived in the archaeology colony, and managed to avoid the alien attacks...until now.</span>",\
	"<span class='notice'>You are fully aware of the xenomorph threat and are able to use this knowledge as you see fit.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive until marines rescue you. If you want to assault the hive - adminhelp.</span>")
	story_text = "You with a small group made a run for the caves after an attack on the colony. Unfortunately during the escape you all got ambushed by one of the xenomorphs. Limping away, you and your friends found a shelter in the caves, in a place with a nice skylight above. You mustered a defence, ignoring wounds that creature dealt to you. It will be a good idea to heal up, before you attempt anything."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 3
	make_objective = 1

/obj/effect/landmark/survivor_spawner/lv624_crashed_clf
	equipment = "CLF Survivor"
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a soldier of Colonial Liberation Front. Your ship received a distress signal from a planet bordering the CLF controlled space under USCM control. Ready and willing to save poor colonists from parasitic tyrants, you and your team boarded small ship called Marie Curie. Unfortunately, right before you came close to a landing zone, a glob of acid hit the ship, damaging one of the engines. Despite all the efforts of the pilot, the ship went straight into nearby mountain. You were hurt pretty badly in the crash. Dumbfounded, you rose up and noticed that one of your limbs is at a weird angle, broken. You looked at other survivors, also limping and trying to fix their broken bones. \red You also notice that sentry turrets on the ramp of your ship beep angrily, it seems their logic circuits got damaged. They will identify you as a foe, but at least they will identify everything as a foe."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2
	make_objective = 0

/obj/effect/landmark/survivor_spawner/bigred_crashed_pmc
	equipment = "Survivor - PMC"
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are a PMC from Weston-Yamada. Your ship was enroute to Solaris Ridge to escort an Assistant Manager. On the way, your ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, your pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. Your squadmates lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You need to find out what happened to the colony, see if you can find any of your squadmates, and find a way to contact Weston-Yamada."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2
	make_objective = 0

/obj/effect/landmark/survivor_spawner/bigred_crashed_cl
	equipment = "Survivor - Corporate Supervisor"
	intro_text = list("<h2>You are a survivor of a crash landing!</h2>",\
	"<span class='notice'>You are NOT aware of the xenomorph threat.</span>",\
	"<span class='danger'>Your primary objective is to heal up and survive. If you want to assault the hive - adminhelp.</span>")
	story_text = "You are an Assistant Manager from Weston-Yamada. You were being escorted onboard a PMC ship to Solaris Ridge. On the way, the ship received a distress signal from the colony about an attack. Worried that it might be a CLF attack, the pilot set full speed for the colony. However, during atmospheric entry the engine failed and you fell unconcious from the G-Forces. You wake up wounded... and see that the ship has crashed onto the colony. The shipcrew lie dead beside you, but there's some missing. Perhaps they survived and moved elsewhere? You must get up and find a way to contact Weston-Yamada."
	roundstart_damage_min = 3
	roundstart_damage_max = 10
	roundstart_damage_times = 2
	make_objective = 1
