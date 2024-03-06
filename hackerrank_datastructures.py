#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul  8 18:21:56 2023

@author: sola"""

## Data structure 1


import math
import os
import random
import re
import sys



def reverseArray(a):
    # Write your code here
  res = a[::-1]
  return res
    
    
    


print("Enter a number")
arr_count = int(input().strip())

print("Enter the values here:")
arr = list(map(int, input().rstrip().split()))


res = reverseArray(arr)
print(res)
    


a, b, c = 15, 93, 22
print(a,b,c)

max = a if a>b and a>c else  b if b>c else c

print(max)
print(max)
