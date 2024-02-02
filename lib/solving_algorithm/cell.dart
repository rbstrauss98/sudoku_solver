class Cell{
  List<int> domain = List<int>.generate(9, (index) => index + 1);
  int? value;

  void assignValue(int value) {
    domain = [value];
    this.value = value;
  }
  
  void setDomain(List<int> domain) {
    this.domain = List<int>.from(domain);
    value = null;
  }

  bool removeValue(int value) {
    domain.remove(value);
    return domain.isNotEmpty;
  }

  void copyCell(Cell other) {
    domain = List<int>.from(other.domain);
    value = other.value;
  }
}
