//
//  SupabaseManager.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//


import Supabase
import Foundation

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://ysyzyalaurvzfgcfgcai.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlzeXp5YWxhdXJ2emZnY2ZnY2FpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUyMTUzNzAsImV4cCI6MjA5MDc5MTM3MH0.DnTPiOEw2lT9C60z_GWGPxlT5WMq2Enu5f5Kmo4lQjk"
)

