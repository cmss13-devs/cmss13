/obj/item/hardpoint/locomotion/blackfoot_thrusters
	name = "\improper TJ-700 Turbojet Engines"
	desc = "Integral to the flight and movement of the blackfoot."
	icon = 'icons/obj/vehicles/hardpoints/arc.dmi'

	damage_multiplier = 0.15

	icon_state = "tires"
	disp_icon = "arc"
	disp_icon_state = "arc_wheels"

	health = 500

	move_delay = VEHICLE_SPEED_SUPERFAST
	move_max_momentum = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.5

	var/idle_sound_cooldown = 10 SECONDS
	var/last_idle_sound = 0

/obj/item/hardpoint/locomotion/blackfoot_thrusters/process(deltatime)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner
	
	if(!blackfoot_owner)
		return
	
	for(var/atom/movable/screen/blackfoot/custom_screen as anything in blackfoot_owner.custom_hud)
		custom_screen.update(blackfoot_owner.fuel, blackfoot_owner.max_fuel, blackfoot_owner.health, blackfoot_owner.maxhealth, blackfoot_owner.battery, blackfoot_owner.max_battery)

	if(world.time > last_idle_sound + idle_sound_cooldown)
		playsound(blackfoot_owner.loc, 'sound/vehicles/vtol/engineidle.ogg', 25, FALSE)
		last_idle_sound = world.time
	
	blackfoot_owner.fuel = max(0, blackfoot_owner.fuel - deltatime / 2)

	if(blackfoot_owner.fuel < 0)
		blackfoot_owner.toggle_engines()
		STOP_PROCESSING(SSobj, src)
	
