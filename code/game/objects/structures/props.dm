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
	icon = 'icons/obj/structures/props/drill.dmi'
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
	icon = 'icons/obj/structures/props/vehicles.dmi'
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
	icon = 'icons/obj/structures/props/vehicles.dmi'
	icon_state = "van"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/dam/van/damaged
	icon_state = "van_damaged"

/obj/structure/prop/dam/crane
	name = "cargo crane"
	icon = 'icons/obj/structures/props/vehicles.dmi'
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
	icon = 'icons/obj/structures/props/torii.dmi'
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
	icon = 'icons/obj/structures/props/dam.dmi'
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/dam/boulder/boulder1
	icon_state = "boulder1"
/obj/structure/prop/dam/boulder/boulder2
	icon_state = "boulder2"
/obj/structure/prop/dam/boulder/boulder3
	icon_state = "boulder3"


/obj/structure/prop/dam/large_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_large.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/dam/large_boulder/boulder1
	icon_state = "boulder_large1"
/obj/structure/prop/dam/large_boulder/boulder2
	icon_state = "boulder_large2"

/obj/structure/prop/dam/wide_boulder
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_wide.dmi'
	bound_height = 32
	bound_width = 64

/obj/structure/prop/dam/wide_boulder/boulder1
	icon_state = "boulder1"


/obj/structure/prop/mech
	icon = 'icons/obj/structures/props/mech.dmi'

/obj/structure/prop/mech/hydralic_clamp
	name = "Hydraulic Clamp"
	icon_state = "mecha_clamp"

/obj/structure/prop/mech/drill
	name = "Drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mecha_drill"

/obj/structure/prop/mech/armor_booster
	name = "Armor Booster Module (Close Combat Weaponry)"
	desc = "Boosts exosuit armor against armed melee attacks. Requires energy to operate."
	icon_state = "mecha_abooster_ccw"

/obj/structure/prop/mech/repair_droid
	name = "Repair Droid"
	desc = "Automated repair droid. Scans exosuit for damage and repairs it. Can fix almost all types of external or internal damage."
	icon_state = "repair_droid"

/obj/structure/prop/mech/tesla_energy_relay
	name = "Energy Relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low."
	icon_state = "tesla"

/obj/structure/prop/mech/mech_parts
	name = "mecha part"
	flags_atom = FPRINT|CONDUCT

/obj/structure/prop/mech/mech_parts/chassis
	name="Mecha Chassis"
	icon_state = "backbone"

/obj/structure/prop/mech/mech_parts/chassis/ripley
	name = "Ripley Chassis"
	icon_state = "ripley_chassis"

/obj/structure/prop/mech/mech_parts/part/ripley_torso
	name="Ripley Torso"
	desc="A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"

/obj/structure/prop/mech/mech_parts/part/ripley_left_arm
	name="Ripley Left Arm"
	desc="A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"

/obj/structure/prop/mech/mech_parts/part/ripley_right_arm
	name="Ripley Right Arm"
	desc="A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"

/obj/structure/prop/mech/mech_parts/part/ripley_left_leg
	name="Ripley Left Leg"
	desc="A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"

/obj/structure/prop/mech/mech_parts/part/ripley_right_leg
	name="Ripley Right Leg"
	desc="A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"

/obj/structure/prop/mech/mech_parts/chassis/gygax
	name = "Gygax Chassis"
	icon_state = "gygax_chassis"

/obj/structure/prop/mech/mech_parts/part/gygax_torso
	name="Gygax Torso"
	desc="A torso part of Gygax. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"

/obj/structure/prop/mech/mech_parts/part/gygax_head
	name="Gygax Head"
	desc="A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"

/obj/structure/prop/mech/mech_parts/part/gygax_left_arm
	name="Gygax Left Arm"
	desc="A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"

/obj/structure/prop/mech/mech_parts/part/gygax_right_arm
	name="Gygax Right Arm"
	desc="A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"

/obj/structure/prop/mech/mech_parts/part/gygax_left_leg
	name="Gygax Left Leg"
	icon_state = "gygax_l_leg"

/obj/structure/prop/mech/mech_parts/part/gygax_right_leg
	name="Gygax Right Leg"
	icon_state = "gygax_r_leg"

/obj/structure/prop/mech/mech_parts/part/gygax_armor
	name="Gygax Armor Plates"
	icon_state = "gygax_armor"

/obj/structure/prop/mech/mech_parts/chassis/durand
	name = "Durand Chassis"
	icon_state = "durand_chassis"

/obj/structure/prop/mech/mech_parts/part/durand_torso
	name="Durand Torso"
	icon_state = "durand_harness"

/obj/structure/prop/mech/mech_parts/part/durand_head
	name="Durand Head"
	icon_state = "durand_head"

/obj/structure/prop/mech/mech_parts/part/durand_left_arm
	name="Durand Left Arm"
	icon_state = "durand_l_arm"

/obj/structure/prop/mech/mech_parts/part/durand_right_arm
	name="Durand Right Arm"
	icon_state = "durand_r_arm"

/obj/structure/prop/mech/mech_parts/part/durand_left_leg
	name="Durand Left Leg"
	icon_state = "durand_l_leg"

/obj/structure/prop/mech/mech_parts/part/durand_right_leg
	name="Durand Right Leg"
	icon_state = "durand_r_leg"

/obj/structure/prop/mech/mech_parts/part/durand_armor
	name="Durand Armor Plates"
	icon_state = "durand_armor"

/obj/structure/prop/mech/mech_parts/chassis/firefighter
	name = "Firefighter Chassis"
	icon_state = "ripley_chassis"

/obj/structure/prop/mech/mech_parts/chassis/phazon
	name = "Phazon Chassis"
	icon_state = "phazon_chassis"

/obj/structure/prop/mech/mech_parts/part/phazon_torso
	name="Phazon Torso"
	icon_state = "phazon_harness"

/obj/structure/prop/mech/mech_parts/part/phazon_head
	name="Phazon Head"
	icon_state = "phazon_head"

/obj/structure/prop/mech/mech_parts/part/phazon_left_arm
	name="Phazon Left Arm"
	icon_state = "phazon_l_arm"

/obj/structure/prop/mech/mech_parts/part/phazon_right_arm
	name="Phazon Right Arm"
	icon_state = "phazon_r_arm"

/obj/structure/prop/mech/mech_parts/part/phazon_left_leg
	name="Phazon Left Leg"
	icon_state = "phazon_l_leg"

/obj/structure/prop/mech/mech_parts/part/phazon_right_leg
	name="Phazon Right Leg"
	icon_state = "phazon_r_leg"

/obj/structure/prop/mech/mech_parts/part/phazon_armor_plates
	name="Phazon Armor Plates"
	icon_state = "phazon_armor"

/obj/structure/prop/mech/mech_parts/chassis/odysseus
	name = "Odysseus Chassis"
	icon_state = "odysseus_chassis"

/obj/structure/prop/mech/mech_parts/part/odysseus_head
	name="Odysseus Head"
	icon_state = "odysseus_head"

/obj/structure/prop/mech/mech_parts/part/odysseus_torso
	name="Odysseus Torso"
	desc="A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"

/obj/structure/prop/mech/mech_parts/part/odysseus_left_arm
	name="Odysseus Left Arm"
	desc="An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"

/obj/structure/prop/mech/mech_parts/part/odysseus_right_arm
	name="Odysseus Right Arm"
	desc="An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"

/obj/structure/prop/mech/mech_parts/part/odysseus_left_leg
	name="Odysseus Left Leg"
	desc="An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"

