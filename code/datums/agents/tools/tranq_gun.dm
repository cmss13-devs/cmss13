/obj/item/weapon/gun/pistol/tranquilizer
    name = "Tranquilizer gun"
    desc = "Contains horse tranquilizer darts. Useful at knocking people out."
    icon_state = "pk9r"
    item_state = "pk9r"
    current_mag = /obj/item/ammo_magazine/pistol/tranq

    burst_amount = 1

/obj/item/weapon/gun/pistol/tranquilizer/set_gun_config_values()
    ..()
    fire_delay = FIRE_DELAY_TIER_6
    accuracy_mult = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_7
    accuracy_mult_unwielded = BASE_ACCURACY_MULT + HIT_ACCURACY_MULT_TIER_10
    scatter = SCATTER_AMOUNT_TIER_10
    scatter_unwielded = SCATTER_AMOUNT_TIER_10
    damage_mult = 0 // Miniscule amounts of damage

/obj/item/weapon/gun/pistol/tranquilizer/handle_starting_attachment()//Making the gun have an invisible silencer since it's supposed to have one.
    ..()
    var/obj/item/attachable/suppressor/S = new(src)
    S.hidden = TRUE
    S.flags_attach_features &= ~ATTACH_REMOVABLE
    S.Attach(src)
    update_attachable(S.slot)

/obj/item/ammo_magazine/pistol/tranq
    name = "\improper Tranquilizer magazine (Horse Tranquilizer)"
    default_ammo = /datum/ammo/bullet/pistol/tranq
    caliber = ".22"
    icon_state = "pk-9_tranq"
    max_rounds = 5
    gun_type = /obj/item/weapon/gun/pistol/tranquilizer