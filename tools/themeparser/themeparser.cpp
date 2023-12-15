/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

#include "themeparser.h"

#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <QVariant>
#include <QColor>
#include <QMetaEnum>

namespace {
	QRegularExpression optimizeExpression(const QString &expression)
	{
		QRegularExpression regexp(expression);
		regexp.optimize();
		return regexp;
	}
}

namespace Victron {
namespace VenusOS {

static const QString FilePreamble =
R"(
/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

// THIS FILE IS AUTOMATICALLY GENERATED!
// DO NOT EDIT IT MANUALLY!
// YOU NEED TO RUN themeparser IF ANY OF
// THE THEME .json FILES CHANGE!

#ifndef VICTRON_VENUSOS_GUI_V2_THEMEOBJECTS_H
#define VICTRON_VENUSOS_GUI_V2_THEMEOBJECTS_H

#include <QObject>
#include <QColor>
#include <QFont>
#include <QVariant>
#include <QVariantMap>

namespace Victron {
namespace VenusOS {

class ThemeBase : public QObject
{
	Q_OBJECT
	QML_ELEMENT
	Q_PROPERTY(ScreenSize screenSize READ screenSize NOTIFY screenSizeChanged)
	Q_PROPERTY(ColorScheme colorScheme READ colorScheme NOTIFY colorSchemeChanged)

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

	enum StatusLevel {
		Ok = 0,
		Warning,
		Critical
	};
	Q_ENUM(StatusLevel)

	ThemeBase(QObject *parent = nullptr) : QObject(parent) {}

	ScreenSize screenSize() const { return m_screenSize; }
	ColorScheme colorScheme() const { return m_colorScheme; }

Q_SIGNALS:
	void screenSizeChanged(ScreenSize screenSize);
	void colorSchemeChanged(ColorScheme colorScheme);

protected:
	ScreenSize m_screenSize = FiveInch;
	ColorScheme m_colorScheme = Dark;
};

class Internal_Theme_SizeVaryingClass : public QObject
{
	Q_OBJECT
	QML_ELEMENT

public:
	Internal_Theme_SizeVaryingClass(QObject *parent = nullptr)
		: QObject(parent) {}

public Q_SIGNALS:
	void propertiesChanged(); // used as QML change signal by leaf classes.
	void themeChanged(ThemeBase::ScreenSize newValue);

public Q_SLOTS:
	void handleThemeChanged(ThemeBase::ScreenSize newValue) {
		if (m_themeValue != newValue) {
			m_themeValue = newValue;
			Q_EMIT themeValueChanged(newValue);
			Q_EMIT propertiesChanged();
		}
	}

protected:
	ThemeBase::ScreenSize m_themeValue = ThemeBase::FiveInch;
};

class Internal_Theme_ColorVaryingClass : public QObject
{
	Q_OBJECT
	QML_ELEMENT

public:
	Internal_Theme_ColorVaryingClass(QObject *parent = nullptr)
		: QObject(parent) {}

public Q_SIGNALS:
	void propertiesChanged(); // used as QML change signal by leaf classes.
	void themeValueChanged(ThemeBase::ColorScheme newValue);

public Q_SLOTS:
	void handleThemeValueChanged(ThemeBase::ColorScheme newValue) {
		if (m_themeValue != newValue) {
			m_themeValue = newValue;
			Q_EMIT themeValueChanged(newValue);
			Q_EMIT propertiesChanged();
		}
	}

protected:
	ThemeBase::ColorScheme m_themeValue = ThemeBase::Dark;
};

)";

// %1 is type, %2 is name
static const QString LeafThemeClassPropertyDeclaration =
R"(
	Q_PROPERTY(%1 %2 READ %2 NOTIFY propertiesChanged FINAL)
)";

// %1 is type, %2 is name, %3 is chained-ternary-value.
// e.g. m_themeValue == ThemeBase::FiveInch ? 1024 : 800
static const QString LeafThemeClassPropertyAccessors =
R"(
	%1 %2() const {
		return %3;
	}

)";

// %1 is the class name, %2 is the type to extend (SizeVaryingClass or ColorVaryingClass)
static const QString LeafThemeClassDeclaration =
R"(

class Internal_Theme_%1 : public Internal_Theme_%2
{
	Q_OBJECT
	QML_ELEMENT

