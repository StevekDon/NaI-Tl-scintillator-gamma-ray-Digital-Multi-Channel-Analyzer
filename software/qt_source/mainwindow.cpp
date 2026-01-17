#include "mainwindow.h"
#include "ui_mainwindow.h"

#define CHANNELCNT  16384
#define BYTESCNT    16384*4 + 16 +2

/* variable */
uint* org_data = new uint[CHANNELCNT]();

QStringList portName, portNum;  //存储串口设备名和端口号

bool measureStartButton_flag = false, serialpushButton_flag = false;

bool readLiveTime_flag = false; //用于区分读数据和读活时间的标志

uint serialPortDevIndex = 0, serialPortBpsIndex = 460800;

uint params[8] = {0};

uint timer_count = 0, ms_remain_Time = 0;

uint MsLiveTime = 0;

float MsLiveCPS = 0;
/* END */

#define	CMD_MS_START				0x000000f0
#define	CMD_MS_STOP					0x000000f1
#define	CMD_MS_READ					0x000000f2
#define	CMD_TM_READ					0x000000f3
#define	CMD_ZYNQ_RESET				0x000000e0
#define	CMD_PARAM_NA				0x000000d0
#define	CMD_PARAM_NB				0x000000d1
#define	CMD_PARAM_D					0x000000d2
#define	CMD_PARAM_PEAK_THD			0x000000d3
#define	CMD_PARAM_PEAK_THD_CNT		0x000000d4
#define	CMD_PARAM_PEAK_TOP_DLY		0x000000d5


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QWidget *widget = new QWidget (this);
    widget -> setLayout(ui->horizontalLayout);
    this -> setCentralWidget(widget);
    QWidget::showMaximized();

    CfgFileRead();  //读取配置文件
    TimerInit(1000);    //初始化定时器ms
    showSerialPort();

    ui->progressBar_Time->setValue(0);
    ui->label_B_Time->setText(" 剩余时间：" + QString::number(0) + "s");
    ui->label_B_cpsTi->setText(" 实时计数率：");
    ui->label_B_cps->setText(QString::number(0) + " cps");
    std::fill(org_data, org_data + CHANNELCNT, 0); //复位原始能谱数组数据
    ChartInit(); //初始化折线图

    //信号槽
    connect(&serial, &QSerialPort::readyRead, this, &MainWindow::handleData);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::TimerInit(quint32 cycle)
{
    connect(&timer0, SIGNAL(timeout()), this, SLOT(on_Timeout())); //定时器中断槽函数
    timer0.start(cycle); // 设置定时器为cycle ms触发一次
    timer0.stop();  //仅在测量时启用定时器
}

void MainWindow::on_Timeout()   //定时器中断槽
{
    timer_count++;

    ui->progressBar_Time->setValue(timer_count / (float)params[0] * 100);
    ui->label_B_Time->setText(" 剩余时间：" + QString::number(params[0] - timer_count) + "s");
    ms_remain_Time = params[0]-timer_count;

    if(timer_count >= params[0]) // 定时结束
    {
        serialSend8Bytes(CMD_MS_STOP, 0x00000000);  // 向设备发送 停止测量指令
        timer0.stop();
        ui->pushButton_StartMs->setText("开始测量");
        ui->pushButton_StartMs->setStyleSheet( "QPushButton { background-color: #00CC00 }" );

        measureStartButton_flag = 0;
        timer_count = 0;

        // 显示等待对话框
        QMessageBox* msgBox = new QMessageBox(
                    QMessageBox::Information,
                    "提示",
                    "正在获取活时间，请稍等片刻...",
                    QMessageBox::NoButton,
                    this
                    );
        msgBox->setAttribute(Qt::WA_DeleteOnClose); // 自动释放
        msgBox->setWindowFlags(Qt::Dialog | Qt::CustomizeWindowHint); // 无关闭按钮
        QPushButton *okBtn = msgBox->addButton("确定", QMessageBox::AcceptRole); // 自定义文本[2](@ref)
        okBtn->setEnabled(false);
        msgBox->show();

        // 单次定时器发送指令
        QTimer::singleShot(2500, this, [this, msgBox]() {
            msgBox->close();
            readLiveTime_flag = 1;
            serialSend8Bytes(CMD_TM_READ, 0x00000000);
        });
    }
}

