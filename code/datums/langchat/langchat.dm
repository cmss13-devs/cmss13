/client/var/list/image/langchat_list = list()

/mob/var/list/image/lang_text = list()
/mob/var/was_deafened = FALSE
/mob/var/langchat_height = 32 // abovetile usually
/mob/var/langchat_color = "#FFFFFF"
/mob/var/langchat_styles = ""

/mob/living/carbon/Xenomorph/langchat_color = "#b491c8"
/mob/living/carbon/Xenomorph/Carrier/langchat_height = 64
/mob/living/carbon/Xenomorph/Ravager/langchat_height = 64
/mob/living/carbon/Xenomorph/Queen/langchat_height = 64
/mob/living/carbon/Xenomorph/Praetorian/langchat_height = 64
/mob/living/carbon/Xenomorph/Hivelord/langchat_height = 64
/mob/living/carbon/Xenomorph/Defender/langchat_height = 48
/mob/living/carbon/Xenomorph/Warrior/langchat_height = 48

/datum/language/var/list/image/lang_image_list = list()
/datum/language/var/list/mob/lang_mob_list = list()
/datum/language/var/langchat_supported = FALSE

/datum/language/common/langchat_supported = TRUE
/datum/language/xenocommon/langchat_supported = TRUE

var/global_langchat_disabled = FALSE

/proc/disable_global_langchat()
	global_langchat_disabled = TRUE
	for(var/lang_name in all_languages)
		if(all_languages[lang_name].langchat_supported)
			var/datum/language/L = all_languages[lang_name]
			if(!istype(L))
				continue
			
			for(var/mob/M in L.lang_mob_list)
				if(!M || !M.client)
					continue
				M.client.images -= L.lang_image_list
				M.client.langchat_list -= L.lang_image_list
			L.lang_image_list.Cut()
			L.lang_mob_list.Cut()

/mob/add_language(language)
	..(language)
	if(global_langchat_disabled)
		return
	var/datum/language/new_language = all_languages[language]
	if(!istype(new_language))
		return
	if(!new_language.langchat_supported)
		return
	// create image for ourselves
	var/image/lang_image = image(null, src)
	lang_image.layer = 20
	lang_image.alpha = 0
	lang_image.color = langchat_color
	lang_image.appearance_flags = KEEP_APART
	// put the image for the mob
	lang_text[language] = lang_image
	// put this image into global list
	new_language.lang_image_list |= lang_image	
	// tell everyone in language knowers that we have new person that can talk
	for(var/mob/M in new_language.lang_mob_list)
		// no client? you should get it when you come back
		if(!M.client || !M.client.prefs || M.client.prefs.lang_chat_disabled)
			continue
		M.client.images |= lang_image
		M.client.langchat_list |= lang_image
	// put ourselves into mob list for that language
	new_language.lang_mob_list += src
	// read all images that already exist for this language (this will add our own image too)
	if(!client || !client.prefs || client.prefs.lang_chat_disabled)
		return
	client.images |= new_language.lang_image_list
	client.langchat_list |= new_language.lang_image_list

/mob/proc/langchat_update_colors()
	for(var/lang_name in lang_text)
		var/datum/language/L = all_languages[lang_name]
		if(!istype(L))
			continue
		if(!L.langchat_supported)
			continue
		lang_text[lang_name].color = langchat_color

/mob/proc/langchat_detach()
	for(var/lang_name in lang_text)
		var/datum/language/L = all_languages[lang_name]
		if(!istype(L))
			continue
		if(!L.langchat_supported)
			continue
		L.lang_image_list -= lang_text[lang_name]
		L.lang_mob_list -= src
		for(var/mob/M in L.lang_mob_list)
			if(!M || !M.client)
				continue
			M.client.images -= lang_text[lang_name]
			M.client.langchat_list -= lang_text[lang_name]

/client/proc/setup_lang_text(var/mob/M)
	// clear old icons
	images -= langchat_list
	if(langchat_list)
		langchat_list.Cut()
	else
		langchat_list = list()
	if(prefs && prefs.lang_chat_disabled)
		return
	if(!istype(M))
		M = mob
	if(isobserver(M))
		langchat_ghost_setup()
		return
	for(var/datum/language/L in M.languages)
		if(!L.langchat_supported)
			continue
		images |= L.lang_image_list
		langchat_list |= L.lang_image_list

/client/proc/unsetup_lang_text()
	// clear old icons
	images -= langchat_list
	if(langchat_list)
		langchat_list.Cut()
	else
		langchat_list = list()

