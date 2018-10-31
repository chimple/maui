import xml.etree.ElementTree as ET
import sys

svg_file = sys.argv[1]

tree = ET.parse(svg_file)
root = tree.getroot()

x = []
y = []
c = []
for circle in root.iter('{http://www.w3.org/2000/svg}circle'):
    x.append(str(int(float(circle.attrib['cx']))))
    y.append(str(int(float(circle.attrib['cy']))))
    c.append('0')

svg_file_list = svg_file.split('.')

with open(svg_file_list[0]+'.json','w') as json_file:
    json_file.write('{"id":"dot","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":['+','.join(x)+'],"y":['+','.join(y)+'],"c":['+','.join(c)+']}}]}')
