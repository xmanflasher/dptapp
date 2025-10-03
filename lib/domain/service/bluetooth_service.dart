abstract class DataSource {
  double getData();
}

class BluetoothService implements DataSource {
  @override
  double getData() {
    return (5 + (10 * (DateTime.now().second % 10) / 10));
  }
}

class MockService implements DataSource {
  double _value = 5;
  @override
  double getData() {
    _value += 0.5;
    return _value % 15;
  }
}