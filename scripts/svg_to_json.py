import xml.etree.ElementTree as ET
import sys
from glob import glob
import os
import re

svg_dir = sys.argv[1]
dot_map = 'final dotMap = {\n'
for svg_file in glob(svg_dir + "/*/*_dot.svg"):
  m = re.findall(r'(.*)_dot.svg', svg_file)
  dot_name = m[0].replace(os.path.sep, '/')
  under_dot_name = '_'.join(dot_name.split('/'))
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
  dot_map += '"'+under_dot_name+'": \'{"id":"'+under_dot_name+'","template":"assets/'+dot_name+'_line.svg","pathHistory":{"paths":[],"startX":null,"startY":null,"x":null,"y":null},"things":[{"id":"dot","type":"dot","dotData":{"x":['+','.join(x)+'],"y":['+','.join(y)+'],"c":['+','.join(c)+']}}]}\',\n'

dot_map += '};'

with open('dot.dart','w') as json_file:
  json_file.write(dot_map)