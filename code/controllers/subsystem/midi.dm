/datum/midi_record
	var/target
	var/midi

SUBSYSTEM_DEF(midi)
	name     = "Midi"
	wait     = 2 SECONDS
	flags    = SS_NO_INIT|SS_BACKGROUND|SS_DISABLE_FOR_TESTING
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	priority = SS_PRIORITY_MIDI

	var/list/datum/midi_record/prepped_midis = list()

	var/list/datum/midi_record/currentrun = list()


/datum/controller/subsystem/midi/stat_entry(msg)
	msg = "MR:[prepped_midis.len]"
	return ..()


/datum/controller/subsystem/midi/fire(resumed = FALSE)
	if (!resumed)
		currentrun = prepped_midis
		prepped_midis = list()

	while (currentrun.len)
		var/datum/midi_record/E = currentrun[currentrun.len]
		currentrun.len--

		if (!E)
			continue

		E.target << E.midi

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/midi/proc/queue(target, midi)
	if(!prepped_midis)
		prepped_midis = list()
	var/datum/midi_record/MR = new()
	MR.target = target
	MR.midi = midi
	prepped_midis.Add(MR)
