#define FALLOFF_SOUNDS 1

#define FREE_CHAN_END 1016
#define INITIAL_SOUNDSCAPE_COOLDOWN 20

#define EAR_DEAF_MUTE 1

#define VOLUME_SFX 1
#define VOLUME_AMB 2
#define VOLUME_ADM 3
#define VOLUME_LOBBY 4
#define VOLUME_ANNOUNCEMENT 5

#define MUFFLE_LOW -500
#define MUFFLE_MEDIUM -2000
#define MUFFLE_HIGH -10000

#define SOUND_FREQ_HIGH 55000
#define SOUND_FREQ_LOW 32000

#define ITEM_EQUIP_VOLUME 50

//Reserved channels
#define SOUND_CHANNEL_NOTIFY 1016
#define SOUND_CHANNEL_VOX    1017
#define SOUND_CHANNEL_MUSIC 1018
#define SOUND_CHANNEL_AMBIENCE 1019
#define SOUND_CHANNEL_WALKMAN 1020
#define SOUND_CHANNEL_SOUNDSCAPE 1021
//#define SOUND_CHANNEL_ADMIN_MIDI 1022
#define SOUND_CHANNEL_LOBBY 1023
#define SOUND_CHANNEL_Z 1024


//default byond sound echo list index positions.
//ECHO_DIRECT and ECHO_ROOM are the only two that actually appear to do anything, and represent the dry and wet channels of the environment effects, respectively.
#define ECHO_DIRECT 1
#define ECHO_DIRECTHF 2
#define ECHO_ROOM 3
#define ECHO_ROOMHF 4
#define ECHO_OBSTRUCTION 5
#define ECHO_OBSTRUCTIONLFRATIO 6
#define ECHO_OCCLUSION 7
#define ECHO_OCCLUSIONLFRATIO 8
#define ECHO_OCCLUSIONROOMRATIO 9
#define ECHO_OCCLUSIONDIRECTRATIO 10
#define ECHO_EXCLUSION 11
#define ECHO_EXCLUSIONLFRATIO 12
#define ECHO_OUTSIDEVOLUMEHF 13
#define ECHO_DOPPLERFACTOR 14
#define ECHO_ROLLOFFFACTOR 15
#define ECHO_ROOMROLLOFFFACTOR 16
#define ECHO_AIRABSORPTIONFACTOR 17
#define ECHO_FLAGS 18

//default byond sound environments
#define SOUND_ENVIRONMENT_NONE -1
#define SOUND_ENVIRONMENT_GENERIC 0
#define SOUND_ENVIRONMENT_PADDED_CELL 1
#define SOUND_ENVIRONMENT_ROOM 2
#define SOUND_ENVIRONMENT_BATHROOM 3
#define SOUND_ENVIRONMENT_LIVINGROOM 4
#define SOUND_ENVIRONMENT_STONEROOM 5
#define SOUND_ENVIRONMENT_AUDITORIUM 6
#define SOUND_ENVIRONMENT_CONCERT_HALL 7
#define SOUND_ENVIRONMENT_CAVE 8
#define SOUND_ENVIRONMENT_ARENA 9
#define SOUND_ENVIRONMENT_HANGAR 10
#define SOUND_ENVIRONMENT_CARPETED_HALLWAY 11
#define SOUND_ENVIRONMENT_HALLWAY 12
#define SOUND_ENVIRONMENT_STONE_CORRIDOR 13
#define SOUND_ENVIRONMENT_ALLEY 14
#define SOUND_ENVIRONMENT_FOREST 15
#define SOUND_ENVIRONMENT_CITY 16
#define SOUND_ENVIRONMENT_MOUNTAINS 17
#define SOUND_ENVIRONMENT_QUARRY 18
#define SOUND_ENVIRONMENT_PLAIN 19
#define SOUND_ENVIRONMENT_PARKING_LOT 20
#define SOUND_ENVIRONMENT_SEWER_PIPE 21
#define SOUND_ENVIRONMENT_UNDERWATER 22
#define SOUND_ENVIRONMENT_DRUGGED 23
#define SOUND_ENVIRONMENT_DIZZY 24
#define SOUND_ENVIRONMENT_PSYCHOTIC 25

