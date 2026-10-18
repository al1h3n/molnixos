#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES3/gl32.h>
#include "Render/MapModel.hpp"
#include "Render/PlayerModel.hpp"
#include <array>
#include <chrono>
#include <cmath>
#include <iostream>
#include <stdexcept>
#include <thread>

static void require(bool ok, const char* message) {
    if (!ok) throw std::runtime_error(message);
}
static std::array<unsigned char,4> pixel(int x) {
    std::array<unsigned char,4> p{};
    glReadPixels(x,32,1,1,GL_RGBA,GL_UNSIGNED_BYTE,p.data());
    require(glGetError()==GL_NO_ERROR,"OpenGL readback failed");
    return p;
}
static void verify(bool authored, const char* model) {
    const auto a=pixel(16), b=pixel(48);
    std::cout<<model<<" authored="<<authored<<" left="<<int(a[0])<<","<<int(a[2])
             <<" right="<<int(b[0])<<","<<int(b[2])<<std::endl;
    require(b[0]>110 && b[0]<145 && b[2]>110 && b[2]<145,"Smooth material must remain linearly filtered");
    if (authored) require(a[0]<15 && a[2]>240,"Authored NEAREST sampler was ignored");
    else require(a[0]>110 && a[0]<145,"Missing sampler must retain smooth defaults");
}
int main(int argc,char** argv) {
    try {
        require(argc==3 || argc==4,"usage: check-sampling authored.glb default.glb [avatar.glb]");
        EGLDisplay display=eglGetPlatformDisplay(EGL_PLATFORM_SURFACELESS_MESA,EGL_DEFAULT_DISPLAY,nullptr);
        require(eglInitialize(display,nullptr,nullptr),"EGL initialization failed");
        require(eglBindAPI(EGL_OPENGL_ES_API),"GLES binding failed");
        EGLint configAttrs[]={EGL_SURFACE_TYPE,EGL_PBUFFER_BIT,EGL_RENDERABLE_TYPE,EGL_OPENGL_ES3_BIT,
            EGL_RED_SIZE,8,EGL_GREEN_SIZE,8,EGL_BLUE_SIZE,8,EGL_ALPHA_SIZE,8,EGL_DEPTH_SIZE,24,EGL_NONE};
        EGLConfig config{}; EGLint count{};
        require(eglChooseConfig(display,configAttrs,&config,1,&count) && count,"No EGL configuration");
        EGLint surfaceAttrs[]={EGL_WIDTH,64,EGL_HEIGHT,64,EGL_NONE};
        EGLint contextAttrs[]={EGL_CONTEXT_CLIENT_VERSION,3,EGL_NONE};
        EGLSurface surface=eglCreatePbufferSurface(display,config,surfaceAttrs);
        EGLContext context=eglCreateContext(display,config,EGL_NO_CONTEXT,contextAttrs);
        require(eglMakeCurrent(display,surface,surface,context),"EGL context failed");
        glViewport(0,0,64,64);
        for (int fixture=1;fixture<=2;++fixture) {
            const bool authored=fixture==1;
            H3D::CMapModel map;
            require(map.load(argv[fixture],{0,0,0},{0,0,0},{1,1,1}),"Map load failed");
            for (int i=0;i<500 && !map.loaded();++i) { map.poll();std::this_thread::sleep_for(std::chrono::milliseconds(2)); }
            require(map.loaded(),"Map upload failed");map.setFlat(true);
            glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
            map.draw(H3D::Mat4::identity(),{0,0,1});verify(authored,"map");
            map.destroy();
            H3D::CPlayerModel player;
            require(player.load(argv[fixture]),"Player load failed");
            player.setFlat(true);player.setPose({0,0,0},0,{1,1,1},{0,0,0},{0,0,0});player.update(0);
            glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
            player.draw(H3D::Mat4::identity(),{0,0,1});verify(authored,"player");
            player.destroy();
        }
        if (argc==4) {
            H3D::CPlayerModel avatar;
            require(avatar.load(argv[3]) && avatar.programValid(),"Provided avatar failed native load/shader setup");
            require(avatar.primCount()==6 && avatar.animationCount()==4,"Avatar geometry or animation clips are missing");
            require(avatar.setAnim(H3D::CPlayerModel::EState::Walk,"Walk"),"Walk clip not found");
            avatar.update(0);
            const auto rest=avatar.nodeWorld(3);
            avatar.setState(H3D::CPlayerModel::EState::Walk);avatar.update(.2f);
            const auto walking=avatar.nodeWorld(3);
            float changed=0;
            for (int i=0;i<16;++i) changed+=std::abs(rest.m[i]-walking.m[i]);
            require(changed>.01f,"Avatar Walk animation did not change its pose");
            avatar.destroy();
            std::cout<<"PASS: supplied-skin avatar loads natively and its Walk animation moves"<<std::endl;
        }
        std::cout<<"PASS: native map/player loaders honor independent samplers sharing an image"<<std::endl;
    } catch (const std::exception& e) {std::cerr<<e.what()<<std::endl;return 1;}
}
