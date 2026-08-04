// --- Weapons (Bundled with ammo to artificially inflate costs to make it a bit more penalizing to lose them.) ---

/datum/supply_packs/arcsentry_replacement
	name = "Replacement RE700 Rotary Cannon (x1)"
	contains = list(
		/obj/item/hardpoint/primary/arc_sentry,
	)
	cost = 25
	containertype = /obj/structure/closet/crate/weapon
	containername = "RE700 Rotary Cannon crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_primary_flamer
	name = "Replacement DRG-N Offensive Flamer Unit (x1)"
	contains = list(
		/obj/item/hardpoint/primary/flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
	)
	cost = 45 // ammo_drgn_flamer (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "DRG-N Offensive Flamer Unit crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_ltb_cannon
	name = "Replacement LTB Cannon (x1)"
	contains = list(
		/obj/item/hardpoint/primary/cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon/he_shell,
	)
	cost = 45 // ammo_ltb_cannon (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "LTB Cannon crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_minigun
	name = "Replacement LTAA-AP Minigun (x1)"
	contains = list(
		/obj/item/hardpoint/primary/minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
	)
	cost = 45 // ammo_ltaaap_minigun (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "LTAA-AP Minigun crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_autocannon
	name = "Replacement AC3-E Autocannon (x1)"
	contains = list(
		/obj/item/hardpoint/primary/autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
	)
	cost = 45 // ammo_ace_autocannon (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "AC3-E Autocannon crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_small_flamer
	name = "Replacement LZR-N Flamer Unit (x1)"
	contains = list(
		/obj/item/hardpoint/secondary/small_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
	)
	cost = 35 // tank_flamer_ammo (20) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "LZR-N Flamer Unit crate"
	group = "Vehicle Equipment"

/* Commenting this out since the TOW wasn't really touched by Desant yet.
/datum/supply_packs/tank_spare_towlauncher
	name = "Replacement TOW Launcher (x1)"
	contains = list(
		/obj/item/hardpoint/secondary/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
	)
	cost = 45 // ammo_towlauncher (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "TOW Launcher crate"
	group = "Vehicle Equipment"
*/

/datum/supply_packs/tank_spare_m56cupola
	name = "Replacement M56 Cupola (x1)"
	contains = list(
		/obj/item/hardpoint/secondary/m56cupola,
		/obj/item/ammo_magazine/m56d,
	)
	cost = 35 // ammo_m56_cupola (20) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "M56 Cupola crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_grenade_launcher
	name = "Replacement M92T Grenade Launcher (x1)"
	contains = list(
		/obj/item/hardpoint/secondary/grenade_launcher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
	)
	cost = 35 // ammo_glauncher (20) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "M92T Grenade Launcher crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_brute_launcher
	name = "Replacement M6H-BRUTE Launcher (x1)"
	contains = list(
		/obj/item/hardpoint/secondary/brute_launcher,
		/obj/item/ammo_magazine/rocket/brute,
		/obj/item/ammo_magazine/rocket/brute,
		/obj/item/ammo_magazine/rocket/brute,
		/obj/item/ammo_magazine/rocket/brute,
		/obj/item/ammo_magazine/rocket/brute,
		/obj/item/ammo_magazine/rocket/brute,
	)
	cost = 45 // brute_rockets (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "M6H-BRUTE Launcher crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_flag_mount
	name = "Replacement United Americas Flag Mount (x1)"
	contains = list(/obj/item/hardpoint/secondary/united_americas_flag)
	cost = 20
	containertype = /obj/structure/closet/crate/weapon
	containername = "United Americas Flag Mount crate"
	group = "Vehicle Equipment"

/datum/supply_packs/apc_spare_dualcannon
	name = "Replacement PARS-159 Boyars Dualcannon (x1)"
	contains = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
	)
	cost = 45 // ammo_dualcannon (30) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "PARS-159 Boyars Dualcannon crate"
	group = "Vehicle Equipment"

/datum/supply_packs/apc_spare_frontalcannon
	name = "Replacement Bleihagel RE-RE700 Frontal Cannon (x1)"
	contains = list(
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon,
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon,
	)
	cost = 35 // ammo_frontalcannon (20) + 15 hardware premium
	containertype = /obj/structure/closet/crate/weapon
	containername = "Bleihagel RE-RE700 Frontal Cannon crate"
	group = "Vehicle Equipment"

// --- Structural/utility hardpoints ---

/datum/supply_packs/tank_spare_turret_mount
	name = "Replacement Turret Mount (x1)"
	contains = list(/obj/item/hardpoint/holder/tank_turret)
	cost = 25 // bare weapon-mounting socket, no weapon included
	containertype = /obj/structure/closet/crate/construction
	containername = "Turret Mount crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_engine
	name = "Replacement Engine (x1)"
	contains = list(/obj/item/hardpoint/engine/tank)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Engine crate"
	group = "Vehicle Equipment"

/datum/supply_packs/apc_spare_engine
	name = "Replacement APC Engine (x1)"
	contains = list(/obj/item/hardpoint/engine/apc)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "APC Engine crate"
	group = "Vehicle Equipment"

/datum/supply_packs/arc_spare_engine
	name = "Replacement ARC Engine (x1)"
	contains = list(/obj/item/hardpoint/engine/arc)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "ARC Engine crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_fuel_tank
	name = "Replacement Fuel Tank (x1)"
	contains = list(/obj/item/hardpoint/fuel_tank/uscm)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "Fuel Tank crate"
	group = "Vehicle Equipment"

