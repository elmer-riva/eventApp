abstract class Resource<T> {
  final T? data;
  final String? message;
  const Resource({this.data, this.message});
}

class Success<T> extends Resource<T> {
  const Success(T data) : super(data: data);
}

class Failure<T> extends Resource<T> {
  const Failure(String message) : super(message: message);
}