/obj/structure/prop/mech/mech_parts/part/odysseus_right_leg
	name="Odysseus Right Leg"
	desc="A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"

/obj/structure/prop/mech/mech_parts/part/odysseus_armor_plates
	name="Odysseus Armor Plates"
	icon_state = "odysseus_armor"

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
	icon = 'icons/obj/structures/props/biomass_turbine.dmi'
	icon_state = "biomass_turbine"
	desc = "A gigantic turbine that runs on god knows what. It could probably be turned on by someone with the correct know-how."
	density = TRUE
	breakable = FALSE
	indestructible = TRUE
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
	icon = 'icons/obj/structures/props/biomass_turbine.dmi'
	icon_state = "support_struts_r"
	desc = "Pipes, or maybe support struts that lead into, or perhaps support that big ol' turbine."
	density = FALSE
	breakable = FALSE
	indestructible = TRUE
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
	icon = 'icons/obj/structures/props/power_transformer.dmi'
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
	indestructible = TRUE
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
	icon = 'icons/obj/structures/structures.dmi'
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
	icon = 'icons/obj/structures/structures.dmi'
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
	icon = 'icons/obj/structures/structures.dmi'
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
			mob.bodytemperature += min(round(T20C - mob.bodytemperature)*0.7, 25)
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
	icon = 'icons/obj/structures/props/vehicles.dmi'
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
	icon = 'icons/obj/structures/props/overhead_ducting.dmi'
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
	icon = 'icons/obj/structures/props/generic_props.dmi'
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
	icon_state = "off-0"

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
	icon = 'icons/obj/structures/props/crosses.dmi'
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
		GLOB.fallen_list_cross -= dogtag_name
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
		..()
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
		user.visible_message(SPAN_NOTICE("[user] begins to [action_msg] [src]."),\
			SPAN_NOTICE("You begin to [action_msg] [src]."), null, 4)

		if(!do_after(user, length(message) * time_multiplier, INTERRUPT_ALL, BUSY_ICON_GENERIC))
			to_chat(user, SPAN_WARNING("You were interrupted!"))
		else
			user.visible_message(SPAN_NOTICE("[user] uses \his [W.name] to [action_msg] [src]."),\
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
		M.visible_message(SPAN_DANGER("[M] slices [src] apart!"), \
		SPAN_DANGER("You slice [src] apart!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	else
		M.visible_message(SPAN_DANGER("[M] slashes [src]!"), \
		SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	return XENO_ATTACK_ACTION

/obj/structure/prop/wooden_cross/update_icon()
	if(tagged)
		overlays += mutable_appearance('icons/obj/structures/props/crosses.dmi', "cross_overlay")


/obj/structure/prop/invuln/rope
	name = "rope"
	desc = "A secure rope looks like someone might've been hiding out on those rocks."
	icon = 'icons/obj/structures/props/almayer_props.dmi'
	icon_state = "rope"
	density = FALSE

/obj/structure/prop/pred_flight
	name = "hunter flight console"
	desc = "A console designed by the Hunters to assist in flight pathing and navigation."
	icon = 'icons/obj/structures/machinery/computer.dmi'
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


// Hybrisa props

/obj/structure/prop/hybrisa
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	icon_state = "pimp"

// Cave props

/obj/structure/prop/hybrisa/boulders
	icon = 'icons/obj/structures/props/boulder_largedark.dmi'
	icon_state = "boulder_largedark1"

/obj/structure/prop/hybrisa/boulders/large_boulderdark
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_largedark.dmi'
	icon_state = "boulder_largedark1"
	density = TRUE
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark1
	icon_state = "boulder_largedark1"
/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark2
	icon_state = "boulder_largedark2"
/obj/structure/prop/hybrisa/boulders/large_boulderdark/boulder_dark3
	icon_state = "boulder_largedark3"
/obj/structure/prop/hybrisa/boulders/wide_boulderdark
	name = "boulder"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_widedark.dmi'
	icon_state = "boulderwidedark"
	density = TRUE
	bound_height = 32
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/boulders/wide_boulderdark/wide_boulder1
	icon_state = "boulderwidedark"
/obj/structure/prop/hybrisa/boulders/wide_boulderdark/wide_boulder2
	icon_state = "boulderwidedark2"
/obj/structure/prop/hybrisa/boulders/smallboulderdark
	name = "boulder"
	icon_state = "bouldersmalldark1"
	desc = "A large rock. It's not cooking anything."
	icon = 'icons/obj/structures/props/boulder_small.dmi'
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark1
	icon_state = "bouldersmalldark1"
/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark2
	icon_state = "bouldersmalldark2"
/obj/structure/prop/hybrisa/boulders/smallboulderdark/boulder_dark3
	icon_state = "bouldersmalldark3"

/obj/structure/prop/hybrisa/cavedecor
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	name = "stalagmite"
	icon_state = "stalagmite"
	desc = "A cave stalagmite."
/obj/structure/prop/hybrisa/cavedecor/stalagmite0
	icon_state = "stalagmite"
/obj/structure/prop/hybrisa/cavedecor/stalagmite1
	icon_state = "stalagmite1"
/obj/structure/prop/hybrisa/cavedecor/stalagmite2
	icon_state = "stalagmite2"
/obj/structure/prop/hybrisa/cavedecor/stalagmite3
	icon_state = "stalagmite3"
/obj/structure/prop/hybrisa/cavedecor/stalagmite4
	icon_state = "stalagmite4"
/obj/structure/prop/hybrisa/cavedecor/stalagmite5
	icon_state = "stalagmite5"

// Vehicles

/obj/structure/prop/hybrisa/vehicles
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	icon_state = "SUV"
	health = 600
	var/damage_state = 0

/obj/structure/prop/hybrisa/vehicles/update_icon()
	switch(health)
		if(500 to 600)
			icon_state = initial(icon_state)
			return
		if(400 to 500)
			damage_state = 1
		if(300 to 400)
			damage_state = 2
		if(200 to 300)
			damage_state = 3
		if(100 to 200)
			damage_state = 4
		if(0 to 100)
			damage_state = 5
	icon_state = "[initial(icon_state)]_damage_[damage_state]"

/obj/structure/prop/hybrisa/vehicles/proc/explode(dam, mob/M)
    src.visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), null, null, 1)
    playsound(loc, 'sound/effects/car_crush.ogg', 25)
    var/turf/Tsec = get_turf(src)
    new /obj/item/stack/rods(Tsec)
    new /obj/item/stack/rods(Tsec)
    new /obj/item/stack/sheet/metal(Tsec)
    new /obj/item/stack/sheet/metal(Tsec)
    new /obj/item/stack/cable_coil/cut(Tsec)

    new /obj/effect/spawner/gibspawner/robot(Tsec)
    new /obj/effect/decal/cleanable/blood/oil(src.loc)

    deconstruct(FALSE)
/obj/structure/prop/hybrisa/vehicles/proc/take_damage(dam, mob/M)
    if(health) //Prevents unbreakable objects from being destroyed
        health -= dam
        if(health <= 0)
            explode()
        else
            update_icon()

/obj/structure/prop/hybrisa/vehicles/attack_alien(mob/living/carbon/xenomorph/user)
    take_damage(30)
    update_icon()

/obj/structure/prop/hybrisa/vehicles/bullet_act(obj/projectile/P)
    if(P.ammo.damage)
        take_damage(P.ammo.damage)
        update_icon()

/obj/structure/prop/hybrisa/vehicles/suv
    icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
    icon_state = "SUV"

/obj/structure/prop/hybrisa/vehicles/suvdamaged
    icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
    icon_state = "SUV_damaged"

/obj/structure/prop/hybrisa/vehicles/largetruck
    icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
    icon_state = "zenithlongtruck3"

/obj/structure/prop/hybrisa/vehicles/Car
    icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
    icon_state = "MeridianCar_1"

/obj/structure/prop/hybrisa/vehicles/suv
	name = "SUV"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	icon_state = "SUV"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/suv/suv_1
	icon_state = "SUV1"
/obj/structure/prop/hybrisa/vehicles/suv/suv_2
	icon_state = "SUV2"
/obj/structure/prop/hybrisa/vehicles/suv/suv_5
	icon_state = "SUV5"
/obj/structure/prop/hybrisa/vehicles/suv/suv_6
	icon_state = "SUV6"
/obj/structure/prop/hybrisa/vehicles/suv/suv_7
	icon_state = "SUV7"
/obj/structure/prop/hybrisa/vehicles/suv/suv_8
	icon_state = "SUV8"

// Meridian Cars

/obj/structure/prop/hybrisa/vehicles/Car
	health = 600
	name = "Mono-Spectra"
	desc = "The 'Mono-Spectra', a mass-produced civilian vehicle for the colonial markets, in and outside of the United Americas. Produced by 'Meridian' a car marque and associated operating division of the Weyland-Yutani Corporation."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	icon_state = "MeridianCar_1"
	bound_height = 32
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = ABOVE_MOB_LAYER





/obj/structure/prop/hybrisa/vehicles/Car/Red
	icon = 'icons/obj/structures/props/car_damage_states.dmi'
	icon_state = "car_red"

/obj/structure/prop/hybrisa/vehicles/Car/Car_1
	icon_state = "MeridianCar_2"
/obj/structure/prop/hybrisa/vehicles/Car/Car_2
	icon_state = "MeridianCar_3"
/obj/structure/prop/hybrisa/vehicles/Car/Car_3
	icon_state = "MeridianCar_4"
/obj/structure/prop/hybrisa/vehicles/Car/Car_4
	icon_state = "MeridianCar_5"
/obj/structure/prop/hybrisa/vehicles/Car/Car_5
	icon_state = "MeridianCar_6"

// Car Chassis

/obj/structure/prop/hybrisa/vehicles/Car/Car_chassis
    desc = "A Mono-Spectra chassis in the early stages of assembly."

/obj/structure/prop/hybrisa/vehicles/Car/Car_chassis
	name = "Mono-Spectra Chassis"
	icon_state = "MeridianCar_shell"

// damaged suv

/obj/structure/prop/hybrisa/vehicles/suvdamaged
    name = "heavily damaged SUV"
    desc = "A shell of a vehicle, broken down beyond repair."

/obj/structure/prop/hybrisa/vehicles/suvdamaged/suv_damaged0
	icon_state = "SUV_damaged"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/suvdamaged/suv_damaged1
	icon_state = "SUV1_damaged"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/suvdamaged/suv_damaged2
	icon_state = "SUV2_damaged"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

// small trucks

/obj/structure/prop/hybrisa/vehicles/truck
	name = "truck"
	icon_state = "zentruck1"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/truck/truck1
	icon_state = "zentruck2"
/obj/structure/prop/hybrisa/vehicles/truck/truck2
	icon_state = "zentruck3"
/obj/structure/prop/hybrisa/vehicles/truck/truck3
	icon_state = "zentruck4"
/obj/structure/prop/hybrisa/vehicles/truck/truck4
	icon_state = "zentruck5"
/obj/structure/prop/hybrisa/vehicles/truck/truck5
	icon_state = "truck_cargo"
/obj/structure/prop/hybrisa/vehicles/truck/truck6
	icon_state = "truck"
/obj/structure/prop/hybrisa/vehicles/truck/garbage
	name = "garbage truck"
	icon_state = "zengarbagetruck"
	desc = "Seems to be broken down."
/obj/structure/prop/hybrisa/vehicles/truck/mining
	name = "mining supply truck"
	icon_state = "truck_mining"
	desc = "Seems to be broken down."
// large trucks

/obj/structure/prop/hybrisa/vehicles/largetruck
	name = "mega-hauler truck"
	icon_state = "zenithlongtruck4"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck1
	icon_state = "zenithlongtruck2"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck2
	icon_state = "zenithlongtruck3"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck3
	icon_state = "zenithlongtruck4"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruck4
	icon_state = "zenithlongtruck5"

// mining truck

/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckmining
	icon_state = "zenithlongtruckkellandmining1"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckmining
    name = "Kelland mining mega-hauler truck"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckmining/mining
	icon_state = "zenithlongtruckkellandmining1"

// w-y truck

/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy
	icon_state = "zenithlongtruckweyland1"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy
    name = "Weyland-Yutani mega-hauler truck"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy/wy1
	icon_state = "zenithlongtruckweyland1"
/obj/structure/prop/hybrisa/vehicles/largetruck/largetruckwy/wy2
	icon_state = "zenithlongtruckweyland2"

// Colony Crawlers

/obj/structure/prop/hybrisa/vehicles/colonycrawlers
	icon_state = "crawler_wy2"
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining
	icon_state = "miningcrawler1"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining2
	icon_state = "crawler_fuel"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining3
	icon_state = "crawler_covered_bed"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science
	icon_state = "crawler_wy2"
	desc = "It is a tread bound crawler used in harsh conditions. This one is designed for personnel transportation. Supplied by Orbital Blue International; 'Your friends, in the Aerospace business.' A subsidiary of Weyland Yutani."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'

// science crawlers

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science
    name = "weyland-yutani colony crawler"

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science/science1
	icon_state = "crawler_wy1"
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/science/science2
	icon_state = "crawler_wy2"
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'

// Mining Crawlers

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining
    name = "kelland mining colony crawler"

/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining1
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawler2"
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining2
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawler3"
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining3
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawler4"
/obj/structure/prop/hybrisa/vehicles/colonycrawlers/mining/mining4
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by The Kelland Mining Company; A subsidiary of Weyland Yutani."
	icon_state = "miningcrawlerblank"

// Special SUV's

/obj/structure/prop/hybrisa/vehicles/suv/misc
	name = "Weyland-Yutani rapid response vehicle"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	icon_state = "WYSUV1"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/suv/misc/wy1
	icon_state = "WYSUV1"
/obj/structure/prop/hybrisa/vehicles/suv/misc/wy2
	icon_state = "WYSUV2"
/obj/structure/prop/hybrisa/vehicles/suv/misc/wy3
	icon_state = "WYSUV3"
/obj/structure/prop/hybrisa/vehicles/suv/misc/ambulance
	name = "emergency response medical van"
	desc = "Seems to be broken down."
	icon_state = "ambulance"
/obj/structure/prop/hybrisa/vehicles/suv/misc/whitevan
	name = "maintenance SUV"
	desc = "Seems to be broken down."
	icon_state = "whitevan"
/obj/structure/prop/hybrisa/vehicles/suv/misc/maintenance
	name = "maintenance SUV"
	desc = "Seems to be broken down."
	icon_state = "maintenaceSUV"
/obj/structure/prop/hybrisa/vehicles/suv/misc/marshalls
	name = "colonial marshalls rapid response SUV"
	desc = "Seems to be broken down."
	icon_state = "marshalls"
/obj/structure/prop/hybrisa/vehicles/suv/misc/marshalls2
	name = "colonial marshalls rapid response SUV"
	desc = "Seems to be broken down."
	icon_state = "marshalls2"
/obj/structure/prop/hybrisa/vehicles/suv/misc/expensive
	name = "Expensive looking SUV"
	desc = "Seems to be broken down."
	icon_state = "SUV9"
/obj/structure/prop/hybrisa/vehicles/suv/misc/expensive2
	name = "Expensive Weyland-Yutani SUV"
	desc = "Seems to be broken down."
	icon_state = "blackSUV"
/obj/structure/prop/hybrisa/vehicles/suv/misc/expensive3
	name = "The Pimp-Mobile"
	desc = "Seems to be broken down."
	icon_state = "pimpmobile"

// Vans

/obj/structure/prop/hybrisa/vehicles/van
	name = "van"
	desc = "Seems to be broken down."
	icon = 'icons/obj/structures/props/vehiclesexpanded.dmi'
	icon_state = "greyvan"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/van/vandamaged
	name = "van"
	desc = "A shell of a vehicle, broken down beyond repair."
	icon_state = "greyvan_damaged"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/van/vanpizza
	name = "pizza delivery van"
	desc = "Seems to be broken down."
	icon_state = "pizzavan"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/van/vanmining
	name = "Kelland Mining van"
	desc = "Seems to be broken down."
	icon_state = "kellandminingvan"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/van/hyperdynevan
	name = "Hyperdyne van"
	desc = "Seems to be broken down."
	icon_state = "hyperdynevan"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/vehicles/crashedcarsleft
	name = "car pileup"
	desc = "Burned out wrecked vehicles block your path."
	icon = 'icons/obj/structures/props/crashedcars.dmi'
	icon_state = "crashedcarsleft"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = 5
/obj/structure/prop/hybrisa/vehicles/crashedcarsright
	name = "car pileup"
	desc = "Burned out wrecked vehicles block your path."
	icon = 'icons/obj/structures/props/crashedcars.dmi'
	icon_state = "crashedcarsright"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	density = TRUE
	layer = 5

// Supermart

/obj/structure/prop/hybrisa/supermart
	name = "long rack"
	icon_state = "longrack1"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	density = TRUE

/obj/structure/prop/hybrisa/supermart/rack/longrackempty
	name = "shelf"
	desc = "A long empty shelf."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrackempty"
/obj/structure/prop/hybrisa/supermart/rack/longrack1
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack1"
/obj/structure/prop/hybrisa/supermart/rack/longrack2
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack2"
/obj/structure/prop/hybrisa/supermart/rack/longrack3
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack3"
/obj/structure/prop/hybrisa/supermart/rack/longrack4
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack4"
/obj/structure/prop/hybrisa/supermart/rack/longrack5
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack5"
/obj/structure/prop/hybrisa/supermart/rack/longrack6
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack6"
/obj/structure/prop/hybrisa/supermart/rack/longrack7
	name = "shelf"
	desc = "A long shelf filled with various foodstuffs"
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "longrack7"

/obj/structure/prop/hybrisa/supermart/supermartbelt
	name = "conveyor belt"
	desc = "A conveyor belt."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "checkoutbelt"

/obj/structure/prop/hybrisa/supermart/freezer
	name = "commercial freezer"
	desc = "A commercial grade freezer."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerupper"
	density = TRUE
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer1
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerupper"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer2
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerlower"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer3
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezermid"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer4
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerupper1"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer5
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezerlower1"
/obj/structure/prop/hybrisa/supermart/freezer/supermartfreezer6
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "freezermid1"

/obj/structure/prop/hybrisa/supermart/supermartfruitbasketempty
	name = "basket"
	desc = "A basket."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasketempty"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketoranges
	name = "basket"
	desc = "A basket full of oranges."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket1"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketpears
	name = "basket"
	desc = "A basket full of pears."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket2"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketcarrots
	name = "basket"
	desc = "A basket full of carrots."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket3"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketmelons
	name = "basket"
	desc = "A basket full of melons."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket4"
/obj/structure/prop/hybrisa/supermart/supermartfruitbasketapples
	name = "basket"
	desc = "A basket full of apples."
	icon = 'icons/obj/structures/props/supermart.dmi'
	icon_state = "supermarketbasket5"

// Hospital

/obj/structure/prop/hybrisa/hospital
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hospital"
/obj/structure/prop/hybrisa/hospital/hospitaldivider
	name = "hospital divider"
	desc = "A hospital divider for privacy."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hospitalcurtain"
	layer = ABOVE_MOB_LAYER

// Furniture

/obj/structure/prop/hybrisa/furniture
    icon = 'icons/obj/structures/props/zenithtables.dmi'
    icon_state = "blackmetaltable"

/obj/structure/prop/hybrisa/furniture/tables
    icon = 'icons/obj/structures/props/zenithtables.dmi'
    icon_state = "table_pool"

/obj/structure/prop/hybrisa/furniture/tables/tableblack
	name = "large metal table"
	desc = "A large black metal table, looks very expensive."
	icon_state = "blackmetaltable"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	bound_height = 32
	bound_width = 64
	debris = list(/obj/item/stack/sheet/metal)

/obj/structure/prop/hybrisa/furniture/tables/tableblack/blacktablecomputer
    icon = 'icons/obj/structures/props/zenithtables.dmi'
    icon_state = "blackmetaltable_computer"

/obj/structure/prop/hybrisa/furniture/tables/tablewood
	name = "large wood table"
	desc = "A large wooden table, looks very expensive."
	icon_state = "brownlargetable"
	density = TRUE
	climbable = TRUE
	breakable = TRUE
	bound_height = 32
	bound_width = 64
	debris = list(/obj/item/stack/sheet/wood)

/obj/structure/prop/hybrisa/furniture/tables/tablewood/woodtablecomputer
    icon = 'icons/obj/structures/props/zenithtables.dmi'
    icon_state = "brownlargetable_computer"

/obj/structure/prop/hybrisa/furniture/tables/tablepool
	name = "pool table"
	desc = "A large table used for Pool."
	icon = 'icons/obj/structures/props/zenithtables.dmi'
	icon_state = "table_pool"
	density = TRUE
	bound_height = 32
	bound_width = 64
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)
/obj/structure/prop/hybrisa/furniture/tables/tablegambling
	name = "gambling table"
	desc = "A large table used for gambling."
	icon = 'icons/obj/structures/props/zenithtables.dmi'
	icon_state = "table_cards"
	density = TRUE
	bound_height = 32
	bound_width = 64
	climbable = TRUE
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)

