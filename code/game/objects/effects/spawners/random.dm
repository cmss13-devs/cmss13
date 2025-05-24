/obj/effect/spawner/random
	name = "Random Object"
	desc = "This item type is used to spawn random objects at round-start"
	icon = 'icons/landmarks.dmi'
	icon_state = "x3"
	var/spawn_nothing_percentage = 0 // this variable determines the likelyhood that this random object will not spawn anything
	var/spawn_on_roundstart = FALSE

// creates a new object and deletes itself
/obj/effect/spawner/random/Initialize()
	. = ..()

	if(!prob(spawn_nothing_percentage))
		if(spawn_on_roundstart)
			alpha = 0
			return INITIALIZE_HINT_ROUNDSTART
		else
			spawn_item()

	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/random/LateInitialize()
	spawn_item()
	qdel(src)

// this function should return a specific item to spawn
/obj/effect/spawner/random/proc/item_to_spawn()
	return 0


// creates the random item
/obj/effect/spawner/random/proc/spawn_item()
	var/build_path = item_to_spawn()
	if(!ispath(build_path))
		return
	return (new build_path(src.loc))


/obj/effect/spawner/random/tool
	name = "Random Tool"
	desc = "This is a random tool"
	icon_state = "random_tool"

/obj/effect/spawner/random/tool/item_to_spawn()
	return pick(/obj/item/tool/screwdriver,\
				/obj/item/tool/wirecutters,\
				/obj/item/tool/weldingtool,\
				/obj/item/tool/crowbar,\
				/obj/item/tool/wrench,\
				/obj/item/device/flashlight)


/obj/effect/spawner/random/technology_scanner
	name = "Random Scanner"
	desc = "This is a random technology scanner."
	icon = 'icons/obj/items/devices.dmi'
	icon_state = "atmos"

/obj/effect/spawner/random/technology_scanner/item_to_spawn()
	return pick_weight(list(
		"none" = 10,
		/obj/item/device/t_scanner = 10,
		/obj/item/device/radio = 8,
		/obj/item/device/analyzer = 10,
		/obj/item/device/black_market_hacking_device = 2,
	))

/obj/effect/spawner/random/powercell
	name = "Random Powercell"
	desc = "This is a random powercell."
	icon_state = "random_cell_battery"

/obj/effect/spawner/random/powercell/item_to_spawn()
	return pick(prob(10);/obj/item/cell/crap,\
				prob(40);/obj/item/cell,\
				prob(40);/obj/item/cell/high,\
				prob(9);/obj/item/cell/super,\
				prob(1);/obj/item/cell/hyper)


/obj/effect/spawner/random/bomb_supply
	name = "Bomb Supply"
	desc = "This is a random bomb supply."
	icon = 'icons/obj/items/new_assemblies.dmi'
	icon_state = "signaller"

/obj/effect/spawner/random/bomb_supply/item_to_spawn()
	return pick(/obj/item/device/assembly/igniter,\
				/obj/item/device/assembly/prox_sensor,\
				/obj/item/device/assembly/signaller,\
				/obj/item/device/multitool)


/obj/effect/spawner/random/toolbox
	name = "Random Toolbox"
	desc = "This is a random toolbox."
	icon_state = "random_toolbox"

/obj/effect/spawner/random/toolbox/item_to_spawn()
	return pick(prob(3);/obj/item/storage/toolbox/mechanical,\
				prob(2);/obj/item/storage/toolbox/electrical,\
				prob(2);/obj/item/storage/toolbox/mechanical/green,\
				prob(1);/obj/item/storage/toolbox/emergency)


/obj/effect/spawner/random/tech_supply
	name = "Random Tech Supply"
	desc = "This is a random piece of technology supplies."
	icon = 'icons/obj/structures/machinery/power.dmi'
	icon_state = "cell"
	spawn_nothing_percentage = 50

/obj/effect/spawner/random/tech_supply/item_to_spawn()
	return pick(prob(3);/obj/effect/spawner/random/powercell,\
				prob(2);/obj/effect/spawner/random/technology_scanner,\
				prob(1);/obj/item/packageWrap,\
				prob(2);/obj/effect/spawner/random/bomb_supply,\
				prob(1);/obj/item/tool/extinguisher,\
				prob(1);/obj/item/clothing/gloves/fyellow,\
				prob(3);/obj/item/stack/cable_coil,\
				prob(2);/obj/effect/spawner/random/toolbox,\
				prob(2);/obj/item/storage/belt/utility,\
				prob(5);/obj/effect/spawner/random/tool)


