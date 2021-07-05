python pack_sub.py build_ext  --inplace
rm -rf build
rm -rf dist
rm -rf py_extractor.egg-info
rm -f extractor/document.c
mv extractor/document.py .
python setup.py sdist build
twine upload dist/*
mv document.py extractor/
rm -f extractor/document.cpython-38-darwin.so
rm -rf build
rm -rf dist
rm -rf py_extractor.egg-info
