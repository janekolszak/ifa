from libcpp.map    cimport map
from libcpp.vector cimport vector
from libcpp.string cimport string

from cython.parallel import prange
from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free
import numpy as np
cimport numpy as np

import cython
import ctypes

ctypedef map[string, double] Distribution

cdef extern from "ifa.cpp":
    double c_entropy(vector[double] probabilities) nogil
    double c_entropy_of_distribution(Distribution distribution) nogil
    double c_jsd(vector[Distribution] distributions, vector[double] weights) nogil
    Distribution c_common(Distribution p, Distribution q) nogil
    int c_direction(Distribution p, Distribution q) nogil
    int c_index_d(Distribution p, Distribution q, double p_weight, double q_weight) nogil


cpdef entropy(vector[double] probabilities):
    return c_entropy(probabilities)


cpdef jsd(vector[Distribution] distributions, vector[double] weights ):
    return c_jsd(distributions, weights)


cpdef common(Distribution p, Distribution q):
    return c_common(p,q)


cpdef direction(Distribution p, Distribution q):
    return c_direction(p, q)


cpdef index_d(Distribution p, Distribution q, double p_weight, double q_weight):
    return c_index_d(p, q, p_weight, q_weight)


def compute_entropy(vector[Distribution] distributions):
    cdef np.ndarray[double, ndim=1, mode='c'] entropies
    entropies = np.empty((distributions.size(),), dtype = ctypes.c_double)

    cdef int i
    for i in prange(distributions.size(), nogil=True):
        entropies[i] = c_entropy_of_distribution(distributions[i])

    return entropies


def compute_data(vector[Distribution] distributions, vector[double] weights):
    cdef int n = distributions.size()
    cdef int ret_size = (n - 1) * n / 2

    cdef np.ndarray[int, ndim=1, mode='c'] pIdxs
    cdef np.ndarray[int, ndim=1, mode='c'] qIdxs
    cdef np.ndarray[double, ndim=1, mode='c'] index_ds
    cdef np.ndarray[int, ndim=1, mode='c'] directions

    pIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    qIdxs = np.empty((ret_size,), dtype = ctypes.c_int)
    index_ds = np.empty((ret_size,), dtype = ctypes.c_double)
    directions = np.empty((ret_size,), dtype = ctypes.c_int)

    cdef int i, j, k
    print "Compute Data"
    for i in range(1, n):
        print i
        for j in prange(i, n, nogil=True):
            k = n * (i - 1) + j - i * (i - 1) / 2 - i
            pIdxs[k] = i
            qIdxs[k] = j
            index_ds[k] = c_index_d(distributions[i], distributions[j], weights[i], weights[j])
            directions[k] = c_direction(distributions[i], distributions[j])

    return (pIdxs, qIdxs, index_ds, directions)