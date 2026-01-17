#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QChart>
#include <QChartView>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QValueAxis>
#include <QLineSeries>
#include <QFontDatabase>
#include <QMessageBox>
#include <QDebug>
#include <QFileDialog>
#include <QtEndian>
#include <QTimer>
#include <QThread>
#include <QProgressDialog>
#include <QDateTime>
#include <QPointer>

QT_CHARTS_USE_NAMESPACE

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
    void ChartInit();
    void showSerialPort();
    void listSerialDevices();
    void CfgFileRead();
    void updateChart();
    bool saveParamsToFile();
    void serialSend8Bytes(qint32 command, qint32 data);
    void sendParams();
    void handleData();
    void TimerInit(quint32 cycle);
    void rawDataManulSave();
    void rawDataAutoSave();
    void CalcCPS();

private slots:
    void on_pushButton_SerialSrch_clicked();

    void on_pushButton_SerialCon_clicked();

    void on_comboBox_B_DevC_currentIndexChanged(int index);

    void on_comboBox_B_BPS_currentTextChanged(const QString &arg1);

    void on_actionopen_triggered();

    void on_actionexit_triggered();

    void on_lineEdit_Rising_textChanged(const QString &arg1);

    void on_lineEdit_Falling_textChanged(const QString &arg1);

    void on_lineEdit_Tao_textChanged(const QString &arg1);

    void on_lineEdit_pThd_textChanged(const QString &arg1);

    void on_lineEdit_ThdCNT_textChanged(const QString &arg1);

    void on_lineEdit_tCNT_textChanged(const QString &arg1);

    void on_lineEdit_mTime_textChanged(const QString &arg1);

    void on_radioButton_autoSave_toggled(bool checked);

    void on_actioncfgsave_triggered();

    void on_pushButton_StartMs_clicked();

    void on_Timeout();

    void on_actionsave_as_triggered();

    void on_actionAboutSW_triggered();

private:
    Ui::MainWindow *ui;
    QChart *chart;
    QValueAxis *axisX;
    QValueAxis *axisXE;
    QValueAxis *axisY;
    QLineSeries *lineSeries;
    QSerialPort serial;
    QByteArray buffer;
    QByteArray liveTimeBuffer;
    QTimer timer0;

protected:
    void closeEvent( QCloseEvent * event );
};
#endif // MAINWINDOW_H
