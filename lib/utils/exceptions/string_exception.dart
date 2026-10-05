class StringException extends Error {
  final String data;

  StringException(this.data);

  @override
  String toString() {
    return data;
  }
}
