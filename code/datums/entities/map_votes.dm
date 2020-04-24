/datum/entity/map_vote
	var/map_name
	var/total_votes

	
/datum/entity_meta/map_vote
	entity_type = /datum/entity/map_vote
	table_name = "map_vote"
	field_types = list("map_name"=DB_FIELDTYPE_STRING_LARGE,
			"total_votes"=DB_FIELDTYPE_BIGINT
		)

/datum/entity_meta/map_vote/on_read(var/datum/entity/map_vote/vote)
	vote.total_votes = text2num("[vote.total_votes]")