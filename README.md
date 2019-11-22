# datum

Application for data collection, CSV conversion and attachment sending by mail.

# Method of Operation
The App collects Data from the normal user when the admin mode is set to false in build.

Every data validated and sent goes to the firebase storage.
In the admin mode = true build, the app performs similarly but has an extra widget in the app bar which launches the Dashboard route. 

In the dashboard page, the admins can enter there email addres, click <b>compile and publish</b>. 
The app then fetches the data from firestore and converts to a csv file. then sends to desired mail.

# Usage
If you want to use the app. you'll need to make some changes.

# Create your Firebase Project
Create your firebase project from <a href="https://console.firebase.com">Firebase Console</a>. Create and android app. and follow the instruction to add your <code>google-service.json</code> file to the required path.

# Setup Firestore
This should be pretty easy to do

# Modify the form.
Navigate to form.dart and customize the form to look the way you want.

# Customize the UI to your taste.

# Build the app

# That'll be all!
