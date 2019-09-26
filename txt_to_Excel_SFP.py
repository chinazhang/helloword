#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# importing tkinter and tkinter.ttk
# and all their functions and classes
from tkinter import *
from tkinter.ttk import *

# importing askopenfile function
# from class filedialog
from tkinter.filedialog import askopenfile

import xlsxwriter
import os

root = Tk()
root.geometry('600x350')

content=''

# This function will be used to open file
def open_file():
    global content
    global entry
    file = askopenfile(mode ='r', filetypes =[('TXT Files','*.txt *.log'),('Python Files', '*.py'),('XML Files','*.xml')])
    if file is not None:
        content = file.name
    entry.delete(0,END)
    entry.insert(INSERT,content)

btn = Button(root, text ='Open', command = lambda:open_file())
btn.grid(row=0,column=0)

entry =Entry(root,width=50)
entry.grid(row=0,column=1)
entry.insert(INSERT,'')


def txtToExcel(file_txt, file_excel):
    # 打开txt文件，并以行为单位读取数据

	# 定义关键字
    BCFwords='Parameter'
    BTSwords='Measurement'
    SBTSwords='Measurements'


    # 创建一个excel文件，并添加一个sheet，命名为BSCdata
    workbook = xlsxwriter.Workbook(file_excel)
    sheet = workbook.add_worksheet('BSCdata')

    # 设置粗体
    bold = workbook.add_format({'bold': True})

    # 先在第一行写标题，用粗体
    sheet.write('A1', u'filename', bold)
    sheet.write('B1', u'SFP', bold)
    sheet.write('C1', u'vendor', bold)
    sheet.write('D1', u'Serial number', bold)
    sheet.write('E1', u'Connector type', bold)
    sheet.write('F1', u'SFP wavelength', bold)
    sheet.write('G1', u'SFP transmission mode', bold)
    sheet.write('H1', u'SFP transmission rate', bold)
    sheet.write('I1', u'Transmission distance', bold)
    sheet.write('J1', u'Max Transmission Distance SMF KM', bold)
    sheet.write('K1', u'Max Transmission Distance SMF', bold)
    sheet.write('L1', u'SFPTWO', bold)
    sheet.write('M1', u'Module temperature', bold)
    sheet.write('N1', u'Transceiver TX supply voltage', bold)
    sheet.write('O1', u'Transceiver TX bias current', bold)
    sheet.write('P1', u'Transceiver TX power', bold)
    sheet.write('Q1', u'Transceiver RX optical power', bold)

    # 行号，具体信息从第二行开始
    row = 2

    current_dir = os.path.abspath(os.path.dirname(file_txt))
    file_name = open(file_txt, 'r')
    file_list = file_name.readlines()
    for filename in file_list:
        filename = filename.rstrip("\n")
        txt = open(current_dir+"\\"+filename, 'r', encoding='UTF-8')
        data = txt.readlines()


        # 记录当前行数
        count = 0
    # 将data中的数据按txt的每行的顺序依次赋值给x
        for x in data:
            # 根据条件筛选出需要的信息，获取BSC型号及BSC号，并赋值给word_BSC
            # 将x根据空格分裂成list并赋值给words
            words = x.split()
            # 将words中的数据按顺序赋值给text
            for text in words:
                # 根据筛选条件，以站（BCF）为单位获取信息
                if BCFwords in text:
                    word_SFP = data[count]
                    word_Vendor = data[count+2]  # 获取下2行数据
                    word_Snmuber = data[count+3]
                    word_type = data[count+4]
                    word_wavelength = data[count+5]
                    word_mode = data[count+6]
                    word_rate = data[count+7]
                    word_distance = data[count+8]
                    word_maxdistanceone = data[count+9]
                    word_maxdistancetwo = data[count+10]
                elif BTSwords in text and SBTSwords not in text:
                    word_sfptwo = data[count-1]
                    word_temp = data[count+2]
                    word_voltage = data[count+3]
                    word_current = data[count+4]
                    word_TX = data[count+5]
                    word_RX = data[count+6]
                    sheet.write('A%d' % row, filename)
                    sheet.write('B%d' % row, word_SFP[9:].strip())
                    sheet.write('C%d' % row, word_Vendor[6:].strip())
                    sheet.write('D%d' % row, word_Snmuber[13:].strip())
                    sheet.write('E%d' % row, word_type[14:].strip())
                    sheet.write('F%d' % row, word_wavelength[21:].strip())
                    sheet.write('G%d' % row, word_mode[21:].strip())
                    sheet.write('H%d' % row, word_rate[21:].strip())
                    sheet.write('I%d' % row, word_distance[21:].strip())
                    sheet.write('J%d' % row, word_maxdistanceone[34:].strip())
                    sheet.write('K%d' % row, word_maxdistancetwo[34:].strip())
                    sheet.write('L%d' % row, word_sfptwo)
                    sheet.write('M%d' % row, word_temp[30:-22].strip())
                    sheet.write('N%d' % row, word_voltage[30:-22].strip())
                    sheet.write('O%d' % row, word_current[30:-22].strip())
                    sheet.write('P%d' % row, word_TX[30:-22].strip())
                    sheet.write('Q%d' % row, word_RX[30:-22].strip())
                    row += 1
            count += 1

        # 关闭文件
        txt.close()
    workbook.close()
    msg = Label(root, text='Done!')
    msg.grid(row=1,column=0)

btn = Button(root, text ='txt_to_excel', command = lambda:txtToExcel(content,str(entry.get())+'.xlsx'))
btn.grid(row=1,column=1)


mainloop()
