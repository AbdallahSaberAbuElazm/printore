import 'package:get/get.dart';
import 'package:printore/model/cart/cart.dart';
import 'package:printore/model/product/product.dart';
import 'package:printore/services/firestore_db.dart';

class CartController extends GetxController {
  final cart = <Cart>[].obs;
  final _products = {}.obs;
  final price = 0.0.obs;
  final priceCart = 0.0.obs;

  @override
  void onInit() {
    cart.bindStream(FirestoreDB().getCart());
    super.onInit();
  }

  increaseQuantity(int index) {
    cart[index].noOfCopies++;
    update();
  }

  decreaseQuantity(int index) {
    cart[index].noOfCopies--;
    update();
  }

  updateQuantity(int index, int quantity) {
    cart[index].noOfCopies = quantity;
    update();
  }

  getAllPriceOffCart() {
    priceCart.value = 0.0;
    for (var cartData in cart) {
      priceCart.value += cartData.totalPrice!;
    }
    update();
  }

  updatePrice(double priceUpdated) {
    price.value += priceUpdated;
    update();
  }

  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] += 1;
    } else {
      _products[product] = 1;
    }
  }

  get products => _products;
  int productLength() {
    return _products.length;
  }

  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product] == 1) {
      _products.removeWhere((key, value) => key == product);
    } else {
      _products[product] -= 1;
    }
  }

  double calculateFilePrice(
      {required int numOfPages,
      required int numOfCopies,
      required double paperPrice,
      required int layoutNumOfPages,
      required double layoutPrice,
      required double wrappingPrice,
      required int side,
      required double priceSide}) {
    int numOfPapers =
        ((numOfCopies * numOfPages) / (layoutNumOfPages * side)).ceil();

    double priceOfLayout = (numOfPages > 1) ? (numOfPapers * layoutPrice) : 0;
    double pricePaperWithSide =
        (numOfPages > 1) ? (numOfPapers * priceSide) : 0;

    // print('data is ${(7 * 3 / 2).round()}');

    return (numOfPapers * paperPrice) +
        priceOfLayout * side +
        pricePaperWithSide +
        wrappingPrice;
  }
}
