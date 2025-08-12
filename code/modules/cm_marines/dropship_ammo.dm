


/// Dropship weaponry ammunition
/obj/structure/ship_ammo
	icon = 'icons/obj/structures/props/dropship/dropship_ammo.dmi'
	density = TRUE
	anchored = TRUE
	throwpass = TRUE
	climbable = TRUE
	/// Delay between firing steps
	var/fire_mission_delay = 4
	/// Time to impact in deciseconds
	var/travelling_time = 100
	/// Type of dropship equipment that accepts this type of ammo.
	var/obj/structure/dropship_equipment/equipment_type
	/// Ammunition count remaining
	var/ammo_count
	/// Maximal ammunition count
	var/max_ammo_count
	/// What to call the ammo in the ammo transferring message
	var/ammo_name = "round"
	var/ammo_id
	/// Whether the ammo inside this magazine can be transferred to another magazine.
	var/transferable_ammo = FALSE
	/// How many tiles the ammo can deviate from the laser target
	var/accuracy_range = 3
	/// Sound played mere seconds before impact
	var/warning_sound = 'sound/effects/rocketpod_fire.ogg'
	/// Volume of the sound played before impact
	var/warning_sound_volume = 70
	/// Ammunition expended each time this is fired
	var/ammo_used_per_firing = 1
	/// Maximum deviation allowed when the ammo is not longer guided by a laser
	var/max_inaccuracy = 6
	/// Cost to build in the fabricator, zero means unbuildable
	var/point_cost
	/// Mob that fired this ammunition (the pilot pressing the trigger)
	var/mob/source_mob
	var/combat_equipment = TRUE
	var/faction_exclusive //if this ammo is obtainable only by certain faction
	//if TRUE, this ammo can be used to break through cave roofs
	var/cavebreaker = FALSE
	//if TRUE, this ammo can pierce metal roofs in direct fire
	var/metalbreaker = FALSE
	//delay in how fast to loop the simulation, mainly for GAU/Laser currently
	var/sleep_per_shot = 1
	//if this ammo doesn't require a powerloader to be moved
	var/handheld = FALSE
	//if this ammo has a safety toggle
	var/safety_enabled = FALSE
	var/handheld_type = null // Type path to the corresponding handheld item, if any

/obj/structure/ship_ammo/update_icon()
	. = ..()

	var/ammo_stage = ammo_count / ammo_used_per_firing
	icon_state = "[initial(icon_state)]_[ammo_stage]"

	if (ammo_count == max_ammo_count)
		icon_state = initial(icon_state)

/obj/structure/ship_ammo/attack_alien(mob/living/carbon/xenomorph/current_xenomorph)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	current_xenomorph.animation_attack_on(src)
	playsound(src, 'sound/effects/metalhit.ogg', 25, 1)
	current_xenomorph.visible_message(SPAN_DANGER("[current_xenomorph] slashes at [src]!"),
	SPAN_DANGER("You slash at [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	update_health(rand(current_xenomorph.melee_damage_lower, current_xenomorph.melee_damage_upper))
	return XENO_ATTACK_ACTION

/obj/structure/ship_ammo/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/powerloader_clamp))
		var/obj/item/powerloader_clamp/PC = I
		if(!PC.linked_powerloader)
			qdel(PC)
			return FALSE
		if(PC.loaded)
			if(istype(PC.loaded, /obj/structure/ship_ammo))
				var/obj/structure/ship_ammo/SA = PC.loaded
				SA.transfer_ammo(src, user)
				return FALSE
		else
			if(ammo_count < 1)
				to_chat(user, SPAN_WARNING("\The [src] has ran out of ammo, so you discard it!"))
				qdel(src)
				return FALSE

			if(ammo_name == "rocket")
				PC.grab_object(user, src, "ds_rocket", 'sound/machines/hydraulics_1.ogg')
			else
				PC.grab_object(user, src, "ds_ammo", 'sound/machines/hydraulics_1.ogg')
			update_icon()
			return FALSE
	else
		. = ..()


/obj/structure/ship_ammo/get_examine_text(mob/user)
	. = ..()
	. += "Moving this will require some sort of lifter."

//what to show to the user that examines the weapon we're loaded on.
/obj/structure/ship_ammo/proc/show_loaded_desc(mob/user)
	return "It's loaded with \a [src]."

/obj/structure/ship_ammo/proc/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	return

/obj/structure/ship_ammo/proc/can_fire_at(turf/impact, mob/user)
	return TRUE

/obj/structure/ship_ammo/proc/transfer_ammo(obj/structure/ship_ammo/target, mob/user)
	if(type != target.type)
		to_chat(user, SPAN_NOTICE("\The [src] and \the [target] use incompatible types of ammunition!"))
		return
	if(!transferable_ammo)
		to_chat(user, SPAN_NOTICE("\The [src] doesn't support [ammo_name] transfer!"))
		return
	var/obj/item/powerloader_clamp/PC
	if(istype(loc, /obj/item/powerloader_clamp))
		PC = loc
	if(ammo_count < 1)
		if(PC)
			PC.loaded = null
			PC.update_icon()
		to_chat(user, SPAN_WARNING("\The [src] has ran out of ammo, so you discard it!"))
		forceMove(get_turf(loc))
		qdel(src)
	if(target.ammo_count >= target.max_ammo_count)
		to_chat(user, SPAN_WARNING("\The [target] is fully loaded!"))
		return

	var/transf_amt = min(target.max_ammo_count - target.ammo_count, ammo_count)
	target.ammo_count += transf_amt
	ammo_count -= transf_amt
	playsound(loc, 'sound/machines/hydraulics_1.ogg', 40, 1)
	to_chat(user, SPAN_NOTICE("You transfer [transf_amt] [ammo_name] to \the [target]."))
	src?.update_icon()
	target.update_icon()
	if(ammo_count < 1)
		if(PC)
			PC.loaded = null
			PC.update_icon()
		to_chat(user, SPAN_WARNING("\The [src] has ran out of ammo, so you discard it!"))
		forceMove(get_turf(loc))
		qdel(src)
	else
		if(PC)
			if(ammo_name == "rocket")
				PC.update_icon("ds_rocket")
			else
				PC.update_icon("ds_ammo")


