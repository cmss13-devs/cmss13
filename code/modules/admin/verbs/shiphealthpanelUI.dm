GLOBAL_DATUM_INIT(ship_health_panel_UI, /datum/shiphealthpanelUI, new)

/datum/shiphealthpanelUI/tgui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "shiphealthpanelUI")
    ui.open()

/datum/shiphealthpanelUI/ui_data(mob/user)
  var/list/data = list()
  data["missile"] = GLOB.ship_hits_tally["times_hit_missile"]
  data["railgun"] = GLOB.ship_hits_tally["times_hit_railgun"]
  data["odc"] = GLOB.ship_hits_tally["times_hit_odc"]
  data["aaboiler"] = GLOB.ship_hits_tally["times_hit_aaboiler"]
  data["hull"] = GLOB.ship_health_vars["ship_hull_health"]
  data["systems"] = GLOB.ship_health_vars["ship_systems_health"]
  return data

/datum/shiphealthpanelUI/ui_state(mob/user)
	return GLOB.always_state
/*
/datum/shiphealthpanelUI/ui_act(action, params)
  if(..())
    return
  switch(action)
    if("copypasta")
      var/newvar = params["var"]
      // A demo of proper input sanitation.
      var = CLAMP(newvar, min_val, max_val)
      . = TRUE
  update_icon() // Not applicable to all objects.
*/











/*
/datum/shiphealthpanelUI

/datum/shiphealthpanelUI/New(mob/target)
	. = ..()
	targetMob = target


/datum/shiphealthpanelUI/Destroy(force, ...)
	targetMob = null

	SStgui.close_uis(src)
	return ..()


/datum/shiphealthpanelUI/tgui_interact(mob/user, datum/tgui/ui)
	if(!targetMob)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "PlayerPanel", "[targetMob.name] Player Panel")
		ui.open()
		ui.set_autoupdate(FALSE)

// Player panel
/datum/shiphealthpanelUI/ui_data(mob/user)
	. = list()


/datum/shiphealthpanelUI/ui_data(mob/user)
	. = list()
	.["mob_name"] = targetMob.name

	.["mob_sleeping"] = targetMob.sleeping
	.["mob_frozen"] = targetMob.frozen

	.["mob_speed"] = targetMob.speed
	.["mob_status_flags"] = targetMob.status_flags

	if(isliving(targetMob))
		var/mob/living/L = targetMob
		.["mob_feels_pain"] = L.pain?.feels_pain

	.["current_permissions"] = user.client?.admin_holder?.rights

	if(targetMob.client)
		var/client/targetClient = targetMob.client

		.["client_key"] = targetClient.key
		.["client_ckey"] = targetClient.ckey

		.["client_muted"] = targetClient.prefs.muted
		.["client_rank"] = targetClient.admin_holder ? targetClient.admin_holder.rank : "Player"
		.["client_muted"] = targetClient.prefs.muted

		.["client_name_banned_status"] = targetClient.human_name_ban
*/
