
/datum/minimap_blip_click_listener_manager
	// Used by users that want to know about xenos/humans clicking on tacmap blips. Keyed by atom so cbs can be deregistered.
	var/list/datum/callback/human_blip_click_listeners = list()
	var/list/datum/callback/xeno_blip_click_listeners = list()

/datum/minimap_blip_click_listener_manager/proc/register_human_blip_click_listener(atom/key, datum/callback/listener_cb)
	human_blip_click_listeners[key] = listener_cb

/datum/minimap_blip_click_listener_manager/proc/deregister_human_blip_click_listener(atom/key)
	human_blip_click_listeners -= key

/datum/minimap_blip_click_listener_manager/proc/handle_click_on_human_blip(mob/clicker, mob/living/carbon/human/click_target)
	for (var/atom/key in human_blip_click_listeners)
		human_blip_click_listeners[key].Invoke(clicker, click_target)

/datum/minimap_blip_click_listener_manager/proc/register_xeno_blip_click_listener(atom/key, datum/callback/listener_cb)
	xeno_blip_click_listeners[key] = listener_cb

/datum/minimap_blip_click_listener_manager/proc/deregister_xeno_blip_click_listener(atom/key)
	xeno_blip_click_listeners -= key

/datum/minimap_blip_click_listener_manager/proc/handle_click_on_xeno_blip(mob/clicker, mob/living/carbon/xenomorph/click_target)
	for (var/atom/key in xeno_blip_click_listeners)
		xeno_blip_click_listeners[key].Invoke(clicker, click_target)
