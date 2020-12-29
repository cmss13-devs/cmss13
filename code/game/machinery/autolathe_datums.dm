/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/reagent_container/glass/bucket
	category = "General"

/datum/autolathe/recipe/mopbucket
	name = "mop bucket"
	path = /obj/item/reagent_container/glass/bucket/mopbucket
	category = "General"

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight
	category = "General"

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/tool/extinguisher
	category = "General"

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/tool/crowbar
	category = "Tools"

/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = "Tools"

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = "Tools"

/datum/autolathe/recipe/weldertool
	name = "blowtorch"
	path = /obj/item/tool/weldingtool
	category = "Tools"

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/tool/screwdriver
	category = "Tools"

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/tool/wirecutters
	category = "Tools"

/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/tool/wrench
	category = "Tools"

/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset
	category = "General"

/datum/autolathe/recipe/radio_bounced
	name = "station bounced radio"
	path = /obj/item/device/radio/off
	category = "General"

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = "General"

/datum/autolathe/recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/sheet/metal
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/sheet/glass
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/sheet/glass/reinforced
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/rods
	name = "metal rods"
	path = /obj/item/stack/rods
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/tool/kitchen/knife
	category = "General"

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder
	category = "General"

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/circuitboard/airlock
	category = "Engineering"

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/circuitboard/firealarm
	category = "Engineering"

/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/circuitboard/apc
	category = "Engineering"

/datum/autolathe/recipe/rcd_ammo
	name = "matter cartridge"
	path = /obj/item/ammo_rcd
	category = "Engineering"

/datum/autolathe/recipe/table_parts
	name = "table parts"
	path = /obj/item/frame/table
	category = "Engineering"

/datum/autolathe/recipe/table_parts_reinforced
	name = "reinforced table parts"
	path = /obj/item/frame/table/reinforced
	category = "Engineering"

/datum/autolathe/recipe/rack_parts
	name = "rack parts"
	path = /obj/item/frame/rack
	category = "Engineering"

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/tool/surgery/scalpel
	category = "Surgery"

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/tool/surgery/circular_saw
	category = "Surgery"

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/tool/surgery/surgicaldrill
	category = "Surgery"

/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/tool/surgery/retractor
	category = "Surgery"

/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/tool/surgery/cautery
	category = "Surgery"

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/tool/surgery/hemostat
	category = "Surgery"

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/reagent_container/glass/beaker
	category = "Glassware"

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/reagent_container/glass/beaker/large
	category = "Glassware"

/datum/autolathe/recipe/drinkingglass
	name = "drinking glass"
	path = /obj/item/reagent_container/food/drinks/drinkingglass
	category = "Glassware"

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/stock_parts/console_screen
	category = "Devices and Components"

/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = "Devices and Components"

/datum/autolathe/recipe/signaller
	name = "signaller"
	path = /obj/item/device/assembly/signaller
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = "Devices and Components"

/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = "Devices and Components"

/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/light_bulb/tube
	category = "General"

/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/light_bulb/bulb
	category = "General"

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/ashtray/glass
	category = "General"

/datum/autolathe/recipe/hand_labeler
	name = "hand labeler"
	path = /obj/item/tool/hand_labeler
	category = "General"

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/frame/camera
	category = "Engineering"
/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/welder_industrial
	name = "industrial blowtorch"
	path = /obj/item/tool/weldingtool/largetank
	hidden = 1
	category = "Tools"

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/handcuffs
	hidden = 1
	category = "General"

//Armylathe recipes
/datum/autolathe/recipe/armylathe

/datum/autolathe/recipe/armylathe/m40
	name = "M40 Grenade Casing"
	path = /obj/item/explosive/grenade/custom
	category = "Explosives"

/datum/autolathe/recipe/armylathe/m15
	name = "M15 Grenade Casing"
	path = /obj/item/explosive/grenade/custom/large
	category = "Explosives"

/datum/autolathe/recipe/armylathe/m20
	name = "M20 Mine Casing"
	path = /obj/item/explosive/mine/custom
	category = "Explosives"

/datum/autolathe/recipe/armylathe/c4
	name = "C4 Plastic Casing"
	path = /obj/item/explosive/plastic/custom
	category = "Explosives"

