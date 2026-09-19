GLOBAL_REFERENCE_LIST_INDEXED(adminreplies, /datum/autoreply/admin, title)
GLOBAL_REFERENCE_LIST_INDEXED(mentorreplies, /datum/autoreply/mentor, title)

/datum/autoreply
	/// What shows up in the list of replies, and the big red header on the reply itself.
	var/title = "Blank"
	/// The detailed message in the auto reply.
	var/message = "Lorem ipsum dolor sit amit."
	/// If the autoreply will automatically close the ahelp or not.
	var/closer = TRUE

/// Admin Replies
/datum/autoreply/admin/handled
	title = "Being Handled"
	message = "Staff are aware of this issue and it is being handled"
	closer = FALSE

/datum/autoreply/admin/icissue
	title = "IC Issue"
	message = "Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character."

/datum/autoreply/admin/bug
	title = "Bug Report"

ON_CONFIG_LOAD(/datum/autoreply/admin/bug)
	message = "Please report all bugs on our <a href='[CONFIG_GET(string/githuburl)]'>Github</a>. Administrative staff are unable to fix most bugs on a round to round basis and only round critical bugs, or exploits, should be ahelped."

/datum/autoreply/admin/marine
	title = "Marine Guide"

ON_CONFIG_LOAD(/datum/autoreply/admin/marine)
	message = "Your action can be answered by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MARINE_QUICKSTART]'>Marine Quickstart Guide</a>. If anything is unclear or you have another question please make a new mentorhelp or ahelp about it."

/datum/autoreply/admin/xeno
	title = "Xeno Guide"

ON_CONFIG_LOAD(/datum/autoreply/admin/xeno)
	message = "Your action can be answered by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_XENO_QUICKSTART]'>Xeno Quickstart Guide</a>. If anything is unclear or you have another question please make a new mentorhelp or ahelp about it."

/datum/autoreply/admin/changelog
	title = "Changelog"
	message = "The answer to your question can be found in the Changelog. Click the changelog button at the top-right of the screen to view it in-game, alternatively go to the CM-SS13 discord server where you can look at the cm-changelog channel to find links to any merged changes to the server."

/datum/autoreply/admin/intended
	title = "Intended"
	message = "This is an intended feature and therefore does not need admin intervention."

/datum/autoreply/admin/event
	title = "Event"
	message = "There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member."

/datum/autoreply/admin/whitelist
	title = "Whitelist Issue"

ON_CONFIG_LOAD(/datum/autoreply/admin/whitelist)
	message = "Staff are unable to handle most whitelist rulebreaks in-game, please make a player report on the forums, <a href='[CONFIG_GET(string/playerreport)]'>here</a>."

/datum/autoreply/admin/clear_cache
	title = "Clear Cache"
	message = "In order to clear cache, you need to click on gear icon located in upper-right corner of your BYOND client and select preferences. Switch to Games tab and click Clear Cache button. In some cases you need to manually delete cache. To do that, select Advanced tab and click Open User Directory and delete \"cache\" folder there."
	closer = FALSE

/datum/autoreply/admin/lobby
	title = "Cryo and Ghost to Lobby"
	message = "Staff have approved your request to be returned to the lobby. In order to do so, you must enter a cryogenics bay and ghost. You will be then manually returned to the lobby by staff."
	closer = FALSE
////////////////////////////
/////   MENTOR HELPS   /////
////////////////////////////

/datum/autoreply/mentor/staff_issue
	title = "A: Staff Issue"
	message = "This is not something that mentors can help with, please contact the staff team via AdminHelp."

/datum/autoreply/mentor/mentors_helping
	title = "L: Mentors on their way to help"
	message = "A mentor will attend to help. Thanks for letting us know!"

/datum/autoreply/mentor/whitelist
	title = "L: Whitelist Issue"

ON_CONFIG_LOAD(/datum/autoreply/mentor/whitelist)
	message = "This is not something that mentors can help with, please contact the staff team via AdminHelp. Staff are unable to handle most whitelist rulebreaks in-game and you are likely to be told to make a player report on the forums, <a href='[CONFIG_GET(string/playerreport)]'>here</a>."

/datum/autoreply/mentor/event
	title = "A: Event in Progress"
	message = "There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member."

/datum/autoreply/mentor/changelog
	title = "C: Changelog"
	message = "The answer to your question can be found in the Changelog. Click the changelog button at the top-right of the screen to view it in-game, alternatively go to the CM-SS13 discord server where you can look at the cm-changelog channel to find links to any merged changes to the server."