//创建图表
void MainWindow::ChartInit()
{
    int i = 0;

    // 创建字体对象，并设置为微软雅黑和特定大小
    QFont font = QFontDatabase::systemFont(QFontDatabase::GeneralFont);
    font.setFamily("Microsoft YaHei"); // 设置字体为微软雅黑
    font.setPointSize(10); // 设置字体大小为12点

    //2. 创建图表
    chart = new QChart();
    //3. 创建坐标系
    axisX = new QValueAxis();
    axisY = new QValueAxis();
    axisXE = new QValueAxis(); //能量轴

    //4. 设置坐标轴范围, 标题及显示格式
    axisX->setRange(0, CHANNELCNT - 1);
    axisX->setTickCount(17); //设置刻度分割网格数目
    axisY->setRange(0, 100);
    axisY->setTickCount(9);
    //1.创建一个图表视图，但已在ui中创建
    //QChartView *chart = new QChartView();
    //显示坐标轴标题
    axisX->setTitleText("道址 / 能量");
    axisX->setLabelsFont(font); //设置字体
    axisY->setTitleText("计数");
    axisY->setLabelsFont(font);

    //显示整数
    axisX->setLabelFormat("%d");
    axisY->setLabelFormat("%d");

    //5. 将坐标轴添加到图表上
    chart->createDefaultAxes();
    chart->addAxis(axisX, Qt::AlignBottom); //X轴添加到底部
    chart->addAxis(axisY, Qt::AlignLeft); //Y轴添加到左边
    chart->addAxis(axisXE, Qt::AlignBottom); //X轴添加到底部
    axisXE->setVisible(false);
    //6. 设置图表头标题
    //chart->setTitle("原始能谱图");
    chart->legend()->setVisible(false);    //设置图例，不可见

    //7. 创建折线对象 ！！！放到.h中类中
    lineSeries = new QLineSeries();

    //用于添加图像点！！
    for(i=0;i<CHANNELCNT - 1;i++)
    {
        lineSeries->append(i, org_data[i]);
    }

    QPen pen(QColor::fromRgb(0, 0, 0)); //设置折线颜色
    lineSeries->setPen(pen);

    //8. 添加曲线
    chart->addSeries(lineSeries);

    //9. 将曲线数据与坐标轴联系！！
    lineSeries->attachAxis(axisX);
    lineSeries->attachAxis(axisY);

    //10. 将图表放入图表视图
    ui->chartView->setChart(chart);
    //chart->update();
}

