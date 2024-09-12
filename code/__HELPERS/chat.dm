/**
 * Asynchronously sends a message to TGS chat channels.
 *
 * message - The [/datum/tgs_message_content] to send.
 * channel_tag - Required. If "", the message with be sent to all connected (Game-type for TGS3) channels. Otherwise, it will be sent to TGS4 channels with that tag (Delimited by ','s).
 * admin_only - Determines if this communication can only be sent to admin only channels.
 */
/proc/send2chat(datum/tgs_message_content/message, channel_tag, admin_only = FALSE)
	set waitfor = FALSE
	if(channel_tag == null || !world.TgsAvailable())
		return

	var/datum/tgs_version/version = world.TgsVersion()
	if(channel_tag == "" || version.suite == 3)
		world.TgsTargetedChatBroadcast(message, admin_only)
		return

	var/list/channels_to_use = list()
	for(var/I in world.TgsChatChannelInfo())
		var/datum/tgs_chat_channel/channel = I
		var/list/applicable_tags = splittext(channel.custom_tag, ",")
		if((!admin_only || channel.is_admin_channel) && (channel_tag in applicable_tags))
			channels_to_use += channel

	if(length(channels_to_use))
		world.TgsChatBroadcast(message, channels_to_use)

/**
 * Sends a message to TGS admin chat channels.
 *
 * category - The category of the mssage.
 * message - The message to send.
 */
/proc/send2adminchat(category, message, embed_links = FALSE)
	category = replacetext(replacetext(category, "\proper", ""), "\improper", "")
	message = replacetext(replacetext(message, "\proper", ""), "\improper", "")
	if(!embed_links)
		message = GLOB.has_discord_embeddable_links.Replace(replacetext(message, "`", ""), " ```$1``` ")
	world.TgsTargetedChatBroadcast("[category] | [message]", TRUE)
