pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Wayland

// only allow one popup window open at a time to avoid weird behaviour
// all popup windows should go through this singleton
Singleton {
        property PopupWindow currentPopup: null

        function open(popup: PopupWindow): void {
                // hide currently visible popup window
                if (currentPopup && currentPopup !== popup) {
                        currentPopup.visible = false 
                }
                popup.visible = true
                currentPopup = popup
        }

        function close(popup: PopupWindow): void {
                if (currentPopup === popup) {
                        currentPopup = null
                }
                popup.visible = false
        }

}
