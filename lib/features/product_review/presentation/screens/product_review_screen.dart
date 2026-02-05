import 'package:crafty_bay/features/common/presentation/widgets/center_circular_progress.dart';
import 'package:crafty_bay/features/home/presentation/widgets/circle_icon_button.dart';
import 'package:crafty_bay/features/product_review/presentation/provider/product_review_provider.dart';
import 'package:crafty_bay/features/product_review/presentation/screens/create_product_review_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/app_colors.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../widgets/review_card.dart';

class ProductReviewScreen extends StatefulWidget {


  const ProductReviewScreen({super.key, required this.productId,});

  static const String name = '/product_review';
  final String productId;

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {

  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProductReviewProvider>().loadInitialReviewList(widget.productId);
      _scrollController.addListener(_loadMoreData);
    },);
  }


  void _loadMoreData(){
    if(context.read<ProductReviewProvider>().loadingMoreData){
      return;
    }

    if(_scrollController.position.extentAfter < 300){
      context.read<ProductReviewProvider>().fetchReviewList(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {

        return Scaffold(
            appBar: AppBar(
              title: Row(
                spacing: 4,
                children: [
                  Text('Reviews'),
                  CircleIconButton(icon: Icons.edit, onTap: (){}),
                ],
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),

            ),


            body: Column(
              children: [
                Expanded(
                  child: Consumer<ProductReviewProvider>(
                      builder: (context, provider, _) {
                        if (provider.reviewListInProgress) {
                          return CenterCircularProgress();
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: provider.reviewList.length,
                                  itemBuilder: (context, index) {
                                    return ReviewCard(productId: widget.productId, reviewModel: provider.reviewList[index]);
                                  },
                                ),
                              ),
                            ),
                            if(provider.loadingMoreData)CenterCircularProgress()
                          ],
                        );
                      },
                  ),
                ),
                _buildAddReviewSection(),
              ],
            ),

          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _onTapAddReviewButton();
            },
            shape: CircleBorder(),
            backgroundColor: AppColours.themeColor,
            child: Icon(Icons.add, color: Colors.white, ),
          ),

        );

  }


  Widget _buildAddReviewSection() {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: AppColours.themeColor.withAlpha(40),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ProductReviewProvider>(
                  builder: (context,_,_) {
                    return Text('Reviews (${context.read<ProductReviewProvider>().totalReviewCount})', style: TextTheme.of(context).bodyLarge?.copyWith(fontSize: 20));
                  }
                )],
            ),
          ),

        ],
      ),
    );
  }

  void _onTapAddReviewButton() async{
    if(await AuthController.isAlreadyLoggedIn()){
    Map<String, dynamic> map = {
    "productId" : widget.productId,
    "reviewModel" : null
    };
    Navigator.pushNamed(context, CreateProductReviewScreen.name, arguments:map);
    }else{
    Navigator.pushNamed(context, SignUpScreen.name);
    }
  }



}
