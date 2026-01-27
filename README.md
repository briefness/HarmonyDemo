# HarmonyHub

这是 "HarmonyOS NEXT 开发者系列教程" 的配套代码库。配合文章，你可以直接运行这些示例代码，更快掌握 HarmonyOS NEXT 的核心特性。

## 项目简介

这里包含了 HarmonyOS 开发的关键模块，从 UI 构建到性能优化，每个目录都是一个独立可运行的示例。

## 包含模块

目前包含的代码示例：

*   **UI 与动画 (AnimationsPage)**: 展示了 HarmonyOS 强大的动画能力，包括属性动画、转场动画等。
*   **数据持久化 (DataPage)**: 演示了如何在应用中存储和管理数据，包括首选项 (Preferences) 和数据库的使用。
*   **自定义绘制 (DrawingPage)**: 展示了 Canvas 和图形绘制能力，用于实现自定义 UI 组件。
*   **多媒体 (MediaPage)**: 涵盖了音频、视频播放及相关媒体控制功能的实现。
*   **网络通信 (NetworkPage)**: 演示了如何进行 HTTP 请求、处理网络响应及数据解析。
*   **性能优化 (PerformancePage)**: 提供了一些性能优化的最佳实践和示例，帮助提升应用流畅度。
*   **系统能力 (SystemPage)**: 展示了如何调用系统级功能，如传感器、设备信息等。
*   **Web 集成 (WebPage)**: 演示了 Web 组件的使用，实现 ArkUI 与 Web 页面的交互。

## 环境要求

*   **IDE**: DevEco Studio NEXT (建议最新版本)
*   **SDK**: HarmonyOS NEXT SDK (api 12 或更高版本)

## 快速开始

1.  **克隆项目**

    ```bash
    git clone git@github.com:briefness/HarmonyDemo.git
    ```

2.  **打开项目**
    启动 DevEco Studio，选择 "Open Project"，然后定位到 `HarmonyHub` 目录并打开。

3.  **同步依赖**
    项目打开后，DevEco Studio 会自动尝试同步项目配置。如果未自动开始，请点击工具栏上的 "Sync Now" 按钮，确保所有 NPM 依赖 (`@kit.*`) 正确解析。

4.  **运行项目**
    *   连接 HarmonyOS 真机或启动模拟器。
    *   选择 `entry` 模块。
    *   点击 "Run" 按钮 (绿色三角形) 编译并安装应用。

## 目录结构

```text
HarmonyHub/
├── entry/                  # 主入口模块
│   └── src/main/ets/
│       ├── entryability/   # 应用入口 Ability
│       ├── pages/          # 示例页面 (Animations, Data, Media 等)
│       └── utils/          # 通用工具类
├── build-profile.json5     # 构建配置文件
├── hvigorfile.ts           # 构建脚本
└── oh-package.json5        # 依赖包配置
```

## 贡献

欢迎提交 Issue 或 Pull Request 来改进代码，或者补充新的示例。

## 许可证

MIT License
