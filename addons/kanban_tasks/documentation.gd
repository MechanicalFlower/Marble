# SPDX-FileCopyrightText: 2022-2023 HolonProduction
#
# SPDX-License-Identifier: MIT
#
# Source: https://github.com/HolonProduction/godot_kanban_tasks

tool
extends AcceptDialog

onready var label := $VBoxContainer/RichTextLabel

func _ready():
	label.connect("meta_clicked", self, "__label_meta_clicked")

func __label_meta_clicked(meta):
	OS.shell_open(meta)