/datum/autoreply/mentor/join_server
	title = "C: Joining the Server"
	message = "Joining for new players is disabled for the current round due to either a staff member or and automatic setting during the end of the round. You can observe while it ends and wait for a new round to start."

/datum/autoreply/mentor/leave_server
	title = "C: Leaving the Server"
	message = "If you need to leave the server as a marine, either go to cryo or ask someone to cryo you before leaving. If you are a xenomorph, find a safe place to rest and ghost before leaving, that will instantly unlock your xeno for observers to join."

/datum/autoreply/mentor/clear_cache
	title = "C: Clear Cache"
	message = "In order to clear cache, you need to click on gear icon located in upper-right corner of your BYOND client and select preferences. Switch to Games tab and click Clear Cache button. In some cases you need to manually delete cache. To do that, select Advanced tab and click Open User Directory and delete \"cache\" folder there."

/datum/autoreply/mentor/dissappearing_mouse
	title = "C: Dissappearing Mouse"
	message = "This is a issue with Windows. To fix, either use the taskbar search or Windows Run (Win+R), type in \"main.cpl\", go to the pointer options menu, and under the visibility section untick \"Hide Pointer while typing\". Remember to click apply at the bottom of the page."

/datum/autoreply/mentor/click_drag
	title = "C: Combat Click-Drag Override"
	message = "When clicking while moving the mouse, Byond sometimes detects it as a click-and-drag attempt and prevents the click from taking effect, even if the button was only held down for an instant.\
This toggle means that when you're on disarm or harm intent, depressing the mouse triggers a click immediately even if you hold it down - unless you're trying to click-drag yourself, an ally, or something in your own inventory."

/datum/autoreply/mentor/discord
	title = "L: Discord"

ON_CONFIG_LOAD(/datum/autoreply/mentor/discord)
	message = "You can join our Discord server by using <a href='[CONFIG_GET(string/discordurl)]'>this link</a>!"

/datum/autoreply/mentor/bug
	title = "L: Bug Report"

ON_CONFIG_LOAD(/datum/autoreply/mentor/bug)
	message = "Please report all bugs on our <a href='[CONFIG_GET(string/githuburl)]'>Github</a>. Administrative staff are unable to fix most bugs on a round to round basis and only round critical bugs, or exploits, should be ahelped."

/datum/autoreply/mentor/currentmap
	title = "L: Current Map"

ON_CONFIG_LOAD(/datum/autoreply/mentor/currentmap)
	message = "If you need a map overview of the current round, use Current Map verb in OOC tab to check name of the map. Then open our <a href='[CONFIG_GET(string/wikiurl)]'>wiki front page</a> and look for the map overview in the 'Maps' section. If the map is not listed, it's a new or rare map and the overview hasn't been finished yet."

/datum/autoreply/mentor/marine
	title = "L: Marine Guide"

ON_CONFIG_LOAD(/datum/autoreply/mentor/marine)
	message = "Your action can be answered by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MARINE_QUICKSTART]'>Marine Quickstart Guide</a>. If anything is unclear or you have another question please make a new mentorhelp or ahelp about it."

/datum/autoreply/mentor/xeno
	title = "L: Xeno Guide"

ON_CONFIG_LOAD(/datum/autoreply/mentor/xeno)
	message = "Your action can be answered by the <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_XENO_QUICKSTART]'>Xeno Quickstart Guide</a>. If anything is unclear or you have another question please make a new mentorhelp or ahelp about it."

/datum/autoreply/mentor/macros
	title = "L: Macros"

ON_CONFIG_LOAD(/datum/autoreply/mentor/macros)
	message = "This <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_MACROS]'>guide</a> explains how to set up macros including examples of most common and useful ones."

/datum/autoreply/mentor/ability_activation
	title = "L: Ability Activation"
	message = "To activate an ability, ensure that it is selected on the ability bar (Top left of the game screen), then depending on the abilitty it may be activated immediately on clicking the button, open a UI menu, or may only activate on click of the middle mouse button.\
The ability bar can be entirely hidden by using the leftwards arrow at the end of the ability bar (and reshown with the same arrow button).\
As a xenomorph only, you can change your ability activation button from middle click by changing it in \"Edit Characters\" (available from the escape menu or the preferences tab on the top of the chat window) then under the sub-menu Settings and section Game Setttings click \"Button To Activate Xenomorph Abilities\"."

