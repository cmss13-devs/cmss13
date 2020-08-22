/client
    var/datum/entity/clan_player/clan_info

/client/load_player_data_info(datum/entity/player/player)
    set waitfor = FALSE

    . = ..()
    if(RoleAuthority && (RoleAuthority.roles_whitelist[ckey] & WHITELIST_PREDATOR))
        clan_info = GET_CLAN_PLAYER(player.id)
        clan_info.sync()

        if(RoleAuthority.roles_whitelist[ckey] & WHITELIST_YAUTJA_LEADER)
            clan_info.clan_rank = clan_ranks_ordered[CLAN_RANK_ADMIN]
            clan_info.permissions |= CLAN_PERMISSION_ALL
        else
            clan_info.permissions &= ~CLAN_PERMISSION_ADMIN_MANAGER // Only the leader can manage the ancients

        clan_info.save()

/client/proc/usr_create_new_clan()
    set name = "A: Create New Clan"
    set category = "Debug"

    if(!clan_info)
        return
    
    if(!(clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER))
        return
    
    var/input = input(src, "Name the clan:", "Create a Clan") as text|null

    if(!input)
        return

    to_chat(src, SPAN_NOTICE("Made a new clan called: [input]"))

    create_new_clan(input)

/client/verb/view_clan_info()
    set name = "View Clan Info"
    set category = "OOC"
    
    INVOKE_ASYNC(src, .proc/usr_view_clan_info)

/client/proc/usr_view_clan_info(var/clan_id, var/force_clan_id = FALSE)
    var/clan_to_get

    if(!has_clan_permission(CLAN_PERMISSION_VIEW))
        return

    if(!clan_id && !force_clan_id)
        if(!clan_info)
            to_chat(src, SPAN_WARNING("You don't have a yautja whitelist!"))
            return

        if(clan_info.permissions & CLAN_PERMISSION_ADMIN_VIEW)
            var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)

            var/clans = list()
            for(var/datum/view_record/clan_view/CV in CPV)
                clans += list("[CV.name]" = CV.clan_id)

            clans += list("People without clans" = null)

            var/input = input(src, "Choose the clan to view", "View clan") as null|anything in clans

            if(!input)
                to_chat(src, SPAN_WARNING("Couldn't find any clans for you to view!"))
                return

            clan_to_get = clans[input]
        else if(clan_info.clan_id)

            var/options = list(
                "Your clan" = clan_info.clan_id,
                "People without clans" = null
            )

            var/input = input(src, "Choose the clan to view", "View clan") as null|anything in options

            if(!input)
                return

            clan_to_get = options[input]
        else
            clan_to_get = null
    else
        clan_to_get = clan_id

    var/datum/entity/clan/C 
    var/list/datum/view_record/clan_playerbase_view/CPV

    if(clan_to_get)
        C = GET_CLAN(clan_to_get)
        C.sync()
        CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, clan_to_get))
    else
        CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_IS, clan_to_get))

    var/list/data

    var/player_rank = clan_info.clan_rank

    if(clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER)
        player_rank = 999 // Target anyone except other managers

    if(C)
        data = list(
            clan_id = C.id,
            clan_name = html_encode(C.name),
            clan_description = html_encode(C.description),
            clan_honor = C.honor,
            clan_keys = list(),

            player_rank_pos = player_rank,

            player_delete_clan = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
            player_sethonor_clan = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
            player_setcolor_clan = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MODIFY),

            player_rename_clan = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MODIFY),
            player_setdesc_clan = (clan_info.permissions & CLAN_PERMISSION_MODIFY),
            player_modify_ranks = (clan_info.permissions & CLAN_PERMISSION_MODIFY),

            player_purge = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
            player_move_clans = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MOVE)
        )
    else
        data = list(
            clan_id = null,
            clan_name = "Players without a clan",
            clan_description = "This is a list of players without a clan",
            clan_honor = null,
            clan_keys = list(),

            player_rank_pos = player_rank,

            player_delete_clan = FALSE,
            player_sethonor_clan = FALSE,
            player_rename_clan = FALSE,
            player_setdesc_clan = FALSE,
            player_modify_ranks = FALSE,
            
            player_purge = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MANAGER),
            player_move_clans = (clan_info.permissions & CLAN_PERMISSION_ADMIN_MOVE)
        )
        
    var/list/clan_members[CPV.len]

    var/index = 1
    for(var/datum/view_record/clan_playerbase_view/CP in CPV)
        var/rank_to_give = CP.clan_rank

        if(CP.permissions & CLAN_PERMISSION_ADMIN_MANAGER)
            rank_to_give = 999

        var/list/player = list(
            player_id = CP.player_id,
            name = CP.ckey,
            rank = clan_ranks[CP.clan_rank], // rank_to_give not used here, because we need to get their visual rank, not their position
            rank_pos = rank_to_give,
            honor = (CP.honor? CP.honor : 0)
        )

        clan_members[index++] = player

    data["clan_keys"] = clan_members

    var/datum/nanoui/ui = nanomanager.try_update_ui(mob, mob, "clan_status_ui", null, data)
    if(!ui)
        ui = new(mob, mob, "clan_status_ui", "clan_menu.tmpl", "Clan Menu", 550, 500)
        ui.set_initial_data(data)
        ui.set_auto_update(FALSE)
        ui.open()

