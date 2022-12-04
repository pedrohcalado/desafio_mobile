//
//  Validations.swift
//  ByCodersApp
//
//  Created by Pedro Henrique Calado on 04/12/22.
//

func validateFields(email: String?, password: String?) -> String? {
    let emailCleaned = email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    let passwordCleaned = password?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    
    if emailCleaned == "" {
        return "O e-mail é obrigatório."
    }
    
    if passwordCleaned == "" {
        return "A senha é obrigatória."
    }
    
    if !emailCleaned.isValidEmail() {
        return "Preencha com um e-mail válido."
    }
    if !passwordCleaned.isValidPassword() {
        return "A senha deve conter pelo menos 8 caracteres, um número e um caracter especial."
    }
    
    return nil
}
