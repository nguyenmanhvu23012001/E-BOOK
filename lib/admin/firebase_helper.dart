import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_ecommerce/models/category_model/category_model.dart';
import 'package:youtube_ecommerce/models/product_model/product_model.dart';

import '../models/user_model/user_model.dart';


class FirebaseStoreHelper {
  static FirebaseStoreHelper instance = FirebaseStoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUserList() async{
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
        await _firebaseFirestore.collection("users").get();

    return querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }

  Future<List<CategoryModel>> getCategoryList() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _firebaseFirestore.collection("categories").get();
    return querySnapshot.docs.map((e) => CategoryModel.fromJson(e.data()))
        .toList();
  }

  Future<List<ProductModel>> getProductList() async{
    QuerySnapshot<Map<String,dynamic>> querySnapshot =
    await _firebaseFirestore.collection("products").get();
    return querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
  }




}