/*SPAWNING LANDMARKS*/
//Check below to see what the crates contain, these landmarks will spawn in a bunch of crates at once, to make it easy to spawn in supplies.
/obj/effect/landmark/supplyspawner
	name = "supply spawner"
	var/list/supply = list()

/obj/effect/landmark/supplyspawner/New()
	..()
	if(/turf/open in range(1))
		var/list/T = list()
		for(var/turf/open/O in range(1))
			T += O
		if(length(supply))
			for(var/s in supply)
				var/amount = supply[s]
				for(var/i = 1, i <= amount, i++)
					new s (pick(T))
		sleep(-1)
	qdel(src)


/obj/effect/landmark/supplyspawner/weapons
	name = "weapon supplies"
	supply = list(
		/obj/structure/largecrate/supply/weapons/m41a = 2,
		/obj/structure/largecrate/supply/weapons/shotgun = 2,
		/obj/structure/largecrate/supply/weapons/m39 = 2,
		/obj/structure/largecrate/supply/weapons/pistols = 2,
		/obj/structure/largecrate/supply/weapons/flamers = 2,
		/obj/structure/largecrate/supply/weapons/hpr = 2,
		/obj/structure/closet/crate/secure/mortar_ammo/mortar_kit = 1,
		/obj/structure/largecrate/supply/explosives/mines = 2,
		/obj/structure/largecrate/supply/explosives/grenades = 2,
	)

/obj/effect/landmark/supplyspawner/ammo
	name = "ammunition supplies"
	supply = list(
		/obj/structure/largecrate/supply/ammo/m41a = 4,
		/obj/structure/largecrate/supply/ammo/m41a_box = 4,
		/obj/structure/largecrate/supply/ammo/shotgun = 4,
		/obj/structure/largecrate/supply/ammo/m39 = 4,
		/obj/structure/largecrate/supply/ammo/pistol = 4,
	)

/obj/effect/landmark/supplyspawner/engineering
	name = "engineering supplies"
	supply = list(
		/obj/structure/largecrate/supply/supplies/metal = 5,
		/obj/structure/largecrate/supply/supplies/plasteel = 3,
		/obj/structure/largecrate/supply/supplies/sandbags = 5,
		/obj/structure/largecrate/supply/generator = 1,
		/obj/structure/largecrate/supply/floodlights = 2,
		/obj/structure/largecrate/supply/supplies/flares = 3,
		/obj/structure/largecrate/supply/powerloader = 1,
		/obj/structure/largecrate/machine/recycler = 2,
	)

/obj/effect/landmark/supplyspawner/turrets
	name = "defensive gun emplacement supplies"
	supply = list(
		/obj/structure/largecrate/supply/weapons/m56d = 2,
		/obj/structure/largecrate/supply/ammo/sentry = 1,
		/obj/structure/largecrate/supply/ammo/m56d = 1,
	)

/obj/effect/landmark/supplyspawner/food
	name = "food crate supplies"
	supply = list(/obj/structure/largecrate/supply/supplies/mre = 3, /obj/structure/largecrate/supply/supplies/water = 2)

/obj/effect/landmark/supplyspawner/medical
	name = "medical supplies"
	supply = list(
		/obj/structure/largecrate/supply/medicine/medkits = 2,
		/obj/structure/largecrate/supply/medicine/blood = 2,
		/obj/structure/largecrate/supply/medicine/iv = 2,
		/obj/structure/largecrate/supply/medicine/medivend = 2,
		/obj/structure/largecrate/machine/autodoc = 3,
		/obj/structure/largecrate/machine/bodyscanner = 1,
		/obj/structure/largecrate/machine/sleeper = 2,
		/obj/structure/largecrate/supply/medicine/optable = 1,
		/obj/structure/largecrate/supply/supplies/tables_racks = 1,
	)
/*NEW SUPPLY CRATES*/
//Lotsocrates for lotsosupplies for events, meaning less setup time.
//Wooden crates and not metal ones so we don't have a ton of metal crates laying around
//SHOULD contain everything needed for events. Should.

/obj/structure/largecrate/supply
	name = "supply crate"
	var/list/supplies = list()

/obj/structure/largecrate/supply/Initialize()
	. = ..()
	if(length(supplies))
		for(var/s in supplies)
			var/amount = supplies[s]
			for(var/i = 1, i <= amount, i++)
				new s (src)

