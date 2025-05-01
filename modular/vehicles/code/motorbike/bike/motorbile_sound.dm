/obj/vehicle/motorbike
	// Стартер
	var/start_sound = 'modular/sounds/sound/vehicles/bike/sound_bike_start.ogg'
	var/start_sound_delay = 2 SECONDS // На 1 сек меньше чем аудиофайл
	var/start_sound_vol = 20
	var/start_sound_range = 45

	// Движение
	var/movement_sound = 'modular/sounds/sound/vehicles/bike/sound_bike_move_fade.ogg'
	var/move_sound_delay = 1 SECONDS	// 10 децисекунд ОК если FADE
	var/rotate_sound = 'modular/sounds/sound/vehicles/bike/sound_bike_rotate_fade.ogg'
	var/rotate_sound_delay = 7 DECISECONDS // на 3 децисекунды меньше
	var/move_sound_vol = 20
	var/move_sound_range = 30
	var/next_move_sound_play = 0	//Cooldown for next sound to play

	// Выпендреж
	var/show_sound = 'modular/sounds/sound/vehicles/bike/sound_bike_show.ogg'
	var/show_sound_delay = 3 SECONDS
	var/show_sound_vol = 20
	var/show_sound_range = 45
	var/next_show_sound_play = 0

	// Гудок
	var/honk_sound = 'sound/vehicles/honk_4_light.ogg'
	var/honk_sound_delay = 1 SECONDS //to prevent spamming
	var/honk_sound_vol = 45
	var/honk_sound_range = 15
	var/next_honk_sound_play = 0

// ==========================================
// ================= СТАРТЕР ================
// Я СКАЗАЛ - СТАРТУЕМ!

/obj/vehicle/motorbike/proc/play_start_sound()
	if(start_sound && world.time > next_move_sound_play)
		playsound(src, start_sound, start_sound_vol, sound_range = start_sound_range)
		next_move_sound_play = world.time + start_sound_delay

// ==========================================
// ================ ДВИЖЕНИЕ ================

/obj/vehicle/motorbike/proc/play_move_sound()
	if(movement_sound && world.time > next_move_sound_play)
		playsound(src, movement_sound, move_sound_vol, sound_range = move_sound_range)
		next_move_sound_play = world.time + move_sound_delay

/obj/vehicle/motorbike/proc/play_rotate_sound()
	if(rotate_sound && world.time > next_move_sound_play)
		playsound(src, rotate_sound, move_sound_vol, sound_range = move_sound_range)
		next_move_sound_play = world.time + rotate_sound_delay

// ==========================================
// ================== ГУДОК =================

/obj/vehicle/motorbike/proc/play_honk_sound()
	if(honk_sound && world.time > next_honk_sound_play)
		playsound(loc, honk_sound, honk_sound_vol, TRUE, sound_range = honk_sound_range)
		next_honk_sound_play = world.time + honk_sound_delay

	if(honk_sound && world.time < honk_sound_delay)
		to_chat(buckled_mob, SPAN_WARNING("Перед следующим гудком - подождите [(honk_sound_delay - world.time) / 10] секунд."))

// ==========================================
// ================ Выпендреж ===============

/obj/vehicle/motorbike/proc/play_show_sound()
	if(show_sound && world.time > next_show_sound_play)
		playsound(loc, show_sound, show_sound_vol, TRUE, sound_range = show_sound_range)
		next_show_sound_play = world.time + show_sound_delay

