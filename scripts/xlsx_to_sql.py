import openpyxl as px
import sys
import json
import re
import os
import random

types = {
	'select': 0,
	'selaect': 0,
	'quiz': 0,
	'activity': 1,
	'actiivity': 1,
	'actvity': 1,
	'activty': 1,
	'actitvity': 1,
	'topic': 2,
	'article': 3,
	'many': 4,
	'multi': 4,
	'match': 5,
	'open': 6,
	'connection': 9,
	'choice': 100,
	'option': 100,
	'answer': 101,
	'template': 102,
	'sticker': -1,
}

colors = [
'FFB3C8FF',
'FF9DEDE3',
'FFF4E1B5',
'FF9DEDE3',
'FFB3C8FF',
'FFCFB5DD',
'FF9DEDE3',
]

type = 0
header = 1
title = 3
content = 5
#title_en = 2
#content_en = 4
#title_sw = 3
#content_sw = 5
option = 6

xlsx_file = sys.argv[1]
asset_dir = 'assets/topic'
collection_name = os.path.splitext(xlsx_file)[0]


def esc(a):
	if a == None:
		return 'NULL'
	if str(a).lower().endswith(('.svg','.png','.jpg','.jpeg','.gif')):
		prefix = asset_dir + '/'
	else:
		prefix = ''
	return "'" + prefix + str(a).replace("'", "''") + "'"

def row_value(row, name):
	try:
		value = row[name].value
		if value is not None:
			return str(value).strip()
	except:
		value = None
	return value

wb = px.load_workbook(xlsx_file, read_only=True)

collection_sql = ''
topics = []

with open(collection_name+'.sql', 'w') as sqlfile:
	for sheet in wb:
		topic = ''
		card = ''
		extra = -1
		card_number = 1
		extra_number = 1
		row_num = 1
		quiz_type = ''
		topic_header = ''
		for row in sheet.iter_rows(row_offset=1):
			row_num+=1
			# print(sheet.title, row_num)
			add_template = False
			type_value = row_value(row, type)
			title_value = row_value(row, title)
			content_value = row_value(row, content)
			header_value = row_value(row, header)
			option_value = row_value(row, option)

			if(type_value == None):
				continue
			type_value = type_value.lower()
			type_data = types[type_value]

			if collection_name == 'story' and type_data == 1 and header_value == None:
				add_template = True
				header_value = sheet.title + '.svg'

			if type_data == -1:
				continue
			elif type_data == 0:
				option_value = 'oneAtATime'
			elif type_data == 4:
				option_value = 'many'
				type_data = 0
			elif type_data == 5:
				option_value = 'pair'
				type_data = 0
			elif type_data == 6:
				option_value = 'open'
				type_data = 0
			elif type_data == 2:
				option_value = colors[random.randint(0, len(colors)-1)]
			if(type_data <= 4):
				if title_value != None or (type_data==3 and content_value != None):
					if type_data == 2:
						card = sheet.title
					else:
						card = sheet.title+'_'+str(row_num)
					if option_value == 'open' and header_value == None:
						header_value = topic_header
					sqlfile.write(f"INSERT INTO `card` (id, type, title, header, content, option) VALUES ({esc(card)}, {type_data}, {esc(title_value)}, {esc(header_value)}, {esc(content_value)}, {esc(option_value)});\n")
					if add_template:
						sqlfile.write(f"INSERT INTO `cardExtra` (cardId, type, serial, content) VALUES ({esc(card)}, 2, 1, {esc(header_value)});\n")
				else:
					card = ''
			if type_data == 2:
				print(card)
				topic = card
				card_number = 1
				extra = -1
				topic_header = header_value
				if topic != '':
					topics.append(topic)
			elif type_data <= 9:
				if topic == '':
					topic = sheet.title
				if card != '':
					collection_sql += f"INSERT INTO `collection` (id, serial, cardId) VALUES ({esc(topic)}, {card_number}, {esc(card)});\n"
				card_number += 1
				extra = -1
			else:
				if extra != type_data-100:
					extra = type_data-100
					extra_number = 1
				extra_content = header_value
				if extra_content == None:
					extra_content = title_value
				if card != '':					
					sqlfile.write(f"INSERT INTO `cardExtra` (cardId, type, serial, content) VALUES ({esc(card)}, {extra}, {extra_number}, {esc(extra_content)});\n")
				extra_number += 1
	sqlfile.write(f"INSERT INTO `card` (id, type, title, header, content, option) VALUES ({esc(collection_name)}, {types['topic']}, {esc(collection_name)}, NULL, NULL, NULL);\n")
	serial = 0
	for topic_id in topics:
		collection_sql += f"INSERT INTO `collection` (id, serial, cardId) VALUES ({esc(collection_name)}, {serial}, {esc(topic_id)});\n"
		serial += 1
	sqlfile.write(collection_sql)
