enum UIError{
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials
}

extension UIErrorExtension on UIError{
  String get description {
    switch(this){
      case UIError.requiredField: return "Campo obrigatório.";
      case UIError.invalidField: return "Campo inválido.";
      case UIError.invalidCredentials: return "Credenciais inválidas.";
      default: return "Resposta inesperada. Tente novamente em breve.";
    }
  }
}