/datum/supply_packs/arc_spare_fuel_tank
	name = "Replacement ARC Fuel Tank (x1)"
	contains = list(/obj/item/hardpoint/fuel_tank/arc)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "ARC Fuel Tank crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_radiator
	name = "Replacement Radiator (x1)"
	contains = list(/obj/item/hardpoint/radiator/uscm)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "Radiator crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_battery
	name = "Replacement Battery (x1)"
	contains = list(/obj/item/hardpoint/battery/uscm)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "Battery crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_hatch
	name = "Replacement Hatch (x1)"
	contains = list(/obj/item/hardpoint/hatch/armored/uscm)
	cost = 5
	containertype = /obj/structure/closet/crate/construction
	containername = "Hatch crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_iff_module
	name = "Replacement IFF Module (x1)"
	contains = list(/obj/item/hardpoint/iff_module/uscm)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "IFF Module crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_visual_sensors
	name = "Replacement Visual Sensors (x1)"
	contains = list(/obj/item/hardpoint/visual_sensors/uscm)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "Visual Sensors crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_turret_ring
	name = "Replacement Turret Ring (x1)"
	contains = list(/obj/item/hardpoint/turret_ring/uscm)
	cost = 10
	containertype = /obj/structure/closet/crate/construction
	containername = "Turret Ring crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_air_filter
	name = "Replacement Air Filter (x1)"
	contains = list(/obj/item/hardpoint/air_filter/uscm)
	cost = 5
	containertype = /obj/structure/closet/crate/construction
	containername = "Air Filter crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_treads
	name = "Replacement Treads (x1)"
	contains = list(/obj/item/hardpoint/locomotion/treads)
	cost = 15
	containertype = /obj/structure/closet/crate/construction
	containername = "Treads crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_treads_robust
	name = "Replacement Reinforced Treads (x1)"
	contains = list(/obj/item/hardpoint/locomotion/treads/robust)
	cost = 15
	containertype = /obj/structure/closet/crate/construction
	containername = "Reinforced Treads crate"
	group = "Vehicle Equipment"

/datum/supply_packs/apc_spare_wheels
	name = "Replacement APC Wheels (x1)"
	contains = list(/obj/item/hardpoint/locomotion/apc_wheels)
	cost = 15
	containertype = /obj/structure/closet/crate/construction
	containername = "APC Wheels crate"
	group = "Vehicle Equipment"

/datum/supply_packs/arc_spare_wheels
	name = "Replacement ARC Wheels (x1)"
	contains = list(/obj/item/hardpoint/locomotion/arc_wheels)
	cost = 15
	containertype = /obj/structure/closet/crate/construction
	containername = "ARC Wheels crate"
	group = "Vehicle Equipment"

// --- Armor plating  ---

/datum/supply_packs/tank_spare_armor_ballistic
	name = "Ballistic Armor Plating (x1)"
	contains = list(/obj/item/hardpoint/armor/ballistic)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Ballistic Armor Plating crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_armor_caustic
	name = "Caustic-Resistant Armor Plating (x1)"
	contains = list(/obj/item/hardpoint/armor/caustic)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Caustic-Resistant Armor Plating crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_armor_concussive
	name = "Concussive-Dampening Armor Plating (x1)"
	contains = list(/obj/item/hardpoint/armor/concussive)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Concussive-Dampening Armor Plating crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_armor_paladin
	name = "Paladin Armor Plating (x1)"
	contains = list(/obj/item/hardpoint/armor/paladin)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Paladin Armor Plating crate"
	group = "Vehicle Equipment"

// --- Not armor, just a utility bumper in its own hardpoint slot ---

/datum/supply_packs/tank_spare_armor_snowplow
	name = "Snowplow (x1)"
	contains = list(/obj/item/hardpoint/snowplow)
	cost = 5
	containertype = /obj/structure/closet/crate/construction
	containername = "Snowplow crate"
	group = "Vehicle Equipment"

// --- Support modules ---

/datum/supply_packs/tank_spare_overdrive
	name = "Overdrive Enhancer (x1)"
	contains = list(/obj/item/hardpoint/support/overdrive_enhancer)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Overdrive Enhancer crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_iwsa
	name = "Integrated Weapons Sensor Array (x1)"
	contains = list(/obj/item/hardpoint/support/weapons_sensor)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Integrated Weapons Sensor Array crate"
	group = "Vehicle Equipment"

/datum/supply_packs/tank_spare_artillery_module
	name = "Artillery Module (x1)"
	contains = list(/obj/item/hardpoint/support/artillery_module)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "Artillery Module crate"
	group = "Vehicle Equipment"

/datum/supply_packs/apc_spare_flare_launcher
	name = "Replacement M-87F Flare Launcher (x1)"
	contains = list(/obj/item/hardpoint/support/flare_launcher)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "M-87F Flare Launcher crate"
	group = "Vehicle Equipment"

/datum/supply_packs/arc_spare_antenna
	name = "Replacement U-56 Radar Antenna (x1)"
	contains = list(/obj/item/hardpoint/support/arc_antenna)
	cost = 20
	containertype = /obj/structure/closet/crate/construction
	containername = "U-56 Radar Antenna crate"
	group = "Vehicle Equipment"
