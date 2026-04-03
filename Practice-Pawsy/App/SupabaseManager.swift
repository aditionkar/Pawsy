//
//  SupabaseManager.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//


import Supabase
import Foundation

struct Config {
    static let supabaseURL: String = {
        let value = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String
        print("SUPABASE_URL =", value ?? "nil") // 👈 ADD THIS
        return value!
    }()

    static let supabaseKey: String = {
        let value = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String
        print("SUPABASE_KEY =", value ?? "nil") // 👈 ADD THIS
        return value!
    }()
}

let supabase = SupabaseClient(
    supabaseURL: URL(string: Config.supabaseURL)!,
    supabaseKey: Config.supabaseKey
)