//30mm gun

/obj/structure/ship_ammo/heavygun
	name = "\improper PGU-100 Multi-Purpose 30mm ammo crate"
	icon_state = "30mm_crate"
	desc = "A crate full of PGU-100 30mm Multi-Purpose ammo designed to penetrate light (non reinforced) structures, as well as shred infantry, IAVs, LAVs, IMVs, and MRAPs. Works in large areas for use on Class 4 and superior alien insectoid infestations, as well as fitting within the armaments allowed for use against a tier 4 insurgency as well as higher tiers. However, it lacks armor penetrating capabilities, for which Anti-Tank 30mm ammo is needed. Can be loaded into the GAU-21 30mm cannon."
	equipment_type = /obj/structure/dropship_equipment/weapon/heavygun
	ammo_count = 400
	max_ammo_count = 400
	transferable_ammo = TRUE
	ammo_used_per_firing = 40
	point_cost = 275
	fire_mission_delay = 2
	var/bullet_spread_range = 3 //how far from the real impact turf can bullets land
	var/shrapnel_type = /datum/ammo/bullet/shrapnel/gau //For siming 30mm bullet impacts.
	var/directhit_damage = 105 //how much damage is to be inflicted to a mob, this is here so that we can hit resting mobs.
	var/penetration = 10 //AP value pretty much

/obj/structure/ship_ammo/heavygun/get_examine_text(mob/user)
	. = ..()
	. += "It has [ammo_count] round\s."

/obj/structure/ship_ammo/heavygun/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] containing [ammo_count] round\s."
	else
		return "It's loaded with an empty [name]."

/obj/structure/ship_ammo/heavygun/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	set waitfor = 0
	var/list/turf_list = RANGE_TURFS(bullet_spread_range, impact)
	var/soundplaycooldown = 0
	var/debriscooldown = 0

	for(var/i = 1 to ammo_used_per_firing)
		sleep(sleep_per_shot)
		var/turf/impact_tile = pick(turf_list)
		var/datum/cause_data/cause_data = create_cause_data(fired_from.name, source_mob)
		impact_tile.ex_act(EXPLOSION_THRESHOLD_VLOW, pick(GLOB.alldirs), cause_data)
		create_shrapnel(impact_tile,1,0,0,shrapnel_type,cause_data,FALSE,100) //simulates a bullet
		for(var/atom/movable/explosion_effect in impact_tile)
			if(iscarbon(explosion_effect))
				var/mob/living/carbon/bullet_effect = explosion_effect
				explosion_effect.ex_act(EXPLOSION_THRESHOLD_VLOW, null, cause_data)
				bullet_effect.apply_armoured_damage(directhit_damage,ARMOR_BULLET,BRUTE,null,penetration)
			else
				explosion_effect.ex_act(EXPLOSION_THRESHOLD_VLOW)
		new /obj/effect/particle_effect/expl_particles(impact_tile)
		if(!soundplaycooldown) //so we don't play the same sound 20 times very fast.
			playsound(impact_tile, 'sound/effects/gauimpact.ogg',40,1,20)
			soundplaycooldown = 3
		soundplaycooldown--
		if(!debriscooldown)
			impact_tile.ceiling_debris_check(1)
			debriscooldown = 6
		debriscooldown--
	sleep(11) //speed of sound simulation
	playsound(impact, 'sound/effects/gau.ogg',100,1,60)


/obj/structure/ship_ammo/heavygun/antitank
	name = "\improper PGU-105 30mm Anti-tank ammo crate"
	icon_state = "30mm_crate_hv"
	desc = "A crate full of PGU-105 Specialized 30mm APFSDS Titanium-Tungsten alloy penetrators, made for countering peer and near peer APCs, IFVs, and MBTs in CAS support. It is designed to penetrate up to the equivalent 1350mm of RHA when launched from a GAU-21. It is much less effective against soft targets however, in which case 30mm ball ammunition is recommended. WARNING: discarding petals from the ammunition can be harmful if the dropship does not pull out at the needed speeds. Please consult page 3574 of the manual, available for order at any ARMAT store. It can penetrate through metal ceilings. Can be loaded into the GAU-21 30mm cannon."
	travelling_time = 60
	ammo_count = 500
	max_ammo_count = 500
	ammo_used_per_firing = 50
	bullet_spread_range = 4
	point_cost = 325
	fire_mission_delay = 2
	shrapnel_type = /datum/ammo/bullet/shrapnel/gau/at
	directhit_damage = 80 //how much damage is to be inflicted to a mob, this is here so that we can hit resting mobs.
	penetration = 40 //AP value pretty much
	sleep_per_shot = 0.75 // fires volleys more frequently than standard ammo
	metalbreaker = TRUE // Can pierce metal roofs like mortars