// Chairs
/obj/structure/bed/hybrisa/chairs
    name = "expensive chair"
    desc = "A expensive looking chair"

/obj/structure/bed/hybrisa/chairs/black
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithblack"
/obj/structure/bed/hybrisa/chairs/red
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithred"
/obj/structure/bed/hybrisa/chairs/blue
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithblue"
/obj/structure/bed/hybrisa/chairs/brown
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "comfychair_zenithbrown"

// Beds

/obj/structure/bed/hybrisa
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hybrisa"

/obj/structure/bed/hybrisa/prisonbed
	name = "bunk bed"
	desc = "A sorry looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "prisonbed"

/obj/structure/bed/hybrisa/bunkbed1
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed"

/obj/structure/bed/hybrisa/bunkbed2
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed2"

/obj/structure/bed/hybrisa/bunkbed3
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed3"

/obj/structure/bed/hybrisa/bunkbed4
	name = "bunk bed"
	desc = "A comfy looking bunk-bed."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zbunkbed4"

/obj/structure/bed/hybrisa/hospitalbeds
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "hospital"

/obj/structure/bed/hybrisa/hospitalbeds/hospitalbed1
	name = "hospital bed"
	desc = "A mattress seated on a rectangular metallic frame with wheels. This is used to support a lying person in a comfortable manner."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigrollerempty2_up"

