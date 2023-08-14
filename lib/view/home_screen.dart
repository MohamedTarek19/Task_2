import 'package:flutter/material.dart';
import 'package:task_two/models/todo_model.dart';
import 'package:task_two/view/categories_screen.dart';
import 'package:task_two/view_models/todo_vm.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDo>? todoList;
  TextEditingController catName = TextEditingController();

  double completionPercent = 0;
  ToDoVm todoVm = ToDoVm();

  void setProgress() {
    var list = todoList?.where((element) => element.completed == true);
    completionPercent = double.tryParse(list?.length.toString() ?? '0') ?? 0;
    completionPercent =
        ((completionPercent * 100) / (todoList?.length ?? 0)).floorToDouble();
  }

  List<bool?>? checkedList;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      todoList = await todoVm.getToDoList();

      checkedList = List<bool>.filled(((todoList?.length ?? 0) + 1), false,growable: true);
      setState(() {
        flag = true;
      });
      //print();
    });
  }

  List<Map<String, List<ToDo>>> categories = [];

  alert() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: const [
              Text('create category\n'),
              Center(
                child: Text('Add category name'),
              )
            ],
          ),
          content: TextField(
            controller: catName,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Map<String, List<ToDo>> map = Map<String, List<ToDo>>();
                  var res = categories.indexWhere((element) => element.keys.first == catName.text);
                  map[catName.text] = [];
                  List<ToDo>? todoTemp = List.from(todoList!);
                  List<bool?>? checkedTemp = List.from(checkedList!);
                  int length = (checkedList?.length ?? 0);
                  for (int i = 0; i < length - 1; i++) {
                    if (checkedList![i] == true) {
                      print(i);
                      if(res != -1){
                        categories[res][catName.text]?.add(todoList![i]);
                      }else{
                        map[catName.text]?.add(todoList![i]);
                      }
                      var todo = todoList![i];
                      todoTemp.remove(todo);
                      var c = checkedList![i];
                      checkedTemp.remove(c);
                    }
                  }
                  print('todo length : ${todoTemp.length} , checked length :  ${checkedTemp.length}');
                  setState(() {
                    todoList = todoTemp;
                    checkedList = checkedTemp;
                    if(res == -1){
                      categories.add(map);
                    }
                  });
                  Navigator.pop(context);
                },
                child: Text('Add category')),
          ],
        );
      },
    );
  }

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    setProgress();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purple[900]!, Colors.pink[500]!]),
          ),
        ),
        title: const Text('ToDo App'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return Categories(categories: categories,);
            }));

          }, icon: Icon(Icons.grid_view_outlined),)
        ],
      ),
      body: flag == false
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[200],
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  itemCount: (todoList?.length ?? 0) + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0.1,
                      childAspectRatio: 0.9),
                  itemBuilder: (BuildContext context, int index) {
                    int i = index;
                    i--;
                    return GridTile(i, checkedList, context);
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await alert();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  InkWell GridTile(int i, List<bool?>? checkedList, BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          i == -1 ? (checkedList?.last = !(checkedList.last ?? false)) : null;
          print(checkedList?.last);
          if (i != -1) {
            todoList![i].completed = !(todoList![i].completed ?? false);
            //checkedList[i] = !checkedList[i];
            setProgress();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: i == -1 ? Colors.purple : Colors.white54,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Container(
              margin: (i != -1 && (checkedList?.last ?? false))
                  ? const EdgeInsets.only(right: 15, top: 0, left: 15)
                  : const EdgeInsets.only(right: 15, top: 15, left: 15),
              child: i == -1
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30, right: 15, left: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "UnCategorized Tasks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${todoList?.length} Item',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (checkedList?.last ?? false) == true
                                ? Transform.scale(
                                    scale: 1.5,
                                    child: Checkbox(
                                        shape: const CircleBorder(),
                                        value: checkedList?[i],
                                        onChanged: (bool? val) {
                                          setState(() {
                                            checkedList?[i] = val;
                                          });
                                        }),
                                  )
                                : Container(),
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (todoList![i].completed ?? false)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${todoList![i].todo}'),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Completion: ',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                  height: 30,
                                  child: Text(
                                      '${(todoList![i].completed ?? false) ? "completed" : "not completed"}'),
                                ),
                              ],
                            ),
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
