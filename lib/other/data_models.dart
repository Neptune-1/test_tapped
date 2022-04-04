import 'dart:math';

class Book {
  final int? index;
  final String title;
  final String subtitle;
  final String photoUrl;
  final DateTime addedTime;
  bool newItem;

  Book({
    this.index,
    required this.title,
    required this.subtitle,
    required this.addedTime,
    required this.newItem,
    required this.photoUrl,
  });

  static Book random({int? index}) {
    return Book(
      index: index,
      title: 'Book Cover $index',
      subtitle: 'A lot of authors',
      // random date in 2021 year
      addedTime: DateTime.utc(
        2021,
        Random().nextInt(11) + 1,
        Random().nextInt(27) + 1,
      ),
      newItem: Random().nextInt(2) == 1,
      photoUrl: "https://picsum.photos/seed/${Random().nextInt(1000)}/200",
    );
  }
}
