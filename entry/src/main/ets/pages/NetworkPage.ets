import { rcp } from '@kit.RemoteCommunicationKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct NetworkPage {
  @State result: string = 'Ready to fetch data...';
  @State isLoading: boolean = false;
  
  // 1. 创建会话 (最佳实践：在真实应用中应作为单例使用)
  private session: rcp.Session = rcp.createSession({
    requestConfiguration: {
      transfer: { 
        timeout: { 
          connectMs: 10000, // 连接超时调整为10秒
          transferMs: 10000
        } 
      }
    }
  });

  async fetchData() {
    this.isLoading = true;
    this.result = 'Loading...';
    
    try {
      // 2. 创建请求
      const req = new rcp.Request('https://jsonplaceholder.typicode.com/todos/1', 'GET');
      
      // 3. 发起请求
      const resp = await this.session.fetch(req);
      
      if (resp.statusCode === 200) {
        // 4. 处理数据
        const data: object = resp.toJSON() as object; 
        this.result = JSON.stringify(data, null, 2);
      } else {
        this.result = `Error: Status ${resp.statusCode}`;
      }
    } catch (e) {
      this.result = `Exception: ${JSON.stringify(e)}`;
    } finally {
      this.isLoading = false;
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
        Text('RCP Network Demo')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)

      Column({ space: 20 }) {
        Button(this.isLoading ? 'Fetching...' : 'Fetch Data (GET)')
          .onClick(() => {
            if (!this.isLoading) {
              this.fetchData();
            }
          })
          .width('80%')

        TextArea({ text: this.result })
          .width('90%')
          .height(300)
          .backgroundColor('#f5f5f5')
          .fontSize(14)
      }
      .width('100%')
      .padding(20)
    }
    .width('100%')
    .height('100%')
  }
}
