# Shuttle Module

Heres some notes which help understand what is going on.

A shuttle is split into two docking ports: a mobile one, which is the shuttle itself, and the stationary one - where the shuttle can come to a rest.

The map template `/datum/map_template/shuttle/ert1` - give it a unique name and the `shuttle_id` parameter is the map name you are using for the shuttle.

The map template shuttle_id points to the file in folder `maps\shuttles`. It also refers to the `id` variable in the mobile docking port. The best way to resolve this is using a define in `code\__DEFINES\shuttles.dm`.
