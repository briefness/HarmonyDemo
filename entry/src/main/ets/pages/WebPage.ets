import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

// Define the bridge class
class Bridge {
  callNative(msg: string): string {
    return "Native received: " + msg;
  }
}

@Entry
@Component
struct WebPage {
  private controller: webview.WebviewController = new webview.WebviewController();
  @State logs: string = 'Logs will appear here...';

  build() {
    Column() {
      // Header
      Row() {
        Button('Back')
          .onClick(() => {
            router.back();
          })
          .margin({ right: 20 })
        Text('Web Hybrid Demo')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)

      // Controls
      Row() {
        Button('Change H5 to Red')
          .onClick(() => {
            // Call H5 function
            this.controller.runJavaScript("changeColor('#ffcccc')", (error: BusinessError, result: string) => {
              if (error) {
                 this.logs = `RunJS Error: ${JSON.stringify(error)}`;
              } else {
                 this.logs = `RunJS Result: ${result}`;
              }
            });
          })
          .margin({ right: 10 })
        
        Button('Change H5 to Blue')
          .onClick(() => {
            this.controller.runJavaScript("changeColor('#ccccff')");
          })
      }
      .margin({ bottom: 10 })

      Text(this.logs)
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ bottom: 10 })

      // Web Component
      Web({ src: $rawfile('index.html'), controller: this.controller })
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .onControllerAttached(() => {
           // Register JS Proxy
           // parameters: object, name in window, methods list
           this.controller.registerJavaScriptProxy(new Bridge(), "bridge", ["callNative"]);
           this.controller.refresh(); // Refresh to ensure proxy is injected if needed at earliest stage
        })
        .onInterceptRequest((event) => {
          if (event.request.getRequestUrl().includes('logo.png')) {
             console.info('Intercepted request for logo.png');
             // Return a mock response or nothing to block it
             let response = new WebResourceResponse();
             response.setResponseData('Mock Data'); // Just text for demo
             response.setResponseEncoding('utf-8');
             response.setResponseMimeType('text/plain');
             response.setResponseCode(200);
             response.setReasonMessage('OK');
             return response;
          }
          return null;
        })
        .width('100%')
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}
