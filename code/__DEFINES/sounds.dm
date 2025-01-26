#define FALLOFF_SOUNDS 1

#define FREE_CHAN_END 1016
#define INITIAL_SOUNDSCAPE_COOLDOWN 20

#define EAR_DEAF_MUTE 1

#define VOLUME_SFX 1
#define VOLUME_AMB 2
#define VOLUME_ADM 3
#define VOLUME_LOBBY 4
#define VOLUME_TTS  5

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

#define SOUND_ECHO_REVERB_ON list(0, 0, 0, 0, 0, 0.0, 0, 0.25, 1.5, 1.0, 0, 1.0, 0, 0.0, 0.0, 0.0, 1.0, 0)
#define SOUND_ECHO_REVERB_OFF list(0, 0, -10000, -10000, 0, 0.0, 0, 0.25, 1.5, 1.0, 0, 1.0, 0, 0.0, 0.0, 0.0, 1.0, 0) //-10000 to Room & RoomHF makes enviromental reverb effectively inaudible

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

// Hybrisa Soundscapes

#define AMBIENCE_CITY 'sound/ambience/city_on_fire.ogg'
#define AMBIENCE_DERELICT 'sound/ambience/derelict_ambience.ogg'
#define AMBIENCE_LAB 'sound/ambience/lab_ambience.ogg'
#define AMBIENCE_LAB_2 'sound/ambience/lab_ambience_2.ogg'
#define AMBIENCE_LAB_HALLWAY 'sound/ambience/lab_ambience_hallway.ogg'
#define AMBIENCE_WEYMART 'sound/ambience/weymart.ogg'
#define AMBIENCE_HYBRISA_INTERIOR 'sound/ambience/hybrisa_interior.ogg'
#define AMBIENCE_HYBRISA_CAVES 'sound/ambience/caves_ambience.ogg'
#define AMBIENCE_HYBRISA_CAVES_ALARM 'sound/ambience/caves_ambience_alarm.ogg'

#define SCAPE_PL_LV759_OUTDOORS list('sound/soundscape/lv759/outdoors/wind4.ogg','sound/soundscape/lv759/outdoors/wind5.ogg','sound/soundscape/lv759/outdoors/wind6.ogg','sound/soundscape/lv759/outdoors/wind7.ogg','sound/soundscape/lv759/outdoors/wind8.ogg','sound/soundscape/lv759/outdoors/wind9.ogg','sound/soundscape/lv759/outdoors/wind10.ogg','sound/soundscape/lv759/outdoors/wind11.ogg','sound/soundscape/lv759/outdoors/wind12.ogg','sound/soundscape/lv759/outdoors/wind13.ogg','sound/soundscape/lv759/outdoors/wind14.ogg','sound/soundscape/lv759/outdoors/wind15.ogg','sound/soundscape/lv759/outdoors/wind16.ogg','sound/soundscape/lv759/outdoors/wind17.ogg','sound/soundscape/lv759/outdoors/wind18.ogg','sound/soundscape/lv759/outdoors/wind19.ogg','sound/soundscape/lv759/outdoors/wind20.ogg','sound/soundscape/lv759/outdoors/wind21.ogg','sound/soundscape/lv759/outdoors/wind22.ogg','sound/soundscape/lv759/outdoors/wind23.ogg','sound/soundscape/lv759/outdoors/wind24.ogg','sound/soundscape/lv759/outdoors/wind25.ogg','sound/soundscape/lv759/outdoors/wind26.ogg','sound/soundscape/lv759/outdoors/wind27.ogg','sound/soundscape/lv759/outdoors/wind28.ogg',)
#define SCAPE_PL_LV759_INDOORS list('sound/soundscape/lv522/indoors/indoor_wind.ogg','sound/soundscape/lv522/indoors/indoor_wind2.ogg','sound/soundscape/lv759/indoors/vent_1.ogg','sound/soundscape/lv759/indoors/vent_2.ogg','sound/soundscape/lv759/indoors/vent_3.ogg','sound/soundscape/lv759/indoors/vent_4.ogg','sound/soundscape/lv759/indoors/vent_5.ogg','sound/soundscape/lv759/indoors/vent_6.ogg','sound/soundscape/lv759/indoors/vent_7.ogg','sound/soundscape/lv759/indoors/vent_6.ogg','sound/soundscape/lv759/indoors/distant_sounds_1.ogg','sound/soundscape/lv759/indoors/distant_sounds_2.ogg','sound/soundscape/lv759/indoors/distant_sounds_3.ogg','sound/soundscape/lv759/indoors/distant_sounds_4.ogg','sound/soundscape/lv759/indoors/distant_sounds_5.ogg','sound/soundscape/lv759/indoors/distant_sounds_6.ogg','sound/soundscape/lv759/indoors/distant_sounds_7.ogg','sound/soundscape/lv759/indoors/distant_sounds_8.ogg','sound/soundscape/lv759/indoors/distant_sounds_9.ogg','sound/soundscape/lv759/indoors/distant_sounds_10.ogg','sound/soundscape/engamb1.ogg','sound/soundscape/engamb2.ogg','sound/soundscape/engamb3.ogg','sound/soundscape/engamb4.ogg','sound/soundscape/engamb5.ogg','sound/soundscape/engamb6.ogg','sound/soundscape/engamb7.ogg',)
#define SCAPE_PL_LV759_DERELICTSHIP list('sound/soundscape/lv759/indoors/derelict1.ogg','sound/soundscape/lv759/indoors/derelict2.ogg','sound/soundscape/lv759/indoors/derelict3.ogg','sound/soundscape/lv759/indoors/derelict4.ogg','sound/soundscape/lv759/indoors/derelict5.ogg','sound/soundscape/lv759/indoors/derelict6.ogg','sound/soundscape/lv759/indoors/derelict7.ogg','sound/soundscape/lv759/indoors/derelict8.ogg')
#define SCAPE_PL_LV759_DEEPCAVES list('sound/soundscape/lv759/outdoors/deepcave1.ogg','sound/soundscape/lv759/outdoors/deepcave2.ogg')
#define SCAPE_PL_LV759_CAVES list('sound/soundscape/lv759/outdoors/windy_caverns_1.ogg','sound/soundscape/lv759/outdoors/windy_caverns_2.ogg','sound/soundscape/lv759/outdoors/windy_caverns_3.ogg',)
#define SCAPE_PL_LV759_PLATEAU_OUTDOORS list('sound/soundscape/lv759/outdoors/derelict_plateau_1.ogg','sound/soundscape/lv759/outdoors/derelict_plateau_2.ogg',)
