# 程序功能
## generate_coe.py
该文件用于生成ROM初始化文件romdata.coe，在使用时只需在安装python3的环境中直接运行该文件即可。

如果想要改变生成的数据的个数（默认为8192（$2^{13}$）组数据），只需要打开文件，修改全局变量中的num即可。
## romdata.coe
该文件为ROM初始化文件，用于存储测试数据集，所有的数据以16进制的格式进行存储，一行为一个数据，三行为一组数据，分别为A、B以及(A\*B)%N的结果。默认情况下该文件所需要的对应ROM空间大小至少为$2^{13}$\*3\*128(位)。
## romdata_fault.coe
该文件作用同romdata.coe，但是第二组数据有误，用于测试fail信号
## montgomery_multiply.v
该文件为蒙哥马利模乘算法实现模块，首先通过直接书写(A*B)%C来简单实现
## test_multiply.v
该文件为比较模块的实现，其中存储模块用了一个rom的ip核(Xilinx Block Memory Generator)，初始化文件为romdata.coe或romdata_fault.coe
## test_montgomery_sim.v
对比较模块进行行为仿真的仿真文件

# 仿真结果说明
1. romdata_fault.coe中的第二组测试数据存在错误，此时仿真结果中应该将fail信号拉高，在遍历完所有测试数据后，done信号将拉高而pass信号将一直为低。

![图片](https://raw.githubusercontent.com/yggycs/Montgomery_multiply/main/%E6%B5%8B%E8%AF%95%E7%BB%93%E6%9E%9C1.png)

![图片](https://raw.githubusercontent.com/yggycs/Montgomery_multiply/main/%E6%B5%8B%E8%AF%95%E7%BB%93%E6%9E%9C2.png)

2. romdata.coe中所有数据都是正确的，在遍历完所有测试数据后，done信号和pass将拉高

![图片](https://raw.githubusercontent.com/yggycs/Montgomery_multiply/main/%E6%B5%8B%E8%AF%95%E7%BB%93%E6%9E%9C3.png)
