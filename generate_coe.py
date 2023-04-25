# coding:utf-8
import random

# 产生8192(2^13)组数据
num = 8192

# 产生对应的数据个数的测试信息
def generate_data(num):
  data_list = []
  N = 170141183460469231731687303715885907969
  for i in range(num):
    # 产生两个128位的无符号随机数(范围为0-2^128-1)A和B
    A = random.randint(0, 2**128-1)
    data_list.append(A)
    B = random.randint(0, 2**128-1)
    data_list.append(B)
    tmp = (A * B) % N
    data_list.append(tmp)    
  return data_list

# 在当前路径下生成./romdata.coe文件
def generate_coe(data_list):
  file = open('romdata.coe', 'w')
  # 十六进制表示
  file.write("memory_initialization_radix = 16;\n")
  file.write("memory_initialization_vector =\n")
  # 开始写入数据
  for data in data_list:
    # 首先将数据转换成128bit的十六进制数
    data = hex(data)
    data = str(data)

    # 去掉前缀0x
    data = data[2:]

    # 然后长度不足32要补零，超过32报错
    if len(data) > 32:
      print("ERROR:THE GENERATED NUMBER IS LARGER THAN 2^128-1!")
    elif len(data) < 32:
      times = 32-len(data)
      for j in range(times):
        data = '0' + data
    
    # 此时再判断一下长度是否为128bit
    if len(data) != 32:
      print("ERROR:THE GENERATED NUMBER IS NOT A 128-bit NUMBER!")
    
    # 写入file文件
    file.write(data)
    file.write(",\n")
  
  # 末尾加个0结束
  file.write("00000000000000000000000000000000;")
  file.close()
  return

if __name__ == '__main__':
  data_list = generate_data(num)
  generate_coe(data_list)
  print("------generation completed!------")