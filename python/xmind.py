import os
import re
import json
import html
import xmind
from zipfile import ZipFile
from xml.dom import minidom
from pathlib import Path
from xmind.core.topic import TopicElement
from xmind.core.mixin import WorkbookMixinElement


class ImageElement(WorkbookMixinElement):
    TAG_NAME = 'xhtml:img'

    def __init__(self, name, node=None, ownerWorkbook=None):
        super(ImageElement, self).__init__(node, ownerWorkbook)
        self.setAttribute('align', 'left')
        self.setAttribute('svg:height', '30')
        self.setAttribute('svg:width', '30')
        for i in os.listdir('markers'):
            for j in os.listdir(f'markers/{i}'):
                if name in j:
                    self.setAttribute('xhtml:src', f'xap:markers/{i}/{j}')



class Mind(object):
    def __init__(self, name):
        super(Mind, self).__init__()
        self.name = name
        self.content = []
        self.is_zen = False
        self.workbook = xmind.load(name)
        if not os.path.exists(name):
            return
        with ZipFile(name) as m:
            if 'content.json' in m.namelist():
                self.is_zen = True
                d = m.open('content.json').read().decode('utf-8')
                self.content = json.loads(d)

    def save(self, name=None):
        if not self.is_zen:
            xmind.save(self.workbook, name or self.name)
        else:
            with ZipFile(name or self.name, 'w') as x:
                x.writestr('content.json', json.dumps(self.content, ensure_ascii=False, indent=3))
                manifest = '{"file-entries":{"content.json":{},"metadata.json":{},"":{}}}'
                metadata = '{"creator":{"name":"Vana","version":"10.1.1.202003310622"}}'
                x.writestr('manifest.json', manifest)
                x.writestr('metadata.json', metadata)

    def parse_mm(self, name):
        print(name)
        with open(name, encoding='gbk') as f:
            xml = f.read()
        xml = html.unescape(xml)
        xml = xml.replace('&', '').replace(r'"<', '"').replace('=、>，>=，<，<=，<>', '')
        xml = re.sub(r'<(\d+|高|正确|分工|低|P|EXCEL|,|=|>)', r'\1', xml)
        xml = re.sub(r'TEXT="(.*?)">', lambda x: 'TEXT="' + re.split(r' VSHIFT| VGAP', x.group(1).replace('"', ''))[0] + '">', xml)
        with open('tmp', 'w') as f:
            f.write(xml)
        dom = minidom.parseString(xml).documentElement
        sheet = self.workbook.getPrimarySheet()
        sheet.setTitle(Path(name).name)
        topic = sheet.getRootTopic()
        topic.setTitle('map')
        node = [i for i in dom.childNodes if i.nodeName == 'node'][0]
        self.get_node_data(node, topic)
        self.save()

        with ZipFile(self.name, 'a') as f:
            manifest = '''
                <manifest xmlns="urn:xmind:xmap:xmlns:manifest:1.0" password-hint="">
                    %s
                    <file-entry full-path="markers/" media-type=""/>
                    <file-entry full-path="content.xml" media-type="text/xml"/>
                    <file-entry full-path="META-INF/" media-type=""/>
                    <file-entry full-path="META-INF/manifest.xml" media-type="text/xml"/>
                    <file-entry full-path="meta.xml" media-type="text/xml"/>
                    <file-entry full-path="styles.xml" media-type="text/xml"/>
                    <file-entry full-path="markers/markerSheet.xml" media-type="text/xml"/>
                </manifest>
                '''
            marks = '<marker-sheet xmlns="urn:xmind:xmap:xmlns:marker:2.0" version="2.0"> %s </marker-sheet>'
            manis = []
            mars = []
            for i in os.listdir('markers'):
                mars.append(f'<marker-group id="{i}" name="{i}" singleton="true">')
                for j in os.listdir('markers/' + i):
                    icon_name = f'{i}/{j}'
                    f.write(f'markers/{icon_name}')
                    mars.append(f'<marker id="{j.split(".")[0]}" name="{j}" resource="{icon_name}"/>')
                    manis.append(f'<file-entry full-path="markers/{icon_name}" media-type="image/{j.split(".")[-1].replace("jpg", "jpeg")}"/>')
                mars.append(f'</marker-group>')

            manifest = manifest % '\n'.join(manis)
            marks = marks % '\n'.join(mars)
            f.writestr('META-INF/manifest.xml', manifest)
            f.writestr('markers/markerSheet.xml', marks)

    def get_node_data(self, n: minidom.Element, superTopic: TopicElement):
        topic = superTopic.addSubTopic()
        for i, c in enumerate(n.childNodes):
            if c.nodeName in ['font', 'edge', 'head', 'style', 'arrowlink', '#text', '#comment', 'hook']:
                continue
            elif c.nodeName == 'node':
                self.get_node_data(c, topic)
            elif c.nodeName == 'icon':
                mark = c.getAttribute('BUILTIN')
                # icon = ImageElement(mark, None, topic.getOwnerWorkbook())
                if i == len(n.childNodes) - 1:
                    # superTopic.appendChild(icon)
                    superTopic.addMarker(mark)
                else:
                    # topic.appendChild(icon)
                    topic.addMarker(mark)
            elif c.nodeName in ['richcontent', 'body']:
                n.setAttribute('TEXT', '\n'.join([i.toxml() for i in c.childNodes if i.nodeName == 'p']))
            else:
                raise Exception()
        title = n.getAttribute('TEXT')
        topic.setTitle(title)
        link = n.getAttribute('LINK')
        if link:
            topic.setURLHyperlink(link)


if __name__ == '__main__':
    for i in os.listdir('xmind'):
        os.remove(f'xmind/{i}')
    for m in os.listdir('mm'):
        mind = Mind(f'xmind/{m}.xmind')
        mind.parse_mm('mm/' + m)




