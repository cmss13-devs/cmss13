
/obj/structure/machinery/door/airlock/secure/colony
	name = "\improper Secure Airlock"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_com
	openspeed = 4
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/command/colony
	name = "\improper Command Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_com
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/security/colony
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/secdoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_sec
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_SECURITY)

/obj/structure/machinery/door/airlock/engineering/colony
	name = "\improper Engineering Airlock"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_eng
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/medical/colony
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_med
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)


/obj/structure/machinery/door/airlock/maintenance/colony
	name = "\improper Maintenance Hatch"
	icon = 'icons/obj/structures/doors/maintdoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_mai
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC, ACCESS_CIVILIAN_ENGINEERING, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/external/colony
	name = "\improper External Airlock"
	icon = 'icons/obj/structures/doors/Doorext.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_ext
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/glass/colony
	name = "\improper Glass Airlock"
	icon = 'icons/obj/structures/doors/Doorglass.dmi'
	opacity = FALSE
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/centcom/colony
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi'
	opacity = 1
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/vault/colony
	name = "\improper Vault"
	icon = 'icons/obj/structures/doors/vault.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_highsecurity //Until somebody makes better sprites.
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_LEADERSHIP)

/obj/structure/machinery/door/airlock/freezer/colony
	name = "\improper Freezer Airlock"
	icon = 'icons/obj/structures/doors/Doorfreezer.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_fre
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/hatch/colony
	name = "\improper Airtight Hatch"
	icon = 'icons/obj/structures/doors/Doorhatchele.dmi'
	opacity = TRUE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_hatch
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/glass_command/colony
	name = "\improper Command Airlock"
	icon = 'icons/obj/structures/doors/Doorcomglass.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_com
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/glass_engineering/colony
	name = "\improper Engineering Airlock"
	icon = 'icons/obj/structures/doors/engidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_eng
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/glass_security/colony
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/secdoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_sec
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/glass_medical/colony
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_med
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/mining/colony
	name = "\improper Mining Airlock"
	icon = 'icons/obj/structures/doors/Doormining.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_min
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/marine/colony
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/door_marines.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_min

/obj/structure/machinery/door/airlock/atmos/colony
	name = "\improper Atmospherics Airlock"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_atmo
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/research/colony
	name = "\improper Research Airlock"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_research
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/glass_research/colony
	name = "\improper Research Airlock"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_research
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/glass_mining/colony
	name = "\improper Mining Airlock"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_min
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/glass_atmos/colony
	name = "\improper Atmospherics Airlock"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_atmo
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/requisitions/colony
	name = "\improper Requisitions Bay"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_CIVILIAN_LOGISTICS, ACCESS_MARINE_CARGO)
	opacity = 0
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/gold
	name = "\improper Gold Airlock"
	icon = 'icons/obj/structures/doors/Doorgold.dmi'
	mineral = "gold"

/obj/structure/machinery/door/airlock/silver
	name = "\improper Silver Airlock"
	icon = 'icons/obj/structures/doors/Doorsilver.dmi'
	mineral = "silver"

/obj/structure/machinery/door/airlock/diamond
	name = "\improper Diamond Airlock"
	icon = 'icons/obj/structures/doors/Doordiamond.dmi'
	mineral = "diamond"

/obj/structure/machinery/door/airlock/uranium
	name = "\improper Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/structures/doors/Dooruranium.dmi'
	mineral = "uranium"
	var/last_event = 0

/obj/structure/machinery/door/airlock/uranium/process()
	if(world.time > last_event+20)
		if(prob(50))
			radiate()
		last_event = world.time
	..()

/obj/structure/machinery/door/airlock/uranium/proc/radiate()
	for(var/mob/living/L in range (3,src))
		L.apply_effect(15,IRRADIATE,0)
	return

/obj/structure/machinery/door/airlock/phoron
	name = "\improper Phoron Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/structures/doors/Doorphoron.dmi'
	mineral = "phoron"

/obj/structure/machinery/door/airlock/sandstone
	name = "\improper Sandstone Airlock"
	icon = 'icons/obj/structures/doors/Doorsand.dmi'
	mineral = "sandstone"

/obj/structure/machinery/door/airlock/science/colony
	name = "\improper Research Airlock"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_science
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/glass_science/colony
	name = "\improper Research Airlock"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = 0
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_science
	glass = 1
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/highsecurity/colony
	name = "\improper High Tech Security Airlock"
	icon = 'icons/obj/structures/doors/hightechsecurity.dmi'
	assembly_type = /obj/structure/airlock_assembly/airlock_assembly_highsecurity
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_SECURITY, ACCESS_WY_LEADERSHIP)


