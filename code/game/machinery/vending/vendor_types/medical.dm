//------------SUPPLY LINK FOR MEDICAL VENDORS------------

/obj/structure/medical_supply_link
	name = "medilink supply port"
	desc = "A complex network of pipes and machinery, linking to large storage systems below the deck. Medical vendors linked to this port will be able to infinitely restock supplies."
	icon = 'icons/effects/warning_stripes.dmi'
	icon_state = "medlink_unclamped"
	var/base_state = "medlink"
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	plane = FLOOR_PLANE
	layer = ABOVE_TURF_LAYER //It's the floor, man

/obj/structure/medical_supply_link/ex_act(severity, direction)
	return FALSE

/obj/structure/medical_supply_link/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_STRUCTURE_WRENCHED, PROC_REF(do_clamp_animation))
	RegisterSignal(src, COMSIG_STRUCTURE_UNWRENCHED, PROC_REF(do_unclamp_animation))
	update_icon()

/// Performs the clamping animation when a structure is anchored in our loc
/obj/structure/medical_supply_link/proc/do_clamp_animation()
	SIGNAL_HANDLER
	flick("[base_state]_clamping", src)
	addtimer(CALLBACK(src, PROC_REF(update_icon), 2.6 SECONDS))
	update_icon()

/// Performs the unclamping animation when a structure is unanchored in our loc
/obj/structure/medical_supply_link/proc/do_unclamp_animation()
	SIGNAL_HANDLER
	flick("[base_state]_unclamping", src)
	addtimer(CALLBACK(src, PROC_REF(update_icon), 2.6 SECONDS))
	update_icon()

/obj/structure/medical_supply_link/update_icon()
	var/obj/structure/machinery/cm_vending/sorted/medical/vendor = locate() in loc
	if(vendor && vendor.anchored)
		icon_state = "[base_state]_clamped"
	else
		icon_state = "[base_state]_unclamped"

/obj/structure/medical_supply_link/green
	icon_state = "medlink_green_unclamped"
	base_state = "medlink_green"


//------------RESTOCK CARTS FOR MEDICAL VENDORS------------

/obj/structure/restock_cart
	name = "restock cart"
	desc = "A rather heavy cart filled with various supplies to restock a vendor with."
	icon = 'icons/obj/objects.dmi'
	icon_state = "tank_normal" // Temporary
	var/overlay_color = rgb(252, 186, 3) // Temporary
	density = TRUE
	anchored = FALSE
	drag_delay = 2
	health = 100 // Can be destroyed in 2-4 slashes.
	unslashable = FALSE
	///The quantity of things this can restock
	var/supplies_remaining = 20
	///The max quantity of things this can restock
	var/supplies_max = 20
	///The descriptor for the kind of things being restocked
	var/supply_descriptor = "supplies"
	///The sound to play when attacked
	var/attacked_sound = 'sound/effects/metalhit.ogg'
	///The sound to play when destroyed
	var/destroyed_sound = 'sound/effects/metalhit.ogg'
	///Random loot to spawn if destroyed as assoc list of type_path = max_quantity
	var/list/destroyed_loot = list(
		/obj/item/stack/sheet/metal = 2
	)

/obj/structure/restock_cart/medical
	name = "\improper Wey-Yu restock cart"
	desc = "A rather heavy cart filled with various supplies to restock a vendor with. Provided by Wey-Yu Pharmaceuticals Division(TM)."
	icon = 'icons/obj/objects.dmi'
	icon_state = "tank_normal" // Temporary
	supplies_remaining = 20
	supplies_max = 20
	supply_descriptor = "sets of medical supplies"
	destroyed_loot = list(
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/advanced/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/splint = 2,
		/obj/item/device/healthanalyzer = 1,
	)

/obj/structure/restock_cart/medical/reagent
	name = "\improper Wey-Yu reagent restock cart"
	desc = "A rather heavy cart filled with various reagents to restock a vendor with. Provided by Wey-Yu Pharmaceuticals Division(TM)."
	icon_state = "tank_normal" // Temporary
	overlay_color = rgb(252, 115, 3) // Temporary
	supplies_remaining = 1200
	supplies_max = 1200
	supply_descriptor = "units of medical reagents"
	destroyed_sound = 'sound/effects/slosh.ogg'
	destroyed_loot = list()

/obj/structure/restock_cart/Initialize(mapload, ...)
	. = ..()
	supplies_remaining = min(supplies_remaining, supplies_max)
	update_icon()

