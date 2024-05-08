

/obj/item/device/walkman
	name = "walkman"
	desc = "A cassette player that first hit the market over 200 years ago. Crazy how these never went out of style."
	icon = 'icons/obj/items/walkman.dmi'
	icon_state = "walkman"
	w_class = SIZE_SMALL
	flags_equip_slot = SLOT_WAIST | SLOT_EAR
	actions_types = list(/datum/action/item_action/walkman/play_pause,/datum/action/item_action/walkman/next_song,/datum/action/item_action/walkman/restart_song)
	var/obj/item/device/cassette_tape/tape
	var/paused = TRUE
	var/list/current_playlist = list()
	var/list/current_songnames = list()
	var/sound/current_song
	var/mob/current_listener
	var/pl_index = 1
	var/volume = 25
	var/design = 1 // What kind of walkman design style to use
	item_icons = list(
		WEAR_L_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_R_EAR = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_WAIST = 'icons/mob/humans/onmob/ears.dmi',
		WEAR_IN_J_STORE = 'icons/mob/humans/onmob/ears.dmi'
		)
	black_market_value = 15

/obj/item/device/walkman/Initialize()
	. = ..()
	design = rand(1, 5)
	update_icon()

/obj/item/device/walkman/Destroy()
	QDEL_NULL(tape)
	break_sound()
	current_song = null
	current_listener = null
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/device/walkman/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/device/cassette_tape))
		if(W == user.get_active_hand() && (src in user))
			if(!tape)
				insert_tape(W)
				playsound(src,'sound/weapons/handcuffs.ogg',20,1)
				to_chat(user,SPAN_INFO("You insert \the [W] into \the [src]"))
			else
				to_chat(user,SPAN_WARNING("Remove the other tape first!"))

/obj/item/device/walkman/attack_self(mob/user)
	..()

	if(!current_listener)
		current_listener = user
		START_PROCESSING(SSobj, src)
	if(istype(tape))
		if(paused)
			play()
			to_chat(user,SPAN_INFO("You press [src]'s 'play' button"))
		else
			pause()
			to_chat(user,SPAN_INFO("You pause [src]"))
		update_icon()
	else
		to_chat(user,SPAN_INFO("There's no tape to play"))
	playsound(src,'sound/machines/click.ogg',20,1)

/obj/item/device/walkman/attack_hand(mob/user)
	if(tape && src == user.get_inactive_hand())
		eject_tape(user)
		return
	else
		..()


/obj/item/device/walkman/proc/break_sound()
	var/sound/break_sound = sound(null, 0, 0, SOUND_CHANNEL_WALKMAN)
	break_sound.priority = 255
	update_song(break_sound, current_listener, 0)

/obj/item/device/walkman/proc/update_song(sound/S, mob/M, flags = SOUND_UPDATE)
	if(!istype(M) || !istype(S)) return
	if(M.ear_deaf > 0)
		flags |= SOUND_MUTE
	S.status = flags
	S.volume = src.volume
	S.channel = SOUND_CHANNEL_WALKMAN
	sound_to(M,S)

/obj/item/device/walkman/proc/pause(mob/user)
	if(!current_song) return
	paused = TRUE
	update_song(current_song,current_listener, SOUND_PAUSED | SOUND_UPDATE)

/obj/item/device/walkman/proc/play()
	if(!current_song)
		if(current_playlist.len > 0)
			current_song = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
			current_song.status = SOUND_STREAM
		else
			return
	paused = FALSE
	if(current_song.status & SOUND_PAUSED)
		to_chat(current_listener,SPAN_INFO("Resuming [pl_index] of [current_playlist.len]"))
		update_song(current_song,current_listener)
	else
		to_chat(current_listener,SPAN_INFO("Now playing [pl_index] of [current_playlist.len]"))
		update_song(current_song,current_listener,0)

	update_song(current_song,current_listener)

/obj/item/device/walkman/proc/insert_tape(obj/item/device/cassette_tape/CT)
	if(tape || !istype(CT)) return

	tape = CT
	if(ishuman(CT.loc))
		var/mob/living/carbon/human/H = CT.loc
		H.drop_held_item(CT)
	CT.forceMove(src)

	update_icon()
	paused = TRUE
	pl_index = 1
	if(tape.songs["side1"] && tape.songs["side2"])
		var/list/L = tape.songs["[tape.flipped ? "side2" : "side1"]"]
		for(var/S in L)
			current_playlist += S
			current_songnames += L[S]


/obj/item/device/walkman/proc/eject_tape(mob/user)
	if(!tape) return

	break_sound()

	current_song = null
	current_playlist.Cut()
	current_songnames.Cut()
	user.put_in_hands(tape)
	paused = TRUE
	tape = null
	update_icon()
	playsound(src,'sound/weapons/handcuffs.ogg',20,1)
	to_chat(user,SPAN_INFO("You eject the tape from [src]"))

