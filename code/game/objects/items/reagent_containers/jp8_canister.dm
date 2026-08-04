/obj/item/reagent_container/glass/beaker/jp8_canister
	name = "\improper JP-8 canister"
	desc = "A rugged steel canister for storing and transporting bulk liquids, sized for topping off a vehicle's fuel tank or radiator. Holds up to 500 units."
	icon = 'icons/obj/items/tank.dmi'
	icon_state = "gas"
	item_state = "gas"
	w_class = SIZE_MEDIUM
	matter = list("metal" = 2000)
	volume = 500
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(10, 25, 50, 100, 250, 500)

/obj/item/reagent_container/glass/beaker/jp8_canister/update_icon()
	icon_state = is_open_container() ? "gas" : "gas_closed"

/obj/item/reagent_container/glass/beaker/jp8_canister/full
	desc = "A rugged steel canister for storing and transporting bulk liquids, sized for topping off a vehicle's fuel tank or radiator. Holds up to 500 units. This one is pre-filled with JP-8."

/obj/item/reagent_container/glass/beaker/jp8_canister/full/Initialize(mapload)
	. = ..()
	reagents.add_reagent("jp8", volume)
	update_icon()
