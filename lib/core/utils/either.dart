class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;
  
  const Either.left(L value) : _left = value, _right = null, _isLeft = true;
  const Either.right(R value) : _left = null, _right = value, _isLeft = false;
  
  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;
  
  L get left {
    if (_isLeft && _left != null) return _left as L;
    throw StateError('Called left on Right or null left value');
  }
  
  R get right {
    if (!_isLeft && _right != null) return _right as R;
    throw StateError('Called right on Left or null right value');
  }
  
  T fold<T>(T Function(L) leftFunction, T Function(R) rightFunction) {
    if (_isLeft && _left != null) {
      return leftFunction(_left as L);
    } else if (!_isLeft && _right != null) {
      return rightFunction(_right as R);
    } else {
      throw StateError('Both left and right values are null');
    }
  }
}
