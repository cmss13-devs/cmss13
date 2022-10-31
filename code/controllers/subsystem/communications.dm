/*
  HOW IT WORKS

  The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
  Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
  procs:

    add_object(obj/device as obj, var/new_frequency as num, var/filter as text|null = null)
      Adds listening object.
      parameters:
        device - device receiving signals, must have proc receive_signal (see description below).
          one device may listen several frequencies, but not same frequency twice.
        new_frequency - see possibly frequencies below;
        filter - thing for optimization. Optional, but recommended.
                 All filters should be consolidated in this file, see defines later.
                 Device without listening filter will receive all signals (on specified frequency).
                 Device with filter will receive any signals sent without filter.
                 Device with filter will not receive any signals sent with different filter.
      returns:
       Reference to frequency object.

    remove_object (obj/device, old_frequency)
      Obliviously, after calling this proc, device will not receive any signals on old_frequency.
      Other frequencies will left unaffected.

   return_frequency(var/frequency as num)
      returns:
       Reference to frequency object. Use it if you need to send and do not need to listen.

  radio_frequency is a global object maintaining list of devices that listening specific frequency.
  procs:

    post_signal(obj/source as obj|null, datum/signal/signal, var/filter as text|null = null, var/range as num|null = null)
      Sends signal to all devices that wants such signal.
      parameters:
        source - object, emitted signal. Usually, devices will not receive their own signals.
        signal - see description below.
        filter - described above.
        range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.

  obj/proc/receive_signal(datum/signal/signal, var/receive_method as num, var/receive_param)
    Handler from received signals. By default does nothing. Define your own for your object.
    Avoid of sending signals directly from this proc, use spawn(-1). DO NOT use sleep() here or call procs that sleep please. If you must, use spawn()
      parameters:
        signal - see description below. Extract all needed data from the signal before doing sleep(), spawn() or return!
        receive_method - may be TRANSMISSION_WIRE or TRANSMISSION_RADIO.
          TRANSMISSION_WIRE is currently unused.
        receive_param - for TRANSMISSION_RADIO here comes frequency.

  datum/signal
    vars:
    source
      an object that emitted signal. Used for debug and bearing.
    data
      list with transmitting data. Usual use pattern:
        data["msg"] = "hello world"
    encryption
      Some number symbolizing "encryption key".
      Note that game actually do not use any cryptography here.
      If receiving object don't know right key, it must ignore encrypted signal in its receive_signal.

*/

/*
Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)
*/

var/const/MIN_FREE_FREQ = 1201 // -------------------------------------------------

//Misc channels
var/const/YAUT_FREQ 	= 1214
var/const/PMC_FREQ 		= 1235
var/const/WY_FREQ 		= 1236
var/const/DUT_FREQ 		= 1340
var/const/ERT_FREQ 		= 1342
var/const/VAI_FREQ		= 1218
var/const/RUS_FREQ		= 1338
var/const/CLF_FREQ		= 1339
var/const/DTH_FREQ 		= 1344
var/const/AI_FREQ 		= 1447
var/const/HC_FREQ		= 1240
var/const/CCT_FREQ		= 1350

//Ship department channels
var/const/COMM_FREQ 	= 1353
var/const/MED_FREQ 		= 1355
var/const/ENG_FREQ 		= 1357
var/const/SEC_FREQ 		= 1359
var/const/SUP_FREQ 		= 1354
var/const/JTAC_FREQ 	= 1358
var/const/INTEL_FREQ	= 1356

var/const/DS1_FREQ		= 1441
var/const/DS2_FREQ		= 1443

//Marine channels
var/const/ALPHA_FREQ 	= 1449
var/const/BRAVO_FREQ 	= 1451
var/const/CHARLIE_FREQ 	= 1453
var/const/DELTA_FREQ 	= 1455
var/const/ECHO_FREQ 	= 1456
var/const/CRYO_FREQ		= 1457
var/const/SOF_FREQ	= 1241

var/const/MIN_FREQ 		= 1460 // ------------------------------------------------------

var/const/PUB_FREQ 		= 1461

var/const/MAX_FREQ 		= 1468 // ------------------------------------------------------

//Civilian channels
var/const/COLONY_FREQ	= 1469

var/const/MAX_FREE_FREQ = 1599 // -------------------------------------------------

