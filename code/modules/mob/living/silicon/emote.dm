/datum/emote/silicon
	mob_type_allowed_typecache = list(/mob/living/silicon/robot)
	emote_type = EMOTE_AUDIBLE

/datum/emote/silicon/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/clap
	key = "clap"
	message = "claps."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/flap
	key = "flap"
	key_third_person = "flaps"
	message = "flaps their wings.."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "flaps their wings ANGRILY!"
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches violently."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/twitch_subtle
	key = "twitch_s"
	message = "twitches."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/nod
	key = "nod"
	message = "nods."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/deathgasp
	key = "deathgasp"
	message = "shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/glare
	key = "glare"
	message = "glares."
	message_param = "glares at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/stare
	key = "stare"
	message = "stares."
	message_param = "stares at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/look
	key = "look"
	message = "looks."
	message_param = "looks at %t."
	emote_type = EMOTE_VISIBLE

/datum/emote/silicon/beep
	key = "beep"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/machines/twobeep.ogg'

/datum/emote/silicon/ping
	key = "ping"
	message = "pings."
	message_param = "pings at %t."
	sound = 'sound/machines/ping.ogg'

/datum/emote/silicon/buzz
	key = "buzz"
	message = "buzzes."
	message_param = "buzzes at %t."
	sound = 'sound/machines/buzz-sigh.ogg'

/datum/emote/silicon/alert
	key = "alert"
	message = "sounds an alert!"
	message_param = "sounds an alert at %t!"
	sound = 'sound/machines/beepalert.ogg'

/datum/emote/silicon/sad
	key = "sad"
	message = "makes a sad beep."
	message_param = "makes a sad beep at %t."
	sound = 'sound/machines/beepsad.ogg'

/datum/emote/silicon/confused
	key = "confused"
	message = "makes a confused beep."
	message_param = "makes a confused beep at %t."
	sound = 'sound/machines/beepconfused.ogg'

/datum/emote/silicon/spark
	key = "spark"
	message = "shoots out sparks!"

/datum/emote/silicon/spark/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return

	var/mob/living/silicon/robot/silicon_user = user

	silicon_user.spark_system.start()

/datum/emote/silicon/law
	key = "law"

/datum/emote/silicon/law/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return

	var/mob/living/silicon/robot/silicon_user = user

	if(!istype(silicon_user.module, /obj/item/circuitboard/robot_module/security))
		to_chat(silicon_user, "You are not THE LAW, pal.")
		return

	silicon_user.visible_message("<b>[silicon_user]</b> shows its legal authorization barcode.")
	playsound(silicon_user, 'sound/voice/biamthelaw.ogg', 25, 0)

/datum/emote/silicon/halt
	key = "halt"

/datum/emote/silicon/halt/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return

	var/mob/living/silicon/robot/silicon_user = user

	if(!istype(silicon_user.module, /obj/item/circuitboard/robot_module/security))
		to_chat(silicon_user, "You are not security.")
		return

	user.visible_message("<b>[silicon_user]</b>'s speakers skreech, \"Halt! Security!\".")
	playsound(silicon_user, 'sound/voice/halt.ogg', 25, 0)
