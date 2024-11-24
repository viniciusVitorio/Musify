import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedProfilesScreen extends StatefulWidget {
  @override
  _LikedProfilesScreenState createState() => _LikedProfilesScreenState();
}

class _LikedProfilesScreenState extends State<LikedProfilesScreen> {
  List<String> likedProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadLikedProfiles();
  }

  Future<void> _loadLikedProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      likedProfiles = prefs.getStringList('likedProfiles') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfis que Eu Gostei"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: likedProfiles.isEmpty
          ? Center(child: Text("Você ainda não curtiu nenhum perfil."))
          : ListView.builder(
              itemCount: likedProfiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(likedProfiles[index]),
                  trailing: Icon(Icons.favorite, color: Colors.red),
                );
              },
            ),
    );
  }
}