	// leaf property declarations
%3

public:
	Internal_Theme_%1(QObject *parent = nullptr) : QObject(parent) {}

	// leaf property accessors
%4
};

)";

// %1 is the private subobject class name, %2 is the private subobject name.
static const QString ThemeClassPropertyDeclaration =
R"(
	Q_PROPERTY(Internal_Theme_%1* %2 READ %2 CONSTANT FINAL)
)";

// %1 is the class name, %2 is the private subobject name, %3 is the private subobject class name
static const QString ThemeClassSignalConnection =
R"(
		connect(this, &Internal_Theme_%1::themeValueChanged, &m_%2, &Internal_Theme_%3::handleThemeValueChanged);
)";

// %1 is the private subobject class name, %2 is the private subobject name
static const QString ThemeClassPropertyAccessor =
R"(
	Internal_Theme_%1 *%2() const { return &m_%2; }
)";

// %1 is the private subobject class name, %2 is the private subobject name
static const QString ThemeClassPrivateSubObject =
R"(
	Internal_Theme_%1 m_%2;
)";

// %1 is the class name, %2 is the type to extend (SizeVaryingClass or ColorVaryingClass)
static const QString ThemeClassDeclaration =
R"(
class Internal_Theme_%1 : public Internal_Theme_%2
{
	Q_OBJECT
	QML_ELEMENT

	// property declarations
%3

public:
	Internal_Theme_%1(QObject *parent = nullptr)
		: QObject(parent)
	{
		// signal connections
%4
	}

	// property accessors
%5

private:
	// sub-objects
%6

};

)";

static const QString ThemeObjectSizeChangedSignalConnection =
R"(
		connect(this, &Theme::screenSizeChanged, &m_%1, &Internal_Theme_%2::handleThemeValueChanged)
)";

static const QString ThemeObjectColorChangedSignalConnection =
R"(
		connect(this, &Theme::colorSchemeChanged, &m_%1, &Internal_Theme_%2::handleThemeValueChanged)
)";

static const QString ThemeObjectDeclaration =
R"(
class Theme : public ThemeBase
{
	Q_OBJECT
	QML_ELEMENT
	QML_SINGLETON

	// property declarations
%1

public:
	Theme(QObject *parent = nullptr)
		: QObject(parent)
	{
		// size changed signal connections
%2

		// color changed signal connections
%3
	}

	// property accessors
%4

	Q_INVOKABLE QColor statusColorValue(StatusLevel level, bool darkColor = false) const
	{
		const QVariant c = (level == Ok && darkColor) ? m_color.darkOk()
			: (level == Ok) ? m_color.ok()
			: (level == Warning && darkColor) ? m_color.darkWarning()
			: (level == Warning) ? m_color.warning()
			: (level == Critical && darkColor) ? m_color.darkCritical()
			: m_color.critical();
		return c.typeId() == QMetaType::QColor ? c.value<QColor>() : QColor(c.value<QString>());
	}

private:
	// sub-objects
%5

};

)";


static const QString FilePostfix =
R"(

} // namespace VenusOS
} // namespace VictronOS

#endif // VICTRON_VENUSOS_GUI_V2_THEMEOBJECTS_H

)";

ThemeParser::ThemeParser(QObject *parent)
	: QObject(parent)
{
}

ThemeParser::~ThemeParser()
{
}

QByteArray ThemeParser::generateLeafClassCode(const ThemeInfo &info, QVariantMap *subtree, const QString &namePrefix)
{
	QStringList propertyDeclarations, propertyAccessors;

	// for each key in subtree:
	//     generate LeafClass property accessor for it
	//     generate LeafClass property declaration for it

	QString classCode = LeafThemeClassDeclaration.arg(
		namePrefix,
		info.variesByColorScheme ? QStringLiteral("ColorVaryingClass") : QStringLiteral("SizeVaryingClass"),
		propertyDeclarations.join('\n'),
		propertyAccessors.join ('\n'));
	return classCode.toUtf8();
}

