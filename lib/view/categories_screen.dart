import 'package:flutter/material.dart';
import 'package:task_two/models/todo_model.dart';

class Categories extends StatelessWidget {
  Categories({Key? key, required this.categories}) : super(key: key);
  List<Map<String, List<ToDo>>> categories;

  double progress = 0.0;

  double completionPercent = 0.0;

  void setProgress(int i) {
    var list = categories[i].values.first.where((element) => element.completed == true);
    completionPercent = double.tryParse(list.length.toString() ?? '0') ?? 0;
    progress = ((completionPercent) / categories[i].values.first.length);
    completionPercent =
        ((completionPercent * 100) / categories[i].values.first.length).floorToDouble();
    print(progress);
  }

  @override
  Widget build(BuildContext context) {

    print(categories.length);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purple[900]!, Colors.pink[500]!]),
          ),
        ),
        title: Center(child: const Text('Categories')),
      ),
      body: Container(
        color: Colors.grey[200],
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            itemCount: (categories.length ?? 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0.1,
                childAspectRatio: 0.9),
            itemBuilder: (BuildContext context, int index) {
              setProgress(index);
              return GridTile(index, context);
            },
          ),
        ),
      ),
    );

  }

  InkWell GridTile(int i, BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color:  Color((0xff9C2700) + (0x00001180 + i*25)),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10, top: 15, left: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 15, left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${completionPercent}%',
                          style: TextStyle(
                              color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) setState) {
                            return Material(
                              elevation: 3,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.green,
                                    value: progress,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, right: 15, left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            categories[i].keys.first,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${categories[i].values.first.length} Item',
                            style: TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
