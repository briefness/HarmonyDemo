import { router } from '@kit.ArkUI';

@Entry
@Component
struct AnimationsPage {
  // 1. Implicit Animation State
  @State scaleValue: number = 1;
  
  // 2. Explicit Animation State
  @State explicitY: number = 0;
  @State explicitColor: Color = Color.Blue;

  // 3. Shared Element State
  @State isExpanded: boolean = false;

  build() {
    Scroll() {
      Column({ space: 20 }) {
        // Header
        Row() {
          Button('Back')
            .onClick(() => {
              router.back();
            })
            .margin({ right: 20 })
          Text('Animations & Transitions')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .padding(20)
        .justifyContent(FlexAlign.Start)

        // 1. Implicit Animation
        Column() {
          Text('1. Implicit Animation (.animation)')
            .fontWeight(FontWeight.Bold)
            .width('100%')
          
          Button('Click to Scale')
            .onClick(() => {
              this.scaleValue = this.scaleValue === 1 ? 1.5 : 1;
            })
            .margin({ top: 10, bottom: 10 })

          Image($r('app.media.startIcon')) // Using startIcon as placeholder
            .width(50)
            .height(50)
            .scale({ x: this.scaleValue, y: this.scaleValue })
            .animation({
              duration: 1000,
              curve: Curve.EaseOut,
              iterations: 1,
              playMode: PlayMode.Normal
            })
            .backgroundColor(Color.Gray) // Fallback if image not found
        }
        .padding(10)
        .backgroundColor('#f0f0f0')
        .width('90%')
        .borderRadius(10)

        // 2. Explicit Animation
        Column() {
          Text('2. Explicit Animation (animateTo)')
            .fontWeight(FontWeight.Bold)
            .width('100%')
          
          Button('Run Animation')
            .onClick(() => {
              animateTo({ duration: 500, curve: Curve.FastOutSlowIn }, () => {
                this.explicitY = this.explicitY === 0 ? 100 : 0;
                this.explicitColor = this.explicitColor === Color.Blue ? Color.Red : Color.Blue;
              })
            })
            .margin({ top: 10, bottom: 10 })

          Rect()
            .width(50)
            .height(50)
            .fill(this.explicitColor)
            .translate({ x: 0, y: this.explicitY })
        }
        .padding(10)
        .backgroundColor('#e0e0e0')
        .width('90%')
        .height(200) // Fixed height to allow movement
        .borderRadius(10)
        .alignItems(HorizontalAlign.Start)

        // 3. Shared Element Transition
        Column() {
          Text('3. Shared Element (geometryTransition)')
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .margin({ bottom: 10 })

          if (!this.isExpanded) {
            // State A
            Row() {
              Image($r('app.media.startIcon'))
                .width(50)
                .height(50)
                .geometryTransition('shared_icon')
              
              Text('Click to Expand')
                .margin({ left: 10 })
            }
            .width('100%')
            .onClick(() => {
              animateTo({ duration: 300 }, () => {
                this.isExpanded = true;
              })
            })
          } else {
            // State B
            Column() {
              Image($r('app.media.startIcon'))
                .width(150)
                .height(150)
                .geometryTransition('shared_icon')
              
              Text('Expanded View (Click to Shrink)')
                .margin({ top: 10 })
            }
            .width('100%')
            .onClick(() => {
              animateTo({ duration: 300 }, () => {
                this.isExpanded = false;
              })
            })
          }
        }
        .padding(10)
        .backgroundColor('#d0d0d0')
        .width('90%')
        .borderRadius(10)

        // 4. Particle Effect
        Column() {
          Text('4. Particle Effect')
            .fontWeight(FontWeight.Bold)
            .width('100%')
          
          // Using a placeholder box as simple Particle component might be complex to configure without assets
          // Emulating behavior or using simple Circle particles
          
           Particle({ particles: [
            {
              emitter: {
                particle: {
                  type: ParticleType.POINT,
                  config: {
                    radius: 5
                  },
                  count: 100,
                  lifetime: 5000,
                  lifetimeRange: 0
                },
                emitRate: 10,
                position: [0, 0],
                size: [300, 200]
              },
              color: {
                range: [Color.White, Color.White],
                distributionType: DistributionType.UNIFORM
              }
            }
          ] })
          .width(300)
          .height(200)
          .backgroundColor(Color.Black)
        }
        .padding(10)
        .width('90%')
        .borderRadius(10)
        .margin({ bottom: 50 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}
