import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/common/presentation/widgets/snack_bar_message.dart';
import 'package:crafty_bay/features/product_review/presentation/provider/product_review_provider.dart';
import 'package:crafty_bay/features/product_review/presentation/provider/update_review_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/review_model.dart';
import '../provider/create_product_review_provider.dart';

class CreateProductReviewScreen extends StatefulWidget {

  const CreateProductReviewScreen({super.key, required this.productId, this.reviewModel});

  static const String name = '/create_review';

  final String productId;
  final ReviewModel? reviewModel;

  @override
  State<CreateProductReviewScreen> createState() =>
      _CreateProductReviewScreenState();
}

class _CreateProductReviewScreenState extends State<CreateProductReviewScreen> {
  final CreateProductReviewProvider _createProductReviewProvider = CreateProductReviewProvider();
  final UpdateReviewProvider _updateReviewProvider = UpdateReviewProvider();

  final TextEditingController _reviewTEController = TextEditingController();
  final TextEditingController _ratingTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.reviewModel != null){
      _reviewTEController.text = widget.reviewModel!.review;
      _ratingTEController.text = widget.reviewModel!.rating.toString();
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _createProductReviewProvider),
        ChangeNotifierProvider(create: (context) => _updateReviewProvider),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text('Create Review'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 50),
                SizedBox(
                  height: 200,
                  child: TextFormField(
                    controller: _reviewTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Write your Review',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    maxLines: 6,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ratingTEController,
                  decoration: InputDecoration(hintText: 'Rating ~ 1-5'),
                  keyboardType: TextInputType.number
                ),

                SizedBox(height: 16),
                Consumer2<CreateProductReviewProvider, UpdateReviewProvider>(
                    builder: (context, _, _,_) {
                      if (_createProductReviewProvider.createReviewInProgress || _updateReviewProvider.updateReviewInProgress) {
                        return CenterCircularProgress();
                      }
                      return FilledButton(onPressed: _onTapSubmitButton, child: Text((widget.reviewModel != null) ? "Update" : 'Submit'));
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTapSubmitButton() async {

    if(widget.reviewModel != null){

      bool isSuccess = await _updateReviewProvider.updateReview(
        reviewId: widget.reviewModel!.id,
        newReview: _reviewTEController.text.trim(),
        rating: _ratingTEController.text.trim(),
      );

      if(isSuccess){
        ShowSnackBarMessage(context, 'update Review Success!');
        context.read<ProductReviewProvider>().loadInitialReviewList(widget.productId);
        Navigator.pop(context);
      }else{
        ShowSnackBarMessage(context, _createProductReviewProvider.errorMessage!);
      }
  }else{
      bool isSuccess = await _createProductReviewProvider.createProductReview(
        productId: widget.productId,
        review: _reviewTEController.text.trim(),
        rating: _ratingTEController.text.trim(),
      );

      if(isSuccess){
        ShowSnackBarMessage(context, 'Add Review Success!');
        context.read<ProductReviewProvider>().loadInitialReviewList(widget.productId);
        Navigator.pop(context);
      }else{
        ShowSnackBarMessage(context, _createProductReviewProvider.errorMessage!);
      }
    }

  }

  @override
  void dispose() {
   _reviewTEController.dispose();
   _ratingTEController.dispose();
    super.dispose();
  }
}
