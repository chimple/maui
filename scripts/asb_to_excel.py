import openpyxl as px
import sys
from bs4 import BeautifulSoup
from urllib import request
import re

#story_id = sys.argv[1]
#with urllib.request.urlopen('https://www.africanstorybook.org/read/readbook.php?id='+story_id+'&d=0&a=1') as f:
story_file = sys.argv[1]
wb = px.Workbook()
ws = wb.active
ws.name = story_file
row = 1
ws.cell(row=row, column=1).value = 'type'
ws.cell(row=row, column=2).value = 'header'
ws.cell(row=row, column=3).value = 'title'
ws.cell(row=row, column=4).value = 'content'
ws.cell(row=row, column=5).value = 'option'
row = row+1

with open(story_file) as f:
    soup = BeautifulSoup(f, features="html.parser")
    title_img_el = soup.find('div',class_='cover-image')['style']
    m = re.search(r"\(.*\)", title_img_el)
    title_img = m.group(0)[1:-1]
    img_name = title_img.split('/')[-1]
    title = soup.find('div',class_='cover_title').text
    content = soup.find('div',class_='cover_author').text
    content += '\n'+soup.find('div',class_='cover_artist').text
    request.urlretrieve("https://www.africanstorybook.org/"+title_img, 'asb/'+img_name)

    print(title_img,',',title,',',content)
    ws.cell(row=row, column=1).value = 'topic'
    ws.cell(row=row, column=2).value = 'asb/'+img_name
    ws.cell(row=row, column=3).value = title
    ws.cell(row=row, column=4).value = content
    ws.cell(row=row, column=5).value = ''
    row = row+1

    for tag in soup.find_all('div',class_='swiper-slide'):
        img = ''
        text = ''
        img_name = ''
        img_el = tag.find('div',class_='page-image')
        if img_el:
            m = re.search(r"\(.*\)", img_el['style'])
            img = m.group(0)[1:-1]
        text_el = tag.find('div',class_='page-text-story')
        if not text_el:
            text_el = tag.find('div',class_='page-textonly-story')
        if text_el:
            text = text_el.get_text("\n", strip=True)
        if img != '' or text != '':
            if img != '':
                img_name = img.split('/')[-1]
                request.urlretrieve("https://www.africanstorybook.org/"+img, 'asb/'+img_name)

            print(img, ',', text)
            ws.cell(row=row, column=1).value = 'article'
            ws.cell(row=row, column=2).value = 'asb/'+img_name
            ws.cell(row=row, column=3).value = ''
            ws.cell(row=row, column=4).value = text
            ws.cell(row=row, column=5).value = ''
            row = row+1
wb.save(story_file+'.xlsx')
