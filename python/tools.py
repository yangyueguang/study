# coding=utf-8
import os
import requests
import numpy as np
import pandas as pd
import pymysql.cursors
import aiohttp


def verify_proxy(proxy):
    with aiohttp.ClientSession(connector=aiohttp.TCPConnector(verify_ssl=False)) as session:
        res = session.get('http://www.baidu.com', proxy=f'http://{proxy}', timeout=15, allow_redirects=False)
        return res.status == 200


class Work(object):
    def run(self, excel_path):
        headers = []
        file_paths = [os.path.join(path, file_name) for task_id in self.task_ids for path, dir_list, file_list in
                     os.walk("{}/{}/".format(self.path, task_id)) for
                     file_name in file_list if file_name.endswith('pdf')]
        file_paths.sort()
        result = np.empty((len(file_paths), len(self.fields) * 4 + 1), dtype='U1000')
        writer = pd.ExcelWriter(excel_path, engine='xlsxwriter')
        df = pd.DataFrame(result, columns=headers)
        df.to_excel(writer, sheet_name='result', startrow=0, header=headers, index=False)
        workbook = writer.book
        sheet = writer.sheets['result']
        sheet.set_column(0, result.shape[0], 16)
        header_format = workbook.add_format({'bold': True, 'align': 'vcenter', 'text_wrap': True})
        sheet.set_row(0, cell_format=header_format)
        bad_format = workbook.add_format({'bold': True, 'text_wrap': True, 'valign': 'top', 'align': 'right', 'fg_color': '#FF0000', 'border': 2})
        for row, v in enumerate(result):
            for column, vv in enumerate(v):
                if column > 0 and (column - 1) % 4 in [2, 3] and vv < 1:
                    sheet.write(row + 1, column, vv, bad_format)
        writer.save()

