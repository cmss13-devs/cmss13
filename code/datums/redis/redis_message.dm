/**
 * # Redis message
 *
 * Used to hold redis messages created prior to the initialization of SSredis
 */
/datum/redis_message
	/// destination redis channel
	var/channel
	/// message being sent to the channel
	var/message

