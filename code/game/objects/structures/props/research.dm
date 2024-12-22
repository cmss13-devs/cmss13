/obj/structure/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/structures/machinery/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	var/list/parts_to_build

/obj/structure/machinery/r_n_d/Initialize(mapload, ...)
	. = ..()
	QDEL_NULL_LIST(component_parts)
	for(var/typepath in parts_to_build)
		LAZYADD(component_parts, new typepath(src))
	RefreshParts()

/obj/structure/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	flags_atom = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	parts_to_build = list(
		/obj/item/circuitboard/machine/circuit_imprinter,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/beaker,
	)

/obj/structure/machinery/r_n_d/server
	name = "R&D Server"
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	health = 100
	idle_power_usage = 800
	req_access = list(ACCESS_MARINE_CMO) //Only the R&D can change server settings.
	parts_to_build = list(
		/obj/item/circuitboard/machine/rdserver,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil,
	)

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
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	parts_to_build = list(
		/obj/item/circuitboard/machine/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
	)

/obj/structure/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000
	parts_to_build = list(
		/obj/item/circuitboard/machine/protolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/beaker,
	)

/obj/structure/machinery/r_n_d/server
	name = "R&D Server"
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	health = 100
	idle_power_usage = 800
	req_access = list(ACCESS_MARINE_CMO) //Only the R&D can change server settings.
	parts_to_build = list(
		/obj/item/circuitboard/machine/rdserver,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stack/cable_coil,
		/obj/item/stack/cable_coil,
	)

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
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "comm_traffic"
	circuit = /obj/item/circuitboard/computer/rdconsole  //It will eventually need it's own circuit.
	req_access = list(ACCESS_MARINE_RESEARCH) //Data and setting manipulation requires scientist access.


/obj/structure/machinery/r_n_d/organic_analyzer
	name = "Weyland-Yutani Brand Organic Analyzer(TM)"
	icon_state = "d_analyzer"
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	parts_to_build = list(
		/obj/item/circuitboard/machine/destructive_analyzer,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/micro_laser,
	)

/obj/structure/machinery/r_n_d/bioprinter
	name = "Weyland-Yutani Brand Bio-Organic Printer(TM)"
	icon_state = "protolathe"
	flags_atom = OPENCONTAINER
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000
	parts_to_build = list(
		/obj/item/circuitboard/machine/protolathe,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_container/glass/beaker,
		/obj/item/reagent_container/glass/beaker,
	)


/obj/structure/machinery/blackbox_recorder
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100


/obj/structure/machinery/message_server
	icon = 'icons/obj/structures/machinery/research.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
