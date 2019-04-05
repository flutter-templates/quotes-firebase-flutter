Quotes Sharing App is a template app with Firebase Firestore Integration in Flutter.


## To Use this template:

You need the following items

+ Create a Firebase Project and add iOS, Android applications in the console.
+ Create a Firestore Database Collection. For Document field details, Please refer the below image

<img src="/images/database_screenshot.png"/>

After, you complete creating the Firebase project and database:

+ I assume you might have configured the app with firebase plugin and info.plist files.
+ Now you can run the app, it will communicate to your database in real time.

Here is the example of the app updating in iOS, Android apps & also in Firestore database in realtime based on user interactions.

<img src="/images/screen_record.gif"/>


## Steps involved in creating this template

1. Create a Flutter project in Android Studio. (We used Android Studio to create this project)
+ Fill Project name
+ Fill package name

2. Go to android/app/src/main/AndroidManifest.xml or android/app/build.gradle & note down the package name.
3. Go to ios/Runner/Info.plist & search for bundle indentifier & note down the bundle identifier.

4. Go to firebase console & create a new project.
5. Add android app (Here you can use the package name noted down in the seconds step)
+ Configure the plist file in android directory
6. Add ios app (Here you can use the bundle identifier noted down in the third step)
+ Configure the plist file in android directory
(In case, if you see any issues in iOS app later, open the iOS module in xcode and add the downloaded plist file in the project. The file should have a target checkbox checked in the right side while you select the copied plist file in xcode.)
7. Now in Firebase console - Go to database and create new Firestore database
8. Add the collection with the documents and fields mentioned similar to the above mentioned screenshot.
9. Now go to pubspec.yaml and add firestore dependency.
10. Go to main.dart file and import firestore
11. Now ready to start coding with the cloud firestore integrated data. There are comments in the main.dart file to follow from here.



## About Us:

We love to share what we learn to the world. We want to keep doing more and more templates and tutorials for the open source community.
