//
//  AuthViewModel.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI
import Supabase
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated = false
    @Published var userRole: String? = nil
    @Published var authError: String? = nil
    @Published var isNewUser = false
    @Published var currentUser: User?  // ← ADD THIS LINE
    
    // MARK: - Session Restore
    func getInitialSession() async {
        do {
            let current = try await supabase.auth.session
            self.session = current
            self.currentUser = current.user  // ← ADD THIS LINE
            self.isAuthenticated = true
            await fetchRole(userId: current.user.id)
        } catch {
            self.isAuthenticated = false
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, role: String) async {
        authError = nil
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            
            // Use result.user directly — session may be nil if email confirmation is on
            let userId = result.user.id
            self.currentUser = result.user  // ← ADD THIS LINE

            struct UserInsert: Encodable {
                let id: UUID
                let email: String
                let password: String
                let role: String
            }

            try await supabase
                .from("users")
                .insert(UserInsert(id: userId, email: email, password: password, role: role))
                .execute()

            self.userRole = role
            self.session = result.session   // may be nil until confirmed
            self.isNewUser = true
            self.isAuthenticated = true

        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        authError = nil
        do {
            let result = try await supabase.auth.signIn(email: email, password: password)
            self.session = result
            self.currentUser = result.user  // ← ADD THIS LINE
            self.isNewUser = false
            self.isAuthenticated = true
            await fetchRole(userId: result.user.id)
        } catch {
            authError = error.localizedDescription
        }
    }

    // MARK: - Fetch Role from custom users table
    func fetchRole(userId: UUID) async {
        do {
            struct UserRow: Decodable {
                let role: String
            }
            let rows: [UserRow] = try await supabase
                .from("users")
                .select("role")
                .eq("id", value: userId.uuidString)
                .limit(1)
                .execute()
                .value
            self.userRole = rows.first?.role
        } catch {
            print("Failed to fetch role: \(error.localizedDescription)")
        }
    }

    // MARK: - Sign Out
    func signOut() async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.currentUser = nil  // ← ADD THIS LINE
            self.isAuthenticated = false
            self.userRole = nil
        } catch {
            print("Sign-out failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Complete Onboarding
    func completeOnboarding() {
        self.isNewUser = false
    }
}