/obj/structure/ship_ammo/heavygun/bellygun
	name = "\improper PGU-110 25mm Compact ammo crate"
	icon_state = "30mm_crate_bg"
	desc = "A crate full of PGU-110 Compact 25mm rounds designed for precise supporting fire from gunner stations aboard dropships. These smaller, lighter rounds feature enhanced ballistic stability for tighter shot groupings, making them ideal for strikes against light armored insurgents and soft targets. The reduced size allows for manual reloading by crewmembers within the dropship. Can be loaded into the GAU-24/B Belly Gunner Station."
	equipment_type = /obj/structure/dropship_equipment/weapon/heavygun/bay
	travelling_time = 30
	ammo_count = 400
	max_ammo_count = 400
	ammo_used_per_firing = 20
	bullet_spread_range = 2
	point_cost = 300
	fire_mission_delay = 2
	shrapnel_type = /datum/ammo/bullet/shrapnel/gau/at
	directhit_damage = 70 //how much damage is to be inflicted to a mob, this is here so that we can hit resting mobs.
	penetration = 20 //AP value pretty much
	sleep_per_shot = 0.75 // fires volleys more frequently than standard ammo
	metalbreaker = TRUE // Can pierce metal roofs like mortars
	handheld = TRUE // compact ammo can be manually loaded
	density = FALSE //
	anchored = FALSE // allows manual pickup
	handheld_type = /obj/item/ship_ammo_handheld/bellygun

//laser battery

/obj/structure/ship_ammo/laser_battery
	name = "\improper BTU-17/LW Hi-Cap Laser Battery"
	icon_state = "laser_battery"
	desc = "A high-capacity laser battery used to power laser beam weapons.  Can be loaded into the LWU-6B Laser Cannon."
	travelling_time = 10
	ammo_count = 100
	max_ammo_count = 100
	equipment_type = /obj/structure/dropship_equipment/weapon/laser_beam_gun
	ammo_name = "charge"
	transferable_ammo = TRUE
	accuracy_range = 1
	ammo_used_per_firing = 10
	max_inaccuracy = 1
	warning_sound = 'sound/effects/nightvision.ogg'
	point_cost = 250
	fire_mission_delay = 4 //very good but long cooldown


/obj/structure/ship_ammo/laser_battery/get_examine_text(mob/user)
	. = ..()
	. += "It's at [floor(100*ammo_count/max_ammo_count)]% charge."


/obj/structure/ship_ammo/laser_battery/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] at [floor(100*ammo_count/max_ammo_count)]% charge."
	else
		return "It's loaded with an empty [name]."


/obj/structure/ship_ammo/laser_battery/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	set waitfor = 0
	var/list/turf_list = RANGE_TURFS(3, impact) //This is its area of effect
	playsound(impact, 'sound/effects/pred_vision.ogg', 20, 1)
	var/datum/cause_data/cause_data = create_cause_data(fired_from.name, source_mob)
	for(var/i=1 to 16) //This is how many tiles within that area of effect will be randomly ignited
		var/turf/U = pick(turf_list)
		turf_list -= U
		fire_spread_recur(U, cause_data, 1, null, 5, 60, "#EE6515")//Very, very intense, but goes out very quick

	if(!ammo_count && !QDELETED(src))
		qdel(src) //deleted after last laser beam is fired and impact the ground.


//Rockets

/obj/structure/ship_ammo/rocket
	name = "abstract rocket"
	icon_state = "single"
	icon = 'icons/obj/structures/props/dropship/dropship_ammo64.dmi'
	equipment_type = list(/obj/structure/dropship_equipment/weapon/rocket_pod, /obj/structure/dropship_equipment/autoreloader)
	ammo_count = 1
	max_ammo_count = 1
	ammo_name = "rocket"
	ammo_id = ""
	bound_width = 64
	bound_height = 32
	travelling_time = 60 //faster than 30mm rounds
	max_inaccuracy = 5
	point_cost = 0
	fire_mission_delay = 4

/obj/structure/ship_ammo/rocket/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	qdel(src)

//this one is air-to-air only
/obj/structure/ship_ammo/rocket/widowmaker
	name = "\improper AIM-224B 'Widowmaker'"
	desc = "The AIM-224B missile is a retrofit of the latest in air-to-air missile technology. Earning the nickname of 'Widowmaker' from various dropship pilots after improvements to its guidance warhead prevents it from being jammed leading to its high kill rate. Not well suited for ground bombardment but its high velocity makes it reach its target quickly. This one has been modified to be a free-fall bomb as a result of dropship ammo shortages. Can be loaded into the LAU-444 Guided Missile Launcher and LAB-107 Bomb Bay."
	icon_state = "single"
	travelling_time = 40 //not powerful, but reaches target fast
	ammo_id = ""
	point_cost = 300

/obj/structure/ship_ammo/rocket/widowmaker/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 300, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS) //Your standard HE splash damage rocket. Good damage, good range, good speed, it's an all rounder
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/banshee
	name = "\improper AGM-228W 'Banshee'"
	desc = "The AGM-228W missile is a recently new addition of the overhauled dropship fleet against any mobile or armored ground targets. It's earned the nickname of 'Banshee' from the sudden wail that it emits right before hitting a target. This variation utilizes a mixture of white phosphorus and jelled gasoline, useful for burning large areas. Can be loaded into the LAU-444 Guided Missile Launcher."
	icon_state = "banshee"
	ammo_id = "b"
	point_cost = 300

