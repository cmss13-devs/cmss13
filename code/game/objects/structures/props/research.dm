/obj/structure/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/structures/machinery/research.dmi'
	density = 1
	anchored = 1
	use_power = 1


/obj/structure/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	flags_atom = OPENCONTAINER
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/structure/machinery/r_n_d/circuit_imprinter/Initialize()
		..()
		component_parts = list()
		component_parts += new /obj/item/circuitboard/machine/circuit_imprinter(src)
		component_parts += new /obj/item/stock_parts/matter_bin(src)
		component_parts += new /obj/item/stock_parts/manipulator(src)
		component_parts += new /obj/item/reagent_container/glass/beaker(src)
		component_parts += new /obj/item/reagent_container/glass/beaker(src)
		RefreshParts()

/obj/structure/machinery/r_n_d/server
	name = "R&D Server"
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	health = 100
	idle_power_usage = 800
	req_access = list(ACCESS_MARINE_CMO) //Only the R&D can change server settings.


/obj/structure/machinery/r_n_d/server/Initialize()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/rdserver(src)
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	RefreshParts()

/obj/structure/machinery/r_n_d/server/centcom
	name = "Centcom Central R&D Database"

/obj/structure/machinery/computer/rdservercontrol
	name = "R&D Server Controller"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/computer/rdservercontrol

/obj/structure/machinery/r_n_d/server/robotics
	name = "Robotics R&D Server"
	
/obj/structure/machinery/r_n_d/server/core
	name = "Core R&D Server"


/obj/structure/machinery/r_n_d/destructive_analyzer
	name = "Destructive Analyzer"
	icon_state = "d_analyzer"
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/structure/machinery/r_n_d/destructive_analyzer/Initialize()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/destructive_analyzer(src)
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/micro_laser(src)
	RefreshParts()


/obj/structure/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000

/obj/structure/machinery/r_n_d/protolathe/Initialize()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/protolathe(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/reagent_container/glass/beaker(src)
	component_parts += new /obj/item/reagent_container/glass/beaker(src)
	RefreshParts()


/obj/structure/machinery/r_n_d/server
	name = "R&D Server"
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	health = 100
	idle_power_usage = 800
	req_access = list(ACCESS_MARINE_CMO) //Only the R&D can change server settings.

/obj/structure/machinery/r_n_d/server/Initialize()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/rdserver(src)
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	component_parts += new /obj/item/stack/cable_coil(src)
	RefreshParts()

/obj/structure/machinery/r_n_d/server/centcom
	name = "Centcom Central R&D Database"

/obj/structure/machinery/r_n_d/server/robotics
	name = "Robotics R&D Server"
	
/obj/structure/machinery/r_n_d/server/core
	name = "Core R&D Server"


/obj/structure/machinery/computer/rdservercontrol
	name = "R&D Server Controller"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/computer/rdservercontrol

/obj/structure/machinery/computer/rdconsole
	name = "R&D Console"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/computer/rdconsole
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	req_access = null

/obj/structure/machinery/computer/rdconsole/core
	name = "Core R&D Console"


/obj/structure/machinery/computer/WYresearch
	name = "R&D Console"
	icon = 'icons/obj/structures/machinery/mainframe.dmi'
	icon_state = "aimainframe"
	circuit = /obj/item/circuitboard/computer/rdconsole  //It will eventually need it's own circuit.
	req_access = list(ACCESS_MARINE_RESEARCH)	//Data and setting manipulation requires scientist access.


/obj/structure/machinery/r_n_d/organic_analyzer
	name = "Weston-Yamada Brand Organic Analyzer(TM)"
	icon_state = "d_analyzer"
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/structure/machinery/r_n_d/organic_analyzer/Initialize()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/destructive_analyzer(src) //We'll need it's own board one day.
	component_parts += new /obj/item/stock_parts/scanning_module(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/micro_laser(src)
	RefreshParts()


/obj/structure/machinery/r_n_d/bioprinter
	name = "Weston-Yamada Brand Bio-Organic Printer(TM)"
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 5000

/obj/structure/machinery/r_n_d/bioprinter/Initialize()
	..()
	component_parts = list()
	component_parts += new /obj/item/circuitboard/machine/protolathe(src) //We'll need to make our own board one day
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/stock_parts/manipulator(src)
	component_parts += new /obj/item/reagent_container/glass/beaker(src)
	component_parts += new /obj/item/reagent_container/glass/beaker(src)
	RefreshParts()


/obj/structure/machinery/blackbox_recorder
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100


/obj/structure/machinery/message_server
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
