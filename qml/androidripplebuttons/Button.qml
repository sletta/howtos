/*
    Copyright (c) 2014, Gunnar Sletta
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this
      list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import "../shaders"

Item {
    id: root

    width: 100
    height: 100

    property bool round: false

    Rectangle {
        id: buttonBg
        anchors.fill: parent
        radius: root.round ? width / 2 : 0
        color: "white"
    }

    Item {
        id: ripple
        anchors.fill: parent
        visible: false

        Rectangle {
            id: rippleBox
            property real cx
            property real cy
            x: cx - width / 2
            y: cy - height / 2
            width: 0
            height: width
            radius: width / 2
            color: "lightsteelblue"
        }

        layer.effect: SimpleOpacityMask { mask: buttonBg }
    }

    Image {
        id: playImage
        source: "play.svg"
        anchors.centerIn: parent
        sourceSize: Qt.size(parent.width / 3, parent.height / 3);
    }
    Image {
        id: pauseImage;
        source: "pause.svg"
        anchors.centerIn: parent
        rotation: -90
        opacity: 0
        sourceSize: Qt.size(parent.width / 3, parent.height / 3);
    }

    SequentialAnimation {
        id: rippleAnimation
        ScriptAction { script: {
                rippleBox.width = 0;
                rippleBox.opacity = 0.3
                ripple.visible = true;
                buttonBg.layer.enabled = true;
                ripple.layer.enabled = true;
            }
        }
        NumberAnimation { target: rippleBox; property: "width"; from: 0; to: root.width * 3; duration: 150 }
        NumberAnimation { target: rippleBox; property: "opacity"; to: 0; duration: 250 }
        ScriptAction { script: {
                buttonBg.layer.enabled = false;
                ripple.layer.enabled = false;
                ripple.visible = false;
            }
        }
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges { target: playImage; opacity: 0; rotation: 90 }
            PropertyChanges { target: pauseImage; opacity: 1; rotation: 0 }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { properties: "opacity,rotation"; duration: 150 }
        }
    ]

    MouseArea {
        anchors.fill: parent
        onClicked: {
            print("clicked")
            rippleBox.cx = mouse.x
            rippleBox.cy = mouse.y
            rippleAnimation.running = true;
            if (root.state == "pressed")
                root.state = ""
            else
                root.state = "pressed"
        }
    }




}
