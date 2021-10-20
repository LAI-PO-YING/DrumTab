//
//  DrumKit.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/18.
//

import Foundation

class DrumKit {

    private static let drumKitAudioFileNames = [
        "drumCloseHiHat.wav",
        "drumSnare.wav",
        "drumTom1.wav",
        "drumFloorTom.wav",
        "drumCrash.wav",
        "drumStool.wav"
    ]

    static var hiHat = ["1", "0", "1", "0", "1", "0", "1", "0", "1", "0", "1", "0", "0", "0", "0", "0"]
    static var snare = ["0", "0", "0", "0", "1", "0", "0", "1", "0", "1", "0", "0", "1", "0", "0", "0"]
    static var tom1 = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1", "0", "0"]
    static var tomF = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1", "1"]
    static var stool = ["1", "0", "0", "1", "0", "0", "0", "0", "0", "0", "1", "1", "0", "0", "0", "0"]
    static var crash = ["1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]

    static var index = 0
    static func initSounds() {
        DrumKit.hiHat = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.snare = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.tom1 = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.tomF = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.stool = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.crash = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
    }

    @objc func playDrumSound() {
        if DrumKit.hiHat[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[0]
            )
        }

        if DrumKit.stool[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[5]
            )
        }

        if DrumKit.snare[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[1]
            )
        }
        if DrumKit.tom1[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[2]
            )
        }
        if DrumKit.tomF[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[3]
            )
        }
        if DrumKit.crash[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[4]
            )
        }
        DrumKit.index += 1
        if DrumKit.index == 16 {
            DrumKit.index = 0
        }
    }
}

import AudioToolbox

extension SystemSoundID {
    static func playSound(withFilename filename: String) {
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(
            forResource: filename, withExtension: nil
        ) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
}
