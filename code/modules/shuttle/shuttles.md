# Shuttle Module

Heres some notes which help understand what is going on.

A shuttle is split into two docking ports: a mobile one, which is the shuttle itself, and the stationary one - where the shuttle can come to a rest.

The map template `/datum/map_template/shuttle/ert1` - give it a unique name and the `shuttle_id` parameter is the map name you are using for the shuttle.

The map template shuttle_id points to the file in folder `maps\shuttles`. It also refers to the `id` variable in the mobile docking port. The best way to resolve this is using a define in `code\__DEFINES\shuttles.dm`.
## Shuttle map templates

Shuttle map templates are used to define what the shuttle should look like.

## Shuttle dimensions

When defining the shuttle dimensions, define the height/width as if it was orienting north. The subsystem will properly line everything up, this allows for stationary docks to be in different orientations to their defined map template.

A shuttle has a height, width, dheight and dwidth. The height and width is the size of the shuttle, with respect to its direction. If the template direction is North/South then width is your X coordinate and height is your Y. If the template direction is East/West then width is your Y direction and height is your X. On stationary docking ports, you can specify dwidth and dheight (auto generated for mobile), these are offsets for how your shuttle should land on the site. When a mobile port lands on a stationary port it wants to place the bottom left of the shuttle turfs on the stationary port. The dwidth/dheight allows you to offset this.
