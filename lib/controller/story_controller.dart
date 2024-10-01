import 'package:get/get.dart';
import 'package:story_app/api/api_service.dart';
import 'package:story_app/model/user_model.dart';

class StoryController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStories();
  }

  void fetchStories() async {
    try {
      isLoading(true);
      var stories = await ApiService().fetchStories();
      if (stories.isNotEmpty) {
        userList.assignAll(stories);
      }
    } finally {
      isLoading(false);
    }
  }
}
