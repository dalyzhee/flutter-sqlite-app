import 'package:flutter/material.dart';
import 'package:flutter_sqlite/database/database.dart';
import 'package:flutter_sqlite/models/planets.dart';
import 'package:flutter_sqlite/pages/add_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHelper handler;
  Future<int> addPlanets() async {
    Users firstPlanet = Users(name: "Mercury", age: 24, id: 1, email: 'mars');
    Users secondPlanet = Users(name: "Venus", age: 31, id: 2, email: 'mars');
    Users thirdPlanet = Users(id: 3, name: 'Earth', age: 4, email: 'mars');
    Users fourthPlanet = Users(id: 4, name: 'Mars', age: 5, email: 'mars');

    List<Users> users = [firstPlanet, secondPlanet, thirdPlanet, fourthPlanet];
    return await handler.insertUser(users);
  }

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    handler.initDB().whenComplete(() async {
      await addPlanets();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("User"),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: handler.retrieveUsers(),
          builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      leading: GestureDetector(
                        child: const Icon(Icons.edit),
                        onTap: () {
                          print("edited");
                        },
                      ),
                      trailing: GestureDetector(
                        child: const Icon(Icons.delete),
                        onTap: () {
                          print("deleted");
                        },
                      ),
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(snapshot.data![index].name),
                      subtitle: Text(
                        snapshot.data![index].age.toString(),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_sqlite/database/database.dart';
// import 'package:flutter_sqlite/models/planets.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.blue,
//           centerTitle: true,
//         ),
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Future<void> addOrEditUser() async {
//     String email = emailController.text;
//     String name = nameController.text;
//     String age = ageController.text;

//     if (!isEditing) {
//       Users user =
//           Users(name: name, age: int.parse(age), email: email, id: null);
//       await addUser(user);
//     } else {
//       _user.email = email;
//       _user.age = int.parse(age);
//       _user.name = name;
//       await updateUser(_user);
//     }
//     resetData();
//     setState(() {});
//   }

//   Future<int> addUser(Users user) async {
//     return await dbHelper.insertUser(user);
//   }

//   Future<int> updateUser(Users user) async {
//     return await dbHelper.updateUser(user);
//   }

//   void resetData() {
//     nameController.clear();
//     ageController.clear();
//     emailController.clear();
//     isEditing = false;
//   }

//   late DatabaseHelper dbHelper;
//   final nameController = TextEditingController();
//   final ageController = TextEditingController();
//   final emailController = TextEditingController();
//   bool isEditing = false;
//   late Users _user;

//   @override
//   void initState() {
//     super.initState();
//     dbHelper = DatabaseHelper();
//     dbHelper.initDB().whenComplete(() async {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Flutter Sqlite"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Form(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextFormField(
//                       controller: nameController,
//                       decoration: const InputDecoration(
//                         hintText: 'Enter your name',
//                         labelText: 'Name',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: ageController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.allow(
//                           RegExp(r'[0-9]'),
//                         ),
//                       ],
//                       decoration: const InputDecoration(
//                         hintText: 'Enter your age',
//                         labelText: 'Age',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: emailController,
//                       decoration: const InputDecoration(
//                         hintText: 'Enter your email',
//                         labelText: 'Email',
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           child: ElevatedButton(
//                             onPressed: addOrEditUser,
//                             child: const Text('Submit'),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 )),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: SafeArea(child: userWidget()),
//               )
//             ],
//           ))
//         ],
//       ),
//     );
//   }

//   Widget userWidget() {
//     return FutureBuilder(
//       future: dbHelper.retrieveUsers(),
//       builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (context, position) {
//                 return Dismissible(
//                     direction: DismissDirection.endToStart,
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                       child: const Icon(Icons.delete_forever),
//                     ),
//                     key: UniqueKey(),
//                     onDismissed: (DismissDirection direction) async {
//                       await dbHelper.deleteUser(snapshot.data![position].id!);
//                     },
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () => populateFields(snapshot.data![position]),
//                       child: Column(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                         12.0, 12.0, 12.0, 6.0),
//                                     child: Text(
//                                       snapshot.data![position].name,
//                                       style: const TextStyle(
//                                           fontSize: 22.0,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.fromLTRB(
//                                         12.0, 6.0, 12.0, 12.0),
//                                     child: Text(
//                                       snapshot.data![position].email.toString(),
//                                       style: const TextStyle(fontSize: 18.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: <Widget>[
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.black26,
//                                           borderRadius:
//                                               BorderRadius.circular(100)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Text(
//                                           snapshot.data![position].age
//                                               .toString(),
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Divider(
//                             height: 2.0,
//                             color: Colors.grey,
//                           )
//                         ],
//                       ),
//                     ));
//               });
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   void populateFields(Users user) {
//     _user = user;
//     nameController.text = _user.name;
//     ageController.text = _user.age.toString();
//     emailController.text = _user.email;
//     isEditing = true;
//   }
// }
