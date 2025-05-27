/obj/structure/prop/tower
	name = "destroyed comms tower"
	desc = "An old company comms tower used to transmit communications between subspace bodies. Looks like this one has seen better days."
	icon = 'icons/obj/structures/machinery/comm_tower.dmi'
	icon_state = "comm_tower_destroyed"
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = ABOVE_FLY_LAYER
	bound_height = 96

/obj/structure/prop/dam
	density = TRUE

/obj/structure/prop/dam/drill
	name = "mining drill"
	desc = "An old mining drill, seemingly used for mining. And possibly drilling."
	icon = 'icons/obj/structures/props/industrial/drill.dmi'
	icon_state = "drill"
	bound_height = 96
	var/on = FALSE//if this is set to on by default, the drill will start on, doi

/obj/structure/prop/dam/drill/attackby(obj/item/W, mob/user)
	. = ..()
	if(isxeno(user))
		return
	else if (ishuman(user) && HAS_TRAIT(W, TRAIT_TOOL_WRENCH))
		on = !on
		visible_message("You wrench the controls of \the [src]. The drill jumps to life." , "[user] wrenches the controls of \the [src]. The drill jumps to life.")

		update()

/obj/structure/prop/dam/drill/proc/update()
	icon_state = "thumper[on ? "-on" : ""]"
	if(on)
		set_light(3)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		set_light(0)
		playsound(src, 'sound/machines/turbine_off.ogg')
	return

/obj/structure/prop/dam/drill/Initialize()
	. = ..()
	update()

/obj/structure/prop/dam/truck
	name = "truck"
	desc = "An old truck, seems to be broken down."
	icon = 'icons/obj/structures/props/vehicles/vehicles.dmi'
	icon_state = "truck"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/truck/damaged
	icon_state = "truck_damaged"

/obj/structure/prop/dam/truck/mining
	name = "mining truck"
	desc = "An old mining truck, seems to be broken down."
	icon_state = "truck_mining"

/obj/structure/prop/dam/truck/cargo
	name = "cargo truck"
	desc = "An old cargo truck, seems to be broken down."
	icon_state = "truck_cargo"

/obj/structure/prop/dam/van
	name = "van"
	desc = "An old van, seems to be broken down."
	icon = 'icons/obj/structures/props/vehicles/vehicles.dmi'
	icon_state = "van"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/van/damaged
	icon_state = "van_damaged"

/obj/structure/prop/dam/crane
	name = "cargo crane"
	icon = 'icons/obj/structures/props/vehicles/vehicles.dmi'
	icon_state = "crane"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/crane/damaged
	icon_state = "crane_damaged"

/obj/structure/prop/dam/crane/cargo
	icon_state = "crane_cargo"

/obj/structure/prop/dam/torii
	name = "torii arch"
	desc = "A traditional Japanese archway, made out of wood, and adorned with lanterns."
	icon = 'icons/obj/structures/props/furniture/torii.dmi'
	icon_state = "torii"
	density = FALSE
	pixel_x = -16
	layer = MOB_LAYER+0.5
	var/lit = 0

/obj/structure/prop/dam/torii/New()
	..()
	Update()

/obj/structure/prop/dam/torii/proc/Update()
	underlays.Cut()
	underlays += "shadow[lit ? "-lit" : ""]"
	icon_state = "torii[lit ? "-lit" : ""]"
	if(lit)
		set_light(6)
	else
		set_light(0)
	return

/obj/structure/prop/dam/torii/attack_hand(mob/user as mob)
	..()
	if(lit)
		lit = !lit
		visible_message("[user] extinguishes the lanterns on [src].",
			"You extinguish the fires on [src].")
		Update()
	return

/obj/structure/prop/dam/torii/attackby(obj/item/W, mob/user)
	var/L
	if(lit)
		return
	if(iswelder(W))
		var/obj/item/tool/weldingtool/WT = W
		if(WT.isOn())
			L = 1
	else if(istype(W, /obj/item/tool/lighter/zippo))
		var/obj/item/tool/lighter/zippo/Z = W
		if(Z.heat_source)
			L = 1
	else if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/FL = W
		if(FL.heat_source)
			L = 1
	else if(istype(W, /obj/item/tool/lighter))
		var/obj/item/tool/lighter/G = W
		if(G.heat_source)
			L = 1
	else if(istype(W, /obj/item/tool/match))
		var/obj/item/tool/match/M = W
		if(M.heat_source)
			L = 1
	else if(istype(W, /obj/item/weapon/energy/sword))
		var/obj/item/weapon/energy/sword/S = W
		if(S.active)
			L = 1
	else if(istype(W, /obj/item/device/assembly/igniter))
		L = 1
	else if(istype(W, /obj/item/attachable/attached_gun/flamer))
		L = 1
	else if(istype(W, /obj/item/weapon/gun/flamer))
		var/obj/item/weapon/gun/flamer/F = W
		if(!(F.flags_gun_features & GUN_TRIGGER_SAFETY))
			L = 1
		else
			to_chat(user, SPAN_WARNING("Turn on the pilot light first!"))

	else if(isgun(W))
		var/obj/item/weapon/gun/G = W
		for(var/slot in G.attachments)
			if(istype(G.attachments[slot], /obj/item/attachable/attached_gun/flamer))
				L = 1
				break
	else if(istype(W, /obj/item/tool/surgery/cautery))
		L = 1
	else if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/C = W
		if(C.item_state == C.icon_on)
			L = 1
	else if(istype(W, /obj/item/tool/candle))
		if(W.heat_source > 200)
			L = 1
	if(L)
		visible_message("[user] quietly goes from lantern to lantern on the torii, lighting the wicks in each one.")
		lit = TRUE
		Update()

