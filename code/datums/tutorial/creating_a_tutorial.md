# Tutorial Creation

## Step 1: Identifying the Goal

Your first objective when making a tutorial should be to have a clear and concise vision of what you want the tutorial to convey to the user. People absorb information better in smaller chunks, so you should ideally keep a tutorial to one section of information at a time.

For example, if you are making a tutorial for new CM players, it should be split into multiple parts like:

-   Basics
-   Medical
-   Weaponry
-   Requisitions/Communication

## Step 2: Coding

For an example of the current code standards for tutorials, see [this](https://github.com/cmss13-devs/cmss13/pull/4442/files#diff-843b2f84360b9b932dfc960027992f2b5117667962bfa8da14f9a35f0179a926) file.

The API for tutorials is designed to be very simple, so I'll go over all the base `/datum/tutorial` procs and some vars here:

### Variables

-   `name<string>`
    -   This is the player-facing name of the tutorial.
-   `tutorial_id<string>`
    -   This is the back-end ID of the tutorial, used for save files. Try not to change a tutorial's ID after it's on the live server.
-   `category<string>`
    -   This is what category the tutorial should be under. Use the `TUTORIAL_CATEGORY_XXXX` macros.
-   `tutorial_template</datum/map_template/tutorial>`
    -   This is what type the map template of the tutorial should be. The default space is 12x12; ideally make it so it fits the given scale of the tutorial with some wiggle room for the player to move around.
-   `parent_path<path>`
    -   This is the top-most parent `/datum/tutorial` path, used to exclude abstract parents from the tutorial menu. For example, `/datum/tutorial/marine/basic` would have a `parent_path` of `/datum/tutorial/marine`, since that path is the top-most abstract path.
-   `completion_marked<bool>`
    -   If this is `TRUE`, the tutorial will be marked as completed if ended in any way. You can modify this with `mark_completed()` but is not necessary if `end_tutorial(TRUE)` is called.

### Procs

-   `start_tutorial(mob/starting_mob)`
    -   This proc starts the tutorial, setting up the map template and player. This should be overridden with a parent call before any overridden code.
-   `end_tutorial(completed = FALSE)`
    -   This proc ends the tutorial, sending the player back to the lobby and deleting the tutorial itself. A parent call on any subtypes should be at the end of the overridden segment. If `completed` is `TRUE`, then the tutorial will save as a completed one for the user. If `mark_completed()` was called previously, the tutorial will count as completed regardless of if this is called with an argument of `TRUE` or `FALSE`.
-   `add_highlight(atom/target, color = "#d19a02")`
    -   This proc adds a highlight filter around an atom, by default <span style="color:#d19a02">this</span> color. Successive calls of highlight on the same atom will override the last.
-   `remove_highlight(atom/target)`
    -   This proc removes the tutorial highlight from a target.
-   `add_to_tracking_atoms(atom/reference)`
    -   This proc will add a reference to the tutorial's tracked atom dictionary. For what a tracked atom is, see Step 2.1.
-   `remove_from_tracking_atoms(atom/reference)`
    -   This proc will remove a reference from the tutorial's tracked atom dictionary. For what a tracked atom is, see Step 2.1.
-   `message_to_player(message)`
    -   This proc is the ideal way to communicate to a player. It is visually similar to overwatch messages or weather alerts, but appears and disappears much faster. The messages sent should be consise, but can have a degree of dialogue to them.
-   `update_objective(message)`
    -   This proc is used to update the player's objective in their status panel. This should be only what is required and how to do it without any dialogue or extra text.
-   `init_mob()`
    -   This proc is used to initialize the mob and set them up correctly.
-   `init_map()`
    -   This proc does nothing by default, but can be overriden to spawn any atoms necessary for the tutorial from the very start.
-   `tutorial_end_in(time = 5 SECONDS, completed = TRUE)`
    -   This proc will end the tutorial in the given time, defaulting to 5 seconds. Once the proc is called, the player will be booted back to the menu screen after the time is up. Will mark the tutorial as completed if `completed` is `TRUE`
-   `loc_from_corner(offset_x = 0, offset_y = 0)`
    -   This proc will return a turf offset from the bottom left corner of the tutorial zone. Keep in mind, the bottom left corner is NOT on a wall, it is on the first floor on the bottom left corner. `offset_x` and `offset_y` are used to offset what turf you want to get, and should never be negative.
-   `on_ghost(datum/source, mob/dead/observer/ghost)`
    -   This proc is used to properly end and clean up the tutorial should a player ghost out. You shouldn't need to override or modify this when making a tutorial.
-   `signal_end_tutorial(datum/source)`
    -   This proc is used to call `end_tutorial()` via signals. If something (e.g. a player dying) should send a signal that ends the tutorial, have the signal call this proc.
-   `on_logout(datum/source)`
    -   This proc is called when a player logs out, disconnecting their client from the server. As with `on_ghost()` and similar procs, it cleans up and ends the tutorial.
-   `generate_binds()`
    -   This proc generates a dictionary of the player's keybinds, in the form of {"action_name" : "key_to_press"}. This is used for the `retrieve_bind()` proc to be able to tell the user what buttons to press.
-   `retrieve_bind(action_name)`
    -   This proc will be one you'll get a fair amount of use from. Whenever you tell the user to do something like "drop an item", you should tell them what button to press by calling `retrieve_bind("drop_item")` in the string telling them to drop an item.
-   `mark_completed()`
    -   This proc can be used as an alternative to calling `end_tutorial(TRUE)`. Calling this proc means any method of exiting the tutorial (ghosting, dying, pressing the exit button) will mark the tutorial as completed.

## Step 2.1: Tracking Atoms

Naturally, you will need to keep track of certain objects or mobs for signal purposes, so the tracking system exists to fill that purpose. When you add a reference to the tracking atom list with `add_to_tracking_atoms()`, it gets put into a dictionary of `{path : reference}`. Because of this limitation, you should not track more than 1 object of the same type. To get a tracked atom, use of the `TUTORIAL_ATOM_FROM_TRACKING(path, varname)` macro is recommended. `path` should be replaced with the precise typepath of the tracked atom, and `varname` should be replaced with the variable name you wish to use. If an object is going to be deleted, remove it with `remove_from_tracking_atoms()` first.

## Step 2.2: Scripting Format

Any proc whose main purpose is to advance the tutorial will be hereon referred to as a "script proc", as part of the entire "script". In the vast majority of cases, a script proc should hand off to the next using signals. Here is an example from `basic_marine.dm`:

```javascript
/datum/tutorial/marine/basic/proc/on_cryopod_exit()
	SIGNAL_HANDLER

	UnregisterSignal(tracking_atoms[/obj/structure/machinery/cryopod/tutorial], COMSIG_CRYOPOD_GO_OUT)
	message_to_player("Good. You may notice the yellow \"food\" icon on the right side of your screen. Proceed to the outlined <b>Food Vendor</b> and vend the <b>USCM Protein Bar</b>.")
	update_objective("Vend a <b>USCM Protein Bar</b> from the outlined <b>ColMarTech Food Vendor</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial, food_vendor)
	add_highlight(food_vendor)
	food_vendor.req_access = list()
	RegisterSignal(food_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(on_food_vend))

```

Line-by-line:
- `SIGNAL_HANDLER` is necessary as this proc was called via signal.
- Here we are unregistering the signal we registered in the previous proc to call this one, which inthis case was waiting for the player to leave the tracked cryopod.
- Now, we tell the user the next step in the script, which is sent to their screen.
- Here we update the player's status panel with similar info to the above line, but far morecondensed.
- Since we need to access the food vendor, we use the `TUTORIAL_ATOM_FROM_TRACKING()` macro to get aref to it.
- We add a yellow outline to the food vendor to make it more clear what is wanted of the player
- The tutorial food vendors are locked to `ACCESS_TUTORIAL_LOCKED` by default, so here we remove thataccess requirement
- And finally, we register a signal for the next script proc, waiting for the user to vend something from the food vendor.

## Step 2.3: Quirks & Tips

-   Generally speaking, you will want to create `/tutorial` subtypes of anything you add in the tutorial, should it need any special functions or similar.
-   Restrict access from players as much as possible. As seen in the example above, restricting access to vendors and similar machines is recommended to prevent sequence breaking. Additionally, avoid adding anything that detracts from the tutorial itself.
-   Attempt to avoid softlocks when possible. If someone could reasonably do something (e.g. firing every bullet they have at a ranged target and missing, now unable to kill them and progress) that could softlock them, then there should be a fallback of some sort. However, accomodations don't need to be made for people who purposefully cause a softlock; there's a "stop tutorial" button for a reason.
-   When calling `message_to_player()` or `update_objective()`, **bold** the names of objects, items, and keybinds.
-   Attempt to bind as many scripting signals to the `tutorial_mob` as possible. The nature of SS13 means something as sequence-heavy as this will always be fragile, so keeping the fragility we can affect to a minimum is imperative.
