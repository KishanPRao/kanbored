import 'package:flutter/material.dart';
import 'package:kanbored/api/api.dart';
import 'package:kanbored/constants.dart';
import 'package:kanbored/models/project_model.dart';
import 'package:kanbored/strings.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ProjectModel> projects = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var projects = await Api.getmyProjects();
    setState(() {
      this.projects = projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: "primary".themed(context),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, routeSettings).then((value) {
                if (value is bool && value) {
                  Navigator.pushNamed(context, routeLogin);
                }
              });
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: projects
            .map((project) => Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                      splashColor:
                          "primary".themed(context).withAlpha(30),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          routeBoard,
                          arguments: project,
                        );
                      },
                      child: SizedBox(
                        child: Center(child: Text(project.name)),
                      )),
                ))
            .toList(),
      ),
    );
  }
}
