#include "mainwindow.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.setWindowTitle("数字多道上位机系统"); // 设置窗口标题
    w.show();
    return a.exec();
}
