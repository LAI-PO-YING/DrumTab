//
//  SectionView.swift
//  DrumTab
//
//  Created by 賴柏穎 on 2021/10/21.
//

import UIKit

class SectionView: UIView {

    @IBOutlet weak var tab3LineView: UIView!
    //MARK: note1Outlet
    @IBOutlet weak var note1LineView: UIView!
    @IBOutlet weak var note1LineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabCrashLine1View: UIView!
    @IBOutlet weak var note1CRImageView: UIImageView!
    @IBOutlet weak var note1HHImageView: UIImageView!
    @IBOutlet weak var note1RIImageView: UIImageView!
    @IBOutlet weak var note1T1ImageView: UIImageView!
    @IBOutlet weak var note1T2ImageView: UIImageView!
    @IBOutlet weak var note1SNImageView: UIImageView!
    @IBOutlet weak var note1TFImageView: UIImageView!
    @IBOutlet weak var note1BAImageView: UIImageView!
    //MARK: note2Outlet
    @IBOutlet weak var note2LineView: UIView!
    @IBOutlet weak var note2LineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabCrashLine2View: UIView!
    @IBOutlet weak var note2CRImageView: UIImageView!
    @IBOutlet weak var note2HHImageView: UIImageView!
    @IBOutlet weak var note2RIImageView: UIImageView!
    @IBOutlet weak var note2T1ImageView: UIImageView!
    @IBOutlet weak var note2T2ImageView: UIImageView!
    @IBOutlet weak var note2SNImageView: UIImageView!
    @IBOutlet weak var note2TFImageView: UIImageView!
    @IBOutlet weak var note2BAImageView: UIImageView!
    // MARK: note3Outlet
    @IBOutlet weak var note3LineView: UIView!
    @IBOutlet weak var note3LineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabCrashLine3View: UIView!
    @IBOutlet weak var note3CRImageView: UIImageView!
    @IBOutlet weak var note3HHImageView: UIImageView!
    @IBOutlet weak var note3RIImageView: UIImageView!
    @IBOutlet weak var note3T1ImageView: UIImageView!
    @IBOutlet weak var note3T2ImageView: UIImageView!
    @IBOutlet weak var note3SNImageView: UIImageView!
    @IBOutlet weak var note3TFImageView: UIImageView!
    @IBOutlet weak var note3BAImageView: UIImageView!
    //MARK: note4Outlet
    @IBOutlet weak var note4LineView: UIView!
    @IBOutlet weak var note4LineConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabCrashLine4View: UIView!
    @IBOutlet weak var note4CRImageView: UIImageView!
    @IBOutlet weak var note4HHImageView: UIImageView!
    @IBOutlet weak var note4RIImageView: UIImageView!
    @IBOutlet weak var note4T1ImageView: UIImageView!
    @IBOutlet weak var note4T2ImageView: UIImageView!
    @IBOutlet weak var note4SNImageView: UIImageView!
    @IBOutlet weak var note4TFImageView: UIImageView!
    @IBOutlet weak var note4BAImageView: UIImageView!

    @IBOutlet weak var eighthNoteViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var eighthNoteViewTrailingContraint: NSLayoutConstraint!
    @IBOutlet weak var eighthNoteView: UIView!
    @IBOutlet weak var rightSixteenthNoteViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightSixteenthNoteView: UIView!
    @IBOutlet weak var leftSixteenthNoteViewWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var leftSixteenthNoteView: UIView!

    let nibName = "SectionView"

    var hiHat: [String]
    var snare: [String]
    var tom1: [String]
    var tom2: [String]
    var tomF: [String]
    var bass: [String]
    var crash: [String]
    var ride: [String]

    init(frame: CGRect,
         hiHat: [String],
         snare: [String],
         tom1: [String],
         tom2: [String],
         tomF: [String],
         bass: [String],
         crash: [String],
         ride: [String]
    ) {
        self.hiHat = hiHat
        self.snare = snare
        self.tom1 = tom1
        self.tom2 = tom2
        self.tomF = tomF
        self.bass = bass
        self.crash = crash
        self.ride = ride
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        note1Setup()
        note2Setup()
        note3Setup()
        note4Setup()
        eighthNoteViewSetup()
        sixteenthNoteViewSetup()
//        view.backgroundColor = UIColor(red: 200/255, green: 202/255, blue: 216/255, alpha: 1)
        self.addSubview(view)
        
    }

