import 'package:flutter/material.dart';
import 'package:pagination/pagination_api_service.dart';
import 'project_model.dart';


class ScrollPaginationScreen extends StatefulWidget {
  const ScrollPaginationScreen({super.key});

  @override
  ScrollPaginationScreenState createState() => ScrollPaginationScreenState();
}

class ScrollPaginationScreenState extends State<ScrollPaginationScreen> {
  final ProjectService _projectService = ProjectService();
  List<Projects> projects = [];
  int currentPage = 1;
  bool isLoading = false;
  int? totalPages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadProjects();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadProjects();
      }
    });
  }

  Future<void> _loadProjects() async {
    if (isLoading || (totalPages != null && currentPage > totalPages!)) return;
    setState(() => isLoading = true);
    try {
      final projectModel = await _projectService.getProjects(page: currentPage);
      setState(() {
        projects.addAll(projectModel.projects ?? []);
        currentPage++;
        totalPages = projectModel.pages;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          projects.clear();
          currentPage = 1;
          totalPages = null;
        });
        await _loadProjects();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: projects.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == projects.length) {
            return Padding(padding: EdgeInsets.all(8), child: Center(child: CircularProgressIndicator()));
          }
          final project = projects[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.folder, color: Colors.white),
              ),
              title: Text(project.name ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(project.description ?? 'No Description'),
              trailing: Text('ID: ${project.id}'),
            ),
          );
        },
      ),
    );
  }
}