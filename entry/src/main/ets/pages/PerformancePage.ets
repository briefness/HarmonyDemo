import { BasicDataSource } from '../utils/BasicDataSource';

class ItemData {
  id: string;
  title: string;
  detail: string;
  color: Color;

  constructor(id: string, title: string, detail: string, color: Color) {
    this.id = id;
    this.title = title;
    this.detail = detail;
    this.color = color;
  }
}

@Entry
@Component
struct PerformancePage {
  @State isOptimized: boolean = false;
  private data: ItemData[] = [];
  private dataSource: BasicDataSource<ItemData> = new BasicDataSource([]);

  aboutToAppear() {
    for (let i = 0; i < 5000; i++) {
      this.data.push(new ItemData(
        `id_${i}`,
        `List Item ${i}`,
        `Detailed description for item ${i}. This is a long text to simulate content rendering.`,
        i % 2 === 0 ? Color.Blue : Color.Orange
      ));
    }
    this.dataSource = new BasicDataSource(this.data);
  }

  build() {
    Column() {
      // Control Panel
      Row() {
        Column() {
          Text("Performance Lab")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Text(this.isOptimized ? "Mode: Optimized (Lazy + Reuse)" : "Mode: Standard (Slow)")
            .fontSize(14)
            .fontColor(this.isOptimized ? '#007DFF' : '#FF0000')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        
        Blank()

        Toggle({ type: ToggleType.Switch, isOn: this.isOptimized })
          .onChange((isOn) => {
            this.isOptimized = isOn;
          })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F1F3F5')
      .shadow({ radius: 4, color: '#20000000', offsetY: 2 })

      // Content Area
      if (this.isOptimized) {
        // ✅ Optimized: LazyForEach + CachedCount + Reusable + Flat Layout
        List() {
          LazyForEach(this.dataSource, (item: ItemData) => {
            ListItem() {
              ReusableCard({ item: item })
            }
          }, (item: ItemData) => item.id)
        }
        .cachedCount(4) // Prepare 4 items off-screen
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#EEEEEE' })
      } else {
        // ❌ Unoptimized: ForEach + Deep Nesting + No Reuse
        List() {
          ForEach(this.data, (item: ItemData) => {
            ListItem() {
              SlowCard({ item: item })
            }
          }, (item: ItemData) => item.id)
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#EEEEEE' })
      }
    }
    .width('100%')
    .height('100%')
  }
}

// ❌ "Slow" Component: Deep nesting, no reuse
@Component
struct SlowCard {
  @Prop item: ItemData; // Passing data as Prop (potentially copying)

  build() {
    // Artificial deep hierarchy to increase Measure/Layout time
    Stack() {
      Column() {
        Row() {
          Column() {
            Row() {
              Column() {
                Text(this.item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
              }
            }
          }
        }
        .margin({ bottom: 5 })

        Text(this.item.detail)
          .fontSize(14)
          .fontColor(Color.Gray)
      }
      .alignItems(HorizontalAlign.Start)
      .padding(12)
    }
    .width('100%')
  }
}

// ✅ "Fast" Component: Flat layout, @Reusable
@Component
@Reusable
struct ReusableCard {
  @State item: ItemData = new ItemData('', '', '', Color.Black);

  // Triggered when component is recycled from the pool
  aboutToReuse(params: Record<string, Object>) {
    this.item = params.item as ItemData;
  }

  build() {
    // Flat layout using Row/Column efficiently
    Row() {
      // Visual indicator
      Circle({ width: 40, height: 40 })
        .fill(this.item.color)
        .margin({ right: 12 })

      Column() {
        Text(this.item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        
        Text(this.item.detail)
          .fontSize(14)
          .fontColor(Color.Gray)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
    }
    .width('100%')
    .height(70)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
  }
}
