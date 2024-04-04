//
//  SignUpView.swift
//  BookBillionaireUser
//
//  Created by Seungjae Yu on 3/25/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var nameText: String = ""
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var passwordConfirmText: String = ""
    @State var isShowingProgressView = false
    @State var isShowingAlert: Bool = false
    @State var isPasswordCountError: Bool = false
    @State var isPasswordUnCorrectError: Bool = false
    @State var isEmailError: Bool = false
    @State var emailErrorText: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.accentColor1
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 30) {
                    Image("logoBookBillionaire")
                    
                    VStack(alignment: .leading) {
                        Text("이름")
                            .font(.headline)
                        TextField("이름을 입력해주세요", text: $nameText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                        Text("이메일")
                            .font(.headline)
                        TextField("이메일을 입력해주세요", text: $emailText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .onChange(of: emailText, perform: { newValue in
                                isEmailError = !isValidEmail(newValue)
                            })
                            .textInputAutocapitalization(.none)
                            .autocapitalization(.none)
                            .padding(.bottom, 20)
                        Text(emailErrorText)
                            .font(.system(size: 15))
                            .foregroundColor(isEmailError ? .red : .clear)
                            .padding(.leading, 10)
                        Text("비밀번호")
                            .font(.headline)
                        SecureField("비밀번호를 6자리 이상 입력해주세요", text: $passwordText)
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(10)
                        Text("비밀번호는 6자리 이상 입력해주세요.")
                            .font(.system(size: 15))
                            .foregroundColor(isPasswordCountError ? .red : .clear)
                            .padding(.leading, 10)
                        Text("비밀번호 확인")
                        SecureField("비밀번호를 다시 입력해주세요", text: $passwordConfirmText)
                            .padding()
                            .background(.thinMaterial)
                            .border(.red, width: passwordConfirmText != passwordText ? 1 : 0)
                            .cornerRadius(10)
                        Text("비밀번호가 서로 다릅니다.")
                            .font(.system(size: 15))
                            .foregroundColor(isPasswordUnCorrectError ? .red : .clear)
                            .padding(.leading, 10)
                    }
                    
                    Button {
                        isShowingProgressView = true
                        
                        if passwordText.count < 6 {
                            isPasswordCountError = true
                        }
                        if passwordConfirmText != passwordText {
                            isPasswordUnCorrectError = true
                        }
                        if !isValidEmail(emailText) {
                            isEmailError = true
                            emailErrorText = "올바른 이메일 형식이 아닙니다."
                        }
                        if passwordText.count >= 6 && passwordConfirmText == passwordText && isValidEmail(emailText) {
                            authViewModel.emailAuthSignUp(email: emailText, userName: nameText, password: passwordText)
                            isShowingAlert = true
                        }
                    } label: {
                        Text("회원 가입")
                            .frame(width: 100, height: 50)
                            .background(!checkSignUpCondition() ? .gray : .blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .alert("회원가입", isPresented: $isShowingAlert) {
                                Button {
                                    dismiss()
                                } label: {
                                    Text("OK")
                                }
                            } message: {
                                Text("회원가입이 완료되었습니다.")
                            }
                            .padding()
                    }
                    .disabled(!checkSignUpCondition())
                    
                    if isShowingProgressView {
                        ProgressView()
                    }
                }
                .padding()
                .padding(.bottom, 15)
            }
        }
        
    }
    
    func checkSignUpCondition () -> Bool {
        if nameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || passwordConfirmText.isEmpty {
            return false
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}
