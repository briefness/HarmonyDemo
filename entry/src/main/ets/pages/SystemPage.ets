import { router } from '@kit.ArkUI';
import { taskpool } from '@kit.ArkTS';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';

import { fibonacci } from '../utils/Calc';

@Entry
@Component
struct SystemPage {
  @State fibResult: string = 'Ready to calc';
  @State isCalculating: boolean = false;
  @State locationAuthStatus: string = 'Not granted';

  async runTaskPool() {
    this.isCalculating = true;
    this.fibResult = 'Calculating Fib(40)...';
    try {
      let task = new taskpool.Task(fibonacci, 40);
      let res = await taskpool.execute(task);
      this.fibResult = `Result: ${res}`;
    } catch (e) {
      this.fibResult = `Error: ${e}`;
    } finally {
      this.isCalculating = false;
    }
  }

  async sendNotification() {
    let notificationRequest: notificationManager.NotificationRequest = {
      id: 1,
      content: {
        contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT as number,
        normal: {
          title: 'HarmonyHub System Demo',
          text: 'This is a notification from SystemPage',
          additionalText: 'It works!'
        }
      }
    };
    
    try {
      await notificationManager.publish(notificationRequest);
      console.info('Notification published');
    } catch (e) {
      console.error(`Notification failed: ${(e as BusinessError).message}`);
    }
  }

  build() {
    Column() {
      // 头部标题栏
      Row() {
        Button('Back')
          .onClick(() => {
            router.back();
          })
          .margin({ right: 20 })
        Text('System Capabilities')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)

      Column({ space: 30 }) {
        // 1. 并发 (TaskPool)
        Column() {
          Text('1. Concurrency (TaskPool)').fontWeight(FontWeight.Bold)
          Text(this.fibResult).fontSize(14).margin(10)
          Button(this.isCalculating ? 'Computing...' : 'Calc Fibonacci(40)')
            .onClick(() => {
               if(!this.isCalculating) this.runTaskPool();
            })
        }
        .padding(10)
        .backgroundColor('#e0f7fa')
        .width('90%')
        .borderRadius(10)

          // 2. 硬件 (模拟)
          Column() {
            Text('2. Hardware (Location Simulation)').fontWeight(FontWeight.Bold)
            Text(`Status: ${this.locationAuthStatus}`).margin(10)
            
            Button('Request Location')
              .onClick(() => {
                 this.locationAuthStatus = 'Granted (Simulated)';
              })
          }
          .padding(10)
          .backgroundColor('#f3e5f5')
          .width('90%')
          .borderRadius(10)

        // 3. 通知
        Column() {
          Text('3. Notification').fontWeight(FontWeight.Bold)
          Button('Send Notification')
            .margin({ top: 10 })
            .onClick(() => {
              this.sendNotification();
            })
        }
        .padding(10)
        .backgroundColor('#fff3e0')
        .width('90%')
        .borderRadius(10)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}
