import 'package:flutter/material.dart';
import 'package:pagination/pagination_api_service.dart';
import 'project_model.dart';


class ButtonPaginationScreen extends StatefulWidget {
  const ButtonPaginationScreen({super.key});

  @override
  ButtonPaginationScreenState createState() => ButtonPaginationScreenState();
}

class ButtonPaginationScreenState extends State<ButtonPaginationScreen> {
  final ProjectService _projectService = ProjectService();
  List<Projects> projects = [];
  int currentPage = 1;
  bool isLoading = false;
  int? totalPages;

  @override
  void initState() {
    super.initState();
    _loadProjects();
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
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
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
          ),
          if (isLoading) Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator()),
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: (totalPages == null || currentPage <= totalPages!) && !isLoading ? _loadProjects : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Load More'),
            ),
          ),
        ],
      ),
    );
  }
}