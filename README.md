# TweetApp

Chào mừng bạn đến với dự án TweetApp, một dự án xây dựng một mạng xã hội đơn giản.
## Features

TweetApp có những tính năng chính như sau:

1. **Trang đăng nhập và đăng ký:** Người dùng có thể tạo tài khoản mới hoặc đăng nhập với tài  khoản đã có.

2. **Sáng tạo bài đăng (Tweet):** Người dùng có thể sáng tạo các bài Tweet và chia sẻ chúng với những người theo dõi mình.

3. **Đăng bình luận:** Trên mỗi bài Tweet, người dùng có thể tạo bình luận.

4. **Đăng hình ảnh và thích bài viêt:** Người dùng có thể tải lên hình ảnh và thích cái bài đăng.

5. **Hệ thống theo dõi:** Người dùng có theo dõi người dùng khác và theo dõi các bài Tweet của họ trên bảng tin.

6. **Bảng tin:** Đây là nơi người dùng có thể theo dõi các bài Tweet được đăng bởi những người mà mình theo dõi.

7. **Hệ thống tìm kiém:** Người dùng có thể tìm kiếm những người dùng khác thông qua các tên định danh (identifiers).

8. **Hệ thống nhắn tin:** Người dùng có thể nhắn tin riêng tư vơới dùng người khác thông qua hệ thống nhắn tin.

## Để chạy được dự án này:

1. Bạn cần cài đặt Flutter SDK phiên bản mới nhất. Nếu chưa cài đặt thì bạn có thể thực hiện theo hướng dẫn [flutter.dev](https://flutter.dev/docs/get-started/install) .

2. Bạn cần cài đặt 1 IDE phù hợp với phiên bản mới nhất (Android Studio hay Visual Studio Core):
- https://developer.android.com/studio
- https://code.visualstudio.com/download

3. Cài đặt cái Plugin phù hợp (Flutter, Dart, Flutter PUB)

4. Tạo 1 dự án Firebase, hướng dẫn tại đây: [https://console.firebase.google.com](https://console.firebase.google.com/).

5. Trong dự án Firebase, Khởi tạo các dịch vụ Firebase Auth, Firebase Firestore, and Firebase Storage.

6. Run the project on an emulator or physical device:

<pre><div class="bg-black rounded-md mb-4"><div class="flex items-center relative text-gray-200 bg-gray-800 px-4 py-2 text-xs font-sans justify-between rounded-t-md"><span>bash</span><button class="flex ml-auto gap-2"><svg stroke="currentColor" fill="none" stroke-width="2" viewBox="0 0 24 24" stroke-linecap="round" stroke-linejoin="round" class="h-4 w-4" height="1em" width="1em" xmlns="http://www.w3.org/2000/svg"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg>Copy code</button></div><div class="p-4 overflow-y-auto"><code class="!whitespace-pre hljs language-bash">flutter run
</code></div></div></pre>

## State Management

TweetApp uses [Mobx](https://pub.dev/packages/mobx) for state management, a powerful library for reactive state control. Mobx makes it easy to update user interface components in response to changes in the app's state.

## Dependency and Routing Management

For dependency management and routing handling, TweetApp utilizes [Flutter Modular](https://pub.dev/packages/flutter_modular). Flutter Modular is a library that organizes and modularizes the project's structure, making it easier to maintain and scale.

## Back-End: Firebase

TweetApp utilizes Firebase services as the back-end platform, leveraging the resources provided by Firebase to ensure a smooth and reliable user experience. The Firebase setup includes:

* **Firebase Auth:** Used for user authentication, enabling secure registration and login.
* **Firebase Firestore:** Responsible for storing user information, Tweets, and the Follow system. It is a real-time database that keeps information synchronized across all connected devices.
* **Firebase Storage:** Utilized to store photos of Tweets, comments, user profile pictures, and banners.

## Contributing

Contributions are welcome! Feel free to open issues or send pull requests with improvements, bug fixes, or new features.

## License

This project is licensed under the MIT License.