QByteArray ThemeParser::generateThemeClassCode(const ThemeInfo &info, QVariantMap *subtree, const QString &namePrefix)
{
	QByteArray ret;

	// if any key in subtree has a value which is a QVariantMap, then:
	// for each key in subtree:
	// if value is a QVariantMap*, then:
	//     generateThemeClassCode(info, value, namePrefix + key + "_");
	//     generate ThemeClass subobject for it
	//     generate ThemeClass property accessor for it
	//     generate ThemeClass signal connection for it
	//     generate ThemeClass property declaration for it
	// else:
	//     generate LeafClass property accessor for it
	//     generate LeafClass property declaration for it

	// else (i.e. no keys are QVariantMap*) then:
	// generateLeafClassCode()
}

bool ThemeParser::generateThemeCode(const QString &themeDir, const QString &outputFile)
{
	if (!load(themeDir)) {
		qWarning() << "Failed to load theme files.";
		return false;
	}

	QByteArray fileData;
	fileData.append(FilePreamble.toUtf8());

	for (const ThemeInfo &info : qAsConst(m_themeValues)) {
		// for each key in info.values:
		//    if value is a QVariantMap*, then:
		//        generateThemeClassCode(info, value, "");
		//        generate Theme subobject for it
		//        generate Theme property accessor for it
		//        generate Theme change signal connection for it
		//        generate Theme property declaration for it
		//    else
		//        qWarning() << "Immediate value of Theme object not allowed!";
	}

	fileData.append(FilePostfix.toUtf8());
	QFile writeFile(outputFile);
	writeFile.open(QIODevice::ReadWrite);
	writeFile.write(fileData);
	writeFile.close();
	return true;
}

bool ThemeParser::load(const QString &themeDir)
{
	bool ret = true;

	auto screenSizeMetaEnum = QMetaEnum::fromType<ThemeParser::ScreenSize>();
	for (int idx = 0; idx < screenSizeMetaEnum.keyCount(); ++idx) {
		const int screenSize = screenSizeMetaEnum.value(idx);
		ThemeInfo themeInfo;
		themeInfo.variesByScreenSize = true;
		bool typographyDesign = parseTheme(QStringLiteral(":/themes/typography/TypographyDesign.json"), &themeInfo);
		bool typography = parseTheme(QStringLiteral(":/themes/typography/%1.json")
			.arg(screenSizeMetaEnum.valueToKey(screenSize)), &themeInfo);
		bool geometry = parseTheme(QStringLiteral(":/themes/geometry/%1.json")
			.arg(screenSizeMetaEnum.valueToKey(screenSize)), &themeInfo);
		m_themeValues.append(themeInfo);
		ret = ret && typographyDesign && typography && geometry;
	}

	auto colorSchemeMetaEnum = QMetaEnum::fromType<ThemeParser::ColorScheme>();
	for (int idx = 0; idx < colorSchemeMetaEnum.keyCount(); ++idx) {
		const int colorScheme = colorSchemeMetaEnum.value(idx);
		ThemeInfo themeInfo;
		themeInfo.variesByColorScheme = true;
		bool colorDesign = parseTheme(QStringLiteral(":/themes/color/ColorDesign.json"), &themeInfo);
		bool color = parseTheme(QStringLiteral(":/themes/color/%1.json")
			.arg(colorSchemeMetaEnum.valueToKey(colorScheme)), &themeInfo);
		m_themeValues.append(themeInfo);
		ret = ret && colorDesign && color;
	}

	{
		ThemeInfo themeInfo;
		bool animation = parseTheme(QStringLiteral(":/themes/animation/Animation.json"), &themeInfo);
		m_themeValues.append(themeInfo);
		ret = ret && animation;
	}

	return ret;
}

QVariant ThemeParser::resolvedValue(
		const QString &key,
		bool *found,
		bool warnOnFailure,
		ThemeInfo *themeInfo)
{
	if (found) *found = false;
	const QString resolvedSubTree = key.mid(0, key.lastIndexOf(QLatin1Char('.')));
	if (!themeInfo->subtrees.contains(resolvedSubTree)) {
		if (warnOnFailure) qWarning() << "Theme: unable to resolve:" << key << ": subtree does not exist.";
	} else {
		QVariantMap *subtree = themeInfo->subtrees[resolvedSubTree];
		const QString valueKey = key.mid(resolvedSubTree.length()+1);
		if (!subtree->contains(valueKey)) {
			if (warnOnFailure) qWarning() << "Theme: unable to resolve:" << key << ": subtree does not contain key.";
		} else {
			if (found) *found = true;
			return subtree->value(valueKey);
		}
	}
	return QVariant();
}

