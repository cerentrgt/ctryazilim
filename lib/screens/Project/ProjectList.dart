import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kapsul_teknoloji/screens/Project/ProjectDetail.dart';
import 'package:kapsul_teknoloji/service/ProjectService.dart';

import 'ProjectAdd.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectListState();
}

class _ProjectListState extends State {
  var projectService = ProjectService();
  bool showFullList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projeler"),
        backgroundColor: Color(0xff0d0b28),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff0d0b28),
        onPressed: () {
          goToMemoryAdd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  StreamBuilder body() {
    return StreamBuilder<QuerySnapshot>(
        stream: projectService.getProject(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const CircularProgressIndicator(
                  color: Colors.indigo,
                )
              : snapshot.data == null
                  ? const CircularProgressIndicator(
                      color: Colors.indigo,
                    )
                  : ProjectListBody(snapshot);
        });
  }

  ListView ProjectListBody(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    Map<String, List<DocumentSnapshot>> projectsByTitle = {};

    for (DocumentSnapshot post in snapshot.data!.docs) {
      String projectTitle = post['projectTitle'];
      if (!projectsByTitle.containsKey(projectTitle)) {
        projectsByTitle[projectTitle] = [];
      }
      projectsByTitle[projectTitle]!.add(post);
    }
    bool isExpand = false;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: projectsByTitle.keys.length,
        itemBuilder: (context, index) {
          String projectTitle = projectsByTitle.keys.toList()[index];
          List<DocumentSnapshot> projects = projectsByTitle[projectTitle]!;
          if (projectTitle == "Akıllı Sehirler") {
            return ExpansionTile(
              title: Text(
                projectTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.2125,
                  color: Color(0xff0d0b28),
                ),
              ),
              onExpansionChanged: (isExpanded) {
                setState(() {
                  isExpanded = isExpand;
                });
              },
              children: projects.map((post) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.circle,
                            color: post['projectStatus'] == "Devam Ediyor"
                                ? Colors.yellow
                                : Colors.green),
                        title: Text(
                          post['projectName'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: 20),
                        ),
                        subtitle: Text(
                          post['mostRecentText'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(204, 0, 0, 0),
                              fontStyle: FontStyle.italic,
                              fontSize: 13),
                        ),
                        trailing: Text(
                          post['date'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(204, 0, 0, 0),
                              fontStyle: FontStyle.italic,
                              fontSize: 13),
                        ),
                        onTap: () {
                          goToDetail(post);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return ExpansionTile(
              title: Text(
                projectTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.2125,
                  color: Color(0xff0d0b28),
                ),
              ),
              onExpansionChanged: (isExpanded) {
                setState(() {
                  isExpanded = isExpand;
                });
              },
              children: projects.map((post) {
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.circle,
                            color: post['projectStatus'] == "Devam Ediyor"
                                ? Colors.yellow
                                : Colors.green),
                        title: Text(
                          post['projectName'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: 20),
                        ),
                        subtitle: Text(
                          post['mostRecentText'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(204, 0, 0, 0),
                              fontStyle: FontStyle.italic,
                              fontSize: 13),
                        ),
                        trailing: Text(
                          post['date'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(204, 0, 0, 0),
                              fontStyle: FontStyle.italic,
                              fontSize: 13),
                        ),
                        onTap: () {
                          goToDetail(post);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  void goToMemoryAdd() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProjectAdd()));
  }

  void goToDetail(DocumentSnapshot post) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetail(post: post),
      ),
    );
  }
}
