/*
 *  SPDX-FileCopyrightText: 2015 David Rosca <nowrep@gmail.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef QUICKLAUNCH_P_H
#define QUICKLAUNCH_P_H

#include <QObject>
#include <QUrl>
#include <QVariantMap>

class QuicklaunchPrivate : public QObject
{
    Q_OBJECT

public:
    explicit QuicklaunchPrivate(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap launcherData(const QUrl &url);
    Q_INVOKABLE void openUrl(const QUrl &url);
    Q_INVOKABLE void openExec(const QString &exec);

    Q_INVOKABLE void addLauncher(bool isPopup = false);
    Q_INVOKABLE void editLauncher(QUrl url, int index, bool isPopup = false);

Q_SIGNALS:
    void launcherAdded(const QString &url, bool isPopup);
    void launcherEdited(const QString &url, int index, bool isPopup);
};

#endif // QUICKLAUNCH_P_H
