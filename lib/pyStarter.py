#!/usr/bin/python
from __future__ import print_function
import os
import sys
from os import path
from termcolor import colored
from subprocess import Popen, PIPE


def shell(*cmd):
    p = Popen(cmd, stdout=PIPE, stderr=PIPE)
    (out, err) = p.communicate()
    code = p.returncode
    return (code, out, err)

def shellSafe(*cmd):
    (code,out,err) = shell(*cmd)
    if code != 0:
        error('An error occured ('+str(code)+'):\n' + out + '\n' + err)
    return out

def var(shellVar):
    return os.environ[shellVar]

def error(message):
    printRed('ERROR] ' + message)
    sys.exit(1)

def warning(message):
    printYellow('[WARNING] ' + message)

def assertMore(argv, expected=1):
    if len(argv) < expected:
        error('Missing arguments')

def inputNumber(message, min=None, max=None):
    r_input = raw_input(message)
    try:
        choice = int(r_input)

        if not min is None and choice < min:
            warning('Should be bigger than ' + str(min))
            return inputNumber(message, min, max)
        if not max is None and choice > max:
            warning('Should be smaller than ' + str(max))
            return inputNumber(message, min, max)

        return choice
    except ValueError:
        warning('Enter a number')
        return inputNumber(message, min, max)

def printn(prt): print(prt,end='')
def printRed(prt,end='\n'): print("\033[91m{}\033[00m" .format(prt),end=end)
def printGreen(prt,end='\n'): print("\033[92m{}\033[00m" .format(prt),end=end)
def printYellow(prt,end='\n'): print("\033[93m{}\033[00m" .format(prt),end=end)
def printLightPurple(prt,end='\n'): print("\033[94m{}\033[00m" .format(prt),end=end)
def printPurple(prt,end='\n'): print("\033[95m{}\033[00m" .format(prt),end=end)
def printCyan(prt,end='\n'): print("\033[96m{}\033[00m" .format(prt),end=end)
def printLightGray(prt,end='\n'): print("\033[97m{}\033[00m" .format(prt),end=end)
def printBlack(prt,end='\n'): print("\033[98m{}\033[00m" .format(prt),end=end)