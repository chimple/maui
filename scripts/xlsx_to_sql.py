import openpyxl as px
import sys
import json
import re

types = {
	'select': 0,
	'activity': 1,
	'topic': 2,
	'article': 3,
	'many': 4,
	'match': 5,
	'connection': 9,
	'choice': 100,
	'option': 100,
	'answer': 101,
	'template': 102
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

def esc(a):
	if a == None:
		return 'NULL'
	if a.endswith(('.svg','.png','.jpg','.jpeg','.gif')):
		prefix = asset_dir + '/'
	else:
		prefix = ''
	return "'" + prefix + a.replace("'", "''") + "'"

wb = px.load_workbook(xlsx_file, read_only=True)

collection_sql = ''

with open(xlsx_file+'.sql', 'w') as sqlfile:
	for sheet in wb:
		topic = ''
		card = ''
		extra = -1
		card_number = 1
		extra_number = 1
		row_num = 1
		for row in sheet.iter_rows(row_offset=1):
			row_num+=1
			if(row[type].value == None):
				continue
			type_data = types[row[type].value]
			option_value = row[option].value
			if type_data == 0:
				option_value = 'oneAtATime'
			if type_data == 4:
				option_value = 'many'
				type_data = 0
			elif type_data == 5:
				option_value = 'pair'
				type_data = 0
			if(type_data <= 4):
				if type_data == 2:
					card = sheet.title
				else:
					card = sheet.title+str(row_num)
				sqlfile.write(f"INSERT INTO `card` (id, type, title, header, content, option) VALUES ({esc(card)}, {type_data}, {esc(row[title].value)}, {esc(row[header].value)}, {esc(row[content].value)}, {esc(option_value)});\n")
			if type_data == 2:
				topic = card
				card_number = 1
				extra = -1
			elif type_data <= 9:
				collection_sql += f"INSERT INTO `collection` (id, serial, cardId) VALUES ({esc(topic)}, {card_number}, {esc(card)});\n"
				card_number += 1
				extra = -1
			else:
				if extra != type_data-100:
					extra = type_data-100
					extra_number = 1
				extra_content = row[1].value
				if extra_content == None:
					extra_content = row[2].value
				sqlfile.write(f"INSERT INTO `cardExtra` (cardId, type, serial, content) VALUES ({esc(card)}, {extra}, {extra_number}, {esc(extra_content)});\n")
				extra_number += 1

	sqlfile.write(collection_sql)
