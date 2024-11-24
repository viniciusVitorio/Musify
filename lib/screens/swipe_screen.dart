import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'match_screen.dart'; 
import 'profile_screen.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late MatchEngine _matchEngine;
  final List<SwipeItem> _swipeItems = [];
  final List<Map<String, String>> _mockProfiles = [
    {
      "name": "Vinícius",
      "instrument": "Violão",
      "genre": "MPB",
      "image": "https://ui-avatars.com/api/?name=Vinícius&background=random&size=150"
    },
    {
      "name": "Marina",
      "instrument": "Piano",
      "genre": "Clássico",
      "image": "https://ui-avatars.com/api/?name=Marina&background=random&size=150"
    },
    {
      "name": "Lucas",
      "instrument": "Bateria",
      "genre": "Rock",
      "image": "https://ui-avatars.com/api/?name=Lucas&background=random&size=150"
    },
  ];

  int _currentIndex = 0; // Variável para armazenar o índice da carta atual

  @override
  void initState() {
    super.initState();

    // Criando os itens de swipe
    for (var profile in _mockProfiles) {
      _swipeItems.add(SwipeItem(
        content: profile,
        likeAction: () {
          // Exibe o "match" diretamente quando o usuário curtir um perfil
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchScreen(
                profileName1: "Você", // Nome do usuário atual
                profileName2: profile['name']!, // Nome do perfil curtido
              ),
            ),
          );
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Você ignorou ${profile['name']}.")),
          );
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Descubra Músicos"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SwipeCards(
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
                    _currentIndex = index; // Atualizando o índice manualmente
                  });
                  print("Item mudou: ${item.content}");
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
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
