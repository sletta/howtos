import QtQuick 2.0

Item {
    id: root

    width: 320
    height: 480

    ListView
    {
        id: listView
        anchors.fill: parent
        model: 100

        property real delegateHeight: 30
        property real expandedHeaderSize: 200
        property real collapsedHeaderSize: 50

        delegate: Item {
            // The very first item has a padding on the top equal to the header's size.
            // As this item gets moved out, we can use ListView.contentY to collapse the
            // header
            width: listView.width
            height: listView.delegateHeight + (index == 0 ? listView.expandedHeaderSize : 0);

            Rectangle {
                // This item is the "proper" delegate root. It anchors to the bottom
                // in the case of the first item and has the correct delegate height.
                height: listView.delegateHeight
                width: parent.width
                anchors.bottom: parent.bottom
                color: (index % 2) == 0 ? "transparent" : "#f8f8f8";

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: font.pixelSize
                    text: "Item #" + index
                }
            }
        }

        Item {
            id: header

            width: parent.width
            height: Math.min(listView.expandedHeaderSize, Math.max(listView.expandedHeaderSize - listView.contentY, listView.collapsedHeaderSize));
            clip: true // To clip the image

            // Convenience for the amount of compression in case we want to tie animations or
            // properties to the compression ratio. 0 -> max size, 1 -> compressed size
            property real compression: (height - listView.collapsedHeaderSize) / (listView.expandedHeaderSize - listView.collapsedHeaderSize);

            Image {
                source: "../images/grapes.jpg"

                // Add a bit of motion, just for the fun of it..
                property real t;
                NumberAnimation on t {
                    from: 0;
                    to: Math.PI * 2.0;
                    duration: 50000;
                    loops: Animation.Infinite
                }
                property real dx: Math.sin(t + 1) + Math.sin(t * 2 + 3);
                property real dy: Math.sin(t + 5) + Math.sin(t * 2 + 7);
                x: parent.width / 2 - width / 2 + dx * 10
                y: parent.height / 2 - height / 2 + dy * 10
                scale: 1 + Math.sin(t) * 0.1;
                rotation: Math.sin(t + 13) * 5

                fillMode: Image.PreserveAspectCrop

                width: Math.max(sourceSize.width, parent.width + 200);
                height: Math.max(sourceSize.height, parent.height + 200);
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0; color: "lightsteelblue" }
                    GradientStop { position: 1; color: "black" }
                }
                opacity: 0.5
            }

            Text {
                // centered
                property real cx: parent.width / 2 - implicitWidth / 2
                property real cy: parent.height / 2 - implicitHeight / 2
                // anchored to right, 10px margin
                property real ax: parent.width - implicitWidth - 10;
                x: header.compression * cx + (1 - header.compression) * ax
                y: cy
                font.pixelSize: header.height / 3
                color: "white"
                style: Text.Raised
                text: "Header"
            }

        }

        // header's drop shadow..
        Rectangle {
            width: header.width
            height: listView.delegateHeight * 0.25
            anchors.top: header.bottom
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0.2, 0.2, 0.2, 0.4); }
                GradientStop { position: 1; color: "transparent" }
            }
        }
    }

}