    func eighthNoteViewSetup() {
        if hiHat[0] == "1" || snare[0] == "1" || tom1[0] == "1" || tom2[0] == "1" || tomF[0] == "1" || bass[0] == "1" || crash[0] == "1" || ride[0] == "1",
            hiHat[3] == "1" || snare[3] == "1" || tom1[3] == "1" || tom2[3] == "1" || tomF[3] == "1" || bass[3] == "1" || crash[3] == "1" || ride[3] == "1" {
            eighthNoteViewTrailingContraint.isActive = false
            eighthNoteView.trailingAnchor.constraint(equalTo: note4LineView.trailingAnchor).isActive = true
        } else if hiHat[0] == "1" || snare[0] == "1" || tom1[0] == "1" || tom2[0] == "1" || tomF[0] == "1" || bass[0] == "1" || crash[0] == "1" || ride[0] == "1",
                  hiHat[2] == "1" || snare[2] == "1" || tom1[2] == "1" || tom2[2] == "1" || tomF[2] == "1" || bass[2] == "1" || crash[2] == "1" || ride[2] == "1" {
            eighthNoteViewTrailingContraint.isActive = false
            eighthNoteView.trailingAnchor.constraint(equalTo: note3LineView.trailingAnchor).isActive = true
        } else {
            eighthNoteView.isHidden = true
        }
    }

    func sixteenthNoteViewSetup() {
        if hiHat[0] == "1" || snare[0] == "1" || tom1[0] == "1" || tom2[0] == "1" || tomF[0] == "1" || bass[0] == "1" || crash[0] == "1" || ride[0] == "1",
           hiHat[1] == "1" || snare[1] == "1" || tom1[1] == "1" || tom2[1] == "1" || tomF[1] == "1" || bass[1] == "1" || crash[1] == "1" || ride[1] == "1",
           hiHat[2] == "1" || snare[2] == "1" || tom1[2] == "1" || tom2[2] == "1" || tomF[2] == "1" || bass[2] == "1" || crash[2] == "1" || ride[2] == "1",
           hiHat[3] == "1" || snare[3] == "1" || tom1[3] == "1" || tom2[3] == "1" || tomF[3] == "1" || bass[3] == "1" || crash[3] == "1" || ride[3] == "1" {
            leftSixteenthNoteViewWidthContraint.isActive = false
            rightSixteenthNoteViewWidthConstraint.isActive = false
            leftSixteenthNoteView.widthAnchor.constraint(equalTo: tab3LineView.widthAnchor, multiplier: 0.375).isActive = true
            rightSixteenthNoteView.widthAnchor.constraint(equalTo: tab3LineView.widthAnchor, multiplier: 0.375).isActive = true
        } else if hiHat[0] == "1" || snare[0] == "1" || tom1[0] == "1" || tom2[0] == "1" || tomF[0] == "1" || bass[0] == "1" || crash[0] == "1" || ride[0] == "1",
                  hiHat[1] == "1" || snare[1] == "1" || tom1[1] == "1" || tom2[1] == "1" || tomF[1] == "1" || bass[1] == "1" || crash[1] == "1" || ride[1] == "1",
                  hiHat[3] == "1" || snare[3] == "1" || tom1[3] == "1" || tom2[3] == "1" || tomF[3] == "1" || bass[3] == "1" || crash[3] == "1" || ride[3] == "1" {
            // default
        } else if hiHat[0] == "1" || snare[0] == "1" || tom1[0] == "1" || tom2[0] == "1" || tomF[0] == "1" || bass[0] == "1" || crash[0] == "1" || ride[0] == "1",
                  hiHat[2] == "1" || snare[2] == "1" || tom1[2] == "1" || tom2[2] == "1" || tomF[2] == "1" || bass[2] == "1" || crash[2] == "1" || ride[2] == "1",
                  hiHat[3] == "1" || snare[3] == "1" || tom1[3] == "1" || tom2[3] == "1" || tomF[3] == "1" || bass[3] == "1" || crash[3] == "1" || ride[3] == "1" {
            rightSixteenthNoteViewWidthConstraint.isActive = false
            rightSixteenthNoteView.widthAnchor.constraint(equalTo: tab3LineView.widthAnchor, multiplier: 0.25).isActive = true
            leftSixteenthNoteView.isHidden = true
        } else {
            leftSixteenthNoteView.isHidden = true
            rightSixteenthNoteView.isHidden = true
        }
    }