/obj/structure/largecrate/supply/weapons
	name = "weapons chest"
	icon_state = "chest"
	parts_type = /obj/item/stack/sheet/metal
	unpacking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/largecrate/supply/weapons/m41a
	name = "\improper M41A pulse rifle weapons chest (x10)"
	desc = "A weapons chest containing ten M41A rifles."
	supplies = list(/obj/item/weapon/gun/rifle/m41a = 10)

/obj/structure/largecrate/supply/weapons/shotgun
	name = "\improper M37A2 pump action shotgun weapons chest (x10)"
	desc = "A weapons chest containing ten M37A2 pump shotguns."
	supplies = list(/obj/item/weapon/gun/shotgun/pump = 10)

/obj/structure/largecrate/supply/weapons/m39
	name = "\improper M39 sub machinegun weapons chest (x8)"
	desc = "A weapons chest containing eight M39 submachine guns."
	supplies = list(/obj/item/weapon/gun/smg/m39 = 8)

/obj/structure/largecrate/supply/weapons/pistols
	name = "sidearm weapons chest (x20)"
	desc = "A weapons chest containing eight M44 revolvers, and twelve M4A3 service pistols."
	supplies = list(/obj/item/weapon/gun/revolver/m44 = 6, /obj/item/weapon/gun/pistol/m4a3 = 12)

/obj/structure/largecrate/supply/weapons/flamers
	name = "\improper M240A1 incinerator weapons chest (x4)"
	desc = "A weapons chest containing four M240A1 incinerator units."
	supplies = list(/obj/item/weapon/gun/flamer/m240 = 4)

/obj/structure/largecrate/supply/weapons/hpr
	name = "\improper M41AE2 heavy pulse rifle weapons chest (x2)"
	desc = "A weapons chest containing two M41AE2 heavy pulse rifles."
	supplies = list(/obj/item/weapon/gun/rifle/lmg = 2)

/obj/structure/largecrate/supply/weapons/m56d
	name = "\improper M56D mounted smartgun chest (x2)"
	desc = "A supply crate containing two boxed M56D mounted smartguns."
	supplies = list(/obj/item/storage/box/m56d_hmg = 2)



/obj/structure/largecrate/supply/ammo
	name = "ammunition case"
	icon_state = "case"

/obj/structure/largecrate/supply/ammo/m41a
	name = "\improper M41A magazine case (x20)"
	desc = "An ammunition case containing 20 M41A magazines."
	supplies = list(/obj/item/ammo_magazine/rifle = 20)

/obj/structure/largecrate/supply/ammo/m41a/half
	name = "\improper M41A magazine case (x10)"
	desc = "An ammunition case containing 10 M41A magazines."
	supplies = list(/obj/item/ammo_magazine/rifle = 10)

/obj/structure/largecrate/supply/ammo/m41a_box
	name = "\improper M41A ammunition box case (x4)"
	desc = "An ammunition case containing four M41A 600 round boxes of ammunition."
	supplies = list(/obj/item/ammo_box/rounds = 4)

/obj/structure/largecrate/supply/ammo/shotgun
	name = "12 Gauge ammunition crate (x20)"
	desc = "An ammunition case containing eight boxes of slugs, eight boxes of buckshot, and four boxes of flechette rounds."
	supplies = list(/obj/item/ammo_magazine/shotgun/slugs = 8, /obj/item/ammo_magazine/shotgun/buckshot = 8, /obj/item/ammo_magazine/shotgun/flechette = 4)

/obj/structure/largecrate/supply/ammo/m39
	name = "\improper M39 HV magazine case (x16)"
	desc = "An ammunition case containing sixteen M39 HV magazines."
	supplies = list(/obj/item/ammo_magazine/smg/m39 = 16)

/obj/structure/largecrate/supply/ammo/m39/half
	name = "\improper M39 HV magazine case (x8)"
	desc = "An ammunition case containing eight M39 HV magazines."
	supplies = list(/obj/item/ammo_magazine/smg/m39 = 8)

/obj/structure/largecrate/supply/ammo/pistol
	name = "sidearm ammunition case (x40)"
	desc = "An ammunition case containing sixteen M44 speedloaders, and twenty-four M4A3 magazines."
	supplies = list(/obj/item/ammo_magazine/revolver = 16, /obj/item/ammo_magazine/pistol = 24)

