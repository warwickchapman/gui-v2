/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

#ifndef VICTRON_VENUSOS_GUI_V2_THEMEPARSER_H
#define VICTRON_VENUSOS_GUI_V2_THEMEPARSER_H

#include <QVariantMap>
#include <QObject>
#include <QJsonValue>
#include <QString>
#include <QColor>

#include <deque>

namespace Victron {
namespace VenusOS {

struct ThemeInfo
{
	bool variesByScreenSize = false;
	bool variesByColorScheme = false;

	QVariantMap values;
	QHash<QString, QVariantMap *> subtrees;
	std::deque<std::pair<QString, QJsonValue>> deferred;
};

class ThemeParser : public QObject
{
	Q_OBJECT

public:
	enum ScreenSize {
		FiveInch = 0,
		SevenInch
	};
	Q_ENUM(ScreenSize)

	enum ColorScheme {
		Dark = 0,
		Light
	};
	Q_ENUM(ColorScheme)

	explicit ThemeParser(QObject *parent = nullptr);
	~ThemeParser() override;

	Q_INVOKABLE bool load(const QString &themeDir);

private:
	static bool parseTheme(const QString &themeFile, ThemeInfo *themeInfo);
	static QVariant parseValue(const QJsonValue &value, const QString &key, bool defer, ThemeInfo *themeInfo);
	static void insertValue(
		QVariantMap *tree,
		const QString &key,
		const QJsonValue &value,
		int depth,
		bool defer,
		ThemeInfo *themeInfo);
	static QVariant resolvedValue(const QString &key, bool *found, bool warnOnFailure, ThemeInfo *themeInfo);
	static QColor resolvedColor(const QString &value);

	QVector<ThemeInfo> m_themeValues;
};

}
}

#endif // VICTRON_VENUSOS_GUI_V2_THEMEPARSER_H

