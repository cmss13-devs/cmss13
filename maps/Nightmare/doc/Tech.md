# CM-SS13 Nightmare Tech Notes

The Nightmare system was designed with flexibility in mind, but quickly became somewhat complicated due to a certain amount of technical issues with the concept and game tech stack.

## Overview
The Nightmare system is comprised of several components:
 * `/datum/nmnode` describe entries in the configuration
 * `/datum/nmcontext` describe a context used for resolving nodes and tasks
 * `/datum/nmtask` describe tasks to act upon the rest of the game
 * `SSnightmare` handles parsing configuration JSON files, init, and startup

## Organisation
To keep things as simple as possible in usage, each component is fenced to its specific usage:
 * a `nmnode` is instanciated with only its own JSON info
 * a `nmnode` is resolved in a `nmcontext` and should have no outside effects
 * a `nmnode` from scenario may only affect the `nmcontext` scenario
 * a `nmnode` from runtime config may only affect the `nmcontext` tasks
 * a `nmtask`must be synchronous and independant from context and nodes

## The scheduling problem
Nightmare occupies a weird blind spot in CM and /tg/ tooling because it performs tasks that would typically pertain to game and Master Controller initialization (notably map loading), but does so further in during lobby / game setup time to allow edition.

After resolving all `nmnode`s, `nmcontext`s contain a list of tasks to be executed. These tasks may be long-running and include map loading, which sleeps to keep game running. We however, need to be able to know when they end. This brings very few practical solutions :

### Method 1: Mandatory Synchronicity
This is the chosen method as of current. Basically, we assume that every task is executed sychronously and will be done by the time the call returns. This mean that any sleeping within the task will also sleep the caller thread. This does not allow for parallelism / juggling tasks. It also requires a global lock to monitor completion: in current implementation, this is done via SSnightmare.stat monitored by SSticker loop.

### Method 2: Supervised tasks
This works similarly to above, but tasks can now run asynchronously. This means having a detachable invoke wrapper, to both know when the task sleeps, and when it hands. The result is picked up by either a callback or a waiting loop. Unfortunately, callback stacking deepens call stack much like a loop, and any task failing to properly return will cause everything to stop.

### Method 3: Cooperative scheduling
The most complicated to implement is to use cooperative scheduling. We use a subsystem like SSnightmare to provide a ticker. Then every task must return to it without sleeping, with a status code: ok, error, continue execution, pause execution. Sleep can be handled by wrappers described above, or through the ticker loop checking for return. It provides many inconvenients of method 2, but a fine grained control over execution. The biggest drawback is that this is essentially making a mini-MC with tasks instead of subsystems...
