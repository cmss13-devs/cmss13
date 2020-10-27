// BLOCKING PROC, RUN ASYNC

/proc/stickyban_internal(var/ckey, var/address, var/cid, var/reason, var/linked_stickyban, var/datum/entity/player/banning_admin)

    if(!ckey || !address || !cid)
        CRASH("Incorrect data passed to stickyban_internal ([ckey], [address], [cid])")

    var/datum/entity/player/P = get_player_from_key(ckey)

    if(!P)
        message_admins("Tried stickybanning ckey \"[ckey]\", player entity was unable to be found. Please try again later.")
        return
    
    var/datum/entity/player_sticky_ban/PSB = DB_ENTITY(/datum/entity/player_sticky_ban)
    PSB.player_id = P.id
    if(reason)
        PSB.reason = reason
    PSB.address = address
    PSB.computer_id = cid
    PSB.ckey = P.ckey
    PSB.date = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"

    if(linked_stickyban)
        PSB.linked_stickyban = linked_stickyban

    if(!reason)
        reason = "No reason given."

    if(banning_admin)
        PSB.admin_id = banning_admin.id
        if(banning_admin.owning_client)
            message_admins("[banning_admin.owning_client.ckey] has stickybanned [ckey].")
    
    message_admins("[ckey] (IP: [address], CID: [cid]) has been stickybanned for: \"[reason]\".")

    if(P.owning_client)
        to_chat_forced(P.owning_client, SPAN_WARNING("<BIG><B>You have been sticky banned by [banning_admin? banning_admin.ckey : "Host"].\nReason: [sanitize(reason)].</B></BIG>"))
        to_chat_forced(P.owning_client, SPAN_WARNING("This is a permanent ban"))
        QDEL_NULL(P.owning_client)

    PSB.save()

/datum/entity/player/proc/process_stickyban(var/address, var/computer_id, var/source_id, var/reason, var/datum/entity/player/banning_admin, var/list/PSB)
    if(length(PSB) > 0) // sticky ban with identical data already exists, no need for another copy
        if(banning_admin)
            to_chat(banning_admin, SPAN_WARNING("Failed to add stickyban to [ckey]. Reason: Stickyban already exists."))
        return

    stickyban_internal(ckey, address, computer_id, reason, source_id, banning_admin)


/datum/entity/player/proc/check_for_sticky_ban(var/address, var/computer_id)
    var/list/datum/view_record/stickyban_list_view/SBLW = DB_VIEW(/datum/view_record/stickyban_list_view,
        DB_OR(
            DB_COMP("ckey", DB_EQUALS, ckey),
            DB_COMP("address", DB_EQUALS, address),
            DB_COMP("computer_id", DB_EQUALS, computer_id)
        ))

    if(length(SBLW) == 0)
        return

    if(stickyban_whitelisted)
        return

    return SBLW

/client/proc/cmd_stickyban()
    set category = "Admin"
    set desc = "Opens up the stickyban panel"
    set name = "D: Stickyban Panel"

    if(admin_holder)
        admin_holder.stickyban()

/datum/admins/var/datum/stickyban_panel_handler/stickyban_handler

/datum/admins/proc/stickyban()
    if(!check_rights(R_ADMIN))
        return
    
    if(!stickyban_handler)
        stickyban_handler = new()
        stickyban_handler.linked_admin = src
        RegisterSignal(src, COMSIG_PARENT_QDELETING, .proc/cleanup_stickyban_handler)

    stickyban_handler.ui_interact(usr)


/datum/admins/proc/cleanup_stickyban_handler()
    SIGNAL_HANDLER
    QDEL_NULL(stickyban_handler)

/datum/stickyban_panel_handler
    var/name = "Stickyban Panel"
    var/datum/admins/linked_admin
    var/list/data
    var/list/modifiable_vars
    var/next_click = 0

    var/last_query = ""

/datum/stickyban_panel_handler/is_datum_protected()
    return TRUE

