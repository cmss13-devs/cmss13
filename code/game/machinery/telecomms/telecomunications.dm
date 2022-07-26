//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Hello, friends, this is Doohl from sexylands. You may be wondering what this
	monstrous code file is. Sit down, boys and girls, while I tell you the tale.


	The machines defined in this file were designed to be compatible with any radio
	signals, provided they use subspace transmission. Currently they are only used for
	headsets, but they can eventually be outfitted for real COMPUTER networks. This
	is just a skeleton, ladies and gentlemen.

	Look at radio.dm for the prequel to this code.
*/

GLOBAL_LIST_EMPTY_TYPED(telecomms_list, /obj/structure/machinery/telecomms)

/obj/structure/machinery/telecomms
	unslashable = TRUE
	unacidable = TRUE

	var/id = "NULL" // identification string
	var/network = "NULL" // the network of the machinery

	var/list/links = list() // list of machines this machine is linked to
	var/traffic = 0 // value increases as traffic increases
	var/netspeed = 5 // how much traffic to lose per tick (50 gigabytes/second * netspeed)
	var/list/autolinkers = list() // list of text/number values to link with
	var/list/freq_listening = list() // list of frequencies to tune into: if none, will listen to all
	var/machinetype = 0 // just a hacky way of preventing alike machines from pairing
	var/delay = 10 // how many process() ticks to delay per heat
	var/long_range_link = 0	// Can you link it across Z levels or on the otherside of the map? (Relay & Hub)
	var/circuitboard = null // string pointing to a circuitboard type
	var/listening_level = 0	// 0 = auto set in New() - this is the z level that the machine is listening to.

	var/tcomms_machine = FALSE 			// Set to true if the machine is enabling tcomms
	var/toggled = TRUE 					// Is it toggled on
	var/on = TRUE						// Is it actually on
	var/hide = FALSE					// Is it a hidden machine?

//Never allow tecommunications machinery being blown up
/obj/structure/machinery/telecomms/ex_act(severity)
	return

/obj/structure/machinery/telecomms/Initialize(mapload, ...)
	. = ..()
	GLOB.telecomms_list += src
	tcomms_startup()

/obj/structure/machinery/telecomms/Destroy()
	GLOB.telecomms_list -= src
	tcomms_shutdown()
	return ..()

/obj/structure/machinery/telecomms/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/structure/machinery/telecomms/power_change(var/area/master_area = null)
	. = ..()
	update_state()

// When effectively started up
/obj/structure/machinery/telecomms/proc/tcomms_startup()
	on = TRUE
	if(tcomms_machine)
		SSradio.add_tcomm_machine(src)

// When effectively shut down
/obj/structure/machinery/telecomms/proc/tcomms_shutdown()
	on = FALSE
	if(tcomms_machine)
		SSradio.remove_tcomm_machine(src)

// In any case that might warrant reevaluating working state
/obj/structure/machinery/telecomms/proc/update_state()
	if(!toggled || inoperable(EMPED) || health <= 0)
		if(on)
			tcomms_shutdown()
	else if(!on)
		tcomms_startup()
	update_icon()
	return on

// When an operator attempts to flip the switch
/obj/structure/machinery/telecomms/proc/toggle_state(mob/user)
	toggled = !toggled
	update_state()

/obj/structure/machinery/telecomms/emp_act(severity)
	if(prob(100/severity))
		if(!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10)/severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the machines to reboot.
				stat &= ~EMPED
	..()

/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. They then just relay this information to all linked devices,
	which can would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/

/obj/structure/machinery/telecomms/receiver
	name = "Subspace Receiver"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 600
	machinetype = 1
	circuitboard = /obj/item/circuitboard/machine/telecomms/receiver

/*
	The HUB idles until it receives information. It then passes on that information
	depending on where it came from.

	This is the heart of the Telecommunications Network, sending information where it
	is needed. It mainly receives information from long-distance Relays and then sends
	that information to be processed. Afterwards it gets the uncompressed information
	from Servers/Buses and sends that back to the relay, to then be broadcasted.
*/

/obj/structure/machinery/telecomms/hub
	name = "Telecommunication Hub"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "hub"
	desc = "A mighty piece of hardware used to send/receive massive amounts of data."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 1600
	machinetype = 7
	circuitboard = /obj/item/circuitboard/machine/telecomms/hub
	long_range_link = 1
	netspeed = 40


/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/

/obj/structure/machinery/telecomms/relay
	name = "Telecommunication Relay"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 600
	machinetype = 8
	circuitboard = /obj/item/circuitboard/machine/telecomms/relay
	netspeed = 5
	long_range_link = 1
	var/broadcasting = 1
	var/receiving = 1

/*
	The bus mainframe idles and waits for hubs to relay them signals. They act
	as junctions for the network.

	They transfer uncompressed subspace packets to processor units, and then take
	the processed packet to a server for logging.

	Link to a subspace hub if it can't send to a server.
*/

/obj/structure/machinery/telecomms/bus
	name = "Bus Mainframe"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "bus"
	desc = "A mighty piece of hardware used to send massive amounts of data quickly."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 1000
	machinetype = 2
	circuitboard = /obj/item/circuitboard/machine/telecomms/bus
	netspeed = 40
	var/change_frequency = 0

/*
	The processor is a very simple machine that decompresses subspace signals and
	transfers them back to the original bus. It is essential in producing audible
	data.

	Link to servers if bus is not present
*/

/obj/structure/machinery/telecomms/processor
	name = "Processor Unit"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "processor"
	desc = "This machine is used to process large quantities of information."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 600
	machinetype = 3
	delay = 5
	circuitboard = /obj/item/circuitboard/machine/telecomms/processor
	var/process_mode = 1 // 1 = Uncompress Signals, 0 = Compress Signals

/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a maximum of 100 logs and then deletes them.
*/


/obj/structure/machinery/telecomms/server
	name = "Telecommunication Server"
	icon = 'icons/obj/structures/props/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 300
	machinetype = 4
	circuitboard = /obj/item/circuitboard/machine/telecomms/server
	var/list/log_entries = list()
	var/list/stored_names = list()
	var/list/TrafficActions = list()
	var/logs = 0 // number of logs
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/list/memory = list()	// stored memory
	var/rawcode = ""	// the code to compile (raw text)
	var/datum/TCS_Compiler/Compiler	// the compiler that compiles and runs the code
	var/autoruncode = 0		// 1 if the code is set to run every time a signal is picked up

	var/encryption = "null" // encryption key: ie "password"
	var/salt = "null"		// encryption salt: ie "123comsat"
							// would add up to md5("password123comsat")
	var/language = "human"
	var/obj/item/device/radio/headset/server_radio = null

/obj/structure/machinery/telecomms/server/Initialize(mapload, ...)
	. = ..()
	server_radio = new()