/obj/structure/largecrate/supply/ammo/pistol/half
	name = "sidearm ammunition case (x20)"
	desc = "An ammunition case containing eight M44 speedloaders, and twelve M4A3 magazines."
	supplies = list(/obj/item/ammo_magazine/revolver = 8, /obj/item/ammo_magazine/pistol = 12)

/obj/structure/largecrate/supply/ammo/sentry
	name = "\improper UA 571-C ammunition drum case (x6)"
	desc = "An ammunition case containing six UA 571-C sentry ammunition drums."
	supplies = list(/obj/item/ammo_magazine/sentry = 6)

/obj/structure/largecrate/supply/ammo/m56d
	name = "\improper M56D ammunition drum case (x6)"
	desc = "An ammunition case containing six M56D ammunition drums."
	supplies = list(/obj/item/ammo_magazine/m56d = 6)



/obj/structure/largecrate/supply/explosives
	name = "explosives supply crate"
	desc = "A case containing explosives."
	icon_state = "case_double"

/obj/structure/largecrate/supply/explosives/mines
	name = "\improper M20 claymore case (x25)"
	desc = "A case containing five boxes of five M20 claymores."
	supplies = list(/obj/item/storage/box/explosive_mines = 5)

/obj/structure/largecrate/supply/explosives/grenades
	name = "\improper M40 HDEP grenade case (x50)"
	desc = "A case containing two twenty-five M40 HDEP grenade boxes."
	supplies = list(/obj/item/storage/box/nade_box = 2)

/obj/structure/largecrate/supply/explosives/mortar_he
	name = "80mm HE mortar shell case (x25)"
	desc = "A case containing twenty-five 80mm HE mortar shells."
	supplies = list(/obj/item/mortar_shell/he = 25)

/obj/structure/largecrate/supply/explosives/mortar_incend
	name = "80mm incendiary mortar shell case (x25)"
	desc = "A case containing twenty-five 80mm incendiary mortar shells."
	supplies = list(/obj/item/mortar_shell/incendiary = 25)

/obj/structure/largecrate/supply/explosives/mortar_flare
	name = "80mm flare mortar shell case (x25)"
	desc = "A case containing twenty-five 80mm flare mortar shells."
	supplies = list(/obj/item/mortar_shell/flare = 25)


/obj/structure/largecrate/supply/supplies
	name = "supplies crate"
	icon_state = "secure_crate"

/obj/structure/largecrate/supply/supplies/flares
	name = "Flare supply crate (x200)"
	desc = "A supply crate containing two crates of flares."
	supplies = list(/obj/item/ammo_box/magazine/misc/flares = 2)

/obj/structure/largecrate/supply/supplies/metal
	name = "metal sheets supply crate (x200)"
	desc = "A supply crate containing four fifty stacks of metal sheets."
	supplies = list(/obj/item/stack/sheet/metal/large_stack = 4)

/obj/structure/largecrate/supply/supplies/plasteel
	name = "plasteel supply crate (x60)"
	desc = "A supply crate containing two stacks of 30 plasteel sheets."
	supplies = list(/obj/item/stack/sheet/plasteel/medium_stack = 2)

/obj/structure/largecrate/supply/supplies/sandbags
	name = "sandbag supply crate (x100)"
	desc = "A supply crate containing four piles of twenty-five sandbags."
	supplies = list(/obj/item/stack/sandbags/large_stack = 4)

/obj/structure/largecrate/supply/supplies/tables_racks
	name = "storage solutions crate (x10, x10)"
	desc = "A crate containing ten table parts, and ten rack parts, for easy storage setup."
	supplies = list(/obj/item/frame/table = 10, /obj/item/frame/rack = 10)

/obj/structure/largecrate/supply/supplies/mre
	name = "\improper USCM MRE crate (x60)"
	desc = "A supply crate containing sixty USCM MRE packets."
	supplies = list(/obj/item/ammo_box/magazine/misc/mre = 5)

/obj/structure/largecrate/supply/supplies/mre/wy
	name = "\improper W-Y brand rations crate (x60)"
	desc = "A supply crate containing sixty W-Y brand ration packets."
	supplies = list(/obj/item/ammo_box/magazine/misc/mre/wy = 5)

/obj/structure/largecrate/supply/supplies/wy_emergency_food
	name = "\improper WY emergency nutrition briquettes crate (x100)"
	desc = "A supply crate containing one hundred WY emergency nutrition briquettes."
	supplies = list(/obj/item/ammo_box/magazine/misc/mre/emergency = 5)

