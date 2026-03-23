/*
	This datum is used to store all of the values for halo shielding, both Spartan and Covenant.
	It also stores the shields of specific ranks within the Covenant. Icons and other values such as
	the current health of a shield are found within the armor itself
*/

/datum/halo_shield
	/// The maximum health of the shield
	var/max_shield_strength
	/// The time it takes to begin regen after taking damage
	var/time_to_regen
	/// The time it takes for a shield to reach full health again
	var/recovery_time = 5 SECONDS

/datum/halo_shield/tester_shield
	max_shield_strength = 100
	time_to_regen = 5 SECONDS

/datum/halo_shield/sangheili
	time_to_regen = 15 SECONDS

/datum/halo_shield/sangheili/minor
	max_shield_strength = 150
	recovery_time = 5 SECONDS

/datum/halo_shield/sangheili/major
	max_shield_strength = 200
	recovery_time = 4 SECONDS

/datum/halo_shield/sangheili/ultra
	max_shield_strength = 300
	recovery_time = 3 SECONDS

/datum/halo_shield/sangheili/zealot
	max_shield_strength = 400
	recovery_time = 2 SECONDS

/datum/halo_shield/sangheili/stealth
	max_shield_strength = 100
	time_to_regen = 10 SECONDS
	recovery_time = 2 SECONDS