//STRATA AIRLOCKS // Add me later y'know?
/obj/structure/machinery/door/airlock/strata
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/strata/strata_doors.dmi' //Whoever made it so each door is it's own sheet and doesn't dynamically use overlays ought to be drawn and quartered.
	openspeed = 5
	req_access = null // Colony side airlocks should not have any sort of access.
	req_one_access = null
	tiles_with = list(
		/obj/structure/window/framed/strata,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/strata/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/maintenance
	name = "\improper Maintenance Airlock"
	icon = 'icons/obj/structures/doors/strata/strata_maint.dmi'

/obj/structure/machinery/door/airlock/strata/maintenance/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/security
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/strata/strata_sec.dmi'

/obj/structure/machinery/door/airlock/strata/security/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/strata/mining
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/strata/strata_mining.dmi'

/obj/structure/machinery/door/airlock/strata/mining/autoname
	autoname = TRUE

//YAUTJA SHIP - CURRENTLY USES STRATA DOORS
/obj/structure/machinery/door/airlock/yautja
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/strata/strata_doors.dmi'
	openspeed = 5
	req_access = null
	req_one_access = null
	tiles_with = list(
		/obj/structure/window/framed/strata,
		/obj/structure/machinery/door/airlock,
	)
	masterkey_resist = TRUE
	no_panel = TRUE
	not_weldable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/airlock/yautja/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/yautja/secure
	heavy = TRUE
	req_one_access = list(ACCESS_YAUTJA_SECURE, ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT)

/obj/structure/machinery/door/airlock/yautja/secure/elder
	req_one_access = list(ACCESS_YAUTJA_ELDER, ACCESS_YAUTJA_ANCIENT)

/obj/structure/machinery/door/airlock/yautja/secure/ancient
	req_one_access = list(ACCESS_YAUTJA_ANCIENT)
	unslashable = TRUE

//FIORINA PENITENTIARY (PRISON_FOP) MAINTENANCE HATCHES

/obj/structure/machinery/door/airlock/prison_hatch
	name = "\improper Maintenance Hatch"
	icon = 'icons/obj/structures/doors/prison_FOP/prison_hatches.dmi'
	openspeed = 5
	req_access = null
	req_one_access = null
	tiles_with = list(
		/obj/structure/window/framed/prison,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/prison_hatch/autoname
	autoname = TRUE

//ALMAYER AIRLOCKS

/obj/structure/machinery/door/airlock/almayer
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi' //Tiles with is here FOR SAFETY PURPOSES
	openspeed = 4 //shorter open animation.
	tiles_with = list(
		/obj/structure/window/framed/almayer,
		/obj/structure/machinery/door/airlock,
	)

/obj/structure/machinery/door/airlock/almayer/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/door/airlock/almayer/LateInitialize()
	. = ..()
	relativewall_neighbours()

/obj/structure/machinery/door/airlock/almayer/take_damage(dam, mob/M)
	var/damage_check = max(0, damage + dam)
	if(damage_check >= damage_cap && M && is_mainship_level(z))
		SSclues.create_print(get_turf(M), M, "The fingerprint contains bits of wire and metal specks.")

	..()

/obj/structure/machinery/door/airlock/almayer/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/security
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/secdoor.dmi'
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/machinery/door/airlock/almayer/security/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/almayer/security/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/security/reinforced
	name = "\improper Reinforced Security Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/security/reinforced/colony
	name = "\improper Reinforced Security Airlock"
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/almayer/security/glass
	name = "\improper Security Airlock"
	icon = 'icons/obj/structures/doors/secdoor_glass.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/security/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)


/obj/structure/machinery/door/airlock/almayer/security/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/security/glass/reinforced
	name = "\improper Reinforced Security Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/security/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND)

/obj/structure/machinery/door/airlock/almayer/command
	name = "\improper Command Airlock"
	icon = 'icons/obj/structures/doors/comdoor.dmi'
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/command/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/command/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/command/reinforced
	name = "\improper Reinforced Command Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/command/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_BRIG, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/secure
	name = "\improper Secure Airlock"
	icon = 'icons/obj/structures/doors/securedoor.dmi'
	req_access = list(ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/secure/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/secure/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/secure/reinforced
	name = "\improper Reinforced Secure Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/secure/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/maint
	name = "\improper Maintenance Hatch"
	icon = 'icons/obj/structures/doors/maintdoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_MAINT)

/obj/structure/machinery/door/airlock/almayer/maint/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/maint/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/maint/colony/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/maint/reinforced
	name = "\improper Reinforced Maintenance Hatch"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/maint/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/engineering
	name = "\improper Engineering Airlock"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	opacity = FALSE
	glass = 1
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_ENGINEERING)

/obj/structure/machinery/door/airlock/almayer/engineering/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/almayer/engineering/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/engineering/glass
	name = "\improper Engineering Airlock"
	icon = 'icons/obj/structures/doors/engidoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/engineering/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/almayer/engineering/reinforced
	name = "\improper Reinforced Engineering Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/engineering/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_ENGINEERING, ACCESS_CIVILIAN_LOGISTICS)

/obj/structure/machinery/door/airlock/almayer/engineering/reinforced/OT
	name = "\improper Ordnance Workshop"
	icon = 'icons/obj/structures/doors/engidoor.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_OT)

/obj/structure/machinery/door/airlock/almayer/medical
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/medical/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/medical/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/medical/glass
	name = "\improper Medical Airlock"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = FALSE
	glass = 1
	req_access = list()
	req_one_access = list(ACCESS_MARINE_MEDBAY, ACCESS_MARINE_COMMAND)

/obj/structure/machinery/door/airlock/almayer/medical/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/almayer/medical/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/research
	name = "\improper Research Airlock"
	icon = 'icons/obj/structures/doors/medidoor.dmi'
	req_one_access = list(ACCESS_MARINE_RESEARCH, ACCESS_WY_RESEARCH, ACCESS_WY_EXEC)

/obj/structure/machinery/door/airlock/almayer/research/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/almayer/research/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/research/reinforced
	name = "\improper Reinforced Research Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/research/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL, ACCESS_WY_RESEARCH)

/obj/structure/machinery/door/airlock/almayer/research/glass
	name = "\improper Research Airlock"
	icon = 'icons/obj/structures/doors/medidoor_glass.dmi'
	opacity = FALSE
	glass = 1
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/door/airlock/almayer/research/glass/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/research/glass/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/research/glass/reinforced
	name = "\improper Reinforced Research Airlock"
	masterkey_resist = TRUE

/obj/structure/machinery/door/airlock/almayer/research/glass/reinforced/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/almayer/generic
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'

/obj/structure/machinery/door/airlock/almayer/generic/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/rusted
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/rusted_door.dmi'

/obj/structure/machinery/door/airlock/almayer/generic/autoname/rusted
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/rusted_door.dmi'

/obj/structure/machinery/door/airlock/almayer/generic/rusted_white
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/white_rusted_solid.dmi'

/obj/structure/machinery/door/airlock/almayer/generic/autoname/rusted_wite
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/white_rusted_solid.dmi'

/obj/structure/machinery/door/airlock/almayer/generic/glass
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/personaldoor_glass.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/glass/rusted_window
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/rusted_door_window.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/glass/rusted_window_small
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/rusted_door_windowsmall.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/autoname/glass/rusted_window
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/rusted_door_window.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/autoname/glass/rusted_window_small
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/rusted_door_windowsmall.dmi'
	opacity = FALSE
	glass = TRUE

/obj/structure/machinery/door/airlock/almayer/generic/corporate
	name = "Corporate Liaison's Quarters"
	icon = 'icons/obj/structures/doors/personaldoor.dmi'
	req_access = list(ACCESS_WY_GENERAL)

/obj/structure/machinery/door/airlock/almayer/generic/press
	name = "Press Office"
	req_access = list(ACCESS_PRESS)

/obj/structure/machinery/door/airlock/almayer/marine
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/autoname
	autoname = TRUE

/obj/structure/machinery/door/airlock/almayer/marine/requisitions
	name = "\improper Requisitions Bay"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_access = list()
	req_one_access = list(ACCESS_MARINE_COMMAND, ACCESS_MARINE_CARGO)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/requisitions/colony
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_LOGISTICS, ACCESS_MARINE_CARGO)

/obj/structure/machinery/door/airlock/almayer/marine/alpha
	name = "\improper Alpha Squad Preparations"
	icon = 'icons/obj/structures/doors/prepdoor_alpha.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/sl
	name = "\improper Alpha Squad Leader Preparations"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/spec
	name = "\improper Alpha Squad Specialist Preparations"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/engineer
	name = "\improper Alpha Squad ComTech Preparations"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/medic
	name = "\improper Alpha Squad Medical Preparations"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/alpha/smart
	name = "\improper Alpha Squad Smartgunner Preparations"
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_ALPHA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo
	name = "\improper Bravo Squad Preparations"
	icon = 'icons/obj/structures/doors/prepdoor_bravo.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_BRAVO)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/sl
	name = "\improper Bravo Squad Leader Preparations"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/spec
	name = "\improper Bravo Squad Specialist Preparations"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/engineer
	name = "\improper Bravo Squad ComTech Preparations"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/medic
	name = "\improper Bravo Squad Medical Preparations"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/bravo/smart
	name = "\improper Bravo Squad Smartgunner Preparations"
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_BRAVO)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie
	name = "\improper Charlie Squad Preparations"
	icon = 'icons/obj/structures/doors/prepdoor_charlie.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/sl
	name = "\improper Charlie Squad Leader Preparations"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/spec
	name = "\improper Charlie Squad Specialist Preparations"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/engineer
	name = "\improper Charlie Squad ComTech Preparations"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/medic
	name = "\improper Charlie Squad Medical Preparations"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/charlie/smart
	name = "\improper Charlie Squad Smartgunner Preparations"
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_CHARLIE)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta
	name = "\improper Delta Squad Preparations"
	icon = 'icons/obj/structures/doors/prepdoor_delta.dmi'
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/sl
	name = "\improper Delta Squad Leader Preparations"
	req_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/spec
	name = "\improper Delta Squad Specialist Preparations"
	req_access = list(ACCESS_MARINE_SPECPREP, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/engineer
	name = "\improper Delta Squad ComTech Preparations"
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/medic
	name = "\improper Delta Squad Medical Preparations"
	req_access = list(ACCESS_MARINE_MEDPREP, ACCESS_MARINE_DELTA)
	req_one_access = list()
	dir = SOUTH
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/delta/smart
	name = "\improper Delta Squad Smartgunner Preparations"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_SMARTPREP)
	dir = SOUTH
	opacity = FALSE
	glass = 1

