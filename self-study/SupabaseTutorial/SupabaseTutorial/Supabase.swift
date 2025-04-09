//
//  Supabase.swift
//  SupabaseTutorial
//
//  Created by 임영택 on 4/9/25.
//

import Foundation
import Supabase
import os.log

private let url: String = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as! String
private let key: String = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as! String
private let logger = Logger.init(subsystem: "", category: "SupabaseHelper")

let supabase = SupabaseClient(
    supabaseURL: URL(string: url)!,
    supabaseKey: key
)
