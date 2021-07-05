pdf_path = '/Users/super/Downloads/a.pdf'
from extractor.document import Document, Page
doc = Document(pdf_path)
page = doc[8]
p = Page(doc, page.number, *page.rect.irect)
p.parse()
a = p.meta_list
print(a)
