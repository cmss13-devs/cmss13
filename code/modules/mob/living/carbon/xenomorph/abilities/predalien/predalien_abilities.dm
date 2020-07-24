/datum/action/xeno_action/activable/pounce/predalien
    name = "Leap"
    ability_primacy = XENO_PRIMARY_ACTION_1

    knockdown = FALSE

    distance = 5                    
    knockdown = FALSE                // Should we knock down the target?
    slash = FALSE                    // Do we slash upon reception?
    freeze_self = FALSE                // Should we freeze ourselves after the lunge?
    should_destroy_objects = TRUE   // Only used for ravager charge

/datum/action/xeno_action/activable/predalien_roar
    name = "Roar"
    action_icon_state = "screech"
    ability_name = "roar"
    action_type = XENO_ACTION_ACTIVATE
    ability_primacy = XENO_PRIMARY_ACTION_2
    xeno_cooldown = 25 SECONDS
    plasma_cost = 50

    var/screech_sound_effect = "sound/voice/predalien_roar.ogg"
    var/bonus_damage_scale = 2.5
    var/bonus_speed_scale = 0.05

/datum/action/xeno_action/activable/smash
    name = "Smash"
    action_icon_state = "stomp"
    ability_name = "smash"
    action_type = XENO_ACTION_CLICK
    ability_primacy = XENO_PRIMARY_ACTION_3
    xeno_cooldown = 20 SECONDS
    plasma_cost = 80

    var/freeze_duration = 1.5 SECONDS

    var/activation_delay = SECONDS_1
    var/smash_sounds = list('sound/effects/alien_footstep_charge1.ogg', 'sound/effects/alien_footstep_charge2.ogg', 'sound/effects/alien_footstep_charge3.ogg')

/datum/action/xeno_action/activable/devastate
    name = "Devastate"
    action_icon_state = "gut"
    ability_name = "devastate"
    action_type = XENO_ACTION_CLICK
    ability_primacy = XENO_PRIMARY_ACTION_4
    xeno_cooldown = 20 SECONDS
    plasma_cost = 110

    var/activation_delay = SECONDS_1

    var/base_damage = 25
    var/damage_scale = 10 // How much it scales by every kill