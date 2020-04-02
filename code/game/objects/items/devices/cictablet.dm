#define STATE_DEFAULT 1
#define STATE_MESSAGELIST 5
#define STATE_VIEWMESSAGE 6
#define STATE_DELMESSAGE 7
#define STATE_STATUSDISPLAY 8
#define STATE_ALERT_LEVEL 9
#define STATE_CONFIRM_LEVEL 10

#define COOLDOWN_COMM_MESSAGE MINUTES_1
#define COOLDOWN_COMM_REQUEST MINUTES_5
#define COOLDOWN_COMM_CENTRAL SECONDS_30

/obj/item/device/cotablet
    icon = 'icons/obj/items/devices.dmi'
    name = "command tablet"
    desc = "A special device used by the Captain of the ship."
    suffix = "\[3\]"
    icon_state = "Cotablet"
    item_state = "Cotablet"
    req_access = list(ACCESS_MARINE_BRIDGE)
    var/on = 1 // 0 for off
    var/mob/living/carbon/human/current_mapviewer
    var/prints_intercept = 1
    var/authenticated = 0
    var/list/messagetitle = list()
    var/list/messagetext = list()
    var/currmsg = 0
    var/aicurrmsg = 0
    var/state = STATE_DEFAULT
    var/aistate = STATE_DEFAULT
    var/cooldown_message = 0
    var/cooldown_request = 0
    var/cooldown_destruct = 0
    var/cooldown_central = 0
    var/tmp_alertlevel = 0

    var/status_display_freq = "1435"
    var/stat_msg1
    var/stat_msg2

/obj/item/device/cotablet/attack_self(mob/user as mob)
    if(src.allowed(user))
        user.set_interaction(src)
        interact(user)
    else to_chat(user, SPAN_DANGER("Access denied."))