/obj/structure/ship_ammo/rocket/banshee/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 225, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS) //Small explosive power compensated by its fire + white phosphorous effect
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 4, 15, 50, "#00b8ff"), 1 SECONDS) //Very intense but the fire doesn't last very long
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), impact, 4, /obj/effect/particle_effect/smoke/phosphorus), null, 6)
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/keeper
	name = "\improper GBU-67 'Keeper II'"
	desc = "The GBU-67 'Keeper II' is the latest in a generation of laser guided weaponry that spans all the way back to the 20th century. Earning its nickname from a shortening of 'Peacekeeper' which comes from the program that developed its guidance system and the various uses of it during peacekeeping conflicts. Its payload is designed to devastate armored targets. It can penetrate through metal ceilings. Can be loaded into the LAU-444 Guided Missile Launcher."
	icon_state = "paveway"
	travelling_time = 20 //A fast payload due to its very tight blast zone
	ammo_id = "k"
	accuracy_range = 2
	max_inaccuracy = 3
	point_cost = 300
	metalbreaker = TRUE // Can pierce metal roofs like mortars

/obj/structure/ship_ammo/rocket/keeper/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 450, 100, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS) //Insane fall off combined with insane damage makes the Keeper useful for single targets, but very bad against multiple.
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/harpoon
	name = "\improper AGM-184 'Harpoon II'"
	desc = "The AGM-184 Harpoon II is an Anti-Ship Missile, designed and used to effectively take down enemy ships with a huge blast wave with low explosive power. This one is modified to use ground signals and can be seen as a cheaper alternative to conventional ordnance. Can be loaded into the LAU-444 Guided Missile Launcher."
	icon_state = "harpoon"
	ammo_id = "s"
	travelling_time = 50
	point_cost = 200
	fire_mission_delay = 4

/obj/structure/ship_ammo/rocket/harpoon/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 200, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/napalm
	name = "\improper AGM-99 'Napalm'"
	desc = "The AGM-99 'Napalm' is an incendiary missile used to turn specific targeted areas into giant balls of fire for a long time. Can be loaded into the LAU-444 Guided Missile Launcher and LAB-107 Bomb Bay."
	icon_state = "napalm"
	ammo_id = "n"
	equipment_type = list(/obj/structure/dropship_equipment/weapon/rocket_pod, /obj/structure/dropship_equipment/weapon/bomb_bay, /obj/structure/dropship_equipment/autoreloader)
	point_cost = 500
	fire_mission_delay = 0 //0 means unusable

/obj/structure/ship_ammo/rocket/napalm/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 300, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 6, 60, 30, "#EE6515"), 0.5 SECONDS) //Color changed into napalm's color to better convey how intense the fire actually is.
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/rocket/thermobaric
	name = "\improper BLU-200 'Dragon's Breath'"
	desc = "The BLU-200 'Dragon's Breath' is a thermobaric fuel-air bomb. The aerosolized fuel mixture creates a vacuum when ignited causing serious damage to those in its way. Can be loaded into the LAU-444 Guided Missile Launcher."
	icon_state = "fatty"
	ammo_id = "f"
	travelling_time = 50
	point_cost = 300

/obj/structure/ship_ammo/rocket/thermobaric/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 4, 25, 50, "#c96500"), 0.5 SECONDS) //Very intense but the fire doesn't last very long
	for(var/mob/living/carbon/victim in orange(5, impact))
		victim.throw_atom(impact, 3, 15, src, TRUE) // Implosion throws affected towards center of vacuum
	QDEL_IN(src, 0.5 SECONDS)


//minirockets

/obj/structure/ship_ammo/minirocket
	name = "\improper AGR-59 'Mini-Mike'"
	desc = "The AGR-59 'Mini-Mike' minirocket is a cheap and efficient means of putting hate down range. Though rockets lack a guidance package, it makes up for it in ammunition count. Can be loaded into the LAU-229 Rocket Pod."
	icon_state = "minirocket"
	equipment_type = /obj/structure/dropship_equipment/weapon/minirocket_pod
	ammo_count = 6
	max_ammo_count = 6
	ammo_name = "minirocket"
	travelling_time = 80 //faster than 30mm cannon, slower than real rockets
	transferable_ammo = TRUE
	point_cost = 300
	fire_mission_delay = 3 //high cooldown

/obj/structure/ship_ammo/minirocket/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(2)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 200, 44, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion_particles), impact, 4), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), impact, 1, /obj/effect/particle_effect/smoke, null, 1), 1 SECONDS)
	if(!ammo_count && loc)
		qdel(src) //deleted after last minirocket is fired and impact the ground.

/obj/structure/ship_ammo/minirocket/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] containing [ammo_count] minirocket\s."

/obj/structure/ship_ammo/minirocket/get_examine_text(mob/user)
	. = ..()
	. += "It has [ammo_count] minirocket\s."


/obj/structure/ship_ammo/minirocket/incendiary
	name = "\improper AGR-59-I 'Mini-Mike'"
	desc = "The AGR-59-I 'Mini-Mike' incendiary minirocket is a cheap and efficient means of putting hate down range AND setting them on fire! Though rockets lack a guidance package, it makes up for it in ammunition count. Can be loaded into the LAU-229 Rocket Pod."
	icon_state = "minirocket_inc"
	point_cost = 500
	fire_mission_delay = 3 //high cooldown

/obj/structure/ship_ammo/minirocket/incendiary/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	..()
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), impact, create_cause_data(initial(name), source_mob), 3, 25, 20, "#EE6515"), 0.5 SECONDS)

//missiles

/obj/structure/ship_ammo/missile
	name = "abstract missile"
	icon_state = "double"
	icon = 'icons/obj/structures/props/dropship/dropship_ammo64.dmi'
	equipment_type = list(/obj/structure/dropship_equipment/weapon/missile_silo, /obj/structure/dropship_equipment/autoreloader)
	ammo_count = 4
	max_ammo_count = 4
	ammo_name = "missile"
	travelling_time = 60 // can't be fired on direct so this won't come into play
	transferable_ammo = TRUE
	point_cost = 300
	fire_mission_delay = 2 //low cooldown
	ammo_id = ""
	bound_width = 64
	bound_height = 32
	accuracy_range = 2 // missiles are tailored for accurate low altitude ground bombardment
	max_inaccuracy = 5
	point_cost = 0
	ammo_used_per_firing = 1

