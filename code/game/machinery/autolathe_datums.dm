/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden = FALSE
	var/category
	var/power_use = 0
	var/is_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/reagent_container/glass/bucket
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/mopbucket
	name = "mop bucket"
	path = /obj/item/reagent_container/glass/bucket/mopbucket
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/mopbucket
	name = "janitorial bucket"
	path = /obj/item/reagent_container/glass/bucket/janibucket
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/tool/extinguisher
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/tool/crowbar
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/weldertool
	name = "blowtorch"
	path = /obj/item/tool/weldingtool
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/tool/screwdriver
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/tool/wirecutters
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/tool/wrench
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/mop
	name = "mop"
	path = /obj/item/tool/mop
	category = AUTOLATHE_CATEGORY_TOOLS

/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/radio_bounced
	name = "shortwave radio"
	path = /obj/item/device/radio/off
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/sheet/metal
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/sheet/glass
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/sheet/glass/reinforced
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/rods
	name = "metal rods"
	path = /obj/item/stack/rods
	category = AUTOLATHE_CATEGORY_GENERAL
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/tool/kitchen/knife
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/circuitboard/airlock
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/circuitboard/firealarm
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/circuitboard/apc
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/rcd_ammo
	name = "matter cartridge"
	path = /obj/item/ammo_rcd
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/table_parts
	name = "table parts"
	path = /obj/item/frame/table
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/table_parts_reinforced
	name = "reinforced table parts"
	path = /obj/item/frame/table/reinforced
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/rack_parts
	name = "rack parts"
	path = /obj/item/frame/rack
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/tool/surgery/scalpel
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/tool/surgery/circular_saw
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/tool/surgery/surgicaldrill
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/tool/surgery/retractor
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/tool/surgery/cautery
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/tool/surgery/hemostat
	category = AUTOLATHE_CATEGORY_SURGERY

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/reagent_container/glass/beaker
	category = AUTOLATHE_CATEGORY_GLASSWARE

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/reagent_container/glass/beaker/large
	category = AUTOLATHE_CATEGORY_GLASSWARE

/datum/autolathe/recipe/drinkingglass
	name = "drinking glass"
	path = /obj/item/reagent_container/food/drinks/drinkingglass
	category = AUTOLATHE_CATEGORY_GLASSWARE

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/stock_parts/console_screen
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/signaller
	name = "signaller"
	path = /obj/item/device/assembly/signaller
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/light_bulb/tube
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/light_bulb/bulb
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/ashtray/glass
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/hand_labeler
	name = "hand labeler"
	path = /obj/item/tool/hand_labeler
	category = AUTOLATHE_CATEGORY_GENERAL

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/frame/camera
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/matrix_frame
	name = "matrix assembly"
	path = /obj/item/frame/matrix_frame
	category = AUTOLATHE_CATEGORY_ENGINEERING

/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = TRUE
	category = AUTOLATHE_CATEGORY_DEVICES_AND_COMPONENTS

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/restraint/handcuffs
	hidden = TRUE
	category = AUTOLATHE_CATEGORY_GENERAL

//Armylathe recipes
/datum/autolathe/recipe/armylathe

/datum/autolathe/recipe/armylathe/m40
	name = "M40 Grenade Casing"
	path = /obj/item/explosive/grenade/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/m15
	name = "M15 Grenade Casing"
	path = /obj/item/explosive/grenade/custom/large
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/m20
	name = "M20 Mine Casing"
	path = /obj/item/explosive/mine/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/c4
	name = "C4 Plastic Casing"
	path = /obj/item/explosive/plastic/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/rocket_tube
	name = "88mm Rocket Tube"
	path = /obj/item/ammo_magazine/rocket/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/rocket_warhead
	name = "88mm Rocket Warhead"
	path = /obj/item/explosive/warhead/rocket
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/mortar_shell
	name = "80mm Mortar Shell"
	path = /obj/item/mortar_shell/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/mortar_warhead
	name = "80mm Mortar Warhead"
	path = /obj/item/explosive/warhead/mortar
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/mortar_camera_warhead
	name = "80mm Mortar Camera Warhead"
	path = /obj/item/explosive/warhead/mortar/camera
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/flamer_tank
	name = "Custom M240A1 Fuel Tank"
	path = /obj/item/ammo_magazine/flamer_tank/custom
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/large_flamer_tank
	name = "Custom M240-T Fuel Tank"
	path = /obj/item/ammo_magazine/flamer_tank/custom/large
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

/datum/autolathe/recipe/armylathe/smoke_tank
	name = "Custom M240A1 Smoke Tank"
	path = /obj/item/ammo_magazine/flamer_tank/smoke
	category = AUTOLATHE_CATEGORY_EXPLOSIVES

