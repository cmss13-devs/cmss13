/datum/rank
    var/name

    var/limit_type
    var/limit

    var/permissions = CLAN_PERMISSION_USER_VIEW
    var/permission_required = CLAN_PERMISSION_USER_MODIFY

/datum/rank/unblooded
    name = CLAN_RANK_UNBLOODED

/datum/rank/young
    name = CLAN_RANK_YOUNG

/datum/rank/blooded
    name = CLAN_RANK_BLOODED

/datum/rank/elite
    name = CLAN_RANK_ELITE

    limit_type = CLAN_LIMIT_SIZE
    limit = 5

/datum/rank/elder
    name = CLAN_RANK_ELDER

    limit_type = CLAN_LIMIT_SIZE
    limit = 12

/datum/rank/leader
    name = CLAN_RANK_LEADER

    permissions = CLAN_PERMISSION_USER_ALL
    permission_required = CLAN_PERMISSION_ADMIN_MODIFY
    limit_type = CLAN_LIMIT_NUMBER
    limit = 1

/datum/rank/ancient
    name = CLAN_RANK_ADMIN

    permission_required = CLAN_PERMISSION_ADMIN_MANAGER
    permissions = CLAN_PERMISSION_ADMIN_ANCIENT