/obj/structure/ship_ammo/missile/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	qdel(src)

/obj/structure/ship_ammo/missile/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] containing [ammo_count] missile\s."

/obj/structure/ship_ammo/missile/get_examine_text(mob/user)
	. = ..()
	. += "It has [ammo_count] missile\s."

/obj/structure/ship_ammo/missile/zeus
	name = "\improper MK.12 'Zeus'"
	desc = "The MK.12 'Zeus' is an unguided, spin stabilized rocket system which has become a mainstay option for low altitude air strikes against personnel. Its nickname 'Zeus' comes from its resembelance to a bolt of lightning when striking upon targets. It is capable of being fired from the Mk.14 Missile Silo."
	icon_state = "zeus"
	ammo_id = "z"
	travelling_time = 40
	point_cost = 300

/obj/structure/ship_ammo/missile/zeus/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(2)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 250, 40, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion_particles), impact, 3), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), impact, 2, /obj/effect/particle_effect/smoke, null, 2), 1 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_shrapnel), impact, 60, 0, 360, /datum/ammo/bullet/shrapnel/hornet_rounds, create_cause_data(initial(name), source_mob), FALSE, 100), 0.5 SECONDS)
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/missile/sgw
	name = "\improper MK.91 'SGW'"
	desc = "The MK.91 'SGW' is short range 'fire and forget' missile designed for use against light armor and entrenched positions. Its popularity skyrocketed upon rumors of a single well placed payload decimating an entire CLF guerilla bunker. It is capable of being fired from the Mk.14 Missile Silo."
	icon_state = "sgw"
	ammo_id = "sg"
	travelling_time = 40
	point_cost = 300
	ammo_count = 4
	max_ammo_count = 4
	fire_mission_delay = 3 // moderate cooldown

/obj/structure/ship_ammo/missile/sgw/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(2)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 290, 70, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion_particles), impact, 3), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), impact, 2, /obj/effect/particle_effect/smoke, null, 2), 1 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_shrapnel), impact, 60, 0, 360, /datum/ammo/bullet/shrapnel/metal, create_cause_data(initial(name), source_mob), FALSE, 100), 0.5 SECONDS)
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/missile/banshee
	name = "\improper MK.25 'Banshee'"
	desc = "The Mk.25 'Banshee' is modified version of the standard AGM-228, designed for use in missile silos. As opposed to releasing a flaming willypete compound, it instead employs incendiary flechette capable of puncturing and igniting heavy armor. It is capable of being fired from the Mk.14 Missile Silo."
	icon_state = "bansheeM"
	ammo_id = "bm"
	travelling_time = 40
	point_cost = 300
	ammo_count = 4
	max_ammo_count = 4

/obj/structure/ship_ammo/missile/banshee/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(2)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 225, 50, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion_particles), impact, 3), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), impact, 2, /obj/effect/particle_effect/smoke, null, 2), 1 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_shrapnel), impact, 60, 0, 360, /datum/ammo/bullet/shrapnel/incendiary, create_cause_data(initial(name), source_mob), FALSE, 100), 0.5 SECONDS)
	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/missile/hellhound
	name = "\improper ATM-230D 'HELLHOUND IV'"
	desc = "The ATM-230D 'HELLHOUND IV' is the latest installment of multi-role tactical missiles employed by gunship pilots. Designed specifically for use against high priority targets such as vehicles, buildings and bunkers, it houses a complicated three stage motor. It is capable of piercing through caves. It is capable of being fired from the Mk.14 Missile Silo."
	icon_state = "hellhound"
	ammo_id = "h"
	travelling_time = 40
	point_cost = 500
	ammo_count = 4
	max_ammo_count = 4
	fire_mission_delay = 4 // high cooldown
	cavebreaker = TRUE // Designed for bunker busting

/obj/structure/ship_ammo/missile/hellhound/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(2)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 350, 75, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion_particles), impact, 6), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), impact, 3, /obj/effect/particle_effect/smoke, null, 2), 1 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_shrapnel), impact, 75, 0, 360, /datum/ammo/bullet/shrapnel/breaching, create_cause_data(initial(name), source_mob), FALSE, 100), 0.5 SECONDS)
	QDEL_IN(src, 0.5 SECONDS)

//bombs

/obj/structure/ship_ammo/bomb
	name = "abstract bomb"
	icon_state = "double"
	icon = 'icons/obj/structures/props/dropship/dropship_ammo64.dmi'
	equipment_type = /obj/structure/dropship_equipment/weapon/bomb_bay
	ammo_count = 1
	max_ammo_count = 1
	ammo_name = "bomb"
	travelling_time = 80 //bombs are slow, but they hit hard
	transferable_ammo = TRUE
	point_cost = 0
	fire_mission_delay = 0 //unusable in firemissions
	ammo_id = ""
	bound_width = 64
	bound_height = 32
	accuracy_range = 3 // bombs are a bit inaccurate
	max_inaccuracy = 5
	point_cost = 0
	ammo_used_per_firing = 1
	metalbreaker = TRUE // Can pierce metal roofs like mortars

/obj/structure/ship_ammo/bomb/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	qdel(src)

/obj/structure/ship_ammo/bomb/show_loaded_desc(mob/user)
	if(ammo_count)
		return "It's loaded with \a [src] containing [ammo_count] bomb\s."