/obj/item/device/cotablet/interact(mob/user as mob)
    if(!on)
        return

    user.set_interaction(src)
    var/dat = "<body>"
    if(EvacuationAuthority.evac_status == EVACUATION_STATUS_INITIATING)
        dat += "<B>Evacuation in Progress</B>\n<BR>\nETA: [EvacuationAuthority.get_status_panel_eta()]<BR>"

    switch(state)
        if(STATE_DEFAULT)
            if(authenticated)
                dat += "<BR><A HREF='?src=\ref[src];operation=logout'>LOG OUT</A> "
                dat += "<BR><A HREF='?src=\ref[src];operation=changeseclevel'>Change alert level</A> "
                dat += "<BR><A HREF='?src=\ref[src];operation=status'>Set status display</A> "
                dat += "<BR><A HREF='?src=\ref[src];operation=messagelist'>Message list</A> "
                dat += "<BR><A href='?src=\ref[src];operation=mapview'>Toggle Tactical Map</A> "
                dat += "<BR><A href='?src=\ref[src];operation=defconlist'>List DEFCON assets</A> "
                dat += "<BR><A href='?src=\ref[src];operation=defcon'>Enable DEFCON assets</A> "
                dat += "<BR><hr>"
                dat += "<BR>DEFCON [defcon_controller.current_defcon_level]: [defcon_controller.check_defcon_percentage()]%"
                dat += "<BR>Threat assessment level: [defcon_controller.last_objectives_completion_percentage*100]%"
                dat += "<BR>Remaining DEFCON asset budget: $[defcon_controller.remaining_reward_points * DEFCON_TO_MONEY_MULTIPLIER]."
                dat += "<BR><A href='?src=\ref[src];operation=defcon'>Enable DEFCON assets</A> "
                dat += "<BR><hr>"

                if(authenticated == 2)
                    dat += "<BR>Primary LZ"
                    if(ticker.mode.active_lz)
                        dat += "<BR>[get_area(ticker.mode.active_lz)]"
                    else
                        dat += "<BR><A HREF='?src=\ref[src];operation=selectlz'>Select primary LZ</A> "
                    dat += "<BR><hr>"
                    dat += "<BR><A HREF='?src=\ref[src];operation=announce'>Make an announcement</A> "
                    dat += admins.len > 0 ? "<BR><A HREF='?src=\ref[src];operation=messageUSCM'>Send a message to USCM</A> " : "<BR>USCM communication offline "
                    dat += "<BR><A HREF='?src=\ref[src];operation=award'>Award a medal</A> "
                    dat += "<BR><A HREF='?src=\ref[src];operation=distress'>Send Distress Beacon</A> "
                    switch(EvacuationAuthority.evac_status)
                        if(EVACUATION_STATUS_STANDING_BY) dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_start'>Initiate emergency evacuation</A> "
                        if(EVACUATION_STATUS_INITIATING) dat += "<BR><A HREF='?src=\ref[src];operation=evacuation_cancel'>Cancel emergency evacuation</A> "

            else
                dat += "<BR><A HREF='?src=\ref[src];operation=login'>LOG IN</A> "

        if(STATE_EVACUATION)
            dat += "Are you sure you want to evacuate the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_start'>Confirm</A>"

        if(STATE_EVACUATION_CANCEL)
            dat += "Are you sure you want to cancel the evacuation of the [MAIN_SHIP_NAME]? <A HREF='?src=\ref[src];operation=evacuation_cancel'>Confirm</A>"

        if(STATE_DISTRESS)
            dat += "Are you sure you want to trigger a distress signal? The signal can be picked up by anyone listening, friendly or not. <A HREF='?src=\ref[src];operation=distress'>Confirm</A>"

        if(STATE_DESTROY)
            dat += "Are you sure you want to trigger the self destruct? This would mean abandoning ship. <A HREF='?src=\ref[src];operation=destroy'>Confirm</A>"

        if(STATE_MESSAGELIST)
            dat += "Messages:"
            for(var/i = 1; i<=messagetitle.len; i++)
                dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[messagetitle[i]]</A>"

        if(STATE_VIEWMESSAGE)
            if (currmsg)
                dat += "<B>[messagetitle[currmsg]]</B><BR><BR>[messagetext[currmsg]]"
                if (authenticated)
                    dat += "<BR><BR><A HREF='?src=\ref[src];operation=delmessage'>Delete "
            else
                state = STATE_MESSAGELIST
                attack_hand(user)
                interact(usr)
                return FALSE

        if(STATE_DELMESSAGE)
            if (currmsg)
                dat += "Are you sure you want to delete this message? <A HREF='?src=\ref[src];operation=delmessage2'>OK</A>|<A HREF='?src=\ref[src];operation=viewmessage'>Cancel</A> "
            else
                state = STATE_MESSAGELIST
                attack_hand(user)
                interact(usr)
                return FALSE

        if(STATE_STATUSDISPLAY)
            dat += "Set Status Displays<BR>"
            dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> <BR>"
            dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=time'>Station Time</A> <BR>"
            dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> <BR>"
            dat += "<A HREF='?src=\ref[src];operation=setstat;statdisp=message'>Message</A> "
            dat += "<ul><li> Line 1: <A HREF='?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
            dat += "<li> Line 2: <A HREF='?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
            dat += "\[ Alert: <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
            dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
            dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
            dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"

        if(STATE_ALERT_LEVEL)
            dat += "Current alert level: [get_security_level()]<BR>"
            if(security_level == SEC_LEVEL_DELTA)
                if(EvacuationAuthority.dest_status >= NUKE_EXPLOSION_ACTIVE)
                    dat += SET_CLASS("<b>The self-destruct mechanism is active. [EvacuationAuthority.evac_status != EVACUATION_STATUS_INITIATING ? "You have to manually deactivate the self-destruct mechanism." : ""]</b>", INTERFACE_RED)
                    dat += "<BR>"
                switch(EvacuationAuthority.evac_status)
                    if(EVACUATION_STATUS_INITIATING)
                        dat += SET_CLASS("<b>Evacuation initiated. Evacuate or rescind evacuation orders.</b>", INTERFACE_RED)
                    if(EVACUATION_STATUS_IN_PROGRESS)
                        dat += SET_CLASS("<b>Evacuation in progress.</b>", INTERFACE_RED)
                    if(EVACUATION_STATUS_COMPLETE)
                        dat += SET_CLASS("<b>Evacuation complete.</b>", INTERFACE_RED)
            else
                dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
                dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A>"

        if(STATE_CONFIRM_LEVEL)
            dat += "Current alert level: [get_security_level()]<BR>"
            dat += "Confirm the change to: [num2seclevel(tmp_alertlevel)]<BR>"
            dat += "<A HREF='?src=\ref[src];operation=swipeidseclevel'>Swipe ID</A> to confirm change.<BR>"

        if(STATE_DEFCONLIST)
            for(var/str in typesof(/datum/defcon_reward))
                var/datum/defcon_reward/DR = new str
                if(!DR.cost)
                    continue
                dat += "DEFCON [DR.minimum_defcon_level] - [DR.name]<BR>"

    dat += "<BR>[(state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A>|" : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> "
    show_browser(user, dat, "Communications Console", "communications", "size=400x500")
    onclose(user, "communications")
    updateDialog()
    return