/client/proc/langchat_add_watcher(language)
	if(prefs && prefs.lang_chat_disabled)
		return
	var/datum/language/new_language = all_languages[language]
	if(!istype(new_language))
		return
	if(!new_language.langchat_supported)
		return
	new_language.lang_mob_list += mob
	images += new_language.lang_image_list
	langchat_list += new_language.lang_image_list

/mob/proc/langchat_clear(language)
	if(!lang_text[language])
		return
	lang_text[language].maptext = ""

#define LANGCHAT_LONGEST_TEXT 32
#define LANGCHAT_WIDTH 96
#define LANGCHAT_X_OFFSET -32
#define LANGCHAT_MAX_ALPHA 196

#define LANGCHAT_DEFAULT_POP 0
#define LANGCHAT_PANIC_POP 1
#define LANGCHAT_FAST_POP 2

// params for default pop
#define LANGCHAT_MESSAGE_POP_TIME 3
#define LANGCHAT_MESSAGE_POP_Y_SINK 8
// params for panic pop
#define LANGCHAT_MESSAGE_PANIC_POP_TIME 1
#define LANGCHAT_MESSAGE_PANIC_POP_Y_SINK 8
#define LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE 6
#define LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES 6
#define LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN 1
// params for fast pop
#define LANGCHAT_MESSAGE_FAST_POP_TIME 1
#define LANGCHAT_MESSAGE_FAST_POP_Y_SINK 8

/mob/proc/langchat_say(language, text, var/list/additional_styles, animation_style)
	if(!lang_text[language])
		return
	var/text_to_display = text
	if(length(text) > LANGCHAT_LONGEST_TEXT)
		text_to_display = copytext_char(text, 1, LANGCHAT_LONGEST_TEXT + 1) + "..."

	var/timer = (length(text_to_display) / LANGCHAT_LONGEST_TEXT) * SECONDS_4 + SECONDS_2
	
	text_to_display = "<span class='center [additional_styles != null ? additional_styles.Join(" ") : ""] [langchat_styles] langchat'>[text_to_display]</span>"
	var/image/LTI = lang_text[language]
	LTI.maptext = text_to_display
	LTI.maptext_y = langchat_height
	LTI.pixel_x = 0
	LTI.pixel_y = 0
	LTI.maptext_width = LANGCHAT_WIDTH
	LTI.maptext_x = LANGCHAT_X_OFFSET

	switch(animation_style)
		if(LANGCHAT_DEFAULT_POP)
			LTI.maptext_y -= LANGCHAT_MESSAGE_POP_Y_SINK
			LTI.alpha = 0
			animate(LTI, pixel_y = LTI.pixel_y + LANGCHAT_MESSAGE_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_POP_TIME)
		if(LANGCHAT_PANIC_POP)
			LTI.maptext_y -= LANGCHAT_MESSAGE_PANIC_POP_Y_SINK
			LTI.alpha = LANGCHAT_MAX_ALPHA
			animate(LTI, pixel_y = LTI.pixel_y + LANGCHAT_MESSAGE_PANIC_POP_Y_SINK, time = LANGCHAT_MESSAGE_PANIC_POP_TIME)			
			animate(pixel_x = LTI.pixel_x - LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			for(var/i = 1 to LANGCHAT_MESSAGE_PANIC_SHAKE_TIMES)
				animate(pixel_x = LTI.pixel_x + 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = 2*LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
				animate(pixel_x = LTI.pixel_x - 2*LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
			animate(pixel_x = LTI.pixel_x + LANGCHAT_MESSAGE_PANIC_SHAKE_SIZE, time = LANGCHAT_MESSAGE_PANIC_SHAKE_TIME_TAKEN, easing = CUBIC_EASING)
		if(LANGCHAT_FAST_POP)
			LTI.maptext_y -= LANGCHAT_MESSAGE_FAST_POP_Y_SINK
			LTI.alpha = 0
			animate(LTI, pixel_y = LTI.pixel_y + LANGCHAT_MESSAGE_FAST_POP_Y_SINK, alpha = LANGCHAT_MAX_ALPHA, time = LANGCHAT_MESSAGE_FAST_POP_TIME)
	
	add_timer(CALLBACK(src, /mob.proc/langchat_clear, language), timer, TIMER_UNIQUE|TIMER_OVERRIDE_UNIQUE|TIMER_NO_WAIT_UNIQUE)

/client/proc/langchat_ghost_setup()
	unsetup_lang_text()
	for(var/lan_name in all_languages)
		if(all_languages[lan_name].langchat_supported)
			langchat_add_watcher(lan_name)