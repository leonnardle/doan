class Customer {
  String _address;
  String _name;
  String _password;
  String _phoneNumber;
  DateTime _birthday;

  Customer.name(
      this._address, this._name, this._password, this._phoneNumber, this._birthday);

  DateTime get birthday => _birthday;

  set birthday(DateTime value) {
    _birthday = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get password => _password;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          _phoneNumber == other._phoneNumber;

  @override
  int get hashCode => _phoneNumber.hashCode;

  set password(String value) {
    _password = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

}
