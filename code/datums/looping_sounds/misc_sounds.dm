/datum/looping_sound/looping_launch_announcement_alarm
	mid_sounds = list('sound/vehicles/Dropships/single_alarm_brr_dropship_1.ogg' = 1)
	start_sound = list('sound/vehicles/Dropships/single_alarm_brr_dropship_1.ogg' = 1)

/datum/looping_sound/telephone/ring
	start_sound = 'sound/machines/telephone/dial.ogg'
	start_length = 3.2 SECONDS
	mid_sounds = 'sound/machines/telephone/ring_outgoing.ogg'
	mid_length = 2.1 SECONDS
	volume = 10

/datum/looping_sound/telephone/busy
	start_sound = 'sound/voice/callstation_unavailable.ogg'
	start_length = 5.7 SECONDS
	mid_sounds = 'sound/machines/telephone/phone_busy.ogg'
	mid_length = 5 SECONDS
	volume = 15

/datum/looping_sound/telephone/hangup
	start_sound = 'sound/machines/telephone/remote_hangup.ogg'
	start_length = 0.6 SECONDS
	mid_sounds = 'sound/machines/telephone/phone_busy.ogg'
	mid_length = 5 SECONDS
	volume = 15
