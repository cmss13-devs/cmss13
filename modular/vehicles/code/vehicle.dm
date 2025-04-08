// Внимание!
// Если добавляешь MULTIVEHICLE, то добавляй их в GLOB.all_multi_vehicles
// Чтобы они отслеживались в get_multi_vehicles()
/proc/get_spec_vehicles()
	var/list/spec_vehicles = GLOB.all_spec_vehicles.Copy()
	var/list/names = list()
	var/list/namecounts = list()
	var/list/vehicles = list()
	for(var/obj/vehicle/SV in spec_vehicles)
		var/name = SV.name
		if(name in names)
			namecounts[name]++
			name = "[name] #([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		vehicles[name] = SV

	return vehicles


// ==========================================

// Пересечение ловушек теперь ловит и тех кто посажен за кровать / стул / транспорт
/obj/effect/alien/resin/trap/Crossed(atom/A)
	// !!! Потом выпилить если примут фикс на оффы
	if((isStructure(A) && istype(A, /obj/structure/bed)) || (isVehicle(A) && !isVehicleMultitile(A))) // у нас есть передвижные кровати и коляски от них
		var/obj/O = A
		if(O.buckled_mob)
			var/mob/living/M = O.buckled_mob
			O.unbuckle()
			M.forceMove(get_turf(O))
			HasProximity(M)
			to_chat(M, SPAN_XENOHIGHDANGER("Вы попали в яму полную смолы!"))
		if(istype(O, /obj/vehicle/motorbike))
			var/obj/vehicle/motorbike/OM = O
			if(OM.stroller && OM.stroller.buckled_mob)
				var/mob/living/M = OM.stroller.buckled_mob
				OM.unbuckle() // Просто сбрасываем позади
				M.apply_effect(2, WEAKEN)
				to_chat(M, SPAN_XENOHIGHDANGER("Вы упали с тележки после того как байк въехал в яму полную смолы!"))

	if(trap_type != RESIN_TRAP_EMPTY)
		return
	. = ..()
