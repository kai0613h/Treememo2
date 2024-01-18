import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Page {
  Page? up;
  Page? down;
  Page? left;
  Page? right;
  String content;
  int index;

  Page(this.index, this.content);

  Widget buildPage() {
    return Center(
      child: Text(
        content,
        style: TextStyle(
              fontSize: 34.0, // テキストのサイズを変更するにはここで指定
            ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Page currentPage;
  TextEditingController alertDialogController = TextEditingController(); // 新しく追加したController

  @override
  void initState() {
    super.initState();
    currentPage = Page(0, 'Sample Page');
  }

  void handlePageChange(String direction) {
    setState(() {
      if (direction == 'right' && currentPage.right != null) {
        currentPage = currentPage.right!;
      } else if (direction == 'left' && currentPage.left != null) {
        currentPage = currentPage.left!;
      } else if (direction == 'down' && currentPage.down != null) {
        currentPage = currentPage.down!;
      } else if (direction == 'up' && currentPage.up != null) {
        currentPage = currentPage.up!;
      } else if (direction == 'right' && currentPage.right == null) {
        Page newRightPage = Page(currentPage.index + 1, 'New Right Page');
        newRightPage.left = currentPage;
        currentPage.right = newRightPage;
        currentPage = newRightPage;
      } else if (direction == 'down' && currentPage.down == null) {
        Page newDownPage = Page(currentPage.index + 1, 'New Down Page');
        newDownPage.up = currentPage;
        currentPage.down = newDownPage;
        currentPage = newDownPage;
      }
    });
  }

  void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('内容を入力してください'),
        content: TextField(
          keyboardType: TextInputType.multiline, // 追加
          maxLines: null, // 追加
          controller: alertDialogController,
          decoration: InputDecoration(labelText: 'Content'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                currentPage.content = alertDialogController.text;
                alertDialogController.text = "";
              });
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
  }
  void deletePagesright() {
        setState(() {
      currentPage.right = null;
    });
  }

  void deletePagesdown() {
    setState(() {
      currentPage.down = null;
    });
  }

  void backParent() {
    setState(() {
      if (currentPage.up != null) {
        while (currentPage.up != null) {
          currentPage = currentPage.up!;
        }
      }
      else if (currentPage.left != null) {
        while (currentPage.left != null) {
          currentPage = currentPage.left!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home: Builder(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(''),
            shape: Border(bottom: BorderSide.none),
            // AppBarに追加するアイコン
            leading:IconButton(
              icon: Icon(Icons.west),
              onPressed: () {
                backParent() ;
              },
            ),
            backgroundColor: const Color.fromARGB(255, 5, 0, 0)
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                handlePageChange('right');
              } else if (details.primaryVelocity! > 0) {
                handlePageChange('left');
              }
            },
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                handlePageChange('down');
              } else if (details.primaryVelocity! > 0) {
                handlePageChange('up');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentPage.buildPage(),
                SizedBox(height: 200),
                SizedBox(height: 20),

              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.south_rounded),
                label: '下消去',
                tooltip: '下のページを消去します',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mode_edit_outline_rounded ,color:Colors.black),
                label: '編集',
                tooltip: 'ページの中身を書き換らえれます',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.east_rounded,color:Colors.blue),
                label: '右消去',
                tooltip: '右のページを消去します',
                backgroundColor: Colors.blue
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                deletePagesdown();
              } else if (index == 1) {
                showAlertDialog(context);
              }else if (index == 2) {
                deletePagesright();
              }
            },
          ),
        );
      },
    ),
  );
}
}
