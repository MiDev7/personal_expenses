import 'package:expenses_planner/widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ],
  );
  runApp(const MyApp());
}

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
        appBarTheme: const AppBarTheme(
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
              titleLarge: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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

  bool _showChart = false;

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
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

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget transactionList,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show chart'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (value) {
              setState(
                () {
                  _showChart = value;
                },
              );
            },
          )
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.75,
              margin: const EdgeInsets.symmetric(
                horizontal: 50.0,
                vertical: 0.0,
              ),
              child: Chart(
                recentTransaction: _recentTransaction,
              ))
          : transactionList
    ];
  }

  List<Widget> _builtPortaitContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget transactionList,
  ) {
    return [
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
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
      transactionList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
          onPressed: () => _newTransactionModal(context),
          icon: const Icon(Icons.add),
        )
      ],
    );

    final transactionList = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.75,
      child: TransactionList(
        transactions: _userTransaction,
        deleteTx: _deleteTransaction,
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (isLandscape)
                  ..._buildLandscapeContent(
                      mediaQuery, appBar, transactionList),
                if (!isLandscape)
                  ..._builtPortaitContent(mediaQuery, appBar, transactionList),
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _newTransactionModal(context),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
