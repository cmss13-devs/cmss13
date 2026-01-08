#define CLAN_PERMISSION_USER_VIEW 1

/// Modify ranks within clan
#define CLAN_PERMISSION_USER_MODIFY 2

#define CLAN_PERMISSION_USER_ALL (CLAN_PERMISSION_USER_MODIFY|CLAN_PERMISSION_USER_VIEW)

/// View all clans
#define CLAN_PERMISSION_ADMIN_VIEW 4
/// Modify all clans
#define CLAN_PERMISSION_ADMIN_MODIFY 8
/// Move people to and from clans
#define CLAN_PERMISSION_ADMIN_MOVE  16
/// Manages the ancients
#define CLAN_PERMISSION_ADMIN_MANAGER 32

#define CLAN_PERMISSION_ADMIN_ANCIENT (CLAN_PERMISSION_ADMIN_VIEW|CLAN_PERMISSION_ADMIN_MODIFY|CLAN_PERMISSION_ADMIN_MOVE)
#define CLAN_PERMISSION_ADMIN_ALL (CLAN_PERMISSION_ADMIN_ANCIENT|CLAN_PERMISSION_ADMIN_MANAGER)

#define CLAN_PERMISSION_MODIFY (CLAN_PERMISSION_ADMIN_MODIFY|CLAN_PERMISSION_USER_MODIFY)
#define CLAN_PERMISSION_VIEW (CLAN_PERMISSION_USER_VIEW|CLAN_PERMISSION_ADMIN_VIEW)

#define CLAN_PERMISSION_ALL (CLAN_PERMISSION_USER_ALL|CLAN_PERMISSION_ADMIN_ALL)

/// Unused for the moment
#define CLAN_RANK_UNBLOODED "Unblooded"
/// Clanless
#define CLAN_RANK_YOUNG "Young Blood"
/// New to the clan
#define CLAN_RANK_BLOODED "Blooded"
#define CLAN_RANK_ELITE "Elite"
#define CLAN_RANK_ELDER "Elder"
#define CLAN_RANK_LEADER "Clan Leader"

/// Must be given by someone with CLAN_PERMISSION_ADMIN_MODIFY
#define CLAN_RANK_ADMIN "Ancient"

#define CLAN_RANK_UNBLOODED_INT 1
#define CLAN_RANK_YOUNG_INT 2
#define CLAN_RANK_BLOODED_INT 3
#define CLAN_RANK_ELITE_INT 4
#define CLAN_RANK_ELDER_INT 5
#define CLAN_RANK_LEADER_INT 6
#define CLAN_RANK_ADMIN_INT 7

/// Hard limit
#define CLAN_LIMIT_NUMBER 1
/// Scales with clan size
#define CLAN_LIMIT_SIZE 2

#define CLAN_HREF "clan_href"
#define CLAN_TARGET_HREF "clan_target_href"

#define CLAN_ACTION "clan_action"

/// Set name of clan
#define CLAN_ACTION_CLAN_RENAME "rename"
/// Set description of clan
#define CLAN_ACTION_CLAN_SETDESC "setdesc"
/// Set honor of clan
#define CLAN_ACTION_CLAN_SETHONOR "sethonor"

#define CLAN_ACTION_CLAN_DELETE "delete"
#define CLAN_ACTION_CLAN_SETCOLOR "setcolor"

/// Set a player's clan
#define CLAN_ACTION_PLAYER_MOVECLAN "moveclan"
/// Set a player's rank. Resets when moved from clan to Young Blood
#define CLAN_ACTION_PLAYER_MODIFYRANK "modifyrank"

#define CLAN_ACTION_PLAYER_PURGE "purge"

#define GET_CLAN(clan_id) DB_ENTITY(/datum/entity/clan, clan_id)
#define GET_CLAN_PLAYER(player_id) DB_EKEY(/datum/entity/clan_player, text2num(player_id))

#define NO_CLAN_LIST list(\
			clan_id = null,\
			clan_name = "Clanless",\
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

#define ERT_JOB_YOUNGBLOOD "Young Blood"
#define JOB_YOUNGBLOOD_ROLES /datum/timelock/young_blood
#define JOB_YOUNGBLOOD_ROLES_LIST list(ERT_JOB_YOUNGBLOOD)
