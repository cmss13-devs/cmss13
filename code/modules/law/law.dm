/*
	There's a single instance of each law datum per rounds. These hold all of the data
	that is needed to process a crime. When a criminal is brought in, you select a law
	that was broken, and a crime datum is created.
*/

/datum/law
	var/name = "Law" // This is the name of the law.
	var/desc = "Pay the court a fine or serve your sentence." // This is used for the description of the crime.
	var/explanation //This is used by the mp to describe what the person did for the charge.
	var/brig_time = 0 //The amount of time the sentence brings

	var/special_punishment = "" //This is for special punishments.
	var/conditions = "" //This is for detailing conditions of application.

//These are bitflags to indicate the type of crime it is.
#define OPTIONAL_CRIME (1<<0)
#define MINOR_CRIME (1<<1)
#define MAJOR_CRIME (1<<2)
#define CAPITAL_CRIME (1<<3)
#define PRECAUTIONARY_CHARGE (1<<4)

//These are bitflags for special punishments
#define PERMABRIG (1<<0)
#define DOUBLE_TIME (1<<1)
#define SAME_AS_ACCUSED (1<<2)
#define DEMOTION (1<<3)
