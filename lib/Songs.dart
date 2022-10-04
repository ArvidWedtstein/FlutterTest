import 'dart:ffi';
import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongApp extends StatelessWidget {
  SongApp({Key? key, required this.title}) : super(key: key);
  final String title;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<Song> _list = ListModel<Song>(
    listKey: _listKey,
    initialItems: songs,
    removedItemBuilder: _buildRemovedItem,
  );

  Song? _selectedItem;
  late int
        _nextItem = songs.length;


  final isHovering = <String>{};

  
  final songs = <Song>{
    Song(name: "Sonne", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"),
    Song(name: "Mutter", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"),
    Song(name: "Ich will", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"),
    Song(name: "Du hast", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e02a715d32590424cd667879ba3"),
    Song(name: "Deutschland", artist: "Rammstein", imgUrl: "https://i.scdn.co/image/ab67616d00001e0202add2c77fb6999e311a3248"),
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawerScrimColor: Colors.amber,
      
      appBar: AppBar(
        title: Text(title),
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
  }

  


  void _insert() {
    final int index =
        _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
    _list.insert(index, Song(name: "test", artist: "test", imgUrl: "https://i.scdn.co/image/ab67616d00001e028b2c42026277efc3e058855b"));
    _nextItem++;
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      // setState(() {
      //   _selectedItem = null;
      // });
    }
  }

  Widget _buildRemovedItem(
      Song item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      itemIndex: _list.indexOf(item),
    );
  }

  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      itemIndex: index,
      onTap: () {
        // setState(() {
        //   _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        // });
      },
    );
  }

  
}

class Song {
    String name;
    String artist;
    String imgUrl;
    Song({required this.name, required this.artist, required this.imgUrl});
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
