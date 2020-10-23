/obj/item/device/professor_dummy_tablet
    icon = 'icons/obj/items/devices.dmi'
    name = "Professor DUMMY tablet"
    desc = "A Professor DUMMY Control Tablet."
    suffix = "\[3\]"
    icon_state = "Cotablet"
    item_state = "Cotablet"

    var/mob/living/carbon/human/linked_dummy

/obj/item/device/professor_dummy_tablet/Destroy()
    linked_dummy = null
    . = ..()

/obj/item/device/professor_dummy_tablet/proc/link_mob(mob/living/carbon/human/H)
    linked_dummy = H

/obj/item/device/professor_dummy_tablet/attack_self(mob/user as mob)
    interact(user)

/obj/item/device/professor_dummy_tablet/interact(mob/user as mob)
    user.set_interaction(src)
    var/dat = "<head><title>Professor DUMMY Control Tablet</title></head><body>"

    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=brute_damage_limb'>Brute Damage (Limb)</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=brute_damage_organ'>Brute Damage (Organ)</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=burn_damage'>Burn Damage</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=toxin'>Inject Toxins</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=bones'>Break Bones</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=blood_loss'>Blood Loss</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=bleeding'>Internal Bleeding</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=shrapnel'>Shrapnel</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=delimb'>Delimb</A> \]"
    dat += "<BR>\[ <A HREF='?src=\ref[src];operation=reset'>Reset</A> \]"
    dat += "<BR><hr>"

    show_browser(user, dat, "Professor DUMMY Control Tablet", window_options="size=400x500")
    onclose(user, "communications")
    updateDialog()
    return

/obj/item/device/professor_dummy_tablet/proc/select_delimb_target()
    var/list/procedureChoices = list(
        "Right Hand" = "r_hand",
        "Left Hand" = "l_hand",
        "Right Arm" = "r_arm",
        "Left Arm" = "l_arm",
        "Right Foot" = "r_foot",
        "Left Foot" = "l_foot",
        "Right Leg" = "r_leg",
        "Left Leg" = "l_leg",
    )
    var/selection = ""
    selection = input(usr, "Select Organ") as null|anything in procedureChoices
    return LAZYACCESS(procedureChoices, selection)


/obj/item/device/professor_dummy_tablet/proc/select_internal_organ()
    var/list/procedureChoices = list(
        "Heart" = "heart",
        "Lungs" = "lungs",
        "Liver" = "liver",
        "Kidneys" = "kidneys",
        "Brain" = "brain",
        "Eyes" = "eyes",
    )
    var/selection = ""
    selection = input(usr, "Select Organ") as null|anything in procedureChoices
    return LAZYACCESS(procedureChoices, selection)

/obj/item/device/professor_dummy_tablet/proc/select_body_part()
    var/list/procedureChoices = list(
        "Head" = "head",
        "Chest" = "chest",
        "Groin" = "groin",
        "Right Hand" = "r_hand",
        "Left Hand" = "l_hand",
        "Right Arm" = "r_arm",
        "Left Arm" = "l_arm",
        "Right Foot" = "r_foot",
        "Left Foot" = "l_foot",
        "Right Leg" = "r_leg",
        "Left Leg" = "l_leg",
    )
    var/selection = ""
    selection = input(usr, "Select Organ") as null|anything in procedureChoices
    return LAZYACCESS(procedureChoices, selection)


/obj/item/device/professor_dummy_tablet/Topic(href, href_list)
    if(..()) return FALSE
    usr.set_interaction(src)



    switch(href_list["operation"])
        if ("brute_damage_organ")
            var/selection = select_internal_organ()
            if (!selection)
                return
            var/datum/internal_organ/organ = LAZYACCESS(linked_dummy.internal_organs_by_name, selection)
            if (!istype(organ))
                return
            var/amount = 0
            amount = input(usr, "Amount?") as num|null
            if (amount==0)
                return
            organ.take_damage(amount)
        if ("brute_damage_limb")
            var/selection = select_body_part()
            if (!selection)
                return
            var/obj/limb/limb = linked_dummy.get_limb(selection)
            if (!istype(limb))
                return
            if(limb.status & LIMB_DESTROYED)
                return
            var/amount = 0
            amount = input(usr, "Amount?") as num|null
            if (amount==0)
                return
            limb.take_damage(amount, 0)
        if ("burn_damage")
            var/selection = select_body_part()
            if (!selection)
                return
            var/obj/limb/limb = linked_dummy.get_limb(selection)
            if (!istype(limb))
                return
            if(limb.status & LIMB_DESTROYED)
                return
            var/amount = 0
            amount = input(usr, "Amount?") as num|null
            if (amount==0)
                return
            limb.take_damage(0, amount)
        if ("toxin")
            var/amount = 0
            amount = input(usr, "Amount?") as num|null
            if (amount==0)
                return
            linked_dummy.reagents.add_reagent("toxin", amount)
        if ("bones")
            var/selection = select_body_part()
            if (!selection)
                return
            var/obj/limb/limb = linked_dummy.get_limb(selection)
            if (!istype(limb))
                return
            if(limb.status & LIMB_DESTROYED)
                return
            limb.fracture()
        if ("blood_loss")
            var/amount = 0
            amount = input(usr, "Amount?") as num|null
            if (amount==0)
                return
            linked_dummy.drip(amount)
        if ("bleeding")
            var/selection = select_body_part()
            if (!selection)
                return
            var/obj/limb/limb = linked_dummy.get_limb(selection)
            if (!istype(limb))
                return
            if(limb.status & LIMB_DESTROYED)
                return
            if(linked_dummy.get_limb(selection).status & LIMB_DESTROYED)
                return
            var/datum/wound/internal_bleeding/I = new (10)
            limb.wounds += I
        if ("shrapnel")
            var/selection = select_body_part()
            if (!selection)
                return
            var/obj/limb/limb = linked_dummy.get_limb(selection)
            if (!istype(limb))
                return
            if(limb.status & LIMB_DESTROYED)
                return
            var/obj/item/shard/shrapnel/s = new /obj/item/shard/shrapnel()
            limb.embed(s)
        if ("delimb")
            var/selection = select_body_part()
            if (!selection)
                return
            var/obj/limb/limb = linked_dummy.get_limb(selection)
            if (!istype(limb))
                return
            if(limb.status & LIMB_DESTROYED)
                return
            limb.droplimb(1, 0, "tablet")
            playsound(loc, 'sound/weapons/slice.ogg', 25)
        if("reset")
            linked_dummy.revive()
        else
            updateUsrDialog()
            return FALSE
    linked_dummy.regenerate_all_icons()
    linked_dummy.emote("scream")
    updateUsrDialog()
    return TRUE
