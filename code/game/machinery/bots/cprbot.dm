/obj/structure/machinery/bot/cprbot
    name = "CPRbot"
    desc = "Designed for urgent medical intervention, this CPRbot offers high-tech support in a compact form."
    icon = 'icons/obj/structures/machinery/aibots.dmi'
    icon_state = "cprbot0"
    density = FALSE
    anchored = FALSE
    health = 100
    maxhealth = 100
    req_access = list(ACCESS_MARINE_MEDBAY)
    var/const/search_radius = 10
    var/const/cprbot_proximity_check_radius = 2 // Radius to check for nearby CPRbots
    var/processing = TRUE
    var/mob/living/carbon/human/target = null
    var/cpr_cooldown = 0
    var/path = list() // Path for movement logic
    var/currently_healing = 0
    var/iff_signal = FACTION_MARINE // IFF signal to check for valid targets
    var/list/medical_facts = list(
        "Did you know? The human heart beats over 100,000 times a day.",
        "Fun fact: Blood makes up about 7% of your body's weight.",
        "Medical trivia: Your brain uses 20% of the oxygen you breathe.",
        "Laughter really can increase your pain tolerance.",
        "Did you know? The human skeleton is made up of 206 bones.",
        "Fun fact: The average adult human body contains about 5 liters of blood.",
        "Medical trivia: The human body has around 37.2 trillion cells.",
        "The skin is the largest organ in the human body.",
        "Did you know? The liver can regenerate itself if a portion is removed.",
        "Fun fact: Your sense of smell is closely linked to your memory."
		"The only muscle that never tires is that heart."
		"Did you know? not breathing can lead to a premature cessation of life!"
    )
    var/list/idle_messages = list(
        "Stay still, I'm assessing the situation.",
        "Just a routine check-up, don't worry.",
        "Scanning the area for any casualties.",
        "I’m ready to save lives, one compression at a time.",
        "I hope everyone is feeling alright today!"
		"It's not magic it's CPR Buddy 9000!"
		"I should have been a plastic surgeon."
		"What kind of medbay is this, everyone’s dropping like flies"
		"Each breath a day keeps me at bay!"
		"I sense a disturbance in my circuit board. as of a million people stopped breathing and were suddenly silent."
    )
    var/motivational_message = "Live! Live! Don't die on me now!"
    var/list/has_said_to_patient = list() // Track which patients have been warned
    var/last_message_time = 0 // Tracks the last time a message was spoken

/obj/structure/machinery/bot/cprbot/New()
    ..()
    spawn(5) // Wait for 5 seconds after spawning before starting initialization
    src.initialize_cprbot()

/obj/structure/machinery/bot/cprbot/proc/initialize_cprbot()
    while (processing && health > 0)
        src.find_and_move_to_patient()
        if (target && world.time >= cpr_cooldown)
            src.perform_cpr(target)
        src.random_message() // Check if it's time to send a random message
        sleep(2) // Slower processing loop, moves once every 2 seconds

/obj/structure/machinery/bot/cprbot/proc/random_message()
    if (world.time >= last_message_time + 600) // At least 1 minute (600 deciseconds) cooldown
        if (currently_healing)
            src.speak(motivational_message)
        else
            if (prob(50))
                src.speak(pick(medical_facts))
            else
                src.speak(pick(idle_messages))
        last_message_time = world.time // Update the last message time

/obj/structure/machinery/bot/cprbot/proc/speak(message)
    if (!processing || !message)
        return
    visible_message("[src] beeps, \"[message]\"")

/obj/structure/machinery/bot/cprbot/proc/find_and_move_to_patient()
    var/list/humans = list()
    for (var/mob/living/carbon/human/H in range(search_radius))
        if (H.stat == DEAD && H.check_tod() && H.is_revivable() && H.get_target_lock(iff_signal) && !src.has_nearby_cprbot(H))
            humans += H

    if (humans.len > 0)
        target = src.get_nearest(humans)
        if (target && !has_said_to_patient.Find(target))
            visible_message("[target] is injured! I'm coming!")
            has_said_to_patient += target
        src.move_to_target(target)
    else
        target = null

