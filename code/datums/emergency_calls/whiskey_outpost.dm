

//whiskey outpost extra marines
/datum/emergency_call/wo
    name = "Marine Reinforcements (Squad)"
    mob_max = 15
    mob_min = 1
    probability = 0
    objectives = "Assist the USCM forces"
    max_heavies = 4
    max_medics = 2

/datum/emergency_call/wo/create_member(datum/mind/M)
    if(map_tag == MAP_WHISKEY_OUTPOST)
        name_of_spawn = "distress_wo"
    var/turf/spawn_loc = get_spawn_point()
    var/mob/original = M.current

    if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

    var/mob/living/carbon/human/mob = new(spawn_loc)
    mob.gender = pick(60;MALE,40;FEMALE)
    var/datum/preferences/A = new()
    A.randomize_appearance_for(mob)
    mob.real_name = capitalize(pick(mob.gender == MALE ? first_names_male : first_names_female)) + " " + capitalize(pick(last_names))
    mob.name = mob.real_name
    mob.age = rand(21,45)
    mob.dna.ready_dna(mob)
    mob.key = M.key
    if(mob.client) mob.client.change_view(world.view)
    mob.mind.assigned_role = "Reinforcements"
    spawn(5)
        if(!leader)
            leader = mob
            mob.arm_equipment(mob, "Dust Raider Squad Leader")
            mob << "<font size='3'>\red You are a Squad leader in the USCM, your squad is here to assist in the defence of the [map_tag]. </B>"
        else if (heavies < max_heavies)
            if(prob(40))
                mob.arm_equipment(mob, "Dust Raider Smartgunner")
                mob << "<font size='3'>\red You are a smartgunner in the USCM, your squad is here to assist in the defence of the [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
            else if(prob(20))
                mob.arm_equipment(mob, "Dust Raider Specialist")
                mob << "<font size='3'>\red You are a specialist in the USCM, your squad is here to assist in the defence of the [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
            else
                mob.arm_equipment(mob, "Dust Raider Engineer")
                mob << "<font size='3'>\red You are an engineer in the USCM, your squad is here to assist in the defence of the [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
            heavies ++
        else if (medics < max_medics)
            mob.arm_equipment(mob, "Dust Raider Medic")
            mob << "<font size='3'>\red You are a medic in the USCM, your squad is here to assist in the defence of the [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
            medics ++
        else
            mob << "<font size='3'>\red You are a private in the USCM, your squad is here to assist in the defence of [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
            mob.arm_equipment(mob,"Dust Raider Private")
    spawn(10)
        mob << "<B>Objectives:</b> [objectives]"
        RoleAuthority.randomize_squad(mob)
        mob.sec_hud_set_ID()
        mob.sec_hud_set_implants()
        mob.hud_set_special_role()
        mob.hud_set_squad()

    if(original)
        cdel(original)

/datum/game_mode/whiskey_outpost/activate_distress()
    picked_call = /datum/emergency_call/wo
    picked_call.activate(FALSE)
    return

datum/emergency_call/wo/platoon
    name = "Marine Reinforcements (Platoon)"
    mob_min = 8
    mob_max = 30
    probability = 0
    max_heavies = 8