/obj/structure/restock_cart/update_icon()
	. = ..()
	var/image/overlay_image = image(icon, icon_state = "tn_color") // Temporary
	overlay_image.color = overlay_color
	overlays += overlay_image

/obj/structure/restock_cart/get_examine_text(mob/user)
	. = ..()
	if(get_dist(user, src) > 2 && user != loc)
		return
	. += SPAN_NOTICE("It contains:")
	if(supplies_remaining)
		. += SPAN_NOTICE(" [supplies_remaining] [supply_descriptor].")
	else
		. += SPAN_NOTICE(" Nothing.")

/obj/structure/restock_cart/deconstruct(disassembled)
	playsound(loc, destroyed_sound, 35, 1)
	visible_message(SPAN_NOTICE("[src] falls apart as its contents spill everywhere!"))

	// Assumption: supplies_max is > 0
	if(supplies_remaining > 0 && length(destroyed_loot))
		var/spawned_any = FALSE
		var/probability = supplies_remaining / supplies_max
		for(var/type_path in destroyed_loot)
			if(prob(probability * 100))
				for(var/amount in 1 to rand(1, destroyed_loot[type_path]))
					new type_path(loc)
					spawned_any = TRUE
		if(!spawned_any) // It wasn't empty so atleast drop something
			var/type_path = pick(destroyed_loot)
			for(var/amount in 1 to rand(1, destroyed_loot[type_path]))
				new type_path(loc)

	return ..()

/obj/structure/restock_cart/proc/healthcheck()
	if(health <= 0)
		deconstruct(FALSE)

/obj/structure/restock_cart/bullet_act(obj/projectile/Proj)
	health -= Proj.damage
	playsound(src, attacked_sound, 25, 1)
	healthcheck()
	return TRUE

/obj/structure/restock_cart/attack_alien(mob/living/carbon/xenomorph/user)
	if(unslashable)
		return XENO_NO_DELAY_ACTION
	user.animation_attack_on(src)
	health -= (rand(user.melee_damage_lower, user.melee_damage_upper))
	playsound(src, attacked_sound, 25, 1)
	user.visible_message(SPAN_DANGER("[user] slashes [src]!"), \
	SPAN_DANGER("You slash [src]!"), null, 5, CHAT_TYPE_XENO_COMBAT)
	healthcheck()
	return XENO_ATTACK_ACTION

/obj/structure/restock_cart/ex_act(severity)
	if(indestructible)
		return

	switch(severity)
		if(0 to EXPLOSION_THRESHOLD_LOW)
			if(prob(5))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_LOW to EXPLOSION_THRESHOLD_MEDIUM)
			if(prob(50))
				deconstruct(FALSE)
				return
		if(EXPLOSION_THRESHOLD_MEDIUM to INFINITY)
			deconstruct(FALSE)
			return

//------------SORTED MEDICAL VENDORS------------

/obj/structure/machinery/cm_vending/sorted/medical
	name = "\improper Wey-Med Plus"
	desc = "Medical Pharmaceutical dispenser. Provided by Wey-Yu Pharmaceuticals Division(TM)."
	icon_state = "med"
	req_access = list(ACCESS_MARINE_MEDBAY)

	unacidable = TRUE
	unslashable = FALSE
	wrenchable = TRUE
	hackable = TRUE

	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 0.5 SECONDS

	/// sets vendor to require a medlink to be able to resupply
	var/requires_supply_link_port = TRUE

	var/datum/health_scan/last_health_display

	var/healthscan = TRUE
	var/chem_refill_volume = 600
	var/chem_refill_volume_max = 600
	var/list/chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/bicaridine,
		/obj/item/reagent_container/hypospray/autoinjector/dexalinp,
		/obj/item/reagent_container/hypospray/autoinjector/adrenaline,,
		/obj/item/reagent_container/hypospray/autoinjector/inaprovaline,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane,
		/obj/item/reagent_container/hypospray/autoinjector/oxycodone,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol,
		/obj/item/reagent_container/hypospray/autoinjector/tricord,
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,

		/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless,

		/obj/item/reagent_container/glass/bottle/bicaridine,
		/obj/item/reagent_container/glass/bottle/antitoxin,
		/obj/item/reagent_container/glass/bottle/dexalin,
		/obj/item/reagent_container/glass/bottle/inaprovaline,
		/obj/item/reagent_container/glass/bottle/kelotane,
		/obj/item/reagent_container/glass/bottle/oxycodone,
		/obj/item/reagent_container/glass/bottle/peridaxon,
		/obj/item/reagent_container/glass/bottle/tramadol,
		)

