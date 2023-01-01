# Shuttle Module

Heres some notes which help understand what is going on.

A shuttle is split into two docking ports: a mobile one, which is the shuttle itself, and the stationary one - where the shuttle can come to a rest.

The map template `/datum/map_template/shuttle/ert1` - give it a unique name and the `shuttle_id` parameter is the map name you are using for the shuttle.

The map template shuttle_id points to the file in folder `maps\shuttles`. It also refers to the `id` variable in the mobile docking port. The best way to resolve this is using a define in `code\__DEFINES\shuttles.dm`.
## Shuttle map templates

Shuttle map templates are used to define what the shuttle should look like.

## Shuttle dimenions

When defining the shuttle dimensions, define the height/width as if it was orienting north. The subsystem will properly line everything up, this allows for stationary docks to be in different orientations to their defined map template.
