# CM Nightmare for Content Creators

## Introduction

Nightmare is a system designed to provide variation to game rounds. This can take the form of additions, or modifications, completely randomly, or in a structured fashion such as a scenario. It provides a (although incomplete) framework for this by providing config files in a tree-like JSON structure, and pre-made tools.

## Features

* **Generic actions** : While most of the implementations are for mapping, the configuration aims to be generic enough to do more
* **'Scenario'** : The Scenario is a simple set of values representing the setup, to make creation simpler and allow hand edit eg. for events
* **Map folder scanning** : Common map variations can be setup just by putting files in folders, and placing landmarks on map

## Map inserts primer

*Okay, your stuff is cool and all, but I just want to map.*

If you are creating standalone inserts, or creating variations of existing ones, but don't care about more advanced features, you can just use some of the added tools mentionned above! Just keep in mind they have to be setup in the map first.

### Landmarks and map placement

Default Nightmare Map inserts occur at map-placed landmarks (type `/obj/effect/nightmare/landmark`). If there is not already one where you would want the map to pop up, you will have to add one. The map files will insert from this point toward positive coordinates, north and east. You also need to give it an `insert_tag` value to reference it, that doesn't contain underscores [`_`]. **You are, obviously, encouraged to reuse existing and matching ones!**

### Map creation notes

When creating inserts, you are advised to use passthrough when able. If you set turfs/areas to /{turf,area}/template_noop, this means the turf (or area) won't be changed. This is interesting because it means your insert doesn't have to replicate (and keep updated) the main map, and blends in nicer with others.

### Adding standalone inserts: 'sprinkles'

The `map_sprinkle` tool is designed to allow easily adding small map inserts. If the map uses it, there should probably be a `sprinkles/` directory.

From there on, all you need to do is create (or reuse) a landmark, toss the file in with correct name, and that's it!

The name should be as follows:

* A number, percentage of chances to be included
* Either a dot `.` to mean this replaces previous map, or `+` to mean it adds to it
* The `insert_tag` of the landmark this should be put at
* Optionally an underscore and additional name
* `.dmm`

Examples:

* `50.hydro_destroyed.dmm` -> 50% chance to put this at `hydro`, replacing what's there
* `20+cargo_furniture.dmm` -> 20% chance to add this to `cargo`
* `10.armory.dmm` -> 10% chance to replace what's at armory with this
* `_34.something.dmm` -> doesn't start by digits, so ignored

### Adding 'variations'

The `map_variations` tool is similar, but selects among several files to put one at the landmark.

* This works similarly to sprinkles, but picks from files in a folder
* The weighting is relative, so if you have 50, 50, and 100, this means 25%, 25%, and 50%
* The rest of the file name doesn't matter

Example, if you have both:

* `maps/LV624/armory/10.extra.dmm`
* `maps/LV624/armory/10.looted.dmm`

-> Will pick either at 50% and insert it at the landmark defined in configuration.
From there on you can easily toss more in to add more.

## Content creation primer

There's more you can do in term of content creation, beyond just adding more random map changes.

### The Scenario

The Scenario is a simple intermediate step that is meant to simplify, and railroad, the creation process into something that globally makes sense.

Because it's easy to get lost in conditions, and the JSON tree format is not the most practical for this, but we don't want to give people unneeded freedom into making spagget, the intended way use Nightmare is to paint a scenario separately, then applying it.

This means deciding on important global parameters that are important to the process as a whole, such as the intended pathing that will be used in the map, global events, and so on, and encourage to sit down for a second, and clearly define what you're doing. It also allows these values to be edited in-game during Lobby!

The Scenario is special in that it is run immediately on loading, and provides more freedom in a logical sense. The main, simple intended usage is to use `def` node, which allows to set values.

This might sound stupidly simple, or annoying and unneeded, but for example allows to clearly untangle the 300 lines of NMC LV mess into something much simpler:

* Choosing between one of two special events, or none
* Choosing for a potential fog gap, west, bridge, or east

### Doing more than maps

As of current, all implemented tooling revolves around mapping. However the reason for making this system generic is to allow expanding on it with much more, as was attempted previously, for example flavouring of roles! Contact your nearby coder to implement new ones.
