# 多级流水线cpu的实现

* 相应文件夹说明

  > * single_circle_cpu文件夹中是单周期CPU实现代码
  > * Initialize_the_pipeline_cpu是将单周期CPU改为流水线cpu的初始版本，但是未解决任何冒险
  > * data_adventures在初始版本使用数据前推和停顿解决数据冒险
  > * control_adventures在初始版本上解决控制冒险
  > * finally_pipeline_cpu最终解决控制冒险和数据冒险的流水线CPU