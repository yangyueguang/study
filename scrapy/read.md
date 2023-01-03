# scrapy爬虫
外面还有一个scrapy.cfg，配置的是这个文件夹
## require.txt
```text
numpy==1.18.0
openpyxl==3.0.2
redis==3.3.11
requests==2.22.0
Scrapy==1.8.0
scrapy-redis==0.6.8
urllib3==1.25.7
urlparser==0.1.2
selenium==3.141.0
PyMySQL==0.9.3
pymongo==3.10.1
```
## run.sh
```bash
scrapy_name='YY'
function all_run() {
  projects=(jincai zhongyang difang yidong liantong jianyu dongfang nanfang dianli cgzb center huobiao jundui jungong)
  for var in ${projects[@]}
  do
    echo $var
    scrapy crawl $var
  done
}

function run_all() {
    scrapy crawlall
}

function create() {
    scrapy startproject $scrapy_name
}

function run() {
    scrapy crawl $scrapy_name
}

function output_scrapy() {
    scrapy crawl $scrapy_name -o a.json
}

function output_requirs() {
    pip3 freeze > require.txt
}

function send() {
    python3 task.py
}
```

## debug scrapy
```python
import os
import sys
from scrapy.cmdline import execute
def debug_scrapy():
    scrapy_name = 'sun'
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    execute(['scrapy', 'crawl', scrapy_name])
```

