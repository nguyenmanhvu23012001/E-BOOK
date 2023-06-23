import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_ecommerce/models/product_model/product_model.dart';

import '../../models/category_model/category_model.dart';
import '../../models/user_model/user_model.dart';
import '../firebase_helper.dart';


class UserProvider with ChangeNotifier {

  List<UserModel> _userModelList = [];
  List<ProductModel> _products =[];
  List<CategoryModel> _categories =[];

  Future<void> getUserList() async{
    _userModelList = await FirebaseStoreHelper.instance.getUserList();
  }

  Future<void> getCategoriesList() async{
    _categories = await FirebaseStoreHelper.instance.getCategoryList();
  }

  Future<void> getProductList() async{
    _products = await FirebaseStoreHelper.instance.getProductList();
  }

  List<UserModel> get getUserModelList =>_userModelList;
  List<CategoryModel> get getCategoryList =>_categories;
  List<ProductModel> get getProduct =>_products;

  void init() async{
    await getUserList();
    await getCategoriesList();
    await getProductList();

  }

}