void MainWindow::handleData()
{
    if (readLiveTime_flag) {
        // 活时间模式：数据存入独立缓冲区
        liveTimeBuffer.append(serial.readAll());

        // 检查是否收到完整4字节
        if (liveTimeBuffer.size() >= 4) {

            if (liveTimeBuffer.size() == 4) {
                MsLiveTime = qFromLittleEndian<qint32>(liveTimeBuffer.constData());
                qWarning() << "lvtime" << MsLiveTime;
                QMessageBox::information(this, "测量活时间",
                                         "本次测量的活时间为：" + QString::number(MsLiveTime) + "ms");
                if(params[7]) {
                    rawDataAutoSave();
                    QMessageBox::information(this, "提示", "文件已自动存储！");
                }
            } else {
                qWarning() << "LiveTime data corrupted! Size:" << liveTimeBuffer.size();
                QMessageBox::critical(this, "错误", "活时间数据异常");
            }
            readLiveTime_flag = false;
            liveTimeBuffer.clear();
        }
    }
    else {
        buffer.append(serial.readAll());
        // 检查缓冲区溢出（65554 * 2 = 131108）
        if (buffer.size() > BYTESCNT) {
            buffer.clear(); // 清空缓冲区防止溢出
            qWarning() << "Buffer overflow! Clearing buffer.";
        }

        // 处理完整数据包（65554字节）
        while(buffer.size() >= BYTESCNT) {
            // 检查包头有效性 (0xA5 0x5A)
            if (static_cast<quint8>(buffer[0]) != 0xA5) {
                buffer.remove(0, 1); // 移除无效字节并重新尝试同步
                continue;
            }

            QByteArray fullPacket = buffer.left(BYTESCNT);
            buffer = buffer.mid(BYTESCNT); // 移除已处理数据

            // 检查包尾有效性 (0x5A)
            if (static_cast<quint8>(fullPacket[BYTESCNT-1]) != 0x5A) {
                qWarning() << "Invalid packet footer!";
                continue; // 跳过无效数据包
            }

            // 提取有效数据（跳过包头包尾）
            QByteArray dataPacket = fullPacket.mid(1, BYTESCNT - 2); // 2字节包头 + 65552数据

            const char *rawData = dataPacket.constData();

            // 解析数据
            for(int i = 0; i < CHANNELCNT; ++i) {
                org_data[i] = qFromLittleEndian<qint32>(rawData + i*4);
            }

            updateChart();  //更新图表显示信息
            CalcCPS(); //更新CPS显示信息
        }
    }
}

void MainWindow::CalcCPS()
{
    uint data_sum = 0;

    // 求和
    for(int i = 0; i < CHANNELCNT; ++i) {
        data_sum += org_data[i];
    }
    qDebug()<< data_sum;
    if(timer_count > 0) MsLiveCPS = data_sum / (float)timer_count;
    else MsLiveCPS = 0;

    ui->label_B_cps->setText(QString::number(MsLiveCPS) + " cps");
}

void MainWindow::showSerialPort()
{
    uint8_t i = 0;
    // 获取所有可用的串口设备信息
    QList<QSerialPortInfo> serialPorts = QSerialPortInfo::availablePorts();

    portNum.clear();    //全局变量，更新前清零
    portName.clear();

    if(serialPorts.isEmpty())   //未查询到设备时输出错误信息
    {
        QMessageBox::critical(nullptr, "错误", "没有找到可用设备，请重试！");
    }
    else
    {
        ui->comboBox_B_DevC->clear();  //清除所有选项后再插入新设备选型
        //遍历并打印每个串口设备的信息
        for (i = 0; i < serialPorts.size(); ++i) {
            const QSerialPortInfo &serialPort = serialPorts.at(i);
            portNum.append(serialPort.portName());                  // 使用append()添加元素
            portName.append(serialPort.description());

            QString fullName = QString("%1 (%2)").arg(serialPort.portName()).arg(serialPort.description());
            ui->comboBox_B_DevC->addItem(fullName);
        }
    }

    serialPorts.clear();
}