/obj/structure/largecrate/supply/supplies/water
	name = "\improper WY Bottled Water crate (x50)"
	desc = "A crate containing fifty Weyland-Yutani Bottled Spring Water bottles."
	supplies = list(/obj/item/reagent_container/food/drinks/cans/waterbottle = 50)

/obj/structure/largecrate/supply/powerloader
	name = "\improper Caterpillar P-5000 Work Loader crate"
	desc = "A crate containing one folded, but fully assembled, Caterpillar P-5000 Work Loader and included pamphlet for quick training."
	supplies = list(
		/obj/vehicle/powerloader = 1,
		/obj/item/pamphlet/skill/powerloader = 1,
	)

/obj/structure/largecrate/supply/floodlights
	name = "floodlight crate (x4)"
	desc = "A crate containing four floodlights."
	supplies = list(/obj/structure/machinery/floodlight = 4)

/obj/structure/largecrate/supply/generator
	name = "\improper P.A.C.M.A.N. crate"
	desc = "A crate containing a P.A.C.M.A.N. generator, some fuel, and some cable coil to get your power up and going."
	supplies = list(/obj/structure/machinery/power/port_gen/pacman = 1, /obj/item/stack/sheet/mineral/phoron/medium_stack = 1, /obj/item/stack/cable_coil/yellow = 3)

/obj/structure/largecrate/supply/medicine
	name = "medical crate"
	desc = "A crate containing medical supplies."
	icon_state = "chest_white"
	parts_type = /obj/item/stack/sheet/metal
	unpacking_sound = 'sound/effects/metalhit.ogg'

/obj/structure/largecrate/supply/medicine/medkits
	name = "first aid supply crate (x20)"
	desc = "A medical supply crate containing six advanced, three standard, three burn, two toxin, two oxygen, and two radiation first aid kits."
	supplies = list(
		/obj/item/storage/firstaid/regular = 3,
		/obj/item/storage/firstaid/fire = 3,
		/obj/item/storage/firstaid/adv = 6,
		/obj/item/storage/firstaid/toxin = 2,
		/obj/item/storage/firstaid/o2 = 2,
		/obj/item/storage/firstaid/rad = 2,
	)

/obj/structure/largecrate/supply/medicine/blood
	name = "blood supply crate (x12)"
	desc = "A medical supply crate containing twelve bags of type O- blood."
	supplies = list(/obj/item/reagent_container/blood/OMinus = 12)

/obj/structure/largecrate/supply/medicine/iv
	name = "\improper IV stand crate (x3)"
	desc = "A medical supply crate containing three IV drips."
	supplies = list(/obj/structure/machinery/iv_drip = 3)

/obj/structure/largecrate/supply/medicine/optable
	name = "medical operation crate (x1)"
	desc = "A crate containing an operating table, two tanks of anesthetic, a surgery kit, some anesthetic injectors, and some space cleaner."
	supplies = list(/obj/structure/machinery/optable = 1, /obj/item/storage/surgical_tray = 1, /obj/item/tank/anesthetic = 2, /obj/item/reagent_container/spray/cleaner = 1)

/obj/structure/largecrate/supply/medicine/medivend
	name = "\improper Wey-Med Plus crate (x1)"
	desc = "A crate containing one Weyland Plus medical vendor."
	supplies = list(/obj/structure/machinery/cm_vending/sorted/medical = 1)


/obj/structure/largecrate/machine
	name = "machine crate"
	desc = "A crate containing a pre-assembled machine."
	icon_state = "secure_crate_strapped"
	var/dir_needed = EAST //If set to anything but 0, will check that space before spawning in.
	var/unmovable = 1 //If set to 1, then on examine, the user will see a warning that states the contents cannot be moved after opened.

/obj/structure/largecrate/machine/get_examine_text(mob/user)
	. = ..()
	if(unmovable)
		. += SPAN_DANGER("!!WARNING!! CONTENTS OF CRATE UNABLE TO BE MOVED ONCE UNPACKAGED!")

/obj/structure/largecrate/machine/unpack(forced)
	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)
	qdel(src)