/*
//from https://github.com/g-truc/shooter/blob/e149886ede8e51d4f95fbdd0a3f64fd1f4b9a366/external/fmod-3.75/api/delphi/fmodpresets.pas#L55-L84
//                                            EnvSize  EnvDiffusion    Room  RoomHF  RoomLF  DecayTime  DecayHFRatio  DecayLFRatio  Reflections  ReflectionsDelay  Reverb  ReverbDelay  EchoTime  EchoDepth  ModulationTime  ModulationDepth  AirAbsorptionHF  HFReference  LFReference  RoomRolloffFactor  Diffusion  Density  Flags
#define SOUND_ENVIRONMENT_OFF              list(  7.5,         1.00, -10000, -10000,      0,      1.00,         1.00,          1.0,       -2602,            0.007,    200,       0.011,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,       0.0,     0.0,    33)
#define SOUND_ENVIRONMENT_GENERIC          list(  7.5,         1.00,  -1000,   -100,      0,      1.49,         0.83,          1.0,       -2602,            0.007,    200,       0.011,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_PADDEDCELL       list(  1.4,         1.00,  -1000,  -6000,      0,      0.17,         0.10,          1.0,       -1204,            0.001,    207,       0.002,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_ROOM             list(  1.9,         1.00,  -1000,   -454,      0,      0.40,         0.83,          1.0,       -1646,            0.002,     53,       0.003,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_BATHROOM         list(  1.4,         1.00,  -1000,  -1200,      0,      1.49,         0.54,          1.0,        -370,            0.007,   1030,       0.011,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,    60.0,     3)
#define SOUND_ENVIRONMENT_LIVINGROOM       list(  2.5,         1.00,  -1000,  -6000,      0,      0.50,         0.10,          1.0,       -1376,            0.003,  -1104,       0.004,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_STONEROOM        list( 11.6,         1.00,  -1000,   -300,      0,      2.31,         0.64,          1.0,        -711,            0.012,     83,       0.017,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_AUDITORIUM       list( 21.6,         1.00,  -1000,   -476,      0,      4.32,         0.59,          1.0,        -789,            0.020,   -289,       0.030,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_CONCERTHALL      list( 19.6,         1.00,  -1000,   -500,      0,      3.92,         0.70,          1.0,       -1230,            0.020,     -2,       0.029,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_CAVE             list( 14.6,         1.00,  -1000,      0,      0,      2.91,         1.30,          1.0,        -602,            0.015,   -302,       0.022,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     1)
#define SOUND_ENVIRONMENT_ARENA            list( 36.2,         1.00,  -1000,   -698,      0,      7.24,         0.33,          1.0,       -1166,            0.020,     16,       0.030,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_HANGAR           list( 50.3,         1.00,  -1000,  -1000,      0,     10.05,         0.23,          1.0,        -602,            0.020,    198,       0.030,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_CARPETTEDHALLWAY list(  1.9,         1.00,  -1000,  -4000,      0,      0.30,         0.10,          1.0,       -1831,            0.002,  -1630,       0.030,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_HALLWAY          list(  1.8,         1.00,  -1000,   -300,      0,      1.49,         0.59,          1.0,       -1219,            0.007,    441,       0.011,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_STONECORRIDOR    list( 13.5,         1.00,  -1000,   -237,      0,      2.70,         0.79,          1.0,       -1214,            0.013,    395,       0.020,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_ALLEY            list(  7.5,         0.30,  -1000,   -270,      0,      1.49,         0.86,          1.0,       -1204,            0.007,     -4,       0.011,    0.125,      0.95,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_FOREST           list( 38.0,         0.30,  -1000,  -3300,      0,      1.49,         0.54,          1.0,       -2560,            0.162,   -229,       0.088,    0.125,      1.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,      79.0,   100.0,     3)
#define SOUND_ENVIRONMENT_CITY             list(  7.5,         0.50,  -1000,   -800,      0,      1.49,         0.67,          1.0,       -2273,            0.007,  -1691,       0.011,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,      50.0,   100.0,     3)
#define SOUND_ENVIRONMENT_MOUNTAINS        list(100.0,         0.27,  -1000,  -2500,      0,      1.49,         0.21,          1.0,       -2780,            0.300,  -1434,       0.100,    0.250,      1.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,      27.0,   100.0,     1)
#define SOUND_ENVIRONMENT_QUARRY           list( 17.5,         1.00,  -1000,  -1000,      0,      1.49,         0.83,          1.0,      -10000,            0.061,    500,       0.025,    0.125,      0.70,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_PLAIN            list( 42.5,         0.21,  -1000,  -2000,      0,      1.49,         0.50,          1.0,       -2466,            0.179,  -1926,       0.100,    0.250,      1.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,      21.0,   100.0,     3)
#define SOUND_ENVIRONMENT_PARKINGLOT       list(  8.3,         1.00,  -1000,      0,      0,      1.65,         1.50,          1.0,       -1363,            0.008,  -1153,       0.012,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     1)
#define SOUND_ENVIRONMENT_SEWERPIPE        list(  1.7,         0.80,  -1000,  -1000,      0,      2.81,         0.14,          1.0,         429,            0.014,   1023,       0.021,    0.250,      0.00,           0.25,           0.000,            -5.0,      5000.0,       250.0,               0.0,      80.0,    60.0,     3)
#define SOUND_ENVIRONMENT_UNDERWATER       list(  1.8,         1.00,  -1000,  -4000,      0,      1.49,         0.10,          1.0,        -449,            0.007,   1700,       0.011,    0.250,      0.00,           1.18,           0.348,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     3)
#define SOUND_ENVIRONMENT_DRUGGED          list(  1.9,         0.50,  -1000,      0,      0,      8.39,         1.39,          1.0,        -115,            0.002,    985,       0.030,    0.250,      0.00,           0.25,           1.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     1)
#define SOUND_ENVIRONMENT_DIZZY            list(  1.8,         0.60,  -1000,   -400,      0,     17.23,         0.56,          1.0,       -1713,            0.020,   -613,       0.030,    0.250,      1.00,           0.81,           0.310,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     1)
#define SOUND_ENVIRONMENT_PSYCHOTIC        list(  1.0,         0.50,  -1000,   -151,      0,      7.56,         0.91,          1.0,        -626,            0.020,    774,       0.030,    0.250,      0.00,           4.00,           1.000,            -5.0,      5000.0,       250.0,               0.0,     100.0,   100.0,     1)
*/

