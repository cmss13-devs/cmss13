

//whiskey outpost extra marines
/datum/emergency_call/wo
    name = "Marine squad"
    mob_max = 15
    mob_min = 1
    probability = 0
    objectives = "Assist the USCM forces"
    max_heavies = 4

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
    mob.mind.assigned_role = "MODE"
    mob.mind.special_role = "EVENT"
    spawn(0)
        if(!leader)
            leader = mob
            mob.mind.set_cm_skills(/datum/skills/SL)
            mob.arm_equipment(mob, "USCM Specialist (Armor)")
            mob << "<font size='3'>\red You are a Squad leader in the USCM, your squad is here to assist in the defence of the [map_tag]. </B>"
        else if(heavies < max_heavies)
            mob.mind.set_cm_skills(/datum/skills/smartgunner)
            mob.arm_equipment(mob, "USCM Specialist (Smartgunner)")
            mob << "<font size='3'>\red You are a smartgunner in the USCM, your squad is here to assist in the defence of the [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
        else
            mob.mind.set_cm_skills(/datum/skills/pfc/crafty)
            mob << "<font size='3'>\red You are a private in the USCM, your squad is here to assist in the defence of [map_tag]. Listen to [leader.name] they are your (acting) squad leader. </B>"
            mob.arm_equipment(mob,"USCM Private")
    spawn(10)
        mob << "<B>Objectives:</b> [objectives]"
    
    if(original)
        cdel(original)

/datum/game_mode/whiskey_outpost/activate_distress()
    picked_call = /datum/emergency_call/wo
    picked_call.activate(FALSE)
    return
    