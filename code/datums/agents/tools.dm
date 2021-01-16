/obj/item/device/portable_vendor/antag
    name = "Suspicious Automated Storage Briefcase"
    desc = "A suitcase-sized automated storage and retrieval system. Designed to efficiently store and selectively dispense small items."

    w_class = SIZE_MEDIUM

    req_access = list()
    req_role = null
    listed_products = list(
        list("<h2>WEAPONS</h2>", -1, null, null, null),
        list("Configured Stunbaton", 25, /obj/item/weapon/melee/baton/antag, "white", "A stun baton with more charge, tuned to work only for agents."),
        list("Tranquilizer Gun", 25, /obj/item/weapon/gun/pistol/tranquilizer, "white", "A tranquilizer gun. Comes with 5 darts. Deals no damage, knockout guaranteed."),
        list("Chloroform Cloth", 18, /obj/item/weapon/melee/chloroform, "white", "A cloth dosed with chloroform. Has 8 effective uses and can only be used whilst behind a target. You must be in disarm intent to use."),

        list("<h2>ONE-USE TOOLS</h2>", -1, null, null, null),
        list("Experimental Stimulant Pills", 20, /obj/item/storage/pill_bottle/ultrazine/antag, "white", "Useful stimulants that allow you to resist stamina damage. Lasts for approximately 2 minutes. Take only 1 pill. Use with care."),
        list("Decoy", 14, /obj/item/explosive/grenade/decoy, "white", "A decoy grenade. Emits a loud explosion that can be heard from very far away, keep away from ears. Can be used 3 times."),

        list("<h2>UTILITY</h2>", -1, null, null, null),
        list("Security Access Tuner v2", 25, /obj/item/device/multitool/antag, "white", "An upgraded access tuner, able to rapidly hack various machinery. Disguised as a regular multitool"),
		list("OoI Tracker", 20, /obj/item/device/tracker, "white", "A tracker that tracks different objects of interest in a nearby range."),

        list("<h2>KITS</h2>", -1, null, null, null),
        list("Badass Kit", 12, /obj/item/storage/box/badass_kit, "white", "Contains MP private comms encryption key, for snooping into enemy communications and sunglasses that protect you from flashbangs"),
        list("Tools Kit", 15, /obj/item/storage/toolbox/antag, "white", "A toolbox containing general tools and an engineering pamphlet to help you break into places of interest."),
        list("Hacking Kit", 15, /obj/item/storage/box/antag_signaller, "white", "A box containing a screwdriver, a multi-tool and an engineering pamphlet, as well as 5 signallers to help you hack doors."),

        list("<h2>TRANSFER POINTS</h2>", -1, null, null, "A method of transferring points between agents."),
        list("1 point", 1, /obj/item/stack/points/p1, "white", null),
        list("5 points", 5, /obj/item/stack/points/p5, "white", null),
        list("20 points", 20, /obj/item/stack/points/p20, "white", null),
    )

    points = 40
    max_points = 100

    var/faction_belonging = "WY"

    var/list/types_to_convert = list(
        /obj/item/ammo_magazine/smg/m39 = /obj/item/ammo_magazine/smg/m39/rubber,
        /obj/item/ammo_magazine/rifle = /obj/item/ammo_magazine/rifle/rubber,
        /obj/item/ammo_magazine/rifle/l42a = /obj/item/ammo_magazine/rifle/l42a/rubber,
        /obj/item/ammo_magazine/pistol =  /obj/item/ammo_magazine/pistol/rubber
    )

/obj/item/device/portable_vendor/antag/allowed(mob/M)
    if(!ishuman(M))
        return FALSE

    return TRUE

/obj/item/device/portable_vendor/antag/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
    . = ..()
    if(!allowed(user) || user.action_busy)
        return .

    var/mob/living/carbon/human/H = user
    var/obj/item/ammo_magazine/target_mag = target

    if(!istype(target_mag))
        return .

    if(target.type in types_to_convert)
        var/type_to_set = types_to_convert[target.type]

        if(target_mag.current_rounds < target_mag.max_rounds)
            to_chat(H, SPAN_WARNING("[target_mag] needs to be full to convert these into rubber rounds!"))
            return .

        to_chat(H, SPAN_NOTICE("You start converting [target_mag] into a rubber magazine."))
        playsound(user.loc, "sound/machines/fax.ogg", 5)

        if(!do_after(H, 3 SECONDS, INTERRUPT_ALL, BUSY_ICON_HOSTILE, target_mag, INTERRUPT_ALL))
            return .

        to_chat(H, SPAN_NOTICE("You convert [target] into a rubber magazine."))
        var/obj/item/ammo_magazine/mag = new type_to_set(get_turf(user.loc))
        qdel(target)

        H.put_in_any_hand_if_possible(mag)


/obj/item/device/portable_vendor/antag/process()
	STOP_PROCESSING(SSobj, src)

/obj/item/device/portable_vendor/antag/attackby(obj/item/W, mob/user)
    if(istype(W, /obj/item/stack/points))
        var/obj/item/stack/points/P = W

        if(points >= max_points)
            return . = ..()

        var/amount_to_add = min(P.amount, max_points - points)

        to_chat(user, SPAN_NOTICE("You insert [P] into [src]."))

        if(P.use(amount_to_add))
            points += amount_to_add
    else
        . = ..()

/obj/item/stack/points
    name = "credits"
    singular_name = "credit"

    icon_state = "point"

    stack_id = "antag points"

    amount = 0
    max_amount = 40

/obj/item/stack/points/Initialize(mapload, ...)
    . = ..()
    update_name()

/obj/item/stack/points/add(extra)
    . = ..()
    update_name()

/obj/item/stack/points/use(used)
    . = ..()
    update_name()

/obj/item/stack/points/proc/update_name()
    if(amount == 1)
        name = "[amount] [initial(singular_name)]"
    else
        name = "[amount] [initial(name)]"

/obj/item/stack/points/p1
    amount = 1

/obj/item/stack/points/p5
    amount = 5

/obj/item/stack/points/p20
    amount = 20
