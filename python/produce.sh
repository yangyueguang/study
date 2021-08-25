python pack_sub.py build_ext  --inplace
rm -rf build
rm -rf dist
rm -rf py_libx.egg-info
rm -f libx/document.c
mv libx/document.py .
python setup.py sdist build
twine upload dist/*
mv document.py libx/
rm -f libx/document.cpython-38-darwin.so
rm -rf build
rm -rf dist
rm -rf py_libx.egg-info
