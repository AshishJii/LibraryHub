import 'package:flutter/material.dart';
import 'books_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'book_${widget.book.title}',
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.book.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.book.author,
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        'Rating: ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      RatingBar.builder(
                        initialRating: widget.book.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 28.0,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            widget.book.rating = rating;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.book.description,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Comments',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (widget.book.comments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No comments yet. Be the first to comment!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.book.comments.length,
                      itemBuilder: (context, index) {
                        final comment = widget.book.comments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                comment.user[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              comment.user,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(comment.text),
                            ),
                            trailing: Icon(
                              comment.liked ? Icons.thumb_up : Icons.thumb_down,
                              color: comment.liked 
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.red[400],
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      hintText: 'Share your thoughts about this book...',
                      prefixIcon: const Icon(Icons.comment),
                      suffixIcon: Icon(Icons.send, color: Theme.of(context).colorScheme.secondary),
                    ),
                    maxLines: 3,
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        setState(() {
                          widget.book.comments.add(Comment(user: 'Reader', text: text, liked: true));
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}