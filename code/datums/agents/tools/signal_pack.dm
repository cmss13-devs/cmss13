/obj/item/storage/box/antag_signaller
    name = "suspicious box"
    desc = "A compact and suspicious looking box. This one is small enough to fit into a bag."

    w_class = SIZE_MEDIUM

    storage_slots = 8

/obj/item/storage/box/antag_signaller/Initialize(mapload, ...)
    . = ..()
    new /obj/item/device/assembly/signaler(src)
    new /obj/item/device/assembly/signaler(src)
    new /obj/item/device/assembly/signaler(src)
    new /obj/item/device/assembly/signaler(src)
    new /obj/item/device/assembly/signaler(src)
    new /obj/item/tool/screwdriver(src)
    new /obj/item/device/multitool(src)
    new /obj/item/pamphlet/engineer/antag(src)