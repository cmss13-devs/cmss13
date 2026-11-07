/// all clients
GLOBAL_LIST_EMPTY(clients)
/// all clients whom are admins
GLOBAL_LIST_EMPTY(admins)
GLOBAL_PROTECT(admins)

GLOBAL_LIST_EMPTY(deadmins)
GLOBAL_PROTECT(deadmins)

/// all ckeys with associated client
GLOBAL_LIST_EMPTY(directory)

GLOBAL_DATUM(all_player_keys_regex, /regex)
GLOBAL_LIST_EMPTY(all_player_keys)

GLOBAL_DATUM(all_player_cids_regex, /regex)
GLOBAL_LIST_EMPTY(all_player_cids)

GLOBAL_DATUM(all_player_ckeys_regex, /regex)
GLOBAL_LIST_EMPTY(all_player_ckeys)

/// all mobs **with clients attached**
GLOBAL_LIST_EMPTY_TYPED(player_list, /mob)
/// all /mob/living with clients
GLOBAL_LIST_EMPTY_TYPED(living_player_list, /mob/living)

/// all /mob/dead/observer
GLOBAL_LIST_EMPTY_TYPED(observer_list, /mob/dead/observer)

/// all /mob/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.
GLOBAL_LIST_EMPTY_TYPED(new_player_list, /mob/new_player)

GLOBAL_LIST_EMPTY_TYPED(mob_list, /mob)

GLOBAL_LIST_EMPTY_TYPED(living_mob_list, /mob/living)
GLOBAL_LIST_EMPTY_TYPED(marker_mob_list, /mob/dead/mob_marker)
GLOBAL_LIST_EMPTY_TYPED(alive_mob_list, /mob)

/// excludes /mob/new_player
GLOBAL_LIST_EMPTY_TYPED(dead_mob_list, /mob)

GLOBAL_LIST_EMPTY_TYPED(human_mob_list, /mob/living/carbon/human)
/// list of alive marines
GLOBAL_LIST_EMPTY_TYPED(alive_human_list, /mob/living/carbon/human)

GLOBAL_LIST_EMPTY_TYPED(xeno_mob_list, /mob/living/carbon/xenomorph)
GLOBAL_LIST_EMPTY_TYPED(living_xeno_list, /mob/living/carbon/xenomorph)
GLOBAL_LIST_EMPTY_TYPED(xeno_cultists, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(player_embryo_list, /obj/item/alien_embryo)
/// List of playable facehuggers and lesser drones
GLOBAL_LIST_EMPTY_TYPED(xeno_ghost_role_mobs, /mob/living/carbon/xenomorph)

GLOBAL_LIST_EMPTY_TYPED(hellhound_list, /mob/living/carbon/xenomorph/hellhound)
GLOBAL_LIST_EMPTY_TYPED(zombie_list, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(yautja_mob_list, /mob/living/carbon/human)
