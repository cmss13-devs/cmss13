// These may have some say.dm bugs regarding understanding common,
// might be worth adapting the bugs into a feature and using these
// subtypes as a basis for non-common-speaking alien foreigners. ~ Z

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/synthetic/New(var/new_loc)
	..(new_loc, "Synthetic")

/mob/living/carbon/human/synthetic_old/New(var/new_loc)
	..(new_loc, "Early Synthetic")

/mob/living/carbon/human/synthetic_2nd_gen/New(var/new_loc)
	..(new_loc, "Second Generation Synthetic")