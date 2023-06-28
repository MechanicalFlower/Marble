# SPDX-FileCopyrightText: 2023 Florian Vazelle <florian.vazelle@vivaldi.net>
#
# SPDX-License-Identifier: MIT

tool

extends Label


func _ready():
	var build_version = ProjectSettings.get_setting("build_info/package/version")
	var build_commit = ProjectSettings.get_setting("build_info/source/commit")
	if build_version and build_commit:
		set_text("v" + build_version + "@" + build_commit.left(7))
	else:
		set_text("")
