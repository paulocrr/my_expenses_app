enum ScreenState {
  idle,
  loading,
  error,
  completed;

  bool isLoading() => this == loading;
  bool isCompleted() => this == completed;
  bool isError() => this == error;
}
