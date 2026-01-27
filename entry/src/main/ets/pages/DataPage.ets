import { router } from '@kit.ArkUI';
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

// V2 State Management
// V1 State Management (More stable for compiler)
@Observed
class Task {
  id: number;
  name: string;
  isFinished: boolean;

  constructor(id: number, name: string, isFinished: boolean) {
    this.id = id;
    this.name = name;
    this.isFinished = isFinished;
  }
}

@Entry
@Component
struct DataPage {
  @State tasks: Task[] = [];
  @State newTaskName: string = '';
  
  private context = getContext(this) as common.UIAbilityContext;
  private store: relationalStore.RdbStore | undefined = undefined;
  
  // Database Config
  private readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'TaskStore.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };
  
  private readonly SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS TASK (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    NAME TEXT NOT NULL,
    IS_FINISHED INTEGER DEFAULT 0
  )`;

  async aboutToAppear() {
    await this.initDb();
    await this.queryTasks();
  }

  async initDb() {
    try {
      this.store = await relationalStore.getRdbStore(this.context, this.STORE_CONFIG);
      await this.store.executeSql(this.SQL_CREATE_TABLE);
      console.info('RDB initialized');
    } catch (e) {
      console.error(`RDB init failed: ${JSON.stringify(e)}`);
    }
  }

  async addTask() {
    if (!this.store || !this.newTaskName) return;
    
    const valueBucket: ValuesBucket = {
      'NAME': this.newTaskName,
      'IS_FINISHED': 0
    };
    
    try {
      await this.store.insert('TASK', valueBucket);
      this.newTaskName = '';
      await this.queryTasks(); // Refresh list associated with UI
    } catch (e) {
      console.error(`Insert failed: ${JSON.stringify(e)}`);
    }
  }

  async queryTasks() {
    if (!this.store) return;
    
    let predicates = new relationalStore.RdbPredicates('TASK');
    // Order by ID desc
    predicates.orderByDesc('ID');
    
    let resultSet = await this.store.query(predicates);
    
    let tempTasks: Task[] = [];
    while (resultSet.goToNextRow()) {
      let id = resultSet.getLong(resultSet.getColumnIndex('ID'));
      let name = resultSet.getString(resultSet.getColumnIndex('NAME'));
      let isFinished = resultSet.getLong(resultSet.getColumnIndex('IS_FINISHED'));
      tempTasks.push(new Task(id, name, isFinished === 1));
    }
    
    // Close result set to prevent leak
    resultSet.close();
    
    this.tasks = tempTasks;
  }

  async toggleTask(task: Task) {
    if (!this.store) return;
    
    task.isFinished = !task.isFinished;
    // V1 Hack: Force UI update for nested object change in array if not using ObjectLink
    // Or just re-assign the list item if possible. 
    // For RDB demo, queries usually refresh the list anyway.
    let index = this.tasks.findIndex(t => t.id === task.id);
    if (index !== -1) {
        this.tasks[index] = new Task(task.id, task.name, task.isFinished);
    }
    
    const valueBucket: ValuesBucket = {
      'IS_FINISHED': task.isFinished ? 1 : 0
    };
    
    let predicates = new relationalStore.RdbPredicates('TASK');
    predicates.equalTo('ID', task.id);
    
    await this.store.update(valueBucket, predicates);
  }

  async deleteTask(task: Task) {
    if (!this.store) return;
    
    let predicates = new relationalStore.RdbPredicates('TASK');
    predicates.equalTo('ID', task.id);
    
    await this.store.delete(predicates);
    await this.queryTasks();
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
        Text('RDB & State V2')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding(20)
      .justifyContent(FlexAlign.Start)

      // Add Task Input
      Row() {
        TextInput({ placeholder: 'New Task...', text: this.newTaskName })
          .layoutWeight(1)
          .onChange((value: string) => {
             this.newTaskName = value;
          })
        
        Button('Add')
          .margin({ left: 10 })
          .onClick(() => {
            this.addTask();
          })
      }
      .width('100%')
      .padding({ left: 20, right: 20, bottom: 20 })

      // Task List
      List({ space: 10 }) {
        ForEach(this.tasks, (item: Task) => {
          ListItem() {
            Row() {
              Checkbox({ name: 'checkbox', group: 'tasks' })
                .select(item.isFinished)
                .onChange((value: boolean) => {
                  this.toggleTask(item);
                })
              
              Text(item.name)
                .fontSize(18)
                .margin({ left: 10 })
                .decoration({ type: item.isFinished ? TextDecorationType.LineThrough : TextDecorationType.None })
                .layoutWeight(1)
              
              Button('Delete')
                .fontColor(Color.Red)
                .backgroundColor(Color.Transparent)
                .onClick(() => {
                  this.deleteTask(item);
                })
            }
            .width('100%')
            .padding(15)
            .backgroundColor('#ffffff')
            .borderRadius(10)
          }
        })
      }
      .width('90%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f0f0f0')
  }
}
