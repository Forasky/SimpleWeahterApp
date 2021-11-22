class DatabaseBlocState {
  final String message;
  final List<String> listCity;

  DatabaseBlocState({
    required this.message,
    this.listCity = const [],
  });
}
