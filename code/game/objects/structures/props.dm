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
	else if (ishuman(user) && istype(W, /obj/item/tool/wrench))
		on = !on
		visible_message("You wrench the controls of \the [src]. The drill jumps to life." , "[user] wrenches the controls of \the [src]. The drill jumps to life.")

		update()

/obj/structure/prop/dam/drill/proc/update()
	icon_state = "thumper[on ? "-on" : ""]"
	if(on)
		SetLuminosity(3)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		SetLuminosity(0)
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
		SetLuminosity(6)
	else
		SetLuminosity(0)
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
	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
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
	icon_state = "blank"
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
	icon_state = "gygas_chassis"

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

/obj/structure/prop/mech/mech_parts/part/gygax_armour
	name="Gygax Armour Plates"
	icon_state = "gygax_armour"

/obj/structure/prop/mech/mech_parts/chassis/durand
	name = "Durand Chassis"
	icon_state = "gygas_chassis"

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

/obj/structure/prop/mech/mech_parts/part/durand_armour
	name="Durand Armour Plates"
	icon_state = "durand_armour"

/obj/structure/prop/mech/mech_parts/chassis/firefighter
	name = "Firefighter Chassis"
	icon_state = "ripley_chassis"

/obj/structure/prop/mech/mech_parts/chassis/phazon
	name = "Phazon Chassis"

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

/obj/structure/prop/mech/mech_parts/chassis/odysseus
	name = "Odysseus Chassis"
	icon_state = "gygas_chassis"

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
	else if (ishuman(user) && istype(W, /obj/item/tool/crowbar))
		on = !on
		visible_message("You pry at the control valve on [src]. The machine shudders." , "[user] pries at the control valve on [src]. The entire machine shudders.")

		Update()

/obj/structure/prop/turbine/proc/Update()
	icon_state = "biomass_turbine[on ? "-on" : ""]"
	if (on)
		SetLuminosity(3)
		playsound(src, 'sound/machines/turbine_on.ogg')
	else
		SetLuminosity(0)
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
	icon_state = "cash_registern_off"

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

/obj/structure/prop/invuln/lifeboat_hatch_placeholder/terminal
	icon = 'icons/obj/structures/machinery/bolt_terminal.dmi'

/obj/structure/prop/invuln/dropship_parts //for TG shuttle system
	density = TRUE

/obj/structure/prop/invuln/dropship_parts/beforeShuttleMove() //moves content but leaves the turf behind (for cool space turf)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS
		. &= ~MOVE_TURF

/obj/structure/prop/invuln/dropship_parts/lifeboat
	name = "Lifeboat"
	icon = 'icons/turf/lifeboat.dmi'


/obj/structure/prop/brazier
	name = "brazier"
	desc = "The fire inside the brazier emits a relatively dim glow to flashlights and flares, but nothing can replace the feeling of sitting next to a fireplace with your friends."
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "brazier"
	density = TRUE

/obj/structure/prop/brazier/Initialize()
	. = ..()
	SetLuminosity(6)

/obj/structure/prop/brazier/torch
	name = "torch"
	desc = "It's a torch."
	icon_state = "torch"
	density = FALSE

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
	name = "poly_kevlon roll"
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
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/prop/vehicles/crawler
	name = "colony crawler"
	desc = "It is a tread bound crawler used in harsh conditions. Supplied by Orbital Blue International; 'Your friends, in the Aerospace business.' A subsidiary of Weyland Yutani."
	icon_state = "crawler"
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
		fallen_list_cross -= dogtag_name
	return ..()

/obj/structure/prop/wooden_cross/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/dogtag))
		var/obj/item/dogtag/dog = W
		if(!tagged)
			tagged = TRUE
			user.visible_message(SPAN_NOTICE("[user] drapes the [W] around the [src]."))
			dogtag_name = popleft(dog.fallen_names)
			dogtag_assign = popleft(dog.fallen_assgns)
			dogtag_blood = popleft(dog.fallen_blood_types)
			fallen_list_cross += dogtag_name
			update_icon()
			if(!length(dog.fallen_names))
				qdel(dog)
			else
				return
		else
			to_chat(user, SPAN_WARNING("There's already a dog tag on the [src]!"))
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
