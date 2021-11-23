class SearchBlocState {
  SearchBlocState({
    this.foundUsers = const [],
  }) : super();

  late List<dynamic> items = [];
  final List<dynamic> foundUsers;
}