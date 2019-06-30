#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Hello World application for Tkinter"""
from tkinter import *
from tkinter.ttk import *
root = Tk()
label = Label(root, text="Hello World")
label.pack()
button = Button(root, text="click me")
button.pack()
root.mainloop()