void MainWindow::on_pushButton_SerialCon_clicked()
{
    if(measureStartButton_flag)
    {
        QMessageBox::warning(nullptr, "警告", "测量进行中，无法操作设备！");
        return;
    }
    if(serialpushButton_flag)   //判断串口是否在连接中
    {
        serial.close();     //断开连接
        serialpushButton_flag = 0;
        ui->pushButton_SerialCon->setStyleSheet( "QPushButton {background-color: yellow}" );
        ui->pushButton_SerialCon->setText("连接");
        //使下拉选择框和搜索按钮有效
        ui->comboBox_B_DevC->setDisabled(0);
        ui->comboBox_B_BPS->setDisabled(0);
        ui->pushButton_SerialSrch->setDisabled(0);
    }
    else //设备未连接的情况
    {
        if(portNum.size()==0)
        {
            QMessageBox::critical(nullptr, "错误", "没有串口设备可用于连接！");
        }
        else
        {
            serial.setPortName(portNum[serialPortDevIndex]); // Windows 上的串口名
            serial.setBaudRate(serialPortBpsIndex); // 设置具体的波特率值
            serial.setDataBits(QSerialPort::Data8);
            serial.setStopBits(QSerialPort::OneStop);
            serial.setParity(QSerialPort::NoParity);
            serial.setFlowControl(QSerialPort::NoFlowControl);
            serial.setReadBufferSize(BYTESCNT * 2);    //设置串口读取缓冲区大小

            if (serial.open(QIODevice::ReadWrite))
            {
                //qDebug() << "Serial port opened successfully";
                serialpushButton_flag = 1;
                ui->pushButton_SerialCon->setStyleSheet( "QPushButton {background-color: #00CC00}" );
                ui->pushButton_SerialCon->setText("断开");
                //使下拉选择框和搜索按钮失效
                ui->comboBox_B_DevC->setDisabled(1);
                ui->comboBox_B_BPS->setDisabled(1);
                ui->pushButton_SerialSrch->setDisabled(1);
            }
            else
            {
                QMessageBox::critical(nullptr, "错误", "串口设备连接失败，请重试！");
            }
        }
    }
}

void MainWindow::CfgFileRead()
{
    //发布应用时请设置为根目录！
    QFile file(QCoreApplication::applicationDirPath() + "/" + "param_cfgqt.txt");
    //QFile file(":/param_cfgqt.txt");
    if (file.exists()) {
        if (file.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            QTextStream in(&file);
            QString line;
            QVector<float> params; // 使用QVector来动态存储参数

            // 逐行读取文件内容
            while (!in.atEnd()) {
                line = in.readLine();
                line = line.trimmed(); // 去除行首尾的空白字符
                // 使用正则表达式检查行是否只包含数字，包括0
                QRegularExpression rx("^\\d+(\\.\\d+)?$"); // 匹配整数或浮点数
                if (rx.match(line).hasMatch()) {
                    bool ok;
                    float value = line.toFloat(&ok); // 尝试将字符串转换为浮点数
                    if (ok) {
                        params.push_back(value); // 如果转换成功，将值添加到参数列表中
                    }
                }
            }

            // 关闭文件
            file.close();

            //设置所有输入框Placeholder的显示值
            ui->lineEdit_mTime->setText(QString::number(int(params[0]))); //测量时间
            ui->lineEdit_Rising->setText(QString::number(int(params[1])));   //上升时间Na
            ui->lineEdit_Falling->setText(QString::number(int(params[2])));   //平顶时间Nb
            ui->lineEdit_Tao->setText(QString::number(int(params[3])));   //成形参数tao
            ui->lineEdit_pThd->setText(QString::number(int(params[4])));
            ui->lineEdit_ThdCNT->setText(QString::number(int(params[5])));
            ui->lineEdit_tCNT->setText(QString::number(params[6]));
            ui->radioButton_autoSave->setChecked(params[7] ? 1:0);
        } else
        {
            qDebug() << "Failed to open file for reading";
        }
    }
    else
    {
        QMessageBox::critical(nullptr, "错误", "配置文件不存在！");
    }
}

bool MainWindow::saveParamsToFile()
{
    // 1. 打开文件（覆盖模式 + 文本模式）
    QFile file(QCoreApplication::applicationDirPath() + "/" + "param_cfgqt.txt");
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Truncate)) {
        qCritical() << "无法打开文件：" << file.errorString();
        return false;
    }

    // 创建文本流并写入数据
    QTextStream out(&file);
    // 按固定顺序写入参数，注释行与数字行交替
    out << "//Measurement Time(s)0\n" << params[0] << "\n"
        << "//Rise TimeNa 1\n"        << params[1] << "\n"
        << "//Flat TimeNb 2\n"        << params[2] << "\n"
        << "//Tao-D 3\n"              << params[3] << "\n"
        << "//Threshold 4\n"          << params[4] << "\n"
        << "//DelayCNT 5\n"           << params[5] << "\n"
        << "//TrapzdlDelay 6\n"       << params[6] << "\n"
        << "//AutoSave 7\n"           << params[7] << "\n";

    // 3. 关闭文件并刷新缓冲区
    file.close();
    return true;
}

