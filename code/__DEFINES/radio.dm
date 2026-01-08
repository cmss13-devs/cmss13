#define WIRE_SIGNAL 1 //sends a signal, like to set off a bomb or electrocute someone
#define WIRE_RECEIVE 2
#define WIRE_TRANSMIT 4
#define TRANSMISSION_DELAY 5 // only 2/second/radio
#define FREQ_LISTENING 1

#define RADIO_VOLUME_QUIET  0
#define RADIO_VOLUME_RAISED 1
#define RADIO_VOLUME_IMPORTANT  2
#define RADIO_VOLUME_CRITICAL   3
#define RADIO_VOLUME_MAX    3

#define RADIO_VOLUME_QUIET_STR "Quiet"
#define RADIO_VOLUME_RAISED_STR "Raised"
#define RADIO_VOLUME_IMPORTANT_STR "Important"
#define RADIO_VOLUME_CRITICAL_STR "Critical"
#define RADIO_MODE_WHISPER "whisper"

//Radio channels
#define RADIO_CHANNEL_BLANK "UNSET"
#define RADIO_CHANNEL_ALMAYER "Almayer"
#define RADIO_CHANNEL_ALAMO "Alamo"
#define RADIO_CHANNEL_COMMAND "Command"
#define RADIO_CHANNEL_COLONY "Colony"
#define RADIO_CHANNEL_DEPARTMENT "department"
#define RADIO_CHANNEL_HEADSET "headset"
#define RADIO_CHANNEL_ENGI "Engi"
#define RADIO_CHANNEL_HIGHCOM "HighCom"
#define RADIO_CHANNEL_PROVOST "Provost"
#define RADIO_CHANNEL_INTERCOM "intercom"
#define RADIO_CHANNEL_INTEL "Intel"
#define RADIO_CHANNEL_JTAC "JTAC"
#define RADIO_CHANNEL_MEDSCI "MedSci"
#define RADIO_CHANNEL_MP "MP"
#define RADIO_CHANNEL_NORMANDY "Normandy"
#define RADIO_CHANNEL_SAIPAN "Saipan"
#define RADIO_CHANNEL_REQ "Req"
#define RADIO_CHANNEL_SENTRY "Sentry Network"
#define RADIO_CHANNEL_SPECIAL "special"

//CLF Comms
#define RADIO_CHANNEL_CLF_GEN "CLF"
#define RADIO_CHANNEL_CLF_CMD "CLF Command"
#define RADIO_CHANNEL_CLF_CCT "CLF CCT"
#define RADIO_CHANNEL_CLF_MED "CLF Med"
#define RADIO_CHANNEL_CLF_ENGI "CLF Engi"

//UPP Comms
#define RADIO_CHANNEL_UPP_GEN "UPP"
#define RADIO_CHANNEL_UPP_CMD "UPP Command"
#define RADIO_CHANNEL_UPP_MED "UPP Med"
#define RADIO_CHANNEL_UPP_ENGI "UPP Engi"
#define RADIO_CHANNEL_UPP_CCT "UPP CCT"
#define RADIO_CHANNEL_UPP_KDO "UPP Kdo"

//WY Comms
#define RADIO_CHANNEL_WY "WY"
#define RADIO_CHANNEL_PMC_GEN "WY PMC"
#define RADIO_CHANNEL_PMC_CMD "PMC Command"
#define RADIO_CHANNEL_PMC_MED "PMC Med"
#define RADIO_CHANNEL_PMC_ENGI "PMC Engi"
#define RADIO_CHANNEL_PMC_CCT "PMC CCT"
#define RADIO_CHANNEL_WY_WO "SpecOps"

//Hyperdyne Comms

#define RADIO_CHANNEL_HYPERDYNE "Hyperdyne"

//Listening Devices
#define RADIO_CHANNEL_BUG_A "Listening Device A"
#define RADIO_CHANNEL_BUG_B "Listening Device B"

//Fax Responder Bugs
#define RADIO_CHANNEL_FAX_WY "WY Monitor"
#define RADIO_CHANNEL_FAX_USCM_HC "USCM-HC Monitor"
#define RADIO_CHANNEL_FAX_USCM_PVST "Provost Monitor"

//1-Channel ERTs
#define RADIO_CHANNEL_DUTCH_DOZEN "DD"
#define RADIO_CHANNEL_VAI "VAI"
#define RADIO_CHANNEL_CMB "CMB"
#define RADIO_CHANNEL_ROYAL_MARINE "Royal Marine"
#define RADIO_CHANNEL_CIA "CIA"

#define RADIO_CHANNEL_YAUTJA "Yautja"
#define RADIO_CHANNEL_YAUTJA_OVERSEER "Overseer"


// Listening bug broadcast setting. Whether or not it plays only to ghosts with preferences, or doesn't show to ghosts at all.
#define NOT_LISTENING_BUG 0
#define LISTENING_BUG_PREF 1
#define LISTENING_BUG_NEVER 2