/obj/structure/bed/hybrisa/hospitalbeds/hospitalbed2
	name = "hospital bed"
	desc = "A mattress seated on a rectangular metallic frame with wheels. This is used to support a lying person in a comfortable manner."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigrollerempty_up"

/obj/structure/bed/hybrisa/hospitalbeds/hospitalbed3
	name = "hospital bed"
	desc = "A mattress seated on a rectangular metallic frame with wheels. This is used to support a lying person in a comfortable manner."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "bigrollerempty3_up"

// Xenobiology

/obj/structure/prop/hybrisa/xenobiology
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellemptyon"
	layer = ABOVE_MOB_LAYER


/obj/structure/prop/hybrisa/xenobiology/small/empty
	name = "specimen containment cell"
	desc = "It's empty."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellemptyon"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/offempty
	name = "specimen containment cell"
	desc = "It's turned off and empty."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellemptyoff"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/larva
	name = "specimen containment cell"
	desc = "There is something worm-like inside..."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocelllarva"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/egg
	name = "specimen containment cell"
	desc = "There is, what looks like some sort of egg inside..."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellegg"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/hugger
	name = "specimen containment cell"
	desc = "There's something spider-like inside..."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellhugger"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/cracked1
	name = "specimen containment cell"
	desc = "Looks like something broke it...from the inside."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellcrackedempty"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/cracked2
	name = "specimen containment cell"
	desc = "Looks like something broke it...from the inside."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellcrackedempty2"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/small/crackedegg
	name = "specimen containment cell"
	desc = "Looks like something broke it, there's a giant empty egg inside."
	icon = 'icons/obj/structures/props/zenithxenocryogenics.dmi'
	icon_state = "xenocellcrackedegg"
	density = TRUE
