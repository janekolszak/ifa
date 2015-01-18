main:
	python setup.py build_ext --inplace

install:
	python setup.py install

pypi:
	python setup.py sdist upload -r pypi

clean:
	rm -rf ./build ./ifa/*.so
	rm -rf ./build ./ifa/*.pyc
	rm -rf ./build ./ifa/utils.cpp
	rm -rf ./build ./ifa/distribution.cpp
	rm -rf ./build ./ifa/divergence.cpp
	rm -rf ./build ./ifa/connections.cpp
	rm -rf ./build ./ifa/MANIFEST