/obj/item/device/cotablet/proc/update_mapview(var/close = 0)
    if(close || (current_mapviewer && !Adjacent(current_mapviewer)))
        if(current_mapviewer)
            close_browser(current_mapviewer, "marineminimap")
            current_mapviewer = null
        return
    if(!istype(marine_mapview_overlay_5))
        overlay_marine_mapview()
    current_mapviewer << browse_rsc(marine_mapview_overlay_5, "marine_minimap.png")
    show_browser(current_mapviewer, "<img src=marine_minimap.png>", "Marine Minimap", "marineminimap", "size=[(map_sizes[1][1]*2)+50]x[(map_sizes[1][2]*2)+50]")


/obj/item/device/cotablet/Topic(href, href_list)
    if(..())
        return FALSE
    usr.set_interaction(src)

    switch(href_list["operation"])
        if("mapview")
            if(current_mapviewer)
                update_mapview(1)
                return
            current_mapviewer = usr
            update_mapview()
            return
        if("defcon")
            defcon_controller.list_and_purchase_rewards()
            return

        if("defconlist")
            state = STATE_DEFCONLIST
            interact(usr)
        if("main")
            state = STATE_DEFAULT
            interact(usr)

        if("login")
            if(issilicon(usr))
                return
            var/mob/living/carbon/human/C = usr
            var/obj/item/card/id/I = C.get_active_hand()
            if(istype(I))
                if(check_access(I))
                    authenticated = 1
                    interact(usr)
                if(ACCESS_MARINE_COMMANDER in I.access)
                    authenticated = 2
                    interact(usr)
            else
                I = C.wear_id
                if(istype(I))
                    if(check_access(I)) authenticated = 1
                    if(ACCESS_MARINE_COMMANDER in I.access)
                        authenticated = 2
                        interact(usr)
        if("logout")
            authenticated = 0
            interact(usr)
        if("swipeidseclevel")
            var/mob/M = usr
            var/obj/item/card/id/I = M.get_active_hand()
            if(istype(I))
                if(ACCESS_MARINE_COMMANDER in I.access || ACCESS_MARINE_BRIDGE in I.access) //Let heads change the alert level.
                    switch(tmp_alertlevel)
                        if(-INFINITY to SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN //Cannot go below green.
                        if(SEC_LEVEL_BLUE to INFINITY) tmp_alertlevel = SEC_LEVEL_BLUE //Cannot go above blue.

                    var/old_level = security_level
                    set_security_level(tmp_alertlevel)
                    if(security_level != old_level)
                        //Only notify the admins if an actual change happened
                        log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
                        message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
                else
                    to_chat(usr, SPAN_WARNING("You are not authorized to do this."))
                tmp_alertlevel = SEC_LEVEL_GREEN //Reset to green.
                state = STATE_DEFAULT
                interact(usr)
            else
                to_chat(usr, SPAN_WARNING("You need to swipe your ID."))

        if("announce")
            if(authenticated == 2)
                if(world.time < cooldown_message + COOLDOWN_COMM_MESSAGE)
                    to_chat(usr, SPAN_WARNING("Please wait [(COOLDOWN_COMM_MESSAGE + cooldown_message - world.time)*0.1] second\s before making your next announcement."))
                    return FALSE
                var/input = input(usr, "Please write a message to announce to the station crew.", "Priority Announcement", "") as message|null
                if(!input || authenticated != 2 || world.time < cooldown_message + COOLDOWN_COMM_MESSAGE || !(usr in view(1, src)))
                    return FALSE

                input += "<br><br><i>- Sent from my USCM Command Tablet</i>"

                marine_announcement(input)
                log_announcement("[key_name(usr)] has announced the following: [input]")
                cooldown_message = world.time

        if("evacuation_start")
            if(state == STATE_EVACUATION)

                if(world.time < EVACUATION_TIME_LOCK || !ticker || !ticker.mode || !ticker.mode.force_end_at) //Cannot call it early in the round.
                    to_chat(usr, SPAN_WARNING("USCM protocol does not allow immediate evacuation. Please wait another [round((EVACUATION_TIME_LOCK-world.time)/MINUTES_1)] minutes before trying again."))
                    return FALSE

                if(security_level < SEC_LEVEL_RED)
                    to_chat(usr, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
                    return FALSE

                if(EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY)
                    to_chat(usr, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
                    return FALSE

                if(!EvacuationAuthority.initiate_evacuation())
                    to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
                    return FALSE

                log_game("[key_name(usr)] has called for an emergency evacuation.")
                message_admins("[key_name_admin(usr)] has called for an emergency evacuation.")
                return TRUE

            state = STATE_EVACUATION
            interact(usr)
        if("evacuation_cancel")
            if(state == STATE_EVACUATION_CANCEL)
                if(!EvacuationAuthority.cancel_evacuation())
                    to_chat(usr, SPAN_WARNING("You are unable to cancel the evacuation right now!"))
                    return FALSE

                spawn(35)//some time between AI announcements for evac cancel and SD cancel.
                    if(EvacuationAuthority.evac_status == EVACUATION_STATUS_STANDING_BY)//nothing changed during the wait
                        //if the self_destruct is active we try to cancel it (which includes lowering alert level to red)
                        if(!EvacuationAuthority.cancel_self_destruct(1))
                            //if SD wasn't active (likely canceled manually in the SD room), then we lower the alert level manually.
                            set_security_level(SEC_LEVEL_RED, TRUE) //both SD and evac are inactive, lowering the security level.

                log_game("[key_name(usr)] has canceled the emergency evacuation.")
                message_admins("[key_name_admin(usr)] has canceled the emergency evacuation.")
                return TRUE

            state = STATE_EVACUATION_CANCEL
            interact(usr)
        if("distress")
            if(state == STATE_DISTRESS)

                //Comment to test
                if(world.time < DISTRESS_TIME_LOCK)
                    to_chat(usr, SPAN_WARNING("The distress beacon cannot be launched this early in the operation. Please wait another [round((DISTRESS_TIME_LOCK-world.time)/MINUTES_1)] minutes before trying again."))
                    return FALSE

                if(!ticker || !ticker.mode)
                    return FALSE

                if(ticker.mode.force_end_at == 0)
                    to_chat(usr, SPAN_WARNING("ARES has denied your request for operational security reasons."))
                    return FALSE

                if(ticker.mode.has_called_emergency)
                    to_chat(usr, SPAN_WARNING("The [MAIN_SHIP_NAME]'s distress beacon is already broadcasting."))
                    return FALSE

                if(ticker.mode.distress_cooldown)
                    to_chat(usr, SPAN_WARNING("The distress beacon is currently recalibrating."))
                    return FALSE

                //Comment block to test
                if(world.time < cooldown_request + COOLDOWN_COMM_REQUEST)
                    to_chat(usr, SPAN_WARNING("The distress beacon has recently broadcast a message. Please wait."))
                    return FALSE

                if(security_level == SEC_LEVEL_DELTA)
                    to_chat(usr, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
                    return FALSE

                for(var/client/C in admins)
                    if((R_ADMIN|R_MOD) & C.admin_holder.rights)
                        C << 'sound/effects/sos-morse-code.ogg'
                message_staff("[key_name(usr)] has requested a Distress Beacon! (<A HREF='?_src_=admin_holder;ccmark=\ref[usr]'>Mark</A>) (<A HREF='?_src_=admin_holder;distress=\ref[usr]'>SEND</A>) (<A HREF='?_src_=admin_holder;ccdeny=\ref[usr]'>DENY</A>) (<A HREF='?_src_=admin_holder;adminplayerobservejump=\ref[usr]'>JMP</A>) (<A HREF='?_src_=admin_holder;CentcommReply=\ref[usr]'>RPLY</A>)")
                to_chat(usr, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))

                cooldown_request = world.time
                return TRUE

            state = STATE_DISTRESS
            interact(usr)

        if("award")
            if(usr.job != "Commanding Officer")
                to_chat(usr, SPAN_WARNING("Only the Commanding Officer can award medals."))
                interact(usr)
                return
            if(give_medal_award(usr.loc))
                visible_message(SPAN_NOTICE("[src] prints a medal."))
                interact(usr)


        if("messagelist")
            currmsg = 0
            state = STATE_MESSAGELIST
            interact(usr)
        if("viewmessage")
            state = STATE_VIEWMESSAGE
            if (!currmsg)
                if(href_list["message-num"]) 	currmsg = text2num(href_list["message-num"])
                else 							state = STATE_MESSAGELIST
            interact(usr)
        if("delmessage")
            state = (currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
            interact(usr)
        if("delmessage2")
            if(authenticated)
                if(currmsg)
                    var/title = messagetitle[currmsg]
                    var/text  = messagetext[currmsg]
                    messagetitle.Remove(title)
                    messagetext.Remove(text)
                    if(currmsg == aicurrmsg) aicurrmsg = 0
                    currmsg = 0
                state = STATE_MESSAGELIST
                interact(usr)
            else
                state = STATE_VIEWMESSAGE
                interact(usr)


        if("status")
            state = STATE_STATUSDISPLAY
            interact(usr)

        if("setmsg1")
            stat_msg1 = reject_bad_text(trim(copytext(sanitize(input("Line 1", "Enter Message Text", stat_msg1) as text|null), 1, 40)), 40)
            updateDialog()

        if("setmsg2")
            stat_msg2 = reject_bad_text(trim(copytext(sanitize(input("Line 2", "Enter Message Text", stat_msg2) as text|null), 1, 40)), 40)
            updateDialog()

        if("messageUSCM")
            if(authenticated == 2)
                if(world.time < cooldown_central + COOLDOWN_COMM_CENTRAL)
                    to_chat(usr, SPAN_WARNING("Arrays recycling.  Please stand by."))
                    return FALSE
                var/input = stripped_input(usr, "Please choose a message to transmit to USCM.  Please be aware that this process is very expensive, and abuse will lead to termination.  Transmission does not guarantee a response. There is a small delay before you may send another message. Be clear and concise.", "To abort, send an empty message.", "")
                if(!input || !(usr in view(1,src)) || authenticated != 2 || world.time < cooldown_central + COOLDOWN_COMM_CENTRAL) return FALSE

                Centcomm_announce(input, usr)
                to_chat(usr, SPAN_NOTICE("Message transmitted."))
                log_say("[key_name(usr)] has made an USCM announcement: [input]")
                cooldown_central = world.time

        if("securitylevel")
            tmp_alertlevel = text2num( href_list["newalertlevel"] )
            if(!tmp_alertlevel) tmp_alertlevel = 0
            state = STATE_CONFIRM_LEVEL
            interact(usr)
        if("changeseclevel")
            state = STATE_ALERT_LEVEL
            interact(usr)
        if("selectlz")
            if(!ticker.mode.active_lz)
                var/lz_choices = list()
                for(var/obj/structure/machinery/computer/shuttle_control/console in machines)
                    if(console.z == 1 && !console.onboard)
                        lz_choices += console
                var/new_lz = input(usr, "Choose the primary LZ for this operation", "Operation Staging")  as null|anything in lz_choices
                if(new_lz)
                    ticker.mode.select_lz(new_lz)

        else return FALSE

    updateUsrDialog()
