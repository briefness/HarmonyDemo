import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct UniqueInteractionsPage {
  @State isFlashBallEnabled: boolean = false;
  @State gripStatus: string = 'Unknown'; // Unknown, Left, Right
  @State isSharing: boolean = false;

  build() {
    Column() {
      // Header
      Row() {
        Button('< Back')
          .onClick(() => {
            router.back();
          })
          .backgroundColor(Color.Transparent)
          .fontColor(Color.Blue)
        Text('Unique Interactions')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .padding({ left: 10 })
      .backgroundColor('#ffffff')

      List({ space: 20 }) {
        // 1. Flash Control Ball Simulation
        ListItem() {
          Column() {
            Text('1. Flash Control Ball (闪控球)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('100%')
            
            Text('Simulates enabling a global floating bubble.')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 })
              .width('100%')

            Button(this.isFlashBallEnabled ? 'Disable Flash Ball' : 'Enable Flash Ball')
              .onClick(() => {
                this.isFlashBallEnabled = !this.isFlashBallEnabled;
                if (this.isFlashBallEnabled) {
                  promptAction.showToast({ message: 'Flash Ball API called (Simulation)' });
                }
              })
              .width('100%')
              .backgroundColor(this.isFlashBallEnabled ? Color.Red : Color.Blue)
            
            if (this.isFlashBallEnabled) {
              // Simulated Floating Ball (In-app representation)
              Row() {
                 Image($r('app.media.startIcon')) // Using default icon as placeholder
                   .width(40)
                   .height(40)
                   .borderRadius(20)
                 Text('Order: #1234')
                   .margin({ left: 10 })
                   .fontColor(Color.White)
              }
              .margin({ top: 10 })
              .padding(10)
              .backgroundColor(Color.Black)
              .borderRadius(30)
              .shadow({ radius: 10, color: Color.Gray })
            }
          }
          .padding(15)
          .backgroundColor('#ffffff')
          .borderRadius(12)
        }

        // 2. Smart Sensing (Grip Detection)
        ListItem() {
          Column() {
            Text('2. Smart Grip (智感握姿)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('100%')

            Text('Simulates hand detection provided by MultimodalAwarenessKit.')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 })
              .width('100%')

            Row() {
              Button('Left Hand')
                .onClick(() => this.gripStatus = 'Left')
                .backgroundColor(this.gripStatus === 'Left' ? Color.Green : Color.Gray)
              Button('Right Hand')
                .onClick(() => this.gripStatus = 'Right')
                .backgroundColor(this.gripStatus === 'Right' ? Color.Green : Color.Gray)
                .margin({ left: 10 })
            }
            .margin({ bottom: 10 })

            // Adaptive UI based on grip
            Row() {
              if (this.gripStatus === 'Right') {
                Blank()
              }
              Button('Smart Action')
                .type(ButtonType.Circle)
                .width(60)
                .height(60)
                .backgroundColor(Color.Orange)
              if (this.gripStatus === 'Left') {
                Blank()
              }
            }
            .width('100%')
            .backgroundColor('#f0f0f0')
            .padding(10)
            .borderRadius(8)
            
            Text(`Current Grip: ${this.gripStatus}`)
              .margin({ top: 5 })
          }
          .padding(15)
          .backgroundColor('#ffffff')
          .borderRadius(12)
        }

        // 3. OneHop (Touch to Share)
        ListItem() {
          Column() {
            Text('3. OneHop (碰一碰)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('100%')

            Text('Simulates NFC OneHop event.')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 })
              .width('100%')

            Button(this.isSharing ? 'Sharing...' : 'Simulate NFC Tap')
              .onClick(() => {
                this.isSharing = true;
                setTimeout(() => {
                  this.isSharing = false;
                  promptAction.showToast({ message: 'Content shared to MatePad!' });
                }, 1500);
              })
              .width('100%')
              
            if (this.isSharing) {
               LoadingProgress()
                 .width(40)
                 .height(40)
                 .margin({ top: 10 })
            }
          }
          .padding(15)
          .backgroundColor('#ffffff')
          .borderRadius(12)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding(15)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }
}
