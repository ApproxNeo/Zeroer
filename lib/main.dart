import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menubar/menubar.dart' as menubar;
import 'package:path_provider/path_provider.dart';
import 'package:win32/win32.dart';

import 'models/winver.dart';
import 'volumepanel.dart';

void main() {
  runApp(ZeroerApp());
}

class ZeroerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool showRoundedCornerSwitch = false;

  @override
  void initState() {
    showRoundedCornerSwitch = isWindows11();

    super.initState();
  }

  void showDocumentsPath() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final hwnd = GetForegroundWindow();
    final pMessage = 'Path: ${appDocDir.path}'.toNativeUtf16();
    final pTitle = 'Application Documents'.toNativeUtf16();

    MessageBox(hwnd, pMessage, pTitle, MB_OK);

    free(pMessage);
    free(pTitle);
  }

  @override
  Widget build(BuildContext context) {
    menubar.setApplicationMenu([
      menubar.Submenu(label: 'Explore', children: [
        menubar.MenuItem(
          label: 'Show Docs Path...',
          shortcut: LogicalKeySet(LogicalKeyboardKey.control,
              LogicalKeyboardKey.shift, LogicalKeyboardKey.keyP),
          onClicked: () async => showDocumentsPath(),
        ),
      ]),
    ]);

    return Scaffold(
      body: Column(
        children: const [
          Expanded(child: VolumePanel()),
        ],
      ),
    );
  }
}