/client/proc/has_clan_permission(permission_flag, clan_id, warn)
    if(!clan_info)
        if(warn) to_chat(src, "You do not have a yautja whitelist!")
        return FALSE

    if(clan_id)
        if(clan_id != clan_info.clan_id)
            if(warn) to_chat(src, "You do not have permission to perform actions on this clan!")
            return FALSE
        

    if(!(clan_info.permissions & permission_flag))
        if(warn) to_chat(src, "You do not have the necessary permissions to perform this action!")
        return FALSE

    return TRUE

/client/proc/add_honor(var/number)
    if(!clan_info)
        return FALSE
    clan_info.sync()

    clan_info.honor = max(number + clan_info.honor, 0)
    clan_info.save()

    if(clan_info.clan_id)
        var/datum/entity/clan/target_clan = GET_CLAN(clan_info.clan_id)
        target_clan.sync()

        target_clan.honor = max(number + target_clan.honor, 0)

        target_clan.save()
    
    return TRUE

/client/proc/clan_topic(href, href_list)
    set waitfor = FALSE

    if(usr.client != src)
        return

    if(!clan_info)
        return ..()

    clan_info.sync() // Make sure permissions/clan is accurate

    if(href_list[CLAN_HREF])
        var/datum/entity/clan/target_clan = GET_CLAN(href_list[CLAN_HREF])
        target_clan.sync()

        switch(href_list[CLAN_ACTION])
            if(CLAN_ACTION_CLAN_RENAME)
                if(!has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY))
                    return
                
                var/input = input(src, "Input the new name", "Set Name", target_clan.name) as text|null

                if(!input || input == target_clan.name)
                    return


                log_and_message_staff("[key_name_admin(src)] has set the name of [target_clan.name] to [input].")
                to_chat(src, SPAN_NOTICE("Set the name of [target_clan.name] to [input]."))
                target_clan.name = trim(input)

            if(CLAN_ACTION_CLAN_SETDESC)
                if(!has_clan_permission(CLAN_PERMISSION_USER_MODIFY))
                    return

                var/input = input(usr, "Input a new description", "Set Description", target_clan.description) as message|null
                
                if(!input || input == target_clan.description)
                    return

                log_and_message_staff("[key_name_admin(src)] has set the description of [target_clan.name].")
                to_chat(src, SPAN_NOTICE("Set the description of [target_clan.name]."))
                target_clan.description = trim(input)

            if(CLAN_ACTION_CLAN_SETCOLOR)
                if(!has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY))
                    return

                var/color = input(usr, "Input a new color", "Set Color", target_clan.color) as color|null

                if(!color)
                    return
                
                target_clan.color = color
                log_and_message_staff("[key_name_admin(src)] has set the color of [target_clan.name] to [color].")
                to_chat(src, SPAN_NOTICE("Set the name of [target_clan.name] to [color]."))
            if(CLAN_ACTION_CLAN_SETHONOR)
                if(!has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER))
                    return

                var/input = input(src, "Input the new honor", "Set Honor", target_clan.honor) as num|null

                if((!input && input != 0) || input == target_clan.honor)
                    return

                log_and_message_staff("[key_name_admin(src)] has set the honor of clan [target_clan.name] from [target_clan.honor] to [input].")
                to_chat(src, SPAN_NOTICE("Set the honor of [target_clan.name] from [target_clan.honor] to [input]."))
                target_clan.honor = input
                
            if(CLAN_ACTION_CLAN_DELETE)
                if(!has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER))
                    return

                var/input = input(src, "Please input the name of the clan to proceed.", "Delete Clan") as text|null

                if(input != target_clan.name)
                    to_chat(src, "You have decided not to delete [target_clan.name].")
                    return

                log_and_message_staff("[key_name_admin(src)] has deleted the clan [target_clan.name].")
                to_chat(src, SPAN_NOTICE("You have deleted [target_clan.name]."))
                var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view, DB_COMP("clan_id", DB_EQUALS, target_clan.id))

                for(var/datum/view_record/clan_playerbase_view/CP in CPV)
                    var/datum/entity/clan_player/pl = DB_EKEY(/datum/entity/clan_player/, CP.player_id)
                    pl.sync()

                    pl.clan_id = null
                    pl.permissions = clan_ranks[CLAN_RANK_UNBLOODED].permissions
                    pl.clan_rank = clan_ranks_ordered[CLAN_RANK_UNBLOODED]

                    pl.save()

                target_clan.delete()
                usr_view_clan_info(null, TRUE)
                return // We delete here. We don't need to save the clan after it deletes

        target_clan.save()
        target_clan.sync()

        if(target_clan.id)
            usr_view_clan_info(target_clan.id)

    else if(href_list[CLAN_TARGET_HREF])
        var/datum/entity/clan_player/target = GET_CLAN_PLAYER(href_list[CLAN_TARGET_HREF])
        target.sync()

        var/datum/entity/player/P = DB_ENTITY(/datum/entity/player, target.player_id)
        P.sync()

        var/player_name = P.ckey

        var/player_rank = clan_info.clan_rank

        if(has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER, warn = FALSE))
            player_rank = 999
        
        if((target.permissions & CLAN_PERMISSION_ADMIN_MANAGER) || player_rank <= target.clan_rank)
            to_chat(src, SPAN_DANGER("You can't target this person!"))
            return

        switch(href_list[CLAN_ACTION])
            if(CLAN_ACTION_PLAYER_PURGE)
                if(!has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER))
                    return

                var/input = input(src, "Are you sure you want to purge this person? Type '[player_name]' to purge", "Confirm Purge") as text|null

                if(!input || input != player_name)
                    return

                var/target_clan = target.clan_id
                log_and_message_staff("[key_name_admin(src)] has purged [player_name]'s clan profile.")
                to_chat(src, SPAN_NOTICE("You have purged [player_name]'s clan profile."))

                target.delete()

                if(P.owning_client)
                    P.owning_client.clan_info = null

                usr_view_clan_info(target_clan, TRUE)
                return // Return because we don't want to save them. They've been deleted
                
            if(CLAN_ACTION_PLAYER_MOVECLAN)
                if(!has_clan_permission(CLAN_PERMISSION_ADMIN_MOVE))
                    return

                var/is_clan_manager = has_clan_permission(CLAN_PERMISSION_ADMIN_MANAGER, warn = FALSE)
                var/list/datum/view_record/clan_view/CPV = DB_VIEW(/datum/view_record/clan_view/)

                var/list/clans = list()
                for(var/datum/view_record/clan_view/CV in CPV)
                    clans += list("[CV.name]" = CV.clan_id)
                
                if(is_clan_manager && clans.len >= 1)
                    if(target.permissions & CLAN_PERMISSION_ADMIN_ANCIENT)
                        clans += list("Remove from Ancient") 
                    else
                        clans += list("Make Ancient")

                if(target.clan_id)
                    clans += list("Remove from clan")

                var/input = input(src, "Choose the clan to put them in", "Change player's clan") as null|anything in clans

                if(!input)
                    return

                if((input == "Remove from clans" || input == "Remove from Ancient") && target.clan_id)
                    target.clan_id = null
                    target.clan_rank = clan_ranks_ordered[CLAN_RANK_UNBLOODED]
                    target.permissions = clan_ranks[CLAN_RANK_UNBLOODED].permissions
                    to_chat(src, SPAN_NOTICE("Removed [player_name] from their clan."))
                    log_and_message_staff("[key_name_admin(src)] has removed [player_name] from their current clan.")
                else if(input == "Make Ancient" && is_clan_manager)
                    target.clan_id = null
                    target.clan_rank = clan_ranks_ordered[CLAN_RANK_ADMIN]
                    target.permissions = CLAN_PERMISSION_ADMIN_ANCIENT
                    to_chat(src, SPAN_NOTICE("Made [player_name] an ancient."))
                    log_and_message_staff("[key_name_admin(src)] has made [player_name] an ancient.")
                else
                    to_chat(src, SPAN_NOTICE("Moved [player_name] to [input]."))
                    log_and_message_staff("[key_name_admin(src)] has moved [player_name] to clan [input].")

                    target.clan_id = clans[input]
                    target.permissions = clan_ranks[CLAN_RANK_YOUNG].permissions
                    target.clan_rank = clan_ranks_ordered[CLAN_RANK_YOUNG]

            if(CLAN_ACTION_PLAYER_MODIFYRANK)
                if(!target.clan_id)
                    to_chat(src, SPAN_WARNING("This player doesn't belong to a clan!"))
                    return

                var/ranks = clan_ranks.Copy()
                ranks -= CLAN_RANK_ADMIN // Admin rank should not and cannot be obtained from here

                var/datum/rank/chosen_rank
                if(has_clan_permission(CLAN_PERMISSION_ADMIN_MODIFY, warn = FALSE))
                    var/input = input(src, "Select the rank to change this user to.", "Select Rank") as null|anything in ranks

                    if(!input)
                        return

                    chosen_rank = ranks[input]

                else if(has_clan_permission(CLAN_PERMISSION_USER_MODIFY, target.clan_id))
                    for(var/rank in ranks)
                        if(!has_clan_permission(ranks[rank].permission_required, warn = FALSE))
                            ranks -= rank

                    var/input = input(src, "Select the rank to change this user to.", "Select Rank") as null|anything in ranks

                    if(!input)
                        return

                    chosen_rank = ranks[input]

                    if(chosen_rank.limit_type)
                        var/list/datum/view_record/clan_playerbase_view/CPV = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_AND(DB_COMP("clan_id", DB_EQUALS, target.clan_id), DB_COMP("rank", DB_EQUALS, clan_ranks_ordered[input])))
                        var/players_in_rank = CPV.len

                        switch(chosen_rank.limit_type)
                            if(CLAN_LIMIT_NUMBER)
                                if(players_in_rank >= chosen_rank.limit)
                                    to_chat(src, SPAN_DANGER("This slot is full! (Maximum of [chosen_rank.limit] slots)"))
                                    return
                            if(CLAN_LIMIT_SIZE)
                                var/list/datum/view_record/clan_playerbase_view/clan_players = DB_VIEW(/datum/view_record/clan_playerbase_view/, DB_COMP("clan_id", DB_EQUALS, target.clan_id))
                                var/available_slots = Ceiling(clan_players.len / chosen_rank.limit)

                                if(players_in_rank >= available_slots)
                                    to_chat(src, SPAN_DANGER("This slot is full! (Maximum of [chosen_rank.limit] per player in the clan, currently [available_slots])"))
                                    return
                                

                else
                    return // Doesn't have permission to do this

                if(!has_clan_permission(chosen_rank.permission_required)) // Double check
                    return
                
                target.clan_rank = clan_ranks_ordered[chosen_rank.name]
                target.permissions = chosen_rank.permissions
                log_and_message_staff("[key_name_admin(src)] has set the rank of [player_name] to [chosen_rank.name] for their clan.")
                to_chat(src, SPAN_NOTICE("Set [player_name]'s rank to [chosen_rank.name]"))
            
        target.save()
        target.sync()
        usr_view_clan_info(target.clan_id, TRUE)
                    

    ..()