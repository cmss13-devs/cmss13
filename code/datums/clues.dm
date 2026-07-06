/datum/clue
	/// Who created this clue?
	var/clue_owner = null

	/// An optional description to accompany the clue.
	var/description = null

	/// This clue has been marked for cleanup.
	/// Do what you need to do before calling the parent process method.
	var/cleanup = FALSE
	var/created_time = 0

/datum/clue/New(/mob/living/carbon/human/owner, desc = "")
	clue_owner = owner

	if (desc != "")
		description = desc

/datum/clue/process()
	// Safety check to delete clues after an hour of gametime
	if (world.timeofday - created_time > 1 HOURS)
		return PROCESS_KILL

	if (cleanup)
		return PROCESS_KILL

/datum/clue/prints
	/// The type of glove that was worn when these fingerprints were created.
	/// Is null if no gloves were worn.
	var/glove_type = null

	/// If these fingerprints were made by a left hand, is true.
	var/left_handed = FALSE

	/// If these fingerprints were made by something oily.
	/// Determines if forensic spray increases the chance of them being found.
	var/oily = FALSE

/datum/clue/prints/New()


/datum/clue/hair
	/// The length of this hair.
	/// Humans with longer hairstyles are more likely to leave longer hairs on objects.
	var/hair_length = 0

	/// The approximate color of the hair.
	var/hair_color = null

/datum/clue/fiber
	/// The type of clothing that was worn when this clue was created.
	/// CAN include glove fibers. Should not be null.
	var/clothing_type = null

/datum/clue/footprint
	/// The type of footwear that was worn when this footprint was made.
	/// Is null if these are barefoot prints (ew).
	var/boot_type = null

	/// Was this footprint made after stepping in a pool of blood?
	var/is_bloody = FALSE

	/// Was this footprint made after stepping in a pool of oil?
	var/is_oily = FALSE

/datum/clue/blood_splatter
	/// Was this splatter made by a blunt object?
	var/is_blunt = FALSE

	/// Was this splatter made by a sharp object?
	var/is_sharp = FALSE

	/// Was this splatter caused by a bullet?
	var/is_bullet = FALSE

	/// How many people were nearby when this blood spatter was made?
	/// In real life, this is found by seeing where the blood spray is NOT.
	var/nearby_assailants = 0

	/// Does this blood splatter need to be sprayed with forensic spray to be found?
	var/is_subtle = FALSE