/obj/structure/ship_ammo/bomb/get_examine_text(mob/user)
	. = ..()
	. += "It has [ammo_count] bomb\s."

/obj/structure/ship_ammo/bomb/cluster
	name = "\improper SM-21 'Chubby'"
	desc = "The SM-21 'Chubby' is a cluster-bomb type ordnance that only requires laser-guidance when first launched. Derived from the popular SM-17 'Fatty', this is a smaller and more compact version of its predecessor, primarily used against target rich environments. It can penetrate through metal ceilings. It is capable of being dropped from the LAB-107 Bomb Bay."
	icon_state = "chubby"
	ammo_id = "c"
	travelling_time = 70 //slow but accurate
	accuracy_range = 2
	max_inaccuracy = 3
	point_cost = 400

/obj/structure/ship_ammo/bomb/cluster/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	// Make debris fall from the ceiling when the bomb lands
	impact.ceiling_debris(3)
	// Initial small explosion
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), impact, 150, 25, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(initial(name), source_mob)), 0.5 SECONDS)

	// Diamond-shaped cluster explosions - center plus 4 cardinal directions
	var/list/diamond_coords = list(
		list(0, 0),   // Center
		list(0, 3),   // North
		list(3, 0),   // East
		list(0, -3),  // South
		list(-3, 0)   // West
	)

	var/cached_name = initial(name)
	var/mob/cached_source_mob = source_mob

	// Schedule cluster explosions with rapid delays and warning dots
	for(var/i = 1 to diamond_coords.len)
		var/list/coords = diamond_coords[i]
		var/turf/target_turf = locate(impact.x + coords[1], impact.y + coords[2], impact.z)
		if(target_turf)
			// Schedule warning dot and explosion (using global procs to avoid src dependency)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_in_a_hole_cluster), target_turf, 200, 50, cached_name, cached_source_mob), (0.5 + i * 0.1) SECONDS)

	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/bomb/incendiary
	name = "\improper AGM-81 'Firecracker'"
	desc = "The AGM-81 'Firecracker' is a cluster incendiary bomb designed for area denial and anti-personnel use. A more streamlined version of the AGM-99 'Napalm', it earned its nickname 'Firecracker' due to the crackling of its incendiary reaction upon detonation. It can penetrate through metal ceilings. It is capable of being dropped from the LAB-107 Bomb Bay."
	icon_state = "firecracker"
	ammo_id = "fr"
	travelling_time = 70 // slow but powerful
	accuracy_range = 3
	max_inaccuracy = 5
	point_cost = 400

/obj/structure/ship_ammo/bomb/incendiary/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	// Make debris fall from the ceiling when the bomb lands
	impact.ceiling_debris(3)
	// Get all turfs in a 7x7 area around the impact
	var/list/target_turfs = RANGE_TURFS(3, impact) // 3 range = 7x7 area

	var/cached_name = initial(name)
	var/mob/cached_source_mob = source_mob

	// Create 5 random explosions with napalm fire spread and warning dots
	var/list/selected_turfs = list()
	for(var/i = 1 to 5)
		var/turf/target_turf = pick(target_turfs)
		selected_turfs += target_turf
		if(target_turf)
			// Schedule warning dot, explosion and fire (using global procs to avoid src dependency)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_in_a_hole_incendiary), target_turf, 150, 50, cached_name, cached_source_mob), (0.3 + i * 0.1) SECONDS)

	QDEL_IN(src, 0.5 SECONDS)

/obj/structure/ship_ammo/bomb/bunkerbuster
	name = "\improper AGM-98 'MOP'"
	desc = "The latest cutting edge installment of heavy duty missiles, the AGM-98 'Massive Ordinance Penetrator' is a heavy duty bunker busting bomb designed to penetrate hardened structures and deliver a devastating payload. It is intentionally set to a delayed fuse to further maximize penetration before detonation. It can penetrate through caves. It is capable of being dropped from the LAB-107 Bomb Bay."
	icon_state = "bunkerbuster"
	ammo_id = "bb"
	travelling_time = 80 // very slow but powerful and accurate
	accuracy_range = 1
	max_inaccuracy = 2
	point_cost = 800
	cavebreaker = TRUE // Designed for bunker busting

/obj/structure/ship_ammo/bomb/bunkerbuster/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	impact.ceiling_debris_check(3)
	// Create the physical bomb object that lands first
	var/obj/item/explosive/bomb_payload/bunker_buster/bomb_obj = new(impact)
	bomb_obj.source_mob = source_mob
	bomb_obj.fired_from_name = initial(name)

	// Make debris fall from the ceiling when the bomb lands
	impact.ceiling_debris(3)

	// Schedule the delayed explosion
	addtimer(CALLBACK(bomb_obj, TYPE_PROC_REF(/obj/item/explosive/bomb_payload/bunker_buster, detonate)), 2 SECONDS)

	QDEL_IN(src, 0.1 SECONDS)

// Physical bomb object that appears on the ground with a 2 seconds delayed fuse, giving xenos even MORE time to run away
/obj/item/explosive/bomb_payload/bunker_buster
	name = "AGM-98 'MOP' warhead"
	desc = "A massive ordnance penetrator bomb that has embedded itself halfway into the ground. It looks like it's about to explode, run!"
	icon = 'icons/obj/items/weapons/grenade.dmi'
	icon_state = "bunkerbuster_active"
	w_class = SIZE_HUGE
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	var/mob/source_mob
	var/fired_from_name

/obj/item/explosive/bomb_payload/bunker_buster/Initialize()
	. = ..()
	// Add danger overlay and play warning sound
	overlays += new /obj/effect/overlay/danger
	playsound(src, 'sound/effects/bang.ogg', 50, 1)