/obj/item/device/walkman/proc/next_song(mob/user)

	if(user.is_mob_incapacitated() || current_playlist.len == 0) return

	break_sound()

	if(pl_index + 1 <= current_playlist.len)
		pl_index++
	else
		pl_index = 1
	current_song = sound(current_playlist[pl_index], 0, 0, SOUND_CHANNEL_WALKMAN, volume)
	current_song.status = SOUND_STREAM
	play()
	to_chat(user,SPAN_INFO("You change the song"))


/obj/item/device/walkman/update_icon()
	..()
	overlays.Cut()
	if(design)
		overlays += "+[design]"
	if(tape)
		if(!paused)
			overlays += "+playing"
	else
		overlays += "+empty"

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.regenerate_icons()

/obj/item/device/walkman/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if((slot == WEAR_L_EAR || slot == WEAR_R_EAR) && !paused)
		var/image/I = overlay_image(ret.icon, "+music", color, RESET_COLOR)
		ret.overlays += I
	return ret

/obj/item/device/walkman/process()
	if(!(src in current_listener.GetAllContents(3)) || current_listener.stat & DEAD)
		if(current_song)
			current_song = null
		break_sound()
		paused = TRUE
		current_listener = null
		update_icon()
		STOP_PROCESSING(SSobj, src)
		return

	if(current_listener.ear_deaf > 0 && current_song && !(current_song.status & SOUND_MUTE))
		update_song(current_song, current_listener)
	if(current_listener.ear_deaf == 0 && current_song && current_song.status & SOUND_MUTE)
		update_song(current_song, current_listener)

/obj/item/device/walkman/verb/play_pause()
	set name = "Play/Pause"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated()) return

	attack_self(usr)

/obj/item/device/walkman/verb/eject_cassetetape()
	set name = "Eject tape"
	set category = "Object"
	set src in usr

	eject_tape(usr)

/obj/item/device/walkman/verb/next_pl_song()
	set name = "Next song"
	set category = "Object"
	set src in usr

	next_song(usr)

/obj/item/device/walkman/verb/change_volume()
	set name = "Change Walkman volume"
	set category = "Object"
	set src in usr

	if(usr.is_mob_incapacitated() || !current_song) return

	var/tmp = tgui_input_number(usr,"Change the volume (0 - 100)","Volume", volume, 100, 0)
	if(tmp == null) return
	if(tmp > 100) tmp = 100
	if(tmp < 0) tmp = 0
	volume = tmp
	update_song(current_song, current_listener)

/obj/item/device/walkman/proc/restart_song(mob/user)
	if(user.is_mob_incapacitated() || !current_song) return

	update_song(current_song, current_listener, 0)
	to_chat(user,SPAN_INFO("You restart the song"))

/obj/item/device/walkman/verb/restart_current_song()
	set name = "Restart Song"
	set category = "Object"
	set src in usr

	restart_song(usr)

/*

	ACTION BUTTONS

*/

/datum/action/item_action/walkman

/datum/action/item_action/walkman/New()
	..()
	button.overlays += image('icons/mob/hud/actions.dmi', button, action_icon_state)

/datum/action/item_action/walkman/play_pause
	action_icon_state = "walkman_playpause"

/datum/action/item_action/walkman/play_pause/New()
	..()
	name = "Play/Pause"
	button.name = name

/datum/action/item_action/walkman/play_pause/action_activate()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.attack_self(owner)

/datum/action/item_action/walkman/next_song
	action_icon_state = "walkman_next"

/datum/action/item_action/walkman/next_song/New()
	..()
	name = "Next song"
	button.name = name

/datum/action/item_action/walkman/next_song/action_activate()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.next_song(owner)

/datum/action/item_action/walkman/restart_song
	action_icon_state = "walkman_restart"

/datum/action/item_action/walkman/restart_song/New()
	..()
	name = "Restart song"
	button.name = name

/datum/action/item_action/walkman/restart_song/action_activate()
	if(target)
		var/obj/item/device/walkman/WM = target
		WM.restart_song(owner)

/*
	TAPES
*/

/obj/item/device/cassette_tape
	name = "cassette Tape"
	desc = "A cassette tape"
	icon = 'icons/obj/items/walkman.dmi'
	icon_state = "cassette_flip"
	w_class = SIZE_SMALL
	black_market_value = 15
	var/side1_icon = "cassette"
	var/flipped = FALSE //Tape side
	var/list/songs = list()
	var/id = 1

