import 'AuthResultStatus.dart';

class AuthExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      case "invalid_email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "too-many-requests":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "E-mail adresinizi hatalı girdiniz.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Parolanız yanlış";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "Bu E-mail'e sahip kullanıcı bulunmuyor.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "Bu E-mail'e sahip kullanıcı devre dışı bırakıldı.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Çok fazla istek. Daha sonra tekrar deneyin.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "E-posta ve Şifre ile oturum açma etkin değil.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "E-mail zaten kayıtlı. Lütfen giriş yapın veya şifrenizi sıfırlayın.";
        break;
      default:
        errorMessage = "Tanımlanmayan bir hata oluştu.";
    }

    return errorMessage;
  }
}
