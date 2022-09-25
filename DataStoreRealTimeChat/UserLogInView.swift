//
//  ContentView.swift
//  DataStoreRealTimeChat
//
//  Created by Manthena, Manaswi on 9/24/22.
//

import SwiftUI
import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSAuthCore

struct UserLogInView: View {
    @State var isSignInMode = false
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 16){
                    Picker(selection: $isSignInMode, label: Text("Picker here")) {
                        Text("Sign In")
                            .tag(true)
                        Text("Sign Up")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isSignInMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 72))
                                .padding()
                                .foregroundColor(Color.orange)
                        }
                    }
                    Group{
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        SecureField("Password", text: $password)
                    }
                    .background(Color.white)
                    .padding(12)
                    Button {
                        handleAmplifyAuthAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isSignInMode ? "Sign In" : "Sign Up")
                                .foregroundColor(.white)
                                .padding(10)
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }.background(.orange)
                    }
                }.padding()
                
            }
            .navigationTitle(isSignInMode ? "Sign In" : "Sign Up")
        }
        .background(Color(.init(white: 0, alpha: 0.05)))
        .ignoresSafeArea()
    }
    
    private func handleAmplifyAuthAction() {
            if isSignInMode {
                signInUser()
            } else {
                signUpUser()
            }
    }
    @State var loginStatusMessage = ""
    private func signInUser() {
        Amplify.Auth.signIn(username: email, password: password) { result in
            switch result {
            case .success(let signInresult):
                print("Sign in succeeded")
                self.loginStatusMessage = "successfully signed In as \(email)"
                
            case .failure(let error):
                print("Sign in failed \(error)")
                self.loginStatusMessage = "failed to sign In as \(email)"
            }
        }
    }
    
    private func signUpUser() {
        //        func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: email, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
            }
        }
    }
    //add later after datastore
//    func confirmSignUp() {
//        Amplify.Auth.confirmSignUp(for: email, confirmationCode: confirmationCode) { result in
//            switch result {
//            case .success:
//                print("Confirm signUp succeeded")
//            case .failure(let error):
//                print("An error occurred while confirming sign up \(error)")
//            }
//        }
//    }
    
    //        do {
    //            _ = try await Amplify.Auth.signUp(username: email, password: password)
    //        } catch let error as AuthError {
    //            print("error signing Up the user \(error)")
    //        } catch {
    //            print("Unexpected error \(error)")
    //        }
}
//session.isSigned In not available?
//    private func fetchCurrentAuthSession() async {
//        do {
//            let session = try await Amplify.Auth.fetchAuthSession()
//            print("Is user signed in - \(session.)")
//        } catch {
//            print("Fetch session failed with error \(error)")
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserLogInView()
    }
}
