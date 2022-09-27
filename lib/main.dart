import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:english_words/english_words.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arvid Test App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const RandomWords(),
    );
  }
}


class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final images = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <String>{};

  
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (imgurl) {
              // return Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(width: 10, color: Colors.black38),
              //           borderRadius: const BorderRadius.all(Radius.circular(8))
              //         ),
              //         margin: const EdgeInsets.all(4),
              //         child: Image.asset(imgurl)
              //       )
              //     )
              //   ]
              // );
              return ListTile(
                title: Image.asset(imgurl)
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                  color: Colors.amber,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Liked Images'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(  
        title: const Text('Test App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Images',
          ),
        ],
      ),
      // body: ListView.builder(
      //   padding: const EdgeInsets.all(16.0),
      //   itemBuilder: (context, i) {
      //     if (i.isOdd) return const Divider();

      //     final index = i ~/ 2; /*3*/

      //     if (index >= _suggestions.length) {
      //       _suggestions.addAll(generateWordPairs().take(10));
      //     }

      //     final alreadySaved = _saved.contains(_suggestions[index]);
  
      //     return ListTile(
      //       title: Text(
      //         _suggestions[index].asPascalCase,
      //         style: _biggerFont,
      //       ),
      //       subtitle: Text(
      //         _suggestions[index].asCamelCase,
      //         style: _biggerFont,
      //       ),
      //       trailing: Icon(
      //         alreadySaved ? Icons.favorite : Icons.favorite_border,
      //         color: alreadySaved ? Colors.red : null,
      //         semanticLabel: alreadySaved ? 'Removed from saved' : 'Save',
      //       ),
      //       onTap: () {
      //         setState(() {
      //           if (alreadySaved) {
      //             _saved.remove(_suggestions[index]);
      //           } else {
      //             _saved.add(_suggestions[index]);
      //           }
      //         });
      //       },
      //     );
      //   },
      // ),
      body: _buildGrid(),
    );
  }
  
  Widget _buildImageColumn() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black26
      ),
      child: Column(
        children: [
          _buildImageRow(1),
          _buildImageRow(3),
        ],    
      ),
    );
  }

  Widget _buildImageRow(int imageIndex) => Row(
    children: [
      _buildDecoratedImage(imageIndex),
      _buildDecoratedImage(imageIndex + 1),
    ],
  );

  Widget _buildDecoratedImage(int imageIndex) {
    images.add('images/pic$imageIndex.png');
    final alreadySaved = _saved.contains(images[imageIndex]);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: alreadySaved ? 10 : 0, color: Colors.black38),
          borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        margin: const EdgeInsets.all(4),
        child: GestureDetector(
          child: Image.asset('images/pic$imageIndex.png'),
          onTap: () {
            
            setState(() {
              if (alreadySaved) {
                _saved.remove(images[imageIndex]);
              } else {
                _saved.add(images[imageIndex]);
              }
            });
          },
        )
      ),
    );
  }

  Widget _buildGrid() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(20),
  );

  List<Container> _buildGridTileList(int count) {
    return List.generate(
      count, (i) {
        images.add('images/pic$i.png');
        final alreadySaved = _saved.contains(images[i]);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black38),
            borderRadius: const BorderRadius.all(Radius.circular(3))
          ),
          margin: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('images/pic$i.png'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border_outlined),
                    onTap: () {
                      
                      setState(() {
                        if (alreadySaved) {
                          _saved.remove(images[i]);
                        } else {
                          _saved.add(images[i]);
                        }
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        );
      }
    );
  }
}