/obj/structure/largecrate/machine/attackby(obj/item/W as obj, mob/user as mob)
	if(HAS_TRAIT(W, TRAIT_TOOL_CROWBAR))
		if(turf_blocked_check())
			to_chat(user, SPAN_WARNING("You need a clear space[dir_needed ? " to the [dir2text(dir_needed)] of the crate" : ""] in order to unpack \the [src]."))
			return
		if(alert(user, "Are you sure you want to unpack \the [src] here?", "Confirmation", "Yes", "No") != "Yes")
			return

		user.visible_message(SPAN_NOTICE("[user] pries \the [src] open."), SPAN_NOTICE("You pry open \the [src]."))
		unpack()
	else
		return attack_hand(user)

/obj/structure/largecrate/machine/proc/turf_blocked_check()
	var/turf/T
	var/turf_blocked = FALSE
	if(dir_needed)
		T = get_step(src, dir_needed)
		if(T.density)
			turf_blocked = TRUE
		else
			for(var/atom/movable/AM in T.contents)
				if(AM.density)
					turf_blocked = TRUE
					break
	else
		T = get_turf(loc)
		if(T.density) //I can totally imagine marines getting this crate on dense turf somehow
			turf_blocked = TRUE
		else
			for(var/atom/movable/AM in T.contents)
				if(AM.density)
					turf_blocked = TRUE
					break
	return turf_blocked

/obj/structure/largecrate/machine/recycler
	name = "recycler crate (x1)"
	desc = "A crate containing one recycler, for removal of trash."
	dir_needed = 0

/obj/structure/largecrate/machine/recycler/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	new /obj/structure/machinery/wo_recycler(loc)

	qdel(src)
	return TRUE

/obj/structure/largecrate/machine/autodoc
	name = "autodoctor machine crate (x1)"
	desc = "A crate containing one autodoc."

/obj/structure/largecrate/machine/autodoc/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	var/obj/structure/machinery/medical_pod/autodoc/unskilled/E = new (T)
	var/obj/structure/machinery/autodoc_console/C = new (get_step(T, dir_needed))
	E.connected = C
	C.connected = E

	qdel(src)
	return TRUE

/obj/structure/largecrate/machine/bodyscanner
	name = "bodyscanner machine crate (x1)"
	desc = "A crate containing one medical bodyscanner."

/obj/structure/largecrate/machine/bodyscanner/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	var/obj/structure/machinery/medical_pod/bodyscanner/E = new (T)
	var/obj/structure/machinery/body_scanconsole/C = new (get_step(T, dir_needed))
	C.connected = E

	qdel(src)
	return TRUE

/obj/structure/largecrate/machine/sleeper
	name = "sleeper machine crate (x1)"
	desc = "A crate containing one medical sleeper."

/obj/structure/largecrate/machine/sleeper/unpack()
	var/turf/T = get_turf(loc)
	if(!istype(T, /turf/open))
		return FALSE

	if(parts_type)
		new parts_type(loc, 2)
	playsound(src, unpacking_sound, 35)

	var/obj/structure/machinery/medical_pod/sleeper/E = new (T)
	var/obj/structure/machinery/sleep_console/C = new (get_step(T, dir_needed))
	E.connected = C
	C.connected = E

	qdel(src)
	return TRUE

// Empty

/obj/structure/largecrate/empty/secure
	name = "secure supply crate"
	desc = "A secure crate."
	icon_state = "secure_crate_strapped"
	var/strapped = TRUE

/obj/structure/largecrate/empty/secure/attackby(obj/item/W as obj, mob/user as mob)
	if (!strapped)
		..()
		return

	if (!W.sharp)
		to_chat(user, SPAN_NOTICE("You need something sharp to cut off the straps."))
		return

	to_chat(user, SPAN_NOTICE("You begin to cut the straps off [src]..."))

	if (do_after(user, 1.5 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC))
		playsound(loc, 'sound/items/Wirecutter.ogg', 25, 1)
		to_chat(user, SPAN_NOTICE("You cut the straps away."))
		icon_state = "secure_crate"
		strapped = FALSE

/obj/structure/largecrate/empty/case
	name = "storage case"
	desc = "A black storage case."
	icon_state = "case"

/obj/structure/largecrate/empty/case/double
	name = "cases"
	desc = "A stack of black storage cases."
	icon_state = "case_double"

/obj/structure/largecrate/empty/case/double/unpack()
	if(parts_type)
		new parts_type(loc, 2)
	for(var/obj/thing in contents)
		thing.forceMove(loc)
	new /obj/structure/largecrate/empty/case(loc)
	playsound(src, unpacking_sound, 35)
	qdel(src)

//----------------------------------------------------//
