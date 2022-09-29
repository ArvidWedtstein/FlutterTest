import 'dart:ffi';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arvid Test App',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        // textTheme: GoogleFonts.latoTextTheme(),
        fontFamily: 'Comic',
      ),
      darkTheme: ThemeData(
        cardColor: Colors.blue,
        brightness: Brightness.dark,
        accentColor: Colors.red,
        backgroundColor: Colors.red,
        hoverColor: Colors.white,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black45,
        ),
        // textTheme: GoogleFonts.latoTextTheme(),
        fontFamily: 'Comic',
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
class Song {
    String name;
    String artist;
    String imgUrl;
    Song({required this.name, required this.artist, required this.imgUrl});
}
class _RandomWordsState extends State<RandomWords> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<Song> _list;
  Song? _selectedItem;
  late int
        _nextItem;
  
  @override
  void initState() {
    super.initState();
    _list = ListModel<Song>(
      listKey: _listKey,
      initialItems: songs,
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = songs.length;
  }

  final images = <String>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <String>{};
  final isHovering = <String>{};

  
  final songs = <Song>{
    Song(name: "Sonne", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"),
    Song(name: "Mutter", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"),
    Song(name: "Ich will", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"),
    Song(name: "Du hast", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e02a715d32590424cd667879ba3"),
    Song(name: "Deutschland", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e0202add2c77fb6999e311a3248"),
  };

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          
          final tiles = _saved.map(
            (imgurl) {
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
            backgroundColor: Colors.grey,
            drawerScrimColor: Colors.amber,
            
            appBar: AppBar(
              title: const Text('Liked Images'),
              actions: [
                _saved.isNotEmpty ? IconButton(
                  icon: const Icon(Icons.fire_extinguisher),
                  onPressed: _showDialogModal,
                  tooltip: 'Delete all saved images',
                  highlightColor: Colors.red,
                  selectedIcon: const Icon(Icons.fire_extinguisher_outlined),
                ) : Icon(Icons.widgets, color: Colors.transparent),
              ],
            ),
            body: _saved.isNotEmpty ? GridView.count(
              padding: const EdgeInsets.all(4),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 3,
              children: _buildSavedGridTileList(),
            ) : const Center(child: Text("There's nothing saved here yet😑")),
          );
        },
      ),
    );
  }

  Future<void> _showDialogModal() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Alert!"),
        content: const Text("Do you really want to delete all saved images?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _saved.clear();
              });
              setState(() {});
              Navigator.pop(context, 'OK');
            },
            child: const Text('Yes plz'),
          ),
        ]
      )
    );
  }

  void _nextPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            drawerScrimColor: Colors.amber,
            
            appBar: AppBar(
              title: const Text('Songs'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _insert,
                  tooltip: 'Insert a new item',
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: _remove,
                  tooltip: 'Remove the selected item',
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _list.length,
                itemBuilder: _buildItem,
              ),
            ),
          );
        },
      ),
    );
  }

  
  void _insert() {
    final int index =
        _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
    _list.insert(index, new Song(name: "test", artist: "test", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"));
    _nextItem++;
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(  
        title: const Text('Test App'),
        leading: const Text('Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Images',
            hoverColor: Colors.red,
          ),
          IconButton(
            icon: const Icon(Icons.pages),
            onPressed: _nextPage,
            tooltip: 'Next Page',
            hoverColor: Colors.red,
          ),
        ],
      ),
      body: _buildGrid(),
    );
  }


  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      itemIndex: index,
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }
  
  Widget _buildRemovedItem(
      Song item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      itemIndex: _list.indexOf(item),
    );
  }


  Widget _buildGrid() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(16),
  );
  List<Center> _buildGridTileList(int count) {
    return List.generate(
      count, (i) {
        images.add('images/pic$i.png');
        final alreadySaved = _saved.contains(images[i]);
        final hover = isHovering.contains(images[i]);
        return Center(
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black38),
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                image: DecorationImage(
                  image: AssetImage('images/pic$i.png'),
                  fit: BoxFit.cover
                )
              ),
              margin: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black38),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(3), bottomRight: Radius.circular(3)),
                      color: Colors.grey.withOpacity(hover ? 1 : 0.3)
                    ),
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border_outlined, color: alreadySaved ? Colors.red : Colors.black),
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
                    ),
                  ),
                ],
              ),
            ),
            onDoubleTap:() {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(images[i]);
                } else {
                  _saved.add(images[i]);
                }
              });
            },
          )
        );
      }
    );
  }

  List<Center> _buildSavedGridTileList() {
    return List.generate(_saved.length, (index) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black38),
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            image: DecorationImage(
              image: AssetImage(_saved.elementAt(index)),
              fit: BoxFit.cover
            )
          ),
          margin: const EdgeInsets.all(0),
        )
      );
    });
  }
}
typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final RemovedItemBuilder<E> removedItemBuilder;
  final List<E> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList!.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList!.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  int get length => _items.length;
  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    this.onTap,
    this.selected = false,
    required this.animation,
    required this.item,
    required this.itemIndex
  }) : assert(itemIndex >= 0);

  final Animation<double> animation;
  final VoidCallback? onTap;
  final Song item;
  final bool selected;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4!;
    if (selected) {
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    }
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Card(
            color: Colors.black,
            // shape: RoundedRectangleBorder(
            //   side: BorderSide(
            //     width: 3,
            //     color: Colors.accents[itemIndex % Colors.accents.length], // Colors.primaries[itemIndex % Colors.primaries.length],
            //   )
            // ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 59, 0, 0),
                    Color.fromARGB(255, 105, 25, 0),
                  ],
                )
              ),
              margin: EdgeInsets.all(1),
              padding: EdgeInsets.all(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    // leading: Icon(Icons.album),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(item.imgUrl),
                    ),
                    title: Text(item.name),
                    subtitle: Text("Music by " + item.artist)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.play_arrow),
                        tooltip: 'Listen',
                        onPressed: () {
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  )
                ],
              )
            )
          )
        ),
      ),
    );
  }
}
