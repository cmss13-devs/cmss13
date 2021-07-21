/obj/structure/prop/tower
	name = "destroyed comms tower"
	desc = "An old company comms tower used to transmit communications between subspace bodies. Looks like this one has seen better days."
	icon = 'icons/obj/structures/machinery/comm_tower.dmi'
	icon_state = "comm_tower_destroyed"
	unslashable = TRUE
	unacidable = TRUE
	density = 1
	layer = ABOVE_FLY_LAYER
	bound_height = 96

/obj/structure/prop/dam
	density = 1

/obj/structure/prop/dam/drill
	name = "mining drill"
	desc = "An old mining drill, seemingly used for mining. And possibly drilling."
	icon = 'icons/obj/structures/props/drill.dmi'
	icon_state = "drill"
	bound_height = 96

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
	desc = "A traditional japanese archway, made out of wood, and adorned with lanterns."
	icon = 'icons/obj/structures/props/torii.dmi'
	icon_state = "torii"
	density = 0
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
	if(istype(W, /obj/item/tool/weldingtool))
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
	desc = "A grave marker, in the traditional japanese style."
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
	density = 0
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

/obj/structure/prop/structure_lattice //instance me by direction for color variants
	name = "structural lattice"
	desc = "Like rebar, but in space."
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "structure_lattice"
	density = 1 //impassable by default


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

/obj/structure/prop/invuln/lifeboat_hatch_placeholder
	density = 0
	name = "non-functional hatch"
	desc = "You'll need more than a prybar for this one."
	icon = 'icons/obj/structures/machinery/bolt_target.dmi'

/obj/structure/prop/invuln/lifeboat_hatch_placeholder/terminal
	icon = 'icons/obj/structures/machinery/bolt_terminal.dmi'

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
	desc = "Some sort of doohicky that measures stuff."
	icon_state = "measuring_device"

/obj/structure/prop/ice_colony/dense
	health = 75
	density = 1

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
	density = 0
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


//INVULNERABLE PROPS

/obj/structure/prop/invuln
	layer = ABOVE_MOB_LAYER
	density = 1
	icon = 'icons/obj/structures/props/ice_colony/props.dmi'
	icon_state = "ice_tray"

/obj/structure/prop/invuln/catwalk_support
	name = "support lattice"
	icon_state = "support_lattice"
	desc = "The middle of a large set of steel support girders."
	density = 0

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
	density = 1

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
	density = 1
	layer = 3
	bound_width = 64
	bound_height = 64

/obj/structure/prop/invuln/ice_prefab/trim
	layer = ABOVE_MOB_LAYER
	density = 0

/obj/structure/prop/invuln/ice_prefab/roof_greeble
	icon = 'icons/obj/structures/props/ice_colony/fabs_greebles.dmi'
	icon_state = "antenna"
	layer = ABOVE_MOB_LAYER
	desc = "Windsocks, Air-Con units, solarpanels, oh my!"
	density = FALSE

/obj/structure/prop/invuln/ice_prefab/standalone
	density = 1
	icon = 'icons/obj/structures/props/ice_colony/fabs_64.dmi'
	icon_state = "orange"//instance icons
	layer = 3

/obj/structure/prop/invuln/ice_prefab/standalone/trim
	icon_state = "orange_trim"//instance icons
	layer = ABOVE_MOB_LAYER
	density = 0

