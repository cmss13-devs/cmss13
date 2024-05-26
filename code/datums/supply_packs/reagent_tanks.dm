// Here will be added all the reagent tank water fuel etc.....

/datum/supply_packs/fueltank
	name = "fuel tank crate (x1)"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"
	group = "Reagent tanks"

/datum/supply_packs/emptytank
	name = "reagent tank crate (x1)"
	contains = list(/obj/structure/reagent_dispensers)
	cost = 10
	containertype = /obj/structure/largecrate
	containername = "empty tank crate"
	group = "Reagent tanks"

/datum/supply_packs/watertank
	name = "water tank crate (x1)"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "water tank crate"
	group = "Reagent tanks"