#define SOUND_ECHO_REVERB_OFF list(null, null, -10000, -10000, null, null, null, null, null, null, null, null, null, null, null, null, null, null) //-10000 to Room & RoomHF makes enviromental reverb effectively inaudible, nulls are interpreted as default values

//for /datum/sound_template.sound_flags
/// Enviromental sounds are effected by environmental reverb
#define SOUND_TEMPLATE_ENVIRONMENTAL (1<<4)
/// Sound can be muted by mob deafness
#define SOUND_TEMPLATE_CAN_DEAFEN (1<<5)
/// Spatial sounds set the sound position relative to the source
#define SOUND_TEMPLATE_SPATIAL (1<<6)
/// Sound is tracked by soundOutput for updating position, volume, etc
#define SOUND_TEMPLATE_TRACKED (1<<7)

#define AMBIENCE_SHIP 'sound/ambience/shipambience.ogg'
#define AMBIENCE_JUNGLE 'sound/ambience/ambienceLV624.ogg'
#define AMBIENCE_RIVER  'sound/ambience/ambienceriver.ogg'
#define AMBIENCE_MALL 'sound/ambience/medbay1.ogg'
#define AMBIENCE_CAVE 'sound/ambience/desert.ogg'
#define AMBIENCE_YAUTJA 'sound/ambience/yautja_ship.ogg'

#define SOUND_MARINE_DRUMS 'sound/effects/drums.ogg'

#define AMBIENCE_ALMAYER 'sound/ambience/almayerambience.ogg'
#define AMBIENCE_LV624 'sound/ambience/ambienceLV624.ogg'
#define AMBIENCE_BIGRED 'sound/ambience/desert.ogg'
#define AMBIENCE_NV 'sound/ambience/ambienceNV.ogg'
#define AMBIENCE_PRISON 'sound/ambience/shipambience.ogg'
#define AMBIENCE_TRIJENT 'sound/ambience/desert.ogg'

#define SCAPE_PL_WIND list('sound/soundscape/wind1.ogg','sound/soundscape/wind2.ogg')
#define SCAPE_PL_LV522_OUTDOORS list('sound/soundscape/lv522/outdoors/wind1.ogg','sound/soundscape/lv522/outdoors/wind2.ogg','sound/soundscape/lv522/outdoors/wind3.ogg',)
#define SCAPE_PL_LV522_INDOORS list('sound/soundscape/lv522/indoors/indoor_wind.ogg','sound/soundscape/lv522/indoors/indoor_wind2.ogg')
#define SCAPE_PL_CAVE list('sound/soundscape/rocksfalling1.ogg', 'sound/soundscape/rocksfalling2.ogg')
#define SCAPE_PL_ELEVATOR_MUSIC list('sound/soundscape/medbay1.ogg','sound/soundscape/medbay2.ogg', 'sound/soundscape/medbay3.ogg')
#define SCAPE_PL_THUNDER list('sound/soundscape/thunderclap1.ogg', 'sound/soundscape/thunderclap2.ogg')
#define SCAPE_PL_DESERT_STORM list('sound/soundscape/thunderclap1.ogg', 'sound/soundscape/thunderclap2.ogg', 'sound/soundscape/wind1.ogg','sound/soundscape/wind2.ogg')
#define SCAPE_PL_CIC list('sound/soundscape/cicamb2.ogg', 'sound/soundscape/cicamb3.ogg', 'sound/soundscape/cicamb4.ogg', 'sound/soundscape/cicamb5.ogg', 'sound/soundscape/cicamb6.ogg', )
#define SCAPE_PL_ENG list('sound/soundscape/engamb1.ogg', 'sound/soundscape/engamb2.ogg', 'sound/soundscape/engamb3.ogg', 'sound/soundscape/engamb4.ogg', 'sound/soundscape/engamb5.ogg', 'sound/soundscape/engamb6.ogg', 'sound/soundscape/engamb7.ogg', )
#define SCAPE_PL_HANGAR list('sound/soundscape/hangaramb1.ogg', 'sound/soundscape/hangaramb2.ogg', 'sound/soundscape/hangaramb3.ogg', 'sound/soundscape/hangaramb4.ogg', 'sound/soundscape/hangaramb5.ogg', 'sound/soundscape/hangaramb6.ogg', 'sound/soundscape/hangaramb7.ogg', 'sound/soundscape/hangaramb8.ogg', 'sound/soundscape/hangaramb9.ogg', 'sound/soundscape/hangaramb10.ogg', )
#define SCAPE_PL_ARES list('sound/soundscape/mother.ogg')
