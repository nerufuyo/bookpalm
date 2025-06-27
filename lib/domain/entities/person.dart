class Person {
  final int? birthYear;
  final int? deathYear;
  final String name;

  const Person({
    this.birthYear,
    this.deathYear,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
