# 程序功能
## generate_coe.py
该文件用于生成ROM初始化文件romdata.coe，在使用时只需在安装python3的环境中直接运行该文件即可。

如果想要改变生成的数据的个数（默认为8192（$2^{13}$）组数据），只需要打开文件，修改全局变量中的num即可。
## romdata.coe
该文件为ROM初始化文件，用于存储测试数据集，所有的数据以16进制的格式进行存储，一行为一个数据，三行为一组数据，分别为A、B以及(A\*B)%N的结果。默认情况下该文件所需要的对应ROM空间大小至少为$2^{13}$\*3\*128(位)。
## montgomery_multiply.v
该文件为蒙哥马利模乘算法实现模块，首先通过直接书写(A*B)%C来简单实现
## test_multiply.v
该文件为比较模块的实现，其中存储模块用了一个rom的ip核，初始化文件为romdata.coe
## test_montgomery_sim.v
对比较模块进行行为仿真的仿真文件
## 部分仿真截图.PNG
展示了部分的仿真结果

![图片](https://raw.githubusercontent.com/yggycs/Montgomery_multiply/main/%E9%83%A8%E5%88%86%E4%BB%BF%E7%9C%9F%E6%88%AA%E5%9B%BE.PNG)
