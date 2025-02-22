import 'package:flutter/material.dart';
import 'member_detail_screen.dart';

class Member {
  final String name;
  final String email;
  final String image;
  final String description;

  Member({
    required this.name,
    required this.email,
    required this.image,
    required this.description,
  });
}

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final List<Member> _members = [
    Member(
      name: 'Priya Sharma',
      email: 'priya.sharma@example.com',
      image: 'https://picsum.photos/150?random=4',
      description: 'Regular Member',
    ),
    Member(
      name: 'Raj Patel',
      email: 'raj.patel@example.com',
      image: 'https://picsum.photos/150?random=3',
      description: 'Premium Member',
    ),
    Member(
      name: 'Anita Desai',
      email: 'anita.desai@example.com',
      image: 'https://picsum.photos/150?random=5',
      description: 'Guest Member',
    ),
    Member(
      name: 'Vikram Singh',
      email: 'vikram.singh@example.com',
      image: 'https://picsum.photos/150?random=6',
      description: 'Honorary Member',
    )
  ];

  List<Member> _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMembers = _members;
    _searchController.addListener(_filterMembers);
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _members.where((member) {
        return member.name.toLowerCase().contains(query) ||
            member.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _addMember(String name, String email, String image, String description) {
    setState(() {
      _members.add(Member(
        name: name,
        email: email,
        image: image,
        description: description,
      ));
      _filterMembers();
    });
  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
      _filterMembers();
    });
  }

  void _showAddMemberDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add a New Member', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Profile Image URL',
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
                _addMember(
                  nameController.text,
                  emailController.text,
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
        title: const Text('Members'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _showAddMemberDialog,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Member'),
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
                hintText: 'Search members by name or email...',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
        ),
      ),
      body: _filteredMembers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No members found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                final member = _filteredMembers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(member.image),
                    ),
                    title: Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Icon(Icons.email, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              member.email,
                              style: TextStyle(color: Colors.grey[700], fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => MemberDetailScreen(member: member),
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
                        _removeMember(index);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