/obj/effect/spawner/random/attachment
	name = "Random Attachment"
	desc = "This is a random attachment"
	icon_state = "random_attachment"

/obj/effect/spawner/random/attachment/item_to_spawn()
	return pick(prob(3);/obj/item/attachable/flashlight,\
				prob(3);/obj/item/attachable/reddot,\
				prob(3);/obj/item/attachable/extended_barrel,\
				prob(3);/obj/item/attachable/magnetic_harness,\
				prob(2);/obj/item/attachable/flashlight/grip,\
				prob(2);/obj/item/attachable/suppressor,\
				prob(2);/obj/item/attachable/burstfire_assembly,\
				prob(2);/obj/item/attachable/compensator,\
				prob(1);/obj/item/attachable/alt_iff_scope,\
				prob(1);/obj/item/attachable/heavy_barrel,\
				prob(1);/obj/item/attachable/scope/mini)

/obj/effect/spawner/random/balaclavas
	name = "Random Balaclava"
	desc = "This is a randomly chosen balaclava."
	icon_state = "loot_goggles"
	spawn_nothing_percentage = 50

/obj/effect/spawner/random/balaclavas/item_to_spawn()
	return pick(prob(100);/obj/item/clothing/mask/balaclava,\
				prob(50);/obj/item/clothing/mask/balaclava/tactical,\
				prob(25);/obj/item/clothing/mask/rebreather/scarf/green,\
				prob(25);/obj/item/clothing/mask/rebreather/scarf/gray,\
				prob(25);/obj/item/clothing/mask/rebreather/scarf/tan,\
				prob(10);/obj/item/clothing/mask/rebreather/skull,\
				prob(10);/obj/item/clothing/mask/rebreather/skull/black)

///If anyone wants to make custom sprites for this and the bala random spawner, be my guest.
/obj/effect/spawner/random/facepaint
	name = "Random Facepaint"
	desc = "This is a randomly chosen facepaint."
	icon_state = "loot_goggles"
	spawn_nothing_percentage = 50

/obj/effect/spawner/random/facepaint/item_to_spawn()
	return pick(prob(100);/obj/item/facepaint/black,\
				prob(50);/obj/item/facepaint/green,\
				prob(25);/obj/item/facepaint/brown,\
				prob(25);/obj/item/facepaint/sunscreen_stick,\
				prob(10);/obj/item/facepaint/sniper,\
				prob(10);/obj/item/facepaint/skull)

/obj/effect/spawner/random/supply_kit
	name = "Random Supply Kit"
	desc = "This is a random kit."
	icon_state = "random_kit"

/obj/effect/spawner/random/supply_kit/item_to_spawn()
	return pick(prob(3);/obj/item/storage/box/kit/pursuit,\
				prob(3);/obj/item/storage/box/kit/self_defense,\
				prob(3);/obj/item/storage/box/kit/mini_medic,\
				prob(2);/obj/item/storage/box/kit/mou53_sapper,\
				prob(1);/obj/item/storage/box/kit/heavy_support)

/obj/effect/spawner/random/supply_kit/market/item_to_spawn()
	return pick(prob(3);/obj/item/storage/box/kit/pursuit,\
				prob(3);/obj/item/storage/box/kit/mini_intel,\
				prob(3);/obj/item/storage/box/kit/mini_jtac,\
				prob(2);/obj/item/storage/box/kit/mou53_sapper,\
				prob(1);/obj/item/storage/box/kit/heavy_support)

/obj/effect/spawner/random/toy
	name = "Random Toy"
	desc = "This is a random toy."
	icon_state = "ipool"