/obj/structure/prop/dam/gravestone
	name = "grave marker"
	desc = "A grave marker, in the traditional Japanese style."
	icon = 'icons/obj/structures/props/props.dmi'
	icon_state = "gravestone1"

/obj/structure/prop/dam/gravestone/New()
	..()
	icon_state = "gravestone[rand(1,4)]"

/obj/structure/prop/dam/boulder
	name = "boulder"
	icon_state = "boulder1"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/vegetation/dam.dmi'

/obj/structure/prop/dam/boulder/boulder1
	icon_state = "boulder1"

/obj/structure/prop/dam/boulder/boulder2
	icon_state = "boulder2"

/obj/structure/prop/dam/boulder/boulder3
	icon_state = "boulder3"


/obj/structure/prop/dam/large_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/boulder_large.dmi'
	bound_height = 64
	bound_width = 64

/obj/structure/prop/dam/large_boulder/boulder1
	icon_state = "boulder_large1"

/obj/structure/prop/dam/large_boulder/boulder2
	icon_state = "boulder_large2"

/obj/structure/prop/dam/wide_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/natural/boulder_wide.dmi'
	bound_height = 32
	bound_width = 64

/obj/structure/prop/dam/wide_boulder/boulder1
	icon_state = "boulder1"

//Use these to replace non-functional machinery 'props' around maps from bay12

/obj/structure/prop/server_equipment
	name = "server rack"
	desc = "A rack full of hard drives, micro-computers, and ethernet cables."
	icon = 'icons/obj/structures/props/server_equipment.dmi'
	icon_state = "rackframe"
	density = TRUE
	health = 150

/obj/structure/prop/server_equipment/broken
	name = "broken server rack"
	desc = "A rack that was once full of hard drives, micro-computers, and ethernet cables. Though most of those are scattered on the floor now."
	icon_state = "rackframe_broken"
	health = 100

/obj/structure/prop/server_equipment/yutani_server
	name = "Yutani OS server box"
	desc = "Yutani OS is a proprietary operating system used by the Company to run most all of their servers, banking, and management systems. A code leak in 2144 led some amateur hackers to believe that Yutani OS is loosely based on the 2017 release of TempleOS. But the Company has refuted these claims."
	icon_state = "yutani_server_on"

/obj/structure/prop/server_equipment/yutani_server/broken
	icon_state = "yutani_server_broken"

/obj/structure/prop/server_equipment/yutani_server/off
	icon_state = "yutani_server_off"

/obj/structure/prop/server_equipment/laptop
	name = "laptop"
	desc = "Laptops, porta-comps, and reel-back computers, all of these and more available at your local Wey-Mart electronics section!"
	icon_state = "laptop_off"
	density = FALSE

/obj/structure/prop/server_equipment/laptop/closed
	icon_state = "laptop_closed"

/obj/structure/prop/server_equipment/laptop/on
	icon_state = "laptop_on"
	desc = "The screen is stuck on some sort of boot-loop in terrible garish green. All the text is in Rusoek, a creole language spawned out of the borders of UA and UPP space from some Korean settlements."

//biomass turbine

/obj/structure/prop/turbine //maybe turn this into an actual power generation device? Would be cool!
	name = "power turbine"
	icon = 'icons/obj/structures/props/industrial/biomass_turbine.dmi'
	icon_state = "biomass_turbine"
	desc = "A gigantic turbine that runs on god knows what. It could probably be turned on by someone with the correct know-how."
	density = TRUE
	breakable = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE
	var/on = FALSE
	bound_width = 32
	bound_height = 96

