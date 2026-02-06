import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'HarmonyHub Demos';

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 50, bottom: 30 })

      List({ space: 15 }) {
        ListItem() {
          Button('Drawing Demo (Canvas)')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/DrawingPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Media Demo (AVPlayer)')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/MediaPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Web Demo (Hybrid)')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/WebPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Animations Demo (Article 5)')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/AnimationsPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Network (RCP) Demo')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/NetworkPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Data (RDB/StateV2) Demo')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/DataPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('System (TaskPool/Noti) Demo')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/SystemPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Performance (Lazy/Reuse) Demo')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/PerformancePage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Unique Interactions Demo (Art. 7)')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/UniqueInteractionsPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)

        ListItem() {
          Button('Smart Features Demo (Art. 8)')
            .width('80%')
            .height(50)
            .onClick(() => {
              router.pushUrl({ url: 'pages/SmartFeaturesPage' });
            })
        }
        .width('100%')
        .align(Alignment.Center)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
}