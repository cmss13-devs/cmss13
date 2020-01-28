var/datum/subsystem/sound/SSsound

/*
	Subsystem that handles sound queueing
*/

/datum/sound_item
	var/client/hearer
	var/datum/sound_template/template

/datum/subsystem/sound
	name          = "Sound"
	flags 		  =  SS_TICKER
	wait          = 1
	priority      = SS_PRIORITY_SOUND

	var/list/playsound_queue = list()
	var/list/playsound_queue_cur = list()

/datum/subsystem/sound/New()
	NEW_SS_GLOBAL(SSsound)
	
/datum/subsystem/sound/fire(resumed = FALSE)
	for(var/datum/sound_item/I in playsound_queue_cur)
		de_queue(I)
		playsound_queue_cur -= I
		if(MC_TICK_CHECK)
			return

	if(!playsound_queue_cur.len)
		playsound_queue_cur = playsound_queue
		playsound_queue = list()

/datum/subsystem/sound/proc/queue(client/hearer, datum/sound_template/template)
	if(!hearer || !template)
		return 
	var/datum/sound_item/I  = new()
	I.hearer = hearer
	I.template = template
	playsound_queue.Add(I)

/datum/subsystem/sound/proc/de_queue(datum/sound_item/I)
	if(I.hearer && I.hearer.soundOutput)
		I.hearer.soundOutput.process_sound(I.template)