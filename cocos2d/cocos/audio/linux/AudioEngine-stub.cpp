/****************************************************************************
 AudioEngine Stub for ARM64 Linux builds (no FMOD available)
 
 This provides empty implementations of AudioEngine functions.
 Game will run but without sound.
 ****************************************************************************/

#include "audio/include/AudioEngine.h"

NS_CC_BEGIN
namespace experimental {

const int AudioEngine::INVALID_AUDIO_ID = -1;
const float AudioEngine::TIME_UNKNOWN = -1.0f;

std::unordered_map<int, AudioEngine::AudioInfo> AudioEngine::_audioIDInfoMap;
std::unordered_map<std::string, std::list<int>> AudioEngine::_audioPathIDMap;
std::unordered_map<std::string, AudioEngine::ProfileHelper> AudioEngine::_audioPathProfileHelperMap;
unsigned int AudioEngine::_maxInstances = 24;
AudioEngine::ProfileHelper* AudioEngine::_defaultProfileHelper = nullptr;
AudioEngineImpl* AudioEngine::_audioEngineImpl = nullptr;
AudioEngine::AudioEngineThreadPool* AudioEngine::s_threadPool = nullptr;
bool AudioEngine::_isEnabled = true;

AudioEngine::AudioInfo::AudioInfo()
    : filePath(nullptr)
    , profileHelper(nullptr)
    , volume(1.0f)
    , loop(false)
    , duration(TIME_UNKNOWN)
    , state(AudioState::INITIALIZING)
{
}

AudioEngine::AudioInfo::~AudioInfo()
{
}

bool AudioEngine::lazyInit() { return true; }
void AudioEngine::end() {}
AudioProfile* AudioEngine::getDefaultProfile() { return nullptr; }

int AudioEngine::play2d(const std::string& filePath, bool loop, float volume, const AudioProfile* profile) {
    return INVALID_AUDIO_ID;  // No audio - return invalid
}

void AudioEngine::setLoop(int audioID, bool loop) {}
bool AudioEngine::isLoop(int audioID) { return false; }
void AudioEngine::setVolume(int audioID, float volume) {}
float AudioEngine::getVolume(int audioID) { return 1.0f; }
void AudioEngine::pause(int audioID) {}
void AudioEngine::pauseAll() {}
void AudioEngine::resume(int audioID) {}
void AudioEngine::resumeAll() {}
void AudioEngine::stop(int audioID) {}
void AudioEngine::stopAll() {}
bool AudioEngine::setCurrentTime(int audioID, float sec) { return false; }
float AudioEngine::getCurrentTime(int audioID) { return 0.0f; }
float AudioEngine::getDuration(int audioID) { return 0.0f; }
AudioEngine::AudioState AudioEngine::getState(int audioID) { return AudioState::ERROR; }
void AudioEngine::setFinishCallback(int audioID, const std::function<void(int, const std::string&)>& callback) {}
bool AudioEngine::setMaxAudioInstance(int maxInstances) { _maxInstances = maxInstances; return true; }
void AudioEngine::uncache(const std::string& filePath) {}
void AudioEngine::uncacheAll() {}
AudioProfile* AudioEngine::getProfile(int audioID) { return nullptr; }
AudioProfile* AudioEngine::getProfile(const std::string& profileName) { return nullptr; }
void AudioEngine::preload(const std::string& filePath, const std::function<void(bool isSuccess)>& callback) {
    if (callback) callback(false);
}
int AudioEngine::getPlayingAudioCount() { return 0; }
void AudioEngine::setEnabled(bool isEnabled) { _isEnabled = isEnabled; }
bool AudioEngine::isEnabled() { return _isEnabled; }
void AudioEngine::addTask(const std::function<void()>& task) {}
void AudioEngine::remove(int audioID) {}

} // namespace experimental
NS_CC_END