/obj/item/device/cassette_tape/attack_self(mob/user)
	..()

	if(flipped == TRUE)
		flipped = FALSE
		icon_state = side1_icon
	else
		flipped = TRUE
		icon_state = "cassette_flip"
	to_chat(user,"You flip [src]")

/obj/item/device/cassette_tape/verb/flip()
	set name = "Flip tape"
	set category = "Object"
	set src in usr

	attack_self()

/obj/item/device/cassette_tape/pop1
	name = "blue cassette"
	id = 2
	desc = "A plastic cassette tape with a blue sticker.\nFrom 13th with love."
	icon_state = "cassette_blue"
	side1_icon = "cassette_blue"
	songs = list("side1" = list("sound/music/walkman/pop1/1-1-1.ogg",\
								"sound/music/walkman/pop1/1-1-2.ogg",\
								"sound/music/walkman/pop1/1-1-3.ogg"),\
				"side2" = list("sound/music/walkman/pop1/1-2-1.ogg",\
								"sound/music/walkman/pop1/1-2-2.ogg",\
								"sound/music/walkman/pop1/1-2-3.ogg"))

/obj/item/device/cassette_tape/pop2
	name = "rainbow cassette"
	id = 3
	desc = "A plastic cassette tape with a rainbow-colored sticker.\nFrom 13th with love."
	icon_state = "cassette_rainbow"
	side1_icon = "cassette_rainbow"
	songs = list("side1" = list("sound/music/walkman/pop2/2-1-1.ogg",\
								"sound/music/walkman/pop2/2-1-2.ogg",\
								"sound/music/walkman/pop2/2-1-3.ogg"),\
				"side2" = list("sound/music/walkman/pop2/2-2-1.ogg",\
								"sound/music/walkman/pop2/2-2-2.ogg",\
								"sound/music/walkman/pop2/2-2-3.ogg"))

/obj/item/device/cassette_tape/pop3
	name = "orange cassette"
	id = 4
	desc = "A plastic cassette tape with an orange sticker.\nFrom shizoidov with love."
	icon_state = "cassette_orange"
	side1_icon = "cassette_orange"
	songs = list("side1" = list("sound/music/walkman/pop3/3-1-1.ogg",\
								"sound/music/walkman/pop3/3-1-2.ogg",\
								"sound/music/walkman/pop3/3-1-3.ogg"),\
				"side2" = list("sound/music/walkman/pop3/3-2-1.ogg",\
								"sound/music/walkman/pop3/3-2-2.ogg",\
								"sound/music/walkman/pop3/3-2-3.ogg"))

/obj/item/device/cassette_tape/pop4
	name = "pink cassette"
	id = 5
	desc = "A plastic cassette tape with a pink striped sticker.\nFrom shizoidov with love."
	icon_state = "cassette_pink_stripe"
	side1_icon = "cassette_pink_stripe"
	songs = list("side1" = list("sound/music/walkman/pop4/4-1-1.ogg",\
								"sound/music/walkman/pop4/4-1-2.ogg",\
								"sound/music/walkman/pop4/4-1-3.ogg"),\
				"side2" = list("sound/music/walkman/pop4/4-2-1.ogg",\
								"sound/music/walkman/pop4/4-2-2.ogg",\
								"sound/music/walkman/pop4/4-2-3.ogg"))

/obj/item/device/cassette_tape/heavymetal
	name = "red-black cassette"
	id = 6
	desc = "A plastic cassette tape with a red and black sticker.\nFrom Rocky with love."
	icon_state = "cassette_red_black"
	side1_icon = "cassette_red_black"
	songs = list("side1" = list("sound/music/walkman/heavymetal/5-1-1.ogg",\
								"sound/music/walkman/heavymetal/5-1-2.ogg",\
								"sound/music/walkman/heavymetal/5-1-3.ogg"),\
				"side2" = list("sound/music/walkman/heavymetal/5-2-1.ogg",\
								"sound/music/walkman/heavymetal/5-2-2.ogg",\
								"sound/music/walkman/heavymetal/5-2-3.ogg"))

/obj/item/device/cassette_tape/industrial
	name = "red striped cassette"
	id = 7
	desc = "A plastic cassette tape with a gray sticker with red stripes.\nFrom Rocky with love."
	icon_state = "cassette_red_stripe"
	side1_icon = "cassette_red_stripe"
	songs = list("side1" = list("sound/music/walkman/industrial/6-1-1.ogg",\
								"sound/music/walkman/industrial/6-1-2.ogg",\
								"sound/music/walkman/industrial/6-1-3.ogg"),\
				"side2" = list("sound/music/walkman/industrial/6-2-1.ogg",\
								"sound/music/walkman/industrial/6-2-2.ogg",\
								"sound/music/walkman/industrial/6-2-3.ogg"))

