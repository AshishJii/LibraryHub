import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_screen.dart';
import 'books_screen.dart';
import 'members_screen.dart';
import 'about_screen.dart';
import 'chatbot_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load environment variables from .env (root of project)
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E35B1), // Deep Purple
          primary: const Color(0xFF5E35B1),
          secondary: const Color(0xFF26A69A), // Teal
          tertiary: const Color(0xFF7E57C2), // Light Purple
          surface: Colors.white,
          background: const Color(0xFFF5F5F5),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFF5E35B1),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF26A69A),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF5E35B1), width: 2),
          ),
        ),
      ),
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
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BooksScreen(),
    MembersScreen(),
    chatbotScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: const Text(
                'National Library',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              accountEmail: const Text(
                'Public Library',
                style: TextStyle(fontSize: 16),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/library.png'),
              ),
            ),
            ListTile(
              leading: const CircleAvatar(backgroundImage: AssetImage('assets/photo.jpg')),
              title: const Text(
                'Ashish Verma',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Administrator',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              leading: Icon(Icons.book, color: Theme.of(context).colorScheme.primary),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              title: const Text('Books'),
              selected: _selectedIndex == 1,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              leading: Icon(Icons.people, color: Theme.of(context).colorScheme.primary),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              title: const Text('Members'),
              selected: _selectedIndex == 2,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Theme.of(context).colorScheme.secondary),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              title: const Text('Chat Bot'),
              selected: _selectedIndex == 3,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
              leading: Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              title: const Text('About'),
              selected: _selectedIndex == 4,
              selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}