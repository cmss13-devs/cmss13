#define BASE_CHEM_STORAGE_RECHARGE_RATE 10
#define BASE_CHEM_STORAGE_MAX_ENERGY 100
#define DYNAMIC_SCALING_CHEM_ENERGY_RATE_PER_MEDIC 5
#define DYNAMIC_SCALING_CHEM_MAX_ENERGY_PER_MEDIC 60
#define DYNAMIC_SCALING_CHEM_ENERGY_MINIMUM_SCALE 4

/// How much the recharge rate of chem storages are scaled by during roundstart (<00:20)
#define ROUNDSTART_RECHARGE_RATE_MULTIPLIER 4

/obj/structure/machinery/chem_storage
	name = "Chemical Storage System"
	desc = "Storage system for a large supply of chemicals, which slowly recharges."
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "chemstorage"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	density = TRUE
	bound_x = 32

	var/network = "Ground"
	var/recharge_cooldown = 8
	var/recharge_rate = BASE_CHEM_STORAGE_RECHARGE_RATE
	var/energy = BASE_CHEM_STORAGE_MAX_ENERGY
	var/max_energy = BASE_CHEM_STORAGE_MAX_ENERGY
	var/dynamic_storage = FALSE
	var/roundstart_buff = FALSE

	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/chem_storage/medbay
	name = "Chemical Storage System (Medbay)"
	network = "Medbay"
	dynamic_storage = TRUE
	roundstart_buff = TRUE

/obj/structure/machinery/chem_storage/research
	name = "Chemical Storage System (Research)"
	network = "Research"

/obj/structure/machinery/chem_storage/misc
	name = "Chemical Storage System (Misc)"
	network = "Misc"

/obj/structure/machinery/chem_storage/Initialize()
	. = ..()
	GLOB.chemical_data.add_chem_storage(src)
	start_processing()

/obj/structure/machinery/chem_storage/Destroy()
	GLOB.chemical_data.remove_chem_storage(src)
	return ..()

/// Scales the energy capacity and charge rates for chemical dispensers using the dynamic_storage var
/obj/structure/machinery/chem_storage/proc/calculate_dynamic_storage(scale, round_start=FALSE)
	if(!dynamic_storage)
		return
	if(scale < DYNAMIC_SCALING_CHEM_ENERGY_MINIMUM_SCALE)
		scale = DYNAMIC_SCALING_CHEM_ENERGY_MINIMUM_SCALE
	recharge_rate = initial(recharge_rate) + floor(scale * DYNAMIC_SCALING_CHEM_ENERGY_RATE_PER_MEDIC)
	max_energy = initial(max_energy) + floor(scale * DYNAMIC_SCALING_CHEM_MAX_ENERGY_PER_MEDIC)
	if(round_start)
		energy = max_energy

/obj/structure/machinery/chem_storage/get_examine_text(mob/user)
	. = ..()
	if(in_range(user, src) || istype(user, /mob/dead/observer))
		var/charge = floor((energy / max_energy) * 100)
		. += SPAN_NOTICE("The charge meter reads [charge]%")

/obj/structure/machinery/chem_storage/process()
	if(recharge_cooldown <= 0)
		recharge()
		recharge_cooldown = initial(recharge_cooldown)
	else
		recharge_cooldown--

/obj/structure/machinery/chem_storage/proc/recharge()
	if(inoperable())
		return
	if(energy >= max_energy)
		return
	var/roundstart_multiplier = (ROUND_TIME < 20 MINUTES && roundstart_buff) ? ROUNDSTART_RECHARGE_RATE_MULTIPLIER : 1
	energy = min(energy + recharge_rate * roundstart_multiplier, max_energy)
	use_power(1500) // This thing uses up a lot of power (this is still low as shit for creating reagents from thin air)

#undef BASE_CHEM_STORAGE_RECHARGE_RATE
#undef BASE_CHEM_STORAGE_MAX_ENERGY
#undef DYNAMIC_SCALING_CHEM_ENERGY_RATE_PER_MEDIC
#undef DYNAMIC_SCALING_CHEM_MAX_ENERGY_PER_MEDIC
#undef DYNAMIC_SCALING_CHEM_ENERGY_MINIMUM_SCALE
#undef ROUNDSTART_RECHARGE_RATE_MULTIPLIER
