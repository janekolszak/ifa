# The MIT License (MIT)
#
# Copyright (c) 2014 Jan Olszak (j.olszak@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import cython
import numpy as np
cimport numpy as np
from c_declarations cimport Distribution as CDistribution

from libcpp.string cimport string

cdef class Distribution:
    def __cinit__(self, events = None, probabilities = None):
        self.thisptr = new CDistribution()

        if (events is not None) and (probabilities is not None):
            for e, p in zip(events,probabilities):
                self.thisptr.insert(e, p)


    def __dealloc__(self):
        del self.thisptr

    def __iter__(self):
        self.thisptr.startIteration()
        return self

    def __next__(self):
        try:
            return self.thisptr.next()
        except IndexError:
            raise StopIteration()

    def __getitem__(self, event):
        if type(event) is not str:
            raise TypeError("Events should be str")

        try:
            return self.thisptr.get(event)
        except IndexError:
            raise KeyError("No such event")

    def __setitem__(self, event, prob):
        if type(event) is not str:
            raise TypeError("Events should be str")

        self.thisptr.set(event, prob)

    def __delitem__(self, event):
        if type(event) is not str:
            raise TypeError("Events should be str")

        if not self.thisptr.contains(event):
            raise KeyError("No such event")

        self.thisptr.erase(event)

    def __contains__(self, event):
        return self.thisptr.contains(event)

    def __len__(self):
        return self.thisptr.size()

    def __div__(self, q):
        return self.thisptr 

    def size(self):
        return self.thisptr.size()

    def insert(self, event, probability):
        self.thisptr.insert(event, probability)

    def normalize(self):
        self.thisptr.normalize()

    def entropy(self):
        return self.thisptr.entropy()

    def contains(self, event):
        return self.thisptr.contains(event)

# THE line below does not work:
# from cython.operator cimport dereference, preincrement

# This one does work
cimport cython.operator as co

from cython.operator cimport dereference, preincrement
cimport cython.operator as co

# cdef extern from "myheader" namespace "my":
#     cppclass iterator:
#         iterator& operator++() 
#         bint operator==(iterator)
#         int operator*()

# cdef class wi:
#     cdef iterator* it
#     cdef iterator* end

#     def __cinit__(self, ):
#         self.end = new iterator()

#     # Most likely, you will be calling this directly from this 
#     # or another Cython module, not from Python. 
#     cdef set_iter(self, iterator* it):
#         self.it = it

#     def __iter__(self):
#         return self 

#     def __dealloc__(self):
#         # This works by calling "delete" in C++, you should not
#         # fear that Cython will call "free"
#         del self.it 
#         del self.end

#     def __next__(self):
#         # This works correctly by using "*it" and "*end" in the code,
#         if  co.dereference( self.it ) == co.dereference( self.end ) :
#             raise StopIteration()
#         result =  co.dereference( co.dereference( self.it ) )
#         # This also does the expected thing.
#         co.preincrement(  co.dereference( self.it ) )
#         return result