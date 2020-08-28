# Copyright (C) 2018 Łukasz Langa
# Copyright (C) 2019-2020 Michael Smith
import ast
import re
import sys

from setuptools import setup

assert sys.version_info >= (3, 6, 0), "lavender requires Python 3.6+"
from pathlib import Path  # noqa E402

CURRENT_DIR = Path(__file__).parent
sys.path.insert(0, str(CURRENT_DIR))  # for setuptools.build_meta


def get_long_description() -> str:
    readme_md = CURRENT_DIR / "README.md"
    with open(readme_md, encoding="utf8") as ld_file:
        return ld_file.read()


def get_version() -> str:
    lavender_py = CURRENT_DIR / "lavender.py"
    _version_re = re.compile(r"__version__\s+=\s+(?P<version>.*)")
    with open(lavender_py, "r", encoding="utf8") as f:
        match = _version_re.search(f.read())
        version = match.group("version") if match is not None else '"unknown"'
    return str(ast.literal_eval(version))


setup(
    name="lavender",
    version=get_version(),
    description="The slightly more compromising code formatter.",
    long_description=get_long_description(),
    long_description_content_type="text/markdown",
    keywords="automation formatter yapf autopep8 pyfmt gofmt rustfmt black",
    author="Michael Smith",
    author_email="michael@spinda.net",
    url="https://github.com/spinda/lavender",
    license="MIT",
    py_modules=["lavender", "lavenderd"],
    packages=["blib2to3", "blib2to3.pgen2"],
    package_data={"blib2to3": ["*.txt"]},
    python_requires=">=3.6",
    zip_safe=False,
    install_requires=[
        "appdirs >=1.4.0, <2",
        "attrs >=18.1.0, <19",
        "click >=6.5, <7",
        "pathspec >=0.6, <0.7",
        "regex >=2019.8.19",
        "toml >=0.9.4, <0.10",
        "typed-ast >=1.4.0, <2",
    ],
    extras_require={"d": ["aiohttp >= 3.3.2, <4", "aiohttp-cors >=0.7.0, <0.8"]},
    classifiers=[
        "Development Status :: 4 - Beta",
        "Environment :: Console",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3 :: Only",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Software Development :: Quality Assurance",
    ],
    entry_points={
        "console_scripts": [
            "lavender=lavender:patched_main",
            "lavenderd=lavenderd:patched_main [d]",
        ]
    },
)
