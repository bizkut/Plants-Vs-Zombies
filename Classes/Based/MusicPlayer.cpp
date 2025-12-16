/**
 *Copyright (c) 2019 LZ.All Right Reserved
 *Author : LZ
 *Date: 2020.4.20
 *Emal: 2117610943@qq.com
 */

#include "MusicPlayer.h"

#include <AudioEngine.h>

#include "Runtime.h"

using namespace cocos2d::experimental;

void MusicPlayer::playMusic(const std::string& musicName, const bool isControlVolume) {
    auto runtime = Runtime::getInstance();
    auto& resourcePath = runtime->gameData->getResourcePath();
    auto& userSetting = runtime->userData->getUserSetting();
    
    auto& musicMap = resourcePath.getMusicPath();
    auto it = musicMap.find(musicName);
    if (it == musicMap.end()) {
        cocos2d::log("MusicPlayer::playMusic: Music not found: %s", musicName.c_str());
        return;
    }

    if (isControlVolume) {
        if (userSetting.soundEffectVolume > 0) {
            AudioEngine::setVolume(
                AudioEngine::play2d(it->second),
                userSetting.soundEffectVolume);
        } else {
            cocos2d::log("soundEffectVolume negative or zero");
        }
    } else {
        AudioEngine::play2d(it->second);
    }
}

int MusicPlayer::playMusic(const std::string& musicName, const int) {
    auto& resourcePath = Runtime::getInstance()->gameData->getResourcePath();
    auto& musicMap = resourcePath.getMusicPath();
    auto it = musicMap.find(musicName);
    if (it == musicMap.end()) {
        cocos2d::log("MusicPlayer::playMusic: Music not found: %s", musicName.c_str());
        return -1;
    }
    return AudioEngine::play2d(it->second);
}

int MusicPlayer::changeBackgroundMusic(const string& musicName, bool loop) {
    auto runtime = Runtime::getInstance();
    auto& resourcePath = runtime->gameData->getResourcePath();
    auto& userSetting = runtime->userData->getUserSetting();

    // pause previous background music
    for (auto sp : userSetting.backgroundMusic) {
        AudioEngine::stop(sp);
    }
    userSetting.backgroundMusic.clear();

    auto& musicMap = resourcePath.getMusicPath();
    auto it = musicMap.find(musicName);
    if (it == musicMap.end()) {
        cocos2d::log("MusicPlayer::changeBackgroundMusic: Music not found: %s", musicName.c_str());
        return -1;
    }

    // play new background music
    int AudioID = AudioEngine::play2d(it->second, loop);
    AudioEngine::setVolume(AudioID, userSetting.backgroundMusicVolume);

    userSetting.backgroundMusic.push_back(AudioID);

    return AudioID;
}

void MusicPlayer::setMusicVolume(const int audioId) {
    auto& userSetting = Runtime::getInstance()->userData->getUserSetting();
    // sound effect is other music volume base
    AudioEngine::setVolume(audioId, userSetting.soundEffectVolume);
}

void MusicPlayer::stopMusic() { AudioEngine::pauseAll(); }

void MusicPlayer::resumeMusic() { AudioEngine::resumeAll(); }
