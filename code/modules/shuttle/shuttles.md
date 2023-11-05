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


# Generic Elevator Shuttle

The elevator used on Trijent (DesertDam) can be used in any map and multiple can exist on one map.

Do not modify the trident shuttle map. You can code in elevators from the following two docking ports (where the elevator can go):

- /obj/docking_port/stationary/trijent_elevator/occupied
- /obj/docking_port/stationary/trijent_elevator/empty

An occupied stationary port will start the map with an elevator and an empty one will not.
All docking ports are, by default, linked together. One elevator can go to all docking ports.
To limit access between docking ports you can use tags.

To setup an elevator:
- place the docking port where you want the elevator to sit
- give the docking port instance a unique ID
- give the docking port instance a unique Name
- make sure the door direction is correct west/east
- give the docking port shuttle_area the area name for where it sits
- if you want to build a docking port 'network' then change the roudnstart_template to a subclass
- if you want to assign a docking port to a 'network' then give it a value in "tag"

If things are unclear, look at trident. It has two elevator networks.
