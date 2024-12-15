/*
HOW IT WORKS

The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
procs:

	add_object(obj/device as obj, new_frequency as num, filter as text|null = null)
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

	return_frequency(frequency as num)
		returns:
			Reference to frequency object. Use it if you need to send and do not need to listen.

radio_frequency is a global object maintaining list of devices that listening specific frequency.
	procs:

	post_signal(obj/source as obj|null, datum/signal/signal, filter as text|null = null, range as num|null = null)
		Sends signal to all devices that wants such signal.
	parameters:
		source - object, emitted signal. Usually, devices will not receive their own signals.
		signal - see description below.
		filter - described above.
		range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.

	obj/proc/receive_signal(datum/signal/signal, receive_method as num, receive_param)
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

#define UNIVERSAL_FREQ 1

#define MIN_FREE_FREQ 1201 // -------------------------------------------------

//Misc channels
#define YAUT_FREQ 1205
#define DUT_FREQ 1210
#define VAI_FREQ 1215
#define RMC_FREQ 1216
#define CMB_FREQ 1220
#define CIA_FREQ 1225

//WY Channels (1230-1249)
#define WY_FREQ 1231
#define PMC_CMD_FREQ 1232
#define PMC_FREQ 1233
#define PMC_ENGI_FREQ 1234
#define PMC_MED_FREQ 1235
#define PMC_CCT_FREQ 1236
#define WY_WO_FREQ 1239

//UPP Channels (1250-1269)
#define UPP_FREQ 1251
#define UPP_CMD_FREQ 1252
#define UPP_ENGI_FREQ 1253
#define UPP_MED_FREQ 1254
#define UPP_CCT_FREQ 1255
#define UPP_KDO_FREQ 1259
#define UPP_DS1_FREQ 1260
#define UPP_DS2_FREQ 1261

//CLF Channels (1270-1289)
#define CLF_FREQ 1271
#define CLF_CMD_FREQ 1272
#define CLF_ENGI_FREQ 1273
#define CLF_MED_FREQ 1274
#define CLF_CCT_FREQ 1275

//Listening Bugs (1290-1291)
#define BUG_A_FREQ 1290
#define BUG_B_FREQ 1291

//Listening Bugs (1296-1300)
#define FAX_WY_FREQ 1296
#define FAX_USCM_HC_FREQ 1297
#define FAX_USCM_PVST_FREQ 1298

//General Radio
#define MIN_FREQ 1460 // ------------------------------------------------------
#define PUB_FREQ 1461
#define MAX_FREQ 1468 // ------------------------------------------------------

//USCM High Command (USCM 1470-1499)
#define HC_FREQ 1471
#define SOF_FREQ 1472
#define PVST_FREQ 1473
#define CBRN_FREQ 1474
#define FORECON_FREQ 1475

//Ship department channels
#define SENTRY_FREQ 1480
#define COMM_FREQ 1481
#define MED_FREQ 1482
#define ENG_FREQ 1483
#define SEC_FREQ 1484
#define REQ_FREQ 1485
#define JTAC_FREQ 1486
#define INTEL_FREQ 1487

#define DS1_FREQ 1488
#define DS2_FREQ 1489
#define DS3_FREQ 1490

//Marine Squad channels
#define ALPHA_FREQ 1491
#define BRAVO_FREQ 1492
#define CHARLIE_FREQ 1493
#define DELTA_FREQ 1494
#define ECHO_FREQ 1495
#define CRYO_FREQ 1496

//Civilian channels
#define COLONY_FREQ 1469

#define AI_FREQ 1500

#define MAX_FREE_FREQ 1599 // -------------------------------------------------

GLOBAL_LIST_INIT(radiochannels, list(
	RADIO_CHANNEL_YAUTJA = YAUT_FREQ,
	RADIO_CHANNEL_VAI = VAI_FREQ,
	RADIO_CHANNEL_CMB = CMB_FREQ,
	RADIO_CHANNEL_DUTCH_DOZEN = DUT_FREQ,
	RADIO_CHANNEL_ROYAL_MARINE = RMC_FREQ,
	RADIO_CHANNEL_CIA = CIA_FREQ,

	RADIO_CHANNEL_HIGHCOM = HC_FREQ,
	RADIO_CHANNEL_PROVOST = PVST_FREQ,
	RADIO_CHANNEL_ALMAYER = PUB_FREQ,
	RADIO_CHANNEL_COMMAND = COMM_FREQ,
	RADIO_CHANNEL_MEDSCI = MED_FREQ,
	RADIO_CHANNEL_ENGI = ENG_FREQ,
	RADIO_CHANNEL_MP = SEC_FREQ,
	RADIO_CHANNEL_REQ = REQ_FREQ,
	RADIO_CHANNEL_SENTRY = SENTRY_FREQ,
	RADIO_CHANNEL_JTAC = JTAC_FREQ,
	RADIO_CHANNEL_INTEL = INTEL_FREQ,

	SQUAD_MARINE_1 = ALPHA_FREQ,
	SQUAD_MARINE_2 = BRAVO_FREQ,
	SQUAD_MARINE_3 = CHARLIE_FREQ,
	SQUAD_MARINE_4 = DELTA_FREQ,
	SQUAD_MARINE_5 = ECHO_FREQ,
	SQUAD_MARINE_CRYO = CRYO_FREQ,
	SQUAD_SOF = SOF_FREQ,
	SQUAD_CBRN = CBRN_FREQ,
	SQUAD_FORECON = FORECON_FREQ,
	SQUAD_SOLAR = SOF_FREQ,

	RADIO_CHANNEL_ALAMO = DS1_FREQ,
	RADIO_CHANNEL_NORMANDY = DS2_FREQ,
	RADIO_CHANNEL_SAIPAN = DS3_FREQ,

	RADIO_CHANNEL_COLONY = COLONY_FREQ,


	RADIO_CHANNEL_WY = WY_FREQ,
	RADIO_CHANNEL_PMC_GEN = PMC_FREQ,
	RADIO_CHANNEL_PMC_CMD = PMC_CMD_FREQ,
	RADIO_CHANNEL_PMC_ENGI = PMC_ENGI_FREQ,
	RADIO_CHANNEL_PMC_MED = PMC_MED_FREQ,
	RADIO_CHANNEL_PMC_CCT = PMC_CCT_FREQ,
	RADIO_CHANNEL_WY_WO = WY_WO_FREQ,

	RADIO_CHANNEL_UPP_GEN = UPP_FREQ,
	RADIO_CHANNEL_UPP_CMD = UPP_CMD_FREQ,
	RADIO_CHANNEL_UPP_ENGI = UPP_ENGI_FREQ,
	RADIO_CHANNEL_UPP_MED = UPP_MED_FREQ,
	RADIO_CHANNEL_UPP_CCT = UPP_CCT_FREQ,
	RADIO_CHANNEL_UPP_KDO = UPP_KDO_FREQ,
	RADIO_CHANNEL_UPP_MORANA = UPP_DS1_FREQ,
	RADIO_CHANNEL_UPP_KOROLOV = UPP_DS2_FREQ,

	RADIO_CHANNEL_CLF_GEN = CLF_FREQ,
	RADIO_CHANNEL_CLF_CMD = CLF_CMD_FREQ,
	RADIO_CHANNEL_CLF_ENGI = CLF_ENGI_FREQ,
	RADIO_CHANNEL_CLF_MED = CLF_MED_FREQ,
	RADIO_CHANNEL_CLF_CCT = CLF_CCT_FREQ,

	RADIO_CHANNEL_BUG_A = BUG_A_FREQ,
	RADIO_CHANNEL_BUG_B = BUG_B_FREQ,

	RADIO_CHANNEL_FAX_WY = FAX_WY_FREQ,
	RADIO_CHANNEL_FAX_USCM_HC = FAX_USCM_HC_FREQ,
	RADIO_CHANNEL_FAX_USCM_PVST = FAX_USCM_PVST_FREQ,
))

// Response Teams
#define ERT_FREQS list(VAI_FREQ, DUT_FREQ, YAUT_FREQ, CMB_FREQ, RMC_FREQ)

// UPP Frequencies
#define UPP_FREQS list(UPP_FREQ, UPP_CMD_FREQ, UPP_ENGI_FREQ, UPP_MED_FREQ, UPP_CCT_FREQ, UPP_KDO_FREQ)

// CLF Frequencies
#define CLF_FREQS list(CLF_FREQ, CLF_CMD_FREQ, CLF_ENGI_FREQ, CLF_MED_FREQ, CLF_CCT_FREQ)

// PMC Frequencies
#define PMC_FREQS list(PMC_FREQ, PMC_CMD_FREQ, PMC_ENGI_FREQ, PMC_MED_FREQ, PMC_CCT_FREQ, WY_WO_FREQ, WY_FREQ)

//Listening Device Frequencies
#define BUG_FREQS list(BUG_A_FREQ, BUG_B_FREQ)

//Fax Responder internal monitor frequencies
#define FAX_RESP_FREQS list(FAX_WY_FREQ, FAX_USCM_HC_FREQ, FAX_USCM_PVST_FREQ)

//Depts - used for colors in headset.dm, as well as deciding what the marine comms tower can listen into
#define DEPT_FREQS list(COMM_FREQ, MED_FREQ, ENG_FREQ, SEC_FREQ, SENTRY_FREQ, ALPHA_FREQ, BRAVO_FREQ, CHARLIE_FREQ, DELTA_FREQ, ECHO_FREQ, CRYO_FREQ, REQ_FREQ, JTAC_FREQ, INTEL_FREQ, WY_FREQ)

#define TRANSMISSION_WIRE 0
#define TRANSMISSION_RADIO 1

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also receive signals sent to any other filter.
#define RADIO_DEFAULT "radio_default"

#define RADIO_TO_AIRALARM "radio_airalarm" //air alarms
#define RADIO_FROM_AIRALARM "radio_airalarm_rcvr" //devices interested in receiving signals from air alarms
#define RADIO_CHAT "radio_telecoms"
#define RADIO_SIGNALS "radio_signals"
#define RADIO_ATMOSIA "radio_atmos"
#define RADIO_NAVBEACONS "radio_navbeacon"
#define RADIO_AIRLOCK "radio_airlock"
#define RADIO_MULEBOT "radio_mulebot"
#define RADIO_MAGNETS "radio_magnet"

//callback used by objects to react to incoming radio signals
/obj/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return null

SUBSYSTEM_DEF(radio)
	name = "radio"
	flags = SS_NO_FIRE|SS_NO_INIT
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
		"[SENTRY_FREQ]" = "sentryradio",
		"[MED_FREQ]" = "medradio",
		"[REQ_FREQ]" = "supradio",
		"[JTAC_FREQ]" = "jtacradio",
		"[INTEL_FREQ]" = "intelradio",
		"[WY_FREQ]" = "wyradio",
		"[VAI_FREQ]" = "vairadio",
		"[RMC_FREQ]" = "rmcradio",
		"[CIA_FREQ]" = "ciaradio",
		"[CMB_FREQ]" = "cmbradio",
		"[ALPHA_FREQ]" = "alpharadio",
		"[BRAVO_FREQ]" = "bravoradio",
		"[CHARLIE_FREQ]" = "charlieradio",
		"[DELTA_FREQ]" = "deltaradio",
		"[ECHO_FREQ]" = "echoradio",
		"[CRYO_FREQ]" = "cryoradio",
		"[CBRN_FREQ]" = "hcradio",
		"[FORECON_FREQ]" = "hcradio",
		"[SOF_FREQ]" = "hcradio",
		"[HC_FREQ]" = "hcradio",
		"[PVST_FREQ]" = "pvstradio",
		"[COLONY_FREQ]" = "deptradio",
		"[BUG_A_FREQ]" = "airadio",
		"[BUG_B_FREQ]" = "aiprivradio",
		"[UPP_FREQ]" = "syndradio",
		"[UPP_CMD_FREQ]" = "opforcmd",
		"[UPP_ENGI_FREQ]" = "opforeng",
		"[UPP_MED_FREQ]" = "opformed",
		"[UPP_CCT_FREQ]" = "opforcct",
		"[UPP_KDO_FREQ]" = "opforspe",
		"[CLF_FREQ]" = "clfradio",
		"[CLF_CMD_FREQ]" = "opforcmd",
		"[CLF_ENGI_FREQ]" = "opforeng",
		"[CLF_MED_FREQ]" = "opformed",
		"[CLF_CCT_FREQ]" = "opforcct",
		"[FAX_WY_FREQ]" = "airadio",
		"[FAX_USCM_HC_FREQ]" = "aiprivradio",
		"[FAX_USCM_PVST_FREQ]" = "aiprivradio",
	)

/datum/controller/subsystem/radio/proc/add_object(obj/device as obj, new_frequency as num, filter = null as text|null)
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

		if(!length(frequency.devices))
			qdel(frequency)
			frequencies -= f_text

	return 1

/datum/controller/subsystem/radio/proc/return_frequency(new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	return frequency

/datum/controller/subsystem/radio/proc/get_available_tcomm_zs(frequency)
	//Returns lists of Z levels that have comms
	var/list/target_zs = SSmapping.levels_by_trait(ZTRAIT_ADMIN)
	var/list/extra_zs = SSmapping.levels_by_trait(ZTRAIT_AWAY)
	if(length(extra_zs))
		target_zs += extra_zs
	for(var/obj/structure/machinery/telecomms/T as anything in tcomm_machines_ground)
		if((UNIVERSAL_FREQ in T.freq_listening) || (frequency in T.freq_listening))
			target_zs += SSmapping.levels_by_trait(ZTRAIT_GROUND)
			break
	for(var/obj/structure/machinery/telecomms/T as anything in tcomm_machines_almayer)
		if((UNIVERSAL_FREQ in T.freq_listening) || (frequency in T.freq_listening))
			target_zs += SSmapping.levels_by_trait(ZTRAIT_MARINE_MAIN_SHIP)
			target_zs += SSmapping.levels_by_trait(ZTRAIT_RESERVED)
			break
	SEND_SIGNAL(src, COMSIG_SSRADIO_GET_AVAILABLE_TCOMMS_ZS, target_zs)
	return target_zs

/datum/controller/subsystem/radio/proc/add_tcomm_machine(obj/machine)
	if(is_ground_level(machine.z))
		addToListNoDupe(tcomm_machines_ground, machine)
	if(is_mainship_level(machine.z))
		addToListNoDupe(tcomm_machines_almayer, machine)

/datum/controller/subsystem/radio/proc/remove_tcomm_machine(obj/machine)
	tcomm_machines_ground -= machine
	tcomm_machines_almayer -= machine

/datum/controller/subsystem/radio/proc/get_frequency_span(frequency)
	var/freq_span = freq_to_span["[frequency]"]
	if(freq_span)
		return freq_span
	if(frequency in PMC_FREQS)
		return "pmcradio"
	if(frequency in ERT_FREQS)
		return "centradio"
	if(frequency in DEPT_FREQS)
		return "deptradio"
	return "radio"

/datum/radio_frequency
	var/frequency as num
	var/list/list/datum/weakref/devices = list()

/datum/radio_frequency/proc/post_signal(obj/source as obj|null, datum/signal/signal, filter = null as text|null, range = null as num|null)
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
/datum/radio_frequency/proc/send_to_filter(obj/source, datum/signal/signal, filter, turf/start_point = null, range = null)
	if (range && !start_point)
		return

	for(var/datum/weakref/device_ref as anything in devices[filter])
		var/obj/device = device_ref.resolve()

		if(!device)
			continue

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

/datum/radio_frequency/proc/add_listener(obj/device as obj, filter as text|null)
	if (!filter)
		filter = RADIO_DEFAULT

	var/datum/weakref/new_listener = WEAKREF(device)
	if(isnull(new_listener))
		return stack_trace("null, non-datum or qdeleted device")

	var/list/devices_line = devices[filter]
	if (!devices_line)
		devices_line = new
		devices[filter] = devices_line
	devices_line += new_listener

/datum/radio_frequency/proc/remove_listener(obj/device)
	for (var/devices_filter in devices)
		var/list/devices_line = devices[devices_filter]
		devices_line -= device.weak_reference
		if (!length(devices_line))
			devices -= devices_filter

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
