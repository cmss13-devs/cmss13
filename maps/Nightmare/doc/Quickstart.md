# CM-SS13 Nightmare: Quick Start
Nightmare is a system used to introduce round variations. No two rounds should be same, beyond simply changing people and map. Unknowns and changes maintain the game fresh. This is primarily done by dynamically changing the game map.

## The Scenario
The Scenario is a set of parameters that direct what Nightmare will do - for example, LV-624 fog gap location. On startup, the game will automatically generate a Scenario, which can then be edited by Admins while in the Lobby to fine-tune or for event running purposes.

## Configuration
Nightmare works via configuration files. Each map is setup with a folder containing them, for example `maps/Nightmare/maps/LV624/`. The two main files are `scenario.json` which is used to generate the scenario, and `nightmare.json` which describes the actual game setup.
### Format
Configuration contains a list of "nodes", JSON objects that describe an action to perform. The `type` defines what to do, `chance`is probability of doing it, `when` adds conditions to do it. Different types of nodes will also take extra arguments to work (for example, a `map_insert` needs a `path` to the map inserted)

## Adding map insertions
The primary purpose of Nightmare is to change the round by "inserting" maps, which is replacing chunks of the game map by different ones. This can be done by adding to the nightmare files.

### Map Landmarks
To know where to insert map files, we use a landmark object. This means placing `/obj/effect/landmark/nightmare` on the main map to mark the location, with an `insert_tag` to identify them.

### Example 1: Map Sprinkles
The `map_sprinkle` node is usually already configured on maps, with a folder such as `maps/Nightmare/maps/BigRed/sprinkles`. It allows to randomly insert standalone map changes, by directly using map files.

Each file will randomly be inserted depending on its name: `40.viro_open.dmm` for example has 40% chance to be included at `viro_open` landmark. You can drop in extra files to take advantage of this.

### Example 2: Map Variations
`map_variations` work similarly, but only pick one file in the folder at random. For example, if you have three files:
* `armory/10.cheese.dmm`
* `armory/10.extra.dmm`
* `armory/20.looted.dmm`
One of the map files will be inserted at `armory` at random, weighted by the number in their name.

### Example 3: Custom inserts
Sometimes you might want to do more complicated things, in which case you can edit the configuration files.
Exact usage goes beyond this quick start guide, but to take an example:

```
{
  "type": "map_insert",                          # Insert a map
  "landmark": "lv-rightsidepass",                # at lv-rightsidepass
  "chance": 0.7,                                 # with 70% chance
  "path": "standalone/rightsidepass.dmm",        # from file standalone/rightsidepass.dmm
  "when": { "mainpath": "right" }                # when "mainpath" is "right"
},
```

## Forward Base: adding a bunker to an existing map

The bunker goes in a separate DMM that loads over the normal map. We'll use Big Red as an example map here.

## 1. Make the bunker file

Create `maps/map_files/BigRed/standalone/BigRed_Forward_Base.dmm`. Make it the same size as `maps/map_files/BigRed/BigRed.dmm`, with the same amount of z-levels.

Set every tile you aren't using to `/turf/template_noop` and `/area/template_noop`, with no objects or anything else on it. That tells the game to leave the normal map alone. Only create the base, the paths up to it, its fog, upper floors, and off-map ASRS elevator. Don't crop off the blank space.

## 2. Put the base together

For making your life easier, copy the working parts from another FB map, like `maps/map_files/Kutjevo/standalone/Kutjevo_Forward_Base.dmm`, then arrange them to fit your base.

- For indoor areas, only use areas under `/area/forward_base`
- Copy the Normandy landing port and flight console. Put the console in a Forward Base area. Give the port a unique `id`, such as `bigred-fb-hangar`, and set the console's `linked_lz` to match.
- Copy the ASRS elevator and its off-map part. Keep their areas as `/area/supply/station/uscm` and `/area/supply/dock/uscm`

## 3. Mark where it loads

Open the normal `maps/map_files/BigRed/BigRed.dmm`. At the coordinate (1,1,1), place `/obj/effect/landmark/nightmare` and set its `insert_tag` to `forward-base`. This lines the bunker file up with the normal map.

## 4. Add it to Nightmare

Open `maps/Nightmare/maps/BigRed/nightmare.json` and put this at the top of the list, just after the opening `[`:

```json
{
  "type": "map_insert",
  "landmark": "forward-base",
  "chance": 1.0,
  "path": "standalone/BigRed_Forward_Base.dmm",
  "when": {
    "$gamemode": "Distress Signal: Forward Base"
  }
}
```

The bunker loads first. Other inserts can still load afterward if their landmarks survive, so check they don't overwrite your base or thhe fog.

## 5. Allow Forward Base on the map

In `maps/bigredv2.json`, add `"Distress Signal: Forward Base"` to the `gamemodes` list.