/obj/structure/machinery/cm_vending/sorted/medical/Destroy()
	QDEL_NULL(last_health_display)
	. = ..()

/obj/structure/machinery/cm_vending/sorted/medical/get_examine_text(mob/living/carbon/human/user)
	. = ..()
	if(healthscan)
		. += SPAN_NOTICE("[src] offers assisted medical scans, for ease of use with minimal training. Present the target in front of the scanner to scan.")

/obj/structure/machinery/cm_vending/sorted/medical/ui_data(mob/user)
	. = ..()
	if(LAZYLEN(chem_refill))
		.["reagents"] = chem_refill_volume
		.["reagents_max"] = chem_refill_volume_max

/// checks if there is a supply link in our location and we are anchored to it
/obj/structure/machinery/cm_vending/sorted/medical/proc/get_supply_link()
	if(!anchored)
		return FALSE
	var/obj/structure/medical_supply_link/linkpoint = locate() in loc
	if(!linkpoint)
		return FALSE
	return TRUE

/obj/structure/machinery/cm_vending/sorted/medical/additional_restock_checks(obj/item/item_to_stock, mob/user, list/vendspec)
	var/dynamic_metadata = dynamic_stock_multipliers[vendspec]
	if(dynamic_metadata)
		if(vendspec[2] >= dynamic_metadata[2] && (!requires_supply_link_port || !get_supply_link()))
			to_chat(user, SPAN_WARNING("[src] is already full of [vendspec[1]]!"))
			return FALSE
	else
		stack_trace("[src] could not find dynamic_stock_multipliers for [vendspec[1]]!")

	if(istype(item_to_stock, /obj/item/reagent_container))
		if(istype(item_to_stock, /obj/item/reagent_container/syringe) || istype(item_to_stock, /obj/item/reagent_container/dropper))
			var/obj/item/reagent_container/container = item_to_stock
			if(container.reagents.total_volume != 0)
				to_chat(user, SPAN_WARNING("[item_to_stock] needs to be empty to restock it!"))
				return FALSE
		else
			return try_deduct_chem(item_to_stock, user)

	return TRUE

/// Attempts to consume our reagents needed for the container (doesn't actually change the container)
/// Will return TRUE if reagents were deducated or no reagents were needed
/obj/structure/machinery/cm_vending/sorted/medical/proc/try_deduct_chem(obj/item/reagent_container/container, mob/user)
	var/missing_reagents = container.reagents.maximum_volume - container.reagents.total_volume
	if(missing_reagents <= 0)
		return TRUE
	if(!LAZYLEN(chem_refill) || !(container.type in chem_refill))
		if(container.reagents.total_volume == initial(container.reagents.total_volume))
			return TRUE
		to_chat(user, SPAN_WARNING("[src] cannot refill [container]."))
		return FALSE
	if(chem_refill_volume < missing_reagents)
		var/auto_refill = requires_supply_link_port && get_supply_link()
		to_chat(user, SPAN_WARNING("[src] blinks red and makes a buzzing noise as it rejects [container]. Looks like it doesn't have enough reagents [auto_refill ? "yet" : "left"]."))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 15, TRUE)
		return FALSE

	chem_refill_volume -= missing_reagents
	to_chat(user, SPAN_NOTICE("[src] makes a whirring noise as it refills your [container.name]."))
	playsound(src, 'sound/effects/refill.ogg', 25, 1, 3)
	return TRUE

/obj/structure/machinery/cm_vending/sorted/medical/attackby(obj/item/I, mob/user)
	if(stat != WORKING)
		return ..()

	if(istype(I, /obj/item/reagent_container))
		if(!hacked)
			if(!allowed(user))
				to_chat(user, SPAN_WARNING("Access denied."))
				return

			if(LAZYLEN(vendor_role) && !vendor_role.Find(user.job))
				to_chat(user, SPAN_WARNING("This machine isn't for you."))
				return

		var/obj/item/reagent_container/container = I
		if(istype(I, /obj/item/reagent_container/syringe) || istype(I, /obj/item/reagent_container/dropper))
			stock(container, user)
			return

		if(container.reagents.total_volume == container.reagents.maximum_volume)
			stock(container, user)
			return

		if(!try_deduct_chem(container, user))
			return

		// Since the reagent is deleted on use it's easier to make a new one instead of snowflake checking
		var/obj/item/reagent_container/new_container = new container.type(src)
		qdel(container)
		user.put_in_hands(new_container)
		return

	else if(hacked || (allowed(user) && (!LAZYLEN(vendor_role) || vendor_role.Find(user.job))))
		if(stock(I, user))
			return

	return ..()

