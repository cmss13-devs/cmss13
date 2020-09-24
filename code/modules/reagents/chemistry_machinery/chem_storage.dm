/obj/structure/machinery/chem_storage
	name = "Chemical Storage System"
	desc = "Storage system for a large supply of chemicals, which slowly recharges."
	icon = 'icons/obj/structures/machinery/science_machines_64x32.dmi'
	icon_state = "chemstorage"
	active_power_usage = 1000
	layer = BELOW_OBJ_LAYER
	density = 1
	bound_x = 32

	var/network = "Ground"
	var/recharge_cooldown = 15
	var/recharge_rate = 10
	var/energy = 50
	var/max_energy = 50

/obj/structure/machinery/chem_storage/medbay
	name = "Chemical Storage System (Medbay)"
	network = "Medbay"

/obj/structure/machinery/chem_storage/research
	name = "Chemical Storage System (Research)"
	network = "Research"

/obj/structure/machinery/chem_storage/misc
	name = "Chemical Storage System (Misc)"
	network = "Misc"

/obj/structure/machinery/chem_storage/Initialize()
	. = ..()
	chemical_data.add_chem_storage(src)
	start_processing()

/obj/structure/machinery/chem_storage/examine(mob/user)
	..()
	if(in_range(user, src) || istype(user, /mob/dead/observer))
		var/charge = round((energy / max_energy) * 100)
		to_chat(user, SPAN_NOTICE("The charge meter reads [charge]%"))

/obj/structure/machinery/chem_storage/process()
	if(recharge_cooldown <= 0)
		recharge()
		recharge_cooldown = initial(recharge_cooldown)
	else
		recharge_cooldown -= 1

/obj/structure/machinery/chem_storage/proc/recharge()
	if(inoperable())
		return
	if(energy >= max_energy)
		return
	energy = min(energy + recharge_rate, max_energy)
	use_power(1500) // This thing uses up alot of power (this is still low as shit for creating reagents from thin air)