/obj/effect/spawner/random/toy/item_to_spawn()
	return pick(/obj/item/storage/wallet,\
				/obj/item/storage/photo_album,\
				/obj/item/storage/box/snappops,\
				/obj/item/storage/fancy/crayons,\
				/obj/item/storage/belt/champion,\
				/obj/item/tool/soap/deluxe,\
				/obj/item/tool/pickaxe/silver,\
				/obj/item/tool/pen/white,\
				/obj/item/explosive/grenade/smokebomb,\
				/obj/item/corncob,\
				/obj/item/poster,\
				/obj/item/toy/bikehorn,\
				/obj/item/toy/beach_ball,\
				/obj/item/toy/balloon,\
				/obj/item/toy/blink,\
				/obj/item/toy/crossbow,\
				/obj/item/toy/gun,\
				/obj/item/toy/katana,\
				/obj/item/toy/prize/deathripley,\
				/obj/item/toy/prize/durand,\
				/obj/item/toy/prize/fireripley,\
				/obj/item/toy/prize/gygax,\
				/obj/item/toy/prize/honk,\
				/obj/item/toy/prize/marauder,\
				/obj/item/toy/prize/mauler,\
				/obj/item/toy/prize/odysseus,\
				/obj/item/toy/prize/phazon,\
				/obj/item/toy/prize/ripley,\
				/obj/item/toy/prize/seraph,\
				/obj/item/toy/spinningtoy,\
				/obj/item/toy/sword,\
				/obj/item/reagent_container/food/snacks/grown/ambrosiadeus,\
				/obj/item/reagent_container/food/snacks/grown/ambrosiavulgaris,\
				/obj/item/clothing/accessory/tie/horrible,\
				/obj/item/clothing/shoes/slippers,\
				/obj/item/clothing/shoes/slippers_worn,\
				/obj/item/clothing/head/collectable/tophat/super)

/obj/effect/spawner/random/pills
	name = "Pill Bottle Loot Spawner" // 60% chance for strong loot
	desc = "This is a random pill bottle, for survivors. Remember to set spawn nothing percentage chance in instancing"
	icon_state = "loot_pills"

/obj/effect/spawner/random/pills/item_to_spawn()
	return pick(prob(4);/obj/item/storage/pill_bottle/inaprovaline/skillless,\
				prob(4);/obj/item/storage/pill_bottle/mystery/skillless,\
				prob(3);/obj/item/storage/pill_bottle/alkysine/skillless,\
				prob(3);/obj/item/storage/pill_bottle/imidazoline/skillless,\
				prob(3);/obj/item/storage/pill_bottle/tramadol/skillless,\
				prob(3);/obj/item/storage/pill_bottle/bicaridine/skillless,\
				prob(3);/obj/item/storage/pill_bottle/kelotane/skillless,\
				prob(3);/obj/item/storage/pill_bottle/peridaxon/skillless,\
				prob(2);/obj/item/storage/pill_bottle/packet/oxycodone)

/obj/effect/spawner/random/pills/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pills_20"

/obj/effect/spawner/random/pills/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_pills_50"

/obj/effect/spawner/random/pills/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_pills_80"

/obj/effect/spawner/random/goggles
	name = "Goggles Loot Spawner"
	desc = "This is a random set of goggles, for survivors. Remember to set spawn nothing percentage chance in instancing"
	icon_state = "loot_goggles"

/obj/effect/spawner/random/goggles/item_to_spawn()
	return pick(prob(4);/obj/item/clothing/glasses/welding/superior,\
				prob(4);/obj/item/clothing/glasses/hud/security/jensenshades,\
				prob(4);/obj/item/clothing/glasses/meson/refurbished,\
				prob(4);/obj/item/clothing/glasses/science,\
				prob(4);/obj/item/clothing/glasses/hud/sensor,\
				prob(4);/obj/item/clothing/glasses/hud/security)

/obj/effect/spawner/random/goggles/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_goggles_20"

/obj/effect/spawner/random/goggles/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_goggles_50"

/obj/effect/spawner/random/goggles/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_goggles_80"

/obj/effect/spawner/random/sentry
	name = "sentry Loot Spawner"
	desc = "This is a random sentry, for survivors. Remember to set spawn nothing percentage chance in instancing"
	icon_state = "loot_sentry"

/obj/effect/spawner/random/sentry/item_to_spawn()
	return pick(/obj/item/defenses/handheld/tesla_coil,\
				/obj/item/defenses/handheld/planted_flag,\
				/obj/item/defenses/handheld/sentry,\
				/obj/item/defenses/handheld/sentry/flamer)

/obj/effect/spawner/random/sentry/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_sentry_20"

/obj/effect/spawner/random/sentry/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_sentry_50"

/obj/effect/spawner/random/sentry/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_sentry_80"

/*
// Gun subtype spawners
// these spawn a gun and some ammo for it, can be configured and messed around with
// presets for maps - pistol, shotgun, smg, rifle
*/

/obj/effect/spawner/random/gun
	name = "PARENT TYPE"
	desc = "don't spawn this"
	icon_state = "map_hazard"
	var/scatter = TRUE
	var/mags_max = 5
	var/mags_min = 1
	var/list/guns = list(
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy
		)



