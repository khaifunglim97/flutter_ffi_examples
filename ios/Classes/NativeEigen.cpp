#include <string>
#include <iostream>
#include <sstream>
#include "Eigen/Dense"

using Eigen::MatrixXd;

extern "C" __attribute__((visibility("default"))) __attribute__((used))
const char* eigen_matrix( void ) {
    MatrixXd m(2, 2);
    m(0, 0) = 3;
    m(1, 0) = 2.5;
    m(0, 1) = -1;
    m(1, 1) = m(1, 0) + m(0, 1);

    std::stringstream buffer;
    buffer << m;
    const char* res = buffer.str().c_str();
    return strdup(res);
}