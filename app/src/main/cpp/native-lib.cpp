#include <jni.h>
#include <android/log.h>
#include <string>

extern "C" void BeefMain(int argc, char** argv);

extern "C" JNIEXPORT void JNICALL Java_com_beeflang_tester_MainActivity_nativeBeefMain(JNIEnv*, jobject) {
    BeefMain(0, nullptr);
}

struct Bounds
{
     double l, b, r, t;
};

extern "C" void* cpBoxShapeNew2(void* handle, Bounds bounds, double radius) {
    __android_log_print(ANDROID_LOG_INFO, "BEEFJNI", "cpBoxShapeNew2 %p, (%f %f %f), %f", handle, bounds.l, bounds.b, bounds.r, bounds.t, radius);
    return handle;
}

struct Vec2
{
     float x, y;
};

enum class Cond : uint32_t
{
    SomeShit = 7
};

 extern "C" void* imguiSetNextWindowPos(Vec2 pos, Cond cond, Vec2 pivot) {
    __android_log_print(ANDROID_LOG_INFO, "BEEFJNI", "imguiSetNextWindowPos (%f %f), %d, (%f %f)", pos.x, pos.y, cond, pivot.x, pivot.y);
    return (void*)0x1234;
}