/datum/stickyban_panel_handler/New()
    . = ..()
    data = list(
        "panel_menu" = "searchmenu",
        "query_info" = list(),

        "entry_ckey" = "",
        "entry_address" = "",
        "entry_cid" = "",
        "entry_reason" = ""
    )
    modifiable_vars = list(
        "entry_ckey",
        "entry_address",
        "entry_cid",
        "entry_reason"
    )

/datum/stickyban_panel_handler/Destroy(force, ...)
    linked_admin = null
    return ..()

/datum/stickyban_panel_handler/proc/ui_interact(mob/user, ui_key = "stickyban", var/datum/nanoui/ui = null)
    ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)

    if(!ui)
        ui = new(user, src, ui_key, "stickyban_panel.tmpl", "Stickyban Panel", 800, 900, null, -1)
        ui.set_initial_data(data)
        ui.open()

/datum/stickyban_panel_handler/Topic(href, href_list)
    ..()
    if(!check_rights(R_ADMIN))
        return
    
    if(next_click > world.time)
        return

    if(!usr.client || !usr.client.player_data)
        return

    . = handle_topic(href, href_list)
    next_click = world.time + 0.5 SECONDS

    ui_interact(usr)

/datum/stickyban_panel_handler/proc/generate_query(var/query_data)
    var/list/datum/view_record/stickyban_list_view/SBLW 
    
    if(query_data)
        SBLW = DB_VIEW(/datum/view_record/stickyban_list_view,
        DB_OR(
            DB_COMP("ckey", DB_EQUALS, ckey(query_data)),
            DB_COMP("address", DB_EQUALS, query_data),
            DB_COMP("computer_id", DB_EQUALS, query_data)
        ))
    else
        SBLW = DB_VIEW(/datum/view_record/stickyban_list_view)

    var/list/query_info[length(SBLW)]
    var/index = 1
    for(var/I in SBLW)
        var/datum/view_record/stickyban_list_view/SB = I
        var/list/row_data = list(
            "id" = SB.entry_id,
            "ckey" = SB.ckey,
            "address" = SB.address,
            "computer_id" = SB.computer_id,
            "date" = SB.date,
            "reason" = SB.reason,
            "whitelisted" = SB.whitelisted? 1 : 0,

            "linked_ckey" = SB.linked_ckey,
            "linked_reason" = SB.linked_reason,
            
            "admin_ckey" = SB.admin_ckey
        )

        if(!SB.linked_ckey)
            row_data["linked_ckey"] = ""
            row_data["linked_reason"] = ""

        if(!SB.admin_ckey)
            row_data["admin_ckey"] = SB.linked_admin_ckey
            if(!row_data["admin_ckey"])
                row_data["admin_ckey"] = "--UNKNOWN--"
    
        query_info[index++] = row_data
    
    return query_info