/obj/structure/prop/hybrisa/xenobiology/big
	name = "specimen containment cell"
	desc = "A giant tube with a hulking monstrosity inside, is this thing alive?"
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo1"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

/obj/structure/prop/hybrisa/xenobiology/big/bigleft
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo1"
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/xenobiology/big/bigright
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo2"
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/xenobiology/big/bigbottomleft
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo3"
	density = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/xenobiology/big/bigbottomright
	icon = 'icons/obj/structures/props/zenithxenocryogenics2.dmi'
	icon_state = "bigqueencryo4"
	density = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/xenobiology/misc
	name = "strange egg"
	desc = "A strange ancient looking egg, it seems to be inert."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "inertegg"
	unslashable = TRUE
	indestructible = TRUE
	layer = 2

// Engineer

/obj/structure/prop/hybrisa/engineer
	icon = 'icons/obj/structures/props/engineerJockey.dmi'
	icon_state = "spacejockey"

/obj/structure/prop/hybrisa/engineer/spacejockey
	name = "Giant Pilot"
	desc = "A Giant Alien life form. Looks like it's been dead a long time. Fossilized. Looks like it's growing out of the chair. Bones are bent outward, like it exploded from inside."
	icon = 'icons/obj/structures/props/engineerJockey.dmi'
	icon_state = "spacejockey"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/engineer/giantpodbroken
	name = "Giant Hypersleep Chamber"
	desc = "What looks to be a Giant Hypersleep Chamber, this one appears to contain a Alien life form. it looks like it's been dead for a long time, Fossilized. From what you can see it's bones are bent outwards, the chambers outer shell has holes melted, pushing outwards. "
	icon = 'icons/obj/structures/props/engineerPod.dmi'
	icon_state = "pod_broken"
	bound_height = 96
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
	density = TRUE
obj/structure/prop/hybrisa/engineer/giantpod
	name = "Giant Hypersleep Chamber"
	desc = "What looks to be a Giant Hypersleep Chamber, a strange alien design, unlike anything you've ever seen before. It's empty."
	icon = 'icons/obj/structures/props/engineerPod.dmi'
	icon_state = "pod"
	bound_height = 96
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	density = TRUE
obj/structure/prop/hybrisa/engineer/giantconsole
	name = "Giant Alien Console"
	desc = "A Giant Alien console of some kind, unlike anything you've ever seen before. Who knows the purpose of this strange technology..."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "engineerconsole"
	bound_height = 32
	bound_width = 32
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	density = TRUE
/obj/structure/prop/hybrisa/engineer/engineerpillar
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1fade"
	bound_height = 64
	bound_width = 128
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/engineer/engineerpillar/northwesttop
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_NW1"
/obj/structure/prop/hybrisa/engineer/engineerpillar/northwestbottom
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_NW2"
/obj/structure/prop/hybrisa/engineer/engineerpillar/southwesttop
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1"
/obj/structure/prop/hybrisa/engineer/engineerpillar/southwestbottom
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW2"
/obj/structure/prop/hybrisa/engineer/engineerpillar/smallsouthwest1
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW1fade"
/obj/structure/prop/hybrisa/engineer/engineerpillar/smallsouthwest2
	name = "strange pillar"
	icon = 'icons/obj/structures/props/zenithengineerpillarangled.dmi'
	icon_state = "engineerpillar_SW2fade"

/obj/structure/prop/hybrisa/engineer/blackgoocontainer
	name = "strange container"
	icon_state = "blackgoocontainer1"
	desc = "A strange alien container, who knows what's inside..."
	icon = 'icons/obj/structures/props/blackgoocontainers.dmi'

// Signs

/obj/structure/prop/hybrisa/signs
	name = "neon sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "jacksopen_on"
	bound_height = 64
	bound_width = 64
	unslashable = TRUE
	unacidable = TRUE
	layer = ABOVE_MOB_LAYER

/obj/structure/prop/hybrisa/signs/casniosign
	name = "casino sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "nightgoldcasinoopen_on"
/obj/structure/prop/hybrisa/signs/jackssign
	name = "jack's surplus sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "jacksopen_on"
/obj/structure/prop/hybrisa/signs/opensign
	name = "open sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "open_on"
/obj/structure/prop/hybrisa/signs/opensign2
	name = "open sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "open_on2"
/obj/structure/prop/hybrisa/signs/pizzasign
	name = "pizza sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "pizzaneon_on"
/obj/structure/prop/hybrisa/signs/weymartsign
	name = "weymart sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "weymartsign2"
/obj/structure/prop/hybrisa/signs/mechanicsign
	name = "mechanic sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "mechanicopen_on2"
/obj/structure/prop/hybrisa/signs/cuppajoessign
	name = "cuppa joe's sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "cuppajoes"
/obj/structure/prop/hybrisa/signs/barsign
	name = "bar sign"
	icon = 'icons/obj/structures/props/zenith64x64_signs.dmi'
	icon_state = "barsign_on"

// Small Sign
/obj/structure/prop/hybrisa/signs/high_voltage
	name = "warning sign"
	desc = "DANGER - HIGH VOLTAGE - DEATH!."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "shockyBig"
/obj/structure/prop/hybrisa/signs/high_voltage/small
	name = "warning sign"
	desc = "DANGER - HIGH VOLTAGE - DEATH!."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "shockyTiny"

// Airport

