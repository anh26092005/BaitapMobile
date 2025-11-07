├── firebase_api.dart
├── firebase_options.dart
├── login_google.dart             # (bạn đã có)
├── main_tabs_page.dart           # sẽ chứa UI hiển thị API
├── main.dart                     # (bạn đã có)
│
├── models/
│   └── task.dart                 # cấu trúc dữ liệu từ API
├── services/
│   └── api_service.dart          # gọi API (GET, DELETE)
├── screens/
│   ├── home_screen.dart          # màn hình danh sách công việc
│   ├── detail_screen.dart        # chi tiết công việc
│   └── empty_view.dart           # khi danh sách rỗng
└── widgets/
    └── task_card.dart            # hiển thị 1 task
