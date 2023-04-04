/**
 * Proc called to hit the ship with weapons
 *
 * Hits the ship with the weapon of choice
 * Calling Shakeship acoording to the weapon used
 * All sounds that should happen when they hit are in here already.
 * Probably doesn't work in other shipmaps.
 * Arguments:
 * * weaponused - chooses the weapon through a switchcase
 * * specificlocation - bool, if yes, it will instead of choosing a random location on the ship, hit at a chosen location
 */
/proc/weaponhits(weaponused, specificlocation, location)
