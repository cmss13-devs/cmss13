var/datum/subsystem/midi/SSmidi

/datum/midi_record
	var/target
	var/midi

/datum/subsystem/midi
	name     = "Midi"
	wait     = 2 SECONDS
	flags    = SS_NO_INIT|SS_BACKGROUND|SS_FIRE_IN_LOBBY|SS_DISABLE_FOR_TESTING
	priority = SS_PRIORITY_MIDI

	var/list/datum/midi_record/prepped_midis = list()

	var/list/datum/midi_record/currentrun = list()


/datum/subsystem/midi/New()
	NEW_SS_GLOBAL(SSmidi)


/datum/subsystem/midi/stat_entry()
	..("MR:[prepped_midis.len]")


/datum/subsystem/midi/fire(resumed = FALSE)
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

/datum/subsystem/midi/proc/queue(target, midi)
	if(!prepped_midis)
		prepped_midis = list()
	var/datum/midi_record/MR = new()
	MR.target = target
	MR.midi = midi
	prepped_midis.Add(MR)