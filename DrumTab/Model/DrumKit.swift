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
        "drumBass.wav",
        "drumTom2.wav",
        "drumRide.wav"
    ]

    static var hiHat: [String] = []
    static var snare: [String] = []
    static var tom1: [String] = []
    static var tom2: [String] = []
    static var tomF: [String] = []
    static var bass: [String] = []
    static var crash: [String] = []
    static var ride: [String] = []

    static var index = 0
    static func initSounds() {
        DrumKit.hiHat = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.snare = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.tom1 = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.tom2 = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.tomF = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.bass = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.crash = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        DrumKit.ride = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
    }

    @objc func playDrumSound() {
        if DrumKit.hiHat[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[0]
            )
        }

        if DrumKit.bass[DrumKit.index] == "0" {

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
        if DrumKit.tom2[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[6]
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
        if DrumKit.ride[DrumKit.index] == "0" {

        } else {
            SystemSoundID.playSound(
                withFilename: DrumKit.drumKitAudioFileNames[7]
            )
        }
        DrumKit.index += 1
        if DrumKit.index == DrumKit.hiHat.count {
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
