import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct MediaPage {
  private avPlayer: media.AVPlayer | undefined = undefined;
  private surfaceId: string = '';
  private context = getContext(this) as common.UIAbilityContext;
  private controller: XComponentController = new XComponentController();
  
  @State isPlaying: boolean = false;
  @State currentTime: number = 0;
  @State duration: number = 0;
  @State sliderValue: number = 0;

  // 视频地址：使用 Zencoder 的测试视频，确保网络访问正常
  private videoUrl: string = 'http://vjs.zencdn.net/v/oceans.mp4';

  aboutToAppear(): void {
    // 页面即将显示：在此处可以检查权限，通常网络权限在模拟器默认开启，真机需要在 module.json5 声明
  }

  aboutToDisappear(): void {
    if (this.avPlayer) {
      this.avPlayer.release();
    }
  }

  async createAVPlayer() {
    try {
      this.avPlayer = await media.createAVPlayer();
      this.setAVPlayerCallback();
      this.avPlayer.url = this.videoUrl; 
    } catch (error) {
      console.error(`Failed to create AVPlayer. Code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
    }
  }

  setAVPlayerCallback() {
    if (!this.avPlayer) return;

    // 状态机回调函数
    this.avPlayer.on('stateChange', (state: media.AVPlayerState, reason: media.StateChangeReason) => {
      console.info(`AVPlayer state change: ${state}`);
      switch (state) {
        case 'idle': // 创建成功
          console.info('AVPlayer state: idle');
          // this.avPlayer.url = this.videoUrl; // Already set in createAVPlayer
          break;
        case 'initialized': // URL 已设置
          console.info('AVPlayer state: initialized');
          if (this.surfaceId && this.avPlayer) {
            this.avPlayer.surfaceId = this.surfaceId;
            this.avPlayer.prepare();
          }
          break;
        case 'prepared': // 准备就绪，可以播放
          console.info('AVPlayer state: prepared');
          if (this.avPlayer) {
             this.duration = this.avPlayer.duration;
             this.activateAudioSession(); // 激活音频会话，管理焦点
          }
          break;
        case 'playing':
          console.info('AVPlayer state: playing');
          this.isPlaying = true;
          break;
        case 'paused':
          console.info('AVPlayer state: paused');
          this.isPlaying = false;
          // this.deactivateAudioSession(); // 此处可选：暂停时是否释放焦点，视需求而定
          break;
        case 'completed':
          console.info('AVPlayer state: completed');
          this.isPlaying = false;
          this.deactivateAudioSession();
          break;
        case 'released':
          console.info('AVPlayer state: released');
          this.deactivateAudioSession();
          break;
        case 'error':
          console.error('AVPlayer state: error');
          break;
      }
    });

    // 播放进度更新回调
    this.avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
      if (this.duration > 0) {
        this.sliderValue = (this.currentTime / this.duration) * 100;
      }
    });

    this.avPlayer.on('error', (err: BusinessError) => {
       console.error(`AVPlayer error: ${err.message}`);
    });
  }
  async activateAudioSession() {
    let audioManager = audio.getAudioManager();
    let audioSessionManager = audioManager.getSessionManager();
    await audioSessionManager.activateAudioSession({
      concurrencyMode: audio.AudioConcurrencyMode.CONCURRENCY_MIX_WITH_OTHERS
    });
    console.info('AudioSession activated');
    
    // 注册音频中断回调
    audioSessionManager.on('audioSessionDeactivated', (event) => {
      console.info(`AudioSession deactivated, reason: ${event.reason}`);
      if (this.isPlaying && this.avPlayer) {
        this.avPlayer.pause();
      }
    });
  }

  async deactivateAudioSession() {
    let audioManager = audio.getAudioManager();
    let audioSessionManager = audioManager.getSessionManager();
    await audioSessionManager.deactivateAudioSession();
    console.info('AudioSession deactivated');
  }

  togglePlay() {
    if (!this.avPlayer) return;

    if (this.isPlaying) {
      this.avPlayer.pause();
    } else {
      this.avPlayer.play();
    }
  }

  seekTo(value: number) {
     if (!this.avPlayer || this.duration === 0) return;
     let targetTime = (value / 100) * this.duration;
     this.avPlayer.seek(targetTime);
  }

  formatTime(ms: number): string {
    let totalSeconds = Math.floor(ms / 1000);
    let minutes = Math.floor(totalSeconds / 60);
    let seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
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
        Text('AVPlayer Demo')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)

      // XComponent 用于视频画面渲染
      XComponent({
        id: 'video_player',
        type: XComponentType.SURFACE,
        libraryname: '',
        controller: this.controller
      })
        .onLoad(() => {
          // 通过 explicitly controller 获取 surface ID，确保在 onLoad 中可用
          this.controller.setXComponentSurfaceSize({ surfaceWidth: 1920, surfaceHeight: 1080 });
          this.surfaceId = this.controller.getXComponentSurfaceId();
          console.info(`XComponent onLoad, surfaceId: ${this.surfaceId}`);
          this.createAVPlayer();
        })
        .width('100%')
        .aspectRatio(1.77) // 16:9
        .backgroundColor('#000000')

      // 控制区域
      Column() {
        // 进度条
        Row() {
          Text(this.formatTime(this.currentTime)).fontSize(12).fontColor('#666')
          Slider({
            value: this.sliderValue,
            min: 0,
            max: 100,
            style: SliderStyle.OutSet
          })
            .layoutWeight(1)
            .margin({ left: 10, right: 10 })
            .onChange((value: number, mode: SliderChangeMode) => {
              if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
                this.seekTo(value);
              }
            })
          Text(this.formatTime(this.duration)).fontSize(12).fontColor('#666')
        }
        .width('100%').padding({ left: 20, right: 20, top: 10 })

        // 播放/暂停 按钮
        Button(this.isPlaying ? 'Pause' : 'Play')
          .width(100)
          .margin({ top: 20 })
          .onClick(() => {
            this.togglePlay();
          })
      }
    }
    .width('100%')
    .height('100%')
  }
}
