import 'dart:io';

class ArrayDeposit {
  double deposit;
  double interestRate;
  ArrayDeposit(this.deposit, this.interestRate);
}

class depositType {
  static double get min => 0.03;
  static double get avr => 0.04;
  static double get max => 0.07;
}

class Account {
  String _ownerName;
  String _accountNumber;
  List<ArrayDeposit> _deposits = [];
  double _balance = 0;
  bool _isPassed = true;

  Account(this._ownerName, this._accountNumber) {
    if (_ownerName.isEmpty || !RegExp(r'^[a-zA-Z]+$').hasMatch(_ownerName)) {
      _isPassed = false;
      print("Invalid owner name: $_ownerName");
    }
    if (_accountNumber.length != 8 ||
        !RegExp(r'^\d+$').hasMatch(_accountNumber)) {
      _isPassed = false;
      print("Invalid account number: $_accountNumber");
    }
  }

  bool getIsPassed() {
    return this._isPassed;
  }

  void openDeposit(ArrayDeposit amount) {
    if (amount.deposit <= 0) {
      print("Invalid deposit amount: ${amount.deposit}");
    }
    if (amount.interestRate <= 0) {
      print("Invalid interest rate: ${amount.interestRate}");
    }
    _deposits.add(amount);
  }

  void accrueInterest() {
    for (var i = 0; i < _deposits.length; i++) {
      var tmp = _deposits[i].deposit * _deposits[i].interestRate;
      _deposits[i].deposit += tmp;
    }
  }

  void replenish(double amount) {
    if (amount <= 0) {
      print("Invalid deposit amount: $amount");
    }
    _balance += amount;
  }

  void withdrawal(double amount) {
    if (amount <= 0) {
      print("Invalid withdrawal amount: $amount");
    }
    if (_balance < amount) {
      print("Insufficient account balance: $_balance");
    }
    _balance -= amount;
  }

  void terminateDeposit() {
    for (var deposit in _deposits) {
      replenish(deposit.deposit);
    }
    _deposits.clear();
  }

  double getTotalFunds() {
    var total = _balance;
    for (var deposit in _deposits) {
      total += deposit.deposit;
    }
    return total;
  }

  @override
  String toString() {
    var depositString = '';
    for (var deposit in _deposits) {
      depositString += '${deposit.deposit.toStringAsFixed(2)}, ';
    }
    if (depositString.isNotEmpty) {
      depositString = depositString.substring(0, depositString.length - 2);
    }
    return 'Account(ownerName: $_ownerName, accountNumber: $_accountNumber, deposits: [$depositString], balance: ${_balance.toStringAsFixed(2)})';
  }
}

void main() {
  while (true) {
    String name;
    String accountNumber;

    print("1. Enter a name");
    name = stdin.readLineSync()!;
    print("2. Account number");
    accountNumber = stdin.readLineSync()!;
    var account = Account(name, accountNumber);

    while (account.getIsPassed()) {
      print(
          "Welcome to your account. Enter command number:\n1) Account replenishment\n2) Account withdrawal");
      print(
          "3) Opening a deposit\n4) Removing the deposit\n5) General account information.\n6) Interest accrual for the year");
      int state = int.tryParse(stdin.readLineSync()!) ?? 9;
      switch (state) {
        case 1:
          print("How much do you want to replenishment:");
          double countMoney = double.tryParse(stdin.readLineSync()!) ?? 0;
          account.replenish(countMoney);
          print(account);
          account.getTotalFunds();
          break;
        case 2:
          print(" How much do you want to withdraw:");
          double countMoney = double.tryParse(stdin.readLineSync()!) ?? 0;
          account.withdrawal(countMoney);
          print(account);
          account.getTotalFunds();
          break;
        case 3:
          print("Enter the deposite amount:");
          double money = double.tryParse(stdin.readLineSync()!) ?? 0;
          print("Choose type of deposite:\n1) Min\n2) Avr\n3) Max");
          int state = int.tryParse(stdin.readLineSync()!) ?? 9;
          switch (state) {
            case 1:
              var startDeposite = ArrayDeposit(money, depositType.min);
              account.openDeposit(startDeposite);
              break;
            case 2:
              var startDeposite = ArrayDeposit(money, depositType.avr);
              account.openDeposit(startDeposite);
              break;
            case 3:
              var startDeposite = ArrayDeposit(money, depositType.avr);
              account.openDeposit(startDeposite);
              break;
            default:
              print("You entered an invalid value, please try again");
              break;
          }
          print(account);
          break;
        case 4:
          account.terminateDeposit();
          print("The deposit has been removed");
          print(account);
          break;
        case 5:
          print(account.toString());
          break;
        case 6:
          account.accrueInterest();
          print(account);
          break;
        default:
          print("This command does not exist, please try again.");
          break;
      }
    }
  }
}