    func note1Setup() {
        // MARK: -----Note1-----
        // note1LineConstraint
        if bass[0] == "1" {
            note1LineConstraint.constant = 50
        } else if tomF[0] == "1" {
            note1LineConstraint.constant = 39
        } else if snare[0] == "1" {
            note1LineConstraint.constant = 28
        } else if tom2[0] == "1" {
            note1LineConstraint.constant = 22.5
        } else if tom1[0] == "1" {
            note1LineConstraint.constant = 17
        } else if ride[0] == "1" {
            note1LineConstraint.constant = 8
        } else if hiHat[0] == "1" {
            note1LineConstraint.constant = 2.5
        } else if crash[0] == "1" {
            note1LineConstraint.constant = -3
        } else {
            note1LineView.isHidden = true
        }
        // not1 crash
        if crash[0] == "1" {
            note1CRImageView.isHidden = false
            tabCrashLine1View.isHidden = false
        } else {
            note1CRImageView.isHidden = true
            tabCrashLine1View.isHidden = true
        }
        // not1 hiHat
        if hiHat[0] == "1" {
            note1HHImageView.isHidden = false
        } else {
            note1HHImageView.isHidden = true
        }
        // not1 ride
        if ride[0] == "1" {
            note1RIImageView.isHidden = false
        } else {
            note1RIImageView.isHidden = true
        }
        // not1 tom1
        if tom1[0] == "1" {
            note1T1ImageView.isHidden = false
        } else {
            note1T1ImageView.isHidden = true
        }
        // not1 tom2
        if tom2[0] == "1" {
            note1T2ImageView.isHidden = false
        } else {
            note1T2ImageView.isHidden = true
        }
        // not1 snare
        if snare[0] == "1" {
            note1SNImageView.isHidden = false
        } else {
            note1SNImageView.isHidden = true
        }
        // not1 tomF
        if tomF[0] == "1" {
            note1TFImageView.isHidden = false
        } else {
            note1TFImageView.isHidden = true
        }
        // not1 bass
        if bass[0] == "1" {
            note1BAImageView.isHidden = false
        } else {
            note1BAImageView.isHidden = true
        }
    }
    func note2Setup() {
        // MARK: -----Note2-----
        // note2LineConstraint
        if bass[1] == "1" {
            note2LineConstraint.constant = 50
        } else if tomF[1] == "1" {
            note2LineConstraint.constant = 39
        } else if snare[1] == "1" {
            note2LineConstraint.constant = 28
        } else if tom2[1] == "1" {
            note2LineConstraint.constant = 22.5
        } else if tom1[1] == "1" {
            note2LineConstraint.constant = 17
        } else if ride[1] == "1" {
            note2LineConstraint.constant = 8
        } else if hiHat[1] == "1" {
            note2LineConstraint.constant = 2.5
        } else if crash[1] == "1" {
            note2LineConstraint.constant = -3
        } else {
            note2LineView.isHidden = true
        }
        // not2 crash
        if crash[1] == "1" {
            note2CRImageView.isHidden = false
            tabCrashLine2View.isHidden = false
        } else {
            note2CRImageView.isHidden = true
            tabCrashLine2View.isHidden = true
        }
        // not2 hiHat
        if hiHat[1] == "1" {
            note2HHImageView.isHidden = false
        } else {
            note2HHImageView.isHidden = true
        }
        // not2 ride
        if ride[1] == "1" {
            note2RIImageView.isHidden = false
        } else {
            note2RIImageView.isHidden = true
        }
        // not2 tom1
        if tom1[1] == "1" {
            note2T1ImageView.isHidden = false
        } else {
            note2T1ImageView.isHidden = true
        }
        // not2 tom2
        if tom2[1] == "1" {
            note2T2ImageView.isHidden = false
        } else {
            note2T2ImageView.isHidden = true
        }
        // not2 snare
        if snare[1] == "1" {
            note2SNImageView.isHidden = false
        } else {
            note2SNImageView.isHidden = true
        }
        // not2 tomF
        if tomF[1] == "1" {
            note2TFImageView.isHidden = false
        } else {
            note2TFImageView.isHidden = true
        }
        // not2 bass
        if bass[1] == "1" {
            note2BAImageView.isHidden = false
        } else {
            note2BAImageView.isHidden = true
        }
    }
    func note3Setup() {
        // MARK: -----Note3-----
        // note3LineConstraint
        if bass[2] == "1" {
            note3LineConstraint.constant = 50
        } else if tomF[2] == "1" {
            note3LineConstraint.constant = 39
        } else if snare[2] == "1" {
            note3LineConstraint.constant = 28
        } else if tom2[2] == "1" {
            note3LineConstraint.constant = 22.5
        } else if tom1[2] == "1" {
            note3LineConstraint.constant = 17
        } else if ride[2] == "1" {
            note3LineConstraint.constant = 8
        } else if hiHat[2] == "1" {
            note3LineConstraint.constant = 2.5
        } else if crash[2] == "1" {
            note3LineConstraint.constant = -3
        } else {
            note3LineView.isHidden = true
        }
        // not3 crash
        if crash[2] == "1" {
            note3CRImageView.isHidden = false
            tabCrashLine3View.isHidden = false
        } else {
            note3CRImageView.isHidden = true
            tabCrashLine3View.isHidden = true
        }
        // not3 hiHat
        if hiHat[2] == "1" {
            note3HHImageView.isHidden = false
        } else {
            note3HHImageView.isHidden = true
        }
        // not3 ride
        if ride[2] == "1" {
            note3RIImageView.isHidden = false
        } else {
            note3RIImageView.isHidden = true
        }
        // not3 tom1
        if tom1[2] == "1" {
            note3T1ImageView.isHidden = false
        } else {
            note3T1ImageView.isHidden = true
        }
        // not3 tom2
        if tom2[2] == "1" {
            note3T2ImageView.isHidden = false
        } else {
            note3T2ImageView.isHidden = true
        }
        // not3 snare
        if snare[2] == "1" {
            note3SNImageView.isHidden = false
        } else {
            note3SNImageView.isHidden = true
        }
        // not3 tomF
        if tomF[2] == "1" {
            note3TFImageView.isHidden = false
        } else {
            note3TFImageView.isHidden = true
        }
        // not3 bass
        if bass[2] == "1" {
            note3BAImageView.isHidden = false
        } else {
            note3BAImageView.isHidden = true
        }
    }
    func note4Setup() {
        // MARK: -----Note4-----
        // note4LineConstraint
        if bass[3] == "1" {
            note4LineConstraint.constant = 50
        } else if tomF[3] == "1" {
            note4LineConstraint.constant = 39
        } else if snare[3] == "1" {
            note4LineConstraint.constant = 28
        } else if tom2[3] == "1" {
            note4LineConstraint.constant = 22.5
        } else if tom1[3] == "1" {
            note4LineConstraint.constant = 17
        } else if ride[3] == "1" {
            note4LineConstraint.constant = 8
        } else if hiHat[3] == "1" {
            note4LineConstraint.constant = 2.5
        } else if crash[3] == "1" {
            note4LineConstraint.constant = -3
        } else {
            note4LineView.isHidden = true
        }
        // not4 crash
        if crash[3] == "1" {
            note4CRImageView.isHidden = false
            tabCrashLine4View.isHidden = false
        } else {
            note4CRImageView.isHidden = true
            tabCrashLine4View.isHidden = true
        }
        // not4 hiHat
        if hiHat[3] == "1" {
            note4HHImageView.isHidden = false
        } else {
            note4HHImageView.isHidden = true
        }
        // not4 ride
        if ride[3] == "1" {
            note4RIImageView.isHidden = false
        } else {
            note4RIImageView.isHidden = true
        }
        // not4 tom1
        if tom1[3] == "1" {
            note4T1ImageView.isHidden = false
        } else {
            note4T1ImageView.isHidden = true
        }
        // not4 tom2
        if tom2[3] == "1" {
            note4T2ImageView.isHidden = false
        } else {
            note4T2ImageView.isHidden = true
        }
        // not4 snare
        if snare[3] == "1" {
            note4SNImageView.isHidden = false
        } else {
            note4SNImageView.isHidden = true
        }
        // not4 tomF
        if tomF[3] == "1" {
            note4TFImageView.isHidden = false
        } else {
            note4TFImageView.isHidden = true
        }
        // not4 bass
        if bass[3] == "1" {
            note4BAImageView.isHidden = false
        } else {
            note4BAImageView.isHidden = true
        }
    }

    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