/obj/structure/machinery/bot/cprbot/proc/has_nearby_cprbot(mob/living/carbon/human/H)
    // Check if there are any other CPRbots within a two-tile radius of the target
    for (var/obj/structure/machinery/bot/cprbot/nearby_cprbot in range(H, cprbot_proximity_check_radius))
        if (nearby_cprbot != src) // Ignore self
            return TRUE
    return FALSE

/obj/structure/machinery/bot/cprbot/proc/get_nearest(list/humans)
    var/mob/living/carbon/human/nearest = null
    var/distance = search_radius + 1

    for (var/mob/living/carbon/human/H in humans)
        var/d = get_dist(src, H)
        if (d < distance)
            nearest = H
            distance = d

    return nearest

/obj/structure/machinery/bot/cprbot/proc/move_to_target(mob/living/carbon/human/H)
    if (H)
        var/pathfinding_result = AStar(src.loc, get_turf(H), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30)
        if (length(pathfinding_result) == 0)
            // No reachable path to the target, so stop looking for this patient
            target = null
            return
        path = pathfinding_result

        // Begin moving towards the target if a path exists
        if (get_dist(src, H) > 1)
            if (length(path) > 0)
                step_to(src, path[1])
                path -= path[1]
                spawn(10) // Moves every 10 ticks (approximately 1 second)
                    if (length(path))
                        step_to(src, path[1])
                        path -= path[1]
        else
            currently_healing = 1
    else
        // No valid target, stop looking
        target = null


/obj/structure/machinery/bot/cprbot/proc/perform_cpr(mob/living/carbon/human/H)
    if (!H || H.stat != DEAD || !H.is_revivable() || !ishuman_strict(H))
        target = null
        icon_state = "cprbot0"
        currently_healing = 0
        return

    if (get_dist(src, H) > 1)
        src.move_to_target(H)
        return

    icon_state = "cprbot_active"
    H.revive_grace_period += 4 SECONDS
    cpr_cooldown = world.time + 7 SECONDS
    H.visible_message(SPAN_NOTICE("<b>[src]</b> automatically performs <b>CPR</b> on <b>[H]</b>."))
    H.visible_message(SPAN_DANGER("Currently performing CPR on <b>[H]</b> do not intervene!"))
    currently_healing = 1

    spawn(0.5)
        while (H.is_revivable() && H.stat == DEAD && get_dist(src, H) <= 1)
            sleep(0.5)
        icon_state = "cprbot0"
        currently_healing = 0

/obj/structure/machinery/bot/cprbot/proc/self_destruct(mob/living/carbon/human/user = null)
    var/obj/item/cprbot_item/I = new /obj/item/cprbot_item(src.loc)

    if (user)
        if (!user.put_in_active_hand(I))
            if (!user.put_in_inactive_hand(I))
                I.forceMove(src.loc)
    else
        I.forceMove(src.loc)

    qdel(src)

/obj/structure/machinery/bot/cprbot/attack_hand(mob/user as mob)
    if (..())
        return TRUE

    SEND_SIGNAL(user, COMSIG_LIVING_ATTACKHAND_HUMAN, src)

    if (user != src)
        visible_message(SPAN_DANGER("<B>[user] begins to undeploy [src]!</B>"))
    src.self_destruct(user)
    return TRUE

/obj/structure/machinery/bot/cprbot/explode()
    src.on = 0
    src.visible_message(SPAN_DANGER("<B>[src] blows apart!</B>"), null, null, 1)
    var/turf/Tsec = get_turf(src)

    new /obj/item/cprbot_broken(Tsec)

    var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
    s.set_up(3, 1, src)
    s.start()
    qdel(src)
    return

