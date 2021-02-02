//
//  ImageEditLayer.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/2/1.
//

#include "ImageEditLayer.hpp"

ImageEditLayer::ImageEditLayer(string layerId):EditLayer(layerId) {
    layerType = LayerType::ImageLayer;
    imageTexture = new Texture();
    imageMaskTexture = new Texture();
    imageTexture->createFrameBuffer();
}
ImageEditLayer:: ~ImageEditLayer() {}

EditLayer * ImageEditLayer::hitTest(PGPoint point) {
    return this;
}

bool ImageEditLayer::pointInside(PGPoint point) {
    return false;
}

void ImageEditLayer::setupImageTexture(string layerId, Texture *imageTexture)  {}

void ImageEditLayer::setupImageTexture(string layerId, Texture *imageTexture, string texturePath, float &textureScaleFactor)  {}

EditLayerContentErrorType::Enum ImageEditLayer:: setupMaskTexture(string layerID, Texture *maskTexture)  {
    return EditLayerContentErrorType::Success;
}

EditLayerContentErrorType::Enum ImageEditLayer:: getImageTexture(std::string layerID, Texture *&imageTexture) {
    return EditLayerContentErrorType::Success;
}

EditLayerContentErrorType::Enum ImageEditLayer::getMaskTexture(string layerID, Texture *&maskTexture) {
    return EditLayerContentErrorType::Success;
}

EditLayerContentErrorType::Enum ImageEditLayer:: exchangeImageTexture(string layerID, Texture *&imageTexture) {
    return EditLayerContentErrorType::Success;
}

void ImageEditLayer::setupImageTexture(string texturePth, float &textureScaleFactor)  {}

void ImageEditLayer::setupImageTexture(Texture *imageTexture)  {}

void ImageEditLayer::exchangeImageTexture(Texture *&imageTexture)  {}

void ImageEditLayer::setupMaskTexture(Texture *maskTexture)  {}

Texture *ImageEditLayer::getImageTexture() {
    return nullptr;
}

Texture *ImageEditLayer::getMaskTexture() {
    return nullptr;
}