//TL doors, yes this is stupid

/obj/structure/machinery/door/airlock/almayer/marine/alpha/tl
	name = "\improper Alpha Squad Fireteam Leader Preparations"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

/obj/structure/machinery/door/airlock/almayer/marine/bravo/tl
	name = "\improper Bravo Squad Fireteam Leader Preparations"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

/obj/structure/machinery/door/airlock/almayer/marine/charlie/tl
	name = "\improper Charlie Squad Fireteam Leader Preparations"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

/obj/structure/machinery/door/airlock/almayer/marine/delta/tl
	name = "\improper Delta Squad Fireteam Leader Preparations"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_TL_PREP)
	dir = SOUTH

//SQUAD PREP SHARED DOORS

/obj/structure/machinery/door/airlock/almayer/marine/shared
	name = "\improper Squads Preparations"
	icon = 'icons/obj/structures/doors/prepdoor.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)
	opacity = FALSE
	glass = 1

/obj/structure/machinery/door/airlock/almayer/marine/shared/alpha_bravo
	name = "\improper Alpha-Bravo Squads Preparations"
	icon = 'icons/obj/structures/doors/prepdoor_alpha.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_ALPHA, ACCESS_MARINE_BRAVO)

/obj/structure/machinery/door/airlock/almayer/marine/shared/alpha_bravo/yellow
	icon = 'icons/obj/structures/doors/prepdoor_bravo.dmi'

