/obj/item/hardpoint/primary/minigun
	name = "LTAA-AP Minigun"
	desc = "A primary weapon for tanks that spews bullets"

	icon_state = "ltaaap_minigun"
	disp_icon = "tank"
	disp_icon_state = "ltaaap_minigun"

	health = 350
	firing_arc = 90

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

	scatter = 7
	gun_firemode = GUN_FIREMODE_AUTOMATIC
	gun_firemode_list = list(
		GUN_FIREMODE_AUTOMATIC,
	)
	fire_delay = 0.8 SECONDS //base fire rate, modified by stage_delay_mult

	activation_sounds = list('sound/weapons/gun_minigun.ogg')
	/// Active firing time to reach max spin_stage.
	var/spinup_time = 8 SECONDS
	/// Grace period before losing spin_stage.
	var/spindown_grace_time = 2 SECONDS
	COOLDOWN_DECLARE(spindown_grace_cooldown)
	/// Cooldown time to reach min spin_stage.
	var/spindown_time = 3 SECONDS
	/// Index of stage_rate.
	var/spin_stage = 1
	/// Shots fired per fire_delay at a particular spin_stage.
	var/list/stage_rate = list(1, 1, 2, 2, 3, 3, 3, 4, 4, 4, 5)
	/// Fire delay multiplier for current spin_stage.
	var/stage_delay_mult = 1
	/// When it was last fired, related to world.time.
	var/last_fired = 0

/obj/item/hardpoint/primary/minigun/set_fire_delay(value)
	fire_delay = value
	SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay * stage_delay_mult)

/obj/item/hardpoint/primary/minigun/set_fire_cooldown()
	calculate_stage_delay_mult() //needs to check grace_cooldown before refreshed
	last_fired = world.time
	COOLDOWN_START(src, spindown_grace_cooldown, spindown_grace_time)
	COOLDOWN_START(src, fire_cooldown, fire_delay * stage_delay_mult)

/obj/item/hardpoint/primary/minigun/proc/calculate_stage_delay_mult()
	var/stage_rate_len = stage_rate.len
	var/delta_time = world.time - last_fired

	var/old_spin_stage = spin_stage
	if(auto_firing || burst_firing) //spinup if continuing fire
		var/delta_stage = delta_time * (stage_rate_len - 1)
		spin_stage += delta_stage / spinup_time
	else if(COOLDOWN_FINISHED(src, spindown_grace_cooldown)) //spindown if initiating fire after grace
		var/delta_stage = (delta_time - spindown_grace_time) * (stage_rate_len - 1)
		spin_stage -= delta_stage / spindown_time
	else
		return
	spin_stage = clamp(spin_stage, 1, stage_rate_len)

	var/old_stage_rate = stage_rate[floor(old_spin_stage)]
	var/new_stage_rate = stage_rate[floor(spin_stage)]

	if(old_stage_rate != new_stage_rate)
		stage_delay_mult = 1 / new_stage_rate
		SEND_SIGNAL(src, COMSIG_GUN_AUTOFIREDELAY_MODIFIED, fire_delay * stage_delay_mult)
