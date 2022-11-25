# CM-SS13 Nightmare Design Notes
The Nightmare system is intended to be a replacement for legacy "Nightmare Creator". Its primary function is to change the game map, but is being expanded to encompass more dynamic round variations.

## Lifecycle
Nightmare is resovled in three phases:
 * The Scenario is resolved at game init
 * The Main Configuration is resolved at game start
 * The resulting Tasks to effect the game are then executed


## The Scenario

By design, the scenario is initialized at game init to leave game staff the possibility to adjust  it before game start.
This makes it possible to override or tweak what Nightmare will do, for example for event running purposes.

In addition, the Scenario is meant to provide a guard against overcomplex usage: the creator is expected to first use the scenario step to define pivotal elements (eg. LV-624 fog gap location), then act upon them with simplified logic.

**This means the scenario can only define logical flow, and the main configuration can only use it.**

Fencing such usage prevents logical loops or procedural logic to keep things as simple as possible

## Contexts and Scoping
Because Nightmare's primary usage is to affect the game maps, each map is handled individually through a `nmcontext`. Each context contains relevant information to resolve configured steps. This allows to take action upon loading everything on a map, or to have operations scoped to a Z-Level, etc...

In addition to the contexts for ground and ship map, we also have a "global" context. It is meant for any dynamic actions that do not concern the maps directly : for example changing jobs, game mode, etc.
