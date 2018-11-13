import openpyxl as px
import sys
import json
import re

types = {
	'quiz': 0,
	'activity': 1,
	'topic': 2,
	'article': 3,
	'connection': 9,
	'choice': 100,
	'answer': 101,
	'template': 102
}

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
card_sheet = wb['card']

collection_sql = ''
with open(xlsx_file+'.sql', 'w') as sqlfile:
	topic = ''
	card = ''
	extra = -1
	card_number = 1
	extra_number = 1
	for row in card_sheet.iter_rows(row_offset=1):
		if(row[0].value == None):
			continue
		type_data = types[row[0].value]
		if(type_data <= 3):
			card = row[2].value
			sqlfile.write(f"INSERT INTO `card` (id, type, title, header, content, option) VALUES ({esc(card)}, {type_data}, {esc(row[1].value)}, {esc(row[3].value)}, {esc(row[4].value)}, {esc(row[5].value)});\n")
		if type_data == 2:
			topic = row[2].value
			card_number = 1
			extra = -1
		elif type_data <= 9:
			collection_sql += f"INSERT INTO `collection` (id, serial, cardId) VALUES ({esc(topic)}, {card_number}, {esc(row[2].value)});\n"
			card_number += 1
			extra = -1
		else:
			if extra != type_data-100:
				extra = type_data-100
				extra_number = 1
			sqlfile.write(f"INSERT INTO `cardExtra` (cardId, type, serial, content) VALUES ({esc(card)}, {extra}, {extra_number}, {esc(row[1].value)});\n")
			extra_number += 1
	sqlfile.write(collection_sql)
