import QtQuick 2.0

Item {
    id: effectRoot

    visible: source != undefined;

    /*
      The input source item. This is the item that will be blurred
     */
    property Item source;

    /*
      The subrect of sourceItem that should be used for blurring
     */
    property rect sourceRect: source != undefined ? Qt.rect(0, 0, source.width, source.height) : Qt.rect(0, 0, 1, 1);

    /*
      The amount of blurring to apply. 0.0 gives a grainy result
      0.5 is the default and 1.0 gives a grainy result again.
     */
    property alias spread: blur.spread

    /*
      The amount of downscaling to apply to the intermediate texture.
      The default value is 16.

      A higher value means higher blur factor and faster performance, but
      too high a value will cause aliasing artifacts.
     */
    property real downScaleFactor: 32

    x: sourceRect.x
    y: sourceRect.y
    width: sourceRect.width
    height: sourceRect.height

    ShaderEffect {
        id: blur;

        anchors.fill: parent

        property ShaderEffectSource source: ShaderEffectSource {
            sourceRect: effectRoot.sourceRect
            sourceItem: effectRoot.source
            textureSize: Qt.size(sourceRect.width / Math.max(1, effectRoot.downScaleFactor),
                                 sourceRect.height / Math.max(1, effectRoot.downScaleFactor));

        }

        // Apply a basic box blur to reduce some of the pixelation artifacts..

        property real spread: 0.55
        property var invSize: Qt.vector4d(spread / source.textureSize.width, spread / source.textureSize.height,
                                          -spread / source.textureSize.width, -spread / source.textureSize.height);

        fragmentShader: "
            uniform lowp sampler2D source;
            uniform highp vec4 invSize;

            varying highp vec2 qt_TexCoord0;

            void main() {
                gl_FragColor =
                    0.25 * (texture2D(source, qt_TexCoord0 + invSize.xy)
                            + texture2D(source, qt_TexCoord0 + invSize.zw))
                    + 0.25 * (texture2D(source, qt_TexCoord0 + invSize.xw)
                            + texture2D(source, qt_TexCoord0 + invSize.yz));
            }
            "

        // To make it fast, we turn this item into a layer, whose texture size is still
        // very small. Though the box blur is fairly cheap, we save quite a bit of
        // GPU work by keeping the size small. Then we smooth scale the resulting blurred
        // texture back up to the original view size.
        layer.enabled: true
        layer.smooth: true
        layer.textureSize: Qt.size(source.textureSize.width, source.textureSize.height);



    }


}
