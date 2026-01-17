<img width="1440" height="1001" alt="image" src="https://github.com/user-attachments/assets/48b68dfa-a8f0-4631-88e6-23a4c1cf6c95" /># NaI-Tl-scintillator-gamma-ray-Digital-Multi-Channel-Analyzer
The portable NaI(Tl) scintillation energy spectrum measurement system can accurately measure gamma rays in the environment, statistically provide radiation energy distribution, and assist in identifying radiation sources and intensities. Due to its portability and low cost, it can provide support for radiation monitoring and other applications.

# Portable NaI(Tl) Scintillator Gamma-ray Spectrometer System

便携式 **NaI(Tl) 闪烁体环境伽玛射线能谱测量系统**。  
这是一个完整开源的伽玛射线能谱仪项目，涵盖硬件、电路、FPGA 逻辑以及 PC 上位机软件。

项目原始发布于 OSHWHUB：  
https://oshwhub.com/steve-don/portable-naitl-scintillator-ambi

---

## ✨ Features

- 基于 **NaI(Tl) 闪烁体 + PMT** 的环境伽玛射线能谱测量
- 便携式设计，适合现场与环境监测
- 完整开源：硬件 + FPGA + 上位机软件
- Zynq-7020 SoC 作为核心采集与处理平台
- FPGA 实现多道能谱统计（最高 16384 道）
- Qt 编写的 PC 上位机，实时显示与控制
- 成本可控，适合复刻与二次开发

---

## 🧠 Overview

该系统通过 NaI(Tl) 闪烁体探头将伽玛射线转换为电脉冲信号，经模拟前端放大后，由 ADC 采集进入 Zynq FPGA。  
FPGA 完成脉冲提取、梯形成形、能量计算与多道分析（MCA），最终由 PS 端串口上传至 PC 上位机进行显示与存储。

---

## 🎯 Application Scenarios

- 环境辐射水平监测
- 个人辐射防护
- 放射源定位与排查
- 放射性矿物与地质勘探
- 教学、科研与开源项目演示

---

## 🔧 Technologies Used

- **NaI(Tl) Scintillator + PMT**
- **Zynq-7020 SoC**
- **Vivado 2022.2**
- **Vitis 2022.2**
- **MATLAB 2021b**
- **Qt 5.14.2**
- 高压 PMT 供电模块
- 模拟前端（前置放大、滤波、成形）

---

## 🧩 Hardware Architecture

系统主要由以下部分组成：

1. NaI(Tl) 闪烁晶体 + 光电倍增管（PMT）
2. 高压电源模块（PMT 偏置）
3. 模拟前端电路  
   - 电荷放大  
   - 成形与滤波  
4. ADC 数据采集
5. Zynq FPGA  
   - 脉冲检测  
   - 数字成形  
   - 峰值提取  
   - 多道能谱统计  
6. ARM / PC 上位机软件
7. 外壳（PVC / 3D 打印）

---

## ⚙️ FPGA Processing Flow

- ADC 数据采集
- 数字滤波
- 脉冲触发与堆积判断
- 梯形成形（Trapezoidal Shaping）
- 峰值搜索
- MCA 统计（最多 16384 Channels）

---

## 💻 PC Software

PC 上位机基于 **Qt** 开发，主要功能包括：

- 实时能谱显示
- 参数配置
- 数据保存与导出
- 历史数据回放

---

## 📁 Repository Structure


---

## 📜 License

This project is released under:

**CC BY-NC-SA 4.0**  
(Attribution – NonCommercial – ShareAlike)

*** The project was completed independently by me and has been fully open-sourced, without involving any issues such as illegal theft of achievements, academic misconduct, or exposure of non-public information. If you have any questions, please contact me via email（tangzhijie@mail.ustc.edu.cn）.
*** Once again, it is strictly prohibited to use any achievements of this project for personal scientific research papers (please indicate the citation) or commercial profit-making activities. Once discovered, we will pursue accountability to the end!

Please credit the original author when using or modifying this project.

---

## 🙌 Contribution

欢迎对以下方向感兴趣的开发者参与贡献：

- 核辐射测量与 MCA 算法
- FPGA / SoC 数据采集系统
- 模拟前端优化
- Android / 嵌入式终端显示
- 机械与工业设计优化

Issues & Pull Requests 都非常欢迎！

---

## 📎 Acknowledgements

Original project published on **OSHWHUB**  
Original WebSite: https://oshwhub.com/steve-don/portable-naitl-scintillator-ambi
Author: Steve Don
