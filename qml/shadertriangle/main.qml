import QtQuick 2.0

Rectangle {
    width: 320
    height: 480

    gradient: Gradient {
        GradientStop { position: 0; color: "steelblue" }
        GradientStop { position: 1; color: "black" }
    }

    Triangle {
        anchors.centerIn: parent;
    }

    Triangle {
        p1: Qt.vector2d(10, 10);
        p2: Qt.vector2d(200, 0);
        p3: Qt.vector2d(0, 200);
        color: "palegreen"
    }
}