/obj/structure/prop/turbine/attackby(obj/item/W, mob/user)
	. = ..()
	if(isxeno(user))
		return
	else if (ishuman(user) && HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		on = !on
		visible_message("You pry at the control valve on [src]. The machine shudders." , "[user] pries at the control valve on [src]. The entire machine shudders.")

		Update()

/obj/structure/prop/turbine/proc/Update()
	icon_state = "biomass_turbine[on ? "-on" : ""]"
	if (on)
		set_light(3)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		set_light(0)
		playsound(src, 'sound/machines/turbine_off.ogg')
	return

/obj/structure/prop/turbine/ex_act(severity, direction)
	return

/obj/structure/prop/turbine_extras
	name = "power turbine struts"
	icon = 'icons/obj/structures/props/industrial/biomass_turbine.dmi'
	icon_state = "support_struts_r"
	desc = "Pipes, or maybe support struts that lead into, or perhaps support that big ol' turbine."
	density = FALSE
	breakable = FALSE
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/turbine_extras/border
	name = "power turbine warning stripes"
	icon_state = "biomass_turbine_border"
	desc = "Warning markers. Keep a safe distance, high voltage!"
	layer = 2.5

/obj/structure/prop/turbine_extras/left
	name = "power turbine struts"
	icon_state = "support_struts_l"

/obj/structure/prop/turbine_extras/ex_act(severity, direction)
	return

//power transformer

/obj/structure/prop/power_transformer
	name = "power transformer"
	icon = 'icons/obj/structures/props/industrial/power_transformer.dmi'
	icon_state = "transformer"
	bound_width = 64
	bound_height = 64
	desc = "A passive electrical component that controls where and which circuits power flows into."

//cash registers

/obj/structure/prop/cash_register
	name = "digital cash register"
	desc = "A Seegson brand point of sales system that accepts credit chits... and cash assuming it is operated. Rumor has it these use the same logic board as Seegson Working Joes. You are becoming financially unstable."
	icon = 'icons/obj/structures/props/cash_register.dmi'
	icon_state = "cash_register"
	density = TRUE
	health = 50

/obj/structure/prop/cash_register/open
	icon_state = "cash_register_open"

/obj/structure/prop/cash_register/broken
	icon_state = "cash_register_broken"

/obj/structure/prop/cash_register/broken/open
	icon_state = "cash_register_broken_open"

/obj/structure/prop/cash_register/off
	icon_state = "cash_register_off"

/obj/structure/prop/cash_register/off/open
	icon_state = "cash_register_off_open"

/obj/structure/prop/structure_lattice //instance me by direction for color variants
	name = "structural lattice"
	desc = "Like rebar, but in space."
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "structure_lattice"
	density = TRUE //impassable by default

/obj/structure/prop/resin_prop
	name = "resin coated object"
	desc = "Well, it's useless now."
	icon = 'icons/obj/resin_objects.dmi'
	icon_state = "watertank"

//industructible props
/obj/structure/prop/invuln
	name = "instanceable object"
	desc = "this needs to be defined by a coder"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "structure_lattice"
	explo_proof = TRUE
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/invuln/ex_act(severity, direction)
	return

/obj/structure/prop/invuln/static_corpse

/obj/structure/prop/invuln/static_corpse/afric_zimmer
	name = "Maj. Afric Zimmerman"
	desc = "What remains of Maj. Afric Zimmerman. Their entire head is missing. Someone shed a tear."
	icon = 'icons/obj/structures/props/64x64.dmi'
	icon_state = "afric_zimmerman"
	density = FALSE

/obj/structure/prop/invuln/lifeboat_hatch_placeholder
	density = FALSE
	name = "non-functional hatch"
	desc = "You'll need more than a prybar for this one."
	icon = 'icons/obj/structures/machinery/bolt_target.dmi'
	icon_state = "closed"

/obj/structure/prop/invuln/lifeboat_hatch_placeholder/terminal
	icon = 'icons/obj/structures/machinery/bolt_terminal.dmi'
	icon_state = "closed"

/obj/structure/prop/invuln/dropship_parts //for TG shuttle system
	density = TRUE

/obj/structure/prop/invuln/dropship_parts/beforeShuttleMove() //moves content but leaves the turf behind (for cool space turf)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS
		. &= ~MOVE_TURF

/obj/structure/prop/invuln/dropship_parts/lifeboat
	name = "Lifeboat"
	icon_state = ""
	icon = 'icons/turf/lifeboat.dmi'

#define STATE_COMPLETE 0
#define STATE_FUEL 1
#define STATE_IGNITE 2

/obj/structure/prop/brazier
	name = "brazier"
	desc = "The fire inside the brazier emits a relatively dim glow to flashlights and flares, but nothing can replace the feeling of sitting next to a fireplace with your friends."
	icon = 'icons/obj/structures/bonfire.dmi'
	icon_state = "brazier"
	density = TRUE
	health = 150
	light_range = 6
	light_on = TRUE
	/// What obj this becomes when it gets to its next stage of construction / ignition
	var/frame_type
	/// What is used to progress to the next stage
	var/state = STATE_COMPLETE

/obj/structure/prop/brazier/Initialize()
	. = ..()

	if(!light_on)
		set_light(0)

/obj/structure/prop/brazier/get_examine_text(mob/user)
	. = ..()
	switch(state)
		if(STATE_FUEL)
			. += "[src] requires wood to be fueled."
		if(STATE_IGNITE)
			. += "[src] needs to be lit."

/obj/structure/prop/brazier/attackby(obj/item/hit_item, mob/user)
	switch(state)
		if(STATE_COMPLETE)
			return ..()
		if(STATE_FUEL)
			if(!istype(hit_item, /obj/item/stack/sheet/wood))
				return ..()
			var/obj/item/stack/sheet/wood/wooden_boards = hit_item
			if(!wooden_boards.use(5))
				to_chat(user, SPAN_WARNING("Not enough wood!"))
				return
			user.visible_message(SPAN_NOTICE("[user] fills [src] with [hit_item]."))
		if(STATE_IGNITE)
			if(!hit_item.heat_source)
				return ..()
			if(!do_after(user, 3 SECONDS, INTERRUPT_MOVED, BUSY_ICON_BUILD))
				return
			user.visible_message(SPAN_NOTICE("[user] ignites [src] with [hit_item]."))

	new frame_type(loc)
	qdel(src)

/obj/structure/prop/brazier/frame
	name = "empty brazier"
	desc = "An empty brazier."
	icon_state = "brazier_frame"
	light_on = FALSE
	frame_type = /obj/structure/prop/brazier/frame/full
	state = STATE_FUEL

/obj/structure/prop/brazier/frame/full
	name = "empty full brazier"
	desc = "An empty brazier. Yet it's also full. What???  Use something hot to ignite it, like a welding tool."
	icon_state = "brazier_frame_filled"
	frame_type = /obj/structure/prop/brazier
	state = STATE_IGNITE

/obj/structure/prop/brazier/torch
	name = "torch"
	desc = "It's a torch."
	icon_state = "torch"
	density = FALSE
	light_range = 5

/obj/structure/prop/brazier/frame/full/torch
	name = "unlit torch"
	desc = "It's a torch, but it's not lit.  Use something hot to ignite it, like a welding tool."
	icon_state = "torch_frame"
	frame_type = /obj/structure/prop/brazier/torch

/obj/item/prop/torch_frame
	name = "unlit torch"
	icon = 'icons/obj/structures/bonfire.dmi'
	desc = "It's a torch, but it's not lit or placed down. Click on a wall to place it."
	icon_state = "torch_frame"

/obj/structure/prop/brazier/frame/full/campfire
	name = "unlit campfire"
	desc = "A circle of stones surrounding a pile of wood. If only you were to light it."
	icon_state = "campfire"
	frame_type = /obj/structure/prop/brazier/campfire
	density = FALSE

/obj/structure/prop/brazier/frame/full/campfire/smolder
	name = "smoldering campfire"
	desc = "A campfire that used to be lit, but was extinguished. You can still see the embers, and smoke rises from it."
	state = STATE_FUEL
	frame_type = /obj/structure/prop/brazier/frame/full/campfire

/obj/structure/prop/brazier/campfire
	name = "campfire"
	desc = "A circle of stones surrounding a burning pile of wood. The fire is roaring and you can hear its crackle. You could probably stomp the fire out."
	icon = 'icons/obj/structures/bonfire.dmi'
	icon_state = "campfire_on"
	density = FALSE
	///How many tiles the heating and sound goes
	var/heating_range = 2
	/// time between sounds
	var/time_to_sound = 20
	/// Time for it to burn through fuel
	var/fuel_stage_time = 1 MINUTES
	/// How much fuel it has
	var/remaining_fuel = 5 //Maxes at 5, but burns one when made
	/// If the fire can be manually put out
	var/extinguishable = TRUE
	/// Make no noise
	var/quiet = FALSE

/obj/structure/prop/brazier/campfire/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	fuel_drain(TRUE)

/obj/structure/prop/brazier/campfire/get_examine_text(mob/user)
	. = ..()
	switch(remaining_fuel)
		if(4 to INFINITY)
			. += "The fire is roaring."
		if(2 to 3)
			. += "The fire is burning warm."
		if(-INFINITY to 1)
			. += "The embers of the fire barely burns."

/obj/structure/prop/brazier/campfire/process(delta_time)
	if(!isturf(loc))
		return

	for(var/mob/living/carbon/human/mob in range(heating_range, src))
		if(mob.bodytemperature < T20C)
			mob.bodytemperature += min(floor(T20C - mob.bodytemperature)*0.7, 25)
			mob.recalculate_move_delay = TRUE

	if(quiet)
		return
	time_to_sound -= delta_time
	if(time_to_sound <= 0)
		playsound(loc, 'sound/machines/firepit_ambience.ogg', 15, FALSE, heating_range)
		time_to_sound = initial(time_to_sound)

/obj/structure/prop/brazier/campfire/attack_hand(mob/user)
	. = ..()
	if(!extinguishable)
		to_chat(user, SPAN_WARNING("You cannot extinguish [src]."))
		return
	to_chat(user, SPAN_NOTICE("You begin to extinguish [src]."))
	while(remaining_fuel)
		if(user.action_busy || !do_after(user, 3 SECONDS, INTERRUPT_MOVED, BUSY_ICON_BUILD))
			return
		fuel_drain()
		to_chat(user, SPAN_NOTICE("You continue to extinguish [src]."))
	visible_message(SPAN_NOTICE("[user] extinguishes [src]."))

/obj/structure/prop/brazier/campfire/attackby(obj/item/attacking_item, mob/user)
	if(!istype(attacking_item, /obj/item/stack/sheet/wood))
		to_chat(user, SPAN_NOTICE("You cannot fuel [src] with [attacking_item]."))
		return
	var/obj/item/stack/sheet/wood/fuel = attacking_item
	if(remaining_fuel >= initial(remaining_fuel))
		to_chat(user, SPAN_NOTICE("You cannot fuel [src] further."))
		return
	if(!fuel.use(1))
		to_chat(user, SPAN_NOTICE("You do not have enough [attacking_item] to fuel [src]."))
		return
	visible_message(SPAN_NOTICE("[user] fuels [src] with [fuel]."))
	remaining_fuel++

/obj/structure/prop/brazier/campfire/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(!extinguishable)
		to_chat(xeno, SPAN_WARNING("You cannot extinguish [src]."))
		return
	to_chat(xeno, SPAN_NOTICE("You begin to extinguish [src]."))
	while(remaining_fuel)
		if(xeno.action_busy || !do_after(xeno, 1 SECONDS, INTERRUPT_MOVED, BUSY_ICON_HOSTILE))
			return
		fuel_drain()
		to_chat(xeno, SPAN_NOTICE("You continue to extinguish [src]."))
	visible_message(SPAN_WARNING("[xeno] extinguishes [src]!"))

/obj/structure/prop/brazier/campfire/proc/fuel_drain(looping)
	remaining_fuel--
	if(!remaining_fuel)
		new /obj/structure/prop/brazier/frame/full/campfire/smolder(loc)
		qdel(src)
		return
	if(!looping || !fuel_stage_time)
		return
	addtimer(CALLBACK(src, PROC_REF(fuel_drain), TRUE), fuel_stage_time)

/obj/structure/prop/brazier/campfire/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

#undef STATE_COMPLETE
#undef STATE_FUEL
#undef STATE_IGNITE

//ICE COLONY PROPS
//Thematically look to Blackmesa's Xen levels. Generic science-y props n' stuff.

/obj/structure/prop/ice_colony
	name = "prop"
	desc = "Call a coder (or a mapper) you shouldn't be seeing this!"
	icon = 'icons/obj/structures/props/ice_colony/props.dmi'
	projectile_coverage = 10

/obj/structure/prop/ice_colony/soil_net
	name = "soil net"
	desc = "Scientists use these suspended nets to superimpose a grid over a patch of ground for study."
	icon_state = "soil_grid"

/obj/structure/prop/ice_colony/ice_crystal
	name = "ice crystal"
	desc = "It is a giant crystal of ice. The chemical process that keeps it frozen despite major seasonal temperature flux is what the United American Greater Argentinian science team is studying here on the Snowball."
	icon_state = "ice_crystal"

/obj/structure/prop/ice_colony/ground_wire
	name = "ground wire"
	desc = "A small string of black wire hangs between two marker posts. Probably used to mark off an area."
	icon_state = "small_wire"

/obj/structure/prop/ice_colony/poly_kevlon_roll
	name = "plastic roll"
	desc = "A big roll of poly-kevlon plastic used in temporary shelter construction."
	icon_state = "kevlon_roll"
	anchored = FALSE

/obj/structure/prop/ice_colony/surveying_device
	name = "surveying device"
	desc = "A small laser measuring tool and camera mounted on a tripod. Comes in a stark safety yellow."
	icon_state = "surveying_device"
	anchored = FALSE

/obj/structure/prop/ice_colony/surveying_device/measuring_device
	name = "measuring device"
	desc = "Some sort of doohickey that measures stuff."
	icon_state = "measuring_device"

/obj/structure/prop/ice_colony/dense
	health = 75
	density = TRUE

/obj/structure/prop/ice_colony/dense/attack_alien(mob/living/carbon/xenomorph/xeno)
	if(xeno.a_intent == INTENT_HARM)
		if(unslashable)
			return
		xeno.animation_attack_on(src)
		playsound(loc, 'sound/effects/metalhit.ogg', 25, 1)
		xeno.visible_message(SPAN_DANGER("[xeno] slices [src] apart!"),
		SPAN_DANGER("We slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
		deconstruct(FALSE)
		return XENO_ATTACK_ACTION
	else
		attack_hand(xeno)
		return XENO_NONCOMBAT_ACTION

/obj/structure/prop/ice_colony/dense/ice_tray
	name = "ice slab tray"
	icon_state = "ice_tray"
	desc = "It is a tray filled with slabs of dark ice."

/obj/structure/prop/ice_colony/dense/planter_box
	icon_state = "planter_box_soil"
	name = "grow box"
	desc = "A root lattice is half buried inside the grow box."

/obj/structure/prop/ice_colony/dense/planter_box/hydro
	icon_state = "hydro_tray"
	name = "hydroponics lattice"
	desc = "A root lattice connected to two floating pontoons."

/obj/structure/prop/ice_colony/dense/planter_box/plated
	icon_state = "planter_box_empty"
	name = "plated grow box"
	desc = "The planter box is empty."

/obj/structure/prop/ice_colony/flamingo
	density = FALSE
	name = "lawn flamingo"
	desc = "For ornamenting your suburban lawn... or your ice colony."
	icon_state = "flamingo"

/obj/structure/prop/ice_colony/flamingo/festive
	name = "festive lawn flamingo"
	desc = "For ornamenting your suburban lawn... or your ice colony during the festive season. Not that anyone has an Earth calendar out here."
	icon_state = "flamingo_santa"

/obj/structure/prop/ice_colony/hula_girl //todo, animate based on dropship movement -Monkey
	name = "hula girl"
	desc = "Apparently at one point, Hawaii had beaches."
	icon = 'icons/obj/structures/props/ice_colony/Hula.dmi'
	icon_state = "Hula_Gal"

/obj/structure/prop/ice_colony/tiger_rug
	name = "tiger rug"
	desc = "A rather tasteless but impressive tiger rug. Must've costed a fortune to get this exported to the rim."
	icon = 'icons/obj/structures/props/ice_colony/Tiger_Rugs.dmi'
	icon_state = "Bengal" //instanceable, lots of variants!

//HOLIDAY THEMED BULLSHIT

/obj/structure/prop/holidays
	projectile_coverage = 0
	density = FALSE
	icon = 'icons/obj/structures/props/holiday_props.dmi'
	desc = "parent object for temporary holiday structures. If you are reading this, go find a mapper and tell them to search up error code: TOO MUCH EGGNOG"//hello future mapper. Next time use the sub types or instance the desc. Thanks -past mapper.
	layer = 4
	health = 50
	anchored = TRUE

/obj/structure/prop/holidays/string_lights
	name = "M1 pattern festive bulb strings"
	desc = "Strung from strut to strut, these standard issue M1 pattern 'festive bulb strings' flicker and shimmer to the tune of the output frequency of the Almayer's Engine... or the local power grid. Might want to ask the Bravo's to check which one it is for ya. Ya damn jarhead."
	icon_state = "string_lights"


/obj/structure/prop/holidays/string_lights/corner
	icon_state = "strings_lights_corner"

/obj/structure/prop/holidays/string_lights/cap
	icon_state = "string_lights_cap"

/obj/structure/prop/holidays/wreath
	name = "M1 pattern festive needle torus"
	desc = "In 2140 after a two different sub levels of the São Luís Bay Underground Habitat burned out (evidence points to a Bladerunner incident, but local police denies such claims) due to actual wreaths made with REAL needles, these have been issued ever since. They're made of ''''''pine'''''' scented poly-kevlon. According to the grunts from the American Corridor, during the SACO riots, protestors would pack these things into pillow cases, forming rudimentary body armor against soft point ballistics."
	icon_state = "wreath"
/obj/structure/prop/vehicles
	name = "van"
	desc = "An old van, seems to be broken down."
	icon = 'icons/obj/structures/props/vehicles/vehicles.dmi'
	icon_state = "van"
	bound_height = 64
	bound_width = 64
	unslashable = FALSE
	unacidable = FALSE

/obj/structure/prop/vehicles/crawler
	name = "colony crawler"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by Orbital Blue International; 'Your friends, in the Aerospace business.' A subsidiary of Weyland Yutani."
	icon_state = "crawler"
	density = TRUE

/obj/structure/prop/vehicles/tank/twe
	name = "\improper FV150 Shobo MKII"
	desc = "The FV150 Shobo MKII is a Combat Reconnaissance Vehicle Tracked, abbreviated to CVR(T) in official documentation. It was co-developed in 2175 by Weyland-Yutani and Gallar Co., a Titan based heavy vehicle manufacturer. Taking into account lessons learned from the MkI's performance in the Australian Wars, major structual changes were made, and the MKII went into production in 2178. It is armed with a twin 30mm cannon and a L56A2 10x28mm coaxial, complimented by its ammunition stores of 170 rounds of 30mm and 1600 rounds of 10x28mm. The maximum speed of the Shobo is 60 mph, but on a standard deployment after the ammo stores are fully loaded and the terrain is taken into account, it consistently sits at 55mph."
	icon = 'icons/obj/vehicles/twe_tank.dmi'
	icon_state = "twe_tank"
	density = TRUE

//overhead prop sets

/obj/structure/prop/invuln/overhead
	layer = ABOVE_FLY_LAYER
	icon = 'icons/obj/structures/props/industrial/overhead_ducting.dmi'
	icon_state = "flammable_pipe_1"

/obj/structure/prop/invuln/overhead/flammable_pipe
	name = "dense fuel line"
	desc = "Likely to be incredibly flammable."
	density = TRUE

/obj/structure/prop/invuln/overhead/flammable_pipe/fly
	density = FALSE


/obj/structure/prop/static_tank
	name = "liquid tank"
	desc = "Warning, contents under pressure!"
	icon = 'icons/obj/structures/props/industrial/generic_props.dmi'
	icon_state = "tank"
	density = TRUE

/obj/structure/prop/static_tank/fuel
	desc = "It contains Decatuxole-Hypospaldirol. A non-volatile liquid fuel type that tastes like oranges. Can't really be used for anything outside of atmos-rocket boosters."
	icon_state = "weldtank_old"

/obj/structure/prop/static_tank/water
	desc = "It contains non-potable water. A label on the side instructs you to boil before consumption. It smells vaguely like the showers on the Almayer."
	icon_state = "watertank_old"

/obj/structure/prop/broken_arcade
	desc = "You can't see anything behind the screen, it looks half human and half machine."
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "arcadeb"
	name = "Spirit Phone, The Game, The Movie: II"

//INVULNERABLE PROPS

/obj/structure/prop/invuln
	layer = ABOVE_MOB_LAYER
	density = TRUE
	icon = 'icons/obj/structures/props/ice_colony/props.dmi'
	icon_state = "ice_tray"

/obj/structure/prop/invuln/catwalk_support
	name = "support lattice"
	icon_state = "support_lattice"
	desc = "The middle of a large set of steel support girders."
	density = FALSE

/obj/structure/prop/invuln/minecart_tracks
	name = "rails"
	icon_state = "rail"
	icon = 'icons/obj/structures/props/mining.dmi'
	density =  0
	desc = "Minecarts and rail vehicles go on these."
	layer = 3

/obj/structure/prop/invuln/minecart_tracks/bumper
	name = "rail bumpers"
	icon_state = "rail_bumpers"
	desc = "This (usually) stops minecarts and other rail vehicles at the end of a line of track."

/obj/structure/prop/invuln/dense
	density = TRUE

/obj/structure/prop/invuln/dense/catwalk_support
	name = "support lattice"
	icon_state = "support_lattice"
	desc = "The base of a large set of steel support girders."

/obj/structure/prop/invuln/dense/ice_tray
	name = "ice slab tray"
	icon_state = "ice_tray"
	desc = "It is a tray filled with slabs of dark ice."

/obj/structure/prop/invuln/ice_prefab
	name = "prefabricated structure"
	desc = "This structure is made of metal support rods and robust poly-kevlon plastics. A derivative of the stuff used in UA ballistics vests, USCM and UPP uniforms. The loose walls roll with each gust of wind."
	icon = 'icons/obj/structures/props/ice_colony/fabs_tileset.dmi'
	icon_state = "fab"
	density = TRUE
	layer = 3
	bound_width = 32
	bound_height = 32

/obj/structure/prop/invuln/ice_prefab/trim
	layer = ABOVE_MOB_LAYER
	density = FALSE

/obj/structure/prop/invuln/ice_prefab/roof_greeble
	icon = 'icons/obj/structures/props/ice_colony/fabs_greebles.dmi'
	icon_state = "antenna"
	layer = ABOVE_MOB_LAYER
	desc = "Windsocks, Air-Con units, solarpanels, oh my!"
	density = FALSE


/obj/structure/prop/invuln/ice_prefab/standalone
	density = TRUE
	icon = 'icons/obj/structures/props/ice_colony/fabs_64.dmi'
	icon_state = "orange"//instance icons
	layer = 3
	bound_width = 64
	bound_height = 64

/obj/structure/prop/invuln/ice_prefab/standalone/trim
	icon_state = "orange_trim"//instance icons
	layer = ABOVE_MOB_LAYER
	density = FALSE

/obj/structure/prop/invuln/remote_console_pod
	name = "Remote Console Pod"
	desc = "A drop pod used to launch remote piloting equipment to USCM areas of operation"
	icon = 'icons/obj/structures/droppod_32x64.dmi'
	icon_state = "techpod_open"
	layer = DOOR_CLOSED_LAYER

/obj/structure/prop/invuln/overhead_pipe
	name = "overhead pipe segment"
	desc = ""
	icon = 'icons/obj/pipes/pipes.dmi'
	icon_state = "intact-scrubbers"
	projectile_coverage = 0
	density = FALSE
	layer = RIPPLE_LAYER

/obj/structure/prop/invuln/overhead_pipe/Initialize(mapload)
	. = ..()
	desc = "This is a section of the pipe network that carries water (and less pleasant fluids) throughout the [is_mainship_level(z) ? copytext(MAIN_SHIP_NAME, 5) : "colony"]."

///Decorative fire.
/obj/structure/prop/invuln/fire
	name = "fire"
	desc = "That isn't going out any time soon."
	color = "#FF7700"
	icon = 'icons/effects/fire.dmi'
	icon_state = "dynamic_2"
	layer = MOB_LAYER
	light_range = 3
	light_on = TRUE

/obj/structure/prop/invuln/fusion_reactor
	name = "\improper S-52 fusion reactor"
	desc = "A Westingland S-52 Fusion Reactor.  Takes fuels cells and converts them to power.  Also produces a large amount of heat."
	icon = 'icons/obj/structures/machinery/fusion_eng.dmi'
	icon_state = "off"

/obj/structure/prop/invuln/pipe_water
	name = "pipe water"
	desc = ""
	icon = 'icons/obj/structures/props/watercloset.dmi'
	icon_state = "water"
	density = 0

/obj/structure/prop/invuln/pipe_water/Initialize(mapload)
	. = ..()
	desc = "The [is_mainship_level(z) ? copytext(MAIN_SHIP_NAME, 5) : "colony"] has sprung a leak!"

/obj/structure/prop/invuln/lattice_prop
	desc = "A lightweight support lattice."
	name = "lattice"
	icon = 'icons/obj/structures/props/smoothlattice.dmi'
	icon_state = "lattice0"
	density = FALSE
	layer = RIPPLE_LAYER

/obj/structure/prop/wooden_cross
	name = "wooden cross"
	desc = "A wooden grave marker. Is it more respectful because someone made it by hand, or less, because it's crude and misshapen?"
	icon = 'icons/obj/structures/props/furniture/crosses.dmi'
	icon_state = "cross1"
	density = FALSE
	health = 30
	var/inscription
	var/obj/item/helmet
	///This is for cross dogtags.
	var/tagged = FALSE
	///This is for cross engraving/writing.
	var/engraved = FALSE
	var/dogtag_name
	var/dogtag_blood
	var/dogtag_assign

/obj/structure/prop/wooden_cross/Destroy()
	if(helmet)
		helmet.forceMove(loc)
		helmet = null
	if(tagged)
		var/obj/item/dogtag/new_info_tag = new(loc)
		new_info_tag.fallen_names = list(dogtag_name)
		new_info_tag.fallen_assgns = list(dogtag_assign)
		new_info_tag.fallen_blood_types = list(dogtag_blood)
	return ..()

/obj/structure/prop/wooden_cross/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/dogtag))
		var/obj/item/dogtag/dog = W
		if(!tagged)
			tagged = TRUE
			user.visible_message(SPAN_NOTICE("[user] drapes [W] around [src]."))
			dogtag_name = popleft(dog.fallen_names)
			dogtag_assign = popleft(dog.fallen_assgns)
			dogtag_blood = popleft(dog.fallen_blood_types)
			if(!(dogtag_name in GLOB.fallen_list_cross))
				GLOB.fallen_list_cross += dogtag_name
			update_icon()
			if(!length(dog.fallen_names))
				qdel(dog)
			else
				return
		else
			to_chat(user, SPAN_WARNING("There's already a dog tag on [src]!"))
			balloon_alert(user, "already a tag here!")

	if(istype(W, /obj/item/clothing/head))
		if(helmet)
			to_chat(user, SPAN_WARNING("[helmet] is already resting atop [src]!"))
			return
		if(!user.drop_inv_item_to_loc(W, src))
			return
		helmet = W
		dir = SOUTH
		var/image/visual_overlay = W.get_mob_overlay(null, WEAR_HEAD)
		visual_overlay.pixel_y = -10 //Base image is positioned to go on a human's head.
		overlays += visual_overlay
		to_chat(user, SPAN_NOTICE("You set \the [W] atop \the [src]."))
		return

	if(user.a_intent == INTENT_HARM)
		. = ..()
		if(W.force && !(W.flags_item & NOBLUDGEON))
			playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
			update_health(W.force)
		return

	if(W.sharp || W.edge || HAS_TRAIT(W, TRAIT_TOOL_PEN) || istype(W, /obj/item/tool/hand_labeler))
		var/action_msg
		var/time_multiplier
		if(W.sharp || W.edge)
			action_msg = "carve something into"
			time_multiplier = 3
		else
			action_msg = "write something on"
			time_multiplier = 2

		var/message = sanitize(input(user, "What do you write on [src]?", "Inscription"))
		if(!message)
			return
		user.visible_message(SPAN_NOTICE("[user] begins to [action_msg] [src]."),
			SPAN_NOTICE("You begin to [action_msg] [src]."), null, 4)

		if(!do_after(user, length(message) * time_multiplier, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interrupted!"))
		else
			user.visible_message(SPAN_NOTICE("[user] uses \his [W.name] to [action_msg] [src]."),
				SPAN_NOTICE("You [action_msg] [src] with your [W.name]."), null, 4)
			if(inscription)
				inscription += "\n[message]"
			else
				inscription = message
				engraved = TRUE

/obj/structure/prop/wooden_cross/get_examine_text(mob/user)
	. = ..()
	. += (tagged ? "There's a dog tag draped around the cross. The dog tag reads, \"[dogtag_name] - [dogtag_assign] - [dogtag_blood]\"." : "There's no dog tag draped around the cross.")
	. += (engraved ? "There's something carved into it. It reads: \"[inscription]\"" : "There's nothing carved into it.")

/obj/structure/prop/wooden_cross/attack_hand(mob/user)
	if(helmet)
		helmet.forceMove(loc)
		user.put_in_hands(helmet)
		to_chat(user, SPAN_NOTICE("You lift \the [helmet] off of \the [src]."))
		helmet = null
		overlays.Cut()

/obj/structure/prop/wooden_cross/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	update_health(rand(M.melee_damage_lower, M.melee_damage_upper))
	playsound(src, 'sound/effects/woodhit.ogg', 25, 1)
	if(health <= 0)
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"),
		SPAN_DANGER("You slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		M.visible_message(SPAN_DANGER("[M] slashes [src]!"),
		SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/prop/wooden_cross/update_icon()
	if(tagged)
		overlays += mutable_appearance('icons/obj/structures/props/furniture/crosses.dmi', "cross_overlay")


/obj/structure/prop/invuln/rope
	name = "rope"
	desc = "A secure rope looks like someone might've been hiding out on those rocks."
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	icon_state = "rope"
	density = FALSE

/obj/structure/prop/pred_flight
	name = "hunter flight console"
	desc = "A console designed by the Hunters to assist in flight pathing and navigation."
	icon = 'icons/obj/structures/machinery/yautja_machines.dmi'
	icon_state = "overwatch"
	density = TRUE

/obj/structure/prop/invuln/joey
	name = "Workin' Joey"
	desc = "A defunct Seegson-brand Working Joe lifted from deep storage by a crew of marines after the last shore leave. Attempts have been made to modify the janitorial synthetic to serve as a crude bartender, but with little success."
	icon = 'icons/obj/structures/props/props.dmi'
	icon_state = "joey"
	unslashable = FALSE
	wrenchable = FALSE
	/// converted into minutes when used to determine cooldown timer between quips
	var/quip_delay_minimum = 5
	/// delay between Quips. Slightly randomized with quip_delay_minimum plus a random number
	COOLDOWN_DECLARE(quip_delay)
	/// delay between attack voicelines. Short but done for anti-spam
	COOLDOWN_DECLARE(damage_delay)
	/// list of quip emotes, taken from Working Joe
	var/static/list/quips = list(
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/alwaysknow_damaged,
		/datum/emote/living/carbon/human/synthetic/working_joe/quip/not_liking,
		/datum/emote/living/carbon/human/synthetic/working_joe/greeting/how_can_i_help,
		/datum/emote/living/carbon/human/synthetic/working_joe/farewell/day_never_done,
		/datum/emote/living/carbon/human/synthetic/working_joe/farewell/required_by_apollo,
		/datum/emote/living/carbon/human/synthetic/working_joe/warning/safety_breach
	)
	/// list of voicelines to use when damaged
	var/static/list/damaged = list(
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/damage,
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/that_stings,
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/irresponsible,
		/datum/emote/living/carbon/human/synthetic/working_joe/damage/this_is_futile,
		/datum/emote/living/carbon/human/synthetic/working_joe/warning/hysterical,
		/datum/emote/living/carbon/human/synthetic/working_joe/warning/patience
	)

/obj/structure/prop/invuln/joey/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/prop/invuln/joey/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/prop/invuln/joey/process()
	//check if quip_delay cooldown finished. If so, random chance it says a line
	if(COOLDOWN_FINISHED(src, quip_delay) && prob(10))
		emote(pick(quips))
		var/delay = rand(3) + quip_delay_minimum
		COOLDOWN_START(src, quip_delay, delay MINUTES)

// Advert your eyes.
/obj/structure/prop/invuln/joey/attackby(obj/item/W, mob/user)
	attacked()
	return ..()

/obj/structure/prop/invuln/joey/bullet_act(obj/projectile/P)
	attacked()
	return ..()

/// A terrible way of handling being hit. If signals would work it should be used.
/obj/structure/prop/invuln/joey/proc/attacked()
	if(COOLDOWN_FINISHED(src, damage_delay) && prob(25))
		emote(pick(damaged))
		COOLDOWN_START(src, damage_delay, 8 SECONDS)

/// SAY THE LINE JOE
/obj/structure/prop/invuln/joey/proc/emote(datum/emote/living/carbon/human/synthetic/working_joe/emote)
	if (!emote)
		return FALSE

	for(var/mob/mob in hearers(src, null))
		mob.show_message("<span class='game say'><span class='name'>[src]</span> says, \"[initial(emote.say_message)]\"</span>", SHOW_MESSAGE_AUDIBLE)

	var/list/viewers = get_mobs_in_view(7, src)
	for(var/mob/current_mob in viewers)
		if(!(current_mob.client?.prefs.toggles_langchat & LANGCHAT_SEE_EMOTES))
			viewers -= current_mob
	langchat_speech(initial(emote.say_message), viewers, GLOB.all_languages, skip_language_check = TRUE)

	if(initial(emote.sound))
		playsound(loc, initial(emote.sound), 50, FALSE)
	return TRUE
