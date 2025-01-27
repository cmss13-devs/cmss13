#define REAL_CLIENTS length(GLOB.clients) - length(GLOB.que_clients)

#define AMMO_IGNORE_XENO_IFF (1<<23)

///TTS preference is disbaled entirely, no sound will be played.
#define TTS_SOUND_OFF "Disabled"
///TTS preference is enabled, and will give full text-to-speech.
#define TTS_SOUND_ENABLED "Enabled"
///TTS preference is set to only play blips of a sound, rather than speech.
#define TTS_SOUND_BLIPS "Blips Only"
//we don't have such settings in our filters
//#define TTS_FILTER_XENO @{"[0:a] asplit [out0][out2]; [out0] asetrate=%SAMPLE_RATE%*0.8,aresample=%SAMPLE_RATE%,atempo=1/0.8,aformat=channel_layouts=mono [p0]; [out2] asetrate=%SAMPLE_RATE%*1.2,aresample=%SAMPLE_RATE%,atempo=1/1.2,aformat=channel_layouts=mono[p2]; [p0][0][p2] amix=inputs=3"}

#define TTS_HIVEMIND_ALL 3
#define TTS_HIVEMIND_LEADERS 2
#define TTS_HIVEMIND_QUEEN 1
#define TTS_HIVEMIND_OFF 0

#define TTS_RADIO_ALL 2
#define TTS_RADIO_BIG_VOICE_ONLY 1
#define TTS_RADIO_OFF 0

#define TTS_FLAG_HIVEMIND (1<<0)
#define TTS_FLAG_RADIO (1<<1)
