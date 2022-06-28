#include <opencv2/imgcodecs.hpp>

using namespace std;
using namespace cv;

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t opencv_img_pixels( unsigned char *byteData, int32_t byteSize ) {
    Mat src, dst;

    vector<unsigned char> ImVec(byteData, byteData + byteSize);
    src = imdecode(ImVec, IMREAD_COLOR);
    if (src.empty())
    {
        printf(" Error opening image\n");
        return -1;
    }

    return src.total();
}