/obj/structure/machinery/door/airlock/almayer/marine/shared/charlie_delta
	name = "\improper Charlie-Delta Squads Preparations"
	icon = 'icons/obj/structures/doors/prepdoor_charlie.dmi'
	req_one_access = list(ACCESS_MARINE_PREP, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO, ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DELTA)

/obj/structure/machinery/door/airlock/almayer/marine/shared/charlie_delta/blue
	icon = 'icons/obj/structures/doors/prepdoor_delta.dmi'

//DROPSHIP SIDE AIRLOCKS

/obj/structure/machinery/door/airlock/dropship_hatch
	name = "\improper Dropship Hatch"
	icon = 'icons/obj/structures/doors/dropship1_side.dmi' //Tiles with is here FOR SAFETY PURPOSES
	id = "sh_dropship1"
	openspeed = 4 //shorter open animation.
	no_panel = 1
	not_weldable = 1
	unslashable = TRUE
	unacidable = TRUE

/obj/structure/machinery/door/airlock/dropship_hatch/ex_act(severity)
	return

/obj/structure/machinery/door/airlock/dropship_hatch/unlock(forced = FALSE)
	if(is_reserved_level(z) && !forced) // in flight
		return FALSE
	return ..()

/obj/structure/machinery/door/airlock/dropship_hatch/attack_alien(mob/living/carbon/xenomorph/xeno)

	if(xeno.hive_pos != XENO_QUEEN)
		return ..()

	if(!locked)
		return ..()

	to_chat(xeno, SPAN_NOTICE("You try and force the doors open"))
	if(do_after(xeno, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE))
		unlock(TRUE)
		open(1)
		lock(TRUE)

