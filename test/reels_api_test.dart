import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/reels/models/reel_model.dart';
import 'package:my_flutter_app/features/reels/services/reels_api_service.dart';

void main() {
  test('ReelsApiResponse fromJson parsing test', () {
    final sampleJson = {
      "success": true,
      "message": "Reels fetched successfully",
      "data": [
        {
          "id": "gid://shopify/Product/10357805613338",
          "video_url": "https://cdn.shopify.com/videos/c/vp/bd13ba5001b04464abc7888866064c9b/bd13ba5001b04464abc7888866064c9b.SD-480p-1.5Mbps-91084646.mp4",
          "thumbnail_url": "https://cdn.shopify.com/s/files/1/1005/5047/6058/files/6285319321118950127.jpg?v=1786177141",
          "caption": "Women's Premium Cotton Embroidered Straight Kurta Pant & Floral Printed Organza Dupatta Set",
          "model_name": null,
          "likes_count": 0,
          "shares_count": 0,
          "product": {
            "id": "gid://shopify/Product/10357805613338",
            "title": "Women's Premium Cotton Embroidered Straight Kurta Pant & Floral Printed Organza Dupatta Set",
            "price": "1899.00",
            "original_price": null,
            "discount": null,
            "image_url": "https://cdn.shopify.com/s/files/1/1005/5047/6058/files/6285319321118950127.jpg?v=1786177141",
            "product_url": "https://0je0xa-0n.myshopify.com/products/womens-premium-cotton-embroidered-straight-kurta-pant-floral-printed-organza-dupatta-set"
          }
        }
      ],
      "pagination": {
        "page": 1,
        "limit": 20,
        "total": 46,
        "totalPages": 3,
        "hasMore": true
      }
    };

    final response = ReelsApiResponse.fromJson(sampleJson);
    expect(response.success, isTrue);
    expect(response.data.length, equals(1));
    expect(response.pagination.total, equals(46));
    expect(response.pagination.hasMore, isTrue);

    final item = response.data.first;
    expect(item.videoUrl, contains('cdn.shopify.com'));
    expect(item.product, isNotNull);
    expect(item.product!.formattedPrice, equals('₹1899'));
    expect(item.product!.productUrl, contains('myshopify.com'));
  });

  test('Live ReelsApiService test against local backend', () async {
    final service = ReelsApiService();
    final response = await service.fetchReels(page: 1, limit: 5);
    service.dispose();

    if (response != null) {
      expect(response.success, isTrue);
      expect(response.data.isNotEmpty, isTrue);
    }
  });
}