/datum/stickyban_panel_handler/proc/handle_topic(href, href_list)
    if(href_list["switch_panel"])
        data["panel_menu"] = href_list["switch_panel"]
        return TRUE
        
    if(href_list["stickyban_update_query"])
        var/query_data = input("Please input what to search for (this can include IPs, CIDs and ckeys):") as null|text

        if(!query_data)
            return TRUE

        last_query = query_data
        log_access("[key_name_admin(usr)] has made a query in the stickyban panel: \"[query_data]\"")
        data["query_info"] = generate_query(query_data)
        return TRUE

    if(href_list["stickyban_getall_query"])

        last_query = null
        log_access("[key_name_admin(usr)] has queried for all stickyban rows.")
        data["query_info"] = generate_query(null)
        return TRUE

    if(href_list["row_href"])
        var/datum/entity/player_sticky_ban/PSB = DB_ENTITY(/datum/entity/player_sticky_ban, href_list["row_href"])
        PSB.sync()

        if(href_list["remove_stickyban"])
            if(!check_rights(R_HOST) && (!PSB.admin_id || PSB.admin_id != usr.client.player_data.id))
                return TRUE

            var/list/datum/view_record/stickyban_list_view/SBLW = DB_VIEW(/datum/view_record/stickyban_list_view, DB_COMP("linked_stickyban", DB_EQUALS, PSB.id))

            if(input("You are about to remove [length(SBLW)+1] sticky ban entries. Please input \"confirm\" to proceed with this action.") != "confirm")
                return TRUE
            
            var/datum/entity/player/P = DB_ENTITY(/datum/entity/player, PSB.player_id)
            P.sync()

            message_staff("[key_name_admin(usr)] has deleted [length(SBLW)+1] sticky ban entries linked to [P.ckey]")
            for(var/entry in SBLW)
                var/datum/view_record/stickyban_list_view/SB = entry
                var/datum/entity/player_sticky_ban/to_remove = DB_ENTITY(/datum/entity/player_sticky_ban, SB.entry_id)

                to_remove.delete()

            if(PSB.status != DB_ENTITY_STATE_DELETED)
                PSB.delete()
            
            PSB.sync() // Will wait for it to be deleted before continuing.

        if(href_list["whitelist_ckey"])
            var/should_whitelist = href_list["should_whitelist_ckey"]

            var/datum/entity/player/to_whitelist = DB_ENTITY(/datum/entity/player, PSB.player_id)
            to_whitelist.sync()

            if((input("You are about to [should_whitelist? "whitelist" : "dewhitelist"] [to_whitelist.ckey] from stickybans. Please input \"[to_whitelist.ckey]\" to proceed with this action.") as null|text) != to_whitelist.ckey)
                return TRUE

            message_staff("[key_name_admin(usr)] has [should_whitelist? "whitelisted" : "dewhitelisted"] [to_whitelist.ckey] from the stickyban system")
            to_whitelist.stickyban_whitelisted = should_whitelist
            to_whitelist.save()
            to_whitelist.sync()
        
        data["query_info"] = generate_query(last_query)
        return TRUE

    if(href_list["modify"])
        if(!(href_list["modify"] in modifiable_vars))
            return TRUE
        
        var/to_input = strip_html(input(usr, "Please input a value for this field:", "Modify Field", data[href_list["modify"]]))

        data[href_list["modify"]] = to_input
        return TRUE

    if(href_list["finish_entry"])
        var/ckey = trim(data["entry_ckey"])
        var/address = trim(data["entry_address"])
        var/cid = trim(data["entry_cid"])
        var/reason = trim(data["entry_reason"])

        if(!ckey || !address || !cid || !reason)
            to_chat(usr, SPAN_WARNING("Sticky bans require all fields to be filled out."))
            return
        
        var/datum/entity/player/P = get_player_from_key(ckey)
        if(!P)
            to_chat(usr, SPAN_WARNING("Bad ckey. Please input a valid ckey"))
            return

        P.sync()

        if(alert(usr, "You are about to add an entry. Please confirm details:\nCKEY - [P.ckey]\nIP ADDRESS - [address]\nCOMPUTER ID - [cid]\nREASON - [reason]", "Confirm", "Add Entry", "Cancel") == "Cancel")
            return
        
        P.stickyban_whitelisted = FALSE
        P.save()

        message_staff("[key_name_admin(usr)] has attempted to place a stickyban on [P.ckey], IP: [address] CID:[cid] for: [reason]")
        message_staff("Notice: This won't work if the CKEY, IP and CID already exist as a row in the database.")
        DB_FILTER(/datum/entity/player_sticky_ban,
            DB_AND(
                DB_COMP("ckey", DB_EQUALS, P.ckey),
                DB_COMP("address", DB_EQUALS, address),
                DB_COMP("computer_id", DB_EQUALS, cid)
            ), CALLBACK(P, /datum/entity/player.proc/process_stickyban, address, cid, null, reason, usr.client.player_data))

    if(href_list["autofill_entry"])
        var/ckey = trim(data["entry_ckey"])

        var/datum/entity/player/P = get_player_from_key(ckey)
        if(!P)
            to_chat(usr, SPAN_WARNING("Bad ckey. Please input a valid ckey"))
            return

        if(!P.owning_client)
            to_chat(usr, SPAN_WARNING("This player is not currently on the server. This only works if the player is on the server."))
            return

        var/client/C = P.owning_client
    
        data["entry_address"] = C.address
        data["entry_cid"] = C.computer_id