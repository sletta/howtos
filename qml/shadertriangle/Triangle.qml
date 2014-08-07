import QtQuick 2.0

ShaderEffect {
    id: shader

    width: 100
    height: 100

    property var p1: Qt.vector2d(width, 0);
    property var p2: Qt.vector2d(0, height / 2);
    property var p3: Qt.vector2d(width / 2, height);

    property color color: "lightsteelblue"

    vertexShader: "
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;

        uniform highp mat4 qt_Matrix;
        uniform highp vec2 p1;
        uniform highp vec2 p2;
        uniform highp vec2 p3;

        void main() {
            highp vec2 pos;

            if (qt_MultiTexCoord0.y < 0.1) {
                pos = p1;
            } else if (qt_MultiTexCoord0.x < 0.1) {
                pos = p2;
            } else {
                pos = p3;
            }
            gl_Position = qt_Matrix * vec4(pos, 0, 1);
        }"

    fragmentShader: "
        uniform lowp float qt_Opacity;
        uniform lowp vec4 color;
        void main() {
            gl_FragColor = color * qt_Opacity;
        }"

}