/obj/structure/prop/hybrisa/airport
	name = "nose cone"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipfrontwhite1"
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/hybrisa/airport/dropshipnosecone
	name = "nose cone"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipfrontwhite1"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/airport/dropshipwingleft
	name = "wing"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipwingtop1"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/airport/dropshipwingright
	name = "wing"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipwingtop2"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/airport/dropshipvent1left
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent1"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/airport/dropshipvent2right
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent2"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/airport/dropshipventleft
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent3"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER
/obj/structure/prop/hybrisa/airport/dropshipventright
	name = "vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dropshipvent4"
	indestructible = TRUE
	layer = ABOVE_MOB_LAYER

// Dropship damage

/obj/structure/prop/hybrisa/airport/dropshipenginedamage
	name = "dropship damage"
	desc = "the engine appears to have severe damage."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "dropship_engine_damage"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

/obj/structure/prop/hybrisa/airport/dropshipenginedamagenofire
	name = "dropship damage"
	desc = "the engine appears to have severe damage."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "dropship_engine_damage_nofire"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

/obj/structure/prop/hybrisa/airport/refuelinghose
	name = "refueling hose"
	desc = "A long refueling hose that connects to various types of dropships."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "fuelline1"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/airport/refuelinghose2
	name = "refueling hose"
	desc = "A long refueling hose that connects to various types of dropships."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "fuelline2"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

// Pilot body

/obj/structure/prop/hybrisa/airport/deadpilot1
	name = "decapitated Weyland-Yutani Pilot"
	desc = "What remains of a Weyland-Yutani Pilot. Their entire head is missing. Where'd it roll off to?..."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "pilotbody_decap1"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
/obj/structure/prop/hybrisa/airport/deadpilot2
	name = "decapitated Weyland-Yutani Pilot"
	desc = "What remains of a Weyland-Yutani Pilot. Their entire head is missing. Where'd it roll off to?..."
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "pilotbody_decap2"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE

// Misc

/obj/structure/prop/hybrisa/misc
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier"

// Floor props

/obj/structure/prop/hybrisa/misc/floorprops
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/grate
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/grate2
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate5"

/obj/structure/prop/hybrisa/misc/floorprops/grate3
	name = "solid metal grate"
	desc = "A metal grate."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zhalfgrate1"

/obj/structure/prop/hybrisa/misc/floorprops/floorglass
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate2"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
/obj/structure/prop/hybrisa/misc/floorprops/floorglass2
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate3"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
	layer = 2.1
/obj/structure/prop/hybrisa/misc/floorprops/floorglass3
	name = "reinforced glass floor"
	desc = "A heavily reinforced glass floor panel, this looks almost indestructible."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "solidgrate4"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

// Graffiti

/obj/structure/prop/hybrisa/misc/graffiti
	name = "graffiti"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti4"
	bound_height = 64
	bound_width = 96
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE

/obj/structure/prop/hybrisa/misc/graffiti/graffiti1
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti1"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti2
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti2"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti3
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti3"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti4
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti4"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti5
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti5"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti6
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti6"
/obj/structure/prop/hybrisa/misc/graffiti/graffiti7
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zgraffiti7"

// Wall Blood

/obj/structure/prop/hybrisa/misc/blood
	name = "blood"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wallblood_floorblood"
	unslashable = TRUE
	unacidable = TRUE
	breakable = TRUE

/obj/structure/prop/hybrisa/misc/blood/blood1
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wallblood_floorblood"
/obj/structure/prop/hybrisa/misc/blood/blood2
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wall_blood_1"
/obj/structure/prop/hybrisa/misc/blood/blood3
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "wall_blood_2"

// Fire

/obj/structure/prop/hybrisa/misc/fire/fire1
	name = "fire"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zfire_smoke"
	layer = 5
	light_on = TRUE
	light_power = 2
	light_range = 3

/obj/structure/prop/hybrisa/misc/fire/fire2
	name = "fire"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zfire_smoke2"
	layer = 5
	light_on = TRUE
	light_power = 2
	light_range = 3

/obj/structure/prop/hybrisa/misc/fire/firebarrel
	name = "barrel"
	icon = 'icons/obj/structures/props/64x96-zenithrandomprops.dmi'
	icon_state = "zbarrelfireon"
	layer = 5
	light_on = TRUE
	light_power = 2
	light_range = 3

// Misc

/obj/structure/prop/hybrisa/misc/commandosuitemptyprop
	name = "Weyland-Yutani 'Ape-Suit' Showcase"
	desc = "A display model of the Weyland-Yutani 'Apesuit', shame it's only a model..."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "dogcatchersuitempty1"

/obj/structure/prop/hybrisa/misc/cabinet
	name = "cabinet"
	desc = "a small cabinet with drawers."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sidecabinet"
/obj/structure/prop/hybrisa/misc/trash/green
	name = "trash bin"
	desc = "A Weyland-Yutani trash bin used for disposing your unwanted items, or you can just throw your shit on the ground like every other asshole."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "trashgreen"
	density = TRUE
/obj/structure/prop/hybrisa/misc/trash/blue
	name = "trash bin"
	desc = "A Weyland-Yutani trash bin used for disposing your unwanted items, or you can just throw your shit on the ground like every other asshole."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "trashblue"
	density = TRUE
/obj/structure/prop/hybrisa/misc/redmeter
	name = "meter"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "redmeter"

/obj/structure/prop/hybrisa/misc/firebarreloff
	name = "barrel"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zfirebarreloff"

/obj/structure/prop/hybrisa/misc/trashbagfullprop
	name = "trash bag"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "ztrashbag"

/obj/structure/prop/hybrisa/misc/slotmachine
	name = "slot machine"
	desc = "A slot machine."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "slotmachine"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	layer = 3.2
/obj/structure/prop/hybrisa/misc/slotmachine_broken
	name = "slot machine"
	desc = "A broken slot machine."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "slotmachine_broken"
	bound_width = 32
	bound_height = 32
	anchored = TRUE
	density = TRUE
	layer = 3.2
/obj/structure/prop/hybrisa/misc/coffeestuff/coffeemachine1
	name = "coffee machine"
	desc = "A coffee machine."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "coffee"

/obj/structure/prop/hybrisa/misc/coffeestuff/coffeemachine2
	name = "coffee machine"
	desc = "A coffee machine."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "coffee_cup"

/obj/structure/prop/hybrisa/misc/machinery/computers
	name = "computer"
	icon_state = "mapping_comp"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer1
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "mapping_comp"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer2
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "mps"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer3
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sensor_comp1"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer4
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sensor_comp2"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerwhite/computer5
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "sensor_comp3"


/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer1
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blackmapping_comp"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer2
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blackmps"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer3
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blacksensor_comp1"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer4
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blacksensor_comp2"

/obj/structure/prop/hybrisa/misc/machinery/computers/computerblack/computer5
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "blacksensor_comp3"


/obj/structure/prop/hybrisa/misc/machinery/screens
    name = "monitor"
/obj/structure/prop/hybrisa/misc/machinery/screens/frame
	icon_state = "frame"
/obj/structure/prop/hybrisa/misc/machinery/screens/security
	icon_state = "security"
/obj/structure/prop/hybrisa/misc/machinery/screens/evac
	icon_state = "evac"
/obj/structure/prop/hybrisa/misc/machinery/screens/redalert
	icon_state = "redalert"
/obj/structure/prop/hybrisa/misc/machinery/screens/redalertblank
	icon_state = "redalertblank"
/obj/structure/prop/hybrisa/misc/machinery/screens/entertainment
	icon_state = "entertainment"
