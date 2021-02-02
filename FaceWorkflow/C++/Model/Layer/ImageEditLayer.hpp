//
//  ImageEditLayer.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/2/1.
//

#ifndef ImageEditLayer_hpp
#define ImageEditLayer_hpp
#include "LayerStackDefine.hpp"
#include <stdio.h>
#include "EditLayer.hpp"
#include <string>
#include "Texture.hpp"
#include "LayerStackDefine.hpp"
#include "CommonDefine.hpp"

using namespace std;

class ImageEditLayer: public EditLayer {
    EditLayer * hitTest(PGPoint point) override;
    bool pointInside(PGPoint point) override;
    
    virtual void setupImageTexture(string layerId, Texture *imageTexture);
    
    virtual void setupImageTexture(string layerId, Texture *imageTexture, string texturePath, float &textureScaleFactor);
    
    virtual EditLayerContentErrorType::Enum setupMaskTexture(string layerID, Texture *maskTexture);
    
    
    virtual EditLayerContentErrorType::Enum getImageTexture(std::string layerID, Texture *&imageTexture);
    
    
    virtual EditLayerContentErrorType::Enum getMaskTexture(string layerID, Texture *&maskTexture);
    
    virtual EditLayerContentErrorType::Enum exchangeImageTexture(string layerID, Texture *&imageTexture);
public:
    Texture *imageTexture { nullptr };
    Texture *imageMaskTexture { nullptr };
    float ranCenAngle{0};
    float ranCenYRatio {0.5};
    bool hasMirror {false};
    
    ImageEditLayer(string layerId);
    virtual ~ImageEditLayer();
    
    virtual void setupImageTexture(string texturePth, float &textureScaleFactor);
    
    virtual void setupImageTexture(Texture *imageTexture);
    
    virtual void exchangeImageTexture(Texture *&imageTexture);

    virtual void setupMaskTexture(Texture *maskTexture);

    virtual Texture *getImageTexture();
    
    virtual Texture *getMaskTexture();
};

#endif /* ImageEditLayer_hpp */
