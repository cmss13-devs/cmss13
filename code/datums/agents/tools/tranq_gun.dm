/obj/item/weapon/gun/pistol/tranquilizer
    name = "Tranquilizer gun"
    desc = "Contains horse tranquilizer darts. Useful at knocking people out."
    icon_state = "pk9r"
    item_state = "pk9r"
    current_mag = /obj/item/ammo_magazine/pistol/tranq

    burst_amount = 1

/obj/item/weapon/gun/pistol/tranquilizer/set_gun_config_values()
    ..()
    fire_delay = config.high_fire_delay
    accuracy_mult = config.base_hit_accuracy_mult + config.high_hit_accuracy_mult
    accuracy_mult_unwielded = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
    scatter = config.min_scatter_value
    scatter_unwielded = config.min_scatter_value
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