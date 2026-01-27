// 标准卡片入口组件
let storage = new LocalStorage();

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('title') title: string = 'HarmonyHub';
  @LocalStorageProp('detail') detail: string = '原子化服务就绪';

  build() {
    Column() {
      Row() {
        Image($r('app.media.startIcon'))
          .width(24)
          .height(24)
          .margin({ right: 10 })
        Text(this.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .margin({ bottom: 5 })

      Text(this.detail)
        .fontSize(14)
        .opacity(0.6)
        
      // 使用 postCardAction 实现交互
      Button('Refresh')
        .fontSize(12)
        .height(28)
        .margin({ top: 10 })
        .onClick(() => {
          let params: Record<string, string> = {
            'targetPage': 'index'
          };
          postCardAction(this, {
            'action': 'router',
            'abilityName': 'EntryAbility',
            'params': params
          });
        })
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#ffffff')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Start)
  }
}
