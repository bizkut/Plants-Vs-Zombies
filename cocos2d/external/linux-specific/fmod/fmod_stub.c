// FMOD Stub Library for ARM64 - C API Implementation
// Provides empty stubs for all FMOD C API functions used by Cocos2d-x
// Audio will be disabled but game will run

#include <stddef.h>

// FMOD type definitions (from fmod_common.h)
typedef int FMOD_RESULT;
typedef unsigned int FMOD_MODE;
typedef unsigned int FMOD_TIMEUNIT;
typedef unsigned int FMOD_INITFLAGS;
typedef unsigned int FMOD_OUTPUTTYPE;
typedef int FMOD_BOOL;

typedef void FMOD_SYSTEM;
typedef void FMOD_SOUND;
typedef void FMOD_CHANNEL;
typedef void FMOD_CHANNELGROUP;
typedef void* FMOD_CREATESOUNDEXINFO;
typedef void* FMOD_CHANNELCONTROL_CALLBACK;

#define FMOD_OK 0

#ifdef __cplusplus
extern "C" {
#endif

// System API
FMOD_RESULT FMOD_System_Create(FMOD_SYSTEM **system, unsigned int version) { if(system) *system = (FMOD_SYSTEM*)1; return FMOD_OK; }
FMOD_RESULT FMOD_System_Release(FMOD_SYSTEM *system) { return FMOD_OK; }
FMOD_RESULT FMOD_System_SetOutput(FMOD_SYSTEM *system, FMOD_OUTPUTTYPE output) { return FMOD_OK; }
FMOD_RESULT FMOD_System_Init(FMOD_SYSTEM *system, int maxchannels, FMOD_INITFLAGS flags, void *extradriverdata) { return FMOD_OK; }
FMOD_RESULT FMOD_System_Close(FMOD_SYSTEM *system) { return FMOD_OK; }
FMOD_RESULT FMOD_System_Update(FMOD_SYSTEM *system) { return FMOD_OK; }
FMOD_RESULT FMOD_System_CreateSound(FMOD_SYSTEM *system, const char *name_or_data, FMOD_MODE mode, FMOD_CREATESOUNDEXINFO exinfo, FMOD_SOUND **sound) { if(sound) *sound = 0; return FMOD_OK; }
FMOD_RESULT FMOD_System_CreateStream(FMOD_SYSTEM *system, const char *name_or_data, FMOD_MODE mode, FMOD_CREATESOUNDEXINFO exinfo, FMOD_SOUND **sound) { if(sound) *sound = 0; return FMOD_OK; }
FMOD_RESULT FMOD_System_PlaySound(FMOD_SYSTEM *system, FMOD_SOUND *sound, FMOD_CHANNELGROUP *channelgroup, FMOD_BOOL paused, FMOD_CHANNEL **channel) { if(channel) *channel = 0; return FMOD_OK; }

// Sound API
FMOD_RESULT FMOD_Sound_Release(FMOD_SOUND *sound) { return FMOD_OK; }
FMOD_RESULT FMOD_Sound_GetLength(FMOD_SOUND *sound, unsigned int *length, FMOD_TIMEUNIT lengthtype) { if(length) *length = 0; return FMOD_OK; }
FMOD_RESULT FMOD_Sound_SetUserData(FMOD_SOUND *sound, void *userdata) { return FMOD_OK; }
FMOD_RESULT FMOD_Sound_GetUserData(FMOD_SOUND *sound, void **userdata) { if(userdata) *userdata = 0; return FMOD_OK; }

// Channel API
FMOD_RESULT FMOD_Channel_Stop(FMOD_CHANNEL *channel) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetPaused(FMOD_CHANNEL *channel, FMOD_BOOL paused) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_GetPaused(FMOD_CHANNEL *channel, FMOD_BOOL *paused) { if(paused) *paused = 0; return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetVolume(FMOD_CHANNEL *channel, float volume) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_GetVolume(FMOD_CHANNEL *channel, float *volume) { if(volume) *volume = 1.0f; return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetMode(FMOD_CHANNEL *channel, FMOD_MODE mode) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_GetMode(FMOD_CHANNEL *channel, FMOD_MODE *mode) { if(mode) *mode = 0; return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetCallback(FMOD_CHANNEL *channel, FMOD_CHANNELCONTROL_CALLBACK callback) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_IsPlaying(FMOD_CHANNEL *channel, FMOD_BOOL *isplaying) { if(isplaying) *isplaying = 0; return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetUserData(FMOD_CHANNEL *channel, void *userdata) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_GetUserData(FMOD_CHANNEL *channel, void **userdata) { if(userdata) *userdata = 0; return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetPosition(FMOD_CHANNEL *channel, unsigned int position, FMOD_TIMEUNIT postype) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_GetPosition(FMOD_CHANNEL *channel, unsigned int *position, FMOD_TIMEUNIT postype) { if(position) *position = 0; return FMOD_OK; }
FMOD_RESULT FMOD_Channel_SetLoopCount(FMOD_CHANNEL *channel, int loopcount) { return FMOD_OK; }
FMOD_RESULT FMOD_Channel_GetLoopCount(FMOD_CHANNEL *channel, int *loopcount) { if(loopcount) *loopcount = 0; return FMOD_OK; }

// ChannelGroup API (same as Channel in many cases)
FMOD_RESULT FMOD_ChannelGroup_Stop(FMOD_CHANNELGROUP *channelgroup) { return FMOD_OK; }
FMOD_RESULT FMOD_ChannelGroup_SetPaused(FMOD_CHANNELGROUP *channelgroup, FMOD_BOOL paused) { return FMOD_OK; }
FMOD_RESULT FMOD_ChannelGroup_SetVolume(FMOD_CHANNELGROUP *channelgroup, float volume) { return FMOD_OK; }
FMOD_RESULT FMOD_ChannelGroup_SetMode(FMOD_CHANNELGROUP *channelgroup, FMOD_MODE mode) { return FMOD_OK; }
FMOD_RESULT FMOD_ChannelGroup_SetCallback(FMOD_CHANNELGROUP *channelgroup, FMOD_CHANNELCONTROL_CALLBACK callback) { return FMOD_OK; }
FMOD_RESULT FMOD_ChannelGroup_SetUserData(FMOD_CHANNELGROUP *channelgroup, void *userdata) { return FMOD_OK; }
FMOD_RESULT FMOD_ChannelGroup_GetUserData(FMOD_CHANNELGROUP *channelgroup, void **userdata) { if(userdata) *userdata = 0; return FMOD_OK; }

#ifdef __cplusplus
}
#endif
