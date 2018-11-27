import openpyxl as px
import sys
import json
import re
import os
import random

xlsx_file = sys.argv[1]

wb = px.load_workbook(xlsx_file, read_only=True)

collection_sql = ''
topics = []

for sheet in wb:
  title = sheet.cell(2, 3).value
  if title is not None:
	  print(sheet.title+title)