import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/product_review/presentation/provider/delete_review_provider.dart';
import 'package:crafty_bay/features/product_review/presentation/provider/product_review_provider.dart';
import 'package:crafty_bay/features/product_review/presentation/screens/create_product_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/presentation/widgets/snack_bar_message.dart';
import '../../data/models/review_model.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({super.key, required this.reviewModel, required this.productId,});

  final ReviewModel reviewModel;
  final String productId;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

final DeleteReviewProvider _deleteReviewProvider = DeleteReviewProvider();

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ChangeNotifierProvider(
        create: (context) => _deleteReviewProvider,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundColor: Colors.grey.withAlpha(100), radius: 16, child: Icon(Icons.person_outline,),),
                      SizedBox(width: 8,),
                      Text('${widget.reviewModel.firstName} ${widget.reviewModel.lastName}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),)
                    ],
                  ),
                  SizedBox(height: 8,),
                  Text(widget.reviewModel.review),

                ],
              ),
              Column(
                children: [
                  Consumer<DeleteReviewProvider>(
                      builder: (context, _, _) {
                        if(_deleteReviewProvider.deleteReviewInProgress){
                          return CenterCircularProgress();
                        }
                        return GestureDetector(
                            onTap: () {
                              _onTapDeleteReview();
                            },
                            child: Icon(Icons.delete));
                      }
                  ),
                  SizedBox(height: 8,),
                  GestureDetector(
                      onTap: () {
                        _onTapEditButton();
                      },
                      child: Icon(Icons.edit))
                ],)
            ],
          ),
        ),
      ),
    );
  }

  void _onTapEditButton(){
    Map<String, dynamic> map = {
      "productId" : widget.productId,
      "reviewModel" : widget.reviewModel
    };
    Navigator.pushNamed(context, CreateProductReviewScreen.name, arguments: map);
  }


  Future<void> _onTapDeleteReview() async {
    bool isSuccess = await _deleteReviewProvider.deleteReview(reviewId: widget.reviewModel.id);
    if(isSuccess){
      context.read<ProductReviewProvider>().loadInitialReviewList(widget.reviewModel.id);
    }else{
      ShowSnackBarMessage(context, _deleteReviewProvider.errorMessage!);
    }
  }
}
