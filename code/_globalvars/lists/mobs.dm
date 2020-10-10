GLOBAL_LIST_EMPTY(clients)							//all clients
GLOBAL_LIST_EMPTY(admins)							//all clients whom are admins
GLOBAL_PROTECT(admins)

GLOBAL_LIST_EMPTY(directory)							//all ckeys with associated client

GLOBAL_LIST_EMPTY(player_list)				//all mobs **with clients attached**.

GLOBAL_LIST_EMPTY(observer_list)			//all /mob/dead/observer

GLOBAL_LIST_EMPTY(new_player_list)			//all /mob/dead/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.
