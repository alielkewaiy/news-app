import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newspro/modules/news_detals/web_view.dart';

Widget defaultTextFormField({
  Function? showPassword,
  required TextEditingController controller,
  required TextInputType textInputType,
  Function? onChange,
  Function? onFieldSubmitted(value)?,
  FormFieldValidator<String>? validate,
  bool isPassword = true,
  Function? onTap,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isClickable = true,
}) =>
    TextFormField(
      onChanged: (v) {
        onChange!(v);
      },
      enabled: isClickable,
      controller: controller,
      onTap: () {
        onTap!();
      },
      keyboardType: textInputType,
      onFieldSubmitted: (value) {
        onFieldSubmitted!(value);
      },
      validator: validate,
      obscureText: isPassword,
      decoration: InputDecoration(
          labelText: '$label',
          border: OutlineInputBorder(),
          prefixIcon: Icon(prefix),
          suffixIcon: IconButton(
              onPressed: () {
                showPassword!();
              },
              icon: Icon(suffix))),
    );

Widget buildArticleItem(article, context) => InkWell(
      onTap: () {
        navigateTo(context, Details(article['url']));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: NetworkImage(
                        '${article['urlToImage'] == null ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKrW3T3pi1t9C0PrGueBH01PrSZTG96V71dwsVdsdlUy_mzOmeja4kDeq_sVyvrSVRILo&usqp=CAU' : article['urlToImage']}'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 120,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text('${article['title']}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${article['publishedAt']}',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

Widget searchItem(List list) {
  if (list.length == 0) {
    return Center();
  } else {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildArticleItem(list[index], context),
        separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.grey,
                height: 1,
                width: double.infinity,
              ),
            ),
        itemCount: 10);
  }
}

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => widget), (route) {
      return false;
    });
void showToast({required String message, required ToastStates states}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: choseToastColor(states),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARING }

Color choseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARING:
      color = Colors.amber;
      break;
  }

  return color;
}