/obj/structure/prop/hybrisa/misc/machinery/screens/telescreen
	icon_state = "telescreen"
/obj/structure/prop/hybrisa/misc/machinery/screens/telescreenbroke
	icon_state = "telescreenb"
/obj/structure/prop/hybrisa/misc/machinery/screens/telescreenbrokespark
	icon_state = "telescreenbspark"

// Multi-Monitor

//Green
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorsmall_off
	icon_state = "multimonitorsmall_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorsmall_on
	icon_state = "multimonitorsmall_on"
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitormedium_off
	icon_state = "multimonitormedium_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitormedium_on
	icon_state = "multimonitormedium_on"
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorbig_off
	icon_state = "multimonitorbig_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/multimonitorbig_on
	icon_state = "multimonitorbig_on"

// Blue

/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorsmall_off
	icon_state = "bluemultimonitorsmall_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorsmall_on
	icon_state = "bluemultimonitorsmall_on"
/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitormedium_off
	icon_state = "bluemultimonitormedium_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitormedium_on
	icon_state = "bluemultimonitormedium_on"
/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorbig_off
	icon_state = "bluemultimonitorbig_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/bluemultimonitorbig_on
	icon_state = "bluemultimonitorbig_on"

// Egg
/obj/structure/prop/hybrisa/misc/machinery/screens/wallegg_off
	icon_state = "wallegg_off"
/obj/structure/prop/hybrisa/misc/machinery/screens/wallegg_on
	icon_state = "wallegg_on"

/obj/structure/prop/hybrisa/misc/fake/pipes
    name = "disposal pipe"

/obj/structure/prop/hybrisa/misc/fake/pipes/pipe1
	layer = 2
	icon_state = "pipe-s"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe2
	layer = 2
	icon_state = "pipe-c"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe3
	layer = 2
	icon_state = "pipe-j1"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe4
	layer = 2
	icon_state = "pipe-y"
/obj/structure/prop/hybrisa/misc/fake/pipes/pipe5
	layer = 2
	icon_state = "pipe-b"

/obj/structure/prop/hybrisa/misc/fake/wire
    name = "power cable"

/obj/structure/prop/hybrisa/misc/fake/wire/red
	layer = 2
	icon_state = "intactred"
/obj/structure/prop/hybrisa/misc/fake/wire/yellow
	layer = 2
	icon_state = "intactyellow"
/obj/structure/prop/hybrisa/misc/fake/wire/blue
	layer = 2
	icon_state = "intactblue"


/obj/structure/prop/hybrisa/misc/fake/heavydutywire
    name = "heavy duty wire"

/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy1
	layer = 2
	icon_state = "0-1"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy2
	layer = 2
	icon_state = "1-2"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy3
	layer = 2
	icon_state = "1-4"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy4
	layer = 2
	icon_state = "1-2-4"
/obj/structure/prop/hybrisa/misc/fake/heavydutywire/heavy5
	layer = 2
	icon_state = "1-2-4-8"

/obj/structure/prop/hybrisa/misc/fake/lattice
    name = "structural lattice"

/obj/structure/prop/hybrisa/misc/fake/lattice/full
	icon_state = "latticefull"
	layer = 2

// Barriers

/obj/structure/prop/hybrisa/misc/road
	name = "road barrier"
	desc = "A plastic barrier for blocking entry."
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/mineral/plastic)

/obj/structure/prop/hybrisa/misc/road/roadbarrierred
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier"
/obj/structure/prop/hybrisa/misc/road/roadbarrierredlong
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier4"
/obj/structure/prop/hybrisa/misc/road/roadbarrierblue
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier2"
/obj/structure/prop/hybrisa/misc/road/roadbarrierbluelong
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier5"
/obj/structure/prop/hybrisa/misc/road/roadbarrierwyblack
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier3"
/obj/structure/prop/hybrisa/misc/road/roadbarrierwyblacklong
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrier6"
/obj/structure/prop/hybrisa/misc/road/roadbarrierwyblackjoined
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierjoined3"
/obj/structure/prop/hybrisa/misc/road/roadbarrierjoined
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierjoined"

/obj/structure/prop/hybrisa/misc/road/wood
	name = "road barrier"
	desc = "A wooden barrier for blocking entry."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierwood"
	breakable = TRUE
	debris = list(/obj/item/stack/sheet/wood)

/obj/structure/prop/hybrisa/misc/road/wood/roadbarrierwoodorange
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierwood"
/obj/structure/prop/hybrisa/misc/road/wood/roadbarrierwoodblue
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "roadbarrierpolice"

// Cargo Containers extended

/obj/structure/prop/hybrisa/containersextended
	name = "cargo container"
	desc = "a cargo container."
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "blackwyleft"
	bound_width = 32
	bound_height = 32
	density = TRUE
	health = 200
	opacity = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	layer = 5

/obj/structure/prop/hybrisa/containersextended/blueleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "blueleft"
/obj/structure/prop/hybrisa/containersextended/blueright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "blueright"
/obj/structure/prop/hybrisa/containersextended/greenleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "greenleft"
/obj/structure/prop/hybrisa/containersextended/greenright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "greenright"
/obj/structure/prop/hybrisa/containersextended/tanleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "tanleft"
/obj/structure/prop/hybrisa/containersextended/tanright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "tanright"
/obj/structure/prop/hybrisa/containersextended/redleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "redleft"
/obj/structure/prop/hybrisa/containersextended/redright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "redright"
/obj/structure/prop/hybrisa/containersextended/greywyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "greywyleft"
/obj/structure/prop/hybrisa/containersextended/greywyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "greywyright"
/obj/structure/prop/hybrisa/containersextended/lightgreywyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "lightgreywyleft"
/obj/structure/prop/hybrisa/containersextended/lightgreywyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "lightgreywyright"
/obj/structure/prop/hybrisa/containersextended/blackwyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "blackwyleft"
/obj/structure/prop/hybrisa/containersextended/blackwyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "blackwyright"
/obj/structure/prop/hybrisa/containersextended/whitewyleft
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "whitewyleft"
/obj/structure/prop/hybrisa/containersextended/whitewyright
	name = "Weyland-Yutani cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "whitewyright"

/obj/structure/prop/hybrisa/containersextended/tanwywingsleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "tanwywingsleft"
/obj/structure/prop/hybrisa/containersextended/tanwywingsright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "tanwywingsright"
/obj/structure/prop/hybrisa/containersextended/greenwywingsleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "greenwywingsleft"
/obj/structure/prop/hybrisa/containersextended/greenwywingsright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "greenwywingsright"
/obj/structure/prop/hybrisa/containersextended/bluewywingsleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "bluewywingsleft"
/obj/structure/prop/hybrisa/containersextended/bluewywingsright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "bluewywingsright"
/obj/structure/prop/hybrisa/containersextended/redwywingsleft
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "redwywingsleft"
/obj/structure/prop/hybrisa/containersextended/redwywingsright
	name = "cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "redwywingsright"
/obj/structure/prop/hybrisa/containersextended/medicalleft
	name = "medical cargo containers"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "medicalleft"
/obj/structure/prop/hybrisa/containersextended/medicalright
	name = "medical cargo containers"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "medicalright"
/obj/structure/prop/hybrisa/containersextended/emptymedicalleft
	name = "medical cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "emptymedicalleft"
/obj/structure/prop/hybrisa/containersextended/emptymedicalright
	name = "medical cargo container"
	icon = 'icons/obj/structures/props/containersextended.dmi'
	icon_state = "emptymedicalright"

