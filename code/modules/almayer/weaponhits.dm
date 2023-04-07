/**
 * Proc called to hit the ship with weapons
 *
 * Hits the ship with the weapon of choice
 * Calling Shakeship acoording to the weapon used
 * All sounds that should happen when they hit are in here already.
 * Probably doesn't work in other shipmaps.
 * Arguments:
 * * weaponused - chooses the weapon through a switchcase
 * * shotnumber - how many shots of the weapon will be fired, may not have effect with specific weapons
 * * specificlocation - bool, if yes, it will instead of choosing a random location on the ship, hit at a chosen location
 * * location - location to be used.
 */
/proc/weaponhits(weaponused, shotnumber specificlocation, location)