/datum/autolathe/recipe/armylathe/rocket_tube
	name = "88mm Rocket Tube"
	path = /obj/item/ammo_magazine/rocket/custom
	category = "Explosives"

/datum/autolathe/recipe/armylathe/rocket_warhead
	name = "88mm Rocket Warhead"
	path = /obj/item/explosive/warhead/rocket
	category = "Explosives"

/datum/autolathe/recipe/armylathe/mortar_shell
	name = "80mm Mortar Shell"
	path = /obj/item/mortar_shell/custom
	category = "Explosives"

/datum/autolathe/recipe/armylathe/mortar_warhead
	name = "80mm Mortar Warhead"
	path = /obj/item/explosive/warhead/mortar
	category = "Explosives"

//Medilathe recipes
/datum/autolathe/recipe/medilathe
	category = "Medical"

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
	category = "Injectors"

/datum/autolathe/recipe/medilathe/autoinjector/s15x3
	name = "autoinjector (C-S) (15x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/small

/datum/autolathe/recipe/medilathe/autoinjector/s30x3
	name = "autoinjector (C-M) (30x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medium

datum/autolathe/recipe/medilathe/autoinjector/s60x3
	name = "autoinjector (C-L) (60x3)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/large

datum/autolathe/recipe/medilathe/autoinjector/s15x1
	name = "EZ autoinjector (E-T) (15x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless

datum/autolathe/recipe/medilathe/autoinjector/s45x1
	name = "EZ autoinjector (E-S) (45x1)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/skillless/small

datum/autolathe/recipe/medilathe/autoinjector/s15x6
	name = "Medic autoinjector (M-M) (15x6)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medic

datum/autolathe/recipe/medilathe/autoinjector/s30x6
	name = "Medic Autoinjector (M-L) (30x6)"
	path = /obj/item/reagent_container/hypospray/autoinjector/empty/medic/large

/datum/autolathe/recipe/medilathe/hypospray
	name = "hypospray"
	path = /obj/item/reagent_container/hypospray

/datum/autolathe/recipe/medilathe/bloodpack
	name = "bloodpack"
	path = /obj/item/reagent_container/blood

/datum/autolathe/recipe/medilathe/bluespace
	name = "bluespace beaker"
	path = /obj/item/reagent_container/glass/beaker/bluespace

/datum/autolathe/recipe/medilathe/bonesetter
	name = "bonesetter"
	path = /obj/item/tool/surgery/bonesetter

/datum/autolathe/recipe/medilathe/cryobag
	name = "stasis bag"
	path = /obj/item/bodybag/cryobag

/datum/autolathe/recipe/medilathe/rollerbed
	name = "rollerbed"
	path = /obj/item/roller

/datum/autolathe/recipe/medilathe/pill_bottle
	name = "pill bottle"
	path = /obj/item/storage/pill_bottle
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/firstaid_regular
	name = "first aid kit (reg)"
	path = /obj/item/storage/firstaid/regular/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/firstaid_fire
	name = "first aid kit (fire)"
	path = /obj/item/storage/firstaid/fire/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/firstaid_toxin
	name = "first aid kit (tox)"
	path = /obj/item/storage/firstaid/toxin/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/firstaid_oxy
	name = "first aid kit (oxy)"
	path = /obj/item/storage/firstaid/o2/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/firstaid_adv
	name = "first aid kit (adv)"
	path = /obj/item/storage/firstaid/adv/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/firstaid_rad
	name = "first aid kit (rad)"
	path = /obj/item/storage/firstaid/rad/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/syringe_case
	name = "syringe case"
	path = /obj/item/storage/syringe_case
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/vial_box
	name = "vial box"
	path = /obj/item/storage/fancy/vials/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/surgical_tray
	name = "surgical tray"
	path = /obj/item/storage/surgical_tray/empty
	category = "Medical Containers"

/datum/autolathe/recipe/medilathe/pressurized_reagent_container
	name = "Pressurized Reagent Container"
	path = /obj/item/storage/pouch/pressurized_reagent_canister
	category = "Medical Containers"
