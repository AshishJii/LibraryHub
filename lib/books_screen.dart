import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'book_detail_screen.dart';

class Book {
  final String title;
  final String author;
  final String image;
  final String description;
  double rating;
  List<Comment> comments;

  Book({
    required this.title,
    required this.author,
    required this.image,
    required this.description,
    this.rating = 0.0,
    this.comments = const [],
  });
}

class Comment {
  final String user;
  final String text;
  final bool liked;

  Comment({required this.user, required this.text, this.liked = false});
}

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final List<Book> _books = [
    Book(
      title: 'HitchHiker\'s Guide to the Galaxy',
      author: 'Douglas Adams',
      image: 'https://picsum.photos/150?random=1',
      description: 'A science fiction comedy series created by Douglas Adams.',
    ),
    Book(
      title: 'The Martian',
      author: 'Andy Weir',
      image: 'https://picsum.photos/150?random=2',
      description: 'A science fiction novel about an astronaut stranded on Mars.',
    ),
    Book(
      title: '1984',
      author: 'George Orwell',
      image: 'https://picsum.photos/150?random=3',
      description: 'A dystopian social science fiction novel and cautionary tale about the dangers of totalitarianism.',
    ),
    Book(
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      image: 'https://picsum.photos/150?random=4',
      description: 'A novel about the serious issues of rape and racial inequality.',
    ),
    Book(
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      image: 'https://picsum.photos/150?random=5',
      description: 'A romantic novel that charts the emotional development of the protagonist Elizabeth Bennet.',
    ),
  ];

  List<Book> _filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBooks = _books;
    _searchController.addListener(_filterBooks);
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = _books.where((book) {
        return book.title.toLowerCase().contains(query) ||
            book.author.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addBook(String title, String author, String image, String description) {
    setState(() {
      _books.add(Book(
        title: title,
        author: author,
        image: image,
        description: description,
      ));
      _filterBooks();
    });
  }

  void _removeBook(int index) {
    setState(() {
      _books.removeAt(index);
      _filterBooks();
    });
  }

  void _showAddBookDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController authorController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add a New Book', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(
                    labelText: 'Author',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Cover Image URL',
                    prefixIcon: Icon(Icons.image),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addBook(
                  titleController.text,
                  authorController.text,
                  imageController.text,
                  descriptionController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _showAddBookDialog,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Book'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books by title or author...',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: _filteredBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No books found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredBooks.length,
              itemBuilder: (context, index) {
                final book = _filteredBooks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.image,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Author: ${book.author}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        RatingBar.builder(
                          initialRating: book.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              book.rating = rating;
                            });
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => BookDetailScreen(book: book),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      color: Colors.red[400],
                      onPressed: () {
                        _removeBook(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
