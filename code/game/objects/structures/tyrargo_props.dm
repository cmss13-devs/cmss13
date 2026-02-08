/obj/structure/prop/tyrargo/boards
	name = "boards"
	desc = "Salvaged wooden boards."
	icon = 'icons/obj/structures/props/tyrargo_props.dmi'
	icon_state = "boards"
	density = FALSE
	anchored = TRUE
	unslashable = FALSE
	health = 100
	layer = 2.4
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/prop/tyrargo/boards/boards_1
	icon_state = "boards_2"
/obj/structure/prop/tyrargo/boards/boards_2
	icon_state = "boards_3"

/obj/structure/prop/tyrargo/boards/bullet_act(obj/projectile/P)
	health -= P.damage
	playsound(src, 'sound/effects/woodhit.ogg', 35, 1)
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/tyrargo/boards/proc/explode()
	visible_message(SPAN_DANGER("[src] crumbles!"), max_distance = 1)
	playsound(loc, 'sound/effects/woodhit.ogg', 25)

	deconstruct(FALSE)

/obj/structure/prop/tyrargo/boards/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/tyrargo/boards/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/tyrargo/boards/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// tents

/obj/structure/prop/tyrargo/large_tents
	name = "Tent"
	icon = 'icons/obj/structures/props/large_tent_props.dmi'
	icon_state = "medical_tent"
	health = 300
	layer = ABOVE_FLY_LAYER
	bound_height = 96
	bound_width = 96
	density = TRUE

/obj/structure/prop/tyrargo/large_tents/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/items/paper_ripped.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/tyrargo/large_tents/medical
	name = "Medical Tent"
	icon_state = "medical_tent"

/obj/structure/prop/tyrargo/large_tents/command
	name = "Command Tent"
	icon_state = "command_tent"

/obj/structure/prop/tyrargo/large_tents/supply
	name = "Supply Tent"
	icon_state = "supply_tent"

/obj/structure/prop/tyrargo/large_tents/small
	name = "Tent"
	icon_state = "small_tent"

/obj/structure/prop/tyrargo/large_tents/small_closed
	name = "Tent"
	icon_state = "small_closed_tent"

/obj/structure/prop/tyrargo/large_tents/small_closed/back
	name = "Tent"
	icon_state = "small_closed_tent_back"

// Military Light Source

/obj/structure/prop/tyrargo/illuminator
	name = "\improper UE-92/B Area Illuminator"
	desc = "Varient of the UE-92, a large deployable floodlight. This version is less powerful but it houses an internal power source that allows it to operate for several hours without being linked to a power generator."
	icon = 'icons/obj/structures/props/industrial/illuminator.dmi'
	icon_state = "floodlight-off"
	health = 300
	density = TRUE
	layer = ABOVE_FLY_LAYER
	bound_height = 32

/obj/structure/prop/tyrargo/illuminator/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// Watchtower

/obj/structure/prop/tyrargo/watchtower
	name = "Watchtower"
	desc = "UA military watchtower. Who watches the watchers?"
	icon = 'icons/obj/structures/props/industrial/watchtower.dmi'
	icon_state = "watchtower"
	health = 500
	density = TRUE
	layer = ABOVE_FLY_LAYER
	bound_height = 64
	bound_width = 64

/obj/structure/prop/tyrargo/watchtower/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

// Signs

/obj/structure/prop/tyrargo/military_alert_sign
	name = "ICC quarantine notice"
	desc = "A quarantine poster, bearing the ICC's logo, it reads: This area is designated a secure transit zone by the ICC and US Military. Non-compliance with military directives is punishable under the interplanetary biohazard preparedness act."
	icon = 'icons/obj/structures/props/wall_decorations/decals.dmi'
	icon_state = "military_sign"
	layer = WALL_OBJ_LAYER

/obj/structure/prop/tyrargo/military_alert_sign/alt
	icon_state = "military_sign_alt"

