import 'package:flutter/material.dart';
//import 'Pages_1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages_vybor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (const bool.fromEnvironment('dart.library.html', defaultValue: false)) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB3fAE1ojuETvPDtZmzTGtVQ2NGTxWbDZM",
        authDomain: "cafe-cat-2311.firebaseapp.com",
        projectId: "cafe-cat-2311",
        storageBucket: "cafe-cat-2311.firebasestorage.app",
        messagingSenderId: "893875242518",
        appId: "1:893875242518:web:d3f9d0d4099cd5d7e79737",
        measurementId: "G-FGK32EMGVJ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MaterialApp(home: VyborScreen()));
}