/obj/effect/spawner/random/gun/spawn_item()
	var/gunpath = pick(guns)
	var/ammopath
	if(istype(gunpath, /obj/item/weapon/gun/shotgun))
		ammopath = pick(GLOB.shotgun_boxes_12g)
	else if(istype(gunpath, /obj/item/weapon/gun/launcher/grenade))
		ammopath = pick(GLOB.grenade_packets)
	else
		ammopath = guns[gunpath]
	spawn_weapon_on_floor(gunpath, ammopath, rand(mags_min, mags_max))

/obj/effect/spawner/random/gun/proc/spawn_weapon_on_floor(gunpath, ammopath, ammo_amount = 1)

	var/turf/spawnloc = get_turf(src)
	var/obj/gun
	var/obj/ammo

	if(gunpath)
		gun = new gunpath(spawnloc)
		if(scatter)
			var/direction = pick(GLOB.alldirs)
			var/turf/turf = get_step(gun, direction)
			if(!turf || turf.density)
				return
			gun.forceMove(turf)
	if(ammopath)
		for(var/i in 0 to ammo_amount-1)
			ammo = new ammopath(spawnloc)
			if(scatter)
				for(i=0, i<rand(1,3), i++)
					var/direction = pick(GLOB.alldirs)
					var/turf/turf = get_step(ammo, direction)
					if(!turf || turf.density)
						break
					ammo.forceMove(turf)

/*
// the actual spawners themselves
*/

/obj/effect/spawner/random/gun/pistol
	name = "pistol loot spawner"
	desc = "spawns a surv pistol and some ammo"
	icon_state = "loot_pistol"
	mags_max = 4
	mags_min = 1
	guns = list(
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/weapon/gun/pistol/b92fs = /obj/item/ammo_magazine/pistol/b92fs,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/revolver/cmb = /obj/item/ammo_magazine/revolver/cmb,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/pistol/highpower = /obj/item/ammo_magazine/pistol/highpower,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/kt42,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/kt42,
		/obj/item/weapon/gun/pistol/kt42 = /obj/item/ammo_magazine/pistol/kt42,
		/obj/item/weapon/gun/pistol/m1911 = /obj/item/ammo_magazine/pistol/m1911,
		/obj/item/weapon/gun/revolver/small = /obj/item/ammo_magazine/revolver/small,
		/obj/item/weapon/gun/pistol/heavy = /obj/item/ammo_magazine/pistol/heavy,
		/obj/item/weapon/gun/pistol/skorpion = /obj/item/ammo_magazine/pistol/skorpion,
		)

/obj/effect/spawner/random/gun/pistol/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_pistol_20"

/obj/effect/spawner/random/gun/pistol/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_pistol_50"

/obj/effect/spawner/random/gun/pistol/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_pistol_80"

/obj/effect/spawner/random/gun/rifle
	name = "rifle loot spawner"
	desc = "spawns a surv rifle and some ammo"
	icon_state = "loot_rifle"
	guns = list(
		/obj/item/weapon/gun/boltaction = /obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/weapon/gun/boltaction = /obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/weapon/gun/boltaction = /obj/item/ammo_magazine/rifle/boltaction,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/m16 = /obj/item/ammo_magazine/rifle/m16,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40/carbine = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/mar40 = /obj/item/ammo_magazine/rifle/mar40,
		/obj/item/weapon/gun/rifle/ar10 = /obj/item/ammo_magazine/rifle/ar10,
		/obj/item/weapon/gun/rifle/l42a/abr40 = /obj/item/ammo_magazine/rifle/l42a/abr40,
		/obj/item/weapon/gun/rifle/nsg23/no_lock/stripped = /obj/item/ammo_magazine/rifle/nsg23
		)

/obj/effect/spawner/random/gun/rifle/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_rifle_20"

/obj/effect/spawner/random/gun/rifle/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_rifle_50"

/obj/effect/spawner/random/gun/rifle/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_rifle_80"

/obj/effect/spawner/random/gun/shotgun
	name = "shotgun loot spawner"
	desc = "spawns a surv shotgun and some ammo"
	icon_state = "loot_shotgun"
	mags_min = 1
	mags_max = 2
	guns = list(
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = null,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = null,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = null,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = null,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = null,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb = null,
		/obj/item/weapon/gun/lever_action/r4t = /obj/item/ammo_magazine/lever_action,
		/obj/item/weapon/gun/lever_action/r4t = /obj/item/ammo_magazine/lever_action,
		/obj/item/weapon/gun/lever_action/r4t = /obj/item/ammo_magazine/lever_action,
		/obj/item/weapon/gun/shotgun/merc = null,
		/obj/item/weapon/gun/shotgun/pump/dual_tube/cmb/m3717 = null,
	) //no ammotypes needed as it spawns random 12g boxes. Apart from the r4t. why is the r4t in the shotgun pool? fuck you, that's why.

