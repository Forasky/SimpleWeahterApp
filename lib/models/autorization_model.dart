class Credits {
  Credits({
    required this.message,
    required this.isLogin,
    this.userName,
    this.eMail,
  }) : super();

  final String message;
  final bool isLogin;
  final String? userName;
  final String? eMail;
}
