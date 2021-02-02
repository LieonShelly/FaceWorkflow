//
//  EditLayer.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/2/1.
//

#ifndef EditLayer_hpp
#define EditLayer_hpp
#include <string>
#include <stdio.h>
#include "CommonDefine.hpp"
#include "BlendMode.hpp"

using namespace std;

class Texture;

class EditLayer {
    string layerID;
    
protected:
    void pixelInTexture(Texture *imgTexure, PGPoint point, unsigned char *outputInfo);
    
public:
    PGRect layerRect;
    float scaleFactor = 1.0f;
    PGPoint offsetFactor {0.0, 0.0};
    LayerType::Enum layerType;
    bool isHidden = false;
    float opacity = 0.0;
    LayerBlendMode::Enum blendMode = LayerBlendMode::Normal;
    float angle = 0.0;
    
    EditLayer();
    EditLayer(string layerId);
    
    virtual ~EditLayer();
    string getLayerId();
    virtual bool isShadowLayer();
    virtual PGRect getRealLayerRect(PGRect rect = PGRectZero);
    virtual void setLayersRect(PGRect layRect);
    virtual void setLayerRect(PGRect layRect);
    virtual PGRect getLayerRect();
    
    virtual void setLayersScaleFactor(float factor);
    virtual void setLayerScaleFactor(float factor);
    virtual void getLayerScaleFactor(float factor);
    
    virtual void setLayersOffsetFactor(PGPoint factor);
    virtual void setLayerOffsetFactor(PGPoint factor);
    virtual PGPoint getLayerOffsetFactor();
    
    virtual void setLayersBlendMode(LayerBlendMode::Enum mode);
    virtual void setLayerBlendMode(LayerBlendMode::Enum mode);
    virtual LayerBlendMode::Enum getLayerBlendMode();
    
    virtual void setAllLayerIsHidden(bool hidden);
    virtual void setLayerIsHidden(bool hidden);
    
    virtual void setLayerOpacity(float opacity);
    virtual void setAllLayerOpacity(float opacity);
    
    virtual void setLayerAngle(float angle);
    virtual void setLayersAngle(float angle);
    virtual float getLayerAngle();
    
    virtual EditLayer * hitTest(PGPoint point);
    virtual bool pointInside(PGPoint point);
};
#endif /* EditLayer_hpp */