var/list/radiochannels = list(
	RADIO_CHANNEL_ERT  			= ERT_FREQ,
	RADIO_CHANNEL_YAUTJA		= YAUT_FREQ,
	RADIO_CHANNEL_WY			= WY_FREQ,
	RADIO_CHANNEL_WY_PMC		= PMC_FREQ,
	RADIO_CHANNEL_VAI			= VAI_FREQ,
	RADIO_CHANNEL_SPECOPS		= DTH_FREQ,
	RADIO_CHANNEL_UPP			= RUS_FREQ,
	RADIO_CHANNEL_CLF			= CLF_FREQ,
	RADIO_CHANNEL_DUTCH_DOZEN	= DUT_FREQ,
	RADIO_CHANNEL_HIGHCOM		= HC_FREQ,
	RADIO_CHANNEL_CCT			= CCT_FREQ, // HvH JTAC Equiv

	RADIO_CHANNEL_ALMAYER		= PUB_FREQ,
	RADIO_CHANNEL_COMMAND		= COMM_FREQ,
	RADIO_CHANNEL_MEDSCI		= MED_FREQ,
	RADIO_CHANNEL_ENGI			= ENG_FREQ,
	RADIO_CHANNEL_MP			= SEC_FREQ,
	RADIO_CHANNEL_REQ			= SUP_FREQ,
	RADIO_CHANNEL_JTAC			= JTAC_FREQ,
	RADIO_CHANNEL_INTEL 		= INTEL_FREQ,

	SQUAD_MARINE_1				= ALPHA_FREQ,
	SQUAD_MARINE_2				= BRAVO_FREQ,
	SQUAD_MARINE_3				= CHARLIE_FREQ,
	SQUAD_MARINE_4				= DELTA_FREQ,
	SQUAD_MARINE_5				= ECHO_FREQ,
	SQUAD_MARINE_CRYO			= CRYO_FREQ,
	SQUAD_SOF				= SOF_FREQ,

	SQUAD_MARINE_1				= ALPHA_FREQ,
	SQUAD_MARINE_2				= BRAVO_FREQ,
	SQUAD_MARINE_3				= CHARLIE_FREQ,
	SQUAD_MARINE_4				= DELTA_FREQ,
	SQUAD_MARINE_5				= ECHO_FREQ,
	SQUAD_MARINE_CRYO			= CRYO_FREQ,
	SQUAD_SOF				= SOF_FREQ,

	RADIO_CHANNEL_ALAMO			= DS1_FREQ,
	RADIO_CHANNEL_NORMANDY 		= DS2_FREQ,

	RADIO_CHANNEL_COLONY		= COLONY_FREQ
)

// central command channels, i.e deathsquid & response teams
#define CENT_FREQS list(ERT_FREQ, DTH_FREQ, PMC_FREQ, VAI_FREQ, DUT_FREQ, YAUT_FREQ, HC_FREQ, SOF_FREQ)

// Antag channels, i.e. Syndicate
#define ANTAG_FREQS list()

//Depts - used for colors in headset.dm, as well as deciding what the marine comms tower can listen into
#define DEPT_FREQS list(COMM_FREQ, MED_FREQ, ENG_FREQ, SEC_FREQ, ALPHA_FREQ, BRAVO_FREQ, CHARLIE_FREQ, DELTA_FREQ, ECHO_FREQ, CRYO_FREQ, SUP_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ)

#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also receive signals sent to any other filter.
var/const/RADIO_DEFAULT = "radio_default"

var/const/RADIO_TO_AIRALARM = "radio_airalarm" //air alarms
var/const/RADIO_FROM_AIRALARM = "radio_airalarm_rcvr" //devices interested in receiving signals from air alarms
var/const/RADIO_CHAT = "radio_telecoms"
var/const/RADIO_ATMOSIA = "radio_atmos"
var/const/RADIO_NAVBEACONS = "radio_navbeacon"
var/const/RADIO_AIRLOCK = "radio_airlock"
var/const/RADIO_MULEBOT = "radio_mulebot"
var/const/RADIO_MAGNETS = "radio_magnet"

//callback used by objects to react to incoming radio signals
/obj/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return null

SUBSYSTEM_DEF(radio)
	name = "radio"
	flags = SS_NO_FIRE
	init_order = SS_INIT_RADIO
	var/list/datum/radio_frequency/frequencies = list()

	//Keeping a list of tcomm machines to see which Z level has comms
	var/list/tcomm_machines_ground = list()
	var/list/tcomm_machines_almayer = list()

	var/static/list/freq_to_span = list(
		"[COMM_FREQ]" = "comradio",
		"[AI_FREQ]" = "airadio",
		"[SEC_FREQ]" = "secradio",
		"[ENG_FREQ]" = "engradio",
		"[MED_FREQ]" = "medradio",
		"[SUP_FREQ]" = "supradio",
		"[JTAC_FREQ]" = "jtacradio",
		"[INTEL_FREQ]" = "intelradio",
		"[WY_FREQ]" = "wyradio",
		"[VAI_FREQ]" = "vairadio",
		"[RUS_FREQ]" = "syndradio",
		"[CLF_FREQ]" = "clfradio",
		"[CCT_FREQ]" = "cctradio",
		"[ALPHA_FREQ]" = "alpharadio",
		"[BRAVO_FREQ]" = "bravoradio",
		"[CHARLIE_FREQ]" = "charlieradio",
		"[DELTA_FREQ]" = "deltaradio",
		"[ECHO_FREQ]" = "echoradio",
		"[CRYO_FREQ]" = "cryoradio",
		"[SOF_FREQ]" = "hcradio",
		"[HC_FREQ]" = "hcradio",
		"[COLONY_FREQ]" = "deptradio",
	)