void MainWindow::closeEvent( QCloseEvent * event )
{
    switch( QMessageBox::information( this, tr("警告"), tr("是否退出程序？"), tr("Yes"), tr("No"), 0, 1 ) )
    {
    case 0:
        event->accept();
        break;
    case 1:
    default:
        event->ignore();
        break;
    }
}

void MainWindow::on_actionopen_triggered()
{
    QString fileName = QFileDialog::getOpenFileName(this, tr("打开谱图文件"), QString(),
                                                    tr("CSV Files (*.csv);;Text Files (*.txt);;所有文件(*)"));
    int i = 0;
    if(!fileName.isEmpty())
    {
        QFile file(fileName);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            qDebug() << "Cannot open file for reading:" << fileName;
            QMessageBox::critical(nullptr, "错误", "无法打开文件！");
        }
        else
        {
            QTextStream in(&file);

            while (!in.atEnd())
            {
                QString line = in.readLine();
                QStringList parts = line.split(',');    // 按逗号分割字符串

                // 检查每行是否包含两个元素
                if (parts.size() == 2)
                {
                    org_data[i] = parts[1].toUInt();
                    i++;
                }
            }
        }
        file.close();
    }

    updateChart();
}

void MainWindow::updateChart()
{
    QList<QPointF> points;
    // 遍历数组并将每个元素转换为 QPointF 对象
    for (int i = 0; i < CHANNELCNT; ++i)
    {
        QPointF point(i, org_data[i]); // 原始谱
        points.append(point);
    }

    axisX->setRange(0, CHANNELCNT-1);
    lineSeries->clear();
    //用于添加图像点！！
    lineSeries->replace(points);

    // 遍历数组以找到极大值
    uint max_value = org_data[0];
    uint min_value = org_data[0];
    for (int i = 1; i < CHANNELCNT; ++i) {
        if (org_data[i] > max_value) {
            max_value = org_data[i]; // 如果发现更大的值，更新极大值
        }
        if (org_data[i] < min_value) {
            min_value = org_data[i]; // 如果发现更小的值，更新极小值
        }
    }
    //if(max_value < 10) max_value = 100; //设置一个最小值用于初始化坐标轴

    //axisX->setRange(0, 16383);
    axisY->setRange(0, max_value + 50); //动态设置Y轴范围
    // 更新图表以显示新数据
    chart->update();
}

void MainWindow::on_pushButton_SerialSrch_clicked()
{
    showSerialPort();   //刷新串口号
}

void MainWindow::on_comboBox_B_DevC_currentIndexChanged(int index)
{
    serialPortDevIndex = index;
}

void MainWindow::on_comboBox_B_BPS_currentTextChanged(const QString &arg1)
{
    serialPortBpsIndex = arg1.toUInt();
    qDebug() << serialPortBpsIndex;
}

void MainWindow::on_actionexit_triggered()
{
    switch( QMessageBox::information( this, tr("警告"), tr("是否退出程序？"), tr("Yes"), tr("No"), 0, 1 ) )
    {
    case 0:
        QApplication::quit();
        break;
    case 1:
    default:
        return;
    }
}

void MainWindow::serialSend8Bytes(qint32 command, qint32 data)
{
    // 定义8字节缓冲区（含4字节命令 + 4字节0）
    QByteArray sendData;
    sendData.resize(8); // 预分配8字节

    command = qToBigEndian(command);
    data = qToBigEndian(data);
    // 填充数据
    memcpy(sendData.data(), &command, 4);       // 前4字节：命令
    memcpy(sendData.data() + 4, &data, 4);      // 后4字节

    qDebug() << "data: " << sendData;
    serial.write(sendData, 8);
}

