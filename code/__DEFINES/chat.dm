/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/// How many chat payloads to keep in history
#define CHAT_RELIABILITY_HISTORY_SIZE 5
/// How many resends to allow before giving up
#define CHAT_RELIABILITY_MAX_RESENDS 3

#define MESSAGE_TYPE_SYSTEM "system"
#define MESSAGE_TYPE_LOCALCHAT "localchat"
#define MESSAGE_TYPE_RADIO "radio"
#define MESSAGE_TYPE_HIVEMIND "hivemind"
#define MESSAGE_TYPE_INFO "info"
#define MESSAGE_TYPE_WARNING "warning"
#define MESSAGE_TYPE_DEADCHAT "deadchat"
#define MESSAGE_TYPE_OOC "ooc"
#define MESSAGE_TYPE_ADMINPM "adminpm"
#define MESSAGE_TYPE_COMBAT "combat"
#define MESSAGE_TYPE_ADMINCHAT "adminchat"
#define MESSAGE_TYPE_MODCHAT "modchat"
#define MESSAGE_TYPE_MENTOR "mentor"
#define MESSAGE_TYPE_STAFF_IC "staff_ic"
#define MESSAGE_TYPE_EVENTCHAT "eventchat"
#define MESSAGE_TYPE_ADMINLOG "adminlog"
#define MESSAGE_TYPE_ATTACKLOG "attacklog"
#define MESSAGE_TYPE_DEBUG "debug"
#define MESSAGE_TYPE_NICHE "niche"

/// Adds a generic box around whatever message you're sending in chat. Really makes things stand out.
#define boxed_message(str) ("<div class='boxed_message'>" + str + "</div>")
/// Adds a box around whatever message you're sending in chat. Can apply color and/or additional classes. Available colors: red, green, blue, purple. Use it like red_box
#define custom_boxed_message(classes, str) ("<div class='boxed_message " + classes + "'>" + str + "</div>")
/// Makes a fieldset with a neaty styled name. Can apply additional classes.
#define fieldset_block(title, content, classes) ("<fieldset class='fieldset " + classes + "'><legend class='fieldset_legend'>" + title + "</legend>" + content + "</fieldset>")