/datum/controller/subsystem/radio/proc/add_object(obj/device as obj, var/new_frequency as num, var/filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/subsystem/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(frequency)
		frequency.remove_listener(device)

		if(frequency.devices.len == 0)
			qdel(frequency)
			frequencies -= f_text

	return 1

/datum/controller/subsystem/radio/proc/return_frequency(var/new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	return frequency

/datum/controller/subsystem/radio/proc/get_available_tcomm_zs(var/frequency)
	//Returns lists of Z levels that have comms
	var/list/target_zs = SSmapping.levels_by_trait(ZTRAIT_ADMIN)
	var/list/extra_zs = SSmapping.levels_by_trait(ZTRAIT_AWAY)
	if(length(extra_zs))
		target_zs += extra_zs
	for(var/obj/structure/machinery/telecomms/T as anything in tcomm_machines_ground)
		if(!length(T.freq_listening) || (frequency in T.freq_listening))
			target_zs += SSmapping.levels_by_trait(ZTRAIT_GROUND)
			break
	for(var/obj/structure/machinery/telecomms/T as anything in tcomm_machines_almayer)
		if(!length(T.freq_listening) || (frequency in T.freq_listening))
			target_zs += SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)
			target_zs += SSmapping.levels_by_trait(ZTRAIT_LOWORBIT)
			break
	SEND_SIGNAL(src, COMSIG_SSRADIO_GET_AVAILABLE_TCOMMS_ZS, target_zs)
	return target_zs

/datum/controller/subsystem/radio/proc/add_tcomm_machine(var/obj/machine)
	if(is_ground_level(machine.z))
		addToListNoDupe(tcomm_machines_ground, machine)
	if(is_mainship_level(machine.z))
		addToListNoDupe(tcomm_machines_almayer, machine)

/datum/controller/subsystem/radio/proc/remove_tcomm_machine(var/obj/machine)
	tcomm_machines_ground -= machine
	tcomm_machines_almayer -= machine

/datum/controller/subsystem/radio/proc/get_frequency_span(var/frequency)
	var/freq_span = freq_to_span["[frequency]"]
	if(freq_span)
		return freq_span
	if(frequency in ANTAG_FREQS)
		return "syndradio"
	if(frequency in CENT_FREQS)
		return "centradio"
	if(frequency in DEPT_FREQS)
		return "deptradio"
	return "radio"

/datum/radio_frequency
	var/frequency as num
	var/list/list/obj/devices = list()

/datum/radio_frequency/proc/post_signal(obj/source as obj|null, datum/signal/signal, var/filter = null as text|null, var/range = null as num|null)
	var/turf/start_point
	if(range)
		start_point = get_turf(source)
		if(!start_point)
			qdel(signal)
			return 0
	if (filter)
		send_to_filter(source, signal, filter, start_point, range)
		send_to_filter(source, signal, RADIO_DEFAULT, start_point, range)
	else
		//Broadcast the signal to everyone!
		for (var/next_filter in devices)
			send_to_filter(source, signal, next_filter, start_point, range)

//Sends a signal to all machines belonging to a given filter. Should be called by post_signal()
/datum/radio_frequency/proc/send_to_filter(obj/source, datum/signal/signal, var/filter, var/turf/start_point = null, var/range = null)
	if (range && !start_point)
		return

	for(var/obj/device in devices[filter])
		if(device == source)
			continue

		if(!OBJECTS_CAN_REACH(device, source))
			continue

		if(range)
			var/turf/end_point = get_turf(device)
			if(!end_point)
				continue
			if(start_point.z!=end_point.z || get_dist(start_point, end_point) > range)
				continue

		device.receive_signal(signal, TRANSMISSION_RADIO, frequency)

/datum/radio_frequency/proc/add_listener(obj/device as obj, var/filter as text|null)
	if (!filter)
		filter = RADIO_DEFAULT
	//log_admin("add_listener(device=[device],filter=[filter]) frequency=[frequency]")
	var/list/obj/devices_line = devices[filter]
	if (!devices_line)
		devices_line = new
		devices[filter] = devices_line
	devices_line+=device
//			var/list/obj/devices_line___ = devices[filter_str]
//			var/l = devices_line___.len
	//log_admin("DEBUG: devices_line.len=[devices_line.len]")
	//log_admin("DEBUG: devices(filter_str).len=[l]")

/datum/radio_frequency/proc/remove_listener(obj/device)
	for (var/devices_filter in devices)
		var/list/devices_line = devices[devices_filter]
		devices_line-=device
		while (null in devices_line)
			devices_line -= null
		if (devices_line.len==0)
			devices -= devices_filter
			qdel(devices_line)

/datum/signal
	var/obj/source

	var/transmission_method = 0 //unused at the moment
	//0 = wire
	//1 = radio transmission
	//2 = subspace transmission

	var/data = list()
	var/encryption

	var/frequency = 0

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	transmission_method = model.transmission_method
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if (source)
		. = "signal = {source = '[source]' ([source:x],[source:y],[source:z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for (var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"
