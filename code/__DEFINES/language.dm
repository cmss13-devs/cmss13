#define LANGUAGE_ENGLISH "English"
#define LANGUAGE_JAPANESE "Japanese"
#define LANGUAGE_CHINESE "Chinese"
#define LANGUAGE_RUSSIAN "Russian"
#define LANGUAGE_GERMAN "German"
#define LANGUAGE_SPANISH "Spanish"
#define LANGUAGE_TSL "Tactical Sign Language"
#define LANGUAGE_YAUTJA "Sainja"
#define LANGUAGE_MONKEY "Primitive" // nanu
#define LANGUAGE_HELLHOUND "Hellhound"

#define LANGUAGE_XENOMORPH "Xenomorph"
#define LANGUAGE_HIVEMIND "Hivemind"

#define LANGUAGE_APOLLO "Apollo Link"

#define LANGUAGE_TELEPATH "Telepath Implant"

#define ALL_HUMAN_LANGUAGES list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_CHINESE, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_SPANISH)

#define ALL_SYNTH_LANGUAGES list(LANGUAGE_ENGLISH, LANGUAGE_JAPANESE, LANGUAGE_CHINESE, LANGUAGE_RUSSIAN, LANGUAGE_GERMAN, LANGUAGE_SPANISH, LANGUAGE_YAUTJA, LANGUAGE_XENOMORPH)

//Chinese language sound bitflags

//initial flags

#define FRONT_CLOSE_ONLY (1<<0)
#define SIMPLE_U_ONLY (1<<1)
#define HALF_U (1<<2)
#define NO_FRONT_CLOSE (1<<3)
#define SIMPLIFY_UO (1<<4)
#define NO_E_ONG (1<<5)
#define DENTAL_ALV (1<<6)
#define NONDENTAL_ALV (1<<7)
#define NO_SYLLABIC_I (1<<8)
#define ZERO_INITIAL (1<<9)

//final flags

#define U_GROUP_FULL (1<<0)
#define U_UMLAUT (1<<1)
#define U_UMLAUT_RARE (1<<2)
