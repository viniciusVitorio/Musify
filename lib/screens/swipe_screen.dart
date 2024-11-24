import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'match_screen.dart';
import 'profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'matches_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final response = await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    final List<String> instruments = [
      'Violão', 'Piano', 'Bateria', 'Guitarra', 'Baixo', 'Teclado', 'Violino', 'Saxofone'
    ];

    final List<String> genres = [
      'MPB', 'Rock', 'Jazz', 'Clássico', 'Pop', 'Reggae', 'Eletrônica', 'Blues'
    ];

    final Random random = Random();

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Map<String, String>> profiles = [];
      
      for (var user in data['results']) {
        profiles.add({
          'name': '${user['name']['first']} ${user['name']['last']}',
          'instrument': instruments[random.nextInt(instruments.length)],
          'genre': genres[random.nextInt(genres.length)],
          'image': "https://ui-avatars.com/api/?name=${user['name']['first']}&background=random&size=150",
        });
      }

      setState(() {
        _swipeItems.addAll(profiles.map((profile) {
          return SwipeItem(
            content: profile,
            likeAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchScreen(
                    profileName1: "Você",
                    profileName2: profile['name']!,
                  ),
                ),
              );
              _saveLikedProfile(profile['name']!);
            },
            nopeAction: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Você ignorou ${profile['name']}.")),
              );
            },
          );
        }).toList());

        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      });
    } else {
      throw Exception('Falha ao carregar os perfis');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Descubra Músicos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LikedProfilesScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _swipeItems.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        final profile = _swipeItems[index].content as Map<String, String>;
                        return Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            shadowColor: Colors.deepPurple.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    profile['image']!,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  profile['name']!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Instrumento: ${profile['instrument']}",
                                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Gênero: ${profile['genre']}",
                                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        );
                      },
                      onStackFinished: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Você viu todos os perfis!")),
                        );
                      },
                      itemChanged: (SwipeItem item, int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                final currentProfile = _swipeItems[_currentIndex].content as Map<String, String>;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(profile: currentProfile),
                  ),
                );
              },
              child: const Text("Ir para o Perfil"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para salvar os perfis curtidos no local storage
  Future<void> _saveLikedProfile(String profileName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> likedProfiles = prefs.getStringList('likedProfiles') ?? [];
    likedProfiles.add(profileName);
    await prefs.setStringList('likedProfiles', likedProfiles);
  }
}
