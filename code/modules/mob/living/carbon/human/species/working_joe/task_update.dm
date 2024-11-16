/datum/emote/living/carbon/human/synthetic/working_joe/task_update
	category = JOE_EMOTE_CATEGORY_TASK_UPDATE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/could_require_attention
	key = "couldrequireattention"
	sound = 'sound/voice/joe/could_require_attention.ogg'
	haz_sound = 'sound/voice/joe/could_require_attention_haz.ogg'
	say_message = "This could require my attention."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/let_me_help
	key = "letmehelp"
	sound = 'sound/voice/joe/let_me_help.ogg'
	say_message = "Let me help you."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/follow_me
	key = "followme"
	sound = 'sound/voice/joe/follow_me.ogg'
	say_message = "Follow me."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/follow_me_please
	key = "followmeplease"
	sound = 'sound/voice/joe/follow_me_please.ogg'
	haz_sound = 'sound/voice/joe/follow_me_please_haz.ogg'
	say_message = "Follow me please."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/come_with_me
	key = "comewithme"
	sound = 'sound/voice/joe/come_with_me.ogg'
	say_message = "Come with me please."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/with_you_shortly
	key = "withyoushortly"
	sound = 'sound/voice/joe/with_you_shortly.ogg'
	haz_sound = 'sound/voice/joe/with_you_shortly_haz.ogg'
	say_message = "I will be with you shortly."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/take_a_seat
	key = "takeaseat"
	sound = 'sound/voice/joe/take_a_seat.ogg'
	say_message = "Please take a seat, someone will be with you shortly."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/existing_tasks
	key = "existingtasks"
	sound = 'sound/voice/joe/existing_tasks.ogg'
	say_message = "Existing tasks have a higher priority."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE

/datum/emote/living/carbon/human/synthetic/working_joe/task_update/ticket_remove
	key = "ticketremoved"
	sound = 'sound/voice/joe/support_ticket_removed.ogg'
	haz_sound = 'sound/voice/joe/support_ticket_removed_haz.ogg'
	say_message = "Service support ticket removed from queue."
	emote_type = EMOTE_AUDIBLE|EMOTE_VISIBLE
	joe_flag = WORKING_JOE_EMOTE|HAZARD_JOE_EMOTE
