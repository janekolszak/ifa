main:
	python setup.py build_ext --inplace

install:
	python setup.py build_ext --inplace
	python setup.py install

clean:
	rm -rf ./build ./ifa/*.so ./ifa/*.pyc
	# rm -rf ./build ./ifa/utils.cpp ./ifa/utils.so ./ifa/*.pyc
