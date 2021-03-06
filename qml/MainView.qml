import Qt 4.7

Rectangle {
    signal logoClicked

    SearchModel {
        id: searchModel
        phrase: searchInput.throttledText
    }

    Rectangle {
        id: topBar
        width: parent.width
        height: logo.height + 10
        z: 10

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#000" }
            GradientStop { position: 0.3; color: "#333" }
            GradientStop { position: 1.0; color: "#888" }
        }

        Image {
            id: logo
            source: "/img/twitter_logo.png"

            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.left: parent.left

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    logoClicked()
                }
            }
        }


        FocusScope {
            id: searchInput
            property string throttledText: "meego"
            anchors.verticalCenter: parent.verticalCenter

            anchors.left: logo.right
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.margins: 2
            height: parent.height - 6

            Rectangle {
                anchors.fill: parent

                TextInput {
                    anchors.fill: parent
                    color: "black"
                    text: searchInput.throttledText

                    Keys.onPressed: {
                        if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                            searchInput.throttledText = text
                            event.accepted = true
                        }
                    }
                }
                focus: true
            }
        }
    }

    Rectangle {
        id: topGradient
        width: parent.width
        y: topBar.height
        height: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#444" }
            GradientStop { position: 0.2; color: "#ccc" }
            GradientStop { position: 0.5; color: "#eee" }
            GradientStop { position: 1.0; color: "#fff" }
        }
    }

    Rectangle {
        id: bottomGradient
        width: parent.width
        anchors.bottom: parent.bottom
        height: 20
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#fff" }
            GradientStop { position: 0.6; color: "#eee" }
            GradientStop { position: 1.0; color: "#ccc" }
        }
    }

    Rectangle {
        id: content
        x: 0
        width: parent.width
        anchors.top: topGradient.bottom
        anchors.bottom: bottomGradient.top

        AnimatedImage {
            id: loading
            source: "/img/ajax-loader.gif"

            anchors.leftMargin: 120
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 12
            visible: !tweetView.visible
        }

        TweetView {
            id: tweetView
            model: searchModel
            visible: model.ready
            anchors.fill: parent
            onVisibleChanged: {
                // ugly hack to keep focus in search input box
                searchInput.focus = true
            }
        }
    }
}