/obj/structure/prop/tyrargo/military_evac_sign
	name = "US military evacuation notice"
	desc = "A evacuation poster, it reads: All residents of Tyrargo Rift and outlying areas are required to evacuate by 5:45pm/2182. All evacuees will be asked to provide identification and may be subject to medical testing. Evacuees resisting offical direction will be detained. Evacuation is mandatory."
	icon = 'icons/obj/structures/props/wall_decorations/tyrargo32x64_signs.dmi'
	icon_state = "evac_sign"
	layer = WALL_OBJ_LAYER

/obj/structure/prop/tyrargo/military_checkpoint_sign
	name = "US military checkpoint notice"
	desc = "A military notice poster, it reads: Halt. US army checkpoint ahead. Comply or be shot."
	icon = 'icons/obj/structures/props/wall_decorations/tyrargo64x64_signs.dmi'
	icon_state = "tyrargo_checkpoint_sign"
	layer = WALL_OBJ_LAYER
	density = TRUE
	bound_width = 64

/obj/structure/prop/tyrargo/military_checkpoint_sign/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/tyrargo/military_checkpoint_sign/bullet_act(obj/projectile/P)
	health -= P.damage
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/tyrargo/military_checkpoint_sign/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/tyrargo/military_checkpoint_sign/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/tyrargo/military_checkpoint_sign/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

// TRR Truck

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/trr
	name = "Throop Rescue and Recovery truck"
	desc = "Emergency response vehicle used by the Throop Rescue and Recovery organization. A private group that assists in rapid response, search and rescue operations."
	icon = 'icons/obj/structures/props/vehicles/armored_truck_trr.dmi'
	icon_state = "armored_truck_trr"
	bound_height = 32
	layer = 4.2

// Traffic Sign
/obj/structure/prop/tyrargo/traffic_signal
	name = "Portable Changeable Message Sign"
	desc = "A PCMS, it displays offical instructions by the local authorities."
	icon = 'icons/obj/structures/props/industrial/traffic_signal.dmi'
	icon_state = "traffic_1"
	layer = BILLBOARD_LAYER
	density = TRUE
	health = 500
	light_on = TRUE
	light_color ="#FA9632"
	light_power = 2
	light_range = 2

/obj/structure/prop/tyrargo/traffic_signal/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/prop/tyrargo/traffic_signal/bullet_act(obj/projectile/P)
	health -= P.damage
	..()
	healthcheck()
	return TRUE

/obj/structure/prop/tyrargo/traffic_signal/proc/explode()
	visible_message(SPAN_DANGER("[src] breaks apart!"), max_distance = 1)
	deconstruct(FALSE)

/obj/structure/prop/tyrargo/traffic_signal/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/structure/prop/tyrargo/traffic_signal/ex_act(severity)
	switch(severity)
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)

/obj/structure/prop/tyrargo/traffic_signal/traffic_signal_1
	icon_state = "traffic_2"

/obj/structure/prop/tyrargo/traffic_signal/traffic_signal_2
	icon_state = "traffic_3"

/obj/structure/prop/tyrargo/traffic_signal/traffic_signal_3
	icon_state = "traffic_4"

/obj/structure/prop/tyrargo/traffic_signal/traffic_signal_4
	icon_state = "traffic_5"

/obj/structure/prop/tyrargo/traffic_signal/traffic_signal_5
	icon_state = "traffic_6"

// Prop Generator

/obj/structure/prop/tyrargo/gen
	name = "\improper expended UE-11 Generator Unit"
	desc = "Special power module designed to be a backup generator in the event of a transformer malfunction. This generator has already been expended."
	icon = 'icons/obj/structures/props/tyrargo_props.dmi'
	icon_state = "gen"
	density = TRUE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	anchored = TRUE

/obj/structure/prop/hybrisa/vehicles/Armored_Truck/trr
	name = "Throop Rescue and Recovery truck"
	desc = "Emergency response vehicle used by the Throop Rescue and Recovery organization. A private group that assists in rapid response, search and rescue operations."
	icon = 'icons/obj/structures/props/vehicles/armored_truck_trr.dmi'
	icon_state = "armored_truck_trr"
	bound_height = 32
	layer = 4.2
