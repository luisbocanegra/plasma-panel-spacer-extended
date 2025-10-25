/*
 *  SPDX-FileCopyrightText: 2015 David Rosca <nowrep@gmail.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "quicklaunch_p.h"

#include <QQmlEngine>
#include <QQmlExtensionPlugin>

class QuicklaunchPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) override
    {
        qmlRegisterType<QuicklaunchPrivate>(uri, 1, 0, "Logic");
    }
};

#include "quicklaunchplugin.moc"
