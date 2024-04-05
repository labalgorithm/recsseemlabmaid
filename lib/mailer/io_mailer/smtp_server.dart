export '../io_mailer/smtp_server/gmail.dart';
export '../io_mailer/smtp_server/hotmail.dart';
export '../io_mailer/smtp_server/mailgun.dart';
export '../io_mailer/smtp_server/qq.dart';
export '../io_mailer/smtp_server/yahoo.dart';
export '../io_mailer/smtp_server/yandex.dart';
export '../io_mailer/smtp_server/zoho.dart';

class SmtpServer {
  final String host;
  final int port;
  final bool ignoreBadCertificate;
  final bool ssl;
  final bool allowInsecure;
  final String? username;
  final String? password;
  final String? xoauth2Token;

  SmtpServer(this.host,
      {this.port = 587,
      String? name,
      this.ignoreBadCertificate = false,
      this.ssl = false,
      this.allowInsecure = false,
      this.username,
      this.password,
      this.xoauth2Token});
}
