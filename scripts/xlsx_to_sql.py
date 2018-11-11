import openpyxl as px
import sys
import json
import re
import os

types = {
	'select': 0,
	'quiz': 0,
	'activity': 1,
	'topic': 2,
	'article': 3,
	'many': 4,
	'multi': 4,
	'match': 5,
	'connection': 9,
	'choice': 100,
	'option': 100,
	'answer': 101,
	'template': 102,
	'sticker': -1,
}

type = 0
header = 1
title = 2
content = 4
#title_sw = 3
#content_sw = 5
option = 6

xlsx_file = sys.argv[1]
asset_dir = 'assets/topic'
collection_name = os.path.splitext(xlsx_file)[0]


def esc(a):
	if a == None:
		return 'NULL'
	if str(a).endswith(('.svg','.png','.jpg','.jpeg','.gif')):
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
		for row in sheet.iter_rows(row_offset=1):
			row_num+=1
			print(sheet.title, row_num)
			type_value = row_value(row, type)
			title_value = row_value(row, title)
			content_value = row_value(row, content)
			header_value = row_value(row, header)
			option_value = row_value(row, option)

			if(type_value == None):
				continue
			type_value = type_value.lower()
			type_data = types[type_value]
			if type_data == -1:
				continue
			elif type_data == 0:
				quiz_type = 'oneAtATime'
			elif type_data == 4:
				quiz_type = 'many'
				type_data = 0
			elif type_data == 5:
				quiz_type = 'pair'
				type_data = 0
			if(type_data <= 4):
				if type_data == 2:
					card = sheet.title
				else:
					card = sheet.title+str(row_num)
				sqlfile.write(f"INSERT INTO `card` (id, type, title, header, content, option) VALUES ({esc(card)}, {type_data}, {esc(title_value)}, {esc(header_value)}, {esc(content_value)}, NULL);\n")
			if type_data == 2:
				topic = card
				card_number = 1
				extra = -1
				topics.append(topic)
			elif type_data <= 9:
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
				sqlfile.write(f"INSERT INTO `cardExtra` (cardId, type, serial, content) VALUES ({esc(card)}, {extra}, {extra_number}, {esc(extra_content)});\n")
				extra_number += 1
	sqlfile.write(f"INSERT INTO `card` (id, type, title, header, content, option) VALUES ({esc(collection_name)}, {types['topic']}, {esc(collection_name)}, NULL, NULL, NULL);\n")
	serial = 0
	for topic_id in topics:
		collection_sql += f"INSERT INTO `collection` (id, serial, cardId) VALUES ({esc(collection_name)}, {serial}, {esc(topic_id)});\n"
		serial += 1
	sqlfile.write(collection_sql)