QColor ThemeParser::resolvedColor(const QString &value)
{
	static const QRegularExpression hexColor = ::optimizeExpression(
			QStringLiteral("^#[0-9a-fA-F]{6,8}$"));
	static const QRegularExpression rgbaColor = ::optimizeExpression(
			QStringLiteral("^rgba\\((\\d+), (\\d+), (\\d+), (\\d+(?:\\.\\d+)?)\\)$"));

	if (value == "transparent") {
		return QColor(value);
	}

	QRegularExpressionMatch match = hexColor.match(value);
	if (match.hasMatch()) {
		return QColor(value);
	}

	match = rgbaColor.match(value);
	if (match.hasMatch()) {
		return QColor(
			match.captured(1).toInt(),
			match.captured(2).toInt(),
			match.captured(3).toInt(),
			qRound(255 * match.captured(4).toDouble()));
	}

	return {};
}

QVariant ThemeParser::parseValue(
		const QJsonValue &value,
		const QString &key,
		bool defer,
		ThemeInfo *themeInfo)
{
	if (value.isString()) {
		const QString valueStr = value.toString();

		QColor color = resolvedColor(valueStr);
		if (color.isValid())
			return QVariant::fromValue(color);

		// Check to see if the value should resolve to a pre-existing theme value.
		if (!valueStr.contains('.')) {
			return valueStr; // no, just a string value.
		}

		bool found = false;
		const QVariant var = resolvedValue(valueStr, &found, !defer, themeInfo);
		if (found) {
			if (var.isNull()) {
				// Still not resolved - try again
				themeInfo->deferred.push_back({ key, value });
			}
			return var;
		} else if (defer) {
			themeInfo->deferred.push_back({ key, value });
			return QVariant();
		}

		return valueStr;
	} else {
		return value.toVariant();
	}
}

void ThemeParser::insertValue(
		QVariantMap *tree,
		const QString &key,
		const QJsonValue &value,
		int depth,
		bool defer,
		ThemeInfo *themeInfo)
{
	const int dot = static_cast<int>(key.indexOf(QLatin1Char('.'), depth));
	if (dot == -1) {
		const QString name = key.mid(depth);
		tree->insert(name, parseValue(value, key, defer, themeInfo));
		return;
	}

	const QString subtreeKey = key.mid(0, dot);
	QVariantMap *subtree = nullptr;
	if (themeInfo->subtrees.contains(subtreeKey)) {
		subtree = themeInfo->subtrees[subtreeKey];
	} else {
		subtree = new QVariantMap;
		themeInfo->subtrees.insert(subtreeKey, subtree);
		tree->insert(key.mid(depth, dot-depth), QVariant::fromValue(subtree));
	}
	insertValue(subtree, key, value, dot+1, defer, themeInfo);
}

bool ThemeParser::parseTheme(const QString &themeFile, ThemeInfo *themeInfo)
{
	QFile file(themeFile);
	if (!file.open(QIODevice::ReadOnly)) {
		qWarning() << "Error opening theme file:" << themeFile
			<< ":" << file.errorString();
		return false;
	}

	QJsonParseError err;
	const QJsonDocument doc = QJsonDocument::fromJson(file.readAll(), &err);
	if (doc.isNull()) {
		qWarning() << "Error parsing JSON:" << themeFile
			<< ":" << qPrintable(err.errorString());
		return false;
	}

	const QJsonObject obj = doc.object();
	for (auto it = obj.constBegin(); it != obj.constEnd(); ++it) {
		insertValue(&themeInfo->values, it.key(), it.value(), 0, true, themeInfo);
	}

	// Process any previously deferred values
	while (!themeInfo->deferred.empty()) {
		const auto &pair(themeInfo->deferred.front());
		insertValue(&themeInfo->values, pair.first, pair.second, 0, false, themeInfo);
		themeInfo->deferred.pop_front();
	}

	return true;
}

} // VenusOS
} // Victron
