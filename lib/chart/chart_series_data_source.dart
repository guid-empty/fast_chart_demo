class ChartSeriesDataSource<T> implements Iterable<T> {
  final List<T> _initial;

  ChartSeriesDataSource(this._initial);

  @override
  get first => _initial.first;

  @override
  bool get isEmpty => _initial.isEmpty;

  @override
  bool get isNotEmpty => _initial.isNotEmpty;

  @override
  Iterator<T> get iterator => _initial.iterator;

  @override
  get last => _initial.last;

  @override
  int get length => _initial.length;

  @override
  get single => _initial.single;

  T operator [](int index) => _initial[index];

  void operator []=(int index, T value) => _initial[index] = value;

  @override
  bool any(bool Function(T) test) {
    return _initial.any(test);
  }

  @override
  Iterable<R> cast<R>() {
    return _initial.cast<R>();
  }

  @override
  bool contains(Object? element) {
    return _initial.contains(element);
  }

  @override
  elementAt(int index) {
    return _initial.elementAt(index);
  }

  @override
  bool every(bool Function(T) test) {
    return _initial.every(test);
  }

  @override
  Iterable<E> expand<E>(Iterable<E> Function(T) f) {
    return _initial.expand(f);
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _initial.firstWhere(test, orElse: orElse);
  }

  @override
  E fold<E>(E initialValue, E combine(E previousValue, T element)) {
    return _initial.fold<E>(initialValue,
        (E previousValue, T element) => combine(previousValue, element));
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return _initial.followedBy(other);
  }

  @override
  void forEach(void Function(T element) f) {
    return _initial.forEach(f);
  }

  @override
  String join([String separator = ""]) {
    return _initial.join(separator);
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _initial.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> map<E>(E Function(T e) f) {
    return _initial.map(f);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return _initial.reduce(combine);
  }

  @override
  T singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return _initial.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return _initial.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return _initial.skipWhile(test);
  }

  @override
  Iterable<T> take(int count) {
    return _initial.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    return _initial.takeWhile(test);
  }

  @override
  List<T> toList({bool growable = true}) {
    return _initial.toList();
  }

  @override
  Set<T> toSet() {
    return _initial.toSet();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return _initial.where(test);
  }

  @override
  Iterable<E> whereType<E>() {
    return _initial.whereType<E>();
  }
}
