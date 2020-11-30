GLOBAL_LIST_EMPTY(clients)							//all clients
GLOBAL_LIST_EMPTY(admins)							//all clients whom are admins
GLOBAL_PROTECT(admins)

GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client

GLOBAL_LIST_EMPTY(player_list)				//all mobs **with clients attached**.

GLOBAL_LIST_EMPTY(observer_list)			//all /mob/dead/observer

GLOBAL_LIST_EMPTY(new_player_list)			//all /mob/dead/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.

GLOBAL_LIST_EMPTY_TYPED(mob_list, /mob)

GLOBAL_LIST_EMPTY_TYPED(living_mob_list, /mob/living)
GLOBAL_LIST_EMPTY_TYPED(alive_mob_list, /mob)

GLOBAL_LIST_EMPTY_TYPED(dead_mob_list, /mob) // excludes /mob/new_player

GLOBAL_LIST_EMPTY_TYPED(human_mob_list, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(alive_human_list, /mob/living/carbon/human) // list of alive marines

GLOBAL_LIST_EMPTY_TYPED(xeno_mob_list, /mob/living/carbon/Xenomorph)
GLOBAL_LIST_EMPTY_TYPED(living_xeno_list, /mob/living/carbon/Xenomorph)
GLOBAL_LIST_EMPTY_TYPED(xeno_cultists, /mob/living/carbon/human)

GLOBAL_LIST_EMPTY_TYPED(hellhound_list, /mob/living/carbon/hellhound)
GLOBAL_LIST_EMPTY_TYPED(zombie_list, /mob/living/carbon/human)
GLOBAL_LIST_EMPTY_TYPED(yautja_mob_list, /mob/living/carbon/human)