/obj/structure/machinery/cm_vending/sorted/medical/MouseDrop(obj/over_object as obj)
	if(stat == WORKING && over_object == usr && CAN_PICKUP(usr, src))
		var/mob/living/carbon/human/user = usr
		if(!hacked && !allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return

		if(!healthscan)
			to_chat(user, SPAN_WARNING("[src] does not have health scanning function."))
			return

		if (!last_health_display)
			last_health_display = new(user)
		else
			last_health_display.target_mob = user

		last_health_display.look_at(user, DETAIL_LEVEL_HEALTHANALYSER, bypass_checks = TRUE)
		return

/obj/structure/machinery/cm_vending/sorted/medical/MouseDrop_T(atom/movable/A, mob/user)
	if(inoperable())
		return
	if(user.stat || user.is_mob_restrained())
		return
	if(get_dist(user, src) > 1 || get_dist(user, A) > 1)
		return
	if(!ishuman(user))
		return

	if(istype(A, /obj/structure/restock_cart/medical))
		var/obj/structure/restock_cart/medical/cart = A
		if(cart.supplies_remaining <= 0)
			to_chat(user, SPAN_WARNING("[cart] is empty!"))
			return
		if(being_restocked)
			to_chat(user, SPAN_WARNING("[src] is already being restocked, you will get in the way!"))
			return

		var/restocking_reagents = istype(cart, /obj/structure/restock_cart/medical/reagent)
		if(restocking_reagents && !LAZYLEN(chem_refill))
			to_chat(user, SPAN_WARNING("[src] doesn't use reagent canisters!"))
			return

		user.visible_message(SPAN_NOTICE("[user] starts stocking a bunch of supplies into [src]."), \
		SPAN_NOTICE("You start stocking a bunch of supplies into [src]."))
		being_restocked = TRUE

		while(cart.supplies_remaining > 0)
			if(!do_after(user, 2 SECONDS, INTERRUPT_ALL, BUSY_ICON_GENERIC, src))
				being_restocked = FALSE
				user.visible_message(SPAN_NOTICE("[user] stopped stocking [src] with supplies."), \
				SPAN_NOTICE("You stop stocking [src] with supplies."))
				return
			if(QDELETED(cart) || get_dist(user, cart) > 1)
				being_restocked = FALSE
				user.visible_message(SPAN_NOTICE("[user] stopped stocking [src] with supplies."), \
				SPAN_NOTICE("You stop stocking [src] with supplies."))
				return

			if(restocking_reagents)
				var/reagent_added = restock_reagents(min(cart.supplies_remaining, 100))
				if(reagent_added <= 0 || chem_refill_volume == chem_refill_volume_max)
					break // All done
				cart.supplies_remaining -= reagent_added
			else
				if(!restock_supplies(prob_to_skip = 0, can_remove = FALSE))
					break // All done
				cart.supplies_remaining--

		being_restocked = FALSE
		user.visible_message(SPAN_NOTICE("[user] finishes stocking [src] with supplies."), \
		SPAN_NOTICE("You finish stocking [src] with supplies."))
		return

	return ..()

/obj/structure/machinery/cm_vending/sorted/medical/populate_product_list(scale)
	listed_products = list(
		list("FIELD SUPPLIES", -1, null, null),
		list("Burn Kit", round(scale * 8), /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", round(scale * 8), /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", round(scale * 8), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", round(scale * 8), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", round(scale * 8), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("AUTOINJECTORS", -1, null, null),
		list("Autoinjector (Bicaridine)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/bicaridine, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Dexalin+)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/dexalinp, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Epinephrine)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/adrenaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Inaprovaline)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Kelotane)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/kelotane, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Oxycodone)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/oxycodone, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tramadol)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/tramadol, VENDOR_ITEM_REGULAR),
		list("Autoinjector (Tricord)", round(scale * 4), /obj/item/reagent_container/hypospray/autoinjector/tricord, VENDOR_ITEM_REGULAR),

		list("LIQUID BOTTLES", -1, null, null),
		list("Bottle (Bicaridine)", round(scale * 4), /obj/item/reagent_container/glass/bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Bottle (Dylovene)", round(scale * 4), /obj/item/reagent_container/glass/bottle/antitoxin, VENDOR_ITEM_REGULAR),
		list("Bottle (Dexalin)", round(scale * 4), /obj/item/reagent_container/glass/bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Bottle (Inaprovaline)", round(scale * 4), /obj/item/reagent_container/glass/bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Bottle (Kelotane)", round(scale * 4), /obj/item/reagent_container/glass/bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Bottle (Oxycodone)", round(scale * 4), /obj/item/reagent_container/glass/bottle/oxycodone, VENDOR_ITEM_REGULAR),
		list("Bottle (Peridaxon)", round(scale * 4), /obj/item/reagent_container/glass/bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Bottle (Tramadol)", round(scale * 4), /obj/item/reagent_container/glass/bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("PILL BOTTLES", -1, null, null),
		list("Pill Bottle (Bicaridine)", round(scale * 3), /obj/item/storage/pill_bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dexalin)", round(scale * 3), /obj/item/storage/pill_bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Dylovene)", round(scale * 3), /obj/item/storage/pill_bottle/antitox, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Inaprovaline)", round(scale * 3), /obj/item/storage/pill_bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Kelotane)", round(scale * 3), /obj/item/storage/pill_bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Peridaxon)", round(scale * 2), /obj/item/storage/pill_bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Pill Bottle (Tramadol)", round(scale * 3), /obj/item/storage/pill_bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("MEDICAL UTILITIES", -1, null, null),
		list("Emergency Defibrillator", round(scale * 3), /obj/item/device/defibrillator, VENDOR_ITEM_REGULAR),
		list("Surgical Line", round(scale * 2), /obj/item/tool/surgery/surgical_line, VENDOR_ITEM_REGULAR),
		list("Synth-Graft", round(scale * 2), /obj/item/tool/surgery/synthgraft, VENDOR_ITEM_REGULAR),
		list("Hypospray", round(scale * 3), /obj/item/reagent_container/hypospray/tricordrazine, VENDOR_ITEM_REGULAR),
		list("Health Analyzer", round(scale * 5), /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Medical Storage Rig", round(scale * 2), /obj/item/storage/belt/medical, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", round(scale * 3), /obj/item/clothing/glasses/hud/health, VENDOR_ITEM_REGULAR),
		list("Stasis Bag", round(scale * 4), /obj/item/bodybag/cryobag, VENDOR_ITEM_REGULAR),
		list("Syringe", round(scale * 7), /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/populate_product_list_and_boxes(scale)
	. = ..()

	// If this is groundside and isn't dynamically changing we will spawn with stock randomly removed from it
	if(vend_flags & VEND_STOCK_DYNAMIC)
		return
	var/turf/location = get_turf(src)
	if(location && is_ground_level(location.z))
		random_unstock()

/obj/structure/machinery/cm_vending/sorted/medical/Initialize()
	. = ..()

	// If this is a medlinked vendor (that needs a link) and isn't dynamically changing it will periodically restock itself
	if(vend_flags & VEND_STOCK_DYNAMIC)
		return
	if(!requires_supply_link_port)
		return
	if(!get_supply_link())
		return
	START_PROCESSING(SSslowobj, src)

/obj/structure/machinery/cm_vending/sorted/medical/toggle_anchored(obj/item/W, mob/user)
	. = ..()

	// If the anchor state changed, this is a vendor that needs a link, and isn't dynamically changing, update whether we automatically restock
	if(. && !(vend_flags & VEND_STOCK_DYNAMIC) && requires_supply_link_port)
		if(get_supply_link())
			START_PROCESSING(SSslowobj, src)
		else
			STOP_PROCESSING(SSslowobj, src)

/obj/structure/machinery/cm_vending/sorted/medical/process()
	if(!get_supply_link())
		STOP_PROCESSING(SSslowobj, src)
		return // Somehow we lost our link
	restock_supplies()
	restock_reagents()

/// Randomly (based on prob_to_skip) adjusts all amounts of listed_products towards their desired values by 1
/// Returns the quantity of items added
/obj/structure/machinery/cm_vending/sorted/medical/proc/restock_supplies(prob_to_skip = 80, can_remove = TRUE)
	. = 0
	for(var/list/vendspec as anything in listed_products)
		if(vendspec[2] < 0)
			continue // It's a section title, not an actual entry
		var/dynamic_metadata = dynamic_stock_multipliers[vendspec]
		if(!dynamic_metadata)
			stack_trace("[src] could not find dynamic_stock_multipliers for [vendspec[1]]!")
			continue
		if(vendspec[2] == dynamic_metadata[2])
			continue // Already at desired value
		if(vendspec[2] > dynamic_metadata[2])
			if(can_remove)
				vendspec[2]--
				update_derived_ammo_and_boxes(vendspec)
			continue // Returned some items to the void
		if(prob(prob_to_skip))
			continue // 20% chance to restock per entry by default
		vendspec[2]++
		update_derived_ammo_and_boxes_on_add(vendspec)
		.++

/// Refills reagents towards chem_refill_volume_max
/// Returns the quantity of reagents added
/obj/structure/machinery/cm_vending/sorted/medical/proc/restock_reagents(additional_volume = 100)
	var/old_value = chem_refill_volume
	chem_refill_volume = min(chem_refill_volume + additional_volume, chem_refill_volume_max)
	return chem_refill_volume - old_value

/// Randomly removes amounts of listed_products and reagents
/obj/structure/machinery/cm_vending/sorted/medical/proc/random_unstock()
	// Random interval of 25 for reagents
	chem_refill_volume = rand(0, chem_refill_volume_max * 0.04) * 25

	for(var/list/vendspec as anything in listed_products)
		var/amount = vendspec[2]
		if(amount <= 0)
			continue

		// Chance to just be empty
		if(prob(25))
			vendspec[2] = 0
			continue

		// Otherwise its some amount between 1 and the original amount
		vendspec[2] = rand(1, amount)

/obj/structure/machinery/cm_vending/sorted/medical/chemistry
	name = "\improper Wey-Chem Plus"
	desc = "Medical chemistry dispenser. Provided by Wey-Yu Pharmaceuticals Division(TM)."
	icon_state = "chem"
	req_access = list(ACCESS_MARINE_CHEMISTRY)

	healthscan = FALSE
	chem_refill_volume = 800
	chem_refill_volume_max = 800
	chem_refill = list(
		/obj/item/reagent_container/glass/bottle/bicaridine,
		/obj/item/reagent_container/glass/bottle/antitoxin,
		/obj/item/reagent_container/glass/bottle/dexalin,
		/obj/item/reagent_container/glass/bottle/inaprovaline,
		/obj/item/reagent_container/glass/bottle/kelotane,
		/obj/item/reagent_container/glass/bottle/oxycodone,
		/obj/item/reagent_container/glass/bottle/peridaxon,
		/obj/item/reagent_container/glass/bottle/tramadol,
	)

/obj/structure/machinery/cm_vending/sorted/medical/chemistry/populate_product_list(scale)
	listed_products = list(
		list("LIQUID BOTTLES", -1, null, null),
		list("Bicaridine Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/bicaridine, VENDOR_ITEM_REGULAR),
		list("Dylovene Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/antitoxin, VENDOR_ITEM_REGULAR),
		list("Dexalin Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/dexalin, VENDOR_ITEM_REGULAR),
		list("Inaprovaline Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/inaprovaline, VENDOR_ITEM_REGULAR),
		list("Kelotane Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/kelotane, VENDOR_ITEM_REGULAR),
		list("Oxycodone Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/oxycodone, VENDOR_ITEM_REGULAR),
		list("Peridaxon Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/peridaxon, VENDOR_ITEM_REGULAR),
		list("Tramadol Bottle", round(scale * 5), /obj/item/reagent_container/glass/bottle/tramadol, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Beaker (60 Units)", round(scale * 3), /obj/item/reagent_container/glass/beaker, VENDOR_ITEM_REGULAR),
		list("Beaker, Large (120 Units)", round(scale * 3), /obj/item/reagent_container/glass/beaker/large, VENDOR_ITEM_REGULAR),
		list("Box of Pill Bottles", round(scale * 2), /obj/item/storage/box/pillbottles, VENDOR_ITEM_REGULAR),
		list("Dropper", round(scale * 3), /obj/item/reagent_container/dropper, VENDOR_ITEM_REGULAR),
		list("Syringe", round(scale * 7), /obj/item/reagent_container/syringe, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/no_access
	req_access = list()

/obj/structure/machinery/cm_vending/sorted/medical/bolted
	wrenchable = FALSE

/obj/structure/machinery/cm_vending/sorted/medical/chemistry/no_access
	req_access = list()

/obj/structure/machinery/cm_vending/sorted/medical/antag
	name = "\improper Medical Equipment Vendor"
	desc = "A vending machine dispensing various pieces of medical equipment."
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	requires_supply_link_port = FALSE
	req_access = null
	vendor_theme = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/sorted/medical/marinemed
	name = "\improper ColMarTech MarineMed"
	desc = "Medical Pharmaceutical dispenser with basic medical supplies for marines."
	icon_state = "marinemed"
	req_access = list()
	req_one_access = list()
	vendor_theme = VENDOR_THEME_USCM

	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,
	)

/obj/structure/machinery/cm_vending/sorted/medical/marinemed/populate_product_list(scale)
	listed_products = list(
		list("AUTOINJECTORS", -1, null, null),
		list("First-Aid Autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/skillless, VENDOR_ITEM_REGULAR),
		list("Pain-Stop Autoinjector", round(scale * 5), /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, VENDOR_ITEM_REGULAR),

		list("DEVICES", -1, null, null),
		list("Health Analyzer", round(scale * 3), /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),

		list("FIELD SUPPLIES", -1, null, null),
		list("Fire Extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("Ointment", round(scale * 7), /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", round(scale * 7), /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", round(scale * 7), /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/medical/marinemed/antag
	name = "\improper Basic Medical Supplies Vendor"
	desc = "A vending machine dispensing basic medical supplies."
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	requires_supply_link_port = FALSE
	req_access = null
	vendor_theme = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/sorted/medical/blood
	name = "\improper MM Blood Dispenser"
	desc = "The Marine Med Brand Blood Pack Dispensary is the premier, top-of-the-line blood dispenser of 2105! Get yours today!" //Don't update this year, the joke is it's old.
	icon_state = "blood"
	wrenchable = TRUE
	hackable = TRUE

	listed_products = list(
		list("BLOOD PACKS", -1, null, null),
		list("A+ Blood Pack", 5, /obj/item/reagent_container/blood/APlus, VENDOR_ITEM_REGULAR),
		list("A- Blood Pack", 5, /obj/item/reagent_container/blood/AMinus, VENDOR_ITEM_REGULAR),
		list("B+ Blood Pack", 5, /obj/item/reagent_container/blood/BPlus, VENDOR_ITEM_REGULAR),
		list("B- Blood Pack", 5, /obj/item/reagent_container/blood/BMinus, VENDOR_ITEM_REGULAR),
		list("O+ Blood Pack", 5, /obj/item/reagent_container/blood/OPlus, VENDOR_ITEM_REGULAR),
		list("O- Blood Pack", 5, /obj/item/reagent_container/blood/OMinus, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Empty Blood Pack", 5, /obj/item/reagent_container/blood, VENDOR_ITEM_REGULAR)
	)

	healthscan = FALSE
	chem_refill = null

/obj/structure/machinery/cm_vending/sorted/medical/blood/bolted
	wrenchable = FALSE

/obj/structure/machinery/cm_vending/sorted/medical/blood/populate_product_list(scale)
	return

/obj/structure/machinery/cm_vending/sorted/medical/blood/antag
	req_one_access = list(ACCESS_ILLEGAL_PIRATE, ACCESS_UPP_GENERAL, ACCESS_CLF_GENERAL)
	requires_supply_link_port = FALSE
	req_access = null
	vendor_theme = VENDOR_THEME_CLF

/obj/structure/machinery/cm_vending/sorted/medical/wall_med
	name = "\improper NanoMed"
	desc = "Wall-mounted Medical Equipment Dispenser."
	icon_state = "wallmed"
	vend_delay = 0.7 SECONDS
	requires_supply_link_port = FALSE

	req_access = list()

	density = FALSE
	wrenchable = FALSE
	listed_products = list(
		list("SUPPLIES", -1, null, null),
		list("First-Aid Autoinjector", 2, /obj/item/reagent_container/hypospray/autoinjector/skillless, VENDOR_ITEM_REGULAR),
		list("Pain-Stop Autoinjector", 2, /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, VENDOR_ITEM_REGULAR),
		list("Roll Of Gauze", 4, /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", 4, /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 2, /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("UTILITY", -1, null, null),
		list("HF2 Health Analyzer", 2, /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR)
	)

	appearance_flags = TILE_BOUND

	chem_refill_volume = 250
	chem_refill_volume_max = 250
	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,
		/obj/item/reagent_container/hypospray/autoinjector/tricord/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/bicaridine/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/kelotane/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/tramadol/skillless,
	)

/obj/structure/machinery/cm_vending/sorted/medical/wall_med/limited
	desc = "Wall-mounted Medical Equipment Dispenser. This version is more limited than standard USCM NanoMeds."

	chem_refill_volume = 150
	chem_refill_volume_max = 150
	chem_refill = list(
		/obj/item/reagent_container/hypospray/autoinjector/skillless,
		/obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol,
	)

/obj/structure/machinery/cm_vending/sorted/medical/wall_med/lifeboat
	name = "Lifeboat Medical Cabinet"
	icon = 'icons/obj/structures/machinery/lifeboat.dmi'
	icon_state = "medcab"
	desc = "A wall-mounted cabinet containing medical supplies vital to survival. While better equipped, it can only refill basic supplies."

	listed_products = list(
		list("AUTOINJECTORS", -1, null, null),
		list("First-Aid Autoinjector", 8, /obj/item/reagent_container/hypospray/autoinjector/skillless, VENDOR_ITEM_REGULAR),
		list("Pain-Stop Autoinjector", 8, /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, VENDOR_ITEM_REGULAR),

		list("DEVICES", -1, null, null),
		list("Health Analyzer", 8, /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),

		list("FIELD SUPPLIES", -1, null, null),
		list("Burn Kit", 8, /obj/item/stack/medical/advanced/ointment, VENDOR_ITEM_REGULAR),
		list("Trauma Kit", 8, /obj/item/stack/medical/advanced/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", 8, /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Roll of Gauze", 8, /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Splints", 8, /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR)
	)

	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	hackable = FALSE
	chem_refill_volume = 500
	chem_refill_volume_max = 500

/obj/structure/machinery/cm_vending/sorted/medical/wall_med/populate_product_list(scale)
	return

/obj/structure/machinery/cm_vending/sorted/medical/wall_med/souto
	name = "\improper SoutoMed"
	desc = "In Soutoland (Trademark pending), one is never more than 6ft away from canned Havana goodness. Drink a Souto today! For a full selection of Souto products please visit a licensed retailer or vending machine. Also doubles as basic first aid station."
	icon_state = "soutomed"
	icon = 'icons/obj/structures/souto_land.dmi'
	listed_products = list(
		list("FIRST AID SUPPLIES", -1, null, null),
		list("First-Aid Autoinjector", 2, /obj/item/reagent_container/hypospray/autoinjector/skillless, VENDOR_ITEM_REGULAR),
		list("Pain-Stop Autoinjector", 2, /obj/item/reagent_container/hypospray/autoinjector/skillless/tramadol, VENDOR_ITEM_REGULAR),
		list("Roll Of Gauze", 4, /obj/item/stack/medical/bruise_pack, VENDOR_ITEM_REGULAR),
		list("Ointment", 4, /obj/item/stack/medical/ointment, VENDOR_ITEM_REGULAR),
		list("Medical Splints", 2, /obj/item/stack/medical/splint, VENDOR_ITEM_REGULAR),

		list("UTILITY", -1, null, null),
		list("HF2 Health Analyzer", 2, /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR),

		list("SOUTO", -1, null, null),
		list("Souto Classic", 1, /obj/item/reagent_container/food/drinks/cans/souto/classic, VENDOR_ITEM_REGULAR),
		list("Diet Souto Classic", 1, /obj/item/reagent_container/food/drinks/cans/souto/diet/classic, VENDOR_ITEM_REGULAR),
		list("Souto Cranberry", 1, /obj/item/reagent_container/food/drinks/cans/souto/cranberry, VENDOR_ITEM_REGULAR),
		list("Diet Souto Cranberry", 1, /obj/item/reagent_container/food/drinks/cans/souto/diet/cranberry, VENDOR_ITEM_REGULAR),
		list("Souto Grape", 1, /obj/item/reagent_container/food/drinks/cans/souto/grape, VENDOR_ITEM_REGULAR),
		list("Diet Souto Grape", 1, /obj/item/reagent_container/food/drinks/cans/souto/diet/grape, VENDOR_ITEM_REGULAR)
	)