/obj/item/explosive/bomb_payload/bunker_buster/proc/detonate()
	// One massive explosion with high power and wide range
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), get_turf(src), 500, 100, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(fired_from_name, source_mob)), 0.5 SECONDS)
	// Add some dramatic effects
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(explosion_particles), get_turf(src), 8), 0.5 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(smoke_spread), get_turf(src), 4, /obj/effect/particle_effect/smoke, null, 3), 1.0 SECONDS)

	QDEL_IN(src, 0.1 SECONDS)

//utility

/obj/structure/ship_ammo/sentry
	name = "\improper A/C-49-P Air Deployable Sentry"
	desc = "An omni-directional sentry, capable of defending an area from lightly armored hostile incursion. Can be loaded into the LAG-14 Internal Sentry Launcher."
	icon_state = "launchable_sentry"
	equipment_type = /obj/structure/dropship_equipment/weapon/launch_bay
	ammo_count = 1
	max_ammo_count = 1
	ammo_name = "area denial sentry"
	travelling_time = 0 // handled by droppod
	point_cost = 600 //handled by printer
	accuracy_range = 0 // pinpoint
	max_inaccuracy = 0
	fire_mission_delay = 0 //0 means unusable
	/// Special structures it needs to break with drop pod
	var/list/breakeable_structures = list(/obj/structure/barricade, /obj/structure/surface/table)

/obj/structure/ship_ammo/sentry/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	var/obj/structure/droppod/equipment/sentry/droppod = new(impact, /obj/structure/machinery/defenses/sentry/launchable, source_mob)
	droppod.special_structures_to_damage = breakeable_structures
	droppod.special_structure_damage = 500
	droppod.drop_time = 5 SECONDS
	droppod.launch(impact)
	qdel(src)

/obj/structure/ship_ammo/sentry/can_fire_at(turf/impact, mob/user)
	for(var/obj/structure/machinery/defenses/def in range(4, impact))
		to_chat(user, SPAN_WARNING("The selected drop site is too close to another deployed defense!"))
		return FALSE
	if(istype(impact, /turf/closed))
		to_chat(user, SPAN_WARNING("The selected drop site is a sheer wall!"))
		return FALSE
	return TRUE

/obj/structure/ship_ammo/flare
	name = "\improper AN/ALE-557 Flare Launcher cartridge"
	desc = "A cartidge containing several M97-P flare sticks packed tightly into individual silos. These parachute flares are designed to be launched out of a dropship's flare launcher to provide battlefield illumination during hours of darkness. Use a screwdriver to disable the safety panel."
	icon_state = "flare_cartridge_safety"
	equipment_type = /obj/structure/dropship_equipment/weapon/flare_launcher
	safety_enabled = TRUE // safety is enabled by default, preventing loading into a flare launcher
	point_cost = 100
	ammo_count = 3
	max_ammo_count = 6
	travelling_time = 20 // parachute flares light up the sky very quickly
	accuracy_range = 4 // though not very accurate
	max_inaccuracy = 6
	handheld = TRUE // flare cartridges are manually installed by hand
	density = FALSE
	anchored = FALSE
	handheld_type = /obj/item/ship_ammo_handheld/flare

/obj/structure/ship_ammo/flare/detonate_on(turf/impact, obj/structure/dropship_equipment/weapon/fired_from)
	new /obj/item/device/flashlight/flare/on/illumination/parachute(impact)
	playsound(impact, 'sound/weapons/gun_flare.ogg', 50, 1, 4)

/obj/structure/ship_ammo/flare/update_icon()
	if (safety_enabled)
		icon_state = "flare_cartridge_safety"
	else
		icon_state = "flare_cartridge"

/obj/structure/ship_ammo/flare/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/screwdriver))
		if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
			return
		if(safety_enabled)
			safety_enabled = FALSE
			icon_state = "flare_cartridge"
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, SPAN_NOTICE("You disable the safety on [src]. It can now be loaded into a flare launcher."))
		else
			safety_enabled = TRUE
			icon_state = "flare_cartridge_safety"
			to_chat(user, SPAN_NOTICE("You re-enable the safety on [src]. It can no longer be loaded into a flare launcher."))
		return
	. = ..()

// Handheld item version of ship_ammo
/obj/item/ship_ammo_handheld
	var/ammo_count
	var/max_ammo_count
	var/safety_enabled = FALSE
	var/structure_type = null

/obj/item/ship_ammo_handheld/attack_hand(mob/user)
	if(anchored)
		to_chat(user, SPAN_WARNING("[src] is anchored and cannot be picked up."))
		return FALSE
	if(user.is_mob_restrained() || user.buckled || user.is_mob_incapacitated(TRUE))
		to_chat(user, SPAN_WARNING("You can't pick this up right now."))
		return FALSE
	if(ammo_count < 1)
		to_chat(user, SPAN_WARNING("The [src] has ran out of ammo, so you discard it!"))
		qdel(src)
		return FALSE
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/ship_ammo_handheld/I = new src.type()
		I.ammo_count = src.ammo_count
		I.max_ammo_count = src.max_ammo_count
		I.safety_enabled = src.safety_enabled
		I.update_icon()
		if(H.put_in_hands(I))
			qdel(src)
			to_chat(user, SPAN_NOTICE("You pick up [I] by hand."))
			return TRUE
		else
			qdel(I)
			to_chat(user, SPAN_WARNING("You need a free hand to pick this up."))
			return FALSE
	else
		to_chat(user, SPAN_WARNING("You can't pick this up by hand."))
		return FALSE