/obj/structure/machinery/door/airlock/dropship_hatch/two
	icon = 'icons/obj/structures/doors/dropship2_side.dmi' //Tiles with is here FOR SAFETY PURPOSES
	id = "sh_dropship2"

/obj/structure/machinery/door/airlock/dropship_hatch/monorail
	icon = 'icons/obj/structures/doors/pod_doors.dmi' //TEMPLATE NEED TO REPLACE LATER
	name = "monorail door"
	id = "gr_transport1"

/obj/structure/machinery/door/airlock/hatch/cockpit
	icon = 'icons/obj/structures/doors/dropship1_pilot.dmi'
	name = "cockpit"
	req_access = list(ACCESS_MARINE_DROPSHIP)
	req_one_access = list()
	unslashable = TRUE
	unacidable = TRUE
	no_panel = 1
	not_weldable = 1

/obj/structure/machinery/door/airlock/hatch/cockpit/two
	icon = 'icons/obj/structures/doors/dropship2_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/three
	icon = 'icons/obj/structures/doors/dropship3_pilot.dmi'

/obj/structure/machinery/door/airlock/hatch/cockpit/upp
	icon = 'icons/obj/structures/doors/dropship_upp_pilot.dmi'

//PRISON AIRLOCKS
/obj/structure/machinery/door/airlock/prison
	name = "cell Door"
	icon = 'icons/obj/structures/doors/celldoor.dmi'
	glass = 0

/obj/structure/machinery/door/airlock/prison/horizontal
	dir = SOUTH


// Hybrisa

/obj/structure/machinery/door/airlock/hybrisa
	openspeed = 4

/obj/structure/machinery/door/airlock/hybrisa/generic
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_generic_glass.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = null

/obj/structure/machinery/door/airlock/hybrisa/generic/autoname
	req_access = null
	opacity = FALSE
	glass = TRUE
	autoname = TRUE

/obj/structure/machinery/door/airlock/hybrisa/generic_solid
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_generic.dmi'
	opacity = TRUE
	glass = FALSE
	req_access = null

/obj/structure/machinery/door/airlock/hybrisa/generic_solid/autoname
	autoname = TRUE
	opacity = TRUE
	glass = FALSE
	req_access = null

// Medical

/obj/structure/machinery/door/airlock/hybrisa/medical
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_medidoor_glass.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = null

/obj/structure/machinery/door/airlock/hybrisa/medical/autoname
	autoname = TRUE
	opacity = FALSE
	glass = TRUE
	req_access = null

/obj/structure/machinery/door/airlock/hybrisa/medical_solid
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_medidoor.dmi'
	opacity = TRUE
	glass = FALSE
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

/obj/structure/machinery/door/airlock/hybrisa/medical_solid/autoname
	autoname = TRUE
	opacity = TRUE
	glass = FALSE
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_MEDBAY, ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_CIVILIAN_PUBLIC)

// Personal

/obj/structure/machinery/door/airlock/hybrisa/personal
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_personaldoor_glass.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = null

/obj/structure/machinery/door/airlock/hybrisa/personal/autoname
	autoname = TRUE
	opacity = FALSE
	glass = TRUE
	req_access = null

/obj/structure/machinery/door/airlock/hybrisa/personal_solid
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_personaldoor.dmi'
	opacity = TRUE
	glass = FALSE
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/hybrisa/personal_solid/autoname
	autoname = TRUE
	req_access = null
	opacity = TRUE
	glass = FALSE
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

// Personal White

/obj/structure/machinery/door/airlock/hybrisa/personal_white
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_personaldoor_glass_white.dmi'
	opacity = FALSE
	glass = TRUE
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/hybrisa/personal_white/autoname
	autoname = TRUE
	req_access = null
	opacity = FALSE
	glass = TRUE
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)


/obj/structure/machinery/door/airlock/hybrisa/personal_solid_white
	name = "\improper Airlock"
	icon = 'icons/obj/structures/doors/hybrisa/hybrisa_personaldoor_white.dmi'
	opacity = TRUE
	glass = FALSE
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)

/obj/structure/machinery/door/airlock/hybrisa/personal_solid_white/autoname
	autoname = TRUE
	opacity = TRUE
	glass = FALSE
	req_access = null
	req_one_access = list(ACCESS_CIVILIAN_RESEARCH, ACCESS_CIVILIAN_COMMAND, ACCESS_WY_COLONIAL)
