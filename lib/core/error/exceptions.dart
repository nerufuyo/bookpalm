abstract class Exception {
  final String message;
  
  const Exception(this.message);
  
  @override
  String toString() => message;
}

class ServerException extends Exception {
  const ServerException(super.message);
}

class NetworkException extends Exception {
  const NetworkException(super.message);
}

class CacheException extends Exception {
  const CacheException(super.message);
}

class GeneralException extends Exception {
  const GeneralException(super.message);
}
