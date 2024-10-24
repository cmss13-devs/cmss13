DEFINE_ENTITY(map_vote, "map_vote")
FIELD_STRING_LARGE(map_vote, map_name)
FIELD_BIGINT(map_vote, total_votes)

// TODO: have this handled automatically by virtue of type (deserialization)
/datum/entity_meta/map_vote/on_read(datum/entity/map_vote/vote)
	vote.total_votes = text2num("[vote.total_votes]")
