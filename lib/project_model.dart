class ProjectModel {
  int? currentPage;
  int? pages;
  int? perPage;
  List<Projects>? projects;
  int? total;

  ProjectModel(
      {this.currentPage, this.pages, this.perPage, this.projects, this.total});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    pages = json['pages'];
    perPage = json['per_page'];
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(Projects.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['pages'] = pages;
    data['per_page'] = perPage;
    if (projects != null) {
      data['projects'] = projects!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    return data;
  }
}

class Projects {
  String? createdAt;
  String? description;
  int? id;
  int? imageCount;
  String? name;
  String? updatedAt;

  Projects(
      {this.createdAt,
      this.description,
      this.id,
      this.imageCount,
      this.name,
      this.updatedAt});

  Projects.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    description = json['description'];
    id = json['id'];
    imageCount = json['image_count'];
    name = json['name'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['description'] = description;
    data['id'] = id;
    data['image_count'] = imageCount;
    data['name'] = name;
    data['updated_at'] = updatedAt;
    return data;
  }
}
