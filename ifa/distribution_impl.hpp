/*
The MIT License (MIT)

Copyright (c) 2014 Jan Olszak (j.olszak@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#ifndef IFA_DISTRIBUTION_HPP
#define IFA_DISTRIBUTION_HPP

#include <map>
#include <string>
#include <utility>

namespace ifa {

class Distribution {
public:
    typedef std::map<std::string, double> Map;

    Distribution();
    ~Distribution();

    unsigned int size() const;
    bool isEmpty() const;


    bool contains(const std::string &event) const;
    double get(const std::string &event) const;
    void set(const std::string &event, const double probability);
    void erase(const std::string &event);
    void insert(const std::string &event, const double probability);

    void normalize();

    void startIteration();
    std::pair<std::string, double> next();

    double entropy() const;

    Map dist;

private:
    Map::iterator m_it;
};


void common(const Distribution *p, const Distribution *q, Distribution *result);
int direction(const Distribution *p, const Distribution *q);

} // namespace ifa

#endif // IFA_DISTRIBUTION_HPP