void MainWindow::sendParams()
{
    serialSend8Bytes((qint32)CMD_PARAM_NA, params[1]);
    QThread::msleep(10);
    serialSend8Bytes((qint32)CMD_PARAM_NB, params[2]);
    QThread::msleep(10);
    serialSend8Bytes((qint32)CMD_PARAM_D, params[3]);
    QThread::msleep(10);
    serialSend8Bytes((qint32)CMD_PARAM_PEAK_THD, params[4]);
    QThread::msleep(10);
    serialSend8Bytes((qint32)CMD_PARAM_PEAK_THD_CNT, params[5]);
    QThread::msleep(10);
    serialSend8Bytes((qint32)CMD_PARAM_PEAK_TOP_DLY, params[6]);
    QThread::msleep(10);
}

void MainWindow::rawDataManulSave()
{
    // 创建一个文件对话框实例
    QString fileName = QFileDialog::getSaveFileName(this,  tr("另存为"), QString(),// 默认文件路径
                                                    tr("CSV 文件 (*.csv);;文本文件 (*.txt);;所有文件(*)")); // 可选的文件类型过滤器
    int i = 0;
    // 获取当前时间
    QDateTime currentTime = QDateTime::currentDateTime();
    QString fileHead = currentTime.toString("yyyyMMdd_HHmmss") + "\r\nSet Time:" +
            QString::number(params[0] - ms_remain_Time) + "s\r\nLive Time:" + QString::number(MsLiveTime) + "ms\r\n";
    const char *fileTime = fileHead.toUtf8().constData();
    if(!fileName.isEmpty())     //用户输入了文件名
    {
        QFile file(fileName);
        if (file.open(QIODevice::WriteOnly | QIODevice::Text))
        {
            file.write(fileTime);
            file.flush();
            for(i=0; i<16384; i++)  //以逗号分隔符格式保存谱数据
            {
                file.write(std::to_string(i).c_str());
                file.write(",");
                file.write(std::to_string(org_data[i]).c_str());
                file.write("\n");
            }
            file.flush();
            file.close();
        }
    }
}

void MainWindow::rawDataAutoSave()
{
    // 获取当前时间
    QDateTime currentTime = QDateTime::currentDateTime();
    // 转换为字符串，格式为 当前目录 + "yyyyMMdd_HHmmss" + .csv
    QString fileName = QCoreApplication::applicationDirPath() + "/AutoSave/" + currentTime.toString("yyyyMMdd_HHmmss") + ".csv";
    QFile file(fileName);

    QString fileHead = currentTime.toString("yyyyMMdd_HHmmss") + "\r\nSet Time:" +
            QString::number(params[0] - ms_remain_Time) + "s\r\nLive Time:" + QString::number(MsLiveTime) + "ms\r\n";
    const char *fileTime = fileHead.toUtf8().constData();
    int i = 0;
    if (file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        file.write(fileTime);
        file.flush();
        for(i=0; i<16384; i++)  //以逗号分隔符格式保存谱数据
        {
            file.write(std::to_string(i).c_str());
            file.write(",");
            file.write(std::to_string(org_data[i]).c_str());
            file.write("\n");
        }
        file.flush();
        file.close();
    }
}

void MainWindow::on_lineEdit_Rising_textChanged(const QString &arg1)
{
    params[1] = arg1.toUInt();

    ui->lineEdit_Rising->setText(QString::number(uint(params[1])));
}

void MainWindow::on_lineEdit_Falling_textChanged(const QString &arg1)
{
    params[2] = arg1.toUInt();

    ui->lineEdit_Falling->setText(QString::number(uint(params[2])));
}

void MainWindow::on_lineEdit_Tao_textChanged(const QString &arg1)
{
    params[3] = arg1.toUInt();

    ui->lineEdit_Tao->setText(QString::number(uint(params[3])));
}

void MainWindow::on_lineEdit_pThd_textChanged(const QString &arg1)
{
    params[4] = arg1.toUInt();

    ui->lineEdit_pThd->setText(QString::number(uint(params[4])));
}

