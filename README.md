# 流水线CPU实现
## 相关文件说明
> * single-circle-cpu是一个单周期cpu的实现
> * Initialize_the_pipeline_cpu是流水线CPU的初步实现，但是未解决相关的冒险操作
> * data_adventures在Initialize_the_pipeline_cpu的基础上采用数据前推和停顿解决数据冒险
> * control_adventures在Initialize_the_pipeline_cpu的基础上解决控制冒险
> * finally_pipeline_cpu解决了数据冒险和控制冒险
