main:
	python setup.py build_ext --inplace

install:
	python setup.py install

test:
	make clean
	make
	./test.py

pypi:
	python setup.py sdist upload -r pypi

clean:
	rm -rf ./build ./ifa/*.so
	rm -rf ./build ./ifa/*.pyc
	rm -rf ./build ./ifa/MANIFEST