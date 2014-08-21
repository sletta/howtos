import QtQuick 2.2

import "../shaders"

Item {
    width: 640
    height: 480

    Image {
        id: contentRoot

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "../images/grapes.jpg"

        property int rowCount: 2 * contentRoot.width / 320;
        property real cellSize: width / rowCount;

        Grid {
            id: grid

            columns: contentRoot.width / contentRoot.cellSize;
            rows: Math.floor(contentRoot.height / contentRoot.cellSize) + 5;

            property real fullHeight: rows * contentRoot.cellSize;

            SequentialAnimation {
                ParallelAnimation {
                    YAnimator { target: grid; from: 0; to: contentRoot.height - grid.fullHeight; duration: 2000; easing.type: Easing.InOutQuad }
                    OpacityAnimator { target: grid; from: 1; to: 0; duration: 2000; easing.type: Easing.InOutQuad }
                }
                PauseAnimation { duration: 2000 }
                ParallelAnimation {
                    YAnimator { target: grid; from: contentRoot.height - grid.fullHeight; to: 0; duration: 2000; easing.type: Easing.InOutQuad }
                    OpacityAnimator { target: grid; from: 0; to: 1; duration: 2000; easing.type: Easing.InOutQuad }
                }
                PauseAnimation { duration: 2000 }
                loops: Animation.Infinite
                running: true;
            }

            width: contentRoot.width

            Repeater {
                model: grid.columns * grid.rows;

                Item {
                    width: contentRoot.cellSize
                    height: contentRoot.cellSize

                    Rectangle {
                        id: box
                        anchors.fill: parent
                        anchors.margins: 2

                        property color hue: Qt.hsla(Math.random(), 0.5, 0.7);
                        gradient: Gradient {
                            GradientStop { position: 0; color: box.hue }
                            GradientStop { position: 1; color: Qt.darker(box.hue); }
                        }

                        radius: width / 3;
                    }
                }
            }
        }
    }

    HeavyFastBlur {
        id: blur;
        source: contentRoot
        sourceRect: Qt.rect(contentRoot.cellSize, contentRoot.cellSize,
                            contentRoot.width - contentRoot.cellSize * 2,
                            contentRoot.height - contentRoot.cellSize * 2);
    }

    Rectangle {
        border.color: "white"
        color: "transparent"
        anchors.fill: blur;
        anchors.margins: -1
    }
    Rectangle {
        border.color: "palegreen"
        color: "transparent"
        anchors.fill: blur;
        anchors.margins: -2
        opacity: 0.66
    }
    Rectangle {
        border.color: "palegreen"
        color: "transparent"
        anchors.fill: blur;
        anchors.margins: -3
        opacity: 0.33
    }

    Text {
        anchors.bottom: blur.bottom
        anchors.left: blur.left

        color: "white"
        text: "Spread: " + Math.round(blur.spread * 100) / 100 + "\n" +
              "Downscale: " + Math.round(blur.downScaleFactor * 10) / 10;
    }

    MouseArea {
        anchors.fill: parent
        onMouseYChanged: { blur.spread = mouseY / contentRoot.height; }
        onMouseXChanged: { blur.downScaleFactor = mouseX / contentRoot.width * 100 }
    }



}
