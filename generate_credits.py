import os
from string import Template

ADDON = "addon"
MODEL = "model"
TEXTURE = "texture"
FONT = "font"

SECTIONS = {
    ADDON,
    MODEL,
    TEXTURE,
    FONT,
}


def main():
    template = Template((
        '- "[$files]($source)" by **$author** licensed'
        ' under [$license](https://spdx.org/licenses/$license.html)\n'
    ))

    deps = {section: [] for section in SECTIONS}
    last_section = None

    with open(".reuse/dep5", "r") as file:
        for line in file:
            if line.startswith("Files: "):
                if "addons/" in line:
                    last_section = ADDON
                elif "assets/" in line:
                    if "models/" in line:
                        last_section = MODEL
                    elif "textures/" in line or "icons/" in line:
                        last_section = TEXTURE
                    elif "fonts/" in line:
                        last_section = FONT
                else:
                    last_section = None
                    continue

                deps[last_section].append({"files": line[len("Files: "):-1]})

            elif last_section and line.startswith("Copyright: "):
                date_author = line[len("Copyright: "):-1].split(" ")
                date_author.pop(0)
                deps[last_section][-1]["author"] = " ".join(date_author)

            elif last_section and line.startswith("License: "):
                deps[last_section][-1]["license"] = line[len("License: "):-1]

            elif last_section and line.startswith("Source: "):
                deps[last_section][-1]["source"] = line[len("Source: "):-1]

    if deps[ADDON] or deps[MODEL] or deps[TEXTURE] or deps[FONT]:
        with open("CREDITS.md", "w") as file:
            file.writelines("# Credits\n\n")

            if deps[ADDON]:
                file.writelines("## Addons\n")
                for dep in deps[ADDON]:
                    file.writelines(template.substitute(**dep))

            if deps[MODEL] or deps[TEXTURE] or deps[FONT]:
                file.writelines("## Assets\n")

                if deps[MODEL]:
                    file.writelines("### Models\n")
                    for dep in deps[MODEL]:
                        file.writelines(template.substitute(**dep))

                if deps[TEXTURE]:
                    file.writelines("### Textures\n")
                    for dep in deps[TEXTURE]:
                        file.writelines(template.substitute(**dep))

                if deps[FONT]:
                    file.writelines("### Fonts\n")
                    for dep in deps[FONT]:
                        file.writelines(template.substitute(**dep))
    else:
        if os.path.exists("CREDITS.md"):
            os.remove("CREDITS.md")


if __name__ == "__main__":
    main()
