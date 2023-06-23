import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:youtube_ecommerce/admin/firebase_helper.dart';
import 'package:youtube_ecommerce/models/user_model/user_model.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({Key? key}) : super(key: key);

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Người dùng",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Xử lý sự kiện khi nhấn nút Floating Action Button
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: FirebaseStoreHelper.instance.getUserList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) =>
                        _buildUserTitle(snapshot.data![index]),
                  ),
                );
              }
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }));
  }

  Widget _buildUserTitle(UserModel user) {
    return SwipeActionCell(
      key: ObjectKey(user.id),
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "Delete",
            onTap: (CompletionHandler handler) async {
              // list.removeAt(index);
              setState(() {});
            },
            color: Colors.red),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.image ??
                'https://png.pngtree.com/png-clipart/20190921/original/pngtree-user-avatar-boy-png-image_4693645.jpg'),
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.name,style: TextStyle(
              fontWeight: FontWeight.w700
            ),),
            Text(
              user.email,
              style: TextStyle(),
            )
          ]),
        ),
      ),
    );
  }
}