/// Fake Platforms

/obj/structure/prop/hybrisa/fakeplatforms
    name = "platform"

/obj/structure/prop/hybrisa/fakeplatforms/platform1
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "engineer_platform"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
/obj/structure/prop/hybrisa/fakeplatforms/platform2
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "engineer_platform_platformcorners"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
/obj/structure/prop/hybrisa/fakeplatforms/platform3
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "platform"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE
/obj/structure/prop/hybrisa/fakeplatforms/platform4
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zenithplatform3"
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

/// Medical Details breakable

/obj/structure/prop/hybrisa/decal/medical
	name = "medical decal"
	icon = 'icons/effects/medical_decals.dmi'
	icon_state = "cryotop"
	layer = 1


// Grille

/obj/structure/prop/hybrisa/misc/highvoltagegrille
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "highvoltagegrille"

//
/obj/structure/prop/hybrisa/misc/buildinggreeblies
	name = "machinery"
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "buildingventbig1"
	bound_width = 64
	bound_height = 32
	density = TRUE
	health = 200
	anchored = TRUE
	layer = 5
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble1
	icon_state = "buildingventbig2"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble2
	icon_state = "buildingventbig3"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble3
	icon_state = "buildingventbig4"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble4
	icon_state = "buildingventbig5"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble5
	icon_state = "buildingventbig6"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble6
	icon_state = "buildingventbig7"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble7
	icon_state = "buildingventbig8"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble8
	icon_state = "buildingventbig9"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble9
	icon_state = "buildingventbig10"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble10
	density = FALSE
	icon_state = "buildingventbig11"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble11
	density = FALSE
	icon_state = "buildingventbig12"
/obj/structure/prop/hybrisa/misc/buildinggreeblies/greeble12
	density = FALSE
	icon_state = "buildingventbig13"

/obj/structure/prop/hybrisa/misc/buildinggreebliessmall
	name = "wall vent"
	name = "wall vent"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "smallwallvent1"
	density = FALSE
/obj/structure/prop/hybrisa/misc/buildinggreebliessmall2
	name = "wall vent"
	icon_state = "smallwallvent2"
/obj/structure/prop/hybrisa/misc/buildinggreebliessmall2
	name = "wall vent"
	icon_state = "smallwallvent2"
/obj/structure/prop/hybrisa/misc/buildinggreebliessmall3
	name = "wall vent"
	icon_state = "smallwallvent3"


/obj/structure/prop/hybrisa/misc/buildinggreebliessmall/computer
	name = "machinery"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "zcomputermachine"
	density = TRUE

/obj/structure/prop/hybrisa/misc/metergreen
	name = "meter"
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "biggreenmeter1"

/obj/structure/prop/hybrisa/misc/stoneplanterseats
	name = "concrete seated planter"
	desc = "A decorative concrete planter with seating attached, the seats are fitted with synthetic leather, they've faded in time.."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "planterseats"
	bound_width = 32
	bound_height = 64
	density = TRUE
	health = 200
	anchored = TRUE

/obj/structure/prop/hybrisa/misc/stoneplanterseats/empty
	name = "concrete planter"
	desc = "A decorative concrete planter."
	icon_state = "planterempty"

/obj/structure/prop/hybrisa/misc/concretestatue
	name = "concrete statue"
	desc = "A decorative statue with the Weyland-Yutani 'Wings' adorned on it, A corporate brutalist piece of art."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "concretesculpture"
	bound_width = 64
	bound_height = 64
	density = TRUE
	anchored = TRUE
	unslashable = TRUE
	unacidable = TRUE
	indestructible = TRUE

/obj/structure/prop/hybrisa/misc/detonator
	name = "inactive detonator"
	desc = "A detonator for explosives, this one appears to be missing a vital component."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "detonator"
	density = TRUE
	anchored = TRUE

/obj/structure/prop/hybrisa/misc/firehydrant
	name = "fire hydrant"
	desc = "A fire hydrant public water outlet, designed for quick access to water."
	icon = 'icons/obj/structures/props/zenithrandomprops.dmi'
	icon_state = "firehydrant"
	density = TRUE
	anchored = TRUE
/obj/structure/prop/hybrisa/misc/phonebox
	name = "phonebox"
	desc = "A phone-box, it doesn't seem to be working, the line must be down."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "phonebox_closed"
	layer = ABOVE_MOB_LAYER
	bound_width = 32
	bound_height = 32
	density = TRUE
	anchored = TRUE
/obj/structure/prop/hybrisa/misc/phonebox/broken
	desc = "A phone-box, it doesn't seem to be working, the line must be down. The glass has been broken."
	icon_state = "phonebox_closed_broken"

/obj/structure/prop/hybrisa/misc/phonebox/lightup
	desc = "A phone-box, it doesn't seem to be working, the line must be down."
	icon_state = "phonebox_closed_light"

/obj/structure/prop/hybrisa/misc/bench
	name = "bench"
	desc = "A metal frame, with seats that are fitted with synthetic leather, they've faded in time."
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "seatedbench"
	bound_width = 32
	bound_height = 64
	layer = 4
	density = FALSE
	health = 200
	anchored = TRUE

// Billboards, Signs and Posters

/obj/structure/prop/hybrisa/BillboardsandSigns/BigBillboards
	name = "billboard"
	desc = "A advertisement billboard."
	icon = 'icons/obj/structures/props/32x64_zenithbillboards.dmi'
	icon_state = "billboard_bigger"
	bound_width = 64
	bound_height = 32
	density = FALSE
	health = 200
	anchored = TRUE
/obj/structure/prop/hybrisa/BillboardsandSigns/Billboardsmedium/Billboard1
	name = "billboard"
	desc = "A advertisement billboard."
	icon = 'icons/obj/structures/props/32x64_zenithbillboards.dmi'
	icon_state = "billboard1"
/obj/structure/prop/hybrisa/BillboardsandSigns/Billboardsmedium/Billboard2
	name = "billboard"
	desc = "A advertisement billboard."
	icon = 'icons/obj/structures/props/32x64_zenithbillboards.dmi'
	icon_state = "billboard2"
/obj/structure/prop/hybrisa/BillboardsandSigns/Billboardsmedium/Billboard3
	name = "billboard"
	desc = "A advertisement billboard."
	icon = 'icons/obj/structures/props/32x64_zenithbillboards.dmi'
	icon_state = "billboard3"
/obj/structure/prop/hybrisa/BillboardsandSigns/Billboardsmedium/Billboard4
	name = "billboard"
	desc = "A advertisement billboard."
	icon = 'icons/obj/structures/props/32x64_zenithbillboards.dmi'
	icon_state = "billboard4"
// Car Factory

/obj/structure/prop/hybrisa/Factory
	icon = 'icons/obj/structures/props/64x64_zenithrandomprops.dmi'
	icon_state = "factory_roboticarm"

/obj/structure/prop/hybrisa/Factory/Robotic_arm
	name = "Robotic arm"
	desc = "A robotic arm used in the construction of 'Meridian' Automobiles."
	icon_state = "factory_roboticarm"
	bound_width = 64
	bound_height = 32
	anchored = TRUE
/obj/structure/prop/hybrisa/Factory/Robotic_arm/Flipped
	icon_state = "factory_roboticarm2"
/obj/structure/prop/hybrisa/Factory/Conveyor_belt
	name = "large conveyor belt"
	desc = "A large conveyor belt used in industrial factories."
	icon_state = "factory_conveyer"
	density = FALSE




