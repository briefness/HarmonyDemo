import { router } from '@kit.ArkUI';

@Entry
@Component
struct DrawingPage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private offscreenCanvas: OffscreenCanvas = new OffscreenCanvas(300, 300);
  private offCanvas: OffscreenCanvasRenderingContext2D = this.offscreenCanvas.getContext('2d', this.settings);
  @State percent: number = 0;
  private intervalId: number = -1;
  private isOffscreenDrawn: boolean = false;

  aboutToAppear() {
    this.intervalId = setInterval(() => {
      this.percent = (this.percent + 1) % 100;
      this.draw();
    }, 50);
  }

  aboutToDisappear() {
    clearInterval(this.intervalId);
  }

  drawBackground() {
    let width = this.context.width;
    let height = this.context.height;
    // Ensure offscreen dimensions match
    this.offscreenCanvas.width = width;
    this.offscreenCanvas.height = height;

    let centerX = width / 2;
    let centerY = height / 2;
    let radius = Math.min(width, height) / 3;

    this.offCanvas.beginPath();
    this.offCanvas.arc(centerX, centerY, radius, 0, 2 * Math.PI);
    this.offCanvas.lineWidth = 20;
    this.offCanvas.strokeStyle = '#f0f0f0';
    this.offCanvas.stroke();
    
    this.isOffscreenDrawn = true;
  }

  draw() {
    let width = this.context.width;
    let height = this.context.height;

    // First time init offscreen background
    if (!this.isOffscreenDrawn && width > 0 && height > 0) {
        this.drawBackground();
    }

    // Clear main canvas
    this.context.clearRect(0, 0, width, height);

    // 1. Draw static background from offscreen canvas
    if (this.isOffscreenDrawn) {
        let image = this.offCanvas.transferToImageBitmap();
        this.context.transferFromImageBitmap(image);
    }
    
    // Center coordinates
    let centerX = width / 2;
    let centerY = height / 2;
    let radius = Math.min(width, height) / 3;

    // 2. Draw dynamic progress arc
    this.context.beginPath();
    let startAngle = -Math.PI / 2;
    let endAngle = startAngle + (this.percent / 100) * 2 * Math.PI;
    
    this.context.arc(centerX, centerY, radius, startAngle, endAngle);
    this.context.lineWidth = 20; // Re-set line width as clearRect might reset context state in some implementations, best to be safe
    
    // Create gradient
    let grad = this.context.createLinearGradient(centerX - radius, centerY - radius, centerX + radius, centerY + radius);
    grad.addColorStop(0.0, '#00c6ff');
    grad.addColorStop(1.0, '#0072ff');
    
    this.context.strokeStyle = grad;
    this.context.stroke();

    // Draw text
    this.context.font = '40vp sans-serif';
    this.context.fillStyle = '#333333';
    this.context.textAlign = 'center';
    this.context.textBaseline = 'middle';
    this.context.fillText(`${this.percent}%`, centerX, centerY);
  }

  build() {
    Column() {
      // Header
      Row() {
        Button('Back')
          .onClick(() => {
            router.back();
          })
          .margin({ right: 20 })
        Text('Canvas Drawing')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)

      // Canvas
      Canvas(this.context)
        .width('100%')
        .height('60%')
        .backgroundColor('#ffffff')
        .onReady(() => {
          this.draw();
        })
    }
    .width('100%')
    .height('100%')
  }
}
