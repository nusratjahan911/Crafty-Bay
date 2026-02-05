class Urls {
  static const String _baseUrl = 'https://ecom-rs8e.onrender.com/api';
  static const String signUpUrl = '$_baseUrl/auth/signup';
  static const String verifyOtpUrl = '$_baseUrl/auth/verify-otp';
  static const String signInUrl = '$_baseUrl/auth/login';

  static const String homeSliderUrl = '$_baseUrl/slides';
  static String get10ProductInHomePageUrl(String slug) => '$_baseUrl/products?count=10&category=$slug';

  static String categoryListUrl(int pageSize, int pageNo) => '$_baseUrl/categories?count=$pageSize&page=$pageNo';
  static String productsByCategoryUrl(
      int pageSize,
      int pageNo,
      String categoryId,
      ) => '$_baseUrl/products?count=$pageSize&page=$pageNo&category=$categoryId';
  static String productDetailsUrl(String productId) => '$_baseUrl/products/id/$productId';
  static String productDetailsBySlugUrl(int count,int page,String productSlug) => '$_baseUrl/products?count=$count&page=$page&category=$productSlug';

  static const String cartItemListUrl = '$_baseUrl/cart';
  static const String addToCartUrl = '$_baseUrl/cart';
  static String updateCartItemUrl(String cartId) => '$_baseUrl/cart/$cartId';
  static String deleteCartItemUrl(String cartId) => '$_baseUrl/cart/$cartId';

  static const String updateProfileUrl = '$_baseUrl/auth/profile';

  static const String createReviewUrl = '$_baseUrl/review';
  static String updateReviewUrl(String reviewId) => '$_baseUrl/reviews/$reviewId';
  static String reviewListUrl(int count,int page, String productId) => '$_baseUrl/reviews?count=$count&page=$page&product=$productId';
  static String deleteReviewUrl(String reviewId) => '$_baseUrl/reviews/$reviewId';


  static String wishListUrl(int pageSize, int pageNo) => '$_baseUrl/wishlist?count=$pageNo&page=$pageSize';
  static String deleteWishListItemUrl(String wishListId) => '$_baseUrl/wishlist/$wishListId';
  static const String addToWishListUrl = '$_baseUrl/wishlist';


}
