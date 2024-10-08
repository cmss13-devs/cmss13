/datum/yautja_rank
	var/name

	var/limit_type
	var/limit

	var/permissions = CLAN_PERMISSION_USER_VIEW
	var/permission_required = CLAN_PERMISSION_USER_MODIFY

/datum/yautja_rank/unblooded
	name = CLAN_RANK_UNBLOODED
	permission_required = CLAN_PERMISSION_ADMIN_MODIFY

/datum/yautja_rank/young
	name = CLAN_RANK_YOUNG

/datum/yautja_rank/blooded
	name = CLAN_RANK_BLOODED

/datum/yautja_rank/elite
	name = CLAN_RANK_ELITE

	limit_type = CLAN_LIMIT_SIZE
	limit = 5

/datum/yautja_rank/elder
	name = CLAN_RANK_ELDER

	limit_type = CLAN_LIMIT_SIZE
	limit = 12

/datum/yautja_rank/leader
	name = CLAN_RANK_LEADER

	permissions = CLAN_PERMISSION_USER_ALL
	permission_required = CLAN_PERMISSION_ADMIN_MODIFY
	limit_type = CLAN_LIMIT_NUMBER
	limit = 1

/datum/yautja_rank/ancient
	name = CLAN_RANK_ADMIN

	permission_required = CLAN_PERMISSION_ADMIN_MANAGER
	permissions = CLAN_PERMISSION_ADMIN_ANCIENT



/datum/yautja_ancillary
	var/name

	var/limit_type = CLAN_LIMIT_SIZE
	var/limit = 5

	var/granter_title_required = CLAN_RANK_LEADER
	var/target_rank_required = CLAN_RANK_ELITE

/datum/yautja_ancillary/high_enforcer
	name = CLAN_ANCILLARY_HIGH_ENFORCER
	target_rank_required = CLAN_RANK_ELDER
	limit_type = CLAN_LIMIT_NUMBER
	limit = 1

/datum/yautja_ancillary/enforcer
	name = CLAN_ANCILLARY_ENFORCER
	granter_title_required = CLAN_ANCILLARY_HIGH_ENFORCER

/datum/yautja_ancillary/high_shaman
	name = CLAN_ANCILLARY_HIGH_SHAMAN
	target_rank_required = CLAN_RANK_ELDER
	limit_type = CLAN_LIMIT_NUMBER
	limit = 1

/datum/yautja_ancillary/shaman
	name = CLAN_ANCILLARY_SHAMAN
	granter_title_required = CLAN_ANCILLARY_HIGH_SHAMAN

/datum/yautja_ancillary/adjutant
	name = CLAN_ANCILLARY_ADJUTANT

/datum/yautja_ancillary/hound_master
	name = CLAN_ANCILLARY_HOUND_MASTER

/datum/yautja_ancillary/task_master
	name = CLAN_ANCILLARY_TASK_MASTER