//Medilathe recipes
/datum/autolathe/recipe/medilathe
	category = AUTOLATHE_CATEGORY_MEDICAL

/datum/autolathe/recipe/medilathe/syringe
	name = "syringe"
	path = /obj/item/reagent_container/syringe

/datum/autolathe/recipe/medilathe/dropper
	name = "dropper"
	path = /obj/item/reagent_container/dropper

/datum/autolathe/recipe/medilathe/spray
	name = "spray bottle"
	path = /obj/item/reagent_container/spray

/datum/autolathe/recipe/medilathe/autoinjector
	name = "autoinjector (C-T) (5x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty
	category = AUTOLATHE_CATEGORY_INJECTORS

/datum/autolathe/recipe/medilathe/autoinjector/s15x3
	name = "autoinjector (C-S) (15x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/small

/datum/autolathe/recipe/medilathe/autoinjector/s30x3
	name = "autoinjector (C-M) (30x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medium

/datum/autolathe/recipe/medilathe/autoinjector/s60x3
	name = "autoinjector (C-L) (60x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/large

/datum/autolathe/recipe/medilathe/autoinjector/s1x1
	name = "EZ autoinjector (E-U) (1x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/unit

/datum/autolathe/recipe/medilathe/autoinjector/s5x1
	name = "EZ autoinjector (E-VS) (5x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/verysmall

/datum/autolathe/recipe/medilathe/autoinjector/s10x1
	name = "EZ autoinjector (E-S) (10x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small

/datum/autolathe/recipe/medilathe/autoinjector/s15x1
	name = "EZ autoinjector (E-T) (15x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless

/datum/autolathe/recipe/medilathe/autoinjector/s30x1
	name = "EZ autoinjector (E-M) (30x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/medium

/datum/autolathe/recipe/medilathe/autoinjector/s45x1
	name = "EZ autoinjector (E-L) (45x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/large

/datum/autolathe/recipe/medilathe/autoinjector/s60x1
	name = "EZ autoinjector (E-XL) (60x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/extralarge

/datum/autolathe/recipe/medilathe/autoinjector/s15x6
	name = "Medic autoinjector (M-M) (15x6)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medic

/datum/autolathe/recipe/medilathe/autoinjector/s30x6
	name = "Medic Autoinjector (M-L) (30x6)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medic/large

/datum/autolathe/recipe/medilathe/hypospray
	name = "hypospray"
	path = /obj/item/reagent_container/hypospray

/datum/autolathe/recipe/medilathe/bloodpack
	name = "bloodpack"
	path = /obj/item/reagent_container/blood

/datum/autolathe/recipe/medilathe/bluespace
	name = "high-capacity beaker"
	path = /obj/item/reagent_container/glass/beaker/bluespace

/datum/autolathe/recipe/medilathe/bonesetter
	name = "bonesetter"
	path = /obj/item/tool/surgery/bonesetter

/datum/autolathe/recipe/medilathe/fixovein
	name = "FixOVein"
	path = /obj/item/tool/surgery/FixOVein

/datum/autolathe/recipe/medilathe/cryobag
	name = "stasis bag"
	path = /obj/item/bodybag/cryobag

/datum/autolathe/recipe/medilathe/rollerbed
	name = "rollerbed"
	path = /obj/item/roller

/datum/autolathe/recipe/medilathe/pill_bottle
	name = "pill bottle"
	path = /obj/item/storage/pill_bottle
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_regular
	name = "first aid kit (reg)"
	path = /obj/item/storage/firstaid/regular/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_fire
	name = "first aid kit (fire)"
	path = /obj/item/storage/firstaid/fire/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_toxin
	name = "first aid kit (tox)"
	path = /obj/item/storage/firstaid/toxin/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_oxy
	name = "first aid kit (oxy)"
	path = /obj/item/storage/firstaid/o2/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_adv
	name = "first aid kit (adv)"
	path = /obj/item/storage/firstaid/adv/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/firstaid_rad
	name = "first aid kit (rad)"
	path = /obj/item/storage/firstaid/rad/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/syringe_case
	name = "syringe case"
	path = /obj/item/storage/syringe_case
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/surgical_case
	name = "surgical case"
	path = /obj/item/storage/surgical_case
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/vial_box
	name = "vial box"
	path = /obj/item/storage/fancy/vials/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/surgical_tray
	name = "surgical tray"
	path = /obj/item/storage/surgical_tray/empty
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/pressurized_reagent_container
	name = "Pressurized Reagent Canister Pouch"
	path = /obj/item/storage/pouch/pressurized_reagent_canister
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS

/datum/autolathe/recipe/medilathe/pressurized_canister
	name = "Pressurized Canister"
	path = /obj/item/reagent_container/glass/pressurized_canister
	category = AUTOLATHE_CATEGORY_MEDICAL_CONTAINERS
