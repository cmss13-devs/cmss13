/obj/item/hardpoint/primary/minigun
	name = "LTAA-AP Minigun"
	desc = "A primary weapon for tanks that spews bullets"

	icon_state = "ltaaap_minigun"
	disp_icon = "tank"
	disp_icon_state = "ltaaap_minigun"

	health = 350
	//accuracy = 0.6
	firing_arc = 90

	origins = list(0, -3)

	ammo = new /obj/item/ammo_magazine/hardpoint/ltaaap_minigun
	max_clips = 1

	px_offsets = list(
		"1" = list(0, 21),
		"2" = list(0, -32),
		"4" = list(32, 0),
		"8" = list(-32, 0)
	)

	muzzle_flash_pos = list(
		"1" = list(0, 57),
		"2" = list(0, -67),
		"4" = list(77, 0),
		"8" = list(-77, 0)
	)

	fire_delay = 0.8 SECONDS
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	scatter = 7

	var/start_sound = 'sound/weapons/vehicles/minigun_start.ogg'
	var/loop_sound = 'sound/weapons/vehicles/minigun_loop.ogg'
	var/stop_sound = 'sound/weapons/vehicles/minigun_stop.ogg'
	activation_sounds = list('sound/weapons/gun_minigun.ogg')
	/// Active firing time to reach max spin_stage
	var/spinup_time = 8 SECONDS
	/// Cooldown time to reach min spin_stage
	var/spindown_time = 3 SECONDS
	/// Index of stage_rate
	var/spin_stage = 1
	/// Shots fired per fire_delay at a particular spin_stage
	var/list/stage_rate = list(1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5)
	/// Fire delay for current spin_stage
	var/stage_delay = 0.8 SECONDS

/obj/item/hardpoint/primary/minigun/process(delta_time)
	var/stage_rate_len = stage_rate.len
	var/delta_stage = (delta_time SECONDS) * (stage_rate_len - 1)

	var/old_spin_stage = spin_stage
	if(auto_firing || burst_firing) //spinup if firing
		spin_stage += delta_stage / spinup_time
	else //spindown if not firing
		spin_stage -= delta_stage / spindown_time
	spin_stage = Clamp(spin_stage, 1, stage_rate_len)

	var/old_stage_rate = stage_rate[Floor(old_spin_stage)]
	var/new_stage_rate = stage_rate[Floor(spin_stage)]

	if(old_stage_rate != new_stage_rate)
		stage_delay = fire_delay / new_stage_rate
		SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, stage_delay)

	if(spin_stage <= 1)
		spin_stage = 1
		STOP_PROCESSING(SSobj, src)

/obj/item/hardpoint/primary/minigun/handle_fire()
	. = ..()

	if((. & AUTOFIRE_CONTINUE))
		COOLDOWN_START(src, fire_cooldown, stage_delay)
		START_PROCESSING(SSobj, src)
