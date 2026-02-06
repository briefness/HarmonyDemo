import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct SmartFeaturesPage {
  // Live View State
  @State isLiveViewActive: boolean = false;
  @State liveViewTime: number = 0;
  @State liveViewInterval: number = -1;

  // AI Vision State
  @State recognizedText: string = '';
  @State isScanning: boolean = false;

  // AI Speech State
  @State speechText: string = '';
  @State isListening: boolean = false;

  toggleLiveView() {
    if (this.isLiveViewActive) {
      clearInterval(this.liveViewInterval);
      this.isLiveViewActive = false;
      this.liveViewTime = 0;
    } else {
      this.isLiveViewActive = true;
      this.liveViewInterval = setInterval(() => {
        this.liveViewTime++;
      }, 1000);
      promptAction.showToast({ message: 'Live View Started (Simulated)' });
    }
  }

  simulateOCR() {
    this.isScanning = true;
    setTimeout(() => {
      this.recognizedText = 'HarmonyOS NEXT\nVersion: 4.0.0\nID: 8888 8888';
      this.isScanning = false;
    }, 1500);
  }

  toggleSpeech() {
    if (this.isListening) {
      this.isListening = false;
      this.speechText = 'This is the simulated result of speech recognition.';
    } else {
      this.isListening = true;
      this.speechText = 'Listening...';
    }
  }

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
        Text('Smart Features')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .padding({ left: 10 })
      .backgroundColor('#ffffff')

      List({ space: 20 }) {
        // 1. Live View Simulation
        ListItem() {
          Column() {
            Text('1. Live View (实况窗)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('100%')
            
            Text('Simulates a capsule/card for long-running tasks.')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 })
              .width('100%')

            Button(this.isLiveViewActive ? 'Stop Live View' : 'Start Live View (Timer)')
              .onClick(() => this.toggleLiveView())
              .width('100%')
              .backgroundColor(this.isLiveViewActive ? Color.Red : Color.Blue)
            
            if (this.isLiveViewActive) {
              // Simulated Capsule
              Row() {
                 Image($r('app.media.startIcon')) // Using default icon
                   .width(24)
                   .height(24)
                   .borderRadius(12)
                 Text(`Recording: 00:${this.liveViewTime.toString().padStart(2, '0')}`)
                   .margin({ left: 10 })
                   .fontColor(Color.White)
                   .fontWeight(FontWeight.Medium)
              }
              .width('60%')
              .height(36)
              .margin({ top: 15 })
              .padding({ left: 10, right: 10 })
              .backgroundColor('#FF5500')
              .borderRadius(18)
              .shadow({ radius: 5 })
            }
          }
          .padding(15)
          .backgroundColor('#ffffff')
          .borderRadius(12)
        }

        // 2. AI Vision (VisionKit)
        ListItem() {
          Column() {
            Text('2. AI Vision (VisionKit)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('100%')

            Text('Simulates OCR text recognition.')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 })
              .width('100%')

            // Placeholder Image area
            Stack() {
              Rect()
                .width('100%')
                .height(120)
                .fill('#e0e0e0')
                .radius(8)
              Text('ID Card Image')
                .fontColor('#888')
            }
            .margin({ bottom: 10 })

            Button(this.isScanning ? 'Scanning...' : 'Recognize Text')
              .enabled(!this.isScanning)
              .onClick(() => this.simulateOCR())
              .width('100%')
            
            if (this.recognizedText) {
              Text('Result:')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 10 })
              Text(this.recognizedText)
                .backgroundColor('#f9f9f9')
                .width('100%')
                .padding(10)
                .margin({ top: 5 })
                .borderRadius(4)
            }
          }
          .padding(15)
          .backgroundColor('#ffffff')
          .borderRadius(12)
        }

        // 3. AI Speech (CoreSpeechKit)
        ListItem() {
          Column() {
            Text('3. AI Speech (CoreSpeechKit)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .width('100%')

            Text('Simulates speech-to-text.')
              .fontSize(14)
              .fontColor(Color.Gray)
              .margin({ bottom: 10 })
              .width('100%')

            Button(this.isListening ? 'Stop Listening' : 'Start Listening')
              .onClick(() => this.toggleSpeech())
              .width('100%')
              .backgroundColor(this.isListening ? Color.Red : Color.Blue)
              
            Text(this.speechText)
              .fontSize(16)
              .fontColor(this.isListening ? Color.Green : Color.Black)
              .margin({ top: 15 })
              .width('100%')
              .textAlign(TextAlign.Center)
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