/obj/item/device/cassette_tape/indie
	name = "rising sun cassette"
	id = 8
	desc = "A plastic cassette tape with the Japanese Rising Sun.\nSeems empty."
	icon_state = "cassette_rising_sun"
	side1_icon = "cassette_rising_sun"
	songs = list("side1" = list("sound/music/walkman/indie/7-1-1.ogg",\
								"sound/music/walkman/indie/7-1-2.ogg",\
								"sound/music/walkman/indie/7-1-3.ogg"),\
				"side2" = list("sound/music/walkman/indie/7-2-1.ogg",\
								"sound/music/walkman/indie/7-2-2.ogg",\
								"sound/music/walkman/indie/7-2-3.ogg"))

/obj/item/device/cassette_tape/hiphop
	name = "blue stripe cassette"
	id = 9
	desc = "An orange plastic cassette tape with a blue stripe.\nFrom Cat with love."
	icon_state = "cassette_orange_blue"
	side1_icon = "cassette_orange_blue"
	songs = list("side1" = list("sound/music/walkman/pop8/8-1-1.ogg",\
								"sound/music/walkman/pop8/8-1-2.ogg",\
								"sound/music/walkman/pop8/8-1-3.ogg"),\
				"side2" = list("sound/music/walkman/pop8/8-2-1.ogg",\
								"sound/music/walkman/pop8/8-2-2.ogg",\
								"sound/music/walkman/pop8/8-2-3.ogg"))

/obj/item/device/cassette_tape/nam
	name = "green cassette"
	id = 10
	desc = "A green plastic cassette tape.\nFrom TWE with love."
	icon_state = "cassette_green"
	side1_icon = "cassette_green"
	songs = list("side1" = list("sound/music/walkman/britmus/9-1-1.ogg",\
								"sound/music/walkman/britmus/9-1-2.ogg"),\
				"side2" = list("sound/music/walkman/britmus/9-2-1.ogg",\
								"sound/music/walkman/britmus/9-2-2.ogg"))

/obj/item/device/cassette_tape/ocean
	name = "ocean cassette"
	id = 11
	desc = "A blue and white plastic cassette tape.\nSeems empty."
	icon_state = "cassette_ocean"
	side1_icon = "cassette_ocean"
	songs = list("side1" = list("sound/music/walkman/surf/10-1-1.ogg",\
								"sound/music/walkman/surf/10-1-2.ogg",\
								"sound/music/walkman/surf/10-1-3.ogg",\
								"sound/music/walkman/surf/10-1-4.ogg"),\
				"side2" = list("sound/music/walkman/surf/10-2-1.ogg",\
								"sound/music/walkman/surf/10-2-2.ogg",\
								"sound/music/walkman/surf/10-2-3.ogg",\
								"sound/music/walkman/surf/10-2-4.ogg"))

// hotline reference
/obj/item/device/cassette_tape/aesthetic
	name = "aesthetic cassette"
	id = 12
	desc = "An aesthetic looking cassette tape. 'Jacket' is written on the front.\nSeems empty."
	icon_state = "cassette_aesthetic"
	side1_icon = "cassette_aesthetic"

//cassette tape that I thought was a good idea but doesnt fit for new maps.
/obj/item/device/cassette_tape/cargocrate
	name = "weyland yutani cassette"
	id = 13
	desc = "A blue metallic cassette with a weyland yutani logo.\nSeems empty."
	icon_state = "cassette_wy"
	side1_icon = "cassette_wy"

// cassette tapes for map lore
/obj/item/device/cassette_tape/solaris
	name = "red UCP cassette"
	id = 14
	desc = "A cassette with a red UCP camo design.\nSeems empty."
	icon_state = "cassette_solaris"
	side1_icon = "cassette_solaris"


/obj/item/device/cassette_tape/icecolony
	name = "frozen cassette"
	id = 15
	desc = "A cassette. It's covered in ice and snow.\nSeems empty."
	icon_state = "cassette_ice"
	side1_icon = "cassette_ice"

/obj/item/device/cassette_tape/lz
	name = "nostalgic cassette"
	id = 16
	desc = "There's a cut up postcard taped to this cassette. You know this place.\nSeems empty."
	icon_state = "cassette_lz"
	side1_icon = "cassette_lz"

/obj/item/device/cassette_tape/desertdam
	name = "dam cassette"
	id = 17
	desc = "Attached to this cassette is a picture of a dam.\nSeems empty."
	icon_state = "cassette_dam"
	side1_icon = "cassette_dam"

/obj/item/device/cassette_tape/prison
	name = "broken cassette"
	id = 18
	desc = "The shell on this cassette is broken, it still looks like it'll work, though!\nSeems empty."
	icon_state = "cassette_worstmap"
	side1_icon = "cassette_worstmap"
