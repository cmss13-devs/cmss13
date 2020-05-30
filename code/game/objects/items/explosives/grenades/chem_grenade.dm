/obj/item/explosive/grenade/custom
	name = "Custom grenade"
	icon_state = "grenade_custom"
	desc = "A custom chemical grenade with an M40 casing. This one is made to fit into underslung grenade launchers, but can also be used in hand."
	w_class = SIZE_SMALL
	force = 2.0
	dangerous = TRUE
	customizable = TRUE
	underslug_launchable = TRUE
	allowed_sensors = list(/obj/item/device/assembly/timer)
	matter = list("metal" = 3750)

/obj/item/explosive/grenade/custom/prime()
	overlays.Cut()
	..()

/obj/item/explosive/grenade/custom/large
	name = "Large Custom Grenade"
	desc = "A custom chemical grenade with an M15 casing. This casing has a higher explosive capacity than the M40 variant."
	icon_state = "large_grenade_custom"
	allowed_containers = list(/obj/item/reagent_container/glass)
	max_container_volume = 180
	reaction_limits = list(	"max_ex_power" = 215,	"base_ex_falloff" = 90,	"max_ex_shards" = 32,
							"max_fire_rad" = 5,		"max_fire_int" = 20,	"max_fire_dur" = 24,
							"min_fire_rad" = 1,		"min_fire_int" = 3,		"min_fire_dur" = 3
	)
	underslug_launchable = FALSE
	
	w_class = SIZE_MEDIUM
	matter = list("metal" = 7000)


/obj/item/explosive/grenade/custom/metalfoam
	name = "Metal-Foam Grenade"
	desc = "Used for emergency sealing of air breaches."
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE

/obj/item/explosive/grenade/custom/metalfoam/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 30)
	B2.reagents.add_reagent("foaming_agent", 10)
	B2.reagents.add_reagent("pacid", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()


/obj/item/explosive/grenade/custom/incendiary
	name = "Incendiary Grenade"
	desc = "Used for clearing rooms of living things."
	assembly_stage = ASSEMBLY_LOCKED

/obj/item/explosive/grenade/custom/incendiary/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 15)
	B1.reagents.add_reagent("fuel",20)
	B2.reagents.add_reagent("phoron", 15)
	B2.reagents.add_reagent("sacid", 15)
	B1.reagents.add_reagent("fuel",20)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()


/obj/item/explosive/grenade/custom/antiweed
	name = "weedkiller grenade"
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE

/obj/item/explosive/grenade/custom/antiweed/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("plantbgone", 25)
	B1.reagents.add_reagent("potassium", 25)
	B2.reagents.add_reagent("phosphorus", 25)
	B2.reagents.add_reagent("sugar", 25)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()


/obj/item/explosive/grenade/custom/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE

/obj/item/explosive/grenade/custom/cleaner/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 40)
	B2.reagents.add_reagent("water", 40)
	B2.reagents.add_reagent("cleaner", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	containers += B1
	containers += B2
	update_icon()




/obj/item/explosive/grenade/custom/teargas
	name = "\improper M66 teargas grenade"
	desc = "Tear gas grenade used for nonlethal riot control. Please wear adequate gas protection."
	assembly_stage = ASSEMBLY_LOCKED
	harmful = FALSE

/obj/item/explosive/grenade/custom/teargas/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("condensedcapsaicin", 25)
	B1.reagents.add_reagent("potassium", 25)
	B2.reagents.add_reagent("phosphorus", 25)
	B2.reagents.add_reagent("sugar", 25)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src, 2) //~4 second timer

	containers += B1
	containers += B2

	update_icon()


/obj/item/explosive/grenade/custom/teargas/attack_self(mob/user)
	if(!skillcheck(user, SKILL_POLICE, SKILL_POLICE_MP))
		to_chat(user, SPAN_WARNING("You don't seem to know how to use [src]..."))
		return
	..()


/obj/item/explosive/grenade/custom/ied
	name = "improvised explosive device"
	desc = "An improvised chemical explosive grenade. Designed to kill through fragmentation."
	assembly_stage = ASSEMBLY_LOCKED

/obj/item/explosive/grenade/custom/ied/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("potassium", 20)
	B1.reagents.add_reagent("iron", 40)
	B2.reagents.add_reagent("water", 20)
	B2.reagents.add_reagent("iron", 40)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src, 2) //~4 second timer

	containers += B1
	containers += B2

	update_icon()


/obj/item/explosive/grenade/custom/ied_incendiary
	name = "improvised explosive device (incendiary)"
	desc = "An improvised chemical explosive grenade. Designed spray incendiary shrapnel across a wide area."
	assembly_stage = ASSEMBLY_LOCKED

/obj/item/explosive/grenade/custom/ied_incendiary/Initialize()
	..()
	var/obj/item/reagent_container/glass/beaker/B1 = new(src)
	var/obj/item/reagent_container/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("potassium", 20)
	B1.reagents.add_reagent("iron", 40)
	B2.reagents.add_reagent("water", 20)
	B2.reagents.add_reagent("iron", 30)
	B2.reagents.add_reagent("phoron", 10)

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src, 2) //~4 second timer

	containers += B1
	containers += B2

	update_icon()