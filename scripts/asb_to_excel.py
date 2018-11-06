import openpyxl as px
import sys
from bs4 import BeautifulSoup
from urllib import request
import re
import os.path

def parse_story(soup, lang):
    row = 1
    ws_list = [
    {
        'type': 'type',
        'header': 'header',
        'title': 'title_'+lang,
        'content': 'content_'+lang,
        'option': 'option'
    }
    ]
    # ws.cell(row=row, column=1).value = 'type'
    # ws.cell(row=row, column=2).value = 'header'
    # ws.cell(row=row, column=3).value = 'title'
    # ws.cell(row=row, column=4).value = 'content'
    # ws.cell(row=row, column=5).value = 'option'
    row = row+1
    title_img_el = soup.find('div',class_='cover-image')['style']
    m = re.search(r"\(.*\)", title_img_el)
    title_img = m.group(0)[1:-1]
    img_name = title_img.split('/')[-1]
    title = soup.find('div',class_='cover_title').text
    content = soup.find('div',class_='cover_author').text
    content += '\n'+soup.find('div',class_='cover_artist').text
    if not os.path.isfile('asb/'+img_name):
        request.urlretrieve("https://www.africanstorybook.org/"+title_img, 'asb/'+img_name)

    print(title_img,',',title,',',content)
    ws_list.append({
        'type': 'topic',
        'header': 'asb/'+img_name,
        'title': title,
        'content': content,
        'option': ''
    })
    # ws.cell(row=row, column=1).value = 'topic'
    # ws.cell(row=row, column=2).value = 'asb/'+img_name
    # ws.cell(row=row, column=3).value = title
    # ws.cell(row=row, column=4).value = content
    # ws.cell(row=row, column=5).value = ''
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
                if not os.path.isfile('asb/'+img_name):
                    request.urlretrieve("https://www.africanstorybook.org/"+img, 'asb/'+img_name)

            print(img, ',', text)
            row_dict = {
                'type': 'article'
            }
            # ws.cell(row=row, column=1).value = 'article'
            if img_name:
                # ws.cell(row=row, column=2).value = 'asb/'+img_name
                row_dict['header'] = 'asb/'+img_name
            else:
                # ws.cell(row=row, column=2).value = ''
                row_dict['header'] = ''
            # ws.cell(row=row, column=3).value = ''
            # ws.cell(row=row, column=4).value = text
            # ws.cell(row=row, column=5).value = ''
            row_dict['title'] = ''
            row_dict['content'] = text
            row_dict['option'] = ''
            ws_list.append(row_dict)
            row = row+1
    back_cover = soup.find('div',class_='backcover_wrapper')
    if back_cover:
        back_cover_text = back_cover.get_text("\n", strip=True)
        print(back_cover_text)
        # ws.cell(row=row, column=1).value = 'article'
        # ws.cell(row=row, column=2).value = ''
        # ws.cell(row=row, column=3).value = ''
        # ws.cell(row=row, column=4).value = back_cover_text
        # ws.cell(row=row, column=5).value = ''
        ws_list.append({
            'type': 'article',
            'header': '',
            'title': '',
            'content': back_cover_text,
            'option': ''
        })
    return ws_list

#story_id = sys.argv[1]
story_file = sys.argv[1]
wb = px.load_workbook(story_file+'.xlsx')
worksheets = wb.worksheets;
with open(story_file) as f:
    for story_id in f:
        story_id = story_id.rstrip()
        print(story_id)
        ws = wb.active
        if story_id in worksheets:
            ws = wb[story_id]
        else:
            ws = wb.create_sheet(story_id)
        with request.urlopen('https://www.africanstorybook.org/read/readbook.php?id='+story_id+'&d=0&a=1') as f:
            soup = BeautifulSoup(f, features="html.parser")
            sw_list = parse_story(soup, 'sw')

            s = soup.find('div',class_='list-bliock').find(string=re.compile('English'))
            if s:
                link = s.parent.parent.parent.parent['onclick']
                m = re.search(r"\d+",link)
                eng_story_id = m.group(0)
                with request.urlopen('https://www.africanstorybook.org/read/readbook.php?id='+eng_story_id+'&d=0&a=1') as eng_f:
                    soup = BeautifulSoup(eng_f, features="html.parser")
                    en_list = parse_story(soup, 'en')
                    if len(sw_list) == len(en_list):
                        for i in range(len(en_list)):
                            en_row = en_list[i]
                            sw_row = sw_list[i]
                            if sw_row['type'] == en_row['type'] and sw_row['header'] == en_row['header']:
                                sw_list[i]['title_en'] = en_row['title']
                                sw_list[i]['content_en'] = en_row['content']
                                print(sw_list[i])
            row = 1
            for row_dict in sw_list:
                print(row_dict)
                ws.cell(row=row, column=1).value = row_dict['type']
                ws.cell(row=row, column=2).value = row_dict['header']
                ws.cell(row=row, column=3).value = row_dict['title_en']
                ws.cell(row=row, column=4).value = row_dict['content_en']
                ws.cell(row=row, column=5).value = row_dict['title']
                ws.cell(row=row, column=6).value = row_dict['content']
                ws.cell(row=row, column=7).value = row_dict['option']
                row = row+1

wb.save(story_file+'.xlsx')