/obj/effect/spawner/random/gun/shotgun/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_shotgun_20"

/obj/effect/spawner/random/gun/shotgun/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_shotgun_50"

/obj/effect/spawner/random/gun/shotgun/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_shotgun_80"

/obj/effect/spawner/random/gun/smg
	name = "smg loot spawner"
	desc = "spawns a surv smg and some ammo"
	icon_state = "loot_smg"
	guns = list(
		/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
		/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
		/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
		/obj/item/weapon/gun/smg/mp5 = /obj/item/ammo_magazine/smg/mp5,
		/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
		/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
		/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
		/obj/item/weapon/gun/smg/mp27 = /obj/item/ammo_magazine/smg/mp27,
		/obj/item/weapon/gun/smg/pps43 = /obj/item/ammo_magazine/smg/pps43,
		/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15,
		/obj/item/weapon/gun/smg/mac15 = /obj/item/ammo_magazine/smg/mac15,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
		/obj/item/weapon/gun/smg/uzi = /obj/item/ammo_magazine/smg/uzi,
		/obj/item/weapon/gun/smg/fp9000 = /obj/item/ammo_magazine/smg/fp9000
		)

/obj/effect/spawner/random/gun/smg/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_smg_20"

/obj/effect/spawner/random/gun/smg/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_smg_50"

/obj/effect/spawner/random/gun/smg/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_smg_80"

/obj/effect/spawner/random/gun/special
	name = "special gun loot spawner"
	desc = "spawns a surv special gun and some ammo"
	icon_state = "loot_special"
	guns = list(
		/obj/item/weapon/gun/rifle/mar40/lmg = /obj/item/ammo_magazine/rifle/mar40/lmg,
		/obj/item/weapon/gun/shotgun/merc = null,
		/obj/item/weapon/gun/launcher/rocket/anti_tank/disposable = /obj/item/prop/folded_anti_tank_sadar,
		/obj/item/weapon/gun/rifle/m41a = /obj/item/ammo_magazine/rifle,
		/obj/item/weapon/gun/shotgun/combat = null,
		/obj/item/weapon/gun/pistol/vp78 = /obj/item/ammo_magazine/pistol/vp78,
		/obj/item/weapon/gun/launcher/grenade/m81/m79 = null
		)

/obj/effect/spawner/random/gun/special/lowchance
	spawn_nothing_percentage = 80
	icon_state = "loot_special_20"

/obj/effect/spawner/random/gun/special/midchance
	spawn_nothing_percentage = 50
	icon_state = "loot_special_50"

/obj/effect/spawner/random/gun/special/highchance
	spawn_nothing_percentage = 20
	icon_state = "loot_special_80"

/*
// claymore spawners
*/

/obj/effect/spawner/random/claymore
	name = "Random Claymore"
	desc = "This is a random deployed and active claymore."
	icon_state = "claymore"

/obj/effect/spawner/random/claymore/item_to_spawn()
	return pick(/obj/item/explosive/mine/active/no_iff,\
				/obj/item/explosive/mine/pmc/active)

/obj/effect/spawner/random/claymore/spawn_item()
	var/build_path = item_to_spawn()
	var/obj/item/explosive/mine/M = new build_path(src.loc)
	M.dir = src.dir
	return

/obj/effect/spawner/random/claymore/lowchance
	spawn_nothing_percentage = 80
	icon_state = "claymore_20"

/obj/effect/spawner/random/claymore/midchance
	spawn_nothing_percentage = 50
	icon_state = "claymore_50"

/obj/effect/spawner/random/claymore/highchance
	spawn_nothing_percentage = 20
	icon_state = "claymore_80"


/*
// OB spawners
*/

/obj/effect/spawner/random/warhead
	name = "random orbital warhead"
	desc = "This is a random orbital warhead."
	icon = 'icons/obj/structures/props/almayer/almayer_props.dmi'
	icon_state = "ob_warhead_1"
	spawn_on_roundstart = TRUE

/obj/effect/spawner/random/warhead/item_to_spawn()
	var/list/spawnables = list(
		/obj/structure/ob_ammo/warhead/explosive,
		/obj/structure/ob_ammo/warhead/incendiary,
		/obj/structure/ob_ammo/warhead/cluster
	)
	return pick(spawnables)
