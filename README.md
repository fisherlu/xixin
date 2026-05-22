# 息心 (Xixin / RestMind)

> 中文原生正念冥想与呼吸训练 App

## 开发

```bash
flutter pub get
flutter run
```

## 打包

```bash
# Android
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

# 鸿蒙 (Flutter HarmonyOS 分支)
flutter build hap --release
```

## 架构

```
lib/
├── main.dart          # 入口
├── app.dart           # MaterialApp
├── core/              # 主题/路由/音频/存储
├── shared/           # 共享模型 + 组件
└── features/         # 首页/冥想/呼吸/睡眠/个人中心
```

## CI/CD

每次 git push 自动触发：
- flutter analyze (静态检查)
- flutter test (单元测试)
- Android APK 打包
- iOS 构建

配置文件：`.github/workflows/build.yml`
