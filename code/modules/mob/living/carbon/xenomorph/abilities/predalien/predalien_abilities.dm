/datum/action/xeno_action/activable/pounce/predalien
    ability_primacy = XENO_PRIMARY_ACTION_1

    var/yautja_knockdown_time = 6
    var/yautja_slowdown_time = 50

    knockdown = FALSE // We want to handle this ourselves, because we apply a knockdown based on species

    slash = TRUE
    slash_bonus_damage = 15

/datum/action/xeno_action/activable/predalien_roar
    name = "Roar"
    action_icon_state = "screech"
    ability_name = "roar"
    action_type = XENO_ACTION_ACTIVATE
    ability_primacy = XENO_PRIMARY_ACTION_2
    xeno_cooldown = 80
    plasma_cost = 50

    var/screech_sound_effect = "sound/voice/predalien_roar.ogg"
