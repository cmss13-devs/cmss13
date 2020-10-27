/datum/entity/player_sticky_ban
    var/player_id
    var/admin_id
    var/reason
    var/date
    var/ckey
    var/address
    var/computer_id 

    var/linked_stickyban

BSQL_PROTECT_DATUM(/datum/entity/player_sticky_ban)

/datum/entity_meta/player_sticky_ban
    entity_type = /datum/entity/player_sticky_ban
    table_name = "player_sticky_bans"
    field_types = list("player_id"=DB_FIELDTYPE_BIGINT,
            "admin_id"=DB_FIELDTYPE_BIGINT,
            "reason"=DB_FIELDTYPE_STRING_MAX,
            "date"=DB_FIELDTYPE_STRING_LARGE,
            "address"=DB_FIELDTYPE_STRING_LARGE,
            "ckey" = DB_FIELDTYPE_STRING_LARGE,
            "computer_id"=DB_FIELDTYPE_STRING_LARGE,
            "linked_stickyban"=DB_FIELDTYPE_BIGINT
        )


/datum/entity_link/linked_sticky_bans
    parent_entity = /datum/entity/player_sticky_ban
    child_entity = /datum/entity/player_sticky_ban
    child_field = "linked_stickyban"

    parent_name = "linked_ban"
    child_name = "linked_bans"

/datum/entity_link/player_to_player_sticky_bans
    parent_entity = /datum/entity/player
    child_entity = /datum/entity/player_sticky_ban
    child_field = "player_id"

    parent_name = "player"
    child_name = "stickybans"

/datum/entity_link/admin_to_player_sticky_bans
    parent_entity = /datum/entity/player
    child_entity = /datum/entity/player_sticky_ban
    child_field = "admin_id"

    parent_name = "admin"

/datum/view_record/stickyban_list_view
    var/entry_id
    var/player_id
    var/admin_id

    var/reason
    var/date
    var/address
    var/computer_id 
    var/ckey
    var/whitelisted

    var/linked_stickyban
    var/linked_ckey
    var/linked_reason

    var/admin_ckey
    var/linked_admin_ckey


/datum/entity_view_meta/stickyban_list_view
    root_record_type = /datum/entity/player_sticky_ban
    destination_entity = /datum/view_record/stickyban_list_view
    fields = list(
        "entry_id" = "id",
        "player_id",
        "admin_id",

        "reason",
        "date",
        "address",
        "computer_id",
        "ckey" = "player.ckey",
        "whitelisted" = "player.stickyban_whitelisted",

        "linked_stickyban",
        "linked_ckey" = "linked_ban.player.ckey",
        "linked_reason" = "linked_ban.reason",

        "admin_ckey" = "admin.ckey",
        "linked_admin_ckey" = "linked_ban.admin.ckey"
    )
    order_by = list("entry_id" = DB_ORDER_BY_DESC)
