import 'package:appium_testing_app/components/custom_app_bar.dart';
import 'package:appium_testing_app/models/feature_model.dart';
import 'package:appium_testing_app/screens/lazy_loading.dart';
import 'package:appium_testing_app/screens/loader_screen.dart';
import 'package:appium_testing_app/screens/native_screen.dart';
import 'package:appium_testing_app/screens/slider_screen.dart';
import 'package:appium_testing_app/screens/ui_elements_screen.dart';
import 'package:appium_testing_app/screens/vertical_swiping_screen.dart';
import 'package:appium_testing_app/screens/web_view_screen.dart';
import 'package:appium_testing_app/screens/wheel_picker_screen.dart';
import 'package:flutter/material.dart';

import 'carousel_screen.dart';
import 'double_and_long_tap_screen.dart';
import 'drag_and_drop_screen.dart';
import 'forms_screen.dart';
import 'multiple_scroll_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FeatureModel> featureModels = [];

  @override
  void initState() {
    super.initState();
    featureModels.add(FeatureModel(
      title: "Native View",
      subtitle: "Chained View",
    ));
    featureModels
        .add(FeatureModel(title: "Slider", subtitle: "Slide your number"));
    featureModels.add(FeatureModel(
        title: "Vertical Swiping", subtitle: "Demos vertical swiping"));
    featureModels.add(
        FeatureModel(title: "Drag & Drop", subtitle: "Demo drag and drop"));
    featureModels.add(
        FeatureModel(title: "Double Tap", subtitle: "Demo double tap button"));
    featureModels.add(
        FeatureModel(title: "Long Press", subtitle: "Demo Long press button"));
    featureModels
        .add(FeatureModel(title: "Web View", subtitle: "View hacker news"));
    featureModels.add(
        FeatureModel(title: "Carousel", subtitle: "Demos swipe left & right"));
    featureModels.add(FeatureModel(
        title: "Wheel Picker", subtitle: "Demos wheel picker color"));
    featureModels.add(FeatureModel(title: "Form", subtitle: "Demos for forms"));
    featureModels.add(FeatureModel(
        title: "UI Elements",
        subtitle: "Demos different ui elements with different states"));
    featureModels.add(FeatureModel(
        title: "Lazy Loading", subtitle: "Demos dynamic fields appearence"));
    featureModels.add(FeatureModel(
        title: "Multiple Scrollview",
        subtitle: "Page with horizontal and vertical scroll"));
    featureModels.add(FeatureModel(
        title: "Loader Screen", subtitle: "Page with loader and a button"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarWidget(
          title: "Samples List",
        ),
        body: ListView.separated(
          itemCount: featureModels.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(featureModels[index].title),
              subtitle: Text(featureModels[index].subtitle),
              onTap: () {
                _navigateScreen(index);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }

  void _navigateScreen(int index) {
    Widget page;
    switch (index) {
      case 0:
        page = NativeScreen(title: featureModels[index].title);
        break;
      case 1:
        page = SliderScreen(title: featureModels[index].title);
        break;
      case 2:
        page = VerticalSwipingScreen(title: featureModels[index].title);
        break;
      case 3:
        page = DragAndDropScreen(title: featureModels[index].title);
        break;
      case 4:
        page = DoubleTapScreen(
          title: featureModels[index].title,
        );
        break;
      case 5:
        page = LongPressScreen(
          title: featureModels[index].title,
        );
        break;
      case 6:
        page = WebViewScreen(
          title: featureModels[index].title,
        );
        break;
      case 7:
        page = CarouselScreen(
          title: featureModels[index].title,
        );
        break;
      case 8:
        page = WheelPickerScreen(
          title: featureModels[index].title,
        );
        break;
      case 9:
        page = FormsScreen(
          title: featureModels[index].title,
        );
        break;
      case 10:
        page = UiElementsScreen(
          title: featureModels[index].title,
        );
        break;
      case 11:
        page = LazyLoadingScreen(
          title: featureModels[index].title,
        );
        break;
      case 12:
        page = MultipleScrollViewScreen(
          title: featureModels[index].title,
        );
        break;
      case 13:
        page = LoaderScreen(title: featureModels[index].title);
      default:
        page = NativeScreen(title: featureModels[index].title);
        break;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
