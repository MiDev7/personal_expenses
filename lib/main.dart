import 'package:expenses_planner/widgets/chart.dart';

import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          tertiaryContainer: Colors.blue[700],
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
        textTheme: ThemeData.light().textTheme.copyWith(
            titleMedium: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
            titleLarge: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 24,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          tertiaryContainer: Colors.blue[700],
          onTertiaryContainer: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 24,
              color: Colors.white),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
              titleLarge: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    // Transaction(
    //   id: '#1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: '#2',
    //   title: 'Grocery',
    //   amount: 32.00,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
    String newTitle,
    double newAmount,
    DateTime choosenDate,
  ) {
    final newTransaction = Transaction(
      id: DateTime.now().second.toString(),
      title: newTitle,
      amount: newAmount,
      date: choosenDate,
    );

    setState(() {
      _userTransaction.add(newTransaction);
    });
  }

  void _newTransactionModal(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return NewTransaction(addTransaction: _addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
          onPressed: () => _newTransactionModal(context),
          icon: Icon(Icons.add),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: (MediaQuery.of(context).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.25,
                child: Chart(
                  recentTransaction: _recentTransaction,
                )),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 0.0,
              ),
              child: Divider(
                thickness: 2.0,
                color: Colors.grey[400],
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.75,
              child: TransactionList(
                transactions: _userTransaction,
                deleteTx: _deleteTransaction,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _newTransactionModal(context),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
