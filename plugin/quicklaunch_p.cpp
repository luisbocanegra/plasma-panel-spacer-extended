/*
 *  SPDX-FileCopyrightText: 2008-2009 Lukas Appelhans <l.appelhans@gmx.de>
 *  SPDX-FileCopyrightText: 2010-2011 Ingomar Wesp <ingomar@wesp.name>
 *  SPDX-FileCopyrightText: 2013 Bhushan Shah <bhush94@gmail.com>
 *  SPDX-FileCopyrightText: 2015 David Rosca <nowrep@gmail.com>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

#include "quicklaunch_p.h"

#include <QDir>
#include <QFileInfo>
#include <QMimeDatabase>
#include <QMimeType>
#include <QRandomGenerator>
#include <QStandardPaths>

#include <KConfig>
#include <KConfigGroup>
#include <KDesktopFile>
#include <KFileItem>
#include <KIO/CommandLauncherJob>
#include <KIO/OpenUrlJob>
#include <KNotificationJobUiDelegate>
#include <KOpenWithDialog>
#include <KPropertiesDialog>

#include <kio/global.h>

QuicklaunchPrivate::QuicklaunchPrivate(QObject *parent)
    : QObject(parent)
{
}

QVariantMap QuicklaunchPrivate::launcherData(const QUrl &url)
{
    QString name;
    QString icon;
    QString genericName;
    QVariantList jumpListActions;

    if (url.scheme() == QLatin1String("quicklaunch")) {
        // Ignore internal scheme
    } else if (url.isLocalFile()) {
        const KFileItem fileItem(url);
        const QFileInfo fi(url.toLocalFile());

        if (fileItem.isDesktopFile()) {
            const KDesktopFile f(url.toLocalFile());
            name = f.readName();
            icon = f.readIcon();
            genericName = f.readGenericName();
            if (name.isEmpty()) {
                name = QFileInfo(url.toLocalFile()).fileName();
            }

            const QStringList &actions = f.readActions();

            for (const QString &actionName : actions) {
                const KConfigGroup &actionGroup = f.actionGroup(actionName);

                if (!actionGroup.isValid() || !actionGroup.exists()) {
                    continue;
                }

                const QString &name = actionGroup.readEntry("Name");
                const QString &exec = actionGroup.readEntry("Exec");
                if (name.isEmpty() || exec.isEmpty()) {
                    continue;
                }

                jumpListActions << QVariantMap{{QStringLiteral("name"), name},
                                               {QStringLiteral("icon"), actionGroup.readEntry("Icon")},
                                               {QStringLiteral("exec"), exec}};
            }
        } else {
            QMimeDatabase db;
            name = fi.baseName();
            icon = db.mimeTypeForUrl(url).iconName();
            genericName = fi.baseName();
        }
    } else {
        if (url.scheme().contains(QLatin1String("http"))) {
            name = url.host();
        } else if (name.isEmpty()) {
            name = url.toString();
            if (name.endsWith(QLatin1String(":/"))) {
                name = url.scheme();
            }
        }
        icon = KIO::iconNameForUrl(url);
    }

    return QVariantMap{{QStringLiteral("applicationName"), name},
                       {QStringLiteral("iconName"), icon},
                       {QStringLiteral("genericName"), genericName},
                       {QStringLiteral("jumpListActions"), jumpListActions}};
}

void QuicklaunchPrivate::openUrl(const QUrl &url)
{
    auto *job = new KIO::OpenUrlJob(url);
    job->setUiDelegate(new KNotificationJobUiDelegate(KJobUiDelegate::AutoHandlingEnabled));
    job->setRunExecutables(true);
    job->start();
}

void QuicklaunchPrivate::openExec(const QString &exec)
{
    KIO::CommandLauncherJob *job = new KIO::CommandLauncherJob(exec);
    job->setUiDelegate(new KNotificationJobUiDelegate(KJobUiDelegate::AutoHandlingEnabled));
    job->start();
}

void QuicklaunchPrivate::addLauncher(bool isPopup)
{
    KOpenWithDialog *dialog = new KOpenWithDialog();
    dialog->setModal(false);
    dialog->setAttribute(Qt::WA_DeleteOnClose);
    dialog->hideRunInTerminal();
    dialog->setSaveNewApplications(true);
    dialog->show();

    connect(dialog, &KOpenWithDialog::accepted, this, [this, dialog, isPopup]() {
        if (!dialog->service()) {
            return;
        }
        const QUrl &url = QUrl::fromLocalFile(dialog->service()->entryPath());
        if (url.isValid()) {
            Q_EMIT launcherAdded(url.toString(), isPopup);
        }
    });
}

static QString locateLocal(const QString &file)
{
    const QString &dataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    const QString appDataPath = QStringLiteral("%1/quicklaunch").arg(dataPath);
    QDir().mkpath(appDataPath);
    return QStringLiteral("%1/%2").arg(appDataPath, file);
}

static QString determineNewDesktopFilePath(const QString &baseName)
{
    QString appendix;
    QString desktopFilePath = locateLocal(baseName) + QLatin1String(".desktop");

    auto *generator = QRandomGenerator::global();
    while (QFile::exists(desktopFilePath)) {
        if (appendix.isEmpty()) {
            appendix += QLatin1Char('-');
        }

        // Limit to [0-9] and [a-z] range.
        char newChar = generator->bounded(36);
        newChar += newChar < 10 ? 48 : 97 - 10;
        appendix += QLatin1Char(newChar);

        desktopFilePath = locateLocal(baseName + appendix + QLatin1String(".desktop"));
    }

    return desktopFilePath;
}

void QuicklaunchPrivate::editLauncher(QUrl url, int index, bool isPopup)
{
    // If the launcher does not point to a desktop file, create one,
    // so that user can change url, icon, text and description.
    bool desktopFileCreated = false;

    if (!url.isLocalFile() || !KDesktopFile::isDesktopFile(url.toLocalFile())) {
        const QString desktopFilePath = determineNewDesktopFilePath(QStringLiteral("launcher"));
        const QVariantMap data = launcherData(url);

        KConfig desktopFile(desktopFilePath);
        KConfigGroup desktopEntry(&desktopFile, "Desktop Entry");

        desktopEntry.writeEntry("Name", data.value(QStringLiteral("applicationName")).toString());
        desktopEntry.writeEntry("Comment", data.value(QStringLiteral("genericName")).toString());
        desktopEntry.writeEntry("Icon", data.value(QStringLiteral("iconName")).toString());
        desktopEntry.writeEntry("Type", "Link");
        desktopEntry.writeEntry("URL", url);

        desktopEntry.sync();

        url = QUrl::fromLocalFile(desktopFilePath);
        desktopFileCreated = true;
    }

    KPropertiesDialog *dialog = new KPropertiesDialog(url);
    dialog->setModal(false);
    dialog->setAttribute(Qt::WA_DeleteOnClose);
    dialog->show();

    connect(dialog, &KPropertiesDialog::accepted, this, [this, dialog, index, isPopup]() {
        QUrl url = dialog->url();
        QString path = url.toLocalFile();

        // If the user has renamed the file, make sure that the new
        // file name has the extension ".desktop".
        if (!path.endsWith(QLatin1String(".desktop"))) {
            QFile::rename(path, path + QLatin1String(".desktop"));
            path += QLatin1String(".desktop");
            url = QUrl::fromLocalFile(path);
        }
        Q_EMIT launcherEdited(url.toString(), index, isPopup);
    });

    connect(dialog, &KPropertiesDialog::rejected, this, [url, desktopFileCreated]() {
        if (desktopFileCreated) {
            // User didn't save the data, delete the temporary desktop file.
            QFile::remove(url.toLocalFile());
        }
    });
}
