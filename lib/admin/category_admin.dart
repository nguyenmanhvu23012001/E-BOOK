import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:youtube_ecommerce/admin/firebase_helper.dart';
import 'package:youtube_ecommerce/models/category_model/category_model.dart';


class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Sản phẩm",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openCreateFrom();
            // Xử lý sự kiện khi nhấn nút Floating Action Button
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: FirebaseStoreHelper.instance.getCategoryList(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) => _buildUserTitle(snapshot.data![index]),
                  ),
                );}
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
        ));
  }

  Widget _buildUserTitle(CategoryModel category) {
    return SwipeActionCell(
      key: ObjectKey(category.id),
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "Delete",
            onTap: (CompletionHandler handler) async {
              deleteProduct(category.id);
              setState(() {
              });
            },
            color: Colors.red),
      ],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(
              category.image,width:100 ),
          title:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(category.name,style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
             ]),
        ),
      ),
    );
  }

  void openCreateFrom(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FormModal();
      },
    ).then((value) {
      setState(() {
      });
    });
  }

  Future<void> deleteProduct(String id)async{
    productsCollection.doc(id).delete().then((_) {
      Fluttertoast.showToast(msg: "Xóa sản phẩm thành công");
      print('Đã xóa sản phẩm thành công');
    }).catchError((error) {
      print('Lỗi khi xóa sản phẩm: $error');
    });

  }
}


class FormModal extends StatefulWidget {
  @override
  _FormModalState createState() => _FormModalState();
}

class _FormModalState extends State<FormModal> {

  bool isLoading = false;
  TextEditingController nameEditControler = TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Thông tin thể loại',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 16.0),
          _selectedImage != null
              ? Image.file(_selectedImage!, height: 50 )
              : Container(),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              _pickImage(ImageSource.gallery); // Open gallery to pick image
            },
            child: Text('Chọn ảnh'),
          ),
          SizedBox(height: 8.0),
          SizedBox(height: 16.0),
          TextField(
            controller: nameEditControler,
            decoration: InputDecoration(
              labelText: 'Tên thể loại',
            ),
          ),
          SizedBox(height: 8.0),

          ElevatedButton(
            onPressed: () async {
              if(_selectedImage == null){
                Fluttertoast.showToast(msg: "Hãy chọn ảnh cho thể loại");
              }if(nameEditControler.text == ''){
                Fluttertoast.showToast(msg: "Hãy chọn điền tên thể loại");
              }
              else{
                await saveProduct(nameEditControler.text);
                Navigator.pop(context);

              }
            },
            child: Text('Thêm'),
          ),
        ],
      ),
    );
  }

  Future<void> saveProduct(String name) async {

    setState(() {
      isLoading = true;
    });
    // Tải ảnh lên Firebase Storage
    FirebaseStorage storage = FirebaseStorage.instance;
    File imageFile = File(_selectedImage!.path);
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    try {
      TaskSnapshot snapshot = await storage.ref()
          .child('images/$fileName')
          .putFile(imageFile);
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Lưu thông tin sản phẩm vào Cloud Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference productCollection = firestore.collection('categories');
      var productRef = productCollection.doc();
      String id  = productRef.id;

      await productRef.set({
        'id':id,
        'name': name,
        'image': imageUrl,
      });

      Fluttertoast.showToast(msg: "Thêm sản phẩm thành công");

      print('Lưu sản phẩm thành công');
    } catch (e) {
      print('Lỗi khi lưu sản phẩm: $e');
    }
  }
}