void MainWindow::on_lineEdit_ThdCNT_textChanged(const QString &arg1)
{
    params[5] = arg1.toUInt();

    ui->lineEdit_ThdCNT->setText(QString::number(uint(params[5])));
}

void MainWindow::on_lineEdit_tCNT_textChanged(const QString &arg1)
{
    params[6] = arg1.toUInt();

    ui->lineEdit_tCNT->setText(QString::number(uint(params[6])));
}

void MainWindow::on_lineEdit_mTime_textChanged(const QString &arg1)
{
    params[0] = arg1.toUInt();

    ui->lineEdit_mTime->setText(QString::number(uint(params[0])));
}

void MainWindow::on_radioButton_autoSave_toggled(bool checked)
{
    params[7] = checked;
}

void MainWindow::on_actioncfgsave_triggered()
{
    if(saveParamsToFile()){
        QMessageBox::information(nullptr, "成功", "成功更新配置文件！");
    }
}

void MainWindow::on_pushButton_StartMs_clicked()
{
    if(serial.isOpen()&&(!measureStartButton_flag)) //串口连接，且未开始测量
    {
        timer_count = 0;
        readLiveTime_flag = 0;
        buffer.clear();
        liveTimeBuffer.clear();
        std::fill(org_data, org_data + CHANNELCNT, 0);
        updateChart();
        sendParams(); //测量前 首先需要把更新的参数发送到下位机
        serialSend8Bytes((qint32)CMD_MS_START, 0x00000000);

        measureStartButton_flag = 1;
        ui->pushButton_StartMs->setText("停止测量");
        ui->pushButton_StartMs->setStyleSheet( "QPushButton { background-color: yellow }" );
        timer0.start(); //启动定时器
    }
    else if(serial.isOpen()&&measureStartButton_flag)   //串口连接，且测量进行中
    {
        serialSend8Bytes((qint32)CMD_MS_STOP, 0x00000000);  // 向设备发送 停止测量指令
        timer0.stop();

        ms_remain_Time = params[0]-timer_count; //计算剩余时间

        ui->pushButton_StartMs->setText("开始测量");
        ui->pushButton_StartMs->setStyleSheet( "QPushButton { background-color: #00CC00 }" );

        measureStartButton_flag = 0;
        timer_count = 0;

        // 显示等待对话框
        QMessageBox* msgBox = new QMessageBox(
                    QMessageBox::Information,
                    "提示",
                    "正在获取活时间，请稍等片刻...",
                    QMessageBox::NoButton,
                    this
                    );
        msgBox->setAttribute(Qt::WA_DeleteOnClose); // 自动释放
        msgBox->setWindowFlags(Qt::Dialog | Qt::CustomizeWindowHint); // 无关闭按钮
        QPushButton *okBtn = msgBox->addButton("确定", QMessageBox::AcceptRole); // 自定义文本[2](@ref)
        okBtn->setEnabled(false);
        msgBox->show();
        // 单次定时器发送指令
        QTimer::singleShot(2000, this, [this, msgBox]() {
            msgBox->close();
            readLiveTime_flag = 1;
            serialSend8Bytes(CMD_TM_READ, 0x00000000);
        });
    }
    else
    {
        QMessageBox::critical(nullptr, "错误", "串口设备未正常连接，请重试！");
    }

}

void MainWindow::on_actionsave_as_triggered()
{
    rawDataManulSave();
}

void MainWindow::on_actionAboutSW_triggered()
{
    QMessageBox::warning(nullptr, "关于",
                         "基于ZYNQ SoC的数字多道上位机控制系统\n"
                         "基于Qt5.14.2设计，软件禁止用于科研及商业用途！\n"
                         "中国科学院上海同步辐射光源\n\n"
                         "Email:tangzhijie@mail.ustc.edu.cn\n"
                         "Programed By Steve 2025/06 Ver0.0.1\n"
                         "Software Complies with GPL3.0 OpenSourse License");
}
