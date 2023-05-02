# FEDLEXplorer

The **frontend** based on [Flutter](https://docs.flutter.dev/).

## Getting Started

Following **Flutter** environments are currently supported: `web`, `macos`, `android` and `ios`
(NOT tested yet).

Assuming you are sitting behind a **macos** machine, running the application is as easy
as triggering following command `flutter run lib/main_app.dart`.

### web

Because we are triggering `HTTP` requests (instead of `HTTPS`), you will need to perform
following [modifications](https://stackoverflow.com/a/66879350) if you want to run
the application in **Chrome**.

### NO Android Studio

[Instructions](https://gist.github.com/ullaskunder3/385cb078ff31cedf239ce65e64f605dd) for people
who don't want to overload their hard-disk when installing **Flutter**,  but still have a decent
`DEV` environment.
