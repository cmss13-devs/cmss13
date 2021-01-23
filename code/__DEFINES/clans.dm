#define CLAN_PERMISSION_USER_VIEW 1
#define CLAN_PERMISSION_USER_MODIFY 2 // Modify ranks within clan
#define CLAN_PERMISSION_USER_ALL (CLAN_PERMISSION_USER_MODIFY|CLAN_PERMISSION_USER_VIEW)

#define CLAN_PERMISSION_ADMIN_VIEW 4 // View all clans
#define CLAN_PERMISSION_ADMIN_MODIFY 8// Modify all clans
#define CLAN_PERMISSION_ADMIN_MOVE  16 // Move people to and from clans
#define CLAN_PERMISSION_ADMIN_MANAGER 32 // Manages the ancients

#define CLAN_PERMISSION_ADMIN_ANCIENT (CLAN_PERMISSION_ADMIN_VIEW|CLAN_PERMISSION_ADMIN_MODIFY|CLAN_PERMISSION_ADMIN_MOVE)
#define CLAN_PERMISSION_ADMIN_ALL (CLAN_PERMISSION_ADMIN_ANCIENT|CLAN_PERMISSION_ADMIN_MANAGER)

#define CLAN_PERMISSION_MODIFY (CLAN_PERMISSION_ADMIN_MODIFY|CLAN_PERMISSION_USER_MODIFY)
#define CLAN_PERMISSION_VIEW (CLAN_PERMISSION_USER_VIEW|CLAN_PERMISSION_ADMIN_VIEW)

#define CLAN_PERMISSION_ALL (CLAN_PERMISSION_USER_ALL|CLAN_PERMISSION_ADMIN_ALL)

#define CLAN_RANK_UNBLOODED     "Unblooded" // Doesn't belong to a clan
#define CLAN_RANK_YOUNG         "Young Blood" // Recruit phase
#define CLAN_RANK_BLOODED       "Blooded"
#define CLAN_RANK_ELITE         "Elite"
#define CLAN_RANK_ELDER         "Elder"
#define CLAN_RANK_LEADER        "Clan Leader"

#define CLAN_RANK_ADMIN         "Ancient" // Must be given by someone with CLAN_PERMISSION_ADMIN_MODIFY

#define CLAN_LIMIT_NUMBER 1 // Hard limit
#define CLAN_LIMIT_SIZE 2 // Scales with clan size

var/global/list/datum/rank/clan_ranks = list(
    CLAN_RANK_UNBLOODED = new /datum/rank/unblooded(), 
    CLAN_RANK_YOUNG = new /datum/rank/young(), 
    CLAN_RANK_BLOODED = new /datum/rank/blooded(), 
    CLAN_RANK_ELITE = new /datum/rank/elite(), 
    CLAN_RANK_ELDER = new /datum/rank/elder(),
    CLAN_RANK_LEADER = new /datum/rank/leader(),
    CLAN_RANK_ADMIN = new /datum/rank/ancient()
)

var/global/list/clan_ranks_ordered = list(
    CLAN_RANK_UNBLOODED = 1,
    CLAN_RANK_YOUNG = 2,
    CLAN_RANK_BLOODED = 3,
    CLAN_RANK_ELITE = 4,
    CLAN_RANK_ELDER = 5,
    CLAN_RANK_LEADER = 6,
    CLAN_RANK_ADMIN = 7
)

#define CLAN_HREF "clan_href"
#define CLAN_TARGET_HREF "clan_target_href"

#define CLAN_ACTION "clan_action"

#define CLAN_ACTION_CLAN_RENAME "rename" // Set name of clan
#define CLAN_ACTION_CLAN_SETDESC "setdesc" // Set description of clan
#define CLAN_ACTION_CLAN_SETHONOR "sethonor" // Set honor of clan
#define CLAN_ACTION_CLAN_DELETE "delete"
#define CLAN_ACTION_CLAN_SETCOLOR "setcolor"

#define CLAN_ACTION_PLAYER_MOVECLAN "moveclan" // Set a player's clan
#define CLAN_ACTION_PLAYER_MODIFYRANK "modifyrank" // Set a player's rank. Resets when moved from clan to Young Blood
#define CLAN_ACTION_PLAYER_PURGE "purge"

#define GET_CLAN(clan_id) DB_ENTITY(/datum/entity/clan, clan_id)
#define GET_CLAN_PLAYER(player_id) DB_EKEY(/datum/entity/clan_player, text2num(player_id))

#define NO_CLAN_LIST list(\
            clan_id = null,\
            clan_name = "Players without a clan",\
            clan_description = "This is a list of players without a clan",\
            clan_honor = null,\
            clan_keys = list(),\
            \
            player_delete_clan = FALSE,\
            player_sethonor_clan = FALSE,\
            player_rename_clan = FALSE,\
            player_setdesc_clan = FALSE,\
            player_modify_ranks = FALSE,\
            \
            player_move_clans = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MOVE)\
        )

#define CLAN_SHIP_PUBLIC -1