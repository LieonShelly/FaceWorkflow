//
//  CommonDefine.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

#ifndef CommonDefine_hpp
#define CommonDefine_hpp

#include <stdio.h>

struct PGScaleAnchor {
    float centerX;
    float centerY;
    float dis; // 放缩两点间距离
};

struct PGPoint {
    float x;
    float y;
    
    PGPoint(void):x(0.f),y(0.f){}
    
    PGPoint(float X, float Y):x(X),y(Y){}
    
    inline PGPoint operator + (PGPoint point) {
        return PGPoint(x + point.x, y + point.y);
    }
    
    inline void operator += (PGPoint point) {
        x += point.x;
        y += point.y;
    }
    
    inline PGPoint operator - (PGPoint point) {
        return PGPoint(x - point.x, y - point.y);
    }
    
    inline void operator -= (PGPoint point) {
        x -= point.x;
        y -= point.y;
    }
    
    inline PGPoint operator * (float multiplier) {
        return PGPoint(x * multiplier, y * multiplier);
    }
    
    inline PGPoint operator / (float multiplier) {
        return PGPoint(x / multiplier, y / multiplier);
    }
    
    inline bool operator == (PGPoint anotherPoint) {
        return x == anotherPoint.x && y == anotherPoint.y;
    }
};

static PGPoint PGPointZero = PGPoint{0.0, 0.0};

struct PGSize {
    float width;
    float height;
    
    PGSize(void):
    width(0.f),
    height(0.f)
    {}
    
    PGSize(float Width, float Height):
    width(Width),
    height(Height) {
    }
    
    bool operator == (const PGSize& other) const {
        bool bRet = true;
        if (&other != this)
        {
            bRet = ((width == other.width) && (height == other.height));
        }
        return bRet;
    }
};

static PGSize PGSizeZero = PGSize{0.0, 0.0};

struct PGRect {
    float x1, y1;
    float x2, y2;
    
    PGRect(void):x1(0.f), y1(0.f), x2(0.f), y2(0.f) {}
    
    PGRect(const PGRect& other):
    x1(other.x1),
    y1(other.y1),
    x2(other.x2),
    y2(other.y2) {}
    
    PGRect(float x1, float y1, float x2, float y2):
    x1(x1),
    y1(y1),
    x2(x2),
    y2(y2) {}
    
    PGRect(const PGPoint& pt, const PGSize& size):
    x1(pt.x),
    y1(pt.y),
    x2(pt.x + size.width),
    y2(pt.y + size.height) {}
    
    PGRect& operator = (const PGRect& other) {
        if (&other != this) {
            x1 = other.x1;
            y1 = other.y1;
            x2 = other.x2;
            y2 = other.y2;
        }
        return *this;
    }
    
    bool operator == (const PGRect& other) const {
        bool bRet = true;
        if (&other != this)
        {
            bRet = ((x1 == other.x1) &&
                    (y1 == other.y1) &&
                    (x2 == other.x2) &&
                    (y2 == other.y2));
        }
        return bRet;
    }
    
    void copyTo(float buffer[4])const {
        buffer[0] = x1;
        buffer[1] = y1;
        buffer[2] = x2;
        buffer[3] = y2;
    }
    
    float width(void)const {
        return x2 - x1;
    }
    
    float height(void)const {
        return y2 - y1;
    }
    
    PGPoint center() const {
        return PGPoint{static_cast<float>(x1+(x2-x1) * 0.5), static_cast<float>(y1+(y2-y1) * 0.5)};
    }
    
    PGSize size() const {
        return PGSize{static_cast<float>(x2-x1), static_cast<float>(y2-y1)};
    }
    
    bool contain(PGPoint point) const {
        return (((point.x >= x1) && (point.x <= x2)) && ((point.y >= y1) && (point.y <= y2)));
    }
    
    void scale(float scaleFactor) {
        this->x1 *= scaleFactor;
        this->x2 *= scaleFactor;
        this->y1 *= scaleFactor;
        this->y2 *= scaleFactor;
    }
    
    void offset(PGSize offset) {
        this->x1 += offset.width;
        this->x2 += offset.width;
        this->y1 += offset.height;
        this->y2 += offset.height;
    }
};

static PGRect PGRectMake(float x, float y, float width, float height) {
    PGRect rect;
    rect.x1 = x;
    rect.y1 = y;
    rect.x2 = x + width;
    rect.y2 = y + height;
    return rect;
}

static float PGRectGetWidth(PGRect rect)
{
    //    return abs(rect.x2 - rect.x1);
    return rect.x2 - rect.x1;
}

static float PGRectGetHeight(PGRect rect)
{
    //    return abs(rect.y2 - rect.y1);
    return rect.y2 - rect.y1;
}

static const PGRect PGRectZero = PGRect{0.0, 0.0, 0.0, 0.0};

struct PGColor {
    float red;
    float green;
    float blue;
};

struct LayerType {
    enum Enum {
        Unknow = 1,
        ImageLayer = 2
    };
};
#endif /* CommonDefine_hpp */
