import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:youtube_ecommerce/admin/firebase_helper.dart';
import 'package:youtube_ecommerce/models/product_model/product_model.dart';


class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

  final CollectionReference productsCollection =
  FirebaseFirestore.instance.collection('products');

  bool _isDialogOpen = false;
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
          future: FirebaseStoreHelper.instance.getProductList(),
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

  Widget _buildUserTitle(ProductModel product) {
    return SwipeActionCell(
      key: ObjectKey(product.id),
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "Delete",
            onTap: (CompletionHandler handler) async {
              await deleteProduct(product.id);
              setState(() {
              });

            },
            color: Colors.red),
      ],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(
                product.image),
          title:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(product.name,style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),),
          Text(" Giá : ${product.price.toString()}")]),
        ),
      ),
    );
  }

  void openCreateFrom(){
    setState(() {
      _isDialogOpen = true;
    });
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FormModal();
      },
    ).then((value) => setState(() {
      _isDialogOpen = true;
    }));

    
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
  TextEditingController nameEditControler = TextEditingController();
  TextEditingController priceEditControler = TextEditingController();
  TextEditingController descriptionController = TextEditingController();



  bool isLoading = false;


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
            'Thông tin sản phẩm',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 16.0),
          _selectedImage != null
              ? Image.file(_selectedImage!, height: 50)
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
              labelText: 'Tên sách',
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: priceEditControler,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Giá",
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () async {
              if(_selectedImage == null){
                Fluttertoast.showToast(msg: "Hãy chọn ảnh cho sản phẩm");
              }if(nameEditControler.text == ''){
                Fluttertoast.showToast(msg: "Hãy chọn ảnh cho sản phẩm");
              }if(priceEditControler.text ==''){
                Fluttertoast.showToast(msg: "Hãy điền giá cho sản phẩm");
              }
              else{
              await saveProduct(nameEditControler.text, priceEditControler.text);

                Navigator.pop(context);

              }

              // Close the modal
            },
            child: isLoading ? CircularProgressIndicator(color: Colors.white,) : Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> saveProduct(String name, String price) async {

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
      CollectionReference productCollection = firestore.collection('products');
      var productRef = productCollection.doc();
      String id  = productRef.id;

      await productRef.set({
        'id':id,
        'name': name,
        'price': price,
        'image': imageUrl,
        'description':"",
        'isFavourite': false,
      });

      Fluttertoast.showToast(msg: "Thêm sản phẩm thành công");

      print('Lưu sản phẩm thành công');
    } catch (e) {
      print('Lỗi khi lưu sản phẩm: $e');
    }
  }


}



