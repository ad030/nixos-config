pragma Singleton

import Quickshell
import QtQuick

Singleton {
        id: root

        // fonts
        readonly property string fontFamily: "MesloLGM Nerd Font";
        readonly property string iconFontFamily: "Font Awesome 5 Free";
        readonly property int fontSize: 16;


        readonly property color background: "#282828";
}
