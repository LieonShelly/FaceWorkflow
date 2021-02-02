//
//  EditLayer.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/2/1.
//

#include "EditLayer.hpp"
#include "Texture.hpp"

EditLayer::EditLayer() {
    layerID = "undefine";
    layerType = LayerType::Unknow;
}

EditLayer::EditLayer(string layerId) {
    layerID = layerId;
}

EditLayer::~EditLayer() {
    
}

string EditLayer::getLayerId() {
    return layerID;
}

bool EditLayer::isShadowLayer() {
    return false;
}

PGRect EditLayer::getRealLayerRect(PGRect) {
    return PGRectZero;
}

void EditLayer::setLayersRect(PGRect layRect) {
    
}

void EditLayer::setLayerRect(PGRect layRect) {
    
}
PGRect EditLayer::getLayerRect() {
    return PGRectZero;
}

void EditLayer::setLayersScaleFactor(float factor) {
    
}

void EditLayer::setLayerScaleFactor(float factor) {
    
}

void EditLayer::getLayerScaleFactor(float factor) {
    
}

void EditLayer::setLayersOffsetFactor(PGPoint factor){
    
}
void EditLayer::setLayerOffsetFactor(PGPoint factor){
    
}
PGPoint EditLayer::getLayerOffsetFactor(){
    return PGPointZero;
}

void EditLayer::setLayersBlendMode(LayerBlendMode::Enum mode){
    
}
void EditLayer::setLayerBlendMode(LayerBlendMode::Enum mode) {
    
}
LayerBlendMode::Enum EditLayer::getLayerBlendMode() {
    return LayerBlendMode::Normal;
}

void EditLayer::setAllLayerIsHidden(bool hidden) {
    
}
void EditLayer::setLayerIsHidden(bool hidden) {
    
}

void EditLayer::setLayerOpacity(float opacity) {
    
}
void EditLayer::setAllLayerOpacity(float opacity) {
    
}

void EditLayer::setLayerAngle(float angle) {
    
}
void EditLayer::setLayersAngle(float angle) {
    
}
float EditLayer::getLayerAngle() {
    return 0.0;
}

EditLayer * EditLayer::hitTest(PGPoint point) {
    return this;
}
bool EditLayer::pointInside(PGPoint point) {
    return false;
}
