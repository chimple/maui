import xml.etree.ElementTree as ET
import sys
import re

svg_file = sys.argv[1]

tree = ET.parse(svg_file)
root = tree.getroot()

x = []
y = []
c = []
for path in root.iter('{http://www.w3.org/2000/svg}path'):
    path_str = path.attrib['d']
    matches = re.findall(r'([Mm])(-?[0-9]*\.?[0-9]*),?(-?\.?[0-9\.]*)',path_str)
    prev_x = 0
    prev_y = 0
    for m in matches:
      print(m)
      cx = int(float(m[1]))
      cy = int(float(m[2]))
      if(m[0] == 'M'):
        x.append(str(cx))
        y.append(str(cy))
        prev_x = cx
        prev_y = cy
      else:
        x.append(str(prev_x + cx))
        y.append(str(prev_y + cy))   
        prev_x = prev_x + cx
        prev_y = prev_y + cy
      c.append('0')

svg_file_list = svg_file.split('.')

with open(svg_file_list[0]+'.json','w') as json_file:
    json_file.write('{"id":"dot","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":['+','.join(x)+'],"y":['+','.join(y)+'],"c":['+','.join(c)+']}}]}')
