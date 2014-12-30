#include "ifa.hpp"
#include <cmath>

inline
double log2(double x)
{
    return ::log(x) / ::log(2);
}

double c_entropy(const std::vector<double> &probabilities)
{
    double entropy = 0;

    for (const double p : probabilities) {
        entropy += p * log2(p);
    }

    return -1 * entropy;
}

double c_entropy_of_distribution(const Distribution &distribution)
{
    double entropy = 0;

    for (const auto &entry : distribution) {
        entropy += entry.second * ::log(entry.second) / ::log(2);
    }

    return -1 * entropy;
}

double c_jsd(const std::vector<Distribution> &distributions,
             const std::vector<double> &weights)
{
    Distribution sumDist = distributions[0];
    for (auto it = sumDist.begin();
            it != sumDist.end();
            ++it) {

        it->second *=  weights[0];
    }


    for (unsigned i = 1; i < distributions.size(); ++i) {
        for (auto it = distributions[i].begin();
                it != distributions[i].end();
                ++it) {

            sumDist[it->first] += it->second * weights[i];
        }
    }

    double entropySum = 0;
    for (unsigned i = 0; i < distributions.size(); ++i) {
        entropySum += c_entropy_of_distribution(distributions[i]) * weights[i];
    }

    return c_entropy_of_distribution(sumDist) - entropySum;
}

Distribution c_common(const Distribution &p,
                      const Distribution &q)
{
    // Get common part
    Distribution commonDistr;
    for (const auto &entry : p) {
        if (q.count(entry.first)) {
            commonDistr[entry.first] = entry.second;
        }
    }

    // and normalize it
    double sum = 0;
    for (const auto &entry : commonDistr) {
        sum += entry.second;
    }

    for (auto &entry : commonDistr) {
        entry.second /= sum;
    }

    return commonDistr;
}

inline
int sign(double x)
{
    return (x > 0) ? 1 : ((x < 0) ? -1 : 0);
}

int c_direction(const Distribution &p,
                const Distribution &q)
{
    Distribution cP = c_common(p, q);

    if (p.empty()) {
        return 0;
    }

    Distribution cQ = c_common(q, p);

    double tp = c_entropy_of_distribution(cP) / (cP.size() / p.size());
    double tq = c_entropy_of_distribution(cQ) / (cQ.size() / q.size());

    return -1 * sign(tp - tq);
}

double c_index_d(const Distribution &p,
                 const Distribution &q,
                 const double p_weight,
                 const double q_weight)
{
    double wp = p_weight / (p_weight + q_weight);
    double wq = q_weight / (p_weight + q_weight);
    double d = c_jsd({p, q}, {wp, wq});
    return d / (-wp * log2(wp) - wq * log2(wq));
}

// std::map<DistributionID, std::vector<DistributionID>>
//         c_compute_connections(const std::map<DistributionID, Distribution> distributions)
// {
//     std::map<DistributionID, std::vector<DistributionID>> connections;

//     for (const auto it = distributions.begin();
//             it != distributions.end();
//             ++it ) {
        
//     }
// }
