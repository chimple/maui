import csv
import sys
import json
import re

topic_csv = sys.argv[1]
asset_dir = 'assets/topic'

def create_quiz_json(question, image, answer, choices):
	answer_list = [normalize(a) for a in answer.split(',')]
	choices_list = [normalize(a) for a in choices.split(',')] if choices is not None else None
	quiz_dict = {
		"question": question,
		"image": image,
		"answer": answer_list,
		"choices": choices_list
	}
	return json.dumps(quiz_dict)

def normalize(a):
	a = a.strip()
	if re.match('(true|false)',a,re.IGNORECASE):
		return a.lower()
	else:
		return a

def esc(a):
	return a.replace("'", "''")

with open(topic_csv, 'r') as csvfile:
	topic_reader = csv.reader(csvfile, delimiter=',', quoting=csv.QUOTE_ALL)
	with open(topic_csv+'.sql', 'w') as sqlfile:
		topic = ''
		article_num = 1
		activity = ''
		activity_num = 1
		quiz_num = 1
		for row in topic_reader:
			if(row[0] == 'topic'):
				sqlfile.write(f"INSERT INTO `card` (id, type, header, title, content) VALUES ('{esc(row[1])}','{esc(row[2])}','{asset_dir}/{esc(row[3])}',NULL);\n")
				topic = row[1]
				article_num = 1
				activity_num = 1
				activity = ''
				quiz_num = 1
			elif(row[0] == 'article'):
				sqlfile.write(f"INSERT INTO `article` VALUES ('{esc(row[1])}','{esc(row[2])}','{esc(topic)}',NULL,NULL,'{asset_dir}/{esc(row[3])}','{esc(row[4])}',{article_num});\n")
				article_num = article_num + 1
			elif(row[0] == 'activity'):
				sqlfile.write(f"INSERT INTO `activity` VALUES ('{esc(row[1])}','{esc(topic)}','{esc(row[2])}',NULL,{activity_num},'{asset_dir}/{esc(row[3])}',NULL,NULL);\n")
				sqlfile.write(f"INSERT INTO `activityTopic` VALUES ('{esc(row[1])}','{esc(topic)}');\n")
				activity = row[1]
				activity_num = activity_num + 1
			elif(row[0] == 'template'):
				sqlfile.write(f"INSERT INTO `activityTemplate` VALUES ('{esc(activity)}','{asset_dir}/{esc(row[3])}');\n")
			elif(row[0] == 'quiz'):
				quiz_json = create_quiz_json(row[2], asset_dir+'/'+row[3], row[4], row[5] if len(row)>=6 else None)
				sqlfile.write(f"INSERT INTO `quiz` VALUES ('{esc(topic)}_{quiz_num}','{esc(topic)}',1,'{esc(row[1])}','{esc(quiz_json)}');\n")
				quiz_num = quiz_num + 1
			elif(row[0] == 'related'):
				sqlfile.write(f"INSERT INTO `relatedTopic` VALUES ('{esc(row[1])}','{esc(row[2])}');\n")
