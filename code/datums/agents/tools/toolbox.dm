/obj/item/storage/toolbox/antag
    name = "suspicious toolbox"
    desc = "A compact and suspicious looking toolbox. This one is small enough to fit into a bag."
    icon_state = "syndicate"
    item_state = "toolbox_syndi"

    w_class = SIZE_MEDIUM

    storage_slots = 8

/obj/item/storage/toolbox/antag/Initialize(mapload, ...)
    . = ..()
    var/color = pick("red","yellow","green","blue","pink","orange","cyan","white")
    new /obj/item/tool/screwdriver(src)
    new /obj/item/tool/wrench(src)
    new /obj/item/tool/weldingtool(src)
    new /obj/item/tool/crowbar(src)
    new /obj/item/stack/cable_coil(src,30,color)
    new /obj/item/tool/wirecutters(src)
    new /obj/item/device/multitool(src)
    new /obj/item/pamphlet/engineer/antag(src)

/obj/item/pamphlet/skill/engineer/antag
    name = "suspicious looking pamphlet"
    desc = "A pamphlet used to quickly impart vital knowledge. This one has an engineering insignia. This one is written in code-speak."
    trait = /datum/character_trait/skills/miniengie/antag
    bypass_pamphlet_limit = TRUE

/obj/item/pamphlet/engineer/antag/attack_self(mob/living/carbon/human/user)
    if(!user.skills || !istype(user))
        return

    if(!skillcheck(user, SKILL_ANTAG, SKILL_ANTAG_TRAINED))
        to_chat(user, SPAN_WARNING("This pamphlet is written in code-speak! You don't quite understand it."))
        return

    . = ..()