//
//  PromptModels.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/23/23.
//

import Foundation


enum ResponseLength: String, CaseIterable {
    case VeryShort = "very short"
    case Short = "short"
    case Medium = "medium"
    case Similar = "similar"
    case Long = "long"
}

enum ResponseTone: String, CaseIterable {
    case Direct = "direct"
    case Friendly = "friendly"
    case Serious = "serious"
    case Excited = "excited"
    case Sad = "sad"
    case Cheerful = "cheerful"
    case Rude = "rude"
    case Humorous = "humorous"
}

enum ResponseStyle: String, CaseIterable  {
    case Professional = "professional"
    case Formal = "formal"
    case Relaxed = "relaxed"
    case InFormal = "informal"
    case Familiar = "familiar"
    case OldEnglish = "old english"
    case Childish = "childish"
    case YoungCali = "young californian"
    case SouthernBelle = "southern belle"
    case Ebonics = "ebonics"
}