/datum/autoreply/mentor/synthkey
	title = "H: Synthetic Reset Key"
	message = "Synthetics cannot be restarted with a normal defibrilator and instead require a unique item called the Synthetic Reset Key. This functions the same as a defibrilator but only for synthetics. It can be used by anyone with engineering training and acquired from various squad role vendors. Most synthetics will carry one at all times."

/datum/autoreply/mentor/radio
	title = "H: Radio"
	message = "Take your headset in hand and activate it by clicking it or pressing \"Page Down\" or \"Z\" (in Hotkey Mode). This will open window with all available channels, which also contains channel keys. Marine headsets have their respective squad channels available on \";\" key. Ship crew headsets have access to the Almayer public comms on \";\" and their respective department channel on \":h\"."

/datum/autoreply/mentor/binos
	title = "H: Binoculars"
	message = "Binoculars allow you to increase distance of your view in direction you are looking. To zoom in, take them into your hand and activate them by pressing \"Page Down\" or \"Z\" (in Hotkey Mode) or clicking them while they are in your hand.\
Rangefinders allow you to get tile coordinates (longitude and latitude) by lasing it while zoomed in (produces a GREEN laser). Ctrl + Click on any open tile to start lasing. Ctrl + Click on your rangefinders to stop lasing without zooming out. Coordinates can be used by Staff Officers to send supply drops or to perform Orbital Bombardment. You also can use them to call mortar fire if there are engineers with a mortar. \
Laser Designators have a second mode (produces a RED laser) that allows highlighting targets for Close Air Support performed by dropship pilots. They also have a fixed ID number that is shown on the pilot's weaponry console. Examine the laser designator to check its ID. Red laser must be maintained as long as needed in order for the dropship pilot to bomb the designated area. To switch between lasing modes, Alt + Click the laser designator. Alternatively, Right + Click it in hand and click \"Toggle Mode\"."

/datum/autoreply/mentor/cpr
	title = "H: CPR"
	message = "When you find a killed ally, if they have not permanently died you can slow their permanent death by applying CPR. If without a sensormate HUD, then you can check if they have died permanently by examining then clicking \"Check Status\" at the bottom of the readout.\
If they are dead then they will be \"...not breathing...\", and otherwise if permanently dead they will be \"...no signs of life...\". If you have a sensormate equipped and activated, you can see at range if a mob is revivable.\
A skull means permanently dead, a solid red line means the player does not want to be revived (DNR), a red box outline means the player has lost connection, while a heartbeat line indicates someone is revivable with a colored line showing how long they have left; A green line is under 5 minutes, a yellow line is under 2 minutes, while a flashing red line is less than 1 minute.\
To apply CPR, on help intent click on a dead human and wait 3 seconds to apply. Once completed successfully, you must wait another 5 seconds to apply CPR successfully again. CPR may be done quicker with a higher medical skill."

/datum/autoreply/mentor/fireman_carry
	title = "H: Fireman Carry"
	message = "Fireman carry allows you to transport other humans quickly without any equipment. To fireman carry, grab the target (CTRL+Click), upgrade the grab once by clicking the grab or using \"Z\" (or \"Page down\" if hotkey mode is disabled). You must have the skill to fireman carry, which can be checked by the \"Check Skills\" command."

/datum/autoreply/mentor/haul
	title = "X: Haul as Xeno"
	message = "Hauling is useful to quickly transport incapacitated hosts from one place to another. In order to haul a host as a Xeno, grab the mob (CTRL+Click) and then click on yourself to begin hauling. The host can break out of your grip, which will result in your death so make sure your target is incapacitated. After approximately 1 minute host will be automatically released. To release your target voluntary, click 'Release' on the HUD to throw them back up."

/datum/autoreply/mentor/plasma
	title = "X: No plasma regen"
	message = "If you have low/no plasma regen, it's most likely because you are off weeds or are currently using a passive ability, such as the Runner's 'Hide' or emitting a pheromone."

/datum/autoreply/mentor/tunnel
	title = "X: Tunnel"
	message = "Click on the tunnel to enter it. While being in the tunnel, Alt + Click it to exit, Ctrl + Click to choose a destination."

/datum/autoreply/mentor/directional_assist
	title = "X: Directional assist"
	message = "Directional assist allows you to slash any target in the direction of your mouse rather than clicking on sprites. To enable, go to the edit characters menu (available from the escape menu or the preferences tab on the top of the chat window), then under Settings sub-menu and the Gameplay Toggles section, and click \"Toggle Directional Assist\"."
