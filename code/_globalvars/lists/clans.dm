GLOBAL_LIST_INIT_TYPED(clan_ranks, /datum/yautja_rank, list(
	CLAN_RANK_UNBLOODED = new /datum/yautja_rank/unblooded(),
	CLAN_RANK_YOUNG = new /datum/yautja_rank/young(),
	CLAN_RANK_BLOODED = new /datum/yautja_rank/blooded(),
	CLAN_RANK_ELITE = new /datum/yautja_rank/elite(),
	CLAN_RANK_ELDER = new /datum/yautja_rank/elder(),
	CLAN_RANK_LEADER = new /datum/yautja_rank/leader(),
	CLAN_RANK_ADMIN = new /datum/yautja_rank/ancient()
))

GLOBAL_LIST_INIT(clan_ranks_ordered, list(
	CLAN_RANK_UNBLOODED = CLAN_RANK_UNBLOODED_INT,
	CLAN_RANK_YOUNG = CLAN_RANK_YOUNG_INT,
	CLAN_RANK_BLOODED = CLAN_RANK_BLOODED_INT,
	CLAN_RANK_ELITE = CLAN_RANK_ELITE_INT,
	CLAN_RANK_ELDER = CLAN_RANK_ELDER_INT,
	CLAN_RANK_LEADER = CLAN_RANK_LEADER_INT,
	CLAN_RANK_ADMIN = CLAN_RANK_ADMIN_INT
))
