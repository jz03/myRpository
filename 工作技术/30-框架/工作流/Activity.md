- 工作流如何关联用户管理模块
- 工作流如何关联业务模块



# 1.基本概念

1.绘图插件

绘图插件主要用来完成工作流的设计工作

2.工作流引擎

ProcessEngine对象是工作流的引擎，是工作流的开始。负责生成各种实例、数据、监控、管理流程的运行

3.配置文件

配置工作流的基本参数和数据库连接池

4.数据库表

总共有23张表，不同的表存放不同方面的数据，有流程定义表、任务结点表、流程变量表、任务历史表等等。

所有的表都以ACT_开头，第二部分是表示表的用途的两个字母标识。用途也和服务的API对应。

- ACT_RE_*: ‘RE’表示repository。 这个前缀的表包含了流程定义和流程静态资源（图片，规则，等等）。

- ACT_RU_*: ‘RU’表示runtime。 这些运行时的表，包含流程实例，任务，变量，异步任务，等运行中的数据。 Activiti只在流程实例执行过程中保存这些数据，在流程结束时就会删除这些记录。 这样运行时表可以一直很小速度很快
- ACT_ID_*: ‘ID’表示identity。 这些表包含身份信息，比如用户，组等等。
- ACT_HI_*: ‘HI’表示history。 这些表包含历史数据，比如历史流程实例，变量，任务等等。
- ACT_GE_*: 通用数据，用于不同场景下，如存放资源文件。

5.service

- RepositoryService:流程的定义与部署
  - 查询已经部署的流程定义
  - 挂起和激活流程
  - 查询流程相关的资源信息

- RuntimeService：处理动态的流程信息，流程中经常修改的部分，与RepositoryService相反
  - 用于检索和存储流程变量
  - 查询流程实例和执行情况（流程执行到哪一步）
  - 当流程实例等待外部触发器需要继续时，将会使用runtimeService
  - 接收外部触发器发送的信号，推动流程实例继续进行下一步。
- TaskService：需要系统用户用来执行的
  - 查询分配给的用户或用户组
  - 创建新的任务，这个任务与流程实例无关
  - 将任务分配给要处理的人
  - 接受任务与完成任务

- HistoryService：引擎所生成的历史数据

​		例如流程实例的开始时间、谁执行了哪些任务、完成任务所需的时间、每个流程实例遵循的路径等等。

- IdentityService：用户身份相关的服务，不会对用户做相关的检查
- ManagementService： 可以查询数据库表与表的元数据

​		对定时job进行管理操作。如计时器、异步延续、延迟挂起/激活等

- DynamicBpmnService：更改流程定义的一部分，而不需要进行部署。



# 2 .使用指南



## 2.1 工作流引擎配置

可以时配置文件，可以是springboot的自动配置

```java
ProcessEngine processEngine = ProcessEngineConfiguration.createStandaloneInMemProcessEngineConfiguration()
  .setDatabaseSchemaUpdate(ProcessEngineConfiguration.DB_SCHEMA_UPDATE_FALSE)
  .setJdbcUrl("jdbc:h2:mem:my-own-db;DB_CLOSE_DELAY=1000")
  .setAsyncExecutorActivate(false)
  .buildProcessEngine();

```

## 2.2 创建工作流定义与部署

```java 
ProcessEngine processEngine = ProcessEngines.getDefaultProcessEngine();
RepositoryService repositoryService = processEngine.getRepositoryService();
repositoryService.createDeployment()
  .addClasspathResource("org/activiti/test/VacationRequest.bpmn20.xml")
  .deploy();

Log.info("Number of process definitions: " + repositoryService.createProcessDefinitionQuery().count());
```

## 2.3. 启动一个工作流

```java
Map<String, Object> variables = new HashMap<String, Object>();
variables.put("employeeName", "Kermit");
variables.put("numberOfDays", new Integer(4));
variables.put("vacationMotivation", "I'm really tired!");

RuntimeService runtimeService = processEngine.getRuntimeService();
ProcessInstance processInstance = runtimeService.startProcessInstanceByKey("vacationRequest", variables);

// Verify that we started a new process instance
Log.info("Number of process instances: " + runtimeService.createProcessInstanceQuery().count());
```

## 2.4.完成一个任务

### 2.4.1.用户查询所要完成的任务

```java
// Fetch all tasks for the management group
TaskService taskService = processEngine.getTaskService();
List<Task> tasks = taskService.createTaskQuery().taskCandidateGroup("management").list();
for (Task task : tasks) {
  Log.info("Task available: " + task.getName());
}
```

### 2.4.2. 用户完成一个任务

```java
Task task = tasks.get(0);

Map<String, Object> taskVariables = new HashMap<String, Object>();
taskVariables.put("vacationApproved", "false");
taskVariables.put("managerMotivation", "We have a tight deadline!");
taskService.complete(task.getId(), taskVariables);
```

## 2.5. 挂起与激活一个流程定义

挂起一个流程定义，将会使这个流程不能创建新的流程实例。

```java
repositoryService.suspendProcessDefinitionByKey("vacationRequest");
//下面将会发生异常
try {
  runtimeService.startProcessInstanceByKey("vacationRequest");
} catch (ActivitiException e) {
  e.printStackTrace();
}
```