/obj/item/ship_ammo_handheld/dropped(mob/user)
	. = ..()
	if(QDELETED(src))
		return .
	if(!structure_type)
		return .
	var/turf/T = get_turf(user)
	var/obj/structure/ship_ammo/S = new structure_type(T)
	S.ammo_count = src.ammo_count
	S.max_ammo_count = src.max_ammo_count
	S.safety_enabled = src.safety_enabled
	S.icon_state = src.icon_state
	S.update_icon()
	qdel(src)
	return .

/obj/item/ship_ammo_handheld/flare
	name = "AN/ALE-557 Flare Launcher cartridge"
	desc = "A cartridge containing several M97-P flare sticks packed tightly into individual silos. These parachute flares are designed to be launched out of a dropship's flare launcher to provide battlefield illumination during hours of darkness. Use a screwdriver to disable the safety panel."
	icon = 'icons/obj/structures/props/dropship/dropship_ammo.dmi'
	icon_state = "flare_cartridge_safety"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/dropship_ammo_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/dropship_ammo_righthand.dmi'
	)
	item_state = "flare_cartridge_safety"
	w_class = SIZE_HUGE
	safety_enabled = TRUE
	structure_type = /obj/structure/ship_ammo/flare

/obj/item/ship_ammo_handheld/flare/update_icon()
	if(safety_enabled)
		icon_state = "flare_cartridge_safety"
		item_state = "flare_cartridge_safety"
	else
		icon_state = "flare_cartridge"
		item_state = "flare_cartridge"
	if(iscarbon(loc))
		var/mob/living/carbon/C = loc
		if(C.r_hand == src)
			C.update_inv_r_hand()
		else if(C.l_hand == src)
			C.update_inv_l_hand()

/obj/item/ship_ammo_handheld/flare/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/screwdriver))
		if(!do_after(user, 10, INTERRUPT_NO_NEEDHAND | BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
			return
		if(safety_enabled)
			safety_enabled = FALSE
			to_chat(user, SPAN_NOTICE("You disable the safety on [src]. It can now be loaded into a flare launcher."))
		else
			safety_enabled = TRUE
			to_chat(user, SPAN_NOTICE("You re-enable the safety on [src]. It can no longer be loaded into a flare launcher."))
		update_icon()
		return
	. = ..()

/obj/item/ship_ammo_handheld/bellygun
	name = "PGU-110 25mm Compact ammo crate"
	desc = "A crate full of PGU-110 Compact 25mm rounds designed for precise supporting fire from gunner stations aboard dropships. These smaller, lighter rounds feature enhanced ballistic stability for tighter shot groupings, making them ideal for strikes against light armored insurgents and soft targets. The reduced size allows for manual reloading by crewmembers within the dropship. Can be loaded into the GAU-24/B Belly Gunner Station."
	icon = 'icons/obj/structures/props/dropship/dropship_ammo.dmi'
	icon_state = "30mm_crate_bg"
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/dropship_ammo_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/dropship_ammo_righthand.dmi'
	)
	item_state = "heavygun_bg"
	w_class = SIZE_HUGE
	safety_enabled = FALSE
	structure_type = /obj/structure/ship_ammo/heavygun/bellygun

/obj/structure/ship_ammo/proc/dropped(mob/user)
	return

/obj/structure/ship_ammo/attack_hand(mob/user)
	if(!handheld)
		return ..()
	if(anchored)
		to_chat(user, SPAN_WARNING("[src] is anchored and cannot be picked up."))
		return FALSE
	if(user.is_mob_restrained() || user.buckled || user.is_mob_incapacitated(TRUE))
		to_chat(user, SPAN_WARNING("You can't pick this up right now."))
		return FALSE
	if(ammo_count < 1)
		to_chat(user, SPAN_WARNING("The [src] has ran out of ammo, so you discard it!"))
		qdel(src)
		return FALSE
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(!src.handheld_type)
			to_chat(user, SPAN_WARNING("This ammo cannot be picked up by hand."))
			return FALSE
		var/obj/item/ship_ammo_handheld/I = new src.handheld_type()
		I.ammo_count = src.ammo_count
		I.max_ammo_count = src.max_ammo_count
		I.safety_enabled = src.safety_enabled
		I.structure_type = src.type
		I.update_icon()
		if(H.put_in_hands(I))
			qdel(src)
			to_chat(user, SPAN_NOTICE("You pick up [I] by hand."))
			return TRUE
		else
			qdel(I)
			to_chat(user, SPAN_WARNING("You need a free hand to pick this up."))
			return FALSE
	else
		to_chat(user, SPAN_WARNING("You can't pick this up by hand."))
		return FALSE

// Proc to create warning dots for cluster/incendiary bombs
/obj/structure/ship_ammo/proc/create_warning_dot(turf/target_turf)
	new /obj/effect/overlay/temp/blinking_laser(target_turf)

// Global procedures for cluster/incendiary bomb effects
/proc/fire_in_a_hole_cluster(turf/target_turf, explosion_power, explosion_falloff, weapon_name, mob/source_mob)
	new /obj/effect/overlay/temp/blinking_laser(target_turf)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), target_turf, explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(weapon_name, source_mob)), 1 SECONDS)

/proc/fire_in_a_hole_incendiary(turf/target_turf, explosion_power, explosion_falloff, weapon_name, mob/source_mob)
	new /obj/effect/overlay/temp/blinking_laser(target_turf)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), target_turf, explosion_power, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data(weapon_name, source_mob)), 1 SECONDS)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fire_spread), target_turf, create_cause_data(weapon_name, source_mob), 3, 30, 25, "#EE6515"), 1.2 SECONDS)
